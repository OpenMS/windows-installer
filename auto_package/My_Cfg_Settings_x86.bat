call "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" amd64

set PATH=C:\dev\AUTO_PACKAGE\release;C:\dev\AUTO_PACKAGE\release\OpenMS_build32\bin\Release;C:\dev\contrib_build32\lib;C:\dev\qt-everywhere-opensource-src-4.7.1_32\bin;%PATH%

REM update OpenMS
svn up OpenMS
IF %ERRORLEVEL% NEQ 0 goto bad_error

REM cmake
mkdir OpenMS_build32
cd OpenMS_build32
cmake -D CONTRIB_CUSTOM_DIR:PATH="C:\dev\contrib_build32" -G "Visual Studio 9 2008" "../OpenMS"
IF %ERRORLEVEL% NEQ 0 goto bad_error
cd..

REM Build OpenMS
devenv OpenMS_build32/OpenMS.sln /Build "Release" /Project TOPP
IF %ERRORLEVEL% NEQ 0 goto bad_error
devenv OpenMS_build32/OpenMS.sln /Build "Release" /Project UTILS
IF %ERRORLEVEL% NEQ 0 goto bad_error
devenv OpenMS_build32/OpenMS.sln /Build "Release" /Project GUI
IF %ERRORLEVEL% NEQ 0 goto bad_error
devenv OpenMS_build32/OpenMS.sln /Build "Release" /Project doc
IF %ERRORLEVEL% NEQ 0 goto bad_error
devenv OpenMS_build32/OpenMS.sln /Build "Release" /Project doc_tutorials
IF %ERRORLEVEL% NEQ 0 goto bad_error

REM build the installer
cd C:\dev\win_installer
"C:\Program Files (x86)\NSIS\makensis" /NOCD C:\dev\AUTO_PACKAGE\release\My_Cfg_Settings_x86.nsi
IF %ERRORLEVEL% NEQ 0 goto bad_error

REM copy the resulting setup:
copy /Y C:\dev\win_installer\OpenMS-1.8_Win32_setup.exe C:\dev\AUTO_PACKAGE\release\
copy /Y C:\dev\win_installer\OpenMS-1.8_Win32_setup.exe \\web\ftp.mi.fu-berlin.de\pub\OpenMS

cd C:\dev\AUTO_PACKAGE\release

exit /B 0

:bad_error
@echo An error occured. Exiting
exit /B 1
