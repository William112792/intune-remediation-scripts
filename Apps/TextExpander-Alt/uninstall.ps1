##################################################################################
#
# Author: William Gordon
# Date: Sunday, April 26, 2026 5:46:17 PM
# Note: $(Get-Date)
#
##################################################################################
#
# Reference Registry:
# HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\
#
# Check for UninstallString:
# Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString, DisplayName_Localized | where {$_.DisplayName -like "TextExpander*"}
#
##################################################################################

## MSI ID of 2E46A839-D6AB-45A3-AEEB-9AAE9F097951 for version 8.4.209 (aka 254.8.4.209)
Start-Process -FilePath "C:\Windows\System32\MsiExec.exe" -ArgumentList "/qn /X{2E46A839-D6AB-45A3-AEEB-9AAE9F097951}" -Wait -WindowStyle Hidden



