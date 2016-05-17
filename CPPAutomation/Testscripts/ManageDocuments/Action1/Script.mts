''***********************************************************************************************************************************************************************
'Initialization steps for current script
''***********************************************************************************************************************************************************************
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file

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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ManageDocument", strOutTestName, strOutErrorDesc) 
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

''***********************************************************************************************************************************************************************
'' ScriptName Name				: Manage Documents
'' Inputs 					    : 
'' Author                   	: Sharmila/Sudheer
''***********************************************************************************************************************************************************************

'=====================================
' Objects required for test execution
'=====================================
Function loadObjects()
	Execute "Set objPage = " & Environment("WPG_AppParent")
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
End Function

'=====================================
' start test execution
'=====================================
'Login to Capella
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	Call Logout()
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

'Close all open patient     
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'Select user roster
isPass = SelectUserRoster(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "Select UserRoster returned error: " & strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

isPass = ManageDocuments()

If not isPass Then
	Call WriteToLog("Fail", "Failed to verify manage documents functionality.")
End If

'kill all the used objects.
killAllObjects

'logout of the application
Call Logout()
CloseAllBrowsers
Call WriteLogFooter()

Function ManageDocuments()
	ManageDocuments = true
	
	Dim intWaitTime
	intWaitTime = 30
	
	'=========================
	' Variable initialization
	'=========================
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
	
	'==============================
	'Open patient from action item
	'==============================
	isPass = selectPatientFromGlobalSearch(strMemberID)
	If Not isPass Then
		Call WriteToLog("Fail", "Unable to open patient " & strPatientName)
		Call WriteLogFooter()
		ExitAction
	End If
	
	Call waitTillLoads("Loading...")

	Call WriteToLog("info", "Test Case - Navigate to Manage Documents screen and verify screen loaded.")
	Call clickOnSubMenu("Tools->Manage Documents")
	
	'wait intWaitTime
	Call waitTillLoads("Loading...")
	
	'load all objects
	loadObjects
	
	'==========================================================
	'Verify that Manage Document Screen open successfully
	'==========================================================
	objManageDocumentScreenTitle.highlight
	If not waitUntilExist(objManageDocumentScreenTitle, 10) Then
		Call WriteToLog("Fail","Unable to open Manage document Screen")
		Exit Function
	End If
	
	
	Call WriteToLog("Pass","Manage document screen opened successfully")	
	
	'============================================
	'Verify the columns of  Manage document grid.
	'============================================
	Call WriteToLog("info", "Test Case - Verify the columns of  Manage document table")
	If not waitUntilExist(objManageDocumentGrid, 10) Then
		Call WriteToLog("Fail","Manage document grid does not exist on manage document screen")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Manage document grid exist on manage document screen")
	
	
	'================================================================================================================
	'Verify that manage document grids columns names are - ;;File Type;File Name;Date Added;Description;Document Type
	'================================================================================================================
	strActualColumnNames = objManageDocumentGrid.GetROProperty("column names")
	If StrComp(strColumnNames,strActualColumnNames,vbTextCompare) = 0 Then
		Call WriteToLog("Pass","Manage document grid column names are as expected. Columns are: "&strColumnNames)
	Else
		Call WriteToLog("Fail","Manage document grid column names are not as expected. Columns are: "&strActualColumnNames)
		Exit Function		
	End If
	
	'==========================================================
	'Verify that manage document screen contain button Delete 
	'==========================================================
	Call WriteToLog("info","Test Case - Verify that manage document screen contain button Delete and verify its functionality.")
	If not waitUntilExist(objDeleteButton,10) Then
		Call WriteToLog("Fail","Delete button does not exist on manage document screen")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Delete button exist on manage document screen")
	
	'=========================================================
	'Delete all attached document from manage document screen
	'=========================================================
	blnReturnValue = DeleteAllManageDocuments(strOutErrorDesc)
	If Not blnReturnValue Then
		Call WriteToLog("Fail","DeleteAllManageDocuments returned error: "&strOutErrorDesc)
		Exit Function		
	End If
	Call WriteToLog("Pass","All documents were deleted sucessfully")
	'==========================================================
	'Verify that manage document screen contain button Upload 
	'==========================================================
	Call WriteToLog("info", "Test Case - Verify that manage document screen contain button Upload and its functionalities.")
	If not waitUntilExist(objUploadButton,10) Then
		Call WriteToLog("Fail","Upload button does not exist on manage document screen")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Upload button exist on manage document screen")
	
	Call WriteToLog("info", "Test Case - Verify document types in the drop down.")
	isPass = validateDocumentTypes()
	
	'=========================================================
	'Upload different file types : TIF File
	'=========================================================
	blnReturnValue = UploadManageDocuments(strOutErrorDesc, "TIF")
	If Not blnReturnValue Then
	    Call WriteToLog("Fail","UploadManageDocuments returned error for TIF File: "&strOutErrorDesc)
	    Exit Function        
	End If
	
	'=========================================================
	'Upload different file types : PDF File
	'=========================================================
	blnReturnValue = UploadManageDocuments(strOutErrorDesc, "PDF")
	If Not blnReturnValue Then
	    Call WriteToLog("Fail","UploadManageDocuments returned error for PDF File: "&strOutErrorDesc)
	    Exit Function        
	End If
	
	killAllObjects
	loadObjects
	
	'=======================================================================
	'Click on Upload button and verify that File Seletion popup should open
	'=======================================================================
	Call WriteToLog("info", "Test Case - Verify Upload file selection dialogue box and its functionality.")
	Call WriteToLog("info", "Verify 'GetFileDescription' message box")
	blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
	If Not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
		Exit Function
	End If
	
	Call waitTillLoads("Loading...")
	'Verify the file popup dialog exists
	If not waitUntilExist(objFileSelectionPopup,10) Then
		Call WriteToLog("Fail","File Seletion popup does not open successfully after clicking on upload button")
		Exit Function
	End If
	
	Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")
	
	'Verify the file selection field name exists
	If not waitUntilExist(objFileSelectionFileNameField,10) Then
		Call WriteToLog("Fail","File name edit field does not exist on File Selection popup")
		Exit Function
	End If
	
	Call WriteToLog("Pass","File name edit field exist on File Selection popup")
	
	If not waitUntilExist(objFileSelectionSelectFile,10) Then
		Call WriteToLog("Fail","Select file button does not exist on File Selection popup")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Select file button exist on File Selection popup")
	
	'objFileSelectionSelectFile.highlight
	
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
	
	Call WriteToLog("Pass","File name edit field exist on Choose file to upload Dialog")
	
	Err.Clear
	objFileNameField.Set strBrowseFileNameWithLocation
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","File name edit field does not exist on choose file to upload Dialog")
		Exit Function
	End If
	
	Wait 2
	'Verify open button exist on Choose file to upload dialog
	If not waitUntilExist(objOpenButton,10) Then
		Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Open button exist on Choose file to upload Dialog")
	
	'Click on open file button
	blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
	If Not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
		Exit Function
	End If
	
	Wait 2
	
	'===================================================================================
	'Set the location of file in File description field to blank and click on OK button
	'===================================================================================
	
	If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
		Call WriteToLog("Fail","File description field does not exist on File Selection popup")
		Exit Function
	End If
	
	Call WriteToLog("Pass","File description field exist on File Selection popup")
	
	Err.Clear
	objFileSelectionFileDescriptionField.Click
	objFileSelectionFileDescriptionField.Set ""
	
	'Call SendKeys("{TAB}")
	
	If Err.Number<>0 Then
		Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: " &Err.Description)
		Exit Function
	End If
	
	Wait 2
	
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
		Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	Call waitTillLoads("Loading...")
	
	'Verify the error pop up message
	blnReturnValue = checkForPopup("GetFileDescription", "Ok", "File description cannot be empty.", strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Error Popup was displayed with message: File description cannot be empty.")
	Else
		Call WriteToLog("Fail","There was no popup displayed when File Description field is blank.")
		Exit Function
	End If
	
	
	'==================================================================
	'Set the location of file in File Description field to some value
	'==================================================================
	
	If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
		Call WriteToLog("Fail","File description field does not exist on File Selection popup")
		Exit Function
	End If
	
	Call WriteToLog("Pass","File description field exist on File Selection popup")
	
	Err.Clear
	objFileSelectionFileDescriptionField.Click
	objFileSelectionFileDescriptionField.Set strFileDescription 
	
	'Call SendKeys("{TAB}")
	
	If Err.Number<>0 Then
		Call WriteToLog("Fail","File description does not set sucessfully in File name field. Error returned: "&Err.Description)
		Exit Function
	End If
	
	Wait 2
	
	'====================================================
	'Click on OK button without giving the Document Type
	'====================================================
	If not waitUntilExist(objOKButton,10) Then
		Call WriteToLog("Fail","OK button does not exist on File Selection popup")
		Exit Function
	End If
	
	Call WriteToLog("Pass","OK button exist on File Selection popup")
	
	blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
	If Not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
		Exit Function
	End If
	
	wait 4
	
	'Verify the error pop up message
	blnReturnValue = checkForPopup("GetFileDescription", "Ok", "Document Type is mandatory field.", strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Error Popup was displayed with message: Document Type is mandatory field.")
	Else
		Call WriteToLog("Fail","There was no popup displayed when Document Type field is not set.")
		Exit Function
	End If
	
	If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
		Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Document Type dropdown exist on File Selection popup")
	
	isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Medical Consents")
	If not isPass Then
		Call WriteToLog("Pass", "Medical Consents does not exist in document type drop down as expected")
	Else
		Call WriteToLog("Fail", "Medical Consents exists in document type drop down")
	End If
	'===========================
	'Set document type field
	'===========================
	isPass = ConnectDB()
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
	End If
	
	strSQLQuery = "Select PCMB_CMBD_CODE from CAPELLA.PCMB_PATIENT_COMORBIDS where PCMB_MEM_UID = (select mem_uid From MEM_MEMBER WHERE Mem_ID in ('" & strMemberID & "')) and PCMB_STATUS = 'A' and PCMB_CMBD_CODE in ('ESRD','CKD')"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	Dim diseaseState
	while not objDBRecordSet.EOF
		diseaseState = objDBRecordSet("PCMB_CMBD_CODE")
		objDBRecordSet.MoveNext
	Wend
	
	'diseaseState = "CKD"
	Call CloseDBConnection()
	
	fileDescription = "Medical Authorization - " & diseaseState
	
	Call selectComboBoxItem(objFileSelectionDocumentTypeDropdown, fileDescription)
	
	Wait 3
	
	'====================================================
	'Click on OK button without giving the Signature Date
	'====================================================
	If not waitUntilExist(objOKButton,10) Then
		Call WriteToLog("Fail","OK button does not exist on File Selection popup")
		Exit Function
	End If
	
	Call WriteToLog("Pass","OK button exist on File Selection popup")
	
	blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
	If Not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
		Exit Function
	End If
	
	wait 5
	
	'Verify the error pop up message
	blnReturnValue = checkForPopup("GetFileDescription", "Ok", "Date of Signature is a mandatory field.", strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Error Popup was displayed with message: Document Type is mandatory field.")
	Else
		Call WriteToLog("Fail","There was no popup displayed when Document Type field is not set.")
		Exit Function
	End If
	
	wait 2
	
	'===========================
	'Set the date of signature
	'===========================
	Execute "Set objSignatureDate = " & Environment.Value("WE_ManageDocument_DateOfSignature")
	If not waitUntilExist(objSignatureDate,3) Then
		Call WriteToLog("Fail","Date of Signature field does not exist.")
		Exit Function
	End If
	
	objSignatureDate.Set strSignatureDate
	
	Call WriteToLog("Pass", "Data of Signature is updated with - " & objSignatureDate.GetROProperty("value"))
	Execute "Set objSignatureDate = Nothing"
	
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
		Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
		Exit Function
	End If
	
	Call waitTillLoads("Saving...")
	
	'========================================================================================
	'Verify that file uploaded successfully message popup is visible after uploading the file
	'========================================================================================
	wait 5
	blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was displayed")
	Else
		Call WriteToLog("Fail","Popup with title: "&strFileUploadedPopupTitle& " and stating message: "&strFileUploadedPopupText&" was not found")
		Exit Function
	End If
	
	wait 5
	
	'=========================================================
	'Upload different file types : PNG File
	'=========================================================
	blnReturnValue = UploadManageDocuments(strOutErrorDesc, "PNG")
	If Not blnReturnValue Then
	    Call WriteToLog("Fail","UploadManageDocuments returned error for PNG File: "&strOutErrorDesc)
	    Exit Function        
	End If
	wait 2
	'=========================================================================================
	'Verify that after attaching the document grid successfully contains the document details
	'=========================================================================================
	Call WriteToLog("info","Test Case - Verify Manage documents data grid contains all uploaded documents with correct document details.")
	If not waitUntilExist(objManageDocumentDataGrid,10) Then
		Call WriteToLog("Fail","Manage document data grid does not exist on screen")
		Exit Function
	End If
	
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
			Else
				expirationDate = objManageDocumentDataGrid.ChildItem(i, 8, "WebElement", 0).GetROProperty("innertext")
				'modified by sudheer as part of defect D-03377
				strExpirationDate = ""	'date + 365
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
			objManageDocumentDataGrid.ChildItem(i,2,"WebElement",0).Click
			If Err.Number<>0 Then
				Call WriteToLog("Fail","Unable to click on the uploaded document" &Err.Description)
				Exit Function
			End If
			wait 2
			objViewDocument.highlight
			If not waitUntilExist(objViewDocument, 10) Then
				Call WriteToLog("Fail","Unable to open the uploaded document")
				Exit Function
			End If
			strFileTypeValue = objManageDocumentDataGrid.GetCellData(i,3)
			Call WriteToLog("Pass","File type: " & strFileTypeValue &" opened successfully in View Document dialog")
			'close the document
			Err.Clear
			objViewDocumentClose.click
			If Err.Number<>0 Then
				Call WriteToLog("Fail","Unable to close the View Document dialog" &Err.Description)
				Exit Function
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
	
	
	'=========================================================
	'Delete all attached document from manage document screen
	'=========================================================
'	blnReturnValue = DeleteAllManageDocuments(strOutErrorDesc)
'	If Not blnReturnValue Then
'		Call WriteToLog("Fail","DeleteAllManageDocuments returned error: "&strOutErrorDesc)
'		Exit Function		
'	End If
End Function

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

Function validateDocumentTypes()
	validateDocumentTypes = false
	
	'==========================================================
    'Verify that manage document screen contain button Upload 
    '==========================================================
    Execute "Set objUploadButton = "  &Environment("WB_ManageDocument_UploadButton")
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
    waitTillLoads "Loading..."
    wait 2
    
    'Verify the file popup dialog exists
    Execute "Set objFileSelectionPopup = "  &Environment("WEL_ManageDocument_FileSelection_PopupTitle")
    If not waitUntilExist(objFileSelectionPopup,10) Then
        strOutErrorDesc = "File Seletion popup does not open successfully after clicking on upload button"  &strOutErrorDesc
        Exit Function
    End If
    
    Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")
	
	'validate the document types in the dropdown
	Execute "Set objFileSelectionDocumentTypeDropdown = "  &Environment("WB_ManageDocument_FileSelection_DocumentType")
	If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
		Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
		Exit Function
	End If

	Call WriteToLog("Pass","Document Type dropdown exist on File Selection popup")
	
	isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Pneumococcal Verification")
	If not isPass Then
		Call WriteToLog("Fail", "Pneumococcal Verification does not exist in document type drop down ")
	Else
		Call WriteToLog("Pass", "Pneumococcal Verification exists in document type drop down as expected")
	End If
	
	
	isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Influenza Verification")
	If not isPass Then
		Call WriteToLog("Fail", "Influenza Verification does not exist in document type drop down ")
	Else
		Call WriteToLog("Pass", "Influenza Verification exists in document type drop down as expected")
	End If
	
	isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "ACP")
	If not isPass Then
		Call WriteToLog("Fail", "ACP does not exist in document type drop down ")
	Else
		Call WriteToLog("Pass", "ACP exists in document type drop down as expected")
	End If
	
	isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Humana Member Summary")
	If not isPass Then
		Call WriteToLog("Fail", "Humana Member Summary does not exist in document type drop down ")
	Else
		Call WriteToLog("Pass", "Humana Member Summary exists in document type drop down as expected")
	End If
	
	isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Diabetic Retinal Eye Exam Verification")
	If not isPass Then
		Call WriteToLog("Fail", "Diabetic Retinal Eye Exam Verification does not exist in document type drop down ")
	Else
		Call WriteToLog("Pass", "Diabetic Retinal Eye Exam Verification exists in document type drop down as expected")
	End If
	
	isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Florida HIE Consent Form")
	If not isPass Then
		Call WriteToLog("Fail", "Florida HIE Consent Form does not exist in document type drop down ")
	Else
		Call WriteToLog("Pass", "Florida HIE Consent Form exists in document type drop down as expected")
	End If
	
	isPass = validateValueExistInDropDown(objFileSelectionDocumentTypeDropdown, "Medical Attestation")
	If not isPass Then
		Call WriteToLog("Fail", "Medical Attestation Form does not exist in document type drop down ")
	Else
		Call WriteToLog("Pass", "Medical Attestation Form exists in document type drop down as expected")
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	blnReturnValue = checkForPopup("Medical Attestation", "No", "This document type is specific to ESCO patients. This is not an ESCO patient. Are you sure you would like to choose this document type?", strOutErrorDesc)
	If Not blnReturnValue Then
		Call WriteToLog("Fail", "Failed to click on No in message Box")
		Exit Function
	End If    
	
	wait 2
    
    selectedVal = getComboBoxSelectedValue(objFileSelectionDocumentTypeDropdown)
    If trim(selectedVal) = "Select a value" Then
    	Call WriteToLog("Pass", "Value of Document Type changed to 'Select a value' on clicking 'No' in the Medical Attestation window.")
    Else
    	Call WriteToLog("Fail", "Value of Document Type did not change to 'Select a value' on clicking 'No' in the Medical Attestation window.")
    End If
    
    Execute "Set objCancelBtn = " & Environment("WB_CancelButton")
    objCancelBtn.Click
    
    wait 2
	
	validateDocumentTypes = true
End Function
