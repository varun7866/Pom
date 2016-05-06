' TestCase Name			: Patient_Assessment
' Purpose of TC			: To verify all the functionality of the Patinet Assessment screen.
' Author                : Harshida
' Comments				: Script will be modified as per user story change.
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Patient_Assessment", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

''****************************************************************************************************************************
'End of Initialization steps for the current script
''****************************************************************************************************************************

'=========================
' Variable initialization
'=========================

strFilePath = Environment.Value("PROJECT_FOLDER")&"\Testdata\ManageDocuments"
strMember = DataTable.Value("MemberID", "CurrentTestCaseData")

Dim intWaitTime
intWaitTime = getConfigFileValue("WaitTime")



Set objFso = CreateObject("Scripting.FileSystemObject")
consentsLibFolder = Environment.Value("PROJECT_FOLDER") & "\Library\SNP_functions"
For each objFile in objFso.GetFolder(consentsLibFolder).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" Then
		LoadFunctionLibrary objFile.Path
	End If
Next
Set objFso = Nothing



''==================================
''Login to Capella as VHN
''===================================
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'''==============================
'''Open patient from action item
'''==============================
strMember = DataTable.Value("MemberID","CurrentTestCaseData")
isPass = selectPatientFromGlobalSearch(strMember)
'isPass = selectPatientFromGlobalSearch("145137")
If Not isPass Then
	Call WriteToLog("Fail", "Failed to open member " & strMember & " from global search.")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")
strMemberID = strMember


Call patientassessment() 



'=========================================
'Logout of the application'
'=========================================
wait 10
Call Logout()
CloseAllBrowsers

Call WriteLogFooter()
