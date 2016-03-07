'**************************************************************************************************************************************************************************
' TestCase Name			: MedAdvisorWFpatient
' Purpose of TC			: Validate MedAdvisor WorkFlow for patient intervention using warm transfer
' Author                : Gregory
' Date                  : 28 August 2015
' Date Modified			: 19 February 2016
'**************************************************************************************************************************************************************************
'----------------
'INITIALIZATION
'----------------
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

Set objFso = Nothing

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "MedAdvisorWFpatient", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'------------------------------------------------------------------
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)

'------------------------
' Variable initialization
'------------------------
strExecutionFlag = DataTable.Value("ExecutionFlag", "CurrentTestCaseData")
strPersonalDetails = DataTable.Value("PersonalDetails", "CurrentTestCaseData") 
strPatientName = Split(strPersonalDetails,",",-1,1)(0)
strProgramDetails = DataTable.Value("ProgramDetails", "CurrentTestCaseData")
dtProgramStartDate = Date
strTechScreeningAnswerOptions = DataTable.Value("TechScreeningAnswerOptions", "CurrentTestCaseData")
strAssignedPHM = DataTable.Value("AssignedPHM", "CurrentTestCaseData")
strPostTechScreeningDetails = "Warm Transfer,"&strAssignedPHM
strLabel = DataTable.Value("Label", "CurrentTestCaseData")
dtWrittenDate = DataTable.Value("WrittenDate", "CurrentTestCaseData")
dtWrittenDate = Split(dtWrittenDate," ",-1,1)(0)
dtFilledDate = DataTable.Value("FilledDate", "CurrentTestCaseData")
dtFilledDate = Split(dtFilledDate," ",-1,1)(0)
strFrequency = DataTable.Value("Frequency", "CurrentTestCaseData")
dtPHMReviewDate = DataTable.Value("PHMReviewDate", "CurrentTestCaseData")
dtPHMReviewDate = Split(dtPHMReviewDate," ",-1,1)(0)
strIntervDisSt = "Diabetes"
strPHMcoding = "Avoided ER"
dtPHMcodingDate = DataTable.Value("PHMcodingDate", "CurrentTestCaseData") 'cannot be less that PHMReview date
dtPHMcodingDate = Split(dtPHMcodingDate," ",-1,1)(0)
strCurrentVisibleStatusinPHMForPatient = "Open"
strCurrentVisibleStatusinPHM = "Pending MD"
strPHMInterventionEditStatus = "Final Review Needed"
strCurrentVisibleStatusinRVR = "Final Review Needed"
strRVRInterventionEditStatus = "Final Review Completed"
strReviewerCoding = "Avoided ER"
strReferredTo = DataTable.Value("ReferredTo", "CurrentTestCaseData")
strRevTitleType= "INSULIN STABILITY"
strRevTitle = "INSULIN STABILITY"
dtReviewerCodingDate = DataTable.Value("ReviewerCodingDate", "CurrentTestCaseData")
dtReviewerCodingDate = Split(dtReviewerCodingDate," ",-1,1)(0)

'Getting equired iterations
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
	
'------------------------------------------------------------------------------------in PTC----------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
Err.Clear

Call WriteToLog("info", "------------------------------Med Advisor Work Flow for Patient intervention------------------------------")

'-----------------
'Login to PTC user
'-----------------
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("ptc", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

'Add new patient in PTC user and retrieve MemID
strProgramDetails = strProgramDetails&","&dtProgramStartDate
lngMemberID = CreateNewPatientFromPTC(strPersonalDetails,,,strProgramDetails,strOutErrorDesc)
If lngMemberID = "" Then
	Call WriteToLog("Fail", "Expected Result: Member should be added; Actual Result: Error adding Member " &strOutErrorDesc)
	Call Terminator 
End If
Call WriteToLog("Pass", "Member is added successfully from PTC")
Wait 2

'-----------------------------------------------
' Do Tech Screening for newly added patient
'-----------------------------------------------
'Navigate to Screenings > Tech Screenings
blnScreenNavigation =  clickOnSubMenu_WE("Screening->Tech Screening")
If not blnScreenNavigation Then
	Call WriteToLog("Fail", "Unable to navigate to tech screening page")
	Call Terminator 
End If
Call WriteToLog("Pass", "Navigated to tech screening page")
Wait 1
	
'Tech screening
blnPTCtechscreening =  PTCtechscreening(strTechScreeningAnswerOptions,strPostTechScreeningDetails, strOutErrorDesc)
If blnPTCtechscreening Then
	Call WriteToLog("Pass", "PTCtech screening done successfully")
Else
	Call WriteToLog("Fail", "Expected Result: PTCtech screening should be done successfully; Actual Result: PTCtech screening is not done successfully " &strOutErrorDesc)
	Call Terminator
End If

'Logout from PTC
Logout()
Call WriteToLog("Pass","Successfully logged out from PTC User")
Wait 5
'------------------------------------------------------------------------------------PTC ends----------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------in PHM----------------------------------------------------------------------------------------------------------------------------------
'--------------------------
'Login to PHM user
'--------------------------
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("phm", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator	
End If
Call WriteToLog("Pass","Navigated to user dashboard")

'Open assigned PHM user dashboard
blnSelectRequiredRoster = SelectRequiredRoster(strAssignedPHM, strOutErrorDesc)
If not blnSelectRequiredRoster Then
	Call WriteToLog("Fail","Unable to open '"&strAssignedPHM&"'s Dashboard. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Opened required '"&strAssignedPHM&"'s Dashboard")

'------------------------------------
'Get patient from warm transefer tray
'------------------------------------
'open warm transfer tray
Execute "Set objWarmTfrAlrtExpnd = " & Environment("WEL_WarmTfrAlrtExpnd")
blnWarmTfrAlrtExpnd = ClickButton("",objWarmTfrAlrtExpnd,strOutErrorDesc)
If blnWarmTfrAlrtExpnd Then
	Call WriteToLog("Pass", "Warm Transfer ALerts tray is expanded")
Else
	Call WriteToLog("Fail", "Expected Result: Warm Transfer ALerts tray should be expanded; Actual Result: Warm Transfer ALerts tray is not expanded " &strOutErrorDesc)
	Call Terminator
End If
Execute "Set objWarmTfrAlrtExpnd = Nothing"
Wait 2
Call waitTillLoads("Loading...")
Wait 1

'get required patient from warm transfer tray
Execute "Set objPage = " & Environment("WPG_AppParent")
Set objReqdPatientFromWarmTrTy = objPage.WebElement("html tag:=DIV","visible:=True","outertext:="&Trim(lngMemberID))
Err.Clear
objReqdPatientFromWarmTrTy.highlight
objReqdPatientFromWarmTrTy.Click	
If Err.Number = 0 Then
	Call WriteToLog("Pass", "Required patient is selected from warm transfer tray")
Else
	Call WriteToLog("Fail", "Expected Result: Required patient should be selected from warm transfer tray; Actual Result: Required patient is not selected from warm transfer tray " &Err.Description)
	Call Terminator
End If
Wait 2
Call waitTillLoads("Loading...")
Wait 1
Call waitTillLoads("Loading...")
Wait 1

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")
Wait 2

'-------------------
'Add Medication
'-------------------
'Close all available popups
blnCloseAllAvailablePopups = CloseAllAvailablePopups()
If not blnCloseAllAvailablePopups Then
	Call WriteToLog("Fail","Unable to close message box. " &Err.Description)
	Call Terminator
End If

'Click on Medications Review tab
Execute "Set objMedReviewTab = " & Environment("WEL_MedReviewTab")
blnMedReviewClicked = ClickButton("Review",objMedReviewTab,strOutErrorDesc)
If blnMedReviewClicked Then
	Call WriteToLog("Pass","Medication Review tab is clicked")
Else
	Call WriteToLog("Fail","Expected Result: Medication Review tab should be clicked; Actual Result: Medication Review tab is not clicked " &strOutErrorDesc)
	Call Terminator 
End If
Execute "Set objMedReviewTab = Nothing"
Wait 2
Call waitTillLoads("Loading...")
Wait 1

'Close all available popups
blnCloseAllAvailablePopups = CloseAllAvailablePopups()
If not blnCloseAllAvailablePopups Then
	Call WriteToLog("Fail","Unable to close message box. " &Err.Description)
	Call Terminator
End If

'Add new medication for the patient
blnAddMedication = AddMedication(strLabel, dtWrittenDate, dtFilledDate, strFrequency, strOutErrorDesc)
If blnAddMedication Then
	Call WriteToLog("Pass", "New medication is added successfully")
Else
	Call WriteToLog("Fail", "Expected Result: New medication should be added successfully; Actual Result: Error adding new medication. " &strOutErrorDesc)
	Call Terminator
End If
Wait 1

'-----------------------------
'Perform Pharmacist Med Review
'-----------------------------
'Navigate to Pharmacist Med Review tab
Execute "Set objPharmacistMedReviewTab = "& Environment("WEL_PharmacistMedReviewTab")
blnPharmacistMedReviewTab = ClickButton("Pharmacist Med Review",objPharmacistMedReviewTab,strOutErrorDesc)
If blnPharmacistMedReviewTab Then
	Call WriteToLog("Pass", "PharmacistMedReview tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: PharmacistMedReview tab should be clicked; Actual Result: PharmacistMedReview tab is not clicked " &strOutErrorDesc)
	Call Terminator
End If
Execute "Set objPharmacistMedReviewTab = Nothing"
Wait 2
Call waitTillLoads("Loading...")
Wait 1

'Close all available popups
blnCloseAllAvailablePopups = CloseAllAvailablePopups()
If not blnCloseAllAvailablePopups Then
	Call WriteToLog("Fail","Unable to close message box. " &Err.Description)
	Call Terminator
End If

'Add med review
blnAddPharmacistMedReview = AddPharmacistMedReview(dtPHMReviewDate, "VHN Referrals", strOutErrorDesc)
If blnAddPharmacistMedReview Then
	Call WriteToLog("Pass", "Pharmacist med review is done successfully")
Else
	Call WriteToLog("Fail", "Expected Result: User should be able to do Pharmacist med review; Actual Result: Unable to do Pharmacist med review. " &strOutErrorDesc)
	Call Terminator 
End If
Wait 2
Call waitTillLoads("Loading...")
Wait 2

'Validate availability of Send Map and Send Med List after pharmacist med review
Call ValidateMapAndMedlistButtons()

'Validate score card in PHM
Call ValidateMedicationScoreCardMAWF("phm","Med Advisor in process")

'-----------------------------------------------------------------------
'Add intervention to medication and make status as 'Final Review Needed'
'-----------------------------------------------------------------------
'Navigate to Clinical Management>Medications>PharmacistMedReview tab
blnScreenNavigation =  clickOnSubMenu_WE("Clinical Management->Medications")
If not blnScreenNavigation Then
	Call WriteToLog("Fail", "Unable to navigate to medications review page")
	Call Terminator 
End If
Call WriteToLog("Pass", "Navigated to medications review page")
Wait 1

'Close all available popups
blnCloseAllAvailablePopups = CloseAllAvailablePopups()
If not blnCloseAllAvailablePopups Then
	Call WriteToLog("Fail","Unable to close message box. " &Err.Description)
	Call Terminator
End If

'Click on PHM Med Review tab
Execute "Set objPharmacistMedReviewTab = "& Environment("WEL_PharmacistMedReviewTab")
blnPharmacistMedReviewTab = ClickButton("Pharmacist Med Review",objPharmacistMedReviewTab,strOutErrorDesc)
If blnPharmacistMedReviewTab Then
	Call WriteToLog("Pass", "PharmacistMedReview tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: PharmacistMedReview tab should be clicked; Actual Result: PharmacistMedReview tab is not clicked " &strOutErrorDesc)
	Call Terminator
End If
Execute "Set objPharmacistMedReviewTab = Nothing"
Wait 2
Call waitTillLoads("Loading...")
Wait 1

'Close all available popups
blnCloseAllAvailablePopups = CloseAllAvailablePopups()
If not blnCloseAllAvailablePopups Then
	Call WriteToLog("Fail","Unable to close message box. " &Err.Description)
	Call Terminator
End If

'---------------------------------------
'Add intervention and Edit intervention
'---------------------------------------
'Click Add (+) button for adding intervention
Execute "Set objInterventionAddIcon = " & Environment("WI_InterventionAddIcon")
Err.Clear
objInterventionAddIcon.highlight
objInterventionAddIcon.click
If Err.Number <> 0 Then
	Call WriteToLog("Fail", "Unable to click on Add Intervention icon. "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass", "Clicked Add Intervention icon")
Execute "Set objInterventionAddIcon = Nothing"
Wait 1

'Add intervention(phm)
blnAddIntervention = AddPHMintervention(strReferredTo, strIntervDisSt, strRevTitleType, strRevTitle, strOutErrorDesc)
If blnAddIntervention Then
	Call WriteToLog("Pass", "Added intervention with required values")
Else
	Call WriteToLog("Fail", "Expected Result: PHM should be able to add intervention with required values; Actual Result: PHM is unable to add intervention with required values")
	Call Terminator
End If
Wait 1

'Edit intervention(phm)
Call FewPreliminarySteps()	
blnEditInterventionStatus = EditInterventionStatus(strPHMInterventionEditStatus, strCurrentVisibleStatusinPHMForPatient, strPHMcoding, dtPHMcodingDate, strOutErrorDesc)
If blnEditInterventionStatus Then
	Call WriteToLog("Pass", "PHM Edited intervention with required values")
Else
	Call WriteToLog("Fail", "Expected Result: PHM should be able to edit intervention with required values; Actual Result: PHM is unable to edit intervention with required values")
	Call Terminator
End If
Wait 1

'Logout PHM
Logout()
Call WriteToLog("Pass","Successfully logged out from PHM User")
Wait 2

'------------------------------------------------------------------------------------PHM ends----------------------------------------------------------------------------------------------------------------------------
'
'------------------------------------------------------------------------------------in RVR----------------------------------------------------------------------------------------------------------------------------------

'-----------------
'Login to RVR user
'-----------------
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("rvr", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator	
End If
Call WriteToLog("Pass","Navigated to user dashboard")
			
'select the patient through global search
blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
If not blnGlobalSearchUsingMemID Then
	Call WriteToLog("Fail","Expected Result: Should be able to select required patient through global search; Actual Result: Unable to select required patient through global search")
	Call Terminator
End If
Call WriteToLog("Pass","Selected required patient through global search")

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")

'---------------------------------------------
'Edit intervention to 'Final Review Completed
'---------------------------------------------
'Navigate to Clinical Management>Medications>PharmacistMedReview tab
blnScreenNavigation =  clickOnSubMenu_WE("Clinical Management->Medications")
If not blnScreenNavigation Then
	Call WriteToLog("Fail", "Unable to navigate to medications review page")
	Call Terminator 
End If
Call WriteToLog("Pass", "Navigated to medications review page")
Wait 1

'Close all available popups
blnCloseAllAvailablePopups = CloseAllAvailablePopups()
If not blnCloseAllAvailablePopups Then
	Call WriteToLog("Fail","Unable to close message box. " &Err.Description)
	Call Terminator
End If

'Click on PHM Med Review tab
Execute "Set objPharmacistMedReviewTab = "& Environment("WEL_PharmacistMedReviewTab")
blnPharmacistMedReviewTab = ClickButton("Pharmacist Med Review",objPharmacistMedReviewTab,strOutErrorDesc)
If blnPharmacistMedReviewTab Then
	Call WriteToLog("Pass", "PharmacistMedReview tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: PharmacistMedReview tab should be clicked; Actual Result: PharmacistMedReview tab is not clicked " &strOutErrorDesc)
	Call Terminator
End If
Execute "Set objPharmacistMedReviewTab = Nothing"
Wait 2
Call waitTillLoads("Loading...")
Wait 1

'Close all available popups
blnCloseAllAvailablePopups = CloseAllAvailablePopups()
If not blnCloseAllAvailablePopups Then
	Call WriteToLog("Fail","Unable to close message box. " &Err.Description)
	Call Terminator
End If

'Edit intervention(RVR)
Call FewPreliminarySteps()
blnEditInterventionStatusInRVR = EditInterventionStatusInRVR(strRVRInterventionEditStatus, strCurrentVisibleStatusinRVR, strReviewerCoding, dtReviewerCodingDate, strOutErrorDesc)
If blnEditInterventionStatusInRVR Then
	Call WriteToLog("Pass", "RVR edited intervention with required values")
Else
	Call WriteToLog("Fail", "Expected Result: RVR should be able to edit intervention with required values; Actual Result: RVR is unable to edit intervention with required values")
	Call Terminator
End If
Wait 1

'Close intervention (RVR)
Call FewPreliminarySteps()
blnCloseIntervention = CloseIntervention()
If blnCloseIntervention Then
	Call WriteToLog("Pass", "RVR closed intervention")
Else
	Call WriteToLog("Fail", "Expected Result: RVR should be able to close intervention; Actual Result: RVR is unable to close intervention")
	Call Terminator
End If
Wait 1

'Validate score card in RVR
Call ValidateMedicationScoreCardMAWF("rvr","Med Advisor Completed")

'Logout from application
Logout()
Call WriteToLog("Pass","Successfully logged out from application")
Wait 2
'------------------------------------------------------------------------------------RVR ends----------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("info", "------------------------------Successfully validated Med Advisor Work Flow for Patient intervention------------------------------")

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'Iteration loop
Loop While False: Next
Wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function CloseAllAvailablePopups()

	On Error Resume Next
	Err Clear
	strOutErrorDesc = ""	
	CloseAllAvailablePopups = False
	
	'Close 'Some Date May Be Out of Date' msgbox
	Execute "Set objSDMBOFDpptleOK = "&Environment("WB_SDMBOFDpptleOK")	
	If objSDMBOFDpptleOK.Exist(3) Then
		Err.Clear
		objSDMBOFDpptleOK.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'Some Data May Be Out of Date' message box OK button." &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked 'Some Data May Be Out of Date' message box OK button")			
	End If
	Execute "Set objSDMBOFDpptleOK = Nothing"
	
	Wait 1
	Call waitTillLoads("Loading...")

	'Close 'Disclaimer' msgbox
	Execute "Set objDisclaimerOK = "&Environment("WB_DisclaimerOK")	
	If objDisclaimerOK.Exist(3) Then
		Err.Clear
		objDisclaimerOK.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'Disclaimer' message box OK button." &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked 'Disclaimer' message box OK button")			
	End If
	Execute "Set objDisclaimerOK = Nothing"
	
	Wait 1
	Call waitTillLoads("Loading...")
	
	CloseAllAvailablePopups = True
	
End Function

Function FewPreliminarySteps()

	On Error Resume Next
	Err Clear
	strOutErrorDesc = ""

	'Click on intervention slider
	Execute "Set objInterventionSlider = " & Environment("WEL_InterventionSlider")
	objInterventionSlider.highlight
	Err.Clear
	objInterventionSlider.click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail", "Unable to click on Intervention slider. "&Err.Description)
		Call Terminator
	End If
	Call WriteToLog("Pass", "Clicked Add Intervention slider")
	Wait 1
	
	'Click drug name
	Execute "Set objDrugName = " & Environment("WEL_DrugName")
	objDrugName.highlight
	Err.Clear
	objDrugName.click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail", "Unable to click on Drug name. "&Err.Description)
		Call Terminator
	End If
	Call WriteToLog("Pass", "Clicked Drug name")
	Wait 1
			
	Execute "Set objInterventionSlider = Nothing"
	Execute "Set objDrugName = Nothing"
	
End Function

Function ValidateMapAndMedlistButtons()
	
	On Error Resume Next
	Err Clear
	strOutErrorDesc = ""
	
	'Validate availability of Send Map and Send Med List after pharmacist med review
	Call WriteToLog("info", "-------Validate availability of Send Map and Send Med List after pharmacist med review-------")
	Execute "Set objPharmacistSendMAP = "&Environment("WB_PharmacistSendMAP")
	If not objPharmacistSendMAP.Exist(2) Then
		Call WriteToLog("Fail","Unable to find 'Send MAP' button after pharmacist med review")
		Call Terminator											
	End If
	Call WriteToLog("Pass","'Send MAP' button is avail after pharmacist med review")
	Execute "Set objPharmacistSendMAP = Nothing"
	
	Execute "Set objPharmacistSendMedList = "&Environment("WB_PharmacistSendMedList")
	If not objPharmacistSendMedList.Exist(2) Then
		Call WriteToLog("Fail","Unable to find 'Send Med List' button after pharmacist med review")
		Call Terminator											
	End If
	Call WriteToLog("Pass","'Send Med List' button is avail after pharmacist med review")
	Execute "Set objPharmacistSendMedList = Nothing"	
	
End Function

Function ValidateMedicationScoreCardMAWF(ByVal strUser, ByVal strValdationString)

	On Error Resume Next
	Err Clear
	strOutErrorDesc = ""
	
	'Click on Patient Snapshot tab
	Execute "Set objPatientSnapshotTab = "& Environment("WL_PatientSnapshotTab")
	blnPatientSnapshotTab = ClickButton("Patient Snapshot",objPatientSnapshotTab,strOutErrorDesc)
	If blnPatientSnapshotTab Then
		Call WriteToLog("Pass", "Patient Snapshot tab is clicked")
	Else
		Call WriteToLog("Fail", "Expected Result: Patient Snapshot tab should be clicked; Actual Result: Patient Snapshot tab is not clicked " &strOutErrorDesc)
		Call Terminator
	End If
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Validate medication score card 
	If Trim(LCase(strUser)) = "phm" Then
	
		Execute "Set objScoreCardContentMedication = " & Environment("WEL_ScoreCardContentMedication")
		
		strMedScoreCardAfterPHMmedReview = Lcase(Replace(objScoreCardContentMedication.GetROPRoperty("outertext")," ","",1,-1,1))
		strValdationString = Lcase(Replace(strValdationString," ","",1,-1,1))
		
		If Instr(1,strMedScoreCardAfterPHMmedReview,strValdationString,1) > 0 Then
			Call WriteToLog("Pass", "'Med Advisor in process' is available under Medications domain of Score Card in PHM")
		Else
			Call WriteToLog("Fail", "'Med Advisor in process' is not available under Medications domain of Score Card in PHM. "&strOutErrorDesc)
			Call Terminator
		End If
		
	End If
	
	If Trim(LCase(strUser)) = "rvr" Then
	
		Execute "Set objScoreCardContentMedication = " & Environment("WEL_ScoreCardContentMedication")
		
		strMedScoreCardAfterPHMmedReview = Lcase(Replace(objScoreCardContentMedication.GetROPRoperty("outertext")," ","",1,-1,1))
		strValdationString = Lcase(Replace(strValdationString," ","",1,-1,1))
		
		'If Instr(1,strMedScoreCardAfterPHMmedReview,"medadvisorcompleted",1) > 0 AND Instr(1,strMedScoreCardAfterPHMmedReview,dateformat(date),1) > 0 Then
		If Instr(1,strMedScoreCardAfterPHMmedReview,strValdationString,1) > 0 Then
			Call WriteToLog("Pass", "'Med Advisor Completed' is available under Medications domain of Score Card in RVR")
		Else
			Call WriteToLog("Fail", "'Med Advisor Completed' is not available under Medications domain of Score Card in RVR."&strOutErrorDesc)
			Call Terminator
		End If
		
	End If
	
	Wait 1
	
	Execute "Set objPatientSnapshotTab = Nothing"
	Execute "Set objScoreCardContentMedication = Nothing"

End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function
