'**************************************************************************************************************************************************************************
' TestCase Name				: LabTask
' Purpose of TC				: Validate enrolled SNP patient's initial Lab task due (Initial LDL/Phosphorous/Albumin/A1C due task)
' Author               		: Gregory
' Date                 		: 9 October 2015
' Date Modified       		: 15 October 2015
' Environment				: QA/Train/Stage (url as described in Config file)
' Comments					: This script covers test case scenarios corresponding to userstories : B-04970,B-04973,B-04974 and certain scenarios of B-05059
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "LabTask", strOutTestName, strOutErrorDesc) 
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
strDomains = DataTable.Value("Domains","CurrentTestCaseData")
strTasks = DataTable.Value("Tasks","CurrentTestCaseData")
dtRequiredDrawDates = DataTable.Value("DrawDates","CurrentTestCaseData")
dtEnrolledDate = DataTable.Value("EnrolledDate","CurrentTestCaseData")
strPatientRecordCKDstage1_2_3 = DataTable.Value("PatientRecordCKDstage1_2_3","CurrentTestCaseData")
strEnrolledWithSNP = DataTable.Value("EnrolledWithSNP","CurrentTestCaseData")
strLabFieldsAndValues = DataTable.Value("LabFieldsAndValues","CurrentTestCaseData")
dtSpecificLabDates = DataTable.Value("SpecificLabDates","CurrentTestCaseData")

On Error Resume Next
arrDomains = Split(strDomains,",",-1,1)
arrTasks = Split(strTasks,",",-1,1)
arrRequiredDrawDates = Split(dtRequiredDrawDates,",",-1,1)
arrLabFieldsAndValues = Split(strLabFieldsAndValues,",",-1,1)
arrSpecificLabDates = Split(dtSpecificLabDates,",",-1,1)
Err.Clear

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

	If lcase(strPatientRecordCKDstage1_2_3) = "no" AND lcase(strEnrolledWithSNP) = "yes" AND EnrolledDateStatus <= 89 Then
	
		'Iterate through all tasks
		For iTsk = 1 To UBound(arrTasks)+1 Step 1
		
			strDomain = arrDomains(iTsk-1)
			strTask = arrTasks(iTsk-1)
			dtRequiredDrawDate = arrRequiredDrawDates(iTsk-1)
			strLabFieldAndValue = arrLabFieldsAndValues(iTsk-1)
			dtSpecificLabDate = arrSpecificLabDates(iTsk-1)	
		
			'Navigate to Menu of Actions > Required domain > select required task
			blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
			Wait 2		
			
				'Testcase: Verify if required task is created upon patient enrollment.       
				If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
					Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should be available under '"&strDomain&"' domain; Actual Result: "&strOutErrorDesc)
					Call Terminator
				ElseIf not blnDomainTasks Then
					Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
					Call Terminator
				End If
							
				'Testcase: Verify on clicking the specified task, user is navigated to 'Labs' screen. Also in lab screen, provide required lab value and save	
				blnProvideLabValues =  ProvideLabValue(dtRequiredDrawDate, strLabFieldAndValue, dtSpecificLabDate, strDipstick, strOutErrorDesc)		
				If Instr(1,strOutErrorDesc,"Lab screen is not available",1) > 0 Then
					Call WriteToLog("Fail", "Expected Result: User should be navigated to 'Labs' screen when clicked on '"&strTask&"'; Actual Result: "&strOutErrorDesc)
					Call Terminator
				ElseIf not blnProvideLabValues Then
					Call WriteToLog("Fail", "Expected Result: Should be able to provide lab value in lab screen; Actual Result: Unable to provide lab value: "&strOutErrorDesc)
					Call Terminator	
				End If
				Call WriteToLog("Pass", "Valiadted Lab screen navigation and new value entry")
				Wait 5
				
		Next
		
	End If	
	
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
	
	If lcase(strPatientRecordCKDstage1_2_3) = "no" AND lcase(strEnrolledWithSNP) = "yes" AND EnrolledDateStatus <= 89 Then
	
		For iTsk = 1 To UBound(arrTasks)+1 Step 1
		
			strDomain = arrDomains(iTsk-1)
			strTask = arrTasks(iTsk-1)
			dtRequiredDrawDate = arrRequiredDrawDates(iTsk-1)
			strLabFieldAndValue = arrLabFieldsAndValues(iTsk-1)
			dtSpecificLabDate = arrSpecificLabDates(iTsk-1)	
			
			'Testcase: Verify the task gets closed when user enters new lab value and saves in Labs screen 
			blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
			If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
				Call WriteToLog("Pass", "'"&strTask&"' task under '"&strDomain&"' domain got closed after providing required lab value as expected")
			ElseIf not blnDomainTasks Then
				Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
				Call Terminator	
			ElseIf blnDomainTasks Then
				Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task under '"&strDomain&"' domain should be closed after providing required lab value; Actual Result: '"&strTask&"' task is not closed")
				Call Terminator	
			End If
			Wait 5	
			
		Next	
	
	Else
		
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
