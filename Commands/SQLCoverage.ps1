# Load all SQLCover functions
. D:\Jenkins\tools\SQLCover\SQLCover.ps1

# Get arguments
$workspace = $args[0]
$dataSource = $args[1]
$database = $args[2]
$sqlCoverPath = "D:\Jenkins\tools\SQLCover\SQLCover.dll"
$reportGeneratorPath = "D:\Jenkins\tools\ReportGenerator\ReportGenerator.exe"

# Run tSQLt tests
$result = Get-CoverTSql "$sqlCoverPath" "server=$dataSource;integrated security=sspi;initial catalog=$database" "$database" "EXEC tSQLt.RunAll"

# Export OpenCover reports
Export-OpenXml $result "$workspace\SQLCoverage"

# Convert to html reports
Start-ReportGenerator "$workspace\SQLCoverage" "$reportGeneratorPath"
