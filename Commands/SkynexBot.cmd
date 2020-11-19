ECHO OFF
SET ConversationId=%1
SET Message=%2

for /f "useback tokens=*" %%a in ('%ConversationId%') do set ConversationId=%%~a

for /f "useback tokens=*" %%a in ('%Message%') do set Message=%%~a

powershell.exe -NonInteractive -ExecutionPolicy ByPass "& '%JENKINS_HOME%\tools\Commands\SkynexBot.ps1' '%ConversationId%' '%Message%'"