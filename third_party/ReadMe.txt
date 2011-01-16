Everything in "to_install" will be included into the installer and copied to '$INSTDIR\share\OpenMS\THIRDPARTY\'

You have to manually extend the PATH within the installer script, if you want the stuff in 'to_install/xy/'
to be found by the system running the installer.

Also update "to_install\Versions.txt" when you add/modify a ThirdParty library.
