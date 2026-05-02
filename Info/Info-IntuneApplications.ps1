
# Component Dependency
<#
Install-Module Microsoft.Graph

Import-Module Microsoft.Graph
#>
cls

# Connect to Graph (required scopes)
$session = Get-MgContext
if($session -eq $null){
    Connect-MgGraph -Scopes "DeviceManagementApps.Read.All","DeviceManagementConfiguration.Read.All","Group.Read.All" -NoWelcome
    $session = Get-MgContext
    $session
}

$Wind32apps = Get-MgDeviceAppManagementMobileApp -All | select *

$Output = @()
$Output2 = @()
$Output3 = @()

$assignments = ""

foreach ($win32app in $Wind32apps) {
# Generate Output Values for each Wind32 App
    $Output += New-Object PSObject -Property @{
        ClientId=$($session.ClientId); 
        TenantId=$($session.TenantId); 
        Id=$($win32app.Id); 
        DisplayName=$($win32app.DisplayName); 
        IsFeatured=$($win32app.IsFeatured); 
        LastModifiedDateTime=$($win32app.LastModifiedDateTime); 
        Owner=$($win32app.Owner); 
        fileName=$($win32app.AdditionalProperties.Values | select -index 2); 
        installCommandLine=$($win32app.AdditionalProperties.Values | select -index 4); 
        uninstallCommandLine=$($win32app.AdditionalProperties.Values | select -index 5); 
        setupFilePath=$($win32app.AdditionalProperties.Values | select -index 7); 
        minimumSupportedWindowsRelease=$($win32app.AdditionalProperties.Values | select -index 8); 
        runAsAccount=$($($win32app.AdditionalProperties.Values | select -index 10).Values | select -index 0); 
        deviceRestartBehavior=$($($win32app.AdditionalProperties.Values | select -index 10).Values | select -index 1); 
        committedContentVersion=$($win32app.AdditionalProperties.Values | select -index 1)
    }

    $assignments = Get-MgDeviceAppManagementMobileAppAssignment -MobileAppId $win32app.Id

    $Output2 = @()

    foreach ($group in $assignments) {
        $Output2 += New-Object PSObject -Property @{
            Intent=$($group.Intent);
            Id=$($group.Id.split("_")[0]);
            DisplayName=$($(Get-MgGroup -GroupId $($group.Id.split("_")[0])).DisplayName);
            AppName=$($win32app.DisplayName);
            AppId=($win32app.Id)
        }
    }

    $Output2 | select Intent, Id, DisplayName, AppName, AppId | Export-Csv "$PSScriptRoot\GroupAssig_$($win32app.DisplayName)_$($win32app.Id)$('.csv')" -NoTypeInformation
    $Output3 = $Output3 + $Output2

}

$Output | select ClientId, TenantId, Id, DisplayName, IsFeatured, minimumSupportedWindowsRelease, deviceRestartBehavior, runAsAccount, LastModifiedDateTime, Owner, setupFilePath, fileName, installCommandLine, uninstallCommandLine | Export-Csv "$PSScriptRoot\IntuneApplications$('.csv')" -NoTypeInformation

$Output | select ClientId, TenantId, Id, DisplayName, IsFeatured, minimumSupportedWindowsRelease, deviceRestartBehavior, runAsAccount, LastModifiedDateTime, Owner, setupFilePath, fileName, installCommandLine, uninstallCommandLine | Out-GridView

$Output3 | select Intent, Id, DisplayName, AppName, AppId | Export-Csv "$PSScriptRoot\AllGroupAssigments$('.csv')" -NoTypeInformation

$Disconnect = Read-Host "Do you want to disconnect? (N)"

if($Disconnect -eq "Y" -or $Disconnect -eq "y"){
    Write-Host "Disconnecting from MgGraph"
    Disconnect-MgGraph
}
