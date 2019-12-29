set PATH_TO_ORICUTRON=C:\Users\Public\Oricutron

ca65 -tatmos glOric.asm -o glOric.o  --include-dir .
rem cl65 -C linker.cfg  -tatmos demo.c glOric.o -o toto.tap
cl65 -C linker.cfg  -tatmos demo.c -o toto.tap
copy toto.tap C:\Users\Public\Oricutron\tapes

PUSHD %PATH_TO_ORICUTRON%
.\oricutron.exe -t tapes\toto.tap
POPD
