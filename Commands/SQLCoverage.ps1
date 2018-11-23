# Load all SQLCover functions
. D:\Jenkins\tools\SQLCover\SQLCover.ps1

# Get arguments
$workspace = $args[0]
$dataSource = $args[1]
$database = $args[2]
$sqlCoverPath = "D:\Jenkins\tools\SQLCover\SQLCover.dll"
$reportGeneratorPath = "D:\Jenkins\tools\ReportGenerator\ReportGenerator.exe"
$sqlCoverageReport = "$workspace\SQLCoverage"
$getTestResultPath = "D:\jenkins\tools\tSQLt\tSQLt_TestResults.sql"
$testResultReportPath = "$workspace\SQLTestResults.xml"

# Create folder if not exist
if( -Not (Test-Path -Path $sqlCoverageReport ) )
{
    New-Item -ItemType directory -Path $sqlCoverageReport
}


# Run tSQLt tests
$result = Get-CoverTSql "$sqlCoverPath" "server=$dataSource;integrated security=sspi;initial catalog=$database" "$database" "EXEC tSQLt.RunAll"

# Export OpenCover reports
Export-OpenXml $result "$sqlCoverageReport"

# Convert to html reports
Start-ReportGenerator "$sqlCoverageReport" "$reportGeneratorPath"

# Generate Test Results
sqlcmd -E -S $dataSource -d $database -y0 -I -i "$getTestResultPath" -o "$testResultReportPath"

exit $LastExitCode