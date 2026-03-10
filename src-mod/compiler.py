import argparse

from filtr import filtr_string
from words import find_word

def is_hex(s):
    try:
        int(s, 16)
        return True
    except ValueError:
        return False

class TextSplitter:
    def __init__(self, text):
        """
        Инициализация класса с текстом
        
        Args:
            text (str): Исходный текст для обработки
        """
        self.text = text
        self.position = 0  # Текущая позиция для поиска следующего разделителя
        
    def следующий(self, разделитель):
        """
        Возвращает часть текста до следующего разделителя
        
        Args:
            разделитель (str): Символ или строка-разделитель
            
        Returns:
            str или None: Часть текста до разделителя или None, если достигнут конец текста
        """
        # Проверяем, не достигли ли мы конца текста
        if self.position >= len(self.text):
            return None
        
        current_pos = self.position
        
        # Особый случай: разделитель - пробел
        if разделитель == " ":
            # Пропускаем все пробельные символы в начале
            while current_pos < len(self.text) and self.text[current_pos].isspace():
                current_pos += 1
            
            # Если после пропуска пробелов достигли конца текста
            if current_pos >= len(self.text):
                self.position = current_pos
                return None
            
            # Ищем следующий пробельный символ (любой)
            next_pos = current_pos
            while next_pos < len(self.text) and not self.text[next_pos].isspace():
                next_pos += 1
        else:
            # Обычный случай: ищем указанный разделитель
            next_delimiter_pos = self.text.find(разделитель, current_pos)
            
            if next_delimiter_pos == -1:
                # Разделитель не найден - возвращаем остаток текста
                result = self.text[current_pos:]
                self.position = len(self.text)
                return result if result else None
            else:
                # Разделитель найден - возвращаем текст до него
                result = self.text[current_pos:next_delimiter_pos]
                self.position = next_delimiter_pos + len(разделитель)
                return result if result else None
        
        # Для случая с пробельным разделителем
        result = self.text[current_pos:next_pos]
        self.position = next_pos + 1
        
        return result if result else None

class Context:
    def __init__(self, splitter, prefix):
        self.splitter = splitter
        self.prefix = prefix
        self.is_prefix = len(prefix) > 0
        self.prefix_defs = []
        self.state = 'interpret'
        self.label_count = 0
        self.label_stack = []
        self.last_name = ''
        self.new_immediate_names = False
        self.new_immediate_list = []
        self.immediate_names = [
            'LITERAL', 'DLITERAL', 'DOES>', ';', ':', '[', 'NEW', 'JOIN', '(', 'SCRATCH',
            '[COMPILE]', '[\']', 'ABORT"', 'C"', '."', '"', '.(', 'IF', 'IFNOT',
            'ELSE', 'THEN', 'BEGIN', 'AGAIN', 'DO', '?DO', 'LOOP', '+LOOP',
            'UNTIL', '--',
        ]

    def interpret(self, word):
        forth_word = find_word(word)
        if forth_word:
            if forth_word.immediate:
                result = forth_word.action(self, forth_word)
            else:
                result = '_', forth_word.name
        else:
            result = '?', word
        return result

    def translate (self, type, text):
        if type == '\\':
            result = ';\ ' + text
        elif type == '(':
            result = f"; ( {text})"
        elif type == '+':
            result = self.create_nfa(text)
        elif type == '_':
            result = self.write_word(text)
        elif type == '-':
            result = self.write_word(text) + '\n'
        elif type == '(")':
            result = (
                f"{self.write_word(type)}\n"
                f"   .byte {len(text)}\n"
                f"   .stringmap russian,\"{text}\""
            )
        elif type == '(.")':
            result = (
                f"{self.write_word(type)}\n"
                f"   .byte {len(text)}\n"
                f"   .stringmap russian,\"{text}\""
            )
        elif type == '(ABORT")':
            result = (
                f"{self.write_word(type)}\n"
                f"   .byte {len(text)}\n"
                f"   .stringmap russian,\"{text}\""
            )
        elif type == 'C"':
            result = f"   .word _LIT, 0x{ord(text):<7x}; C\" {text}"
        elif type == '[comp]':
            int_name = filtr_string(text)
            result = f"   .word _LIT,{int_name:<10}; [COMPILE] {text}"
        elif type == 'comp':
            int_name = filtr_string(text)
            result = f"   .word {int_name:<15}; COMPILE {text}"
        elif type == 'if':
            self.label_count += 1
            self.label_stack.append(self.label_count)
            result = f"   .word __3FBRANCH,@B{self.label_count} ; ?BRANCH @B{self.label_count}"
        elif type == 'ifnot':
            self.label_count += 1
            self.label_stack.append(self.label_count)
            result = f"   .word _N_3FBRANCH,@B{self.label_count} ; N?BRANCH @B{self.label_count}"
        elif type == 'else':
            label = self.label_stack.pop()
            self.label_count += 1
            self.label_stack.append(self.label_count)
            result = f"   .word _BRANCH,@B{self.label_count}    ; BRANCH @B{self.label_count}\n@B{label}:"
        elif type == 'then':
            label = self.label_stack.pop()
            result = f"@B{label}:"
        elif type == 'do':
            self.label_count += 1
            label = self.label_count
            self.label_stack.append(self.label_count)
            self.label_count += 1
            self.label_stack.append(self.label_count)
            result = (
                f"   .word __28_3FDO_29,@B{self.label_count} ; (?DO) @B{self.label_count}\n"
                f"@B{label}:"
            )
        elif type == 'loop':
            label2 = self.label_stack.pop()
            label1 = self.label_stack.pop()
            result = (
                f"   .word __28LOOP_29,@B{label1} ; (LOOP) @B{label1}\n"
                f"@B{label2}:"
            )
        elif type == '+loop':
            label2 = self.label_stack.pop()
            label1 = self.label_stack.pop()
            result = (
                f"   .word __28_2BLOOP_29,@B{label1} ; (+LOOP) @B{label1}\n"
                f"@B{label2}:"
            )
        elif type == 'begin':
            self.label_count += 1
            self.label_stack.append(self.label_count)
            result = f"@B{self.label_count}:"
        elif type == 'again':
            label = self.label_stack.pop()
            result = f"   .word _BRANCH,@B{label}    ; BRANCH @B{label}"
        elif type == 'repeat':
            self.label_count += 1
            self.label_stack.append(self.label_count)
            result = f"@B{self.label_count}:"
        elif type == 'until':
            label = self.label_stack.pop()
            result = f"   .word __3FBRANCH,@B{label} ; ?BRANCH @B{label}"
        elif type == 'lit_const':
            result = f"   .word _LIT,{text:<10}; {text}"
        elif type == 'immediate':
            if self.last_name not in self.immediate_names:
                self.new_immediate_names = True
                self.immediate_names.append(self.last_name)
                self.new_immediate_list.append(self.last_name)
            result = None
        else:
            result = self.write_default(text)
        return result

    def create_nfa(self, name):
        is_immediate = name in self.immediate_names
        int_name = filtr_string(name)[1:]
        if int_name == name and not is_immediate:
            result = f"NFA \"{name}\"\n   call _FCALL"
        else:
            mask_name = ''
            for char in name:
                if char == '"':
                    mask_name += '\\"'
                else:
                    mask_name += char
            imm_suffix = ', IMMEDIATE' if is_immediate else ''
            result = f"NFA2 \"{mask_name}\", \"{int_name}\"{imm_suffix}\n   call _FCALL"
        self.label_count = 0
        if self.is_prefix:
            self.prefix_defs.append(f".def _{int_name} {self.prefix}_{int_name}\n")
        self.last_name = name
        return result

    def write_word(self, name):
        int_name = filtr_string(name)
        result = f"   .word {int_name:<15}; {name}"
        return result

    def write_default(self, text):
        if is_hex(text):
            return f'   .word _LIT,0x{text:<8}; {text}'
        else:
            return self.write_word(text)

def process_file(filename: str, prefix: str):
    file_in = f"{filename}.f"
    file_out = f"{filename}_f.asm"
    try:
        with open(file_in, 'r', encoding='utf-8') as f:
            text = f.read()
    except FileNotFoundError:
        print(f"Ошибка: Файл '{file_in}' не найден.")
        return

    splitter = TextSplitter(text)
    context = Context(splitter, prefix)

    with open(file_out, 'w', encoding='utf-8') as f:
        f.write(
            '.include "memorymap.inc"\n'
            '.include "ext_names.inc"\n'
            '.include "nfa.inc"\n'
            '.include "..\\src\\ramdefs.inc"\n'
            '.include "..\\src\\monitor.inc"\n'
            '\n'
            '.stringmaptable russian "russian.tbl"\n'
            '\n'
            f'.SECTION "{filename.upper()}_F" FREE\n'
            '\n'
            f'.DEF PREV_NFA PREV_NFA_{filename.upper()}_F\n'
            f'.DEF PREFIX PREFIX_{filename.upper()}_F\n'
            '\n'
        )

        while True:
            word = splitter.следующий(' ')
            if word:
                int_word = context.interpret(word)
                out_text = context.translate(*int_word)
                if out_text:
                    f.write(out_text + '\n')
            else:
                break

        f.write(".ENDS\n")

    if context.is_prefix:
        with open(f"{filename}_defs.inc", 'w', encoding='utf-8') as f:
            for line in context.prefix_defs:
                f.write(line)

    if context.new_immediate_names:
        print(filename, context.new_immediate_list)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Транслятор FORTH')
    parser.add_argument('filename', type=str,
                        help='имя файла без расширения')
    parser.add_argument('--prefix', type=str, required=False, default='')
    args = parser.parse_args()
    process_file(args.filename, args.prefix)
