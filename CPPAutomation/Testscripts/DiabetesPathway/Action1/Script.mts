' TestCase Name			: DiabetesPathway
' Purpose of TC			: To perform Diabetes Pathway
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "DiabetesPathway", "DiabetesPathway", strOutErrorDesc) 
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
Function killAllObjects()
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
		
		Call WriteToLog("info", "Diabetes Pathway for the member id - " & strMemberID)
		
		isPass = diabetesPathway()
		If Not isPass Then
			Call WriteToLog("Fail", "Diabetes Pathway failed for the member - " & strMemberID)
		End If
	End If	
Next

If not isRun Then
	Call WriteToLog("info", "There are rows marked Y(Yes) for execution.")
End If

Logout
CloseAllBrowsers
WriteLogFooter

Function diabetesPathway()
	On Error Resume Next
	Err.Clear
	diabetesPathway = false
	
	Call clickOnSubMenu("Clinical Management->Diabetes")
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Call WriteToLog("info", "Test case - Validate all the tabs in Diabetes Management")
'	validate if Diabetes management screen launched
	Execute "Set objDiabetesManagementTitle = " & Environment("WE_DiabetesManagement_Title")
	If not objDiabetesManagementTitle.Exist(3) Then
		Call WriteToLog("Fail", "Failed to navigate to Diabtetes Management screen.")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Successfully navigated to Diabtetes Management screen.")
	
'	verify if Pathway, Screening, Materials and Referrals tabs exists
	Execute "Set objScreeningTab = " & Environment("WEL_DiabetesManagement_ScreeningTab")
	If Not objScreeningTab.Exist(3) Then
		Call WriteToLog("Fail", "Screening tab does not exist.")
	Else
		Call WriteToLog("Pass", "Screening tab exists.")
	End If

	
	Execute "Set objMaterialsTab = " & Environment("WE_DiabetesManagement_MaterialTab")
	If Not objMaterialsTab.Exist(3) Then
		Call WriteToLog("Fail", "Materials tab does not exist.")
	Else
		Call WriteToLog("Pass", "Materials tab exists.")
	End If
	
	Execute "Set objReferralsTab = " & Environment("WE_DiabetesManagement_ReferralsTab")
	If Not objReferralsTab.Exist(3) Then
		Call WriteToLog("Fail", "Referrals tab does not exist.")
	Else
		Call WriteToLog("Pass", "Referrals tab exists.")
	End If
	
	Execute "Set objPathwayTab = " & Environment("WE_DiabetesManagement_PathwayTab")
	If Not objPathwayTab.Exist(1) Then
		Call WriteToLog("Fail", "Pathway tab does not exist.")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Pathway tab exists.")
	
	'click on Pathway tab
	objPathwayTab.Click
	
	wait 2
	
	Call WriteToLog("info", "Test case - Validate all the labels and text in Pathway screen")
	'verify the labels
	labelNames = "Last Blood Sugar Pathway; Diabetic Provider; Last A1C; Diabetic Material Last Requested Date; Diabetic Material Last Fulfilled Date; Diabetic Material Name and Description"

	labels = Split(labelNames, ";")
	For i = LBound(labels) To UBound(labels)
		Set objLabel = getPageObject().WebElement("class:=item-title.*", "html tag:=SPAN", "innerhtml:=" & labels(i) & "")
		If Not objLabel.Exist(1) Then
			Call WriteToLog("Fail", labels(i) & " - label does not exist")
		Else
			Call WriteToLog("Pass", labels(i) & " - label exist")
		End If
	Next
	
'	verify the remaining labels
'	Frequency to complete Pathway	
	Execute "Set objFreqCompPathway = " & Environment("WE_DiabetesManagement_FrequencyLabel")
	If not objFreqCompPathway.Exist(3) then
		Call WriteToLog("Fail", "Frequency to complete pathway label does not exist")
	Else
		Call WriteToLog("Pass", "Frequency to complete pathway label  exists")
	End if
	
	Execute "Set objDiabComplicationText = " & Environment("WE_DiabetesManagement_FrequencyLabel")
	If not objDiabComplicationText.Exist(3) then
		Call WriteToLog("Fail", "Frequency to complete pathway statement does not exist")
	Else
		Call WriteToLog("Pass", "Frequency to complete pathway statement exists")
	End if
	
'	Pathway Focus
	Execute "Set objPathwayFocus = " & Environment("WE_DiabetesManagement_PathwayFocusLabel")
	If not objPathwayFocus.Exist(3) then
		Call WriteToLog("Fail", "Pathway Focus label does not exist")
	Else
		Call WriteToLog("Pass", "Pathway Focus label  exists")
	End if
	
	Execute "Set objPathwayFocusText = " & Environment("WE_DiabetesManagement_PathwayFocusText")
	if not objPathwayFocusText.Exist(3) then
		Call WriteToLog("Fail", "Pathway Focus statement does not exist")
	Else
		Call WriteToLog("Pass", "Pathway Focus statement exists")
	End if
	
'	Care Script
	Execute "Set objCareScriptLabel = " & Environment("WE_DiabetesManagement_CareScriptLabel")
	If not objCareScriptLabel.Exist(3) then
		Call WriteToLog("Fail", "Care Script label does not exist")
	Else
		Call WriteToLog("Pass", "Care Script label  exists")
	End if
	
	Execute "Set objCareScriptText = " & Environment("WE_DiabetesManagement_CareScriptText")
	if not objCareScriptText.Exist(3) then
		Call WriteToLog("Fail", "Care Script statement does not exist")
	Else
		Call WriteToLog("Pass", "Care Script statement exists")
	End if

	Call WriteToLog("info", "Test case - Validate all the buttons in the Pathway")
	'verify the buttons
	'check if Add button is enabled or disabled
	Execute "Set objAddbtn = " & Environment("WE_DiabetesPathway_Add")
	'if Add button is disabled
	If objAddbtn.Object.isDisabled Then
		Call WriteToLog("Pass", "Add button is disabled.")
		
		'verify postpone button is enabled
		Execute "Set objPostponebtn = " & Environment("WE_DiabetesPathway_Postpone")
		If not objPostponebtn.Object.isDisabled Then
			Call WriteToLog("Pass", "Postpone button is enabled.")
		Else
			Call WriteToLog("Fail", "Postpone button is disabled.")
		End If
		
		'verify save button is disabled
		Execute "Set objSavebtn = " & Environment("WE_DiabetesPathway_Save")
		If objSavebtn.Object.isDisabled Then
			Call WriteToLog("Pass", "Save button is disabled.")
		Else
			Call WriteToLog("Fail", "Save button is enabled.")
		End If
		
		'verify cancel button is enabled
		Execute "Set objCancelbtn = " & Environment("WE_DiabetesPathway_Cancel")
		If not objCancelbtn.Object.isDisabled Then
			Call WriteToLog("Pass", "Cancel button is enabled.")
		Else
			Call WriteToLog("Fail", "Cancel button is disabled.")
		End If
	Else
		Call WriteToLog("Pass", "Add button is enabled.")
		
		'verify postpone button is disabled
		Execute "Set objPostponebtn = " & Environment("WE_DiabetesPathway_Postpone")
		If not objPostponebtn.Object.isDisabled Then
			Call WriteToLog("Fail", "Postpone button is enabled.")
		Else
			Call WriteToLog("Pass", "Postpone button is disabled.")
		End If
		
		'verify save button is disabled
		Execute "Set objSavebtn = " & Environment("WE_DiabetesPathway_Save")
		If objSavebtn.Object.isDisabled Then
			Call WriteToLog("Pass", "Save button is disabled.")
		Else
			Call WriteToLog("Fail", "Save button is enabled.")
		End If
		
		'verify cancel button is disabled
		Execute "Set objCancelbtn = " & Environment("WE_DiabetesPathway_Cancel")
		If not objCancelbtn.Object.isDisabled Then
			Call WriteToLog("Fail", "Cancel button is enabled.")
		Else
			Call WriteToLog("Pass", "Cancel button is disabled.")
		End If
		
		Execute "Set objAddbtn = " & Environment("WE_DiabetesPathway_Add")
		objAddbtn.Click
		wait 2
		waitTillLoads "Loading..."
		wait 2
	End If
	
	Call WriteToLog("info", "Test case - Validate the default questions")
'	validate the questions - by default first 3 questions should appear
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("class").Value = "content.*"
	oDesc("html tag").Value = "SPAN"
	
	Set objQ = getPageObject().ChildObjects(oDesc)
	
	If objQ.Count = 3 Then
		Call WriteToLog("Pass", "Default 3 questions exists")
	Else
		Call WriteToLog("Fail", "Only " & objQ.Count & " no. of questions exists. Expected is 3.")
	End If
	
	Call WriteToLog("info", "Test case - Validate all the questions")
	Dim dbConnected : dbConnected = true
	isPass = ConnectDB()
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
		Call CloseDBConnection()
		dbConnected = false
	End If
	If dbConnected Then
		Set objQuestions = GetChildObject("micclass;class;html tag","WebElement;content.*;SPAN")
		For i  = 0 To objQuestions.Count-1 Step 1
			uiQuestion = Trim(objQuestions(i).GetROProperty("innertext"))
			dbQuestion = getSurveyQuestionText(49, i + 1)
			
			If trim(dbQuestion) = trim(uiQuestion) Then
				Call WriteToLog("Pass","Question no. " & i + 1 & " of Diabetes Pathway exists and is - " & uiQuestion)
			Else
				Call WriteToLog("Fail","Question no. " & i + 1 & " of Diabetes Pathway is not as required - " & uiQuestion & ". Required Question - " & dbQuestion)
			End If		
		Next
	Else
		For i  = 0 To objQuestions.Count-1
			uiQuestion = Trim(objQuestions(i).GetROProperty("innertext"))
			
			If uiQuestion <> "" Then
				Call WriteToLog("Pass","Question no. " & i + 1 & " of Diabetes Pathway exists and is - " & uiQuestion)
			Else
				Call WriteToLog("Fail","Question no. " & i + 1 & " of Diabetes Pathway is not as required - " & uiQuestion)
			End If		
		Next
	End If
	
	Call CloseDBConnection()
	If objQuestions.Count = 0 Then
		Call WriteToLog("Fail","No question present on the screening page")
		Exit Function
	End If

	isPass = validateSkipToLogic
	If not isPass Then
		Call WriteToLog("Fail", "Failed to validate all the questions.")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Successfully validated all the questions.")
	
	Execute "Set objComments = " & Environment("WE_DiabetesPathway_SurveyComments")
	If CheckObjectExistence(objComments, 10) Then
		Call WriteToLog("Pass", "Comments box exists.")
		objComments.Set "Testing"
	Else
		Call WriteToLog("Fail", "Comments box does not exist")
	End If
	wait 2
	
	Execute "Set objPatientICRReportChkBox = " & Environment("WE_DiabetesPathway_PatientICRChkbox")
	If CheckObjectExistence(objPatientICRReportChkBox, 10) Then
		Call WriteToLog("Pass", "'Include on Patient ICR Report' check box exists.")
		objPatientICRReportChkBox.Click
	Else
		Call WriteToLog("Fail", "'Include on Patient ICR Report' check box does not exist")
	End If

	Execute "Set objProviderICRReportChkBox = " & Environment("WE_DiabetesPathway_ProviderICRChkbox")
	If CheckObjectExistence(objProviderICRReportChkBox, 10) Then
		Call WriteToLog("Pass", "'Include on Provider ICR Report' check box exists.")
		objProviderICRReportChkBox.click
	Else
		Call WriteToLog("Fail", "'Include on Provider ICR Report' check box does not exist")
	End If

	'save
	Execute "Set objSavebtn = " & Environment("WE_DiabetesPathway_Save")
	objSavebtn.Click
	
	wait 2
	waitTillLoads "Saving..."
	wait 2
	
	Execute "Set objacpDate = " & Environment("WE_DiabetesPathway_ACPDate")
	acpDate = objacpDate.getROPRoperty("innertext")
	If CDate(acpDate) = date Then
		Call WriteToLog("Pass", "ACP date is as required.")
	Else
		Call WriteToLog("Fail", "ACP date is not as required.")
	End If
	
'	Call WriteToLog("info", "Test case - Validate the history button")
'	Click on History button
'	Set objHistorybtn = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("html tag:=DIV", "outertext:=.*History.*", "attribute/data-capella-automation-id:=Diabetes Management_Diabetic Blood Sugar Pathway_Pathway_Btn_History")
'	If Not CheckObjectExistence(objHistorybtn, 10) Then
'		Call WriteToLog("Fail", "History button is disabled")
'		Exit Function
'	End If
'	
'	Call WriteToLog("Pass", "History button is enabled.")
'	objHistorybtn.click
'	
'	wait 5
'	
'	Set objHistoryReport = getPageObject().WebElement("outertext:=.*Pathway Report.*","html tag:=DIV", "class:=col-md-10 drag-handler")
'	If CheckObjectExistence(objHistoryReport, 10) Then
'		Call WriteToLog("Pass", "History Report window opened successfully.")
''		getPageObject().Image("file name:=cross-orig-hover.png", "html tag:=IMG", "visible:=True", "class:=pull-right").Click
'	Else
'		Call WriteToLog("Fail", "History Report window did not open")
'	End If
	
	diabetesPathway = true
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


Function validateSkipToLogic()
	validateSkipToLogic = false
	
	isPass = ConnectDB()
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
		Call CloseDBConnection()
		dbConnected = false
		Exit Function
	End If
	
	Dim endOfLoop : endOfLoop = false
	Dim k : k = 0
	Dim qnNo : qnNo = 1
	Dim survey_ques_uid : survey_ques_uid = 608
	Dim survey_option_uid
	Dim labelText
	
	Do while endOfLoop = false
		
	'	get the label objects
		Set oRDesc = Description.Create
		oRDesc("micclass").Value = "WebElement"
		ORDesc("attribute/data-capella-automation-id").Value = "label-o.Description"
		Set oObj = getPageObject().ChildObjects(oRDesc)
		
		count = getOptionCount(survey_ques_uid)
		If count = "NA" Then
			CloseDBConnection
			Exit Function
		End If
		
		For i = 1 To Cint(count)
			labelText = oObj(k).GetROProperty("innertext")
			survey_option_uid = getQuesOptionUid(survey_ques_uid, labelText)
			If survey_option_uid = "NA" Then
				CloseDBConnection
				Exit Function
			End If
			Set ocrDesc = Description.Create
			ocrDesc("micclass").Value = "WebElement"
			ocrDesc("attribute/data-capella-automation-id").Value = "Diabetes Management_PathWay_" & survey_ques_uid & "_" & survey_option_uid
			Set oRadio = getPageobject().ChildObjects(ocrDesc)
			If oRadio.Count = 1 Then
				oRadio(0).Click
				wait 2
				waitTillLoads "Loading..."
				wait 2
			End If
			
			uid = getSkipToQuestion(survey_ques_uid, survey_option_uid)
			If uid = "NA" Then
				CloseDBConnection
				Exit Function
			End If
			
			If Not isNull(uid) Then
				quesText = getSurveySkipToQuestionText(uid)
				If quesText = "NA" Then
					CloseDBConnection
					Exit Function
				End If
			
				Set quesDesc = Description.Create
				quesDesc("micclass").Value = "WebElement"
				quesDesc("attribute/data-capella-automation-id").Value = "label-q.Text"
				
				Set objQuestions = getPageObject().ChildObjects(quesDesc)
				uiQuestion = Trim(objQuestions(qnNo).GetROProperty("innertext"))
				
				If trim(uiQuestion) = quesText Then
					Call WriteToLog("Pass", "SkipToLogic for question " & qnNo & " option " & labelText & " is correct")
				Else
					Call WriteToLog("Fail", "SkipToLogic for question " & qnNo & " option " & labelText & " is wrong")
				End If
			End If
			
			Select Case survey_ques_uid
				Case 608
					If labelText = "No" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Update provider managing diabetes in Comorbids screen.", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Update provider managing diabetes in Comorbids screen.' exists for question 1 and option 'No'")
						Else
							Call WriteToLog("Fail", "Info text - 'Update provider managing diabetes in Comorbids screen.' does NOT exist for question 1 and option 'No'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_608_1431_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Comorbids screen button exists for question 1 and option 'No'")
							
		'					objNavigate.Click
		'					wait 2
		'					waitTillLoads "Loading..."
		'					wait 2				
						Else
							Call WriteToLog("Fail", "Navigate to Comorbids screen does NOT exist for question 1 and option 'No'")
						End If
					ElseIf labelText = "Yes" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Update provider managing diabetes in Comorbids screen.", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Fail", "Info text - 'Update provider managing diabetes in Comorbids screen.' exists for question 1 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Info text - 'Update provider managing diabetes in Comorbids screen.' does NOT exist for question 1 and option 'Yes'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_608_1431_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Comorbids screen button exists for question 1 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Navigate to Comorbids screen does NOT exist for question 1 and option 'Yes'")
						End If
					End If
					
				Case 609
					If labelText = "No" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_609_1433_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Medical Equipment screen button exists for question 2 and option 'No'")
							
		'					objNavigate.Click
		'					wait 2
		'					waitTillLoads "Loading..."
		'					wait 2				
						Else
							Call WriteToLog("Fail", "Navigate to Medical Equipment screen does NOT exist for question 2 and option 'No'")
						End If
					ElseIf labelText = "Yes" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_609_1433_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Medical Equipment screen button exists for question 2 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Navigate to Medical Equipment screen does NOT exist for question 2 and option 'Yes'")
						End If
					End If
				
				Case 612
					If labelText = "Yes" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Refer patient for diabetic education on glucometer use.""", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Refer patient for diabetic education on glucometer use.""' exists for question 5 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Info text - 'Refer patient for diabetic education on glucometer use.""' does NOT exist for question 5 and option 'Yes'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_612_1440_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Referral screen button exists for question 5 and option 'Yes'")
							
		'					objNavigate.Click
		'					wait 2
		'					waitTillLoads "Loading..."
		'					wait 2				
						Else
							Call WriteToLog("Fail", "Navigate to Referral screen does NOT exist for question 5 and option 'Yes'")
						End If
					ElseIf labelText = "No" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Refer patient for diabetic education on glucometer use.""", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Fail", "Info text - 'Refer patient for diabetic education on glucometer use.""' exists for question 5 and option 'No'")
						Else
							Call WriteToLog("Pass", "Info text - 'Refer patient for diabetic education on glucometer use.""' does NOT exist for question 5 and option 'No'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_612_1440_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 5 and option 'No'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen does NOT exist for question 5 and option 'No'")
						End If
					End If
				
				Case 615
					If labelText = "No" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Blood sugar not well controlled, must refer to Diabetic Provider or Diabetic Educator", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Blood sugar not well controlled, must refer to Diabetic Provider or Diabetic Educator' exists for question 8 and option 'No'")
						Else
							Call WriteToLog("Fail", "Info text - 'Blood sugar not well controlled, must refer to Diabetic Provider or Diabetic Educator' does NOT exist for question 8 and option 'No'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_615_1450_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Referral screen button exists for question 8 and option 'No'")
							
		'					objNavigate.Click
		'					wait 2
		'					waitTillLoads "Loading..."
		'					wait 2				
						Else
							Call WriteToLog("Fail", "Navigate to Referral screen does NOT exist for question 8 and option 'No'")
						End If
					ElseIf labelText = "Yes" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Blood sugar not well controlled, must refer to Diabetic Provider or Diabetic Educator", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Fail", "Info text - 'Blood sugar not well controlled, must refer to Diabetic Provider or Diabetic Educator' exists for question 8 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Info text - 'Blood sugar not well controlled, must refer to Diabetic Provider or Diabetic Educator' does NOT exist for question 8 and option 'Yes'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_615_1450_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 8 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen does NOT exist for question 8 and option 'Yes'")
						End If
					End If
					
				Case 618
					If labelText = "Yes" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Display existing materials fulfillment screen for user entry", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Display existing materials fulfillment screen for user entry' exists for question 11 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Info text - 'Display existing materials fulfillment screen for user entry' does NOT exist for question 11 and option 'Yes'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_618_1456_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Referral screen button exists for question 11 and option 'Yes'")
							
		'					objNavigate.Click
		'					wait 2
		'					waitTillLoads "Loading..."
		'					wait 2				
						Else
							Call WriteToLog("Fail", "Navigate to Referral screen does NOT exist for question 11 and option 'Yes'")
						End If
					ElseIf labelText = "No" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Display existing materials fulfillment screen for user entry", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Fail", "Info text - 'Display existing materials fulfillment screen for user entry' exists for question 11 and option 'No'")
						Else
							Call WriteToLog("Pass", "Info text - 'Display existing materials fulfillment screen for user entry' does NOT exist for question 11 and option 'No'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Diabetes Management_618_1456_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 11 and option 'No'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen does NOT exist for question 11 and option 'No'")
						End If
					End If
			End Select
			
			k = k + 1
					
		Next
		
		qnNo = qnNo + 1
		survey_ques_uid = survey_ques_uid + 1
		
		Set olabelDesc  = Nothing
		Set objLabel = Nothing
		Set oObj = Nothing
		Set oRDesc = Nothing
		Set oRadio = Nothing
		Set ocrDesc = Nothing
		
		If k = 29 Then
			endOfLoop = true
		End If
	Loop 
	
	CloseDBConnection
	validateSkipToLogic = true
End Function


Function getSkipToQuestion(ByVal survey_ques_opt_ques_uid, ByVal survey_ques_opt_uid)
	On Error Resume Next
	Err.Clear

	getSkipToQuestion = "NA"
	
	strSQLQuery = "select survey_ques_uid_skipto from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "' and survey_ques_opt_uid = '" & survey_ques_opt_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		quesUid = objDBRecordSet("survey_ques_uid_skipto")
		objDBRecordSet.MoveNext
	Wend
	
	getSkipToQuestion = quesUid

End Function

Function getOptionCount(ByVal survey_ques_opt_ques_uid)
	On Error Resume Next
	Err.Clear

	getOptionCount = "NA"
	
	strSQLQuery = "select count(*) as COUNT from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		count = objDBRecordSet("COUNT")
		objDBRecordSet.MoveNext
	Wend
	
	getOptionCount = count
End Function

Function getQuesOptionUid(ByVal survey_ques_opt_ques_uid, ByVal optionText)
	On Error Resume Next
	Err.Clear

	getQuesOptionUid = "NA"
	
	strSQLQuery = "select survey_ques_opt_uid from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "' and survey_ques_opt_text = '" & optionText & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		optuid = objDBRecordSet("survey_ques_opt_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getQuesOptionUid = optuid
End Function

Function getSurveySkipToQuestionText(ByVal survey_ques_uid)
	
	On Error Resume Next
	Err.Clear

	getSurveySkipToQuestionText = "NA"
	
	strSQLQuery = "select survey_ques_text from capella.survey_questions where survey_ques_uid = '" & survey_ques_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		quesText = objDBRecordSet("survey_ques_text")
		objDBRecordSet.MoveNext
	Wend
	
	getSurveySkipToQuestionText = quesText
	
End Function
