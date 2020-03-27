set PATH_TO_ORICUTRON=C:\Users\Public\Orix
REM set PATH_TO_ORICUTRON=C:\Users\tbpk7658\Applis\Orix
REM C:\Users\Public\Oricutron
set ORICUTRON=oricutron-sdl2.exe
set PLATFORM=telestrat

DEL glOric_c.asm start.asm *.o *.lst demoGlOric.tap %PATH_TO_ORICUTRON%\usbdrive\bin\d
DEL glOric.lib

ca65 -t%PLATFORM% camera.asm -g -l camera.lst -o camera.o  --include-dir .
ca65 -t%PLATFORM% temp.asm -g -l temp.lst -o temp.o  --include-dir .
ca65 -t%PLATFORM% fill8.asm -g -l fill8.lst -o fill8.o  --include-dir .
ca65 -t%PLATFORM% zbuff.asm -g -l zbuff.lst -o zbuff.o  --include-dir .
ca65 -t%PLATFORM% hzfill.asm -g -l hzfill.lst -o hzfill.o  --include-dir .
ca65 -t%PLATFORM% projection.asm -g -l projection.lst -o projection.o  --include-dir .
ca65 -t%PLATFORM% projectPoint.asm -g -l projectPoint.lst -o projectPoint.o  --include-dir .
ca65 -t%PLATFORM% scene.asm -g -l scene.lst -o scene.o  --include-dir .

cc65 glOric_c.c -D TARGET_ORIX -g -o glOric_c.asm
ca65 -t%PLATFORM% glOric_c.asm -g -l glOric_c.lst -o glOric_c.o --include-dir .

ar65 r glOric.lib camera.o temp.o fill8.o zbuff.o hzfill.o projection.o  projectPoint.o scene.o glOric_c.o

cc65 start.c -D TARGET_ORIX -g -o start.asm
ca65 -t%PLATFORM% start.asm -g -l start.lst -o start.o --include-dir .

cl65 -v -vm -m demo.map -Ln demo.vice -g -t%PLATFORM% start.o glOric.lib -o demoGlOric.tap

IF EXIST demoGlOric.tap GOTO OkFile
GOTO ErBld

:OkFile
copy demoGlOric.tap %PATH_TO_ORICUTRON%\usbdrive\bin\d

PUSHD %PATH_TO_ORICUTRON%
START .\%ORICUTRON%
POPD

:ErBld


