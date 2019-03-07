@ECHO OFF

SET TestFolder=%1

cd %TestFolder%

cmd /c "npm -v & npm install & jest --ci -u --coverage --coverageReporters=lcov --coverageDirectory=""%WORKSPACE%\ts-lcov"" --testResultsProcessor=jest-sonar-reporter"

cmd /c "copy /y test-report.xml ""%WORKSPACE%\ts-test-report.xml"""

exit 0