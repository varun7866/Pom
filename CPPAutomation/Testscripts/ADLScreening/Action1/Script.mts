 '***********************************************************************************************************************************************************************
' TestCase Name				: ADLScreening
' Purpose of TC			    : This script is based on the SNPs Project covers only Access Information tab.
'							: The purpose of this scenario is to verify Add, Postpone and Save button on ADL Screening page after completing screening 
'							: for all the past 7 days.
' Pre-requisites(if any)    : None
' Author                    : Sharmila
' Date                      : 04-SEP-2015
'***********************************************************************************************************************************************************************

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

intWaitTime =Environment.Value("WaitTime") 

Set objFso = Nothing

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ADLScreening", strOutTestName, strOutErrorDesc) 
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

'Variable Initialization
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData") 			'Fetch patient name from test data

'#################################################	Start: Test Case Execution	#################################################
'==========================================================================================================
'Login to Capella, verify the successful loading of the dashboard page and verify My Patient Census widget
'==========================================================================================================
Call WriteToLog("Info","==========Testcase - Login to Capella, verify the successful loading of the dashboard page and verify My Patient Census widget==========")


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
	strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'==============================
'Open patient from action item
'==============================
Call WriteToLog("Info","==========Testcase - Open a patient from Global Search.==========")

strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	strOutErrorDesc = "Failed to select member from Global Search"
	Call WriteToLog("Fail", strOutErrorDesc)
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

wait 2



'=========================================================
'Select Access screen from the Clinical management menu
'=========================================================
Call clickOnSubMenu("Screenings->ADL Screening")

wait intWaitTime/4


'===================================================================================
' Call the function ADLScreening, which does all the validation for ADL Screening. 
' All the function are located at the Library --> Generic Functions
'====================================================================================

blnReturnValue = ADLScreening(strOutErrorDesc)
If not blnReturnValue Then
	Call WriteToLog("Fail","Expected Result:ADL Screening functionalities were Verified; Actual Result: Error was returned:" &strOutErrorDesc)
	Call Logout()
	CloseAllBrowsers	
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","ADL Screening functionalities were verified successfully")


'=================================
'Logout from Capella Application
'=================================
Call Logout()
CloseAllBrowsers


'============================
'Summarize execution status
'============================
Call WriteLogFooter()


Function ADLScreening(strOutErrorDesc)

	strOutErrorDesc = ""
	On Error Resume Next
	Err.clear
	ADLScreening = false
	
	'=========================
	'Objects Initialization
	'=========================
	Execute "Set objADLScreeningTitle = "  &Environment.Value("WEL_ADLScreeningTitle") 'ADL screening screen
	Execute "Set objADLScreeningAddButton= "  &Environment.Value("WEL_ADLScreening_AddButton") 'Create Object required ADL screening screen Add button
	Execute "Set objADLScreeningPostponeButton= "  &Environment.Value("WEL_ADLScreening_PostponeButton") 'Create Object required ADL screening screen postpone button
	Execute "Set objADLScreeningSaveButton= "  &Environment.Value("WEL_ADLScreening_SaveButton") 'ADL screening screen Save button
	Execute "Set objCalenderDisable= "  &Environment.Value("WI_ADLScreening_CalenderIcon_Disable") 'Disable Calender icon
	
	'=========================
	'Variable Initialization
	'=========================
	strPopupTitle = DataTable.Value("PopupTitle","CurrentTestCaseData") 	
	strPostponePopupText = DataTable.Value("PostponePopupText","CurrentTestCaseData") 		
	strSavePopupText = DataTable.Value("SavePopupText","CurrentTestCaseData") 		
	strChangesNotSavePopupText = DataTable.Value("ChangesNotSavePopupText","CurrentTestCaseData") 		
	
	
	'==============================================
	'Verify that ADL screening open successfully
	'==============================================
	Call WriteToLog("Info","==========Testcase - Verify ADL screening was opened successfully. ==========")
	
	
	If not waitUntilExist(objADLScreeningTitle, intWaitTime/2) Then	
		Call WriteToLog("Fail","Expected Result:ADL Screening opened successfully; Actual Result: ADL Screening not opened successfully")
		Exit Function
	End If
	
	Call WriteToLog("Pass","ADL Screening opened successfully")
	
	'==========================================================================================================================
	'Check if the patient is doing a new ADL screening or Adding a new screening or completing the previous screening.
	'==========================================================================================================================

	Call WriteToLog("Info","==========Testcase - Check if the patient is doing a new ADL screening or Adding a new screening or completing the previous screening.. ==========")
	
	'Check if the Add button and Postpone button both are disabled, that means this person, didnt had a screening before.
	If not (waitUntilExist(objADLScreeningAddButton,2)) and  not (waitUntilExist(objADLScreeningPostponeButton,2))  Then
		Call WriteToLog("Pass","There is no previous screening added for this patient. Satrting new screening")		
		strScreenStatus = "New" 'Set the status of screening to be filled.
		
	'Check if the Add button is enabled, that means this person, can add a new screening.	
	ElseIf waitUntilExist(objADLScreeningAddButton,2) Then
		Err.Clear
		objADLScreeningAddButton.Click
		Wait 2
		waitTillLoads "Loading..."
		wait 2
		'Wait time to sync application
		If Err.Number <> 0 Then
			Call WriteToLog("Fail","Unable to click on Add button of ADL screening and Error returned: " & Err.Description)
			Exit Function
		End If
		
	strScreenStatus = "New" 'Set the status of screening to be filled- Since Add button is enabled hence screening status should be New
		
	'Check if the Postpone button is enabled, that means this person, can complete the previous screening.	
	ElseIf waitUntilExist(objADLScreeningPostponeButton,2) Then
		Call WriteToLog("Pass","Previous screening is not completed.Hence completing old screening.")
		
		strScreenStatus = "Previous" 'Set the type of screening to be filled- Since Postpone button is enabled hence screening status should be Previous	
	Else	
		Call WriteToLog("Fail","Add button does not exist on ADL screening")
		Exit Function
	End If

	'Select case for screening
	Select Case strScreenStatus
		
		Case "New"
			'===========================================================================
			'Get child object of rectangular radio button available on ADL screen screen
			'===========================================================================
			Set objADLScreeningAnswerCheckBox = GetChildObject("micclass;outerhtml;html tag","WebElement;.*height-100-percent  acp-radio  margin-left-0px.*;DIV")
			
			
			Call WriteToLog("Info","==========Testcase - Verify that checklist of questions should get enabled for either Adding a screening or for New screening.==========") 
			'============================================================================================================
			'Verify that after clicking on Add button on ADL screening, The new checklist of questions should get enabled
			'============================================================================================================
			Set objAnswerSelectedGreen = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-1 acp-radio.*;DIV")
			Set objAnswerSelectedRed = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-2 acp-radio.*;DIV")
			If objAnswerSelectedGreen.Count = 0 and  objAnswerSelectedRed.Count = 0 Then
				Call WriteToLog("Pass","The new checklist of questions is enabled")
			Else
				Call WriteToLog("Fail","The new checklist of questions is not enabled")
				Exit Function
			End If
			
			'====================================================================================================================================================================
			'Select any answer for few of the questions by selecting the rectangular radio button  associated with each question and  ensure some questions are left unanswered
			'Note: Since there visible 12 rectangular radio button on the screen but actualy one button consist three button ex: button without color,button with green color and 
			'button with red color and for selecting the green button we have to click button after count of 6 mean we are going to click button 1,7,13,19 for selecting only 
			'4 question with first choice so we are looping till 20 
			'====================================================================================================================================================================
			For i = 1 To 20 Step 1
				Err.Clear
				objADLScreeningAnswerCheckBox(i).Click 'Click on rectangular radio button
				If Err.Number <> 0 Then
					Call WriteToLog("Fail", "Unable to click on " & i - 1 & " rectangular radio button of ADL screening and Error returned: " & Err.Description)
					Exit Function
				End If
				i = i + 5
			Next
			
			Call WriteToLog("Info","==========Testcase - Click on Postpone button, postpones the survery and displays the message==========")
			'==========================
			'Click on postpone button
			'==========================
			If waitUntilExist(objADLScreeningPostponeButton,5) Then
				Call WriteToLog("Pass","Postpone button is enable now")
				Err.Clear
				objADLScreeningPostponeButton.Click
				Wait 2
				waitTillLoads "Loading..."
				wait 2
				If Err.Number <> 0 Then
					Call WriteToLog("Fail","Postpone button does not clicked successfully")
					Exit Function
				End If
			Else
				Call WriteToLog("Fail","Postpone button is not enable")
				Exit Function
			End If
			
			
			'===================================================
			'Verify that validation of Postpone popup is displayed
			'===================================================
			blnReturnValue = checkForPopup(strPopupTitle, "Ok", strPostponePopupText, strOutErrorDesc)
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			If blnReturnValue Then
				Call WriteToLog("Pass","ADL Scrrening was successfully saved message was displayed. ")
			Else
				Call WriteToLog("Fail","Expected Result: ADL Scrrening was successfully saved message should be displayed; Actual Result: Error return: "&strOutErrorDesc)
				Exit Function
			End If
			
			
			
			'==========================================================================================================================================
			'Verify that 4 questions first option is selected only. Checking the 4 button are in green color we have to check object count should be 8
			'==========================================================================================================================================
			
			Call WriteToLog("Info","==========Testcase - Click on Postpone button, Verify that 4 questions first option is selected only==========")
			
						
			Set objAnswerSelectedGreen = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-1 acp-radio.*;DIV")
			Set objAnswerSelectedRed = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-2 acp-radio.*;DIV")
			If objAnswerSelectedGreen.Count = 12 and objAnswerSelectedRed.Count = 0 Then
				Call WriteToLog("Pass","First 4 questions of the checklist is selected")
			Else
				Call WriteToLog("Fail","First 4 questions of the checklist is not selected")
				Exit Function
			End If
			
'			'========================================================================================================
'			'Verify the status of the below input elements: Add button Save button Screening Date should be disabled
'			'========================================================================================================
'			Call WriteToLog("Info","==========Testcase - Click on Postpone button, Add button Save button Screening Date should be disabled==========")
'			
'			
'			If objADLScreeningAddButton.disabled and objADLScreeningSaveButton.disabled Then
'				Call WriteToLog("Pass","Add button, Save button are disabled")
'			Else
'				Call WriteToLog("Fail","Add button, Save button, Screening Date are not disabled")
'			End If
			
			'===============================================================================================================================================================================
			'Verify that user should be able to successfully change the answers for the already answered questions
			'Note: Since there visible 12 rectangular radio button on the screen but actualy one button consist three button ex: button without color,button with green color and 
			'button with red color and for selecting the red button to changes the answers we have to click button after count of 3 mean we are going to click button 1,4,7,10
			'for changing the answer of only 4 question with first choice so we are looping till 12
			'====================================================================================================================================================================
			
			Call WriteToLog("Info","==========Testcase - Verify that user should be able to successfully change the answers for the already answered questions==========")
			
			'===========================================================================
			'Get child object of rectangular radio button available on ADL screen screen
			'===========================================================================
			Set objADLScreeningAnswerCheckBox = GetChildObject("micclass;outerhtml;html tag","WebElement;.*height-100-percent  acp-radio  margin-left-0px.*;DIV")
			For i = 1 To 12 Step 1
				Err.Clear
				objADLScreeningAnswerCheckBox(i).Click 'Click on rectangular radio button
				If Err.Number <> 0 Then
					Call WriteToLog("Fail", "Unable to click on " & i - 1 & " rectangular radio button of ADL screening and Error returned: " & Err.Description)
					Exit Function
				End If
				i = i + 2
			Next
			
			'==========================================================================================================================================
			'Verify that 4 questions answer are changed. Checking the 4 button are in red color we have to check object count should be 12
			'==========================================================================================================================================
			Set objAnswerSelectedGreen = GetChildObject("micclass;outerhtml;html tag","WebElement;.*adl-radio-button-1.*;DIV")
			Set objAnswerSelectedRed = GetChildObject("micclass;outerhtml;html tag","WebElement;.*adl-radio-button-2.*;DIV")
			If objAnswerSelectedGreen.Count = 0 and objAnswerSelectedRed.Count = 12 Then
				Call WriteToLog("Pass","First 4 questions of the checklist is answers changed successfully")
			Else
				Call WriteToLog("Fail","First 4 questions of the checklist does not changed successfully")
				Exit Function
			End If
			
			'=================================================================================================================================================================
			'TC-03 The purpose of this Test Case is to verify that the postponed checklist data for a particular patient is displayed after closing and opening the patient
			'=================================================================================================================================================================
			Call WriteToLog("Info","==========Testcase - Verify that the postponed checklist data for a particular patient is displayed after closing and opening the patient==========")
			
			
			'==================================
			'Click on the 'My Dashboard' tab
			'==================================
			ClickOnMainMenu("My Dashboard")
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			
			'=======================================================================
			'Check the existence of popup ADL screening current changes will be lost
			'=======================================================================
			blnReturnValue = checkForPopup(strPopupTitle, "Yes", ChangesNotSavePopupText, strOutErrorDesc)
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			If blnReturnValue Then
				Call WriteToLog("Pass","Navigation warning Popup screen message was displayed,and user discarded the changes. ")
			Else
				Call WriteToLog("Fail","Expected Result: Navigation warning message should be displayed ; Actual Result: Error return: "&strOutErrorDesc)
				Exit Function
			End If
			
'			'===================================================
			'Close all open patient and open the patient again.
			'===================================================
			isPass = CloseAllOpenPatient(strOutErrorDesc)
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			If Not isPass Then
				strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
				Call WriteToLog("Fail", strOutErrorDesc)
				Exit Function
			End If			
			
			
			'=================================================================
			'Go to Patient Profile through Global Search
			'=================================================================
			strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
			blnReturnValue = selectPatientFromGlobalSearch(strMemberID)
			If not blnReturnValue Then	
				Call WriteToLog("Fail","OpenPatientProfileFromActionItemsList returned: "&strOutErrorDesc)
				Exit Function
			End If
			
			'==================================================
			'Select ADL screening from the screening drop down
			'==================================================
			Call clickOnSubMenu("Screenings->ADL Screening")
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			
			'===========================================
			'Verify that ADL screening open successfully
			'===========================================
			'Create Object required for existance check of ADL screening screen
			Execute "Set objADLScreeningTitle = "  &Environment.Value("WEL_ADLScreeningTitle") 'ADL screening screen
			If objADLScreeningTitle.Exist(20) Then
				Call WriteToLog("Pass","ADL screening screen opened successfully")
			Else
				Call WriteToLog("Fail","ADL screening screen not opened successfully")
				Exit Function
			End If
			
			'==========================================================================================================================================
			'Verify that after navigation there is no impact on screening questions selected. 
			'Checking the 4 button are in green color we have to check object count should be 12
			'==========================================================================================================================================
			Set objAnswerSelectedGreen = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-1 acp-radio.*;DIV")
			Set objAnswerSelectedRed = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-2 acp-radio.*;DIV")
			If objAnswerSelectedGreen.Count = 12 and objAnswerSelectedRed.Count = 0 Then
				Call WriteToLog("Pass","Screen question selected same as previous only")
			Else
				Call WriteToLog("Fail","Screen question selected does not same as previous only")
				Exit Function
			End If
			
			'=================================================================================
			'Verify that no screening score will reflected in ADL score field after postpone.
			'=================================================================================
			Execute "Set objADLScore= "  &Environment.Value("WEL_ADLScreening_ADLScore")
			intADLScore = objADLScore.GetROProperty("value")
			If StrComp(intADLScore,"",1) = 0 Then
				Call WriteToLog("Pass","ADL Screening score is blank after postponeing the screening")
			Else
				Call WriteToLog("Fail","ADL Screening score is not blank after postponeing the screening")
			End If
			
			'==============================================================================================================================================================================
			'TC- 04 The purpose of this Test Case is to verify that for a particular patient's postponed checklist in the ADL Screening page, upon completing all the checklist items and 
			'		clicking the 'Save' button, the following occurs:
			'		a) Success message stating 'Screening has been completed successfully' should get displayed
			'		b) None of the activity checklists remain editable.
			'		c) Add button becomes enabled while Save, Postponed and Screening Date becomes disabled.
			'		Pre-Conditions:
			'		A patient for which already existing 'Postponed' checklist should exist
			'================================================================================================================================================================================
			
			Call WriteToLog("Info","==========Testcase - Verify user can complete the Postponed Questions and Save the screening successfully.==========")
			
			'=============================================================================
			'Get child object of rectangular radio button available on ADL screen screen
			'=============================================================================
			Set objADLScreeningAnswerCheckBox = GetChildObject("micclass;outerhtml;html tag","WebElement;.*height-100-percent  acp-radio  margin-left-0px.*;DIV")
			For i = 13 To 20 Step 1
				Err.Clear
				objADLScreeningAnswerCheckBox(i).Click 'Click on rectangular radio button
				If Err.Number <> 0 Then
					Call WriteToLog("Fail", "Unable to click on " & i - 1 & " rectangular radio button of ADL screening and Error returned: " & Err.Description)
					Exit Function
				End If
				i = i + 5
			Next
			
			'==========================
			'Click on save button
			'==========================
			Execute "Set objADLScreeningSaveButton= "  &Environment.Value("WEL_ADLScreening_SaveButton")
			If waitUntilExist(objADLScreeningSaveButton,5) Then
				Call WriteToLog("Pass","Save button is enable now")
				Err.Clear
				objADLScreeningSaveButton.Click
				wait intWaitTime
				waitTillLoads "Loading..."
				wait 2
				If Err.Number <> 0 Then
					Call WriteToLog("Fail","Save button does not clicked successfully")
					Exit Function
				End If
			Else
				Call WriteToLog("Pass","Save button is not enable")
				Exit Function
			End If
			
			'=====================================================================================================
			'Verify that Success message stating 'Screening has been completed successfully' should get displayed
			'=====================================================================================================
			Call WriteToLog("Info","==========Testcase - Verify the message is displayed for completing and Saving ADL Screening successfully. ==========")
			
			
			blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)
			Wait 2
				waitTillLoads "Loading..."
			wait 2
			If blnReturnValue Then
				Call WriteToLog("Pass","ADL Scrrening was successfully saved message was displayed. ")
			Else
				Call WriteToLog("Fail","Expected Result: ADL Scrrening was successfully saved message should be displayed; Actual Result: Error return: "&strOutErrorDesc)
				Exit Function
			End If

			'==============================================================
			'Verify that all question are selected for patient in screening 
			'==============================================================
			Set objAnswerSelectedGreen = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-1 acp-radio.*;DIV")
			Set objAnswerSelectedRed = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-2 acp-radio.*;DIV")
			If objAnswerSelectedGreen.Count = 18 and objAnswerSelectedRed.Count = 0 Then
				Call WriteToLog("Pass","All questions of the checklist is answered successfully")
			Else
				Call WriteToLog("Fail","All questions of the checklist does not answered successfully")
				Exit Function
			End If
					
			'========================================================================================================================
			'Verify Check the status of the input elements: Add button Save button Postpone button Screening Date should be disabled
			'========================================================================================================================
			Call WriteToLog("Info","==========Testcase - Verify Add button is enabled; Save button and Postpone button should be disabled ==========")
			
			Execute "Set objADLScreeningAddButton= "  &Environment.Value("WEL_ADLScreening_AddButton") 'ADL screening Add button
			Execute "Set objADLScreeningSaveButton= "  &Environment.Value("WEL_ADLScreening_SaveButton") 'ADL screening screen Save button
			Execute "Set objADLScreeningPostponeButton= "  &Environment.Value("WEL_ADLScreening_PostponeButton") 'ADL screening screen postpone button
			Execute "Set objCalenderDisable= "  &Environment.Value("WI_ADLScreening_CalenderIcon_Disable") 'Disable Calender icon
			
			If objADLScreeningAddButton.Exist(3) and not objADLScreeningSaveButton.Exist(3) and not objADLScreeningPostponeButton.Exist(3) Then
				Call WriteToLog("Pass","Add button is enabled. Save button, Screening Date and Postpone button are disabled")
			Else
				Call WriteToLog("Fail","Add button is disabled. Save button, Screening Date and Postpone button are enabled")
			End If
			
			'====================================================================
			'Verify the ADL score based on number of green color boxes selected
			'====================================================================
			Call WriteToLog("Info","==========Testcase - Verify the ADL score based on number of answers selected ==========")
			
			
			'Verify the presence of ADL screening score header
			Execute "Set objADLScreeningADLScoreHeader = " & Environment.Value("WEL_ADLScreening_ADLScoreHeader")
			If waitUntilExist(objADLScreeningADLScoreHeader,5) Then
				Call WriteToLog("Pass","ADL score header exist on ADL screening")
			Else
				Call WriteToLog("Fail","ADL score header does not exist on ADL screening")
			End If
			
			'Verify the presence of ADL screening score should be same as number of green color boxes selected.
			Execute "Set objADLScreeningADLScore = " & Environment.Value("WEL_ADLScreening_ADLScore")
			If waitUntilExist(objADLScreeningADLScore,5) Then
				Call WriteToLog("Pass","ADL score exist on ADL screening")
				intADLScreeningScore = Trim(objADLScreeningADLScore.GetROProperty("innertext"))
				
				If Cint(intADLScreeningScore) = Cint(objAnswerSelectedGreen.Count/3) Then
					Call WriteToLog("Pass","ADL score is same as number of green color boxes in screening")
				Else
					Call WriteToLog("Fail","ADL score is not same as number of green color boxes in screening")	
				End If
			Else
				Call WriteToLog("Fail","ADL score does not exist on ADL screening")
			End If
		
		Case "Previous"
			'===========================================================================
			'Get child object of rectangular radio button available on ADL screen screen
			'===========================================================================	
			Set objADLScreeningAnswerCheckBox = GetChildObject("micclass;outerhtml;html tag","WebElement;.*height-100-percent  acp-radio  margin-left-0px.*;DIV")
			For i = 1 To objADLScreeningAnswerCheckBox.Count-1 Step 1
				Err.Clear
				objADLScreeningAnswerCheckBox(i).Click 'Click on rectangular radio button
				If Err.Number <> 0 Then
					Call WriteToLog("Fail", "Unable to click on " & i - 1 & " rectangular radio button of ADL screening and Error returned: " & Err.Description)
					Exit Function
				End If
				i = i + 5
			Next
			
			'==========================
			'Click on postpone button
			'==========================
			Call WriteToLog("Info","==========Testcase - Click on Postpone button, postpones the survery and displays the message==========")
						
			Execute "Set objADLScreeningPostponeButton= "  &Environment.Value("WEL_ADLScreening_PostponeButton") 'ADL screening screen postpone button
			If CheckObjectExistence(objADLScreeningPostponeButton,5) Then
				Call WriteToLog("Pass","Postpone button is enable now")
				Err.Clear
				objADLScreeningPostponeButton.Click
				Wait 2
				waitTillLoads "Loading..."
				wait 2
				If Err.Number <> 0 Then
					Call WriteToLog("Fail","Postpone button is not clicked.")
					Exit Function
				End If
			Else
				Call WriteToLog("Fail","Postpone button is not enabled")
				Exit Function
			End If
			
			'==============================================================================================
			'Verify that Success message stating 'Survey has been saved successfully' should get displayed
			'==============================================================================================
			blnReturnValue = checkForPopup(strPopupTitle, "Ok", strPostponePopupText, strOutErrorDesc)
			Wait 2
				waitTillLoads "Loading..."
			wait 2
			If blnReturnValue Then
				Call WriteToLog("Pass","ADL Scrrening was successfully saved message was displayed. ")
			Else
				Call WriteToLog("Fail","Expected Result: 'ADL Scrrening was successfully saved' message should be displayed; Actual Result: Error return: "&strOutErrorDesc)
				Exit Function
			End If
			
			'==========================
			'Click on save button
			'==========================
			Execute "Set objADLScreeningSaveButton= "  &Environment.Value("WEL_ADLScreening_SaveButton")
			If CheckObjectExistence(objADLScreeningSaveButton,5) Then
				Call WriteToLog("Pass","Save button is enable now")
				Err.Clear
				objADLScreeningSaveButton.Click
				Wait 2
				waitTillLoads "Loading..."
				wait 2
				If Err.Number <> 0 Then
					Call WriteToLog("Fail","Save button does not clicked successfully")
					Exit Function
				End If
			Else
				Call WriteToLog("Pass","Save button is not enable")
				Exit Function
			End If
			
			Wait intWaitTime/5 'Sync Time for application
			'=====================================================================================================
			'Verify that Success message stating 'Screening has been completed successfully' should get displayed
			'=====================================================================================================
			Call WriteToLog("Info","==========Testcase - Verify that Success message stating 'Screening has been completed successfully' should get displayed==========")
			
			blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)
			Wait 2
				waitTillLoads "Loading..."
				wait 2
			If blnReturnValue Then
				Call WriteToLog("Pass","ADL Scrrening was successfully saved message was displayed. ")
			Else
				Call WriteToLog("Fail","Expected Result: ADL Scrrening was successfully saved message should be displayed; Actual Result: Error return: "&strOutErrorDesc)
				Exit Function
			End If
					
			'====================================================================
			'Verify the ADL score based on number of green color boxes selected
			'====================================================================
			Call WriteToLog("Info","==========Testcase - Verify the ADL score based on number of answers selected==========")
			
			
			'Verify the presence of ADL screening score header
			Execute "Set objADLScreeningADLScoreHeader = " & Environment.Value("WEL_ADLScreening_ADLScoreHeader")
			If CheckObjectExistence(objADLScreeningADLScoreHeader,intWaitTime) Then
				Call WriteToLog("Pass","ADL score header exist on ADL screening")
			Else
				Call WriteToLog("Fail","ADL score header does not exist on ADL screening")
			End If
			
			'==================================================================================================
			'Verify the presence of ADL screening score should be same as number of green color boxes selected.
			'==================================================================================================
			Execute "Set objADLScreeningADLScore = " & Environment.Value("WEL_ADLScreening_ADLScore")
			If CheckObjectExistence(objADLScreeningADLScore,intWaitTime) Then
				Call WriteToLog("Pass","ADL score exist on ADL screening")
				intADLScreeningScore = Trim(objADLScreeningADLScore.GetROProperty("innertext"))
				
				Set objAnswerSelectedGreen = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-1 acp-radio.*;DIV")
				
				If Cint(intADLScreeningScore) = Cint((objAnswerSelectedGreen.Count/3)) Then
					Call WriteToLog("Pass","ADL score is same as number of green color boxes in screening")
				Else
					Call WriteToLog("Fail","ADL score is not same as number of green color boxes in screening")	
				End If
			Else
				Call WriteToLog("Fail","ADL score does not exist on ADL screening")
			End If
		
	End Select
	
	
	'==========================================================================================================================
	'Verify the Screening history is updated with the newly added screening details.
	'==========================================================================================================================
	
	Call WriteToLog("Info","==========Testcase - Verify the Screening history is updated with the newly added screening details.==========")
	Execute "Set objScreeningDate = " & Environment("WE_ADLSCreening_ScreeningDate")
	screeningdate = objScreeningDate.GetROProperty("value")
	blnReturnValue  = ADLScreening_ValidateHistory(screeningdate, intADLScreeningScore)
	
	If blnReturnValue Then
	
		Call WriteToLog("Pass","ADL screening values are updated in the History tab")
		
	Else
	
		Call WriteToLog("Fail","Expected Result: ADL screening values are updated in the History tab. Actual Result:ADL screening values are not updated in the History tab")	
				
	End If
	
	
	
	ADLScreening = True




End Function

Function FreeObjects
	
	Execute "Set objADLScreeningTitle = Nothing"  
	Execute "Set objADLScreeningAddButton= Nothing" 
	Execute "Set objADLScreeningPostponeButton= Nothing"  
	Execute "Set objADLScreeningSaveButton= Nothing"  
	Execute "Set objCalenderDisable= Nothing"  
	Execute "Set objADLScreeningADLScore = Nothing" 
	
End Function


'***********************************************************************************************************************************************************************
'Function Name 		: ADLScreening_ValidateHistory
'Purpose	  		: Validate the history data for the ADL Screening 
'Input Arguments    : Screening Completed date
'Output Arguments   : Boolean value: validation successful or not
'***********************************************************************************************************************************************************************


Function ADLScreening_ValidateHistory(Byval dtScreeningCompletedDate, Byval dtScreeningScore)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ADLScreening_ValidateHistory = False
	
	
	'=========================
	'Objects Initialization
	'=========================
	Execute "Set objDS_ScrHistUpArw = "  &Environment.Value("WEL_ADLSCreening_HistoryUpArrow") 'ADL screening History tab up arrow
	Execute "Set objDS_ScrHtryTable= "  &Environment.Value("WT_ADLSCreening_HistoryTable") 'ADL Screening History table
	Execute "Set objDS_ScrHistDnArw= "  &Environment.Value("WEL_ADLSCreening_HistoryDwnArrow") 'ADL screening History tab down arrow
	
	
	'Set objDS_ScrHistUpArw = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").Image("file name:=uparrow.*","html tag:=IMG","outerhtml:=.*padding-bottom.*","image type:=Plain Image","visible:=True")
	
	'click on screening history expand arrow icon
	If waitUntilExist(objDS_ScrHistUpArw,intWaitTime/4) Then
		Err.Clear
		objDS_ScrHistUpArw.Click
		If Err.Number <> 0 Then
			Call WriteToLog("Fail", "Unable to click on Screening history expand arrow icon, Error Returned: "&Err.Description )
			Exit Function
		Else
			Call WriteToLog("Pass", "Clicked on the Screening history expand arrow icon")		
		End If
	Else
		Call WriteToLog("Fail", "Failed to Clicked on history expand arrow")
		Exit Function
		
	End if
	
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2
	
	Execute "Set objDS_ScrHtryTableHdr = " & Environment("WT_ADLSCreening_HistoryTableHdr")
	columnNames = objDS_ScrHtryTableHdr.getroproperty("column names")
	
	reqColNames = DataTable.Value("HistoryColumnNames", "CurrentTestCaseData")
	If trim(columnNames) = trim(reqColNames) Then
		Call WriteToLog("Pass", "Required columns exist in the History Table")
	Else
		Call WriteToLog("Fail", "Required columns does not exist in the History Table")
	End If
	'Validate the history table entries
	RowCount = objDS_ScrHtryTable.RowCount
	If RowCount = "" OR RowCount = 0 Then
		strOutErrorDesc = "History table is not populated with screening details"
		Exit Function
	End If
	
	Call WriteToLog("Pass", "History table is populated with screening details and number of entries are : " & RowCount)

	'validate the count of history records is correct with db
	isPass = ConnectDB()
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
		Call CloseDBConnection()
		Exit Function
	End If
	strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
	getRowCount = getScreeningHistoryCount(1, strMemberID)
	
	If CInt(getRowCount)  = CInt(RowCount) Then
		Call WriteToLog("Pass", "History row count is as required : " & RowCount)
	Else
		Call WriteToLog("Fail", "History row count is NOT as required. History in UI has " & RowCount & ", where as required is " & getRowCount)
	End If
	
	'validate current screening data with UI and DB
	
	Set recordData = getScreeningHistory(1, strMemberID, dtScreeningCompletedDate)
	Dim recordExists : recordExists = false
	If not isObject(recordData) Then
		Call WriteToLog("Fail", "No records in DB with given screening date " & dtScreeningCompletedDate & " for the member " & strMemberID)
	Else
		Call CloseDBConnection()
		recordExists = true
	End If
	Dim dbRecordMatch : dbRecordMatch = False
	If recordExists Then
		For i = 1 To RowCount
			screenDate = objDS_ScrHtryTable.GetCellData(i, 1)
			If CDate(screenDate) = CDate(dtScreeningCompletedDate) Then
				If FormatDateTime(CDate(screenDate),2) = FormatDateTime(CDate(recordData.Item("MEM_SRV_SURVEY_DATE")), 2) Then
					Score = objDS_ScrHtryTable.GetCellData(i, 2)
					ScreeningLevel = objDS_ScrHtryTable.GetCellData(i, 3)
					dbScore = recordData.Item("MEM_SRV_SCORE")
					dbLevel = recordData.Item("MEM_SRV_LEVEL")
					If Not CInt(Score) = Cint(dbScore) Then
						Call WriteToLog("Fail", "Scores does not match between history(" & Score & ") and DB(" & dbScore & ")")
					End If
					
					If not Cint(ScreeningLevel) = Cint(dbLevel) Then
						Call WriteToLog("Fail", "Levels does not match between history(" & ScreeningLevel & ") and DB(" & dbLevel & ")")
					End If
					dbRecordMatch = true
					Exit For
				Else
					Call WriteToLog("Fail", "Screening date in DB does not match the required screening date")
					Exit For
				End If
			End If
		Next
	End If
	
	If not dbRecordMatch Then
		Call WriteToLog("Fail", "No record found in screening history with screening completed date as - " & dtScreeningCompletedDate)
	End If
	
'	strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
'	
	
	'Get current and previous screening	information from screening history table	
	For R = 1 To RowCount Step 1
		ReDim Preserve arrScreeningHistoryInfo(RowCount-1)
		ColumnCount = objDS_ScrHtryTable.ColumnCount(R)
		For C = 1 To objDS_ScrHtryTable.ColumnCount(R)-1 Step 1
				If C = 1 Then
					dtCompletedDateHT = objDS_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 2 Then
					intScore = objDS_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 3 Then
					intScreeningLevel = objDS_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 4 Then
					strLevelComments = objDS_ScrHtryTable.GetCellData(R,C)	
'				ElseIf C = 5 Then
'					strSurveyComments = objDS_ScrHtryTable.GetCellData(R,C)
				End If
		Next
		arrScreeningHistoryInfo(R-1) = dtCompletedDateHT & "|" & intScore & "|" & intScreeningLevel & "|" & strLevelComments 
	Next
	
	'Validate the latest screening details from the history table
	Dim isFound : isFound = false
	For i = 0 To UBound(arrScreeningHistoryInfo)
		hist = split(arrScreeningHistoryInfo(i),"|")
		If CDate(hist(0)) = CDate(dtScreeningCompletedDate) Then
			If dtScreeningScore = hist(1) Then
				Call WriteToLog("Pass", "Recently added screening details found in history table - 'Score: " & hist(1) & "' for the date - '" & hist(0) & "'")
				isFound = true
				Exit For
			End If
		Else
			Call WriteToLog("Pass", "Screening details in history table - 'Score: " & hist(1) & "' for the date - '" & hist(0) & "'")
		End If
	Next
	
	If not isFound Then
		Call WriteToLog("info", "Recently added screening details with Score - '" & dtScreeningScore & "' for the date - '" & dtScreeningCompletedDate & "' is not found in history table.")
	End If
		
	ADLScreening_ValidateHistory = True
	
	'Set objDS_ScrHistDnArw = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").Image("file name:=downarrow.*","html tag:=IMG","outerhtml:=.*padding-bottom.*","image type:=Plain Image","visible:=True")
	objDS_ScrHistDnArw.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Err.Clear
	Execute "Set objDS_ScrHistUpArw = Nothing"
	Execute "Set objDS_ScrHtryTable = Nothing"
	Execute "Set objDS_ScrHistDnArw = Nothing"
	
End Function
