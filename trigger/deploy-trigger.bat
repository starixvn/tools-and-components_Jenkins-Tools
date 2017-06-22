@echo off

FOR /f "tokens=2-4 delims=/ " %%a IN ('date /t') DO (
	SET date=%%c-%%a-%%b
)

FOR /f "tokens=1-3 delims=/:" %%a IN ('time /t') DO (
	SET time=%%a:%%b%%c
)
ECHO Current time is: %date% - %time% 


FOR /f "tokens=1-3 delims=/: " %%a IN ('time /t') DO (
	SET /a hour=1%%a-100
	SET /a minute=1%%b-100
	SET meridiem=%%c
)

IF EXIST "%WORKSPACE%\deploy.trigger" del "%WORKSPACE%\deploy.trigger"
SET LastCommitLocation=%1
SET Force=%2


IF NOT "%Force%"=="" (
	ECHO "The user is forcing to deploy "
	ECHO "The user is forcing to deploy ">"%WORKSPACE%\deploy.trigger"
	EXIT 0
)


IF "%LastCommitLocation%"=="" (
	ECHO Please specify the location of last-commit.git file
)


IF NOT "%LastCommitLocation%"=="" (
	IF EXIST "%LastCommitLocation%" (
		SET /p LAST_DEPLOY_COMMIT=<"%LastCommitLocation%"
	)
)

IF NOT LAST_DEPLOY_COMMIT==GIT_COMMIT (
	IF %hour%  LSS 6 (
		IF %meridiem%==AM (
			ECHO "It's good time to trigger the deployment automatically"
			ECHO "It's good time to trigger the deployment automatically">"%WORKSPACE%\deploy.trigger"
		)
	)
)