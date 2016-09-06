Name "OpenMS"

############################################
## see README before running this script! ##
############################################
## useful resources:
# http://abarinoff-dev.blogspot.com/2010/04/passing-parameters-and-retrieving.html
# http://nsis.sourceforge.net/UAC_plug-in
# http://nsis.sourceforge.net/Inetc_plug-in
#
## using the UAC-plugin the installer is run in elevated mode my default (inner instance). If you want to
## do some user specific action (e.g. Start-Menu entries) you need to use the UAC's wrappers and calls

##################
###   config   ###
##################
### edit the below files to suit your system
# - Cfg_Version.nsh
# - Cfg_Settings.nsh

# set to "0" for deployment!!! use "1" to build the executable fast (for script debugging) 
!define DEBUG_BUILD 0
# set to "0" for deployment!!! use "1" to skip packaging of *.html files (takes ages)
!define DEBUG_SKIP_DOCU 0

# marks a section as off. Already defined in an include
##!define SECTION_OFF 0xFFFFFFFE

##################
###   SCRIPT   ###
##################

# contains the OpenMS version
!ifndef VERSION
!include Cfg_Version.nsh
!endif

# set OpenMS paths and other stuff (if not already set by parent script)
!ifndef VS_REDISTRIBUTABLE_EXE
!include Cfg_Settings.nsh
!endif

!ifndef PLATFORM
!define PLATFORM 32
!endif

# pwiz needs alternative VS runtime libraries (32bit for Agilent libraries)
!define VS_PWIZ_REDISTRIBUTABLE_EXE "vcredist2010_x86_sp1.exe"

# additional pwiz redistributables
!if ${PLATFORM} == 32
  !define VS_PWIZ_ADD1_REDISTRIBUTABLE_EXE "vcredist2012_x86_upd4.exe"
!else
  !define VS_PWIZ_ADD1_REDISTRIBUTABLE_EXE "vcredist2012_x64_upd4.exe"
!endif

!ifndef THIRDPARTYDIR
!warning "Variable THIRDPARTYDIR not set. Will deactivate installation of Thirdparty binaries."
## TODO SetSectionFlag not defined??
##!insertmacro SetSectionFlag ${SEC_ThirdParty} ${SECTION_OFF} 
!endif

# which extensions to connect to TOPPView and TOPPAS
!macro OpenMSGUIExtensions _action
  !insertmacro ${_action} ".mzData" "TOPPView"
  !insertmacro ${_action} ".mzXML" "TOPPView"
  !insertmacro ${_action} ".mzML" "TOPPView"
  !insertmacro ${_action} ".dta" "TOPPView"
  !insertmacro ${_action} ".dta2D" "TOPPView"
  !insertmacro ${_action} ".cdf" "TOPPView"
  !insertmacro ${_action} ".idXML" "TOPPView"
  !insertmacro ${_action} ".featureXML" "TOPPView"
  !insertmacro ${_action} ".consensusXML" "TOPPView"
  !insertmacro ${_action} ".toppas" "TOPPAS"
!macroend

# Defines
!define REGKEY "SOFTWARE\$(^Name)"
!define COMPANY "OpenMS Developer Team"
!define URL http://www.OpenMS.de
!define APPNAME "OpenMS"

## UAC plugin requires us to use normal user privileges
##, it will launch an admin process within the user process automatically
RequestExecutionLevel user    /* RequestExecutionLevel REQUIRED! */

# Included files

!include MUI2.nsh
!include Sections.nsh
!include Library.nsh
!include FileFunc.nsh
!include UAC.nsh
#!define ALL_USERS
!include IncludeScript_Misc.nsh
!include IncludeScript_FileLogging.nsh
!include EnvVarUpdate.nsh
!include x64.nsh
!include LogicLib.nsh

# Reserved Files
!insertmacro MUI_RESERVEFILE_LANGDLL
# Modify the next line to adapt to the plugin for other NSIS versions (currently 3.0b2)
# NSIS 2.x does not have the subfolders x86-unicode or x86-ansi, so remove them.
# The next line was tested on 3.0b1 and 3.0b2 and does not seem to work in 3.0b3
ReserveFile "${NSISDIR}\Plugins\x86-unicode\advsplash.dll"

;--------------------------------
;Interface Configuration

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP ".\images\header.bmp" ; optional
!define MUI_HEADERIMAGE_UNBITMAP ".\images\header-uninstall.bmp" ; optional
!define MUI_HEADERIMAGE_RIGHT
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP ".\images\wizard.bmp" ; optional
!define MUI_UNWELCOMEFINISHPAGE_BITMAP ".\images\wizard-uninstall.bmp" ; optional

!insertmacro RefreshShellIcons
!insertmacro un.RefreshShellIcons
!insertmacro DirState
!insertmacro GetFileName

# Variables
Var StartMenuGroup

# MUI defines
#!define MUI_ICON OpenMS.ico
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
!insertmacro MUI_PAGE_LICENSE ${OPENMSDIRSRC}\License.txt
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

# Installer Language Strings
LangString ^UninstallLink ${LANG_GERMAN} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_FRENCH} "Uninstall $(^Name)"


# predefined installation modes
InstType "Recommended"  #1
InstType "Minimum"      #2
InstType "Full"         #3

# Installer attributes
!if ${PLATFORM} == 32
	OutFile OpenMS-${VERSION}_Win32_setup.exe
	InstallDir "$PROGRAMFILES32\OpenMS-${VERSION}"
!else
	OutFile OpenMS-${VERSION}_Win64_setup.exe
	InstallDir "$PROGRAMFILES64\OpenMS-${VERSION}"
!endif
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

; HKLM (all users) vs HKCU (current user) defines
!define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
!define env_hkcu 'HKCU "Environment"'

!macro CREATE_SMGROUP_SHORTCUT NAME PATH
    Push "${NAME}"
    Push "${PATH}"
    Call CreateSMGroupShortcut
!macroend

Function CreateSMGroupShortcut
    Exch $R0 ;PATH
    Exch
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    StrCpy $OUTDIR "$INSTDIR"       # execute link target in $OUTDIR
    
    CreateDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortcut "$SMPROGRAMS\${APPNAME}\$R1.lnk" $R0
    ## TODO (currently the start menu entry is in admin space)
    #UAC::StackPush "$SMPROGRAMS\$StartMenuGroup\$R1.lnk"
    #UAC::StackPush  $R0
    #GetFunctionAddress $1 CreateShortcut
    #UAC::ExecCodeSegment $1    
no_smgroup:
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd



; Section "-hidden TESTING"
; System::Alloc 32
; Pop $1
; System::Call "Kernel32::GlobalMemoryStatus(i) v (r1)"
; System::Call "*$1(&i4 .r2, &i4 .r3, &i4 .r4, &i4 .r5, \
                  ; &i4 .r6, &i4.r7, &i4 .r8, &i4 .r9)"
; System::Free $1
; DetailPrint "Structure size (useless): $2 Bytes"
; DetailPrint "Memory load: $3%"
; DetailPrint "Total physical memory: $4 Bytes"
; ## do something with that!!

; DetailPrint "Free physical memory: $5 Bytes"
; DetailPrint "Total page file: $6 Bytes"
; DetailPrint "Free page file: $7 Bytes"
; DetailPrint "Total virtual: $8 Bytes"
; DetailPrint "Free virtual: $9 Bytes"
; SectionEnd


# Installer sections
Section "OpenMS Library" SEC_Lib
    SectionIn 1 2 3 RO
# we need to install add dll´s together with the binaries 
# to ensure the dynamic linking uses the correct dll´s
# (putting dll´s in another path makes it prone to 
# invalid PATH settings)
    SetOutPath $INSTDIR\bin
    SetOverwrite on

    # open log file    
    !insertmacro OpenUninstallLog

    # install file (with logging)
    !insertmacro InstallFile "${CONTRIBDIR}\lib\xerces-c_3_1.dll"
    
    !insertmacro InstallFile "${OPENMSDIR}\bin\Release\OpenMS.dll"
    !insertmacro InstallFile "${OPENMSDIR}\bin\Release\OpenMS_GUI.dll"
    !insertmacro InstallFile "${OPENMSDIR}\bin\Release\OpenSwathAlgo.dll"
    !insertmacro InstallFile "${OPENMSDIR}\bin\Release\SuperHirn.dll"
    
    !if ${DEBUG_BUILD} == 0 
        !insertmacro InstallFile "${QTLIBDIR}\QtCore4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtGui4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtNetwork4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtOpenGL4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtSql4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtSvg4.dll"
        !insertmacro InstallFile "${QTLIBDIR}\QtWebKit4.dll"
		!insertmacro InstallFile "${QTLIBDIR}\phonon4.dll"   ## WebKit4 depends on it
    !endif

    SetOutPath $INSTDIR\share
    SetOverwrite on
    !if ${DEBUG_BUILD} == 0 
        !insertmacro InstallFolder "${OPENMSDIRSRC}\share\*.*" ".svn\"
    !endif
    
    # icon for *files* associated with TOPPView
    !insertmacro InstallFile "OpenMS_TOPPView.ico"
    !insertmacro InstallFile "OpenMS_TOPPAS.ico"
    
    !insertmacro CloseUninstallLog
SectionEnd

Section "TOPP tools" SEC_TOPP
    SectionIn 1 2 3 RO
    #open log file    
    !insertmacro OpenUninstallLog

    SetOutPath $INSTDIR\bin
    SetOverwrite on
    
    !if ${DEBUG_BUILD} == 0
        !insertmacro InstallFile "${OPENMSDIR}\bin\Release\*.exe"
    !endif

    !insertmacro CloseUninstallLog
SectionEnd


Section "Documentation" SEC_Doc
    SectionIn 1 3
    #open log file    
    !insertmacro OpenUninstallLog

    SetOverwrite on
    
		## html docu
    !if ${DEBUG_SKIP_DOCU} == 0
      SetOutPath $INSTDIR\doc\html
      !insertmacro InstallFolder "${OPENMSDOCDIR}\html\*.*" ".svn\"
      SetOutPath $INSTDIR\doc
      !insertmacro InstallFile "${OPENMSDOCDIR}\TOPP_tutorial.pdf"
      !insertmacro InstallFile "${OPENMSDOCDIR}\OpenMS_tutorial.pdf"
    !endif    

    !insertmacro CloseUninstallLog
SectionEnd

## Third party libs
SectionGroup "ThirdParty" SEC_ThirdParty   
	!if ${DEBUG_BUILD} == 0
		Section "Proteowizard"
		    SectionIn 1 3
			!insertmacro OpenUninstallLog
			SetOverwrite on
			CreateDirectory "$INSTDIR\share\OpenMS\THIRDPARTY\pwiz-bin"
			SetOutPath "$INSTDIR\share\OpenMS\THIRDPARTY\pwiz-bin"
      !insertmacro InstallFolder "${THIRDPARTYDIR}\pwiz-bin\*.*" ".git\"

			## download .NET 3.5 and 4.0 (required by pwiz)
			MessageBox MB_YESNO "Proteowizard requires both .NET 3.5 SP1 and .NET 4.0 installed. The installer will now download 'Microsoft .NET 3.5 SP1'. \
					   If you already have 'Microsoft .NET 3.5 SP1' installed you can skip this step. Do you wish to download it?" \
					   IDNO net35_install_success

			inetc::get /BANNER "Getting .NET 3.5 SP1 installer." \
					"http://www.microsoft.com/downloads/info.aspx?na=41&SrcFamilyId=AB99342F-5D1A-413D-8319-81DA479AB0D7&SrcDisplayLang=en&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f0%2f6%2f1%2f061F001C-8752-4600-A198-53214C69B51F%2fdotnetfx35setup.exe" \
					"$EXEDIR\NET3.5_SP1_installer.exe"
			Pop $0
			StrCmp $0 "OK" dl35ok
			MessageBox MB_OK|MB_ICONEXCLAMATION "Downloading 'Microsoft .NET 3.5 SP1' failed. You must download and install it manually in order for Proteowizard to work!"
				
			dl35ok:
			ClearErrors
			ExecWait '"$EXEDIR\NET3.5_SP1_installer.exe"' $0
			StrCmp $0 0 net35_install_success
			MessageBox MB_OK "The installation of the Microsoft .NET 3.5 SP1' package failed! You must download and install it manually in order for Proteowizard to work!"
			
			net35_install_success:
			## .NET 3.5 installed, yeah!

			MessageBox MB_YESNO "The installer will now download 'Microsoft .NET 4.0', which is required by Proteowizard. \
					   If you already have 'Microsoft .NET 4.0' installed you can skip this step. Do you wish to download it?" \
					   IDNO net40_install_success

			inetc::get /BANNER "Getting .NET 4.0 installer." \
					"http://www.microsoft.com/downloads/info.aspx?na=41&SrcFamilyId=AB99342F-5D1A-413D-8319-81DA479AB0D7&SrcDisplayLang=en&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f9%2f5%2fA%2f95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE%2fdotNetFx40_Full_x86_x64.exe" \
					"$EXEDIR\NET4.0_installer.exe"
					
			Pop $0
			StrCmp $0 "OK" dl40ok
			MessageBox MB_OK|MB_ICONEXCLAMATION "Downloading 'Microsoft .NET 4.0' failed. You must download and install it manually in order for Proteowizard to work!"
				
			dl40ok:
			ClearErrors
			ExecWait '"$EXEDIR\NET4.0_installer.exe"' $0
			StrCmp $0 0 net40_install_success
			MessageBox MB_OK "The installation of the Microsoft .NET 4.0' package failed! You must download and install it manually in order for Proteowizard to work!"
			
			net40_install_success:
			## .NET 4.0 installed, yeah!
			
			## pwiz now requires vs 2010 32bit (!) runtime libraries installed (Agilent libraries)
			SetOutPath $TEMP
			SetOverwrite on

			!insertmacro InstallFile  ${VS_PWIZ_REDISTRIBUTABLE_EXE}
			ClearErrors
			ExecWait '$TEMP\${VS_PWIZ_REDISTRIBUTABLE_EXE} /q' $0
			StrCmp $0 0 vs_pwiz_install_success
			MessageBox MB_OK "The installation of the Visual Studio redistributable package '${VS_PWIZ_REDISTRIBUTABLE_EXE}' failed! Proteowizard will not work unless this package is installed! The package is located at '$TEMP\${VS_PWIZ_REDISTRIBUTABLE_EXE}'. Try to execute it as administrator - there will likely be an error which you can blame Microsoft for. If you cannot fix it contact the OpenMS developers!"

			## reasons why the install might fail:
			## see doc\doxygen\install\install-win-bin.doxygen --> FAQ
			
			vs_pwiz_install_success:
			
                        !insertmacro InstallFile  ${VS_PWIZ_ADD1_REDISTRIBUTABLE_EXE}
			ClearErrors
			ExecWait '$TEMP\${VS_PWIZ_REDISTRIBUTABLE_EXE} /q' $0
			StrCmp $0 0 vs_pwiz_add1_install_success
			MessageBox MB_OK "The installation of the Visual Studio redistributable package '${VS_PWIZ_ADD1_REDISTRIBUTABLE_EXE}' failed! Proteowizard will not work unless this package is installed! The package is located at '$TEMP\${VS_PWIZ_ADD1_REDISTRIBUTABLE_EXE}'. Try to execute it as administrator - there will likely be an error which you can blame Microsoft for. If you cannot fix it contact the OpenMS developers!"

			vs_pwiz_add1_install_success:
			
			!insertmacro CloseUninstallLog
		SectionEnd

      ## Install everything in the given (flattened) THIRDPARTY folder.
      !tempfile filelist
      !system 'FOR /D %A IN ("${THIRDPARTYDIR}\*") DO @( IF NOT "%~nA" == "pwiz-bin" ((echo Section "%~nA" & echo SectionIn 1 3 & echo !insertmacro OpenUninstallLog & echo SetOverwrite on & echo CreateDirectory "$INSTDIR\share\OpenMS\THIRDPARTY\%~nA" & echo SetOutPath "$INSTDIR\share\OpenMS\THIRDPARTY\%~nA" & echo !insertmacro InstallFolder "%~A\*.*" ".git\" & echo Var /GLOBAL %~nAInstalled & echo StrCpy $%~nAInstalled "1" & echo !insertmacro CloseUninstallLog & echo SectionEnd) >> "${filelist}"))'
      !include "${filelist}"
      !delfile "${filelist}"

	!endif
	

SectionGroupEnd

Section "-License" SEC_License
    SectionIn 1 2 3
    #open log file    
    !insertmacro OpenUninstallLog

    SetOutPath $INSTDIR
    SetOverwrite on

    #!insertmacro InstallFile  "${OPENMSDIR}\License.gpl-2.0.txt"
    #!insertmacro InstallFile  "${OPENMSDIR}\License.lgpl-2.1.txt"
    #!insertmacro InstallFile  "${OPENMSDIR}\License.libSVM.txt"
    #!insertmacro InstallFile  "${OPENMSDIR}\License.NetCDF.txt"
    !insertmacro InstallFile  "ReleaseNotes.txt"

    !insertmacro CloseUninstallLog
SectionEnd

Function CreateShortcuts
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    
		## warning: create shortcuts only AFTER installing files, OR renew SetOutPath
		## otherwise all files will be installed to the default install directory
    !insertmacro CREATE_SMGROUP_SHORTCUT "OpenMS Documentation (html)" $INSTDIR\doc\html\index.html
    !insertmacro CREATE_SMGROUP_SHORTCUT "TOPP and TOPPView tutorial (pdf)" $INSTDIR\doc\TOPP_tutorial.pdf
    !insertmacro CREATE_SMGROUP_SHORTCUT "OpenMS Tutorial (pdf)" $INSTDIR\doc\OpenMS_tutorial.pdf

    !insertmacro CREATE_SMGROUP_SHORTCUT TOPPView $INSTDIR\bin\TOPPView.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT TOPPAS $INSTDIR\bin\TOPPAS.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT INIFileEditor $INSTDIR\bin\INIFileEditor.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT "OpenMS Homepage" http://www.OpenMS.de/
    !insertmacro CREATE_SMGROUP_SHORTCUT "TOPP command line" "$INSTDIR\bin\command.bat"

    SetOutPath $SMPROGRAMS\${APPNAME}
    CreateShortcut "$SMPROGRAMS\${APPNAME}\$(^UninstallLink).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    
FunctionEnd


Section "-Create_StartMenu" SEC_StartMenuCreate
  GetFunctionAddress $0 CreateShortcuts
  UAC::ExecCodeSegment $0
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
    
    ## HINT: do not forget to also add/modify the un.EnvVarUpdate in the uninstall section!
    
    # OpenMS binary path
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"
    IfErrors 0 +2
			MessageBox MB_OK "Unable to add '$INSTDIR\bin' to PATH environment. Add manually if required. See 'details' for details."
	
    # Third Party library paths
    FindFirst $0 $1 "$INSTDIR\share\OpenMS\THIRDPARTY\$1"
    loop:
    StrCmp $1 "" done
    ${If} ${FileExists} "$1\*.*"
      ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\share\OpenMS\THIRDPARTY\$1"
      IfErrors 0 +2
        MessageBox MB_OK "Unable to add '$INSTDIR\share\OpenMS\THIRDPARTY\$1' to PATH environment. Add manually if required. See 'details' for details."
    ${EndIf}
    FindNext $0 $1
    Goto loop
    done:
    FindClose $0

    #create OPENMS_DATA_PATH environment variable (for shared xml files etc)
    ; set variable
    WriteRegExpandStr ${env_hklm} "OPENMS_DATA_PATH" "$INSTDIR\share\OpenMS"
    ; make sure windows knows about the change
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

SectionEnd

SectionGroup "Register File Extensions" SEC_RegisterExt
    # no logging required, as we do not install files in this section


    # windows registry info: http://support.microsoft.com/kb/256986
    !insertmacro OpenMSGUIExtensions RegisterExtensionSection
    
    Section "-RegFileRefreshInternal" SEC_RegFileRefreshInternal
        SectionIn 1 2 3
        ${RefreshShellIcons}
    SectionEnd
        
SectionGroupEnd

Section "-hidden VSRuntime"
    # this requires admin privileges (which we should have, due to UAC plug-in)!
    
    ## TODO (when bored)
		#install the visual studio runtime
		#NSISdl::download http://www.domain.com/file localfile.exe
		#Pop $R0 ;Get the return value
		#	StrCmp $R0 "success" +3
		#		MessageBox MB_OK "The download of the Visual Studio redistributable failed!\nP"
		#		Quit

	SetOutPath $TEMP
    SetOverwrite on

    !insertmacro InstallFile  ${VS_REDISTRIBUTABLE_EXE}
	ClearErrors
    ExecWait '$TEMP\${VS_REDISTRIBUTABLE_EXE} /q' $0
	StrCmp $0 0 vs_install_success
	MessageBox MB_OK "The installation of the Visual Studio redistributable package '${VS_REDISTRIBUTABLE_EXE}' failed! OpenMS will not work unless this package is installed! The package is located at '$TEMP\${VS_REDISTRIBUTABLE_EXE}'. Try to execute it as administrator - there will likely be an error which you can blame Microsoft for. If you cannot fix it contact the OpenMS developers!"
		
    ## reasons why the install might fail:
    ## see doc\doxygen\install\install-win-bin.doxygen --> FAQ
    
	vs_install_success:
		
SectionEnd

Section -post SEC0008
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    WriteRegStr HKLM "${REGKEY}" "UninstallString" "$INSTDIR\uninstall.exe"
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "OpenMS Developer Team"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Installer functions
; Attempt to give the UAC plug-in a user process and an admin process.
Function .onInit

## UAC init:
## copied from http://nsis.sourceforge.net/UAC_plug-in

UAC_Elevate:
    UAC::RunElevated 
    StrCmp 1223 $0 UAC_ElevationAborted ; UAC dialog aborted by user?
    StrCmp 0 $0 0 UAC_Err ; Error?
    StrCmp 1 $1 0 UAC_Success ;Are we the real deal or just the wrapper?
    Quit
 
UAC_Err:
    MessageBox mb_iconstop "Unable to elevate, error $0"
    Abort
 
UAC_ElevationAborted:
    # elevation was aborted, run as normal?
    MessageBox mb_iconstop "This installer requires administrative rights, aborting!"
    Abort
 
UAC_Success:
    StrCmp 1 $3 +4 ;Admin?
    StrCmp 3 $1 0 UAC_ElevationAborted ;Try again?
    MessageBox mb_iconstop "This installer requires administrative rights, try again"
    goto UAC_Elevate 
 
## now our own code:
 
    # show splash screen
    InitPluginsDir
    Push $R1
    File /oname=$PLUGINSDIR\spltmp.bmp OpenMS_splash.bmp
    advsplash::show 1000 600 400 -1 $PLUGINSDIR\spltmp
    Pop $R1
    Pop $R1

	## deny starting of x64 installer on an x86 system (will not run)
	!if ${PLATFORM} == 64
		${If} ${RunningX64}
		${else}
		  MessageBox mb_iconstop "You are running a 32bit operating system. The executables of this setup are 64bit, and thus cannot be run after installation. Use a 64bit OS, or use the 32bit setup of OpenMS."
		  Abort
		${EndIf}
	!endif
	
	
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
        ${EnvVarUpdate} $0 "PATH" "R" "HKLM" "$R0\lib"
        ${EnvVarUpdate} $0 "PATH" "R" "HKLM" "$R0\TOPP"
        ; delete variable
        DeleteRegValue ${env_hklm} "OPENMS_DATA_PATH"
        ; make sure windows knows about the change
        SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
        #${EnvVarUpdate} $0 "OPENMS_DATA_PATH" "R" "HKLM" "$R0\lib"
    
    new_installer:

    ## check that all *.dll´s and *.exe files are gone (userfiles are ok)! otherwise force reboot
    !insertmacro REBOOT_ON_INCOMPLETE_DELETION $R0
   
  virgin_install:
    
    !insertmacro MUI_LANGDLL_DISPLAY
  
    return
    
  quit_installer:
    quit
  
FunctionEnd

Function .OnInstFailed
   UAC::Unload ;Must call unload!
FunctionEnd
 
Function .OnInstSuccess
   UAC::Unload ;Must call unload!
FunctionEnd


# set the component descriptions after the Sections have been defined!
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_Lib} "The core libraries of OpenMS"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_TOPP} "TOPP (The OpenMS Proteomics Pipeline) - chainable tools for data analysis"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_Doc} "Documentation/Tutorials for TOPP, TOPPView and the OpenMS library itself."
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_ThirdParty} "Install third party libraries (e.g. ProteoWizard)."
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_RegisterExt} "Register certain file types (e.g. '.mzML') with TOPPView.exe"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

################
## UNINSTALL ###
################

# Uninstaller sections

Section "Uninstall"
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MUI_UNGETLANGUAGE

    ## undo changes to PATH 
    
    # OpenMS binary path
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin"
    
    # Third Party library paths
    FindFirst $0 $1 "$INSTDIR\share\OpenMS\THIRDPARTY\$1"
    loop:
    StrCmp $1 "" done
    ${If} ${FileExists} "$1\*.*"
      ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\share\OpenMS\THIRDPARTY\$1"
    ${EndIf}
    FindNext $0 $1
    Goto loop
    done:
    FindClose $0

    ## remove OPENMS_DATA_PATH
    ${un.EnvVarUpdate} $0 "OPENMS_DATA_PATH" "R" "HKLM" "$INSTDIR\share\OpenMS"

    # remove extension-links to TOPPView
    !insertmacro OpenMSGUIExtensions UnRegisterExtensionSection
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

    
    RmDir /REBOOTOK $INSTDIR

    ## delete start menu entries (via user process to find the correct $SMPROGRAMS directory)
    GetFunctionAddress $0 un.clearStartMenu
    UAC::ExecCodeSegment $0


SectionEnd

Function un.clearStartMenu
   # delete Startmenu-Entry
   RmDir /r /REBOOTOK $SMPROGRAMS\${APPNAME}
FunctionEnd

# Installer functions
; Attempt to give the UAC plug-in a user process and an admin process.
Function un.onInit

## UAC init:
## copied from http://nsis.sourceforge.net/UAC_plug-in

UAC_Elevate:
    UAC::RunElevated 
    StrCmp 1223 $0 UAC_ElevationAborted ; UAC dialog aborted by user?
    StrCmp 0 $0 0 UAC_Err ; Error?
    StrCmp 1 $1 0 UAC_Success ;Are we the real deal or just the wrapper?
    Quit
 
UAC_Err:
    MessageBox mb_iconstop "Unable to elevate, error $0"
    Abort
 
UAC_ElevationAborted:
    # elevation was aborted, run as normal?
    MessageBox mb_iconstop "This installer requires administrative rights, aborting!"
    Abort
 
UAC_Success:
    StrCmp 1 $3 +4 ;Admin?
    StrCmp 3 $1 0 UAC_ElevationAborted ;Try again?
    MessageBox mb_iconstop "This installer requires administrative rights, try again"
    goto UAC_Elevate 

FunctionEnd
