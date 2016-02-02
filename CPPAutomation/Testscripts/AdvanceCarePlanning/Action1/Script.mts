'**************************************************************************************************************************************************************************
' TestCase Name			: AdvanceCarePlanning
' Purpose of TC			: Validate Initial Advance Care Plan due task for enrolled patient under SNP payor
' Author                : Amar
' Date                  : 12 October 2015
' Environment			: QA/Train/Stage (url as described in Config file)
' Comments				: This script covers test case scenarios corresponding to userstory : B-04977
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "AdvanceCarePlanning", strOutTestName, strOutErrorDesc) 
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
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)
	
' VARIABLE initialization
'========================
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
dtPathwayDt = DataTable.Value("PathwayDate","CurrentTestCaseData") 'SysDate
dtEnrolledDate = DataTable.Value("EnrolledDate","CurrentTestCaseData")
strDomain = DataTable.Value("Domain","CurrentTestCaseData")
strTask = DataTable.Value("Task","CurrentTestCaseData")
strDomainNameForScorecard = DataTable.Value("DomainNameForScorecard","CurrentTestCaseData")
strTaskNameForScorecard = DataTable.Value("TaskNameForScorecard","CurrentTestCaseData")
strTestAllFunctionalities = DataTable.Value("TestAllFunctionalities","CurrentTestCaseData")

Dim arrACS_AnsBook(11)
For i = 1 To 12 Step 1
	strAnswerOption = DataTable.Value("AnswerOption"&i,"CurrentTestCaseData")
	arrACS_AnsBook(i-1) = Replace(strAnswerOption,Left(strAnswerOption,(Instr(1,strAnswerOption,":",1))),"",1,-1,1)
Next
 
'Execution as required
If not Lcase(strExecutionFlag) = "y" Then Exit Do
Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"'----------------") 
'On Error Resume Next
Err.Clear
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

	'-------------------------------------------------------------------------------------------------------------------
	'Navigate to Menu of Actions > Cardiovascular domain > LDL Due task > Enter new LDL value and save in Labs screen 
	'-------------------------------------------------------------------------------------------------------------------
	blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
	Wait 2

	If EnrolledDateStatus <= 89 Then
	
		'Testcase:Verify if ‘Initial Advanced Care Plan’ due task is created upon patient enrollment.
		If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
			Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should be available under '"&strDomain&"' domain; Actual Result: "&strOutErrorDesc)
			Call Terminator
		ElseIf not blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
			Call Terminator	
		End If
			Call WriteToLog("Pass", "'"&strTask&"' task is available under '"&strDomain&"' domain as expected")
	
		'Testcase: Verify upon clicking 'Initial Advanced Care Plan' due task would navigate to 'Advanced Care Plan’ screen. Also perform 'Advanced Care Plan pathway' and save.
		blnAdvanceCarePlanning = AdvanceCarePlanning(arrACS_AnsBook, arrDecidingAns, strTestAllFunctionalities, dtPathwayDt, strOutErrorDesc)
		If Instr(1,strOutErrorDesc,"Advanced Care Plan screen is not available",1) > 0 Then
			Call WriteToLog("Fail", "Expected Result: User should be navigated to 'Advanced Care Plan' screen when clicked on '"&strTask&"'; Actual Result: "&strOutErrorDesc)
			Call Terminator
		ElseIf not blnAdvanceCarePlanning Then
			Call WriteToLog("Fail", "Expected Result: Should be able to perform 'Advanced Care Plan pathway; Actual Result: Unable to perform 'Advanced Care Plan pathway': "&strOutErrorDesc)
			Call Terminator		
		End If
		Call WriteToLog("Pass", "Valiadted Advanced Care Plan pathway screen navigation and Advanced Care Plan pathway")
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
		
		'Testcase: Verify the task gets closed when user performs 'Advanced Care Plan' pathway
		blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
		If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
			Call WriteToLog("Pass", "'"&strTask&"' task under '"&strDomain&"' domain got closed after performing 'Advanced Care Plan pathway' as expected")
		ElseIf not blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
			Call Terminator	
		ElseIf blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task under '"&strDomain&"' domain should be closed after performing 'Advanced Care Plan pathway'; Actual Result: '"&strTask&"' task is not closed")
			Call Terminator		
		End If

	ElseIf EnrolledDateStatus >= 90 Then

		If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
			Call WriteToLog("Pass", "'"&strTask&"' task is not displayed under '"&strDomain&"' domain as patient is having EnrollmentDate >=90 prior sysdate")
		ElseIf not blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
			Call Terminator	
		ElseIf blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should not be displayed under '"&strDomain&"' domain as patient is having EnrollmentDate >=90 prior sysdate; Actual Result: '"&strTask&"' task is displayed under '"&strDomain&"' domain")
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



