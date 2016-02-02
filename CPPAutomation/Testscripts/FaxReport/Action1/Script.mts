    ''***********************************************************************************************************************************************************************
'Initialization steps for current script
''***********************************************************************************************************************************************************************
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True     'Import environment file
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "FaxReport", strOutTestName, strOutErrorDesc) 
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
'' ScriptName Name                : Medical Equipment
'' Inputs                         : 
'' Author                       : Swetha Ryali
''***********************************************************************************************************************************************************************

''=========================
'' Variable initialization
''=========================
 strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
 strDestination = DataTable.Value("Destination","CurrentTestCaseData")
 strFaxReportPopupTitle = DataTable.Value("FaxReportPopupTitle","CurrentTestCaseData")
 strFaxReportPopupText = DataTable.Value("FaxReportPopupText","CurrentTestCaseData")
 strMemberID = DataTable.Value("MemberID", "CurrentTestCaseData")

''=====================================
'' Objects required for test execution
''=====================================
  Execute "Set objPage = " & Environment("WPG_AppParent")
  Execute "Set objFaxReportButton = " & Environment("WI_FaxReport_Button")
  Execute "Set objFaxReportScreenTitle = " & Environment("WE_FaxReport_ScreenTitle")
  Execute "Set objICRRadioButton = "  &Environment("WE_Integratedcarereport_RadioButton")
  Execute "Set objMLRadioButton = "  &Environment("WE_MedcationList_RadioButton")
  Execute "Set objDestinationDropdown = "  &Environment("WB_Destination_Dropdown")
  Execute "Set objAttentionTextBox = "  &Environment("WE_Attention_Textbox")
  Execute "Set objPreviewButton = "  &Environment("WE_Preview_Button")
  Execute "Set objFaxNumberTextbox = "  &Environment("WE_FaxNumber_Textbox")
  Execute "Set objPreviewButton = "  &Environment("WE_Preview_Button")
  Execute "Set objCancelButton = "  &Environment("WE_Cancel_Button")
  Execute "Set objPreviewICRReportScreenTitle = " &Environment("WE_PreviewICRReport_ScreenTitle")
  Execute "Set objSendFaxButton = "  &Environment("WE_SendFax_Button")
 'Execute "Set objFaxReportPopup = "  &Environment("WE_FaxReport_PopupTitle")
 

'=====================================
' start test execution
'=====================================
'Login to Capella

isPass = Login("vhn")
If not isPass Then
    Call WriteToLog("Fail","Failed to Login to VHN role.")
    Call WriteLogFooter()
    ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHES role")

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
    strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
    Call WriteToLog("Fail", strOutErrorDesc)
    Call WriteLogFooter()
    ExitAction
End If

'==============================
'Open patient from action item
'==============================
'strPatientName = "Bauer, Scott"
isPass = OpenPatientProfileFromActionItemsList(strPatientName,strOutErrorDesc)
If Not isPass Then
    Call WriteToLog("Fail", "OpenPatientProfileFromActionItemsList return: " & strOutErrorDesc)
    Call WriteLogFooter()
    ExitAction
End If

wait 2

'==========================
'Click on Fax report button 
'==========================
blnReturnValue = ClickButton("Fax Report button",objFaxReportButton,strOutErrorDesc)
If Not blnReturnValue Then
    Call WriteToLog("Fail","Unable to Click on Fax report Button: "&strOutErrorDesc)
    Call WriteLogFooter()
    ExitAction
End If

'==========================================================
'Verify that Fax Report Screen open successfully
'==========================================================

If not waitUntilExist(objFaxReportScreenTitle, 10) Then
    Call WriteToLog("Fail","Unable to open Fax report Screen")
    Call WriteLogFooter()
    ExitAction
End If

objFaxReportScreenTitle.highlight
Call WriteToLog("Pass","Fax Report screen opened successfully")    

''=======================
''Click the Cancel button
''=======================
objCancelButton.click

Call WriteToLog("Pass","Fax Report screen disappers after clicking the cancel button")    

wait 2
'==========================
'Click on Fax report button 
'==========================
blnReturnValue = ClickButton("Fax Report button",objFaxReportButton,strOutErrorDesc)
If Not blnReturnValue Then
    Call WriteToLog("Fail","Unable to Click on Fax report Button: "&strOutErrorDesc)
    Call WriteLogFooter()
    ExitAction
End If

'==========================================================
'Verify that Fax Report Screen open successfully
'==========================================================

If not waitUntilExist(objFaxReportScreenTitle, 10) Then
    Call WriteToLog("Fail","Unable to open Fax report Screen")
    Call WriteLogFooter()
    ExitAction
End If

objFaxReportScreenTitle.highlight
Call WriteToLog("Pass","Fax Report screen opened successfully")    

'==========================
'Select ICR radio button
'==========================

objICRRadioButton.click

'==============================================================================
'Set Destination Dropdown field and verify the autopopulated values from the db
'==============================================================================

If not waitUntilExist(objDestinationDropdown,10) Then
    Call WriteToLog("Fail","Destination dropdown does not exist")
    Call WriteLogFooter()
    ExitAction
End If

Call WriteToLog("Pass","Destination dropdown exists")

Call selectComboBoxItem(objDestinationDropdown, strDestination)

Wait 2 


'==============================
'Get Nephrologist Info from DB
'==============================
'
If strDestination = "Nephrologist" Then

	RuntimeName = objAttentionTextBox.getROProperty("value")
	print RuntimeName
	
	isPass = ConnectDB()
	If not isPass Then
	    Print "Fail"
	    ExitAction
	End If
	
	strQuery = "select PVD_NAME from PVD_PROVIDER , MPA_MEM_PTA_ASSOCIATE where PVD_UID = MPA_PVD_UID and MPA_ASSOCIATION = 'NEPH' and MPA_DATE_END > SYSDATE and MPA_MEM_UID = (Select mem_uid from mem_member where mem_id = '" & strMemberID & "')"
	
	isPass = RunQueryRetrieveRecordSet(strQuery)
	If not isPass Then
	    Call CloseDBConnection()
	    ExitAction
	End If
	
	while not objDBRecordSet.EOF    
	    DBName = objDBRecordSet("PVD_NAME")        
	    Print DBName    
	    objDBRecordSet.MoveNext
	Wend
	
	
	If strComp(RuntimeName, DBName, 1) = 0 Then
	    objAttentionTextBox.highlight
	End If
	
	Call CloseDBConnection()

End If

'==============================
'Get Fax Number Info from DB
'==============================

'objFaxNumberTextbox.highlight
'RuntimeFaxNumber = objFaxNumberTextbox.getROProperty("value")
'print RuntimeFaxNumber
'
'isPass = ConnectDB()
'If not isPass Then
'    Print "Fail"
'    ExitAction
'End If
'strQuery2 = "select PPH_NUMBER from PVD_PROVIDER , PPH_PDR_PHONE , MPA_MEM_PTA_ASSOCIATE , PTA_PROVIDER_TEAM_ADDRESS where PPH_PTA_UID = PTA_UID and PTA_PVD_UID = PVD_UID and pph_phone_type = 'F' and PVD_NAME = "&DBName&" "
'
'isPass = RunQueryRetrieveRecordSet(strQuery)
'If not isPass Then
'    Call CloseDBConnection()
'    ExitAction
'End If
'
'while not objDBRecordSet.EOF    
'    DBName = objDBRecordSet("PVD_NAME")        
'    Print DBName    
'    objDBRecordSet.MoveNext
'Wend
'
'Call CloseDBConnection()
'
'If StrComp(RuntimeName, DBName) >= 0 Then
'            objPreviewButton.Click
'                
'            Call writeToLog("Pass","Clicked on Preview button after verification")
'            Set objButton = Nothing
'                
'            wait 3
'            Err.Clear
'            checkForPopup = True
'            popUpFound = True
'        End If
'
'End If

'=======================
'Click on Preview button 
'=======================

blnReturnValue = ClickButton("Preview button",objPreviewButton,strOutErrorDesc)
If Not blnReturnValue Then
    Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
    Call WriteLogFooter()
    ExitAction
End If

wait 2

'=========================
'Verify the Report preview
'=========================
If not waitUntilExist(objPreviewICRReportScreenTitle, 10) Then
    Call WriteToLog("Fail","Fax report Preview did not show up")
    Call WriteLogFooter()
    ExitAction
End If

objPreviewICRReportScreenTitle.highlight
Call WriteToLog("Pass","Fax Report screen opened successfully")    

'========================
'Click on Send Fax button 
'========================

blnReturnValue = ClickButton("Send Fax button",objSendFaxButton,strOutErrorDesc)
If Not blnReturnValue Then
    Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
    Call WriteLogFooter()
    ExitAction
End If

wait 2


waitTillLoads("Loading...")
'=========================================================================
'Verify that Medical Equipment Saved successfully message popup is visible 
'=========================================================================

blnReturnValue = checkForPopup(strFaxReportPopupTitle, "Ok", strFaxReportPopupText, strOutErrorDesc)
If blnReturnValue Then
    Call WriteToLog("Pass","Popup with title: "&strFaxReportPopupTitle& " and stating message: "&strFaxReportPopupText&" found successfull")
Else
    Call WriteToLog("Fail","Popup with title: "&strFaxReportPopupTitle& " and stating message: "&strFaxReportPopupText&" does not found successfull")
    Call WriteLogFooter()
    ExitAction
End If

wait 2

'logout of the application
'Call Logout()
'CloseAllBrowsers
'
'Call WriteLogFooter()

'kill all the used objects.
killAllObjects

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
    
End Function

