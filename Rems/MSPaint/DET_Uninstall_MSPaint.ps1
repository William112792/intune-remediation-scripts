##################################################################################
#
# Author: William Gordon
# Date: Sunday, April 26, 2026 6:30:51 PM
# Note: $(Get-Date)
#
##################################################################################

$appcheck = Get-AppxPackage -AllUsers -PackageTypeFilter Bundle -Name Microsoft.Paint

if ($appcheck -eq $null) {
    # App Package Removed Successffully
    write-output "Not detected"
    exit 0
}
else {
    # App Package Still Exists
    write-output "Detected"
    exit 1
}

