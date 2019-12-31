set PATH_TO_ORICUTRON=C:\Users\Public\Oricutron
set PLATFORM=telestrat

ca65 -t%PLATFORM% glOric.asm -g -l glOric.lst -o glOric.o  --include-dir .
ca65 -t%PLATFORM% raster\line.asm -g -l line.lst -o line.o  --include-dir .
ar65 r glOric.lib line.o glOric.o
cc65 demo.c -g -o demo.asm
ca65 -t%PLATFORM% demo.asm -g -l demo.lst -o demo.o --include-dir .
cl65 -v -vm -m demo.map -Ln demo.vice -g -t%PLATFORM% demo.o glOric.lib  -o demoGlOric.tap
copy demoGlOric.tap %PATH_TO_ORICUTRON%\tapes
copy demoGlOric.tap %PATH_TO_ORICUTRON%\usbdrive\bin\d

REM PUSHD %PATH_TO_ORICUTRON%
REM START .\oricutron.exe
REM POPD
