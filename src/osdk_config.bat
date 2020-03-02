@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKADDR=$500
SET OSDKNAME=GLORIC
SET OSDKCOMP=-O2
REM SET OSDKLINK=-B

SET OSDKFILE=main

SET OSDKFILE=%OSDKFILE%  profile
SET OSDKFILE=%OSDKFILE%  glOric kernel
SET OSDKFILE=%OSDKFILE% lrsDemo
SET OSDKFILE=%OSDKFILE% hrsDemo
SET OSDKFILE=%OSDKFILE% txtDemo
SET OSDKFILE=%OSDKFILE% rtDemo
SET OSDKFILE=%OSDKFILE% colorDemo
SET OSDKFILE=%OSDKFILE% profbench
SET OSDKFILE=%OSDKFILE% colors
SET OSDKFILE=%OSDKFILE% glProject8
SET OSDKFILE=%OSDKFILE% glProject
SET OSDKFILE=%OSDKFILE% zbuffer
SET OSDKFILE=%OSDKFILE% render\zbuff

SET OSDKFILE=%OSDKFILE% lrsDrawing
SET OSDKFILE=%OSDKFILE% hrsDrawing
REM SET OSDKFILE=%OSDKFILE% render\lrsDrawing
SET OSDKFILE=%OSDKFILE% geom
SET OSDKFILE=%OSDKFILE% logic
SET OSDKFILE=%OSDKFILE% keyboard
SET OSDKFILE=%OSDKFILE% bresfill
REM SET OSDKFILE=%OSDKFILE% math\div math\root math\square
SET OSDKFILE=%OSDKFILE% math\atan2 math\norm


SET OSDKFILE=%OSDKFILE% render\lrsSegments
SET OSDKFILE=%OSDKFILE% render\face

SET OSDKFILE=%OSDKFILE% raster\buffer raster\line8
SET OSDKFILE=%OSDKFILE% raster\fill8 raster\line
SET OSDKFILE=%OSDKFILE% raster\seg8
SET OSDKFILE=%OSDKFILE% raster\filler
SET OSDKFILE=%OSDKFILE% raster\hzfill

SET OSDKFILE=%OSDKFILE% util\print util\screen util\display util\rand

:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="glOric"

::run99.tap ..\intro\build\intro.tap
SET OSDKDNAME=" -- glOric --"
SET OSDKINIST="?\"V0.01\":WAIT20:!RUNME.COM"
