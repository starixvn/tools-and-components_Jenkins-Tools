$rootFolder = "\\fileserver\bk_nexcel\SRV117\Jenkins"
$backupFolders = dir -Directory $rootFolder | Sort-Object -Descending Name

for($i=0;$i -lt $backupFolders.Count;$i++){
    #Keep 3 latest backup folders
    if($i -gt 2){
        $backupFolder = "$rootFolder\$($backupFolders[$i])"

        Write-Host "Delete $backupFolder"
        Remove-Item $backupFolder -Recurse -Force
    }
} 