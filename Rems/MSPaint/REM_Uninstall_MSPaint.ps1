##################################################################################
#
# Author: William Gordon
# Date: Sunday, April 26, 2026 6:30:51 PM
# Note: $(Get-Date)
#
##################################################################################

# Remove App Package for MSPaint
Get-AppxPackage -AllUsers -PackageTypeFilter Bundle -Name Microsoft.Paint | Remove-AppxPackage -AllUsers
