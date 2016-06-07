 '**************************************************************************************************************************************************************************
' TestCase Name			: PatientInitialTasks
'''''''''''''''' Purpose of TC			: Validate SNP patient enrollment, eligibility status validation at adding new contact and also at initial IPE tasks completion
' Author                : Gregory
' Date                  : 13 November 2015
' Environment			: QA/Train/Stage (url as described in Config file)
' Comments				: This script covers test case scenarios corresponding to userstory : B-04869
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PatientInitialTasks", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Get all required scenarios
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)

'------------------------
' Variable initialization
'------------------------
On Error Resume Next
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
'patient details
	strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")
	lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
	strMedicalDetails = DataTable.Value("MedicalDetails","CurrentTestCaseData")
'Doamin and Tasks values
	'IPE
	strDomain = DataTable.Value("Domain","CurrentTestCaseData")
	strIPEtasks = DataTable.Value("IPEtasks","CurrentTestCaseData")
	arrIPEtasks = Split(strIPEtasks,"|",-1,1)
	'HRA
	strHRATasks = DataTable.Value("HRAtasks","CurrentTestCaseData")
	arrHRATasks = Split(strHRATasks,"|",-1,1)
'Medication Task values
	strMedicationDetails = DataTable.Value("MedicationDetails","CurrentTestCaseData")
	arrMedicationDetails = Split(strMedicationDetails,",",-1,1)
	strLabel = arrMedicationDetails(0)
	dtWrittenDt = arrMedicationDetails(1)
	dtFilledDt = arrMedicationDetails(2)
	strFrequency = arrMedicationDetails(3)
'Allergy Task values
	strReqdAllergy = DataTable.Value("AllergyValue","CurrentTestCaseData")
'IPE Baseline Task values
	strPatientAssessmentBaseLineDetails = DataTable.Value("PatientAssessmentBaseLineDetails","CurrentTestCaseData")
	arrPatientAssessmentBaseLineDetails = Split(strPatientAssessmentBaseLineDetails,",",-1,1)
	dtFirstDialysisDate = arrPatientAssessmentBaseLineDetails(0)
	strFirstDialysisValue = arrPatientAssessmentBaseLineDetails(1)
	dtFirstChronicDlysDate = arrPatientAssessmentBaseLineDetails(2)
	strPrCausesOfRenalDisease = arrPatientAssessmentBaseLineDetails(3)
	strHearingImpair = arrPatientAssessmentBaseLineDetails(4)
	strVisionImpair = arrPatientAssessmentBaseLineDetails(5)
'Access Information Task values
	strAccessInformation = DataTable.Value("AccessInformation","CurrentTestCaseData")
	arrAccessInformation = Split(strAccessInformation,",",-1,1)
	strAccessType = arrAccessInformation(0)
	dtPlacedDate = arrAccessInformation(1)
	strAccessStatus = arrAccessInformation(2)
	dtDateActivated = arrAccessInformation(3)
	strTerminateReason = arrAccessInformation(4)
	strSide = arrAccessInformation(5)
	strRegion = arrAccessInformation(6)
	strExtremity = arrAccessInformation(7)
'Contact details
	strContactDetails = DataTable.Value("ContactDetails","CurrentTestCaseData")
	arrContactDetails = Split(strContactDetails,"|",-1,1)
	strContact = arrContactDetails(0)
	dtContactDt = arrContactDetails(1)
	strContactScores = arrContactDetails(2)
	strContactTeams = arrContactDetails(3)
	strContactResolution = arrContactDetails(4)
	strRequiredNote = arrContactDetails(5)
'Cognitive screening details
	strCogScrAns = DataTable.Value("CognitiveScreeningAnswers","CurrentTestCaseData")
'Pain Assessment details	
	strPainAssessmentAnswers = DataTable.Value("PainAssessmentAnswers","CurrentTestCaseData")
'ADL screening details
	strADLscreeningAnswers = DataTable.Value("ADLscreeningAnswers","CurrentTestCaseData") 
'Depression screening details
	strDepressionScreeningAnswers = DataTable.Value("DepressionScreeningAnswers","CurrentTestCaseData")
	strPatientRefusedSurvey = DataTable.Value("PatientRefusedDepressionScreening","CurrentTestCaseData")
'Comorbid details
	strComorbidDetails = DataTable.Value("ComorbidDetails","CurrentTestCaseData")
	arrComorbidDetails = Split(strComorbidDetails,"|",-1,1)
	dtDateReported = arrComorbidDetails(0)
	strReqdComorbidType = arrComorbidDetails(1)
Err.clear

'----------------------------------
'Object required for test execution
'----------------------------------
Execute "Set objDashboard ="&Environment("WL_Dashboard")

'Execution as required
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'
'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
	
	On Error Resume Next
	Err.Clear	
	
	'-----------------------------------------
	'*Login as EPS and refer a new SNP member.
	'-----------------------------------------
	
	'-------------------------------
	'Close all open patients from DB
	Call closePatientsFromDB("eps")
	'-------------------------------

	'Navigation: Login to EPS > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("eps", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")	

	'Create newpatient
	strNewPatientDetails = ""
	strNewPatientDetails = CreateNewPatientFromEPS(strPersonalDetails,"NA",strMedicalDetails,strOutErrorDesc)
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
	

	'-------------------------------------------------------
	'*Validate eligility status of newly created SNP patient
	'-------------------------------------------------------
	strSearchRequired = "no"
	strPatientEligibilityStatus = PatientEligibilityStatus(lngMemberID,strSearchRequired, strOutErrorDesc)
	If strPatientEligibilityStatus = "" Then
		Call WriteToLog("Fail","Expected Result: Patient Eligibility Status should be retrieved. Actual Result: Unable retrieve Eligibility Status."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Patient Eligibility Status is retrieved")	
			
	'validate eligibility status (enrolled)
	If Instr(1,strPatientEligibilityStatus,"Enrolled",1) <= 0 Then
		Call WriteToLog("Fail","Expected Result: Newly created SNP patient eligibility status should be 'Enrolled'. Actual Result: Available Eligibility Status is "&strPatientEligibilityStatus)
		Call Terminator	
	End If
	Call WriteToLog("Pass","Newly created SNP patient eligibility status is 'Enrolled'")	
	
	'----------------
	'log out from eps
	Call Logout()
	Wait 2	
	'----------------

	'-----------------------------------------------------------------------------
	'*Login as VHN and open the newly created patient in assigned VHN's dashboard
	'-----------------------------------------------------------------------------
	
	'-------------------------------
	'Close all open patients from DB
	Call closePatientsFromDB("vhn")
	'-------------------------------

	'Navigation: Login to VHN > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("vhn", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")

	'Open required patient in assigned VHN user of new SNP patient
	strAssingnedUser = GetAssingnedUserDashboard(lngMemberID, strOutErrorDesc)
	If strAssingnedUser = "" Then
		Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user.  Actual Result: Unable to open required patient in assigned VHN user."&strOutErrorDesc)
		Call Terminator
	End If
	strReqdProvider = strAssingnedUser
	Call WriteToLog("Pass","Opened required patient in assigned VHN user")
	Wait 2
	
	'------------------------------------
	'*Validate color codes in ActionItems
	'------------------------------------
	'Click on assigned user's dashboard
	Err.Clear
	objDashboard.click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Expected Result: User should be able to click dashboard.  Actual Result: Unable to click dashboard. "&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Clicked on dashboard")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Get required date range
	strDateRange = "Custom"
	dtCustom_From = "NA"
	dtCustom_To = DateAdd("d",90,Date)
	blnActionItemDateRange = ActionItemDateRange(strDateRange, dtCustom_From, dtCustom_To, strOutErrorDesc)
	If not blnActionItemDateRange Then
		Call WriteToLog("Fail","Expected Result: User should be able to select required date range.  Actual Result: Unable to select required date range: "&strOutErrorDesc)
		Call Terminator		
	End If
	Call WriteToLog("Pass","Required date range is selected")
	wait 1
	
	'Get task border color
	strBorderColor = ActionItemTaskBorderColor(strPatientFirstName, strOutErrorDesc)
	If strBorderColor = "" Then
		Call WriteToLog("Fail","Expected Result: Available border color should be as per task duedate.  Actual Result: "&strOutErrorDesc)
		Call Terminator		
	End If
	Call WriteToLog("Pass","Border color is "&strBorderColor&" be as per task duedate")
	Wait 1
	
	'Get task icon color
	strTaskIconColor = ActionItemTaskIconColor(strPatientFirstName, "Initial HRA Due", strOutErrorDesc)
	If strTaskIconColor = "" Then
		Call WriteToLog("Fail","Expected Result: Available task icon color should be as per task duedate.  Actual Result: "&strOutErrorDesc)
		Call Terminator		
	End If
	Call WriteToLog("Pass","Task icon color is "&strTaskIconColor&" be as per task duedate")
	Wait 1
	
	'Get task due date from UI
	dtDueDate = getDueDateOfTaskinActionItemsList(strPatientFirstName, "Initial HRA Due")
	If LCase(dtDueDate) = "na" Then
		Call WriteToLog("Fail","Expected Result:Should be able to retrieve Initial HRA Task due date from ActionItems.  Actual Result:Unable to retrieve Initial HRA Task due date from ActionItems")
		Call Terminator	
	End If	
	
	'Validate Initial HRA task due
	dtDaysForDue = DateDiff("d",Date,CDate(dtDueDate))
	If dtDaysForDue = 30 Then
		Call WriteToLog("Pass", "'Initial Health Risk Assessment' task due date is 30 days from enrolled date as expected")
	Else
		Call WriteToLog("Fail","Expected Result: Initial HRA Task should be created with 30 days due. Actual Result: HRA task due date availed is '"&dtDueDate&"'")
		Call Terminator
	End If
	Wait 1
	
	'Validating Action Items color legends for Initial HRA tasks against duedate
	If dtDaysForDue = 0 Then 'Initial HRA DueDate = sys date --> red border and red task button
		If Instr(1,strBorderColor,"red",1) > 0 AND Instr(1,strTaskIconColor,"red",1) > 0 Then
			Call WriteToLog("Pass","Action Items HRA task border color is 'red' as task duedate is equal to sys date")
			Call WriteToLog("Pass","Action Items HRA task icon color is 'red' as HRA task duedate is equal to sys date")
		End If
	ElseIf dtDaysForDue <= 7 Then 'Initial HRA DueDate = sys date+(7days or less than 7 days)  --> yellow border and yellow task button
		If Instr(1,strBorderColor,"yellow",1) > 0 AND Instr(1,strTaskIconColor,"yellow",1) > 0 Then
			Call WriteToLog("Pass","Action Items HRA task border color is 'yellow' as task duedate is equal to sys date")
			Call WriteToLog("Pass","Action Items HRA task icon color is 'yellow' as task duedate is <= 7 days from sys date")
		End If
	ElseIf dtDaysForDue >= 8 Then 'Initial HRA DueDate = sys date+(8days or more than 8 days) --> green border and green task button
		If Instr(1,strBorderColor,"green",1) > 0 AND Instr(1,strTaskIconColor,"green",1) > 0 Then
			Call WriteToLog("Pass","Action Items HRA task border color is 'green' as task duedate is equal to sys date")
			Call WriteToLog("Pass","Action Items HRA task icon color is 'green' as task duedate is >= 8 days from sys date")
		End If
	ElseIf dtDaysForDue < 0 Then 'Initial HRA DueDate < sys date --> red border and orange (alert) task button
		If Instr(1,strBorderColor,"red",1) > 0 AND Instr(1,strTaskIconColor,"orange",1) > 0 Then  
			Call WriteToLog("Pass","Action Items HRA task border color is 'red' as task duedate is equal to sys date")
			Call WriteToLog("Pass","Action Items HRA task icon color is 'orange' as task is overdue")
		End If
	Else
		Call WriteToLog("Fail","Expected Result: Initial HRA Task should be available with required color codes. Actual Result: HRA task is not with required color codes")
		Call Terminator
	End If

	'Select patient from ActionItems
	blnSelectPatientFromActionItems = SelectPatientFromActionItems(strPatientFirstName, strOutErrorDesc)
	If not blnSelectPatientFromActionItems Then
		Call WriteToLog("Fail","Expected Result: Should be able to select patient from ActionItems.  Actual Result: "&strOutErrorDesc)
		Call Terminator		
	End If
	Call WriteToLog("Pass","Selected '"&strPatientFirstName&"' patient from ActionItems")
	Wait 1	
	
	'------------------------------------------------------------------------------
	'*Validate Eligibility status after adding contact method (enrolled to engaged)
	'------------------------------------------------------------------------------
	'Add new contact
	blnAddNewContactMethod = AddContactMethod(strContact, dtContactDt, strContactScores, strContactTeams, strContactResolution, strOutErrorDesc)
	If not blnAddNewContactMethod Then
		Call WriteToLog("Fail","Expected Result: Contact should be added with required details. Actual Result: Unable to add contact."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Contact is added with required values")	
	wait 1
	
	'Close patient record
	blnClosePatientRecord = ClosePatientRecord(strRequiredNote,strOutErrorDesc) 
	If not blnClosePatientRecord Then
		Call WriteToLog("Fail","Expected Result: PatientRecord should be closed. Actual Result: Unable to close patient."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Patient is closed with required details")	
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'open patient through global search and get eligibility status
	strSearchRequired = "yes"
	strPatientEligibilityStatus = PatientEligibilityStatus(lngMemberID,strSearchRequired, strOutErrorDesc)
	If strPatientEligibilityStatus = "" Then
		Call WriteToLog("Fail","Expected Result: Patient Eligibility Status should be retrieved. Actual Result: Unable retrieve Eligibility Status."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Patient Eligibility Status is retrieved")	
	
	'Validate eligibility status(engaged)
	If Instr(1,strPatientEligibilityStatus,"Engaged",1) <= 0 Then
		Call WriteToLog("Fail","Expected Result: Patient Eligibility Status should be changed from 'Enrolled' to 'Engaged'. Actual Result: Available Eligibility Status is "&strPatientEligibilityStatus)
		Call Terminator	
	End If
	Call WriteToLog("Pass","Patient Eligibility Status is changed from 'Enrolled' to 'Engaged' after creating contact for patient with required details")	
	
	'------------------------------------------------------------------
	'*Validate Initial IPE tasks under PatientAssessment domain of MOAN 
	'------------------------------------------------------------------
	'IPE tasks completion with MOAN validation
	For IPEtask = 0 To UBound(arrIPEtasks) Step 1		
		strIPEtask = arrIPEtasks(IPEtask)	
		
		Select Case strIPEtask	
			'Parent task		
			Case "IPE Minimum Data Due"
				blnDomainTask = DomainTasks(strDomain, strIPEtask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strIPEtask, strOutErrorDesc)
				Wait 0,500	
				
			'Initial Medications Required' task	
			Case "Initial Medications Required"
				blnDomainTask = DomainTasks(strDomain, strIPEtask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strIPEtask, strOutErrorDesc)
				Wait 1	
				strAddMedications = AddMedication(strLabel, dtWrittenDt, dtFilledDt, strFrequency, strOutErrorDesc)
				If strAddMedications = "" Then
					Call WriteToLog("Fail", "Expected Result: Should be able to add medication; Actual Result: Unable to add new medication. "&strOutErrorDesc)
					Call Terminator	
				End If
				Call WriteToLog("Pass", "'Initial Medications Required' task is completed by adding new medication")
				Wait 0,500	
				
			'Initial Allergies Record' task					
			Case "Initial Allergies Record"
				blnDomainTask = DomainTasks(strDomain, strIPEtask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strIPEtask, strOutErrorDesc)
				Wait 2	
				blnAddAllergy = AddAllergy(strReqdAllergy, strOutErrorDesc)
				If not blnAddAllergy Then
					Call WriteToLog("Fail", "Expected Result: Should be able to add allergy; Actual Result: Unable to add new allergy. "&strOutErrorDesc)
					Call Terminator	
				End If			
				Call WriteToLog("Pass", "'Initial Allergies Record' task is completed by adding new allergy")	
				Wait 0,500	
				
			'Initial IPE Base Line due' task	
			Case "Initial IPE Base Line due"
				blnDomainTask = DomainTasks(strDomain, strIPEtask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strIPEtask, strOutErrorDesc)
				Wait 2	
				blnPatientAssessmentBaseLine = PatientAssessmentBaseLine(dtFirstDialysisDate,strFirstDialysisValue,dtFirstChronicDlysDate,strPrCausesOfRenalDisease,strHearingImpair,strVisionImpair,strOutErrorDesc)
				If not blnPatientAssessmentBaseLine Then
					Call WriteToLog("Fail", "Expected Result: Should be able to complete Base Line due; Actual Result: Unable to complete Base Line due. "&strOutErrorDesc)
					Call Terminator	
				End If		
				Call WriteToLog("Pass", "'Initial IPE Base Line due' task is completed")
				Wait 0,500	
				
			'Initial Access Management Record' task			
			Case "Initial Access Management Record"
				blnDomainTask = DomainTasks(strDomain, strIPEtask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strIPEtask, strOutErrorDesc)
				Wait 2	
				blnAccessInformationAdd = AccessInformationAdd(strAccessType,dtPlacedDate,strAccessStatus,dtDateActivated,strTerminateReason,strSide,strRegion,strExtremity,strOutErrorDesc)
				If not blnAccessInformationAdd Then
					Call WriteToLog("Fail", "Expected Result: Should be able to complete AccessInformation task; Actual Result: Unable to complete AccessInformation task. "&strOutErrorDesc)
					Call Terminator	
				End If		
				Call WriteToLog("Pass", "'Initial Access Management Record' task is completed")
				Wait 0,500	
				
		End Select
	Next
	Wait 1
	
	'Close patient record and re-open patient through global search (to get changes reflected)
	blnClosePatientAndReopenThroughGlobalSearch = ClosePatientAndReopenThroughGlobalSearch(strPatientFirstName,lngMemberID,strOutErrorDesc)
	If not blnClosePatientAndReopenThroughGlobalSearch Then
		Call WriteToLog("Fail","Unable to close patient record and re-open patient through global search. "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Closed patient record and re-opened patient through global search")

	'--------------------------------------------------------------------------------------
	'*Validate Eligibility status after completing intitial IPE tasks (engaged to assessed)
	'--------------------------------------------------------------------------------------
	strSearchRequired = "no"
	strPatientEligibilityStatus = PatientEligibilityStatus(lngMemberID,strSearchRequired, strOutErrorDesc)
	If strPatientEligibilityStatus = "" Then
		Call WriteToLog("Fail","Expected Result: Patient Eligibility Status should be retrieved. Actual Result: Unable retrieve Eligibility Status."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Patient Eligibility Status is retrieved")	
	Wait 1

	'Validate eligibility status(assessed)
	If Instr(1,strPatientEligibilityStatus,"Assessed",1) <= 0 Then
		Call WriteToLog("Fail","Expected Result: Patient Eligibility Status should be changed from 'Engaged' to 'Assessed'. Actual Result: Available Eligibility Status is "&strPatientEligibilityStatus)
		Call Terminator	
	End If
	Call WriteToLog("Pass","Patient eligibility status is changed from 'Engaged' to 'Assessed' after completion of all intitial IPE tasks")		
	Wait 1	
	
	'------------------------------------------------------------------
	'*Validate Initial HRA tasks under PatientAssessment domain of MOAN 
	'------------------------------------------------------------------
	'HRA tasks completion with MOAN validation
	For HRAtask = 0 To UBound(arrHRATasks) Step 1		
		strHRATask = arrHRATasks(HRAtask)		
		Select Case strHRATask		
		
			Case "Initial HRA Due"
				blnDomainTask = DomainTasks(strDomain, strHRATask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strHRATask, strOutErrorDesc)
				Wait 1			
				
			Case "ADL Survey Due"		
				blnDomainTask = DomainTasks(strDomain, strHRATask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strHRATask, strOutErrorDesc)
				Wait 2
				blnADLScreening = ADLScreening(strADLscreeningAnswers,strOutErrorDesc)
				If not blnADLScreening Then
					Call WriteToLog("Fail", "Expected Result: Should be able to complete ADLScreening; Actual Result: Unable to complete ADLScreening "&strOutErrorDesc)
					Call Terminator	
				End If			
				Call WriteToLog("Pass", "'ADL Survey Due' task is completed by doing ADL screening")	
				Wait 0,500
				
			Case "Comorbid Review Due"		
				blnDomainTask = DomainTasks(strDomain, strHRATask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strHRATask, strOutErrorDesc)
				Wait 2
				Execute "Set objComobidReviewAddBtn ="&Environment("WB_ComobidReviewAddBtn")
				Execute "Set objComobidReviewSaveBtn ="&Environment("WEL_ComobidReviewSaveBtn")
				Err.Clear
				objComobidReviewAddBtn.Click
				If Err.Number <> 0 Then
					Call WriteToLog("Fail", "Expected Result: Unable to click Comorbid Review button. "&Err.Description)
					Call Terminator		
				End If
				Wait 1
				Err.Clear
				objComobidReviewSaveBtn.Click
				If Err.Number <> 0 Then
					Call WriteToLog("Fail", "Expected Result: Unable to click Comorbid Review save button. "&Err.Description)
					Call Terminator		
				End If
				Call WriteToLog("Pass", "Comorbid Review task is completed")
				Wait 2
				Call waitTillLoads("Loading...")
				Wait 1
				Execute "Set objComobidReviewAddBtn = Nothing"
				Execute "Set objComobidReviewSaveBtn = Nothing"
				
			Case "Cognitive Screening Due"
				blnDomainTask = DomainTasks(strDomain, strHRATask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strHRATask, strOutErrorDesc)
				Wait 1
				blnCognitiveScreening = CognitiveScreening(strReqdScreeningType, strCogScrAns, strOutErrorDesc)
				If not blnCognitiveScreening Then
					Call WriteToLog("Fail", "Expected Result: Should be able to complete CognitiveScreening; Actual Result: Unable to complete CognitiveScreening "&strOutErrorDesc)
					Call Terminator	
				End If			
				Call WriteToLog("Pass", "'Cognitive Screening Due' task is completed by doing CognitiveScreening")	
				Wait 0,500
				
			Case "Depression Screening"		
				blnDomainTask = DomainTasks(strDomain, strHRATask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strHRATask, strOutErrorDesc)
				Wait 1
				blnDepressionScreening = DepressionScreening(strPatientRefusedSurvey,strDepressionScreeningAnswers,strOutErrorDesc)
				If not blnDepressionScreening Then
					Call WriteToLog("Fail", "Expected Result: Should be able to complete DepressionScreening; Actual Result: Unable to complete DepressionScreening "&strOutErrorDesc)
					Call Terminator	
				End If			
				Call WriteToLog("Pass", "'Cognitive Screening Due' task is completed by doing DepressionScreening")	
				Wait 0,500
				
			Case "Initial Pain Screening Due"		
				blnDomainTask = DomainTasks(strDomain, strHRATask, strOutErrorDesc)
				Call ValidateDomainAndTask(blnDomainTask,strDomain, strHRATask, strOutErrorDesc)
				Wait 1
				blnPainAssessmentScreening = PainAssessmentScreening(strPainAssessmentAnswers, strOutErrorDesc)		
				If not blnPainAssessmentScreening Then
					Call WriteToLog("Fail", "Expected Result: Should be able to complete PainAssessmentScreening; Actual Result: Unable to complete PainAssessmentScreening "&strOutErrorDesc)
					Call Terminator	
				End If			
				Call WriteToLog("Pass", "'Initial Pain Screening Due' task is completed by doing PainAssessmentScreening")	
				Wait 0,500
				
		End Select
	Next
	
	Wait 2

	'--------------------------------------------------------------------------------------
	'*Validate Eligibility status after completing intitial HRA tasks (assessed to managed)
	'--------------------------------------------------------------------------------------
	strSearchRequired = "no"
	strPatientEligibilityStatus = PatientEligibilityStatus(lngMemberID,strSearchRequired, strOutErrorDesc)
	If strPatientEligibilityStatus = "" Then
		Call WriteToLog("Fail","Expected Result: Patient Eligibility Status should be retrieved. Actual Result: Unable retrieve Eligibility Status."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Patient Eligibility Status is retrieved")	

	'Validate eligibility status(assessed)
	If Instr(1,strPatientEligibilityStatus,"Managed",1) <= 0 Then
		Call WriteToLog("Fail","Expected Result: Patient Eligibility Status should be changed from 'Assessed' to 'Managed'. Actual Result: Available Eligibility Status is "&strPatientEligibilityStatus)
		Call Terminator	
	End If
	Call WriteToLog("Pass","Patient eligibility status is changed from 'Assessed' to 'Managed' after completion of all intitial HRA tasks")	
	Wait 1	
	
	'Close patient record and re-open patient through global search (to get changes reflected)
	blnClosePatientAndReopenThroughGlobalSearch = ClosePatientAndReopenThroughGlobalSearch(strPatientFirstName,lngMemberID,strOutErrorDesc)
	If not blnClosePatientAndReopenThroughGlobalSearch Then
		Call WriteToLog("Fail","Unable to close patient record and re-open patient through global search. "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Closed patient record and re-opened patient through global search")

	'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Verify that after completing all child tasks, 'IPE Minimum Data Due' and 'Initial HRA Due' tasks get colsed and no longer available under 'Patient Assessment' domain of MOAN
	'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	strDomain = "Patient Assessment"
	Dim arrClosedTasks(1)
	arrClosedTasks(0) = "IPE Minimum Data Due"
	arrClosedTasks(1) = "Initial HRA Due"
	
	For iTasks = 0 to UBound(arrClosedTasks)
		strTask = arrClosedTasks(iTasks)
		blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
		If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
			Call WriteToLog("Pass", "'"&arrClosedTasks(iTasks)&"'task got colsed after completing child tasks, and is no longer available under 'Patient Assessment' domain of 'Menu of Actions'")
			strOutErrorDesc = ""
		ElseIf not blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
			Call Terminator	
		ElseIf blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task under '"&strDomain&"' domain should be closed after completing all child tasks; Actual Result: '"&strTask&"' task is not closed")
			Call Terminator	
		End If
	
	Next
		
	'----------------
	'log out from vhn
	Call Logout()
	Wait 2	
	'----------------
	
'Iteration loop
Loop While False: Next
wait 2

'Free object
Execute "Set objDashboard = Nothing"

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

Function ValidateDomainAndTask(ByVal strValDomainTasks,ByVal strValidateDomain, ByVal strValidateTask, ByVal strError)

	If Instr(1,strError,"Unable to find '"&strValidateTask&"' task",1) > 0 Then
		Call WriteToLog("Fail", "Expected Result: '"&strValidateTask&"' task should be available under '"&strValidateDomain&"' domain; Actual Result: "&strError)
		Call Terminator
	ElseIf not strValDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strValidateTask&"' task under '"&strValidateDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strError)
		Call Terminator
	End If
	
End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction

End Function
