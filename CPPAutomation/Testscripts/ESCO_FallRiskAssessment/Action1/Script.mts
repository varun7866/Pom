'**************************************************************************************************************************************************************************
' TestCase Name				: Esco FallRiskAssessment
' Purpose of TC				: Validate Esco fall risk assessment screening functionality
'							: If the task is found for the Esco  patient, it will validate the task and then the functionality of the ESCO fall risk Screening.
'							: If the task is not found for the Esco  patient, it will validate the functionality of the ESCO fall risk Screening from the Screening menu.
' Author               		: Sharmila
' Date                 		: 10 February 2016
'**************************************************************************************************************************************************************************
'--------------
'Initialization
'--------------
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file

'Load the WaitTime from Configuration file
intWaitTime =Environment.Value("WaitTime") 

'Load library file
functionalLibFolder = Environment.Value("PROJECT_FOLDER") & "\Library\generic_functions"
For each objFile in objFso.GetFolder(functionalLibFolder).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" Then
		LoadFunctionLibrary objFile.Path
	End If
Next

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ESCOFallRiskAssessment", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Load SNP library
SNP_Library = Environment.Value("PROJECT_FOLDER") & "\Library\SNP_functions"
For each SNPlibfile in objFso.GetFolder(SNP_Library).Files
	If UCase(objFso.GetExtensionName(SNPlibfile.Name)) = "VBS" Then
		LoadFunctionLibrary SNPlibfile.Path
	End If
Next
Set objFso = Nothing

'Get all required scenarios
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)

	'---------------------------
	' Variable initialization
	'---------------------------
	strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
	lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
	dtEnrolledDate = DataTable.Value("EnrolledDate","CurrentTestCaseData")
	dtScreeningDt = DataTable.Value("ScreeningDate","CurrentTestCaseData") 
	dtCompletedDt = DataTable.Value("CompletedDate","CurrentTestCaseData")  
	strDomain = DataTable.Value("Domain","CurrentTestCaseData")
	strTask = DataTable.Value("Task","CurrentTestCaseData")
	strTestAllFunctionalities = DataTable.Value("TestAllFunctionalities","CurrentTestCaseData") 


	'Execution as required
	If not Lcase(strExecutionFlag) = "y" Then Exit Do

		'-------------------------------Execution------------------------------------
		On Error Resume Next
		Err.Clear

		'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
		blnNavigator = Navigator("vhn", strOutErrorDesc)
		If not blnNavigator Then
			Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
			Call Terminator											
		End If
		Call WriteToLog("Pass","Navigated to user dashboard")

		'Open required patient in assigned VHN user
		strGetAssingnedUserDashboard = GetAssingnedUserDashboard(lngMemberID, strOutErrorDesc)
		If strGetAssingnedUserDashboard = "" Then
			Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user.  Actual Result: Unable to open required patient in assigned VHN user."&strOutErrorDesc)
			Call Terminator
		End If
		Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
		Wait 2

		'Navigate to Menu of Actions > Required domain > select required task
		blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
		Wait 2

		If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
			Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should be available under '"&strDomain&"' domain; Actual Result: "&strOutErrorDesc)
			'Call Terminator
			'If there is no task found for that patient, Countinue doing the Esco Fall Risk Assessment from the menu.
			Call WriteToLog("Info", "==========================TestCase - Verify the Esco Fall Risk Assessment from the Menu without navigating from the task ==========================")
			'================================================================================
			'Select ESCO Fall Risk Assessment screening from the screening drop down
			'================================================================================
			Call clickOnSubMenu("Screenings->ESCO Fall Risk Assessment")
			Wait 2
			waitTillLoads "Loading..."
			wait 2
		
			blnESCOFallRiskAssessmentScreening = ESCOFallRiskAssessmentScreening(strOutErrorDesc)
			If not blnESCOFallRiskAssessmentScreening Then
				Call WriteToLog("Fail", "Expected Result: Should be able to perform 'Esco Fall Risk Assessment screening; Actual Result: Unable to perform 'Esco Fall Risk Assessment' screening: "&strOutErrorDesc)
				Call Terminator		
			End If
			Call WriteToLog("Pass", "Validated Esco Fall Risk Assessment screening")
			Wait 2

		ElseIf not blnDomainTasks Then
			Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
		ElseIf blnDomainTasks Then
			'Testcase: Verify upon clicking ‘Initial Fall Risk Screening’ task would navigate to ‘Fall Risk Assessment’ screen. Also perform 'Fall Risk Assessment screening and save.
			blnESCOFallRiskAssessmentScreening = ESCOFallRiskAssessmentScreening(strOutErrorDesc)
			If Instr(1,strOutErrorDesc,"Esco Fall Risk Assessment screen is not available",1) > 0 Then
				Call WriteToLog("Fail", "Expected Result: User should be navigated to 'Esco Fall Risk Assessment' screen when clicked on '"&strTask&"'; Actual Result: "&strOutErrorDesc)
				Call Terminator
			ElseIf not blnESCOFallRiskAssessmentScreening Then
				Call WriteToLog("Fail", "Expected Result: Should be able to perform 'Esco Fall Risk Assessment screening; Actual Result: Unable to perform 'Esco Fall Risk Assessment' screening: "&strOutErrorDesc)
				Call Terminator		
			End If
			Call WriteToLog("Pass", "Validated Esco Fall Risk Assessment screening")
			Wait 2
			'--------------------------------------------
			'Logout and login  for changes to happen	
			Call WriteToLog("Info","-------------------Logout of application-------------------")
			Call Logout()
			Wait 2
			
			'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
			blnNavigator = Navigator("vhn", strOutErrorDesc)
			If not blnNavigator Then
				Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
				Call Terminator											
			End If
			Call WriteToLog("Pass","Navigated to user dashboard")

			'Open required patient in assigned VHN user
			strGetAssingnedUserDashboard = GetAssingnedUserDashboard(lngMemberID, strOutErrorDesc)
			If strGetAssingnedUserDashboard = "" Then
				Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user.  Actual Result: Unable to open required patient in assigned VHN user."&strOutErrorDesc)
				Call Terminator
			End If
			
			Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
			Wait 2
			'--------------------------------------------
			'Testcase: Verify the task gets closed when user performs 'Esco Fall Risk Assessment' screening
			blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
			If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
				Call WriteToLog("Pass", "'"&strTask&"' task under '"&strDomain&"' domain got closed after performing 'Esco Fall Risk Assessment' screening as expected")
			ElseIf not blnDomainTasks Then
				Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
				Call Terminator
			ElseIf blnDomainTasks Then
				Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task under '"&strDomain&"' domain should be closed after performing 'Esco Fall Risk Assessment' screening; Actual Result: '"&strTask&"' task is not closed")
				Call Terminator		
			End If
		End If
	
		'logout of the application
		Call WriteToLog("Info","-------------------Logout of application-------------------")
		Call Logout()
		Wait 2
	
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


'================================================================================================================================================================================================
'Function Name       :	ESCOFallRiskAssessmentScreening
'Purpose of Function :	1.Perform Esco Fall Risk Assessment screening, 2.validate other functionalities - Postpone
'Output Arguments    :	Boolean value: representing FallRiskAssessment screening
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnFallRiskAssessmentScreening = FallRiskAssessmentScreening(dtScreeningDt, dtCompletedDt, arrAnswerOption, strTestAllFunctionalities, strOutErrorDesc)
'Author				 :  Sharmilsa
'Date				 :	10-Feb-2016
'================================================================================================================================================================================================
Function ESCOFallRiskAssessmentScreening( strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	
	strOutErrorDesc = ""
	ESCOFallRiskAssessmentScreening = False
	
	'Objects required	
	Execute "Set objPage_EFRA = "&Environment("WPG_AppParent")	'page object
	Execute "Set objEFRA_Header = "&Environment("WEL_EFRA_Header")	'Esco Fall risk assessment screen header
	Execute "Set objEFRA_Add = "&Environment("WEL_EFRA_Add")	'Esco Fall risk assessment Add button
	Execute "Set objEFRA_ScrDt = "&Environment("WE_EFRA_ScrDt")	'Esco Fall risk assessment Screening date edit box
	Execute "Set objEFRA_RiskScore = "&Environment("WEL_EFRA_RiskScore")	'Esco Fall risk assessment score
	Execute "Set objEFRA_Save = "&Environment("WEL_EFRA_Save")	'Esco Fall risk assessment save btn
	Execute "Set objEFRA_ScreeningQues = "&Environment("WEL_EFRA_ScrnQuestions") 'Esco Fall risk assessment questions
	Execute "Set objEFRA_Postpone = "&Environment("WEL_EFRA_Postpone") 'Esco fall risk assessment postpone button
	


	'check whether navigated to 'Esco Fall Risk Assessment' screen
	If not objEFRA_Header.Exist(10) Then
		strOutErrorDesc = "Esco Fall Risk Assessment screen is not available"
		Exit Function
	End If 
	Call WriteToLog("Pass", "Navigated to 'Esco Fall Risk Assessment' screen")
	
	'Validating status of Add, Postpone and Save buttons in 'Esco Fall Risk Assessment' screen
	If not objEFRA_Add.Object.isDisabled Then 'Fresh screening
		If objEFRA_Postpone.Object.isDisabled AND objEFRA_Save.Object.isDisabled Then
			Call WriteToLog ("Pass", "Add btn is enabled and Postpone, Save buttons are disabled - Option for adding fresh screening")
		End If
	ElseIf objEFRA_Add.Object.isDisabled Then 'Screening existing - continue or restart
		If not objEFRA_Postpone.Object.isDisabled AND objEFRA_Save.Object.isDisabled Then
			Call WriteToLog("Pass", "Add and Save buttons are disabled. Postpone button is enabled - Option for going forward with existing screening")
		End If
	Else 
		strOutErrorDesc = "Esco Fall Risk screening page buttons are not available as expected"
		Exit Function
	End If
	
	'Click Add btn (for fresh screening)
	If not objEFRA_Add.Object.isDisabled Then
	
		blnFRA_Add = ClickButton("Add",objEFRA_Add,strOutErrorDesc)
		If not blnFRA_Add Then
			strOutErrorDesc = "Unable to click Esco Fall Risk Assessment Add button: "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked on screening Add btn")
	 	Wait 2
	 	
		Call waitTillLoads("Loading Esco Fall Risk Screening...")
		Wait 1
		'Set screening date
		Err.clear
		objEFRA_ScrDt.Set Date
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set Esco Fall Risk Assessment screening date"
			Exit Function
		End If
		Call WriteToLog("Pass", "Screening date is set")
		Wait 2
		
	End If
	
	'objects for Screening question and screening answer options
	Set objEFRA_ScreeningQues = GetChildObject("micclass;attribute/data-capella-automation-id","WebElement;label-question.Text")
	Set objEFRA_ScreeningRadioOpts = GetChildObject("micclass;html tag;outerhtml","WebElement;DIV;.*changeOptionOnQuestion.*")
	
	'Validate screening questions
	EFRAScreeningQuesCount = objEFRA_ScreeningQues.count
	
	ScreeningAnswerCount = objEFRA_ScreeningRadioOpts.count
	If EFRAScreeningQuesCount = "" OR EFRAScreeningQuesCount = 0 Then
		strOutErrorDesc = "No screening questions existing in the screen"
		Exit Function		
	End If
	Call WriteToLog("Pass", "EFRA screening questions count is: "&FRAScreeningQuesCount)
	
	
	'========================================================================================================================
	'Verify the functionality of the first Question, When selected 0 Fall, user should be allowed to Save the screening	
	'========================================================================================================================
	Call WriteToLog("Info",  "==========================Testcase - Verify the functionality of the first Question, When selected 0 Fall, user should be allowed to Save the screening==========================")
	
	'click the Radio button for 0 Falls
	objEFRA_ScreeningRadioOpts(0).Click
	Wait 1
	
	'Save screening
	If not objEFRA_Save.Object.isDisabled Then
		blnFRA_Save = ClickButton("Save",objEFRA_Save,strOutErrorDesc)
		If not blnFRA_Save Then
			strOutErrorDesc = "Esco Fall risk assessment save btn is not clicked. Error returned: "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass", "Esco Fall risk assessment save btn is clicked")
		Wait 2
	Else
		Call WriteToLog("Fail",  "Save buttons is disabled, when the Question 1 is selected with 0 Falls")
		Exit Function
	
	End if
	
	Call waitTillLoads("Saving Esco Fall Risk Screening...")
	Wait 2
	
	'Validate Screening success message
	blnFRA_SavedPP = checkForPopup("Esco Fall Risk Assessment Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not blnFRA_SavedPP Then
		strOutErrorDesc = "Esco FRA saved confirmation popup is not displayed"
		Exit Function
	End If
	Call WriteToLog("Pass", "Screening Saved Successfully Message box is displayed.")

	
	wait intWaitTime/2
	
	Set objEFRA_ScreeningQues = Nothing
	Set objEFRA_ScreeningRadioOpts = Nothing
	Set objEFRA_ScreeningQues = GetChildObject("micclass;attribute/data-capella-automation-id","WebElement;label-question.Text")
	Set objEFRA_ScreeningRadioOpts = GetChildObject("micclass;html tag;outerhtml","WebElement;DIV;.*changeOptionOnQuestion.*")
	
	'========================================================================================================================
	'Add one more screening and Verify the Save button is enabled, when Option for the first Question is selected as 1 Fall
	'========================================================================================================================
	Call WriteToLog("Info",  "==========================Testcase - Verify if the Save button is enabled, when Option for the first Question is selected as 1 Fall==========================")

	'Click Add btn and start a new screening
	
	If not objEFRA_Add.Object.isDisabled Then
		blnFRA_Add = ClickButton("Add",objEFRA_Add,strOutErrorDesc)
		If not blnFRA_Add Then
			strOutErrorDesc = "Unable to click Esco Fall Risk Assessment Add button: "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked on screening Add btn")
	 	Wait 2
	 	
		Call waitTillLoads("Loading Esco Fall Risk Screening...")
		Wait 1
				
	End If
	
	
	'========================================================================================================================
	'Each radio button/Check box  is counted as each number. So there are totally 37 option under each question. 
	'To Select each option, go through from 0 to 36 and give as objEFRA_ScreeningRadioOpts(0).Click
	'========================================================================================================================
	
	Set objEFRA_ScreeningQues = GetChildObject("micclass;attribute/data-capella-automation-id","WebElement;label-question.Text")
	Set objEFRA_ScreeningRadioOpts = GetChildObject("micclass;html tag;outerhtml","WebElement;DIV;.*changeOptionOnQuestion.*")
		
	
	'click the Radio button for 1 Fall
	objEFRA_ScreeningRadioOpts(1).Click
	Wait 1
	
	'Save button should be enabled
	If not objEFRA_Save.Object.isDisabled Then
		Call WriteToLog("Pass", "Save button is enabled, when the option is selected as 1 Fall for the first Question.")
	Else
		Call WriteToLog("Fail",  "Save buttons is disabled, when the Question 1 is selected with 1 Fall")
	End if
	

	'================================================================================================
	'Continue the Screening and Complete few questions and Verify the postpone functionality
	'================================================================================================
	Call WriteToLog("Info",  "==========================Testcase - Complete few questions and Verify the postpone functionality==========================")
	
   'screening with required answers
	For EFRAQuestion = 1 To 4 Step 1
		Set objEFRA_ScreeningQues = GetChildObject("micclass;attribute/data-capella-automation-id","WebElement;label-question.Text")
		Set objEFRA_ScreeningRadioOpts = GetChildObject("micclass;html tag;outerhtml","WebElement;DIV;.*changeOptionOnQuestion.*")
		Select Case EFRAQuestion
			Case 1: 'Verify the functionality of Question 1
			
				objEFRA_ScreeningRadioOpts(2).Click
				'Save button should not enabled until we complete all the questions
				If objEFRA_Save.Object.isDisabled Then
					Call WriteToLog("Pass", "Save button is disabled, when the option is selected as 1 Fall that resulted in Fracture. User should continue with fall risk ")
				Else
					Call WriteToLog("Fail",  "Save buttons is disabled, when the Question 1 is selected with 1 Fall")
				End if	
			
			Case 2:
				objEFRA_ScreeningRadioOpts(5).Click
				
			Case 3:
				objEFRA_ScreeningRadioOpts(7).Click
				objEFRA_ScreeningRadioOpts(8).Click
				
			Case 4:
				objEFRA_ScreeningRadioOpts(11).Click
			
		End Select
		Set objEFRA_ScreeningQues = Nothing
		Set objEFRA_ScreeningRadioOpts = Nothing
	Next	

	'=================================================================================================================================================================
	'Navigate to some other screen ('Home Safety Screening') without clicking postpone button - user should get a warning msg
	'=================================================================================================================================================================
	Call WriteToLog("Info","==========================Testcase - Navigate to some other screen ('My Dashboard') without clicking postpone button - user should get a warning msg==========================")
	
	
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
	blnReturnValue = checkForPopup("ESCO Fall Risk Assessment Screening", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If blnReturnValue Then
		Call WriteToLog("Pass","Navigation warning Popup screen message was displayed. ")
	Else
		Call WriteToLog("Fail","Expected Result: Navigation warning message should be displayed ; Actual Result: Error return: "&strOutErrorDesc)
		Exit Function
	End If
	
	'====================================================================
	'Click postpone button and then navigate to some other screen.
	'====================================================================
	blnClickedPostponeBtn = ClickButton("Postpone",objEFRA_Postpone,strOutErrorDesc)
	If not blnClickedPostponeBtn Then
		strOutErrorDesc = "Postpone button click returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on postpone button")
	Wait 2
	
	Call waitTillLoads("Saving Fall Risk Screening...")
	Wait 2
	
	'Check for save confirmation popup
	blnFRA_SavedPP = checkForPopup("ESCO Fall Risk Assessment Screening", "Ok", "Screening has been saved successfully", strOutErrorDesc)
	If not blnFRA_SavedPP Then
		strOutErrorDesc = "'Screening has been saved successfully' message box for postpone (interim save popup) is not available"
		Exit Function
	End If
	Call WriteToLog("Pass", "Screening was postponed and the questions were saved")
	Wait 2
	
	
	'===============================================================================
	'Click on the 'My Dashboard' tab again, it should not throw any pop up message
	'===============================================================================
	ClickOnMainMenu("My Dashboard")
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	
	
	'===================================================
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
		Call WriteToLog("Fail","selectPatientFromGlobalSearch returned: "&strOutErrorDesc)
		Exit Function
	End If
	
	'================================================================================
	'Select ESCO Fall Risk Assessment screening from the screening drop down
	'================================================================================
	Call clickOnSubMenu("Screenings->ESCO Fall Risk Assessment")
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'===========================================
	'Verify that ADL screening open successfully
	'===========================================
	'check whether user is navigated to 'ESCO Fall Risk Assessment' screen
	If not objEFRA_Header.Exist(10) Then
		strOutErrorDesc = "EscoFall Risk Assessment screen is not available"
		Exit Function
	End If 
	Call WriteToLog("Pass", "Navigated to 'Esco Fall Risk Assessment' screen")
	
	'Validating status of Add, Postpone and Save buttons in 'Esco Fall Risk Assessment' screen
	If objEFRA_Add.Object.isDisabled Then 'Screening existing - continue or restart
		If not objEFRA_Postpone.Object.isDisabled AND objEFRA_Save.Object.isDisabled Then
			Call WriteToLog("Pass", "Add and Save buttons are disabled. Postpone button is enabled - Option for going forward with existing screening")
		End If
	Elseif not objEFRA_Add.Object.isDisabled Then 'Fresh screening
		If objEFRA_Postpone.Object.isDisabled AND objEFRA_Save.Object.isDisabled Then
			Call WriteToLog ("Fail", "Add btn is enabled and Postpone, Save buttons are disabled - Old screening was not saved successfully")
		End If
	Else
		strOutErrorDesc = "Esco Fall Risk screening page buttons are not available as expected"
		Exit Function
	End If
	
	'====================================================================================================
	'Continue the Screening with the existing answers and Complete the rest of the screening and Save it
	'====================================================================================================
	Call WriteToLog("Info",  "==========================Testcase - Continue the Screening with the existing answers and Complete the rest of the screening and Save it==========================")
	
	
	
	'screening with required answers
	For EFRAQuestion = 5 To 10 Step 1
		
		Set objEFRA_ScreeningQues = GetChildObject("micclass;attribute/data-capella-automation-id","WebElement;label-question.Text")
		Set objEFRA_ScreeningRadioOpts = GetChildObject("micclass;html tag;outerhtml","WebElement;DIV;.*changeOptionOnQuestion.*")
	
		Select Case EFRAQuestion
			Case 5: 'Verify the functionality of Question 5
			
				objEFRA_ScreeningRadioOpts(13).Click
			
			Case 6:
				objEFRA_ScreeningRadioOpts(15).Click
				objEFRA_ScreeningRadioOpts(16).Click
				
			Case 7:
				objEFRA_ScreeningRadioOpts(21).Click
				objEFRA_ScreeningRadioOpts(22).Click
				
			Case 8:
				objEFRA_ScreeningRadioOpts(23).Click
				objEFRA_ScreeningRadioOpts(25).Click
				objEFRA_ScreeningRadioOpts(27).Click
				objEFRA_ScreeningRadioOpts(29).Click
				objEFRA_ScreeningRadioOpts(31).Click
			Case 9:
				objEFRA_ScreeningRadioOpts(33).Click
				
			Case 10:
				objEFRA_ScreeningRadioOpts(36).Click
				
		End Select
		
		Set objEFRA_ScreeningQues = Nothing
		Set objEFRA_ScreeningRadioOpts = Nothing
		
	Next	
	'Save screening
	Execute "Set objEFRA_Save = Nothing"
	Execute "Set objEFRA_Save = "&Environment("WEL_EFRA_Save")	'Esco Fall risk assessment save btn
	blnFRA_Save = ClickButton("Save",objEFRA_Save,strOutErrorDesc)
	If not blnFRA_Save Then
		strOutErrorDesc = "Esco Fall risk assessment save btn is not clicked. Error returned: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Esco Fall risk assessment save btn is clicked")
	Wait 2
	
	Call waitTillLoads("Saving Esco Fall Risk Screening...")
	Wait 2
	
	'Validate Screening success message
	blnFRA_SavedPP = checkForPopup("Fall Risk Assessment Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not blnFRA_SavedPP Then
		strOutErrorDesc = "FRA saved confirmation popup is not available"
		Exit Function
	End If
	Call WriteToLog("Pass", "Saved FRA screening, accepted confirmation popup")

	
	
	Call WriteToLog("Pass", "Completed Fall Risk assessment screening successfully")
	
	ESCOFallRiskAssessmentScreening = True
	
	Execute "Set objPage_FRA = Nothing"
	Execute "Set objEFRA_Header = Nothing"
	Execute "Set objEFRA_Add = Nothing"
	Execute "Set objEFRA_ScrDt = Nothing"
	Execute "Set objEFRA_RiskScore = Nothing"
	Execute "Set objEFRA_Save = Nothing"
	Set objEFRA_ScreeningQues = Nothing
	Set objEFRA_ScreeningRadioOpts = Nothing
			
End Function
