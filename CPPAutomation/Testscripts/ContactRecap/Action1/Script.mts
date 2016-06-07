' TestCase Name			: ContactRecap
' Purpose of TC			: To validate the contact methods
' Author                : Sudheer
' Comments				: 
'**************************************************************************************************************************************************************************
'***********************************************************************************************************************************************************************\
'Initialization steps for current script
'***********************************************************************************************************************************************************************
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file

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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Snippets", "Snippets", strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'***********************************************************************************************************************************************************************
'End of Initialization steps for the current script
'***********************************************************************************************************************************************************************
'=====================================
' Objects required for test execution
'=====================================
Function loadObjects()
End Function

Function killAllObjects()
End Function

'=====================================
'start test execution
'=====================================
Call WriteToLog("info", "Test case - Create a new patient using VHN role")
'Login to Capella as VHN
'isPass = Login("vhn")
'If not isPass Then
'	Call WriteToLog("Fail","Failed to Login to VHN role.")
'	Logout
'	CloseAllBrowsers
'	killAllObjects
'	Call WriteLogFooter()
'	ExitAction
'End If

Call WriteToLog("Pass","Successfully logged into VHN role")
Dim isRun
isRun = false
intRowCount = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCount step 1
	DataTable.SetCurrentRow(RowNumber)
	
'	runflag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
'	
'	If trim(lcase(runflag)) = "y" Then
'		'close all open patients
'		isRun = true
'		isPass = CloseAllOpenPatient(strOutErrorDesc)
'		If Not isPass Then
'			strOutErrorDesc = "Failed to close all patients."
'			Call WriteToLog("Fail", strOutErrorDesc)
'			Logout
'			CloseAllBrowsers
'			Call WriteLogFooter()
'			ExitAction
'		End If
'	
'		strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
'		isPass = selectPatientFromGlobalSearch(strMemberID)
'		If Not isPass Then
'			strOutErrorDesc = "Failed to select member from Global Search"
'			Call WriteToLog("Fail", strOutErrorDesc)
'			Logout
'			CloseAllBrowsers
'			Call WriteLogFooter()
'			ExitAction
'		End If
'		
'		'wait till the member loads
'		wait 2
'		waitTillLoads "Loading..."
'		wait 2
'		
'		Call WriteToLog("info", "Test Case - Validate Snippets for the member id - " & strMemberID)
		
		isPass = validateRecapContactScreen()
'		If Not isPass Then
'			Call WriteToLog("Fail", "Validate Snippets failed for the member - " & strMemberID )
'		Else
'			Call WriteToLog("Pass", "Validate Snippets succesfully completed for the member - " & strMemberID )
'		End If
'	End If	
Next

'If not isRun Then
'	Call WriteToLog("info", "There are No rows marked Y(Yes) for execution.")
'End If
'
'Logout
'CloseAllBrowsers
'WriteLogFooter

Function validateRecapContactScreen()
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("html id").Value = "Recap_ContactNote_.*"	'0_Textarea
	
	Set objTA = getPageObject().ChildObjects(oDesc)
	Print objTA.Count
	
	If Not objTA.Count > 0 Then
		Exit Function
	End If
	
	Set objContact = objTA(0)

End Function
