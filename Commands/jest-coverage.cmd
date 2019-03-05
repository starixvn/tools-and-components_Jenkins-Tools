SET TestFolder=%1

cd %TestFolder%
npm -v & npm install & jest --coverage --coverageReporters=lcov --coverageDirectory="%WORKSPACE%\lcov"