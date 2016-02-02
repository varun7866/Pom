'***********************************************************************************************************************************************************************
' TestCase Name				: AccessManagement
' Purpose of TC			    : This script covers only Access Information Tab
'							: This script is based on the SNPs Project covers only Access Information tab.
'							: Scenario 1 - Verify there is any Active Accees
'							  Scenario 2 - When there is a already an Active Access, User cannot add a new Access, it should thrown an error.
'							  Scenario 3 - Verify editing the Active Access to Termed
'							  Scenario 4 - Add New Access
'							  Scenario 5 - Verfiy the Access History for Newly added Access
'							  Scenario 6 - When user adds, more than 3 Inactive Access, it should display an error message. 
' Pre-requisites(if any)    : None
' Author                    : Sharmila
' Date                      : 29-JUL-2015
'***********************************************************************************************************************************************************************

''***********************************************************************************************************************************************************************
'Initialization steps for current script
''***********************************************************************************************************************************************************************
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

intWaitTime =Environment.Value("WaitTime") 

Set objFso = Nothing

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "AccessManagement", strOutTestName, strOutErrorDesc) 
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
'Variable Initialization
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData") 			'Fetch patient name from test data



'#################################################	Start: Test Case Execution	#################################################
'==========================================================================================================
'Login to Capella, verify the successful loading of the dashboard page and verify My Patient Census widget
'==========================================================================================================
Call WriteToLog("Info","==========Testcase - Login to Capella, verify the successful loading of the dashboard page and verify My Patient Census widget==========")


'Login to Capella

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.") 
	Call Logout()
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

'Close all open patient     
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Logout
	CloseAllBrowsers
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
'Open patient from global search
'==============================
Call WriteToLog("Info","==========Testcase - Open a patient from Global Search.==========")

strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	strOutErrorDesc = "Failed to select required member from Global Search"
	Call WriteToLog("Fail", strOutErrorDesc)
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

wait 2
waitTillLoads "Loading..."
wait 2
'=========================================================
'Select Access screen from the Clinical management menu
'=========================================================
Call clickOnSubMenu("Clinical Management->Access")

wait intWaitTime/4
waitTillLoads "Loading..."
wait 2

'===========================================================================================
' Call the function AccessInformation, which does all the validation for adding the Access. 
' All the function are located at the Library --> Generic Functions
'===========================================================================================
blnReturnValue = AccessInformation(strOutErrorDesc)
If not blnReturnValue Then
	Call WriteToLog("Fail","Failed to verify Access Management functionalities")
	Call Logout()
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Expected Result:Access Management functionalities were verified successfully")


'=================================
'Logout from Capella Application
'=================================
Call Logout()
CloseAllBrowsers


'============================
'Summarize execution status
'============================
Call WriteLogFooter()

