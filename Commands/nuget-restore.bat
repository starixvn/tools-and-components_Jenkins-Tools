@echo off

cmd /c "D:\Jenkins\tools\Commands\prepare-output.bat"

ECHO "================== NUGET RESTORE =============="
FOR /r %%f in (*.sln) DO (
	"%JENKINS_HOME%\tools\nuget\nuget.exe" restore "%%~f" -source "https://www.nuget.org/api/v2;http://nuget.nexdev.net/api/v2/;http://nuget.owdev.net/api/v2/"
)

:: Step success
exit 0