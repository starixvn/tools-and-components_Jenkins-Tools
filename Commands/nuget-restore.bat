@echo off

cmd /c "D:\Jenkins\tools\Commands\prepare-output.bat"

ECHO "================== NUGET RESTORE =============="
FOR /r %%f in (*.sln) DO (
	"%JENKINS_HOME%\tools\nuget\nuget.exe" restore "%%~f"
)

:: Step success
exit 0