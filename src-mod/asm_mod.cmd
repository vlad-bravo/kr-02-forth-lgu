@echo off
del forth_mod.bin>nul
del forth_mod.o>nul
C:\dev\wla_dx_v10.6_Win64\wla-8080.exe -i -v2 -o forth_mod.o forth_mod.asm
C:\dev\wla_dx_v10.6_Win64\wlalink.exe -r -v link_mod.cfg forth_mod.bin
