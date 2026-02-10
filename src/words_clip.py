import pyperclip

from filtr import filtr_string

LAST_NFA = 0x458A
LAST_NFA_ASSEMBLER = 0x44C5

words = {}

def process_nfa(dump, nfa: int, recursive=True):
    global words
    if nfa:
        name_length = dump[nfa] % 32    # Clar IMMEDIATE, SMUDGE flags
        imm_flag = dump[nfa] > 32
        lfa = nfa + name_length + 1
        cfa = nfa + name_length + 3
        if name_length == 0:
            name = ''
        else:
            try:
                name = dump[nfa+1:lfa].decode('utf-8')
            except:
                name = dump[nfa+1:lfa]
        lfa_ref = int.from_bytes(dump[lfa:lfa+2], byteorder='little')
        words[f'{nfa:04X}'] = f'{name_length}', name, f'{lfa_ref:04X}', cfa, imm_flag
        if recursive:
            process_nfa(dump, lfa_ref)

def process_nfa_by_adr(dump):
    adr_list = (
        0,
    )
    for adr in adr_list:
        process_nfa(dump, adr, recursive=False)

def process_forth_code(text: str, ptr: int, lim: int) -> str:
    while ptr < lim:
        cfa = int.from_bytes(dump[ptr:ptr+2], byteorder='little')
        name = next((value[1] for _, value in words.items() if value[3] == cfa), None)
        if name:
            label = filtr_string(name)
            name_postfix = ' - ' + name
        else:
            label = f'${cfa:04X}'
            name_postfix = ''
        text += f'   .word {label:<17}; ${ptr:04x} {cfa:04X}{name_postfix}\n'
        ptr += 2
        if name == '(.")' or name == '(ABORT")':
            string_length = dump[ptr]
            string = dump[ptr+1:ptr+string_length+1]
            text += f'   .byte {string_length},"{string}"\n'
            ptr += string_length + 1
    return text

def get_cfa_body(start_cfa: int, prev_nfa: str) -> str:
    lim = int(prev_nfa, base=16)
    text = ''
    ptr = start_cfa + 3
    # CONST, CFA = @
    if dump[start_cfa:ptr] == b'\xcd\x20\x28':
        const = int.from_bytes(dump[ptr:ptr+2], byteorder='little')
        text = (
            f'\n   call __40     ; {start_cfa:04X}'
            f'\n   .word ${const:04X}   ; {start_cfa+3:04X}'
        )
    # VOCABULARY
    elif dump[start_cfa:ptr] == b'\xcd\xd1\x37':
        voc_lfa = int.from_bytes(dump[ptr+2:ptr+4], byteorder='little')
        voc_link = int.from_bytes(dump[ptr+4:ptr+6], byteorder='little')
        text = (
            f'\n   call VOCABULARY_DOES ; {start_cfa:04X}'
            f'\n   .byte 0x01    ; {start_cfa+3:04X}'
            f'\n   .byte 0x80    ; {start_cfa+4:04X} nfa (fake)'
            f'\n   .word ${voc_lfa:04X}   ; {start_cfa+5:04X} lfa'
            f'\n   .word ${voc_link:04X}   ; {start_cfa+7:04X} voc-link'
        )
    # FORTH CODE
    elif dump[start_cfa:ptr] == b'\xcd\x8f\x21':
        text = f'\n   call _FCALL            ; {start_cfa:04X}\n'
        text = process_forth_code(text, ptr, lim)
    return text

with open('C:\\dev\\kr-02-forth-lgu\\src\\rk86-memory-1.bin', 'br') as in_file:
    dump = in_file.read()

try:
    nfa = pyperclip.paste().upper()
    process_nfa(dump, LAST_NFA)
    process_nfa(dump, LAST_NFA_ASSEMBLER)
    # process_nfa_by_adr(dump)
    word = words.get(nfa)
    if not word:
        try:
            process_nfa(dump, int(nfa, base=16), recursive=False)
            word = words.get(nfa)
        except:
            pass
    if word:
        name_length, name, lfa, cfa, imm_flag = word
        if imm_flag:
            name_length = '0x8' + name_length # IMMEDIATE
            imm_label = ' ; IMMEDIATE'
        else:
            imm_label = ''
        label = filtr_string(name)
        label_length = len(label)
        next_word = words.get(lfa)
        if next_word:
            next_name_length, next_name, _, _, _ = next_word
            lfa = 'NFA' + filtr_string(next_name) + ' ' * (12 - int(next_name_length)) + ' ; ' + lfa
        else:
            lfa = '$' + lfa
        prev_nfa = next((key for key, value in words.items() if value[2] == nfa), None)
        if prev_nfa:
            cfa_body = get_cfa_body(cfa, prev_nfa)
        else:
            cfa_body = ''
        text = (f'\nNFA{label}:{" "*(13-int(label_length))}; {nfa}\n'
                f'   .byte {name_length},"{name}"{imm_label}\n'
                f'   .word {lfa}\n'
                f'{label}:{" "*(16-int(label_length))}; {cfa:04X} - {prev_nfa}{cfa_body}')
        pyperclip.copy(text)
except pyperclip.PyperclipException:
    pass
