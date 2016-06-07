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
lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")
strSNPpatientTest = DataTable.Value("SNPpatientTest","CurrentTestCaseData")
dtEnrolledDate = DataTable.Value("EnrolledDate","CurrentTestCaseData")
dtScreeningDt=DataTable.Value("ScreeningDate","CurrentTestCaseData")
dtScreeningDt = Split(dtScreeningDt," ",-1,1)(0)
dtCompletedDt=DataTable.Value("CompletedDate","CurrentTestCaseData")
dtCompletedDt = Split(dtCompletedDt," ",-1,1)(0)
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

'Login as eps and refer a new member.
'-----------------------------------------
'-------------------------------
'Close all open patients from DB
Call closePatientsFromDB("eps")
'-------------------------------

'Navigation: Login as eps > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("eps", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")											

'Create newpatient
strNewPatientDetails = CreateNewPatientFromEPS(strPersonalDetails,"NA","NA",strOutErrorDesc)
If strNewPatientDetails = "" Then
	Call WriteToLog("Fail","Expected Result: User should be able to create new SNP patient in EPS. Actual Result: Unable to  create new SNP patient in EPS."&strOutErrorDesc)
	Call Terminator											
End If

strPatientName = Split(strNewPatientDetails,"|",-1,1)(0)
lngMemberID = Split(strNewPatientDetails,"|",-1,1)(1)
strEligibilityStatus = Split(strNewPatientDetails,"|",-1,1)(2)

Call WriteToLog("Pass","Created new patient in EPS with name: '"&strPatientName&"', MemberID: '"&lngMemberID&"' and Eligibility status: '"&strEligibilityStatus&"'")	

strPatientFirstName = Split(strPatientName,", ",-1,1)(1)
strPatientSecondName = Split(strPatientName,", ",-1,1)(0)

'Logout
Call WriteToLog("Info","-------------------------------------Logout of application--------------------------------------")
Call Logout()
Wait 2

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster
'-------------------------------------------------------------------------------------------------------------------
'-------------------------------
'Close all open patients from DB
Call closePatientsFromDB("vhn")
'-------------------------------

'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")
	
If LCase(Trim(strSNPpatientTest)) = "yes" Then

	'Open required patient in assigned VHN user
	strGetAssingnedUserDashboard = GetAssingnedUserDashboard(lngMemberID, strOutErrorDesc)
	If strGetAssingnedUserDashboard = "" Then
		Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user.  Actual Result: Unable to open required patient in assigned VHN user."&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
	
Else
	
	'search patient through global search
	blnGlobalSearch = GlobalSearchUsingMemID(lngMemberID,strOutErrorDesc)
	If not blnGlobalSearch Then
		Call WriteToLog("Fail","Unable to open required patient through global search. "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Opened required patient through global search")
	
End If		

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientFirstName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")

If LCase(Trim(strSNPpatientTest)) = "yes" Then
	
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
		
		'Close patient record and re-open patient through global search (to get changes reflected)
		Call WriteToLog("Info","------Close patient record and re-open patient through global search------")
		blnClosePatientAndReopenThroughGlobalSearch = ClosePatientAndReopenThroughGlobalSearch(strPatientFirstName,lngMemberID,strOutErrorDesc)
		If not blnClosePatientAndReopenThroughGlobalSearch Then
			Call WriteToLog("Fail","Unable to close patient record and re-open patient through global search. "&strOutErrorDesc)
			Call Terminator
		End If
		Call WriteToLog("Pass","Closed patient record and re-opened patient through global search")
			
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

Else

		'Navigate to 'Fall Risk Assessment' screen, perform screening and save.
		blnClickedSubMenu = clickOnSubMenu_WE("Screenings->Home Safety Screening")
		If not blnClickedSubMenu Then
			Call WriteToLog("Fail", "Unable to click on sub menu 'Screenings->Home Safety Screening'. "&strOutErrorDesc)
			Call Terminator			
		End If		
							
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
