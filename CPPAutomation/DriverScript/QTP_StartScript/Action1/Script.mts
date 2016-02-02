'get project folder and save it in environment variable
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

Environment("HTMLRESULTS_PATH") = Environment.Value("PROJECT_FOLDER") & "\Reports"

'load report functional library
reportFunctionalLib = Environment.Value("PROJECT_FOLDER") & "\Library\generic_functions\ResultReport_Library.vbs"
LoadFunctionLibrary reportFunctionalLib

Set objFso = Nothing

'Initialize results folder
If Not InitializeReport() Then
	MsgBox "Not able to create results file."
	ExitTest
End If
