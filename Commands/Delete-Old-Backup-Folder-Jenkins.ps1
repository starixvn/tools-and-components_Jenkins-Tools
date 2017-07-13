$rootFolder = "\\fileserver\bk_nexcel\1-WINDOWS_SERVER\Web_Servers\Server104\JenkinsBackup"
$backupFolders = dir -Directory $rootFolder | Sort-Object -Descending Name

for($i=0;$i -lt $backupFolders.Count;$i++){
    #Keep 3 latest backup folders
    if($i -gt 2){
        $backupFolder = "$rootFolder\$($backupFolders[$i])"

        Write-Host "Delete $backupFolder"
        Remove-Item $backupFolder -Recurse -Force
    }
} 