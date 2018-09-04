$workspace = $args[0]
$openCoverPath = "D:\Jenkins\tools\opencover\OpenCover.Console.exe"
$xUnitPath = "D:\Jenkins\tools\xunit.runner.console\tools\xunit.console.exe"

if($args.Count -eq 2){
    if( $args[1] -eq "x86"){
        $xUnitPath = "D:\Jenkins\tools\xunit.runner.console\tools\xunit.console.x86.exe"
    }
}

$register = '-register:user'
$target = "-target:""$xUnitPath"""
$targetargs = ""
$reportFile = "coverage.integrationtest.xml"
$output = "-output:$reportFile"
$searchdirs = ""
$filter = '-filter:"-[xunit.*]* +[*]*"'

Write-Host "Searching the test dll files with the *IntegrationTests.dll pattern"

# search the test dll
$testDlls = Get-ChildItem -Path "$workspace\*" -Include *IntegrationTests.dll -Recurse
$testList= New-Object 'System.Collections.Generic.Dictionary[string,string]'

foreach($dllFile in $testDlls){
    if($testList.ContainsKey($dllFile.Name) -eq $false){
        $testList.Add($dllFile.Name,$dllFile.FullName)
    }
}

if($testList.Count -ne 0){
    foreach($item in $testList.GetEnumerator()){
        Write-Host $item.Value

        $debugFolder = Split-Path $item.Value -parent

        if($searchdirs -eq ""){
            $searchdirs = """""$debugFolder"""""
        }else{
            $searchdirs = "$searchdirs;""""$debugFolder"""""
        }
       
        if($targetargs -eq ""){
            $targetargs = """""""""$($item.Value)"""""""""
        }else{
            $targetargs = "$targetargs """"""""$($item.Value)"""""""""
        }
    }

    $targetargs = "-targetargs:""$targetargs"""
    $searchdirs = "-searchdirs:""$searchdirs"""
    
    $arguments = $register,$target,$targetargs,$output,$searchdirs,$filter
    
    $runUnitTestCmd = "& ""$openCoverPath"" $arguments"
    
    Write-Host "Run integration test..."
    Write-Host $runUnitTestCmd
    Invoke-Expression $runUnitTestCmd
}else{
    Write-Warning "The test dll files with the ""*IntegrationTests.dll"" pattern were not found."
}