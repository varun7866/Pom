'**************************************************************************************************************************************************************************
' TestCase Name			: PatientCarePlan
' Purpose of TC			: Complete screen automation for Patient Care Plan screen and impacted screens.
' Author                : Gregory
' Date                  : 12 April 2016
' Comments 				: 
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PatientCarePlan", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Load required screen library
SCREEN_Library = Environment.Value("PROJECT_FOLDER") & "\Library\SCREEN_functions"
For each SCREENlibfile in objFso.GetFolder(SCREEN_Library).Files
	If UCase(objFso.GetExtensionName(SCREENlibfile.Name)) = "VBS" AND Trim((Split(SCREENlibfile.Name,".")(0))) = strOutTestName Then
		LoadFunctionLibrary SCREENlibfile.Path
	End If
Next
Set objFso = Nothing

'-----------------------------------------------------------------
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)
	
	'------------------------
	' Variable initialization
	'------------------------
	strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
	strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")

	'Getting equired iterations
	If not Lcase(strExecutionFlag) = "y" Then Exit Do
	
	'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
	On Error Resume Next
	Err.Clear
		
	'-------------------------------
	'Close all open patients from DB
	Call closePatientsFromDB("eps")
	'-------------------------------
	
	'Login as eps and refer a new member.
	'-----------------------------------------
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
	
	Call WriteToLog("Info","----------------Select required patient through Global Search----------------")
	blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
	If Not blnGlobalSearchUsingMemID Then
	    strOutErrorDesc = "Select patient through global search returned error: "&strOutErrorDesc
	    Call WriteToLog("Fail", "Expected Result: User should be able to select patient through global search; Actual Result: "&strOutErrorDesc)
	    Call Terminator
	End If
	Call WriteToLog("Pass","Successfully selected required patient through global search")
	
	'Handle navigation error if exists
	blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientFirstName,strOutErrorDesc)
	If not blnHandleWrongDashboardNavigation Then
	    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
	End If
	Call WriteToLog("Pass","Provided proper navigation after patient selection")
	
	'-------------------------------------------------------------------------------
	'***Start validating scenarios for Patient care plan screen and impacted screens
	'-------------------------------------------------------------------------------
	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate navigation to Patient Care Plan screen
	blnPCP_ScreenNavigation = PCP_ScreenNavigation(strOutErrorDesc)	
		If not blnPCP_ScreenNavigation Then
		Call WriteToLog("Fail", "User not navigated to Patient Care Plan screen. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate all fileds and status in Patient Care Plan screen
	blnPCP_FieldValidations= PCP_FieldValidations(strOutErrorDesc)	
	If not blnPCP_FieldValidations Then
		Call WriteToLog("Fail", "Unable to validate Patient Care Plan field. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------	
	'Validate tool tips messages in Patient Care Plan screen
	blnPCP_FiledToolTipValidations = PCP_FiledToolTipValidations(strOutErrorDesc)
	If not blnPCP_FiledToolTipValidations Then
		Call WriteToLog("Fail", "Unable to validate Patient Care Plan field tool tip message. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Completed date scenarios
	blnPCP_CompletedDateFieldStatus = PCP_CompletedDateFieldStatus(strOutErrorDesc)
	If not blnPCP_CompletedDateFieldStatus Then
		Call WriteToLog("Fail", "Unable to validate Patient Care Plan Completed date scenarios. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Links and functionalities
	blnPCP_LinkValidations = PCP_LinkValidations(strOutErrorDesc)
	If not blnPCP_LinkValidations Then
		Call WriteToLog("Fail", "Unable to validate Patient Care Plan link functionalities. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate all pre-populated date fileds and values
	blnPCP_PrepopulatedDateVaildations = PCP_PrepopulatedDateVaildations(strOutErrorDesc)
	If not blnPCP_PrepopulatedDateVaildations Then
		Call WriteToLog("Fail", "Unable to validate Patient Care Plan screen all pre-populated date fileds and values. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate all fields in Patent Care Plan in Add mode
	'Order for strAddModeValues -- strCarePlanTopic,strImportance,strConfidenceLevel,strStatus,strClinicalRelevance,strCarePlanName,strBehavioralPlan,strEngagementPlan
	strAddModeValues = "Access Management,Important,Confident,In Progress,Modality Options,CarePlan,BehavioralPlan,EngagementPlan"
	blnPCP_NewMember_AddMode = PCP_NewMember_AddMode(strAddModeValues,strOutErrorDesc)
	If not blnPCP_NewMember_AddMode Then
		Call WriteToLog("Fail", "Unable to validate all fields in Patent Care Plan screen in Add mode. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Status field scenarios
	blnPCP_StatusFieldValidations = PCP_StatusFieldValidations(strOutErrorDesc)
	If not blnPCP_StatusFieldValidations Then
		Call WriteToLog("Fail", "Unable to validate Patent Care Plan screen Status field scenarios. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Start date scenarios
	blnPCP_StartDateValidations = PCP_StartDateValidations(strOutErrorDesc)
	If not blnPCP_StartDateValidations Then
		Call WriteToLog("Fail", "Unable to validate Patent Care Plan screen Start date scenarios. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Due date scenarios
	blnPCP_DueDateValidations = PCP_DueDateValidations(strOutErrorDesc)
	If not blnPCP_StartDateValidations Then
		Call WriteToLog("Fail", "Unable to validate Patent Care Plan screen Due date scenarios. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Barriers and Free-Form text scenarios
	blnPCP_BarriersAndFreeFormTextValidations = PCP_BarriersAndFreeFormTextValidations(strOutErrorDesc)
	If not blnPCP_BarriersAndFreeFormTextValidations Then
		Call WriteToLog("Fail", "Unable to validate Patent Care Plan screen Barriers and Free-Form text scenarios. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate message when navigating to other screen without saving care plan
	blnPCP_OtherScreenNavigationValidation = PCP_OtherScreenNavigationValidation(strOutErrorDesc)
	If not blnPCP_OtherScreenNavigationValidation Then
		Call WriteToLog("Fail", "Unable to validate message when navigating to other screen without saving care plan. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Cancel button functionality
	blnPCP_CancelButtonFunctionality = PCP_CancelButtonFunctionality(strOutErrorDesc)
	If not blnPCP_CancelButtonFunctionality Then
		Call WriteToLog("Fail", "Unable to validate Patent Care Plan screen Cancel button functionality. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Goals section before adding Patient care plan
	blnPCP_GoalsSectionBeforeAddingPCP = PCP_GoalsSectionBeforeAddingPCP(strOutErrorDesc)
	If not blnPCP_GoalsSectionBeforeAddingPCP Then
		Call WriteToLog("Fail", "Unable to validate Goals section before adding Patient care plan. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate no data in Patient Care Report for new patient
	strPCRstring = "Personal Care Summary"
	blnPCP_PCR_NoData_Validation = PCP_PCR_NoData_Validation(strPCRstring, strOutErrorDesc)
	If not blnPCP_PCR_NoData_Validation Then
		Call WriteToLog("Fail", "Unable to validate 'no data' in Patient Care Report for new patient. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Adding Patient Care Plan with all details ('Status' = 'In Progress')
	strFieldValues_Add = "Cardiovascular,BP Control,In Progress,Very Important,Very Confident,CP1CP1,BP1BP1,EP1EP1"
	dtStartDate_Add = Date
	dtDueDate_Add = Date
	strRequiredBarriers_Add = "Poor Habits/Practices,Knowledge Deficit,Equipment Issue"	
	strFFtext_Add = "freeform"
	blnPCP_AddPCP = PCP_AddPCP(strFieldValues_Add,dtStartDate_Add,dtDueDate_Add,strRequiredBarriers_Add,strFFtext_Add,strOutErrorDesc)
	If not blnPCP_AddPCP Then
		Call WriteToLog("Fail", "Unable to add Patient Care Plan with all details. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","--------Validating impacted screens on adding Patient care plan-------")
	'Validate impact on Active Care Plan section after adding Care Plan
	strFieldValues_ACP = strFieldValues_Add	'use same value used during adding care plan
	dtDueDate = dtDueDate_Add	'use same value used during adding care plan
	blnPCP_ActiveCarePlanSectionAfterAddingPCP = PCP_ActiveCarePlanSectionAfterAddingPCP(strFieldValues_ACP,dtDueDate,strOutErrorDesc)
	If not blnPCP_ActiveCarePlanSectionAfterAddingPCP Then
		Call WriteToLog("Fail", "Unable to validate impact on Active Care Plan section after adding Care Plan. "&strOutErrorDesc)
		Call Terminator
	End If	
	'---------------------------------------------------
	'Validate impact on Open Patient Tray after adding Care Plan
	blnPCP_OpenTray_Impact = PCP_OpenTray_Impact(strOutErrorDesc)
	If not blnPCP_OpenTray_Impact Then
		Call WriteToLog("Fail", "Unable to validate impact on Recap screen after adding Care Plan. "&strOutErrorDesc)
		Call Terminator
	End If	
	'---------------------------------------------------
	'Validate impact on Recap Screen after adding Care Plan
	strFieldValues_Recap = strFieldValues_Add	'use same value used during adding care plan
	dtStartDate = dtStartDate_Add	'use same value used during adding care plan
	strBarrier_Recap = strRequiredBarriers_Add	'use same value used during adding care plan
	blnPCP_Add_RecapScreen_Impact = PCP_Add_RecapScreen_Impact(strFieldValues_Recap,dtStartDate,strBarrier_Recap,strOutErrorDesc)
	If not blnPCP_Add_RecapScreen_Impact Then
		Call WriteToLog("Fail", "Unable to validate impact on Open Patient tray after adding Care Plan. "&strOutErrorDesc)
		Call Terminator
	End If
	'---------------------------------------------------	
	'Validate impact on Goals section after adding Care Plan
	strFieldValues_Goals = strFieldValues_Add	'use same value used during adding care plan
	dtStartDate = dtStartDate_Add	'use same value used during adding care plan
	dtDueDate = dtDueDate_Add	'use same value used during adding care plan
	blnPCP_Goals_Impact = PCP_Goals_Impact(strFieldValues_Goals,dtStartDate,dtDueDate,strOutErrorDesc)
	If not blnPCP_Goals_Impact Then
		Call WriteToLog("Fail", "Unable to validate impact on Goals section after adding Care Plan. "&strOutErrorDesc)
		Call Terminator
	End If	
	'---------------------------------------------------
	'Validate impact on Patient Care Report after adding Care Plan
	strFieldValues_Report = strFieldValues_Add	'use same value used during adding care plan	
	dtDueDate = dtDueDate_Add	'use same value used during adding care plan
	blnPCP_PatientCareReportValidations = PCP_PatientCareReportValidations(strFieldValues_Report,dtDueDate,strOutErrorDesc)
	If not blnPCP_PatientCareReportValidations Then
		Call WriteToLog("Fail", "Unable to validate impact on Patient Care Report after adding Care Plan. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Edit mode scenarios
	strFieldValues_EditMode = strFieldValues_Add  'use same value used during adding care plan
	dtDueDate = DateFormat(dtDueDate_Add) 'Should be in MM/DD/YYYY format  'use same value used during adding care plan
	blnPCP_EditMode = PCP_EditMode(strFieldValues_EditMode, dtDueDate, strOutErrorDesc)
	If not blnPCP_EditMode Then
		Call WriteToLog("Fail", "Unable to validate Edit mode scenarios. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Select the required care plan and Edit with Duedate: future date, Status: Not Started
	
	'Select the required care plan for editing   'use same value used during adding care plan
	strCarePlanTopicForEdit = Split(strFieldValues_Add,",",-1,1)(0)	'use same value used during adding care plan
	strClinicalRelevanceForEdit = Split(strFieldValues_Add,",",-1,1)(1)	'use same value used during adding care plan
	strStatus = Split(strFieldValues_Add,",",-1,1)(2)	'use same value used during adding care plan
	dtDueDate =  DateFormat(dtDueDate_Add)	'use same value used during adding care plan (duedate should be in MM/DD/YYY format as duedate is shown in MM/DD/YYYY in ACP section)
	blnPCP_SelectPCPforEdit = PCP_SelectPCPforEdit(strCarePlanTopicForEdit,strClinicalRelevanceForEdit,dtDueDate,strStatus,strOutErrorDesc)
	If not blnPCP_SelectPCPforEdit Then
		Call WriteToLog("Fail","Unable to select required care plan for editing. "&Err.Description)
		Call Terminator
	End If	
	
	'Edit PCP with Duedate: future date, Status: Not Started 
	strFieldValues_Edit = "Not Important,Not Confident,Not Started,EditedBP,EditedEP"
	dtDueDate_Edit = DateAdd("d",3,dtDueDate_Add)
	dtCompletedDate_Edit = "na" 'if status for edit is taken as 'In Progres' or 'Not Started' then dtCompletedDate should be given 'na'
	strRequiredBarriers_Edit = strRequiredBarriers_Add&","&"Psychological,Socioeconomic" 'this will uncheck all barriers during add (Poor Habits/Practices,Knowledge Deficit,Equipment Issue) and check new ones (Psychological,Socioeconomic)
	strNeedToEditSurvey = "yes"
	strFFtext_Edit = "ffEdit"
	blnPCP_EditPCP = PCP_EditPCP(strFieldValues_Edit,dtDueDate_Edit,dtCompletedDate_Edit,strRequiredBarriers_Edit,strNeedToEditSurvey,strFFtext_Edit,strOutErrorDesc)
	If not blnPCP_EditPCP Then
		Call WriteToLog("Fail", "Unable to edit Patient Care Plan with all details. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate all impacted areas on Care Plan edit with Duedate: future date, Status: Not Started 
	
	'Impact on ACP section after Editing care plan
	strStatus = Split(strFieldValues_Edit,",",-1,1)(2)
	dtDueDate = DateFormat(dtDueDate_Edit)
	blnPCP_ActiveCarePlanSectionAfterEdtingPCP = PCP_ActiveCarePlanSectionAfterEdtingPCP(strStatus,dtDueDate,strOutErrorDesc)
	If not blnPCP_ActiveCarePlanSectionAfterEdtingPCP Then
		Call WriteToLog("Fail", "Unable to validate impact on Active Care Plan section after editing Care Plan. "&strOutErrorDesc)
		Call Terminator
	End If
	'---------------------------------------------------	
	'Validate impact on Recap Screen after edting Care Plan
	strFieldValuesEdited_Recap = strFieldValues_Edit	'use same value used during editing care plan
	strBarrierEdited_Recap = "Psychological,Socioeconomic"	'use same value used during editing care plan (eliminate unchecked barriers)
	blnPCP_Edit_RecapScreen_Impact = PCP_Edit_RecapScreen_Impact(strFieldValuesEdited_Recap,strBarrierEdited_Recap,strOutErrorDesc)
	If not blnPCP_Edit_RecapScreen_Impact Then
		Call WriteToLog("Fail", "Unable to validate impact on Open Patient tray after editing Care Plan. "&strOutErrorDesc)
		Call Terminator
	End If	
	'---------------------------------------------------
	'Validate impact on Goals section after edting Care Plan
	strFieldValuesEdited_Goals = strFieldValues_Edit	'use same value used during editing care plan
	dtStartDate = dtStartDate_Add	'use same value used during adding care plan
	dtDueDate = dtDueDate_Edit	'use same value used during editing care plan
	blnPCP_Edit_Goals_Impact = PCP_Edit_Goals_Impact(strFieldValuesEdited_Goals,dtStartDate,dtDueDate,strOutErrorDesc)
	If not blnPCP_Edit_Goals_Impact Then
		Call WriteToLog("Fail", "Unable to validate impact on Goals section after edting Care Plan. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Select the required care plan and Edit with Duedate: sys date, Status: Met, Completed date: = start date, less than due date
	
	'Select the required care plan for editing   'use same value used during adding care plan
	strCarePlanTopicForEdit = Split(strFieldValues_Add,",",-1,1)(0)	'use same value used during adding care plan
	strClinicalRelevanceForEdit = Split(strFieldValues_Add,",",-1,1)(1)	'use same value used during adding care plan
	strStatus = Split(strFieldValues_Edit,",",-1,1)(2)'use same value used during editing care plan
	dtDueDate = DateFormat(dtDueDate_Edit)'use same value used during editing care plan
	blnPCP_SelectPCPforEdit = PCP_SelectPCPforEdit(strCarePlanTopicForEdit,strClinicalRelevanceForEdit,dtDueDate,strStatus,strOutErrorDesc)
	If not blnPCP_SelectPCPforEdit Then
		Call WriteToLog("Fail","Unable to select required care plan for editing. "&Err.Description)
		Call Terminator
	End If	
	
	'Edit PCP with Duedate: sys date, Status: Met
	strFieldValues_Edit_Met = "Very Important,Very Confident,Met,EditedMetBP,EditedMetEP"
	dtDueDate_Edit_Met = Date
	dtCompletedDate_Edit_Met = Date 'if status for edit is taken as 'In Progres' or 'Not Started' then dtCompletedDate should be given 'na'
	strRequiredBarriers_Edit_Met = strRequiredBarriers_Add '"Poor Habits/Practices,Knowledge Deficit,Equipment Issue"
	strNeedToEditSurvey = "No"
	'if strNeedToEditSurvey is "No" then put freeform text value null ("")
	blnPCP_EditPCP_Met = PCP_EditPCP(strFieldValues_Edit_Met,dtDueDate_Edit_Met,dtCompletedDate_Edit_Met,strRequiredBarriers_Edit_Met,strNeedToEditSurvey,"",strOutErrorDesc)
	If not blnPCP_EditPCP_Met Then
		Call WriteToLog("Fail", "Unable to edit Patient Care Plan with Met status. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate all impacted areas on Care Plan edit with Duedate: future date, Status: Met, Completed date: = start date, less than due date
	
	'Impact on ACP section after Editing care plan ('ACP should not show Met status care plans)
	strStatus = Split(strFieldValues_Edit_Met,",",-1,1)(2)
	dtDueDate = DateFormat(dtDueDate_Edit_Met)
	blnPCP_ActiveCarePlanSectionAfterEdtingPCP = PCP_ActiveCarePlanSectionAfterEdtingPCP(strStatus,dtDueDate,strOutErrorDesc)
	If blnPCP_ActiveCarePlanSectionAfterEdtingPCP Then
		Call WriteToLog("Fail", "Unable to validate impact on Active Care Plan section after Editing care plan - ACP is showing Met status care plan")
		Call Terminator
	End If
	Call WriteToLog("Pass","Validated impact on Active Care Plan section after Editing care plan - ACP is not showing Met status care plan")
	
	'Validate Goals section after editing care plan with status Met. Goals section should show 'This patient has no goals defined' message
	blnPCP_GS_Edit_Met = PCP_GoalsSectionBeforeAddingPCP(strOutErrorDesc)
	If not blnPCP_GS_Edit_Met Then
		Call WriteToLog("Fail", "Goals section is not showing 'This patient has no goals defined' message after editing care plan with status Met")
		Call Terminator
	End If	
	Call WriteToLog("Pass","Goals section is showing 'This patient has no goals defined' message after editing care plan with status Met")
	'---------------------------------------------------
	'Validate History table entries
	strCarePlnTopic_For_HT = Split(strFieldValues_Add,",",-1,1)(0)	'use same value used during adding care plan
	strCliRel_For_HT = Split(strFieldValues_Add,",",-1,1)(1)	'use same value used during adding care plan
	dtDueDate_For_HT = DateFormat(dtDueDate_Edit_Met) 'use same value used during last edit
	strStatus_For_HT = Split(strFieldValues_Edit_Met,",",-1,1)(2) 'use same value used during last edit
	strImportance_For_HT = Split(strFieldValues_Edit_Met,",",-1,1)(0) 'use same value used during last edit
	strConfidenceLevel_For_HT = Split(strFieldValues_Edit_Met,",",-1,1)(1) 'use same value used during last edit
	strBPtext_For_HT = Split(strFieldValues_Edit_Met,",",-1,1)(3) 'use same value used during last edit

	blnPCP_HistoryValidation = PCP_HistoryValidation(strCarePlnTopic_For_HT,strCliRel_For_HT,dtDueDate_For_HT,strStatus_For_HT,strImportance_For_HT,strConfidenceLevel_For_HT,strBPtext_For_HT,strOutErrorDesc)
	If not blnPCP_HistoryValidation Then
		Call WriteToLog("Fail", "Unable to validate History table entries on editing care plan with status Met. "&strOutErrorDesc)
		Call Terminator
	End If	
	Call WriteToLog("Pass","Validated all History table entries on editing care plan with status Met")
	'---------------------------------------------------
	'Validate no data in Patient Care Report after editing Care Plan with status Cancelled/Met/Partially Met/Unmet 
	strPCRstring = "Personal Care Summary"
	blnPCP_PCR_NoData_Validation = PCP_PCR_NoData_Validation(strPCRstring, strOutErrorDesc)
	If not blnPCP_PCR_NoData_Validation Then
		Call WriteToLog("Fail", "Unable to validate 'no data' in Patient Care Report after editing Care Plan with status Met. "&strOutErrorDesc)
		Call Terminator
	End If	
	Call WriteToLog("Pass","Validated 'no data' in Patient Care Report after editing Care Plan with status Met")
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Adding Patient Care Plan with 'Status' = 'Not Started'
	strFieldValues_Add = "Cardiovascular,BP Control,Not Started,Very Important,Very Confident,CP1CP1,BP1BP1,EP1EP1"
	dtStartDate_Add = DateAdd("d",-2,Date)
	dtDueDate_Add = DateAdd("d",2,Date)
	strRequiredBarriers_Add = "Poor Habits/Practices,Knowledge Deficit,Equipment Issue"	
	strFFtext_Add = "freeform"
	blnPCP_AddPCP = PCP_AddPCP(strFieldValues_Add,dtStartDate_Add,dtDueDate_Add,strRequiredBarriers_Add,strFFtext_Add,strOutErrorDesc)
	If not blnPCP_AddPCP Then
		Call WriteToLog("Fail", "Unable to validate Adding Patient Care Plan with 'Status' = 'Not Started'. "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Validated Adding Patient Care Plan with 'Status' = 'Not Started'")
	'-----------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","--------Validating impacted screens on adding Patient care plan-------")
	'Validate impact on Active Care Plan section after adding Care Plan
	strFieldValues_ACP = strFieldValues_Add	'use same value used during adding care plan
	dtDueDate = dtDueDate_Add	'use same value used during adding care plan
	blnPCP_ActiveCarePlanSectionAfterAddingPCP = PCP_ActiveCarePlanSectionAfterAddingPCP(strFieldValues_ACP,dtDueDate,strOutErrorDesc)
	If not blnPCP_ActiveCarePlanSectionAfterAddingPCP Then
		Call WriteToLog("Fail", "Unable to validate impact on Active Care Plan section after adding Care Plan with status 'Not Started'. "&strOutErrorDesc)
		Call Terminator
	End If	
	'---------------------------------------------------
	'Validate impact on Open Patient Tray after adding Care Plan
	blnPCP_OpenTray_Impact = PCP_OpenTray_Impact(strOutErrorDesc)
	If not blnPCP_OpenTray_Impact Then
		Call WriteToLog("Fail", "Unable to validate impact on Recap screen after adding Care Plan with status 'Not Started'. "&strOutErrorDesc)
		Call Terminator
	End If
	'---------------------------------------------------
	'Validate impact on Recap Screen after adding Care Plan
	strFieldValues_Recap = strFieldValues_Add	'use same value used during adding care plan
	dtStartDate = dtStartDate_Add	'use same value used during adding care plan
	strBarrier_Recap = strRequiredBarriers_Add	'use same value used during adding care plan
	blnPCP_Add_RecapScreen_Impact = PCP_Add_RecapScreen_Impact(strFieldValues_Recap,dtStartDate,strBarrier_Recap,strOutErrorDesc)
	If not blnPCP_Add_RecapScreen_Impact Then
		Call WriteToLog("Fail", "Unable to validate impact on Open Patient tray after adding Care Plan with status 'Not Started'. "&strOutErrorDesc)
		Call Terminator
	End If	
	'---------------------------------------------------	
	'Validate impact on Goals section after adding Care Plan
	strFieldValues_Goals = strFieldValues_Add	'use same value used during adding care plan
	dtStartDate = dtStartDate_Add	'use same value used during adding care plan
	dtDueDate = dtDueDate_Add	'use same value used during adding care plan
	blnPCP_Goals_Impact = PCP_Goals_Impact(strFieldValues_Goals,dtStartDate,dtDueDate,strOutErrorDesc)
	If not blnPCP_Goals_Impact Then
		Call WriteToLog("Fail", "Unable to validate impact on Goals section after adding Care Plan with status 'Not Started'. "&strOutErrorDesc)
		Call Terminator
	End If	
	'---------------------------------------------------
	'Validate no data in Patient Care Report after adding Care Plan with status 'Not Started'
	strPCRstring = "Personal Care Summary"
	blnPCP_PatientCareReportValidations = PCP_PCR_NoData_Validation(strPCRstring, strOutErrorDesc)
	If not blnPCP_PCR_NoData_Validation Then
		Call WriteToLog("Fail", "Unable to validate impact on Goals section after adding Care Plan with status 'Not Started'. "&strOutErrorDesc)
		Call Terminator
	End If	
	Call WriteToLog("Pass","Validated 'no data' in Patient Care Report after adding Care Plan with status 'Not Started'")
	'-----------------------------------------------------------------------------------------------------------------------------
	'Select the required care plan and Edit with Duedate: future date, Status: Cancelled, Completed date: = start date, less than due date
	
	'Select the required care plan for editing   'use same value used during adding care plan
	strCarePlanTopicForEdit = Split(strFieldValues_Add,",",-1,1)(0)	'use same value used during adding care plan
	strClinicalRelevanceForEdit = Split(strFieldValues_Add,",",-1,1)(1)	'use same value used during adding care plan
	strStatus = Split(strFieldValues_Edit,",",-1,1)(2)'use same value used during editing care plan
	dtDueDate = DateFormat(dtDueDate_Add)'use same value used during adding care plan
	blnPCP_SelectPCPforEdit = PCP_SelectPCPforEdit(strCarePlanTopicForEdit,strClinicalRelevanceForEdit,dtDueDate,strStatus,strOutErrorDesc)
	If not blnPCP_SelectPCPforEdit Then
		Call WriteToLog("Fail","Unable to select required care plan for editing. "&Err.Description)
		Call Terminator
	End If	 	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Edit PCP with Completed date less than 'Start Date' Status: Cancelled - error msg vlidation	
	strStatus = "Cancelled"
	dtCompletedDate = DateAdd("d",-1,Date)
	blnPCP_CompletedDateScenario = PCP_CompletedDateScenario(strStatus, dtCompletedDate, strOutErrorDesc)	
	'-----------------------------------------------------------------------------------------------------------------------------	
	'Edit PCP with Duedate=sys date, Completed date = sys date,  Status: Cancelled	
	strFieldValues_Edit_Cancelled = "Important,Confident,Cancelled,EditedCancelledBP,EditedCancelledEP"
	dtDueDate_Edit_Cancelled = Date
	dtCompletedDate_Edit_Cancelled = Date 'if status for edit is taken as 'In Progres' or 'Not Started' then dtCompletedDate should be given 'na'
	strRequiredBarriers_Edit_Cancelled = strRequiredBarriers_Add&","&"Psychological,Socioeconomic" 'this will uncheck all barriers during add (Poor Habits/Practices,Knowledge Deficit,Equipment Issue) and check new ones (Psychological,Socioeconomic)
	strNeedToEditSurvey = "No"
	'if strNeedToEditSurvey is "No" then put freeform text value null ("")
	blnPCP_EditPCP_Cancelled = PCP_EditPCP(strFieldValues_Edit_Cancelled,dtDueDate_Edit_Cancelled,dtCompletedDate_Edit_Cancelled,strRequiredBarriers_Edit_Cancelled,strNeedToEditSurvey,"",strOutErrorDesc)
	If not blnPCP_EditPCP_Cancelled Then
		Call WriteToLog("Fail", "Unable to edit Patient Care Plan with all details. "&strOutErrorDesc)
		Call Terminator
	End If
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate all impacted areas on Care Plan edit with Due date: less than sys date date, Status: Cancelled
	
	'Impact on ACP section after Editing care plan
	strStatus = Split(strFieldValues_Edit_Cancelled,",",-1,1)(2)
	dtDueDate = DateFormat(dtDueDate_Edit_Cancelled)
	blnPCP_ActiveCarePlanSectionAfterEdtingPCP = PCP_ActiveCarePlanSectionAfterEdtingPCP(strStatus,dtDueDate,strOutErrorDesc)
	If blnPCP_ActiveCarePlanSectionAfterEdtingPCP Then
		Call WriteToLog("Fail", "Unable to validate impact on Active Care Plan section after Editing care plan - ACP is showing Cancelled status care plan")
		Call Terminator
	End If
	Call WriteToLog("Pass","Validated impact on Active Care Plan section after Editing care plan - ACP is not showing Cancelled status care plan")
	'---------------------------------------------------	
	'Validate History table entries
	strCarePlnTopic_For_HT = Split(strFieldValues_Add,",",-1,1)(0)	'use same value used during adding care plan
	strCliRel_For_HT = Split(strFieldValues_Add,",",-1,1)(1)	'use same value used during adding care plan
	dtDueDate_For_HT = DateFormat(dtDueDate_Edit_Cancelled) 'use same value used during last edit
	strStatus_For_HT = Split(strFieldValues_Edit_Cancelled,",",-1,1)(2) 'use same value used during last edit
	strImportance_For_HT = Split(strFieldValues_Edit_Cancelled,",",-1,1)(0) 'use same value used during last edit
	strConfidenceLevel_For_HT = Split(strFieldValues_Edit_Cancelled,",",-1,1)(1) 'use same value used during last edit
	strBPtext_For_HT = Split(strFieldValues_Edit_Cancelled,",",-1,1)(3) 'use same value used during last edit

	blnPCP_HistoryValidation = PCP_HistoryValidation(strCarePlnTopic_For_HT,strCliRel_For_HT,dtDueDate_For_HT,strStatus_For_HT,strImportance_For_HT,strConfidenceLevel_For_HT,strBPtext_For_HT,strOutErrorDesc)
	If not blnPCP_HistoryValidation Then
		Call WriteToLog("Fail", "Unable to validate History table entries on editing care plan with status Cancelled. "&strOutErrorDesc)
		Call Terminator
	End If	
	Call WriteToLog("Pass","Validated all History table entries on editing care plan with status Cancelled")
	'---------------------------------------------------
	'Validate Goals section after editing care plan with status Cancelled. Goals section should show 'This patient has no goals defined' message
	blnPCP_GS_Edit_Cancelled = PCP_GoalsSectionBeforeAddingPCP(strOutErrorDesc)
	If not blnPCP_GS_Edit_Cancelled Then
		Call WriteToLog("Fail", "Goals section is not showing 'This patient has no goals defined' message after editing care plan with status Cancelled")
		Call Terminator
	End If	
	Call WriteToLog("Pass","Goals section is showing 'This patient has no goals defined' message after editing care plan with status Cancelled")	
	'-----------------------------------------------------------------------------------------------------------------------------	
	'Validate no data in Patient Care Report after editing Care Plan with status Cancelled/Met/Partially Met/Unmet 
	strPCRstring = "Personal Care Summary"
	blnPCP_PCR_NoData_Validation = PCP_PCR_NoData_Validation(strPCRstring, strOutErrorDesc)
	If not blnPCP_PCR_NoData_Validation Then
		Call WriteToLog("Fail", "Unable to validate 'no data' in Patient Care Report after editing Care Plan with status Cancelled. "&strOutErrorDesc)
		Call Terminator
	End If	
	'-----------------------------------------------------------------------------------------------------------------------------
	'Validate Duplicate Patient Care Plan addition with 'Status' = 'In Progress'
	strFieldValues_Add = "Cardiovascular,BP Control,In Progress,Important,Confident,CPCP,BPBP,EPEP"
	dtStartDate_Add = Date
	dtDueDate_Add = Date
	strRequiredBarriers_Add = "Poor Habits/Practices,Knowledge Deficit,Equipment Issue"	
	strFFtext_Add = "freeform"
	blnPCP_AddPCP = PCP_AddPCP(strFieldValues_Add,dtStartDate_Add,dtDueDate_Add,strRequiredBarriers_Add,strFFtext_Add,strOutErrorDesc)
	If not blnPCP_AddPCP Then
		Call WriteToLog("Fail", "Unable to add Patient Care Plan with all details. "&strOutErrorDesc)
		Call Terminator
	End If
	
	strFieldValues_Add = "Cardiovascular,BP Control,In Progress,Important,Confident,CPCP,BPBP,EPEP"
	dtStartDate_Add = Date
	dtDueDate_Add = Date
	strRequiredBarriers_Add = "Poor Habits/Practices,Knowledge Deficit,Equipment Issue"	
	strFFtext_Add = "freeform"
	blnPCP_AddPCP = PCP_AddPCP(strFieldValues_Add,dtStartDate_Add,dtDueDate_Add,strRequiredBarriers_Add,strFFtext_Add,strOutErrorDesc)
	If not blnPCP_AddPCP Then
		Call WriteToLog("Fail", "Unable to add Patient Care Plan with all details. "&strOutErrorDesc)
		Call Terminator
	End If	
	
	strCarePlanTopic = Split(strFieldValues_Add,",",-1,1)(0)	'use same value used during adding care plan
	strClinicalRelevance = Split(strFieldValues_Add,",",-1,1)(1)	'use same value used during adding care plan
	strStatus = Split(strFieldValues_Add,",",-1,1)(2)	'use same value used during adding care plan
	dtDueDate =  DateFormat(dtDueDate_Add)	'use same value used during adding care plan (duedate should be in MM/DD/YYY format as duedate is shown in MM/DD/YYYY in ACP section)
	intDuplicates = 2 'as we've added only 2 similar care plans (i.e duplicate)
	
	blnPCP_Dulicates = PCP_Dulicates(intDuplicates, strCarePlanTopic, strClinicalRelevance, dtDueDate, strStatus, strOutErrorDesc)
	If not blnPCP_AddPCP Then
		Call WriteToLog("Fail", "Validate Duplicate Patient Care Plan addition with 'Status' = 'In Progress'. "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Validated Duplicate Patient Care Plan addition")
	'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	'Logout
	Call WriteToLog("Info","------------Logout of application------------")
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



'	'***********************((((((((((((((((((((((((((((((((((((((((((((((((((((
'	'OBJECTS
'	'Main section
'	Execute "Set objPCP_PatCaPlnMainMenu = "&Environment("WL_PatCaPlnTab") 'PatientCarePlan tab
'	Execute "Set objPCP_ActiveCarePlansSection = "&Environment("WEL_PCP_ACPsection") 'ACP section tab
'	Execute "Set objPCP_AddBTN ="&Environment("WEL_PatCaPlnAdd") 'PCP Add button
'	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
'	Execute "Set objPCP_EditBTN ="&Environment("WEL_EditCarePlanBtn") 'PCP Edit button
'	Execute "Set objPCP_CancelBTN ="&Environment("WEL_PCP_CancelBtn") 'PCP Cancel button
'	Execute "Set objPCP_CarePlanTopicDD ="&Environment("WB_PatCaPlnTopic") 'PCP CarePlanTopic dropdown	
'	Execute "Set objPCP_ImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 'PCP Importance drodown
'	Execute "Set objPCP_ConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 'PCP Confidence level dropdown
'	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
'	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
'	Execute "Set objPCP_DueDateTB = "&Environment("WE_PCP_DueDateFiled") 'PCP DueDate field
'	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
'	Execute "Set objPCP_ClinicalRelevanceDD = "&Environment("WB_PatCaPlnClinicalRelvnDD") 'PCP ClinicalRelevance dropdown
'	Execute "Set objPCP_ClinicalRelevanceTB = "&Environment("WE_PCP_ClinicalRelevanceField") 'PCP ClinicalRelevance field	
'	Execute "Set objPCP_CarePlanNameTB = "&Environment("WE_PatCaPlnName") 'PCP CarePlanName field	
'	Execute "Set objPCP_SendMaterialLink = "&Environment("WI_PCP_SendMaterialLink") 'PCP Send Material link
'	Execute "Set objPCP_ReferralLink = "&Environment("WI_PCP_ReferralLink") 'PCP Referral link	
'	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
'	Execute "Set objPCP_EngagementPlanTB = "&Environment("WE_EngagementPlan") 'PCP Engagement plan field	
'	'Barriers
'	Execute "Set objPCP_PoorHabits_BarrierCB = "&Environment("WEL_PCP_PoorHabits_BarrierCB") 'Poor Habits/Practices check box
'	Execute "Set objPCP_KnowledgeDeficit_BarrierCB = "&Environment("WEL_PCP_KnowledgeDeficit_BarrierCB") 'Knowledge Deficit check box
'	Execute "Set objPCP_EquipmentIssue_BarrierCB = "&Environment("WEL_PCP_EquipmentIssue_BarrierCB") 'Equipment Issue check box
'	Execute "Set objPCP_Psychological_BarrierCB = "&Environment("WEL_PCP_Psychological_BarrierCB") 'Psychological check box
'	Execute "Set objPCP_Socioeconomic_BarrierCB = "&Environment("WEL_PCP_Socioeconomic_BarrierCB") 'Socioeconomic check box
'	Execute "Set objPCP_PhysicalLimitation_BarrierCB = "&Environment("WEL_PCP_PhysicalLimitation_BarrierCB") 'Physical Limitation check box	
'	Execute "Set objPCP_NoSupportSystem_BarrierCB = "&Environment("WEL_PCP_NoSupportSystem_BarrierCB") 'No Support System check box
'	Execute "Set objPCP_Other_BarrierCB = "&Environment("WEL_PCP_Other_BarrierCB") 'Other check box
'	Execute "Set objPCP_OtherTB_BarrierTB = "&Environment("WE_PCP_OtherTB_BarrierTB") 'Other field
'	Execute "Set objPCP_NoBarriers_BarrierCB = "&Environment("WEL_PCP_NoBarriers_BarrierCB") 'No Barriers check box
'	'Questions
'	Execute "Set objPCP_Ques1UnderstandCP_YesRdBtn = "&Environment("WEL_PCP_Ques1UnderstandCP_YesRdBtn") 'Understand care plan Yes radio button
'	Execute "Set objPCP_Ques1UnderstandCP_NoRdBtn = "&Environment("WEL_PCP_Ques1UnderstandCP_NoRdBtn") 'Understand care plan No radio button	
'	Execute "Set objPCP_1FreeFormResponse = "&Environment("WE_PCP_1FreeFormResponse") 'PCP Freeform text field 1
'	Execute "Set objPCP_Ques2AgreeCP_YesRdBtn = "&Environment("WEL_PCP_Ques2AgreeCP_YesRdBtn") 'Agree care plan Yes radio button
'	Execute "Set objPCP_Ques2AgreeCP_NoRdBtn = "&Environment("WEL_PCP_Ques2AgreeCP_NoRdBtn") 'Agree care plan No radio button	
'	Execute "Set objPCP_2FreeFormResponse = "&Environment("WE_PCP_2FreeFormResponse") 'PCP Freeform text field 2
'	Execute "Set objPCP_Ques3SelfManagement_YesRdBtn = "&Environment("WEL_PCP_Ques3SelfManagement_YesRdBtn") 'Self Management Yes radio button
'	Execute "Set objPCP_Ques3SelfManagement_NoRdBtn = "&Environment("WEL_PCP_Ques3SelfManagement_NoRdBtn") 'Self Management No radio button
'	Execute "Set objPCP_3FreeFormResponse = "&Environment("WE_PCP_3FreeFormResponse") 'PCP Freeform text field 3
'	Execute "Set objPCP_Ques4NeedSelfManagement_YesRdBtn = "&Environment("WEL_PCP_Ques4NeedSelfManagement_YesRdBtn") 'need self management Yes radio button
'	Execute "Set objPCP_Ques4NeedSelfManagement_NoRdBtn = "&Environment("WEL_PCP_Ques4NeedSelfManagement_NoRdBtn") 'need self management No radio button
'	Execute "Set objPCP_4FreeFormResponse = "&Environment("WE_PCP_4FreeFormResponse") 'PCP Freeform text field 4
'	'CarePlanTable
'	Execute "Set objPCP_CarePlanTable = "&Environment("WT_PCP_CarePlanTable") 'Care plan table
'	'History
'	Execute "Set objPCPHistoryHeader = "&Environment("WT_PCPHistoryHeader") 'PCP History Table Header
'	Execute "Set objPCP_HistoryTableUpArrow = "&Environment("WI_PCP_HistoryTableArrow") 'PCP history table up arrow
'	Execute "Set objPCP_HistoryTableDownArrow = "&Environment("WI_PCP_HistoryTableArrow") 'PCP history table down arrow
'	Execute "Set objPCP_HistoryTable = "&Environment("WT_PCP_HistoryTable") 'PCP history table	
'
'
'	'***********************)))))))))))))))))))))))))))))))))))))))))))))))))))))






