import argparse

parser = argparse.ArgumentParser(description='Конвертация ASCII-карты уровня в .asm')
parser.add_argument('input', help='входной файл (ASCII)')
parser.add_argument('output', help='выходной файл (.asm)')
args = parser.parse_args()

with open(args.input, 'r') as file_in:
    with open(args.output, 'w', encoding='utf8') as file_out:
        file_out.write(f'; {args.input}\n')
        file_out.write('; Адреса в видеопамяти ячеек с живыми клетками')
        lines_in = file_in.readlines()
        addr = 0x76D0
        cntr = 0
        for line in lines_in:
            for char in line:
                # file_out.write(f'0x{addr:04X}:{char}\n')
                if char == '*':
                    if cntr % 8:
                        file_out.write(f',0x{addr:04X}')
                    else:
                        file_out.write(f'\n   .word 0x{addr:04X}')
                    cntr += 1
                if char != '\n':
                    addr += 1
