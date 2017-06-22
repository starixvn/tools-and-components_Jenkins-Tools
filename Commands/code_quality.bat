ECHO OFF

IF "%enableStylecop%"=="1" (
	:: Check StyleCop using StyleCopCmd
	FOR /r %%f in (*.csproj) DO (
	   :ECHO %%~dpnf
	   :ECHO %%~dpf
	   "D:\Jenkins\tools\StyleCopCmd_0.2.1.0\Net.SF.StyleCopCmd.Console\Net.SF.StyleCopCmd.Console.exe" -pf "%%~dpnf.csproj" -r -of "%%~dpnf.StyleCop.xml"
	)
)

IF "%enableDRY%"=="1" ((
	:: Check duplicate code using Atomiq.Console
	echo ^<?xml version=^"1.0^"?^>
	echo ^<Options xmlns:xsi=^"http://www.w3.org/2001/XMLSchema-instance^" xmlns:xsd=^"http://www.w3.org/2001/XMLSchema^"^>
	echo ^<ExcludeFileRegexes^>
	echo \.BASE\.*
	echo \.LOCAL\.*
	echo \.BACKUP\.*
	echo \.REMOTE\.*
	echo AssemblyInfo\.^(vb^|cs^)$
	echo \.g\.^(vb^|cs^)$
	echo \.g\.i\.^(vb^|cs^)$
	echo ^</ExcludeFileRegexes^>
	echo ^<FileSearchPattern^>*.cs^</FileSearchPattern^> 
	echo ^<Directory^>%WORKSPACE:)=^)%^</Directory^>
	echo ^<MinSimilarityLineLength^>10^</MinSimilarityLineLength^>
	echo ^</Options^>
)> "%WORKSPACE%\dry.atomiqProj"
	echo "Run Atomiq"
	"D:\Jenkins\tools\Atomiq_1.1.3.94\Atomiq.Console_1.1.3.94.exe" -output "%WORKSPACE%\cireport\dryreport\DRY.REPORT.htm" -project "%WORKSPACE%\dry.atomiqProj" -blockNumMax 15 -blockSizeMax 40 -totalDupeLinesMax 200
	"D:\Jenkins\tools\CI-DryReport\ci-dry-report.exe" --root="%JENKINS_HOME%\workspace" --name="%JOB_NAME%"
)

IF "%enableFxCop%"=="1" (
	echo "Run fxcop"
	
	FOR /r %%f in (*.sln) DO (
		"C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe" "%%f" /t:Rebuild /p:RunCodeAnalysis=true
	)
)

IF "%enableJsHint%"=="1" (
	echo "Run JsLint"
	"D:\Jenkins\tools\nodejs\node" "D:\Jenkins\tools\nodejs\node_modules\npm\node_modules\jshint\bin\jshint" "%WORKSPACE%" --config "%JENKINS_HOME%\userContent\jshint.config" --exclude "/**/jquery*.*,/**/bootstrap*.*,/**/angular*.*,/**/moderniz*.*,/**/html5shiv*.*,/**/highchart/**,/**/knockout*.*,/**/Debug/**,/**/underscore*.*,/**/*min.js,/**/monpickr*.*,/**/head.js,**/packages/**,/**/json2.js,/**/jx.js" > "%WORKSPACE%\cireport\jshintreport\JSHINT.REPORT.htm"
)
ECHO %JSHINT_ERROR%
IF "%enableJsUnitTest%"=="1" (
	echo "JsUnitTest"
	"D:\Jenkins\tools\Chutzpah\chutzpah.console.exe" "%WORKSPACE%" /junit "%WORKSPACE%\UnitTestOutput\JsUnitTestResult.xml" /testMode "JavaScript" /coverrage /coverageExcludes "*\\jquery*.js,*\\angular*.js" /failOnError /silent /failOnError
)

:: Step success
exit 0