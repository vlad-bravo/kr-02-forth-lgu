@echo off
del *.bin>nul
del *.o>nul
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o forth_mod.o forth_mod.asm
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -o var.o var.asm
C:\dev\wla_dx_v10.6_Win64\wlalink.exe -r link_mod.cfg forth_mod.bin
