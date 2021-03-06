Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adCmdText =1
Const adOpenDynamic = 2

Public DBConnection_Results, DBConnection_Repository, DBConnection_TestData
Public ResultsFolder
Public TestStartTime,TestEndTime,StepStartTime,StepEndTime
Public ExecutionStartTime,ExecutionEndTime
Public HTMLResultsStreamWriter	
Public stepActual,StepResult,stepDuration,stepErrDescription,stepScreenshot,stepDescription,mstepResult, stepErrorMessage,ValidateScreenCapture
Public UserInsertedReport()
Redim UserInsertedReport(0)
Public TestScriptName, TestResult, strManualStepNo
Public buildDetails
Public IterationCount, testparameters
'Public strOutErrorDesc

Public Metrics_TotalExecuted,Metrics_Passed,Metrics_Failed,Metrics_NotRun
Metrics_TotalExecuted=0
Metrics_Passed=0
Metrics_Failed=0
Metrics_NotRun=0
Public stepCounter
stepCounter = 0
Dim continueExecution
continueExecution = True

'sys db connection
Public objDBConnection, objDBRecordSet


Function WriteToLog(ByVal strStatus,ByVal strDescription)
	
	If not isEmpty(ResultsFolder) Then
		Call writeLogResult(strStatus, strDescription)
	End If
	
End Function

Function WriteLogFooter()
	'end time of the script
	TestEndTime = Now
	ReportTestResult

	If CreateObject("Scripting.FileSystemObject").FileExists(Environment("HTMLRESULTS_PATH")&"\temp1.txt") Then
		CompleteReport
		
		Set objFso = CreateObject("Scripting.FileSystemObject")
		If objFso.FileExists(Environment("HTMLRESULTS_PATH")&"\temp.txt") then
			objFso.DeleteFile Environment("HTMLRESULTS_PATH")&"\temp.txt", true
		End if
		
		If objFso.FileExists(Environment("HTMLRESULTS_PATH")&"\startTime.txt") then
			objFso.DeleteFile Environment("HTMLRESULTS_PATH")&"\startTime.txt", true
		End if
		
		If objFso.FileExists(Environment("HTMLRESULTS_PATH")&"\build.txt") then
			objFso.DeleteFile Environment("HTMLRESULTS_PATH")&"\build.txt", true
		End if
		
		objFso.DeleteFile Environment("HTMLRESULTS_PATH")&"\temp1.txt", true
		Set objFso = Nothing
	End If

	'CompleteReport	  
	DisposeDBConnection
End Function

Function worksheetExists(ByVal sheetName, ByVal wb)
	On Error Resume Next
	worksheetExists = false

	Set sht = wb.Worksheets(sheetName)
	If Err.Number <> 0 Then
		Err.Clear
		Exit Function
	End If
	worksheetExists = true
End Function
Public Function InitializeReport()

'	On Error Resume Next
	Dim TemplateFile,ResultsDBFile,objFSO, addtimestamp
	Dim htmlFolderPath	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	htmlFolderPath = Environment("HTMLRESULTS_PATH") 
'	ResultsFolder = Environment("HTMLRESULTS_PATH")
	ResultsFolder = htmlFolderPath
	addtimestamp = "ExecutionResults_" & Environment.Value("UserName") & "_" &  Year(Date) & "-" & Right("0" & Month(Date), 2) & "-" & Right("0" & Day(Date), 2) & "_" & Replace(FormatDateTime(Time),":","")
	
	' Create a new  results folder
	ResultsFolder = ResultsFolder & "\" & addtimestamp
	objFSO.CreateFolder ResultsFolder
	
	If Not objFSO.FolderExists(ResultsFolder) Then
		InitializeReport = False
		Exit Function
	End If
	
	' Create a temp excel file to store results
	Dim objExcel,objWorkbook
	Set objExcel = CreateObject("Excel.Application")
	objExcel.Visible = False
	objExcel.DisplayAlerts = False
	
	Set objWorkbook= objExcel.Workbooks.Add()
	if Not worksheetExists("Sheet1", objWorkbook) Then
		objWorkbook.Worksheets.Add
	End If
	objWorkbook.Worksheets("Sheet1").Name = "TestResults"
	if Not worksheetExists("Sheet2", objWorkbook) Then
		objWorkbook.Worksheets.Add
	End If
	objWorkbook.Worksheets("Sheet2").Name    = "StepResults"
	If Not CreateExcelTables(objWorkbook) Then
		InitializeReport = False
		Exit Function
	End If
	
	ResultsDBFile = ResultsFolder & "\TestResults.xls"
	objWorkbook.saveAs ResultsDBFile,56  
	objWorkbook.close
	set objExcel=nothing
'	KillProcess
	
	'Create text file for writing the log file name
	Set objLogFile = objFSO.CreateTextFile(htmlFolderPath&"\temp.txt") 'strOutLogsPath
	objLogFile.Close
	Set objLogFile = objFSO.CreateTextFile(htmlFolderPath&"\startTime.txt")
	objLogFile.Close
	
	Set objLogFile = Nothing
'	Const ForWriting = 2
'	Const TristateTrue = -1
	
	'Open text file and write the log file name
'	Set objLogFile = objFSO.OpenTextFile(Environment("HTMLRESULTS_PATH")&"\temp.txt", ForWriting, True, TristateTrue) 'strOutLogsPath
'    objLogFile.WriteLine(ResultsFolder)
'    objLogFile.Close 
    
    Set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile(htmlFolderPath&"\temp.txt",2,true)
	objFileToWrite.WriteLine(ResultsFolder)
	objFileToWrite.Close
	Set objFileToWrite = Nothing
	
	TemplateFile = Environment("PROJECT_FOLDER") & "\template\ExecutionResults.htm"
	objFSO.CopyFile TemplateFile, ResultsFolder & "\"
	If Not objFSO.FileExists(ResultsFolder & "\ExecutionResults.htm") Then
		InitializeReport = False
		Exit Function
	End If
	
	'Connect to temp excel file and create tables
'	Set DBConnection_Results = ConnectToExcel(ResultsDBFile,"YES")
'	If Not DBConnection_Results.State = 1 Then
'		InitializeReport = False
'		Exit Function
'	End If
'	
	InitializeReport = True
	ExecutionStartTime = Now
		
'	Const ForWriting = 2
'	Const TristateTrue = -1
	
	'Open text file and write the start time of batch run
    Set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile(htmlFolderPath&"\startTime.txt",2,true)
	objFileToWrite.WriteLine(ExecutionStartTime)
	objFileToWrite.Close
	Set objFileToWrite = Nothing
    Set objFSO = Nothing

End Function

Public Function ConnectToExcel(ExcelPath,HDRValue)

	On Error Resume Next
	Err.Clear
	
	Dim objConnection,dbProvider,dbSource,dbExtended
	Set objConnection = CreateObject("ADODB.Connection")
	dbProvider =  "Provider=Microsoft.Jet.OLEDB.4.0;"
	dbSource =  "Data Source=" & ExcelPath & ";"
	dbExtended =    "Extended Properties=""Excel 8.0;HDR=" & HDRValue & ";"""
	
	objConnection.Open dbProvider & dbSource & dbExtended
	
	If Err.Number <> 0 Then   
		MsgBox Err.description
		ConnectToExcel = ""
		Set objConnection = Nothing    
		Exit Function
	End If
	Set ConnectToExcel = objConnection

End Function


Public Sub ReportTestResult()
			 
	On Error Resume Next
	Err.Clear

	Dim strSQL,objCommand,FieldList,ValuesList

	FieldList = "(TestScript,TestResult,TestDuration)"
	ValuesList =  "'" & TestScriptName & "','" & TestResult & "','" & GetExecutionTime(TestStartTime,TestEndTime) & "'"

	Set objCommand = CreateObject("ADODB.Command") 
	Set objCommand.ActiveConnection = DBConnection_Results

	objCommand.CommandText = "INSERT INTO [TestResults$] " & FieldList & " Values (" & ValuesList & ")"
	objCommand.Execute , , adCmdText

	If Err.Number <> 0 Then   
			 MsgBox Err.Description
			 Set objCommand = Nothing    
			 Exit Sub
	End If
	Set objCommand = Nothing 

End Sub

Function KillProcess()

	On Error Resume Next 
	Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}" & "!\\.\root\cimv2")
	
	Set colProcess = objWMIService.ExecQuery ("Select * From Win32_Process")
	For Each objProcess in colProcess
	  If LCase(objProcess.Name) = LCase("excel.exe") Then
	     'objWshShell.Run "TASKKILL /F /T /IM " & objProcess.Name, 0, False
	     objProcess.Terminate()
	  End If
	Next
	
End Function

Sub WriteResultLog(ByVal testcaseNumber, ByVal stepDescription, ByVal result, ByVal screenshotRequired)

	On Error Resume Next
	Err.Clear
	
	If isEmpty(ResultsFolder) Then
		Exit Sub
	End If
	
	If UCase(result) = "INFO" Then
		strManualStepNo = ""
	Else
		strManualStepNo = testcaseNumber
	End If
	
	If UCase(result) = "FAILED" Then
		Iteration_Result="Failed"
		mstepResult = "Failed"
		TestResult = "Failed"
		screenshotRequired = true
	End If	
	StepResult = result
	mstepResult = result
	
	If screenshotRequired Then
		'Capture screenshot
		Environment.value("blnAttachScreenshot")="TRUE"
		stepScreenshot = ResultsFolder & "\" & TestScriptName & "_" & testcaseNumber & "_" & Hour(Time) & Minute(Time) & Second(Time) & ".png" 
		Desktop.CaptureBitmap stepScreenshot
	Else
		Environment.value("blnAttachScreenshot")="FALSE"
	End If
	
	StepActual = stepDescription
	
	If Environment.value("blnAttachScreenshot")="TRUE" Then
		ValidateScreenCapture="TRUE"
	Else
		ValidateScreenCapture="FALSE"
	End If	
	
	stepDuration = GetExecutionTime(StepStartTime,StepEndTime)
	Call ReportResult()
	stepScreenshot = ""
	stepActual = ""
	stepResult = ""
End Sub

Public Function GetExecutionTime(StartTime,EndTime)
	GetExecutionTime = datediff("s",StartTime,EndTime)
End Function

Public Sub ReportResult()
			 
	On Error Resume Next
	Err.Clear
	
	If not isObject(DBConnection_Results) Then
		Print "No result folder"
		Exit Sub
	End If
	
	Dim strSQL,objCommand,FieldList,ValuesList,intbreakUpActual,breakup
	Dim breakUpActual()
	
	stepActual = " " & stepActual & vbLf & stepErrorMessage
	stepActual = Right(stepActual,Len(stepActual)-1)
	intbreakUpActual=0
	
	stepActual=Replace(stepActual,vbLf,"(*)")
	stepActual=Replace(stepActual,"'","(-)")      
	
	'added to resolve 255 characters issue
	If Len(stepActual) > 255 Then
		'stepActual = Left(stepActual,255)
		'**********Start Addition By Sudheer 15 Jan 2016	
		Dim copyActual
		copyActual=stepActual
		intbreakUpActual=Len(stepActual)/255
		If cint(intbreakUpActual)< (Len(stepActual)/255) Then
			intbreakUpActual=cint(intbreakUpActual)+1
		Else
			intbreakUpActual=Cint(intbreakUpActual)
		End If
		ReDim breakUpActual(intbreakUpActual)
		For breakup=0 To intbreakUpActual-1 
			breakUpActual(breakup)=Left(copyActual,(255))
			If (Len(stepActual)-(255*(breakup+1)))>0 Then
				copyActual=Right(copyActual,(Len(stepActual)-(255*(breakup+1))))
			End If
		Next
		'**********End Addition By Sudheer 15 Jan 2016
	End If


	FieldList = "(TestScript,ManualStep,Actual,Result,Duration,Screenshot,Iteration,ValidateScreenCapture,breakUpActual)"
	
	If IsEmpty(ValidateScreenCapture) Then
		ValidateScreenCapture=""
	End If
	
	CurrentIteration = "1"
	If intbreakUpActual=0 Then
	
		ValuesList =  "'" & TestScriptName &  "','" & strManualStepNo & _
				      "','" & stepActual & "','" & StepResult & _
				      "','" & stepDuration & "','" & stepScreenshot & _
				      "','" & CurrentIteration & "','" & ValidateScreenCapture & _
				      "','" &intbreakUpActual& "'"
	
		Set objCommand = CreateObject("ADODB.Command") 
		Set objCommand.ActiveConnection = DBConnection_Results
	
		objCommand.CommandText = "INSERT INTO [StepResults$] " & FieldList & " Values (" & ValuesList & ")"
		objCommand.Execute , ,adCmdText
		Err.Clear
		'MsgBox Err.Description
	Else
		Set objCommand = CreateObject("ADODB.Command") 
		Set objCommand.ActiveConnection = DBConnection_Results
		Dim iMax
		iMax=0
		If iMax<intbreakUpActual Then
			iMax=intbreakUpActual
		End If
		'MsgBox Err.Description&"before preserve"
		ReDim Preserve breakUpActual(iMax)
		'MsgBox Err.Description&"after preserve"
		Dim StartDescriptionappend
		For StartDescriptionappend = 0 To iMax-1
			If intbreakUpActual=0 And StartDescriptionappend = 0 Then
				breakUpActual(StartDescriptionappend)=stepActual
			End If
			ValuesList =  "'" & TestScriptName &  "','" & strManualStepNo & "','" & _
						  breakUpActual(StartDescriptionappend) & "','" & _
						  mstepResult & "','" & stepDuration & "','" & stepScreenshot & "','" & _
						  CurrentIteration & "','" & ValidateScreenCapture & "','" &intbreakUpActual& "'"
	
			objCommand.CommandText = "INSERT INTO [StepResults$] " & FieldList & " Values (" & ValuesList & ")"
			objCommand.Execute , ,adCmdText
		Next
	End If
	
	Dim i
	For i = 1 To ubound(UserInsertedReport)
		objCommand.CommandText = UserInsertedReport(i)
		objCommand.Execute , ,adCmdText
	Next
	Redim UserInsertedReport(0)
	
	If Err.Number <> 0 Then   
			 Print Err.Description
			 Set objCommand = Nothing    
			 Exit Sub
	End If
	Set objCommand = Nothing    

End Sub


'Function reporterEvent(myStepNo, myDes, myExp, myAct, myResult, withSnapshot)
'	On error resume next
'	Err.clear
'	If lcase(myResult) <> "passed" Then
'		Iteration_Result="Failed"
'		TestResult = "Failed"
'	End If
'	Dim FieldList, myDuration, zero, ValidateScreenCapture, ValuesList
'	FieldList = "(TestScript,ManualStep,StepDescription,Expected,Actual,Result,Duration,Screenshot,Iteration,ValidateScreenCapture,breakUpDescription,breakUpExpected,breakUpActual)"
'
'	myDuration = "0"
'	zero = "0"
'	if lcase(withSnapshot) = "yes" then
'		withSnapshot = "TRUE"
'	End if
'	ValidateScreenCapture = UCASE(withSnapshot)
'
'	Dim mySnapshot
'	If ValidateScreenCapture = "TRUE" Then
'		mySnapshot = ResultsFolder & "\" & TestScriptName & "_" & strManualStepNo & "_" & Hour(Time) & Minute(Time) & Second(Time) & ".png"
'		Desktop.CaptureBitmap mySnapshot
'		wait 1		
'	End If	
'	ValuesList =  "'" & TestScriptName &  "','" & myStepNo & "','" & myDes & "','" & myExp & _
'			"','" & myAct & "','" & myResult & "','" & myDuration & "','" & mySnapshot & "','" & _
'			CurrentIteration & "','" & ValidateScreenCapture & "','"&zero & "','" &zero& "','" &zero& "'"
'	
'	redim preserve UserInsertedReport(ubound(UserInsertedReport)+1)
'	UserInsertedReport(ubound(UserInsertedReport)) = "INSERT INTO [StepResults$] " & FieldList & " Values (" & ValuesList & ")"
'			
'	If Err.Number <> 0 Then
'		Print Err.Description
'	End If
'End Function
'
Public Sub CompleteReport

	On Error Resume Next
	Dim strFile,objFSO
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	ExecutionEndTime = Now
	AddTestResultToHTML
	DBConnection_Results.Close
	Set DBConnection_Results = Nothing
	
	If AddNameToReportFile = "" Then
		AddNameToReportFile = TestScriptName
	End If
	
	strFile = ResultsFolder & "\ExecutionResults_BatchRun.htm"
	objFSO.MoveFile ResultsFolder & "\ExecutionResults.htm",strFile
	Wait 2
	
	objFSO.DeleteFile Environment.Value("HTMLRESULTS_PATH") & "\build.txt", True
	
	strFile = ResultsFolder & "\TestResults.xls"
	objFSO.DeleteFile strFile,True 
	
End Sub

Public Sub DisposeDBConnection()

	On Error Resume Next
	DBConnection_Results.Close
	Set DBConnection_Results = Nothing
	DBConnection_Repository.Close
	Set DBConnection_Repository = Nothing
	DBConnection_TestData.Close
	Set DBConnection_TestData = Nothing
	
End Sub

Public Sub AddTestResultToHTML()

	On Error Resume Next
	Err.Clear
	Dim strSQL,rs,strFile,objFSO
	Dim Count_TC,Count_Passed,Count_Failed,Count_NotRun
	Count_TC = 0
	Count_Passed = 0
	Count_Failed = 0
	Count_NotRun = 0
	
	Const ForAppending = 8
	
	' Open Execution Results.htm file
	strFile = ResultsFolder & "\ExecutionResults.htm"
					
	set objFSO = CreateObject("Scripting.FileSystemObject")					
	set HTMLResultsStreamWriter = objFSO.OpenTextFile(strFile, ForAppending, True)
	
	'Get Test results
	strSQL = "SELECT * FROM [TestResults$]"
	Set rs = CreateObject("ADODB.Recordset")
	rs.Open strSQL, DBConnection_Results, adOpenStatic, adLockOptimistic, adCmdText
	
	Do While not rs.eof
	
		Dim tName,tResult,tDuration
		tName = rs.Fields.Item("TestScript").Value
		tResult = rs.Fields.Item("TestResult").Value
		tDuration = rs.Fields.Item("TestDuration").Value
	
		If IsNull(tName) Then
			'do nothing
		Else
			Print tResult
			If LCase(tResult) = "passed" Then
				Count_Passed = Count_Passed + 1
			ElseIf LCase(tResult) = "failed" Then
				Count_Failed = Count_Failed + 1
			ElseIf tResult = "Not Run" Then
				Count_NotRun = Count_NotRun + 1
			End If
			
			Count_TC = Count_TC + 1
			
			Call AddStepResultsToHTML(tName,tResult,tDuration,Count_TC)
		End If
		
		rs.MoveNext 
	Loop
	
	'finish the HTML Report
	HTMLResultsStreamWriter.WriteLine("</table>" & vbLf)
	HTMLResultsStreamWriter.WriteLine("<input type=""hidden"" id =""hdpassed"" value ="""&Metrics_Passed&""" />" & vbLf &_
									  "<input type=""hidden"" id =""hdfailed"" value="""&Metrics_Failed&""" />" & vbLf &_
									  "<input type=""hidden"" id =""hdTotal"" value="""&Metrics_TotalExecuted&""" />" & vbLf)
	HTMLResultsStreamWriter.WriteLine("</body>  </html>")
	HTMLResultsStreamWriter.Close()
	HTMLResultsStreamWriter = Nothing
	
	Set rs = Nothing
	
	ReplaceSummary CINT(Count_Passed),CINT(Count_Failed),CINT(Count_TC),CINT(Metrics_Passed),CINT(Metrics_Failed),CINT(Metrics_NotRun),CINT(Metrics_TotalExecuted)
	
	If Err.Number <> 0 Then   
		'MsgBox err.description
		Err.Clear
		Exit Sub
	End If

End Sub

Public Sub AddStepResultsToHTML(TestScript,TResult,TDuration,Count_TC)
				 
	On Error Resume Next
	Err.Clear

	Dim strSQL,rs
	'Get Iteration results
	strSQL = "SELECT Iteration FROM [StepResults$] where TestScript='" & TestScript & "' GROUP BY Iteration"
	Set rs = CreateObject("ADODB.Recordset")
	rs.Open strSQL, DBConnection_Results, adOpenStatic, adLockOptimistic, adCmdText

	Dim bgColor,strHyperLnk 

	If Count_TC Mod 2 = 1 Then
		bgColor = "#FFFFFF"
	Else
		bgColor = "#D6EBFC"
	End If

	Dim failColor

	If TResult = "Passed" Then
		'failColor = "#000000" 
		failColor = "#008000"
	ElseIf TResult = "Failed" Then
		failColor = "#FF0000"
	ElseIf TResult = "Not Run" Then
		failColor = "#FF0000"
	End If

	'Write full test result
	HTMLResultsStreamWriter.Write(_
		"<tr>" & vbLf &_
		"<td id=""main" & Count_TC & """ style=""vertical-align: middle; text-align: center; font-family: Calibri; padding: 0px; margin: 0px; background-color: " & bgColor & ";""> " &_
		"&nbsp;<a href=""javascript:void(0)"" onclick=""toggle(" & Count_TC & ", 'open')"" class=""style7"">+</a>&nbsp;</td>" & vbLf &_
	 	"<td style=""vertical-align: middle; text-align: center; font-family: Calibri; padding: 0px; margin: 0px; background-color: " & bgColor & ";""> " &_
			Count_TC & "</td>" & vbLf &_
	 	"<td style=""vertical-align: middle; text-align: center; font-family: Calibri; padding: 0px; margin: 0px; background-color: " & bgColor & ";""> " &_
			TestScript & "</td>" & vbLf &_
	 	"<td style=""vertical-align: middle; text-align: center; font-family: Calibri; padding: 0px; margin: 0px; background-color: " & bgColor & "; color: " & failColor & ";""> " &_
			TResult & "</td>" & vbLf &_
	 	"<td style=""vertical-align: middle; text-align: center; font-family: Calibri; padding: 0px; margin: 0px; background-color: " & bgColor & ";""> " &_
	  		TDuration & "</td>" & vbLf &_
		"</tr>" & vbLf)

	HTMLResultsStreamWriter.WriteLine(_
		"<tr> " & vbLf &_
	 	"<td colspan=""6"" style=""vertical-align: middle; text-align: center; font-family: Calibri;  margin: 0px; background-color: #FFFFFF;""  > " & vbLf &_
	 	"<div  id=""subItem" & Count_TC & """ style=""display :none "" width=""100%"">")

	Do While not rs.eof

		'create header for the sub table
		HTMLResultsStreamWriter.WriteLine("<p></p>")
		Dim citeration
		citeration = rs.Fields.Item("Iteration").Value

		'HTMLResultsStreamWriter.WriteLine(_
		'	"<p style=""font-family: 'Trebuchet MS'; font-size: small; font-weight: bold; text-decoration: underline; text-align: left"">Iteration " & citeration & "</p>" & vbLf)

		HTMLResultsStreamWriter.WriteLine(_
			"<table align=""center"" style=""border-style: ridge; border-width: 2px; width:95%;"" cellpadding=""0"" cellspacing=""0"" > " & vbLf &_
			"<tr>" & vbLf &_
			   "<th width=""15%"" style=""border-style: solid; border-width: 1px; background-color: #00B5F0"">Test Case No</th> " & vbLf &_
			   "<th width=""20%"" style=""border-style: solid; border-width: 1px; background-color: #00B5F0"">Status </th> " & vbLf &_
			   "<th style=""border-style: solid; border-width: 1px; background-color: #00B5F0"">Actual Result</th> " & vbLf &_
		   "</tr>" & vbLf)


	    Dim rs_new
		'Add step results one by one 
		strSQL = "SELECT * FROM [StepResults$] WHERE TestScript='" & TestScript & "' And Iteration='" & citeration & "'"
		Set rs_new = CreateObject("ADODB.Recordset")
		rs_new.Open strSQL, DBConnection_Results, adOpenStatic, adLockOptimistic, adCmdText
		
		Do While not rs_new.eof
			Dim sResult,failDesc,AttachScreen
			Dim intbreakUpAct,strFullActual
		   ' Add step results to the sub table
		    If rs_new.Fields.Item("breakUpActual").Value=0 Then
				HTMLResultsStreamWriter.WriteLine(_
					"<tr>" & vbLf &_
						"<td  style=""border-style: solid; border-width: 1px;""> " &_
							rs_new.Fields.Item("ManualStep").Value & "</td>" & vbLf)
		     	'Dim sResult 
				sResult = rs_new.Fields.Item("Result").Value
				'Dim failDesc
				failDesc = rs_new.Fields.Item("Actual").Value
				failDesc=Replace(failDesc,"(*)","<br>")
				failDesc=Replace(failDesc,"(-)","'")
				'Dim AttachScreen
				AttachScreen=rs_new.Fields.Item("ValidateScreenCapture").Value
					
				If Not Cstr(failDesc) = "" Then
					failDesc = Replace(Cstr(failDesc),vbLf,"<br>")
				End If
					
				If UCase(sResult) = "PASS" Then
					If AttachScreen="TRUE" Then
'						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px;"" > " &_
'						   "<a style=""color:#008000;"" href= """ & rs_new.Fields.Item("Screenshot").Value & """ target=""_blank"">Passed</a> </td>" & vbLf)
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px;"" > " &_
						   "<a style=""color:#008000;"" href= """ & CreateObject("Scripting.FileSystemObject").GetFileName(rs_new.Fields.Item("Screenshot").Value) & """ target=""_blank"">Pass</a> </td>" & vbLf)
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;color:#008000;""> " &_
							failDesc & "</td>" & vbLf & "</tr>" & vbLf)
					Else
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px;"" > " &_
							sResult & "</td>" & vbLf)
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;""> " &_
							failDesc & "</td>" & vbLf & "</tr>" & vbLf)
					End If
						
					Metrics_Passed = Metrics_Passed + 1
				ElseIf UCase(sResult) = "FAIL" Then
					If rs_new.Fields.Item("Screenshot").Value<>"FALSE" Then	
						strHyperLnk="<a style=""color:#FF0000;"" href= """ & CreateObject("Scripting.FileSystemObject").GetFileName(rs_new.Fields.Item("Screenshot").Value) & """  target=""_blank"">" & sResult & "</a> </td>" 
					Else
						strHyperLnk= sResult & "</td>"
					End If
						
					HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px; color:#FF0000;"" > " & strHyperLnk & vbLf)
					HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;color:#FF0000;""> " &_
						failDesc & "</td>" & vbLf & "</tr>" & vbLf)

					Metrics_Failed = Metrics_Failed + 1
				Else
					If rs_new.Fields.Item("Screenshot").Value<>"FALSE" Then	
						strHyperLnk="<a style=""color:#646464;"" href= """ & CreateObject("Scripting.FileSystemObject").GetFileName(rs_new.Fields.Item("Screenshot").Value) & """  target=""_blank"">" & sResult & "</a> </td>" 
					Else
						strHyperLnk= sResult & "</td>"
					End If
						
					HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px; color:#646464;"" > " & strHyperLnk & vbLf)
					If instr(lcase(failDesc), "testcase") > 0 or instr(lcase(failDesc), "test case") > 0 Then
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;""> <b>" &_
							failDesc & "</b></td>" & vbLf & "</tr>" & vbLf)
					Else
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;""> " &_
							failDesc & "</td>" & vbLf & "</tr>" & vbLf)
					End If											
				End If
				
				rs_new.MoveNext 
			Else
				
				intbreakUpAct=Cint(rs_new.Fields.Item("breakUpActual").Value)
				Dim iMax
				iMax=0
				If iMax<intbreakUpAct Then
					iMax=intbreakUpAct
				End If
				
				strFullActual=""
				For intStartbreakUpDes = 1 To iMax
					strFullActual=strFullActual & rs_new.Fields.Item("Actual").Value
					If intStartbreakUpDes=1 Then
						sResult = rs_new.Fields.Item("Result").Value
						'failDesc = rs_new.Fields.Item("Actual").Value
						AttachScreen=rs_new.Fields.Item("ValidateScreenCapture").Value
						Dim strManualStep
						Dim strExpectedResult
						Dim strScreenShot
							
						strManualStep=rs_new.Fields.Item("ManualStep").Value
						strScreenShot=rs_new.Fields.Item("Screenshot").Value
					End If
					rs_new.MoveNext 
				Next
				
				failDesc=strFullActual
				failDesc=Replace(failDesc,"(*)","<br>")
				failDesc=Replace(failDesc,"(-)","'")
		     	HTMLResultsStreamWriter.WriteLine(_
					"<tr>" & vbLf &_
						"<td  style=""border-style: solid; border-width: 1px;""> " & strManualStep & "</td>" & vbLf)	
					If Not Cstr(failDesc) = "" Then
						failDesc = Replace(Cstr(failDesc),vbLf,"<br>")
					End If

					If UCase(sResult) = "PASS" Then
						If AttachScreen="TRUE" Then
							HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px;"" > " &_
								   "<a style=""color:#008000;"" href= """ & CreateObject("Scripting.FileSystemObject").GetFileName(strScreenShot) & """>Passed</a> </td>" & vbLf)
							HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;color:#008000;""> " &_
									failDesc & "</td>" & vbLf & "</tr>" & vbLf)
						Else
							HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px;"" > " &_
								  sResult & "</td>" & vbLf)
							HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;""> " &_
									failDesc & "</td>" & vbLf & "</tr>" & vbLf)
						End If
						
						Metrics_Passed = Metrics_Passed + 1
							
					ElseIf UCase(sResult) = "FAIL" Then
						If rs_new.Fields.Item("Screenshot").Value<>"FALSE" Then	
							strHyperLnk="<a style=""color:#FF0000;"" href= """ & CreateObject("Scripting.FileSystemObject").GetFileName(rs_new.Fields.Item("Screenshot").Value) & """  target=""_blank"">" & sResult & "</a> </td>" 
						Else
							strHyperLnk= sResult & "</td>"
						End If
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px; color:#FF0000;"" > " & strHyperLnk & vbLf)
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;color:#FF0000;""> " &_
							failDesc & "</td>" & vbLf & "</tr>" & vbLf)
							
						Metrics_Failed = Metrics_Failed + 1
					Else
						If rs_new.Fields.Item("Screenshot").Value<>"FALSE" Then	
							strHyperLnk="<a style=""color:#646464;"" href= """ & CreateObject("Scripting.FileSystemObject").GetFileName(rs_new.Fields.Item("Screenshot").Value) & """  target=""_blank"">" & sResult & "</a> </td>" 
						Else
							strHyperLnk= sResult & "</td>"
						End If
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; border-width: 1px; color:#646464;"" > " & strHyperLnk & vbLf)
						HTMLResultsStreamWriter.WriteLine("<td style=""border-style: solid; text-align: left; border-width: 1px;""> " &_
							failDesc & "</td>" & vbLf & "</tr>" & vbLf)
					End If 
				End If
			Loop
		rs_new.Close 
		Set rs_new = Nothing    
		HTMLResultsStreamWriter.WriteLine("</table>" & vbLf &_
		"</div>" & vbLf)
		rs.MoveNext 
	Loop
	rs.Close
	Set rs = Nothing    

	'finish the sub table
	HTMLResultsStreamWriter.WriteLine("<p></p>" & vbLf & "</td> </tr>")
	Metrics_TotalExecuted = Metrics_Passed + Metrics_Failed
	If Err.Number <> 0 Then   
		'MsgBox err.description
		Err.Clear
		Exit Sub
	End If
	
End Sub

Public Sub ReplaceSummary(script_Passed, script_Failed, total_scripts, Count_Passed, Count_Failed,Count_NotRun,Total_TC)
	On Error Resume Next
	Err.Clear
	Dim objFSO,objTextFile,strFile,strText
	Const ForReading = 1
	Const ForWriting = 2
	
	' Open Execution Results.htm file
	strFile = ResultsFolder & "\ExecutionResults.htm"
		set objFSO = CreateObject("Scripting.FileSystemObject")					
	Set objTextFile = objFSO.OpenTextFile(strFile, ForReading)
	strText = objTextFile.ReadAll
	
	'calculate total execution time
	totalExecSeconds = GetExecutionTime(ExecutionStartTime, ExecutionEndTime)
	totalHours = totalExecSeconds \ 3600
	totalExecSeconds = totalExecSeconds Mod 3600
	totalMinutes = totalExecSeconds \ 60 
	totalSeconds = totalExecSeconds Mod 60
	
	Print totalHours
	Print totalMinutes
	Print totalSeconds
	
	totExecTime = totalHours & " hr(s) " & totalMinutes & " min(s) " & totalSeconds & " sec(s)"
		
	strText = Replace(strText,"&amp;Host&amp;", Environment.Value("LocalHostName"))
	strText = Replace(strText,"&amp;Executed By&amp;", Environment.Value("UserName"))
	strText = Replace(strText,"&amp;OS&amp;",Environment.Value("OS"))
	strText = Replace(strText,"&amp;Start Time&amp;", ExecutionStartTime)
'	strText = Replace(strText,"&amp;End Time&amp;", ExecutionEndTime)
	strText = Replace(strText,"&amp;Execution Duration&amp;", totExecTime)
	
	strText = Replace(strText,"&amp;Total TC&amp;", total_scripts)
	strText = Replace(strText,"&amp;Passed&amp;", script_Passed)
	strText = Replace(strText,"&amp;Failed&amp;", script_Failed)
	
	strText = Replace(strText,"&amp;Total Manual TC&amp;", Total_TC)
	strText = Replace(strText,"&amp;Manual Passed&amp;", Count_Passed)
	strText = Replace(strText,"&amp;Manual Failed&amp;", Count_Failed)
	buildDetails = getBuildNumber
	Err.Clear
	strText = Replace(strText, "&amp;Build Details&amp;", buildDetails)
	
	'strText = Replace(strText,"&amp;Not Run&amp;", Count_NotRun)
	objTextFile.Close
	Set objTextFile = Nothing
	
	Set objTextFile = objFSO.OpenTextFile(strFile, ForWriting)
	objTextFile.Write strText
	objTextFile.Close
	Set objTextFile = Nothing
	
	Environment.Value("Total_TC")=Total_TC
	Environment.Value("Count_Passed")=Count_Passed
	Environment.Value("Count_Failed")=Count_Failed
	
	If Err.Number <> 0 Then   
		MsgBox err.description
		Err.Clear
		Exit Sub
	End If
End Sub

Function getBuildNumber()
	On Error Resume Next
	Err.Clear
	Set objFso = CreateObject("Scripting.FileSystemObject")
	driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
	Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)
	Environment("HTMLRESULTS_PATH") = Environment.Value("PROJECT_FOLDER") & "\Reports"
	If Not objFso.FileExists(Environment("HTMLRESULTS_PATH")&"\build.txt") Then
		getBuildNumber = "NA"
		Exit Function
	Else
		Set objLogFiles = objFso.OpenTextFile(Environment("HTMLRESULTS_PATH")&"\build.txt", 1) 'strOutLogsPath
		Do Until objLogFiles.AtEndOfStream
			Redim Preserve arrFileLines(s)
		 	arrFileLines(s) = objLogFiles.ReadLine
		 	s = s + 1
		Loop
		objLogFiles.Close
		buildNo = arrFileLines(0)
		
		getBuildNumber = buildNo
	End If
	
	Set objFso = Nothing
	
End Function

Public Function CreateExcelTables(inpWorkbook)
 
	On Error Resume Next
	
	Dim inpWorksheet
	Set inpWorksheet = inpWorkbook.Worksheets("TestResults")
	inpWorksheet.Cells(1,1) = "TestScript"
	inpWorksheet.Cells(1,2) = "TestResult"
	inpWorksheet.Cells(1,3) = "TestDuration"
	
	Set inpWorksheet = inpWorkbook.Worksheets("StepResults")
	inpWorksheet.Cells(1,1) = "TestScript"
	inpWorksheet.Cells(1,2) = "ManualStep"
	inpWorksheet.Cells(1,3) = "Actual"
	inpWorksheet.Cells(1,4) = "Result"
	inpWorksheet.Cells(1,5) = "Duration"
	inpWorksheet.Cells(1,6) = "Screenshot"
	inpWorksheet.Cells(1,7) = "Iteration"
	inpWorksheet.Cells(1,8) = "ValidateScreenCapture"
	inpWorksheet.Cells(1,9) = "breakUpActual"
	If Err.Number <> 0 Then   
		Print Err.description
		CreateExcelTables = False
		Exit Function
	End If
	CreateExcelTables = True
	Err.Clear

End Function

Public Function InitializeRepository()

	On Error Resume Next
	Dim RepositoryFile,objFSO
	
	RepositoryFile = Environment("REPOSITORYFILE_PATH")
	If RepositoryFile = "" Then
		InitializeRepository = True
		Exit Function
	End If
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	If Not objFSO.FileExists(RepositoryFile) Then
		InitializeRepository = False
		Exit Function
	End If
	
	' Connect to the excel database
	Set DBConnection_Repository = ConnectToExcel(RepositoryFile,"YES")
	If Not DBConnection_Repository.State = 1 Then
		InitializeRepository = False
		Exit Function
	End If
	
	If Err.Number <> 0 Then   
		MsgBox Err.Description
		Err.Clear 
		InitializeRepository = false
		Exit Function
	End If 
	
	InitializeRepository = True

End Function

Public Function InitializeTestData()

	On Error Resume Next
	Dim TestDataFile,objFSO
	
	TestDataFile = Environment("TESTDATA_PATH")
	If TestDataFile = "" Then
		InitializeTestData = True
		Exit Function
	End If
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	If Not objFSO.FileExists(TestDataFile) Then
		InitializeTestData = False
		Exit Function
	End If
	
	' Connect to the excel database
	Set DBConnection_TestData = ConnectToExcel(TestDataFile,"YES")
	If Not DBConnection_TestData.State = 1 Then
		InitializeTestData = False
		Exit Function
	End If
	
	If Err.Number <> 0 Then   
		MsgBox Err.Description
		Err.Clear 
		InitializeTestData = false
		Exit Function
	End If 
	
	InitializeTestData = True

End Function


Public Function GetTestDataIterations()

	On Error Resume Next
	Err.Clear
		
	Dim TestSheet
	TestSheet = "[" & TestScriptName & "$]"
	
	Dim strSQL,rs
	Set rs= CreateObject("ADODB.Recordset")
	strSQL = "SELECT * FROM " & TestSheet & " where Run = 'Y'"
	rs.Open strSQL, DBConnection_TestData, adOpenStatic, adLockOptimistic, adCmdText
	
	If Err.Number <> 0 Then   
		Msgbox "Error while executing the SQL." & Err.Description
		GetTestDataIterations = false
		Set rs = nothing
		Exit Function
	End If 
	
	IterationCount = rs.RecordCount
	
	rs.Close
	Set rs = nothing
	GetTestDataIterations = true

End Function



'**********************************************************
'* Function Name        : RetrieveTestData
'* Function Description :  Retrieve test data details for the current iteration 
'*						: in the AppSettings_<app>.xml environment variable TESTDATA_DBFILE
'* Created By           : Wipro Technologies
'* Created Date         : 11-Oct-10
'* Input Parameter      : NA
'* Output Parameter     : NA
'* Pre-Conditions       : NA
'* Post Conditions      : Connection should be established to the DB path specified in TESTDATA_DBFILE in AppSettings_<app>.xml 
'**********************************************************
Public Function RetrieveTestData(ByVal iterationNo)

	On Error Resume Next
	Err.Clear
	
	Dim strSQL,rs, colCount,col
	Set rs= CreateObject("ADODB.Recordset")
	
	Dim TestSheet
	TestSheet = "[" & TestScriptName & "$]"
	
	strSQL = "SELECT * FROM " & TestSheet & " where Run = 'Y'"
	rs.Open strSQL, DBConnection_TestData, adOpenStatic, adLockOptimistic, adCmdText				
	
	If Err.Number <> 0  Then   
		Msgbox "Error while executing the SQL." & Err.Description
		RetrieveTestData = false
		Set rs = nothing
		Exit Function
	End If 
	
	If rs.RecordCount < 1 Then
		RetrieveTestData = false
		Set rs = nothing
		Exit Function
	End If
	
	rs.Move iterationNo-1,1
	If Err.Number <> 0  Then   
		Msgbox "Error while executing the SQL." & Err.Description
		RetrieveTestData = false
		Set rs = nothing
		Exit Function
	End If 
	colCount=rs.Fields.Count
	Dim fieldNames
	fieldNames = rs.fields
	
'	For col =2 To colCount
'	
'		Print fieldNames(col)
''		Dim pname,pvalue
''		pvalue = rs.Fields.Item(col).Value
''								
''		pos = instr(pvalue,"=")
''		if pos>0 then
''			pname = Trim(left(pvalue, pos-1))
''			pvalue = Trim(Right(pvalue, len(pvalue)-pos))
''			testparameters.Add pname, pvalue
''		end if
'	Next
	
	rs.Close
	Set rs = nothing
	RetrieveTestData = True

End Function



Function writeLogResult(ByVal result,ByVal stepDescription)
	
	On Error Resume Next
	Err.Clear
	
	If UCase(result) <> "INFO" Then
		stepCounter = stepCounter + 1
		strManualStepNo = "TC" & stepCounter
	Else
		strManualStepNo = ""
	End If
	
	If UCase(result) = "FAIL" Then
		Iteration_Result="Failed"
		mstepResult = "Failed"
		TestResult = "Failed"
		screenshotRequired = true		
	End If	
	StepResult = result
	mstepResult = result
	If screenshotRequired Then
		'Capture screenshot
		Environment.value("blnAttachScreenshot")="TRUE"
		stepScreenshot = ResultsFolder & "\" & TestScriptName & "_" & testcaseNumber & "_" & Hour(Time) & Minute(Time) & Second(Time) & ".png" 
		Desktop.CaptureBitmap stepScreenshot
	Else
		Environment.value("blnAttachScreenshot")="FALSE"
	End If

	StepActual = stepDescription
	
	If Environment.value("blnAttachScreenshot")="TRUE" Then
		ValidateScreenCapture="TRUE"
	Else
		ValidateScreenCapture="FALSE"
	End If	
	
	stepDuration = GetExecutionTime(StepStartTime,StepEndTime)
	Call ReportResult()
	stepScreenshot = ""
	stepActual = ""
	stepResult = ""
End Function

'##################################################################################################################################
'Function Name       :	Initialization (Note: It is a must to call this function at the begining of every script)
'Purpose of Function :	To get the Test case name, log path, log file name, execution start time and create log file template
'Input Arguments     :	None
'Output Arguments    :	strOutTestName -> string value which contains the test case name
'						strOutLogsPath -> string value which contains the logs folder path
'						strOutLogFile -> string value which contains the logfile name
'Example of Call     :	Call Initialization(strOutTestName, strOutLogsPath, strOutLogFile)
'Author              :	Kushal Parab/Piyush Chandana
'Date                :	15-Sep-2014
'Modified By		 :  Modified the function by Sudheer to incorporate new framework changes on 28-Apr-2015 
'##################################################################################################################################

Function Initialization()
	
	strOutTestName = ""
	strOutLogsPath = ""
	strOutLogFile = ""
	intStepVerificationFailCount = 0
	intStepVerificationPassCount = 0
	Err.Clear
	On Error Resume Next
	
	strFullTestName = Environment.Value("TestName")	'Get complete name of the testcase
	strOutTestName= strFullTestName 'Mid(strFullTestName,InStr(1,strFullTestName,"AT-",1))	'Testcase name without "ATS_Sprint#" text
	strTestLocation = Environment.Value("TestDir")	'Get test script location
	
	'Check if enviroment variable exists
	vTemp = Environment("logsInExecutionLogsFolder")
	If Err.Number <> 0 Then
		IsEnvVarEmpty = "TRUE"
	End If
	Err.Clear
	'Create FileSystemObject
	htmlFolderPath = Environment("HTMLRESULTS_PATH")
	If err.Description <> "" Then
		Environment("HTMLRESULTS_PATH") = Environment.Value("PROJECT_FOLDER") & "\Reports"
		Err.Clear
	End If
	
	Set fso = CreateObject("Scripting.FileSystemObject")	
	If Not fso.FileExists(Environment("HTMLRESULTS_PATH")&"\temp.txt") Then	    
        'Environment.Value("INDIVIDUAL_RUN") = true
		Set objFileToWrite = CreateObject("Scripting.FileSystemObject").CreateTextFile(Environment("HTMLRESULTS_PATH")&"\temp1.txt") 'environment variable
		objFileToWrite.Close
		Set objFileToWrite = Nothing
		InitializeReport
		ExecutionStartTime = now()
	End If
	
	
	Environment.Value("TestCaseName") = strOutTestName
	Environment.Value("LogFileName") = strOutLogFile
	'***************************************************************sudheer*************************************************
	Environment("HTMLRESULTS_PATH") = Environment.Value("PROJECT_FOLDER") & "\Reports"
	Dim arrFileLines()
	s = 0
	if Not fso.FileExists(Environment("HTMLRESULTS_PATH")&"\temp.txt") then
		InitializeReport = False
		Exit Function
	End if
	
	Set objLogFiles = fso.OpenTextFile(Environment("HTMLRESULTS_PATH")&"\temp.txt", 1) 'strOutLogsPath
	Do Until objLogFiles.AtEndOfStream
		Redim Preserve arrFileLines(s)
	 	arrFileLines(s) = objLogFiles.ReadLine
	 	s = s + 1
	Loop
	objLogFiles.Close
	ResultsFolder = arrFileLines(0)
	
	ResultsDBFile = ResultsFolder & "\TestResults.xls"

'	ResultsDBFile = Environment("HTMLRESULTS_PATH")
	Set DBConnection_Results = ConnectToExcel(ResultsDBFile,"YES")
	If Not DBConnection_Results.State = 1 Then
		InitializeReport = False
		Exit Function
	End If
	
	TestScriptName = strFullTestName	'ScriptName
	TestResult = "Passed"
	'start time of the script
	TestStartTime = Now
	'***************************************************************sudheer*************************************************
	On Error GoTo 0
	Set fso = Nothing
End Function

Function writeMemberIDToTestData(ByVal strMemberId, ByVal sheetName, ByVal columnName)
	'On Error Resume Next
	'Err.Clear

	writeMemberIDToTestData = false
	
	isPass = InitializeTestData
	If not isPass Then
		Call WriteToLog("Fail", "Failed to connect to test data file.")
		Exit Function
	End If
	
	Err.Clear
	
	Set objCommand = CreateObject("ADODB.Command") 
	Set objCommand.ActiveConnection = DBConnection_TestData
	
	objCommand.CommandText = "UPDATE [" & sheetName & "$] SET " & columnName & " = '" & strMemberId & "' WHERE TestCaseName = '" & sheetName & "' AND ExecutionFlag = 'Y'"
	objCommand.Execute , ,adCmdText
	Err.Clear
	
	DBConnection_TestData.Close
	Set DBConnection_TestData = Nothing
	
	writeMemberIDToTestData = true
End Function
