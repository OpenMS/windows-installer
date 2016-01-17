NSIS based Windows Installer for OpenMS
=============

This repository contains all files necessary to create a windows installer from a source build of OpenMS (**System A**).

Additional required software:
-------------

- NSIS (NullSoft Installer System)
  - has been tested up to 3.0b2 from http://nsis.sourceforge.net. It seems to stop working in 3.0b3.
  - to work with NSIS 2.x, you need to remove a subfolder on line 91 in the OpenMS_installer.nsi
  - you might need to copy the content of the 8k string support from http://nsis.sourceforge.net/Special_Builds (Download large strings build)
    build into your NSIS install directory (this should overwrite makensis.exe and Stubs)


TODO before running OpenMS_installer.nsi 
-------------

 1. Copy ```UAC.dll``` to your ```<PATH-to-NSIS>/Plugins``` directory before running the installer script! Otherwise you'll get an error during script compilation: "Invalid command: UAC::RunElevated"
 1. Extract the content of ```Inettc.zip``` to your ```<PATH-to-NSIS>``` directory before running the installer script! Otherwise you'll get an error during script compilation: ```"Invalid command: inetc::get"```

Quick guide
-------------

 1. Fully compile and test OpenMS using a Visual Studio Generator (create the targets [```OpenMS``` ```TOPP``` ```UTILS``` ```GUI```] - NOT MORE!!)
 1. create the documentation (targets "doc" and "doc_tutorial" (NOT doc_internal) in ```OpenMS_build/doc```) **OR** copy the doc folder from Linux if setting up documentation on Windows is too hard or not possible.
 1. Read additional install information in the header of OpenMS_installer.nsi (!)
 1. Adapt relevant settings in the header of OpenMS_installer.nsi to your needs **OR** see ```./auto_package/*.nsi ``` for example files, which you can just copy and modify.
 1. Compile ```OpenMS_installer.nsi``` using NSIS (this should create a file named something like ```OpenMS_setup.exe```)
 1. Distribute


Verifying the installer
-------------

 - Use a Virtual Machine (**System B**)
 - Do **NOT** assume that successfully installing ```OpenMS_setup.exe``` on the **System A** means that the installer will work on a new **System B**! But you can at least check for major quirks.
 - Check if all files were created and Start Menu entries are present and working.
 - To test the TOPP tools, run ```TOPPTest_Assembler.pl``` on **System A**. e.g.,
	- Adapt paths within TOPPTest_Assembler.pl
	- Open a VS command line
	- ```> cd c:\<path to win_installer_dir>```
	- ```> TOPPTest_Assembler.pl```
    - Now, copy the folder /OpenMS/source/TEST/TOPP/ to System B and run TOPP_test.bat (which should have been created by the perl script).
    - Check if the script runs through without pausing (which means that something needs your attention). If you're picky, then check the whole output of the script. Sometimes a TOPP-tool might give a warning and still produce the correct result, thus the script will not remind you of that.


