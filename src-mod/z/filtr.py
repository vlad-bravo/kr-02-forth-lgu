def filtr_char(char: str) -> str:
    """
    Python equivalent of the Forth word (FILTR).
    Transforms a single character according to the specified rules.
    
    - A-Z and 0-9 are kept.
    - '_' is doubled.
    - All other characters are replaced by '_' and their 2-digit hex code.
    """
    c_val = ord(char)
    # Check for uppercase letters (A-Z) or digits (0-9)
    if (0x41 <= c_val <= 0x5A) or (0x30 <= c_val <= 0x39):
        return char
    # Check for underscore
    elif char == '_':
        return '__'
    # All other characters
    else:
        # Use an f-string to format the character's value as a 2-digit uppercase hex number
        return f'_{c_val:02X}'

def filtr_string(input_str: str) -> str:
    """
    Python equivalent of the Forth word FILTR.
    Transforms an entire string.
    """
    output_parts = ['_']
    
    for char in input_str:
        output_parts.append(filtr_char(char))
    
    return "".join(output_parts)

def test():
    """
    Python equivalent of the Forth word TEST.
    Demonstrates the filtration process.
    """
    # The original Forth string literal " 1+!C"
    input_str = "1+!C"
    
    print(f"Original string: '{input_str}'")
    
    # The Forth word FILTR is called here
    result_str = filtr_string(input_str)
    
    # " _1_2B_21C"
    print(f"Result string:   '{result_str}'")

if __name__ == "__main__":
    test()
