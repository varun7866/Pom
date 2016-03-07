'**************************************************************************************************************************************************************************************************************
' TestCase Name			: Hospitalizations
' Purpose of TC			: Screen automation for Hospitalizations > Review screen for VHN role
' Author                : Gregory
' Environment			: QA(sys)/Stage/Train (url as described in Config file)
' Date                  : January 29, 2016
' Date Modified			: February 05, 2016
' Comments 				: 1. Patient chosen for test data must be discharged and discharge date should be minimum 10 days older than sys date, OR the patient should not have any hospitalization record
'						: 2. If need to execute this script off-shore, then run only afternoon
'						: 3. All functions required for this script is kept in SCREEN_functions > Hospitalizations library [except Navigator(), GlobalSearchUsingMemID() and HandleWrongDashboardNavigation()]
'**************************************************************************************************************************************************************************************************************
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Hospitalizations", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Set objFso = CreateObject("Scripting.FileSystemObject")
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
strUser = DataTable.Value("User","CurrentTestCaseData") 
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData") 
lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")

'Getting equired iterations
If not Lcase(strExecutionFlag) = "y" Then Exit Do
Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"'----------------") 

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
Err.Clear

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator(strUser, strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to '"&strUser&"' user dashboard")

'Select patient through global search
Call WriteToLog("Info","----------------Select required patient through global search----------------")
blnGlobalSearch= GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
If not blnGlobalSearch Then
	Call WriteToLog("Fail","Unable to select required patient through global search. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Selected required patient through global search")
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
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Navigation to Hospitalizations > Hospitalization Management > Review screen
blnNavigateToHospRwScr = NavigateToHospRwScr()
If not blnNavigateToHospRwScr Then
	Call WriteToLog("Fail","Unable to validate Hospitalizations > Hospitalization Management > Review screen navigation "&strOutErrorDesc)
	Call Terminator			
End If
Wait 1
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Availablity of Hospitalization Management > Review screen sections
blnPreliminaryScenarios = PreliminaryScenarios()
If not blnPreliminaryScenarios Then
	Call WriteToLog("Fail","Unable to validate Hospitalization Review screen sections "&strOutErrorDesc)
	Call Terminator											
End If
Wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Availability of all Admittance section fields and data entry into all fields
dtAdmitDate = DateAdd("d",-5,Date)
dtNotificationDate = DateAdd("d",-5,Date)
strAdmitType = "Hospital Admit"
strNotifiedBy = "Dialysis Center"
strSourceOfAdmit = "Elective Admit"

blnAdmittance_AllFields = Admittance_AllFields(dtAdmitDate,dtNotificationDate,strAdmitType,strNotifiedBy,strSourceOfAdmit,strOutErrorDesc)
If not blnAdmittance_AllFields Then
	Call WriteToLog("Fail","Unable to validate Admit fields "&strOutErrorDesc)
	Call Terminator											
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Admission without providing AdmitDate, AdmitDate < 365 days to sys date, AdmitDate > sys date, AdmitDate > AdmitNotificationDate, Provide AdmitDate <= AdmitNotificationDate  
blnAdmitDateScenariosPreliminary = AdmitDateScenariosPreliminary()	
If Not blnAdmitDateScenariosPreliminary Then
	Call WriteToLog("Fail","Unable to validate Admit Date scenarios (preliminary). "&strOutErrorDesc)
	Call Terminator	
End If
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Admission without providing AdmitNotificationDate,  AdmitNotificationDate < AdmitDate, AdmitNotificationDate older than 7 days from sys date, AdmitNotificationDate greater than sys date, Provide AdmitNotificationDate less than sys date (not less than 7 days) and >= to admit date   
blnAdmitNotificationDateScenariosPreliminary = AdmitNotificationDateScenariosPreliminary()	
If Not blnAdmitDateScenariosPreliminary Then
	Call WriteToLog("Fail","Unable to validate Admit Notification Date scenarios (preliminary). "&strOutErrorDesc)
	Call Terminator	
End If
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Admission by setting 'Notified By', 'Admit Type', 'Source of Admit', 'Admitting Diagnosis', Working Diagnosis', 'Avoidable Admission' to invalid values
blnOtherAdmitMandatoryScenarios = OtherAdmitMandatoryScenarios()
If Not blnAdmitDateScenariosPreliminary Then
	Call WriteToLog("Fail","Unable to validate mandatory fields for admittance. "&strOutErrorDesc)
	Call Terminator	
End If
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Save admit functionality
blnSaveAdmittance = SaveFunctionality("Admit")
If Not blnSaveAdmittance Then
	Call WriteToLog("Fail","Hospital admittance is not saved. "&strOutErrorDesc)
	Call Terminator	
End If
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - All admittance fileds after admittance
Call AdmittanceFieldsStatusAfterAdmission()
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Hospitalization History Table entries after admittance
blnHistoryTableValidation = HistoryTableValidation()
If not blnHistoryTableValidation Then
	Call WriteToLog("Fail","Unable to validate Hospitalization History Table entries after admittance. "&strOutErrorDesc)
	Call Terminator	
End If
Wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Transer by providing TransferDate < 365 days to sys date, TransferDate > sys date, TransferDate < Admit date, Transfer date less than sys date but not less than admit date. Also validate 'Transfer Facility name' and 'Transfer Facility phone' fields
blnTranferScenariosPreliminary = TranferScenariosPreliminary()
If Not blnTranferScenariosPreliminary Then
	Call WriteToLog("Fail","Unable to validate Trafer scenarios. "&strOutErrorDesc)
	Call Terminator	
End If
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - All transfer fileds after transfer
Call TransferFieldsStatusAfterTransfer()
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Availability of all Discharge section fields and data entry into all fields
blnDischarge_AllFields = Discharge_AllFields()
If Not blnDischarge_AllFields Then
	Call WriteToLog("Fail","Unable to validate Discharge fields "&strOutErrorDesc)
	Call Terminator											
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Discharge without DischargeDate, DischargeDate > sys date, DischargeDate < 365 days to sys date, DischargeDate < AdmitDate, DischargeDate >= AdmitDate, but <= sys date
blnDischargeDateScenariosPreliminary = DischargeDateScenariosPreliminary()
If Not blnDischargeDateScenariosPreliminary Then
	Call WriteToLog("Fail","Unable to validate Discharge Date scenarios (preliminary). "&strOutErrorDesc)
	Call Terminator											
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Discharge without DischargeNotificationDate, DischargeNotificationDate > sys date, DischargeNotificationDate < AdmitDate, DischargeNotificationDate < DischargeDate, Discharge Notification date greater than Discharge date, but <= sys date
blnDischargeNotificationDateScenariosPreliminary = DischargeNotificationDateScenariosPreliminary()
If Not blnDischargeNotificationDateScenariosPreliminary Then
	Call WriteToLog("Fail","Unable to validate Discharge Notification Date scenarios (preliminary). "&strOutErrorDesc)
	Call Terminator											
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Discharge with DischargePlan date > sys date, Discharge Plan date less than Admit date,  Discharge Plan date equal to Discharge Notification date, but <= sys date 
blnDischargePlanDateScenariosPreliminary = DischargePlanDateScenariosPreliminary()
If Not blnDischargePlanDateScenariosPreliminary Then
	Call WriteToLog("Fail","Unable to validate Discharge Plan Date scenarios (preliminary). "&strOutErrorDesc)
	Call Terminator											
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Discharge by setting 'Disposition' to invalid value and clearing all 'Related Diagnoses' check boxes
blnOtherDischargeMandatoryScenarios = OtherDischargeMandatoryScenarios()
If Not blnOtherDischargeMandatoryScenarios Then
	Call WriteToLog("Fail","Unable to validate Discharge Plan Date scenarios (preliminary). "&strOutErrorDesc)
	Call Terminator											
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Save discharge functionality
blnSaveDischarge = SaveFunctionality("Discharge")
If Not blnSaveDischarge Then
	Call WriteToLog("Fail","Hospital Discharge is not saved. "&strOutErrorDesc)
	Call Terminator	
End If
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - All discharge fileds after discharge
Call DischargeFieldsStatusAfterDischarge()
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Hospitalization History Table entries after discharge
blnHistoryTableValidation = HistoryTableValidation()
If not blnHistoryTableValidation Then
	Call WriteToLog("Fail","Unable to validate Hospitalization History Table entries after admittance. "&strOutErrorDesc)
	Call Terminator	
End If
wait 0,250	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Length of stay after discharge
blnLengthofStayAfterDischarge = LengthofStayAfterDischarge()
If not blnLengthofStayAfterDischarge Then
	Call WriteToLog("Fail","Unable to validate Length of stay after discharge. "&strOutErrorDesc)
	Call Terminator	
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Save admittance with admit date less than discharge date, Save admittance with same Admit Date and Admit Type
blnAdmitDateScenariosWithType = AdmitDateScenariosWithType()
If not blnAdmitDateScenariosWithType Then
	Call WriteToLog("Fail","Unable to validate Admit date scenarios with discharge date and admit type "&strOutErrorDesc)
	Call Terminator											
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Save admittance with same Admit Date but with different Admit Type, 'NotifiedBy', 'Source of Admit', '(Readmit) Reason', 'Disposition' dropdown status, 'DischargeDateField' status,  'Patient Refused Plan', 'Medical Equipment' radio buttons status - during EDvist admittance, Save ED Visit' Admittance with 'HomeHealthName' and 'HomeHealthReason'
blnAdmittance_EDvisit = Admittance_EDvisit()
If not blnAdmittance_EDvisit Then
	Call WriteToLog("Fail","Unable to validate ED_Visit admittance and other scenarios "&strOutErrorDesc)
	Call Terminator											
End If
wait 0,250
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Save admittance by providing values for only mandatory fields, admitdate = sys date, admit notification date = sys date, admitnotificationdate = admitdate, Admit patient more than one time with same admit type (but admit date different)
dtAdmitDate = Date
dtNotificationDate = Date
strAdmitType = "Hospital Admit"
strNotifiedBy = "Dialysis Center"
strSourceOfAdmit = "Elective Admit"

blnAdmittance_MandatoryFields = Admittance_MandatoryFields(dtAdmitDate,dtNotificationDate,strAdmitType,strNotifiedBy,strSourceOfAdmit,strOutErrorDesc)
If not blnAdmittance_MandatoryFields Then
	Call WriteToLog("Fail","Unable to validate Admittance with mandatory fields and other scenarios. "&strOutErrorDesc)
	Call Terminator											
End If
wait 1
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Perform transform with sys date and admit date with only mandatory fields
dtTransferDate = Date
blnTransferPatient = TransferPatient(dtTransferDate)
If not blnTransferPatient Then	
	Call WriteToLog("Fail","Unable to do transfer with sys date. "&strOutErrorDesc)
	Call Terminator			
End If
Call WriteToLog("PASS","Done Transfer with sys date")
Wait 1
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validation - Dischage fields with sys date scenarios
blnDischarge_Final = Discharge_Final()
If not blnDischarge_Final Then
	Call WriteToLog("Fail","Unable to validate Dischage fields with sys date scenarios"&strOutErrorDesc)
	Call Terminator			
End If
wait 1
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'---------------------
'Logout of application
'---------------------
Call WriteToLog("Info","---------------Logout of application---------------")
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
