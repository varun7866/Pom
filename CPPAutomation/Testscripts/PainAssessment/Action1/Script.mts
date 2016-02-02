' TestCase Name			: PainAssessment
' Purpose of TC			: To perform Pain Assessment screening
' Author                : Sudheer
' Date					: 08-Sep-2015
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PainAssessment", strOutTestName, strOutErrorDesc) 
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
	Execute "Set objPainAssessmentScreeningTitle = "  & Environment("WEL_PainAssessmentScreeningTitle") 'PainAssessment screening screen title
	Execute "Set objPainAssessmentScreeningDate = " & Environment("WE_PainAssessmentScreening_ScreeningDate") 'PainAssessment screening date object
	Execute "Set objPainAssessmentScore = " & Environment("WE_PainAssessmentScreening_Score")				  'PainAssessment screening Score object
	Execute "Set objPainAssessmentScreeningAddButton= " & Environment("WB_PainAssessmentScreen_AddButton") 	  'PainAssessment screening Add button
	Execute "Set objPainAssessmentScreeningPostponeButton= "  & Environment("WB_PainAssessmentScreen_PostponeButton") 'PainAssessment screening screen postpone button
	Execute "Set objPainAssessmentScreeningSaveButton= " & Environment("WB_PainAssessmentScreen_SaveButton") 'PainAssessment screening screen Save button
	Execute "Set objScreeningHistorySection= " & Environment("WEL_ScreeningHistorySection")		  'PainAssessment screening Screening history section
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
			strOutErrorDesc = "selectPatientFromGlobalSearch returned error: "&strOutErrorDesc
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
		
		Call WriteToLog("info", "Test Case - Pain Assessment Screening for the member id - " & strMemberID)
		
		isPass = painAssessmentScreening()
		If Not isPass Then
			Call WriteToLog("Fail", "Pain Assessment Screening failed for the member - " & strMemberID)
		End If
	End If	
Next

If not isRun Then
	Call WriteToLog("info", "There are rows marked Y(Yes) for execution.")
End If

killAllObjects
Logout
CloseAllBrowsers
WriteLogFooter

Function painAssessmentScreening()

	painAssessmentScreening = false
	intWaitTime = 5
	
	'click on Pain Assessment screening
	clickOnSubMenu("Screenings->Pain Assessment Screening")
		
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'verify if Pain Assessment screening screen loaded
	Execute "Set objPainAssessmentScreeningTitle = "  & Environment("WEL_PainAssessmentScreeningTitle") 'Patient Snapshot> Screening> Pain Assessment screening screen title
	If not CheckObjectExistence(objPainAssessmentScreeningTitle, 10) Then
		Call WriteToLog("Fail","Pain Assessment Screening screen not opened successfully")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Pain Assessment Screening screen opened successfully")
	
	'load all objects required in Pain Assessment Screening
	loadObjects
	
	'=======================================
	'Verify the existance of External Link
	'=======================================
	Call WriteToLog("info", "Test Case - Verify if the external link exists on the screen.")
	Set objExtLink = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("class:=external-link-popup", "html tag:=DIV")
	urlOnUI = objExtLink.GetROProperty("innertext")
	reqUrl = DataTable.Value("ExternalLink","CurrentTestCaseData")
	
	If reqUrl = trim(urlOnUI) Then
		Call WriteToLog("Pass", "The external url in Pain Assessment screen is as required.")
	Else
		Call WriteToLog("Fail", "The external url in Pain Assessment screen is " & trim(urlOnUI) & " but expected is " & reqUrl & ".")
	End If
	
	'=======================================
	'Verify the existance of Screening Date
	'=======================================
	Call WriteToLog("info", "Test Case - Verifying existance of screening date field")
	If CheckObjectExistence(objPainAssessmentScreeningDate,intWaitTime) Then
		Call WriteToLog("Pass","Screening date exist on Pain Assessment screening")		
	Else
		Call WriteToLog("Fail","Screening date does not exist on Pain Assessment screening")
		Exit Function
	End If
	
	'========================================
	'Verify the existance of Pain Assessment score
	'========================================
	Call WriteToLog("info", "Test Case - Verify score field exists")
	If CheckObjectExistence(objPainAssessmentScore,intWaitTime) Then
		Call WriteToLog("Pass","PainAssessment score exist on Pain Assessment screening")		
	Else
		Call WriteToLog("Fail","PainAssessment score does not exist on Pain Assessment screening")	
		Exit Function
	End If
	
	'==============================================
	'Verify that Pain Assessment screening can be edited
	'==============================================
	Call WriteToLog("info", "Test Case - Validate Add, Postpone and Save buttons")
	Dim isNew
	isNew = false
	
	blnReturnValue = objPainAssessmentScreeningAddButton.Object.isDisabled
	If blnReturnValue Then
		Call WriteToLog("info","Screening already completed or screening is in incompleted")
		isNew = true
	Else
		Call WriteToLog("info", "Screening not done yet.")
	End If
	
	If not isNew Then	'screening not done yet
		'====================================
		'Verify the existance of Add button
		'====================================
		blnReturnValue = objPainAssessmentScreeningAddButton.Object.isDisabled
		If Not blnReturnValue Then
			Call WriteToLog("Pass","Add button exist on Pain Assessment screening")
		Else
			Call WriteToLog("Fail","Add button does not exist on Pain Assessment screening")
			Exit Function
		End If
		
		'=======================================
		'Verify the existance of postpone button
		'=======================================
		blnReturnValue = objPainAssessmentScreeningPostponeButton.Object.isDisabled
		If blnReturnValue  Then
			Call WriteToLog("Pass","Postpone button disabled")
		Else
			Call WriteToLog("Fail","Postpone button is enabled")
		End If
		
		'===================================
		'Verify the existance of Save button
		'===================================
		blnReturnValue = objPainAssessmentScreeningSaveButton.Object.isDisabled
		If blnReturnValue Then
			Call WriteToLog("Pass","Save button is disabled")
		Else
			Call WriteToLog("Fail","Save button is enabled")
		End If
	Else	'screening is not done. this is first time screening
		'====================================
		'Verify the existance of Add button
		'====================================
		blnReturnValue = objPainAssessmentScreeningAddButton.Object.isDisabled
		If blnReturnValue Then
			Call WriteToLog("Pass","Add button exist on Pain Assessment screening")
		Else
			Call WriteToLog("Fail","Add button does not exist on Pain Assessment screening")
			Exit Function
		End If
		
		'=======================================
		'Verify the existance of postpone button
		'=======================================
		blnReturnValue = objPainAssessmentScreeningPostponeButton.Object.isDisabled
		If blnReturnValue  Then
			Call WriteToLog("Pass","Postpone button is disabled")
		Else
			Call WriteToLog("Fail","Postpone button is enabled")
		End If
		
		'===================================
		'Verify the existance of Save button
		'===================================
		blnReturnValue = objPainAssessmentScreeningSaveButton.Object.isDisabled
		If blnReturnValue Then
			Call WriteToLog("Pass","Save button is disabled")
		Else
			Call WriteToLog("Fail","Save button is enabled")
		End If	
	End If
		
	'==================================================
	'Verify the existance of Screening history section
	'==================================================
	Call WriteToLog("info", "Test Case - Validate if History section exists")
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
		blnReturnValue = ClickButton("Add",objPainAssessmentScreeningAddButton,strOutErrorDesc)
		Wait intWaitTime/2
		If not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
			Exit Function
		End If
	End If
	
	
	'================================================================
	'Verify the number of radio button on Depresion screening screen
	'================================================================
	Call WriteToLog("info","Test case - verifying if required number of questions exists.")
	Set objRadioOptions = GetChildObject("micclass;html tag;cols","WebTable;TABLE;2")
	If objRadioOptions.Count = 0 Then
		Call WriteToLog("Fail","No questions options present on the screening page")
		Exit Function
	End If
	
	For i  = 0 To objRadioOptions.Count-2 Step 1
		Err.Clear
		objRadioOptions(i).ChildItem(1,1,"WebElement",0).Click
		Wait 1
		If Err.Number <> 0 Then
			Call WriteToLog("Fail",objRadioOptions(i) & " option does not click successfully. Error Returned: "&Err.Description)
			Exit Function
		End If
	Next
	
	Set objRadioOptions = Nothing
	
	'===============================================================
	'Verify the number of question of Pain Assessment questions
	'===============================================================
	Set objQuestions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*screening-question-answer-text.*;DIV;.*question.Text.*")
	For i  = 0 To objQuestions.Count-1 Step 1
		Call WriteToLog("Pass",i+ 1& " question of Depression screen is "&Trim(objQuestions(i).GetROProperty("innertext")))
	Next
	
	If objQuestions.Count = 0 Then
		Call WriteToLog("Fail","No question present on the screening page")
		Exit Function
	End If
	
	'================================================================
	'Verify the number of radio button on Pain Assessment screen
	'================================================================
	Set objRadioOptions = GetChildObject("micclass;html tag;cols","WebTable;TABLE;2")
	If objRadioOptions.Count = 0 Then
		Call WriteToLog("Fail","No radio buttons/questions present on the screening page")
		Exit Function
	End If
	Print objRadioOptions.Count
	
	'=======================================
	'Verify the postpone functionality
	'=======================================
	Call WriteToLog("info", "Test Case - validate Postpone functionality")
	
	objRadioOptions(0).ChildItem(1,1,"WebElement",0).Click
	wait 1
	blnReturnValue = objPainAssessmentScreeningPostponeButton.Object.isDisabled
	If Not blnReturnValue Then
		Call WriteToLog("Pass","Postpone button is enabled after click on Add button and selecting an option")
	Else
		Call WriteToLog("Fail","Postpone button is not enabled after clicking on Add button and selecting an option")
	End If
	Set objRadioOptions = Nothing
	'click on postpone button
	If not blnReturnValue Then
		Err.Clear
		objPainAssessmentScreeningPostponeButton.Click
		wait 2
		waitTillLoads "Loading..."
		wait 2
		
		If err.Number <> 0 Then
			Call WriteToLog("Fail", "Error while clicking on Postpone button. Failed to verify postpone functionality")
		Else
			isPass = checkForPopup("Pain Assessment Screening", "Ok", "Screening has been saved successfully", strOutErrorDesc)
			If not isPass Then
				Call WriteToLog("Fail", "Failed to verify postpone functionality.")
				Exit Function
			End If
			
			'navigate to other screen and come back to verify if same options are checked.
			clickOnMainMenu "PatientSnapshot"
			wait 2
			waitTillLoads "Loading..."
			wait 1
			'click on Pain Assessment screening
			clickOnSubMenu("Screenings->Pain Assessment Screening")
				
			wait 2
			waitTillLoads "Loading..."
			wait 2
			
			'verify if Pain Assessment screening screen loaded
			Execute "Set objPainAssessmentScreeningTitle = "  & Environment("WEL_PainAssessmentScreeningTitle") 'Patient Snapshot> Screening> Pain Assessment screening screen title
			If not CheckObjectExistence(objPainAssessmentScreeningTitle, 10) Then
				Call WriteToLog("Fail","Pain Assessment Screening screen not opened successfully")
				Exit Function
			End If
			
			'verify if the options previously checked are existing
			Set objRadioOptions = GetChildObject("micclass;html tag;cols","WebTable;TABLE;2")
			If objRadioOptions.Count = 0 Then
				Call WriteToLog("Fail","No radio buttons/questions present on the screening page")
				Exit Function
			End If
			Set oDesc = Description.Create
			oDesc("micclass").Value = "WebElement"
			
			Set objObject = objRadioOptions(0).ChildObjects(oDesc)
			classProp = objObject(0).getROProperty("class")
			Print classProp
			
			Call WriteToLog("Pass", "Postpone functionality working correctly")
		End If
	Else
		Call WriteToLog("Fail", "Failed to verify postpone functionality")
	End If
	
	Call WriteToLog("info", "Test Case - Complete the questions and save")
	Dim id
	For q = 1 To 5
		answer = DataTable.Value("Question"&q, "CurrentTestCaseData")
		Select Case q
			Case 1:
				If lcase(answer) = "yes" Then
					id = 0
				ElseIf lcase(answer) = "no" Then
					id = 1
				End If
			Case 2:
				If lcase(answer) = "mild" Then
					id = 2
				ElseIf lcase(answer) = "moderate" Then
					id = 3
				Else
					id = 4
				End If
			Case 3:
				answers = split(answer,";")
				For a = 0 To UBound(answers)
					If lcase(answers(a)) = "head" Then
						id = 5
					ElseIf lcase(answers(a)) = "stomach" Then
						id = 6
					ElseIf lcase(answers(a)) = "back, coccyx" Then
						id = 7
					Else
						id = 8
					End If
					err.clear
					objRadioOptions(id).ChildItem(1,1,"WebElement",0).Click
				Next
			Case 4:
				If lcase(answer) = "nociceptive" Then
					id = 9
				ElseIf lcase(answer) = "neuropathic" Then
					id = 10
				Else
					id = 11
				End If
			Case 5:
				answers = split(answer,";")
				For a = 0 To UBound(answers)
					If lcase(answers(a)) = "medications ( prescription or otc)" Then
						id = 12
					ElseIf lcase(answers(a)) = "physical therapy" Then
						id = 13
					ElseIf lcase(answers(a)) = "chiropractor" Then
						id = 14
					ElseIf lcase(answers(a)) = "relaxation" Then
						id = 15
					ElseIf lcase(answers(a)) = "meditation" Then
						id = 16
					ElseIf lcase(answers(a)) = "massage therapy" Then
						id = 17
					Else
						id = 18
					End If
					
					err.clear
					objRadioOptions(id).ChildItem(1,1,"WebElement",0).Click
				Next
		End Select
		
		'click on required radio button
		If q <> 3 and q <> 5 Then
			Err.Clear
			objRadioOptions(id).ChildItem(1,1,"WebElement",0).Click
		End If
		
		Wait 1
		If Err.Number <> 0 Then
			Call WriteToLog("Fail",objRadioOptions(id) & " option does not click successfully. Error Returned: "&Err.Description)
		Else
			Call WriteToLog("Pass","Selected the option for the Question"&q)
		End If
		
		If q = 1 and id = 1 Then
			Exit For
		End If
	Next
	
	'========================
	'Now Click on Save button
	'=========================
	blnReturnValue = ClickButton("Save",objPainAssessmentScreeningSaveButton,strOutErrorDesc)
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
	isPass = checkForPopup("Pain Assessment Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Expected Message box does not appear.")
		Exit Function
	End If
	
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	'==================================================================
	'Verify the Pain Assessment screening score is getting display on screen
	'==================================================================
	intScore = Trim(objPainAssessmentScore.GetROProperty("innertext"))
	If IsNumeric(intScore) Then
		Call WriteToLog("Pass","Current screening score is: "&intScore)
	Else
		Call WriteToLog("Fail","Current screening score is not a Numeric value. Actual value is: " & intScore)
		Exit Function
	End If
	
	wait 2
	Call WriteToLog("info", "Test Case - Check screening history")
	validateScreeningHistory
	
	painAssessmentScreening = true
End Function

Function killAllObjects()
	Execute "Set objOKButton= Nothing"
End Function


Function validateScreeningHistory()
'	On Error Resume Next
'	Err.Clear
	Dim columnHeaders
	columnHeaders = "Completed Date;Score;Screening Level;Level Comments;"
	Set objScreeningHistoryTab = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("outertext:=.*Screening History.*","html tag:=DIV","visible:=True", "class:=col-xs-12 heading")
	objScreeningHistoryTab.Click
	Set objScreeningHistoryTab = Nothing
	wait 2
	
	Set objHistoryPanel = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("html id:=adl-screening", "html tag:=DIV")
	objHistoryPanel.highlight
	
	Set tableDesc = Description.Create
	tableDesc("micclass").Value = "WebTable"
	
	Set objTables = objHistoryPanel.ChildObjects(tableDesc)
	Print objTables.Count
	
	Set objTableHeader = objTables(0)
	objTableHeader.highlight
	
	columnNames = objTableHeader.GetROProperty("column names")
	Print columnNames
	If columnHeaders = trim(columnNames) Then
		Print "Pass"
	Else 
		Print "Fail"
	End If
	
	Set objTable = objTables(1)
	
	Print objTable.RowCount
	
	If objTable.RowCount = 0 Then
		Print "No screening history found."
		Exit Function
	End If
	
	colCount = objTable.getROProperty("cols")
	For row = 1 To objTable.RowCount
		For col = 1 To colCount
			x = objTable.GetCellData(row, col)
			Print x
		Next
	Next
	
	Set objScreeningHistoryTab = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("outertext:=.*Screening History.*","html tag:=DIV","visible:=True", "class:=col-xs-12 heading")
	objScreeningHistoryTab.Click
	Set objScreeningHistoryTab = Nothing
	
	Set objTables = Nothing
	Set tableDesc = Nothing
	Set objHistoryPanel = Nothing
	Set objTableHeader = Nothing
	
End Function




