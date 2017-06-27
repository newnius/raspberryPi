CC = iccavr
LIB = ilibw
CFLAGS =  -e -D__ICC_VERSION=722 -DATMega128  -l -g -MLongJump -MHasMul -MEnhanced -Wf-use_elpm 
ASFLAGS = $(CFLAGS) 
LFLAGS =  -g -e:0x20000 -ucrtatmega.o -bfunc_lit:0x8c.0x20000 -dram_end:0x10ff -bdata:0x100.0x10ff -dhwstk_size:30 -beeprom:0.4096 -fihx_coff -S2
FILES = DS1302.o 

DS1302:	$(FILES)
	$(CC) -o DS1302 $(LFLAGS) @DS1302.lk   -lcatm128
DS1302.o: C:\iccv7avr\include\iom128v.h C:\iccv7avr\include\macros.h C:\iccv7avr\include\AVRdef.h
DS1302.o:	..\..\..\BK-AVR~1\BK-AVR128配套实验程序\实1C23~1\DS1302.C
	$(CC) -c $(CFLAGS) ..\..\..\BK-AVR~1\BK-AVR128配套实验程序\实1C23~1\DS1302.C
