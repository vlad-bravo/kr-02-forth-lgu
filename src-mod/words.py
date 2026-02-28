from actions import (
    action_backslash,
    action_colon,
    action_semicolon,
    action_dotquot,
    action_cquot,
    action_if,
    action_else,
    action_then,
    action_bracket,
    action_do,
    action_loop,
    action_begin,
    action_again,
)

class Word:
    def __init__(self, name, action=None):
        self.name = name
        self.immediate = not action == None
        self.action = action

WORDS = (
    Word('\\', action_backslash),
    Word('(', action_bracket),
    Word(':', action_colon),
    Word(';', action_semicolon),
    Word('."', action_dotquot),
    Word('C"', action_cquot),
    Word('IF', action_if),
    Word('ELSE', action_else),
    Word('THEN', action_then),
    Word('DO', action_do),
    Word('LOOP', action_loop),
    Word('BEGIN', action_begin),
    Word('AGAIN', action_again),
    Word('0'),
    Word('1'),
    Word('2'),
    Word('DEAD'),
    Word(''),
)

def find_word(word):
    for forth_word in WORDS:
        if forth_word.name == word:
            return forth_word
        
    return None
