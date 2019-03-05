@ECHO OFF

SET TestFolder=%1

cd %TestFolder%

cmd /c "npm -v & npm install & jest -u --coverage --coverageReporters=lcov --coverageDirectory=""%WORKSPACE%\lcov"""

exit 0