REM set PATH_TO_ORICUTRON=C:\Users\Public\Orix
set PATH_TO_ORICUTRON=C:\Users\tbpk7658\Applis\Orix
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
REM ca65 -t%PLATFORM% glOric.asm -g -l glOric.lst -o glOric.o  --include-dir .
REM ca65 -t%PLATFORM% raster\line.asm -g -l line.lst -o line.o  --include-dir .
REM ca65 -t%PLATFORM% raster\fill8.asm -g -l fill8.lst -o fill8.o  --include-dir .
REM ar65 r glOric.lib line.o glOric.o
REM cc65 bresfill.c -D TARGET_ORIX -g -o bresfill.asm
REM ca65 -t%PLATFORM% bresfill.asm -g -l bresfill.lst -o bresfill.o --include-dir .
REM cc65 lrsDemo.c -D TARGET_ORIX -g -o lrsDemo.asm
REM ca65 -t%PLATFORM% lrsDemo.asm -g -l lrsDemo.lst -o lrsDemo.o --include-dir .
REM cc65 logic.c -D TARGET_ORIX -g -o logic.asm
REM ca65 -t%PLATFORM% logic.asm -g -l logic.lst -o logic.o --include-dir .
REM cc65 zbuffer.c -D TARGET_ORIX -g -o zbuffer.asm
REM ca65 -t%PLATFORM% zbuffer.asm -g -l zbuffer.lst -o zbuffer.o --include-dir .
REM cc65 lrsDrawing.c -D TARGET_ORIX -g -o lrsDrawing.asm
REM ca65 -t%PLATFORM% lrsDrawing.asm -g -l lrsDrawing.lst -o lrsDrawing.o --include-dir .
REM cc65 demo.c -D TARGET_ORIX -g -o demo.asm
REM ca65 -t%PLATFORM% demo.asm -g -l demo.lst -o demo.o --include-dir .
REM cl65 -v -vm -m demo.map -Ln demo.vice -g -t%PLATFORM% demo.o logic.o zbuffer.o lrsDemo.o lrsDrawing.o fill8.o bresfill.o glOric.lib  -o demoGlOric.tap

cl65 -v -vm -m demo.map -Ln demo.vice -g -t%PLATFORM% start.o glOric.lib -o demoGlOric.tap

IF EXIST demoGlOric.tap GOTO OkFile
GOTO ErBld

:OkFile
copy demoGlOric.tap %PATH_TO_ORICUTRON%\usbdrive\bin\d

PUSHD %PATH_TO_ORICUTRON%
START .\%ORICUTRON%
POPD

:ErBld


