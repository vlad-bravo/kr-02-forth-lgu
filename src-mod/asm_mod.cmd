@echo off
del *.bin 2>nul
del *.o 2>nul
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o forth_mod.o forth_mod.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o asm.o asm.asm
python compiler.py
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o compiled.o compiled.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o interpret.o interpret.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o math.o math.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o utils.o utils.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o var.o var.asm
C:\dev\wla_dx_v10.6_Win64\wlalink.exe -r link_mod.cfg forth_mod.bin
del *.o 2>nul
