'**************************************************************************************************************************************************************************
' TestCase Name			: DischargeAlert
' Purpose of TC			: To verify alert message which is generated for assigned VHN when a patient is discharged from hospital by any other user.(in Script ARN)
' Author                : Gregory
' Date                  : 25 May 2015
' Date Modified			: 5 October 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04748
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
Set objFso = Nothing

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "DischargeAlert", strOutTestName, strOutErrorDesc) 
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
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
lngMemberID = DataTable.Value("PatientMemberID","CurrentTestCaseData")
strAdmitType = DataTable.Value("AdmitType","CurrentTestCaseData")
strNotifiedBy = DataTable.Value("NotifiedBy","CurrentTestCaseData")
strSourceOfAdmit = DataTable.Value("SourceOfAdmit","CurrentTestCaseData")
strAdmittingDiagnosisTxt = DataTable.Value("AdmittingDiagnosis","CurrentTestCaseData")
strWorkingDiagnosisTxt = DataTable.Value("WorkingDiagnosis","CurrentTestCaseData")
dtAdmitDate = DataTable.Value("AdmitDate","CurrentTestCaseData") 
dtNotificationDate = DataTable.Value("NotificationDate","CurrentTestCaseData")  'should be within 7 days prior to sys date
strDisposition = DataTable.Value("Disposition","CurrentTestCaseData") 
strAcknowledgeDischargeAlert = DataTable.Value("AcknowledgeDischargeAlert","CurrentTestCaseData")
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData") 
strUserOtherThanAssignedVHN = DataTable.Value("UserOtherThanAssignedVHN","CurrentTestCaseData")

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage = " & Environment("WPG_AppParent") 'Page object
Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
Execute "Set objDischargeDateTxt = " & Environment("WE_DischargeDateTxt") 'Discharge Date edit box
Execute "Set objDischargeNotificationDateTxt = " & Environment("WE_DischargeNotificationDateTxt") 'Discharge date notification edit box
Execute "Set objDispositionDD = " & Environment("WB_DispositionDD") 'Disposition dropdown
Execute "Set objAdmitDateTxt = " & Environment("WE_AdmitDateTxt") 'Admit date text box
Execute "Set objHospHistoryArrow = " & Environment("WI_HospHistoryArrow") 'Hospitalization history up arrow
Execute "Set objLDDonPP = " & Environment("WEL_LDDonPP") 'Last date of discharge on popup
Execute "Set objHosHistoryTable = " & Environment("WT_HosHistoryTable") 'Hospitalization history table
Execute "Set objAlertUpArrow = " & Environment("WEL_AlertUpArrow") 'Alert up arrow
Execute "Set objSaveBtn = " & Environment("WI_DischargeSaveBtn") 'Discharge Save btn
Execute "Set objDischargeAcknowledgeAlertpp = " & Environment("WEL_DischargeAcknowledgeAlertpp") 'Acknowledge Alert popup
Execute "Set objDischargeAcknowledgeAlertppYesBtn = " & Environment("WB_DischargeAcknowledgeAlertppYesBtn") 'Acknowledge Alert popup Yes btn
Execute "Set objDischargeAcknowledgeAlertppNoBtn = " & Environment("WB_DischargeAcknowledgeAlertppNoBtn") 'Acknowledge Alert popup No btn
Execute "Set objAlertAcknowledgedpp = " & Environment("WEL_AlertAcknowledgedpp") 'Alert has been acknowledged popup
Execute "Set objAlertAcknowledgedppOK = " & Environment("WB_AlertAcknowledgedppOK") 'Alert has been acknowledged popup OK btn
Execute "Set HospitalizationRecordUpdateSuccesspp = " & Environment("WEL_HospitalizationRecordUpdateSuccesspp")  'RecordUpdateSuccess popup
Execute "Set objPatientProfile = " & Environment("WEL_PatientProfile")  'PatientProfile
			
'Getting equired iterations
If not Lcase(strExecutionFlag) = "y" Then Exit Do
Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"----------------") 

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

'----------------------------------------------
'Getting specific patient through Global Search
'(Ensuring the patient is of assigned VHN)
'----------------------------------------------
blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
If Not blnGlobalSearchUsingMemID Then
	strOutErrorDesc = "Select patient through global search returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", "Expected Result: User should be able to select patient through global search; Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Successfully selected required patient through global search")
Wait 3

Call waitTillLoads("Loading...")
Wait 2

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")
Wait 2

'---------------------------------------------------------------------------------
'Navigating to Clinical Management > Hospitalizations and following business logic
'---------------------------------------------------------------------------------
'Navigate to ClinicalManagement > Hospitalizations
blnScreenNavigation = clickOnSubMenu_WE("Clinical Management->Hospitalizations")
If not blnScreenNavigation Then
	Call WriteToLog("Fail","Unable to navigate to Clinical Management > Hospitalizations "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Navigated to Clinical Management > Hospitalizations")
wait 4
Call waitTillLoads("Loading...")
Wait 2

Err.Clear
'Clk on Hospitalization History table expand arrow image
objHospHistoryArrow.Click
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Expand Hospitalization History Table.  Actual Result: Unable to click Hospitalization History up arrow "&Err.Description)
	Call Terminator
Else 
	Call WriteToLog("Pass","Clicked Hospitalization History up arrow")
End If
Wait 2
	
	'-----------------------------------------------------------------------
	'Admitting the patient with required AdmitType, based on different cases
	'-----------------------------------------------------------------------

		'----------------------------------------------------------------------
		'Case1. If the patient never been to hospital. Admit for the first time.
		'----------------------------------------------------------------------
		'Admitting the patient
		If objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) = 0 AND objHosHistoryTable.RowCount = 0 then  
			
			Call WriteToLog("Info","============Admitting the patient patient who has never been to hospital. Admit for the first time.===========")
			blnReturnValue = AdmitPatient(dtAdmitDate, dtNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
			If Not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result: Perform Admission.  Actual Result: Unable to perform admission"  )
				Call Terminator
			End If 
			Call WriteToLog("Pass","Performed admission for new patient")
			Wait 2
		
		'-------------------------------------------------------------------------------------------------
		'Case2. patient having no previous hospital records is in hospital now > discharge and admit again
		'-------------------------------------------------------------------------------------------------
		'Discharging the patient
		ElseIf	objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) = 0 AND Instr(1,objHosHistoryTable.GetCellData(1,2),"/",1) = 0 then 
			
			Call WriteToLog("Info","============Admitting the patient having no previous hospital records is in hospital now > discharge and admit again===========")
			dtPreviousAdmitdate = objHosHistoryTable.GetCellData(1,1)
			dtDischargeDate = DateAdd("d",1,dtPreviousAdmitdate)
			dtDischargeNotificationDate = DateAdd("d",1,dtPreviousAdmitdate)
			
			blnReturnValue = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
			If Not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result: Perform Discharge.  Actual Result: Unable to perform discharge due to error: "&strOutErrorDesc)
				Call Terminator
			End If 
			Call WriteToLog("Pass","Patient with no previous records is discharged, admit follows")
			Wait 2
				
			'Admitting the patient
			dtAdmitDate = Date-2
			dtNotificationDate = Date-2
			
			blnReturnValue = AdmitPatient(dtAdmitDate, dtNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
			If Not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result: Perform Admission.  Actual Result: Unable to perform admission due to error: "&strOutErrorDesc)
				Call Terminator
			End If 
			Call WriteToLog("Pass","Successfully admitted a patient having single previous record")
			Wait 2
		
		'------------------------------------------------------------------------------------------
		'Case3.patient having previous hospital records, now in hospital; discharge and admit again	
		'------------------------------------------------------------------------------------------
		'Discharging the patient
		ElseIf	objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) <> 0 AND Instr(1,objHosHistoryTable.GetCellData(1,2),"/",1) = 0 then 
			
			Call WriteToLog("Info","============Admitting the patient having previous hospital records, now in hospital; discharge and admit again===========")
			dtPreviousAdmitdate = objHosHistoryTable.GetCellData(1,1)
			dtDischargeDate = DateAdd("d",1,dtPreviousAdmitdate)
			dtDischargeNotificationDate = DateAdd("d",1,dtPreviousAdmitdate)
				
			blnReturnValue = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
			If Not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result: Perform Discharge.  Actual Result: Unable to perform discharge due to error: "&strOutErrorDesc)
				Call Terminator
			End If 
			Call WriteToLog("Pass","Patient with previous records is discharged, admit follows")
			Wait 2
			
			'Admitting the patient
			dtAdmitDate = Date-2
			dtNotificationDate = Date-2
			
			blnReturnValue = AdmitPatient(dtAdmitDate, dtNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
			If Not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result: Perform Admission.  Actual Result: Unable to perform admission due to error: "&strOutErrorDesc)
				Call Terminator
			End If 
			Call WriteToLog("Pass","Successfully admitted a patient with more than one previous record")
			Wait 2
		
		'------------------------------------------------------------------------------------------
		'Case4. patient having previous hospital records is not in hospital now > add new admission
		'------------------------------------------------------------------------------------------
		ElseIf	objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) <> 0 AND Instr(1,objHosHistoryTable.GetCellData(1,2),"/",1) <> 0 then 
			
			Call WriteToLog("Info","============Admitting the patient having previous hospital records is not in hospital now > add new admission===========")
			'Admitting the patient
			blnReturnValue = AdmitPatient(dtAdmitDate, dtNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
			If Not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result: Perform Admission.  Actual Result: Unable to perform admission due to error: "&strOutErrorDesc)
				Call Terminator
			End If 
			Call WriteToLog("Pass","Patient with many previous records is admitted newly")
			Wait 2
		
		'-----------------------------------------
		'Case5.add new admission for fresh patient
		'-----------------------------------------
		Else	
			
			Call WriteToLog("Info","------------------Add new admission for fresh patient------------------")
			'Admitting the patient
			blnReturnValue = AdmitPatient(dtAdmitDate, dtNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
			If Not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result: Perform Admission.  Actual Result: Unable to perform admission due to error: "&strOutErrorDesc)
				Call Terminator
			End If	 
			Call WriteToLog("Pass","New admission for a patient")
			Wait 2
			
		End If
Err.clear
Wait 5

'---------------------
'Logout of application
'---------------------
Call WriteToLog("Info","-------------Logout of application-------------")
Call Logout()
Wait 2

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Condition chk for login - whether assigned VHN or any other user 
	If Ucase(Trim(strUserOtherThanAssignedVHN)) <> "VHN" Then

		'---------------------------------------
		'Login to a user other than assigned VHN
		'---------------------------------------
		Call WriteToLog("Info","-----------------Login to '"&strUserOtherThanAssignedVHN&"' user-----------------")
		blnLogin = Login(strUserOtherThanAssignedVHN)
		If not blnLogin Then
			Call WriteToLog("Fail","Actual Result: Failed to Login to VHN role."&"  Expected Result: Login to ARN with valid credentials")
			Call Terminator
		End If
		Call WriteToLog("Pass","Successfully logged into "&strUserOtherThanAssignedVHN&"  role")
		
		'Close all open patient   
		blnCP = CloseAllOpenPatient(strOutErrorDesc)
		If Not blnCP Then
			strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
			Call WriteToLog("Fail", strOutErrorDesc&"  Expected Result: Close all open patients")
			Call Terminator
		End If
		Call WriteToLog("Pass","Closed all open patients")
		Wait 2
		
		Err.Clear		
		'-------------------------------------------------------
		'Getting specific patient and performing required acions
		'(Ensuring the patient is of assigned VHN)
		'-------------------------------------------------------
		Set objPage = Nothing
		Set objAdmitDateTxt = Nothing  
		Set objDischargeDateTxt = Nothing  
		Set objDischargeNotificationDateTxt = Nothing 
		Set objDispositionDD = Nothing  
		Set objSaveBtn = Nothing 	
		Execute "Set objPage = " & Environment("WPG_AppParent") 'Page object
		Execute "Set objAdmitDateTxt = " & Environment("WE_AdmitDateTxt") 'Admit date text box
		Execute "Set objDischargeDateTxt = " & Environment("WE_DischargeDateTxt") 'Discharge Date edit box
		Execute "Set objDischargeNotificationDateTxt = " & Environment("WE_DischargeNotificationDateTxt") 'Discharge date notification edit box
		Execute "Set objDispositionDD = " & Environment("WB_DispositionDD") 'Disposition dropdown
		Execute "Set objSaveBtn = " & Environment("WI_DischargeSaveBtn") 'Discharge Save btn
		
		'Search with patient MemID 
		blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
		If Not blnGlobalSearchUsingMemID Then
			strOutErrorDesc = "Select patient through global search returned error: "&strOutErrorDesc
			Call WriteToLog("Fail", "Expected Result: User should be able to select patient through global search; Actual Result: "&strOutErrorDesc)
			Call Terminator
		End If
		Call WriteToLog("Pass","Successfully selected required patient through global search")
		Wait 3
		
		Call waitTillLoads("Loading...")
		Wait 2
		
		'Handle navigation error if exists
		blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
		If not blnHandleWrongDashboardNavigation Then
		    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
		End If
		Call WriteToLog("Pass","Provided proper navigation after patient selection")
		Wait 2
		
		'-----------------------------------------------------
		'Discharging the patient to send alert to assigned VHN
		'-----------------------------------------------------
		Call WriteToLog("Info","------------------Discharging the patient to send alert to assigned VHN------------------")
		'Navigate to ClinicalManagement > Hospitalizations
		blnScreenNavigation = clickOnSubMenu_WE("Clinical Management->Hospitalizations")
		If not blnScreenNavigation Then
			Call WriteToLog("Fail","Unable to navigate to Clinical Management > Hospitalizations "&strOutErrorDesc)
			Call Terminator
		End If
		Call WriteToLog("Pass","Navigated to Clinical Management > Hospitalizations")
		wait 4
		Call waitTillLoads("Loading...")
		Wait 2
		
		Err.Clear
		dtAdmitDate = objAdmitDateTxt.GetROProperty("value")
		dtDischargeDate = DateAdd("d",1,dtAdmitDate)
		dtDischargeNotificationDate = dtDischargeDate
		
		dtDischargeDate = DateAdd("d",-2,Date)
		dtDischargeNotificationDate = dtDischargeDate
		strDisposition = "Home"
		
		blnReturnValue = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
		If Not blnReturnValue Then
			Call WriteToLog("Fail","Expected Result: Perform Discharge.  Actual Result: Unable to perform discharge due to error")
			Call Terminator
		End If
		Call WriteToLog("Pass","Successfully discharged the patient from "&strUserOtherThanAssignedVHN&" user")
		Wait 2
		
		'--------------------------------------
		'logout of user other than assigned VHN
		'--------------------------------------
		Call WriteToLog("Info","----------------Logout from "&strUserOtherThanAssignedVHN&" user----------------")
		Call Logout()
		wait 2
		
	End If 'If Ucase(Trim(strUserOtherThanAssignedVHN)) <> "VHN" Then
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				
Set objPage = Nothing
Execute "Set objPage = " & Environment("WPG_AppParent")
'---------------------
'Login to assigned VHN
'---------------------
Call WriteToLog("Info","-------------Login to assigned VHN-------------")
blnLogin = Login("vhn")
If not blnLogin Then
	Call WriteToLog("Fail","Expected Result: Login to VHN with valid credentials.  Actual Result: Failed to Login to VHN role.")
	Call Terminator
End If
Call WriteToLog("Pass","Successfully logged into VHN role")
Wait 5
		
'Select user roster
blnSelectUserRoster = SelectUserRoster(strOutErrorDesc)
If Not blnSelectUserRoster Then
	strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc&"  Expected Result: Select user roater")
	Call Terminator
End If
wait 5
err.Clear

'--------------------------------------------------
'Validating Alert message - both content and format
'--------------------------------------------------
Call WriteToLog("Info","------------------Validating Alert message - both content and format------------------")

'Clk on Alerts expand arrow image
Err.Clear
objAlertUpArrow.click
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Expand Alert Msg Tab.  Actual Result: Unable to click Discharge Alert expand arrow image "&Err.Description)
	Call Terminator	
End If
Call WriteToLog("Pass","Discharge Alert notification tab is expanded")
Wait 5

	'set required date format
	dtDischargeDate = DateFormat(dtDischargeDate)
	'Create discharge alert object for required pAatient
	Set objDischargeAlertMessage = objPage.WebElement("class:=sanitizedFooterAlert","html tag:=PRE","outertext:="&strPatientName&" - Discharged - "&dtDischargeDate&".*")
	objDischargeAlertMessage.highlight
	
	
	If Ucase(Trim(strUserOtherThanAssignedVHN)) <> "VHN" Then  'CASE A:Validation of Discharge Alert to assigned VHN by discharge made by other user
			
		'CASE A.1: Discharge for SNF/Rehab or Hospital admit
		'check availability of Discharge Alert 
		If Trim(strAdmitType) = "SNF/Rehab Admit" OR  Trim(strAdmitType) = "Hospital Admit" Then
			If not objDischargeAlertMessage.Exist(10) Then
				Call WriteToLog("Fail","Expected Result: Discharge Alert should be available for "&strAdmitType&".  ActualResult: DiscahrgeAlert is not available")
				Call Terminator
			End If
			Call WriteToLog("Pass","Discharge Alert is available for "&strAdmitType)
			
			'check format of discharge Alert
			strDischargeAlertFormat = Trim(objDischargeAlertMessage.GetROProperty("outertext"))
			If Trim(strPatientName&" - Discharged - "&dtDischargeDate) = strDischargeAlertFormat Then
				Call WriteToLog("Pass","Discharge Alert is available for "&strAdmitType&" is as per required format")
			Else
				Call WriteToLog("Fail","Discharge Alert is NOT available for "&strAdmitType&" is as per required format")
			End If 
			Err.Clear
			Wait 5
			
			'Check alert acknowldgement
			
			'Clk on required alert msg
			Err.Clear
			objDischargeAlertMessage.Click
			If err.number = 0 Then
				Call WriteToLog("Pass","Clicked on required alert msg")
			Else
				strOutErrorDesc = "Unable to click on required alert msg:"& Err.Description
				Call WriteToLog("Fail","Expected Result: Should be able to click on required alert msg.  Actual Result: "&strOutErrorDesc)
				Call Terminator
			End If
			'Verify DischargeAcknowledgement 
			If objDischargeAcknowledgeAlertpp.Exist(10) Then
				Call WriteToLog("Pass","DischargeAcknowledgeAlert popup exists")
			Else
				strOutErrorDesc = "Unable to find DischargeAcknowledgeAlert popup:"& Err.Description
				Call WriteToLog("Fail","Expected Result: DischargeAcknowledgeAlert popup exists.  Actual Result: "&strOutErrorDesc)
				Call Terminator
			End If
			Err.Clear
			Wait 5
			
				'CASE A.1.1: Discharge for SNF/Rehab or Hospital admit; if he wants to acknowledge alert
				Err.Clear
				If Lcase(strAcknowledgeDischargeAlert) = "yes" Then
					objDischargeAcknowledgeAlertppYesBtn.Click
					If err.number = 0 Then
						Call WriteToLog("Pass","Clicked on DischargeAcknowledgeAlert pop up Yes btn")
					Else
						strOutErrorDesc = "Unable to click DischargeAcknowledgeAlert pop up Yes btn:"& Err.Description
						Call WriteToLog("Fail","Expected Result: Should be able to click DischargeAcknowledgeAlert pop up Yes btn.  Actual Result: "&strOutErrorDesc)
						Call Terminator
					End If
					
					'Verify Alert has been acknowledged popup
					If objAlertAcknowledgedpp.Exist(10) Then
						Call WriteToLog("Pass","Alert Acknowledged popup exists")
					Else
						strOutErrorDesc = "Unable to find Alert Acknowledged popup:"& Err.Description
						Call WriteToLog("Fail","Expected Result: Alert Acknowledged popup should exist.  Actual Result: "&strOutErrorDesc)
						Call Terminator
					End If
					Err.Clear
					Wait 3
					
					'Clk on Alert Acknowledged  popup OK btn
					Err.Clear
					objAlertAcknowledgedppOK.Click
					If err.number = 0 Then
						Call WriteToLog("Pass","Clicked on AlertAcknowledged popup OK btn")
					Else
						strOutErrorDesc = "Unable to click on  AlertAcknowledged popup OK btn:"& Err.Description
						Call WriteToLog("Fail","Expected Result: Should be able to click on AlertAcknowledged popup OK btn.  Actual Result: "&strOutErrorDesc)
						Call Terminator
					End If
					
					'Chk whether PatientProfile is loaded
					If objPatientProfile.Exist(10) Then
						Call WriteToLog("Pass","Patient Profile page is loaded")
					Else
						strOutErrorDesc = "Unable to find Patient Profile page"
						Call WriteToLog("Fail","Expected Result: Should be able to find Patient Profile page.  Actual Result: "&strOutErrorDesc)
						Call Terminator
					End If
					Wait 5
					
					'Check whether alert msg exists - it should NOT exist in this scenario
					'Clk on Alerts expand arrow icon
					Set objAlertUpArrow = Nothing
					Execute "Set objAlertUpArrow = " & Environment("WEL_AlertUpArrow") 'Alert up arrow
					objAlertUpArrow.click
					If Err.number <> 0 Then
						Call WriteToLog("Fail","Actual Result: Unable to click Discharge Alert expand arrow image "&Err.Description&"  Expected Result: Expand Alert Msg Tab")
						Call Terminator	
					End If
					Call WriteToLog("Pass","Discharge Alert notification tab is expanded")
											
					Set objDischargeAlertMessage = Nothing
					Set objDischargeAlertMessage = objPage.WebElement("class:=sanitizedFooterAlert ng-binding","html tag:=PRE","outertext:="&strPatientName&" - Discharged - "&dtDischargeDate&".*")
					
					If not objDischargeAlertMessage.Exist(5) Then
						Call WriteToLog("Pass","Discharge Alert is NOT existing as expected, as user acknowledged Alert Message")
					Else
						Call WriteToLog("Fail","Expected Result: Discharge Alert should not exist if user is acknowledging Alert Message.  Actual Result: Discharge Alert is existing eventhough user acknowledged Alert Message")
						Call Terminator		
					End If
					
				End If
				Wait 5
			
				'CASE A.1.2: Discharge for SNF/Rehab or Hospital admit; if he doesn't want to acknowledge alert
				Err.Clear
				If Lcase(strAcknowledgeDischargeAlert) = "no" Then
					Err.Clear
					objDischargeAcknowledgeAlertppNoBtn.Click
					If err.number = 0 Then
						Call WriteToLog("Pass","Clicked on DischargeAcknowledgeAlert pop up No btn")
					Else
						strOutErrorDesc = "Unable to click DischargeAcknowledgeAlert pop up No btn:"& Err.Description
						Call WriteToLog("Fail","Expected Result: Should be able to click DischargeAcknowledgeAlert pop up No btn.  Actual Result: "&strOutErrorDesc)
						Call Terminator
					End If
					'Chk whether PatientProfile is loaded
					If objPatientProfile.Exist(10) Then
						Call WriteToLog("Pass","Patient Profile page is loaded")
					Else
						strOutErrorDesc = "Unable to find Patient Profile page"
						Call WriteToLog("Fail","Expected Result: Should be able to find Patient Profile page.  Actual Result: "&strOutErrorDesc)
						Call Terminator
					End If
					Wait 15
					
					'Check whether alert msg still exists - it should exist in this scenario
					'Clk on Alerts expand arrow image
					Set objAlertUpArrow = Nothing
					Execute "Set objAlertUpArrow = " & Environment("WEL_AlertUpArrow") 'Alert up arrow
					Err.Clear
					objAlertUpArrow.click
					If Err.number <> 0 Then
						Call WriteToLog("Fail","Actual Result: Unable to click Discharge Alert expand arrow image "&Err.Description&"  Expected Result: Expand Alert Msg Tab")
						Call Terminator	
					End If
					Call WriteToLog("Pass","Discharge Alert notification tab is expanded")
					
					Set objDischargeAlertMessage = Nothing
					Set objDischargeAlertMessage = objPage.WebElement("class:=sanitizedFooterAlert ng-binding","html tag:=PRE","outertext:="&strPatientName&" - Discharged - "&dtDischargeDate&".*")
					
					If objDischargeAlertMessage.Exist(10) Then
						Call WriteToLog("Pass","Discharge Alert is still existing as expected, as user didn't acknowledge Alert Message")
					Else
						Call WriteToLog("Fail","Expected Result: Discharge Alert should exist if user is not acknowledging Alert Message.  Actual Result: Discharge Alert is not existing eventhough user didn't acknowledge Alert Message")
						Call Terminator		
					End If
				End If
		
		'CASE A.2: Discharge Alert NOT required for admit other than SNF/Rehab or Hospital admit	
		Set objDischargeAlertMessage = Nothing
		Set objDischargeAlertMessage = objPage.WebElement("class:=sanitizedFooterAlert ng-binding","html tag:=PRE","outertext:="&strPatientName&" - Discharged - "&dtDischargeDate&".*")
		ElseIf Trim(strAdmitType) <> "SNF/Rehab Admit" AND Trim(strAdmitType) <> "Hospital Admit" Then
			If  objDischargeAlertMessage.Exist(10) Then
				Call WriteToLog("Fail","Expected Result: Discharge Alert should NOT be available for "&strAdmitType&".  ActualResult: DiscahrgeAlert is available")
				Call Terminator
			End If
			Call WriteToLog("Pass","Discharge Alert is NOT available for "&strAdmitType&" as expected")			
		End If

	
	Else  'CASE B:Validation of Discharge Alert to assigned VHN when he only discharges the aptient (Discharge Alert is NOT required for assigned VHN when he only discarges the patient)
		
		Set objDischargeAlertMessage = Nothing
		Set objDischargeAlertMessage = objPage.WebElement("class:=sanitizedFooterAlert ng-binding","html tag:=PRE","outertext:="&strPatientName&" - Discharged - "&dtDischargeDate&".*")
	
		If not objDischargeAlertMessage.Exist(10) Then
			Call WriteToLog("Pass","Discharge Alert is not existing as expected, as user is assigned VHN")
		Else
			Call WriteToLog("Fail","Expected Result: Discharge Alert is should not exist, as user is assigned VHN.  Actual Result: Discharge Alert is still existing eventhough user is assigned VHN")
			Call Terminator			
		End If
		
	End If


'---------------------
'Logout of application
'---------------------
Call WriteToLog("Info","---------------Logout of application---------------")
Call Logout()

'Set objects free
Set objPage = Nothing
Set objAddBtn = Nothing
Set objDischargeDateTxt = Nothing
Set objDischargeNotificationDateTxt = Nothing
Set objDispositionDD = Nothing
Set objAdmitDateTxt = Nothing
Set objHospHistoryArrow = Nothing
Set objLDDonPP = Nothing
Set objHosHistoryTable = Nothing
Set objAlertUpArrow = Nothing
Set objSaveBtn = Nothing
Set objDischargeAcknowledgeAlertpp = Nothing
Set objDischargeAcknowledgeAlertppYesBtn = Nothing
Set objDischargeAcknowledgeAlertppNoBtn = Nothing
Set objAlertAcknowledgedpp = Nothing
Set objAlertAcknowledgedppOK = Nothing
Set HospitalizationRecordUpdateSuccesspp = Nothing
Set objPatientProfile = Nothing

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
