import pyperclip

from filtr import filtr_string
from words_clip import (
        process_nfa, process_nfa_by_adr, process_forth_code, LAST_NFA, LAST_NFA_ASSEMBLER
    )

# Адреса CFA-кодов словарных статей (от - до)
PTR = 0x3fee
LIM = 0x3ffc

words = {}

with open('C:\\dev\\kr-02-forth-lgu\\src\\rk86-memory-1.bin', 'br') as in_file:
    dump = in_file.read()

try:
    process_nfa(dump, LAST_NFA)
    process_nfa(dump, LAST_NFA_ASSEMBLER)
    # process_nfa_by_adr(dump)
    text = process_forth_code('', PTR, LIM)
    pyperclip.copy(text)
except pyperclip.PyperclipException:
    pass
