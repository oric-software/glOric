@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKADDR=$500
SET OSDKNAME=GLORIC
SET OSDKCOMP=
REM SET OSDKLINK=-B

SET OSDKFILE=main


SET OSDKFILE=%OSDKFILE%  glOric kernel
SET OSDKFILE=%OSDKFILE% lrsDemo
SET OSDKFILE=%OSDKFILE% traj
SET OSDKFILE=%OSDKFILE% zbuffer

SET OSDKFILE=%OSDKFILE% lrsDrawing
REM SET OSDKFILE=%OSDKFILE% render\lrsDrawing


SET OSDKFILE=%OSDKFILE% bresfill
REM SET OSDKFILE=%OSDKFILE% math\div math\root math\square
SET OSDKFILE=%OSDKFILE% math\atan2 math\norm


SET OSDKFILE=%OSDKFILE% render\lrsSegments
REM SET OSDKFILE=%OSDKFILE% render\zbuffer
REM SET OSDKFILE=%OSDKFILE% raster\bresfill
REM SET OSDKFILE=%OSDKFILE% raster\buffer raster\line8
SET OSDKFILE=%OSDKFILE% raster\fill8 raster\line
REM SET OSDKFILE=%OSDKFILE% logic

REM SET OSDKFILE=%OSDKFILE%  raster\filler 
SET OSDKFILE=%OSDKFILE% util\print util\screen util\display

:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="glOric"

::run99.tap ..\intro\build\intro.tap
SET OSDKDNAME=" -- glOric --"
SET OSDKINIST="?\"V0.01\":WAIT20:!RUNME.COM"
