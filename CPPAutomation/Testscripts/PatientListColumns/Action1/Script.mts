 '**************************************************************************************************************************************************************************
' TestCase Name			: PatientListColumns
' Purpose of TC			: Validate Last Completed and Last Attempted columns in Patient list grid
' Author                : Gregory
' Date                  : 08 July 2015
' Date Modified			: 5 October 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04753
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PatientListColumns", strOutTestName, strOutErrorDesc) 
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
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
intLastAttemptedColumnNumber = DataTable.Value("LastAttemptedColumnNumber","CurrentTestCaseData") '12
intLastCompletedColumnNumber = DataTable.Value("LastCompletedColumnNumber","CurrentTestCaseData") '13
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

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage ="&Environment("WPG_AppParent")	'page object
Execute "Set objMyPatientsMajorTab ="&Environment("WL_MyPatientsMajorTab") 'MyPatients tab
Execute "Set objMyPatientsMainTab = "&Environment("WL_MyPatientsMainTab") 'My Patients tab
Execute "Set objCustomizeView = "&Environment("WB_CustomizeView") 'CustomizeView button
Execute "Set objCustomizeViewResetBtn = "&Environment("WB_CustomizeViewResetBtn") 'CustomizeView Reset button
Execute "Set objCustomizeViewOKBtn = "&Environment("WB_CustomizeViewOKBtn") 'CustomizeView OK Btn
Execute "Set objChangesSavedOKBtn = "&Environment("WB_ChangesSavedOKBtn") 'ChangesSaved OK Btn
Execute "Set objLADColHeader = "&Environment("WL_LADColHeader") ' Last Attempted Contact date header
Execute "Set objLCDColHeader = "&Environment("WL_LCDColHeader") ' Last Completed Contact date header
Execute "Set objPatientListGridTableRight = "&Environment("WT_PatientListGridTableRight") 'PatientList Grid TableRight side
Execute "Set objPatientSearchDD ="&Environment("WB_PatientSearchDD") 'PatientSearch dropdown
Execute "Set objPatientSearchTxtBx ="&Environment("WE_PatientSearchTxtBx") 'MyRoster patient search
Execute "Set objPatientSearchImage ="&Environment("WEL_PatientSearchImage") 'Patient search image
'Execute "Set objPatientSearchGridCB ="&Environment("WEL_PatientSearchGridCB") 'Patient List grid

'Getting equired iterations
If not Lcase(strExecutionFlag) = "y" Then Exit Do
Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"'----------------")

'Variable into usable format
arrContactMethod = Split(strContactMethods,",",-1,1)
arrRespectiveResolutionForContactMethod = Split(strRespectiveResolutionsForContactMethods,",",-1,1)
arrDateForContact = Split(strDatesForContacts,",",-1,1)
arrExternalTeamddval = Split(strExternalTeamddvals,",",-1,1)
arrInternalTeamddval = Split(strInternalTeamddvals,",",-1,1)
For Dtformat = 0 To Ubound(arrDateForContact) Step 1
	If LCase(Trim(arrDateForContact(Dtformat))) = "date" Then
		arrDateForContact(Dtformat) = Date		
	End If
	arrDateForContact(Dtformat) = DateFormat(arrDateForContact(Dtformat))
Next

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
Err.Clear

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

'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Call WriteToLog("Info","----------------Validating contact date columns in 'Patient List' grid----------------") 

'Click on MyPatients Tab
blnclickOnMainMenu = clickOnMainMenu("My Patients")
If not blnclickOnMainMenu Then
	Call WriteToLog("Fail","Unable to navigate to MyPatients screen. "&strOutErrorDesc)
	Call Terminator
End If
Wait 5

Call waitTillLoads("Loading...")
Wait 2

If not objCustomizeView.Exist(10) Then
	Call WriteToLog("Fail","Expected Result: Customize view button should be available.  Actual Result: Customize view buttonis NOT available")
	Call Terminator	
End If
Call WriteToLog("Pass","'Customize View' button is available")
Wait 5

'Clk on Customize view button
Err.Clear
objCustomizeView.Click
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: User should be able to click Customize view button.  Actual Result: Unable to click Customize view button. "&Err.Description)
	Call Terminator	
End If	
Call WriteToLog("Pass","Clicked 'Customize View' button")
Wait 2

'Clk on 'Reset' button in 'Customize View' popup
Err.Clear
objCustomizeViewResetBtn.Click
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: User should be able to click on 'Reset' button in 'Customize View' popup.  Actual Result: Unable to click 'Reset' button in 'Customize View' popup. "&Err.Description)
	Call Terminator
End If	
Call WriteToLog("Pass","Clicked 'Reset' button in 'Customize View' popup")
Wait 2

'Clk on 'OK' button in 'Customize View' popup
Err.Clear
objCustomizeViewOKBtn.Click
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: User should be able to click on 'OK' button in 'Customize View' popup.  Actual Result: Unable to click 'OK' button in 'Customize View' popup. "&Err.Description)
	Call Terminator
End If	
Call WriteToLog("Pass","Clicked 'OK' button in 'Customize View' popup")
Wait 2
Call waitTillLoads("Loading...")
Wait 3

strMessageTitle = "Changes Saved"
strMessageBoxText = "Changes saved successfully"
'Check the message box having text as "Your request was submitted."
blnReturnValue = checkForPopup(strMessageTitle, "Ok", strMessageBoxText, strOutErrorDesc)
If not blnReturnValue Then
	Call WriteToLog("Fail","Unable to close messsage box 'Changes Saved' ."&strOutErrorDesc)
	Call Terminator
End If
Wait 2
Call waitTillLoads("Loading...")
Wait 1

'Checking Last Attempted Contact in Patient List grid 
If objLADColHeader.Exist(10) Then
	Call WriteToLog("Pass","'Last Attempted Contact' column is existing in 'Patient List grid")
Else
	Call WriteToLog("Fail", "Expected Result: 'Last Attempted Contact' column should be existing in 'Patient List grid.  Actual Result: 'Last Attempted Contact' column is NOT existing in 'Patient List grid.")
	Call Terminator
End If

'Checking Last Completed Contact in Patient List grid 
If objLCDColHeader.Exist(5) Then
	Call WriteToLog("Pass","'Last Completed Contact' column is existing in 'Patient List grid")
Else
	Call WriteToLog("Fail","Expected Result: 'Last Completed Contact' column should be existing in 'Patient List grid.  Actual Result: 'Last Completed Contact' column is NOT existing in 'Patient List grid.")
	Call Terminator
End If
Wait 1

Call WriteToLog("Info","----------------Adding contact for required patient by selecting patient from MyPatient List----------------") 
'Select patient from MyPatient list
blnSelectPatientFromPatientList = SelectPatientFromPatientList(strUser, strPatientName)
If blnSelectPatientFromPatientList Then
	Call WriteToLog("Pass","Selected required patient from MyPatient list")
Else
	strOutErrorDesc = "Unable to select required patient"
	Call WriteToLog("Fail","Expected Result: Should be able to select required patient from MyPatient list.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Wait 2

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")
Wait 2

Call WriteToLog("Info","--------------Adding contact for selected patient--------------")
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
Wait 5

Call WriteToLog("Info","----------------Finalizing and closing record for required patient and navigating to Dashboard for mousehover---------------")
'Closing patient record
blnClosePatientRecord = ClosePatientRecord(strNote,strOutErrorDesc) 
If not blnClosePatientRecord Then
	Call WriteToLog("Fail","Expected Result: Should close patient record.  Actual Result: Failed to close patient record: "&strOutErrorDesc)
	Call Terminator
End If	
Call WriteToLog("Pass","Closed patient record")
Wait 2

Call waitTillLoads("Saving contact for "&strPatientName)
Wait 2

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
Call WriteToLog("Info","------Close patient record and re-open patient through global search------")
blnClosePatientAndReopenThroughGlobalSearch = ClosePatientAndReopenThroughGlobalSearch(strPatientName,lngMemberID,strOutErrorDesc)
If not blnClosePatientAndReopenThroughGlobalSearch Then
	Call WriteToLog("Fail","Unable to close patient record and re-open patient through global search. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Closed patient record and re-opened patient through global search")

Call WriteToLog("Info","----------------Navigating to My Patients screen, Validating Contact date columns of MyPatient list----------------") 
'-----------------------------------------
'Navigate to MyPatients > PatientList grid
'-----------------------------------------
'Click on MyPatients Tab
blnclickOnMainMenu = clickOnMainMenu("My Patients")
If not blnclickOnMainMenu Then
	Call WriteToLog("Fail","Unable to navigate to MyPatients screen. "&strOutErrorDesc)
	Call Terminator
End If
Wait 5

Call waitTillLoads("Loading...")
Wait 2

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

'Validation of dates
dtLADfromPatientGrid = Trim(objPatientListGridTableRight.ChildItem(1,intLastAttemptedColumnNumber,"WebElement",0).GetROProperty("outertext"))
dtLCDfromPatientGrid = Trim(objPatientListGridTableRight.ChildItem(1,intLastCompletedColumnNumber,"WebElement",0).GetROProperty("outertext"))

If Trim(dtLastAttemptedDate) = dtLADfromPatientGrid Then
	Call WriteToLog("Pass","'Last Attempted Contact' is displayed in MyPatients grid based on filters and is in required format")
Else
	Call WriteToLog("Fail","Expected Result: 'Last Attempted Contact' should be displayed in MyPatients grid based on filters and should be in required format.  Actual Result: Last Attempted Contact date is NOT displayed in MyPatients grid as expected")
	Call Terminator
End If

If Trim(dtLastCompletedDate) = dtLCDfromPatientGrid Then
	Call WriteToLog("Pass","'Last Completed Contact' is displayed in MyPatients grid based on filters and is in required format")
Else
	Call WriteToLog("Fail","Expected Result: 'Last Completed Contact' should be displayed in MyPatients grid based on filters and should be in required format.  Actual Result: Last Completed Contact date is NOT displayed in MyPatients grid as expected")
	Call Terminator	
End If

'Logout
Call WriteToLog("Info","----------------Logout of application----------------") 
Call Logout()
Wait 2

'Set objects free
Set objPage = Nothing
Set objMyPatientsMajorTab = Nothing
Set objMyPatientsMainTab = Nothing 
Set objCustomizeView = Nothing 
Set objCustomizeViewResetBtn = Nothing
Set objCustomizeViewOKBtn = Nothing 
Set objChangesSavedOKBtn = Nothing 
Set objLADColHeader = Nothing 
Set objLCDColHeader = Nothing
Set objPatientListGridTableRight = Nothing 

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
