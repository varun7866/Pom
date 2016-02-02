'get project folder and save it in environment variable
ExecutionEndTime = Now()

Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)


'load configuration file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml", true
'retrieve build details from configuration file
buildDetails = Environment.Value("strBuildNumber")
Environment("HTMLRESULTS_PATH") = Environment.Value("PROJECT_FOLDER") & "\Reports"

'Environment("REPOSITORYFILE_PATH") = Environment.Value("PROJECT_FOLDER") & "\Repository\"&Environment.Value("RepositoryFileName")

'Environment("TESTDATA_PATH") = Environment.Value("PROJECT_FOLDER") & "\TestData\" & Environment.Value("TestDataFileName")

'load framework and generic functional libraries
genericFunctionalLib = Environment.Value("PROJECT_FOLDER") & "\Library\generic_functions"
For each objFile in objFso.GetFolder(genericFunctionalLib).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" or UCase(objFso.GetExtensionName(objFile.Name)) = "QFL" Then
		LoadFunctionLibrary objFile.Path
	End If
Next

Dim arrFileLines()
i = 0

Set objLogFile = objFso.OpenTextFile(Environment("HTMLRESULTS_PATH")&"\temp.txt", 1) 'strOutLogsPath
Do Until objLogFile.AtEndOfStream
	Redim Preserve arrFileLines(i)
 	arrFileLines(i) = objLogFile.ReadLine
 	i = i + 1
Loop
objLogFile.Close
ResultsFolder = arrFileLines(0)

'Set objLogFile = objFso.OpenTextFile(Environment("HTMLRESULTS_PATH")&"\startTime.txt", 1) 'strOutLogsPath
'ExecutionStartTime = objLogFile.ReadAll()
'objLogFile.Close
i = 0
Dim arrFileLines1()
Set objLogFile = objFso.OpenTextFile(Environment("HTMLRESULTS_PATH")&"\startTime.txt", 1) 'strOutLogsPath
Do Until objLogFile.AtEndOfStream
	Redim Preserve arrFileLines1(i)
 	arrFileLines1(i) = objLogFile.ReadLine
 	i = i + 1
Loop
objLogFile.Close
ExecutionStartTime = arrFileLines1(0)

Set objLogFile = Nothing

'objFso.DeleteFile Environment("HTMLRESULTS_PATH")&"\temp.txt",True
'objFso.DeleteFile Environment("HTMLRESULTS_PATH")&"\startTime.txt",True
Set objFso = Nothing

ResultsDBFile = ResultsFolder & "\TestResults.xls"
'Connect to temp excel file and create tables
Set DBConnection_Results = ConnectToExcel(ResultsDBFile,"YES")


'Complete html report
CompleteReport

'Close all DB connections
DisposeDBConnection


