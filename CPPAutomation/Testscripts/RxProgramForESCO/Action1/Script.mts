'**************************************************************************************************************************************************************************
' TestCase Name			: RxProgramForESCO
' Purpose of TC			: To validate Auto Start RX program for ESCO patient
' Author                : Gregory
' Date                  : 
' Environment			: QA/Train/Stage (url as described in Config file)
' Comments				: This script covers test case scenarios corresponding to userstory : B-06304
'						: If need to execute this script off-shore, then run only afternoon
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "RxProgramForESCO", strOutTestName, strOutErrorDesc) 
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
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")

'Execution as required
If not Lcase(strExecutionFlag) = "y" Then Exit Do
On Error Resume Next
Err.clear

'-----------------------EXECUTION------------------------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("Info","-------------------Login to EPS and refer new ESCO member-------------------")  

'Login to EPS, close all open patients, select user roster, Refer new ESCO patient and retrieve Member ID
lngMemberID = NavigateToEPSandCreateNewPatient()
If lngMemberID = "" Then
	Call WriteToLog("Fail","Unable to create patient from EPS")
	Call Terminator
End If

'Logout from EPS
Call WriteToLog("Info","-------------------Logout from EPS-------------------")
Call Logout()
Wait 2
'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","-------------------Login to VHN and add comorbid and hospitalization record-------------------")  

'Login to VHN, close all open patients, select user roster and open required patient through global search
Call NavigateToVHNandOpenPatient(lngMemberID) 

'Add required comorbid/s for the patient
Call AddComorbidForPatient()

'Add hospitalization record with required admit type
Call HospitalizationRecordForPatient()

'Close patient record and re-open patient through global search(to get changes reflected)
strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")
strPatientName = Split(strPersonalDetails,",",-1,1)(0)
blnClosePatientAndReopenThroughGlobalSearch = ClosePatientAndReopenThroughGlobalSearch(strPatientName,lngMemberID,strOutErrorDesc)
If not blnClosePatientAndReopenThroughGlobalSearch Then
	Call WriteToLog("Fail","Unable to close patient record and re-open patient through global search. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Closed patient record and re-opened patient through global search")

'Validate Auto Start RX program for ESCO patient
Call Validate_AutoStartRxProgramForESCOpatient()

'Logout from VHN
Call WriteToLog("Info","-------------------Logout from VHN-------------------")
Call Logout()
Wait 2
'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","-------------------Login to PTC and validate patient record in Open Call List-------------------")  

'Login to PTC, close all open patients, select user roster and validate patient record in Open Call List
Call ValidatePatientRecordInPTC()

Call WriteToLog("Info","-------------------Logout from PTC-------------------")
Call Logout()
Wait 2
'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'Iteration loop
Loop While False: Next
Wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

Function NavigateToEPSandCreateNewPatient()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")
	strMedicalDetails = DataTable.Value("MedicalDetails","CurrentTestCaseData")
	
	'Navigation: Login as eps > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("eps", strOutErrorDesc)
	If not blnNavigator Then
	    Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	    Call Terminator                                            
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")                                            
	Wait 0,500
	
	'Create newpatient
	strNewPatientDetails = CreateNewPatientFromEPS(strPersonalDetails,"NA",strMedicalDetails,strOutErrorDesc)
	If strNewPatientDetails = "" Then
	    Call WriteToLog("Fail","Expected Result: User should be able to create new ESCO patient in EPS. Actual Result: Unable to  create new ESCO patient in EPS."&strOutErrorDesc)
	    Call Terminator                                            
	End If
	Call WriteToLog("Pass","Created new ESCO patient in EPS")    
	Wait 1
	
	arrNewPatientDetails = Split(strNewPatientDetails,",",-1,1)
	lngMemberID = arrNewPatientDetails(0)
	Wait 1
	
	NavigateToEPSandCreateNewPatient = lngMemberID

End Function

Function NavigateToVHNandOpenPatient(ByVal lngMemberID)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""

	strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")
	strPatientName = Split(strPersonalDetails,",",-1,1)(0)
	
	'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("vhn", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")

	blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
	If Not blnGlobalSearchUsingMemID Then
		strOutErrorDesc = "Select patient through global search returned error: "&strOutErrorDesc
		Call WriteToLog("Fail", "Expected Result: User should be able to select patient through global search; Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Successfully selected required patient through global search")
	Wait 1

	'Handle navigation error if exists
	blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
	If not blnHandleWrongDashboardNavigation Then
	   Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Provided proper navigation after patient selection")
	
End Function

Function AddComorbidForPatient()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	strComorbidType = DataTable.Value("ComorbidType","CurrentTestCaseData")

	'Click on Clinical Management > Comorbids tab
	blnComorbids_Navigation = clickOnSubMenu_WE("Clinical Management->Comorbids")
	If not blnComorbids_Navigation Then
	   Call WriteToLog("Fail","Unable to navigate to Clinical Management > Comorbids screen")
		Call Terminator
	End If
	Call WriteToLog("Pass","Navigated to Clinical Management > Comorbids screen")
	Wait 1	
	
	'Validate navigation
	Execute "Set objComorbidsListHeader = " & Environment("WE_ComorbidsListHeader")
	If not objComorbidsListHeader.Exist(5) Then
		strOutErrorDesc = "User didn't navigate to Comorbids screen"
		Call Terminator
	End If
	Call WriteToLog("Pass","Navigated to Comorbids screen")
	Execute "Set objComorbidsListHeader = Nothing"
	
	Wait 15 'App performance
	
	'Select required comorbid/s	
	strComorbids = DataTable.Value("ComorbidType","CurrentTestCaseData")
	arrComorbids = Split(strComorbids,",",-1,1)
	
	For crbds = 0 To UBound(arrComorbids) Step 1
	
		'Click on Add button for Comorbids
		Execute "Set objAddComorbidButton = " & Environment("WB_ComorbidDetailsAdd")
		blnAddComorbidClicked = ClickButton("Add",objAddComorbidButton,strOutErrorDesc)
		If not blnAddComorbidClicked Then
			strOutErrorDesc = "Unable to click add button for comorbids"
			Call Terminator
		End If
		Execute "Set objAddComorbidButton = Nothing"
	
		strComorbidType = arrComorbids(crbds)
		
		Execute "Set objComorbidType = " & Environment("WB_ComorbidType")
		blnComorbidSelected = selectComboBoxItem(objComorbidType, strComorbidType)
		If not blnComorbidSelected Then
			strOutErrorDesc = "Unable to select required cormorbid"
			Call Terminator
		End If
		Call WriteToLog("Pass","Selected required cormorbid")
		Execute "Set objComorbidType = Nothing"
		
		'Save comorbid
		Execute "Set objSaveComorbidButton = " & Environment("WB_ComorbidDetailsSave")
		blnSaveComorbidClicked = ClickButton("Save",objSaveComorbidButton,strOutErrorDesc)
		If not blnSaveComorbidClicked Then
			strOutErrorDesc = "Unable to click save button for comorbids"
			Call Terminator
		End If
		Execute "Set objSaveButton = Nothing"
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 1
		
	Next

End Function

Function HospitalizationRecordForPatient()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	dtAdmitDate = DataTable.Value("AdmitDate","CurrentTestCaseData")
	dtAdmitDate = Split(dtAdmitDate," ",-1,1)(0)
	
	strAdmitType = DataTable.Value("AdmitType","CurrentTestCaseData")
	dtNotificationDate = dtAdmitDate
	strNotifiedBy = "Dialysis Center"
	strSourceOfAdmit = "Elective Admit"
	strAdmittingDiagnosisTxt = "AdmittingDiagnosis"
	strWorkingDiagnosisTxt = "WorkingDiagnosis"
	dtDischargeDate = dtAdmitDate
	dtDischargeNotificationDate = dtAdmitDate
	strDisposition = "Home"
	
	'Navigate to Hospitalizations > Review screen
	blnHospReview_Navigation = clickOnSubMenu_WE("Clinical Management->Hospitalizations")
	If not blnHospReview_Navigation Then
	   Call WriteToLog("Fail","Unable to click Clinical Management > Hospitalizations tab")
		Call Terminator
	End If
	Call WriteToLog("Pass","Clicked Clinical Management > Hospitalizations tab")
	Wait 1	
	
	Execute "Set objHospitalizationHeader = " & Environment("WEL_HospitalizationHeader")
	Execute "Set objHospitalizationReviewHeader = " & Environment("WEL_HospitalizationReviewHeader")
	If not objHospitalizationHeader.Exist(5) AND objHospitalizationReviewHeader.Exist(5) Then
		strOutErrorDesc = "User didn't navigate to Hospitalization Review screen"
		Call Terminator
	End If
	Call WriteToLog("Pass","Navigated to Hospitalization Review screen")
	
	blnAdmitPatient = AdmitPatient(dtAdmitDate,dtNotificationDate,strAdmitType,strNotifiedBy,strSourceOfAdmit,strAdmittingDiagnosisTxt,strWorkingDiagnosisTxt,strOutErrorDesc)
	If not blnAdmitPatient Then
	    Call WriteToLog("Fail","Unable Admit patient. "&strOutErrorDesc)
	    Call Terminator
	End If
	Call WriteToLog("Pass","Admitted patient with required details")
	Wait 1	
	
	blnDischargePatient = DischargePatient(dtDischargeDate,dtDischargeNotificationDate,strDisposition,strOutErrorDesc)
	If not blnDischargePatient Then
	    Call WriteToLog("Fail","Unable Discharge patient. "&strOutErrorDesc)
	    Call Terminator
	End If
	Call WriteToLog("Pass","Discharged patient with required details")
	Wait 1	
		
End Function

Function Validate_AutoStartRxProgramForESCOpatient()

	On Error Resume Next
	Err.Clear	
	
	'Navigate to Member Info > Patiet Info screen
	blnHospReview_Navigation = clickOnSubMenu_WE("Member Info->Patient Info")
	If not blnHospReview_Navigation Then
	   Call WriteToLog("Fail","Unable to navigate to Member Info->Patient Info screen")
		Call Terminator
	End If
	Call WriteToLog("Pass","Navigated to Member Info->Patient Info screen")
	Wait 1	

	'Validation - Auto Start RX program for ESCO patient
	Execute "Set objProgramsAdded = " & Environment("WT_ProgramsAdded") 'Programs table	
	
	strAdmitType = DataTable.Value("AdmitType","CurrentTestCaseData") 'Admit Type
	
	'Expected values for Program, start date, start reason and end date (from test data sheet)
	strExpectedProgram = Replace(LCase(DataTable.Value("ExpectedProgram","CurrentTestCaseData"))," ","",1,-1,1)
	dtExpectedStartDate = Date
	strExpectedStartReason = Replace(LCase(DataTable.Value("ExpectedStartReason","CurrentTestCaseData"))," ","",1,-1,1)
	dtExpectedEndDate = DataTable.Value("ExpectedEndDate","CurrentTestCaseData")
	
	'Required row and column numbers of Praograms table in Member Info > Patient Info screen
	intProgramTableRequiredRowNumber = 1
	intProgarmColumnNumber = 1
	intStartDateColumnNumber = 2
	intStartReasonColumnNumber = 3
	intEndDateColumnNumber = 4	
	
	If Instr(1,Replace(LCase(strAdmitType)," ","",1,-1,1),"hospitaladmit",1) > 0 Then		
		
		If objProgramsAdded.Exist(5) Then	
			objProgramsAdded.highlight
			
			'Added (actual) values for Program, start date, start reason and end date (from aplication)
			strProgramAdded = Replace(LCase(objProgramsAdded.getCellData(intProgramTableRequiredRowNumber,intProgarmColumnNumber))," ","",1,-1,1)
			dtStartDateAdded = Replace(objProgramsAdded.getCellData(intProgramTableRequiredRowNumber,intStartDateColumnNumber)," ","",1,-1,1)
			strStartReasonAdded = Replace(LCase(objProgramsAdded.getCellData(intProgramTableRequiredRowNumber,intStartReasonColumnNumber))," ","",1,-1,1)
			dtEndDateAdded = Replace(objProgramsAdded.getCellData(intProgramTableRequiredRowNumber,intEndDateColumnNumber)," ","",1,-1,1)		
			
			'Validate program
			If Instr(1,strProgramAdded,strExpectedProgram,1) > 0 Then
				Call WriteToLog("Pass","Programs Table is populated with '"&strExpectedProgram&"' program") 
			Else
				Call WriteToLog("Fail","Programs Table is not populated with '"&strExpectedProgram&"' program")
				Call Terminator
			End If
			
			'Validate start date
			If Instr(1,dtStartDateAdded,dtExpectedStartDate,1) > 0 Then
				Call WriteToLog("Pass","Programs Table is populated with '"&dtExpectedStartDate&"' as strat date") 
			Else
				Call WriteToLog("Fail","Programs Table is not populated with '"&dtExpectedStartDate&"' as strat date")
				Call Terminator
			End If
			
			'Validate strat reason
			If Instr(1,strStartReasonAdded,strExpectedReason,1) > 0 Then
				Call WriteToLog("Pass","Programs Table is populated with '"&strExpectedStartReason&"' as start reason") 
			Else
				Call WriteToLog("Fail","Programs Table is not populated with '"&strExpectedStartReason&"' as start reason")
				Call Terminator
			End If
			
			'Validate end date
			If Instr(1,dtEndDateAdded,dtExpectedEndDate,1) > 0 Then
				Call WriteToLog("Pass","Programs Table is populated with '"&dtExpectedEndDate&"' as end date") 
			Else
				Call WriteToLog("Fail","Programs Table is not populated with '"&dtExpectedEndDate&"' as end date")
				Call Terminator
			End If
		
		Else
		
			Call WriteToLog("Fail","Programs Table is not available in Member Info > Patient Info screen")
			
		End If
	
	Else
		
		Execute "Set objProgramsAdded = Nothing"
		Execute "Set objProgramsAdded = " & Environment("WT_ProgramsAdded") 'Programs table
		
		If objProgramsAdded.Exist(2) Then
		intPT_RC = objProgramsAdded.RowCount
		
			For rc = 1 To intPT_RC Step 1
	
				strProgramAdded = Replace(LCase(objProgramsAdded.getCellData(rc,intProgarmColumnNumber))," ","",1,-1,1)
				If Instr(1,strProgramAdded,"medadvisor",1) > 0 Then
					Call WriteToLog("Fail","Programs Table is populated with '"&strProgramAdded&"' even though Admit Type is not Hospital Admit") 
					Call Terminator
				End If
				
			Next
			
		Else
				Call WriteToLog("Pass","RX program for ESCO patient is not auto started as Admit Type is not Hospital Admit") 	
		End If	
		
	End If 		

End Function

Function ValidatePatientRecordInPTC()

	On Error Resume Next
	Err.Clear

	strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")
	strPatientName = Split(strPersonalDetails,",",-1,1)(0)
	
	'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("ptc", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")
	
	''Validate PTC assignment
	Execute "Set objPage_PTC = Nothing"
	Execute "Set objPage_PTC = " & Environment("WPG_AppParent")
	
	Set objReqdPatientName = objPage_PTC.WebElement("html tag:=SPAN","visible:=True","outertext:=.*"&strPatientName&".*")
	
	PatientNameStatus=False
	intFinite = 1	
	
	If objReqdPatientName.Exist(5) Then
	
		objReqdPatientName.highlight
		PatientNameStatus=True
		
	Else
	
		Do Until (PatientNameStatus=True OR intFinite = 100)
		
			Execute "Set objPage_PTC = Nothing"
			Execute "Set objPage_PTC = " & Environment("WPG_AppParent")
			
			Err.Clear
			objPage_PTC.WebElement("html tag:=SPAN","outerhtml:=.*Go to the next page.*","visible:=True").click	'GoToNextPage icon
			If Err.Number <> 0 Then
				Call WriteToLog("Fail","Unable to click GoToNextPage icon")
				Call Terminator
			End If		
			Wait 0,100		
			Call waitTillLoads("Loading...")	
			
			Execute "Set objPage_PTC = Nothing"
			Set objReqdPatientName = Nothing
			Execute "Set objPage_PTC = " & Environment("WPG_AppParent")
			Set objReqdPatientName = objPage_PTC.WebElement("html tag:=SPAN","visible:=True","outertext:=.*"&strPatientName&".*")
			
			If objReqdPatientName.Exist(.2) Then
				objReqdPatientName.highlight
				PatientNameStatus=True 
				Exit Do
			End If 
			
			intFinite= intFinite+1
			
		Loop 
		
	End If     
	
	If PatientNameStatus = True Then
		Call WriteToLog("Pass","Patient record is added/displayed in PTC Open Call List")
	Else
		Call WriteToLog("Fail","Patient record is not added/displayed in PTC Open Call List")
		Call Terminator
	End If 
	Wait 2
	
End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function

'Function ClosePatientAndReopenThroughGlobalSearch(ByVal strPatientName, ByVal lngMemberID, strOutErrorDesc)
'	
'	On Error Resume Next
'	Err.Clear
'	strOutErrorDesc = ""
'	ClosePatientAndReopenThroughGlobalSearch = False
'	
'	'Close all open patients
'	blnCloseAllOpenPatient = CloseAllOpenPatient(strOutErrorDesc)
'	If not blnGlobalSearchUsingMemID Then
'		strOutErrorDesc = "Unable to close all open patients in Open Patient widget. "&strOutErrorDesc
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Closed all open patients in Open Patient widget")
'	
'	'Re-open through global search
'	blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
'	If not blnGlobalSearchUsingMemID Then
'		strOutErrorDesc = "Unable to open patient through global search. "&strOutErrorDesc
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Opened patient through global search")
'	
'	blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
'	If not blnHandleWrongDashboardNavigation Then
'		strOutErrorDesc = "Unable to provide proper navigation after patient selection. "&strOutErrorDesc
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Provided proper navigation after patient selection")
'	
'	ClosePatientAndReopenThroughGlobalSearch = True
'	
'End Function
