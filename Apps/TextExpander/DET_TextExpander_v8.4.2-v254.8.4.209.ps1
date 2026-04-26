$executable_name = "TextExpander.exe"
$executablet_path = "C:\Program Files\Smile\TextExpander\" + $executable_name
$executableVersion = "8.4.2" #aka 254.8.4.209

$executableExists = Test-Path $executablet_path
$executableVersMatch = If($(Get-Item -Path $executablet_path | select *).VersionInfo.FileVersion -ge $executableVersion){$true}else{$false}

# Checks executable is present
if($executableExists) {
  # Check Version of executable
  if($executableVersMatch) {
    # Script Exists
    write-output "TextExpander is on Latest or Newer Version"
    Exit 0
  } else {
      # Outdated version
      Exit 1
    }
} else {
  # Missing program completely
  Exit 1
}
