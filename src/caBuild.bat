set PATH_TO_ORICUTRON=C:\Users\Public\Oricutron

ca65 -tatmos glOric.asm -g -l glOric.lst -o glOric.o  --include-dir .
ar65 r glOric.lib  glOric.o
cc65 demo.c -g -o demo.asm
ca65 -tatmos demo.asm -g -l demo.lst -o demo.o  --include-dir .
cl65 -v -vm -m demo.map -Ln demo.vice -g -tatmos demo.o glOric.lib  -o demoGlOric.tap
copy demoGlOric.tap %PATH_TO_ORICUTRON%\tapes

PUSHD %PATH_TO_ORICUTRON%
.\oricutron.exe -t tapes\demoGlOric.tap
POPD
