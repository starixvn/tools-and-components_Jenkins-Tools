@echo off

ECHO OFF

SETLOCAL EnableDelayedExpansion

ECHO "TRY deleting (*.StyleCop.violations.xml) "
FOR /r %%f in (*.StyleCop.violations.xml) DO (
	IF exist "%%~f" DEL "%%~f"
)

ECHO "TRY deleting (*.StyleCop.xml) "
FOR /r %%f in (*.StyleCop.xml) DO (
	IF exist "%%~f" DEL "%%~f"
)

ECHO "TRY deleting (*.FxCop.xml) "
FOR /r %%f in (*.FxCop.xml) DO (
	IF exist "%%~f" DEL "%%~f"
)

ECHO "TRY deleting (*.dll.CodeAnalysisLog.xml) "
FOR /r %%f in (*.dll.CodeAnalysisLog.xml) DO (
	IF exist "%%~f" DEL "%%~f"
)

ECHO "TRY delete old unit test result"
FOR /r %%f in (UnitTestResult_*.xml) DO (
	IF exist "%%~f" DEL "%%~f"
)

FOR /r %%f in (UnitTestCoverage_*.xml) DO (
	IF exist "%%~f" DEL "%%~f"
)

ECHO "TRY deleting (cobertura.xml) "
set coberturaReport=%WORKSPACE%\cobertura.xml
IF exist "!coberturaReport!" DEL "!coberturaReport!"

ECHO "TRY deleting (coverage.xml) "
set coverageReport=%WORKSPACE%\coverage.xml
IF exist "!coverageReport!" DEL "!coverageReport!"

ECHO "TRY deleting (UnitTest.xml) "
set unitTestReport=%WORKSPACE%\UnitTest.xml
IF exist "!unitTestReport!" DEL "!unitTestReport!"

IF exist "%WORKSPACE%\cireport" @RD /S /Q "%WORKSPACE%\cireport"

mkdir "%WORKSPACE%\cireport"
mkdir "%WORKSPACE%\cireport\dryreport"
mkdir "%WORKSPACE%\cireport\jshintreport"
mkdir "%WORKSPACE%\cireport\msbuildreport"
mkdir "%WORKSPACE%\cireport\testcoveragereport"
mkdir "%WORKSPACE%\cireport\jscoveragereport"

echo "Hello World!"> "%WORKSPACE%\cireport\msbuildreport\index.htm"
echo "Hello World!"> "%WORKSPACE%\cireport\dryreport\index.htm"
echo "Hello World!"> "%WORKSPACE%\cireport\jshintreport\index.htm"

:: Step success
exit 0