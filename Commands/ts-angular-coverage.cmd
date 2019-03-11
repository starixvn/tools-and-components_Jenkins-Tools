@ECHO OFF

SET TestFolder=%1

cd %TestFolder%

cmd /c "npm -v & npm install & ng test --codeCoverage=true --watch=false"

exit 0