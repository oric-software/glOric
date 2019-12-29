set PATH_TO_ORICUTRON=C:\Users\Public\Oricutron

ca65 -tatmos glOric.asm -l glOric.lst -o glOric.o  --include-dir .
cl65 -v -vm -m demo.map -Ln demo.vice -tatmos demo.c glOric.o  -o demoGlOric.tap
copy demoGlOric.tap %PATH_TO_ORICUTRON%\tapes

PUSHD %PATH_TO_ORICUTRON%
.\oricutron.exe -t tapes\demoGlOric.tap
POPD
