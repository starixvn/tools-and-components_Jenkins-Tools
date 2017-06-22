:: <copyright file="bundle_publish.bat" company="Nexcel Solutions"/>
:: Author Qui@20131118

@if %_echo%!==! echo off
SETLOCAL

:: Env variables
:: SET CI_DEPLOY_URL=https://TFS209:8172/msdeploy.axd
:: SET CI_MSDEPLOY_PATH=C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe
:: SET CI_PUBLISH_MACHINE=10.18.200.209
:: SET CI_PUBLISH_ROOT=Continuous-Integration
:: SET CI_PUBLISH_ROOT_ID=22
:: SET CI_PUBLISH_URL=http://10.18.200.209:8088/

:: Start package
"C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" "%SOLUTION%" /t:Rebuild /p:AllowUntrustedCertificate=true /p:DeployOnBuild=true;DeployTarget=Package;PackageLocation="%WORKSPACE%\_Published\Package.zip" /nologo /v:minimal

:: Find a way to set site name by adjust Package.SetParameters.xml
(
echo ^<?xml version=^"1.0^"?^>
echo ^<parameters^>
echo ^<setParameter name="IIS Web Application Name" value="%CI_PUBLISH_ROOT%/%JOB_NAME%" /^>
echo ^<setParameter name="applicationPool" value="CI_%JOB_NAME%" /^>
echo ^</parameters^>

) > "%WORKSPACE%\_Published\Package.SetParameters.xml"

:: Publish package to target site
"%WORKSPACE%\_Published\Package.deploy.cmd" -enableLink:AppPoolExtension -allowUntrusted /Y /M:%CI_DEPLOY_URL%