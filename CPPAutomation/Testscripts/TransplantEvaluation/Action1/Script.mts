 '**************************************************************************************************************************************************************************
' TestCase Name			: TransplantEvaluation
' Purpose of TC			: Validate Initial Transplant Evaluation due task for enrolled patient under SNP payor
' Author                : Gregory
' Date                  : October 2015
' Environment			: QA/Train/Stage (url as described in Config file)
' Comments				: This script covers test case scenarios corresponding to userstory : B-04980
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "TransplantEvaluation", strOutTestName, strOutErrorDesc) 
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

'------------------------
' Variable initialization
'------------------------
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
dtEnrolledDate = DataTable.Value("EnrolledDate","CurrentTestCaseData")
dtPathwayDt = DataTable.Value("PathwayDate","CurrentTestCaseData") 'SysDate
strDomain = DataTable.Value("Domain","CurrentTestCaseData")
strTask = DataTable.Value("Task","CurrentTestCaseData")
strDomainNameForScorecard = DataTable.Value("DomainNameForScorecard","CurrentTestCaseData")
strTaskNameForScorecard = DataTable.Value("TaskNameForScorecard","CurrentTestCaseData")
strTestAllFunctionalities = DataTable.Value("TestAllFunctionalities","CurrentTestCaseData")

Dim arrTE_AnsBook(12)
For i = 1 To 13 Step 1
	strAnswerOption = DataTable.Value("AnswerOption"&i,"CurrentTestCaseData")
	arrTE_AnsBook(i-1) = Replace(strAnswerOption,Left(strAnswerOption,(Instr(1,strAnswerOption,":",1))),"",1,-1,1)
Next

Dim arrDecidingAns(2)
arrDecidingAns(0) = arrTE_AnsBook(0) 'PatientOnRenalTransplantList
arrDecidingAns(1) = arrTE_AnsBook(3) 'ReferredForRenalTransplantation
arrDecidingAns(2) = arrTE_AnsBook(6) 'WasAssistanceProvided
'Note: Find details of 'arrAnswerBook array' and 'pathway deciding answers' extreme down

'Execution as required
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
	
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
		'Testcase: Verify if ‘Initial Transplant Evaluation pathway’ due task is created upon patient enrollment.        
		If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
			Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should be available under '"&strDomain&"' domain; Actual Result: "&strOutErrorDesc)
			Call Terminator
		ElseIf not blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
			Call Terminator	
		End If
				
		'Testcase: Verify upon clicking 'Initial Transplant Evaluation pathway' task would navigate to 'Transplant Evaluation’ screen. Also perform 'Transplant Evaluation pathway' and save.
		blnTransplantEvaluation = TransplantEvaluation(arrTE_AnsBook, arrDecidingAns, strTestAllFunctionalities, dtPathwayDt, strOutErrorDesc)
		If Instr(1,strOutErrorDesc,"Transplant Evaluation screen is not available",1) > 0 Then
			Call WriteToLog("Fail", "Expected Result: User should be navigated to 'Transplant Evaluation' screen when clicked on '"&strTask&"'; Actual Result: "&strOutErrorDesc)
			Call Terminator
		ElseIf not blnTransplantEvaluation Then
			Call WriteToLog("Fail", "Expected Result: Should be able to perform 'Transplant Evaluation pathway; Actual Result: Unable to perform 'Transplant Evaluation pathway': "&strOutErrorDesc)
			Call Terminator	
		End If
		Call WriteToLog("Pass", "Valiadted Transplant Evaluation pathway screen navigation and Transplant Evaluation pathway")
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
		
		'Testcase: Verify the task gets closed when user performs 'Transplant Evaluation' pathway
		blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
		If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
			Call WriteToLog("Pass", "'"&strTask&"' task under '"&strDomain&"' domain got closed after performing 'Transplant Evaluation pathway' as expected")
		ElseIf not blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
			Call Terminator	
		ElseIf blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task under '"&strDomain&"' domain should be closed after performing 'Transplant Evaluation pathway'; Actual Result: '"&strTask&"' task is not closed")
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


'''--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'''arrAnswerBook detail
'''(D) for pathway deciding answers
'''--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'''arrAnswerBook(0)	PatientOnRenalTransplantList	Y/N/Undecided		(D)
'''arrAnswerBook(1)	WhichTransplantList		Living/Non-living
'''arrAnswerBook(2)	NotOnRenalTransplantListBecause		Age,GFR,Medical Contraindication(Textbox available),Not Interested,Socio-economic Contraindication,Health Plan Approval Pending,Health Plan Denial,On Hold(Textbox available)		(Multi-selection available)
'''arrAnswerBook(3)	ReferredForRenalTransplantation		Y/N/NA		(D)
'''arrAnswerBook(4)	NotBeenReferredForReason		GFR/Medical Contraindication/Not Interested/Socio-economic Contraindication/Health Plan Approval Pending/Health Plan Denial/Pending Referral 
'''arrAnswerBook(5)	TransplantWorkInitiated		Y/N/NA 
'''arrAnswerBook(6)	WasAssistanceProvided	Y/N/NA	(D)
'''arrAnswerBook(7)	FollowingAssistanceWasProvided  	Referral for testing or screening,Referral for specialist,Referral for dental,Coordinate authorization/work-up,Other(Textbox available)		(Multi-selection available)
'''arrAnswerBook(8)	VerbalEducationProvided		Y/N/NA
'''arrAnswerBook(9)	SendWrittenMaterials	Y/N/NA
'''arrAnswerBook(10) Comments: any string value
'''arrAnswerBook(11) IncludePatientComment:Yes/No
'''arrAnswerBook(12) IncludeProviderComment:Yes/No
'''--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'''arrPathwayDecidingAnswers - Answers which decide the pathway flow (Is patient on a renal transplant list??,Has patient been referred for renal transplantation??,Was assistance provided in the work up process??)
'''--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


