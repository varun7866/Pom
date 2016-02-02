'**************************************************************************************************************************************************************************
' TestCase Name			: ManageDocumentsUpload
' Purpose of TC			: Validating newly added document types and other options in Manage Documents
' Author                : Amar
' Date                  : 1 Nov. 2015
' Modified				: 11 Nov. 2015
' Comments 				: This scripts covers testcases coresponding to user story B-05542
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ManageDocumentsUpload", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If
'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'------------------------
' Variable initialization
'------------------------
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strColumnNames = DataTable.Value("ColumnNames","CurrentTestCaseData")
strFilePath = Environment.Value("PROJECT_FOLDER")&"\Testdata\ManageDocuments"
strFileName = DataTable.Value("FileName","CurrentTestCaseData")
strBrowseFileNameWithLocation = strFilePath&"\"&strFileName
strFileDescription = DataTable.Value("FileDescription","CurrentTestCaseData")
strDocumentType = DataTable.Value("DocumentType","CurrentTestCaseData")
strFileUploadedPopupTitle = DataTable.Value("FileUpLoadedPopupTitle","CurrentTestCaseData")
strFileUploadedPopupText = DataTable.Value("FileUpLoadedPopupText","CurrentTestCaseData")
strSignatureDate = date 'DataTable.Value("SignatureDate", "CurrentTestCaseData")
strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")	'"177053"
strUser = DataTable.Value("User","CurrentTestCaseData")

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
Execute "Set objManageDocumentScreenTitle = "  &Environment("WT_ManageDocument_ScreenTitle")
Execute "Set objManageDocumentGrid = "  &Environment("WT_ManageDocument_Grid")
Execute "Set objUploadButton = "  &Environment("WB_ManageDocument_UploadButton")
Execute "Set objDeleteButton = "  &Environment("WB_ManageDocument_DeleteButton")
Execute "Set objFileSelectionPopup = "  &Environment("WEL_ManageDocument_FileSelection_PopupTitle")
Execute "Set objFileSelectionFileNameField = "  &Environment("WE_ManageDocument_FileSelection_FileName")
Execute "Set objFileSelectionSelectFile = "  &Environment("WEL_ManageDocument_FileSelection_SelectFile")
Execute "Set objFileSelectionFileDescriptionField = "  &Environment("WE_ManageDocument_FileSelection_FileDescription")
Execute "Set objFileSelectionDocumentTypeDropdown = "  &Environment("WB_ManageDocument_FileSelection_DocumentType")
Execute "Set objFileNameField = "  &Environment("WiE_ChooseFileToUpload_Dialog_FileNameField")
Execute "Set objOpenButton = "  &Environment("WiB_ChooseFileToUpload_Dialog_OpenButton")
Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")
Execute "Set objOKButton= "  &Environment("WB_OK")
    
''-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("Info","----------Login to application, Close all open patients, Select user roster----------")

''Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
'
''Open required patient in assigned VHN user
strGetAssingnedUserDashboard = GetAssingnedUserDashboard(strMemberID, strOutErrorDesc)
If strGetAssingnedUserDashboard = "" Then
	Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
Wait 2

'Call WriteToLog("Info","----------------Select required patient from MyPatient List----------------")
'Select patient from MyPatient list
'blnSelectPatientFromPatientList = SelectPatientFromPatientList(strUser, strPatientName)
'If blnSelectPatientFromPatientList Then
'	Call WriteToLog("Pass","Selected required patient from MyPatient list")
'Else
'	strOutErrorDesc = "Unable to select required patient"
'	Call WriteToLog("Fail","Expected Result: Should be able to select required patient from MyPatient list.  Actual Result: "&strOutErrorDesc)
'	Call Terminator
'End If
'Wait 2

Call waitTillLoads("Loading...")

Call clickOnSubMenu1("Tools->Manage Documents")

Call waitTillLoads("Loading...")

''==========================================================
''Verify that Manage Document Screen open successfully
''==========================================================
objManageDocumentScreenTitle.highlight
If not waitUntilExist(objManageDocumentScreenTitle, 10) Then
	Call WriteToLog("Fail","Unable to open Manage document Screen")
	Call Terminator	
End If

Call WriteToLog("Pass","Manage document screen opened successfully")	

'==========================================================
'Verify that manage document screen contain button Delete 
'==========================================================
Call WriteToLog("info","Verify that manage document screen contain button Delete ")
If not waitUntilExist(objDeleteButton,10) Then
	Call WriteToLog("Fail","Delete button does not exist on manage document screen")
	Call Terminator	
End If

Call WriteToLog("Info","Delete button exist on manage document screen")

'==========================================================
'Verify that manage document screen contain button Upload 
'==========================================================
Call WriteToLog("info", "Verify that manage document screen contain button Upload")
If not waitUntilExist(objUploadButton,10) Then
	Call WriteToLog("Fail","Upload button does not exist on manage document screen")
	Call Terminator	
End If

Call WriteToLog("Info","Upload button exist on manage document screen")

'===============================================================================
'TestCase:Click on Upload button and verify that File Seletion popup should open
'===============================================================================
Call WriteToLog("info", "Verify 'GetFileDescription' message box")
blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator	
End If

Call waitTillLoads("Loading...")

'Verify the file popup dialog exists
If not waitUntilExist(objFileSelectionPopup,10) Then
	Call WriteToLog("Fail","File Seletion popup does not open successfully after clicking on upload button")
	Call Terminator	
End If

Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")

''=========================================================================
''TestCase:Click on ‘Document Type’ dropdown and verify for the new values
''=========================================================================
If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
	Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
	Call Terminator	
End If

Call WriteToLog("Info","Document Type dropdown exist on File Selection popup")

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Pneumococcal Verification")
If not isPass Then
	Call WriteToLog("Fail", "Pneumococcal Verification does not exist in document type drop down ")
	Call Terminator	
End If
Call WriteToLog("Pass", "Pneumococcal Verification exists in document type drop down as expected")

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Influenza Verification")
If not isPass Then
	Call WriteToLog("Fail", "Influenza Verification does not exist in document type drop down ")
	Call Terminator	
End If
Call WriteToLog("Pass", "Influenza Verification exists in document type drop down as expected")

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "ACP")
If not isPass Then
	Call WriteToLog("Fail", "ACP does not exist in document type drop down ")
	Call Terminator	
End If
Call WriteToLog("Pass", "ACP exists in document type drop down as expected")

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Humana Member Summary")
If not isPass Then
	Call WriteToLog("Fail", "Humana Member Summary does not exist in document type drop down ")
	Call Terminator	
End If
Call WriteToLog("Pass", "Humana Member Summary exists in document type drop down as expected")

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Diabetic Retinal Eye Exam Verification")
If not isPass Then
	Call WriteToLog("Fail", "Diabetic Retinal Eye Exam Verification does not exist in document type drop down ")
	Call Terminator	
End If
Call WriteToLog("Pass", "Diabetic Retinal Eye Exam Verification exists in document type drop down as expected")

isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Florida HIE Consent Form")
If not isPass Then
	Call WriteToLog("Fail", "Florida HIE Consent Form does not exist in document type drop down ")
	Call Terminator	
End If
Call WriteToLog("Pass", "Florida HIE Consent Form exists in document type drop down as expected")

blnDocumentType=selectComboBoxItem(objFileSelectionDocumentTypeDropdown, "Medical Attestation")
If not blnDocumentType Then
	Call WriteToLog("Fail","Medical Attestation is not Set on Document type field")
	Call Terminator	
End If

Call WriteToLog("Pass", "Medical Attestation exists in document type drop down as expected")

'================================================================================
'TestCase:Select the newly added option ‘Diabetic Retinal Eye Exam Verification’.
'================================================================================
blnDocumentType=selectComboBoxItem(objFileSelectionDocumentTypeDropdown, "Diabetic Retinal Eye Exam Verification")
If not blnDocumentType Then
	Call WriteToLog("Fail","Diabetic Retinal Eye Exam Verification is not Set on Document type field")
	Call Terminator	
End If

Call WriteToLog("Pass","Diabetic Retinal Eye Exam Verification is Set on Document type field")

Wait 3

blnDocumentType=selectComboBoxItem(objFileSelectionDocumentTypeDropdown, "Select a value")

'Testcase4:User should be able to upload the file without selecting the ‘Signature date’ field under ‘File Selection’ popup.
'====================================================
'Click on OK button without giving the Signature Date
'====================================================

'Verify the file selection field name exists
If not waitUntilExist(objFileSelectionFileNameField,10) Then
	Call WriteToLog("Fail","File name edit field does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","File name edit field exist on File Selection popup")

If not waitUntilExist(objFileSelectionSelectFile,10) Then
	Call WriteToLog("Fail","Select file button does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","Select file button exist on File Selection popup")

objFileSelectionSelectFile.highlight

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
	Call Terminator
End If

Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")

Err.Clear
objFileNameField.Set strBrowseFileNameWithLocation
If Err.Number <> 0 Then
	Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
	Call Terminator
End If

Wait 2
'Verify open button exist on Choose file to upload dialog
If not waitUntilExist(objOpenButton,10) Then
	Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
	Call Terminator
End If

Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")

'Click on open file button
blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Wait 2

If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
	Call WriteToLog("Fail","File description field does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","File description field exist on File Selection popup")

Err.Clear
objFileSelectionFileDescriptionField.Click
objFileSelectionFileDescriptionField.Set strFileDescription 

Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"
Execute "Set objFileSelectionDocumentTypeDropdown = "  &Environment("WB_ManageDocument_FileSelection_DocumentType")

blnDocumentType=selectComboBoxItem(objFileSelectionDocumentTypeDropdown, "ACP")
If not blnDocumentType Then
	Call WriteToLog("Fail","ACP is not Set on Document type field")
	Call Terminator
End If

Call WriteToLog("Pass","ACP is Set on Document type field")

Wait 3
Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"

Execute "Set objOKButton = Nothing"
Execute "Set objOKButton= "  &Environment("WB_OK")
If not waitUntilExist(objOKButton,10) Then
	Call WriteToLog("Fail","OK button does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","OK button exist on File Selection popup")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Call waitTillLoads("Loading...")

Execute "Set objOKButton = Nothing"

'========================================================================================
'Verify that file uploaded successfully message popup is visible after uploading the file
'========================================================================================

blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
	Call Terminator
End If

wait 5
''======================================================================================================================================================================
''testcase:User should be able to upload a file with same document type multiple times and the uploaded documents should be displayed under ‘Manage Documents’ section.
''======================================================================================================================================================================
''================================
''testcase:fill all the fields
''================================

blnReturnValue = UploadAllManageDocuments(strOutErrorDesc, "JPG")
If Not blnReturnValue Then
    Call WriteToLog("Fail","UploadManageDocuments returned error for PNG File: "&strOutErrorDesc)
    Call Terminator        
End If

'=========================================================================================
'Verify that after attaching the document successfully grid contains the document details
'=========================================================================================
If not waitUntilExist(objManageDocumentDataGrid,10) Then
	Call WriteToLog("Fail","Manage document data grid does not exist on screen")
	Call Terminator
End If

Call WriteToLog("Info","Manage document data grid exist on screen")
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
			Print "Expiration Date :: " & strExpirationDate
			If strComp(trim(expirationDate), strExpirationDate, 1) = 0 Then
				Call WriteToLog("Pass", "Expiration date for the document type '" & docType & "' is " & expirationDate & " is as expected.")
			Else
				Call WriteToLog("Fail", "Expiration date for the document type '" & docType & "' is " & expirationDate & " is NOT as expected " & strExpirationDate)
			End If
		Else
			expirationDate = objManageDocumentDataGrid.ChildItem(i, 8, "WebElement", 0).GetROProperty("innertext")
			strExpirationDate = ""
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
			Call Terminator
		End If
		wait 2
		objViewDocument.highlight
		If not waitUntilExist(objViewDocument, 10) Then
			Call WriteToLog("Fail","Unable to open the uploaded document")
			Call Terminator
		End If
		strFileTypeValue = objManageDocumentDataGrid.GetCellData(i,3)
		Call WriteToLog("Pass","File type: " & strFileTypeValue &" opened successfully in View Document dialog")
		'close the document
		Err.Clear
		objViewDocumentClose.click
		If Err.Number<>0 Then
			Call WriteToLog("Fail","Unable to close the View Document dialog" &Err.Description)
			Call Terminator
		End If
		wait 2
		Call WriteToLog("Pass","File closed successfully in View Document")
		Execute "Set objViewDocument = nothing"
		Execute "Set objViewDocumentClose = nothing"
		Execute "Set objManageDocumentDataGrid  = Nothing"
	Next
Else
	Call WriteToLog("Fail","File does not uploaded successfully")
End If
blnReturnValue = UploadAllManageDocuments(strOutErrorDesc, "JPG")
If Not blnReturnValue Then
    Call WriteToLog("Fail","UploadManageDocuments returned error for PNG File: "&strOutErrorDesc)
    Call Terminator        
End If

''=========================================================================
''TestCase:Click on OK Button without giving the File Name
''=========================================================================

blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Call waitTillLoads("Loading...")

Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"
Execute "Set objFileSelectionDocumentTypeDropdown = "  &Environment("WB_ManageDocument_FileSelection_DocumentType")
blnDocumentType=selectComboBoxItem(objFileSelectionDocumentTypeDropdown, "ACP")
If not blnDocumentType Then
	Call WriteToLog("Fail","ACP is not Set on Document type field")
	Call Terminator
End If

Call WriteToLog("Pass","ACP is Set on Document type field")

Wait 3

Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"

Execute "Set objSignatureDate = Nothing"
Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
If not waitUntilExist(objSignatureDate,3) Then
	Call WriteToLog("Fail","Date of Signature field does not exist.")
	Call Terminator
End If

objSignatureDate.Set strSignatureDate

Call WriteToLog("Pass", "Data of Signature is updated with - " & objSignatureDate.GetROProperty("value"))
Execute "Set objSignatureDate = Nothing"

Execute "Set objFileSelectionFileDescriptionField = Nothing"
Execute "Set objFileSelectionFileDescriptionField = "  &Environment("WE_ManageDocument_FileSelection_FileDescription")

If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
	Call WriteToLog("Fail","File description field does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","File description field exist on File Selection popup")

Err.Clear
objFileSelectionFileDescriptionField.Click
objFileSelectionFileDescriptionField.Set strFileDescription 

'Call SendKeys("{TAB}")

If Err.Number<>0 Then
	Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: "&Err.Description)
	Call Terminator
End If

Wait 2

Execute "Set objFileSelectionFileDescriptionField = Nothing"

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Call WriteToLog("Pass","User is not allowed to save the changes under ‘File Selection’ window.")

wait 2

Execute "Set objFileNameField = "  &Environment("WiE_ChooseFileToUpload_Dialog_FileNameField")
Execute "Set objFileSelectionPopup = "  &Environment("WEL_ManageDocument_FileSelection_PopupTitle")
Execute "Set objFileSelectionFileNameField = "  &Environment("WE_ManageDocument_FileSelection_FileName")
Execute "Set objFileSelectionSelectFile = "  &Environment("WEL_ManageDocument_FileSelection_SelectFile")
'Verify the file selection field name exists
If not waitUntilExist(objFileSelectionFileNameField,10) Then
	Call WriteToLog("Fail","File name edit field does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","File name edit field exist on File Selection popup")

If not waitUntilExist(objFileSelectionSelectFile,10) Then
	Call WriteToLog("Fail","Select file button does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","Select file button exist on File Selection popup")

objFileSelectionSelectFile.highlight

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
	Call Terminator
End If

Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")

Err.Clear
objFileNameField.Set strBrowseFileNameWithLocation
If Err.Number <> 0 Then
	Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
	Call Terminator
End If

Wait 2
'Verify open button exist on Choose file to upload dialog
If not waitUntilExist(objOpenButton,10) Then
	Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
	Call Terminator
End If

Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")

'Click on open file button
blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Wait 2

Execute "Set objFileNameField = Nothing"
Execute "Set objFileSelectionPopup = Nothing"
Execute "Set objFileSelectionFileNameField = Nothing"
Execute "Set objFileSelectionSelectFile = Nothing"

Execute "Set objOKButton = Nothing"
Execute "Set objOKButton= "  &Environment("WB_OK")
blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

wait 5
Execute "Set objOKButton = Nothing"

'========================================================================================
'Verify that file uploaded successfully message popup is visible after uploading the file
'========================================================================================

blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
	Call Terminator
End If

wait 5

''============================================================
''Testcase:Click on OK Button without giving File Description
''============================================================

blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Call waitTillLoads("Loading...")

Execute "Set objFileNameField = "  &Environment("WiE_ChooseFileToUpload_Dialog_FileNameField")
Execute "Set objFileSelectionPopup = "  &Environment("WEL_ManageDocument_FileSelection_PopupTitle")
Execute "Set objFileSelectionFileNameField = "  &Environment("WE_ManageDocument_FileSelection_FileName")
Execute "Set objFileSelectionSelectFile = "  &Environment("WEL_ManageDocument_FileSelection_SelectFile")

'Verify the file selection field name exists
If not waitUntilExist(objFileSelectionFileNameField,10) Then
	Call WriteToLog("Fail","File name edit field does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","File name edit field exist on File Selection popup")

If not waitUntilExist(objFileSelectionSelectFile,10) Then
	Call WriteToLog("Fail","Select file button does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","Select file button exist on File Selection popup")

objFileSelectionSelectFile.highlight

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
	Call Terminator
End If

Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")

Err.Clear
objFileNameField.Set strBrowseFileNameWithLocation
If Err.Number <> 0 Then
	Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
	Call Terminator
End If

Wait 2
'Verify open button exist on Choose file to upload dialog
If not waitUntilExist(objOpenButton,10) Then
	Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
	Call Terminator
End If

Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")

'Click on open file button
blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Wait 2

Execute "Set objFileNameField = Nothing"
Execute "Set objFileSelectionPopup = Nothing"
Execute "Set objFileSelectionFileNameField = Nothing"
Execute "Set objFileSelectionSelectFile = Nothing"

'Set the date of signature
Execute "Set objSignatureDate = Nothing"
Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
If not waitUntilExist(objSignatureDate,3) Then
	Call WriteToLog("Fail","Date of Signature field does not exist.")
	Call Terminator
End If

objSignatureDate.Set strSignatureDate

Call WriteToLog("Pass", "Data of Signature is updated with - " & objSignatureDate.GetROProperty("value"))
Execute "Set objSignatureDate = Nothing"


Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"
Execute "Set objFileSelectionDocumentTypeDropdown = "  &Environment("WB_ManageDocument_FileSelection_DocumentType")
blnDocumentType=selectComboBoxItem(objFileSelectionDocumentTypeDropdown, "ACP")
If not blnDocumentType Then
	Call WriteToLog("Fail","Medical Attestation is not Set on Document type field")
	Call Terminator
End If

Call WriteToLog("Pass","ACP")

Wait 3
Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"

Execute "Set objOKButton = Nothing"
Execute "Set objOKButton= "  &Environment("WB_OK")
If not waitUntilExist(objOKButton,10) Then
	Call WriteToLog("Fail","OK button does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","OK button exist on File Selection popup")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

wait 5

Execute "Set objOKButton = Nothing"

'Verify the error pop up message
blnReturnValue = checkForPopup("GetFileDescription", "Ok", "File Description cannot be empty.", strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Error Popup was displayed with message: File Description cannot be empty.")
Else
	Call WriteToLog("Fail","There was no popup displayed when File Description field is not set.")
	Call Terminator
End If

wait 2
Execute "Set objFileSelectionFileDescriptionField = Nothing"
Execute "Set objFileSelectionFileDescriptionField = "  &Environment("WE_ManageDocument_FileSelection_FileDescription")

If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
	Call WriteToLog("Fail","File description field does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","File description field exist on File Selection popup")

Err.Clear
objFileSelectionFileDescriptionField.Click
objFileSelectionFileDescriptionField.Set strFileDescription 

'Call SendKeys("{TAB}")

If Err.Number<>0 Then
	Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: "&Err.Description)
	Call Terminator
End If

Wait 2

Execute "Set objFileSelectionFileDescriptionField = Nothing"

Execute "Set objOKButton = Nothing"
Execute "Set objOKButton= "  &Environment("WB_OK")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Call waitTillLoads("Loading...")

wait 5
Execute "Set objOKButton = Nothing"

'========================================================================================
'Verify that file uploaded successfully message popup is visible after uploading the file
'========================================================================================

blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
	Call Terminator
End If

Call waitTillLoads("Loading...")
wait 5

blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Call waitTillLoads("Loading...")

'====================================================
'Click on OK button without Selecting the Document type
'====================================================

Execute "Set objFileNameField = "  &Environment("WiE_ChooseFileToUpload_Dialog_FileNameField")
Execute "Set objFileSelectionPopup = "  &Environment("WEL_ManageDocument_FileSelection_PopupTitle")
Execute "Set objFileSelectionFileNameField = "  &Environment("WE_ManageDocument_FileSelection_FileName")
Execute "Set objFileSelectionSelectFile = "  &Environment("WEL_ManageDocument_FileSelection_SelectFile")

If not waitUntilExist(objFileSelectionFileNameField,10) Then
	Call WriteToLog("Fail","File name edit field does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","File name edit field exist on File Selection popup")

If not waitUntilExist(objFileSelectionSelectFile,10) Then
	Call WriteToLog("Fail","Select file button does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","Select file button exist on File Selection popup")

objFileSelectionSelectFile.highlight

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
	Call Terminator
End If

Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")

Err.Clear
objFileNameField.Set strBrowseFileNameWithLocation
If Err.Number <> 0 Then
	Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
	Call Terminator
End If

Wait 2
'Verify open button exist on Choose file to upload dialog
If not waitUntilExist(objOpenButton,10) Then
	Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
	Call Terminator
End If

Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")


'Click on open file button
blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

Wait 2
Execute "Set objFileNameField = Nothing"
Execute "Set objFileSelectionPopup = Nothing"
Execute "Set objFileSelectionFileNameField = Nothing"
Execute "Set objFileSelectionSelectFile = Nothing"

Execute "Set objSignatureDate = Nothing"
Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
If not waitUntilExist(objSignatureDate,3) Then
	Call WriteToLog("Fail","Date of Signature field does not exist.")
	Call Terminator
End If

objSignatureDate.Set strSignatureDate

Call WriteToLog("Pass", "Data of Signature is updated with - " & objSignatureDate.GetROProperty("value"))
Execute "Set objSignatureDate = Nothing"

Execute "Set objFileSelectionFileDescriptionField = Nothing"
Execute "Set objFileSelectionFileDescriptionField = "  &Environment("WE_ManageDocument_FileSelection_FileDescription")

If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
	Call WriteToLog("Fail","File description field does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","File description field exist on File Selection popup")

Err.Clear
objFileSelectionFileDescriptionField.Click
objFileSelectionFileDescriptionField.Set strFileDescription 

'Call SendKeys("{TAB}")

If Err.Number<>0 Then
	Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: "&Err.Description)
	Call Terminator
End If

Wait 2

Execute "Set objFileSelectionFileDescriptionField = Nothing"

Execute "Set objOKButton = Nothing"
Execute "Set objOKButton= "  &Environment("WB_OK")
If not waitUntilExist(objOKButton,10) Then
	Call WriteToLog("Fail","OK button does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","OK button exist on File Selection popup")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

wait 5

'Verify the error pop up message
blnReturnValue = checkForPopup("GetFileDescription", "Ok", "Document Type is mandatory field.", strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Error Popup was displayed with message: Document Type is mandatory field.")
Else
	Call WriteToLog("Fail","There was no popup displayed when Document Type field is not set.")
	Call Terminator
End If

wait 2

Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"
Execute "Set objFileSelectionDocumentTypeDropdown = "  &Environment("WB_ManageDocument_FileSelection_DocumentType")
blnDocumentType=selectComboBoxItem(objFileSelectionDocumentTypeDropdown, "ACP")
If not blnDocumentType Then
	Call WriteToLog("Fail","ACP")
	Call Terminator
End If

Call WriteToLog("Pass","ACP")


Wait 3
Execute "Set objFileSelectionDocumentTypeDropdown = Nothing"

Execute "Set objOKButton = Nothing"
Execute "Set objOKButton= "  &Environment("WB_OK")
If not waitUntilExist(objOKButton,10) Then
	Call WriteToLog("Fail","OK button does not exist on File Selection popup")
	Call Terminator
End If

Call WriteToLog("Info","OK button exist on File Selection popup")

blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call Terminator
End If

wait 15
Execute "Set objOKButton = Nothing"

'========================================================================================
'Verify that file uploaded successfully message popup is visible after uploading the file
'========================================================================================

blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
	Call Terminator
End If

Call waitTillLoads("Loading...")

wait 5

'===========================================================================
'TestCase:Delete the newly uploaded document from manage document screen
'===========================================================================
blnReturnValue = DeleteNewlyUploadedDocuments(strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","DeleteNewlyUploadedDocuments returned error: "&strOutErrorDesc)
	Call Terminator		
End If

'=========================================================
'Delete all attached document from manage document screen
'=========================================================
blnReturnValue = DeleteAllManageDocuments(strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","DeleteAllManageDocuments returned error: "&strOutErrorDesc)
	Call Terminator		
End If

'=========================================================
'Upload  file type : JPG File
'=========================================================
blnReturnValue = UploadAllManageDocuments(strOutErrorDesc, "JPG")
If Not blnReturnValue Then
    Call WriteToLog("Fail","UploadAllManageDocuments returned error for PNG File: "&strOutErrorDesc)
    Call Terminator        
End If

'logout of the application
Call Logout()
CloseAllBrowsers
Call WriteLogFooter()

'kill all the used objects.
killAllObjects



Function killAllObjects()

	Execute "Set objPage = Nothing"
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
	Execute "Set objManageDocumentDataGrid  = Nothing"  
	Execute "Set objOKButton= Nothing"  
	Execute "Set objDeleteButton = Nothing"  
	
End Function


Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function
'##################################################################################################################################
'Function Name       :	clickOnSubMenu1
'Purpose of Function :	To click on sub menus
'Input Arguments     :	menu
'Output Arguments    :	None
'Example of Call     :	Call clickOnSubMenu1("Screenings->ADL Screening")
'Author              :	Sudheer
'Date                :	14-April-2015
'##################################################################################################################################
Function clickOnSubMenu1(ByVal menu)
	On Error Resume Next
	Err.Clear	
	Set objPage = getPageObject()
	
	menuArr = Split(menu,"->")
	
	For i = 0 To UBound(menuArr)
		Set menuDesc = Description.Create
		menuDesc("micclass").Value = "WebElement"
'		menuDesc("class").Value = "dropdown-.*"
'		menuDesc("class").regularExpression = True
		menuDesc("html tag").Value = "A"
		menuDesc("innertext").Value = ".*" & trim(menuArr(i)) & ".*"
		menuDesc("innertext").regularexpression = true
		
		Set objMenu = objPage.ChildObjects(menuDesc)
		If objMenu.Count = 2 Then
			objMenu(1).Click
		Else
			objMenu(0).Click
		End If
		
		Set menuDesc = Nothing
		Set objMenu = Nothing
	Next
	
	Call WriteToLog("info", "Clicked on the submenu '" & Trim(menu) & "'.")
	
	Set objPage = Nothing
	Err.Clear
End Function


'#######################################################################################################################################################################################################
'Function Name		 : UploadAllManageDocuments
'Purpose of Function : Purpose of this function is to upload different file types in Manage Document
'Input Arguments	 : FileType 
'Output Arguments	 : boolean: True or False
'					 : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call	 : blnReturnValue = UploadManageDocuments(strOutErrorDesc,"JPG")
'Author				 : Amar
'Date				 : 14-Nov-2015
'#######################################################################################################################################################################################################

Function UploadAllManageDocuments(strOutErrorDesc, ByVal TestFileType)

	strOutErrorDesc = ""
    Err.Clear
    On Error Resume Next
    UploadAllManageDocuments = False
    
    strFileUploadedPopupTitle = DataTable.Value("FileUpLoadedPopupTitle","CurrentTestCaseData")
    strFileUploadedPopupText = DataTable.Value("FileUpLoadedPopupText","CurrentTestCaseData")
    strFileDescription = DataTable.Value("FileDescription","CurrentTestCaseData")
    strDocumentType = DataTable.Value("DocumentType","CurrentTestCaseData")
    strFilePath = Environment.Value("PROJECT_FOLDER")&"\Testdata\ManageDocuments"
    strFileName = "Test_"&TestFileType&"File."&TestFileType
    strBrowseFileNameWithLocation = strFilePath&"\"&strFileName
    
    
    Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid") ' Data grid of manage document screen
    Execute "Set objDeleteButton = "  &Environment("WB_ManageDocument_DeleteButton")         ' Delete button
    Execute "Set objUploadButton = "  &Environment("WB_ManageDocument_UploadButton")
    Execute "Set objFileSelectionPopup = "  &Environment("WEL_ManageDocument_FileSelection_PopupTitle")
    Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
    Execute "Set objFileSelectionFileNameField = "  &Environment("WE_ManageDocument_FileSelection_FileName")
    Execute "Set objFileSelectionSelectFile = "  &Environment("WEL_ManageDocument_FileSelection_SelectFile")
    Execute "Set objFileSelectionFileDescriptionField = "  &Environment("WE_ManageDocument_FileSelection_FileDescription")
    Execute "Set objFileSelectionDocumentTypeDropdown = "  &Environment("WB_ManageDocument_FileSelection_DocumentType")
    Execute "Set objFileNameField = "  &Environment("WiE_ChooseFileToUpload_Dialog_FileNameField")
    Execute "Set objOpenButton = "  &Environment("WiB_ChooseFileToUpload_Dialog_OpenButton")
    Execute "Set objOKButton= "  &Environment("WB_OK")
    '==========================================================
    'Verify that manage document screen contain button Upload 
    '==========================================================
    If not waitUntilExist(objUploadButton,10) Then
        strOutErrorDesc = "Upload button does not exist on manage document screen" &strOutErrorDesc
        Exit Function
    End If
    
    Call WriteToLog("Info","Upload button exist on manage document screen")
    
    '=======================================================================
    'Click on Upload button and verify that File Seletion popup should open
    '=======================================================================
    blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
    If Not blnReturnValue Then
        strOutErrorDesc =  "ClickButton returned error: "&strOutErrorDesc
        Exit Function
        
    End If
    
    wait 2
    
    'Verify the file popup dialog exists
    If not waitUntilExist(objFileSelectionPopup,10) Then
        strOutErrorDesc = "File Seletion popup does not open successfully after clicking on upload button"  &strOutErrorDesc
        Exit Function
    End If
    
    Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")
    
    'Verify the file selection field name exists
    If not waitUntilExist(objFileSelectionFileNameField,10) Then
        strOutErrorDesc = "File name edit field does not exist on File Selection popup" &strOutErrorDesc
        Exit Function
    End If
    
    Call WriteToLog("Info","File name edit field exist on File Selection popup")
    
    If not waitUntilExist(objFileSelectionSelectFile,10) Then
        Call WriteToLog("Fail","Select file button does not exist on File Selection popup")
        Exit Function
    End If
    
    Call WriteToLog("Info","Select file button exist on File Selection popup")
    
    
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
        Exit Function
    End If
    
    Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")
    
    Err.Clear
    objFileNameField.Set strBrowseFileNameWithLocation
    If Err.Number <> 0 Then
        strOutErrorDesc = "File name edit field does not exist on choose file to upload Dialog" &strOutErrorDesc
        Exit Function
    End If
    
    Wait 2
    'Verify open button exist on Choose file to upload dialog
    If not waitUntilExist(objOpenButton,10) Then
        Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
        Exit Function
    End If
    
    Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")
    
    'Click on open file button
    blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
    If Not blnReturnValue Then
        strOutErrorDesc = "ClickButton returned error: "&strOutErrorDesc
        Exit Function
    End If
    
    Wait 2
    
        
    '==================================================================
    'Set the location of file in File Description field to some value
    '==================================================================
    
    If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
        Call WriteToLog("Fail","File description field does not exist on File Selection popup")
        Exit Function
    End If
    
    Call WriteToLog("Info","File description field exist on File Selection popup")
    
    Err.Clear
    objFileSelectionFileDescriptionField.Click
    objFileSelectionFileDescriptionField.Set "Test"&TestFileType
    
    'Call SendKeys("{TAB}")
    
    If Err.Number<>0 Then
        strOutErrorDesc = "File description does not set sucessfully in File name field. Error returned: "&strOutErrorDesc
        Exit Function
    End If
    
    Wait 2
    
    If not waitUntilExist(objSignatureDate,3) Then
		Call WriteToLog("Fail","Date of Signature field does not exist.")
		Call WriteLogFooter()
		Exit Function
	End If
    
	objSignatureDate.Set strSignatureDate
    '===========================
    'Set document type field
    '===========================
    
    If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
        Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
        Call WriteLogFooter()
        ExitAction
    End If
    
    Call WriteToLog("Info","Document Type dropdown exist on File Selection popup")
    
    blnDocumentType=selectComboBoxItem(objFileSelectionDocumentTypeDropdown, "ACP")
	If not blnDocumentType Then
	Call WriteToLog("Fail","ACP is not Set on Document type field")
	Call WriteLogFooter()
	ExitAction
	End If

	Call WriteToLog("Pass","ACP is Set on Document type field")
	
 
    Wait 2 'Wait time for application sync
    
    '======================
    'Click on OK button
    '======================
    If not waitUntilExist(objOKButton,10) Then
        Call WriteToLog("Fail","OK button does not exist on File Selection popup")
        Exit Function
    End If
    
    Call WriteToLog("Pass","OK button exist on File Selection popup")
    
    blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
    If Not blnReturnValue Then
        strOutErrorDesc = "ClickButton returned error: "&strOutErrorDesc
        Exit function
    End If
    
    wait 5
'    '========================================================================================
'    'Wait for Saving....
'    '========================================================================================
'
'    Set objPage = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
'    Set objPopup = objPage.WebElement("innertext:=Saving...", "html tag:=SPAN")
'    Dim cnt : cnt = 1
'    
'    Do while objPopup.Exist(2) = True
'        cnt = cnt + 1
'        If cnt = 30 Then
'            waitTillLoads = False
'    
'        End If
'        wait 2
'    Loop
'    
''    waitTillLoads = True
''    Set objPopup = Nothing
''    Set objPage = Nothing
    
    '========================================================================================
    'Verify that file uploaded successfully message popup is visible after uploading the file
    '========================================================================================
    Call waitTillLoads("Saving...")
    wait 6
    blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
    If blnReturnValue Then
        Call WriteToLog("Pass","File Type:" &TestFileType &" Was Uploaded Successfully")
    Else
        Call WriteToLog("Fail","File Type:" &TestFileType & " Was  not Uploaded Successfully")
        Exit function
    End If
    
    wait 3

    UploadAllManageDocuments = True
    

End Function


