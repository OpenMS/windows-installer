set PATH=C:\dev\AUTO_PACKAGE;C:\dev\AUTO_PACKAGE\OpenMS_build\bin\Release;C:\dev\contrib_build\lib;C:\dev\qt-win-opensource-src-4.4.3\bin;%PATH%

REM save old file
move /Y Z:\bielow\OpenMS\OpenMS-head_64_setup.exe Z:\bielow\OpenMS\last_good_OpenMS-head_64_setup.exe

REM update OpenMS
svn up OpenMS
IF %ERRORLEVEL% NEQ 0 goto bad_error

REM cmake
mkdir OpenMS_build
cd OpenMS_build
cmake -D CONTRIB_CUSTOM_DIR:PATH="C:\dev\contrib_build" -G "Visual Studio 9 2008 Win64" "../OpenMS"
IF %ERRORLEVEL% NEQ 0 goto bad_error
cd..

REM Build OpenMS
devenv OpenMS_build/OpenMS.sln /Build "Release" /Project TOPP
IF %ERRORLEVEL% NEQ 0 goto bad_error
devenv OpenMS_build/OpenMS.sln /Build "Release" /Project UTILS
IF %ERRORLEVEL% NEQ 0 goto bad_error
devenv OpenMS_build/OpenMS.sln /Build "Release" /Project doc
IF %ERRORLEVEL% NEQ 0 goto bad_error
devenv OpenMS_build/OpenMS.sln /Build "Release" /Project doc_tutorials
IF %ERRORLEVEL% NEQ 0 goto bad_error

REM build the installer
cd C:\dev\win_installer
"C:\Program Files (x86)\NSIS\makensis" /NOCD C:\dev\AUTO_PACKAGE\My_Cfg_Settings_x64.nsi
IF %ERRORLEVEL% NEQ 0 goto bad_error

REM copy the resulting setup:
copy C:\dev\win_installer\OpenMS-head_64_setup.exe C:\dev\AUTO_PACKAGE\
copy C:\dev\win_installer\OpenMS-head_64_setup.exe Z:\bielow\OpenMS

cd C:\dev\AUTO_PACKAGE

exit /B 0

:bad_error
@echo An error occured. Exiting
exit /B 1
