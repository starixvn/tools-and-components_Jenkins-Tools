$workspace = $args[0]

Write-Host "Searching the test projects with the *Tests.csproj pattern"

# search the test project
$testProjects = Get-ChildItem -Path "$workspace\*" -Include *Tests.csproj -Recurse
$testProjectList= New-Object 'System.Collections.Generic.Dictionary[string,string]'

foreach($testProject in $testProjects){
    if($testProjectList.ContainsKey($testProject.Name) -eq $false){
        $testProjectList.Add($testProject.Name,$testProject.FullName)
    }
}

if($testProjectList.Count -ne 0){
    foreach($testProject in $testProjectList.GetEnumerator()){
        Write-Host $testProject.Value

        $testProjectName = [System.IO.Path]::GetFileNameWithoutExtension($testProject.Value)
        $testDllName = "$testProjectName.dll"
        $testProjectFolder = [System.IO.Path]::GetDirectoryName($testProject.Value)
        $testDllPath = Get-ChildItem -Path "$testProjectFolder\*" -Include $testDllName -Recurse | Select -ExpandProperty FullName -First 1
        $unitTestResultPath = "$workspace\TestResults\$testProjectName-UnitTest.trx"
        $coverageReportDir = "$workspace\CoverageReports"
        $coverageReportPath = "$coverageReportDir\$testProjectName-Coverage.xml"

        $generateCoverageCmd = "& coverlet ""$testDllPath"" --target dotnet --targetargs ""test """"""""$($testProject.Value)"""""""" --no-build --logger """"""""trx;LogFileName=$unitTestResultPath"""""""""" --format cobertura --output ""$coverageReportPath"" --exclude=[xunit.*]*"
        
        Write-Host $generateCoverageCmd
        Invoke-Expression $generateCoverageCmd
        Write-Host
       
        $convertToSonarQubeReport = "& reportgenerator `"-reports:$coverageReportDir\*.xml`" `"-targetdir:$coverageReportDir\SonarQube`" -reporttypes:SonarQube"
        Write-Host $convertToSonarQubeReport
        Invoke-Expression $convertToSonarQubeReport
        Write-Host
    }
}else{
    Write-Warning "The test projects with the ""*Tests.csproj"" pattern were not found."
}