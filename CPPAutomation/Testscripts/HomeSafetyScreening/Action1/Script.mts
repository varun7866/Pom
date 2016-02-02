'**************************************************************************************************************************************************************************
' TestCase Name				: HomeSafetyScreening
' Purpose of TC				: Validate Initial Home Safety Screening due task for enrolled patient under SNP payor
' Author               		: Amar
' Date                 		: 12 September 2015
' Environment				: QA/Train/Stage (url as described in Config file)
' Comments					: This script covers test case scenarios corresponding to userstory : B-04979
'**************************************************************************************************************************************************************************
'==============
'INITIALIZATION
'==============
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file
functionalLibFolder = Environment.Value("PROJECT_FOLDER") & "\Library\generic_functions"
For each objFile in objFso.GetFolder(functionalLibFolder).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" Then
		LoadFunctionLibrary objFile.Path
	End If
Next

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "HomeSafetyScreening", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Set objFso = CreateObject("Scripting.FileSystemObject")
SNP_Library = Environment.Value("PROJECT_FOLDER") & "\Library\SNP_functions"
For each SNPlibfile in objFso.GetFolder(SNP_Library).Files
	If UCase(objFso.GetExtensionName(SNPlibfile.Name)) = "VBS" Then
		LoadFunctionLibrary SNPlibfile.Path
	End If
Next
Set objFso = Nothing

'Get all required scenarios
intRowCount = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCount: Do
	DataTable.SetCurrentRow(RowNumber)

'========================
' VARIABLE initialization
'========================
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
dtEnrolledDate = DataTable.Value("EnrolledDate","CurrentTestCaseData")
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
dtScreeningDt=DataTable.Value("ScreeningDate","CurrentTestCaseData")
dtCompletedDt=DataTable.Value("CompletedDate","CurrentTestCaseData")
strDomain = DataTable.Value("Domain","CurrentTestCaseData")
strTask = DataTable.Value("Task","CurrentTestCaseData")
strTestAllFunctionalities=DataTable.Value("TestAllFunctionalities","CurrentTestCaseData")
strPatientRecordCKDstage1_2_3 = DataTable.Value("PatientRecordCKDstage1_2_3","CurrentTestCaseData")
strEnrolledWithSNP = DataTable.Value("EnrolledWithSNP","CurrentTestCaseData")

Dim arrAnswerOption(14)
For intHSS = 1 To 14 Step 1
	strAnswerOption = DataTable.Value("AnswerOption"&intHSS,"CurrentTestCaseData")
	arrAnswerOption(intHSS-1) =Replace(strAnswerOption,Left(strAnswerOption,(Instr(1,strAnswerOption,":",1))),"",1,-1,1)
Next

'Execution as required
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'-------------------------------Execution------------------------------------
Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"'----------------") 
On Error Resume Next
Err.Clear
wait 1

'-------------------------------------------------------------------------------------------------------------------
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster
'-------------------------------------------------------------------------------------------------------------------
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")
	
'Open required patient in assigned VHN user
strGetAssingnedUserDashboard = GetAssingnedUserDashboard(lngMemberID, strOutErrorDesc)
If strGetAssingnedUserDashboard = "" Then
	Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
Wait 2
	
'Check whether Enrolled date is <=89 OR >=90
EnrolledDateStatus = DateDiff("d",CDate(dtEnrolledDate),Date)
'
''Navigate to Menu of Actions > Required domain > select required task
blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
Wait 2

If lcase(strPatientRecordCKDstage1_2_3) = "no" AND lcase(strEnrolledWithSNP) = "yes" AND EnrolledDateStatus <= 89 Then
	'Testcase: Verify if required task is created upon patient enrollment.       
	If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
		Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should be available under '"&strDomain&"' domain; Actual Result: "&strOutErrorDesc)
		Call Terminator
	ElseIf not blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
		Call Terminator	
	End If
	Call WriteToLog("Pass", "'"&strTask&"' task is available under '"&strDomain&"' domain as expected")

	'Testcase: Verify upon clicking ‘Initial Home Safety Screening’ task would navigate to ‘Initial Home Safety Screening’ screen. Also perform 'Initial Home Safety Screening and save'.
	blnHomeSafetyScreening = HomeSafetyScreening(dtScreeningDt,dtCompletedDt,arrAnswerOption,strTestAllFunctionalities,strOutErrorDesc)
	If Instr(1,strOutErrorDesc,"Home Safety Screening screen is not available",1) > 0 Then
		Call WriteToLog("Fail", "Expected Result: User should be navigated to 'Home Safety Screening' screen when clicked on '"&strTask&"'; Actual Result: "&strOutErrorDesc)
		Call Terminator
	ElseIf not blnHomeSafetyScreening Then
		Call WriteToLog("Fail", "Expected Result: Should be able to perform 'Home Safety Screening; Actual Result: Unable to perform 'Home Safety Screening: "&strOutErrorDesc)
		Call Terminator		
	End If
	Call WriteToLog("Pass", "Validated Home Safety Screening screen navigation and Home Safety Screening")
	Wait 2
	
	'--------------------------------------------
	'Logout and login  for changes to happen	
	Call WriteToLog("Info","-------------------Logout of application-------------------")
	Call Logout()
	Wait 2
		
	'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("vhn", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")
		
	'Open required patient in assigned VHN user
	strGetAssingnedUserDashboard = GetAssingnedUserDashboard(lngMemberID, strOutErrorDesc)
	If strGetAssingnedUserDashboard = "" Then
		Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user. "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
	Wait 2
		
	'Testcase: Verify the task gets closed when user performs 'Home Safety Screening' 
	blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
	If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
		Call WriteToLog("Pass", "'"&strTask&"' task under '"&strDomain&"' domain got closed after performing 'Home Safety Screening' as expected")
	ElseIf not blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
		Call Terminator	
	ElseIf blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task under '"&strDomain&"' domain should be closed after performing 'Home Safety Screening'; Actual Result: '"&strTask&"' task is not closed")
		Call Terminator		
	End If

ElseIf EnrolledDateStatus >= 90 Then

	If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
		Call WriteToLog("Pass", "'"&strTask&"' task is not displayed under '"&strDomain&"' domain as patient is having record as CKDStage1 or CKDStage2 or CKDStage3 / EnrollmentDate >=90 prior sysdate / not having SNP payor")
	ElseIf not blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
		Call Terminator	
	ElseIf blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should not be displayed under '"&strDomain&"' domain as patient is having record as CKDStage1 or CKDStage2 or CKDStage3 / EnrollmentDate >=90 prior sysdate / not having SNP payor; Actual Result: '"&strTask&"' task is displayed under '"&strDomain&"' domain")
		Call Terminator		
	End If

End If

'logout of the application
Call WriteToLog("Info","-------------------Logout of application-------------------")
Call Logout()
Wait 2

'Iteration loop
Loop While False: Next
wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function


