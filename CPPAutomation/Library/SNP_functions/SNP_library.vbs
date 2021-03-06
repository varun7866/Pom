'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: TE_ButtonInitialStatus
'Purpose	  		: Validate initial status on Transplan Evaluation screen buttons and also pathway report 
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			    	: strOutErrorDesc: String value which contains detail error message is error occured
'Example of Call    : Call TE_ButtonInitialStatus(dtCompletedDate)
'Author 	  		: Gregory
'Date               : 29 September 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
Function TE_ButtonInitialStatus()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TE_ButtonInitialStatus = False
	
	Execute "Set objTE_Init_Page = " & Environment("WPG_AppParent")
	Execute "Set objTE_Init_AddBtn = " & Environment("WEL_TE_Add")
	Execute "Set objTE_Init_PotponeBtn = " & Environment("WEL_TE_Postpone")
	Execute "Set objTE_Init_SaveBtn = " & Environment("WEL_TE_Save")
	Execute "Set objTE_Init_CancelBtn = " & Environment("WEL_TE_Cancel")
	Execute "Set objTE_Init_HistoryBtn = " & Environment("WEL_TE_History")	
	Execute "Set objTE_Init_PatwayReportHistoryHdr = " & Environment("WI_TE_PatwayReportHistoryHdr")
	Execute "Set objTE_Init_PatwayReportHistoryClose = " & Environment("WI_TE_PatwayReportHistoryClose")
	
	'Validating ADD btn
		If objTE_Init_AddBtn.exist(1) Then
			blnTE_AddClicked = ClickButton("Add",objTE_Init_AddBtn,strOutErrorDesc)
			If not blnTE_AddClicked Then
				strOutErrorDesc = "Unable to click Transplant Evaluation Add button"
				Exit function
			End If
			Call WriteToLog("Pass", "Clicked on Transplant Evaluation Add button")
			Wait 2
			
			Call waitTillLoads("Loading...")
			Call waitTillLoads("Loading Med Reviews...")
			Wait 2			
			
			'Validating initial status of Postpone,Save and Cancel buttons
			'After clicking Add button (and before answering any pathway questions) Postpone and Save btns sould be disabled; Cancel btn should be enabled 
			If not objTE_Init_PotponeBtn.Object.isDisabled AND not objTE_Init_SaveBtn.Object.isDisabled _
				AND objTE_Init_CancelBtn.Object.isDisabled Then
				strOutErrorDesc = "Transplant Evaluation buttons are not displayed properly"
				Exit Function
			End If
			Call WriteToLog("Pass", "After clicking Add button (and before answering any pathway questions) Postpone and Save btns are disabled; Cancel btn is enabled")
		End If
		
		'Validating TE History
		If not objTE_Init_HistoryBtn.Object.isDisabled Then
		blnTE_HistoryClicked = ClickButton("History",objTE_Init_HistoryBtn,strOutErrorDesc)
			If not blnTE_HistoryClicked Then
				strOutErrorDesc = "Unable to click Transplant Evaluation History button"
				Exit function
			End If
			Call WriteToLog("Pass", "Clicked on Transplant Evaluation History button")
			Wait 2
			
			
			'check for TE pathway report
			Execute "Set objTE_Init_PatwayReportHistoryHdr = " & Environment("WI_TE_PatwayReportHistoryHdr")
			blnwaitUntilExist = waitUntilExist(objTE_Init_PatwayReportHistoryHdr, 100)
			If not blnwaitUntilExist Then
				strOutErrorDesc = "Transplant Evaluation Pathway Report window is unavailable"
				Exit function
			End If
			Call WriteToLog("Pass", "Transplant Evaluation Pathway Report window is available")
			Execute "Set objTE_Init_PatwayReportHistoryHdr = Nothing"
			Wait 5
			
			'close TE pathway report
			Err.clear
			objTE_Init_PatwayReportHistoryClose.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Transplant Evaluation Pathway Report window close btn"
				Exit function
			End If
			Call WriteToLog("Pass", "Closed Transplant Evaluation Pathway Report window")
		End If
		
	TE_ButtonInitialStatus = True	
	
	Execute "Set objTE_Init_Page = Nothing"
	Execute "Set objTE_Init_AddBtn = Nothing"
	Execute "Set objTE_Init_PotponeBtn = Nothing"
	Execute "Set objTE_Init_SaveBtn = Nothing"
	Execute "Set objTE_Init_CancelBtn = Nothing"
	Execute "Set objTE_Init_HistoryBtn = Nothing"
	Execute "Set objTE_Init_PatwayReportHistoryHdr = Nothing"
	Execute "Set objTE_Init_PatwayReportHistoryClose = Nothing"
	
End Function

'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: TE_Cancel_PostponeValidation
'Purpose	  		: Validate Cancel and Postpone button functionalities of Transplan Evaluation screen 
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			    	: strOutErrorDesc: String value which contains detail error message is error occured
'Example of Call    : Call TE_Cancel_PostponeValidation()
'Author 	  		: Gregory
'Date               : 29 September 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------

Function TE_Cancel_PostponeValidation()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TE_Cancel_PostponeValidation = False

	Execute "Set objTE_CP_CancelBtn = " & Environment("WEL_TE_Cancel")
	Execute "Set objTE_CP_PotponeBtn = " & Environment("WEL_TE_Postpone")
	
	'Validating CANCEL btn
	If objTE_CP_CancelBtn.Object.isDisabled Then
		strOutErrorDesc = "Transplant Evaluation Cancel button is disabled for pathway"
		Exit Function
	End If
	Call WriteToLog("Pass", "Transplant Evaluation Cancel button is enabled for pathway")
	
	'click Cancel btn
	blnTE_CancelClicked = ClickButton("Cancel",objTE_CP_CancelBtn,strOutErrorDesc)
	If not blnTE_CancelClicked Then
		strOutErrorDesc = "Unable to click Transplant Evaluation Cancel button"
		Exit function
	End If
	Call WriteToLog("Pass", "Transplant Evaluation Cancel button is clicked")
	Wait 2
	
	'Click option on popup
	blnTE_CancelClickResultPP = clickOnMessageBox("", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnTE_CancelClickResultPP Then
		strOutErrorDesc = "Unable to click 'No' on popup which appeared when Cancel btn is clicked"
		Exit function
	End If
	Wait 2
	
	Call waitTillLoads("Loading Pathway...")
	Wait 2
	Call WriteToLog("Pass", "Transplant Evaluation Cancel button is validated")
	
	'Validating Postpone btn
	If objTE_CP_PotponeBtn.Object.isDisabled Then
		strOutErrorDesc = "Transplant Evaluation Postpone button is disabled for pathway"
		Exit Function
	End If
	Call WriteToLog("Pass", "Transplant Evaluation Postpone button is ensabled for pathway")
	
	'Navigate to some other screen ('Home Safety Screening') without clicking postpone button - user should get a warning msg
	clickOnSubMenu("Screenings->Home Safety Screening")
	Wait 2
	
	blnReturnValue = clickOnMessageBox("Transplant Evaluation", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Your current changes will be lost. Do you want to continue ?' popup is not available before clicking Postpone button"
		Exit Function
	End If
	Call WriteToLog("Pass", "Got warning msg when tried to navigate to other screen without clicking postpone btn")
	
		'Click postpone button {and then navigate to some other screen ('Home Safety Screening')- user should not get warning msg
	blnClickedPostponeBtn = ClickButton("Postpone",objTE_CP_PotponeBtn,strOutErrorDesc)
	If not blnClickedPostponeBtn Then
		strOutErrorDesc = "Postpone button click returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on postpone button")
	Wait 2	
	
	Call waitTillLoads("Saving pathway...")
	Wait 2
	
	'Navigate to some other screen ('Home Safety Screening')
	clickOnSubMenu("Screenings->Home Safety Screening")
	Wait 2
	
	Call waitTillLoads("Loading...")
	Call waitTillLoads("Loading Home Safety...")
	Wait 1
	
										Execute "Set objPageTEpostVal = "&Environment("WPG_AppParent") 'Page Object
										set objHomeSafetyScrHdr = objPageTEpostVal.WebElement("class:=col-md-12.*","html tag:=DIV","outertext:=Home Safety Screening ","visible:=True")
										
	'Check whether user landed on other screen (Home Safety screen)
	If not objHomeSafetyScrHdr.Exist(10) Then
		strOutErrorDesc = "unable to navigate to other screen (HomeSafety) during validation of postpone button"
		Exit Function
	End If
	Call WriteToLog("Pass", "Navigated to Home Safety Screen")
	
	'user should not get 'changes will be lost' warning popup 
	blnReturnValue = clickOnMessageBox("Transplant Evaluation", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If blnReturnValue Then
		strOutErrorDesc = "Got warning msg when tried to navigate to other screen even after clicking postpone btn"
		Exit Function
	End If
	Call WriteToLog("Pass", "User didn't get warning msg when tried to navigate to other screen after clicking postpone btn")
	
	'Navigate back to 'Transplant Evaluation' screen
	clickOnSubMenu("Screenings->Transplant Evaluation")
	Wait 2
	
	Call waitTillLoads("Loading Pathway...")
	Wait 2
	
	Call WriteToLog("Pass", "Postpone button functionality of Transplant Evaluation screen is validated")
	
	TE_Cancel_PostponeValidation = True

	Execute "Set objTE_CP_CancelBtn = Nothing"
	Execute "Set objTE_CP_PotponeBtn = Nothing"

End Function

'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: TestTE_TeamLink
'Purpose	   		: Team link validation for Transplan Evaluation screen
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			   		: strOutErrorDesc: String value which contains detail error message is error occured
'Example of Call    : Call TestTE_TeamLink()
'Author 	   		: Gregory
'Date               : 29 September 2015
'----------------------------------------------------------------------------------------------------------------------------------------------
Function TestTE_TeamLink()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TestTE_TeamLink = False
	
	Execute "Set objCenterInfoMsgLine = " & Environment("WEL_CenterInfoMsgLine")
	Execute "Set objTE_CenterInfoLink = " & Environment("WEL_CenterInfoLink")
	Execute "Set objProviderManagementHeader = " & Environment("WEL_ProviderManagementHeader")
	Execute "Set objBackToPathwayBtn = " & Environment("WEL_BackToPathwayBtn")

	'Testing link functionality for 'Yes' answer opted for "Is patient on a renal transplant list?" pathway question
	blnCenterInfoMsgLine = CheckObjectExistence(objCenterInfoMsgLine,5)
	If not blnCenterInfoMsgLine Then
		strOutErrorDesc = "'Transplant Co-ordinator and Center should be added to the team screen.' message unavailable for 'YES' option of 'Is patient on a renal transplant list?' question" 
		Exit Function
	End If
	Call WriteToLog("Pass","'Transplant Co-ordinator and Center should be added to the team screen.' message unavailable for 'YES' option of 'Is patient on a renal transplant list?' question")
	
	blnCenterInfoLinkClicked = ClickButton("",objTE_CenterInfoLink,strOutErrorDesc)
	If not blnCenterInfoLinkClicked Then
		strOutErrorDesc = "Unable to click button for navigation to 'TEAM' screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked button for navigation to 'TEAM' screen")
	Wait 2
	Call waitTillLoads("Loading...")
	Call waitTillLoads("Loading Providers...")
	
	blnCenterInfoLinkNavigated = waitUntilExist(objProviderManagementHeader,10)
	If not blnCenterInfoLinkNavigated Then
		strOutErrorDesc = "Unable to navigate to 'TEAM' screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Navigated to 'TEAM' screen")
	
	blnBackToPathwayClicked = ClickButton("Back to Pathway",objBackToPathwayBtn,strOutErrorDesc)
	If not blnBackToPathwayClicked Then
		strOutErrorDesc = "Unable to click 'Back to Pathway' button"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked 'Back to Pathway' button")
	Wait 2
	Call waitTillLoads("Loading...")
	
	Call WriteToLog("Pass","Validated 'Team link' for Transplan Evaluation screen")

	TestTE_TeamLink =True

	Execute "Set objCenterInfoMsgLine = Nothing"
	Execute "Set objTE_CenterInfoLink = Nothing"
	Execute "Set objProviderManagementHeader = Nothing"
	Execute "Set objBackToPathwayBtn = Nothing"

End Function

'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: TestTE_ReferralLink
'Purpose	   		: Referral link validation for Transplan Evaluation screen
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			   		: strOutErrorDesc: String value which contains detail error message is error occured
'Example of Call    : Call TestTE_ReferralLink()
'Author 	   		: Gregory
'Date               : 29 September 2015
'----------------------------------------------------------------------------------------------------------------------------------------------
Function TestTE_ReferralLink()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TestTE_ReferralLink = False
	
	Execute "Set objTE_ReferralsInfoLink = " & Environment("WEL_ReferralsInfoLink")
	Execute "Set objReferralsHeader = " & Environment("WEL_ReferralsHeader")
	Execute "Set objBackToPathwayBtn = " & Environment("WEL_BackToPathwayBtn")

	'Testing link functionality for 'Yes' answer opted for "Has patient been referred for renal transplantation?" pathway question
	blnReferralsInfoLinkClicked = ClickButton("",objTE_ReferralsInfoLink,strOutErrorDesc)
	If not blnReferralsInfoLinkClicked Then
		strOutErrorDesc = "Unable to click button for navigation to 'Referral' screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked link for 'Yes' answer opted for 'Has patient been referred for renal transplantation?' pathway question")
	Wait 2
	Call waitTillLoads("Loading...")
	
	blnReferralsInfoLinkNavigated = waitUntilExist(objReferralsHeader,10)
	If not blnReferralsInfoLinkNavigated Then
		strOutErrorDesc = "Unable to navigate to 'Referral' screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Navigated to 'Referral' screen")
	
	blnBackToPathwayClicked = ClickButton("Back to Pathway",objBackToPathwayBtn,strOutErrorDesc)
	If not blnBackToPathwayClicked Then
		strOutErrorDesc = "Unable to click 'Back to Pathway' button"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked 'Back to Pathway' button")
	Wait 2
	Call waitTillLoads("Loading...")
	
	Call WriteToLog("Pass","Validated 'Referral link' for Transplan Evaluation screen")
	
	TestTE_ReferralLink = True
	
	Execute "Set objTE_ReferralsInfoLink = Nothing"
	Execute "Set objReferralsHeader = Nothing"
	Execute "Set objBackToPathwayBtn = Nothing"

End Function

'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: TestTE_MaterialLink
'Purpose	   		: Material link validation for Transplan Evaluation screen
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			    	: strOutErrorDesc: String value which contains detail error message is error occured
'Example of Call    : Call TestTE_MaterialLink()
'Author 	   		: Gregory
'Date               : 29 September 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
Function TestTE_MaterialLink()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TestTE_MaterialLink = False
	
	Execute "Set objTE_MaterialsInfoLink = " & Environment("WEL_MaterialsInfoLink")
	Execute "Set objMaterialsHeader = " & Environment("WEL_MaterialsHeader")
	Execute "Set objBackToPathwayBtn = " & Environment("WEL_BackToPathwayBtn")

	'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
	blnMaterialsInfoLinkClicked = ClickButton("",objTE_MaterialsInfoLink,strOutErrorDesc)
	If not blnMaterialsInfoLinkClicked Then
		strOutErrorDesc = "Unable to click button for navigation to 'Material' screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked link for 'Yes' answer opted for 'Send written materials regarding transplantation?' pathway question")
	Wait 2
	
	Call waitTillLoads("Loading Materials...")
	Call waitTillLoads("Loading...")
	
	blnMaterialsInfoLinkNavigated = waitUntilExist(objMaterialsHeader,10)
	If not blnMaterialsInfoLinkNavigated Then
		strOutErrorDesc = "Unable to navigate to 'Material' screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Navigated to 'Material' screen")
	
	blnBackToPathwayClicked = ClickButton("Back to Pathway",objBackToPathwayBtn,strOutErrorDesc)
	If not blnBackToPathwayClicked Then
		strOutErrorDesc = "Unable to click 'Back to Pathway' button"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked 'Back to Pathway' button")
	Wait 2
	Call waitTillLoads("Loading...")
	
	Call WriteToLog("Pass","Validated 'Material link' for Transplan Evaluation screen")

	TestTE_MaterialLink = True

	Execute "Set objTE_MaterialsInfoLink = Nothing"
	Execute "Set objMaterialsHeader = Nothing"
	Execute "Set objBackToPathwayBtn = Nothing"

End Function

'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: FRA_ValidatePostponeBtn
'Purpose	   		: Validate Postpone functionality of Fall Risk Assessment page
'Output Arguments   : Boolean value: validation successful or not
'			    	: strOutErrorDesc: String value which contains detail error message is error occured
'Example of Call    : Call FRA_ValidatePostponeBtn()
'Author 	  		: Gregory
'Date               : 12 October 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
Function FRA_ValidatePostponeBtn()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	FRA_ValidatePostponeBtn = False
	
	Execute "Set objFRA_Postpone = "&Environment("WEL_FRA_Postpone")	'Fall risk assessment postpone btn
	Execute "Set objFRA_SaveBtn = "&Environment("WEL_FRA_Save")	'Fall risk assessment save btn

	'Navigate to some other screen ('Home Safety Screening') without clicking postpone button - user should get a warning msg
	clickOnSubMenu("Screenings->Home Safety Screening")
							
	blnReturnValue = clickOnMessageBox("Fall Risk Assessment Screening", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Your current changes will be lost. Do you want to continue ?' popup is not available before clicking Postpone button"
		Exit Function
	End If
	Call WriteToLog("Pass", "Got warning msg when tried to navigate to other screen without clicking postpone btn")
	
	'Click postpone button {and then navigate to some other screen ('Home Safety Screening')- user should not get warning msg AND user should get interim save popup}
	blnClickedPostponeBtn = ClickButton("Postpone",objFRA_Postpone,strOutErrorDesc)
	If not blnClickedPostponeBtn Then
		strOutErrorDesc = "Postpone button click returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on postpone button")
	Wait 2
	
	Call waitTillLoads("Saving Fall Risk Screening...")
	Wait 2
	
	'Check for interim save confirmation popup
	blnFRA_SavedPP = checkForPopup("Fall Risk Assessment Screening", "Ok", "Screening has been saved successfully", strOutErrorDesc)
	If not blnFRA_SavedPP Then
		strOutErrorDesc = "'Screening has been saved successfully' message box for postpone (interim save popup) is not available"
		Exit Function
	End If
	Call WriteToLog("Pass", "Got save msg (interim save)")
	Wait 2
		
	'Navigate to some other screen ('Home Safety Screening')
	clickOnSubMenu("Screenings->Home Safety Screening")
	Wait 2
	
	Call waitTillLoads("Loading...")
	Call waitTillLoads("Loading Home Safety...")
	Wait 1
	
										Execute "Set objPageFRApostVal = "&Environment("WPG_AppParent") 'Page Object
										set objHomeSafetyScrHdr = objPageFRApostVal.WebElement("class:=col-md-12.*","html tag:=DIV","outertext:=Home Safety Screening ","visible:=True")
	
	'Check whether user landed on other screen (Home Safety screen)
	If not objHomeSafetyScrHdr.Exist(10) Then
		strOutErrorDesc = "unable to navigate to other screen (HomeSafety) during validation of postpone button"
		Exit Function
	End If
	Call WriteToLog("Pass", "Navigated to Home Safety Screen")
	
	'User should not get warning msg as postpone btn was clicked for interim save
	blnReturnValue = clickOnMessageBox("Fall Risk Assessment Screening", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If blnReturnValue Then
		strOutErrorDesc = "Got warning msg when tried to navigate to other screen even after clicking postpone btn"
		Exit Function
	End If
	Call WriteToLog("Pass", "User didn't get warning msg when tried to navigate to other screen after clicking postpone btn")
		
	'navigate back to 'Fall Risk Assessment' screen - 'Save' btn should be enabled in this scenario
	clickOnSubMenu("Screenings->Fall Risk Assessment")
	Wait 2
	
	Call waitTillLoads("Loading Fall Risk Screening...")
	Wait 2
	
	Call WriteToLog("Pass", "Postpone button functionality of Fall Risk Assessment screen is validated")
	
	FRA_ValidatePostponeBtn = True
	
	Execute "Set objFRA_Postpone = Nothing"
	
End Function

'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: FRA_ValidateHistory
'Purpose	  		: Validate screening history of Fall Risk Assessment page
'Input Arguments    : dtScreeningCompletedDate " date value representing screening completed date
'					: intFRAscore - int value representing FRA score
'Output Arguments   : NA
'Example of Call    : Call FRA_ValidateHistory(dtCompletedDate,intFRA_Score)
'Author 	  		: Gregory
'Date               : 12 October 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
Function FRA_ValidateHistory(Byval dtScreeningCompletedDate, ByVal intFRAscore)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	FRA_ValidateHistory = False
	
	Execute "Set objFRA_ScrHistUpArw = "&Environment("WI_FRA_ScrHistUpArw")	'Screening history expand arrow button
	Execute "Set objFRA_ScrHtryTable = "&Environment("WT_FRA_ScrHtryTable")	'Screening history table
	
	'click on screening history expand arrow icon
	Err.Clear
	objFRA_ScrHistUpArw.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Screening history expand arrow icon, Error Returned: "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on history expand arrow")
	Wait 2
	
	Call waitTillLoads("Loading Fall Risk Screening...")
	Wait 2
	
	'Validate the history table entries
	RowCount = objFRA_ScrHtryTable.RowCount
	If RowCount = "" OR RowCount = 0 Then
		strOutErrorDesc = "History table is not populated with screening details"
		Exit Function
	End If
	Call WriteToLog("Pass", "History table is populated with screening details and number of entries are :"&RowCount)

	'Get current and previous screening	information from screening history table	
	For R = 1 To RowCount Step 1
		ReDim Preserve arrScreeningHistoryInfo(RowCount-1)
		For C = 1 To objFRA_ScrHtryTable.ColumnCount(R) Step 1
				If C = 1 Then
					dtCompletedDateHT = objFRA_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 2 Then
					intScore = objFRA_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 3 Then
					intScreeningLevel = objFRA_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 4 Then
					strLevelComments = objFRA_ScrHtryTable.GetCellData(R,C)				
				End If
		Next
		arrScreeningHistoryInfo(R-1) = dtCompletedDateHT&","&intScore&","&intScreeningLevel&","&strLevelComments
	Next
	
	'Validate the latest screening details from the history table
	strScreeningHistory = dtCompletedDateHT&","&intScore&","&intScreeningLevel&","&strLevelComments 
	strScreeningHistory = Replace(strScreeningHistory," ","",1,-1,1)								
		
	HistoryFlag = False
	dtFRACompletedDate = DateFormat(CDate(dtScreeningCompletedDate))
	For k = 0 To ubound (arrScreeningHistoryInfo) Step 1
		If Instr(1,Trim(arrScreeningHistoryInfo(k)),dtFRACompletedDate&","&intFRAscore,1) > 0 Then
			HistoryFlag = True
			Exit For
		End If
	Next
	
	If not HistoryFlag Then
		strOutErrorDesc = "History table is not populated with required screening details."
		Exit Function
	End If
	Call WriteToLog("Pass", "Validated screening history of Fall Risk Assessment screen")
	
	FRA_ValidateHistory = True
	
	Execute "Set objFRA_ScrHistUpArw = Nothing"
	Execute "Set objFRA_ScrHtryTable = Nothing"

End Function

'----------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: TestACS_TeamLink
'Purpose	   		: Team link validation for Advance Care Planning Screen
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			   		: strOutErrorDesc: String value which contains detail error message occurred
'Example of Call    : Call TestACS_TeamLink()
'Author 	   		: Amar
'Date               : 29 September 2015
'----------------------------------------------------------------------------------------------------------------------------------------------

Function TestACS_TeamLink()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TestACS_TeamLink = False
	
	Execute "Set objCenterInfoMsgLine = " & Environment("WEL_ACS_CenterInfoMsgLine")
	Execute "Set objACS_CenterInfoLink = " & Environment("WEL_ACS_CenterInfoLink")
	Execute "Set objProviderManagementHeader = " & Environment("WEL_ACS_ProviderHeader")
	Execute "Set objBackToPathwayBtn = " & Environment("WEL_ACS_BackToPathwayBtn")

	'Testing link functionality for 'Yes' answer opted for "Is patient on a renal transplant list?" pathway question
	blnCenterInfoMsgLine = CheckObjectExistence(objCenterInfoMsgLine,5)
	If not blnCenterInfoMsgLine Then
		strOutErrorDesc = "'Add the name of Health Care Proxy to Team screen' message unavailable for 'In Place' option of 'Does the patient have a written advance care plan in place' question" 
		Exit Function
	End If
	
	blnCenterInfoLinkClicked = ClickButton("",objACS_CenterInfoLink,strOutErrorDesc)
	If not blnCenterInfoLinkClicked Then
		strOutErrorDesc = "Unable to click button for navigation to 'TEAM' screen"
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Loading...")
	'Call waitTillLoads("Loading Providers...")
	
	blnCenterInfoLinkNavigated = waitUntilExist(objProviderManagementHeader,10)
	If not blnCenterInfoLinkNavigated Then
		strOutErrorDesc = "Unable to navigate to 'TEAM' screen"
		Exit Function
	End If
	
	blnBackToPathwayClicked = ClickButton("Back to Pathway",objBackToPathwayBtn,strOutErrorDesc)
	If not blnBackToPathwayClicked Then
		strOutErrorDesc = "Unable to click 'Back to Pathway' button"
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Loading...")

	TestACS_TeamLink =True

	Execute "Set objCenterInfoMsgLine = Nothing"
	Execute "Set objTE_CenterInfoLink = Nothing"
	Execute "Set objProviderManagementHeader = Nothing"
	Execute "Set objBackToPathwayBtn = Nothing"

End Function

'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: TestACS_MaterialLink
'Purpose	   		: Material link validation for Advance Care Planning Screen
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			    	: strOutErrorDesc: String value which contains detail error message occurred
'Example of Call    : Call TestACS_MaterialLink()
'Author 	   		: Amar
'Date               : 29 September 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
Function TestACS_MaterialLink()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TestACS_MaterialLink = False
	
	Execute "Set objACS_MaterialsInfoLink = " & Environment("WEL_ACS_MaterialsInfoLink")
	Execute "Set objMaterialsHeader = " & Environment("WEL_ACS_MaterialsHeader")
	Execute "Set objBackToPathwayBtn = " & Environment("WEL_ACS_BackToPathwayBtn")

	'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
	blnMaterialsInfoLinkClicked = ClickButton("",objACS_MaterialsInfoLink,strOutErrorDesc)
	If not blnMaterialsInfoLinkClicked Then
		strOutErrorDesc = "Unable to click button for navigation to 'Materials' screen"
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Loading...")
	
	blnMaterialsInfoLinkNavigated = waitUntilExist(objMaterialsHeader,10)
	If not blnMaterialsInfoLinkNavigated Then
		strOutErrorDesc = "Unable to navigate to 'Materials' screen"
		Exit Function
	End If
	
	blnBackToPathwayClicked = ClickButton("Back to Pathway",objBackToPathwayBtn,strOutErrorDesc)
	If not blnBackToPathwayClicked Then
		strOutErrorDesc = "Unable to click 'Back to Pathway' button"
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Loading...")

	TestACS_MaterialLink = True

	Execute "Set objACS_MaterialsInfoLink = Nothing"
	Execute "Set objMaterialsHeader = Nothing"
	Execute "Set objBackToPathwayBtn = Nothing"

End Function
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: ACS_ButtonInitialStatus
'Purpose	  		: Validate initial status on Advance Care Plan screen buttons and also pathway report 
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			    	: strOutErrorDesc: String value which contains detail error message when error occured
'Example of Call    : Call ACS_ButtonInitialStatus()
'Author 	  		: Amar
'Date               : 29 September 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
Function ACS_ButtonInitialStatus()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ACS_ButtonInitialStatus = False
									
	Execute "Set objACS_AddBtn="&Environment("WEL_ACSAddBtn")
	Execute "Set objACS_PostponeBtn="&Environment("WEL_ACSPostponeBtn")
	Execute "Set objACS_CancelBtn="&Environment("WEL_ACSCancelBtn")
	Execute "Set objACS_SaveBtn="&Environment("WEL_ACSSaveBtn")  
	Execute "Set objACS_HistoryBtn="&Environment("WEL_ACSHistoryBtn")  
	Execute "Set objACS_PatwayReportHistoryHdr = " & Environment("WI_ACS_PatwayReportHistoryHdr")
	Execute "Set objACS_PatwayReportHistoryClose = " & Environment("WI_ACS_PatwayReportHistoryClose")
	'Validating ADD btn			
	If not objACS_AddBtn.Object.isDisabled Then
		blnACS_AddClicked = ClickButton("Add",objACS_AddBtn,strOutErrorDesc)
		If not blnACS_AddClicked Then
			strOutErrorDesc = "Unable to click Advance Care Planning Add button"
		Exit function
	End If
			
	Call WriteToLog("Pass", "Clicked on Advance Care Plan Add button")
	Wait 2
			
	Call waitTillLoads("Loading Pathway...")
	Wait 2			
			
	'Validating initial status of Postpone,Save and Cancel buttons
	'After clicking Add button (and before answering any pathway questions) Postpone and Save btns sould be disabled; Cancel btn should be enabled 
			
	If not objACS_PostponeBtn.Object.isDisabled AND not objACS_SaveBtn.Object.isDisabled _
		AND objACS_CancelBtn.Object.isDisabled Then
		strOutErrorDesc = "Advance Care Plan buttons are not displayed properly"
		Exit Function
	End If
	Call WriteToLog("Pass", "After clicking Add button (and before answering any pathway questions) Postpone and Save btns are disabled; Cancel btn is enabled")
	End If
		
	'Validating ACS History
	If not objACS_HistoryBtn.Object.isDisabled Then
	blnACS_HistoryClicked = ClickButton("History",objACS_HistoryBtn,strOutErrorDesc)
		If not blnACS_HistoryClicked Then
			strOutErrorDesc = "Unable to click Advance Care Plan History button"
			Exit function
		End If
	Call WriteToLog("Pass", "Clicked on Advance Care Plan History button")
	Wait 2
		
	'check for ACS pathway report
	If not objACS_PatwayReportHistoryHdr.Exist(20) Then
			strOutErrorDesc = "Advance Care Plan Pathway Report window is unavailable"
			Exit function
	End If
	Call WriteToLog("Pass", "Advance Care Plan Pathway Report window is available")
			
	'close TE pathway report
	Err.clear
	objACS_PatwayReportHistoryClose.Click
	If err.number <> 0 Then
			strOutErrorDesc = "Unable to click Advance Care Plan Pathway Report window close btn"
			Exit function
	End If
			Call WriteToLog("Pass", "Closed Advance Care Plan Pathway Report window")
	End If
		
	ACS_ButtonInitialStatus = True	
		 			
	Execute "Set objACS_AddBtn=Nothing"
	Execute "Set objACS_PostponeBtn=Nothing"
	Execute "Set objACS_CancelBtn=Nothing"
	Execute "Set objACS_SaveBtn=Nothing"
	Execute "Set objACS_HistoryBtn=Nothing" 
	Execute "Set objACS_PatwayReportHistoryHdr = Nothing"
	Execute "Set objACS_PatwayReportHistoryClose =Nothing"
	
	
End Function
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: ACS_Cancel_PostponeValidation
'Purpose	  		: Validate Cancel and Postpone button functionalities of Advance Care Plan screen 
'Input Arguments    : NA
'Output Arguments   : Boolean value: validation successful or not
'			    	: strOutErrorDesc: String value which contains detail error message occured
'Example of Call    : Call ACS_Cancel_PostponeValidation()
'Author 	  		: Amar
'Date               : 12 October 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------

Function ACS_Cancel_PostponeValidation()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ACS_Cancel_PostponeValidation = False

	Execute "Set objACS_PostponeBtn="&Environment("WEL_ACSPostponeBtn")
	Execute "Set objACS_CancelBtn="&Environment("WEL_ACSCancelBtn")
	
	'Validating CANCEL btn
	If objACS_CancelBtn.Object.isDisabled Then
		strOutErrorDesc = "Advance Care Plan Cancel button is disabled for pathway"
		Exit Function
	End If
	Call WriteToLog("Pass", "Advance Care Plan Cancel button is enabled for pathway")
	
	'click Cancel btn
	blnACS_CancelClicked = ClickButton("Cancel",objACS_CancelBtn,strOutErrorDesc)
	If not blnACS_CancelClicked Then
		strOutErrorDesc = "Unable to click Advance Care Plan Cancel button"
		Exit function
	End If
	Call WriteToLog("Pass", "Advance Care Plan Cancel button is clicked")
	Wait 2
	
	'Click option on popup
	blnACS_CancelClickResultPP = clickOnMessageBox("", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnACS_CancelClickResultPP Then
		strOutErrorDesc = "Unable to click 'No' on popup which appeared when Cancel btn is clicked"
		Exit function
	End If
	Wait 2
	
	Call waitTillLoads("Loading Pathway...")
	Wait 2
	Call WriteToLog("Pass", "Advance Care Plan Cancel button is validated")
	
	'Validating Postpone btn
	If objACS_PostponeBtn.Object.isDisabled Then
		strOutErrorDesc = "Advance Care Plan Postpone button is disabled for pathway"
		Exit Function
	End If
	Call WriteToLog("Pass", "Advance Care Plan Postpone button is ensabled for pathway")
	
	'Navigate to some other screen ('Home Safety Screening') without clicking postpone button - user should get a warning msg
	clickOnSubMenu("Screenings->Home Safety Screening")
	Wait 2
	
	blnReturnValue = clickOnMessageBox("Advance Care Planning", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Your current changes will be lost. Do you want to continue ?' popup is not available before clicking Postpone button"
		Exit Function
	End If
	Call WriteToLog("Pass", "Got warning msg when tried to navigate to other screen without clicking postpone btn")
	
	'Click postpone button {and then navigate to some other screen ('Home Safety Screening')- user should not get warning msg
	blnClickedPostponeBtn = ClickButton("Postpone",objACS_PostponeBtn,strOutErrorDesc)
	If not blnClickedPostponeBtn Then
		strOutErrorDesc = "Postpone button click returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on postpone button")
	Wait 2	
	
	Call waitTillLoads("Saving pathway...")
	Wait 2
	
	'Navigate to some other screen ('Home Safety Screening')
	clickOnSubMenu("Screenings->Home Safety Screening")
	Wait 2
	
	Call waitTillLoads("Loading...")
	Call waitTillLoads("Loading Home Safety...")
	Wait 1
	
	Execute "Set objPageACP = "&Environment("WPG_AppParent") 'Page Object
	set objHomeSafetyScrHdr = objPageACP.WebElement("class:=col-md-12.*","html tag:=DIV","outertext:=Home Safety Screening ","visible:=True")
										
	'Check whether user landed on other screen (Home Safety screen)
	If not objHomeSafetyScrHdr.Exist(10) Then
		strOutErrorDesc = "unable to navigate to other screen (HomeSafety) during validation of postpone button"
		Exit Function
	End If
	Call WriteToLog("Pass", "Navigated to Home Safety Screen")
	
	'user should not get 'changes will be lost' warning popup 
	blnReturnValue = clickOnMessageBox("Advance Care Planning", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If blnReturnValue Then
		strOutErrorDesc = "Got warning msg when tried to navigate to other screen even after clicking postpone btn"
		Exit Function
	End If
	Call WriteToLog("Pass", "User didn't get warning msg when tried to navigate to other screen after clicking postpone btn")
	
	'Navigate back to 'Transplant Evaluation' screen
	clickOnSubMenu("Screenings->Advance Care Planning")
	Wait 2
	
	Call waitTillLoads("Loading Pathway...")
	Wait 2
	
	Call WriteToLog("Pass", "Postpone button functionality of Advance Care Plann screen is validated")
	
	ACS_Cancel_PostponeValidation = True
	
	Execute "Set objACS_PostponeBtn=Nothing"	
	Execute "Set objACS_CancelBtn=Nothing"	

End Function

'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: HSS_ValidatePostponeBtn     
'Purpose	   		: Validate Postpone functionality of Home Safety screening page
'Output Arguments   : Boolean value: validation successful or not
'			    	: strOutErrorDesc: String value which contains detail error message  occurred
'Example of Call    : Call HSS_ValidatePostponeBtn()
'Author 	  		: Amar
'Date               : 12 October 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
Function HSS_ValidatePostponeBtn()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	HSS_ValidatePostponeBtn = False
	
	Execute "Set objhomesafetyScreeningPostponeButton1="&Environment("WEL_HSPostponeBtn")	'HomeSafetyScreening Postpone button
	Execute "Set objhomesafetyScreeningSaveButton1="&Environment("WEL_HSSaveBtn")            'HomeSafetyScreening Save button
			
	'Navigate to some other screen ('Fall Risk Assessment Screening') without clicking postpone button - user should get a warning msg 
	 clickOnSubMenu("Screenings->Fall Risk Assessment")
	 Wait 2
					
	Call waitTillLoads("Loading...")
	Wait 2
	
	blnReturnValue = clickOnMessageBox("Fall Risk Assessment Screening", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Your current changes will be lost. Do you want to continue ?' popup is not available before clicking Postpone button"
		Exit Function
	End If
	Call WriteToLog("Pass", "Got warning msg when tried to navigate to other screen without clicking postpone btn")

	'Click postpone button and then navigate to some other screen ('Fall Risk Assessment')- user should not get warning msg AND user should get interim save popup 
	blnClickedPostponeBtn = ClickButton("Postpone",objhomesafetyScreeningPostponeButton1,strOutErrorDesc)
	If not blnClickedPostponeBtn Then
	 	strOutErrorDesc = "Postpone button click returned error: "&strOutErrorDesc
	    Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on postpone button")
	Wait 2						
	Call waitTillLoads("Saving Home Safety Screening...")
	Wait 2
	blnHSS_SavedPP = checkForPopup("Home Safety Screening", "Ok", "Screening has been saved successfully", strOutErrorDesc)
	If not blnHSS_SavedPP Then
		strOutErrorDesc = "'Screening has been saved successfully' message box for postpone (interim save popup) is not available"
		Exit Function
	End If
	Call WriteToLog("Pass", "Got save msg (interim save)")
	Wait 2	
	'Navigate to some other screen ('Fall Risk Assessment')	    
	clickOnSubMenu("Screenings->Fall Risk Assessment")					
	Call waitTillLoads("Loading Fall Risk Screening...")
	Wait 1

	blnReturnValue = clickOnMessageBox("Home Safety Screening", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnReturnValue Then
		print "Pass, user didn't get warning msg when tried to navigate to other screen after clicking postpone btn"
	Else
		strOutErrorDesc = "'Your current changes will be lost. Do you want to continue ?' popup is available even after clicking Postpone button."
		Exit Function
	End If
	print "pass, warning msg is not available as expected"
					
	'navigate back to 'Home Safety Screening' screen - 'Save' btn should be enabled in this scenario
	clickOnSubMenu("Screenings->Home Safety Screening")
	Wait 1
						
	If not objhomesafetyScreeningSaveButton1.Object.isDisabled Then
		Print "Pass, Postpone button functionality is validated"
	Else
		strOutErrorDesc = "Unable to validate Postpone functionality as Save button is in disabled status"
		Exit Function
	End If
	Wait 2		 
	
	HSS_ValidatePostponeBtn = True
	
	Execute "Set objhomesafetyScreeningPostponeButton1 = Nothing"
	Execute "Set objhomesafetyScreeningSaveButton1 = Nothing"
	
End Function

'-----------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name 		: HSS_ValidateHistory      
'Purpose	  		: Validate screening history of Home Safety Screening page
'Input Arguments    : dtScreeningCompletedDate " date value representing screening completed date
'Output Arguments   : NA
'Example of Call    : Call HSS_ValidateHistory(dtCompletedDate)
'Author 	  		: Amar
'Date               : 12 October 2015
'-----------------------------------------------------------------------------------------------------------------------------------------------------------
Function HSS_ValidateHistory(Byval dtScreeningCompletedDate)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	HSS_ValidateHistory = False
	
	Execute "Set objHomeSafetyScreening_HistUpArw1 = "&Environment("WI_HSS_ScrHistUpArw")	'HomeSafetyScreening history expand arrow button
	Execute "Set objHomeSafetyScreening_HtryTable1 = "&Environment("WT_HSS_ScrHtryTable")	'HomeSafetyScreening history table
		
	'click on screening history expand arrow icon
	Err.Clear
	objHomeSafetyScreening_HistUpArw1.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Screening history expand arrow icon, Error Returned: "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on history expand arrow")
	Wait 2
	
	Call waitTillLoads("Loading Home Safety Screening...")
	Wait 2
	
	'Validate the history table entries
	RowCount = objHomeSafetyScreening_HtryTable1.RowCount
	If RowCount = "" OR RowCount = 0 Then
		strOutErrorDesc = "History table is not populated with screening details"
		Exit Function
	End If
	Call WriteToLog("Pass", "History table is populated with screening details and number of entries are :"&RowCount)

	'Get current and previous screening	information from screening history table	
	For R = 1 To RowCount Step 1
		ReDim Preserve arrScreeningHistoryInfo(RowCount-1)
		For C = 1 To objHomeSafetyScreening_HtryTable1.ColumnCount(R) Step 1
				If C = 1 Then
					dtCompletedDateHT = objHomeSafetyScreening_HtryTable1.GetCellData(R,C)
				ElseIf C = 2 Then
					strLevelComments = objHomeSafetyScreening_HtryTable1.GetCellData(R,C)	
				End If
		Next
			arrScreeningHistoryInfo(R-1) = dtCompletedDateHT&","&strLevelComments
	Next
	
	'Validate the latest screening details from the history table
	strScreeningHistory = dtCompletedDateHT&","&strLevelComments 
	strScreeningHistory = Replace(strScreeningHistory," ","",1,-1,1)								
		
	HistoryFlag = False
	dtHSSCompletedDate = DateFormat(dtScreeningCompletedDate)
	For k = 0 To ubound (arrScreeningHistoryInfo) Step 1
		If Instr(1,arrScreeningHistoryInfo(k),dtHSSCompletedDate&","&strLevelComments,1) > 0 Then
			HistoryFlag = True
			Exit For
		End If
	Next
	
	If not HistoryFlag Then
		strOutErrorDesc = "History table is not populated with required screening details."
		Exit Function
	End If
	Call WriteToLog("Pass", "Validated screening history of Home Safety screening screen")
	
	HSS_ValidateHistory = True
	
	Execute "Set objHomeSafetyScreening_HistUpArw1 = Nothing"
	Execute "Set objHomeSafetyScreening_HtryTable1 = Nothing"

End Function

