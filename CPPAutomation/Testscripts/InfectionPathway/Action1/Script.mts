' TestCase Name			: Infection Pathway
' Purpose of TC			: To perform Infection Pathway
' Author                : Sharmila
' Date					: 03/22/2016
' Comments				: This Script is to verify the functionality of Infection Pathway.
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "InfectionPathway", strOutTestName, strOutErrorDesc) 
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
'#################################################	Start: Test Case Execution	#################################################
'==========================================================================================================
'Login to Capella, verify the successful loading of the dashboard page and verify My Patient Census widget
'==========================================================================================================

Call WriteToLog("Info","==========Testcase - Login to Capella, verify the successful loading of the dashboard page and verify My Patient Census widget==========")

'Login to Capella as VHN
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

'Execute the script for each testdata in the excel sheet
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
		
		'==============================
		'Open patient from global search
		'==============================
		strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
		isPass = selectPatientFromGlobalSearch(strMemberID)
		If Not isPass Then
			Call WriteToLog("Fail", "Failed to perform the global search functionality" )
			Logout
			CloseAllBrowsers
			Call WriteLogFooter()
			ExitAction
		End If
		
		'wait till the member loads
		wait 2
		waitTillLoads "Loading..."
		wait 2
		
		Call WriteToLog("info", "==========Testcase- Infection Pathway for the Member ID:" &strMemberID & "==========")
		
		'===========================================================================================================
		' Call the function InfectionPathway, which does all the validation for the Infection Pathway. 
		'===========================================================================================================
		blnCheckInfectionPathway = InfectionPathway()
		
		If not blnCheckInfectionPathway Then
			
			Call WriteToLog("Fail","Failed to verify Infection Pathway functionalities for the Member ID:"  &strMemberID)
			
			'If anything fails in the Infection pathway comeback to the Patient Snapshot screen and make the script as failed.
			clickOnSubMenu "Patient Snapshot"

			wait 2
			waitTillLoads "Loading..."
			wait 2
			
			isPass = checkForPopup("Infection", "Yes", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
			If not isPass Then
				Call WriteToLog("Fail", "Expected Message box does not appear.")
			End If
		
			wait 2
			waitTillLoads "Loading..."
			wait 2
			
		Else
			Call WriteToLog("Pass","Infection Pathway functionalities were verified successfully")
		End If
	
		'continue the testing for the next member
	End If	
Next

If not isRun Then
	Call WriteToLog("Fail", "There are NO rows marked as Y(Yes) for execution.")
End If


'=================================
'Logout from Capella Application
'=================================
Call Logout()
CloseAllBrowsers

'============================
'Summarize execution status
'============================
Call WriteLogFooter()



'#######################################################################################################################################################################################################
'Function Name		 : InfectionPathway
'Purpose of Function : Purpose of this function is to verify the functionality of the Infection Pathway
'Input Arguments	 : N/A
'Output Arguments	 : N/A
'Example of Call	 : blnReturnValue = InfectionPathway()
'Author				 : Sharmila 
'Date				 : 20-March-2016
'##################################################################################################################################################################################

Function InfectionPathway()
	On Error Resume Next
	Err.Clear
	
	InfectionPathway = false
	
	'============================
	' Variable initialization
	'============================
	strLabelNames =  Datatable.Value("LabelNames","CurrentTestCaseData") 'Label Names
	strFrequencyText = Datatable.Value("FrequencyText","CurrentTestCaseData")  'Frequency to complete pathway Text
	strPathwayFocusText = Datatable.Value("PathwayFocusText","CurrentTestCaseData") 'Pathway Focus Text
	strCareScriptText = Datatable.Value("CareScriptText","CurrentTestCaseData") 'Care Script Text 
	strSurveyType = Datatable.Value("SurveyType","CurrentTestCaseData")
	
	'=====================================
	'Objects required for test execution
	'=====================================
	
	Execute "Set objInfectionPathwayTitle = " & Environment.Value("WEL_InfectionPathway_Title") 'object for Infection Pathway title
	Execute "Set objPathwayTab = " & Environment.Value("WEL_InfectionPathway_PathwayTab") 	'object for Pathway tab
	Execute "Set objMaterialsTab = " & Environment.Value("WEL_InfectionPathway_MaterialsTab") 'object for Materials tab
	Execute "Set objReferralsTab = " & Environment.Value("WEL_InfectionPathway_ReferralsTab")	 'object for Referrals tab
	Execute "Set objFreqCompPathway = " & Environment("WE_InfectionPathway_FrequencyLabel")		'object for label frequency to complete pathway
	Execute "Set objFrequencyText = " & Environment("WE_InfectionPathway_FrequencyText")		'object for text frequency to complete pathway
	Execute "Set objPathwayFocus = " & Environment("WE_InfectionPathway_PathwayFocusLabel")		'object for label Pathway Focus
	Execute "Set objPathwayFocusText = " & Environment("WE_InfectionPathway_PathwayFocusText")	'object for text Pathway Focus
	Execute "Set objCareScriptLabel = " & Environment("WE_InfectionPathway_CareScriptLabel")	'object for Lable Care Script
	Execute "Set objCareScriptText = " & Environment("WE_InfectionPathway_CareScriptText")		'object for text Care Script
	Execute "Set objAddbtn = " & Environment("WE_InfectionPathway_Add")		'Object for Inffection Pathway Add button
	Execute "Set objPostponebtn = " & Environment("WE_InfectionPathway_Postpone")		'Object for Inffection Pathway Postpone button
	Execute "Set objSavebtn = " & Environment("WE_InfectionPathway_Save")		'Object for Inffection Pathway Save button
	Execute "Set objCancelbtn = " & Environment("WE_InfectionPathway_Cancel")		'Object for Inffection Pathway Cancel button
	Execute "Set objHistorybtn = " & Environment("WE_InfectionPathway_History")		'Object for Inffection Pathway History button
	Execute "Set objComments = " & Environment("WE_InfectionPathway_SurveyComments")
	Execute "Set objPatientICRReportChkBox = " & Environment("WE_InfectionPathway_PatientICRChkbox")
	Execute "Set objProviderICRReportChkBox = " & Environment("WE_InfectionPathway_ProviderICRChkbox")
	Execute "Set objacpDate = " & Environment("WE_InfectionPathway_ACPDate")
	Execute "Set objPathwayReportWindow = " & Environment("WE_InfectionPathway_Report")
	




	'============================================================
	'Select Infection Pathway from the Clinical management menu
	'============================================================
	Call clickOnSubMenu("Clinical Management->Infection")
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'============================================================
	'Validate all the tabs in Infection Pathway
	'============================================================
	Call WriteToLog("info", "==========Testcase - Validate all the tabs in Infection Pathway==========")
	
	'validate if Infection Pathway screen launched
	If not objInfectionPathwayTitle.Exist(3) Then
		Call WriteToLog("Fail", "Expected Result: User navigated to Infection Pathway Screen;Actual Result: Failed to navigate to  screen.")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Successfully navigated to Infection Pathway screen.")
	
	
	'verify if Pathway, Materials and Referrals tabs exists
	
	
	If Not objMaterialsTab.Exist(3) Then
		Call WriteToLog("Fail", "Expected Reult: Materials tab exists; Actual Result:Materials tab does not exist.")
	Else
		Call WriteToLog("Pass", "Materials tab exists.")
	End If
	
	If Not objReferralsTab.Exist(3) Then
		Call WriteToLog("Fail", "Expected Result: Referrals tab exists; Actual Result:Referrals tab does not exist.")
	Else
		Call WriteToLog("Pass", "Referrals tab exists.")
	End If
'	

	
	
	'================================================================
	'Validate all the labels and text in Infection Pathway screen
	'================================================================
	Call WriteToLog("info", "==========Testcase - Validate all the labels and text in Infection Pathway screen==========")
	
	labels = Split(strLabelNames, ";")
	For i = LBound(labels) To UBound(labels)
		Set objLabel = getPageObject().WebElement("attribute/data-capella-automation-id:=.*label-staticData.LabelText.*", "html tag:=SPAN", "innerhtml:=" & labels(i) & "")
		If Not objLabel.Exist(1) Then
			Call WriteToLog("Fail", labels(i) & " - label does not exist")
		Else
			Call WriteToLog("Pass", labels(i) & " - label exist")
		End If
	Next
	
	'Verify the remaining labels and text
	'Validate Frequency Label and Text	
	objFreqCompPathway.highlight
	If not objFreqCompPathway.Exist(3) then
		Call WriteToLog("Fail", "Frequency to complete pathway label does not exist")
	Else
		Call WriteToLog("Pass", "Frequency to complete pathway label  exists")
	End if
	
	objFrequencyText.highlight
	If not objFrequencyText.Exist(3) then
		Call WriteToLog("Fail", "Frequency to complete pathway text does not exist")
	Else
		Call WriteToLog("Pass", "Frequency to complete pathway text exists")
		'Compare the text
		'strFrequencyText = Replace(strFrequencyText, chr(34), "")
		strActualPathwayText = objFrequencyText.GetROProperty("innertext")
		If (strcomp(Trim(strFrequencyText), Trim(strActualPathwayText),1)) = 0 Then
			Call WriteToLog("Pass", "Frequency to complete pathway text matches with the test data")
		Else
			Call WriteToLog("Fail", "Frequency to complete pathway text doesnot match.")
		End If
	End if
	
	
    'Validate Pathway Focus Label and Text
	objPathwayFocus.highlight
	If not objPathwayFocus.Exist(3) then
		Call WriteToLog("Fail", "Pathway Focus label does not exist")
	Else
		Call WriteToLog("Pass", "Pathway Focus label  exists")
	End if
	
	objPathwayFocusText.highlight 
	if not objPathwayFocusText.Exist(3) then
		Call WriteToLog("Fail", "Pathway Focus text does not exist")
	Else
		Call WriteToLog("Pass", "Pathway Focus text exists")
		'Compare the text
		'strFrequencyText = Replace(strFrequencyText, chr(34), "")
		strActualFocusText = objPathwayFocusText.GetROProperty("innertext")
		If (strcomp(Trim(strPathwayFocusText), Trim(strActualFocusText),1)) = 0 Then
			Call WriteToLog("Pass", "Pathway Focus text matches with the test data")
		Else
			Call WriteToLog("Fail", "Frequency to complete pathway text doesnot match.")
		End If
	End if
	
	
	'Validate Care Script Label and Text
	objCareScriptLabel.highlight
	If not objCareScriptLabel.Exist(3) then
		Call WriteToLog("Fail", "Care Script label does not exist")
	Else
		Call WriteToLog("Pass", "Care Script label  exists")
	End if
	
	if not objCareScriptText.Exist(3) then
		Call WriteToLog("Fail", "Care Script statement does not exist")
	Else
		Call WriteToLog("Pass", "Care Script statement exists")
		'Compare the text
		'strFrequencyText = Replace(strFrequencyText, chr(34), "")
		strActualCareText = objCareScriptText.GetROProperty("innertext")
		If (strcomp(Trim(strCareScriptText), Trim(strActualCareText),1)) = 0 Then
			Call WriteToLog("Pass", "Frequency to complete pathway text exists")
		Else
			Call WriteToLog("Fail", "Frequency to complete pathway text doesnot match.")
		End If
	End if
	
		
	'==========================================================================================================================
	'Check if the patient is doing a new pathway or Adding a new pathway or completing the previous pathway.
	'==========================================================================================================================

	Call WriteToLog("Info","==========Testcase - 'Check if the patient is doing a new pathway or Adding a new pathway or completing the previous pathway. ==========")
	
	'Validating status of Add, Postpone and Save buttons in 'Esco Fall Risk Assessment' screen
	If not objAddbtn.Object.isDisabled Then 'New Screening by clicking Add
		If objPostponebtn.Object.isDisabled AND objSavebtn.Object.isDisabled Then
			Call WriteToLog ("Pass", "Add btn is enabled and Postpone, Save buttons are disabled - Option for adding fresh screening")
			blnFRA_Add = ClickButton("Add",objAddbtn,strOutErrorDesc)
			If not blnFRA_Add Then
				Call WriteToLog("Fail", "Expected Result: Clicked on the Add button; Actual Result: Unable to click the Add button for Infection Pathway")
				Exit Function
			End If
			Call WriteToLog("Pass", "Clicked on the Add button for Infection Pathway")
		 	Wait 2
		 	
			Call waitTillLoads("Loading...")
			Wait 1
		End If
	ElseIf objAddbtn.Object.isDisabled Then 'Screening existing - continue or new screening
		If not objEFRA_Postpone.Object.isDisabled AND objEFRA_Save.Object.isDisabled Then
			Call WriteToLog("Pass", "Add and Save buttons are disabled. Postpone button is enabled - Option for going forward with existing pathway either new or the postponed one.")
		End If
	Else 
		strOutErrorDesc = "Infection Pathway buttons are not available as expected"
		Exit Function
	End If
	
	
	'=======================================================================
	'Validate the questions - by default first 2 questions should appear
	'=======================================================================	
	
	Call WriteToLog("info", "==========Testcase - Validate by default first 2 questions are displayed==========")


	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("attribute/data-capella-automation-id").Value = "label-q.Text"
	oDesc("html tag").Value = "SPAN"
	
	Set objQ = getPageObject().ChildObjects(oDesc)
	
	If objQ.Count = 2 Then
		Call WriteToLog("Pass", "Default 2 questions are displayed")
	Else
		Call WriteToLog("Fail", "Only " & objQ.Count & " no. of questions exists. Expected is 2.")
	End If

	'==================================================================================	
	' Validate text in the default first two questions in the Infection Pathway.
	'==================================================================================	

	Call WriteToLog("info", "==========Testcase - Validate text in the default first two questions in the Infection Pathway.==========")

	Dim dbConnected : dbConnected = true
	isPass = ConnectDB()
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
		Call CloseDBConnection()
		dbConnected = false
	End If
	If dbConnected Then
		
		'Get the Active Survey UID
		survey_uid = getActiveSurveyUid(strSurveyType)
		
		If Not isNull(survey_uid)  Then
			Call WriteToLog("Pass","Active Survey UID is taken from the database")
			Set objQuestions = GetChildObject("micclass;attribute/data-capella-automation-id;html tag","WebElement;label-q.Text;SPAN")
			'Verify the 
			For i  = 0 To objQuestions.Count-1 Step 1
				uiQuestion = Trim(objQuestions(i).GetROProperty("innertext"))
				
				dbQuestion = getSurveyQuestionText(survey_uid, i + 1)
				
				If trim(dbQuestion) = trim(uiQuestion) Then
					Call WriteToLog("Pass","Question no. " & i + 1 & " of Infection Pathway exists and is - " & uiQuestion)
				Else
					Call WriteToLog("Fail","Question no. " & i + 1 & " of Infection Pathway is not as required - " & uiQuestion & ". Required Question - " & dbQuestion)
				End If		
				
			Next
		Else
			Call WriteToLog("Fail","Unable to read the Active Survey from the database.")			
		End If
	Else
		For i  = 0 To objQuestions.Count-1
			uiQuestion = Trim(objQuestions(i).GetROProperty("innertext"))
			
			If uiQuestion <> "" Then
				Call WriteToLog("Pass","Question no. " & i + 1 & " of Infection Pathway exists and is - " & uiQuestion)
			Else
				Call WriteToLog("Fail","Question no. " & i + 1 & " of Infection Pathway is not as required - " & uiQuestion)
			End If		
		Next
	End If
	
	Call CloseDBConnection()
  
    'If the Question Count is 0, then exit the function.
   	If objQuestions.Count = 0 Then
		Call WriteToLog("Fail","No question present on the screening page")
		Exit Function
	End If
	
	'==================================================================================
	'Validate the skipt to logic for all the questions in the infection Pathway.
	'==================================================================================	
	Call WriteToLog("info", "==========Testcase - Validate the skipt to logic for all the questions in the infection Pathway.==========")
	
'	isPass = validateSkipToLogic(strSurveyType)
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to validate all the questions.")
'		Exit Function
'	End If
	
	
	'*************************************************************
	isPass = VerifyUserSpecificAnswers(strSurveyType)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to validate all the questions.")
		Exit Function
	End If
	'*****************************************************************



	Call WriteToLog("Pass", "Successfully validated all the questions.")

	'=======================================================================
	'Verify the Comments box exists and enter a value for the comment box
	'=======================================================================	
	Call WriteToLog("info", "==========Testcase - Verify the Comments box exists and enter a value for the comment box. ==========")
	
	If CheckObjectExistence(objComments, 10) Then
		Call WriteToLog("Pass", "Comments box exists.")
		objComments.Set "Testing"
	Else
		Call WriteToLog("Fail", "Comments box does not exist")
	End If
	wait 2
	
	'=======================================================================
	'Verify the Patient ICR Report Checkbox exists and enter a value
	'=======================================================================	
	Call WriteToLog("info", "==========Testcase - Verify the Patient ICR Report Checkbox exists and enter a value ==========")
	
	If CheckObjectExistence(objPatientICRReportChkBox, 10) Then
		Call WriteToLog("Pass", "'Include on Patient ICR Report' check box exists.")
		objPatientICRReportChkBox.Click
	Else
		Call WriteToLog("Fail", "'Include on Patient ICR Report' check box does not exist")
	End If

	'=======================================================================
	'Verify the Provider ICR Report Checkbox exists and enter a value
	'=======================================================================	
	Call WriteToLog("info", "==========Testcase - Verify the Provider ICR Report Checkbox exists and enter a value ==========")
	
	If CheckObjectExistence(objProviderICRReportChkBox, 10) Then
		Call WriteToLog("Pass", "'Include on Provider ICR Report' check box exists.")
		objProviderICRReportChkBox.click
	Else
		Call WriteToLog("Fail", "'Include on Provider ICR Report' check box does not exist")
	End If

	'==============================================
	'Complete the Pathway and Save the Responses
	'==============================================	
	Call WriteToLog("info", "==========Testcase - Complete the Pathway and Save the Responses ==========")

	'save
	'Execute "Set objSavebtn = " & Environment("WE_FluidPathway_Save")
	objSavebtn.Click
	
	wait 2
	waitTillLoads "Saving..."
	wait 2
	
	'==============================================================
	'Verify the Pathway completed date is updated in the labels
	'==============================================================
	Call WriteToLog("info", "==========Testcase - Verify the Pathway completed date is updated in the labels ==========")
	
	acpDate = objacpDate.getROPRoperty("innertext")
	If CDate(acpDate) = date Then
		Call WriteToLog("Pass", "Pathway completed date is saved as required.")
	Else
		Call WriteToLog("Fail", "Pathway completed date is NOT saved as required.")
	End If
	
	'==============================================================================
	'Verify the Pathway report window is opened when clicking on History button
	'==============================================================================
	Call WriteToLog("info", "==========Testcase - Verify the Pathway report window is opened when clicking on History button ==========")

	
	If CheckObjectExistence(objHistoryBtn, 10) Then
		Call WriteToLog("Pass", "History button is enabled")
	Else
		Call WriteToLog("Fail", "History button is disabled")
	End If
	objHistoryBtn.Click
	wait 5
	
	If CheckObjectExistence(objPathwayReportWindow, 10) Then
		Call WriteToLog("Pass", "Pathway report window exists on clicking History button.")
	Else
		Call WriteToLog("Fail", "Pathway report window does NOT exist on clicking History button.")
		Exit Function
	End If
	objPathwayReportWindow.highlight
	objPathwayReportWindow.WebElement("class:=.*glyphicon-remove.*", "html tag:=SPAN").Click
		
	InfectionPathway = true

End Function

'##################################################################################################################################################################################
'Function Name		 : getQuesNo
'Purpose of Function : This function is used to retrieve the Order of the question from the Question_UID
'Input Arguments	 : Survey Question UID
'Output Arguments	 : returns Question Order Number
'##################################################################################################################################################################################

Function getQuesNo(ByVal survey_ques_uid)
	On Error Resume Next
	Err.Clear

	getQuesNo = "NA"
	
	strSQLQuery = "select survey_ques_order from survey_questions where survey_ques_uid = '" & survey_ques_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		quesNo = objDBRecordSet("survey_ques_order")
		objDBRecordSet.MoveNext
	Wend
	
	getQuesNo = quesNo
End Function

'##################################################################################################################################################################################
'Function Name		 : isEndOfSurvey
'Purpose of Function : This function is used to Verify if its is last question and if it the End of the Survey
'Input Arguments	 : Survey Question Option UID, Survey Question Order
'Output Arguments	 : returns Yes or No
'##################################################################################################################################################################################

Function isEndOfSurvey(ByVal survey_ques_opt_ques_uid, ByVal survey_ques_opt_order)
	On Error Resume Next
	Err.Clear

	isEndOfSurvey = "NA"
	
	strSQLQuery = "select survey_ques_opt_eos_yn from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "' and survey_ques_opt_order = '" & survey_ques_opt_order & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		yn = objDBRecordSet("survey_ques_opt_eos_yn")
		objDBRecordSet.MoveNext
	Wend
	
	isEndOfSurvey = yn
End Function

'##################################################################################################################################################################################
'Function Name		 : validateSkipToLogic
'Purpose of Function : This function is used to Validate all the skip to logic for the answers specified.
'Input Arguments	 : Survey Type
'Output Arguments	 : returns boolean
'##################################################################################################################################################################################
Function validateSkipToLogic(ByVal survey_type)

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
	Dim survey_ques_uid
'	survey_ques_uid = getMinQuestionUid(survey_type)
	Dim survey_option_uid
	Dim labelText
	Dim survey_uid
	survey_uid = getActiveSurveyUid(survey_type)
	Do while endOfLoop = false
		
		survey_ques_uid = getSurveyQuesUid(survey_uid, qnNo)
		
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
			ocrDesc("attribute/data-capella-automation-id").Value = "Infection_PathWay_" & survey_ques_uid & "_" & survey_option_uid
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
					Print "Pass" & "SkipToLogic for question " & qnNo & " option " & labelText & " is correct"
				Else
					Call WriteToLog("Fail", "SkipToLogic for question " & qnNo & " option " & labelText & " is wrong")
					Print "Fail" & "SkipToLogic for question " & qnNo & " option " & labelText & " is wrong"
				End If
			End If
			
			k = k + 1
			Err.Clear			
		Next
		
		qnNo = qnNo + 1
'		survey_ques_uid = survey_ques_uid + 1
		If uid <> "Null" Then
'			If survey_ques_uid < CInt(uid) Then
'				survey_ques_uid = CInt(uid)
'			End If
			qnNo = CInt(getQuesNo(uid))
		End If
		
		Set olabelDesc  = Nothing
		Set objLabel = Nothing
		Set oObj = Nothing
		Set oRDesc = Nothing
		Set oRadio = Nothing
		Set ocrDesc = Nothing
		yn = isEndOfSurvey(survey_ques_uid, count)
		If uCase(yn) = "Y" Then
			endOfLoop = true
		End If
	Loop 
	
'	CloseDBConnection
	validateSkipToLogic = true
End Function

'##################################################################################################################################################################################
'Function Name		 : getSurveyQuestionText
'Purpose of Function : This function is get the text of the Survey Question
'Input Arguments	 : Survey Question UID, Survey Question Order
'Output Arguments	 : returns QuestionText
'##################################################################################################################################################################################
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

'##################################################################################################################################################################################
'Function Name		 : getSkipToQuestion
'Purpose of Function : This function is get the next skip to Question for the Specfic option chosen 
'Input Arguments	 : Survey Question UID, Survey Question Option UID
'Output Arguments	 : returns next (SKIP) Question UID
'##################################################################################################################################################################################
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


'##################################################################################################################################################################################
'Function Name		 : getOptionCount
'Purpose of Function : This function is get the number of Option for each question
'Input Arguments	 : Survey Question Option UID
'Output Arguments	 : returns Option Count
'##################################################################################################################################################################################
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

'##################################################################################################################################################################################
'Function Name		 : getQuesOptionUid
'Purpose of Function : This function is get the Option UID for the corresponding Question and Text
'Input Arguments	 : Survey Question UID, Option text
'Output Arguments	 : returns Option UID
'##################################################################################################################################################################################
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



'##################################################################################################################################################################################
'Function Name		 : getSurveySkipToQuestionText
'Purpose of Function : This function is get the text of the Question for the corresponding Question UID
'Input Arguments	 : Survey Question UID
'Output Arguments	 : returns Question Text
'##################################################################################################################################################################################
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

'##################################################################################################################################################################################
'Function Name		 : getActiveSurveyUid
'Purpose of Function : This function is get Active Survey UID
'Input Arguments	 : Survey Type
'Output Arguments	 : returns Survey UID
'##################################################################################################################################################################################
Function getActiveSurveyUid(ByVal surveyType)
	On Error Resume Next
	Err.Clear
	
	getActiveSurveyUid = "NA"
	
	strSQLQuery = "select m.survey_uid from survey_master m inner join survey_type t on m.survey_type_uid = t.survey_type_uid where t.survey_type = '" & surveyType & "' and (m.survey_start_date <= to_date(current_date) and m.survey_end_date >= to_date(current_date))"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	
	while not objDBRecordSet.EOF
		surveyUid = objDBRecordSet("survey_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getActiveSurveyUid = surveyUid
End Function

'##################################################################################################################################################################################
'Function Name		 : getMinQuestionUid
'Purpose of Function : This function is get Minimum Question UID
'Input Arguments	 : Survey Type
'Output Arguments	 : returns Question UID
'##################################################################################################################################################################################
Function getMinQuestionUid(ByVal surveyType)
	On Error Resume Next
	Err.Clear
	
	getMinQuestionUid = "NA"
	
	survey_ques_survey_uid = getActiveSurveyUid(surveyType)
	If survey_ques_survey_uid = "NA" Then
		Call WriteToLog("Fail", "Unable to get the Minimum Survey Question from the database.")
		Exit Function
	End If
	
	strSQLQuery = "select min(survey_ques_uid) as survey_ques_uid from capella.survey_questions where survey_ques_survey_uid = '" & survey_ques_survey_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Call WriteToLog("Fail", "Unable to get the Minimum Survey Question from the database.Error reading from database")
		Exit Function
	End If
	while not objDBRecordSet.EOF
		surveyQuesUid = objDBRecordSet("survey_ques_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getMinQuestionUid = surveyQuesUid
End Function

'##################################################################################################################################################################################
'Function Name		 : getMaxQuestionUid
'Purpose of Function : This function is get Maximum Question UID
'Input Arguments	 : Survey Type
'Output Arguments	 : returns Question UID
'##################################################################################################################################################################################
Function getMaxQuestionUid(ByVal surveyType)
	On Error Resume Next
	Err.Clear
	
	getMaxQuestionUid = "NA"
	
	survey_ques_survey_uid = getActiveSurveyUid(surveyType)
	If survey_ques_survey_uid = "NA" Then
		Exit Function
	End If
	
	strSQLQuery = "select max(survey_ques_uid) as survey_ques_uid from capella.survey_questions where survey_ques_survey_uid = '" & survey_ques_survey_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		surveyQuesUid = objDBRecordSet("survey_ques_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getMaxQuestionUid = surveyQuesUid
End Function

'##################################################################################################################################################################################
'Function Name		 : getSurveyQuesUid
'Purpose of Function : This function is get corresponding Question UID for the selected Survey and  Question Order
'Input Arguments	 : Survey UID, Question Order
'Output Arguments	 : returns Question UID
'##################################################################################################################################################################################
Function getSurveyQuesUid(ByVal survey_ques_survey_uid, ByVal survey_ques_order)
	On Error Resume Next
	Err.Clear

	getSurveyQuesUid = "NA"
	
	strSQLQuery = "select survey_ques_uid from capella.survey_questions where survey_ques_survey_uid = '" & survey_ques_survey_uid & "' and survey_ques_order = '" & survey_ques_order & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		surveyQuesUid = objDBRecordSet("survey_ques_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getSurveyQuesUid = surveyQuesUid
End Function


'##################################################################################################################################################################################
'Function Name		 : VerifyUserSpecificAnswers
'Purpose of Function : This function is get to read the answers for the Survey from Test data and select those answers in the Survey
'Input Arguments	 : Survey type
'Output Arguments	 : returns boolean
'##################################################################################################################################################################################

Function VerifyUserSpecificAnswers(ByVal survey_type)

	VerifyUserSpecificAnswers = false
	
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
	Dim survey_ques_uid
'	survey_ques_uid = getMinQuestionUid(survey_type)
	Dim survey_option_uid
	Dim labelText
	Dim survey_uid
	survey_uid = getActiveSurveyUid(survey_type)
	Dim DisplayQuestion : DisplayQuestion = 1
		
	Do while endOfLoop = false
		
		survey_ques_uid = getSurveyQuesUid(survey_uid, qnNo)
		
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
		
		'Get the option to be selected from the test data for each question
		strOptionRequired =  Datatable.Value("Question"&DisplayQuestion,"CurrentTestCaseData") 

	
		
		For i = 1 To Cint(count)
			Print qnNo
			labelText = oObj(k).GetROProperty("innertext")
			Print labelText
			If INSTR(trim(labelText),Trim(strOptionRequired))>0 Then
				survey_option_uid = getQuesOptionUid(survey_ques_uid, labelText)
				If survey_option_uid = "NA" Then
					CloseDBConnection
					Exit Function
				End If
				Set ocrDesc = Description.Create
				ocrDesc("micclass").Value = "WebElement"
				ocrDesc("attribute/data-capella-automation-id").Value = "Infection_PathWay_" & survey_ques_uid & "_" & survey_option_uid
				Set oRadio = getPageobject().ChildObjects(ocrDesc)
				If oRadio.Count = 1 Then
					oRadio(0).Click
					wait 2
					waitTillLoads "Loading..."
					wait 2
				Else
					Set oDesc = Description.Create
					oDesc("micclass").Value = "WebElement"
					oDesc("attribute/data-capella-automation-id").Value = "Infection_" & survey_ques_uid & "_" & survey_option_uid
					Set oCheckbox = getPageobject().ChildObjects(oDesc)
					If oCheckbox.Count = 1 Then
						oCheckbox(0).Click
						wait 2
						waitTillLoads "Loading..."
						wait 2
					End if 
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
					objQuestions(DisplayQuestion).highlight
					uiQuestion = Trim(objQuestions(DisplayQuestion).GetROProperty("innertext"))
					
					If trim(uiQuestion) = quesText Then
						Call WriteToLog("Pass", "SkipToLogic for question " & qnNo & " option " & labelText & " is correct")
						Print "Pass" & "SkipToLogic for question " & qnNo & " option " & labelText & " is correct"
					Else
						Call WriteToLog("Fail", "SkipToLogic for question " & qnNo & " option " & labelText & " is wrong")
						Print "Fail" & "SkipToLogic for question " & qnNo & " option " & labelText & " is wrong"
					End If
				End If
			 End If
			k = k + 1
			Err.Clear			
		Next
		
		qnNo = qnNo + 1
'		survey_ques_uid = survey_ques_uid + 1
		If uid <> "Null" Then
'			If survey_ques_uid < CInt(uid) Then
'				survey_ques_uid = CInt(uid)
'			End If
			qnNo = CInt(getQuesNo(uid))
		End If
		DisplayQuestion = DisplayQuestion+1
		
		Set olabelDesc  = Nothing
		Set objLabel = Nothing
		Set oObj = Nothing
		Set oRDesc = Nothing
		Set oRadio = Nothing
		Set ocrDesc = Nothing
		yn = isEndOfSurvey(survey_ques_uid, count)
		If uCase(yn) = "Y" Then
			endOfLoop = true
		End If
	Loop 
	
'	CloseDBConnection
	VerifyUserSpecificAnswers = true
End Function




