 '**************************************************************************************************************************************************************************
' TestCase Name			: EligibilityReport
' Purpose of TC			: Validate Last Completed and Last Attempted dates with required business logic, Generate Eligibility Report and verify implementation of Last Completed and Attempted  dates
' Author                : Gregory
' Date                  : 22 May 2015
' Date Modified			: 6 October 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04755
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "EligibilityReport", strOutTestName, strOutErrorDesc) 
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
lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
strNote = DataTable.Value("Note","CurrentTestCaseData") 
strEngagementStartScore = DataTable.Value("EngagementStartScore","CurrentTestCaseData")
strEngagementEndScore = DataTable.Value("EngagementEndScore","CurrentTestCaseData") 
strContactMethods = DataTable.Value("ContactMethods","CurrentTestCaseData")
strRespectiveResolutionsForContactMethods = DataTable.Value("RespectiveResolutionsForContactMethods","CurrentTestCaseData") 
strDatesForContacts = DataTable.Value("DatesForContacts","CurrentTestCaseData") 
strExternalTeamddvals = DataTable.Value("ExternalTeamddvals","CurrentTestCaseData") 
strInternalTeamddvals = DataTable.Value("InternalTeamddvals","CurrentTestCaseData") 
dtExistingContactAttemptedDate = DataTable.Value("ExistingContactAttemptedDate","CurrentTestCaseData") 
dtExistingContactCompletedDate = DataTable.Value("ExistingContactCompletedDate","CurrentTestCaseData") 
strCacheClear = DataTable.Value("CacheClear","CurrentTestCaseData") 

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objParent ="&Environment("WPG_AppParent")	'Page object
Execute "Set objMyPatientsMajorTab ="&Environment("WL_MyPatientsMajorTab") 'MyPatients tab
Execute "Set objPatientSearchDD ="&Environment("WB_PatientSearchDD") 'PatientSearch dropdown
Execute "Set objPatientSearchTxtBx ="&Environment("WE_PatientSearchTxtBx") 'MyRoster patient search
Execute "Set objPatientSearchImage ="&Environment("WEL_PatientSearchImage") 'Patient search image
Execute "Set objPatientSearchGridCB ="&Environment("WEL_PatientSearchGridCB") 'Patient List grid
Execute "Set objReport ="&Environment("WB_Report") 'Report button
Execute "Set objReportSelcPatients ="&Environment("WEL_ReportSelcPatients") 'Selected patient button
Execute "Set objReportsortDD ="&Environment("WB_ReportsortDD") 'SortReport dropdown
Execute "Set objReportOK ="&Environment("WB_ReportOK") 'Sort OK btn
Execute "Set objPatientEligibilityReportpp ="&Environment("WEL_PatientEligibilityReportpp") 'PatientEligibility Report popup
Execute "Set objCloseReport ="&Environment("WI_CloseReport") 'Eligibility report close image

'Getting equired iterations
On Error Resume Next
If not Lcase(strExecutionFlag) = "y" Then Exit Do
Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"'----------------") 

'Variables in usable format
arrContactMethod = Split(strContactMethods,",",-1,1)
arrRespectiveResolutionForContactMethod = Split(strRespectiveResolutionsForContactMethods,",",-1,1)
arrDateForContact = Split(strDatesForContacts,",",-1,1)
arrExternalTeamddval = Split(strExternalTeamddvals,",",-1,1)
arrInternalTeamddval = Split(strInternalTeamddvals,",",-1,1)
For Dtformat = 0 To Ubound(arrDateForContact) Step 1
	arrDateForContact(Dtformat) = DateFormat(arrDateForContact(Dtformat))
Next

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------

'Login
Call WriteToLog("Info","----------Login to application, Close all open patients, Select user roster----------")

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
Wait 3

Call waitTillLoads("Loading...")
Wait 2

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")

Call WriteToLog("Info","------------Adding contact for selected patient------------")
CMdetails = 0
For CMdetails = 0 To ubound(arrContactMethod) Step 1
	strContactMethod = arrContactMethod(CMdetails)
	dtContactDt = arrDateForContact(CMdetails)
	strEngScores = strEngagementStartScore&","&strEngagementEndScore
	strReqdTeams = arrExternalTeamddval(CMdetails)&","&arrInternalTeamddval(CMdetails)
	strReqdResolution = arrRespectiveResolutionForContactMethod(CMdetails)	
		
	blnAddNewContactMethod = AddContactMethod(strContactMethod, dtContactDt, strEngScores, strReqdTeams, strReqdResolution, strOutErrorDesc)
	If not blnAddNewContactMethod Then
		Call WriteToLog("Fail","Expected Result: Should add new contact with required values; Actual Result: Failed to add contact :"&strOutErrorDesc)
		Call Terminator
	Else
		Call WriteToLog("Pass","Added contact with required values")
	End If
Next
Wait 3

Call WriteToLog("Info","----------Finalizing and closing record for required patient and navigating to Dashboard----------")
'Closing patient record
blnClosePatientRecord = ClosePatientRecord(strNote,strOutErrorDesc) 
If not blnClosePatientRecord Then
	Call WriteToLog("Fail","Expected Result: Should close patient record.  Actual Result: Failed to close patient record: "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Closed patient record")
End If
Wait 2
Call waitTillLoads("Loading...")
Wait 1

'FILTERING --------------------------------------------------------------------
strContactMethods = DataTable.Value("ContactMethods","CurrentTestCaseData")
strRespectiveResolutionsForContactMethods = DataTable.Value("RespectiveResolutionsForContactMethods","CurrentTestCaseData") 
strDatesForContacts = DataTable.Value("DatesForContacts","CurrentTestCaseData") 
strExternalTeamddvals = DataTable.Value("ExternalTeamddvals","CurrentTestCaseData") 
strInternalTeamddvals = DataTable.Value("InternalTeamddvals","CurrentTestCaseData") 
dtExistingContactAttemptedDate = DataTable.Value("ExistingContactAttemptedDate","CurrentTestCaseData") 
dtExistingContactCompletedDate = DataTable.Value("ExistingContactCompletedDate","CurrentTestCaseData") 
arrContactMethod = Split(strContactMethods,",",-1,1)
arrRespectiveResolutionForContactMethod = Split(strRespectiveResolutionsForContactMethods,",",-1,1)
arrExternalTeamddval = Split(strExternalTeamddvals,",",-1,1)
arrInternalTeamddval = Split(strInternalTeamddvals,",",-1,1)
For Dtformat = 0 To Ubound(arrDateForContact) Step 1
	arrDateForContact(Dtformat) = DateFormat(arrDateForContact(Dtformat))
Next

'Array of required filters 
'FOT COMPLETED 
ReDim ReqdContactFormatForCompletedContact(11)
		ReqdContactFormatForCompletedContact(0) = "PhoneRegistered NursePatient"
		ReqdContactFormatForCompletedContact(1) = "PhoneNurse PractitionerPatient"
		ReqdContactFormatForCompletedContact(2) = "PhoneLicensed Practical NursePatient"
		ReqdContactFormatForCompletedContact(3) = "PhoneRegistered NurseCaregiver or Family"
		ReqdContactFormatForCompletedContact(4) = "PhoneNurse PractitionerCaregiver or Family"
		ReqdContactFormatForCompletedContact(5) = "PhoneLicensed Practical NurseCaregiver or Family"
		ReqdContactFormatForCompletedContact(6) = "In PersonRegistered NursePatient"
		ReqdContactFormatForCompletedContact(7) = "In PersonNurse PractitionerPatient"
		ReqdContactFormatForCompletedContact(8) = "In PersonLicensed Practical NursePatient"
		ReqdContactFormatForCompletedContact(9) = "In PersonRegistered NurseCaregiver or Family"
		ReqdContactFormatForCompletedContact(10) = "In PersonNurse PractitionerCaregiver or Family"
		ReqdContactFormatForCompletedContact(11) = "In PersonLicensed Practical NurseCaregiver or Family"
		
'FOR ATTEMPTED OR INCOMPLETE / MESSAGE		
ReDim ReqdContactFormatForAttemptedContact(17)		
		ReqdContactFormatForAttemptedContact(0) = "PhoneRegistered NursePatient"
		ReqdContactFormatForAttemptedContact(1) = "PhoneNurse PractitionerPatient"
		ReqdContactFormatForAttemptedContact(2) = "PhoneLicensed Practical NursePatient"
		ReqdContactFormatForAttemptedContact(3) = "PhoneRegistered NurseCaregiver or Family"
		ReqdContactFormatForAttemptedContact(4) = "PhoneNurse PractitionerCaregiver or Family"
		ReqdContactFormatForAttemptedContact(5) = "PhoneLicensed Practical NurseCaregiver or Family"
		ReqdContactFormatForAttemptedContact(6) = "PhoneRegistered NurseCaregiver or Family"
		ReqdContactFormatForAttemptedContact(7) = "PhoneNurse PractitionerCaregiver or Family"
		ReqdContactFormatForAttemptedContact(8) = "PhoneLicensed Practical NurseCaregiver or Family"
		ReqdContactFormatForAttemptedContact(9) = "In PersonRegistered NursePatient"
		ReqdContactFormatForAttemptedContact(10) = "In PersonNurse PractitionerPatient"
		ReqdContactFormatForAttemptedContact(11) = "In PersonLicensed Practical NursePatient"
		ReqdContactFormatForAttemptedContact(12) = "In PersonRegistered NurseCaregiver or Family"
		ReqdContactFormatForAttemptedContact(13) = "In PersonNurse PractitionerCaregiver or Family"
		ReqdContactFormatForAttemptedContact(14) = "In PersonLicensed Practical NurseCaregiver or Family"
		ReqdContactFormatForAttemptedContact(15) = "In PersonRegistered NurseCaregiver or Family"
		ReqdContactFormatForAttemptedContact(16) = "In PersonNurse PractitionerCaregiver or Family"
		ReqdContactFormatForAttemptedContact(17) = "In PersonLicensed Practical NurseCaregiver or Family"	


dtLastAttemptedDate = ""
dtLastCompletedDate = ""

For Resln = 0 To Ubound(arrContactMethod) Step 1
	If arrRespectiveResolutionForContactMethod(Resln) =  "Completed" Then
		strReqdContactFormatForCompletedContact = arrContactMethod(Resln)&arrInternalTeamddval(Resln)&arrExternalTeamddval(Resln) 'Filter
		For ReqFilt = 0 To Ubound(ReqdContactFormatForCompletedContact) Step 1
			If strReqdContactFormatForCompletedContact = ReqdContactFormatForCompletedContact(ReqFilt) Then
				dtLastCompletedDate = arrDateForContact(Resln)
			End If
		Next
	End If
Next
	
	Resln = 0 
	
For Resln = 0 To Ubound(arrContactMethod) Step 1	
	If arrRespectiveResolutionForContactMethod(Resln) =  "Attempted or Incomplete" OR arrRespectiveResolutionForContactMethod(Resln) =  "Message" Then
		strReqdContactFormatForAttemptedContact = arrContactMethod(Resln)&arrInternalTeamddval(Resln)&arrExternalTeamddval(Resln)
		For ReqFilt = 0 To Ubound(ReqdContactFormatForAttemptedContact) Step 1
			If strReqdContactFormatForAttemptedContact = ReqdContactFormatForAttemptedContact(ReqFilt) Then
				dtLastAttemptedDate = arrDateForContact(Resln)
			End If
		Next
	End If
Next

'check for previous entries and get latest contact dates for completed and attempted
If dtExistingContactCompletedDate <>"" Then
	dtExistingContactCompletedDate = DateFormat(dtExistingContactCompletedDate)
End If
If dtExistingContactAttemptedDate <>"" Then
	dtExistingContactAttemptedDate = DateFormat(dtExistingContactAttemptedDate)
End If

intLADval = DateDiff("d",dtLastAttemptedDate,dtExistingContactAttemptedDate)
If intLADval >= 0 Then
	dtLastAttemptedDate = dtExistingContactAttemptedDate
End If

intLCDval = DateDiff("d",dtLastCompletedDate,dtExistingContactCompletedDate)
If intLCDval >= 0 Then
	dtLastCompletedDate = dtExistingContactCompletedDate
End If

'Close patient record and re-open patient through global search (to get changes reflected)
blnClosePatientAndReopenThroughGlobalSearch = ClosePatientAndReopenThroughGlobalSearch(strPatientName,lngMemberID,strOutErrorDesc)
If not blnClosePatientAndReopenThroughGlobalSearch Then
	Call WriteToLog("Fail","Unable to close patient record and re-open patient through global search. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Closed patient record and re-opened patient through global search")

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("Info","------Navigating to My Patients screen, searching for required patient, Generate Patient Eligibility Report by selecting required report type------") 
'-----------------------------------------
'Navigate to MyPatients > PatientList grid
'-----------------------------------------
'---------------------------------------------------------------------------
'Search with patient name and select required patient from Patient list grid
'---------------------------------------------------------------------------
Err.Clear
'Click on MyPatients Tab
blnclickOnMainMenu = clickOnMainMenu("My Patients")
If not blnclickOnMainMenu Then
	Call WriteToLog("Fail","Unable to navigate to MyPatients screen. "&strOutErrorDesc)
	Call Terminator
End If
Wait 5
Call waitTillLoads("Loading...")
Wait 1

'clk on all patients button
Execute "Set objAllMyPatients ="&Environment("WB_AllMyPatients")
blnAllMyPatientsClicked = ClickButton("All My Patients",objAllMyPatients,strOutErrorDesc)
If not blnAllMyPatientsClicked Then
	Call WriteToLog("Fail","Expected Result: Should be able to click AllMyPatients button. Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked 'All My Patients' button")
Wait 2
Call waitTillLoads("Loading...")
wait 1
Execute "Set objAllMyPatients = Nothing"

'select name from patient search dropdown
blnselectComboBoxItem = selectComboBoxItem(objPatientSearchDD, "Name")
If Not blnselectComboBoxItem Then
	strOutErrorDesc = "Unable to select required value from patient search dropdown: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If

'Set required patient name for SearchMyRoster txtbox
Err.Clear
objPatientSearchTxtBx.Set strPatientName
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set required name for SearchMyRoster txtbox: "& Err.Description
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If
Wait 1

'Clk on Patient Search Image
Err.Clear
objPatientSearchImage.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click Patient Search Image: "& Err.Description
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If
wait 2

'Click check box for required patient	
Execute "Set objCBforPatient_UnChecked = "&Environment("WE_CBforPatient_UnChecked")	
Err.Clear
objCBforPatient_UnChecked.Click
Err.Clear
If Err.Number <> 0 Then
	strOutErrorDesc = "Unable to click Patient check box: "& Err.Description
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If

'Sometimes after clicking also checkbox won't get checked (and no error is captured).
'So first check 'checked' check box is existing or not. If not existing, then check the check box again.
Execute "Set objCBforPatient_Checked = "&Environment("WE_CBforPatient_Checked")
If not objCBforPatient_Checked.Exist(2) Then
	Execute "Set objCBforPatient_UnChecked = Nothing"
	Execute "Set objCBforPatient_UnChecked = "&Environment("WE_CBforPatient_UnChecked")
	Err.Clear
	objCBforPatient_UnChecked.Click		
End If
If Err.Number <> 0 Then
	strOutErrorDesc = "Unable to click Patient check box: "& Err.Description
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass", "Clicked check box for patient in patient list")
Execute "Set objCBforPatient_UnChecked = Nothing"
Execute "Set objCBforPatient_Checked = Nothing"
Wait 1

'---------------------------------------------------------------------
'Generate Patient Eligibility Report by selecting required report type
'---------------------------------------------------------------------
'Clk on PrintIcon for choosing required Report
Err.Clear
objReport.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click PrintIcon for choosing required Report: "& Err.Description
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If 
Call WriteToLog("Pass","Clicked PrintIcon for choosing required Report")
Wait 2

'Choosing required Report from ChooseReports popup
Err.Clear
objReportSelcPatients.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click required Report in ChooseReports popup: "& Err.Description
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Selected required Report from ChooseReports popup")
wait 1

'Select Sort order as "Name" from SortOrder dropdown
blnSortOrder = selectComboBoxItem(objReportsortDD, "Name")
If not blnSortOrder Then
	strOutErrorDesc = "Unable to select required sort order from SortOrder dropdown"
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Selected required sort order from SortOrder dropdown")
wait 1

'Clk OK btn of Choose Reports popup
Err.Clear
objReportOK.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click ChooseReports OK btn: "& Err.Description
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked ChooseReports OK btn")

Wait 100
Call WriteToLog("Info","--------Validate implementation of Last completed and Last attempted or incomplete / message in Eligibility Report--------") 

'----------------------------------------------------------------------------------------------------------
'Validate implementation of Last completed and Last attempted or incomplete / message in Eligibility Report
'----------------------------------------------------------------------------------------------------------
'Getting date format for report
dtLastAttemptedDate = DateFormatForReport(dtLastAttemptedDate)
dtLastCompletedDate = DateFormatForReport(dtLastCompletedDate)
strLCDLAD ="Last Completed Contact : "&Trim(dtLastCompletedDate)&" Last A����empted Contact : "&Trim(dtLastAttemptedDate)

'Object for PDF report
Set objReportPDF = objParent.WinObject("object class:=AVL_AVView","regexpwndclass:=AVL_AVView","text:=AVPageView","visible:=True")

'Right click on PDF reprt, select 'find' (i.e 6th choice in right click menu) 
Err.Clear
objReportPDF.Click ,, micRightBtn
If Err.Number <> 0 Then
	Call WriteToLog("Fail", "Eligibility Report is showning blank page")
	Call Terminator
End If
Wait 1

'Selecting required Choice
Set WshShell = CreateObject("WScript.Shell")
ChoiceNumber=6    
For i = 1 To ChoiceNumber
	WshShell.sendkeys "{DOWN}" 
Next
Wait 1

WshShell.sendkeys "{ENTER}"
Set WshSEll = nothing
Wait 1

'Object for 'Search Box' in PDF report
Set objPDFSearchBox = objParent.WinEdit("nativeclass:=Edit","object class:=Edit","regexpwndclass:=Edit","visible:=True")

'Set obtained value of contact dates in required format to search in PDF report 
Err.Clear
objPDFSearchBox.Set strLCDLAD
WshShell.sendkeys "{ENTER}"
Wait 1

'Create object for Info popup (this popup is available only when report is not displaying contact dates in as required)
Set objInfoFromPDF = Browser("creationtime:=1").Dialog("regexpwndtitle:=Adobe Reader","text:=Adobe Reader","visible:=True").Static("regexpwndtitle:=Reader has finished searching the document\. No matches were found\.","text:=Reader has finished searching the document\. No matches were found\.")
If objInfoFromPDF.Exist(1) Then
	strOutErrorDesc = "Contact dates are not displayed as required"
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Contact dates are displayed in Eligibility Report and are in required format")

'Close Patient Eligibility Report
Err.Clear
objCloseReport.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to close Patient Eligibility Report : "& Err.Description
	Call WriteToLog("Fail", strOutErrorDesc)
	Call Terminator
End If 
Call WriteToLog("Pass","Closed Patient Eligibility Report ")
Wait 2

'---------------------
'Logout of application
'---------------------
Call WriteToLog("Info","------------Login to application------------")
Call Logout()
wait 2

'Set objects free
Set objParent = Nothing	
Set objPatientSnapshotTab = Nothing
Set objAutorizationppOKbtn = Nothing
Set objContactImg = Nothing
Set objDateRange = Nothing
Set objLastYear = Nothing
Set objContactMethodDDbtn = Nothing
Set objContactMethodInPerson = Nothing
Set objContactMethodPhone = Nothing
Set objMyPatientsMajorTab = Nothing
Set objMyPatientsMainTab = Nothing
Set objPatientListScrollbar = Nothing
Set objMyDashboard = Nothing
Set objPatientListGridFP = Nothing
Set objPatientListGridSP = Nothing

'Iteration loop
Loop While False: Next

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

'Get Required Date format for Eligibility Report
Function DateFormatForReport (ByVal dtDateInReport)
	If Instr(1,dtDateInReport,"/0",1) Then
		dtDateInReport = Replace(dtDateInReport,"/0","/",1,-1,1)
	End If
	If Left(dtDateInReport,1) = "0" Then
		dtDateInReport = Replace(dtDateInReport,Left(dtDateInReport,1),"",1,1,1)
	End If
	DateFormatForReport = dtDateInReport
End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction

End Function
