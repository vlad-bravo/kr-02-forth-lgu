from filtr import filtr_string
from words import find_word

file_in = "C:/dev/kr-02-forth-lgu/src-mod/compile.f"
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
            result = ';' + text
        elif type == '+':
            result = self.create_nfa(text)
        elif type == '_':
            result = self.write_word(text)
        elif type == '-':
            result = self.write_word(text) + '\n'
        elif type == '(")':
            result = self.write_str(type, text)
        elif type == 'C"':
            result = self.write_char(type, text)
        elif type == 'if':
            result = self.write_qbranch()
        elif type == 'else':
            result = self.write_branch()
        elif type == 'then':
            result = self.write_b2()
        else:
            result = type, text
        return result

    def create_nfa(self, name):
        int_name = filtr_string(name)
        new_nfa = f'NFA{int_name}'
        result = (
            f"{new_nfa}:\n"
            f"   .byte {len(name)},\"{name}\"\n"
            f"   .word {self.prev_nfa}\n"
            f"{int_name}:"
        )
        self.prev_nfa = new_nfa
        return result

    def write_word(self, name):
        int_name = filtr_string(name)
        result = f"   .word {int_name:<15}; {name}"
        return result

    def write_str(self, name, string):
        return self.write_word(name) + f"\n   .byte {len(string)},\"{string}\""
    
    def write_char(self, name, string):
        return f"   .word _LIT, 0x{ord(string):<7x}; C\" {string}"
    
    def write_qbranch(self):
        return f"   .word __3FBRANCH,@B1 ; ?BRANCH @B1"
    
    def write_branch(self):
        return f"   .word _BRANCH,@B2    ; BRANCH @B2\n@B1:"
    
    def write_b2(self):
        return f"@B2:"

def process_file():
    try:
        with open(file_in, 'r', encoding='utf-8') as f:
            lines = "f.readlines()"
            text = f.read()
    except FileNotFoundError:
        print(f"Ошибка: Файл '{file_in}' не найден.")
        return

    splitter = TextSplitter(text)
    context = Context(splitter)
    while True:
        word = splitter.следующий(' ')
        if word:
            int_word = context.interpret(word)
            out_text = context.translate(*int_word)
            print(out_text)
        else:
            break
    
    content = " ".join(lines)
    
    # Разбиваем на токены (слова разделенные пробелами/переводами строк)
    # Используем split(), который автоматически разбивает по пробельным символам
    tokens = content.split()
    
    # Список словарных статей для хранения данных перед генерацией LFA
    # Структура: {'name': 'HH', 'tokens': [...], 'nfa_label': 'NFA_HH'}
    definitions = []
    
    i = 0
    while i < len(tokens):
        token = tokens[i]
        
        if token == ':':
            # Начало определения
            if i + 1 >= len(tokens):
                break # Ошибка синтаксиса
            
            name = tokens[i+1]
            i += 2 # Пропускаем ':' и имя
            
            body_tokens = []
            # Собираем токены до ';'
            while i < len(tokens) and tokens[i] != ';':
                body_tokens.append(tokens[i])
                i += 1
            
            # Сохраняем определение
            int_name = filtr_string(name)
            definitions.append({
                'name': name,
                'int_name': int_name,
                'body': body_tokens,
                'nfa_label': f"NFA{int_name}"
            })
            
            if i < len(tokens) and tokens[i] == ';':
                i += 1 # Пропускаем ';'
        else:
            # Токены вне определений (игнорируем или обрабатываем по необходимости)
            i += 1

    # Генерация выходного файла
    with open(file_out, 'w', encoding='utf-8') as f:
        f.write(HEADER)
        
        # Переменная для хранения предыдущей метки NFA (для LFA)
        # Первой статье присваиваем значение из LFA_OUT
        prev_nfa = LFA_OUT
        
        # Обрабатываем определения в порядке следования (для правильной цепочки LFA нам нужен обратный порядок ссылок,
        # но по условию "Метка NFA первого слова должна попасть в LFA второго".
        # Это значит: Def2.LFA = Def1.NFA.
        # При записи в файл сверху-вниз: мы знаем prev_nfa (который для 1-го слова = LFA_OUT).
        # После генерации 1-го слова, его NFA становится prev_nfa для 2-го слова.
        
        for definition in definitions:
            name = definition['name']
            int_name = definition['int_name']
            body = definition['body']
            nfa_label = definition['nfa_label']
            
            # Формируем строку-комментарий с исходным кодом
            f.write(f"; : {name} {' '.join(body)} ;\n")
            f.write(f"{nfa_label}:\n")
            f.write(f"   .byte {len(name)},\"{name}\"\n")
            f.write(f"   .word {prev_nfa}\n")
            f.write(f"{int_name}:\n")
            f.write("   call _FCALL\n")
            
            # Тело определения
            j = 0
            while j < len(body):
                bt = body[j]
                
                if bt == "C\"":
                    # C" - следующий символ будет скомпилирован как литерал
                    j += 1
                    bt = body[j]
                    f.write(f"   .word _LIT, 0x{ord(bt[0]):<7x} ; C\" {bt}\n")

                elif bt == "IF":
                    bt = "?BRANCH"
                    int_bt = filtr_string(bt)
                    f.write(f"   .word {int_bt+',@B1':<15} ; {bt} @B1\n")

                elif bt == "ELSE":
                    bt = "BRANCH"
                    int_bt = filtr_string(bt)
                    f.write(f"   .word {int_bt+',@B2':<15} ; {bt} @B2\n")
                    f.write("@B1:\n")

                elif bt == "THEN":
                    f.write("@B2:\n")

                elif bt == '."':
                    # Особый случай для ." (строки)
                    # Имя для ."
                    int_bt = filtr_string("(\")")
                    f.write(f"   .word {int_bt:<15} ; (\")\n")
                    
                    # Собираем строку. В токенах строка может быть разбита или нет.
                    # По примеру входного файла: ." HELLO, HABR!" 
                    # Если токенизация разбила "HELLO, HABR!" или оно вместе, нужно обработать.
                    # Наш токенизатор split() разбивает по пробелам.
                    # Токены: .", HELLO, HABR!"
                    # Нам нужно собрать строку до закрывающей кавычки.
                    
                    j += 1
                    string_parts = []
                    while j < len(body):
                        part = body[j]
                        string_parts.append(part)
                        if part.endswith('"'):
                            break
                        j += 1
                    
                    # Склеиваем строку обратно
                    full_str = " ".join(string_parts)
                    # Убираем кавычки для подсчета длины и вывода
                    # Формат: "TEXT"
                    if full_str.startswith('"') and full_str.endswith('"'):
                        str_content = full_str[1:-1]
                    else:
                        # Если кавычки странно стоят
                        str_content = full_str.replace('"', '')
                        
                    f.write(f"   .byte {len(str_content)},\"{str_content}\"\n")

                # elif is_hex(bt):
                #     # Обработка чисел (LIT)
                #     # Если токен выглядит как шестнадцатеричное число
                #     f.write(f"   .word _LIT, 0x{bt:<7} ; {bt}\n")
                else:
                    # Обычное слово
                    int_bt = filtr_string(bt)
                    f.write(f"   .word {int_bt:<15} ; {bt}\n")
                
                j += 1
            
            # Завершение слова (EXIT)
            f.write("   .word _EXIT           ; EXIT\n")
            
            # Обновляем prev_nfa для следующего слова
            prev_nfa = nfa_label
            f.write("\n")
            
        f.write(FOOTER)

if __name__ == "__main__":
    process_file()
