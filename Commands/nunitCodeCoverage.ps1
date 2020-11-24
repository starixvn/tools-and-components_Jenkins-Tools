$workspace = $args[0]
$openCoverPath = "D:\Jenkins\tools\opencover\OpenCover.Console.exe"
$nunitPath = "D:\Jenkins\tools\NUnit\nunit3-console.exe"
$reportGeneratorPath = "D:\Jenkins\tools\ReportGenerator\ReportGenerator.exe"
$openCoverToCoberturaPath = "D:\Jenkins\tools\OpenCoverToCoberturaConverter\OpenCoverToCoberturaConverter.exe"

$register = '-register:Path64'
$target = "-target:""$nunitPath"""
$targetargs = ""
$reportFile = "coverage.xml"
$output = "-output:$reportFile"
$searchdirs = ""
$filter = '-filter:"-[nunit.*]* +[*]*"'

$generateReportCmd = "& ""$reportGeneratorPath"" -reports:$reportFile -targetDir:cireport\testcoveragereport"
$convertToCoberturaCmd = "& ""$openCoverToCoberturaPath"" -input:$reportFile -output:cobertura.xml -sources:""$workspace"""

Write-Host "Searching the test dll files with the *Tests.dll pattern"

# search the test dll
$testDlls = Get-ChildItem -Path "$workspace\*" -Include *Tests.dll -Recurse
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

    $targetargs = "-targetargs:""$targetargs /result:UnitTest.xml;format=nunit2 --inprocess"""
    $searchdirs = "-searchdirs:""$searchdirs"""
    
    $arguments = $register,$target,$targetargs,$output,$searchdirs,$filter
    
    $runUnitTestCmd = "& ""$openCoverPath"" $arguments"
    
    Write-Host "Run unit test..."
    Write-Host $runUnitTestCmd
    Invoke-Expression $runUnitTestCmd

    Write-Host "Generate the html report from OpenCover report"
    Write-Host $generateReportCmd
    Invoke-Expression $generateReportCmd

    Write-Host "Convert OpenCover report to Cobertura report"
    Write-Host $convertToCoberturaCmd
    Invoke-Expression $convertToCoberturaCmd
}else{
    Write-Warning "The test dll files with the ""*Tests.dll"" pattern were not found."
}