
## define your platform:
!define PLATFORM "64"


!if ${PLATFORM} == 32
  #enable one of the following lines, depending on VS2005 32bit OR VS200864bit package creation!
  !define VS_REDISTRIBUTABLE_EXE "vcredist2008_x86.exe"
  #!define VS_REDISTRIBUTABLE_EXE "vcredist2005_x86.exe"

  # path to QT libs
  !define QTLIBDIR "C:\dev\qt-everywhere-opensource-src-4.7.1_vs10\bin"
  # path to contrib
  !define CONTRIBDIR "C:\dev\contrib_build32"
  # path to OpenMS - build tree
  !define OPENMSDIR "C:\dev\OpenMS_build32"
  # path to OpenMS - source tree
  !define OPENMSDIRSRC "C:\dev\OpenMS"
  # path to OpenMS - doc (for windows is usually hard to set up to build the doc)
  !define OPENMSDOCDIR "C:\dev\OpenMS_build32\doc"

!else
  !define VS_REDISTRIBUTABLE_EXE "vcredist2012_x64.exe"

  # path to QT libs
  !define QTLIBDIR "C:\dev\qt-everywhere-opensource-src-4.8.2\bin"
  # path to contrib
  !define CONTRIBDIR "C:\dev\contrib_build"
  # path to OpenMS - build tree
  !define OPENMSDIR "C:\dev\OpenMS build"
  # path to OpenMS - source tree
  !define OPENMSDIRSRC "C:\dev\OpenMS"
  # path to OpenMS - doc (for windows is usually hard to set up to build the doc)
  !define OPENMSDOCDIR "C:\dev\OpenMS build\doc"
!endif

