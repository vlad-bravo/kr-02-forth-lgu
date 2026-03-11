@echo off

del *.bin 2>nul
del *.o 2>nul

python compiler.py forth --prefix f
python compiler.py life
python compiler.py interpret --prefix i
python compiler.py math --prefix m
python compiler.py tests --prefix t
python compiler.py utils --prefix u

C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o forth.o forth.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o forth_f.o forth_f.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o life_f.o life_f.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o interpret_f.o interpret_f.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o interpret.o interpret.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o life_manual.o life_manual.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o math_f.o math_f.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o math.o math.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o tests_f.o tests_f.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o utils.o utils.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o utils_f.o utils_f.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o var.o var.asm

C:\dev\wla_dx_v10.6_Win64\wlalink.exe -r link_mod.cfg forth_mod.bin

del *.o 2>nul
