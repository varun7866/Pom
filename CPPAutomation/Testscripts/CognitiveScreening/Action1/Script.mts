' TestCase Name			: CognitiveScreening
' Purpose of TC			: To perform cognitive screening
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "CognitiveScreening", strOutTestName, strOutErrorDesc) 
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
	Execute "Set objCognitiveScreeningDate = " & Environment("WE_CognitiveScreening_ScreeningDate") 'Patient Snapshot > Screening > Cognitive screening>Date
	Execute "Set objCognitiveScore = " & Environment("WEL_CognitiveScreening_CognitiveScore") 'Patient Snapshot > Screening > Cognitive screening > Score
	Execute "Set objCognitiveScreeningAddButton= " &Environment("WB_CognitiveScreening_AddButton") 'Patient Snapshot > Screening > Cognitive screening > Add button
	Execute "Set objCognitiveScreeningPostponeButton= "  &Environment("WB_CognitiveScreening_PostponeButton") 'Patient Snapshot > Screening > Cognitive screening>postpone button
	Execute "Set objCognitiveScreeningSaveButton= "  &Environment("WB_CognitiveScreening_SaveButton") 'Patient Snapshot > Screening > Cognitive screening>Save button
	Execute "Set objScreeningHistorySection= "  &Environment("WEL_ScreeningHistorySection") 'Patient Snapshot > Screening > Cognitive screening>Screeing History Section
	Execute "Set objPatientUnableToCompleteCheckBox = "&Environment("WEL_CognitiveScreening_PatientUnableToCompleteCheckBox") 'Patient Snapshot > Screening > Cognitive screening>Patient unable to complete checkbox
'	Execute "Set objPatientRefusedCheckBox = " & Environment("WEL_CognitiveScreening_PatientRefusedSurvey")
	Execute "Set objPopupTitle = "&Environment("WEL_CognitiveScreening_PopupTitle") 'Pop up title
	Execute "Set objPopupText = "&Environment("WEL_PopUp_Text") 'Popup text
	Execute "Set objOKButton= "  &Environment("WB_OK") 'Ok Button
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
		
		Call WriteToLog("info", "Test Case - Cognitive Screening for the member id - " & strMemberID)
		
		isPass = cognitiveScreening()
		If Not isPass Then
			Call WriteToLog("Fail", "Cognitive Screening failed for the member - " & strMemberID )
		Else
			Call WriteToLog("Pass", "Cognitive Screening succesfully completed for the member - " & strMemberID )
		End If
	End If	
Next

If not isRun Then
	Call WriteToLog("info", "There are rows marked Y(Yes) for execution.")
End If

Logout
CloseAllBrowsers
WriteLogFooter

Function cognitiveScreening()

	cognitiveScreening = false
	intWaitTime = 5
	
	'click on cognitive screening
	clickOnSubMenu("Screenings->Cognitive Screening")
		
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'verify if Cognitive screening screen loaded
	Execute "Set objCognitiveScreeningTitle = "  & Environment("WEL_CognitiveScreeningTitle") 'Patient Snapshot> Screening> Cognitive screening screen title
	If not CheckObjectExistence(objCognitiveScreeningTitle, 10) Then
		Call WriteToLog("Fail","Cognitive Screening screen not opened successfully")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Cognitive Screening screen opened successfully")
	
	'load all objects required in Cognitive Screening
	loadObjects
	
	'=======================================
	'Verify the existance of Screening Date
	'=======================================
	If CheckObjectExistence(objCognitiveScreeningDate,intWaitTime) Then
		Call WriteToLog("Pass","Screening date exist on Cognitive screening")		
	Else
		Call WriteToLog("Fail","Screening date not exist on Cognitive screening")
		Exit Function
	End If
	
	'========================================
	'Verify the existance of cognitive score
	'========================================
	If CheckObjectExistence(objCognitiveScore,intWaitTime) Then
		Call WriteToLog("Pass","Cognitive score exist on cognitive screening")		
	Else
		Call WriteToLog("Fail","Cognitive score does not exist on cognitive screening")	
		Exit Function
	End If
	
	'==============================================
	'Verify that Cognitive screening can be edited
	'==============================================
	Dim isNew
	isNew = false
	If Not CheckObjectExistence(objCognitiveScreeningAddButton, 10) Then
		isNew = true
	End If
	
	If not isNew Then
		'====================================
		'Verify the existance of Add button
		'====================================
		If CheckObjectExistence(objCognitiveScreeningAddButton,intWaitTime) Then
			Call WriteToLog("Pass","Add button exist on Cognitive screening")
		Else
			Call WriteToLog("Fail","Add button does not exist on Cognitive screening")
			Exit Function
		End If
	Else
		'=======================================
		'Verify the existance of postpone button
		'=======================================
		If CheckObjectExistence(objCognitiveScreeningPostponeButton,intWaitTime/2) Then
			Call WriteToLog("Pass","Postpone button is enabled")
		Else
			Call WriteToLog("Fail","Postpone button is not enabled")
			Exit Function
		End If
	End If
	
	'===================================
	'Verify the existance of Save button
	'===================================
	If Not CheckObjectExistence(objCognitiveScreeningSaveButton,intWaitTime/2) Then
		Call WriteToLog("Pass","Save button is disabled")
	Else
		Call WriteToLog("Fail","Save button is enabled")
		Exit Function
	End If
	
	'==================================================
	'Verify the existance of Screening history section
	'==================================================
	If CheckObjectExistence(objScreeningHistorySection,intWaitTime/2) Then
		Call WriteToLog("Pass","Screening history widget exist in bottom of screen")
	Else
		Call WriteToLog("Fail","Screening history widget does not exist")
		Exit Function
	End If
	
	If not isNew Then
		'====================================================
		'Click on Add button to enable new screening activity
		'====================================================
		blnReturnValue = ClickButton("Add",objCognitiveScreeningAddButton,strOutErrorDesc)
		Wait intWaitTime/2
		If not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
			Exit Function
		End If
		'=======================================
		'Verify the existance of postpone button
		'=======================================
		If CheckObjectExistence(objCognitiveScreeningPostponeButton,intWaitTime) Then
			Call WriteToLog("Pass","Postpone button is enabled after click on Add button")
		Else
			Call WriteToLog("Fail","Postpone button is not enabled")
			Exit Function
		End If
	End If
	
	'============================================================
	'Verify the number of question of cognitive screening screen
	'============================================================
	Set objQuestions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*screening-question-answer-text.*;DIV;.*question\.Text.*")
	For i  = 0 To objQuestions.Count-1 Step 1
		Call WriteToLog("Pass",i+ 1& " question of cognitive screen is "&Trim(objQuestions(i).GetROProperty("innertext")))
	Next
	
	If objQuestions.Count = 0 Then
		Call WriteToLog("Fail","No question present on the screening page")
		Exit Function
	End If
	
	'=========================================================
	'Check the 'Patient Refused' check box
	'==========================================================
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("class").Value = "screening-check-box.*"
	oDesc("outerhtml").Value = ".*cognitiveScreeningPtRefusedSurveyChkbx.*"
	oDesc("html tag").Value = "DIV"
	Set objPage = getPageObject()
	Set oObj = objPage.ChildObjects(oDesc)
	If oObj.Count > 0 Then
		Set objPatientRefusedCheckBox = oObj(0)
		
		If CheckObjectExistence(objPatientRefusedCheckBox,intWaitTime) Then
			Call WriteToLog("Pass","Patient Unable to complete screening check box exist on screening")
			Err.Clear
			objPatientRefusedCheckBox.Click
			If Err.Number <> 0 Then
				Call WriteToLog("Fail","User not able click on Patient Unable to complete screening check box")
				Exit Function
			End If
			
			'========================
			'Now Click on Save button
			'=========================
			blnReturnValue = ClickButton("Save",objCognitiveScreeningSaveButton,strOutErrorDesc)
			If not blnReturnValue Then
				Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
				Exit Function
			End If
			
			wait 2
			waitTillLoads "Loading..."
			wait 2
			
			'====================================================================================================
			'Verify that Success message stating 'Screening has been completed successfully' should get displayed
			'====================================================================================================
			isPass = checkForPopup("Cognitive Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
			If not isPass Then
				Call WriteToLog("Fail", "Expected Message box does not appear.")
				Exit Function
			End If
		Else
			Call WriteToLog("Fail","Patient Unable to complete screening check box does not exist on screening")
			isNew = true
		End If
	Else
		Call WriteToLog("Fail","Patient Refused Survey check box does not exist on screening")
		isNew = true
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'=========================================================
	'Check the 'Patient Unable to complete screening' check box
	'==========================================================
	'====================================================
	'Click on Add button to enable new screening activity
	'====================================================
	Execute "Set objCognitiveScreeningAddButton= " &Environment("WB_CognitiveScreening_AddButton") 'Patient Snapshot > Screening > Cognitive screening > Add button
	If CheckObjectExistence(objCognitiveScreeningAddButton, intWaitTime) Then
		blnReturnValue = ClickButton("Add",objCognitiveScreeningAddButton,strOutErrorDesc)
		Wait intWaitTime/2
		If not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
			Exit Function
		End If
		
		wait 2
		waitTillLoads "Loading..."
		wait 2
	End If
	
	If CheckObjectExistence(objPatientUnableToCompleteCheckBox,intWaitTime) Then
		Call WriteToLog("Pass","Patient Unable to complete screening check box exist on screening")
		Err.Clear
		objPatientUnableToCompleteCheckBox.Click
		If Err.Number <> 0 Then
			Call WriteToLog("Fail","User not able click on Patient Unable to complete screening check box")
			Exit Function
		End If
	Else
		Call WriteToLog("Fail","Patient Unable to complete screening check box does not exist on screening")
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'verify save button is disabled
	if not objCognitiveScreeningSaveButton.Object.isDisabled Then
		Call WriteToLog("Fail","Save button is enabled.")
		Exit Function
	Else
		Call WriteToLog("Pass","Save button is disabled.")
	End if
	
	Execute "Set objCommentBox = " & Environment("WE_CognitiveScreening_CommentBox")
	If objCommentBox.Exist(1) Then
		Call WriteToLog("Pass", "Comment Box appears as expected.")
	Else
		Call WriteToLog("Fail", "Comment Box does not appear as expected.")
		Exit Function
	End If
	
	'uncheck the check box to verify comment box disappear
	Err.Clear
	objPatientUnableToCompleteCheckBox.Click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","User not able click on Patient Unable to complete screening check box")
		Exit Function
	End If
	Execute "Set objCommentBox = " & Environment("WE_CognitiveScreening_CommentBox")
	If objCommentBox.Exist(1) Then
		Call WriteToLog("Fail", "Comment box still exists after unchecking.")
		Exit Function	
	Else
		Call WriteToLog("Pass", "Comment box does not exist as expected.")
	End If
	
	'save after entering the comments
	objPatientUnableToCompleteCheckBox.Click
	Execute "Set objCommentBox = " & Environment("WE_CognitiveScreening_CommentBox")
	If objCommentBox.Exist(1) Then
		objCommentBox.Click
		Call SendKeys("Testing..")
	End If
	wait 4
	'click on Save button
	if Not objCognitiveScreeningSaveButton.Object.isDisabled Then
		Call WriteToLog("Pass","Save button is enabled.")
	Else
		Call WriteToLog("Fail","Save button is disabled.")
		Exit Function
	End if
	
	blnReturnValue = ClickButton("Save",objCognitiveScreeningSaveButton,strOutErrorDesc)
	Wait intWaitTime/2
	If not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'====================================================================================================
	'Verify that Success message stating 'Screening has been completed successfully' should get displayed
	'====================================================================================================
	isPass = checkForPopup("Cognitive Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Expected Message box does not appear.")
		Exit Function
	End If
	
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	Execute "Set objCognitiveScreeningDate = " & Environment("WE_CognitiveScreening_ScreeningDate")
	screeningDate = objCognitiveScreeningDate.getROProperty("value")
	
	isPass = cognitive_ValidateHistory(screeningDate, "Testing..")
	If not isPass Then
		Call WriteToLog("Fail", "Failed to update history.")
'		Exit Function
	End If
	
	wait 2 
	waitTillLoads "Loading..."
	wait 2
		
	'Click Add button and complete screening
	Execute "Set objCognitiveScreeningAddButton= " &Environment("WB_CognitiveScreening_AddButton")
	blnReturnValue = ClickButton("Add",objCognitiveScreeningAddButton,strOutErrorDesc)
	Wait intWaitTime/2
	If not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	'================================================================
	'Verify the number of radio button on congnitive screening screen
	'================================================================
	Set objRadioOptions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;circular-radio.*;DIV;.*changeOptionOnQuestion.*")
	If objRadioOptions.Count = 0 Then
		Call WriteToLog("Fail","No question present on the screening page")
		Exit Function
	End If
	Dim id
	For q = 1 To 7
		answer = DataTable.Value("Question"&q, "CurrentTestCaseData")
		Select Case q
			Case 1:
				If lcase(answer) = "correct" Then
					id = "o80"
				Else
					id = "o81"
				End If
			Case 2:
				If lcase(answer) = "correct" Then
					id = "o82"
				Else
					id = "o83"
				End If
			Case 3:
				id = "o84"
			Case 4:
				If lcase(answer) = "correct" Then
					id = "o85"
				Else
					id = "o86"
				End If
			Case 5:
				If lcase(answer) = "correct" Then
					id = "o87"
				ElseIf lcase(answer) = "1 error" Then
					id = "o88"
				Else
					id = "o89"
				End If
			Case 6:
				If lcase(answer) = "correct" Then
					id = "o90"
				ElseIf lcase(answer) = "1 error" Then
					id = "o91"
				Else
					id = "o92"
				End If
			Case 7:
				If lcase(answer) = "correct" Then
					id = "o93"
				ElseIf lcase(answer) = "1 error" Then
					id = "o94"
				ElseIf lcase(answer) = "2 errors" Then
					id = "o95"
				ElseIf lcase(answer) = "3 errors" Then
					id = "o96"
				ElseIf lcase(answer) = "4 errors" Then
					id = "o97"
				Else
					id = "o98"
				End If
		End Select
		
		For i  = 0 To objRadioOptions.Count-1
			outerhtml = objRadioOptions(i).getRoproperty("outerhtml")
			If instr(outerhtml, id) > 0 Then
				objRadioOptions(i).Click
				Exit For
			End If
		Next
		
	Next
	
	blnReturnValue = ClickButton("Save",objCognitiveScreeningSaveButton,strOutErrorDesc)
	Wait intWaitTime/2
	If not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	isPass = checkForPopup("Cognitive Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Expected Message box does not appear.")
		Exit Function
	End If
	wait 2
	
	'==================================================================
	'Verify the Cognitive screening score is getting display on screen
	'==================================================================
	intScore = Trim(objCognitiveScore.GetROProperty("innertext"))
	If IsNumeric(intScore) Then
		Call WriteToLog("Pass","Current screening score is: "&intScore)
	Else
		Call WriteToLog("Fail","Current screening score is not a Numeric value. Actual value is: " & intScore)
		Exit Function
	End If
	
	killAllObjects
	cognitiveScreening = true
End Function

Function killAllObjects()
	Execute "Set objCognitiveScreeningDate = Nothing"
	Execute "Set objCognitiveScore = Nothing"
	Execute "Set objCognitiveScreeningAddButton= Nothing"
	Execute "Set objCognitiveScreeningPostponeButton= Nothing"
	Execute "Set objCognitiveScreeningSaveButton= Nothing"
	Execute "Set objScreeningHistorySection= Nothing"
	Execute "Set objPatientUnableToCompleteCheckBox = Nothing"
	Execute "Set objPopupTitle = Nothing"
	Execute "Set objPopupText = Nothing"
	Execute "Set objOKButton= Nothing"
End Function


Function cognitive_ValidateHistory(Byval dtScreeningCompletedDate, ByVal message)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	cognitive_ValidateHistory = False
	
	Execute "Set objDS_ScrHistUpArw = " & Environment("WEL_HistoryUpArrow")
	
	'click on screening history expand arrow icon
	Err.Clear
	objDS_ScrHistUpArw.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Screening history expand arrow icon, Error Returned: "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on history expand arrow")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2
	Execute "Set objDS_ScrHtryTable = " & Environment("WT_HistoryDataTable")
	'Validate the history table entries
	RowCount = objDS_ScrHtryTable.RowCount
	If RowCount = "" OR RowCount = 0 Then
		strOutErrorDesc = "History table is not populated with screening details"
		Exit Function
	ElseIf RowCount <= 2 Then
		Call WriteToLog("Pass", "History table is populated with screening details and number of entries are :"&RowCount)
	End If
	
	'validate the column names
	Execute "Set objHeaderTable = " & Environment("WT_HistoryHeaderTable")
	If not objHeaderTable.Exist(2) Then
		Call WriteToLog("Fail", "Failed to find history table header.")
		Exit Function
	End If
	
	columnNames = objHeaderTable.GetROProperty("column names")
	reqColNames = DataTable.Value("HistoryColumnNames", "CurrentTestCaseData")
	If trim(columnNames) = trim(reqColNames) Then
		Call WriteToLog("Pass", "Required columns exist in history table.")
	Else
		Call WriteToLog("Fail", "Required columns does not exist in history table. The columns are - " & columnNames)
	End If
	
	'Get current and previous screening	information from screening history table	
'	For R = 1 To RowCount Step 1
'		ReDim Preserve arrScreeningHistoryInfo(RowCount-1)
'		For C = 1 To objDS_ScrHtryTable.ColumnCount(R) Step 1
'				If C = 1 Then
'					dtCompletedDateHT = objDS_ScrHtryTable.GetCellData(R,C)
'				ElseIf C = 2 Then
'					intScore = objDS_ScrHtryTable.GetCellData(R,C)
'				ElseIf C = 3 Then
'					intScreeningLevel = objDS_ScrHtryTable.GetCellData(R,C)
'				ElseIf C = 4 Then
'					strLevelComments = objDS_ScrHtryTable.GetCellData(R,C)	
'				ElseIf C = 5 Then
'					strSurveyComments = objDS_ScrHtryTable.GetCellData(R,C)
'				End If
'		Next
'		arrScreeningHistoryInfo(R-1) = dtCompletedDateHT & "|" & intScore & "|" & intScreeningLevel & "|" & strLevelComments & "|" & strSurveyComments
'	Next
'	
'	'Validate the latest screening details from the history table
'	Dim isFound : isFound = false
'	For i = 0 To UBound(arrScreeningHistoryInfo)
'		hist = split(arrScreeningHistoryInfo(i),"|")
'		If CDate(hist(0)) = dtScreeningCompletedDate Then
'			If message = hist(4) Then
'				Call WriteToLog("Pass", "Required survey comments found in history table - '" & hist(4) & "' for the date - '" & hist(0) & "'")
'				isFound = true
'				Exit For
'			End If
'		End If
'	Next
'	
'	If not isFound Then
'		Call WriteToLog("Fail", "Required survey comments - '" & message & "' for the date - '" & date & "' is not found in history table.")
'	End If
		
	cognitive_ValidateHistory = True
	
	Execute "Set objDS_ScrHistDnArw = " & Environment("WEL_HistoryDownArrow")
	objDS_ScrHistDnArw.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	Err.Clear
	Execute "Set objDS_ScrHistUpArw = Nothing"
	Execute "Set objDS_ScrHtryTable = Nothing"
	Execute "Set objDS_ScrHistDnArw = Nothing"
End Function

