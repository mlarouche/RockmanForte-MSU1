Rockman & Forte MSU-1
Version 1.0
by DarkShock

This hack adds CD quality audio to Rockman & Forte using the MSU-1 chip invented by byuu. It also works with the English translation by AGTP
The hack has been tested on SD2SNES, bsnes-plus 073.1b and higan 094.
The patched ROM needs to be named rockmanforte_msu1.sfc.

Note that there's 2 patches:
* rockmanforte_msu1.ips for the original Japanese release
* rockmanforte_msu1_english.ips that apply to AGTP's translation with Rockman & Forte logo

The music pack can be found here: http://www.mediafire.com/file/cxd2oecl5ba4737/RockmanForte_MSU1_Music.7z

Original ROM specs:
ROCKMAN&FORTE
4194304 Bytes (32.0000 Mb)
Padded: Maybe, 132628 Bytes (1.0119 Mb)
Interleaved/Swapped: No
Backup unit/emulator header: No
Version: 1.0
Checksum: Ok, 0xfe92 (calculated) == 0xfe92 (internal)
Inverse checksum: Ok, 0x016d (calculated) == 0x016d (internal)
Checksum (CRC32): 0x5047e0d4

Rockman & Forte (English)
4194304 Bytes (32.0000 Mb)
Padded: Maybe, 29006 Bytes (0.2213 Mb)
Interleaved/Swapped: No
Backup unit/emulator header: No
Version: 1.0
Checksum: Bad, 0x9437 (calculated) != 0xfe92 (internal)
Inverse checksum: Bad, 0x6bc8 (calculated) != 0x016d (internal)
Checksum (CRC32): 0xbc12734c

===============
= Using BSNES =
===============
1. Patch the ROM
2. Unzip the .pcm
3. Launch the game

===============
= Using higan =
===============
1. Patch the ROM
2. Launch it using higan
3. Go to %USERPROFILE%\Emulation\Super Famicom\rockmanforte_msu1.sfc in Windows Explorer.
4. Copy manifest.bml and the .pcm file there
5. Run the game

====================
= Using on SD2SNES =
====================
Drop the ROM file, tmnt4_msu1.msu and the .pcm files in any folder. (I really suggest creating a folder)
Launch the game and voilà, enjoy !

===========
= Credits =
===========
* DarkShock - ASM hacking & coding, Music editing
* Krzysztof Slowikowski - Music reorchestration

=========
= Music =
=========
01 = Title Screen
02 = File Select
04 = Player Select
05 = Stage Select
06 = Stage Selected
07 = Museum
08 = Dynamo Man
09 = Cold Man
10 = Ground Man
11 = Tengu Man
12 = Astro Man
13 = Pirate Man
14 = Burner Man
15 = Magic Man
16 = King Castle
17 = Wily Castle
18 = Seals
19 = King Castle Intro (No Loop)
20 = New Weapon Presentation
21 = Victory (No Loop)
22 = Rightot's Shop
23 = Data Base
24 = Game Over
25 = Credits
27 = Boss
28 = Last Boss

=============
= Compiling =
=============
Source is availabe on GitHub: https://github.com/mlarouche/RockmanForte-MSU1

To compile the hack you need

* bass v14 (http://files.byuu.org/download/bass_v14.tar.xz)
* msupcm (https://github.com/qwertymodo/msupcmplusplus)

To distribute the hack you need

* uCON64 (http://ucon64.sourceforge.net/)
* 7-Zip (http://www.7-zip.org/)

make.bat assemble the patch
create_pcm.bat create the .pcm from the WAV files
distribute.bat distribute the patch
make_all.bat does everything
