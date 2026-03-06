from actions import (
    action_backslash,
    action_colon,
    action_semicolon,
    action_quot,
    action_dotquot,
    action_abortquot,
    action_cquot,
    action_b_comp,
    action_if,
    action_ifnot,
    action_else,
    action_then,
    action_bracket,
    action_do,
    action_loop,
    action_ploop,
    action_begin,
    action_again,
    action_repeat,
    action_until,
    action_lit_const,
    action_immdiate,
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
    Word('"', action_quot),
    Word('."', action_dotquot),
    Word('ABORT"', action_abortquot),
    Word('C"', action_cquot),
    Word('[COMPILE]', action_b_comp),
    Word('IF', action_if),
    Word('IFNOT', action_ifnot),
    Word('ELSE', action_else),
    Word('THEN', action_then),
    Word('DO', action_do),
    Word('LOOP', action_loop),
    Word('+LOOP', action_ploop),
    Word('BEGIN', action_begin),
    Word('AGAIN', action_again),
    Word('REPEAT', action_repeat),
    Word('UNTIL', action_until),
    Word('IMMEDIATE', action_immdiate),
    Word('-1'),
    Word('0'),
    Word('1'),
    Word('2'),
    Word('DEAD'),
    Word('l6014', action_lit_const),
    Word('l600c', action_lit_const),
    Word('l600e', action_lit_const),
    Word('l6002', action_lit_const),
    Word('l6000', action_lit_const),
    Word('l6004', action_lit_const),
    Word('l6006', action_lit_const),
    Word('l600a', action_lit_const),
    Word('l6012', action_lit_const),
    Word(''),
    Word(''),
    Word(''),
    Word(''),
    Word(''),
)

def find_word(word):
    for forth_word in WORDS:
        if forth_word.name == word:
            return forth_word
        
    return None
