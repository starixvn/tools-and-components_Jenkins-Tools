ECHO OFF

IF "%enableStylecop%"=="1" (
	:: Check StyleCop using StyleCopCmd
	FOR /r %%f in (*.csproj) DO (
	   :ECHO %%~dpnf
	   :ECHO %%~dpf
	   "D:\Jenkins\tools\StyleCopCmd_0.2.1.0\Net.SF.StyleCopCmd.Console\Net.SF.StyleCopCmd.Console.exe" -pf "%%~dpnf.csproj" -r -of "%%~dpnf.StyleCop.xml"
	)
)

IF "%enableFxCop%"=="1" (
	echo "Run fxcop"
	
	FOR /r %%f in (*.sln) DO (
		"C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\MSBuild.exe" "%%f" /t:Rebuild /p:RunCodeAnalysis=true
	)
)

IF "%enableJsHint%"=="1" (
	echo "Run JsLint"
	"D:\Jenkins\tools\nodejs\node" "D:\Jenkins\tools\nodejs\node_modules\npm\node_modules\jshint\bin\jshint" "%WORKSPACE%" --config "%JENKINS_HOME%\userContent\jshint.config" --exclude "/**/jquery*.*,/**/bootstrap*.*,/**/angular*.*,/**/moderniz*.*,/**/html5shiv*.*,/**/highchart/**,/**/knockout*.*,/**/Debug/**,/**/underscore*.*,/**/*min.js,/**/monpickr*.*,/**/head.js,**/packages/**,/**/json2.js,/**/jx.js" > "%WORKSPACE%\cireport\jshintreport\JSHINT.REPORT.htm"
)

:: Step success
exit 0