import sys

from filtr import filtr_string

# --- Настройки и константы ---
file_in = "compile.f"
file_out = "output.asm"
LFA_OUT = "NFA_EXIT"

HEADER = """
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\\src\\ramdefs.inc"
.include "..\\src\\monitor.inc"

.SECTION "compiled" FREE

"""
FOOTER = "\n.ENDS\n"

# --- Вспомогательные функции ---

def is_hex(s):
    try:
        int(s, 16)
        return True
    except ValueError:
        return False

# --- Генератор токенов (Lexer) ---

class Token:
    def __init__(self, type, value):
        self.type = type
        self.value = value
    
    def __repr__(self):
        return f"Token({self.type}, {self.value})"

class Lexer:
    def __init__(self, filename):
        self.f = open(filename, 'r', encoding='utf-8')
        self.char = self.f.read(1)
        self.line_num = 1 # Для отладки
    
    def next(self):
        """Возвращает следующий токен или None в конце файла."""
        while self.char:
            # Пропуск пробелов
            if self.char.isspace():
                if self.char == '\n':
                    self.line_num += 1
                self._advance()
                continue
            
            # 1. Обработка комментариев и строк (приоритет)
            if self.char == '\\':
                self._advance()
                content = self._read_until('\n')
                return Token('\\', content)
            
            if self.char == '(':
                self._advance()
                content = self._read_until_match(')')
                return Token('(', content)
            
            if self.char == '"':
                self._advance()
                content = self._read_until('"')
                return Token('str', content)
            
            # 2. Обычные слова (разделители - пробельные символы)
            # Заметь: ".", ":", ";" и т.д. считаются частью слова, если не разделены пробелом
            # Например, ": X" -> токены ":", "X"
            # Например, " ." -> токены "."
            return self._read_word()
            
        return None

    def _advance(self):
        self.char = self.f.read(1)

    def _read_until(self, delimiter):
        """Читает до символа delimiter (не включая его)."""
        content = ""
        while self.char and self.char != delimiter:
            content += self.char
            self._advance()
        if self.char == delimiter:
            self._advance() # Пропускаем закрывающий символ
        return content

    def _read_until_match(self, delimiter):
        """Читает до символа delimiter, пропуская его."""
        content = ""
        while self.char:
            if self.char == delimiter:
                self._advance()
                return content
            content += self.char
            self._advance()
        return content

    def _read_word(self):
        """Читает слово до пробела."""
        word = ""
        while self.char and not self.char.isspace():
            word += self.char
            self._advance()
        return Token('regular', word)

    def close(self):
        self.f.close()

# --- Словарь и обработчики ---

# Глобальные переменные для состояния компиляции
output_lines = []
current_def = None 
prev_nfa = LFA_OUT

def emit(line):
    output_lines.append(line)

# Процедуры для IMMEDIATE слов

def proc_colon(lexer, token):
    """Обработка ':'"""
    global current_def
    
    # Следующий токен - имя слова
    name_token = lexer.next()
    if not name_token: return
    
    name = name_token.value
    int_name = filtr_string(name)
    nfa_label = f"NFA_{int_name}"
    
    current_def = {
        'name': name,
        'int_name': int_name,
        'nfa_label': nfa_label,
        'body_tokens': [] # Можно собирать, но мы будем генерировать на лету
    }
    
    emit(f"; : {name} ... ;") # Заголовок
    emit(f"{nfa_label}:")
    emit(f"   .byte {len(name)},\"{name}\"")
    emit(f"   .word {prev_nfa}")
    emit(f"_{int_name}:")
    emit("   call _FCALL")

def proc_semicolon(lexer, token):
    """Обработка ';'"""
    global current_def, prev_nfa
    emit("   .word _EXIT ; EXIT")
    emit("")
    prev_nfa = current_def['nfa_label']
    current_def = None

def proc_dot_quote(lexer, token):
    """Обработка '." '"""
    # Текущий токен - ." (regular)
    # Следующий токен должен быть строкой (str)
    str_token = lexer.next()
    
    if str_token and str_token.type == 'str':
        str_content = str_token.value
        int_name = filtr_string('."')
        emit(f"   .word _{int_name}   ; (\")")
        emit(f"   .byte {len(str_content)},\"{str_content}\"")
    else:
        print(f"Ошибка: после .\" ожидается строка, получено {str_token}")

def proc_comment_line(lexer, token):
    """Обработка '\\' (комментарий до конца строки)"""
    # Токен уже содержит текст комментария в value, ничего делать не нужно
    pass

def proc_comment_paren(lexer, token):
    """Обработка '(' (комментарий в скобках)"""
    # Токен уже содержит текст комментария в value, ничего делать не нужно
    pass

# Словарь
# Структура: 'ИМЯ': { 'internal': 'ИМЯ', 'immediate': bool, 'proc': function }
# internal нужно для слов, которые не immediate, но имеют спец. имена при компиляции
WORDS = {
    ':'       : {'immediate': True, 'proc': proc_colon},
    ';'       : {'immediate': True, 'proc': proc_semicolon},
    '.'       : {'immediate': True, 'proc': proc_dot_quote}, # Это слово ."
    '('       : {'immediate': True, 'proc': proc_comment_paren},
    '\\'      : {'immediate': True, 'proc': proc_comment_line},
    
    # Слова для компиляции (не immediate)
    'COUNT'   : {'internal': '_COUNT'},
    'TYPE'    : {'internal': '_TYPE'},
    'EXECUTE' : {'internal': '_EXECUTE'},
    'LIT'     : {'internal': '_LIT'},
    'EXIT'    : {'internal': '_EXIT'},
}

# --- Основная логика ---

def compile_token(token):
    """Компиляция обычного токена внутри определения."""
    val = token.value
    
    # 1. Проверка словаря (для не-immediate слов)
    if val in WORDS:
        info = WORDS[val]
        if not info.get('immediate'):
            internal = info['internal']
            emit(f"   .word {internal} ; {val}")
            return

    # 2. Проверка на HEX число
    if is_hex(val):
        emit(f"   .word _LIT ; LIT")
        v = val
        if val.upper() == "F800": v = "COLD_INIT"
        emit(f"   .word {v} ; {v}")
        return
        
    # 3. Неизвестное слово
    int_name = filtr_string(val)
    emit(f"   .word {int_name} ; {val}")

def process_file():
    lexer = Lexer(file_in)
    
    while True:
        token = lexer.next()
        if token is None:
            break
        
        # Определение ключа для поиска в словаре
        # Для типа 'regular' ключ - это значение токена
        # Для типа 'str', '(' или '\' ключ - это тип токена (так как они являются операторами)
        
        lookup_key = token.value
        if token.type in ['str']: # Строки сами по себе не слова, они данные
            lookup_key = None
        elif token.type in ['\\', '(']:
            lookup_key = token.type
            
        # Обработка слов из словаря
        if lookup_key in WORDS:
            word_info = WORDS[lookup_key]
            if word_info.get('immediate'):
                # Выполнение процедуры
                proc = word_info.get('proc')
                if proc:
                    proc(lexer, token)
                continue
            else:
                # Компиляция слова из словаря
                if current_def:
                    compile_token(token)
                continue
        
        # Обработка прочих токенов
        if token.type == 'regular':
            if current_def:
                compile_token(token)
        elif token.type == 'str':
            # Если мы здесь, значит строка не была обработана процедурой ."
            # (например, standalone строка или ошибка синтаксиса)
            pass
            
    lexer.close()

    # Запись в файл
    with open(file_out, 'w', encoding='utf-8') as f:
        f.write(HEADER)
        for line in output_lines:
            f.write(line + "\n")
        f.write(FOOTER)

if __name__ == "__main__":
    process_file()
