# OpenMS version
!define VERSION @version@
# make sure this one has 4 version-levels
!define VERSION_LONG @version_long@


#enable one of the following lines, depending on which VS was used for package creation!
#e.g. !define VS_REDISTRIBUTABLE_EXE "vcredist2008_x86.exe"
!define VS_REDISTRIBUTABLE_EXE @vcredist@

# path to QT libs
!define QTLIBDIR @qtlib_bin_dir@
# path to contrib
!define CONTRIBDIR @contrib_dir@
# path to OpenMS - build tree
!define OPENMSDIR @build_dir@
# path to OpenMS - source tree
!define OPENMSDIRSRC @source_dir@
# path to OpenMS - doc (for windows is usually hard to set up to build the doc and doc_tutorials)
!define OPENMSDOCDIR @doc_dir@
# path to Thirdparty executables (e.g. to clone from git: OpenMS/THIRDPARTY)
!define THIRDPARTYDIR @thirdparty_dir@

!define PLATFORM @arch_no_bit@

## actual installer:
!include @git_openms_installer_nsi_path@
