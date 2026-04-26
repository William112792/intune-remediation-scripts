##################################################################################
#
# Author: William Gordon
# Date: Sunday, April 26, 2026 3:55:04 PM
# Note: $(Get-Date)
#
##################################################################################
#
# Designed a Phased System of Automation for re-use of script
# - Phase 1 to focus on download functionality
#   - Forced cleanup option to ensure no errors occur in rename or download
#   - Bit Transfer alternative typically used for larger files
# - Phase 2 to execute a silent install
#   - Option to skip download before installation
# - Phase 3 to execture an uninstall
#   - Does NOT download before in any fashion (limitation in TextExpander on removal)
#   - Alternatively can build separate uninstall script to search for local installation for native local removal
# NOTE: Tested with version 8.4.209 (aka 254.8.4.209)
#
##################################################################################
#
# Example 1: powershell .\APP_TextExpander.ps1 -Function "download" -Force 1
# Example 2: powershell .\APP_TextExpander.ps1 -Function "1" -Force 1
# Example 3: powershell .\APP_TextExpander.ps1 -Function "1" -Force 1 -SkipDownload 0
# Example 4: powershell .\APP_TextExpander.ps1 -Function "2" -Force 1
#
##################################################################################

# Parameters to pass into this file to limit revisions
param(
    [string]$URL = "https://rest-prod.tenet.textexpander.com/download?platform=windows",
    [string]$Function = "Install",
    [bool]$BitTransfer = 0,
    [bool]$Force = 0,
    [bool]$SkipDownload = 1
)

# Default parameter used to reference folder of execution
## Manually set this in terminal for testing
$FolderExecution = "$PSScriptRoot"

# Ensure action parameter is in lowercase to prevent mismatching
$Function = $Function.ToLower()

# Phase 1a - Download method (Can remove if installer is packaged internally)
if(($Function -eq "download" -or $Function -eq "0" -or $Function -eq "install" -or $Function -eq "1") -and $($SkipDownload -eq $false)){
    
    # Forced Cleanup
    ## Double filter for executable and prefix of TextExpander
    $PackageContents = Get-ChildItem "$FolderExecution" | where {$_.Extension -eq ".exe"} | where {$_.BaseName -like "TextExpander*"}
    ForEach ($installer in $PackageContents) {
        # Remove older files if forced
        Remove-Item -Path $($installer.FullName) -Force
    }
    
    # Phase 1b - Pull installer file from source without version info
    if($BitTransfer -eq $false){
        # Execute non-bit download as default option (large files may fail)
        Invoke-WebRequest -Uri $URL -OutFile "$FolderExecution\TextExpanderSetup-x.x.x.exe" -ErrorAction SilentlyContinue
    } else {
        # Execute a bit transfer for large file subsets (limitations may cause issues)
        Start-BitsTransfer -Source $URL -Destination "$FolderExecution\TextExpanderSetup-x.x.x.exe" -ErrorAction SilentlyContinue
    }



    # Phase 1c - Fix versioning in file name
    ## Only looks for executables
    $PackageContents = Get-ChildItem "$FolderExecution" | where {$_.Extension -eq ".exe"}
    ForEach ($installer in $PackageContents) {
        # Only execute on prefix for TextExpander
        if($($installer.BaseName) -like "TextExpander*") {
            # Rename file to version while extracting non-discolsed prefix in versioning
            Rename-Item -Path $($($installer | select *).DirectoryName + "\" + $($installer | select *).Name) -NewName $("TextExpanderSetup-" + $($($installer | select *).VersionInfo.ProductVersion.Split(".")[1..($($installer | select *).VersionInfo.ProductVersion.Split(".").Count - 1)] -join ".") + ".exe")
        }
    }
}

#Phase 2a - Simple Installation method
if($Function -eq "install" -or $Function -eq "1"){
    # Double filter for executable and prefix of TextExpander
    $PackageContents = Get-ChildItem "$FolderExecution" | where {$_.Extension -eq ".exe"} | where {$_.BaseName -like "TextExpander*"}
    # Install the first match from the given array
    Start-Process -FilePath $($PackageContents[0].FullName) -ArgumentList "/silent" -Wait -WindowStyle Hidden

}

#Phase 3a - Simple Uninstallation method
if($Function -eq "uninstall" -or $Function -eq "2"){
    # Double filter for executable and preffix of TextExpander
    $PackageContents = Get-ChildItem "$FolderExecution" | where {$_.Extension -eq ".exe"} | where {$_.BaseName -like "TextExpander*"}
    # Install the first match from the given array
    Start-Process -FilePath $($PackageContents[0].FullName) -ArgumentList "/uninstall /quiet" -Wait -WindowStyle Hidden

}

