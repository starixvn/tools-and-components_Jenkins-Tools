NunitConsoleLocation ="D:\Jenkins\tools\NUnit 2.6.3\bin\nunit-console.exe"


Sub SearchUnitTestAssemblies(fFolder,writeFile)
    set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFolder = objFSO.GetFolder(fFolder.Path)
    Set colFiles = objFolder.Files
    For Each objFile in colFiles
        fileNameLength = Len(objFile.name)
        position = InStr(objFile.name,".UnitTests.dll")
	    If InStr(objFile.Path,"\obj\")<=0 AND position >0 AND position =(fileNameLength - Len(".UnitTests.dll")+1) THEN
            line = "<assembly path="""+objFile.Path +"""/>"
		    writeFile.WriteLine(line)
	    End If
        position = InStr(objFile.name,".Tests.dll")
        If InStr(objFile.Path,"\obj\")<=0 AND position >0 AND position =(fileNameLength - Len(".Tests.dll")+1) THEN
            line = "<assembly path="""+objFile.Path +"""/>"
		    writeFile.WriteLine(line)
	    End If

    Next

    For Each Subfolder in fFolder.SubFolders
        CALL SearchUnitTestAssemblies (Subfolder , writeFile)
    Next
End Sub

Sub executeCommand(theCommand, rootFolder)

    Dim objShell, objCmdExec
    Set objShell = CreateObject("WScript.Shell")
    objShell.CurrentDirectory = rootFolder
    Set objCmdExec = objshell.exec(thecommand)
    getCommandOutput = objCmdExec.StdOut.ReadAll

end Sub

Sub generateNUnitProject(rootFolder, nunitFile)

    set objFSO = CreateObject("Scripting.FileSystemObject")
    set writeFile =objFSO.CreateTextFile(nunitFile,True)
    Set objSuperFolder = objFSO.GetFolder(rootFolder)

    writeFile.WriteLine("<NUnitProject>")
    writeFile.WriteLine("<Settings activeconfig='Debug' domainUsage='Multiple' />")
    writeFile.WriteLine("<Config name='Debug' binpathtype='Auto'>")

    CALL SearchUnitTestAssemblies(objSuperFolder, writeFile)

    writeFile.WriteLine("</Config>")
    writeFile.WriteLine("<Config name='Release' binpathtype='Auto' />")
    writeFile.WriteLine("</NUnitProject>")

    writeFile.Close

End Sub


IF  WScript.Arguments.Count = 0 Then
    Wscript.Quit
End If


rootFolder = Wscript.Arguments.Item(0) 

nunitFile = rootFolder & "\" & "project.nunit"
command = """" & NunitConsoleLocation & """"
command = command & " """ & nunitFile & """"
command = command & " /xml:""" & rootFolder & "\UnitTest.xml"""

Call generateNUnitProject(rootFolder, nunitFile)

Call executeCommand(command,rootFolder)
