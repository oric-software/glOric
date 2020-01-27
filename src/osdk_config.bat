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
SET OSDKFILE=%OSDKFILE% math\atan2 math\div math\norm math\root math\square 
SET OSDKFILE=%OSDKFILE% raster\buffer raster\display raster\filler raster\line raster\line8 raster\fill8
SET OSDKFILE=%OSDKFILE% util\print util\screen

:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="glOric"

::run99.tap ..\intro\build\intro.tap 
SET OSDKDNAME=" -- glOric --"
SET OSDKINIST="?\"V0.01\":WAIT20:!RUNME.COM"

