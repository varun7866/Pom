'**************************************************************************************************************************************************************************
' TestCase Name			: PTC_AddNewPatient Screen
' Purpose of TC			: To verify add a new patient from PTC Dashboard (Based on the story B-04850)
' Author                : Sudheer/Sharmila
' Comments				: Script will be modified as per user story change B-04850
'**************************************************************************************************************************************************************************

'***********************************************************************************************************************************************************************
'Initialization steps for current script
''***********************************************************************************************************************************************************************
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file
'Environment.LoadFromFile "C:\Project_Management\2.Automation\workflow_automation\Configuration\DaVita-Capella_Configuration.xml",True 
'MsgBox Environment.ExternalFileName
'load all functional libraries
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PTCAddNewPatient", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

''***********************************************************************************************************************************************************************
'End of Initialization steps for the current script
''***********************************************************************************************************************************************************************

''=========================
'' Variable initialization
''=========================
'strPatientFirstName = "Test"
'strPatientLastName =  "Testing3640"
'strPatientDOB = "04/07/1964"
Randomize	'Initialize random-number generator.
dtmStartDate = DateValue("01/01/1960")
dtmEndDate = DateValue("12/31/1987")
dtmRandomDate = DateValue((dtmEndDate - dtmStartDate + 1) * Rnd + dtmStartDate)
strPatientFirstName = "Test"
strPatientLastName =  "Testing" & RandomNumber(1,9999)
strPatientDOB = dtmRandomDate
strAddressTabName = DataTable.Value("AddressTabName","CurrentTestCaseData")  						'Fetch Address history tabs names form test data sheet
strDemogrphicDetailsLabelName = DataTable.Value("DemogrphicDetailsLabelName","CurrentTestCaseData") 'Fetch Demographic details tag name from test data
strAddressLabelName = DataTable.Value("AddressLabelName","CurrentTestCaseData")
strAddressLabelNameForTemporaryAddress = DataTable.Value("AddressLabelNameForTemporaryAddress","CurrentTestCaseData")
strDemogrphicDetailsFieldName = DataTable.Value("DemogrphicDetailsFieldName","CurrentTestCaseData")
strAddressField = DataTable.Value("Address","CurrentTestCaseData")
strAptORSuitField = DataTable.Value("AptORSuit","CurrentTestCaseData")
strAddressValue = DataTable.Value("AddressValue","CurrentTestCaseData")
strAptORSuitValue = DataTable.Value("AptORSuitValue","CurrentTestCaseData")
strPopupTitle = DataTable.Value("PopupTitle","CurrentTestCaseData")
strPopupText = DataTable.Value("SavePopupText","CurrentTestCaseData")

''=====================================
'' Objects required for test execution
''====================================

Function loadObjects()
	Execute "Set objPage = " & Environment("WPG_AppParent")
	Execute "Set objAddNewPatientButton = " & Environment("WB_AddNewPatient_Button")
	Execute "Set objPatientInfoScreenTitle = " & Environment("WEL_PatientInfo_Title")
	Execute "Set objPatientFirstName = " & Environment("WE_PatientInfo_FirstName")
	Execute "Set objPatientLastName = " & Environment("WE_PatientInfo_LastName")
	Execute "Set objPatientDOB = " & Environment("WE_PatientInfo_DOB")
	Execute "Set objAddNewPatient = " & Environment("WB_AddNewPatient_Button")	
	Execute "Set objPatientInfoTitle = " & Environment("WEL_PatientInfo_Title")
	Execute "Set objPatientInfoFirstName = " & Environment("WE_PatientInfo_FirstName")
	Execute "Set objPatientInfoLastName = " & Environment("WE_PatientInfo_LastName")
	Execute "Set objPatientInfoDOB = " & Environment("WE_PatientInfo_DOB")
End Function
'=====================================
' start test execution
'=====================================
Set objFso = CreateObject("Scripting.FileSystemObject")
rxLibFolder = Environment.Value("PROJECT_FOLDER") & "\Library\Rx_functions"
For each objFile in objFso.GetFolder(rxLibFolder).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" Then
		LoadFunctionLibrary objFile.Path
	End If
Next
Set objFso = Nothing

'Login to Capella
Call WriteToLog("Info","==========Testcase - Login to Capella as PTC User.==========")

isPass = Login("PTC")
If not isPass Then
	Call WriteToLog("Fail","Expected Result: Successfully login to capella; Actual Result: Failed to Login to Capella as PTC User.")
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into Capella as PTC User")

'Close all open patient     
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", "Expected Result: Close all the open patients; Actual Result: "&strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'Select user roster
isPass = SelectUserRoster(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", "Expected Result: Verify the roster is PTC; Actual Result: "&strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

loadObjects
'===============================================================
'Verify that Add New Patient Button exists on the PTC Dashboard.
'===============================================================
Call WriteToLog("Info","==========Testcase - Verify that Add New Patient Button exists on the PTC Dashboard.==========")

'Verify AddNewPatient Button exists
If waitUntilExist(objAddNewPatientButton, 10) Then
	Call WriteToLog("Pass", "AddNewPatient button exists")	
Else
	Call WriteToLog("Fail","Expected Result: AddNewPatient button exist; Actual Result: AddNewPatient button does not exist")
	Call WriteLogFooter()
	Exitaction	
End If

'Click on the Ok button of Complete Order pop up
blnReturnValue = ClickButton("Add New Patient",objAddNewPatientButton,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Click on the AddNewPatient button; Actual Result: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If
wait 2
Call waitTillLoads("Loading...")
wait 2

Call WriteToLog("Pass", "AddNewPatient button was clicked successfully")	

'====================================================
'Verify that Patient Info screen open successfully
'=====================================================
Call WriteToLog("Info","==========Testcase - Verify that Patient Info screen open successfully. ==========")

If waitUntilExist(objPatientInfoScreenTitle, 10) Then
	objPatientInfoScreenTitle.highlight
	Call WriteToLog("Pass","Patient Info Screen opened successfully")
Else
	Call WriteToLog("Fail","Expected Result: Open Patient Info Screen; Actual Result: Unable to open Patient Info Screen")
	Call WriteLogFooter()
	ExitAction
End If

'==================================================================
'Search for the patient with FirstName, LastName and DateOfBirth
'==================================================================
Call WriteToLog("Info","==========Testcase - Search for the patient with FirstName, LastName and DateOfBirth. ==========")

'Set value for FirstName
If waitUntilExist(objPatientFirstName, 10) Then
	objPatientFirstName.set strPatientFirstName
End If

'Set value for LastName
If waitUntilExist(objPatientLastName, 10) Then
	objPatientLastName.set strPatientLastName
End If

'Set value for DOB
If waitUntilExist(objPatientDOB, 10) Then
	objPatientDOB.set strPatientDOB
End If


wait 2
Call waitTillLoads("Loading...")
wait 2

blnReturnValue = AddNewPatient(strOutErrorDesc)

If blnReturnValue Then
	Call WriteToLog("Pass", "Member was added successfully")
Else
	Call WriteToLog("Fail", "Expected Result: Member was added successfully; Actual Result: Error adding Member " &strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction 
End If

killAllObjects

wait 2
Call waitTillLoads("Loading...")
wait 2

Set objPage = getPageObject()
objPage.highlight
Set objStatus = objPage.WebElement("class:=col-md-7.*", "outerhtml:=.*CurrentEligibilityStatus.*")
objStatus.highlight

status = objStatus.getROProperty("outertext")
Print status
Set objStatus = Nothing
Set objPage = Nothing


If lcase(trim(status)) <> "enrolled" Then
	Call WriteToLog("Fail", "Patient status is not Enrolled as expected. Status is " & status)
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

Call WriteToLog("info", "Test case - Verify created patient details using PTC role")
isPass = validateCreatedPatient(strPatientFirstName, strPatientLastName, strPatientDOB)
If not isPass Then
	Call WriteToLog("Fail", "Failed to validate Patient information.")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If
Call WriteToLog("Pass", "Successfully validated demographics of the patient")

Call WriteToLog("info", "Test case - Login as PTC and terminate the patient by closing the program.")
isPass = terminateProgram(strPatientFirstName, strPatientLastName, strPatientDOB)
If not isPass Then
	Call WriteToLog("Fail", "Failed to terminate the patient.")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If
Call WriteToLog("Pass", "Patient termed successfully.")

Execute "Set objMemberId = " & Environment("WEL_MemberID")
Dim strMemberId
If objMemberId.Exist(intWait) Then
	strMemberId = objMemberId.getRoProperty("innertext")
	Call WriteToLog("Pass","Patient is enrolled succesfully with Member Id - '" & strMemberId & "'")
Else	
	Call WriteToLog("Fail","Member Id does not exist.")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

'modify the mrp_term_notification_date in MRP_MEM_REFERRAL_PERIOD table
isPass = ConnectDB()
If Not isPass Then
	Call WriteToLog("Fail", "Connect to Database failed.")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

notificationDate = date - 2


Print ExpiryDate
sqlQuery = "UPDATE MRP_MEM_REFERRAL_PERIOD SET mrp_term_notification_date = to_date('" & notificationDate &"', 'mm/dd/yyyy') WHERE mrp_mem_uid = (SELECT MEM_UID FROM MEM_MEMBER WHERE MEM_ID = '" & strMemberId & "')"
isPass = RunQueryRetrieveRecordSet(sqlQuery)
If isPass Then
	isPass = RunQueryRetrieveRecordSet("Commit")
End If

If not isPass Then
	Call WriteToLog("Fail", "Error while running the update query.")
	Call CloseDBConnection()
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

Call CloseDBConnection()

Logout
CloseAllBrowsers

're-open termed patient
Call WriteToLog("info", "test case - reopen termed patient")
isPass = reopenTermedPatient(strPatientFirstName, strPatientLastName, strPatientDOB, strOutErrorDesc)
If not isPass Then
	Call WriteToLog("Error in re-opening the patient.")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

Call WriteToLog("info", "Validate Re-open Patient manually. Since we cannot validate through automation")
Logout
CloseAllBrowsers
WriteLogFooter


Function killAllObjects()

	Execute "Set objPage = Nothing"
	Execute "Set objAddNewPatientButton = Nothing"
	Execute "Set objPatientInfoScreenTitle = Nothing"
	Execute "Set objPatientFirstName = Nothing"
	Execute "Set objPatientLastName = Nothing"
	Execute "Set objPatientDOB = Nothing"
	Execute "Set objReferralManagementTitle = Nothing"
	Execute "Set objReferralDate = Nothing"
	Execute "Set objReferralReceivedDate = Nothing"
	Execute "Set objApplicationDate = Nothing"
	Execute "Set objPayor = Nothing"
	Execute "Set objSaveBtn = Nothing"
	Execute "Set objDiseaseState = Nothing"
	Execute "Set objLOB = Nothing"
	Execute "Set objServiceType = Nothing"
	Execute "Set objSource = Nothing"
	Execute "Set objReferrerName = Nothing" 
	Execute "Set objReferrerPhone = Nothing" 
	Execute "Set objReferrerExt = Nothing" 
	
End Function
