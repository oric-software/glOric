set PATH_TO_ORICUTRON=C:\Users\tbpk7658\Applis\Orix
REM C:\Users\Public\Oricutron
set ORICUTRON=oricutron-sdl2.exe
set PLATFORM=telestrat

ca65 -t%PLATFORM% glOric.asm -g -l glOric.lst -o glOric.o  --include-dir .
ca65 -t%PLATFORM% raster\line.asm -g -l line.lst -o line.o  --include-dir .
ca65 -t%PLATFORM% raster\fill8.asm -g -l fill8.lst -o fill8.o  --include-dir .
ar65 r glOric.lib line.o glOric.o
cc65 bresfill.c -D TARGET_ORIX -g -o bresfill.asm
ca65 -t%PLATFORM% bresfill.asm -g -l bresfill.lst -o bresfill.o --include-dir .
cc65 lrsDemo.c -D TARGET_ORIX -g -o lrsDemo.asm
ca65 -t%PLATFORM% lrsDemo.asm -g -l lrsDemo.lst -o lrsDemo.o --include-dir .
cc65 lrsDrawing.c -D TARGET_ORIX -g -o lrsDrawing.asm
ca65 -t%PLATFORM% lrsDrawing.asm -g -l lrsDrawing.lst -o lrsDrawing.o --include-dir .
cc65 demo.c -D TARGET_ORIX -g -o demo.asm
ca65 -t%PLATFORM% demo.asm -g -l demo.lst -o demo.o --include-dir .
cl65 -v -vm -m demo.map -Ln demo.vice -g -t%PLATFORM% demo.o lrsDemo.o lrsDrawing.o fill8.o bresfill.o glOric.lib  -o demoGlOric.tap
copy demoGlOric.tap %PATH_TO_ORICUTRON%\tapes
copy demoGlOric.tap %PATH_TO_ORICUTRON%\usbdrive\bin\d

REM PUSHD %PATH_TO_ORICUTRON%
REM START .\%ORICUTRON%
REM POPD
