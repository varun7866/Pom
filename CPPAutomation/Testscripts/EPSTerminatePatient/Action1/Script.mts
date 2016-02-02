'**************************************************************************************************************************************************************************
' TestCase Name			: EPS_Terminate Patient
' Purpose of TC			: Login as EPS and search for any member and Terminate the member. (Based on the story - B-05176)
'						: B-05176: A new value of "Transition without Program" under the drop down field labeled as Detail after selecting Reason of "Not Eligible for Program" in Terminate Patient window
' Author                : Sharmila
' Date					: 12-Aug-2015
' Comments				: This script can be used to Terminate N number of patients.
'**************************************************************************************************************************************************************************

'***********************************************************************************************************************************************************************
'Initialization steps for current script
''***********************************************************************************************************************************************************************
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file
'Environment.LoadFromFile "C:\Project_Management\2.Automation\workflow_automation\Configuration\DaVita-Capella_Configuration.xml",True 
'MsgBox Environment.ExternalFileName
'load all functional libraries
functionalLibFolder = Environment.Value("PROJECT_FOLDER") & "\Library\generic_functions"
For each objFile in objFso.GetFolder(functionalLibFolder).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" Then
		LoadFunctionLibrary objFile.Path
	End If
Next

Set objFso = Nothing

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "EPSTerminatePatient", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

''***********************************************************************************************************************************************************************
'End of Initialization steps for the current script
''***********************************************************************************************************************************************************************
'=====================================
' start test execution
'=====================================
'Login to Capella
Call WriteToLog("Info","==========Testcase - Login to Capella as EPS User.==========")

isPass = Login("eps")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to EPS role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into EPS role")

'Close all open patient     
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", "Expected Result: Close all the open patients; Actual Result: "&strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

''====================================================
' Starting to read each row from the Test Date file.
'=====================================================
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout step 1
	DataTable.SetCurrentRow(RowNumber)
	
	strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
	strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData") 
	
	'only if the execution flag is set as Y, continue terminating the patient else move to next patient in the row.
	If Lcase(strExecutionFlag) = "y" Then
		Call WriteToLog("Info","==========Testcase - Terminating patient with Member ID: " &strMemberID& "==========")
	
		isPass = TerminatePatient(strMemberID)
		
		If not isPass Then
			Call WriteToLog("Fail", "Failed to terminate the patient")
			call logout()
			CloseAllBrowsers
			Call WriteLogFooter()
			ExitAction
		End If
		
		'Close all open patient     
		isPass = CloseAllOpenPatient(strOutErrorDesc)
		If Not isPass Then
			strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
			Call WriteToLog("Fail", "Expected Result: Close all the open patients; Actual Result: "&strOutErrorDesc)
			Call WriteLogFooter()
			ExitAction
		End If
	End If 
Next

logout
CloseAllBrowsers
Call WriteLogFooter()

