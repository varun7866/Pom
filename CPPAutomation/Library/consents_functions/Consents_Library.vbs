'Make sure app is logged out and all browsers are closed
'Function terminatePatient(ByVal memberID)
'	On Error Resume Next
'	Err.Clear
'	terminatePatient = False
'	clickOnMainMenu("My Dashboard")
'	wait 2
'	Call waitTillLoads("Loading...")
'	wait 2
'	Set objpage = getPageObject()
'	Execute "Set objMemberId = "  & Environment("WE_SearchMemberId")
'	objMemberId.Set memberID
'	
'	Execute "Set objSearchBtn = " & Environment("WB_MemberSearch")
'	objSearchBtn.Click
'	Set objSearchBtn = Nothing
'	Set objMemberId = Nothing
'	
'	Wait 2
'	Call waitTillLoads("Loading...")
'	
'	Execute "Set objCustomMsgBoxTitle = " & Environment("WEL_MemberSearchResults")
'	If objCustomMsgBoxTitle.WaitProperty("visible",True,5000) Then
'		objCustomMsgBoxTitle.highlight
'		Set objMsg = objpage.WebElement("html tag:=SPAN", "innerhtml:=No Search results found.")
'		If objMsg.WaitProperty("visible", True, 5000) Then
'			Call WriteToLog("Fail", "No search results found for the member id - '" & memberID & "'")
'			Execute "Set objCancelBtn = " & Environment("WB_MemberSearchResultsCancel")
'			objCancelBtn.Click
'			Set objCustomMsgBoxTitle = Nothing
'        	Exit Function
'		End If		
'    End If
'	
'	Set objCustomMsgBoxTitle = Nothing
'		
'	Execute "Set objTable = " & Environment("WT_MemberSearchResultsTable")
'	objTable.ChildItem(1,1, "WebElement", 1).Click
'	Execute "Set objView = " & Environment("WB_MemberSearchView")
'	objView.Click
'	wait 2
'	Call waitTillLoads("Loading...")
'	
'	clickOnSubMenu("Member Info->Patient Info")
'	wait 2
'	Call waitTillLoads("Loading...")
'	Set objpage = Nothing
'	Set objpage = getPageObject()
'	objpage.highlight
'	Execute "Set objterminateBtn = " & Environment("WB_PatientTerminate")
'	isPass = waitUntilExist(objterminateBtn, 10)
'	objterminateBtn.Click
'	Wait 2
'	waitTillLoads "Loading..."
'	wait 2
'	Execute "Set objterminatePatient = " & Environment("WEL_TerminatePatientWindow")
'	If not objterminatePatient.WaitProperty("visible", true, 5000) Then
'		Call WriteToLog("Fail", "Failed to open the Terminate Patient window")
'		Exit Function
'	End if
'	
''	Set objReason = objPage.WebButton("html id:=resone")
''	Call selectComboBoxItem(objReason, "Patient Request")
''	wait 5
''	Set objnotified = objPage.WebButton("html id:=notified", "index:=0")
''	Call selectComboBoxItem(objnotified, "Call Center")
'	Set objDropDown = getTerminatePatientDropDown("Reason")
'	isPass = selectComboBoxItem(objDropDown, "Patient Request")
'	Set objDropDown = Nothing
'	wait 5
'	
'	Set objDropDown = getTerminatePatientDropDown("Notified By")
'	isPass = selectComboBoxItem(objDropDown, "Member")
'	Set objDropDown = Nothing
'	wait 5
'	Set objpage = Nothing
'	Set objpage = getPageObject()
'    objpage.Sync
''	objPage.WebEdit("html id:=eventDatepicker", "outerhtml:=.*data-capella-automation-id=""terminatePatient.myDate"".*").Set date - 1
'	Set dateDesc = Description.Create
'	dateDesc("micclass").Value = "WebEdit"
'	
'	Set objDate = objPage.ChildObjects(dateDesc)
'	For i = 0 To objDate.Count - 1
'		outerhtml = objDate(i).GetROPRoperty("outerhtml")
'		htmlid = objDate(i).GetROProperty("html id")
'		Print outerhtml
'		Print htmlid
'		If lcase(htmlid) = lcase("eventDatepicker") Then
'			objDate(i).highlight
'			objDate(i).Set date - 1
'		End If
'		If instr(outerhtml, "terminatePatient.myDate") > 0 Then
'			objDate(i).highlight
'			objDate(i).Set date - 1
'		End If
'	Next 
'	
'	Set dateDesc = Nothing
'	Set objDate = Nothing
'
'	wait 5
'	
'	Set objDropDown = getTerminatePatientDropDown("Detail")
'	isPass = selectComboBoxItem(objDropDown, "Patient Request")
'	Set objDropDown = Nothing
'	
'	Set objDropDown = getTerminatePatientDropDown("Supporting Details")
'	isPass = selectComboBoxItem(objDropDown, "Don't Need")
'	Set objDropDown = Nothing
'	
'	wait 10
'	
''	Set objDetails = objPage.WebButton("html id:=notified", "index:=1")
''	Call selectComboBoxItem(objDetails, "Patient Request")
''	wait 5
''	Set objSupportingDetails = objPage.WebButton("html id:=notified", "index:=2")
''	Call selectComboBoxItem(objSupportingDetails, "Don't need")
'	Execute "Set objSaveBtn = " & Environment("WB_PatientTerminateSave")
'	objSaveBtn.Click
'	
'	wait 5
'	Call waitTillLoads("Loading...")
'	
'	isPass = checkForPopup("Your changes have been saved successfully.", "Ok", "Member has been Termed.", strOutErrorDesc)
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to terminate the patient.")
'		Exit Function
'	End If
'	
'	terminatePatient = True
'	Set objTable = Nothing
'	Set objPage = Nothing
'End Function
'
Function validateMedicalAuthorization(ByVal reqStatus)
	
	Dim taskMsg : taskMsg = "Authorization " & reqStatus
	Dim taskColor
	
	wait 2

	Call clickOnSubMenu("Patient Snapshot")
	wait 2
	
	Select Case LCase(reqStatus)
		Case "not on file"
			taskColor = "RED"
		Case "current"
			taskColor = "GREEN"
		Case "expired"
			taskColor = "RED"
	End Select
	
	'==============================
	'Validate Medical Authorization status to be 'Not on file'
	Call WriteToLog("info", "Validate Medical Authorization status to be '" & reqStatus & "'")
	'=============================
	medAuthStatus = getValueFromPatientProfileScreen("MEDICAL AUTHORIZATION")
	If Not (trim(lcase(medAuthStatus)) = lcase(reqStatus)) Then
		Call WriteToLog("Fail", "Expected Medical Authorization status is - '" & reqStatus & "'. But UI shows - '" & medAuthStatus & "'.")
	End If
	Call WriteToLog("Pass", "Medical Authorization status is as expected - '" & reqStatus & "'")
	
	'==============================
	'Check if Authorization task exists in General Program and is 'Authorization Not on file'
'	Call WriteToLog("info", "Check if Authorization task exists in General Program and is '"& taskMsg & "'")
	'=============================
'	task = getFullTaskDetails("General Program", "Authorization")
'	If trim(lcase(task)) = lcase(taskMsg) Then
'		Call WriteToLog("Pass", "The task in General Program is as expected - '" & trim(task) & "'")
'	Else
'		Call WriteToLog("Fail", "The task in General Program is - '" & trim(task) & "' and the expected value is '" & taskMsg & "'.")
'	End If
'	
'	'==============================
'	'Check if Authorization Not on File task in General Program has RED color
'	Call WriteToLog("info", "Check if Authorization Not on File task in General Program has RED color")
'	'=============================
'	colorStatus = getTaskStatus("General Program", "Authorization")
'	If trim(lcase(colorStatus)) = lcase(taskColor) Then
'		Call WriteToLog("Pass", "The color status in General Program is as expected - '" & trim(colorStatus) & "'")
'	Else
'		Call WriteToLog("Fail", "The color status in General Program is - '" & trim(colorStatus) & "' and the expected value is '" & taskColor & "'.")
'	End If
	
	
End Function

Function materialFulfillment()
	materialFulfillment = false
	On Error Resume Next
	
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
	Execute "Set objDomainTaskDropDown = " & Environment("WB_MaterialFulFillment_DomainTopicDropDown")
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
	
	
	'==============================
	'Material Fullfilment
	Call WriteToLog("info", "Material Fulfillments")
	'=============================
	Call clickOnSubMenu("Tools->Material Fulfillment")
	
	wait 2
	Call waitTillLoads("Loading...")
	
	If waitUntilExist(objMaterialFulfillmentTitle, 10) Then
		objMaterialFulfillmentTitle.highlight
		Call WriteToLog("Pass","Material Fulfillment Screen opened successfully")
	Else
		Call WriteToLog("Fail","Expected Result: Open Material Fulfillment Screen; Actual Result: Unable to open Material Fulfillment Screen")
		Exit Function
	End If
	
	If Not objReviewOrder.Exist(5) Then
		Set NewOrderDesc = Description.Create
		NewOrderDesc("micclass").Value = "WebElement"
		NewOrderDesc("html tag").Value = "DIV"
		NewOrderDesc("innertext").Value = ".*New Order.*"
		Set objNewOrderDesc = objPage.ChildObjects(NewOrderDesc)
		
		objNewOrderDesc(0).Click
		
		Set objNewOrderDesc = Nothing
		Set NewOrderDesc = Nothing
	End If
	
	
	'=================================================================================
	'Test Case - Verify Review order button is disabled, when topic is not selected.
	'=================================================================================
	Call WriteToLog("Info","==========Testcase - Verify Review order button is disabled, when topic is not selected.==========")
	
	If waitUntilExist(objReviewOrder, 10) Then
		strDisableProperty = objReviewOrder.Object.isDisabled
		If strDisableProperty Then
			Call WriteToLog("Pass", "Review Order button is Disabled when the topic is not selected")	
		Else
			Call WriteToLog("Fail", "Expected Result: Review Order button should be disabled; Actual Result: Review Order button is Enabled.")	
			Exit Function
		End If		
	Else
		Call WriteToLog("Fail", "Expected Result: Review Order button should be disabled; Actual Result:Review Order does not exist ")
		Exit Function
	End If
	
	'Set date to Date Requested field
	If waitUntilExist(objDateRequested, 10) Then
		objDateRequested.set Date - 2
		Call WriteToLog("Pass", "Date Requested field set to today's date")
	End If
	
	'set fulfilled date
	If waitUntilExist(objDateRequested, 10) Then
		objDateFulfilled.set Date - 2
		Call WriteToLog("Pass", "Date Requested field set to today's date")
	End If
	
	'set fulfilled by
	strFulfilledBy = DataTable.Value("FulfilledBy", "CurrentTestCaseData")
	isPass = selectComboBoxItem(objFulfilledBy, strFulfilledBy)
	If not isPass Then
		Call WriteToLog("Fail", "failed to set Fulfilled by to - '" & strFulfilledBy & "'")
		Exit Function
	End If
	Call WriteToLog("Pass", "Fulfilled by set to - '" & strFulfilledBy & "'")
	
	'Set Domain Dropdown value from the testdata
	strDomainDropDown = DataTable.Value("DomainDropDown", "CurrentTestCaseData")
	If waitUntilExist(objDomainDropDown, 10) Then
		call selectComboBoxItem(objDomainDropDown, strDomainDropDown)
		If not isPass Then
			Call WriteToLog("Fail", "Failed to select the value in drop down.")
			Exit Function
		End If
		Call WriteToLog("Pass", "Domain dropdown values are set")
	Else
		Call WriteToLog("Fail", "Expected Result:Domain dropdown values are set; Actual Result: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Set domain task
	If waitUntilExist(objDomainTaskDropDown, 10) Then
		isPass = selectComboBoxItem(objDomainTaskDropDown, "Authorization")
		If not isPass Then
			Call WriteToLog("Fail", "Required task is not selected")
			Exit Function
		End If
		Call WriteToLog("Pass", "Task is selected")
	End If
	
	'validate if the required authorization topic appeared in the table, ESRD/CKD
	Dim intRowCount
	If waitUntilExist(objSelectTable, 10) Then
		Call WriteToLog("Pass", "Material Fulfillment table exists")
		intRowCount = objSelectTable.RowCount	
	Else
		Call WriteToLog("Fail", "Expected Result: Material Fulfillment table should exist.; Actual Reusllt: Material Fulfillment table does not exist")
		Exit Function
	End If
	
	'Select the value given by the User
	If intRowCount = 0 Then
		Call WriteToLog("Fail", "No rows displayed for the selection")
		Exit Function
	End If
	
	Dim strInputDescription : strInputDescription = "NA"
	Dim isSelected : isSelected = false
	For intCount = 1 To intRowCount
		strGetTopicValue = objSelectTable.GetCellData(intCount, 6)
		strTopic = objSelectTable.GetCellData(intCount, 3)
		If instr(strTopic, "Authorization") > 0 Then
			If instr(strGetTopicValue, "Request for and Authorization to Release Medical Records or Health Information") > 0 Then
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
		Call WriteToLog("Fail", "Required authorization topic not found. material not requested")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Required authorization topic is checked")
	
	If waitUntilExist(objFollowUpYES, 10) Then
		Call WriteToLog("Pass", "Follow-up check box is checked by default as required")
	Else
		Call WriteToLog("Fail", "Follow-up check box is NOT checked by default as expected.")
		objFollowUpNO.click
	End If
	
	'Click on Review order button
	blnReturnValue = ClickButton("Review", objReviewOrder, strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: Review Order button is enabled; Actual Result: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Verify Complete Order Button exists
	If waitUntilExist(objCompleteOrder, 10) Then
		Call WriteToLog("Pass", "Complete order button is Enabled ")	
	Else
		Call WriteToLog("Fail","Complete Order button does not exist")
		Exit Function
	End If
	
	
	'Click on the Ok button of Complete Order pop up
	blnReturnValue = ClickButton("Complete",objCompleteOrder,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: Complete Order button should be clicked; Actual Result: Unable to click on Comple order button: " & strOutErrorDesc)
		Exit Function
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
		Exit Function	
	End If	
	
	Call WriteToLog("Info","==========Testcase - Verify the Order placed is updated under Materials Fulfillment History==========")
	'======================================================================================
	'TestCase - Verify the Order placed is updated under Materials Fulfillment History
	'======================================================================================
	'Check the page is landed in Material Fulfillment History
	
	Set objPage = getPageObject()
	Set upArrow = objPage.Image("file name:=arrow-up.png","html tag:=IMG")
	
	upArrow.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	If Not objOrderList.Exist(3) Then
		Call WriteToLog("Fail", "User is NOT redirected to the Material Fulfillment History Screen by default as expected.")
		Set HistoryDesc = Description.Create
		HistoryDesc("micclass").Value = "WebElement"
		HistoryDesc("html tag").Value = "DIV"
		HistoryDesc("innertext").Value = "Materials Fulfillment History "
		Set objMaterialHistory = objPage.ChildObjects(HistoryDesc)
		objMaterialHistory(0).Click
		
		wait 2
		
	Else
		Call WriteToLog("Pass", "User is redirected to the Material Fulfillment History Screen by default as expected.")
	End If
	
	'Verify if the order list exists in the Materials Fulfillment History Screen.
	If waitUntilExist(objOrderList, 10) Then
		Call WriteToLog("Pass", "Order List  exists in the screen")	
	Else
		Call WriteToLog("Fail","Expected result:Order list exists on screen; Actual Result: Order list does not exist under Material Fulfillment History Screen")
		Exit Function
	End If
	
	strOrderText = objOrderList.getROProperty("innertext")
	strSplit = Split(strOrderText," ")
	COrderDate = CDate(trim(strSplit(2)))
	
	i=0 
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
		
		If COrderDate = Date - 2 and objFollowupSave.Exist(5) Then
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
	
	If not isFound Then
		Call WriteToLog("Fail", "Required order not found.")
		Exit Function
	End If
	
	'Set date to Date Followup field
	If waitUntilExist(objFollowupDate, 10) Then
		objFollowupDate.set Date - 2
		Call WriteToLog("Pass", "Date Followup field set to today date")
	Else
		Call WriteToLog("Fail", "Expected Result: Values are set to Date Follow-up field; Actual Result:Date Requested field does not exist" & strOutErrorDesc)
		Exit Function
	End If 
	
	
	If waitUntilExist(objFollowupSave, 10) Then
		Call WriteToLog("info", "Save Button for follow-up exists")	
	Else
		Call WriteToLog("Fail","Expected Result:Save Button for follow-up exists; Actual Result:Save Button for follow-up does not exist")
		Exit Function	
	End If
	
	objFollowupDropDown.highlight
	'Set Followup Dropdown value from the testdata
	If waitUntilExist(objFollowupDropDown, 10) Then
		isPass = selectComboBoxItem(objFollowupDropDown, strFulfilledBy)
		If not isPass Then
			Call WriteToLog("Fail", "Failed to select value Follow-up dropdown")
			Exit Function
		End If
		Call WriteToLog("Pass", "Follow-up dropdown values are set")
	Else
		Call WriteToLog("Fail", "Expected Result: Follow-up dropdown values are set; Actual Result: Follow-up dropdown does not exist" & strOutErrorDesc)
		Exit Function
	End If 
	
	'Click on the Ok button of Complete Order pop up
	blnReturnValue = ClickButton("Save",objFollowupSave,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: Click on Save button; Actual Result: Unable to click on Save button:" & strOutErrorDesc)
		Exit Function
	End If
	wait 10
	Call waitTillLoads("Saving...")
	blnReturnValue = checkForPopup(strPopupTitle, "Ok", strPopupText, strOutErrorDesc)
	
	wait 5
	If blnReturnValue Then
		Call WriteToLog("Pass","Order was saved successfully")
	Else
		Call WriteToLog("Fail","Order Saved successfully message box does not exist/ failed to click OK button on the message box.")	
		Exit Function
	End If	
	materialFulfillment = True
End Function

Function createNewPatient()
	On Error Resume Next
	Err.Clear
	
	createNewPatient = "NA"
	
	intWaitTime  = 20
	'Check the existence of First Name field of Member Search 
	Execute "Set objFirstNameField = " & Environment("WE_SearchMemberFirstName")
	If objFirstNameField.Exist(intWaitTime) Then
		Call WriteToLog("Pass", "First Name field exist.")
	Else
		Call WriteToLog("Fail", "First Name field does not exist.")
		Call WriteLogFooter()
		Exitaction
	End If
	
	'Set value to First Name field
	strFirstName = "Automation"
	Err.clear
	objFirstNameField.set strFirstName
	If Err.Number = 0 Then
		Call WriteToLog("Pass", strFirstName & "is set to First Name field.")
	Else
		Call WriteToLog("Fail",strFirstName & "is not set to First Name field.")
		Exit Function
	End If
	
	'Click on the Search button field
	Execute "Set objSearchBtn = " & Environment("WB_MemberSearch")
	blnReturnValue = ClickButton("Search",objSearchBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "ClickButton returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	WaitTillLoads "Loading..."
	wait 2
	
	'Check the existence of the Member Search Result 
	Execute "Set objMemberSearchResult = " & Environment("WEL_MemberSearchResults")
	If objMemberSearchResult.Exist(intWaitTime) Then
		Call WriteToLog("Pass", "Member Search Result field exist.")
	Else
		Call WriteToLog("Fail", "Member Search Result field does not exist.")
		Exit Function
	End If
	
	'Click on the New Referral button field
	Execute "Set objNewReferralBtn = " & Environment("WB_MemberSearchNewReferral")
	blnReturnValue = ClickButton("New Referral",objNewReferralBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "ClickButton returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	Execute "Set objReferralTitle = " & Environment("WEL_ReferralManagementTitle")
		
	'set referral date
	Execute "Set objReferralDate = " & Environment("WE_ReferralDate")
	objReferralDate.Set date-5
	
	'set referral received date
	Execute "Set objReferralReceivedDate = " & Environment("WE_ReferralReceivedDate")
	objReferralReceivedDate.Set date-5
	
	'set application date
	Execute "Set objApplicationDate = " & Environment("WE_ApplicationDate")
	objApplicationDate.Set date-5
	
	wait(intWaitTime)
		
	'Select value from Referring Payor dropdown
	Execute "Set objPayorDropDown = " & Environment("WB_PayorDropDown")
	strPayor = DataTable.Value("ReferringPayor","CurrentTestCaseData")
	blnReturnValue = selectComboBoxItem(objPayorDropDown, strPayor)
	If blnReturnValue Then
		Call WriteToLog("Pass", strReferringPayorValue & " value is selected from Equipment Type field.")
	Else
		Call WriteToLog("Fail", strReferringPayorValue & "value is not selected from Equipment Type field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	wait 2
	
	'Select value from Disease State dropdown
	strDiseaseState = DataTable.Value("DiseaseState","CurrentTestCaseData")
	Set objDiseaseState = getComboBoxReferralManagement("Disease State")
	blnReturnValue = selectComboBoxItem(objDiseaseState, strDiseaseState)
	If blnReturnValue Then
		Call WriteToLog("Pass", strDiseaseStateValue & " value is selected from Equipment Type field.")
	Else
		Call WriteToLog("Fail", strDiseaseStateValue & "value is not selected from Equipment Type field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	wait 2
	'select value for line of business
	strLOB = DataTable.Value("LOB","CurrentTestCaseData")
	Set objLOB = getComboBoxReferralManagement("Line Of Buisness")
	blnReturnValue = selectComboBoxItem(objLOB, strLOB)
	If blnReturnValue Then
		Call WriteToLog("Pass", strLineOfBuisnessValue & " value is selected from Equipment Type field.")
	Else
		Call WriteToLog("Fail", strLineOfBuisnessValue & "value is not selected from Equipment Type field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	wait 2
	'Select value from Service Type dropdown
	strServiceType = DataTable.Value("ServiceType","CurrentTestCaseData")
	Set objServiceType = getComboBoxReferralManagement("ServiceType")
	blnReturnValue = selectComboBoxItem(objServiceType, strServiceType)
	If blnReturnValue Then
		Call WriteToLog("Pass", strServiceTypeValue & " value is selected from Equipment Type field.")
	Else
		Call WriteToLog("Fail", strServiceTypeValue & "value is not selected from Equipment Type field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	wait 2
	'Select value from Source dropdown
	strSource = DataTable.Value("Source","CurrentTestCaseData")
	Set objSource = getComboBoxReferralManagement("Source")
	blnReturnValue = selectComboBoxItem(objSource, strSource)
	If blnReturnValue Then
		Call WriteToLog("Pass", strServiceTypeValue & " value is selected from Equipment Type field.")
	Else
		Call WriteToLog("Fail", strServiceTypeValue & "value is not selected from Equipment Type field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Click on the Save button
	Execute "Set objSaveBtn = " & Environment("WB_NewReferralSave")
	blnReturnValue = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "ClickButton returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	'set value to Last Name field
	strLastName = "Sheik"
	Execute "Set objLastName = " & Environment("WE_LastName")
	Err.Clear
	strLastName = strLastName & RandomNumber(1,999)
	objLastName.set strLastName
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strLastName & "is set to Last Name field")
	Else
		Call WriteToLog("Fail", strLastName & "is not set to Last Name field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'set date to Date of Birth field (Date of Birth should be minimum 10 years or maximum 105 years.)
	Execute "Set objDOB = " & Environment("WE_DOB")
	Randomize	'Initialize random-number generator.
	dtmStartDate = DateValue("01/01/1960")
	dtmEndDate = DateValue("12/31/1987")
	dtmRandomDate = DateValue((dtmEndDate - dtmStartDate + 1) * Rnd + dtmStartDate)
	
	strDOB = dtmRandomDate			'DataTable.Value("DOB","CurrentTestCaseData")	'"03/02/1976"
	Err.Clear
	objDOB.set strDOB
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strDOB & "is set to Date Of Birth field")
	Else
		Call WriteToLog("Fail", strDOB & "is not set to Date Of Birth field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Set address to Address field
	Execute "Set objAddress = " & Environment("WE_Address")
	strAddress = DataTable.Value("Address","CurrentTestCaseData")	'"Test Address"
	Err.Clear
	objAddress.set strAddress
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strAddress & "is set to Address field")
	Else
		Call WriteToLog("Fail", strAddress & "is not set to Address field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Set value to City field
	Execute "Set objCity = " & Environment("WE_City")
	strCity = DataTable.Value("City","CurrentTestCaseData")	'"Alpine"
	Err.Clear
	objCity.set strCity
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strCity & "is set to City field")
	Else
		Call WriteToLog("Fail", strCity & "is not set to City field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Select value from State dropdown
	Execute "Set objState = " & Environment("WB_StateDropDown")
	strStateValue = DataTable.Value("State","CurrentTestCaseData")	'"California"
	blnReturnValue = selectComboBoxItem(objState, strStateValue)
	'blnReturnValue = SelectDropDownValue ("WB_MemberSearchResults_StateBtn","WEL_MemberSearchResults_StateDropdown","micclass;Link|html tag;A",strStateValue, strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass", strStateValue & " value is selected from Equipment Type field.")
	Else
		Call WriteToLog("Fail", strStateValue & "value is not selected from Equipment Type field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Set value to Zip field
	Execute "Set objZip = " & Environment("WE_Zip")
	strZipValue = DataTable.Value("Zip","CurrentTestCaseData")	'"91901"
	Err.Clear
	objZip.set strZipValue
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strZipValue & "is set to Zip field")
	Else
		Call WriteToLog("Fail", strZipValue & "is not set to Zip field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Set value to Home Phone field
	Err.Clear
	Execute "Set objHomePhone = " & Environment("WE_HomePhone")
	strHomePhone = DataTable.Value("HomePhone","CurrentTestCaseData")	'"1234567891"
	objHomePhone.set strHomePhone
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strHomePhone & "is set to Home Phone field")
	Else
		Call WriteToLog("Fail", strHomePhone & "is not set to Home Phone field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Select value from Primary Phone field
	Execute "Set objPrimaryPhone = " & Environment("WB_PrimaryPhoneDropDown")
	strPrimaryPhone = DataTable.Value("PrimaryPhone","CurrentTestCaseData")	'"Home"
	blnReturnValue = selectComboBoxItem(objPrimaryPhone, strPrimaryPhone)
	If blnReturnValue Then
		Call WriteToLog("Pass", strPrimaryPhone & " value is selected from Primary Phone field.")
	Else
		Call WriteToLog("Fail", strPrimaryPhone & "value is not selected from Primary Phone field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Select value from Language field
	Execute "Set objLanguage = " & Environment("WB_LanguageDropDown")
	strLanguage = DataTable.Value("Language","CurrentTestCaseData")	'"English"
	blnReturnValue = selectComboBoxItem(objLanguage, strLanguage)
	'blnReturnValue = SelectDropDownValue ("WB_MemberSearchResults_LanguageBtn","WEL_MemberSearchResults_LanguageDropdown","micclass;Link|html tag;A",strLanguage, strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass", strLanguage & " value is selected from Language field.")
	Else
		Call WriteToLog("Fail", strLanguage & "value is not selected from Language field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Select value from Gender field
	Execute "Set objGender = " & Environment("WB_GenderDropDown")
	strGender = DataTable.Value("Gender","CurrentTestCaseData")	'"Male"
	blnReturnValue = selectComboBoxItem(objGender, strGender)
	'blnReturnValue = SelectDropDownValue ("WB_MemberSearchResults_GenderBtn","WEL_MemberSearchResults_GenderDropdown","micclass;Link|html tag;A",strGender, strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass", strGender & " value is selected from Gender field.")
	Else
		Call WriteToLog("Fail", strGender & "value is not selected from Gender field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Set Policy Number to Group/Policy Number field
	Err.Clear
	Execute "Set objGroupPolicyNumber = " & Environment("WE_GroupPloicy")
	strGroupPolicyNumber = DataTable.Value("PolicyNumber","CurrentTestCaseData")	'"123545"
	objGroupPolicyNumber.set strGroupPolicyNumber
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strGroupPolicyNumber & "is set to Group/Policy Number field")
	Else
		Call WriteToLog("Fail", strGroupPolicyNumber & "is not set to Group/Policy Number field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Click on the Save button
	Execute "Set objSaveNewPatientData = " & Environment("WEL_NewPatientSaveBtn")
	blnReturnValue = ClickButton("Save",objSaveNewPatientData,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "ClickButton returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	wait 5
	Call waittillLoads("Loading...")
	wait 2
	'Check the message box having title as "The Changes have been saved successfully" 
	strMessageTitle = "The Changes have been saved successfully"
	strMessageBoxText = "Member added successfully."
	blnReturnValue = checkForPopup(strMessageTitle, "Ok", strMessageBoxText, strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "CheckMessageBoxExist returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	wait 5
	Call waittillLoads("Loading...")
	wait 2
	
	'Check the existence of the Status field on Enrollment screen 
	Execute "Set objEnrollmentStatus = " & Environment("WEL_EnrollStatus")
	If not objEnrollmentStatus.Exist(intWaitTime) Then
		Call WriteToLog("Fail", "Status field on Enrollment screen does not exist" & strOutErrorDesc)
		Exit Function
	End If
	
	'Check the patient status should be reffered 
	strEnrollmentStatus = DataTable.Value("ExpectedEPSStatus", "CurrentTestCaseData")
	strPatientStatus = objEnrollmentStatus.getRoProperty("innertext")
	If Trim(strPatientStatus) = Trim(strEnrollmentStatus) Then
		Call WriteToLog("Pass","Patient is created successfully with status " & strPatientStatus )
	Else	
		Call WriteToLog("Fail","Patient is not created successfully. The status shows is '" & strPatientStatus & "', expected is '" & strEnrollmentStatus & "'.")
		Exit Function
	End If
	
	'Check the Member Id of the patient
	Execute "Set objMemberId = " & Environment("WEL_MemberID")
	Dim strMemberId
	If objMemberId.Exist(intWait) Then
		strMemberId = objMemberId.getRoProperty("innertext")
		Call WriteToLog("Pass","Patient created succesfully with Member Id - '" & strMemberId & "'")
	Else	
		Call WriteToLog("Fail","Member Id does not exist.")
		Exit Function
	End If
	
	createNewPatient = strMemberId
End Function


Function enrollmentScreening()
	Execute "Set objEnrollmentScreeningTitle = " & Environment("WEL_EnrolScreenLabel")
	enrollmentScreening = false
	''==================================================
	''Verify that Enrollment screening open successfully
	''==================================================
	If waitUntilExist(objEnrollmentScreeningTitle, 10) Then
		Call WriteToLog("Pass","Enrollment screening opened successfully")
	Else
		Call WriteToLog("Fail","Enrollment screening not opened successfully")
		Exit Function
	End If
	
	'=======================================
	'Verify the existance of Screening Date
	'=======================================
	Execute "Set objEnrollmentScreeningDate= " & Environment("WE_EnrollmentScreeningDate")
	If waitUntilExist(objEnrollmentScreeningDate,10) Then
		Call WriteToLog("Pass","Screening date exist on Enrollment screening")		
	Else
		Call WriteToLog("Fail","Screening date not exist on Enrollment screening")
		Exit Function
	End If
	'objEnrollmentScreeningDate.Set date-5
	wait 2
	'============================================================
	'Verify the number of question of Enrollment screening screen
	'============================================================
	'=====================================
	'Question 1
	'=====================================
	getPageObject().WebElement("outerhtml:=.*data-capella-automation-id=""Q_0_O_0"".*").Click
	wait 1
	getPageObject().WebElement("outerhtml:=.*data-capella-automation-id=""Q_0_O_1"".*").Click
	wait 1			
	'=====================================			
	'End of Question 1	
	'=====================================
	'Question 2
	'=====================================
	Call screeningRadioCheck("2", "Yes")
	'getPageObject().WebElement("outerhtml:=.*data-capella-automation-id=""Q_1_O_Yes"".*", "class:=screening-check-box screening-question-answer-text ng-scope").highlight
	''=====================================
	'End of Question 2	
	''=====================================
	'Question 3
	''=====================================
	Call screeningRadioCheck("3", "Yes")
	
	''=====================================
	'End of Question 3	
	''=====================================
	'Question 4
	''=====================================
	Call screeningRadioCheck("4", "Enrolled")
	''=====================================
	'End of Question 4
	''=====================================
	'Question 4a
	''=====================================
	Call screeningRadioCheck("5", "Auto ARN")
	''=====================================
	'End of Question 4a
	''=====================================
	'Question 7
	''=====================================
	Call screeningRadioCheck("8", "Yes")
	''=====================================
	'End of Question 7
	''=====================================
	'Question 8
	''=====================================
	Set objQuestion6 = getPageObject().WebButton("outerhtml:=.*data-capella-automation-id=""Q_8_O_Select a value"".*", "html id:=option-dropdown")
	objQuestion6.highlight
	isPass = selectComboBoxItem(objQuestion6, "Brother")
	''=====================================
	'End of Question 8
	''=====================================
	''Question 9
	'''=====================================
	Call screeningRadioCheck("10", "Yes")
	'''=====================================
	''End of Question 9
	''=====================================
	'Save the screening
	getPageObject().WebElement("innertext:= Save", "html tag:=DIV").Click
	wait 5
	Call waitTillLoads("Loading...")
	
	isPass = checkForPopup("Enrollment Screening", "Ok", "Screening has been saved successfully", strOutErrorDesc)
	Call waitTillLoads("Loading...")
	If err.Number <> 0 Then
		Exit Function
	End If
	enrollmentScreening = True
End Function
Function screeningRadioCheck(ByVal questionNumber, ByVal optionValue)
	
	reqVal = "Q_" & questionNumber-1 & "_O_" & optionValue
	Set desc = Description.Create
	desc("micclass").Value = "WebElement"
	desc("class").Value = "circular-radio screening-question-answer-text"
	
	Set objDesc = getPageObject().ChildObjects(desc)
	
	For i = 0 To objDesc.Count - 1
		qChk = objDesc(i).getROProperty("outerhtml")
	'	Print qChk
		If instr(qchk, reqVal) > 0 Then
			objDesc(i).Click
		End If
	Next
	
	Set desc = Nothing
	Set objDesc = Nothing
	
End Function


Function getTerminatePatientDropDown(ByVal fieldName)
	Err.Clear
	Dim autoId
	Select Case fieldName
		Case "Reason"
			autoId = "terminatePatient.selectedRole"
		Case "Notified By"
			autoId = "terminatePatient.selectedNotifiedBy"
		Case "Detail"
			autoId = "terminatePatient.selectedDetail"
		Case "Supporting Details"
			autoId = "terminatePatient.selectedSupportingTermDetail"
	End Select
	Set objPage = getPageObject()
	Set desc = Description.Create
	desc("micclass").Value = "WebElement"
	desc("class").Value = "dropdown"
	
	Set objDesc = objPage.ChildObjects(desc)
	For i = 0 To objDesc.Count - 1
		outerhtml = objDesc(i).GetROPRoperty("outerhtml")
		If instr(outerhtml, autoId) > 0 Then
			objDesc(i).highlight
			Set getTerminatePatientDropDown = objDesc(i)
		End If
	Next 
		
	Set desc = Nothing
	Set objDesc = Nothing
	Set objPage = Nothing	
End Function
