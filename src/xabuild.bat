
DEL build\GLORIC.TAP

%OSDK%\bin\cpp.exe -lang-c++ -I %OSDK%\include -D__16BIT__ -D__NOFLOAT__ -DATMOS -DOSDKNAME_GLORIC -DOSDKVER=\"1.15\" -nostdinc start.c %OSDK%\TMP\start.c

%OSDK%\bin\compiler.exe -Nstart -O2 %OSDK%\TMP\start.c  1>%OSDK%\TMP\start.c2

%OSDK%\bin\cpp.exe -lang-c++ -imacros %OSDK%\macro\macros.h  -DXA -traditional -P %OSDK%\TMP\start.c2 %OSDK%\TMP\start.s

%OSDK%\bin\macrosplitter.exe %OSDK%\TMP\start.s %OSDK%\TMP\start

%OSDK%\bin\cpp.exe -lang-c++ -I %OSDK%\include -D__16BIT__ -D__NOFLOAT__ -DATMOS -DOSDKNAME_GLORIC -DOSDKVER=\"1.15\" -nostdinc glOric_c.c %OSDK%\TMP\glOric_c.c

%OSDK%\bin\compiler.exe -NglOric_c -O2 %OSDK%\TMP\glOric_c.c  1>%OSDK%\TMP\glOric_c.c2

%OSDK%\bin\cpp.exe -lang-c++ -imacros %OSDK%\macro\macros.h  -DXA -traditional -P %OSDK%\TMP\glOric_c.c2 %OSDK%\TMP\glOric_c.s

%OSDK%\bin\macrosplitter.exe %OSDK%\TMP\glOric_c.s %OSDK%\TMP\glOric_c

REM ECHO %OSDK%\bin\link65.exe  -d %OSDK%\lib/ -o %OSDK%\TMP\linked.s -f -q  %OSDK%\TMP\start %OSDK%\TMP\glOric_c glOric_s.s  1>%OSDK%\TMP\link.bat

REM CALL %OSDK%\TMP\link.bat

%OSDK%\bin\link65.exe  -d %OSDK%\lib/ -o %OSDK%\TMP\linked.s -f -q  %OSDK%\TMP\start %OSDK%\TMP\glOric_c glOric_s.s

%OSDK%\bin\xa.exe -W -C %OSDK%\TMP\linked.s -o build\final.out -e build\xaerr.txt -l build\symbols -bt $500 -DASSEMBLER=XA  -DOSDKNAME_GLORIC

%OSDK%\bin\header.exe  build\final.out build\GLORIC.tap $500

%OSDK%\bin\taptap.exe ren build\GLORIC.tap "glOric" 0


IF EXIST build\GLORIC.TAP GOTO OkFile
GOTO ErBld

:OkFile
COPY build\GLORIC.TAP %OSDK%\Oricutron\OSDK.TAP  1>NUL
COPY build\symbols %OSDK%\Oricutron\symbols  1>NUL

PUSHD %OSDK%\Oricutron
START oricutron.exe -t OSDK.TAP -s symbols
POPD

:ErBld
