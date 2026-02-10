# выборка слов из образа forth

LAST_NFA = 0x458A

def process_nfa(dump, nfa: int):
    if nfa:
        name_length = dump[nfa] % 32    # Clar IMMEDIATE, SMUDGE flags
        lfa = nfa + name_length + 1
        cfa = nfa + name_length + 3
        name = dump[nfa+1:lfa].decode('utf-8')
        lfa_ref = int.from_bytes(dump[lfa:lfa+2], byteorder='little')
        print(f'{nfa:04X}', f'{name_length:02X}', name, f'{lfa_ref:04X}', f'{cfa:04X}')
        process_nfa(dump, lfa_ref)

with open('rk86-memory-1.bin', 'br') as in_file:
    dump = in_file.read()

process_nfa(dump, LAST_NFA)
