ECHO OFF
SETLOCAL EnableDelayedExpansion

ECHO "Restore packages"
FOR /r "%WORKSPACE%" %%f in (*.sln) DO (
	SET solutionFolder="%%~dpf"
	
	"C:\Program Files\dotnet\dotnet" restore %solutionFolder%
)

FOR /r %%a IN (.) DO (
	SET _path=%%~fa
	
	IF EXIST "!_path!\*.xproj" (		
		IF  !_path:~-6!==.Tests (
			"C:\Program Files\dotnet\dotnet" test "!_path!"
		) ELSE (
			"C:\Program Files\dotnet\dotnet" build "!_path!"
		)
	)
)