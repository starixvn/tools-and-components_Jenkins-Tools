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
        $unitTestResultPath = "$workspace\TestResults\$testProjectName-UnitTest.trx"
        $coverageReportDir = "$workspace\CoverageReports"
        $coverageReportPath = "$coverageReportDir\$testProjectName-Coverage.xml"
        $installCoverletMsBuild = "& dotnet add `"$($testProject.Value)`" package coverlet.msbuild"

        Write-Host $installCoverletMsBuild
        Invoke-Expression $installCoverletMsBuild
        Write-Host

        $generateCoverageCmd = "& dotnet test `"$($testProject.Value)`" --no-build --logger `"trx;LogFileName=$unitTestResultPath`" /p:Exclude=[xunit.*]* /p:CollectCoverage=true /p:CoverletOutputFormat=opencover /p:CoverletOutput=`"$coverageReportPath`""
        
        Write-Host $generateCoverageCmd
        Invoke-Expression $generateCoverageCmd
        Write-Host       
    }
}else{
    Write-Warning "The test projects with the ""*Tests.csproj"" pattern were not found."
}