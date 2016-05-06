' TestCase Name			: DepressionScreening
' Purpose of TC			: To perform Depression screening
' Author                : Sudheer
' Date					: 25-Aug-2015
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "DepressionScreening", strOutTestName, strOutErrorDesc) 
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
	Execute "Set objDepressionScreeningTitle = "  & Environment("WEL_DepressionScreeningTitle") 'Depression screening screen title
	Execute "Set objDepressionScreeningDate = " & Environment("WE_DepressionScreening_ScreeningDate") 'Depression screening date object
	Execute "Set objDepressionScore = " & Environment("WE_DepressionScreening_Score")				  'Depression screening Score object
	Execute "Set objDepressionScreeningAddButton= " & Environment("WB_DepressionScreen_AddButton") 	  'Depression screening Add button
	Execute "Set objDepressionScreeningPostponeButton= "  & Environment("WB_DepressionScreen_PostponeButton") 'Depression screening screen postpone button
	Execute "Set objDepressionScreeningSaveButton= " & Environment("WB_DepressionScreen_SaveButton") 'Depression screening screen Save button
	Execute "Set objScreeningHistorySection= " & Environment("WEL_ScreeningHistorySection")		  'Depression screening Screening history section
	Execute "Set objPatientRefusedCheckBox = " & Environment("WEL_DepressionScreening_PatientRefusedSurveyCheckBox") 'Depression screening patient refused checkbox
	Execute "Set objPopupTitle = " & Environment("WEL_DepressionScreening_PopupTitle")	'Depression screening popup title
	Execute "Set objPopupText = " & Environment("WEL_PopUp_Text")	'Depression screening popup text
	Execute "Set objCaregiverSurveyCheckBox = " & Environment("WEL_DepressionScreening_CareGiverSurveyCheckBox") 'Depression screening Care given checkbox
	Execute "Set objOKButton= " & Environment("WB_OK") 'Ok button
End Function

'=====================================
'start test execution
'=====================================
Call WriteToLog("info", "Test case - Login to Capella using VHN role")
'Login to Capella as VHN
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
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
			strOutErrorDesc = "CloseAllOpenPatient returned error: " & strOutErrorDesc
			Call WriteToLog("Fail", strOutErrorDesc)
			Logout
			CloseAllBrowsers
			Call WriteLogFooter()
			ExitAction
		End If
	
		strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
		isPass = selectPatientFromGlobalSearch(strMemberID)
		If Not isPass Then
			strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
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
		
		Call WriteToLog("info", "Test Case - Depression Screening for the member id - " & strMemberID)
		
		isPass = depressionScreening()
		If not isPass Then
			Call WriteToLog("Fail", "Depression Screening failed for the member - " & strMemberID)
			
			clickOnSubMenu "Patient Snapshot"

			wait 2
			waitTillLoads "Loading..."
			wait 2
			
			isPass = checkForPopup("Depression Screening", "Yes", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
			If not isPass Then
				Call WriteToLog("Fail", "Expected Message box does not appear.")
			End If
		
			
			wait 2
			waitTillLoads "Loading..."
			wait 2
		End If
	End If	
Next

If not isRun Then
	Call WriteToLog("info", "There are NO rows marked Y(Yes) for execution.")
End If

killAllObjects
Logout
CloseAllBrowsers
WriteLogFooter

Function depressionScreening()
	On Error Resume Next
    Err.Clear
	depressionScreening = false
	intWaitTime = 5
	
	'click on Depression screening
	clickOnSubMenu("Screenings->Depression Screening")
		
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'verify if Depression screening screen loaded
	Execute "Set objDepressionScreeningTitle = "  & Environment("WEL_DepressionScreeningTitle") 'Patient Snapshot> Screening> Depression screening screen title
	If not CheckObjectExistence(objDepressionScreeningTitle, 10) Then
		Call WriteToLog("Fail","Depression Screening screen not opened successfully")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Depression Screening screen opened successfully")
	
	'load all objects required in Depression Screening
	loadObjects
	
	Call WriteToLog("info", "Test Case - verify all the required objects exists")
	'=======================================
	'Verify the existance of Screening Date
	'=======================================
	If CheckObjectExistence(objDepressionScreeningDate,intWaitTime) Then
		Call WriteToLog("Pass","Screening date exist on Depression screening")		
	Else
		Call WriteToLog("Fail","Screening date not exist on Depression screening")
		Exit Function
	End If
	
	'========================================
	'Verify the existance of Depression score
	'========================================
	If CheckObjectExistence(objDepressionScore,intWaitTime) Then
		Call WriteToLog("Pass","Depression score exist on Depression screening")		
	Else
		Call WriteToLog("Fail","Depression score does not exist on Depression screening")	
		Exit Function
	End If
	
	'==============================================
	'Verify that Depression screening can be edited
	'==============================================
	Dim isNew
	isNew = false
	
	blnReturnValue = objDepressionScreeningAddButton.Object.isDisabled
	If blnReturnValue Then
		Call WriteToLog("Pass","Screening not be added since all the screening are completed or screening is in incompleted")
		isNew = true
	End If
	
	If not isNew Then	'screening is not already completed
		'====================================
		'Verify the existance of Add button
		'====================================
		blnReturnValue = objDepressionScreeningAddButton.Object.isDisabled
		If Not blnReturnValue Then
			Call WriteToLog("Pass","Add button exist on Depression screening")
		Else
			Call WriteToLog("Fail","Add button does not exist on Depression screening")
			Exit Function
		End If
		
		'=======================================
		'Verify the existance of postpone button
		'=======================================
		blnReturnValue = objDepressionScreeningPostponeButton.Object.isDisabled
		If blnReturnValue  Then
			Call WriteToLog("Pass","Postpone button disabled")
		Else
			Call WriteToLog("Fail","Postpone button is enabled")
		End If
		
		'===================================
		'Verify the existance of Save button
		'===================================
		blnReturnValue = objDepressionScreeningSaveButton.Object.isDisabled
		If blnReturnValue Then
			Call WriteToLog("Pass","Save button is disabled")
		Else
			Call WriteToLog("Fail","Save button is enabled")
		End If
	Else	'screening is not done. this is first time screening
		'====================================
		'Verify the existance of Add button
		'====================================
		blnReturnValue = objDepressionScreeningAddButton.Object.isDisabled
		If blnReturnValue Then
			Call WriteToLog("Pass","Add button exist on Depression screening")
		Else
			Call WriteToLog("Fail","Add button does not exist on Depression screening")
			Exit Function
		End If
		
		'=======================================
		'Verify the existance of postpone button
		'=======================================
		blnReturnValue = objDepressionScreeningPostponeButton.Object.isDisabled
		If not blnReturnValue  Then
			Call WriteToLog("Pass","Postpone button is enabled")
		Else
			Call WriteToLog("Fail","Postpone button is disabled")
		End If
		
		'===================================
		'Verify the existance of Save button
		'===================================
		blnReturnValue = objDepressionScreeningSaveButton.Object.isDisabled
		If blnReturnValue Then
			Call WriteToLog("Pass","Save button is disabled")
		Else
			Call WriteToLog("Fail","Save button is enabled")
		End If	
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
	
	Call WriteToLog("info", "Test Case - Verify comment box for option 1 of question 1")
	If not isNew Then
		'====================================================
		'Click on Add button to enable new screening activity
		'====================================================
		blnReturnValue = ClickButton("Add",objDepressionScreeningAddButton,strOutErrorDesc)
		Wait intWaitTime/2
		If not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
			Exit Function
		End If
		'=======================================
		'Verify the existance of postpone button
		'=======================================
		blnReturnValue = objDepressionScreeningPostponeButton.Object.isDisabled
		If Not blnReturnValue Then
			Call WriteToLog("Pass","Postpone button is enabled after click on Add button")
		Else
			Call WriteToLog("Fail","Postpone button is not enabled after clicking on Add button")
		End If
	End If
	
	surveyMsg = "Testing comment box"
	'================================================================
	'Verify the number of radio button on Depresion screening screen
	'================================================================
	Set objRadioOptionsYes = GetChildObject("micclass;html tag;cols","WebTable;TABLE;3")
	If objRadioOptionsYes.Count = 0 Then
		Call WriteToLog("Fail","No questions options present on the screening page")
'		Exit Function
	End If
	objRadioOptionsYes(1).ChildItem(1,1,"WebElement",0).Click
	wait 1
	if objRadioOptionsYes(1).ChildItem(1,3, "WebEdit",0).Exist(1) Then
		objRadioOptionsYes(1).ChildItem(1,3, "WebEdit",0).Set surveyMsg
		wait 1
		Call writetolog("Pass", "Comment box appear as expected.")
	Else
		Call writetolog("Fail", "Comment box does not appear as expected.")
	End if
	
	Set objRadioOptionsYes = Nothing
	
	killAllObjects
	loadObjects
	'verify save button enabled
	Dim cnt : cnt = 1
	Do
		blnReturnValue = objDepressionScreeningSaveButton.Object.isDisabled
		Set objRadioOptionsYes = GetChildObject("micclass;html tag;cols","WebTable;TABLE;3")
		objRadioOptionsYes(1).ChildItem(1,1,"WebElement",0).Click
		wait 2
		If cnt = 5 Then
			Exit Do
		End If
		sendKeys "{TAB}"
		cnt = cnt + 1
	Loop While blnReturnValue = true
	If not blnReturnValue Then
		Call WriteToLog("Pass","Save button is enabled")
	Else
		Call WriteToLog("Fail","Save button is disabled")
	End If
	
	'click on postpone button
	blnReturnValue = ClickButton("Postpone",objDepressionScreeningPostponeButton,strOutErrorDesc)
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
	isPass = checkForPopup("Depression Screening", "Ok", "Screening has been saved successfully", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Expected Message box does not appear.")
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	clickOnSubMenu "Patient Snapshot"
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	clickOnSubMenu("Screenings->Depression Screening")

	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Set objRadioOptionsYes = GetChildObject("micclass;html tag;cols","WebTable;TABLE;3")
	If objRadioOptionsYes.Count = 0 Then
		Call WriteToLog("Fail","No questions options present on the screening page")
'		Exit Function
	End If
	if objRadioOptionsYes(1).ChildItem(1,3, "WebEdit",0).Exist(1) Then
		getMsg = objRadioOptionsYes(1).ChildItem(1,3, "WebEdit",0).getroproperty("value")
		
		If surveyMsg = getMsg Then
			Call writetolog("Pass", "Comment box appear as expected after postponing and expected message text exists.")
		End If
		wait 1
	Else
		Call writetolog("Fail", "Comment box does not appear as expected after postponing.")
	End if
	
	Set objRadioOptionsYes = Nothing
	
	killAllObjects
	loadObjects
	
	Execute "Set objDepressionScreeningDate = " & Environment("WE_DepressionScreening_ScreeningDate")
	screeningDate = objDepressionScreeningDate.getroproperty("value")

	'click on save button
	blnReturnValue = ClickButton("Save",objDepressionScreeningSaveButton,strOutErrorDesc)
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
	isPass = checkForPopup("Depression Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Expected Message box does not appear.")
		Exit Function
	End If
	
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	'verify history
	isPass = depression_ValidateHistory(screeningDate, surveyMsg)
	
	killAllObjects
	loadObjects
	'============================================
	'Check the 'Patient refused survey' checkbox
	'============================================
	Call WriteToLog("info", "Test Case - verify 'Patient refused survey' checkbox")
	'====================================================
	'Click on Add button to enable new screening activity
	'====================================================
	blnReturnValue = ClickButton("Add",objDepressionScreeningAddButton,strOutErrorDesc)
	Wait intWaitTime/2
	If not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
		Exit Function
	End If
	
	Set objRadioOptions = GetChildObject("micclass;html tag;cols","WebTable;TABLE;3")
	For i  = 1 To objRadioOptions.Count-6 Step 1
		Err.Clear
		if not objRadioOptions(i).ChildItem(1,1,"WebElement",0).Object.isDisabled then
			objRadioOptions(i).ChildItem(1,1,"WebElement",0).Click
		End If
		Wait intWaitTime/10
		If Err.Number <> 0 Then
			Call WriteToLog("Fail",objRadioOptions(i) & " option does not click successfully. Error Returned: "&Err.Description)
		End If
	Next
	
	If CheckObjectExistence(objPatientRefusedCheckBox,5) Then
		Call WriteToLog("Pass","'Patient refused survey' check box exist on screening")
		Err.Clear
		objPatientRefusedCheckBox.Click
		If Err.Number = 0 Then
			Call WriteToLog("Pass","User able to click on 'Patient refused survey' check box")
		Else
			Call WriteToLog("Fail","User not able to click on 'Patient refused survey' check box")
			Exit Function
		End If
	Else
		Call WriteToLog("Fail","'Patient refused survey' check box does not exist on screening")
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 1
	
'	Verify message box
	call clickOnComorbidsMessageBox("", "No", "Your current responses will be lost. Do you want to continue?", strOutErrorDesc)
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	killAllObjects
	loadObjects
	'============================================
	'Check the 'Caregive survey required' checkbox does not exist
	'============================================
	Call WriteToLog("info", "Test Case - verify 'Caregive survey required' checkbox does not exist")
	If Not CheckObjectExistence(objCaregiverSurveyCheckBox,5) Then
		Call WriteToLog("Pass","'Caregiver survey required' check box does not exist on screening")
	Else
		Call WriteToLog("Fail","'Caregiver survey required' check box exist on screening")
		Exit Function
	End If

	clickOnSubMenu "Patient Snapshot"
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	isPass = checkForPopup("Depression Screening", "Yes", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Expected Message box does not appear.")
		Exit Function
	End If

	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	clickOnSubMenu("Screenings->Depression Screening")

	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	killAllObjects
	loadObjects
	
	Call WriteToLog("info", "Test Case - verify complete the screening and save it")
	'====================================================
	'Click on Add button to enable new screening activity
	'====================================================
	blnReturnValue = ClickButton("Add",objDepressionScreeningAddButton,strOutErrorDesc)
	Wait intWaitTime/2
	If not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'============================================================
	'Verify the number of question of Depression screening screen
	'============================================================
	Set objQuestions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*screening-question-answer-text.*;DIV;.*question.Text.*")
	For i  = 0 To objQuestions.Count-1 Step 1
		Call WriteToLog("Pass",i+ 1& " question of Depression screen is "&Trim(objQuestions(i).GetROProperty("innertext")))
	Next
	
	If objQuestions.Count = 0 Then
		Call WriteToLog("Fail","No question present on the screening page")
		Exit Function
	End If
	
	'================================================================
	'Verify the number of radio button on Depresion screening screen
	'================================================================
	Set objRadioOptions = GetChildObject("micclass;html tag;cols","WebTable;TABLE;3")
	For i  = 1 To objRadioOptions.Count-6 Step 1
		Err.Clear
		if not objRadioOptions(i).ChildItem(1,1,"WebElement",0).Object.isDisabled then
			objRadioOptions(i).ChildItem(1,1,"WebElement",0).Click
		Else
			Call WriteToLog("Fail",i + 1 & " is disabled.")
		End If
		Wait intWaitTime/10
		If Err.Number <> 0 Then
			Call WriteToLog("Fail",objRadioOptions(i) & " option does not click successfully. Error Returned: "&Err.Description)
		End If
	Next
	
	'========================
	'Now Click on Save button
	'=========================
	blnReturnValue = ClickButton("Save",objDepressionScreeningSaveButton,strOutErrorDesc)
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
	isPass = checkForPopup("Depression Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Expected Message box does not appear.")
		Exit Function
	End If
	
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	'==================================================================
	'Verify the Depression screening score is getting display on screen
	'==================================================================
	intScore = Trim(objDepressionScore.GetROProperty("innertext"))
	If IsNumeric(intScore) Then
		Call WriteToLog("Pass","Current screening score is: "&intScore)
	Else
		Call WriteToLog("Fail","Current screening score is not a Numeric value. Actual value is: " & intScore)
		Exit Function
	End If

	depressionScreening = true
End Function

Function killAllObjects()
	Execute "Set objDepressionScreeningTitle = Nothing"
	Execute "Set objDepressionScreeningDate = Nothing"
	Execute "Set objDepressionScore = Nothing"
	Execute "Set objDepressionScreeningAddButton= Nothing"
	Execute "Set objDepressionScreeningPostponeButton= Nothing"
	Execute "Set objDepressionScreeningSaveButton= Nothing"
	Execute "Set objScreeningHistorySection= Nothing"
	Execute "Set objPatientRefusedCheckBox = Nothing"
	Execute "Set objPopupTitle = Nothing"
	Execute "Set objPopupText = Nothing"
	Execute "Set objCaregiverSurveyCheckBox = Nothing"
	Execute "Set objOKButton= Nothing"
End Function


Function depression_ValidateHistory(Byval dtScreeningCompletedDate, ByVal message)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	Depression_ValidateHistory = False
	
	Execute "Set objDS_ScrHistUpArw = " & Environment("Im_HistoryUpArrow")
	
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
	End If
	Call WriteToLog("Pass", "History table is populated with screening details and number of entries are :"&RowCount)


	Execute "Set objHeaderTable = " & Environment("WT_HistoryHeaderTable")
	If not objHeaderTable.Exist(10) Then
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
	For R = 1 To RowCount Step 1
		ReDim Preserve arrScreeningHistoryInfo(RowCount-1)
		For C = 1 To objDS_ScrHtryTable.ColumnCount(R) Step 1
				If C = 1 Then
					dtCompletedDateHT = objDS_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 2 Then
					intScore = objDS_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 3 Then
					intScreeningLevel = objDS_ScrHtryTable.GetCellData(R,C)
				ElseIf C = 4 Then
					strLevelComments = objDS_ScrHtryTable.GetCellData(R,C)	
				ElseIf C = 5 Then
					strSurveyComments = objDS_ScrHtryTable.GetCellData(R,C)
				End If
		Next
		arrScreeningHistoryInfo(R-1) = dtCompletedDateHT & "|" & intScore & "|" & intScreeningLevel & "|" & strLevelComments & "|" & strSurveyComments
	Next
	
	'Validate the latest screening details from the history table
	Dim isFound : isFound = false
	For i = 0 To UBound(arrScreeningHistoryInfo)
		hist = split(arrScreeningHistoryInfo(i),"|")
		If CDate(hist(0)) = CDate(dtScreeningCompletedDate) Then
			If message = hist(4) Then
				Call WriteToLog("Pass", "Required survey comments found in history table - '" & hist(4) & "' for the date - '" & hist(0) & "'")
'				isFound = true
'				Exit For
			Else
				Call WriteToLog("Info", "The data in history table - '" & hist(4) & "' for the date - '" & hist(0) & "'")
			End If
		Else
			Call WriteToLog("Info", "The data in history table - '" & hist(4) & "' for the date - '" & hist(0) & "'")
		End If
	Next
	
'	If not isFound Then
'		Call WriteToLog("Fail", "Required survey comments - '" & message & "' for the date - '" & date & "' is not found in history table.")
'	End If
		
	Depression_ValidateHistory = True
	
	Execute "Set objDS_ScrHistDnArw = " & Environment("Im_HistoryDownArrow")
	objDS_ScrHistDnArw.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	Err.Clear
	Execute "Set objDS_ScrHistUpArw = Nothing"
	Execute "Set objDS_ScrHtryTable = Nothing"
	Execute "Set objDS_ScrHistDnArw = Nothing"
End Function
