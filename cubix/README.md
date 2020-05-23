# CUBIX for multicomp6809

This originated as 3 .zip files:

* CUBIXfpga.zip  - fpga/ directory with source, including for r09sase ROM
* fpgacubix.zip  - fpga/ directory and fpgacubix.img for writing to SDcard
* GrantCubix.zip - FPGA project files. Contains 2k rom, serial port only

The stuff here includes the "r09sase ROM" source and "fpgacubix.img" which is a
set of disk images.

For multicomp6809 I created "cubix_autoboot.asm" which allows a direct boot from
multicomp6809 camelforth to CUBIX.

The original .zip files came with a "README-FPGACUBIX.TXT which is included
below.

For more, go to the WIKI: https://github.com/nealcrook/multicomp6809/wiki/CUBIX


````
This is an adaptation of the Standalone CUBIX for the N8VEM 6x0x stack.
It runs on the Grant Searle implementation of the 6809 for the Altera
Cyclone II EP2C5T144.  The board used is one of Dr Acula's (James Moxham)
boards.  It can be built with a perf board and a bunch o wires.

The quick start is to DD (yea, I am a Unix guy) the fpgacubix.img file from
the fpgacubix.zip file on to an SD card.  It is only slightly bigger than
32 MB.

The FPGA code is in GrantCubix.zip.  This will give you a 6809 with a ROM that will
be able to boot CUBIX from the SD card.

----------------EXAMPLE BOOT-----------------
AG5AT DISK 6809 ROM MONITOR READY.

>b
BOOTING FROM SD
RAM... Passed

CUBIX version 1.3  

Copyright 1983-2005 Dave Dunfield
All rights reserved

*sh dr a:
Drive: A
Address=0, Cylinders=32, Heads=1, Sectors/Track=255
*sh fr a:
Drive A has 8160 blocks, 7964 free
*dir [*]

Directory A:[HELP]

SYSTEM.HLP     

Total of 1 files.


Directory A:[SYSTEM]

ASM.EXE        ASP.EXE        BASIC.EXE      BUILD.EXE      CALC.EXE
CHGDISK.EXE    CHKDISK.EXE    CONCAT.EXE     COPY.EXE       DIR.EXE
DIRF.EXE       ED.EXE         EDIT.EXE       EDT.EXE        FLINK.EXE
FORTH.EXE      HELP.EXE       HEXED.EXE      LDIR.EXE       MAPL.EXE
MOVEAPL.EXE    PED.EXE        RAID.EXE       REDIRECT.EXE   SEARCH.EXE
SIM80.EXE      TTYPATCH.EXE   TYPE.EXE       

Total of 28 files.

Grand total of 2 directories, 29 files.
*
-----------------------------------------------------

All of the disks are configured for 4 MB.  They occupy 8 MB of space.  (It
was easier that way).  The CUBIX images is located just above the A: Disk
file space.
You can consult Grant's documentation for CPM on this system and the SD Card
layout.  I kept to that.
So you have:
A:,  B:,  C:,  D:
Each is 4 MB.  Even though Dave (the Cubix author) states that the file system
can be 32 MB, a number of utilities won't function correctly.  I chose 4 MB so
that chkdisk will work.

Building CUBIX.

Building the ROM requires the a09 assembler and the srec_cat program from the
srecord package (I used srecord-1.63 and boost_1_55_0).  This is needed to 
convert the S19 object output file to an Intel .HEX modified to relative zero.
Unless you need to modify it, the provided r09sase.hex will work fine.  

Fixes to CUBIX.

The CUBIX that I am using is from N8VEM STAND_ALONE_Cubix_N8VEM_072310.zip.
There is a fix in the LDIR command that stops repeitive running (LOOPING).
In m6809, mods for FPGA SD boot rom.
In CUBIXOS, new GRANTSD.asm, GRANTSER.asm.  Modifications to drivers.asm to
include the drivers and set up 4 4 M/B disk drives. Removal of source files
that won't be used on Grant's setup and Jim's board.
````
