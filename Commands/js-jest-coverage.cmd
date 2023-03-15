@ECHO OFF

SET TestFolder=%1
SET NPMOption=%2

cd %TestFolder%

IF NOT "%NPMOption%"=="" (
    echo "Use %NPMOption%"
    cmd /c "npm -v & npm install %NPMOption% & jest --ci -u --coverage --coverageReporters=lcov --coverageDirectory=""%WORKSPACE%\js-lcov"" --testResultsProcessor=jest-sonar-reporter"
) ELSE (
    cmd /c "npm -v & npm install & jest --ci -u --coverage --coverageReporters=lcov --coverageDirectory=""%WORKSPACE%\js-lcov"" --testResultsProcessor=jest-sonar-reporter"
)

cmd /c "copy /y test-report.xml ""%WORKSPACE%\js-test-report.xml"""

exit 0