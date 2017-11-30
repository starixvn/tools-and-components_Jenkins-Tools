ECHO OFF

SETLOCAL EnableDelayedExpansion

SET TestFolder=%1

D:\Jenkins\tools\Chutzpah\tools\chutzpah.console.exe !TestFolder! /coverage /junit jsUnitTest.xml /coveragehtml cireport/jscoveragereport/index.htm /lcov tsLcov.dat