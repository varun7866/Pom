' TestCase Name			: Consents_workflow
' Purpose of TC			: To verify all the functionality of the Matrial Fulfillment screen, Including placing order for Medicla Authorization Form.
' Author                : Sudheer
' Comments				: Script will be modified as per user story change.
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Consents_workflow", strOutTestName, strOutErrorDesc) 
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

'=========================
' Variable initialization
'=========================
'strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strFilePath = Environment.Value("PROJECT_FOLDER")&"\Testdata\ManageDocuments"
strFileName = DataTable.Value("FileName","CurrentTestCaseData")
strBrowseFileNameWithLocation = strFilePath&"\"&strFileName
strFileDescription = DataTable.Value("FileDescription","CurrentTestCaseData")
strDocumentType = DataTable.Value("DocumentType","CurrentTestCaseData")
strFileUploadedPopupTitle = DataTable.Value("FileUpLoadedPopupTitle","CurrentTestCaseData")
strFileUploadedPopupText = DataTable.Value("FileUpLoadedPopupText","CurrentTestCaseData")
strSignatureDate = date()			'DataTable.Value("SignatureDate", "CurrentTestCaseData")
Dim intWaitTime
intWaitTime = getConfigFileValue("WaitTime")

'=====================================
' Objects required for test execution
'=====================================
loadObjects

Function loadObjects()
	Execute "Set objManageDocumentScreenTitle = "  & Environment("WT_ManageDocument_ScreenTitle")
	Execute "Set objManageDocumentGrid = "  & Environment("WT_ManageDocument_Grid")
	Execute "Set objUploadButton = "  & Environment("WB_ManageDocument_UploadButton")
	Execute "Set objDeleteButton = "  & Environment("WB_ManageDocument_DeleteButton")
	Execute "Set objFileSelectionPopup = "  & Environment("WEL_ManageDocument_FileSelection_PopupTitle")
	Execute "Set objFileSelectionFileNameField = "  & Environment("WE_ManageDocument_FileSelection_FileName")
	Execute "Set objFileSelectionSelectFile = "  & Environment("WEL_ManageDocument_FileSelection_SelectFile")
	Execute "Set objFileSelectionFileDescriptionField = "  & Environment("WE_ManageDocument_FileSelection_FileDescription")
	Execute "Set objFileSelectionDocumentTypeDropdown = "  & Environment("WB_ManageDocument_FileSelection_DocumentType")
	Execute "Set objFileNameField = "  & Environment("WiE_ChooseFileToUpload_Dialog_FileNameField")
	Execute "Set objOpenButton = "  & Environment("WiB_ChooseFileToUpload_Dialog_OpenButton")
	Execute "Set objOKButton= "  & Environment("WB_OK")
End Function

Set objFso = CreateObject("Scripting.FileSystemObject")
consentsLibFolder = Environment.Value("PROJECT_FOLDER") & "\Library\consents_functions"
For each objFile in objFso.GetFolder(consentsLibFolder).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" Then
		LoadFunctionLibrary objFile.Path
	End If
Next
Set objFso = Nothing
'=====================================
' start test execution
'=====================================
Call WriteToLog("info", "Test case - Create a new patient using EPS role")
'Login to Capella as EPS
isPass = Login("eps")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to EPS role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

'close all open patients
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into EPS role")

Call clickOnMainMenu("My Dashboard")
wait 2
Call waitTillLoads("Loading...")

strMember = createNewPatient()

If trim(strMember) = "" or trim(strMember) = "NA" Then
	Call WriteToLog("Fail", "There was an error retrieving member id.")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If
'Call WriteToLog("Pass", "A new patient has been created with member Id - '" & strMember & "'")

Logout
CloseAllBrowsers

Call WriteToLog("info", "Test case - Do Enrollment Screening, so the eligibility status changes to 'Enrolled'")
strEnrollmentStatus = DataTable.Value("ExpectedEPSStatus", "CurrentTestCaseData")
If strEnrollmentStatus = "Enrolled" Then
	Call WriteToLog("info", "VHES enrollment screening is skipped because the patient is already enrolled.")
Else
	'Login to Capella as VHES
	isPass = Login("vhes")
	If not isPass Then
		Call WriteToLog("Fail","Failed to Login to VHES role.")
		CloseAllBrowsers
		killAllObjects
		Call WriteLogFooter()
		ExitAction
	End If
	
	Call WriteToLog("Pass","Successfully logged into VHES role")
	isPass = CloseAllOpenPatient(strOutErrorDesc)
	If Not isPass Then
		strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
		Call WriteToLog("Fail", strOutErrorDesc)
		Call WriteLogFooter()
		ExitAction
	End If
	
	'Search for the patient
	selectPatientFromGlobalSearch strMember
	wait 2
	Call waitTillLoads("Loading...")
	
	'Do enrollment screening for the patient
	Call clickOnSubMenu("Screenings->Enrollment Screening")
	
	wait 2
	Call waitTillLoads("Loading...")
	isPass = enrollmentScreening()
	If not isPass Then
		Logout
		CloseAllBrowsers
		killAllObjects
		WriteLogFooter
	End If
	
	Logout
	CloseAllBrowsers
	Call WriteToLog("info", "VHES Enrollment Screening is completed.")
End If

Call WriteToLog("info", "Test case - Login as VHN and complete consents workflow")

'Login to Capella
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'==============================
'Open patient from action item
'==============================
isPass = selectPatientFromGlobalSearch(strMember)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")
strMemberID = strMember

Dim eligibilityStatus
eligibilityStatus = getValueFromPatientProfileScreen("ELIGIBILITY STATUS")
If eligibilityStatus <> "Enrolled" Then
	Call WriteToLog("Fail", "Invalid eligibility status - '" & eligibilityStatus & "'. Expected is 'Enrolled'")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If
Call WriteToLog("Pass", "Eligibility Status is - " & eligibilityStatus)
'==============================
'Get the current disease state of the patient
Call WriteToLog("info", "Get the current disease state of the patient")
'=============================
Dim diseaseState
diseaseState = getValueFromPatientProfileScreen("DISEASE STATE")
If diseaseState = "NA" Then
	isPass = ConnectDB()
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
		Logout
		CloseAllBrowsers
		WriteLogFooter
		ExitAction
	End If
	
	strSQLQuery = "Select PCMB_CMBD_CODE from CAPELLA.PCMB_PATIENT_COMORBIDS where PCMB_MEM_UID = (select mem_uid From MEM_MEMBER WHERE Mem_ID in ('" & strMemberID & "')) and PCMB_STATUS = 'A' and PCMB_CMBD_CODE in ('ESRD','CKD')"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		diseaseState = objDBRecordSet("PCMB_CMBD_CODE")
		objDBRecordSet.MoveNext
	Wend
	
'	diseaseState = "CKD"
	Call CloseDBConnection()
End If
Environment("CURRENT_DS") = trim(diseaseState)
Call WriteToLog("Pass", "The current disease state of the patient is - '" & diseaseState & "'.")


Call validateMedicalAuthorization("Not on File")

Call materialFulfillment()
'==============================
'Upload a medical authorization form and validate the status to be 'Current'
Call WriteToLog("info", "Test Case - Upload a medical authorization form and validate the status to be 'Current'")
'=============================
Call clickOnSubMenu("Tools->Manage Documents")

wait 3
Call waitTillLoads("Loading...")

blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

If not waitUntilExist(objFileSelectionPopup,10) Then
	Call WriteToLog("Fail","File Seletion popup does not open successfully after clicking on upload button")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")

'============================================
'Set the location of file in File name field
'============================================
intX = objFileSelectionSelectFile.GetROProperty("abs_x")
intY = objFileSelectionSelectFile.GetROProperty("abs_y")

intX1 = objFileSelectionSelectFile.GetROProperty("width")
intY1 = objFileSelectionSelectFile.GetROProperty("height")

'Move click at middle of an object
Set ObjectName = CreateObject("Mercury.DeviceReplay")
ObjectName.MouseClick intX + intX1/2,intY + intY1/2,LEFT_MOUSE_BUTTON

wait 2

If not waitUntilExist(objFileNameField,10) Then
	Call WriteToLog("Fail","File name edit field does not exist on Choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")

Err.Clear
objFileNameField.Set strBrowseFileNameWithLocation
If Err.Number <> 0 Then
	Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Wait 2
'Verify open button exist on Choose file to upload dialog
If not waitUntilExist(objOpenButton,10) Then
	Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")

'Click on open file button
blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Wait 2

If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
	Call WriteToLog("Fail","File description field does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

objFileSelectionFileDescriptionField.Click
objFileSelectionFileDescriptionField.Set strFileDescription 

If Err.Number<>0 Then
	Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: "&Err.Description)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
	Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Medical Consents")
If not isPass Then
	Call WriteToLog("Pass", "Medical Consents does not exist in document type drop down as expected")
Else
	Call WriteToLog("Fail", "Medical Consents exists in document type drop down")
End If

fileDescription = "Medical Authorization - " & Environment("CURRENT_DS")

isPass = selectComboBoxItem(objFileSelectionDocumentTypeDropdown, fileDescription)

If not isPass Then
	Call WriteToLog("Fail","Date of Signature field does not exist.")
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Wait 2

Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
If not waitUntilExist(objSignatureDate,3) Then
	Call WriteToLog("Fail","Date of Signature field does not exist.")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

objSignatureDate.Set strSignatureDate

Call WriteToLog("Pass", "Data of Signature is updated with - " & objSignatureDate.GetROProperty("value"))
Execute "Set objSignatureDate = Nothing"

If not waitUntilExist(objOKButton,10) Then
	Call WriteToLog("Fail","OK button does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","OK button exist on File Selection popup")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

wait 2
Call waitTillLoads("Loading...")
'========================================================================================
'Verify that file uploaded successfully message popup is visible after uploading the file
'========================================================================================

blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

wait 2
Call waitTillLoads("Loading...")

'validate if the form is uploaded successfully
Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")
intRows = objManageDocumentDataGrid.RowCount
If intRows > 0 Then
	Call WriteToLog("Pass","All the uploaded files are displayed in the grid")
	For i = 1 To intRows Step 1
		Execute "Set objManageDocumentDataGrid  = "  & Environment("WT_ManageDocument_DataGrid")
		
		'validate the expiration date if document type is Medical Authorization - CKD
		Dim docType, docType1
		docType = objManageDocumentDataGrid.ChildItem(i, 6, "WebElement", 0).GetROProperty("innertext")
		docType1 = trim(docType)
		If Instr(docType1, "Medical Authorization") > 0 Then
			Dim expirationDate
			expirationDate = objManageDocumentDataGrid.ChildItem(i, 8, "WebElement", 0).GetROProperty("innertext")
			strExpirationDate = CDate(strSignatureDate) + 365
			If strComp(trim(expirationDate), strExpirationDate, 1) = 0 Then
				Call WriteToLog("Pass", "Expiration date for the document type '" & docType & "' is " & expirationDate & " is as expected.")
			Else
				Call WriteToLog("Fail", "Expiration date for the document type '" & docType & "' is " & expirationDate & " is NOT as expected " & strExpirationDate)
			End If
		End If
		
		Execute "Set objViewDocument = " &Environment("WEL_ViewDocument")
		Execute "Set objViewDocumentClose = " &Environment("IMG_ViewDocumentClose")
		Err.Clear
		'Open the document
		objManageDocumentDataGrid.ChildItem(i,2,"Image",0).Click
		If Err.Number<>0 Then
			Call WriteToLog("Fail","Unable to click on the uploaded document" &Err.Description)
			Logout
			CloseAllBrowsers
			killAllObjects
			Call WriteLogFooter()
			ExitAction
		End If
		wait 2
		Call waitTillLoads("Loading...")
		objViewDocument.highlight
		If not waitUntilExist(objViewDocument, 10) Then
			Call WriteToLog("Fail","Unable to open the uploaded document")
			Logout
			CloseAllBrowsers
			killAllObjects
			Call WriteLogFooter()
			ExitAction
		End If
		strFileTypeValue = objManageDocumentDataGrid.GetCellData(i,3)
		Call WriteToLog("Pass","File type: " & strFileTypeValue &" opened successfully in View Document dialog")
		'close the document
		Err.Clear
		objViewDocumentClose.click
		If Err.Number<>0 Then
			Call WriteToLog("Fail","Unable to close the View Document dialog" &Err.Description)
			Logout
			CloseAllBrowsers
			killAllObjects
			Call WriteLogFooter()
			ExitAction
		End If
		wait 5
		Call waitTillLoads("Loading...")
		Call WriteToLog("Pass","File closed successfully in View Document")
		Execute "Set objViewDocument = nothing"
		Execute "Set objViewDocumentClose = nothing"
		Execute "Set objManageDocumentDataGrid  = Nothing"
	Next
Else
	Call WriteToLog("Fail","File didnot upload successfully.")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

Call WriteToLog("info", "Logout and login for medical authorization status to change to 'Current'")

Logout
CloseAllBrowsers
killAllObjects
loadObjects

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

'==============================
'Validate Medical Authorization status to be 'Current'
Call WriteToLog("info", "Test Case - Validate Medical Authorization status to be 'Current'")
'=============================
Call validateMedicalAuthorization("Current")

'==============================
'Change the expiration date and validate
Call WriteToLog("info", "Test Case - Change the expiration date and validate")
'=============================

isPass = ConnectDB()
If Not isPass Then
	Call WriteToLog("Fail", "Connect to Database failed.")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

ExpiryDate = strSignatureDate + 2

sqlQuery = "UPDATE EFA_EXTERNAL_FILE_ATTACHMENT SET EFA_AUTH_EXPIRE_DATE = to_date('" & ExpiryDate &"', 'mm/dd/yyyy') WHERE EFA_MEM_UID = (SELECT MEM_UID FROM MEM_MEMBER WHERE MEM_ID = '" & strMemberID & "') AND EFA_DOC_TYPE LIKE 'MA%' and EFA_AUTH_END_DATE IS NULL"
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

strQuery1 = "Select to_char(EFA_AUTH_EXPIRE_DATE, 'mm/dd/yyyy') as EXPIRE_DATE from EFA_EXTERNAL_FILE_ATTACHMENT where EFA_MEM_UID = (SELECT MEM_UID FROM MEM_MEMBER WHERE MEM_ID = '" & strMemberID & "') and EFA_AUTH_END_DATE IS NULL AND EFA_DOC_TYPE LIKE 'MA%'"
isPass = RunQueryRetrieveRecordSet(strQuery1)
Dim exDate
If isPass Then
	while not objDBRecordSet.EOF
		exDate = objDBRecordSet("EXPIRE_DATE")
		objDBRecordSet.MoveNext
	Wend
End If
Call WriteToLog("Pass", "Successfully updated the expiration date to " & ExpiryDate)
Call CloseDBConnection()

Logout
CloseAllBrowsers
killAllObjects
loadObjects
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

'==============================
'Validate Medical Authorization status to be 'Current'
Call WriteToLog("info", "Validate Medical Authorization status to be 'Current'")
'=============================
Call validateMedicalAuthorization("Current")

'==============================
'Change the expiry date in the DB so the form expires and UI shows Authorization Expired
Call WriteToLog("info", "Test Case - Change the expiry date in the DB so the form expires and UI shows Authorization Expired")
'=============================
isPass = ConnectDB()
If Not isPass Then
	Call WriteToLog("Fail", "Connect to Database failed.")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

expDate = date - 1

sqlQuery = "UPDATE EFA_EXTERNAL_FILE_ATTACHMENT SET EFA_AUTH_EXPIRE_DATE = to_date('" & expDate &"', 'mm/dd/yyyy') WHERE EFA_MEM_UID = (SELECT MEM_UID FROM MEM_MEMBER WHERE MEM_ID = '" & strMemberID & "') AND EFA_DOC_TYPE LIKE 'MA%' and EFA_AUTH_END_DATE IS NULL"
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

strQuery1 = "Select to_char(EFA_AUTH_EXPIRE_DATE, 'mm/dd/yyyy') as EXPIRE_DATE from EFA_EXTERNAL_FILE_ATTACHMENT where EFA_MEM_UID = (SELECT MEM_UID FROM MEM_MEMBER WHERE MEM_ID = '" & strMemberID & "') and EFA_AUTH_END_DATE IS NULL AND EFA_DOC_TYPE LIKE 'MA%'"
isPass = RunQueryRetrieveRecordSet(strQuery1)

If isPass Then
	while not objDBRecordSet.EOF
		exDate = objDBRecordSet("EXPIRE_DATE")
		objDBRecordSet.MoveNext
	Wend
End If
Call CloseDBConnection()
If CDate(exDate) = CDate(expDate) Then
	Call WriteToLog("Pass", "Successfully updated the expiration date to " & expDate)
Else
	Call WriteToLog("Fail", "Failed to updat the expiration date to " & expDate)
'	Logout
'	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

Logout
CloseAllBrowsers
killAllObjects
loadObjects

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

wait 2
Call waitTillLoads("Loading...")

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

'validate patient profile and score card to be "Expired"
Call validateMedicalAuthorization("Expired")

Call clickOnSubMenu("Tools->Manage Documents")

wait 2
Call waitTillLoads("Loading...")

loadObjects

blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

If not waitUntilExist(objFileSelectionPopup,10) Then
	Call WriteToLog("Fail","File Seletion popup does not open successfully after clicking on upload button")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")

'============================================
'Set the location of file in File name field
'============================================
intX = objFileSelectionSelectFile.GetROProperty("abs_x")
intY = objFileSelectionSelectFile.GetROProperty("abs_y")

intX1 = objFileSelectionSelectFile.GetROProperty("width")
intY1 = objFileSelectionSelectFile.GetROProperty("height")

'Move click at middle of an object
Set ObjectName = CreateObject("Mercury.DeviceReplay")
ObjectName.MouseClick intX + intX1/2,intY + intY1/2,LEFT_MOUSE_BUTTON

wait 2

If not waitUntilExist(objFileNameField,10) Then
	Call WriteToLog("Fail","File name edit field does not exist on Choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")

Err.Clear
objFileNameField.Set strBrowseFileNameWithLocation
If Err.Number <> 0 Then
	Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Wait 2
'Verify open button exist on Choose file to upload dialog
If not waitUntilExist(objOpenButton,10) Then
	Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")

'Click on open file button
blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Wait 2

If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
	Call WriteToLog("Fail","File description field does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

objFileSelectionFileDescriptionField.Click
objFileSelectionFileDescriptionField.Set strFileDescription 

If Err.Number<>0 Then
	Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: "&Err.Description)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
	Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

fileDescription = "Medical Authorization - " & Environment("CURRENT_DS")

Call selectComboBoxItem(objFileSelectionDocumentTypeDropdown, fileDescription)

Wait 2

Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
If not waitUntilExist(objSignatureDate,3) Then
	Call WriteToLog("Fail","Date of Signature field does not exist.")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

objSignatureDate.Set strSignatureDate

Call WriteToLog("Pass", "Data of Signature is updated with - " & objSignatureDate.GetROProperty("value"))
Execute "Set objSignatureDate = Nothing"

If not waitUntilExist(objOKButton,10) Then
	Call WriteToLog("Fail","OK button does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","OK button exist on File Selection popup")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

wait 2
Call waitTillLoads("Loading...")

'========================================================================================
'Verify that file uploaded successfully message popup is visible after uploading the file
'========================================================================================

blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

wait 2
Call waitTillLoads("Loading...")

Dim isOK : isOK = true
'validate if the form is uploaded successfully
Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")
intRows = objManageDocumentDataGrid.RowCount
If intRows > 0 Then
	Call WriteToLog("Pass","All the uploaded files are displayed in the grid")
	For i = 1 To intRows Step 1
		Execute "Set objManageDocumentDataGrid  = "  & Environment("WT_ManageDocument_DataGrid")
		
		'validate the expiration date if document type is Medical Authorization - CKD
		Dim docuType
		docuType = objManageDocumentDataGrid.ChildItem(i, 6, "WebElement", 0).GetROProperty("innertext")
		docuType = trim(docuType)
		endDate = objManageDocumentDataGrid.ChildItem(i, 9, "WebElement", 0).GetROProperty("innertext")
		If Instr(docuType, "Medical Authorization") > 0 and endDate = "" Then
			expirationDate = objManageDocumentDataGrid.ChildItem(i, 8, "WebElement", 0).GetROProperty("innertext")
			strExpirationDate = CDate(strSignatureDate) + 365
			If strComp(trim(expirationDate), strExpirationDate, 1) = 0 Then
				Call WriteToLog("Pass", "Expiration date for the new uploaded document of document type '" & docuType & "' is " & expirationDate & " is as expected.")
			Else
				Call WriteToLog("Fail", "Expiration date for the new uploaded document of document type '" & docuType & "' is " & expirationDate & " is NOT as expected " & strExpirationDate)
				isOK = false
			End If
		ElseIf Instr(docType1, "Medical Authorization") > 0 and endDate <> "" Then
			endReason = objManageDocumentDataGrid.ChildItem(i, 10, "WebElement", 0).GetROProperty("innertext")
			If trim(endReason) = "Authorization Expired" Then
				Call WriteToLog("Pass", "End reason for the previous expired document is as expected - '" & endReason & "'")
			Else
				Call WriteToLog("Fail", "End reason for the previous expired document is NOT as expected - '" & endReason & "'. Expected value is - 'Authorization Expired'")
				isOK = false
			End If
		End If
		
		Execute "Set objManageDocumentDataGrid  = Nothing"
	Next
Else
	Call WriteToLog("Fail","File didnot upload successfully.")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

If not isOK Then
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

Call WriteToLog("info", "Logout and login for medical authorization status to change to 'Current'")

Logout
CloseAllBrowsers
killAllObjects
loadObjects

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

wait 2

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

'validate patient profile and score card to be "Current"
Call validateMedicalAuthorization("Current")

'==============================
'Delete the uploaded authorization form and check end reason as UR in DB
Call WriteToLog("info", "Test Case - Delete the uploaded authorization form and check end reason as UR in DB")
'=============================

Call clickOnSubMenu("Tools->Manage Documents")

wait 2
Call waitTillLoads("Loading...")

'select the row which authorization form
'=========================================================================================
'Verify that after attaching the document successfully grid contains the document details
'=========================================================================================
Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")
If not waitUntilExist(objManageDocumentDataGrid,10) Then
	Call WriteToLog("Fail","Manage document data grid does not exist on screen")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

Call WriteToLog("Info","Manage document data grid exist on screen")
intRows = objManageDocumentDataGrid.RowCount

If intRows > 0 Then
	For i = 1 To intRows Step 1
		Execute "Set objManageDocumentDataGrid  = "  & Environment("WT_ManageDocument_DataGrid")
		
		Dim docType2, docType3
		docType2 = objManageDocumentDataGrid.ChildItem(i, 6, "WebElement", 0).GetROProperty("innertext")
		docType3 = trim(docType2)
		If Instr(docType3, "Medical Authorization - " & Environment("CURRENT_DS")) > 0 Then
			'select the file by checking the check box
			objManageDocumentDataGrid.ChildItem(i, 1, "WebElement", 0).Click
'			Exit For
		End If
		
		Err.Clear
		
		Execute "Set objManageDocumentDataGrid  = Nothing"
	Next
Else
	Call WriteToLog("Fail","The Manage Documents data grid is empty.")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

strFileDeletedPopupText  = DataTable.Value("FileDeletedPopupText","CurrentTestCaseData")  'File deleted popup text message  
strFileDeletedSuccessPopupText = DataTable.Value("FileDeletedSuccessText","CurrentTestCaseData")
	
Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")' Data grid of manage document screen
Execute "Set objDeleteButton = "  &Environment("WB_ManageDocument_DeleteButton")		 ' Delete button

'Click on Delete button
blnReturnValue = ClickButton("Delete button",objDeleteButton,strOutErrorDesc)
If Not blnReturnValue Then
	strOutErrorDesc = "ClickButton returned error: "&strOutErrorDesc
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteToLog("Fail", strOutErrorDesc)
	ExitAction
	
End If

Wait 2
Call waitTillLoads("Loading...")

'Verify that message box exist stating that "Are you sure you want to remove the selected file\(s\)\?"
blnReturnValue =  checkForPopup(strFileDeletedPopupTitle,"Yes",strFileDeletedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedPopupText&" was displayed")
Else
	strOutErrorDesc = "Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedPopupTitle&" was not displayed. Error returned: "&strOutErrorDesc
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteToLog("Fail", strOutErrorDesc)
	ExitAction
End If

Wait 2
Call waitTillLoads("Loading...")

blnReturnValue = checkForPopup(strFileDeletedPopupTitle,"Ok",strFileDeletedSuccessPopupText,strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedSuccessPopupText&" was displayedl")
Else
	strOutErrorDesc = "Popup with title: "&strFileDeletedPopupTitle& " and stating message: "&strFileDeletedSuccessPopupText&" was not displayed. Error returned: "&strOutErrorDesc
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteToLog("Fail", strOutErrorDesc)
	ExitAction
End If
	
Wait 5

'check DB for UR as end reason
isPass = ConnectDB()
If Not isPass Then
	Call WriteToLog("Fail", "Connect to Database failed.")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

strQuery1 = "Select EFA_AUTH_END_REASON from EFA_EXTERNAL_FILE_ATTACHMENT where EFA_MEM_UID = (SELECT MEM_UID FROM MEM_MEMBER WHERE MEM_ID = '" & strMemberID & "') and EFA_AUTH_END_DATE IS NOT NULL AND EFA_DOC_TYPE LIKE 'MA%'"
isPass = RunQueryRetrieveRecordSet(strQuery1)
Dim endReason : endReason = "NA"
If isPass Then
	while not objDBRecordSet.EOF
		endReason = objDBRecordSet("EFA_AUTH_END_REASON")
		objDBRecordSet.MoveNext
	Wend
End If
Call CloseDBConnection()
If endReason = "NA" Then
	Call WriteToLog("Fail", "Authorization form deleted from DB table.")
Else
	Call WriteToLog("Pass", "End Reason is - '" & endReason & "' as expected.")
End If

Logout
CloseAllBrowsers
killAllObjects
loadObjects

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

'==============================
'Validate Medical Authorization status to be 'Not on file'
'Call WriteToLog("info", "Validate Medical Authorization status to be 'Not on file'")
'=============================
Call validateMedicalAuthorization("Not on file")
wait 2

'==============================
'Upload a medical authorization form and validate the status to be 'Current'
Call WriteToLog("info", "Test Case - Upload the medical authorization form again as a pre-requisite for the next steps and validate the status to be 'Current'")
'=============================
Call clickOnSubMenu("Tools->Manage Documents")

wait 2
Call waitTillLoads("Loading...")

blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

If not waitUntilExist(objFileSelectionPopup,10) Then
	Call WriteToLog("Fail","File Seletion popup does not open successfully after clicking on upload button")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")

'============================================
'Set the location of file in File name field
'============================================
intX = objFileSelectionSelectFile.GetROProperty("abs_x")
intY = objFileSelectionSelectFile.GetROProperty("abs_y")

intX1 = objFileSelectionSelectFile.GetROProperty("width")
intY1 = objFileSelectionSelectFile.GetROProperty("height")

'Move click at middle of an object
Set ObjectName = CreateObject("Mercury.DeviceReplay")
ObjectName.MouseClick intX + intX1/2,intY + intY1/2,LEFT_MOUSE_BUTTON

wait 2

If not waitUntilExist(objFileNameField,10) Then
	Call WriteToLog("Fail","File name edit field does not exist on Choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")

Err.Clear
objFileNameField.Set strBrowseFileNameWithLocation
If Err.Number <> 0 Then
	Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Wait 2
'Verify open button exist on Choose file to upload dialog
If not waitUntilExist(objOpenButton,10) Then
	Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")

'Click on open file button
blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Wait 2

If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
	Call WriteToLog("Fail","File description field does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

objFileSelectionFileDescriptionField.Click
objFileSelectionFileDescriptionField.Set strFileDescription 

If Err.Number<>0 Then
	Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: "&Err.Description)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
	Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Medical Consents")
If not isPass Then
	Call WriteToLog("Pass", "Medical Consents does not exist in document type drop down as expected")
Else
	Call WriteToLog("Fail", "Medical Consents exists in document type drop down")
End If

fileDescription = "Medical Authorization - " & Environment("CURRENT_DS")

Call selectComboBoxItem(objFileSelectionDocumentTypeDropdown, fileDescription)

Wait 3

Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
If not waitUntilExist(objSignatureDate,3) Then
	Call WriteToLog("Fail","Date of Signature field does not exist.")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

objSignatureDate.Set strSignatureDate

Call WriteToLog("Pass", "Data of Signature is updated with - " & objSignatureDate.GetROProperty("value"))
Execute "Set objSignatureDate = Nothing"

If not waitUntilExist(objOKButton,10) Then
	Call WriteToLog("Fail","OK button does not exist on File Selection popup")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","OK button exist on File Selection popup")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

wait 2
Call waitTillLoads("Loading...")

'========================================================================================
'Verify that file uploaded successfully message popup is visible after uploading the file
'========================================================================================

blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

wait 2
Call waitTillLoads("Loading...")

'validate if the form is uploaded successfully
Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")
intRows = objManageDocumentDataGrid.RowCount
If intRows > 0 Then
	Call WriteToLog("Pass","All the uploaded files are displayed in the grid")
	For i = 1 To intRows Step 1
		Execute "Set objManageDocumentDataGrid  = "  & Environment("WT_ManageDocument_DataGrid")
		
		'validate the expiration date if document type is Medical Authorization - CKD
		Dim docType7
		docType7 = objManageDocumentDataGrid.ChildItem(i, 6, "WebElement", 0).GetROProperty("innertext")
		docType7 = trim(docType7)
		If Instr(docType7, "Medical Authorization") > 0 Then
			expirationDate = objManageDocumentDataGrid.ChildItem(i, 8, "WebElement", 0).GetROProperty("innertext")
			strExpirationDate = CDate(strSignatureDate) + 365
			If strComp(trim(expirationDate), strExpirationDate, 1) = 0 Then
				Call WriteToLog("Pass", "Expiration date for the document type '" & docType7 & "' is " & expirationDate & " is as expected.")
			Else
				Call WriteToLog("Fail", "Expiration date for the document type '" & docType7 & "' is " & expirationDate & " is NOT as expected " & strExpirationDate)
			End If
		End If
		
		Execute "Set objViewDocumentClose = nothing"
		Execute "Set objManageDocumentDataGrid  = Nothing"
	Next
Else
	Call WriteToLog("Fail","File didnot upload successfully.")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

Call WriteToLog("info", "Logout and login for medical authorization status to change to 'Current'")

Logout
CloseAllBrowsers
killAllObjects
loadObjects

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

'==============================
'Validate Medical Authorization status to be 'Current'
Call WriteToLog("info", "Validate Medical Authorization status to be 'Current'")
'=============================
Call validateMedicalAuthorization("Current")


'==============================
'Change the Disease state in Comorbids
Call WriteToLog("info", "Test Case - Change the Disease State in Comorbids and verify")
'=============================

clickOnSubMenu("Clinical Management->Comorbids")
wait 2
Call waitTillLoads("Loading...")

Execute "Set objAddButton = " & Environment("WB_ComorbidDetailsAdd")
objAddButton.Click

wait 2
Call waitTillLoads("Loading...")

Dim reqComorbid
Dim newDiseaseState
If Environment("CURRENT_DS") = "ESRD" Then
	Execute "Set objComorbidType = " & Environment("WB_ComorbidType")
	Call selectComboBoxItem(objComorbidType, "CKD Stage")
	reqComorbid = "CKD Stage"
	newDiseaseState = "CKD"
'	Execute "Set objProvider = " & Environment("WB_ComorbidProvider")
'	Call selectComboBoxItem(objProvider, "VHN : Harris, Sandra")

	Execute "Set objComorbidDetails = " & Environment("WB_ComorbidDetail")
	Call selectComboBoxItem(objComorbidDetails, "CKD Stage 2")
Else
	Execute "Set objComorbidType = " & Environment("WB_ComorbidType")
	Call selectComboBoxItem(objComorbidType, "ESRD")
	reqComorbid = "ESRD"
	newDiseaseState = "ESRD"
End If

wait 2

Execute "Set objSaveButton = " & Environment("WB_ComorbidDetailsSave")
objSaveButton.Click

wait 2
Call waitTillLoads("Loading...")

Execute "Set objComorbidListTable = " & Environment("WB_ComorbidListTable")
If not waitUntilExist(objComorbidListTable,10) Then
	
End If
Dim tabVal
tabVal = objComorbidListTable.getCellData(1, 1)
If trim(tabVal) = reqComorbid then
	Call WriteToLog("Pass", "Disease state changed successfully to - '" & reqComorbid & "'")
Else
	Call WriteToLog("Fail", "Disease state change fail. Expected Disease state is - " & reqComorbid & "', but actual value in table is - '" & tabVal & "'")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

Logout
CloseAllBrowsers
killAllObjects
loadObjects

'Login to Capella
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

'==============================
'Get the current disease state of the patient
Call WriteToLog("info", "Get the current disease state of the patient")
'=============================
diseaseState = getValueFromPatientProfileScreen("DISEASE STATE")
If diseaseState = "NA" Then
	isPass = ConnectDB()
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
		Logout
		CloseAllBrowsers
		WriteLogFooter
		ExitAction
	End If
	
	strSQLQuery = "Select PCMB_CMBD_CODE from CAPELLA.PCMB_PATIENT_COMORBIDS where PCMB_MEM_UID = (select mem_uid From MEM_MEMBER WHERE Mem_ID in ('" & strMemberID & "')) and PCMB_STATUS = 'A' and PCMB_CMBD_CODE in ('ESRD','CKD')"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		diseaseState = objDBRecordSet("PCMB_CMBD_CODE")
		objDBRecordSet.MoveNext
	Wend
	
'	diseaseState = "CKD"
	Call CloseDBConnection()
End If
Environment("NEW_DS") = trim(diseaseState)
If trim(diseaseState) = trim(newDiseaseState) Then
	Call WriteToLog("Pass", "Disease state successfully updated to - '" & diseaseState & "'.")
Else
	Call WriteToLog("Fail", "Disease state is NOT updated to - '" & newDiseaseState & "' as required. Value in UI/DB is - '" & diseaseState & "'")
'	Logout
'	CloseAllBrowsers
'	killAllObjects
'	WriteLogFooter
'	ExitAction
End If

'==============================
'Upload a medical authorization form and validate the end reason to be 'Change in Disease State'
Call WriteToLog("info", "Test Case - Upload a medical authorization form and validate the end reason to be 'Change in Disease State'")
'=============================
Call clickOnSubMenu("Tools->Manage Documents")

wait 2
Call waitTillLoads("Loading...")

blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

If not waitUntilExist(objFileSelectionPopup,10) Then
	Call WriteToLog("Fail","File Seletion popup does not open successfully after clicking on upload button")
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")

'============================================
'Set the location of file in File name field
'============================================
intX = objFileSelectionSelectFile.GetROProperty("abs_x")
intY = objFileSelectionSelectFile.GetROProperty("abs_y")

intX1 = objFileSelectionSelectFile.GetROProperty("width")
intY1 = objFileSelectionSelectFile.GetROProperty("height")

'Move click at middle of an object
Set ObjectName = CreateObject("Mercury.DeviceReplay")
ObjectName.MouseClick intX + intX1/2,intY + intY1/2,LEFT_MOUSE_BUTTON

wait 2

If not waitUntilExist(objFileNameField,10) Then
	Call WriteToLog("Fail","File name edit field does not exist on Choose file to upload Dialog")
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")

Err.Clear
objFileNameField.Set strBrowseFileNameWithLocation
If Err.Number <> 0 Then
	Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
	Call WriteLogFooter()
	ExitAction
End If

Wait 2
'Verify open button exist on Choose file to upload dialog
If not waitUntilExist(objOpenButton,10) Then
	Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")

'Click on open file button
blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

Wait 2

If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
	Call WriteToLog("Fail","File description field does not exist on File Selection popup")
	Call WriteLogFooter()
	ExitAction
End If

objFileSelectionFileDescriptionField.Click
objFileSelectionFileDescriptionField.Set strFileDescription 

If Err.Number<>0 Then
	Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: "&Err.Description)
	Call WriteLogFooter()
	ExitAction
End If

If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
	Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
	Call WriteLogFooter()
	ExitAction
End If

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Medical Consents")
If not isPass Then
	Call WriteToLog("Pass", "Medical Consents does not exist in document type drop down as expected")
Else
	Call WriteToLog("Fail", "Medical Consents exists in document type drop down")
End If

Dim fileDescription
fileDescription = "Medical Authorization - " & Environment("NEW_DS")

isPass = selectComboBoxItem(objFileSelectionDocumentTypeDropdown, fileDescription)
If not isPass Then
	Call WriteToLog("Fail", "Failed to select the drop down.")
	Logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

Wait 2

Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
If not waitUntilExist(objSignatureDate,3) Then
	Call WriteToLog("Fail","Date of Signature field does not exist.")
	Call WriteLogFooter()
	ExitAction
End If

objSignatureDate.Set strSignatureDate

Call WriteToLog("Pass", "Data of Signature is updated with - " & objSignatureDate.GetROProperty("value"))
Execute "Set objSignatureDate = Nothing"

If not waitUntilExist(objOKButton,10) Then
	Call WriteToLog("Fail","OK button does not exist on File Selection popup")
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Info","OK button exist on File Selection popup")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

wait 2
Call waitTillLoads("Loading...")

'========================================================================================
'Verify that file uploaded successfully message popup is visible after uploading the file
'========================================================================================

blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
	Call WriteLogFooter()
	ExitAction
End If

wait 2
Call waitTillLoads("Loading...")

'validate if the form is uploaded successfully
Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")
intRows = objManageDocumentDataGrid.RowCount
If intRows > 0 Then
	Call WriteToLog("Pass","All the uploaded files are displayed in the grid")
	For i = 1 To intRows Step 1
		Execute "Set objManageDocumentDataGrid  = "  & Environment("WT_ManageDocument_DataGrid")
		
		'validate the expiration date if document type is Medical Authorization - CKD
		Dim docType4
		docType4 = objManageDocumentDataGrid.ChildItem(i, 6, "WebElement", 0).GetROProperty("innertext")
		docType4 = trim(docType4)
		If Instr(docType4, fileDescription) > 0 Then
			expirationDate = objManageDocumentDataGrid.ChildItem(i, 8, "WebElement", 0).GetROProperty("innertext")
			strExpirationDate = CDate(strSignatureDate) + 365
			If strComp(trim(expirationDate), strExpirationDate, 1) = 0 Then
				Call WriteToLog("Pass", "Expiration date for the document type '" & docType & "' is " & expirationDate & " is as expected.")
			Else
				Call WriteToLog("Fail", "Expiration date for the document type '" & docType & "' is " & expirationDate & " is NOT as expected " & strExpirationDate)
			End If
		ElseIf Instr(docType4, "Medical Authorization - " & Environment("CURRENT_DS")) > 0  Then
			endDate = objManageDocumentDataGrid.ChildItem(i, 9, "WebElement", 0).GetROProperty("innertext")
			strEndDate = date
			If strComp(trim(endDate), strEndDate, 1) = 0 Then
				Call WriteToLog("Pass", "End date for the previous document type '" & docType4 & "' is " & endDate & " is as expected.")
			Else
				Call WriteToLog("Fail", "End date for the previous document type '" & docType4 & "' is " & endDate & " is NOT as expected " & strEndDate)
			End If
			
			endReason = objManageDocumentDataGrid.ChildItem(i, 10, "WebElement", 0).GetROProperty("innertext")
			If StrComp(trim(endReason), "Change in Disease State", 1) = 0 Then
				Call WriteToLog("Pass", "End reason for the previous document type '" & docType4 & "' is " & endReason & " is as expected.")
			Else
				Call WriteToLog("Fail", "End reason for the previous document type '" & docType4 & "' is " & endReason & " is NOT as expected 'Change in Disease State'")
			End If
		End If
		
		Execute "Set objManageDocumentDataGrid  = Nothing"
	Next
Else
	Call WriteToLog("Fail","File didnot upload successfully.")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

Call WriteToLog("info", "Logout and login for medical authorization status to change to 'Current'")

Logout
CloseAllBrowsers
killAllObjects
loadObjects

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

'==============================
'Validate Medical Authorization status to be 'Current'
Call WriteToLog("info", "Validate Medical Authorization status to be 'Current'")
'=============================
Call validateMedicalAuthorization("Current")

killAllObjects

Logout
CloseAllBrowsers
killAllObjects

'==================================
'Terminate the patient and check the table
Call WriteToLog("info", "Test Case - Terminate the patient and validate 'Patient Termed' end reason")
'==================================
'Login to Capella as EPS
isPass = Login("eps")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to EPS role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into EPS role")

isPass = terminatePatient(strMemberID)

If not isPass Then
	Call WriteToLog("Fail", "Failed to terminate the patient")
	logout
	CloseAllBrowsers
	killAllObjects
	WriteLogFooter
	ExitAction
End If

logout
CloseAllBrowsers

'Login to Capella as VHN
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

wait 2

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")

Call clickOnSubMenu("Tools->Manage Documents")

wait 2
Call waitTillLoads("Loading...")
'loadObjects
isOK = true
'validate if the form is uploaded successfully
Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")
intRows = objManageDocumentDataGrid.RowCount
If intRows > 0 Then
	Call WriteToLog("Pass","All the uploaded files are displayed in the grid")
	For i = 1 To intRows Step 1
		Execute "Set objManageDocumentDataGrid  = "  & Environment("WT_ManageDocument_DataGrid")
		
		'validate the expiration date if document type is Medical Authorization - CKD
		docuType = objManageDocumentDataGrid.ChildItem(i, 6, "WebElement", 0).GetROProperty("innertext")
		docuType = trim(docuType)
		fileDescription = "Medical Authorization - " & Environment("NEW_DS")
		endDate = objManageDocumentDataGrid.ChildItem(i, 9, "WebElement", 0).GetROProperty("innertext")
		If Instr(docuType, fileDescription) > 0 and endDate <> "" Then
			
			If strComp(CDate(trim(endDate)), date, 1) = 0 Then
				Call WriteToLog("Pass", "End date for the document of document type '" & docuType & "' is " & endDate & " is as expected.")
			Else
				Call WriteToLog("Fail", "End date for the document of document type '" & docuType & "' is " & endDate & " is NOT as expected " & date)
				isOK = false
			End If
			endReason = objManageDocumentDataGrid.ChildItem(i, 10, "WebElement", 0).GetROProperty("innertext")
			If trim(endReason) = "Patient Termed" Then
				Call WriteToLog("Pass", "End reason for the document is as expected - '" & endReason & "'")
			Else
				Call WriteToLog("Fail", "End reason for the document is NOT as expected - '" & endReason & "'. Expected value is - 'Patient Termed'")
				isOK = false
			End If
			
			Exit For
		End If
		
		Execute "Set objManageDocumentDataGrid  = Nothing"
	Next
Else
	Call WriteToLog("Fail","File didnot upload successfully.")
End If

Logout
CloseAllBrowsers
killAllObjects
WriteLogFooter

Function killAllObjects()

	Execute "Set objPage = Nothing"
	Execute "Set objReviewOrder = Nothing"
	Execute "Set objSelectTable = Nothing"
	Execute "Set objDateRequested = Nothing"   
	Execute "Set objMaterialFulfillmentTitle = Nothing" 
	Execute "Set objCompleteOrder= Nothing"
	Execute "Set objDateFulfilled= Nothing"
	Execute "Set objDomainDropDown= Nothing"
	Execute "Set objFulfilledBy= Nothing"
	Execute "Set objFollowUpNO= Nothing"
	Execute "Set objFollowUpYES=  Nothing"
	Execute "Set objAddress1= Nothing"
	Execute "Set objCity= Nothing" 
	Execute "Set objStateDropDown= Nothing" 
	Execute "Set objZipcode= Nothing" 
	Execute "Set objOrderList = Nothing" 
	Execute "Set objItemsOrdered = Nothing" 
	Execute "Set objFollowupDate = Nothing"
	Execute "Set objFollowupDropDown = Nothing" 
	Execute "Set objFollowupSave = Nothing" 
	Execute "Set objMaterialHistory = Nothing"
	Execute "Set HistoryDesc = Nothing"
	
	Execute "Set objManageDocumentScreenTitle = Nothing"
	Execute "Set objManageDocumentGrid = Nothing"
	Execute "Set objUploadButton = Nothing"
	Execute "Set objDeleteButton = Nothing"
	Execute "Set objFileSelectionPopup = Nothing"
	Execute "Set objFileSelectionFileNameField = Nothing"
	Execute "Set objFileSelectionSelectFile = Nothing"
	Execute "Set objFileSelectionFileDescriptionField = Nothing"
	Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"
	Execute "Set objFileNameField = Nothing"
	Execute "Set objOpenButton = Nothing"
	Execute "Set objOKButton= Nothing"
	
	Execute "Set objComorbidDetails = Nothing"
	Execute "Set objProvider = Nothing"
	Execute "Set objComorbidType = Nothing"
	Execute "Set objAddButton = Nothing"
	Execute "Set objSaveButton = Nothing"
	Execute "Set objComorbidListTable = Nothing"
End Function
