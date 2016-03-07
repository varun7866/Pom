' TestCase Name			: FluidManagement
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "FluidManagement", strOutTestName, strOutErrorDesc) 
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
	
End Function

'=====================================
'start test execution
'=====================================
'Call WriteToLog("info", "Test case - Login to Capella using VHN role")
''Login to Capella as VHN
'isPass = Login("vhn")
'If not isPass Then
'	Call WriteToLog("Fail","Failed to Login to VHN role.")
'	CloseAllBrowsers
'	killAllObjects
'	Call WriteLogFooter()
'	ExitAction
'End If
'
'Call WriteToLog("Pass","Successfully logged into VHN role")
'Dim isRun
'isRun = false
'intRowCount = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
'For RowNumber = 1 to intRowCount step 1
'	DataTable.SetCurrentRow(RowNumber)
'	
'	runflag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
'	
'	If trim(lcase(runflag)) = "y" Then
'		'close all open patients
'		isRun = true
'		isPass = CloseAllOpenPatient(strOutErrorDesc)
'		If Not isPass Then
'			strOutErrorDesc = "CloseAllOpenPatient returned error: " & strOutErrorDesc
'			Call WriteToLog("Fail", strOutErrorDesc)
'			Logout
'			CloseAllBrowsers
'			Call WriteLogFooter()
'			ExitAction
'		End If
'	
'		strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
'		isPass = selectPatientFromGlobalSearch(strMemberID)
'		If Not isPass Then
'			strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
'			Call WriteToLog("Fail", strOutErrorDesc)
'			Logout
'			CloseAllBrowsers
'			Call WriteLogFooter()
'			ExitAction
'		End If
'		
'		'wait till the member loads
'		wait 2
'		waitTillLoads "Loading..."
'		wait 2
'		
'		Call WriteToLog("info", "Test Case - Depression Screening for the member id - " & strMemberID)
		
		isPass = fluidManagement()
'		If not isPass Then
'			clickOnSubMenu "Patient Snapshot"
'
'			wait 2
'			waitTillLoads "Loading..."
'			wait 2
'			
'			isPass = checkForPopup("Depression Screening", "Yes", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
'			If not isPass Then
'				Call WriteToLog("Fail", "Expected Message box does not appear.")
'			End If
'		
'			
'			wait 2
'			waitTillLoads "Loading..."
'			wait 2
'		End If
'		If Not isPass Then
'			Call WriteToLog("Fail", "Depression Screening failed for the member - " & strMemberID)
'		End If
'	End If	
'Next
'
'If not isRun Then
'	Call WriteToLog("info", "There are NO rows marked Y(Yes) for execution.")
'End If
'
'killAllObjects
'Logout
'CloseAllBrowsers
'WriteLogFooter

Function fluidManagement()
	On Error Resume Next
	Err.Clear
	
	fluidManagement = false
	
	Call clickOnSubMenu("Clinical Management->Fluid Management")
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Call WriteToLog("info", "Test case - Validate all the tabs in Fluid Management")
	'validate if Fluid management screen launched
	Execute "Set objFluidManagementTitle = " & Environment("WE_FluidManagement_Title")
	If not objFluidManagementTitle.Exist(3) Then
		Call WriteToLog("Fail", "Failed to navigate to Fluid Management screen.")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Successfully navigated to Fluid Management screen.")
	
'	verify if Pathway, Review, Materials and Referrals tabs exists
	Execute "Set objReviewTab = " & Environment("WEL_FluidManagement_ReviewTab")
	If Not objReviewTab.Exist(3) Then
		Call WriteToLog("Fail", "Review tab does not exist.")
	Else
		Call WriteToLog("Pass", "Review tab exists.")
	End If
	
	Execute "Set objMaterialsTab = " & Environment("WE_FluidManagement_MaterialTab")
	If Not objMaterialsTab.Exist(3) Then
		Call WriteToLog("Fail", "Materials tab does not exist.")
	Else
		Call WriteToLog("Pass", "Materials tab exists.")
	End If
	
	Execute "Set objReferralsTab = " & Environment("WE_FluidManagement_ReferralsTab")
	If Not objReferralsTab.Exist(3) Then
		Call WriteToLog("Fail", "Referrals tab does not exist.")
	Else
		Call WriteToLog("Pass", "Referrals tab exists.")
	End If
	
	Execute "Set objPathwayTab = " & Environment("WE_FluidManagement_PathwayTab")
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
	labelNames = "Last Reviewed; Display the last 5 treatment records for DVA patients; Treatment Record 1; Treatment Record 2; Treatment Record 3; Treatment Record 4; Treatment Record 5; Last LDL; Cardiologist Name; Meds; Fluid CHF Last Requested Date; Fluid CHF Material Last Fulfilled Date; Fluid CHF Material Name and Description"

	labels = Split(labelNames, ";")
	For i = LBound(labels) To UBound(labels)
		Set objLabel = getPageObject().WebElement("attribute/data-capella-automation-id:=.*label-staticData.LabelText.*", "html tag:=SPAN", "innerhtml:=" & labels(i) & "")
		If Not objLabel.Exist(1) Then
			Call WriteToLog("Fail", labels(i) & " - label does not exist")
		Else
			Call WriteToLog("Pass", labels(i) & " - label exist")
		End If
	Next
	
	'verify the remaining labels
	'Frequency to complete Pathway	
	Execute "Set objFreqCompPathway = " & Environment("WE_FluidManagement_FrequencyLabel")
	objFreqCompPathway.highlight
	If not objFreqCompPathway.Exist(3) then
		Call WriteToLog("Fail", "Frequency to complete pathway label does not exist")
	Else
		Call WriteToLog("Pass", "Frequency to complete pathway label  exists")
	End if
	
	Execute "Set objFrequencyText = " & Environment("WE_FluidManagement_FrequencyText")
	objFrequencyText.highlight
	If not objFrequencyText.Exist(3) then
		Call WriteToLog("Fail", "Frequency to complete pathway statement does not exist")
	Else
		Call WriteToLog("Pass", "Frequency to complete pathway statement exists")
	End if
	
'	Pathway Focus
	Execute "Set objPathwayFocus = " & Environment("WE_FluidManagement_PathwayFocusLabel")
	objPathwayFocus.highlight
	If not objPathwayFocus.Exist(3) then
		Call WriteToLog("Fail", "Pathway Focus label does not exist")
	Else
		Call WriteToLog("Pass", "Pathway Focus label  exists")
	End if
	
	Execute "Set objPathwayFocusText = " & Environment("WE_FluidManagement_PathwayFocusText")
	objPathwayFocusText.highlight 
	if not objPathwayFocusText.Exist(3) then
		Call WriteToLog("Fail", "Pathway Focus statement does not exist")
	Else
		Call WriteToLog("Pass", "Pathway Focus statement exists")
	End if
	
'	Care Script
	Execute "Set objCareScriptLabel = " & Environment("WE_FluidManagement_CareScriptLabel")
	objCareScriptLabel.highlight
	If not objCareScriptLabel.Exist(3) then
		Call WriteToLog("Fail", "Care Script label does not exist")
	Else
		Call WriteToLog("Pass", "Care Script label  exists")
	End if
	
	Execute "Set objCareScriptText = " & Environment("WE_FluidManagement_CareScriptText")
	if not objCareScriptText.Exist(3) then
		Call WriteToLog("Fail", "Care Script statement does not exist")
	Else
		Call WriteToLog("Pass", "Care Script statement exists")
	End if
	
	Call WriteToLog("info", "Test case - Validate all the buttons in the Pathway")
	'verify the buttons
	'check if Add button is enabled or disabled
	Execute "Set objAddbtn = " & Environment("WE_FluidPathway_Add")
	'if Add button is disabled
	If objAddbtn.Object.isDisabled Then
		Call WriteToLog("Pass", "Add button is disabled.")
		
		'verify postpone button is enabled
		Execute "Set objPostponebtn = " & Environment("WE_FluidPathway_Postpone")
		If not objPostponebtn.Object.isDisabled Then
			Call WriteToLog("Pass", "Postpone button is enabled.")
		Else
			Call WriteToLog("Fail", "Postpone button is disabled.")
		End If
		
		'verify save button is disabled
		Execute "Set objSavebtn = " & Environment("WE_FluidPathway_Save")
		If objSavebtn.Object.isDisabled Then
			Call WriteToLog("Pass", "Save button is disabled.")
		Else
			Call WriteToLog("Fail", "Save button is enabled.")
		End If
		
		'verify cancel button is enabled
		Execute "Set objCancelbtn = " & Environment("WE_FluidPathway_Cancel")
		If not objCancelbtn.Object.isDisabled Then
			Call WriteToLog("Pass", "Cancel button is enabled.")
		Else
			Call WriteToLog("Fail", "Cancel button is disabled.")
		End If
	Else
		Call WriteToLog("Pass", "Add button is enabled.")
		
		'verify postpone button is disabled
		Execute "Set objPostponebtn = " & Environment("WE_FluidPathway_Postpone")
		If not objPostponebtn.Object.isDisabled Then
			Call WriteToLog("Fail", "Postpone button is enabled.")
		Else
			Call WriteToLog("Pass", "Postpone button is disabled.")
		End If
		
		'verify save button is disabled
		Execute "Set objSavebtn = " & Environment("WE_FluidPathway_Save")
		If objSavebtn.Object.isDisabled Then
			Call WriteToLog("Pass", "Save button is disabled.")
		Else
			Call WriteToLog("Fail", "Save button is enabled.")
		End If
		
		'verify cancel button is disabled
		Execute "Set objCancelbtn = " & Environment("WE_FluidPathway_Cancel")
		If not objCancelbtn.Object.isDisabled Then
			Call WriteToLog("Fail", "Cancel button is enabled.")
		Else
			Call WriteToLog("Pass", "Cancel button is disabled.")
		End If
		
		Execute "Set objAddbtn = " & Environment("WE_FluidPathway_Add")
		objAddbtn.Click
		wait 2
		waitTillLoads "Loading..."
		wait 2
	End If
	
	Call WriteToLog("info", "Test case - Validate the default questions")

'	validate the questions - by default first 2 questions should appear
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("attribute/data-capella-automation-id").Value = "label-q.Text"
	oDesc("html tag").Value = "SPAN"
	
	Set objQ = getPageObject().ChildObjects(oDesc)
	
	If objQ.Count = 2 Then
		Call WriteToLog("Pass", "Default 2 questions exists")
	Else
		Call WriteToLog("Fail", "Only " & objQ.Count & " no. of questions exists. Expected is 2.")
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
		Set objQuestions = GetChildObject("micclass;attribute/data-capella-automation-id;html tag","WebElement;label-q.Text;SPAN")
		For i  = 0 To objQuestions.Count-1 Step 1
			uiQuestion = Trim(objQuestions(i).GetROProperty("innertext"))
			dbQuestion = getSurveyQuestionText(58, i + 1)
			
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
	Execute "Set objSavebtn = " & Environment("WE_FluidPathway_Save")
	objSavebtn.Click
	
	wait 2
	waitTillLoads "Saving..."
	wait 2
	
	Execute "Set objacpDate = " & Environment("WE_DiabetesPathway_ACPDate")
	acpDate = objacpDate.getROPRoperty("innertext")
	If CDate(acpDate) = date Then
		Call WriteToLog("Pass", "Pathway completed date is saved as required.")
	Else
		Call WriteToLog("Fail", "Pathway completed date is NOT saved as required.")
	End If
	
'	validate Pathway report window exists when clicking on History button
	Execute "Set objHistoryBtn = " & Environment("WE_FluidPathway_History")
	If CheckObjectExistence(objHistoryBtn, 10) Then
		Call WriteToLog("Pass", "History button is enabled")
	Else
		Call WriteToLog("Fail", "History button is disabled")
	End If
	objHistoryBtn.Click
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Execute "Set objPathwayReportWindow = " & Environment("WE_FluidPathway_Report")
	If CheckObjectExistence(objPathwayReportWindow, 10) Then
		Call WriteToLog("Pass", "Pathway report window exists on clicking History button.")
	Else
		Call WriteToLog("Fail", "Pathway report window does NOT exist on clicking History button.")
		Exit Function
	End If
	objPathwayReportWindow.highlight
	objPathwayReportWindow.Image("file name:=cross-orig.png", "html tag:=IMG").Click
	
	fluidManagement = true

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
	Dim survey_ques_uid : survey_ques_uid = 712
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
			Print qnNo
			labelText = oObj(k).GetROProperty("innertext")
			Print labelText
			survey_option_uid = getQuesOptionUid(survey_ques_uid, labelText)
			If survey_option_uid = "NA" Then
				CloseDBConnection
				Exit Function
			End If
			Set ocrDesc = Description.Create
			ocrDesc("micclass").Value = "WebElement"
			ocrDesc("attribute/data-capella-automation-id").Value = "Fluid Management_PathWay_" & survey_ques_uid & "_" & survey_option_uid
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
				Case 712
					If labelText = "No" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_712_1788_Navigate", "visible:=True")
						If not CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button does NOT exist for question 1 and option 'No'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen button exists for question 1 and option 'No'")
						End If
					ElseIf labelText = "Yes" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_712_1788_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 1 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen button does NOT exist for question 1 and option 'Yes'")
						End If
					ElseIf labelText = "NA" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_712_1788_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 1 and option 'NA'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen button does NOT exist for question 1 and option 'NA'")
						End If
					End If
					
				Case 713
					If labelText = "No" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Request fluid information from dialysis center.", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Request fluid information from dialysis center.' exists for question 2 and option 'No'")
						Else
							Call WriteToLog("Fail", "Info text - 'Request fluid information from dialysis center.' does NOT exist for question 2 and option 'No'")
						End If
						
						Set objInfoText = getPageObject().WebElement("outertext:=Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center", "html tag:=DIV")
						If Not CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center' does NOT exist for question 2 and option 'Unavailable'")
						Else
							Call WriteToLog("Fail", "Info text - 'Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center' exists for question 2 and option 'Unavailable'")
						End If
					ElseIf labelText = "Yes" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Request fluid information from dialysis center.", "html tag:=DIV")
						If Not CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Request fluid information from dialysis center.' does NOT exist for question 2 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Info text - 'Request fluid information from dialysis center.' exists for question 2 and option 'Yes'")
						End If
						
						Set objInfoText = getPageObject().WebElement("outertext:=Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center", "html tag:=DIV")
						If Not CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center' does NOT exist for question 2 and option 'Unavailable'")
						Else
							Call WriteToLog("Fail", "Info text - 'Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center' exists for question 2 and option 'Unavailable'")
						End If
					ElseIf labelText = "Unavailable" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center' exists for question 2 and option 'Unavailable'")
						Else
							Call WriteToLog("Fail", "Info text - 'Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center' does NOT exist for question 2 and option 'Unavailable'")
						End If
						
						Set objInfoText = getPageObject().WebElement("outertext:=Request fluid information from dialysis center.", "html tag:=DIV")
						If Not CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Request fluid information from dialysis center.' does NOT exist for question 2 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Info text - 'Request fluid information from dialysis center.' exists for question 2 and option 'Yes'")
						End If
					ElseIf labelText = "CKD" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Request fluid information from dialysis center.", "html tag:=DIV")
						If Not CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Request fluid information from dialysis center.' does NOT exist for question 2 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Info text - 'Request fluid information from dialysis center.' exists for question 2 and option 'Yes'")
						End If
						
						Set objInfoText = getPageObject().WebElement("outertext:=Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center", "html tag:=DIV")
						If Not CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center' does NOT exist for question 2 and option 'Unavailable'")
						Else
							Call WriteToLog("Fail", "Info text - 'Request Treatment sheets for 3 consecutive treatments within the last 30 days from the Dialysis center' exists for question 2 and option 'Unavailable'")
						End If
					End If
				
				Case 715
					If labelText = "Yes" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Discuss the importance of weighing daily and buying a scale is recommended", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Fail", "Info text - 'Discuss the importance of weighing daily and buying a scale is recommended' exists for question 4 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Info text - 'Discuss the importance of weighing daily and buying a scale is recommended' does NOT exist for question 4 and option 'Yes'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_716_1799_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Medical Equipment screen button exists for question 4 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Navigate to Medical Equipment screen does NOT exist for question 4 and option 'Yes'")
						End If
					ElseIf labelText = "No" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Discuss the importance of weighing daily and buying a scale is recommended", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Discuss the importance of weighing daily and buying a scale is recommended' exists for question 4 and option 'No'")
						Else
							Call WriteToLog("Fail", "Info text - 'Discuss the importance of weighing daily and buying a scale is recommended' does NOT exist for question 4 and option 'No'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_716_1799_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Referral screen button exists for question 5 and option 'No'")
						Else
							Call WriteToLog("Fail", "Navigate to Referral screen does NOT exist for question 5 and option 'No'")
						End If
					End If
				
				Case 719
					If labelText = "Yes" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_719_1806_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Referral screen button exists for question 7 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Navigate to Referral screen does NOT exist for question 7 and option 'Yes'")
						End If
					ElseIf labelText = "No" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_719_1806_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 7 and option 'No'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen does NOT exist for question 7 and option 'No'")
						End If
					ElseIf labelText = "NA" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_719_1806_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 7 and option 'No'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen does NOT exist for question 7 and option 'No'")
						End If
					End If
					
				Case 720
					If labelText = "Yes" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_720_1809_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Referral screen button exists for question 8 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Navigate to Referral screen does NOT exist for question 8 and option 'Yes'")
						End If
					ElseIf labelText = "No" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_720_1809_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 8 and option 'No'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen does NOT exist for question 8 and option 'No'")
						End If
					ElseIf labelText = "NA" Then
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_720_1809_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Referral screen button exists for question 8 and option 'NA'")
						Else
							Call WriteToLog("Pass", "Navigate to Referral screen does NOT exist for question 8 and option 'NA'")
						End If
					End If
					
				Case 721
					If labelText = "Yes" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff' exists for question 9 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Info text - 'Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff' does NOT exist for question 9 and option 'Yes'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_721_1813_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Medical Equipment screen button exists for question 9 and option 'Yes'")
						Else
							Call WriteToLog("Pass", "Navigate to Medical Equipment screen does NOT exist for question 9 and option 'Yes'")
						End If
					ElseIf labelText = "No" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff' exists for question 9 and option 'No'")
						Else
							Call WriteToLog("Fail", "Info text - 'Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff' does NOT exist for question 9 and option 'No'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_721_1813_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Medical Equipment screen button exists for question 9 and option 'No'")
						Else
							Call WriteToLog("Fail", "Navigate to Medical Equipment screen does NOT exist for question 9 and option 'No'")
						End If
					ElseIf labelText = "NA" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Fail", "Info text - 'Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff' exists for question 9 and option 'NA'")
						Else
							Call WriteToLog("Pass", "Info text - 'Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff' does NOT exist for question 9 and option 'NA'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_721_1813_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Medical Equipment screen button exists for question 9 and option 'NA'")
						Else
							Call WriteToLog("Pass", "Navigate to Medical Equipment screen does NOT exist for question 9 and option 'NA'")
						End If
					End If
	
			Case 726
				If labelText = "Yes" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Display existing materials fulfillment screen for user entry", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Pass", "Info text - 'Display existing materials fulfillment screen for user entry' exists for question 14 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Info text - 'Display existing materials fulfillment screen for user entry' does NOT exist for question 14 and option 'Yes'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_726_1827_Navigate")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Pass", "Navigate to Material Fulfillment screen button exists for question 14 and option 'Yes'")
						Else
							Call WriteToLog("Fail", "Navigate to Material Fulfillment screen does NOT exist for question 14 and option 'Yes'")
						End If
					ElseIf labelText = "No" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Display existing materials fulfillment screen for user entry", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Fail", "Info text - 'Display existing materials fulfillment screen for user entry' exists for question 14 and option 'No'")
						Else
							Call WriteToLog("Pass", "Info text - 'Display existing materials fulfillment screen for user entry' does NOT exist for question 14 and option 'No'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_726_1827_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Material Fulfillment screen button exists for question 14 and option 'No'")
						Else
							Call WriteToLog("Pass", "Navigate to Material Fulfillment screen does NOT exist for question 14 and option 'No'")
						End If
					ElseIf labelText = "NA" Then
						Set objInfoText = getPageObject().WebElement("outertext:=Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff", "html tag:=DIV")
						If CheckObjectExistence(objInfoText, 10) Then
							Call WriteToLog("Fail", "Info text - 'Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff' exists for question 14 and option 'NA'")
						Else
							Call WriteToLog("Pass", "Info text - 'Encourage patient to monitor their blood pressure at home and review the results with their healthcare provider and obtain/buy a blood pressure cuff' does NOT exist for question 14 and option 'NA'")
						End If
						
						Set objNavigate = getPageObject().WebElement("attribute/data-capella-automation-id:=Fluid Management_726_1827_Navigate", "visible:=True")
						If CheckObjectExistence(objNavigate, 10) Then
							Call WriteToLog("Fail", "Navigate to Material Fulfillment screen button exists for question 14 and option 'NA'")
						Else
							Call WriteToLog("Pass", "Navigate to Material Fulfillment screen does NOT exist for question 14 and option 'NA'")
						End If
					End If
					
			End Select
			
			k = k + 1
			Err.Clear			
		Next
		
		qnNo = qnNo + 1
		survey_ques_uid = survey_ques_uid + 1
		If uid <> "Null" Then
			If survey_ques_uid < CInt(uid) Then
				survey_ques_uid = CInt(uid)
			End If
		End If
		
		
		Set olabelDesc  = Nothing
		Set objLabel = Nothing
		Set oObj = Nothing
		Set oRDesc = Nothing
		Set oRadio = Nothing
		Set ocrDesc = Nothing
		
		If k = 41 Then
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
