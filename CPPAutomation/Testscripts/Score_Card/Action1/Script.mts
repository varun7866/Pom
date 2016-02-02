'**************************************************************************************************************************************************************************
' TestCase Name			: Score Card
' Purpose of TC			: To verify all the domains Hospitalization, Access, ACP, Fluid Management, Medication, CardioVascular, Diabetes, Depression, Transplant, Immunizations, Health Maintenance, General Program exist as required.
' Author                : Sudheer
' Comments				: 
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ScoreCard", strOutTestName, strOutErrorDesc) 
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

''=========================
'' Variable initialization
''=========================
strMemberID = DataTable.Value("MemberID", "CurrentTestCaseData")
strDomainNames = DataTable.Value("DomainList", "CurrentTestCaseData")
''=====================================
'' start test execution
''=====================================
'Login to Capella

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")
'
''Close all open patient     
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'Select user roster
isPass = SelectUserRoster(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'==============================
'Open patient from action item
'==============================

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "Unable to open patient " & strPatientName)
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

Call clickOnSubMenu("Patient Snapshot")
wait 2
Call waitTillLoads("Loading...")

Dim domains
domains = Split(strDomainNames, ";")

If IsArrayEmpty(domains) Then
	Call WriteToLog("Fail", "No domain names are specified in the test data.")
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
End If

'==========================================
'Test case - validate domain exists
'==========================================
For i = 0 To UBound(domains) Step 1
	Call WriteToLog("info", "Test Case - Validate '" & domains(i) & "' Domain should exist")

	isPass = isDomainExist(trim(domains(i)))
	If not isPass Then
		Call WriteToLog("Fail", "'" & domains(i) & "' domain does not exist as required.")
	End If
	
	Call WriteToLog("Pass", "'" & domains(i) & "' domain exists as required.")
Next

Logout
CloseAllBrowsers
WriteLogFooter
