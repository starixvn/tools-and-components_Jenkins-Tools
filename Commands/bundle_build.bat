@echo off

cmd /c "D:\Jenkins\tools\Commands\nuget-restore.bat"

ECHO "================== BUILD PROJECT =============="
FOR /r %%f in (*.sln) DO (	
	cd "%%~dpf"
	
	"C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\MSBuild.exe" %%f /t:Rebuild /nologo /v:minimal /l:XmlFileLogger,"%JENKINS_HOME%\tools\MSBuild.ExtensionPack.Loggers.dll";logfile=MsBuild.xml;encoding=UTF-8
	
	goto :done
)

:done

:: Step success
exit 0