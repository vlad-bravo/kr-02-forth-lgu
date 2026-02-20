from actions import (
    action_backslash,
    action_colon,
    action_semicolon,
    action_dotquot,
    action_cquot,
    action_if,
    action_else,
    action_then,
)

class Word:
    def __init__(self, name, action=None):
        self.name = name
        self.immediate = not action == None
        self.action = action

WORDS = (
    Word('COUNT'),
    Word('TYPE'),
    Word('EXIT'),
    Word('BYE'),
    Word('\\', action_backslash),
    Word(':', action_colon),
    Word(';', action_semicolon),
    Word('('),
    Word('."', action_dotquot),
    Word('C"', action_cquot),
    Word('EMIT'),
    Word('IF', action_if),
    Word('ELSE', action_else),
    Word('THEN', action_then),
    Word('EXECUTE'),
    Word('SPACE'),
    Word('BASE'),
    Word('@'),
    Word('DUP'),
    Word('DECIMAL'),
    Word('2'),
    Word('.R'),
    Word('!'),
    Word('STATE'),
    Word(''),
    Word(''),
    Word(''),
)

def find_word(word):
    for forth_word in WORDS:
        if forth_word.name == word:
            return forth_word
        
    return None
