
'********************************************************************************************************************************************************************************************
' TestCase Name			: HKCpayor
' Purpose of TC			: Validate if patient name is present under 'Open Call List' of ‘PTC User’.
' Pre requisite			: Patient selected should have 1.any one of VCA,HCP,ATN,ESC,HKC,HMK as payor, 2. should have Med Advisor programs added, 3. should not have PTC association
' Author                : Gregory
' Date                  : 10 August 2015
' Date Modified			: 6 November 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04859
						
'*******************************************************************************************************************************************************************************************
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "HKCpayor", strOutTestName, strOutErrorDesc) 
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
strMedicalDetails = DataTable.Value("MedicalDetails","CurrentTestCaseData")
strPayor = DataTable.Value("Payor","CurrentTestCaseData")
strPayorNames = DataTable.Value("PayorNames","CurrentTestCaseData")
strAdmitType = DataTable.Value("AdmitType","CurrentTestCaseData")
strNotifiedBy = DataTable.Value("NotifiedBy","CurrentTestCaseData")
strSourceOfAdmit = DataTable.Value("SourceOfAdmit","CurrentTestCaseData")
strAdmittingDiagnosisTxt = DataTable.Value("AdmittingDiagnosis","CurrentTestCaseData")
strWorkingDiagnosisTxt = DataTable.Value("WorkingDiagnosis","CurrentTestCaseData")
dtAdmitDate = DataTable.Value("AdmitDate","CurrentTestCaseData") 
dtNotificationDate = DataTable.Value("NotificationDate","CurrentTestCaseData")  'should be within 7 days prior to sys date
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData") 
strTakeDischagreDatesFromTestData = DataTable.Value("TakeDischagreDatesFromTestData","CurrentTestCaseData") 
dtDischargeDateFromTestData = DataTable.Value("DischargeDate","CurrentTestCaseData") 
dtNotificationDateFromTestData = DataTable.Value("DischargeNotificationDate","CurrentTestCaseData")
strDisposition = DataTable.Value("Disposition","CurrentTestCaseData")

On Error Resume Next
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
	
Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"'----------------") 

'Login as eps and refer a new member.
'-----------------------------------------
'Navigation: Login as eps > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("eps", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")											
Wait 0,500

'Create newpatient
strNewPatientDetails = CreateNewPatientFromEPS(strPatientName,"NA",strMedicalDetails,strOutErrorDesc)
If strNewPatientDetails = "" Then
	Call WriteToLog("Fail","Expected Result: User should be able to create new SNP patient in EPS. Actual Result: Unable to  create new SNP patient in EPS."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Created new SNP patient in EPS")	
Wait 1

arrNewPatientDetails = Split(strNewPatientDetails,",",-1,1)
lngMemberID = arrNewPatientDetails(0)
Wait 1

'Logout
Call WriteToLog("Info","-------------------------------------Logout of application--------------------------------------")
Call Logout()
Wait 2

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'Login as vhn - Admit and discharge patient with required Admit type
'-------------------------------------------------------------------
'Navigation: Login as vhn > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

''Getting specific patient through MyPatients Page
''Select patient from MyPatient list
'blnSelectPatientFromPatientList = SelectPatientFromPatientList(strUser, strPatientName)
'If blnSelectPatientFromPatientList Then
'	Call WriteToLog("Pass","Selected required patient from MyPatient list")
'Else
'	strOutErrorDesc = "Unable to select required patient"
'	Call WriteToLog("Fail","Expected Result: Should be able to select required patient from MyPatient list.  Actual Result: "&strOutErrorDesc)
'	Call Terminator
'End If

'Getting specific patient through Global Search
blnGolbalSelection = selectPatientFromGlobalSearch(lngMemberID)
If not blnGolbalSelection Then
	Call WriteToLog("Fail","Expected Result: User should be able to select required patient through Global Search.  Actual Result: Unable to select required patient through Global Search.")
	Call Terminator
End If
Call WriteToLog("Pass","Selected required patient through Global Search")
Wait 2

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")

Wait 3
Call waitTillLoads("Loading...")
Wait 2

'Navigating to Clinical Management > Hospitalizations screen and following business logic
Call WriteToLog("Info","-----------------Navigating to Clinical Management > Hospitalizations screen-------------------")
Call clickOnSubMenu_WE("Clinical Management->Hospitalizations")

wait 2
Call waitTillLoads("Loading...")
wait 2

'Clk on Hospitalization History table expand arrow image
Err.clear
Execute "Set objHospHistoryArrow = " & Environment("WI_HospHistoryArrow") 'Hospitalization history up arrow
objHospHistoryArrow.Click
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Expand Hospitalization History Table.  Actual Result: Unable to click Hospitalization History up arrow "&Err.Description)
	Call Terminator	
End If 
Call WriteToLog("Pass","Clicked Hospitalization History up arrow")
Wait 5

Call WriteToLog("Info","-----------------Patient admission and discharge based on requirements-------------------")
'---------------------------------------------------------------------------------------------------------------------------------------------------
'Case1. If the patient never been to hospital. Admit for the first time with required Admit type and then discharge
'Case2. patient having previous hospital records is not in hospital now > add new admission with required admit type and then discharging the patient 			
'---------------------------------------------------------------------------------------------------------------------------------------------------
Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
Execute "Set objHosHistoryTable = " & Environment("WT_HosHistoryTable") 'Hospitalization history table
Execute "Set objLDDonPP = " & Environment("WEL_LDDonPP") 'Last date of discharge on popup
If objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) = 0 AND objHosHistoryTable.RowCount = 0 OR _
	NOT objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) = 0 AND objHosHistoryTable.RowCount = 0 OR _
	objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) = 0 AND objHosHistoryTable.RowCount <> 0 OR _
	NOT objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) = 0 AND objHosHistoryTable.RowCount <> 0 OR _
	objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) <> 0 AND Instr(1,objHosHistoryTable.GetCellData(1,2),"/",1) <> 0 OR _
	NOT objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) <> 0 AND Instr(1,objHosHistoryTable.GetCellData(1,2),"/",1) <> 0 Then

	'Admitting the patient
	Call WriteToLog("Info","--------------------------Admitting the patient--------------------------")
	blnAdmitPatient = AdmitPatient(dtAdmitDate, dtNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
	If Not blnAdmitPatient Then
		Call WriteToLog("Fail","Expected Result: Perform Admission.  Actual Result: Unable to perform admission"  )
		Call Terminator
	End If	
	
	If strAdmitType <> "ED Visit" Then
		Call WriteToLog("Pass","Patient is admitted")
	Else
		Call WriteToLog("Pass","Patient is discharged")
	End If
	Wait 2
	
	If strAdmitType <> "ED Visit" Then
		'Discharging the patient
		Call WriteToLog("Info","--------------------------Discharging the patinet--------------------------")
		If Ucase(Trim(strTakeDischagreDatesFromTestData)) = "YES" Then
			dtDischargeDate = dtDischargeDateFromTestData
			dtDischargeNotificationDate = dtNotificationDateFromTestData
		Else 		
			dtPreviousAdmitdate = objHosHistoryTable.GetCellData(1,1)
			dtDischargeDate = DateAdd("d",1,dtPreviousAdmitdate)
			dtDischargeNotificationDate = dtDischargeDate
		End If
		
		blnDischargePatient = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
		If Not blnDischargePatient Then
			Call WriteToLog("Fail","Expected Result: Perform Discharge.  Actual Result: Unable to perform discharge due to error: "&strOutErrorDesc)
			Call Terminator
		End If 
		Call WriteToLog("Pass","Patient is discharged")
	End If
	Wait 2	
	
End If
		
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		'Case3. patient having no previous hospital records is in hospital now > discharge him. Need not admit him again if he was having required admit type.
		'But if he is having other admit types, then first discharge him, then admit again with required admit type and then discharge
		'Case4. patient having previous hospital records, now in hospital; discharge him. Need not admit him again if he was having required admit type.
		'But if he is having other admit types,then first discharge him, then admit again with required admit type and then discharge
		'-----------------------------------------------------------------------------------------------------------------------------------------------------
		Execute "Set objAddBtn = Nothing"
		Execute "Set objHosHistoryTable = Nothing"
		Execute "Set objLDDonPP = Nothing"
		Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
		Execute "Set objHosHistoryTable = " & Environment("WT_HosHistoryTable") 'Hospitalization history table
		Execute "Set objLDDonPP = " & Environment("WEL_LDDonPP") 'Last date of discharge on popup
		Execute "Set objAdmitType = " &Environment("WEL_AdmitType")'AdmitType
		
		If	objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) = 0 AND Instr(1,objHosHistoryTable.GetCellData(1,2),"/",1) = 0 OR _
				objAddBtn.Object.isDisabled AND Instr(1,objLDDonPP.GetROProperty("outertext"),"/",1) <> 0 AND Instr(1,objHosHistoryTable.GetCellData(1,2),"/",1) = 0 then 				
			
			If  mid(objAdmitType.GetROproperty("outertext"),1,3) = "Hos" OR mid(objAdmitType.GetROproperty("outertext"),1,3) = "SNF" Then
				'Discharge the patient 
				Call WriteToLog("Info","--------------------------Discharging the patient--------------------------")
				
				dtPreviousAdmitdate = objHosHistoryTable.GetCellData(1,1)
				
				If DateDiff("d",dtPreviousAdmitdate,Date) <= 6 AND DateDiff("d",dtPreviousAdmitdate,Date) >= 0 Then
					dtDischargeDate = dtPreviousAdmitdate
					dtDischargeNotificationDate = dtDischargeDate
				End If
						
				If DateDiff("d",dtPreviousAdmitdate,Date) > 6 Then
					dtDischargeDate = DateAdd("d",-2,Date)
					dtDischargeNotificationDate = dtDischargeDate
				End If
					
				blnDischargePatient = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
				If Not blnDischargePatient Then
					Call WriteToLog("Fail","Expected Result: Perform Discharge.  Actual Result: Unable to perform discharge due to error: "&strOutErrorDesc)
					Call Terminator
				End If 
				Call WriteToLog("Pass","Patient is discharged")
				Wait 2
			End If
			
			If mid(objAdmitType.GetROproperty("outertext"),1,3) <> "Hos" AND mid(objAdmitType.GetROproperty("outertext"),1,3) <> "SNF" Then
				'Discharge the patient
				Call WriteToLog("Info","--------------------------Discharging the patinet--------------------------")
				
				dtPreviousAdmitdate = objHosHistoryTable.GetCellData(1,1)
				
				If DateDiff("d",dtPreviousAdmitdate,Date) <= 6 AND DateDiff("d",dtPreviousAdmitdate,Date) >= 0 Then
					dtDischargeDate = dtPreviousAdmitdate
					dtDischargeNotificationDate = dtDischargeDate
				End If
						
				If DateDiff("d",dtPreviousAdmitdate,Date) > 6 Then
					dtDischargeDate = DateAdd("d",-2,Date)
					dtDischargeNotificationDate = dtDischargeDate
				End If
			
				blnDischargePatient = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
				If Not blnDischargePatient Then
					Call WriteToLog("Fail","Expected Result: Perform Discharge.  Actual Result: Unable to perform discharge due to error: "&strOutErrorDesc)
					Call Terminator
				End If 
				Call WriteToLog("Pass","Patient is discharged")
				Wait 2
				
				'Admitting the patient
				Call WriteToLog("Info","--------------------------Admitting the patinet--------------------------")
				dtAdmitDate = dtDischargeDate
				dtNotificationDate = dtDischargeDate
				
				blnAdmitPatient = AdmitPatient(dtAdmitDate, dtNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
				If Not blnAdmitPatient Then
					Call WriteToLog("Fail","Expected Result: Perform Admission.  Actual Result: Unable to perform admission due to error: "&strOutErrorDesc)
					Call Terminator
				End If 
				
				If strAdmitType <> "ED Visit" Then
					Call WriteToLog("Pass","Patient is admitted")
					Else
					Call WriteToLog("Pass","Patient is discharged")
				End If
				Wait 2
				
				If strAdmitType <> "ED Visit" Then
					'Discharge the patient
					Call WriteToLog("Info","--------------------------Discharging the patinet--------------------------")
					dtPreviousAdmitdate = objHosHistoryTable.GetCellData(1,1)
					dtDischargeDate = dtDischargeDate
					dtDischargeNotificationDate = dtDischargeDate
						
					blnDischargePatient = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
					If Not blnDischargePatient Then
						Call WriteToLog("Fail","Expected Result: Perform Discharge.  Actual Result: Unable to perform discharge due to error: "&strOutErrorDesc)
						Call Terminator
					End If 
					Call WriteToLog("Pass","Patient is discharged")
				End If
				Wait 2	
			End If
			
		End If
Err.clear

'Logout
Call WriteToLog("Info","-------------------------------------Logout of application--------------------------------------")
Call Logout()
Wait 2

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("Info","------------------Login to PTC user and selecting the roster of assigned PTC user------------------")

'Login to assigned PTC and validate PTC assignment, Med Advisor program
'-----------------------------------------------------------------------
''Navigation: Login as VHN > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("ptc", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

Call WriteToLog("Info","------------------Validations:PTC assignment and Med Advisor program addition------------------")

'Validating PTC assignment for required patient
'----------------------------------------------
arrPayors = Split(Trim(strPayorNames),"|",-1,1)
strReqdPatientName =  strRegRxp&strPatientName&strRegRxp
Wait 1
Execute "Set objPage = Nothing"
Execute "Set objPage = " & Environment("WPG_AppParent") 'Page object
Set objReqdPatientName = objPage.WebElement("class:=has-menu open-call-list-patient-name","html tag:=SPAN","visible:=True","outertext:="&strReqdPatientName)
Wait 2
strFalgPTCreqd = False
For iPayor = 0 To Ubound(arrPayors) Step 1
	If Trim(Lcase(strPayor)) = Lcase(arrPayors(iPayor))  Then
		strFalgPTCreqd = True
		Exit For
	End If
Next

'Validating Open Call list for the patient who is having any of VCA,HCP,ATN,ESC,HKC,HMK as payor
If strFalgPTCreqd AND (Ucase(strAdmitType) = "HOSPITAL ADMIT") then 
	Call WriteToLog("Info","Patient has"& Ucase(strPayor)&" as payor, need to be assigned to PTC user; Validation follows")
	Execute "Set objPage = Nothing"
	Execute "Set objPage = " & Environment("WPG_AppParent") 'Page object
	Set ObjName=objPage.Link("class:=k-link","innertext:=Name","outerhtml:=.*Name.*","visible:=True")
	ObjName.Click
	Call waitTillLoads("Loading...")
	wait 5
	strReqdPatientName =  strRegRxp&strPatientName&strRegRxp
	Execute "Set objPage = Nothing"
	Execute "Set objPage = " & Environment("WPG_AppParent") 'Page object
	Set objReqdPatientName = objPage.WebElement("class:=has-menu open-call-list-patient-name","html tag:=SPAN","visible:=True","outertext:=.*"&strReqdPatientName&".*")
	PatientNameStatus=False
	If objReqdPatientName.Exist(1) Then
		PatientNameStatus=True
	else
	  	Do Until PatientNameStatus=True
	  		 Execute "Set objPage = Nothing"
			 Execute "Set objPage = " & Environment("WPG_AppParent") 'Page object
        	 objPage.WebElement("html tag:=SPAN","outerhtml:=.*Go to the next page.*","visible:=True").click
         	 Call waitTillLoads("Loading...")
          	 If objReqdPatientName.Exist(.2) Then
          		objReqdPatientName.highlight
	            PatientNameStatus=True 
	            Exit Do
		 	 End If 
     	 Loop 
	 End If     
If PatientNameStatus=True then
		Call WriteToLog("Pass","Successfully validated PTC assigned for patient:Patient is present in Open Call list of assigned user")
	Else
		strOutErrorDesc = "Patient is not present in Open Call list of assigned user"
		Call WriteToLog("Fail", "Expected Result: Patient should be assigned to PTC user. Actual Result: Patient is not assigned to PTC user. "&strOutErrorDesc)
		Call Terminator
End If 

''Validating Open Call list for the patient who is having any of VCA,HCP,ATN,ESC,HKC,HMK as payor
'If strFalgPTCreqd AND (Ucase(strAdmitType) = "HOSPITAL ADMIT") then 
'	Call WriteToLog("Info","Patient has"& Ucase(strPayor)&" as payor, need to be assigned to PTC user; Validation follows")
'	If objReqdPatientName.Exist(1) then
'			Call WriteToLog("Pass","Successfully validated PTC assigned for patient:Patient is present in Open Call list of assigned user")
'	Else
'		strOutErrorDesc = "Patient is not present in Open Call list of assigned user"
'		Call WriteToLog("Fail", "Expected Result: Patient should be assigned to PTC user. Actual Result: Patient is not assigned to PTC user. "&strOutErrorDesc)
'		Call Terminator
'	End If
	
'Validating Open Call list for the patient who is NOT having any of VCA,HCP,ATN,ESC,HKC,HMK as payor -> patient should not be assigned in this case (-ve scenario))

Else
	Call WriteToLog("Info","Patient has"& Ucase(strPayor)&" as payor, need NOT be assigned to PTC user; Validation follows")
	If NOT objReqdPatientName.Exist(1) then
		Call WriteToLog("Pass","Patient is not having PTC assignment")
	Else
		strOutErrorDesc = "Patient is present in Open Call list of assigned user"
		Call WriteToLog("Fail", "Expected Result: Patient should NOT be assigned to PTC user. Actual Result: Patient is assigned to PTC user. "&strOutErrorDesc)
		Call Terminator
	End If
End If

Wait 2

'Validating Med Advisor program added to required patient
'--------------------------------------------------------
Call WriteToLog("Info","Validating Med Advisor program added to required patient")

'Getting specific patient through Global Search
'----------------------------------------------
blnGolbalSelection = selectPatientFromGlobalSearch(lngMemberID)
If not blnGolbalSelection Then
	Call WriteToLog("Fail","Expected Result: User should be able to select required patient through Global Search.  Actual Result: Unable to select required patient through Global Search.")
	Call Terminator
End If
Call WriteToLog("Pass","Selected required patient through Global Search")
Wait 2

Call waitTillLoads("Loading...")
Wait 2

Call ClosePopups()
Wait 2

'Click on Patient profile expand icon
Err.Clear
Execute "Set objPatientProfileExpand = " & Environment("WI_PatientProfileExpand")  'PatientProfileExpand icon
objPatientProfileExpand.Click
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: User should be able to click on Patient Profile icon.  Actual Result: Unable to click on Patient Profile icon: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked on Patient Profile icon")
Wait 2

'Validating whether Med Advisor Program is added for the patient or not
Execute "Set objProgramsAdded = " & Environment("WT_ProgramsAdded") 'Programs table
intRowForMedAdvisorprog = objProgramsAdded.GetRowWithCellText("Med Advisor")
If intRowForMedAdvisorprog <= 0 Then
	Call WriteToLog("Fail","Expected Result: Med Advisor program should be added to the patient.  Actual Result: Med Advisor program is not added to the patient: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Med Advisor program is added to the patient")

'Logout
Call WriteToLog("Info","-----------------------------------Logout of application-----------------------------------")
Call Logout()
Wait 2

'Set objects free
Set objPage = Nothing
Set objAddBtn = Nothing
Set objHospHistoryArrow = Nothing
Set objLDDonPP = Nothing
Set objHosHistoryTable = Nothing
Set objAlertUpArrow = Nothing
Set objPatientProfileExpand = Nothing
Set objProgramsAdded = Nothing

'Iteration loop
Loop While False: Next
wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

Function ClosePopups()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ClosePopups = False
	
	
	blnSDMBOFDpptleOK = checkForPopup("Some Date May Be Out of Date", "Ok", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
	
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2	
	
	blnDisclaimer = checkForPopup("Disclaimer", "Ok", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2
'		
'
'	Execute "Set SDMBOFDpptle = "&Environment("WEL_SDMBOFDpptle") 'SomeDataMayBeOutOfDate popup title
'	Execute "Set objDisOK = "&Environment("WB_DisclaimerOK") 'DiscLaimer popup OK button
'	
'	'Clk SomeDataMayBeOutOfDate popup OK button if it exists
'	If SDMBOFDpptle.Exist(5) Then
'	blnSDMBOFDpptleOK = checkForPopup("Some Date May Be Out of Date", "Ok", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
'		If Not blnSDMBOFDpptleOK Then
'			strOutErrorDesc = "Some Date May Be Out of Date popup is not closed: "&strOutErrorDesc
'			Call WriteToLog("Fail", "Expected Result: Some Date May Be Out of Date popup should be closed; Actual Result: "&strOutErrorDesc)
'			Logout
'			CloseAllBrowsers
'			WriteLogFooter
'			Exit Function
'		End If
'		Call WriteToLog("Pass","SomeDataMayBeOutOfDate popup closed")
'	End If
'	Wait 2
'	
'	'Clk Disclaimer popup OK button if it exists
'	If objDisOK.Exist(5) Then
'	blnDisclaimer = checkForPopup("Disclaimer", "Ok", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
'		If not blnDisclaimer Then
'			strOutErrorDesc = "Unable to close Disclaimer popup: "&strOutErrorDesc
'			Call WriteToLog("Fail","Expected Result: Disclaimer popup should be closed; Actual Result: "&strOutErrorDesc)
'			Logout
'			CloseAllBrowsers
'			WriteLogFooter
'			Exit Function
'		End If
'		Call WriteToLog("Pass","Disclaimer popup closed")
'	End If
'	Wait 2
'	
'	Call waitTillLoads("Loading...")
'	Wait 2
	
	ClosePopups = True
	
	Execute "Set SDMBOFDpptle = Nothing"
	Execute "Set objDisOK = Nothing"

End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function

