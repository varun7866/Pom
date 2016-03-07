'**************************************************************************************************************************************************************************
' TestCase Name			: MedAdvisorWFprovider
' Purpose of TC			: Validate MedAdvisor WorkFlow for Provider intervention using warm transfer
' Author                : Gregory
' Date                  : 28 August 2015
' Date Modified			: 24 February 2016
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "MedAdvisorWFprovider", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'-----------------------------------------------------------------
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
strProviderType= DataTable.Value("ProviderType", "CurrentTestCaseData")
strGender= DataTable.Value("Gender", "CurrentTestCaseData")
strProviderName = DataTable.Value("ProviderName", "CurrentTestCaseData")
strAddressType = DataTable.Value("AddressType", "CurrentTestCaseData")
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
strTeamType = "Administrative Assistant"
strRevTitleType= "DIABETIC SUPPLIES NEEDED"
strRevTitle = "INSULIN STABILITY"
strTeamName = DataTable.Value("TeamName", "CurrentTestCaseData") 
dtReviewerCodingDate = DataTable.Value("ReviewerCodingDate", "CurrentTestCaseData")
dtReviewerCodingDate = Split(dtReviewerCodingDate," ",-1,1)(0)

'Getting equired iterations
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------in PTC----------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
Err.Clear

Call WriteToLog("info", "------------------------------Med Advisor Work Flow for Provider intervention------------------------------")

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
Wait 2
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

'Validate availability of Send Map and Send Med List after pharmacist med review
Call ValidateMapAndMedlistButtons()

'Validate score card in PHM
Call ValidateMedicationScoreCardMAWF("phm","Med Advisor in process")

'--------------------------
'Add Provider and Team
'--------------------------
Call WriteToLog("info", "-------Add Provider and Team-------")
'Navigae to provider info screen
blnScreenNavigation =  clickOnSubMenu_WE("Member Info->Provider Info")
If not blnScreenNavigation Then
	Call WriteToLog("Fail", "Unable to navigate to provider info page")
	Call Terminator 
End If
Call WriteToLog("Pass", "Navigated to provider info page")
Wait 1

'Add provider
blnAddProvider = AddProvider(strProviderType,strProviderName,strGender,strAddressType,strOutErrorDesc)
If not blnAddProvider Then
	Call WriteToLog("Fail", "Unable to add provider. "&strOutErrorDesc)
	Call Terminator 
End If
Call WriteToLog("Pass", "Added provider")

'((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
'OBJECT IDENTIFICATION - OBJECT SHOULD BE PROPERLY IDENTIFIED - 'TeamType dropdown
''Add team
'blnAddTeamForPatient = AddTeamForPatient(strTeamType,strTeamName,strOutErrorDesc)
'If not blnAddTeamForPatient Then
'	Call WriteToLog("Fail", "Unable to add team. "&strOutErrorDesc)
'	Call Terminator 
'End If
'Call WriteToLog("Pass", "Added team")
'Wait 1
'))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

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

'----------------------------------------------------
'Add intervention, send MD Fax and Edit intervention
'----------------------------------------------------
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

'Send MD Fax
Call FewPreliminarySteps()	
blnSendMDFax = SendMDFax()
If not blnSendMDFax Then
	Call WriteToLog("Fail", "Unable to send MD Fax. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass", "MD Fax is sent")
Wait 1

'Edit intervention(phm)
Call FewPreliminarySteps()
blnEditInterventionStatus = EditInterventionStatus(strPHMInterventionEditStatus, strCurrentVisibleStatusinPHM, strPHMcoding, dtPHMcodingDate, strOutErrorDesc)
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

Call WriteToLog("info", "------------------------------Successfully validated Med Advisor Work Flow for Provider intervention------------------------------")
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'Iteration loop
Loop While False: Next
Wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function AddProvider(ByVal strProviderType, ByVal strProviderName, ByVal strGender, ByVal strAddressType, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	AddProvider = False
	strOutErrorDesc = ""
	
	strAddress = "Addresss1"
	lngZip = 22222
		
	'Click on Add Provider Button
	Execute "Set objAddProviderBtn = " & Environment("WB_AddProviderBtn")
	blnAddProviderBtn = ClickButton("Add Provider",objAddProviderBtn,strOutErrorDesc)
	If not blnAddProviderBtn Then
		strOutErrorDesc = "Unalbe to click add provider btn. "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objAddProviderBtn = Nothing"
	Wait 5	
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Select Provider Type
	Execute "Set objAddNewProvider = " & Environment("WB_AddNewProvider")
	blnProviderType = selectComboBoxItem(objAddNewProvider, strProviderType)		
	If not blnProviderType Then
		strOutErrorDesc = "Unalbe to select Provider Type. "&strOutErrorDesc
		Exit Function	
	End If
	Call WriteToLog("PASS","Selected required Provider Type from AddNewProvider dropdown")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Select Gender Type
	Execute "Set objPage = Nothing"
	Execute "Set objPage = " & Environment("WPG_AppParent")
	Set objPGender=objPage.WebElement("class:=col-md-12 padding-left-5px","html tag:=DIV","outertext:=  Male Female Not Applicable Accepts ReportsAccepts RFIVerified Patient","innertext:=  Male Female Not Applicable Accepts ReportsAccepts RFIVerified Patient")
	Set objGender=objPGender.WebButton("class:=btn btn-default dropdown.*","html id:=dropdownMenu1","html tag:=BUTTON","type:=button")
	objGender.highlight
	blnGenderType = selectComboBoxItem(objGender, strGender)
	
	If Not blnGenderType Then
		
		Err.Clear
		'Close Provider Search window
		Execute "Set objProviderSearchCloseIcon = "&Environment("WI_ProviderSearchCloseIcon_phm")
		objProviderSearchCloseIcon.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click Provider Search close icon. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("PASS","Closed 'Provider Search' window as 'AddNewProvider' dropdown value (Provider Type) was not selected properly in first attempt")
		Execute "Set objNextBtn = Nothing"
		Execute "Set objProviderSearchCloseIcon = Nothing"
		Wait 1
		Call waitTillLoads("Loading...")
		Wait 1
		
		'Again click Add Provider Button
		Execute "Set objAddProviderBtn = " & Environment("WB_AddProviderBtn")
		blnAddProviderBtn = ClickButton("Add Provider",objAddProviderBtn,strOutErrorDesc)
		If not blnAddProviderBtn Then
			strOutErrorDesc = "Unalbe to click add provider btn. "&strOutErrorDesc
			Exit Function
		End If
		Execute "Set objAddProviderBtn = Nothing"
		Wait 5	
		Call waitTillLoads("Loading...")
		Wait 1
		
		'Second attempt to select Provider Type
		Execute "Set objAddNewProvider = " & Environment("WB_AddNewProvider")
		blnProviderType = selectComboBoxItem(objAddNewProvider, strProviderType)		
		If Not blnProviderType Then	
			strOutErrorDesc = "Unable to select Provider Type. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("PASS","Selected Provider Type from AddNewProvider dropdown")
		
		Execute "Set objAddNewProvider = Nothing"
		Execute "Set objNextBtn = Nothing"
		
		'Select Gender Type
		Execute "Set objPage = Nothing"
		Execute "Set objPage = " & Environment("WPG_AppParent")
		Set objPGender=objPage.WebElement("class:=col-md-12 padding-left-5px","html tag:=DIV","outertext:=  Male Female Not Applicable Accepts ReportsAccepts RFIVerified Patient","innertext:=  Male Female Not Applicable Accepts ReportsAccepts RFIVerified Patient")
		Set objGender=objPGender.WebButton("class:=btn btn-default dropdown.*","html id:=dropdownMenu1","html tag:=BUTTON","type:=button")
		
		objGender.highlight
		blnGenderType = selectComboBoxItem(objGender, strGender)		
		If Not blnGenderType Then
			strOutErrorDesc = "Gender Type selection returned error: "&strOutErrorDesc
			Call WriteToLog("Fail","Expected Result: User should be able to select Gender Type.  Actual Result: " &strOutErrorDesc)
			Exit Function
		End If
		Call WriteToLog("PASS","Selected required Gender Type")
		Execute "Set objPage = Nothing"
		Set objPGender = Nothing
		Set objGender = Nothing
		wait 0,500
	
	Else
		
		Call WriteToLog("PASS","Selected required Gender Type")
		Execute "Set objPage = Nothing"
		Set objPGender = Nothing
		Set objGender = Nothing
		wait 0,500
		
	End If
	
	'Set name of Provider
	Execute "Set objProviderName = " & Environment("WE_ProviderName_PHM")
	If waitUntilExist(objProviderName, 10) Then
		Err.Clear
		objProviderName.Set strProviderName
		If Err.Number <> 0 Then
			strOutErrorDesc = "Provider Name field is not set. " & Err.Description
			Exit Function
		End If
	End If
	Call WriteToLog("Pass", strProviderName & "is set to Provider Name field.")
	Execute "Set objProviderName = Nothing"
	wait 0,500
	
	'Click Next Button of Provider Detail
	Err.Clear
	Execute "Set objNextBtn = " & Environment("WB_NextBtn")
	objNextBtn.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Provider Next Button is not Clicked. " & Err.Description
		Exit Function
	End If	
	Call WriteToLog("Pass", "Provider Next Button is  Clicked Successfully.")
	Execute "Set objNextBtn = Nothing"
	wait 2	
	
	'Select Address Type
	Execute "Set objPage = Nothing"
	Execute "Set objPage = " & Environment("WPG_AppParent")
	Set objPaddress=objPage.WebElement("class:=col-md-3","html tag:=DIV","outertext:=Select a value   Select a value  Mailing  Other  Service  ","innertext:=Select a value   Select a value  Mailing  Other  Service  ")
	Set objAddTypeBtn=objPaddress.WebButton("html id:=dropdownMenu1","outertext:=Select a value ","type:=button","name:=Select a value ","index:=8")
	blnAddressType = selectComboBoxItem(objAddTypeBtn, strAddressType)
	If Not blnAddressType Then
		strOutErrorDesc = "Address Type selection returned error: "&strOutErrorDesc
		Call WriteToLog("Fail","Expected Result: User should be able to select Address Type.  Actual Result: " &strOutErrorDesc)
		Exit Function
		End If
	Call WriteToLog("PASS","Selected required Address Type")
	wait 0,500
	Execute "Set objPage = Nothing"
	set objPaddress = Nothing
	set objAddTypeBtn = Nothing
		
	'Set Address
	Execute "Set objAddress = " & Environment("WE_Address1")	
	If waitUntilExist(objAddress, 10) Then
		Err.Clear
		objAddress.Set strAddress
		If Err.Number <> 0 Then
			strOutErrorDesc = "Address field is not set. " & Err.Description
			Exit Function
		End If
	End If
	Call WriteToLog("Pass", strAddress & "is set to Address field.")
	Execute "Set objAddress = Nothing"
	Wait 0,500			
	
	'set zip	
	Execute "Set objZIP = " & Environment("WE_ZIP1")			
	Err.Clear			
	objZIP.Set lngZip
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set zip code. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Zip value is set")
	Execute "Set objZIP = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	Execute "Set objZipCB_phm = " & Environment("WEL_ZipCB_phm")			
	Err.Clear			
	objZipCB_phm.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click zip code check box. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked Zip code check box")
	Execute "Set objZipCB_phm = Nothing"
	Wait 0,500
	
	Execute "Set objZipValidation_OKphm = " & Environment("WEL_ZipValidation_OKphm")			
	Err.Clear			
	objZipValidation_OKphm.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click zip code validation OK button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked Zip code validation OK button")
	Execute "Set objZipValidation_OKphm = Nothing"
	Wait 0,500	
	
	'Set fax number
	lngFaxNumber = 1123233321
	Set objFaxNumberProviderAddress = getPageObject().WebEdit("attribute/data-capella-automation-id:=Phone","index:=1")
	Err.Number = 0
	objFaxNumberProviderAddress.Set lngFaxNumber
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Fax number in Provider Address screen. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Fax number in Provider Address screen is set")
	Set objFaxNumberProviderAddress = Nothing
	Wait 0,250
	
	'Check 'Fax number Verified' check box in Provider Search > Provider Address screen
	Set objParentForCBsInProviderAddressScreen = getPageObject().WebElement("class:=col-md-12 modal-body mymodel-body provider-popup margin-0-px","html tag:=DIV")
	Set objFaxNumberVerifiedCB = objParentForCBsInProviderAddressScreen.WebElement("class:=screening-check-box-no float-left whitebg","html tag:=DIV","index:=1")
	Setting.WebPackage("ReplayType") = 2
	Err.Clear
	objFaxNumberVerifiedCB.FireEvent "onClick"
	Setting.WebPackage("ReplayType") = 1
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to check 'Fax number Verified' check box in Provider Search > Provider Address screen. "&Err.Description
		Exit Function		
	End If
	Call WriteToLog("Pass","check 'Fax number Verified' check box")
	Set objParentForCBsInProviderAddressScreen = Nothing
	Set objFaxNumberVerifiedCB = Nothing
	Wait 0,250
	
	'Click Next Button of Provider Address
	Execute "Set objPSNextBtn = " & Environment("WB_PSNextBtn")
	Err.Clear
	objPSNextBtn.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Provider Search Next Button is not Clicked. " & Err.Description
		Exit Function
	End If	
	Call WriteToLog("Pass", "Provider SearchNext Button is  Clicked Successfully.")
	wait 2
	
	'Click Next Button of Provider Address
	Execute "Set objPSNextBtn = Nothing"
	Execute "Set objPSNextBtn = " & Environment("WB_PSNextBtn")
	Err.Clear
	objPSNextBtn.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Provider Search Next Button is not Clicked. " & Err.Description
		Exit Function
	End If	
	Call WriteToLog("Pass", "Provider Search Next Button clicked")
	wait 1
	Execute "Set objPSNextBtn = Nothing"
	
	'click save btn
	Execute "Set objSaveBtn = " & Environment("WB_SaveBtn")	
	blnAddProviderBtn = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnAddProviderBtn Then
		strOutErrorDesc = "Save Button is not clicked " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Save Button is clicked")
	Execute "Set objSaveBtn = Nothing"	
	Wait 2	
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Validate save msg
	strMessageTitle = "Changes Saved"
	strMessageBoxText = "Changes saved successfully."	
	blnReturnValue = checkForPopup(strMessageTitle, "Ok", strMessageBoxText, strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Changes saved successfully.' message box is not existing / Not clicked OK on popup "& strOutErrorDesc
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	AddProvider = True
	
End Function

Function SendMDFax()

	Err.Clear
	On Error Resume Next
	strOutErrorDesc = ""
	SendMDFax = False

	Execute "Set objMDFaxBtn = " & Environment("WB_MDFaxBtn")
	blnMDFaxBtn = ClickButton("MD Fax",objMDFaxBtn,strOutErrorDesc)
	If not blnMDFaxBtn Then
		strOutErrorDesc = "Unable to click MD fax button. "&strOutErrorDesc
		Exit Function
	End If
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
	
	Execute "Set objChooseRecipientsPPheader = " & Environment("WEL_ChooseRecipientsPPheader")
	objChooseRecipientsPPheader.highlight
	blnChooseRecipientsPopup = waitUntilExist(objChooseRecipientsPPheader, 10)
	If not blnChooseRecipientsPopup Then
		strOutErrorDesc = "Choose Recipient window is not available. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Choose Recipient window is available after clicking MD fax button")	
	Wait 1
	
	Err.Clear	
	For iCB = 0 To 5 Step 1
		Execute "Set objPageMD = " & Environment("WPG_AppParent")
		Set objMDchbx = objPageMD.WebCheckBox("attribute/data-capella-automation-id:=dataItem\.CheckBoxValue","visible:=True","index:="&iCB)
		If objMDchbx.Exist(1) AND not objMDchbx.Object.isDisabled Then
			Err.Clear
			objMDchbx.click
			If Err.Number <> 0 Then
				Call WriteToLog("Fail", "Unable to click MD fax recipient check box"&iCB)
				Exit Function
			End If
			Call WriteToLog("Pass", "Clicked MD fax recipient check box"&iCB)
			Exit For
		End If
		Execute "Set objPageMD = Nothing"
	Next
	Err.Clear		
	Wait 1
	
	Execute "Set objChooseRecipientsPPok = " & Environment("WB_ChooseRecipientsPPok")
	blnChooseRecipientsPPok = ClickButton("OK",objChooseRecipientsPPok,strOutErrorDesc)
	If not blnChooseRecipientsPPok Then
		strOutErrorDesc = "Unable to click OK button in Choose recipient window. "&strOutErrorDesc
		Exit Function
	End If
	Wait 1	
	Call waitTillLoads("Loading...")
	Wait 1
	
	Execute "Set objMDFaxReportHeader = " & Environment("WEL_MDFaxReportHeader")
	blnMDFaxReportHeader = waitUntilExist(objMDFaxReportHeader, 10)
	If not blnMDFaxReportHeader Then
		strOutErrorDesc = "FaxReport is not available. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "FaxReport is available after clicking check boxes and OK button in Choose Recipient window")	
	Wait 2	
	
	Execute "Set objSendAllMDFax = " & Environment("WEL_SendAllMDFax")
	blnSendAllMDFax = ClickButton("Send All",objSendAllMDFax,strOutErrorDesc)
	If not blnSendAllMDFax Then
		strOutErrorDesc = "Unable to click Send All button. "&strOutErrorDesc
		Exit Function
	End If
	Wait 2	
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Validate 'Confirmation' popup
	blnReturnValue = checkForPopup("Confirmation", "OK", "Your request was submitted", strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Your request was submitted.' message box is not existing / Not clicked OK on popup "& strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Validated confirmation popup")
	Wait 1
	
	SendMDFax = True
	
	Execute "Set objMDFaxBtn = Nothing"
	Execute "Set objChooseRecipientsPPheader = Nothing"
	Execute "Set objChooseRecipientsPPok = Nothing"
	Execute "Set objMDFaxReportHeader = Nothing"
	Execute "Set objSendAllMDFax = Nothing"
	
End Function

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
	
	Call WriteToLog("info", "-------Validate Medication Score Card-------")
	
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

Function AddTeamForPatient(ByVal strTeamType,ByVal strTeamName, strOutErrorDesc)
    
    On Error Resume Next
    Err.Clear
    AddTeamForPatient = False
    strOutErrorDesc = ""
    
    'Click AddTeam button
    Execute "Set objAddTeamBtn = " & Environment("WB_AddTeamBtn")
    blnAddTeamBtn = ClickButton("Add Team",objAddTeamBtn,strOutErrorDesc)
    If not blnAddTeamBtn Then
    	Set objAddTeamBtn = getPageObject().WebButton("html id:=dropdownMenu1","html tag:=BUTTON","outerhtml:=.*isTypeDrpDwnEditable.*","index:=1")
    	 blnAddTeamBtn = ClickButton("Add Team",objAddTeamBtn,strOutErrorDesc)
    	 If not blnAddTeamBtn Then
	    	strOutErrorDesc = "Unable to click 'AddTeam' button." &Err.Description
			Exit Function
		End If
	End If
	Wait 2    
    Call waitTillLoads("Loading...")
    Wait 1
    
	'Select reqd Team Type (TeamType same as choice made previously from 'Referred To' dropdown)
	Execute "Set objAddTeamPPTeamTypeDD = " & Environment("WB_AddTeamPPTeamTypeDD")    
    blnReturnValue = selectComboBoxItem(objAddTeamPPTeamTypeDD, strTeamType)
	If not blnReturnValue Then   
    	strOutErrorDesc = "Unable to select Team Type." &strOutErrorDesc
		Exit Function
	End If
    Call WriteToLog("Pass", "Selected Team Type")
    Wait 1
    
    'Set Team Name
    If strTeamName = "" OR Trim(LCase(strTeamName)) = "na" Then
        strTeamName = "Team" & RandomNumber(1,999)
    End If    
    Execute "Set objAddTeamName = " & Environment("WE_AddTeamName")
    Err.Clear
    objAddTeamName.Set strTeamName
    If Err.Number <> 0 Then   
    	strOutErrorDesc = "Unable to set Team Name." &Err.Description
		Exit Function
	End If
    Call WriteToLog("Pass", "Team Name is set")
    
    'Clk on Save button
    Execute "Set objAddTeamSaveBtn = " & Environment("WB_AddTeamSaveBtn")
    blnAddTeamSave = ClickButton("Save",objAddTeamSaveBtn,strOutErrorDesc)
    If not blnAddTeamSave Then
		strOutErrorDesc = "Unable to click 'Save' button." &Err.Description
		Exit Function
	End If
	Wait 2    
    Call waitTillLoads("Loading...")
    Wait 1 
    
    'Verify and clk Ok on success popup for Add team
    blnReturnValue = checkForPopup("Changes Saved", "Ok", "Changes Saved", strOutErrorDesc)
    If not blnReturnValue Then   
    	strOutErrorDesc = "Unable to validate save msg box." &Err.Description
		Exit Function
	End If
    Call WriteToLog("Pass", "Validated save msg box")
    Wait 1    
    Call waitTillLoads("Loading...")
    Wait 1 
    
    AddTeamForPatient = True
    
    Set objAddTeamBtn = Nothing
    Set objAddTeamName = Nothing
    Set objAddTeamPPTeamTypeDD = Nothing
    Set objAddTeamSaveBtn = Nothing   

End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction

End Function
