'**************************************************************************************************************************************************************************
' TestCase Name			: MedAdvisorWorkFlow
' Purpose of TC			: Validate MedAdvisor WorkFlow 
' Author                : Amar
' Date                  : 26 Nov. 2015
' Date Modified			: 26 Nov. 2015
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "MedAdvisorWorkFlow", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath


intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)

'------------------------
' Variable initialization
'------------------------
strExecutionFlag = DataTable.Value("ExecutionFlag", "CurrentTestCaseData")
strInterventionTypeForWorkflow = DataTable.Value("InterventionTypeForWorkflow", "CurrentTestCaseData")
strPersonalDetails = DataTable.Value("PersonalDetails", "CurrentTestCaseData") 
strAddressDetails = DataTable.Value("AddressDetails", "CurrentTestCaseData") 
strMedicalDetails = DataTable.Value("MedicalDetails", "CurrentTestCaseData") 
strProgramDetails = DataTable.Value("ProgramDetails", "CurrentTestCaseData") 
strTechScreeningAnswerOptions = DataTable.Value("TechScreeningAnswerOptions", "CurrentTestCaseData")
strAssignedPHM = DataTable.Value("AssignedPHM", "CurrentTestCaseData")
strPostTechScreeningDetails = "Warm Transfer,"&strAssignedPHM
strLabel = DataTable.Value("Label", "CurrentTestCaseData")

'Provider Info
strProviderType= DataTable.Value("ProviderType", "CurrentTestCaseData")
strGender= DataTable.Value("Gender", "CurrentTestCaseData")
strProviderName = DataTable.Value("ProviderName", "CurrentTestCaseData")
strAddressType = DataTable.Value("AddressType", "CurrentTestCaseData")
strAddress = DataTable.Value("Address", "CurrentTestCaseData")
strCITY = DataTable.Value("CITY", "CurrentTestCaseData")
strSTATE = DataTable.Value("STATE", "CurrentTestCaseData")
strZIP = DataTable.Value("ZIP", "CurrentTestCaseData")
strFAX = DataTable.Value("FAX", "CurrentTestCaseData")


If LCase(strLabel) = "na" OR strLabel = "" Then
	strLabel = "Epogen"
End If
dtWrittenDate = DataTable.Value("WrittenDate", "CurrentTestCaseData")
If LCase(dtWrittenDate) = "na" OR dtWrittenDate = "" Then
	dtWrittenDate = Date-5
End If
dtFilledDate = DataTable.Value("FilledDate", "CurrentTestCaseData")
If LCase(dtFilledDate) = "na" OR dtFilledDate = "" Then
	dtFilledDate = Date-5
End If
strFrequency = DataTable.Value("Frequency", "CurrentTestCaseData")
If LCase(strFrequency) = "na" OR strFrequency = "" Then
	strFrequency = "AS NEEDED"
End If
dtPHMReviewDate = DataTable.Value("PHMReviewDate", "CurrentTestCaseData")
If LCase(dtPHMReviewDate) = "na" OR dtPHMReviewDate = "" Then
	dtPHMReviewDate = Date-2
End If
strIntervDisSt = "Diabetes"
strPHMcoding = "Avoided ER"
dtPHMcodingDate = DataTable.Value("PHMcodingDate", "CurrentTestCaseData") 'cannot be less that PHMReview date
If LCase(dtPHMcodingDate) = "na" OR dtPHMcodingDate = "" Then
	dtPHMcodingDate = Date-1
End If
strCurrentVisibleStatusinPHMForPatient = "Open"
strCurrentVisibleStatusinPHM = "Pending MD"
strPHMInterventionEditStatus = "Final Review Needed"
strCurrentVisibleStatusinRVR = "Final Review Needed"
strRVRInterventionEditStatus = "Final Review Completed"
strReviewerCoding = "Avoided ER"
strReferredTo = DataTable.Value("ReferredTo", "CurrentTestCaseData") '"Assessment Nurse" (for patient intervention) / "Administrative Assistant" (for provider intervention)
strTeamType = DataTable.Value("ReferredTo", "CurrentTestCaseData") 'strTeamType = ReferredTo
strRevTitleType= "DIABETIC SUPPLIES NEEDED"
strRevTitleType1= "INSULIN STABILITY"
strRevTitle = "INSULIN STABILITY"  '"INSULIN STABILITY" (for patient intervention) / "DIABETIC SUPPLIES NEEDED" (for provider intervention)
strTeamName = DataTable.Value("TeamName", "CurrentTestCaseData") 
dtReviewerCodingDate = DataTable.Value("ReviewerCodingDate", "CurrentTestCaseData")
If LCase(dtReviewerCodingDate) = "na" OR dtReviewerCodingDate = "" Then
	dtReviewerCodingDate = Date-1
End If
strCardValStringRVR = "Med Advisor Completed:"&DateFormat(dtPHMReviewDate)

'------------------------------------
' Objects required for test execution
'------------------------------------
Execute "Set objPage = " & Environment("WPG_AppParent")
Execute "Set objWarmTfrAlrtExpnd = " & Environment("WEL_WarmTfrAlrtExpnd")
Execute "Set objWarmTfrAlrtClose = " & Environment("WEL_WarmTfrAlrtClose")
Execute "Set objMedReviewTab = " & Environment("WEL_MedReviewTab")
Execute "Set objPharmacistMedReviewTab = "& Environment("WEL_PharmacistMedReviewTab")
Execute "Set objPatientSnapshotTab = "& Environment("WL_PatientSnapshotTab")



'Getting equired iterations
If not Lcase(strExecutionFlag) = "y" Then Exit Do


'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
'
'------------------------------------------------------------------------------------in PTC----------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
Err.Clear

''-----------------
''Login to PTC user
''-----------------
''Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("ptc", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

'Add new patient in PTC user and retrieve MemID
lngCreateNewPatientFromPTC = CreateNewPatientFromPTC(strPersonalDetails, strAddressDetails, strMedicalDetails, strProgramDetails, strOutErrorDesc)
If lngCreateNewPatientFromPTC = "" Then
	Call WriteToLog("Fail", "Expected Result: Member should be added; Actual Result: Error adding Member " &strOutErrorDesc)
	Call Terminator 
End If
Call WriteToLog("Pass", "Member is added successfully from PTC")
Wait 2

'-----------------------------------------------
''Do Tech Screening for newly added patient
'-----------------------------------------------
'Navigate to Screenings > Tech Screenings

Call waitTillLoads("Loading...")
Call clickOnSubMenu1("Screening->Tech Screening")
Wait 5
Call waitTillLoads("Loading Tech Screening...")
Wait 2
Call waitTillLoads("Loading Menu of Actions...")
Wait 1
	
'Tech screening
blnPTCtechscreening =  PTCtechscreening(strTechScreeningAnswerOptions,strPostTechScreeningDetails, strOutErrorDesc)
If blnPTCtechscreening Then
	Call WriteToLog("Pass", "PTCtech screening done successfully")
Else
	Call WriteToLog("Fail", "Expected Result: PTCtech screening should be done successfully; Actual Result: PTCtech screening is not done successfully " &strOutErrorDesc)
	Call Terminator
End If
Wait 5

'Logout PTC
Logout()
Call WriteToLog("Pass","Successfully logged out from PTC User")
Wait 5
'------------------------------------------------------------------------------------PTC ends----------------------------------------------------------------------------------------------------------------------------
'
'------------------------------------------------------------------------------------in PHM----------------------------------------------------------------------------------------------------------------------------------
'--------------------------
'Login to assigned PHM user
'--------------------------
''Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("phm", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator	
End If
Call WriteToLog("Pass","Navigated to user dashboard")
Wait 5

lngMemberID=lngCreateNewPatientFromPTC

'Switch to required roster
blnSelectRequiredRoster = SelectRequiredRoster(strAssignedPHM, strOutErrorDesc)
If not blnSelectRequiredRoster Then
	GetAssingnedUserDashboard = ""
	Call Terminator		
End If
Wait 1

'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
'Check for 'Disclaimer' popup
Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)

Call waitTillLoads("Loading...")
Wait 2

'------------------------------------
'Get patient from warm transefer tray
'------------------------------------

'open warm transfer tray
Set objWarmTfrAlrtExpnd = Nothing
Execute "Set objWarmTfrAlrtExpnd = " & Environment("WEL_WarmTfrAlrtExpnd")
blnWarmTfrAlrtExpnd = ClickButton("",objWarmTfrAlrtExpnd,strOutErrorDesc)
If blnWarmTfrAlrtExpnd Then
	Call WriteToLog("Pass", "Warm Transfer ALerts tray is expanded")
Else
	Call WriteToLog("Fail", "Expected Result: Warm Transfer ALerts tray should be expanded; Actual Result: Warm Transfer ALerts tray is not expanded " &strOutErrorDesc)
	Call Terminator
End If
Wait 5
Call waitTillLoads("Loading...")

'get required patient from warm transfer tray
Set objReqdPatientFromWarmTrTy = objPage.WebElement("class:=ng-binding","html tag:=DIV","visible:=True","outertext:="&Trim(lngMemberID))
Err.Clear
objReqdPatientFromWarmTrTy.highlight
objReqdPatientFromWarmTrTy.Click
'Setting.WebPackage("ReplayType") = 1
'objReqdPatientFromWarmTrTy.FireEvent "ondblclick"
	
If Err.Number = 0 Then
	Call WriteToLog("Pass", "Required patient is selected from warm transfer tray")
Else
	Call WriteToLog("Fail", "Expected Result: Required patient should be selected from warm transfer tray; Actual Result: Required patient is not selected from warm transfer tray " &Err.Description)
	Call Terminator
End If
Wait 10

Call waitTillLoads("Loading...")
Wait 2

'-------------------
'Add Medication
'-------------------
'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
'Check for 'Disclaimer' popup
Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)

Call waitTillLoads("Loading Med Reviews...")
Wait 2

'Click on Medications Review tab
blnMedReviewClicked = ClickButton("Review",objMedReviewTab,strOutErrorDesc)
If blnMedReviewClicked Then
	Call WriteToLog("Pass", "Medication Review tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: Medication Review tab should be clicked; Actual Result: Medication Review tab is not clicked " &strOutErrorDesc)
	Call Terminator 
End If

Call waitTillLoads("Loading Problems...")
Wait 1
Call waitTillLoads("Loading...")
Wait 2
'
'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)

'Add new medication for the patient
blnAddMedication = AddMedication(strLabel, dtWrittenDate, dtFilledDate, strFrequency, strOutErrorDesc)
If blnAddMedication Then
	Call WriteToLog("Pass", "New medication is added successfully")
Else
	Call WriteToLog("Fail", "Expected Result: New medication should be added successfully; Actual Result: Error adding new medication. " &strOutErrorDesc)
	Call Terminator
End If
Wait 2

'-----------------------------
'Perform Pharmacist Med Review
'-----------------------------
'Navigate to Pharmacist Med Review tab
blnPharmacistMedReviewTab = ClickButton("Pharmacist Med Review",objPharmacistMedReviewTab,strOutErrorDesc)
If blnPharmacistMedReviewTab Then
	Call WriteToLog("Pass", "PharmacistMedReview tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: PharmacistMedReview tab should be clicked; Actual Result: PharmacistMedReview tab is not clicked " &strOutErrorDesc)
	Call Terminator
End If

Call waitTillLoads("Loading Med Reviews...")
Wait 2

'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)

'Add med review
blnAddPharmacistMedReview = AddPharmacistMedReview(dtPHMReviewDate, "VHN Referrals", strOutErrorDesc)
If blnAddPharmacistMedReview Then
	Call WriteToLog("Pass", "Pharmacist med review is done successfully")
Else
	Call WriteToLog("Fail", "Expected Result: User should be able to do Pharmacist med review; Actual Result: Unable to do Pharmacist med review. " &strOutErrorDesc)
	Call Terminator 
End If
Wait 2

'----------------------
'Validate score card
'---------------------
'Click on Patient Snapshot tab
blnPatientSnapshotTab = ClickButton("Patient Snapshot",objPatientSnapshotTab,strOutErrorDesc)
If blnPatientSnapshotTab Then
	Call WriteToLog("Pass", "Patient Snapshot tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: Patient Snapshot tab should be clicked; Actual Result: Patient Snapshot tab is not clicked " &strOutErrorDesc)
	Call Terminator
End If
Wait 5

Call waitTillLoads("Loading...")
Wait 2

'validate medication score card
blnScoreCardValidationAfterPHMmedReview =  getFullTaskDetails("Medication", "Med Advisor")
If Instr(1,blnScoreCardValidationAfterPHMmedReview,"Med Advisor in process",1) > 0 Then
	Call WriteToLog("Pass", "'Med Advisor in process' is available under Medications domain of Score Card")
Else
	Call WriteToLog("Fail", "Expected Result: 'Med Advisor in process' should be available under Medications domain of Score Card; Actual Result: 'Med Advisor in process' is not available under Medications domain of Score Card."&strOutErrorDesc)
	Call Terminator
End If
Wait 2

'Performing AddProvider(if intervention type required is provder)
If Lcase(Trim(strInterventionTypeForWorkflow)) = "provider" Then
	Call clickOnSubMenu1("Member Info->Provider Info")
	Call waitTillLoads("Loading...")
	Call AddProvider(strProviderType,strGender,strProviderName,strAddressType,strAddress,strCITY,strSTATE,strZIP,strFAX, strOutErrorDesc)
End If

'-----------------------------------------------------------------------
'Add intervention to medication and make status as 'Final Review Needed
'-----------------------------------------------------------------------
'Navigate to Clinical Management>Medications>PharmacistMedReview tab
Call clickOnSubMenu("Clinical Management->Medications")
Wait 2
Call waitTillLoads("Loading Problems...")
Call waitTillLoads("Loading...")
Call waitTillLoads("Loading Med Reviews...")

'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1
'Check for 'Disclaimer' popup
Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1
'
'Click on PHM Med Review tab
Set objPharmacistMedReviewTab = Nothing
Execute "Set objPharmacistMedReviewTab = "& Environment("WEL_PharmacistMedReviewTab")
blnPharmacistMedReviewTab = ClickButton("Pharmacist Med Review",objPharmacistMedReviewTab,strOutErrorDesc)
If blnPharmacistMedReviewTab Then
	Call WriteToLog("Pass", "PharmacistMedReview tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: PharmacistMedReview tab should be clicked; Actual Result: PharmacistMedReview tab is not clicked " &strOutErrorDesc)
	Call Terminator
End If
Wait 1
Call waitTillLoads("Loading Med Reviews...")
Wait 2

'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1
'Check for 'Disclaimer' popup
Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1

If Lcase(Trim(strInterventionTypeForWorkflow)) = "patient" Then
'	Add intervention(PHM) 
	PHMAddInte = "Call AddPHMintervention(strReferredTo, strIntervDisSt, strRevTitleType1, strRevTitle, strOutErrorDesc)"
	blnInterventionActions = InterventionActions(PHMAddInte)
	If blnInterventionActions Then
		Call WriteToLog("Pass", "Added intervention with required values")
	Else
		Call WriteToLog("Fail", "Expected Result: PHM should be able to add intervention with required values; Actual Result: PHM is unable to add intervention with required values")
		Call Terminator
	End If
End If

If Lcase(Trim(strInterventionTypeForWorkflow)) = "provider" Then
'	Add intervention(PHM)
	PHMAddInte = "Call AddPHMintervention(strReferredTo, strIntervDisSt, strRevTitleType, strRevTitle, strOutErrorDesc)"
	blnInterventionActions = InterventionActions(PHMAddInte)
	If blnInterventionActions Then
		Call WriteToLog("Pass", "Added intervention with required values")
	Else
		Call WriteToLog("Fail", "Expected Result: PHM should be able to add intervention with required values; Actual Result: PHM is unable to add intervention with required values")
		Call Terminator
	End If
End If

If Lcase(Trim(strInterventionTypeForWorkflow)) = "patient" Then
'	Edit intervention(PHM)
	PHMEditInte = "Call EditInterventionStatus(strPHMInterventionEditStatus, strCurrentVisibleStatusinPHMForPatient, strPHMcoding, dtPHMcodingDate, strOutErrorDesc)"
	blnInterventionActions = InterventionActions(PHMEditInte)
	If blnInterventionActions Then
		Call WriteToLog("Pass", "PHM Edited intervention with required values")
	Else
		Call WriteToLog("Fail", "Expected Result: PHM should be able to edit intervention with required values; Actual Result: PHM is unable to edit intervention with required values")
		Call Terminator
	End If
End If

'Performing AddingTeam for Provider, Sending MD fax (if intervention type required is provder)
lngMemberID=lngCreateNewPatientFromPTC
If Lcase(Trim(strInterventionTypeForWorkflow)) = "provider" Then
	Call MDFaxAction(lngMemberID)
End If

If Lcase(Trim(strInterventionTypeForWorkflow)) = "provider" Then
'	Edit intervention(PHM)
	PHMEditInte = "Call EditInterventionStatus(strPHMInterventionEditStatus, strCurrentVisibleStatusinPHM, strPHMcoding, dtPHMcodingDate, strOutErrorDesc)"
	blnInterventionActions = InterventionActions(PHMEditInte)
	If blnInterventionActions Then
		Call WriteToLog("Pass", "PHM Edited intervention with required values")
	Else
		Call WriteToLog("Fail", "Expected Result: PHM should be able to edit intervention with required values; Actual Result: PHM is unable to edit intervention with required values")
		Call Terminator
	End If
End If
Wait 5

'Logout PHM
Logout()
Call WriteToLog("Pass","Successfully logged out from PHM User")
Wait 5
'
'------------------------------------------------------------------------------------PHM ends----------------------------------------------------------------------------------------------------------------------------
'
'------------------------------------------------------------------------------------in RVR----------------------------------------------------------------------------------------------------------------------------------
'
'-----------------
'Login to RVR user
'-----------------
'
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("rvr", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator	
End If
Call WriteToLog("Pass","Navigated to user dashboard")
Wait 5
										
'select the patient through global search
blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
If not blnGlobalSearchUsingMemID Then
	Call WriteToLog("Fail","Expected Result: Should be able to select required patient through global search; Actual Result: Unable to select required patient through global search")
	Call Terminator
End If
Call WriteToLog("Pass","Selected required patient through global search")
Wait 5

Call waitTillLoads("Loading...")
Wait 2
Call waitTillLoads("Loading...")
Wait 1

'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1
'Check for 'Disclaimer' popup
Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1


'---------------------------------------------
'Edit intervention to 'Final Review Completed
'---------------------------------------------
'Navigate to Clinical Management>Medications>PharmacistMedReview tab
Err.clear
Call clickOnSubMenu("Clinical Management->Medications")
Wait 2
Call waitTillLoads("Loading Problems...")
Call waitTillLoads("Loading...")
Call waitTillLoads("Loading Med Reviews...")

'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1
'Check for 'Disclaimer' popup
Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1

'Click on PHM Med Review tab
Set objPharmacistMedReviewTab = Nothing
Execute "Set objPharmacistMedReviewTab = "& Environment("WEL_PharmacistMedReviewTab")
blnPharmacistMedReviewTab = ClickButton("Pharmacist Med Review",objPharmacistMedReviewTab,strOutErrorDesc)
wait 5

'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1

If blnPharmacistMedReviewTab Then
	Call WriteToLog("Pass", "PharmacistMedReview tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: PharmacistMedReview tab should be clicked; Actual Result: PharmacistMedReview tab is not clicked " &strOutErrorDesc)
	Call Terminator
End If
Wait 1
Call waitTillLoads("Loading Med Reviews...")
Wait 2

'Some Date May Be Out of Date' popup
Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1
'Check for 'Disclaimer' popup
Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
Wait 1

'Edit intervention(RVR)
RVREditInte = "Call EditInterventionStatusInRVR(strRVRInterventionEditStatus, strCurrentVisibleStatusinRVR, strReviewerCoding, dtReviewerCodingDate, strOutErrorDesc)"
blnInterventionActions = InterventionActions(RVREditInte)
If blnInterventionActions Then
	Call WriteToLog("Pass", "RVR edited intervention with required values")
Else
	Call WriteToLog("Fail", "Expected Result: RVR should be able to edit intervention with required values; Actual Result: RVR is unable to edit intervention with required values")
	Call Terminator
End If

'--------------------------
'RVR closes intervention
'---------------------------
RVRCloseInte = "Call CloseIntervention()"
blnInterventionActions = InterventionActions(RVRCloseInte)
If blnInterventionActions Then
	Call WriteToLog("Pass", "RVR closed intervention")
Else
	Call WriteToLog("Fail", "Expected Result: RVR should be able to close intervention; Actual Result: RVR is unable to close intervention")
	Call Terminator
End If

''-----------------------------
''VALIDATING RVR SCORE CARD
''-----------------------------
'Click on Patient Snapshot tab
Execute "Set objPatientSnapshotTab = Nothing" 
Execute "Set objPatientSnapshotTab = "& Environment("WL_PatientSnapshotTab")
blnPatientSnapshotTab = ClickButton("Patient Snapshot",objPatientSnapshotTab,strOutErrorDesc)
If blnPatientSnapshotTab Then
	Call WriteToLog("Pass", "Patient Snapshot tab is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: Patient Snapshot tab should be clicked; Actual Result: Patient Snapshot tab is not clicked " &strOutErrorDesc)
	Call Terminator
End If
Wait 5

Call waitTillLoads("Loading...")
Wait 2

'Validate score card
strScoreCardValidationAfterRVRInter =  getFullTaskDetails("Medication", "Med Advisor")
If Instr(1,strScoreCardValidationAfterRVRInter,strCardValStringRVR,1) > 0 Then
	Call WriteToLog("Pass", "'"&strCardValStringRVR&"' is available under Medications domain of Score Card")
Else
	Call WriteToLog("Fail", "Expected Result: '"&strCardValStringRVR&"' should be available under Medications domain of Score Card; Actual Result: '"&strCardValStringRVR&"' is not available under Medications domain of Score Card."&strOutErrorDesc)
	Call Terminator
End If

'Logout from application
Logout()
Call WriteToLog("Pass","Successfully logged out from application")
Wait 5
'------------------------------------------------------------------------------------RVR ends----------------------------------------------------------------------------------------------------------------------------

Call SetObjectsFree()

'Iteration loop
Loop While False: Next
Wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function InterventionActions(ByVal strActionReqd)

	On Error Resume Next
	Err.Clear
	InterventionActions = False	
	
'	object for Medications Included pane
	Set objMedicationsIncluded = objPage.WebElement("html id:=parent11","html tag:=DIV","visible:=True")
	
'	object for Interventions small tab in Medications Included pane
	Set oInterSmallTab = Description.Create
	oInterSmallTab("micclass").value = "WebElement"
	oInterSmallTab("html tag").value = "DIV"
	oInterSmallTab("outertext").value = ".*INTERVENTIONS.*"
	oInterSmallTab("outertext").regularexpression = True
	oInterSmallTab("class").value = ".*col-md-12 remove-padding ng-binding.*"
	oInterSmallTab("class").regularexpression = True
	Set objInterventionSmallTab = objMedicationsIncluded.ChildObjects(oInterSmallTab)
	
	For q = 0 To objInterventionSmallTab.count-1 Step 1
		blnRequiredIntervention = RequiredIntervention(objInterventionSmallTab, q, strActionReqd)
		If not blnRequiredIntervention Then
			Exit Function
		End If
	Next
	
	InterventionActions = True
	
	Set objMedicationsIncluded = Nothing
	Set oInterSmallTab = Nothing
	Set objInterventionSmallTab = Nothing
	
End Function

Function RequiredIntervention(ByVal objInterventionSmallTab, ByVal q, ByVal strAction)

	On Error Resume Next
	Err.Clear
	RequiredIntervention = False	

	Execute "Set objInterventionEdit = " & Environment("WB_InterventionEdit")
	Execute "Set objMDFax = " & Environment("WB_MDFax")

	RequiredIntervention = ""
	
'	object medication pane
	Set objMedicationsIncluded = objPage.WebElement("html id:=parent11","html tag:=DIV","visible:=True")
	
'	Add icon object
	Set oInterven = Description.Create
	oInterven("micclass").value = "Image"
	oInterven("html tag").value = "IMG"
	oInterven("outerhtml").value = ".*Add Intervention.*"
	oInterven("outerhtml").regularexpression = True
	oInterven("title").value = "Add Intervention"
	Set objAddInterventionIcon = objMedicationsIncluded.ChildObjects(oInterven)
	
''	object for Interventions' information parent field (visible when Interventions small tab is clicked) in Medications Included pane
	Set oDesc = Description.Create
	oDesc("micclass").value = "WebElement"
	oDesc("html tag").value = "DIV"
	oDesc("class").value = ".*col-md-12  remove-padding.*"
	oDesc("class").RegularExpression = True
	Set objInterventionsInfoParent = objMedicationsIncluded.ChildObjects(oDesc)	
	
''	object for Interventions' information (parent field's) children 
'	Set oDesc1 = Description.Create
'	oDesc1("micclass").value = "WebElement"
'	oDesc1("html tag").value = "DIV"
'	oDesc1("class").value = "col-md-10 ng-scope"
'	oDesc1("innertext").value = "MRP:.*"
'	oDesc1("innertext").regularexpression = True	
	Execute "Set objPage = " & Environment("WPG_AppParent")
	Set oDesc1 = objPage.WebElement("class:=col-md-10 ng-scope","html tag:=DIV","innertext:=MRP:.*")
	
	Err.Clear
	add intervention
	For intAddIconCount = 0 To objAddInterventionIcon.Count-1 Step 1
		If Instr(1,strAction,"Add",1) Then
			For intInterv = 0 To objAddInterventionIcon.Count-1 Step 1
				objAddInterventionIcon(intInterv).Click
				Wait 1	
				Execute strAction
			Next
		End If
	Next		
		
'	Err.Clear
'	edit intervention
'	If Instr(1,strAction,"Edit",1) Then
'		objInterventionSmallTab(q).Highlight
'		objInterventionSmallTab(q).Click	'open med info		
'		IC = Left(objInterventionSmallTab(q).GetROProperty("outertext"),1)
'		Set objInterventionChild = objInterventionsInfoParent(q).ChildObjects(oDesc1)		
'		For intI = 0 To IC-1 Step 1
'			wait 4
'			objInterventionChild(intI).highlight
'			objInterventionChild(intI).click
''			Setting.WebPackage("ReplayType") = 2
''			objInterventionChild(intI).FireEvent "ondblclick"			
'			If objInterventionEdit.Exist(1) Then
'				Execute strAction
'			End If
'		Next
'		objInterventionSmallTab(q).Click	'close med info 
'	End If
	
	Err.Clear
	edit intervention
	If Instr(1,strAction,"Edit",1) Then
		objInterventionSmallTab(q).Highlight
		objInterventionSmallTab(q).Click	'open med info	
		oDesc1.highlight
		oDesc1.click		
'		IC = Left(objInterventionSmallTab(q).GetROProperty("outertext"),1)
'		Set objInterventionChild = objInterventionsInfoParent(q).ChildObjects(oDesc1)		
'		For intI = 0 To IC-1 Step 1
'			wait 4
'			objInterventionChild(intI).highlight
'			objInterventionChild(intI).click
'			
''			Setting.WebPackage("ReplayType") = 2
''			objInterventionChild(intI).FireEvent "ondblclick"			
			If objInterventionEdit.Exist(1) Then
				Execute strAction
			End If
'		Next
		objInterventionSmallTab(q).Click	'close med info 
	End If
	
	
'	Err.Clear
'	close intervention
'	If Instr(1,strAction,"Close",1) Then
'		objInterventionSmallTab(q).Highlight
'		objInterventionSmallTab(q).Click	'open med info		
'		IC = Left(objInterventionSmallTab(q).GetROProperty("outertext"),1)
'		Set objInterventionChild = objInterventionsInfoParent(q).ChildObjects(oDesc1)		
'		For intI = 0 To IC-1 Step 1
'			objInterventionChild(intI).click		
'			If objInterventionEdit.Exist(1) Then
'				Execute strAction
'			End If
'		Next
'		objInterventionSmallTab(q).Click	'close med info 
'	End If
	
	Err.Clear
	close intervention
	If Instr(1,strAction,"Close",1) Then
		objInterventionSmallTab(q).Highlight
		objInterventionSmallTab(q).Click	'open med info	
		oDesc1.highlight
		oDesc1.click		
'		IC = Left(objInterventionSmallTab(q).GetROProperty("outertext"),1)
'		Set objInterventionChild = objInterventionsInfoParent(q).ChildObjects(oDesc1)		
'		For intI = 0 To IC-1 Step 1
'			objInterventionChild(intI).click		
			If objInterventionEdit.Exist(1) Then
				Execute strAction
			End If
'		Next
		objInterventionSmallTab(q).Click	'close med info 
	End If
	
	Err.Clear
	send MDFax
'	If Instr(1,strAction,"Fax",1) Then
'		objInterventionSmallTab(q).Highlight
'		objInterventionSmallTab(q).Click	'open med info		
'		IC = Left(objInterventionSmallTab(q).GetROProperty("outertext"),1)
'		Set objInterventionChild = objInterventionsInfoParent(q).ChildObjects(oDesc1)		
'		For intI = 0 To IC-1 Step 1
'			objInterventionChild(intI).click		
'			If objMDFax.Exist(1) Then
'				Execute strAction
'			End If
'		Next
'		objInterventionSmallTab(q).Click	'close med info 
'	End If
	
		If Instr(1,strAction,"Fax",1) Then
		objInterventionSmallTab(q).Highlight
		wait 1
		objInterventionSmallTab(q).Click	'open med info	
		oDesc1.highlight
		oDesc1.click		
'		IC = Left(objInterventionSmallTab(q).GetROProperty("outertext"),1)
'		Set objInterventionChild = objInterventionsInfoParent(q).ChildObjects(oDesc1)		
'		For intI = 0 To IC-1 Step 1
'			objInterventionChild(intI).click

		Execute "Set objMDFaxBtn = " & Environment("WB_MDFaxBtn")
			If objMDFaxBtn.Exist(1) Then
				Execute strAction
			End If
'		Next
		objInterventionSmallTab(q).Click	'close med info 
	End If
	
	RequiredIntervention = True
	
	Set objInterventionEdit = Nothing
	Set objMedicationsIncluded = Nothing
	Set oInterven = Nothing
	Set objAddInterventionIcon = Nothing
	Set oDesc = Nothing
	Set objInterventionsInfoParent = Nothing
	Set oDesc1 = Nothing
	Set objInterventionChild = Nothing
	
End Function
	
	
Function SendMDFax()

	Err.Clear
	On Error Resume Next
	strOutErrorDesc = ""
	SendMDFax = False
	
	Execute "Set objMDFaxBtn = " & Environment("WB_MDFaxBtn")
	Execute "Set objChooseRecipientsPPheader = " & Environment("WEL_ChooseRecipientsPPheader")
	Execute "Set objChooseRecipientsPPchkBox = " & Environment("WCB_ChooseRecipientsPPchkBox")
	Execute "Set objChooseRecipientsPPok = " & Environment("WB_ChooseRecipientsPPok")
	Execute "Set objMDFaxReportHeader = " & Environment("WEL_MDFaxReportHeader")
	Execute "Set objSendAllMDFax = " & Environment("WEL_SendAllMDFax")
	
	blnMDFaxBtn = ClickButton("MD Fax",objMDFaxBtn,strOutErrorDesc)
	Wait 1
	
	objChooseRecipientsPPheader.highlight
	blnChooseRecipientsPopup = waitUntilExist(objChooseRecipientsPPheader, 10)
	Wait 1
	
	Err.Clear	
	For faxCB = 0 To 5 Step 1
		objPage.WebCheckBox("html tag:=INPUT","name:=chkbox","outerhtml:=.*data-capella-automation-id=""dataItem\.CheckBoxValue.*","visible:=True","index:="&faxCB).Click
		If Err.Number <> 0 Then
			Exit For
		End If
	Next
	Err.Clear		
	Wait 1
	
	blnChooseRecipientsPPok = ClickButton("OK",objChooseRecipientsPPok,strOutErrorDesc)
	Wait 1
	
	Call waitTillLoads("Loading...")
	
	blnMDFaxReportHeader = waitUntilExist(objMDFaxReportHeader, 10)
	Wait 1
	
	blnSendAllMDFax = ClickButton("Send All",objSendAllMDFax,strOutErrorDesc)
	Wait 1
	
	Call waitTillLoads("Loading...")

	
''	Validate 'Confirmation' popup
'	Clk OK btn of popup

	strMessageTitle = "Confirmation"
	strMessageBoxText = "Your request was submitted."
'	Check the message box having text as "Your request was submitted."
	blnReturnValue = checkForPopup(strMessageTitle, "Ok", strMessageBoxText, strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Your request was submitted.' message box is not existing / Not clicked OK on popup "& strOutErrorDesc
		Exit Function
	End If
	Wait 2
	SendMDFax = True
	
	Execute "Set objMDFaxBtn = Nothing"
	Execute "Set objChooseRecipientsPPheader = Nothing"
	Execute "Set objChooseRecipientsPPchkBox = Nothing"
	Execute "Set objChooseRecipientsPPok = Nothing"
	Execute "Set objMDFaxReportHeader = Nothing"
	Execute "Set objSendAllMDFax = Nothing"
	
End Function


Function AddProvider(ByVal strProviderType,ByVal strGender,ByVal strProviderName,ByVal strAddressType,ByVal strAddress,ByVal strCITY,ByVal strSTATE,ByVal strZIP,ByVal strFAX, strOutErrorDesc)

On Error Resume Next
Err.Clear
AddProvider = False
strOutErrorDesc = ""

Execute "Set objPage = " & Environment("WPG_AppParent")
Execute "Set objAddProviderBtn = " & Environment("WB_AddProviderBtn")
Execute "Set objAddNewProvider = " & Environment("WB_AddNewProvider")
Execute "Set objProviderDetail = " & Environment("WE_ProviderDetail")
Execute "Set objProviderName = " & Environment("WE_ProviderName")
Execute "Set objNextBtn = " & Environment("WB_NextBtn")
Execute "Set objPSNextBtn = " & Environment("WB_PSNextBtn")
Execute "Set objAddress = " & Environment("WE_Address1")
Execute "Set objZIP = " & Environment("WE_ZIP1")
Execute "Set objFAX = " & Environment("WB_FAX1")
Execute "Set objFAXCHBOX = " & Environment("WB_FAXCHBOX")
Execute "Set objSaveBtn = " & Environment("WB_SaveBtn")

'Click on Add Provider Button
blnAddProviderBtn = ClickButton("Add Provider",objAddProviderBtn,strOutErrorDesc)
If blnAddProviderBtn Then
	Call WriteToLog("Pass", "Add Provider Button is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: Add Provider Button should be clicked; Actual Result: Add Provider Button is not clicked " &strOutErrorDesc)
	Exit Function
End If
Wait 5

Call waitTillLoads("Loading...")
Wait 2

'Select Provider Type
blnProviderType = selectComboBoxItem(objAddNewProvider, strProviderType)
If Not blnProviderType Then
	strOutErrorDesc = "Provider Type selection returned error: "&strOutErrorDesc
	Call WriteToLog("Fail","Expected Result: User should be able to select Provider Type.  Actual Result: " &strOutErrorDesc)
	Exit Function
	End If
Call WriteToLog("PASS","Selected required Provider Type")
wait 1

'Validate Provider Detail page navigation
If Not objProviderDetail.exist(5) Then
	Call WriteToLog("Fail","Expected Result: User should be navigated to Provider Detail page.  Actual Result: Unable to navigate to Provider Detail page")
	Exit Function
End If
Call WriteToLog("PASS","Navigated to Provider Detail page")

'Set name of Provider
If waitUntilExist(objProviderName, 10) Then
	Err.Clear
	objProviderName.Set strProviderName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Provider Name field is not set. " & Err.Description
		Exit Function
	End If
End If
Call WriteToLog("Pass", strProviderName & "is set to Provider Name field.")
wait 1

set objPGender=objPage.WebElement("class:=col-md-12 padding-left-5px","html tag:=DIV","outertext:=  Male Female Not Applicable Accepts ReportsAccepts RFIVerified Patient","innertext:=  Male Female Not Applicable Accepts ReportsAccepts RFIVerified Patient")
objPGender.highlight
set objGender=objPGender.WebButton("class:=btn btn-default dropdown.*","html id:=dropdownMenu1","html tag:=BUTTON","type:=button")
objGender.highlight

'Select Gender Type
blnGenderType = selectComboBoxItem(objGender, strGender)
If Not blnGenderType Then
	strOutErrorDesc = "Gender Type selection returned error: "&strOutErrorDesc
	Call WriteToLog("Fail","Expected Result: User should be able to select Gender Type.  Actual Result: " &strOutErrorDesc)
	Exit Function
	End If
Call WriteToLog("PASS","Selected required Gender Type")
wait 1

'Click Next Button of Provider Detail
Err.Clear
objNextBtn.Click
If Err.Number <> 0 Then
	strOutErrorDesc = "Provider Next Button is not Clicked. " & Err.Description
	Exit Function
End If

Call WriteToLog("Pass", "Provider Next Button is  Clicked Successfully.")
wait 1


set objPaddress=objPage.WebElement("class:=col-md-3","html tag:=DIV","outertext:=Select a value   Select a value  Mailing  Other  Service  ","innertext:=Select a value   Select a value  Mailing  Other  Service  ")
set objAddTypeBtn=objPaddress.WebButton("html id:=dropdownMenu1","outertext:=Select a value ","type:=button","name:=Select a value ","index:=8")
'Select Address Type
blnAddressType = selectComboBoxItem(objAddTypeBtn, strAddressType)
If Not blnAddressType Then
	strOutErrorDesc = "Address Type selection returned error: "&strOutErrorDesc
	Call WriteToLog("Fail","Expected Result: User should be able to select Address Type.  Actual Result: " &strOutErrorDesc)
	Exit Function
	End If
Call WriteToLog("PASS","Selected required Address Type")
wait 1


'Set Address
If waitUntilExist(objAddress, 10) Then
	Err.Clear
	objAddress.Set strAddress
	If Err.Number <> 0 Then
		strOutErrorDesc = "Address field is not set. " & Err.Description
		Exit Function
	End If
End If
Call WriteToLog("Pass", strAddress & "is set to Address field.")
Wait 1

set objPCity=objPage.WebElement("class:=col-md-12 padding-5-0-10-5","html tag:=DIV","outertext:= Select a value   Select a value Alabama Alaska American Samoa Arizona Arkansas California Colorado Connecticut Delaware District of Columbia Florida Georgia Guam Hawaii Idaho Illinois Indiana Iowa Kansas Kentucky Louisiana Maine Maryland Massachusetts Michigan Minnesota Mississippi Missouri Montana Nebraska Nevada New Hampshire New Jersey New Mexico New York North Carolina North Dakota Ohio Oklahoma Oregon Other Non US Pennsylvania Puerto Rico Rhode Island South Carolina South Dakota Tennessee Texas Utah Vermont Virgin Islands, U\.S\. Virginia Washington West Virginia Wisconsin Wyoming   ")
Set objCITY=objPCity.WebEdit("class:=custom-input ng-pristine ng-untouched ng-valid","html tag:=INPUT","name:=WebEdit","type:=text")

'Set CITY
If waitUntilExist(objCITY, 10) Then
	Err.Clear
	objCITY.Set strCITY
	If Err.Number <> 0 Then
		strOutErrorDesc = "CITY field is not set. " & Err.Description
		Exit Function
	End If
End If
Call WriteToLog("Pass", strCITY & "is set to CITY field.")
Wait 1

set objPState=objPage.WebElement("class:=col-md-12 padding-5-0-10-5","html tag:=DIV","outertext:= Select a value   Select a value Alabama Alaska American Samoa Arizona Arkansas California Colorado Connecticut Delaware District of Columbia Florida Georgia Guam Hawaii Idaho Illinois Indiana Iowa Kansas Kentucky Louisiana Maine Maryland Massachusetts Michigan Minnesota Mississippi Missouri Montana Nebraska Nevada New Hampshire New Jersey New Mexico New York North Carolina North Dakota Ohio Oklahoma Oregon Other Non US Pennsylvania Puerto Rico Rhode Island South Carolina South Dakota Tennessee Texas Utah Vermont Virgin Islands, U\.S\. Virginia Washington West Virginia Wisconsin Wyoming   ")
set objStateBtn=objPState.WebButton("html id:=dropdownMenu1","outertext:=Select a value ","type:=button","name:=Select a value ")

'Select State 
blnAddressType = selectComboBoxItem(objStateBtn, strSTATE)
If Not blnAddressType Then
	strOutErrorDesc = "STATE selection returned error: "&strOutErrorDesc
	Call WriteToLog("Fail","Expected Result: User should be able to select STATE.  Actual Result: " &strOutErrorDesc)
			Exit Function
	End If
Call WriteToLog("PASS","Selected required STATE")
wait 1

'Set ZIP
Execute "Set objZIP = Nothing"
Execute "Set objZIP = " & Environment("WE_ZIP1")
If waitUntilExist(objZIP, 10) Then
	Err.Clear
	
	objZIP.Set strZIP
	If Err.Number <> 0 Then
		strOutErrorDesc = "ZIP field is not set. " & Err.Description
		Exit Function
	End If
End If
Call WriteToLog("Pass", strZIP & "is set to ZIP field.")

Call waitTillLoads("Loading...")

set ObjZipVP=objPage.WebElement("class:=row left-right-0-margin.*","html tag:=DIV","visible:=True","outertext:=Adak, AK, 99571  ")
Set ObjZipCB=ObjZipVP.WebElement("class:=check-no whitebg","html tag:=DIV","visible:=True")
ObjZipCB.click



Set ObjZipMsg=objPage.WebElement("class:=col-md-12 col-xs-12.*","html tag:=DIV","outertext:=I am aware this combination of City, State and Zip is not valid and I want to save this record\.  ","visible:=True")
If ObjZipMsg.Exist(1) Then
	ObjZipMsg.click
End If
Set ObjZipVPOKBtn=objPage.WebButton("class:=btn font-white.*","html tag:=INPUT","name:=Ok","type:=button","visible:=True")
ObjZipVPOKBtn.click
Call waitTillLoads("Loading...")
Execute "Set objZIP = Nothing"

'Set FAX
Execute "Set objFAX = Nothing"
Execute "Set objFAX = " & Environment("WB_FAX1")

If waitUntilExist(objFAX, 10) Then
	Err.Clear
	objFAX.Set strFAX
	If Err.Number <> 0 Then
		strOutErrorDesc = "FAX field is not set. " & Err.Description
		Exit Function
	End If
End If
Call WriteToLog("Pass", strFAX & "is set to FAX field.")
Wait 1

Execute "Set objFAX = Nothing"

'Click Fax Number Verified Checkbox
Execute "Set objFAXCHBOX = Nothing"
Execute "Set objFAXCHBOX = " & Environment("WB_FAXCHBOX")
Err.Clear
objFAXCHBOX.Click
If Err.Number <> 0 Then
	strOutErrorDesc = "Fax Number Verified Checkbox is not Clicked. " & Err.Description
	Exit Function
End If

Call WriteToLog("Pass", "Fax Number Verified Checkbox is  Clicked Successfully.")
wait 1

Execute "Set objFAXCHBOX = Nothing"


Execute "Set objPSNextBtn = Nothing"
Execute "Set objPSNextBtn = " & Environment("WB_PSNextBtn")

'Click Next Button of Provider Address
Err.Clear
objPSNextBtn.Click
If Err.Number <> 0 Then
	strOutErrorDesc = "Provider Search Next Button is not Clicked. " & Err.Description
	Exit Function
End If

Call WriteToLog("Pass", "Provider SearchNext Button is  Clicked Successfully.")
wait 1

Execute "Set objPSNextBtn = Nothing"
Execute "Set objPSNextBtn = " & Environment("WB_PSNextBtn")

'Click Next Button of Provider Address
Err.Clear
objPSNextBtn.Click
If Err.Number <> 0 Then
	strOutErrorDesc = "Provider Search Next Button is not Clicked. " & Err.Description
	Exit Function
End If

Call WriteToLog("Pass", "Provider SearchNext Button is  Clicked Successfully.")
wait 1

blnAddProviderBtn = ClickButton("Save",objSaveBtn,strOutErrorDesc)
If blnAddProviderBtn Then
	Call WriteToLog("Pass", "Save Button is clicked")
Else
	Call WriteToLog("Fail", "Expected Result: Save Button should be clicked; Actual Result: Save Button is not clicked " &strOutErrorDesc)
	Call Terminator
End If
Wait 5

Call waitTillLoads("Loading...")
Wait 2

strMessageTitle = "Changes Saved"
strMessageBoxText = "Changes saved successfully."

'Check the message box having text as "Changes saved successfully."
blnReturnValue = checkForPopup(strMessageTitle, "Ok", strMessageBoxText, strOutErrorDesc)
If not blnReturnValue Then
	strOutErrorDesc = "'Changes saved successfully.' message box is not existing / Not clicked OK on popup "& strOutErrorDesc
	Exit Function
End If
Wait 2

AddProvider = True

Set objAddProviderBtn = Nothing
Set objAddNewProvider = Nothing	
Set objProviderName = Nothing
Set objGender = Nothing
Set objNextBtn = Nothing
Set objPSNextBtn = Nothing
Set objAddTypeBtn = Nothing
Set objAddress = Nothing
Set objCITY = Nothing
Set objZIP = Nothing
Set objStateBtn = Nothing
Set objFAX = Nothing
Set objFAXCHBOX = Nothing
Set objSaveBtn = Nothing

End Function

Function AddTeamForProvider(ByVal strTeamType,ByVal strTeamName, strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	AddTeamForProvider = False
	strOutErrorDesc = ""
	
	Execute "Set objAddTeamBtn = " & Environment("WB_AddTeamBtn")
	Execute "Set objAddTeamPPwindow = " & Environment("WEL_AddTeamPPwindow")	
	Execute "Set objAddTeamPPheader = " & Environment("WEL_AddTeamPPheader")
	Execute "Set objAddTeamName = " & Environment("WE_AddTeamName")
	Execute "Set objAddTeamSaveBtn = " & Environment("WB_AddTeamSaveBtn")
	Set objAddTeamPPTeamTypeDD = objAddTeamPPwindow.WebButton("html id:=dropdownMenu1","html tag:=BUTTON","outerhtml:=.*isTypeDrpDwnEditable.*","type:=button")
	
	blnAddTeamBtn = ClickButton("Add Team",objAddTeamBtn,strOutErrorDesc)
	
'	Verify Add team header
	If not waitUntilExist(objAddTeamPPheader, 10) Then
		strOutErrorDesc = "Add Team popup is not available"
		Exit Function
	End If
	
'	Select reqd Team Type (TeamType same as choice made previously from 'Referred To' dropdown)
	blnReturnValue = selectComboBoxItem(objAddTeamPPTeamTypeDD, strTeamType)
	
	Wait 1
	
'	set Team Name
	If strTeamName = "" OR Trim(LCase(strTeamName)) = "na" Then
		strTeamName = "Team" & RandomNumber(1,999)
	End If	
	objAddTeamName.Set strTeamName
	
'	clk on Save button
	blnAddTeamSave = ClickButton("Save",objAddTeamSaveBtn,strOutErrorDesc)
	Wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2
	
'	Verify and clk Ok on success popup for Add team
	blnReturnValue = checkForPopup("Changes Saved", "Ok", "Changes Saved", strOutErrorDesc)
	
	AddTeamForProvider = True
	
	Set objAddTeamBtn = Nothing
	Set objAddTeamPPwindow = Nothing	
	Set objAddTeamPPheader = Nothing
	Set objAddTeamName = Nothing
	Set objAddTeamSaveBtn = Nothing
	Set objAddTeamPPTeamTypeDD = Nothing

End Function

Function MDFaxAction(lngMemberID)
	
'	'Navigate to Member Info > Provider Info tab
'	Call clickOnSubMenu("Member Info->Provider Info")
'	Wait 2
'	Call waitTillLoads("Loading...")
'	Wait 2
'	
'	
'	Call AddTeamForProvider(strTeamType, strTeamName, strOutErrorDesc)
'	Wait 2
'	
'	
'	Call PostAddTeamAction(lngMemberID)
'	Wait 2
	
	PHMSendMDfax = "Call SendMDFax()"
	blnInterventionActions = InterventionActions(PHMSendMDfax)
	Wait 2

End Function

Function PostAddTeamAction(lngMemberID)
	
'	Logout, Login - PHM
	Logout()
	Call WriteToLog("Pass","Successfully logged out from PHM User")
	Wait 5
	
	blnPHM = Login("PHM")
	If not blnPHM Then
		Call WriteToLog("Fail","Expected Result: Successfully login to PHM user; Actual Result: Failed to Login to Capella as PHM User.")
		Call Terminator
	End If
	Call WriteToLog("Pass","Successfully logged into Capella as PHM User")
	
'	Close all open patient     
	blnCloseOpenPatients = CloseAllOpenPatient(strOutErrorDesc)
	If Not blnCloseOpenPatients Then
		strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
		Call WriteToLog("Fail", "Expected Result: Close all the open patients; Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
	
'	Select user roster
	blnSelectRoster = SelectUserRoster(strOutErrorDesc)
	If Not blnSelectRoster Then
		strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
		Call WriteToLog("Fail", "Expected Result: Verify the roster is PTC; Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
	Wait 2
	
'	select the patient through global search
	blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
	If not blnGlobalSearchUsingMemID Then
		Call WriteToLog("Fail","Expected Result: Should be able to select required patient through global search; Actual Result: Unable to select required patient through global search")
		Call Terminator
	End If
	Call WriteToLog("Pass","Selected required patient through global search")
	Wait 5
	
	Call waitTillLoads("Loading Patient Profile...")
	Wait 2
	
'	Some Date May Be Out of Date' popup
	Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
'	Check for 'Disclaimer' popup
	Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
	
	Call waitTillLoads("Loading Med Reviews...")
	Wait 2
	
End Function

Function SetObjectsFree()
	Execute "Set objPage = Nothing"
	Execute "Set objWarmTfrAlrtExpnd = Nothing"
	Execute "Set objWarmTfrAlrtClose = Nothing"
	Execute "Set objMedReviewTab = Nothing"
	Execute "Set objPharmacistMedReviewTab = Nothing"
	Execute "Set objPatientSnapshotTab = Nothing"
End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function










