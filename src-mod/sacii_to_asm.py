with open('stage.ascii', 'r') as file_in:
    with open('_stage.asm', 'w') as file_out:
        lines_in = file_in.readlines()
        addr = 0x76D0
        cntr = 0
        for line in lines_in:
            for char in line:
                # file_out.write(f'0x{addr:04X}:{char}\n')
                if char == '*':
                    if cntr % 14:
                        file_out.write(f',0x{addr:04X}')
                    else:
                        file_out.write(f'\n   .word 0x{addr:04X}')
                    cntr += 1
                if char != '\n':
                    addr += 1
