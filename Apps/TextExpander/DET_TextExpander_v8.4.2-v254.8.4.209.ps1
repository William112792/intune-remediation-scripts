$executable_name = "TextExpander.exe"
$executablet_path = "C:\Program Files\Smile\TextExpander\" + $executable_name
$executableVersion = "8.4.2" #aka 254.8.4.209

$executableExists = Test-Path $executablet_path
$executableVersMatch = If($(Get-Item -Path $executablet_path | select *).VersionInfo.FileVersion -ge $executableVersion){$true}else{$false}

# Checks for Scheduled Task and Script File
if($executableExists) {
  # Scheduled Task Exists
  if($executableVersMatch) {
    # Script Exists
    write-output "TextExpander is on Latest or Newer Version"
    Exit 0
  } else {
      # Missing Script
      Exit 1
    }
} else {
  # Missing Scheduled Task
  Exit 1
}