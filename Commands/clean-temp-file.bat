ECHO OFF

ECHO "Try deleing testcoveragereport. Please ignore error here. "
FORFILES /p "%WORKSPACE%\cireport\testcoveragereport" /m *.* /s /c "cmd /c DEL @path"

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

EXIT 0