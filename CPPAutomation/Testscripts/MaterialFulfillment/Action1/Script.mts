'**************************************************************************************************************************************************************************
' TestCase Name			: Material Fulfillment Screen
' Purpose of TC			: To verify all the functionality of the Matrial Fulfillment screen, Including placing order for Medicla Authorization Form.
' Author                : Sharmila
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "MaterialFulfillment", strOutTestName, strOutErrorDesc) 
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
'strPatientName = DataTable.Value("PatientName", "CurrentTestCaseData")
strDomainDropDown = DataTable.Value("DomainDropDown", "CurrentTestCaseData")
strTopicCheckBox = DataTable.Value("TopicCheckBox", "CurrentTestCaseData")
strFulfilledBy = DataTable.Value("FulfilledBy", "CurrentTestCaseData")
strAddress1 = DataTable.Value("Address1", "CurrentTestCaseData")
strCity = DataTable.Value("City", "CurrentTestCaseData")
strState = DataTable.Value("State", "CurrentTestCaseData")
strZipcode = DataTable.Value("Zipcode", "CurrentTestCaseData")
strPopupTitle = DataTable.Value("ChangesSavedPopUpTitle", "CurrentTestCaseData")
strPopupText = DataTable.Value("ChangesSavedPopUpText", "CurrentTestCaseData")
strInputDescription = DataTable.Value("ItemDescription", "CurrentTestCaseData")
strValidationMessage = ""
strMemberID = DataTable.Value("MemberID", "CurrentTestCaseData")	'"116168"
''=====================================
'' Objects required for test execution
''=====================================
Execute "Set objPage = " & Environment("WPG_AppParent")
Execute "Set objReviewOrder = " & Environment("WEL_MaterialFulFillment_ReviewOrder")
Execute "Set objSelectTable = " & Environment("WT_MaterialFulFillment_SelectTable")
Execute "Set objDateRequested = " & Environment("WE_MaterialFulFillment_DateRequested")   
Execute "Set objMaterialFulfillmentTitle = " & Environment("WEL_MaterialFulFillment_Title") 
Execute "Set objCompleteOrder= " & Environment("WB_MaterialFulFillment_CompleteOrder")
Execute "Set objCancelOrder= " & Environment("WB_MaterialFulFillment_CancelOrder")
Execute "Set objDateFulfilled= " & Environment("WE_MaterialFulFillment_DateFullfilled")
Execute "Set objFollowUpNO= " & Environment("WEL_MaterialFulFillment_FollowupNO")
Execute "Set objFollowUpYES= " & Environment("WEL_MaterialFulFillment_FollowupYES")
Execute "Set objDomainDropDown= " & Environment("WB_MaterialFulFillment_DomainDropDown")
Execute "Set objFulfilledBy= " & Environment("WB_MaterialFulFillment_FulfilledbyDropDown")
Execute "Set objAddressEdit= " & Environment("WEL_MaterialFulFillment_EditButton")
Execute "Set objAddress1= " & Environment("WE_MaterialFulFillment_Address1")
Execute "Set objCity= " & Environment("WE_MaterialFulFillment_City")
Execute "Set objStateDropDown= " & Environment("WB_MaterialFulFillment_StateDropDown")
Execute "Set objZipcode= " & Environment("WE_MaterialFulFillment_ZipCode")
Execute "Set objOrderList = " & Environment("WEL_MaterialFulFillment_OrderList")
Execute "Set objItemsOrdered = " & Environment("WEL_MaterialFulFillment_ItemsOrdered")
Execute "Set objFollowupDate = " & Environment("WE_MaterialFulFillment_FollowupDate")
Execute "Set objFollowupDropDown = " & Environment("WB_MaterialFulFillment_FollowupDropDown")
Execute "Set objFollowupSave = " & Environment("WB_MaterialFulFillment_FollowupSaveButton")
''=====================================
'' start test execution
''=====================================
'Login to Capella

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
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
	strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'==============================
'Open patient from action item
'==============================

isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "Unable to open patient " & strPatientName)
	Call WriteLogFooter()
	ExitAction
End If
wait 2
Call waitTillLoads("Loading...")


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
'Call WriteToLog("Pass", "The current disease state of the patient is - '" & diseaseState & "'.")

Call clickOnSubMenu("Tools->Material Fulfillment")

wait 2
Call waitTillLoads("Loading...")

'==========================================================
'Verify that Material Fulfillment Screen open successfully
'==========================================================
Call WriteToLog("Info","==========Testcase - Verify Material Fulfillment Screen open successfully.==========")


If waitUntilExist(objMaterialFulfillmentTitle, 10) Then
	objMaterialFulfillmentTitle.highlight
	Call WriteToLog("Pass","Material Fulfillment Screen opened successfully")
Else
	Call WriteToLog("Fail","Expected Result: Open Material Fulfillment Screen; Actual Result: Unable to open Material Fulfillment Screen")
	Call WriteLogFooter()
	ExitAction
End If

'Set date to Date Requested field
If waitUntilExist(objDateRequested, 10) Then
	objDateRequested.set Date
	Call WriteToLog("Pass", "Date Requested field set to today's date")
Else
	Call WriteToLog("Fail", "Expected Result: Date Requested field exist; Actual Result: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If 

Call WriteToLog("Info","==========Testcase - Verify Review order button is disabled, when topic is not selected.==========")
'=================================================================================
'Test Case - Verify Review order button is disabled, when topic is not selected.
'=================================================================================

If waitUntilExist(objReviewOrder, 10) Then
	strDisableProperty = objReviewOrder.Object.isDisabled
	If strDisableProperty Then
		Call WriteToLog("Pass", "Review Order button is Disabled when the topic is not selected")	
	Else
		Call WriteToLog("Fail", "Expected Result: Review Order button should be disabled; Actual Result: Review Order button is Enabled.")
		Logout
		CloseAllBrowsers
		WriteLogFooter
		ExitAction
	End If		
Else
	Call WriteToLog("Fail", "Expected Result: Review Order button should be disabled; Actual Result:Review Order does not exist ")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If


'Set Domain Dropdown value from the testdata
If waitUntilExist(objDomainDropDown, 10) Then
	call selectComboBoxItem(objDomainDropDown, strDomainDropDown)
	Call WriteToLog("Pass", "Domain dropdown values are set")
Else
	Call WriteToLog("Fail", "Expected Result:Domain dropdown values are set; Actual Result: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If 


'Get the row count of the table
If waitUntilExist(objSelectTable, 10) Then
	Call WriteToLog("Pass", "Material Fulfillment table exists")
	intRowCount = objSelectTable.RowCount	
Else
	Call WriteToLog("Fail", "Expected Result: Material Fulfillment table should exist.; Actual Reusllt: Material Fulfillment table does not exist")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

'Select the value given by the User
Dim strInputDescription : strInputDescription = "NA"
Dim isSelected : isSelected = false
For intCount = 1 To intRowCount
	strGetTopicValue = objSelectTable.GetCellData(intCount, 6)
	strTopic = objSelectTable.GetCellData(intCount, 3)
	If instr(strTopic, "Authorization") > 0 Then
		If instr(strGetTopicValue, strTopicCheckBox) > 0 Then
			If Instr(strGetTopicValue, Environment("CURRENT_DS")) > 0 Then
				objSelectTable.ChildItem(intCount,1,"WebElement",1).Click
				isSelected = true
				strInputDescription = strGetTopicValue
				Exit For
			End If	
		End If
	End If		
Next

If not isSelected Then
	Call WriteToLog("Fail", "Expected Result: "& strTopicCheckBox &" should be checked; Actual Result: Unable to find topic: " & strTopicCheckBox)	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

Call WriteToLog("Info","==========Testcase - Verify by clicking on the cancel button, Cancels the order==========")
'========================================================================
'Test Case - Verify by clicking on the cancel button, Cancels the order
'========================================================================
'Once selecting the value for the order, click on the review button and 'In the review order dialog, click on the cancel button.

'Click on Review order button
Execute "Set objReviewOrder = " & Environment("WEL_MaterialFulFillment_ReviewOrder")
blnReturnValue = ClickButton("Review",objReviewOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Review Order button is enabled; Actual Result: " & strOutErrorDesc)
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	Exitaction
End If
wait 2
waitTillLoads "Loading..."
wait 2
'Verify Cancel Order Button exists
If waitUntilExist(objCancelOrder, 10) Then
	Call WriteToLog("Pass", "Cancel Order button exists")	
Else
	Call WriteToLog("Fail","Expected Result: Cancel Order button exist; Actual Result: Cancel order button does not exist")
	Call WriteLogFooter()
	Exitaction	
End If

'Click on the Ok button of Complete Order pop up
blnReturnValue = ClickButton("Cancel",objCancelOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Click on the Cancel button; Actual Result: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If
wait 2
Call waitTillLoads("Loading...")
wait 2
Call WriteToLog("Pass", "Cancel Order button was clicked successfully")	


Set newDesc = Description.Create
newDesc("micclass").Value = "WebElement"
newDesc("html tag").Value = "DIV"
newDesc("innertext").Value = "New Order"
Set objnewOrder = objPage.ChildObjects(newDesc)

strScreenHeaderName = objnewOrder(0).getROProperty("innertext")

'Verify if the screen still stays at the New Order Page
If trim(strScreenHeaderName) = "New Order" Then
	Call WriteToLog("Pass", "User is redirected to the New Order Screen")
Else
	Call WriteToLog("Fail", "Expected Result: New order screen should be loaded; Actual Result: User is not redirected to the New Order Screen")
	Call WriteLogFooter()
	Exitaction	
End If

Execute "Set newDesc = Nothing"
Execute "Set objnewOrder = Nothing"
Execute "Set objReviewOrder = Nothing"

Execute "Set objReviewOrder = " & Environment("WEL_MaterialFulFillment_ReviewOrder")
Execute "Set objPage = Nothing"
Set objPage = getPageObject()



Call WriteToLog("Info","==========Testcase - Set the Date Fulfilled less than Date Requested and Fulfilled by as blank.==========")
'====================================================================================
'Test Case - Set the Date Fulfilled less than Date Requested. Fulfilled by as blank
'====================================================================================

'Set date to Date fulfilled field
strDateFulfilled = Date-1
If waitUntilExist(objDateFulfilled, 10) Then
	objDateFulfilled.set strDateFulfilled
	Call WriteToLog("Pass", "Date Fulfilled field set to less than today's date")
Else
	Call WriteToLog("Fail", "Expected Result: Date Fulfilled value is set; Actual Result: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If 

'Click on Review order button
blnReturnValue = ClickButton("Review",objReviewOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result:click on Review Order button; Actual Result: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If

'Verify Complete Order Button exists
If waitUntilExist(objCompleteOrder, 10) Then
	Call WriteToLog("Pass", "Complete order button is Enabled ")	
Else
	Call WriteToLog("Fail","Expected Result: Complete Order button exists; Actual Result: Complete Order button does not exist")
	Call WriteLogFooter()
	Exitaction	
End If


'Click on the Ok button of Complete Order pop up
blnReturnValue = ClickButton("Complete",objCompleteOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: click on Complete Order button; Actual Result:" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If
wait 2
Call waitTillLoads("Loading...")

strValidationMessage = " 'Date Fulfilled' and 'Fulfilled By' should be provided. ; ; 'DateFulfilled' can not be earlier than 'DateRequested'. "


'click on Complete order button will thrown an error since there date fulfilled is less than date requested.
blnReturnValue = checkForPopup("Invalid Data", "Ok", strValidationMessage , strOutErrorDesc)

wait 2
Call waitTillLoads("Loading...")
If blnReturnValue Then
	Call WriteToLog("Pass","Validation Error: Date Fulfilled is less than Date Requested and Fulfilled By should be provided.")
Else
	Call WriteToLog("Fail","Expected Result: Popup message for Date Fulfilled value less than Date Requested should be displayed; Actual Result: " & strOutErrorDesc)	
	Call WriteLogFooter()
	Exitaction	
End If	

Set newDesc = Description.Create
newDesc("micclass").Value = "WebElement"
newDesc("html tag").Value = "DIV"
newDesc("innertext").Value = "New Order"
Set objnewOrder = objPage.ChildObjects(newDesc)

strScreenHeaderName = objnewOrder(0).getROProperty("innertext")

'Verify if the screen still stays at the same spot
If trim(strScreenHeaderName) = "New Order" Then
	Call WriteToLog("Pass", "User is redirected to the New Order Screen")
Else
	Call WriteToLog("Fail", "User is not redirected to the New Order Screen")
	Call WriteLogFooter()
	Exitaction	
End If

Execute "Set newDesc = Nothing"
Execute "Set objnewOrder = Nothing"
Execute "Set objReviewOrder = Nothing"
Execute "Set objCompleteOrder = Nothing"

Execute "Set objReviewOrder = " & Environment("WEL_MaterialFulFillment_ReviewOrder")
Execute "Set objCompleteOrder= " & Environment("WB_MaterialFulFillment_CompleteOrder")
Execute "Set objPage = Nothing"
Set objPage = getPageObject()
strValidationMessage = ""



Call WriteToLog("Info","==========Testcase - Set the Date Fulfilled less than 7 days and set Fulfilled By drop down.==========")
'===================================================================================
'Test Case - Set the Date Fulfilled less than 7 days and set Fulfilled By drop down
'===================================================================================

'Set date to Date fulfilled field
strDateFulfilled = Date-8
If waitUntilExist(objDateFulfilled, 10) Then
	objDateFulfilled.set strDateFulfilled
	Call WriteToLog("Pass", "Date Fulfilled field set to less than 7 days date")
Else
	Call WriteToLog("Fail", "Expected Result: Date Fulfilled field value should be set; Actual Result: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If 


'Set FulfilledBy Dropdown value from the testdata
If waitUntilExist(objFulfilledBy, 10) Then
	call selectComboBoxItem(objFulfilledBy, strFulfilledBy)
	Call WriteToLog("Pass", "Fulfilled By dropdown values set")
Else
	Call WriteToLog("Fail", "Expected Result: Fulfilled By values set; Actual Result: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If 

'Click on Review order button
blnReturnValue = ClickButton("Review",objReviewOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Unable to click on Review button:  " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If

'Verify Complete Order Button exists
If waitUntilExist(objCompleteOrder, 10) Then
	Call WriteToLog("Pass", "Complete order button is Enabled ")	
Else
	Call WriteToLog("Fail","Complete Order button does not exist")
	Call WriteLogFooter()
	Exitaction	
End If


'Click on the Ok button of Complete Order pop up
blnReturnValue = ClickButton("Complete",objCompleteOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Unable to click on Complete Order button::  " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If
wait 2
Call waitTillLoads("Loading...")

strValidationMessage = "'DateFulfilled' cannot be older than 7 days from today's date and cannot be greater than today's date. "


'click on Complete order button will thrown an error since there date fulfilled is less than date requested.
blnReturnValue = checkForPopup("Invalid Data", "Ok", strValidationMessage, strOutErrorDesc)

wait 2
Call waitTillLoads("Loading...")
If blnReturnValue Then
	Call WriteToLog("Pass","Validation Error: Date fulfilled cannot be older than 7 days from today's date and cannot be greater than today's date.")
Else
	Call WriteToLog("Fail","Expected Result: Popup message for Date fulfilled cannot be older than 7 days should be displayed; Actual Result:" & strOutErrorDesc)	
	Call WriteLogFooter()
	Exitaction	
End If	

Set newDesc = Description.Create
newDesc("micclass").Value = "WebElement"
newDesc("html tag").Value = "DIV"
newDesc("innertext").Value = "New Order"
Set objnewOrder = objPage.ChildObjects(newDesc)

strScreenHeaderName = objnewOrder(0).getROProperty("innertext")

'Verify if the screen still stays at the same spot
If trim(strScreenHeaderName) = "New Order" Then
	Call WriteToLog("Pass", "User is redirected to the New Order Screen")
Else
	Call WriteToLog("Fail", "User is not redirected to the New Order Screen")
	Call WriteLogFooter()
	Exitaction	
End If

Execute "Set newDesc = Nothing"
Execute "Set objnewOrder = Nothing"
Execute "Set objReviewOrder = Nothing"
Execute "Set objCompleteOrder = Nothing"

Execute "Set objReviewOrder = " & Environment("WEL_MaterialFulFillment_ReviewOrder")
Execute "Set objCompleteOrder= " & Environment("WB_MaterialFulFillment_CompleteOrder")
Execute "Set objPage = Nothing"
Set objPage = getPageObject()
strValidationMessage = ""



Call WriteToLog("Info","==========Testcase - Set the Date Fulfilled with Correct value==========")
'===========================================================================================
'Test Case - Set the Date Fulfilled , same as Requested date and Fulfilled BY value is set.
'===========================================================================================

'Set date to Date fulfilled field
strDateFulfilled = Date
If waitUntilExist(objDateFulfilled, 10) Then
	objDateFulfilled.set strDateFulfilled
	Call WriteToLog("Pass", "Date Requested field set to today date")
Else
	Call WriteToLog("Fail", "Expected Result:Date Requested field exists; Actual Result:" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If 




'Verify the Followup is checked by default for Medical Authorization form
Dim isClicked : isClicked = false
If strTopicCheckBox <> "Authorization" Then
	If objFollowUpYES.Exist(2) Then
		Call WriteToLog("Pass", "Follow-up check box should be checked by default")
		isClicked = true
	ElseIf objFollowUpNO.Exist(2) Then
		Call WriteToLog("Fail", "Expected Result: By Default Follow-up check box should be checked; Actual Result: follow up check box is not checked.")
		objFollowUpNO.Click
		isClicked = true
	End If
Else
	If objFollowUpNO.Exist(2) Then
		Call WriteToLog("Pass", "Follow-up check box is not checked by default")
	ElseIf objFollowUpYES.Exist(2) Then
		Call WriteToLog("Fail", "Expected Result: By Default Follow-up check box should be not be checked; Actual Result: follow up check box is checked." )
	End If
End If

If isClicked Then
	objFollowUpYES.Click
	wait 2
	waitTillLoads("Loading...")
	
	'click on Complete order button will thrown an error since there is no shipping address
	blnReturnValue = checkForPopup("Follow-Up required", "Ok", "Follow-Up required when Authorization topic is selected.", strOutErrorDesc)
	
	wait 2
	If blnReturnValue Then
		Call WriteToLog("Pass","Follow-Up required error is captured.")
	Else
		Call WriteToLog("Fail","Expected Result: Follow-Up required error is not present.")	
		Call WriteLogFooter()
		Exitaction	
	End If	
	
End If

'If strTopicCheckBox = "Empowerment" Then
'	objFollowUpNO.click
'	If waitUntilExist(objFollowUpYES, 10) Then
'		Call WriteToLog("Pass", "Follow-up check box should be checked by default")
'	Else
'		Call WriteToLog("Fail", "Expected Result: By Default Follow-up check box should be checked; Actual Result:" & strOutErrorDesc)
'		Call WriteLogFooter()
'		Exitaction
'	End If 
'Else
'	If waitUntilExist(objFollowUpNO, 10) Then
'		objFollowUpNO.click
'		Call WriteToLog("Pass", "Follow up checkbox is checked")
'	Else
'		Call WriteToLog("Fail", "Expected Result: Follow up checkbox is checked; Actual Result: Follow-up Check box not checked. - " & strOutErrorDesc)
'	End If 
'End If


'Verify if the ReviewOrder button is enabled
If waitUntilExist(objReviewOrder, 10) Then
	strDisableProperty = objReviewOrder.Object.isDisabled
	If not(strDisableProperty) Then
		Call WriteToLog("Pass", "Review Order button is Enabled ")	
	Else
		Call WriteToLog("Fail", "Expected Result:Review Order button is enabled; Actual Result: Review Order button is disabled")	
	End If		
Else
	Call WriteToLog("Fail", "Expected Result:Review Order button should be enabled; Actual Result: Review Order button is disabled")
	Call WriteLogFooter()
	Exitaction
End If

'Set shipping address to temporary value.
If not waitUntilExist(objAddressEdit, 10) Then
	Call WriteToLog("Fail", "Unable to find the Edit Button" & strOutErrorDesc)
End If

'click on Edit button
blnReturnValue = ClickButton("Edit", objAddressEdit,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Unable to click on the Edit button:  " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If



Call WriteToLog("Info","==========Testcase - Set the Address/city/zip field to blank==========")
'==========================================================
'Test Case - Set the Address/city/zip field to blank
'==========================================================

'Set the Address/city/zip field to blank
objAddress1.Set ""
objCity.Set ""
objZipcode.Set ""


'Click on Review order button
blnReturnValue = ClickButton("Review",objReviewOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Review Order button should be clicked; Actual Result: Unable to click on Review order button:  " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If

Execute "Set objPage = Nothing"
Set objPage = getPageObject()

'Creating pbjects for New order Header since there were 
Set newDesc = Description.Create
newDesc("micclass").Value = "WebElement"
newDesc("html tag").Value = "DIV"
newDesc("innertext").Value = "New Order"
Set objnewOrder = objPage.ChildObjects(newDesc)

strScreenHeaderName = objnewOrder(0).getROProperty("innertext")


'Verify if the screen still stays at the same spot
If trim(strScreenHeaderName) = "New Order" Then
	Call WriteToLog("Pass", "Cannot send the order without proper shipping address")
Else
	Call WriteToLog("Fail", "Expected Result: User should not able to send the order; Actual Result: Able to send the order even without shipping address")
End If

Call WriteToLog("Info","==========Testcase - Set only the Address field to blank==========")
'==========================================================
'Test Case - Set only the Address field to blank
'==========================================================

'Set only the Address field to blank
objAddress1.Set ""
objCity.Set strCity
call selectComboBoxItem(objStateDropDown, strState)
objZipcode.Set strZipcode



If not waitUntilExist(objReviewOrder, 10) Then
	Call WriteToLog("Fail", "Unable to find the Review Button" & strOutErrorDesc)
End If

'Click on Review order button again
blnReturnValue = ClickButton("Review",objReviewOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Review Order button should be clicked; Actual Result: Unable to click on Review order button:" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If

'Verify Complete Order Button exists
If waitUntilExist(objCompleteOrder, 10) Then
	Call WriteToLog("Pass", "Complete order button is Enabled ")	
Else
	Call WriteToLog("Fail","Complete Order button does not exist")
	Call WriteLogFooter()
	Exitaction	
End If


'Click on the Ok button of Complete Order pop up
blnReturnValue = ClickButton("Complete",objCompleteOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Complete Order button should be clicked; Actual Result: Unable to click on Comple order button: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If
wait 2
Call waitTillLoads("Loading...")


'click on Complete order button will thrown an error since there is no shipping address
blnReturnValue = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)

wait 2
If blnReturnValue Then
	Call WriteToLog("Pass","Validation Error popup was captured for Blank Address field.")
Else
	Call WriteToLog("Fail","Expected Result: Validation Error popup Blank Address field should be displayed.; Actual Result: " & strOutErrorDesc)	
	Call WriteLogFooter()
	Exitaction	
End If	

'Verify if the screen still stays at the same spot
If trim(strScreenHeaderName) = "New Order" Then
	Call WriteToLog("Pass", "User is redirected to the New Order Screen")
Else
	Call WriteToLog("Fail", "User is not redirected to the New Order Screen")
	Call WriteLogFooter()
	Exitaction	
End If
'
Execute "Set newDesc = Nothing"
Execute "Set objnewOrder = Nothing"
Execute "Set objReviewOrder = Nothing"
Execute "Set objCompleteOrder = Nothing"

Execute "Set objReviewOrder = " & Environment("WEL_MaterialFulFillment_ReviewOrder")
Execute "Set objCompleteOrder= " & Environment("WB_MaterialFulFillment_CompleteOrder")


Call WriteToLog("Info","==========Testcase - set the Address fields with correct data==========")
'==========================================================
'Test Case - set the Address fields with correct data
'==========================================================

'set the Address fields with correct data
objAddress1.Set strAddress1
objCity.Set strCity
call selectComboBoxItem(objStateDropDown, strState)
objZipcode.Set strZipcode


If not waitUntilExist(objReviewOrder, 10) Then
	Call WriteToLog("Fail","Review Order button does not exist")
End If

'Click on Review order button again
blnReturnValue = ClickButton("Review",objReviewOrder,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Review Order button should be clicked; Actual Result: Unable to click on Review order button:" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If


If not waitUntilExist(objCompleteOrder, 10) Then
	Call WriteToLog("Fail","Complete Order button does not exist")
End If
'Click on the Ok button of Complete Order pop up
blnReturnValue = ClickButton("Complete",objCompleteOrder,strOutErrorDesc)
wait 2
Call waitTillLoads("Loading...")
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Complete Order button should be clicked; Actual Result: Unable to click on Complete order button:" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If
wait 2
Call waitTillLoads("Loading...")

blnReturnValue = checkForPopup(strPopupTitle, "Ok", strPopupText, strOutErrorDesc)

wait 2
Call waitTillLoads("Loading...")
If blnReturnValue Then
	Call WriteToLog("Pass","Order was saved successfully")
Else
	Call WriteToLog("Fail","Expected Result: Order was saved successfully; Actual Result: Order was not saved successfully")	
	Call WriteLogFooter()
	Exitaction	
End If	


Call WriteToLog("Info","==========Testcase - Verify the Order placed is updated under Materials Fulfillment History==========")
'======================================================================================
'TestCase - Verify the Order placed is updated under Materials Fulfillment History
'======================================================================================
'after the HF 11/18 fix, kendo upgrade, the history screen is not automatically loaded. so these changes
Set objPage = getPageObject()
Set upArrow = objPage.Image("file name:=arrow-up.png","html tag:=IMG")

upArrow.Click

wait 2
waitTillLoads "Loading..."
wait 2

'Check the page is landed in Material Fulfillment History
Set HistoryDesc = Description.Create
HistoryDesc("micclass").Value = "WebElement"
HistoryDesc("html tag").Value = "DIV"
HistoryDesc("innertext").Value = "Materials Fulfillment History "
Set objMaterialHistory = objPage.ChildObjects(HistoryDesc)


strHistoryHeaderName = objMaterialHistory(0).getROProperty("innertext")

'Verify if the screen still stays at the same spot
If trim(strHistoryHeaderName) = "Materials Fulfillment History" Then
	Call WriteToLog("Pass", "User is redirected to the Material Fulfillment History Screen")
Else
	Call WriteToLog("Fail", "Expected Result: User redirected to the Material Fulfillment History Screen; Actual Result:User is not redirected to the Material Fulfillment History Screen")
End If

'Verify if the order list exists in the Materials Fulfillment History Screen.
If waitUntilExist(objOrderList, 10) Then
	Call WriteToLog("Pass", "Order List  exists in the screen")	
Else
	Call WriteToLog("Fail","Expected result:Order list exists on screen; Actual Result: Order list does not exist under Material Fulfillment History Screen")
	Call WriteLogFooter()
	Exitaction	
End If

'strOrderText = objOrderList.getROProperty("innertext")
'strSplit = Split(strOrderText," ")
'COrderDate = CDate(trim(strSplit(2)))
i=0 
'Do Until COrderDate < Date
'	
'	objOrderList.setToProperty "html id", "div" &i
'	strOrderText = objOrderList.getROProperty("innertext")
'	strSplit = Split(strOrderText," ")
'	COrderDate = CDate(trim(strSplit(2)))
'	If COrderDate = Date Then
'		objOrderList.click
'		wait 2
'		If err.number<> 0 Then
'			Call WriteToLog("Fail","Unabe to click on the Order List:" &err.description)
'			Call WriteLogFooter()
'			Exitaction
'		End If
'		Execute "Set objItemsOrdered = " & Environment("WEL_MaterialFulFillment_ItemsOrdered")
'		If not waitUntilExist(objItemsOrdered, 10) Then
'			Call WriteToLog("Fail","Expected Result:Items Ordered was found; Actual Result:Items Ordered does not exist")
'		End If
'		objItemsOrdered.highlight
'		strItemDescription = objItemsOrdered.getROProperty("innertext")
'		If trim(strItemDescription) = strInputDescription Then
'			Call WriteToLog("Pass","Items Ordered was found")
'			Exit Do
'		End If
'	End If
'	i = i+1
'	strItemDescription = ""
'	Execute "Set objItemsOrdered = Nothing" 
'Loop
strInputDescription = Environment("CURRENT_DS") & " Request for and Authorization to Release Medical Records or Health Information"
Dim isFound : isFound = False
Do while isFound = False
	Err.Clear
	objOrderList.setToProperty "html id", "div" &i
	strOrderText = objOrderList.getROProperty("innertext")
	If Err.Number <> 0 Then
		Exit Do
	End If
	strSplit = Split(strOrderText," ")
	COrderDate = CDate(trim(strSplit(2)))
	objOrderList.click
	wait 2
	
	If COrderDate = Date and objFollowupSave.Exist(5) Then
		If err.number<> 0 Then
			Call WriteToLog("Fail","Unabe to click on the Order List:" &err.description)
			Exit Do
		End If
'		Execute "Set objItemsOrdered = " & Environment("WEL_MaterialFulFillment_ItemsOrdered")
		Execute "Set objRequestedDate = " & Environment("WEL_MFSaved_RequestedDate")
		Execute "Set objRequestedName = " & Environment("WEL_MFSaved_RequestedName")
		Execute "Set objFulfilledDate = " & Environment("WEL_MFSaved_FulfilledDate")
		Execute "Set objFulfilledName = " & Environment("WEL_MFSaved_FulfilledName")
		
		If trim(objRequestedDate.GetROProperty("innerhtml")) = "" Then
			Call WriteToLog("Fail", "Requested Date in BLANK in the Order History.")
		End If
		If trim(objRequestedName.GetROProperty("innerhtml")) = "" Then
			Call WriteToLog("Fail", "Requested Name in BLANK in the Order History.")
		End If
		If trim(objFulfilledDate.GetROProperty("innerhtml")) = "" Then
			Call WriteToLog("Fail", "Fulfilled Date in BLANK in the Order History.")
		End If
		If trim(objFulfilledName.GetROProperty("innerhtml")) = "" Then
			Call WriteToLog("Fail", "Fulfilled Name in BLANK in the Order History.")
		End If
		
		Set itemsOrderedDesc = Description.Create
		itemsOrderedDesc("micclass").Value = "WebElement"
		itemsOrderedDesc("class").Value = ".*items-order-listItem"
		itemsOrderedDesc("html tag").Value = "SPAN"
		
		Set objItems = getPageObject().ChildObjects(itemsOrderedDesc)
		If objItems.Count = 0 Then
			Call WriteToLog("Fail","Expected Result:Items Ordered was found; Actual Result:Items Ordered does not exist")
			isFound = False
			Exit Do
		End If
		
		For itemRow = 0 To objItems.Count - 1
			strItemDescription = objItems(itemRow).getROProperty("innertext")
			If Instr(trim(strItemDescription), strInputDescription) > 0 Then
				Call WriteToLog("Pass","Items Ordered was found")
				isFound = true
				Exit Do
			End If
		Next
		
	End If
	i = i + 1
	strItemDescription = ""
	Execute "Set objItemsOrdered = Nothing" 
	Execute "Set objRequestedDate = Nothing"
	Execute "Set objRequestedName = Nothing"
	Execute "Set objFulfilledDate = Nothing"
	Execute "Set objFulfilledName = Nothing"
Loop



	
Call WriteToLog("Info", "==========Testcase - Verify for popup message when an invalid follow-up date is entered under Materials Fulfillment History==========")

'==================================================================================================================
'TestCase - Verify for popup message when an invalid follow-up date is entered under Materials Fulfillment History
'==================================================================================================================

'Set date to Date Followup field
'objFollowupDate.highlight
If waitUntilExist(objFollowupDate, 10) Then
	objFollowupDate.set Date-8
	Call WriteToLog("Pass", "Date Followup field set to date older than 7 days")
Else
	Call WriteToLog("Fail", "Expected Result: Values are set to Date Follow-up field; Actual Result: Date Follow-up field does not exist" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If 

'objFollowupDropDown.highlight
'Set Followup Dropdown value from the testdata
If waitUntilExist(objFollowupDropDown, 10) Then
	call selectComboBoxItem(objFollowupDropDown, strFulfilledBy)
	Call WriteToLog("Pass", "Follow-up dropdown values are set")
Else
	Call WriteToLog("Fail", "Expected Result: Follow-up dropdown values are set; Actual Result: Follow-up dropdown does not exist" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If 

'objFollowupSave.highlight
If waitUntilExist(objFollowupSave, 10) Then
	Call WriteToLog("info", "Save Button for follow-up exists")	
Else
	Call WriteToLog("Fail","Expected Result:Save Button for follow-up exists; Actual Result:Save Button for follow-up does not exist")
	Call WriteLogFooter()
	Exitaction	
End If

'Click on the Save button
blnReturnValue = ClickButton("Save",objFollowupSave,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Click on Save button; Actual Result: Unable to click on Save button: " & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If
wait 2

strValidationMessage = " 'DateFollowUp' cannot be older than 7 days from today's date and cannot be greater than today's date. ; ; 'DateFollowUp' can not be earlier than 'DateRequested'. "


'click on Complete order button will thrown an error since there date followup is less than date requested.
blnReturnValue = checkForPopup("Invalid Data", "Ok", strValidationMessage , strOutErrorDesc)

wait 2
If blnReturnValue Then
	Call WriteToLog("Pass","Validation Error: DateFollowUp is less than Date Requested and DateFollowUp cannot be older than 7 days from today's date")
Else
	Call WriteToLog("Fail","Expected Result:Error message should be displayed for Invalid Date Followed by field.; Actual Result: " & strOutErrorDesc)	
	Call WriteLogFooter()
	Exitaction	
End If	


'Verify if the screen still stays at the same spot
If trim(strHistoryHeaderName) = "Materials Fulfillment History" Then
	Call WriteToLog("Pass", "User is redirected to the Material Fulfillment History Screen")
Else
	Call WriteToLog("Fail", "Expected Result:User is redirected to the Material Fulfillment History Screen; Actual Result: User is not redirected to the Material Fulfillment History Screen")
End If

wait 2



Call WriteToLog("Info", "==========Testcase - Verify follow-up date set to today's date and It was successfully saved==========")

'====================================================================================
'TestCase - Verify follow-up date set to today's date and It was successfully saved
'====================================================================================

'Set date to Date Followup field
If waitUntilExist(objFollowupDate, 10) Then
	objFollowupDate.set Date
	Call WriteToLog("Pass", "Date Followup field set to today date")
Else
	Call WriteToLog("Fail", "Expected Result: Values are set to Date Follow-up field; Actual Result:Date Requested field does not exist" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If 


If waitUntilExist(objFollowupSave, 10) Then
	Call WriteToLog("info", "Save Button for follow-up exists")	
Else
	Call WriteToLog("Fail","Expected Result:Save Button for follow-up exists; Actual Result:Save Button for follow-up does not exist")
	Call WriteLogFooter()
	Exitaction	
End If

'Click on the Ok button of Complete Order pop up
blnReturnValue = ClickButton("Save",objFollowupSave,strOutErrorDesc)
If not(blnReturnValue) Then
	Call WriteToLog("Fail", "Expected Result: Click on Save button; Actual Result: Unable to click on Save button:" & strOutErrorDesc)
	Call WriteLogFooter()
	Exitaction
End If
wait 2
Call waitTillLoads("Saving...")

blnReturnValue = checkForPopup(strPopupTitle, "Ok", strPopupText, strOutErrorDesc)

wait 2
If blnReturnValue Then
	Call WriteToLog("Pass","Order was saved successfully")
Else
	Call WriteToLog("Fail","Expected Result: Order was saved successfully; Actual Result: Order was not saved successfully")	
	Call WriteLogFooter()
	Exitaction	
End If	


'logout of the application
Call Logout()
CloseAllBrowsers

Call WriteLogFooter()

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
	
End Function



