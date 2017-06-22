NunitConsoleLocation ="D:\Jenkins\tools\NUnit.ConsoleRunner.3.2.1\tools\nunit3-console.exe"


Function SearchUnitTestAssemblies(fFolder)
	set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFolder = objFSO.GetFolder(fFolder.Path)
	Set colFiles = objFolder.Files
	line = ""
	For Each objFile in colFiles
		fileNameLength = Len(objFile.name)
		position = InStr(objFile.name,".UnitTests.dll")
		If InStr(objFile.Path,"\obj\")<=0 AND position >0 AND position =(fileNameLength - Len(".UnitTests.dll")+1) THEN
			line = line & """" & objFile.Path  & """ "
			
		End If
		position = InStr(objFile.name,".Tests.dll")
		If InStr(objFile.Path,"\obj\")<=0 AND position >0 AND position =(fileNameLength - Len(".Tests.dll")+1) THEN
			line = line & """" & objFile.Path  & """ "
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

parameters = SearchUnitTestAssemblies(objSuperFolder)

command = """" & NunitConsoleLocation & """"
command = command & " " & parameters
command = command & " /result:""" & rootFolder & "\UnitTest.xml;format=nunit2"""

WScript.Echo command
'Call executeCommand(command,rootFolder)
