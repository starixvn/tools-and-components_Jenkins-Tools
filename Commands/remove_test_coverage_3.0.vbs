NunitConsoleLocation = "D:\Jenkins\tools\NUnit.ConsoleRunner.3.2.1\tools\nunit3-console.exe"
OpenCoverLocation = "D:\Jenkins\tools\opencover.4.6.519\OpenCover.Console.exe"
ReportGeneratorLocation="D:\Jenkins\tools\ReportGenerator\ReportGenerator.exe"
OpenCoverToCoberturaConverterLocaltion="D:\Jenkins\tools\OpenCover\OpenCoverToCoberturaConverter.exe"

Function SearchUnitTestAssemblies(fFolder)
	set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFolder = objFSO.GetFolder(fFolder.Path)
	Set colFiles = objFolder.Files
	line = ""
	For Each objFile in colFiles
		fileNameLength = Len(objFile.name)
		position = InStr(objFile.name,".UnitTests.dll")
		If InStr(objFile.Path,"\obj\")<=0 AND position >0 AND position =(fileNameLength - Len(".UnitTests.dll")+1) THEN
			line = line & " """"" & objFile.Path  & """"""
			
		End If
		position = InStr(objFile.name,".Tests.dll")
		If InStr(objFile.Path,"\obj\")<=0 AND position >0 AND position =(fileNameLength - Len(".Tests.dll")+1) THEN
			line = line & " """"" & objFile.Path  & """"""
		End If

	Next

	For Each Subfolder in fFolder.SubFolders
		line = line & SearchUnitTestAssemblies (Subfolder)
	Next
	SearchUnitTestAssemblies = line
End Function

Sub executeCommand(theCommand, rootFolder)

    Dim objShell, objCmdExec
    Set objShell = CreateObject("WScript.Shell")
    objShell.CurrentDirectory = rootFolder
    Set objCmdExec = objshell.exec(thecommand)
    getCommandOutput = objCmdExec.StdOut.ReadAll

end Sub



IF  WScript.Arguments.Count = 0 Then
    Wscript.Quit
End If

rootFolder = Wscript.Arguments.Item(0) 
set objFSO = CreateObject("Scripting.FileSystemObject")
Set objSuperFolder = objFSO.GetFolder(rootFolder)

FileList = SearchUnitTestAssemblies(objSuperFolder)
command = OpenCoverLocation & " -register:user -target:" 
command = command & NunitConsoleLocation & " -targetargs:"""
command = command  & FileList & """ -filter:+[*]* -output:""" & rootFolder & "\coverage.xml"""

reportCommand = ReportGeneratorLocation & " -reports:""" & rootFolder
reportCommand  = reportCommand & "\coverage.xml"" -targetdir:""" 
reportCommand = reportCommand & rootFolder & "\cireport\testcoveragereport"""

coberturaConverterCommand = OpenCoverToCoberturaConverterLocaltion & " ""-input:" & rootFolder & "\coverage.xml"" ""-output:" & rootFolder & "\cobertura.xml"" ""-sources:" & rootFolder & """"

'WScript.Echo coberturaConverterCommand
CALL executeCommand (command, rootFolder)
CALL executeCommand (reportCommand, rootFolder)
CALL executeCommand (coberturaConverterCommand, rootFolder)

