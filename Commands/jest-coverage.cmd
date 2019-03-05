@ECHO OFF
SET TestFolder=%1

cd %TestFolder%
npm -v & npm install & jest -u --coverage --coverageReporters=lcov --coverageDirectory="%WORKSPACE%\lcov"

SET ERRORLEVEL=0