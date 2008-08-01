Name "OpenMS"


### edit this to suit your system

# set to "0" for deployment!!! use "1" to build the executable fast (for script debugging) 
!define DEBUG_BUILD 0

# path to QT libs
!define QTLIBDIR "C:\Qt\4.3.4\bin"
# path to contrib
!define CONTRIBDIR "D:\uni\OpenMS_Win\my\contrib"
# path to OpenMS
!define OPENMSDIR "D:\uni\OpenMS_Win\my\OpenMS_Release1.2"
# OpenMS version
!define VERSION 1.2
# make sure this one has 4 version-levels
!define VERSION_LONG 1.2.0.0

# which extensions to connect to TOPPView
!macro OpenMSTOPPViewExtensions _action
  !insertmacro ${_action} ".mzData"
  !insertmacro ${_action} ".mzXML"
  !insertmacro ${_action} ".mzML"
  !insertmacro ${_action} ".dta"
  !insertmacro ${_action} ".dta2D"
  !insertmacro ${_action} ".cdf"
  !insertmacro ${_action} ".featureXML"
!macroend

##################
### end config ###
##################

# Defines
!define REGKEY "SOFTWARE\$(^Name)"
!define COMPANY "OpenMS Developer Team"
!define URL http://www.OpenMS.de

# we write to the registry and therefore need admin priviliges for VISTA
RequestExecutionLevel admin

# Included files
!include Sections.nsh
!include MUI.nsh
!include Library.nsh
!include FileFunc.nsh
!define ALL_USERS
!include IncludeScript_Misc.nsh
!include IncludeScript_FileLogging.nsh

# Reserved Files
!insertmacro MUI_RESERVEFILE_LANGDLL
ReserveFile "${NSISDIR}\Plugins\AdvSplash.dll"

!insertmacro RefreshShellIcons
!insertmacro un.RefreshShellIcons
!insertmacro DirState
!insertmacro GetFileName

# Variables
Var StartMenuGroup

# MUI defines
!define MUI_ICON OpenMS.ico
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "OpenMS"
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\ReleaseNotes.txt
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_LANGDLL_REGISTRY_ROOT HKLM
!define MUI_LANGDLL_REGISTRY_KEY ${REGKEY}
!define MUI_LANGDLL_REGISTRY_VALUENAME InstallerLanguage

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ${OPENMSDIR}\License.txt
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
#!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE German
!insertmacro MUI_LANGUAGE English
!insertmacro MUI_LANGUAGE French

# predefined installation modes
InstType "Recommended"  #1
InstType "Minimum"      #2
InstType "Full"         #3

# Installer attributes
OutFile OpenMS-${VERSION}_setup.exe
InstallDir "$PROGRAMFILES\OpenMS-${VERSION}"
CRCCheck on
XPStyle on
ShowInstDetails hide
VIProductVersion ${VERSION_LONG}
VIAddVersionKey /LANG=${LANG_GERMAN} ProductName "OpenMS"
VIAddVersionKey /LANG=${LANG_GERMAN} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_GERMAN} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_GERMAN} CompanyWebsite "${URL}"
VIAddVersionKey /LANG=${LANG_GERMAN} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_GERMAN} FileDescription ""
VIAddVersionKey /LANG=${LANG_GERMAN} LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails hide


Section "-hidden TESTING"
System::Alloc 32
Pop $1
System::Call "Kernel32::GlobalMemoryStatus(i) v (r1)"
System::Call "*$1(&i4 .r2, &i4 .r3, &i4 .r4, &i4 .r5, \
                  &i4 .r6, &i4.r7, &i4 .r8, &i4 .r9)"
System::Free $1
DetailPrint "Structure size (useless): $2 Bytes"
DetailPrint "Memory load: $3%"
DetailPrint "Total physical memory: $4 Bytes"
## do something with that!!

DetailPrint "Free physical memory: $5 Bytes"
DetailPrint "Total page file: $6 Bytes"
DetailPrint "Free page file: $7 Bytes"
DetailPrint "Total virtual: $8 Bytes"
DetailPrint "Free virtual: $9 Bytes"

SectionEnd

!macro CREATE_SMGROUP_SHORTCUT NAME PATH
    Push "${NAME}"
    Push "${PATH}"
    Call CreateSMGroupShortcut
!macroend

# Installer sections
Section "OpenMS Library" SEC_Lib
    SectionIn 1 2 3 RO
# we need to install add dll´s together with the binaries 
# to ensure the dynamic linking uses the correct dll´s
# (putting dll´s in another path makes it prone to 
# invalid PATH settings)
    SetOutPath $INSTDIR\bin
    SetOverwrite on

    #open log file    
    !insertmacro OpenUninstallLog

    # install file (with logging)
    !insertmacro InstallFile "${CONTRIBDIR}\lib\libxerces-c2_8_0.dll"
    !insertmacro InstallFile "${CONTRIBDIR}\lib\libgsl-0.dll"
    !insertmacro InstallFile "${CONTRIBDIR}\lib\libgslcblas-0.dll"
    
    # Installing library ..\OpenMS\lib\libOpenMS.dll
    # old: # File D:\uni\OpenMS_Win\my\OpenMS\lib\libOpenMS.dll
    #this should be obsolete: !insertmacro InstallLib REGDLL 1 REBOOT_PROTECTED ${OPENMSDIR}\lib\libOpenMS.dll $INSTDIR\bin\libOpenMS.dll $INSTDIR\bin
    
    !insertmacro InstallFile "${OPENMSDIR}\lib\libOpenMS.dll"
    RegDLL "$INSTDIR\bin\libOpenMS.dll"
    
    !if ${DEBUG_BUILD} == 0 
        !insertmacro InstallFile "${QTLIBDIR}\QtCore4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtGui4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtNetwork4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtOpenGL4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtSql4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\mingwm10.dll"
    !endif

    SetOutPath $INSTDIR\share
    SetOverwrite on
    !if ${DEBUG_BUILD} == 0 
        !insertmacro InstallFolder "${OPENMSDIR}\share\*.*" ".svn\"
    !endif
    
    # icon for files associated with TOPPView
    !insertmacro InstallFile "OpenMS_TOPPView.ico"
    
    !insertmacro CloseUninstallLog
SectionEnd

Section "TOPP tools" SEC_TOPP
    SectionIn 1 2 3 RO
    #open log file    
    !insertmacro OpenUninstallLog

    SetOutPath $INSTDIR\bin
    SetOverwrite on
    
    !if ${DEBUG_BUILD} == 0
        !insertmacro InstallFile ${OPENMSDIR}\bin\*.exe
    !endif

    !insertmacro CREATE_SMGROUP_SHORTCUT TOPPView $INSTDIR\bin\TOPPView.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT INIFileEditor $INSTDIR\bin\INIFileEditor.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT "OpenMS Homepage" http://www.OpenMS.de/
    !insertmacro CREATE_SMGROUP_SHORTCUT "TOPP command line" "$INSTDIR\bin\command.bat"

    !insertmacro CloseUninstallLog
SectionEnd

Section "Documentation" SEC_Doc
    SectionIn 1 3
    #open log file    
    !insertmacro OpenUninstallLog

    SetOutPath $INSTDIR\doc
    SetOverwrite on
    
    !if ${DEBUG_BUILD} == 0
        !insertmacro InstallFolder "${OPENMSDIR}\doc\html\*.*" ".svn\"
    !endif    

    !insertmacro CREATE_SMGROUP_SHORTCUT "OpenMS Documentation" $INSTDIR\doc\index.html

    !insertmacro CloseUninstallLog
SectionEnd

Section "-License" SEC_License
    SectionIn 1 2 3
    #open log file    
    !insertmacro OpenUninstallLog

    SetOutPath $INSTDIR
    SetOverwrite on

    !insertmacro InstallFile  "${OPENMSDIR}\License.gpl-2.0.txt"
    !insertmacro InstallFile  "${OPENMSDIR}\License.lgpl-2.1.txt"
    !insertmacro InstallFile  "${OPENMSDIR}\License.libSVM.txt"
    !insertmacro InstallFile  "${OPENMSDIR}\License.NetCDF.txt"
    !insertmacro InstallFile  "ReleaseNotes.txt"

    !insertmacro CloseUninstallLog
SectionEnd

Section "-Create_command_bat" SEC_CmdBat
    SectionIn 1 2 3
    #open log file    
    !insertmacro OpenUninstallLog
        
    ## create a command bat
    push $R0
    push $0
    StrCpy $R0 $INSTDIR 2
    fileOpen $0 "$INSTDIR\bin\command.bat" w
    fileWrite $0 "$SYSDIR\cmd.exe /k $\"$R0 && cd $INSTDIR\bin && cls && echo on && echo Welcome to the OpenMS TOPP tools command line && echo type 'dir *.exe' to see available commands && echo on $\""
    fileClose $0
    pop $0
    pop $R0

    FileWrite $UninstallLog "$INSTDIR\bin\command.bat$\r$\n"

    !insertmacro CloseUninstallLog
SectionEnd


Section "-PathInst" SEC_PathRegister
    SectionIn 1 2 3
    # no logging required, as we do not install files in this section
    
    Push "$INSTDIR\bin"
    Call AddToPath

    #create OpenMS data path (for shared xml files etc)
    Push "OPENMS_DATA_PATH"
    Push "$INSTDIR\share\OpenMS"
    Call WriteEnvStr

SectionEnd

SectionGroup "Register File Extensions" SEC_RegisterExt
    # no logging required, as we do not install files in this section


    # windows registry info: http://support.microsoft.com/kb/256986
    !insertmacro OpenMSTOPPViewExtensions RegisterExtensionSection
    
    Section "-RegFileRefreshInternal" SEC_RegFileRefreshInternal
        SectionIn 1 2 3
        ${RefreshShellIcons}
    SectionEnd
        
SectionGroupEnd

Section -post SEC0008
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    WriteRegStr HKLM "${REGKEY}" "UninstallString" "$INSTDIR\uninstall.exe"
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    #WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Installer functions
Function .onInit

    # show splash screen
    InitPluginsDir
    Push $R1
    File /oname=$PLUGINSDIR\spltmp.bmp OpenMS_splash.bmp
    advsplash::show 1000 600 400 -1 $PLUGINSDIR\spltmp
    Pop $R1
    Pop $R1
    
    # check for previous versions
    #on install we did:     WriteRegStr HKLM "${REGKEY}" "Path" "$INSTDIR"
    ReadRegStr $R0  HKLM "${REGKEY}" "Path"
    StrCmp $R0 "" virgin_install
    
    ## store, if the old-installer is present ($R8 should be empty then)
    ReadRegStr $R8  HKLM "${REGKEY}" "UninstallString"    

    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
      "OpenMS has already been installed. $\nThe old version will be removed automatically. \
       Please close all OpenMS applications before continuing!" \
      IDCANCEL  quit_installer

    ;Run the uninstaller
    ClearErrors
    ExecWait '$R0\uninstall.exe _?=$R0';; Do not execute the copy of uninstaller (ExecWait won´t work)
    Delete "$R0\uninstall.exe"          # delete installer manually
    
    push $R9
    ${DirState} "$R0" $R9
    StrCmp $R9 1 0 virgin_install
    pop $R9
    
    # look for the very first (and buggy) version of the installer
    StrCmp $R8 "" 0 new_installer    
        # we found the old installer:
        ## delete the licenses, share other stuff
        RmDir /REBOOTOK "$R0\GUI"
        RmDir /REBOOTOK /r "$R0\share"
        Delete /REBOOTOK "$R0\*.txt"
        ## correct Path settings (they were not properly reset)
        Push "$R0\lib"
        Call RemoveFromPath
        Push "$R0\TOPP"
        Call RemoveFromPath
        Push "OPENMS_DATA_PATH"
        Call DeleteEnvStr
            
    
    new_installer:

    ## check that all *.dll´s and *.exe files are gone (userfiles are ok)! otherwise force reboot
    !insertmacro REBOOT_ON_INCOMPLETE_DELETION $R0
   
  virgin_install:
    
    !insertmacro MUI_LANGDLL_DISPLAY
  
    return
    
  quit_installer:
    quit
  
FunctionEnd


# set the component descriptions after the Sections have been defined!
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_Lib} "The core libraries of OpenMS"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_TOPP} "TOPP (The OpenMS Proteomics Pipeline) - chainable tools for data analysis"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_Doc} "Documentation/Tutorials for TOPP, TOPPView and the OpenMS library itself."
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_RegisterExt} "Register certain file types (e.g. '.mzData') with TOPPView.exe"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

################
## UNINSTALL ###
################

# Uninstaller sections

Section "Uninstall"
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MUI_UNGETLANGUAGE


    # unregister our dll    
    UnRegDLL "$INSTDIR\bin\libOpenMS.dll"

    # remove OpenMS from environment paths
    Push "$INSTDIR\bin"
    Call un.RemoveFromPath

    Push "OPENMS_DATA_PATH"
    Call un.DeleteEnvStr

    # remove extension-links to TOPPView
    !insertmacro OpenMSTOPPViewExtensions UnRegisterExtensionSection
    ${un.RefreshShellIcons}

    ## delete all installed files
    FileOpen $UninstallLog "$INSTDIR\uninstall.log" r
  UninstallLoop:
    ClearErrors
    FileRead $UninstallLog $R0
    IfErrors UninstallEnd
    Push $R0
    Call un.TrimNewLines
    Pop $R0
    Delete $R0
    Goto UninstallLoop
  UninstallEnd:
    FileClose $UninstallLog
    Delete "$INSTDIR\uninstall.log"
    Delete "$INSTDIR\uninstall.exe"
    # remove directories which are now empty
    Push "\"
    Call un.RemoveEmptyDirs
    
    ## clean up the registry
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    # delete /Software/OpenMS (with all its content)
    DeleteRegKey HKLM "${REGKEY}"

    # delete Startmenu-Entry
    RmDir /r /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR


SectionEnd


Function CreateSMGroupShortcut
    Exch $R0 ;PATH
    Exch
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    StrCpy $OUTDIR "$INSTDIR"       # execute link target in $OUTDIR
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$R1.lnk" $R0
no_smgroup:
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

# Installer Language Strings
# TODO Update the Language Strings with the appropriate translations.

LangString ^UninstallLink ${LANG_GERMAN} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_FRENCH} "Uninstall $(^Name)"


