 '**************************************************************************************************************************************************************************
' TestCase Name				: FallRiskAssessment
' Purpose of TC				: Validate Initial Fall Risk due task for enrolled patient under SNP payor
' Author               		: Gregory
' Date                 		: 18 September 2015
' Date Modified       		: October 2015
' Environment				: QA/Train/Stage (url as described in Config file)
' Comments					: This script covers test case scenarios corresponding to userstory : B-04978
'**************************************************************************************************************************************************************************
'--------------
'Initialization
'--------------
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "FallRiskAssessment", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Load SNP library
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

'------------------------
' Variable initialization
'------------------------
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
dtEnrolledDate = DataTable.Value("EnrolledDate","CurrentTestCaseData")
dtScreeningDt = DataTable.Value("ScreeningDate","CurrentTestCaseData") 
dtCompletedDt = DataTable.Value("CompletedDate","CurrentTestCaseData")  
strDomain = DataTable.Value("Domain","CurrentTestCaseData")
strTask = DataTable.Value("Task","CurrentTestCaseData")
strTestAllFunctionalities = DataTable.Value("TestAllFunctionalities","CurrentTestCaseData") 

Dim arrAnswerOption(4)
For intFRA = 1 To 5 Step 1
	arrAnswerOption(intFRA-1) = DataTable.Value("AnswerOption"&intFRA, "CurrentTestCaseData")
Next

'Execution as required
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'-------------------------------Execution------------------------------------
On Error Resume Next
Err.Clear

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
	Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user.  Actual Result: Unable to open required patient in assigned VHN user."&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
Wait 2

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")
Wait 2

'Check whether Enrolled date is <=89 OR >=90
EnrolledDateStatus = DateDiff("d",CDate(dtEnrolledDate),Date)

'Navigate to Menu of Actions > Required domain > select required task
blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
Wait 2

If EnrolledDateStatus <= 89 Then
	'Testcase: Verify if required task is created upon patient enrollment.       
	If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
		Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should be available under '"&strDomain&"' domain; Actual Result: "&strOutErrorDesc)
		Call Terminator
	ElseIf not blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
		Call Terminator	
	End If
	
	'Testcase: Verify upon clicking ‘Initial Fall Risk Screening’ task would navigate to ‘Fall Risk Assessment’ screen. Also perform 'Fall Risk Assessment screening and save.
	blnFallRiskAssessmentScreening = FallRiskAssessmentScreening(dtScreeningDt, dtCompletedDt, arrAnswerOption, strTestAllFunctionalities, strOutErrorDesc)
	If Instr(1,strOutErrorDesc,"Fall Risk Assessment screen is not available",1) > 0 Then
		Call WriteToLog("Fail", "Expected Result: User should be navigated to 'Fall Risk Assessment' screen when clicked on '"&strTask&"'; Actual Result: "&strOutErrorDesc)
		Call Terminator
	ElseIf not blnFallRiskAssessmentScreening Then
		Call WriteToLog("Fail", "Expected Result: Should be able to perform 'Fall Risk Assessment screening; Actual Result: Unable to perform 'Fall Risk Assessment' screening: "&strOutErrorDesc)
		Call Terminator		
	End If
	Call WriteToLog("Pass", "Validated Fall Risk Assessment screen navigation and Fall Risk Assessment screening")
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
		Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user.  Actual Result: Unable to open required patient in assigned VHN user."&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
	Wait 2
	
	'Handle navigation error if exists
	blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
	If not blnHandleWrongDashboardNavigation Then
	    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
	End If
	Call WriteToLog("Pass","Provided proper navigation after patient selection")
	Wait 2
'--------------------------------------------

	'Testcase: Verify the task gets closed when user performs 'Fall Risk Assessment' screening
	blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
	If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
		Call WriteToLog("Pass", "'"&strTask&"' task under '"&strDomain&"' domain got closed after performing 'Fall Risk Assessment' screening as expected")
	ElseIf not blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
		Call Terminator
	ElseIf blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task under '"&strDomain&"' domain should be closed after performing 'Fall Risk Assessment' screening; Actual Result: '"&strTask&"' task is not closed")
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
