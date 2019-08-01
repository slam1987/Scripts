# The purpose of this script was to rename a bunch of video files due to naming compatibility issues with Plex Media Server

# Variables
$directoryPath = "E:\Television Shows\The Golden Girls\"
$folderList = Get-ChildItem $directoryPath -Directory
$counter = 0

# For loop to rename the files using a counter
ForEach($folderItem in $folderList) {
$counter = $counter + 1
Get-ChildItem $directoryPath\$folderItem\ | Rename-Item -NewName {$_.Name.Replace("The Golden Girls 0$counter-","") }
}