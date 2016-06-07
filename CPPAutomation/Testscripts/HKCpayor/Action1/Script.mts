'********************************************************************************************************************************************************************************************
' TestCase Name			: HKCpayor
' Purpose of TC			: Validate if patient name is present under 'Open Call List' of ‘PTC User’.
' Pre requisite			: Patient selected should have 1.any one of VCA,HCP,ATN,ESC,HKC,HMK as payor, 2. should have Med Advisor programs added, 3. should not have PTC association
' Author                : Gregory
' Date                  : 10 August 2015
' Date Modified			: 6 November 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04859	
'						: Execute the script offshore ONLY afternoon 
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
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData") 
strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")
strMedicalDetails = DataTable.Value("MedicalDetails","CurrentTestCaseData")
strPayor = DataTable.Value("Payor","CurrentTestCaseData")
strPayorNames = DataTable.Value("PayorNames","CurrentTestCaseData")
dtAdmitDate = DataTable.Value("AdmitDate","CurrentTestCaseData") 
dtAdmitDate = Split(dtAdmitDate," ",-1,1)(0)
dtAdmitNotificationDate = DataTable.Value("AdmitNotificationDate","CurrentTestCaseData")
dtAdmitNotificationDate = Split(dtAdmitNotificationDate," ",-1,1)(0)
dtDischargeDate = DataTable.Value("DischargeDate","CurrentTestCaseData") 
dtDischargeDate = Split(dtDischargeDate," ",-1,1)(0)
dtDischargeNotificationDate = DataTable.Value("DischargeNotificationDate","CurrentTestCaseData") 
dtDischargeNotificationDate = Split(dtDischargeNotificationDate," ",-1,1)(0)
strAdmitType = DataTable.Value("AdmitType","CurrentTestCaseData")
strNotifiedBy = DataTable.Value("NotifiedBy","CurrentTestCaseData")
strSourceOfAdmit = DataTable.Value("SourceOfAdmit","CurrentTestCaseData")
strAdmittingDiagnosisTxt = DataTable.Value("AdmittingDiagnosis","CurrentTestCaseData")
strWorkingDiagnosisTxt = DataTable.Value("WorkingDiagnosis","CurrentTestCaseData")
strDisposition = DataTable.Value("Disposition","CurrentTestCaseData")

On Error Resume Next
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
	
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

'Logout
Call WriteToLog("Info","-------------------------------------Logout of application--------------------------------------")
Call Logout()
Wait 2

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'Login as vhn - Admit and discharge patient with required Admit type
'-------------------------------------------------------------------

'-------------------------------
'Close all open patients from DB
Call closePatientsFromDB("vhn")
'-------------------------------

'Navigation: Login as vhn > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

'Getting specific patient through Global Search
blnGolbalSelection = GlobalSearchUsingMemID(lngMemberID,strOutErrorDesc)
If not blnGolbalSelection Then
	Call WriteToLog("Fail","Expected Result: User should be able to select required patient through Global Search.  Actual Result: Unable to select required patient through Global Search.")
	Call Terminator
End If
Call WriteToLog("Pass","Selected required patient through Global Search")

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientFirstName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")

'Navigating to Clinical Management > Hospitalizations screen, Admit and Discharge the patient
Call WriteToLog("Info","-----------------Navigating to Clinical Management > Hospitalizations screen-------------------")

'Navigate to ClinicalManagement > Hospitalizations
blnScreenNavigation = clickOnSubMenu_WE("Clinical Management->Hospitalizations")
If not blnScreenNavigation Then
	Call WriteToLog("Fail","Unable to navigate to Clinical Management > Hospitalizations "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Navigated to Clinical Management > Hospitalizations")
wait 4
Call waitTillLoads("Loading...")
wait 1

Call WriteToLog("Info","-----------------Patient admission and discharge with required values-------------------")

'Admitting the patient
Call WriteToLog("Info","--------------------------Admitting the patient--------------------------")
blnAdmitPatient = AdmitPatient(dtAdmitDate, dtAdmitNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
If Not blnAdmitPatient Then
	Call WriteToLog("Fail","Expected Result: Perform Admission.  Actual Result: Unable to perform admission"  )
	Call Terminator
End If	
	
If strAdmitType <> "ED Visit" Then
	Call WriteToLog("Pass","Patient is admitted")
Else
	Call WriteToLog("Pass","Patient is discharged")
End If
	
If strAdmitType <> "ED Visit" Then
	'Discharging the patient
	Call WriteToLog("Info","--------------------------Discharging the patient--------------------------")
	blnDischargePatient = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
	If Not blnDischargePatient Then
		Call WriteToLog("Fail","Expected Result: Perform Discharge.  Actual Result: Unable to perform discharge due to error: "&strOutErrorDesc)
		Call Terminator
	End If 
	Call WriteToLog("Pass","Patient is discharged")	
End If

'Logout
Call WriteToLog("Info","-------------------------------------Logout of application--------------------------------------")
Call Logout()
Wait 2

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("Info","------------------Login to PTC user and selecting the roster of assigned PTC user------------------")

'Login to assigned PTC and validate PTC assignment, Med Advisor program
'-----------------------------------------------------------------------

'-------------------------------
'Close all open patients from DB
Call closePatientsFromDB("ptc")
'-------------------------------

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
strReqdPatientName =  strRegRxp&strPatientSecondName&strRegRxp

Execute "Set objPage = " & Environment("WPG_AppParent") 'Page object
Set objReqdPatientName = objPage.WebElement("class:=has-menu open-call-list-patient-name","html tag:=SPAN","visible:=True","outertext:="&strReqdPatientName)

strFalgPTCreqd = False
For iPayor = 0 To Ubound(arrPayors) Step 1
	If Trim(Lcase(strPayor)) = Lcase(arrPayors(iPayor))  Then
		strFalgPTCreqd = True
		Exit For
	End If
Next

'Validating Open Call list for the patient who is having any of VCA,HCP,ATN,ESC,HKC,HMK as payor
If strFalgPTCreqd AND (Ucase(strAdmitType) = "HOSPITAL ADMIT") then 

	strPatientFirstName = Trim(Split(strPatientSecondName,",",-1,1)(0))
	blnValidatePatientRecordInPTC = ValidatePatientRecordInPTC(strPatientFirstName, strOutErrorDesc)
	If not blnValidatePatientRecordInPTC Then
		Call WriteToLog("Fail","Patient record is not added in PTC Open Call List")
		Call Terminator		
	End If 
	Call WriteToLog("Pass","Patient record is added in PTC Open Call List - Successfully validated PTC assignment for patient")

Else

	Call WriteToLog("Info","Patient has"& Ucase(strPayor)&" as payor, need NOT be assigned to PTC user; Validation follows")
	
	strPatientFirstName = Trim(Split(strPatientSecondName,",",-1,1)(0))
	blnValidatePatientRecordInPTC = ValidatePatientRecordInPTC(strPatientFirstName, strOutErrorDesc)	
	If not blnValidatePatientRecordInPTC Then
		Call WriteToLog("Pass","Patient record is not added in PTC Open Call List - Patient is not having PTC assignment")
	Else
		Call WriteToLog("Fail","Patient is assigned to PTC user - Patient is present in Open Call list of assigned user")
		Call Terminator
	End If
	
End If

'Validating Med Advisor program added to required patient
'--------------------------------------------------------
Call WriteToLog("Info","Validating Med Advisor program added to required patient")

'Getting specific patient through Global Search
'----------------------------------------------
blnGolbalSelection = GlobalSearchUsingMemID(lngMemberID,strOutErrorDesc)
If not blnGolbalSelection Then
	Call WriteToLog("Fail","Expected Result: User should be able to select required patient through Global Search.  Actual Result: Unable to select required patient through Global Search.")
	Call Terminator
End If
Call WriteToLog("Pass","Selected required patient through Global Search")

'Close all available popups
blnCloseAllAvailablePopups = CloseAllAvailablePopups()
If not blnCloseAllAvailablePopups Then
	Call WriteToLog("Fail","Unable to close message box. " &Err.Description)
	Call Terminator
End If

'Click on Patient profile expand icon
Execute "Set objPatientProfileExpand = " & Environment("WI_PatientProfileExpand")  'PatientProfileExpand icon
Err.Clear
objPatientProfileExpand.Click
If Err.number <> 0 Then
    Err.Clear
    Execute "Set objPatientProfileExpand = " & Environment("WI_PatientProfileExpand_New")  'PatientProfileExpand icon new    
    Err.Clear
    objPatientProfileExpand.Click
    If Err.number <> 0 Then
        Call WriteToLog("Fail","Expected Result: User should be able to click on Patient Profile icon.  Actual Result: Unable to click on Patient Profile icon: "&strOutErrorDesc)
        Call Terminator
    End If
    Call WriteToLog("Pass","Clicked on Patient Profile icon")
End If
Call WriteToLog("Pass","Clicked on Patient Profile icon")
Wait 2
Call waitTillLoads("Loading...")
Wait 1

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
Set objPatientProfileExpand = Nothing
Set objProgramsAdded = Nothing

'Iteration loop
Loop While False: Next
wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

Function ValidatePatientRecordInPTC(ByVal strPatientFirstName, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ValidatePatientRecordInPTC = False
	
	'Validate PTC assignment
	Execute "Set objPage_PTC = " & Environment("WPG_AppParent")	
	Set objReqdPatientName = objPage_PTC.WebElement("html tag:=SPAN","visible:=True","outertext:=.*"&strPatientFirstName&".*")
	
	blnPatientNameStatus = False
	intFinite = 1	
	
	If objReqdPatientName.Exist(5) Then
	
		objReqdPatientName.highlight
		blnPatientNameStatus=True
		
	Else
	
		Do Until (blnPatientNameStatus = True OR intFinite = 100)
		
			Execute "Set objPage_PTC = Nothing"
			Execute "Set objPage_PTC = " & Environment("WPG_AppParent")
			
			Err.Clear
			objPage_PTC.WebElement("html tag:=SPAN","outerhtml:=.*Go to the next page.*","visible:=True").click	'GoToNextPage icon
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to click GoToNextPage icon of OpenCallList in PTC"
				Exit Function
			End If		
			Wait 0,200		
			Call waitTillLoads("Loading...")	
			
			Execute "Set objPage_PTC = Nothing"
			Set objReqdPatientName = Nothing
			Execute "Set objPage_PTC = " & Environment("WPG_AppParent")
			Set objReqdPatientName = objPage_PTC.WebElement("html tag:=SPAN","visible:=True","outertext:=.*"&strPatientFirstName&".*")
			
			If objReqdPatientName.Exist(.2) Then
				objReqdPatientName.highlight
				blnPatientNameStatus=True 
				Exit Do
			End If 
			
			intFinite= intFinite+1
			
		Loop 
		
	End If     	
	
	If blnPatientNameStatus = True Then
		ValidatePatientRecordInPTC = True		
	End If 
	
	Execute "Set objPage_PTC = Nothing"
	Set objReqdPatientName = Nothing
	
	Wait 1
	
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
	If objDisclaimerOK.Exist(5) Then
		Err.Clear
		objDisclaimerOK.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'Disclaimer' message box OK button." &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked 'Disclaimer' message box OK button")			
	End If
	Execute "Set objDisclaimerOK = Nothing"
	
	Wait 2
	Call waitTillLoads("Loading...")
	
	CloseAllAvailablePopups = True
	
End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function

