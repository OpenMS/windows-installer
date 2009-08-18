# OpenMS version
!define VERSION 1.5
# make sure this one has 4 version-levels
!define VERSION_LONG 1.5.0.0


#enable one of the following lines, depending on VS2005 32bit OR VS200864bit package creation!
#!define VS_REDISTRIBUTABLE_EXE "vcredist2008_x86.exe"
#!define VS_REDISTRIBUTABLE_EXE "vcredist2005_x86.exe"
!define VS_REDISTRIBUTABLE_EXE "vcredist2008_x64.exe"

# path to QT libs
!define QTLIBDIR "C:\dev\qt-win-opensource-src-4.4.3\bin"
# path to contrib
!define CONTRIBDIR "C:\dev\contrib_build"
# path to OpenMS - build tree
!define OPENMSDIR "C:\dev\AUTO_PACKAGE\release\OpenMS_build"
# path to OpenMS - source tree
!define OPENMSDIRSRC "C:\dev\AUTO_PACKAGE\release\OpenMS"
# path to OpenMS - doc (for windows is usually hard to set up to build the doc)
!define OPENMSDOCDIR "C:\dev\AUTO_PACKAGE\release\OpenMS_build\doc"


## eigentlicher Installer:

!include C:\dev\win_installer\OpenMS_installer.nsi