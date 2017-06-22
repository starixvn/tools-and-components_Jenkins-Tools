ECHO OFF

SETLOCAL EnableDelayedExpansion

ECHO "Restore packages"
FOR /r "%WORKSPACE%" %%f in (*.sln) DO (
	SET solutionFolder="%%~dpf"
	
	"C:\Program Files\dotnet\dotnet" restore %solutionFolder%
)

ECHO "Build projects"
FOR /r %%a IN (.) DO (
	SET _path=%%~fa
	
	IF EXIST "!_path!\*.xproj" (		
		"C:\Program Files\dotnet\dotnet" build "!_path!"		
	)
)