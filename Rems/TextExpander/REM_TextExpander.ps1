##################################################################################
#
# Author: William Gordon
# Date: Sunday, April 26, 2026 5:46:17 PM
# Note: $(Get-Date)
#
##################################################################################
# Variables to define existance
$msiID = "{2E46A839-D6AB-45A3-AEEB-9AAE9F097951}"
$msiPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\" + $msiID
#
##################################################################################

# Default parameter used to reference folder of execution
## Manually set this in terminal for testing
$FolderExecution = "$PSScriptRoot"

# Check and Attempt 1
if($(Test-Path $msiPath)) {
    # Attempt Removal via MSI
    Start-Process -FilePath "C:\Windows\System32\MsiExec.exe" -ArgumentList "/qn /X{2E46A839-D6AB-45A3-AEEB-9AAE9F097951}" -Wait -WindowStyle Hidden
}

# Check and Attempt 2
if($(Test-Path $msiPath)) {
    # Download Latest to Attempt Removal
    Invoke-WebRequest -Uri "https://rest-prod.tenet.textexpander.com/download?platform=windows" -OutFile "$FolderExecution\TextExpanderSetup.exe" -ErrorAction SilentlyContinue

    # Attempt Removal with Latest Installer
    Start-Process -FilePath "$FolderExecution\TextExpanderSetup.exe" -ArgumentList "/uninstall /quiet" -Wait -WindowStyle Hidden
}

# Check and Attempt 3
if($(Test-Path $msiPath)) {
    # Attempt Upgrade before Removal
    Start-Process -FilePath "$FolderExecution\TextExpanderSetup.exe" -ArgumentList "/silent" -Wait -WindowStyle Hidden

    # Attempt Removal with Latest Installer
    Start-Process -FilePath "$FolderExecution\TextExpanderSetup.exe" -ArgumentList "/uninstall /quiet" -Wait -WindowStyle Hidden
}
