@ECHO OFF

::
:: Set the build paremeters
::
SET OSDKADDR=$500
SET OSDKNAME=3DWALKTHROUGH
SET OSDKCOMP=-O2
REM SET OSDKLINK=-B

SET OSDKFILE=walkthrough release\glOric_v12



:: List of files to put in the DSK file.
:: Implicitely includes BUILD/%OSDKNAME%.TAP
SET OSDKTAPNAME="3DWalkthrough"

::run99.tap ..\intro\build\intro.tap
SET OSDKDNAME=" -- 3D Walkthrough --"
SET OSDKINIST="?\"V1.1\":WAIT20:!RUNME.COM"
