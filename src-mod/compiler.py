from filtr import filtr_string
from words import find_word

file_in = "compile.f"
file_out = "compiled.asm"

LFA_OUT = "NFA_EXIT"

HEADER = """
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\\src\\ramdefs.inc"
.include "..\\src\\monitor.inc"

.SECTION "compiled" FREE

"""

FOOTER = ".ENDS\n"

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
    def __init__(self, splitter):
        self.splitter = splitter
        self.state = 'interpret'
        self.prev_nfa = LFA_OUT

    def interpret(self, word):
        forth_word = find_word(word)
        if forth_word:
            if forth_word.immediate:
                result = forth_word.action(self)
            else:
                result = '_', forth_word.name
        else:
            result = '?', word
        return result

    def translate (self, type, text):
        if type == '\\':
            result = '; ' + text
        elif type == '(':
            result = f"; ( {text})"
        elif type == '+':
            result = self.create_nfa(text)
        elif type == '_':
            result = self.write_word(text)
        elif type == '-':
            result = self.write_word(text) + '\n'
        elif type == '(")':
            result = self.write_word(type) + f"\n   .byte {len(text)},\"{text}\""
        elif type == 'C"':
            result = f"   .word _LIT, 0x{ord(text):<7x}; C\" {text}"
        elif type == 'if':
            result = f"   .word __3FBRANCH,@B1 ; ?BRANCH @B1"
        elif type == 'else':
            result = f"   .word _BRANCH,@B2    ; BRANCH @B2\n@B1:"
        elif type == 'then':
            result = f"@B2:"
        else:
            result = self.write_default(text)
        return result

    def create_nfa(self, name):
        int_name = filtr_string(name)
        new_nfa = f'NFA{int_name}'
        result = (
            f"{new_nfa}:\n"
            f"   .byte {len(name)},\"{name}\"\n"
            f"   .word {self.prev_nfa}\n"
            f"{int_name}:\n"
            f"   call _FCALL"
        )
        self.prev_nfa = new_nfa
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

def process_file():
    try:
        with open(file_in, 'r', encoding='utf-8') as f:
            text = f.read()
    except FileNotFoundError:
        print(f"Ошибка: Файл '{file_in}' не найден.")
        return

    with open(file_out, 'w', encoding='utf-8') as f:
        f.write(HEADER)

        splitter = TextSplitter(text)
        context = Context(splitter)
        while True:
            word = splitter.следующий(' ')
            if word:
                int_word = context.interpret(word)
                out_text = context.translate(*int_word)
                f.write(out_text + '\n')
            else:
                break
        f.write(FOOTER)

if __name__ == "__main__":
    process_file()
