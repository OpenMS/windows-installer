# OpenMS version
!define VERSION @version@
# make sure this one has 4 version-levels
!define VERSION_LONG @version_long@


#enable one of the following lines, depending on VS2005 32bit OR VS200864bit package creation!
#!define VS_REDISTRIBUTABLE_EXE "vcredist2008_x86.exe"
#!define VS_REDISTRIBUTABLE_EXE "vcredist2005_x86.exe"
!define VS_REDISTRIBUTABLE_EXE @vcredist@

# path to QT libs
!define QTLIBDIR @qtlib_bin_dir@
# path to contrib
!define CONTRIBDIR @contrib_dir@
# path to OpenMS - build tree
!define OPENMSDIR @build_dir@
# path to OpenMS - source tree
!define OPENMSDIRSRC @source_dir@
# path to OpenMS - doc (for windows is usually hard to set up to build the doc)
!define OPENMSDOCDIR @doc_dir@

!define PLATFORM @arch_no_bit@

## actual installer:

!include C:\dev\windows-installer\OpenMS_installer.nsi