' TestCase Name			: PAM Survey
' Purpose of TC			: To perform PAM Survey
' Author                : Sudheer
' Comments				: 
'**************************************************************************************************************************************************************************
'***********************************************************************************************************************************************************************\
'Initialization steps for current script
'***********************************************************************************************************************************************************************
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PAMSurvey", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'***********************************************************************************************************************************************************************
'End of Initialization steps for the current script
'***********************************************************************************************************************************************************************
'=====================================
' Objects required for test execution
'=====================================
Function loadObjects()
	Execute "Set objPAMSurveyTitle = "  &Environment.Value("WEL_PAMSurveyScreenTitle") 'PAM Survey screen title
	Execute "Set objPAMSurveyDate = " &Environment.Value("WE_PAMSurvey_ScreeningDate") 'PAM Survey screen > Date object
	Execute "Set objPAMSurveyScore = " & Environment.Value("WEL_PAMSurvey_Score")	  'PAM Survey screen > score objecr
	Execute "Set objPAMSurveyPAMLevel = " & Environment.Value("WEL_PAMSurvey_Level")	  'PAM Survey screen > Level object
	Execute "Set objPAMSurveyAddButton= "  &Environment.Value("WEL_PAMSurvey_AddButton") 'PAM Survey screen Add button
	Execute "Set objPAMSurveyPostponeButton= "  &Environment.Value("WEL_PAMSurvey_PostponeButton") 'PAM Survey screen postpone button
	Execute "Set objPAMSurveySaveButton= "  &Environment.Value("WEL_PAMSurvey_SaveButton")	'PAM Survey screen Save button
End Function

Function killAllObjects()
		Execute "Set objPAMSurveyTitle = Nothing"
		Execute "Set objPAMSurveyDate = Nothing"
		Execute "Set objPAMSurveyScore = Nothing"
		Execute "Set objPAMSurveyPAMLevel = Nothing"
		Execute "Set objPAMSurveyAddButton= Nothing"
		Execute "Set objPAMSurveyPostponeButton= Nothing"
		Execute "Set objPAMSurveySaveButton= Nothing"
End Function

'=====================================
'start test execution
'=====================================
Call WriteToLog("info", "Test case - Create a new patient using VHN role")
'Login to Capella as VHN
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	Logout
	CloseAllBrowsers
	killAllObjects
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")
Dim isRun
isRun = false
intRowCount = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCount step 1
	DataTable.SetCurrentRow(RowNumber)
	
	runflag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
	
	If trim(lcase(runflag)) = "y" Then
		'close all open patients
		isRun = true
		isPass = CloseAllOpenPatient(strOutErrorDesc)
		If Not isPass Then
			strOutErrorDesc = "Failed to close all patients."
			Call WriteToLog("Fail", strOutErrorDesc)
			Logout
			CloseAllBrowsers
			Call WriteLogFooter()
			ExitAction
		End If
	
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
		
		'wait till the member loads
		wait 2
		waitTillLoads "Loading..."
		wait 2
		
		Call WriteToLog("info", "Test Case - PAM Survey for the member id - " & strMemberID)
		
		isPass = pamSurvey()
		If Not isPass Then
			Call WriteToLog("Fail", "PAM Survey  failed for the member - " & strMemberID )
		Else
			Call WriteToLog("Pass", "PAM Survey succesfully completed for the member - " & strMemberID )
		End If
	End If	
Next

If not isRun Then
	Call WriteToLog("info", "There are No rows marked Y(Yes) for execution.")
End If

Logout
CloseAllBrowsers
WriteLogFooter

Function pamSurvey()
	pamSurvey = false
	intWaitTime = 5
	
	Call WriteToLog("info", "Test Case - Validate PAM Survey buttons")
	
	'click on PAM Survey
	clickOnSubMenu("Screenings->PAM Survey")
		
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'verify if PAM Survey screen loaded
	Execute "Set objPAMSurveyTitle = "  &Environment.Value("WEL_PAMSurveyScreenTitle") 'PAM Survey screen title
	If not CheckObjectExistence(objPAMSurveyTitle, 10) Then
		Call WriteToLog("Fail","PAM Survey screen not opened successfully")
		Exit Function
	End If
	
	Call WriteToLog("Pass","PAM Survey screen opened successfully")
	
	'load all objects required in PAM Survey
	loadObjects
	
	'Verify the existence of Screening Date	
	If CheckObjectExistence(objPAMSurveyDate,5) Then
		Call WriteToLog("Pass","Screening date exist on PAM Survey screening")		
	Else
		Call WriteToLog("Fail","Screening date not exist on PAM Survey screening")
	End If
	
	'Verify the existence of PAM Survey score
	If CheckObjectExistence(objPAMSurveyScore,5) Then
		Call WriteToLog("Pass","PAM Survey score exist on PAM Survey screening")		
	Else
		Call WriteToLog("Fail","PAM Survey score does not exist on PAM Survey screening")	
	End If
	
	'Verify the existence of PAM level
	If CheckObjectExistence(objPAMSurveyPAMLevel,5) Then
		Call WriteToLog("Pass","PAM Survey PAM Level exist on PAM Survey screening")		
	Else
		Call WriteToLog("Fail","PAM Survey PAM Level does not exist on PAM Survey screening")	
	End If
	
	Dim isAddEnabled : isAddEnabled = false
	'Verify the existence of Add button
	If CheckObjectExistence(objPAMSurveyAddButton,5) Then
		Call WriteToLog("Pass","Add button exist on PAM Survey screening")
		isAddEnabled = true
	Else
		Call WriteToLog("Pass","Add button already is in disabled mode on PAM Survey screening or all screenings completed.")
	End If
	
	If isAddEnabled Then	'if add button is enabled
		'Verify the existence of postpone button
		If Not CheckObjectExistence(objPAMSurveyPostponeButton,5) Then
			Call WriteToLog("Pass","Postpone button is disabled")
		Else
			Call WriteToLog("Fail","Postpone button is enabled")
		End If
		
		If not CheckObjectExistence(objPAMSurveySaveButton,5) Then
			Call WriteToLog("Pass","Save button is disabled")
		Else
			Call WriteToLog("Fail","Save button is enabled")
		End If	
	End If
	
	If isAddEnabled Then
		'Click on Add button to enable new survey activity
		blnReturnValue = ClickButton("Add",objPAMSurveyAddButton,strOutErrorDesc)
		Wait intWaitTime/2
		If not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
			Exit Function
		End If
		
		wait 2
		waitTillLoads "Loading..."
		wait 2
	End If
	wait 5
	'verify add button disabled after clicking on Add button
	Execute "Set objPAMSurveyAddButton= "  &Environment.Value("WEL_PAMSurvey_AddButton") 'PAM Survey screen Add button
	If CheckObjectExistence(objPAMSurveyAddButton,5) Then
		Call WriteToLog("Fail","Add button is enabled")
	Else
		Call WriteToLog("Pass","Add button is disabled.")
	End If
	'Verify the existence of postpone button
	Execute "Set objPAMSurveyPostponeButton= "  &Environment.Value("WEL_PAMSurvey_PostponeButton") 'PAM Survey screen postpone button
	If CheckObjectExistence(objPAMSurveyPostponeButton,5) Then
		Call WriteToLog("Pass","Postpone button is enabled")
	Else
		Call WriteToLog("Fail","Postpone button is Disable")
	End If
	
	'Verify the existence of Save button
	Execute "Set objPAMSurveySaveButton= "  &Environment.Value("WEL_PAMSurvey_SaveButton")	'PAM Survey screen Save button
	If not CheckObjectExistence(objPAMSurveySaveButton,5) Then
		Call WriteToLog("Pass","Save button is disabled")
	Else
		Call WriteToLog("Fail","Save button is enabled")
	End If
	
	'verify Patient Refused survey exists
	Call WriteToLog("info", "Test Case - Validate PAM Survey Patient Refused Survey")
	Dim isPRExists : isPRExists = true
	Execute "Set objPR = " & Environment.Value("WEL_PAM_PatientRefused")
	If CheckObjectExistence(objPR,5) Then
		Call WriteToLog("Pass","Patient Refused Survey exists.")
	Else
		Call WriteToLog("Fail","Patient Refused Survey does NOT exists.")
		isPRExists = false
	End If

	'validate patient refused survey functionality
	If isPRExists Then
		objPR.Click
		wait 2
		
		Execute "Set objPAMSurveySaveButton= "  &Environment.Value("WEL_PAMSurvey_SaveButton")	'PAM Survey screen Save button
		If CheckObjectExistence(objPAMSurveySaveButton,5) Then
			Call WriteToLog("Pass","Save button is enabled")
			blnReturnValue = ClickButton("Save",objPAMSurveySaveButton,strOutErrorDesc)
			If not blnReturnValue Then
				Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
				Call WriteLogFooter()
				ExitAction
			End If
			
			wait 2
			waitTillLoads "Saving..."
			wait 2
			
			isPass = checkForPopup("PAM Survey", "Ok", "Survey has been completed successfully", strOutErrorDesc)
			If not isPass Then
				Call writeToLog("Fail", "Failed to click OK on message box.")
				Exit Function
			End If
		Else
			Call WriteToLog("Fail","Save button is disabled")
		End If		
	End If
	
	Call WriteToLog("info", "Test Case - Validate PAM Survey Caregiver Survey Required")
	
	'click on patient snapshot
	clickOnSubMenu "Patient Snapshot"
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	clickOnSubMenu "Screenings->PAM Survey"
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	Execute "Set objPAMSurveyAddButton= "  &Environment.Value("WEL_PAMSurvey_AddButton") 'PAM Survey screen Add button
	If CheckObjectExistence(objPAMSurveyAddButton,5) Then
		blnReturnValue = ClickButton("Add",objPAMSurveyAddButton,strOutErrorDesc)
		wait 5
	End If
		
	'validate patient refused survey functionality
	'verify Caregiver survey required exists
	Dim isCaregiverExists : isCaregiverExists = true
	Execute "Set objCaregiver = " & Environment.Value("WEL_PAM_CaregiverSurveyReq")
	If CheckObjectExistence(objCaregiver,5) Then
		Call WriteToLog("Pass","Caregiver survey required exists.")
	Else
		Call WriteToLog("Fail","Caregiver survey required does NOT exists.")
		isCaregiverExists = false
	End If
	
	If isCaregiverExists Then
		objCaregiver.Click
		wait 2
		
		Execute "Set objPAMSurveySaveButton= "  &Environment.Value("WEL_PAMSurvey_SaveButton")	'PAM Survey screen Save button
		If CheckObjectExistence(objPAMSurveySaveButton,5) Then
			Call WriteToLog("Pass","Save button is enabled")
			blnReturnValue = ClickButton("Save",objPAMSurveySaveButton,strOutErrorDesc)
			If not blnReturnValue Then
				Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
				Call WriteLogFooter()
				ExitAction
			End If
			
			wait 2
			waitTillLoads "Saving..."
			wait 2
			
			isPass = checkForPopup("PAM Survey", "Ok", "Survey has been completed successfully", strOutErrorDesc)
			If not isPass Then
				Call writeToLog("Fail", "Failed to click OK on message box.")
				Exit Function
			End If
		Else
			Call WriteToLog("Fail","Save button is disabled")
		End If
	End If

	Call WriteToLog("info", "Test Case - Validate PAM Survey questions")
	
	'click on patient snapshot
	clickOnSubMenu "Patient Snapshot"
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	clickOnSubMenu "Screenings->PAM Survey"
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	Execute "Set objPAMSurveyAddButton= "  &Environment.Value("WEL_PAMSurvey_AddButton") 'PAM Survey screen Add button
	If CheckObjectExistence(objPAMSurveyAddButton,5) Then
		blnReturnValue = ClickButton("Add",objPAMSurveyAddButton,strOutErrorDesc)
		wait 5
	End If

	'Verify the number of question of PAM Survey screening screen
	Dim dbConnected : dbConnected = true
	isPass = ConnectDB()
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
		Call CloseDBConnection()
		dbConnected = false
	End If
	If dbConnected Then
		Set objQuestions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*pam-question-text.*;TD;.*QuestionText.*")
		For i  = 0 To objQuestions.Count-1 Step 1
			uiQuestion = Trim(objQuestions(i).GetROProperty("innertext"))
			dbQuestion = getSurveyQuestionText(16, i + 1)
			
			If i+1 & dbQuestion = uiQuestion Then
				Call WriteToLog("Pass","Question no. " & i + 1 & " of PAM Survey screen is as expected.")
			Else
				Call WriteToLog("Fail","Question no. " & i + 1 & " of PAM Survey screen is NOT as expected.")
			End If		
		Next
	Else
		For i  = 0 To objQuestions.Count-1
			uiQuestion = Trim(objQuestions(i).GetROProperty("innertext"))
			
			If uiQuestion <> "" Then
				Call WriteToLog("Pass","Question no. " & i + 1 & " of PAM Survey screen exists.")
			Else
				Call WriteToLog("Fail","Question no. " & i + 1 & " of PAM Survey screen does not exists.")
			End If		
		Next
	End If
	
	Call CloseDBConnection()
	If objQuestions.Count = 0 Then
		Call WriteToLog("Fail","No question present on the screening page")
		Exit Function
	End If
	
	
	Call WriteToLog("info", "Test Case - Validate PAM Survey answer all questions and save")
	'===========================================================================
	'Verify the number of radio button on PAM Survey screening screen
	'===========================================================================
	Set objRadioOptions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*screening-radio.*;DIV;.*screening-radio.*")
	For i  = 5 To objRadioOptions.Count-1 Step 1
		Err.Clear
		objRadioOptions(i).Click
		If Err.Number<>0 Then
			Call WriteToLog("Fail",i + 1 & " button is not clicked")
			Exit Function
		End If	
		i = i + 4
	Next
	
	If objRadioOptions.Count = 0 Then
		Call WriteToLog("Fail","No question present on the screening page")
		Call WriteLogFooter()
		ExitAction
	End If
	
	wait 2
	
	Execute "Set objPAMSurveySaveButton= "  &Environment.Value("WEL_PAMSurvey_SaveButton")	'PAM Survey screen Save button
	If CheckObjectExistence(objPAMSurveySaveButton,5) Then
		Call WriteToLog("Pass","Save button is enabled")
		blnReturnValue = ClickButton("Save",objPAMSurveySaveButton,strOutErrorDesc)
		If not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
			Call WriteLogFooter()
			ExitAction
		End If
		
		wait 2
		waitTillLoads "Saving..."
		wait 2
		
		isPass = checkForPopup("PAM Survey", "Ok", "Survey has been completed successfully", strOutErrorDesc)
		If not isPass Then
			Call writeToLog("Fail", "Failed to click OK on message box.")
			Exit Function
		End If
	Else
		Call WriteToLog("Fail","Save button is disabled")
	End If
	wait 2
	
	Call WriteToLog("info", "Test Case - Validate PAM Survey View Trending accordian")
	'verify View Trending
	Set objViewTrending = getPageObject().WebElement("outertext:=.*View Trending.*", "class:=.*accordion.*")
	If CheckObjectExistence(objViewTrending, 5) Then
		Call WriteToLog("Pass", "View Trending accordian exists.")
	Else
		Call WriteToLog("Fail", "View Trending accordian does not exists.")
	End If	
	pamSurvey = true
End Function

Function getSurveyQuestionText(ByVal survey_ques_survey_uid, ByVal survey_ques_order)
	
	On Error Resume Next
	Err.Clear

	getSurveyQuestionText = "NA"
	
	strSQLQuery = "select survey_ques_text from capella.survey_questions where survey_ques_survey_uid = '" & survey_ques_survey_uid & "' and survey_ques_order = '" & survey_ques_order & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		quesText = objDBRecordSet("survey_ques_text")
		objDBRecordSet.MoveNext
	Wend
	
	getSurveyQuestionText = quesText
	
End Function
