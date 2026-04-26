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
# Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString, DisplayName_Localized, PSChildName | where {$_.DisplayName -like "TextExpander*"}
#
##################################################################################

$msiID = "{2E46A839-D6AB-45A3-AEEB-9AAE9F097951}"
$msiPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\" + $msiID
$msiExists = Test-Path $msiPath

if($msiExists) {
    # Installation successful
    write-output "TextExpander found"
    Exit 0
} else {
    # MSI NOT found
    Exit 1
}
