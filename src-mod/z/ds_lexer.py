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
        self.position = next_pos  # Останавливаемся на пробельном символе (не пропускаем его)
        
        return result if result else None


# Демонстрация работы с примером из описания
if __name__ == "__main__":
    # Исходный текст: ' "  123 "'
    # Обратите внимание: в Python строковые литералы могут быть в разных кавычках
    text = ' "  123 "'
    print(f"Исходный текст: {text}")
    print(f"Длина текста: {len(text)} символов")
    print(f"Символы по индексам:")
    for i, ch in enumerate(text):
        print(f"  [{i}] = '{ch}' (код: {ord(ch)})")
    
    print("\n--- Начинаем разбор ---")
    splitter = TextSplitter(text)
    
    # Первый поиск с разделителем " "
    result1 = splitter.следующий(" ")
    print(f"\n1. следующий(\" \"):")
    print(f"   Результат: '{result1}'")
    print(f"   Позиция после вызова: {splitter.position}")
    print(f"   Оставшийся текст: '{text[splitter.position:]}'")
    
    # Второй поиск с разделителем '"'
    result2 = splitter.следующий('"')
    print(f"\n2. следующий('\"'):")
    print(f"   Результат: '{result2}'")
    print(f"   Позиция после вызова: {splitter.position}")
    print(f"   Оставшийся текст: '{text[splitter.position:]}'")
    
    # Третий поиск (должен вернуть None)
    result3 = splitter.следующий(" ")
    print(f"\n3. следующий(\" \"):")
    print(f"   Результат: {result3}")
    
    print("\n" + "="*50)
    print("Дополнительные тесты:")
    print("="*50)
    
    # Тест с несколькими пробельными разделителями подряд
    print("\n--- Тест: несколько пробелов между словами ---")
    text2 = "  hello   world  !  "
    print(f"Текст: '{text2}'")
    splitter2 = TextSplitter(text2)
    
    i = 1
    while True:
        result = splitter2.следующий(" ")
        if result is None:
            print(f"{i}. None (конец)")
            break
        print(f"{i}. '{result}' (позиция: {splitter2.position})")
        i += 1
    
    # Тест с разными типами разделителей
    print("\n--- Тест: смешанные разделители ---")
    text3 = '  key1  =  "value1"  key2  =  "value2"  '
    print(f"Текст: '{text3}'")
    splitter3 = TextSplitter(text3)
    
    # Парсинг простого формата key = "value"
    while True:
        # Пропускаем пробелы и получаем ключ
        key = splitter3.следующий(" ")
        if key is None:
            break
        print(f"Ключ: '{key}'")
        
        # Пропускаем пробелы до "="
        eq = splitter3.следующий(" ")
        print(f"  Разделитель: '{eq}' (должен быть '=')")
        
        # Пропускаем пробелы до значения в кавычках
        value = splitter3.следующий('"')
        print(f"  Значение: '{value}'")
