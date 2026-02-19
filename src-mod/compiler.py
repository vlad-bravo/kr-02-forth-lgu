from filtr import filtr_string

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
    """Проверяет, является ли строка шестнадцатеричным числом."""
    try:
        int(s, 16)
        return True
    except ValueError:
        return False

def clean_lines(lines):
    # Удаляем комментарии, начинающиеся с '\'
    clean_lines = []
    for line in lines:
        # Ищем символ обратного слэша, который не экранирован (простой случай)
        # В Forth комментарий начинается с \ и идет до конца строки.
        comment_start = line.find('\\')
        if comment_start != -1:
            line = line[:comment_start]
        clean_lines.append(line)
    return clean_lines

def process_file():
    try:
        with open(file_in, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"Ошибка: Файл '{file_in}' не найден.")
        return

    content = " ".join(clean_lines(lines))
    
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

                elif is_hex(bt):
                    # Обработка чисел (LIT)
                    # Если токен выглядит как шестнадцатеричное число
                    f.write(f"   .word _LIT, 0x{bt:<7} ; {bt}\n")
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
