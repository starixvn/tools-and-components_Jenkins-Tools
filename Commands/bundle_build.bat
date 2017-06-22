@echo off

cmd /c "D:\Jenkins\tools\Commands\nuget-restore.bat"

ECHO "================== BUILD PROJECT =============="
"C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe" /t:Compile /nologo /v:minimal /l:XmlFileLogger,"%JENKINS_HOME%\tools\MSBuild.ExtensionPack.Loggers.dll";logfile=MsBuild.xml;encoding=UTF-8 "%JENKINS_HOME%\tools\bundle_build.proj"

:: Step success
exit 0