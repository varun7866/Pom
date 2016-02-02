'**************************************************************************************************************************************************************************
' TestCase Name			: PatientCarePlan
' Purpose of TC			: Spell check for Patient Care Plan Note  for new and existing notes
' Author                : Gregory
' Date                  : 08 July 2015
' Date Modified			: 08 October 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04749
'**************************************************************************************************************************************************************************

'--------------
'Initialization
'--------------
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PatientCarePlan", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'------------------------
' Variable initialization
'------------------------
strUser = DataTable.Value("User","CurrentTestCaseData")
lngMemberID = DataTable.Value("PatientMemberID","CurrentTestCaseData")
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strCarePlanTopic = DataTable.Value("CarePlanTopic","CurrentTestCaseData")
strImportanceLevel = DataTable.Value("ImportanceLevel","CurrentTestCaseData")
strConfidenceLevel = DataTable.Value("ConfidenceLevel","CurrentTestCaseData")
strStatusForCPadd = DataTable.Value("StatusForAddingCarePlan","CurrentTestCaseData")
dtStartDate = DataTable.Value("StartDate","CurrentTestCaseData")
dtDueDate = DataTable.Value("DueDate","CurrentTestCaseData")
strClinicalRelevance = DataTable.Value("ClinicalRelevance","CurrentTestCaseData")
strReqdCarePlanName = DataTable.Value("CarePlanName","CurrentTestCaseData")
strReqdBehavioralPlan = DataTable.Value("BehavioralPlanText","CurrentTestCaseData")
strEngagementPlan = DataTable.Value("EngagementPalnText","CurrentTestCaseData")
strSelfManagement = DataTable.Value("SelfManagementValue","CurrentTestCaseData")
strPatientCarePlanExisting = DataTable.Value("PatientCarePlanExisting","CurrentTestCaseData") 
strBehavioralPlanText = DataTable.Value("BehavioralPlanText","CurrentTestCaseData")
strImportanceLevelEdited = DataTable.Value("ImportanceLevelEdited","CurrentTestCaseData")
strConfidenceLevelEdited = DataTable.Value("ConfidenceLevelEdited","CurrentTestCaseData")
strDueDateEdited = DataTable.Value("DueDateEdited","CurrentTestCaseData")
strBehavioralPlanTextEdited = DataTable.Value("BehavioralPlanTextEdited","CurrentTestCaseData")
strEngagementPalnTextEdited = DataTable.Value("EngagementPalnTextEdited","CurrentTestCaseData")

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
Execute "Set objAddCPbtn ="&Environment("WEL_PatCaPlnAdd") 'Add CarePlan button
Execute "Set objCaPlnTpc ="&Environment("WB_PatCaPlnTopic") 'CarePlanTopic dropdown
Execute "Set objPatitentCarePlanDueDateEditbox ="&Environment("WL_PatitentCarePlanDueDateEditbox") 'Due Date webedit
Execute "Set objStatus ="&Environment("WB_PatCaPlnStatus") 'Status dropdown
Execute "Set objCliRelvn ="&Environment("WB_PatCaPlnClinicalRelvnDD") 'ClinicalRelevance dropdown
Execute "Set objCPname ="&Environment("WE_PatCaPlnName") 'CarePlanName text
Execute "Set objBepln ="&Environment("WE_PatCaPlnBePln") 'BehavioralPlan text	
Execute "Set objSelManTB ="&Environment("WE_PatCaPlnSlfMng") 'SelfManagement text		
Execute "Set objSaveCPbtn ="&Environment("WE_PatCaPlnSave") 'Save carepaln button
Execute "Set objEditCarePlanBtn ="&Environment("WEL_EditCarePlanBtn") 'Edit carepaln button
Execute "Set objEngagementPlan ="&Environment("WE_EngagementPlan") 'Engagement plan text
Execute "Set objPatCaPln = "&Environment("WL_PatCaPlnTab") 'PatientCarePlan tab
Execute "Set objPatientListScrollbar = "&Environment("WEL_PatientListScrollbar") ' PatientList Scrollbar
Execute "Set objMyPatientsMainTab = "&Environment("WL_MyPatientsMainTab") 'My Patients tab
Execute "Set objImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 
Execute "Set objConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 
Set objStartDate = objPage.WebEdit("html tag:=INPUT","name:=WebEdit","outerhtml:=.*StartDate.*","visible:=True")
Set objDueDate = objPage.WebEdit("html tag:=INPUT","name:=WebEdit","class:=form-control ref-ipfix3.*","visible:=True","index:=1")

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
Err.Clear

Call WriteToLog("Info","----------Login to application, Close all open patients, Select user roster----------")
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

'Call WriteToLog("Info","----------------Select required patient from MyPatient List----------------")
''Select patient from MyPatient list
'blnSelectPatientFromPatientList = SelectPatientFromPatientList(strUser, strPatientName)
'If blnSelectPatientFromPatientList Then
'	Call WriteToLog("PASS","Selected required patient from MyPatient list")
'Else
'	strOutErrorDesc = "Unable to select required patient"
'	Call WriteToLog("Fail","Expected Result: Should be able to select required patient from MyPatient list.  Actual Result: "&strOutErrorDesc)
'	Call Terminator
'End If
'Wait 2

Call WriteToLog("Info","----------------Select required patient through Global Search----------------")
blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
If Not blnGlobalSearchUsingMemID Then
	strOutErrorDesc = "Select patient through global search returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", "Expected Result: User should be able to select patient through global search; Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Successfully selected required patient through global search")
Wait 3

Call waitTillLoads("Loading...")
Wait 2

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")
Wait 2

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","CarePlan note spell check for newly added care plan by navigating to Patient Care Paln tab and creating new care paln")
'---------------------------
'Navigate to PatientCarePlan
'---------------------------
'Clk on PatientCarePlan tab
Err.Clear
objPatCaPln.click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click PatientCarePlan tab : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to click PatientCarePlan tab.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Navigated to Patient Care Plan screen")
Wait 2

Call waitTillLoads("Loading Patient Care Plans...")
Wait 2

'--------------------------------------
'Add new carepaln with required details
'--------------------------------------
If objAddCPbtn.Exist(5) Then
'Clk on Add button for creating new Care Plan
blnAddClicked = ClickButton("Add",objAddCPbtn,strOutErrorDesc)
	If not blnAddClicked Then
		strOutErrorDesc = "Unable to click Add care plan button : "&" Error returned: " & Err.Description
		Call WriteToLog("Fail","Expected Result: User should be able to click Add care plan button.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
End If
Call WriteToLog("PASS","Clicked Add button for adding a new care plan")
Wait 2

Call waitTillLoads("Loading...")
Wait 2

'Select required CarePlanTopic from dropdown
blnReturnValue = selectComboBoxItem(objCaPlnTpc, strCarePlanTopic)
If not blnReturnValue Then
	strOutErrorDesc = "Unable to select required topic from CarePlanTopic dropdown : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to select required topic from CarePlanTopic dropdown .  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Selected required topic from CarePlanTopic dropdown ")
Wait 2

Call waitTillLoads("Loading...")
Wait 2

'select Importance level
blnImportance = selectComboBoxItem(objImportanceLevelDD, strImportanceLevel)
If not blnImportance Then
	strOutErrorDesc = "Unable to select required Importance Level from ImportanceLevel dropdown : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to select Importance Level from ImportanceLevel dropdown  .  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Selected required Importance Level from ImportanceLevel dropdown ")
Wait 1

'select confidence level
blnConfidence = selectComboBoxItem(objConfidenceLevelDD, strConfidenceLevel)
If not blnConfidence Then
	strOutErrorDesc = "Unable to select required Confidence Level from ConfidenceLevel dropdown : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to select Confidence Level from ConfidenceLevel dropdown  .  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Selected required Confidence Level from ConfidenceLevel dropdown ")
Wait 1

'clk on Status drop down and select required value
blnReturnValue = selectComboBoxItem(objStatus, strStatusForCPadd)
If not blnReturnValue Then
	strOutErrorDesc = "Unable to select required value of status from CarePlan Status dropdown : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to select required value of status from CarePlan Status dropdown.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Selected required value of status from CarePlan Status dropdown")
Wait 1

'Set start date for care paln
Err.Clear
objStartDate.Set dtStartDate
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set StartDate for care plan "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to set StartDate for careplan.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Set StartDate for Patient care plan")
Wait 1

'Set due date for care paln
Err.Clear
objDueDate.Set dtDueDate
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set duedate for care plan "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to set duedate for careplan.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Set duedate for Patient care plan")
Wait 1

'Select Clinical Relevance from dropdown
blnReturnValue = selectClinicalRelevance(objCliRelvn, strClinicalRelevance)
If not blnReturnValue Then
	strOutErrorDesc = "Unable to select required value for Clinical Relevance from Dropdown: "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to select required value for Clinical Relevance from Dropdown.  Actual Result: "&strOutErrorDesc)
	Call Terminator	
End If
Call WriteToLog("PASS","Selected required clinical relavence from dropdown")
Wait 1

'Set required Care Plan Name
Err.Clear
objCPname.Set strReqdCarePlanName
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set required Care Plan name"&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to to set required Care Plan name.  Actual Result: "&strOutErrorDesc)
	Call Terminator				
End If
Call WriteToLog("PASS","Populated Careplan name textbox with required value")
Wait 1

'Set required Behavioral Plan 
Err.Clear
objBepln.Set strReqdBehavioralPlan
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set required Behavioral Plan "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to set required Behavioral Plan.  Actual Result: "&strOutErrorDesc)
	Call Terminator		
End If
Call WriteToLog("PASS","Populated BehavioralPlan textbox with required value")
Wait 1

'Set required value for Engagement Plan
Err.Clear
objEngagementPlan.Set strEngagementPlan
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set required Enagagement Plan "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to set required Enagagement Plan.  Actual Result: "&strOutErrorDesc)
	Call Terminator			
End If
Call WriteToLog("PASS","Populated EngagementPlan textbox with required value")
Wait 1

'set Barriers
Err.Clear
For BarrierNumber = 0 To 3 Step 1
	Execute "Set objPage = Nothing"
	Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
	Set objBarrierCB = objPage.WebElement("class:=check-no","html tag:=DIV","visible:=True","Index:="&BarrierNumber)
	Err.Clear
	objBarrierCB.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set Barriers "&" Error returned: " & Err.Description
		Call WriteToLog("Fail", "Expected Result: User should be able to set required Barriers for care plan.  Actual Result: "&strOutErrorDesc)
		Call Terminator			
	End If
Next
Call WriteToLog("PASS","Set required Barriers for care plan")
Wait 1

Err.clear
'Select values for ChangeOptionQuestions
For i=1 to 9 Step 4
	Execute "Set objPage = Nothing"
	Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
	Set objChOpQues = objPage.WebElement("html tag:=DIV","outerhtml:=.*ChangeOptionOnQuestion.*","visible:=True","index:="&i)
	Err.Clear
	objChOpQues.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to select ChangeOptionQuestions radio btns: "&" Error returned: " & Err.Description
		Call WriteToLog("Fail", "Expected Result: User should be able to select ChangeOptionQuestions radio btns.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
Next
Call WriteToLog("PASS","Selected change option questions")
Wait 1

'Set required value for SelfManagement 
Err.clear
objSelManTB.Set strSelfManagement
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set required self management value "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to set required self management value.  Actual Result: "&strOutErrorDesc)
	Call Terminator			
End If
Call WriteToLog("PASS","Populated self management textbox with required value")
Wait 1

'Save care plan
Set objSaveCPbtn = Nothing
Execute "Set objSaveCPbtn ="&Environment("WE_PatCaPlnSave") 'Save carepaln button
blnSaveClicked = ClickButton("Save",objSaveCPbtn,strOutErrorDesc)
If not blnSaveClicked Then
	strOutErrorDesc = "Unable to Click Save care plan button "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to Save care plan.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Saved new care paln with with required values")
Wait 2

Call waitTillLoads("Adding Patient Care Plan...")
Call waitTillLoads("Loading...")
Wait 2

'Spell check 
strSpellChk = CarePlanNoteSpellCheck()	
If strSpellChk Then
	Call WriteToLog("PASS","Spell check done successfully")
Else
	strOutErrorDesc = "Spell check unsuccessful"
	Call WriteToLog("Fail", "Expected Result:Should have successful spell check.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Wait 1

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","CarePlan note spell check for existing care plan by navigating to Patient Care Paln tab and editing existing care paln")

Set objMenuOfActionsArrow = Nothing
Execute "Set objPage = Nothing"
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
Set objMenuOfActionsArrow = objPage.Image("class:=a-2 left moa-ribbon-expand-collapse-img","file name:=arrow-right\.png","html tag:=IMG","image type:=Plain Image","visible:=True")
Err.Clear
objMenuOfActionsArrow.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click MenuOfActions Arrow : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to click MenuOfActions Arrow.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Clicked Menu of Actions arrow button")
Wait 2

'Clk Patient Care Plan tab
Err.Clear
Execute "Set objPatCaPln = Nothing"
Execute "Set objPatCaPln = "&Environment("WL_PatCaPlnTab") 'PatientCarePlan tab
objPatCaPln.click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click PatientCarePlan tab : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to click PatientCarePlan tab.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Navigated to Patient Care Plan screen")
Wait 2

Call waitTillLoads("Loading Patient Care Plans...")
Wait 2

Err.Clear
'Click on Edit button
Set objEditCarePlanBtn = Nothing
Execute "Set objEditCarePlanBtn ="&Environment("WEL_EditCarePlanBtn") 'Edit carepaln button
blnEditClicked = ClickButton("Edit",objEditCarePlanBtn,strOutErrorDesc)
If not blnEditClicked Then
	strOutErrorDesc = "Unable to click Edit care plan button "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to click Edit care plan button.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Clicked Edit care plan button")
Wait 2

Call waitTillLoads("Loading...")
Wait 2

'select Importance level
Execute "Set objImportanceLevelDD = Nothing"
Execute "Set objImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 
blnImportance = selectComboBoxItem(objImportanceLevelDD, strImportanceLevelEdited)
If not blnImportance Then
	strOutErrorDesc = "Unable to select required Importance Level from ImportanceLevel dropdown : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to select Importance Level from ImportanceLevel dropdown  .  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Selected required Importance Level from ImportanceLevel dropdown ")
Wait 1
'
'select confidence level
Execute "Set objConfidenceLevelDD = Nothing"
Execute "Set objConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 
blnConfidence = selectComboBoxItem(objConfidenceLevelDD, strConfidenceLevelEdited)
If not blnConfidence Then
	strOutErrorDesc = "Unable to select required Confidence Level from ConfidenceLevel dropdown : "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to select Confidence Level from ConfidenceLevel dropdown  .  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Selected required Confidence Level from ConfidenceLevel dropdown ")
Wait 1

'Set due date for care paln
Set objDueDate = Nothing
Execute "Set objPage = Nothing"
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
Set objDueDate = objPage.WebEdit("html tag:=INPUT","name:=WebEdit","class:=form-control ref-ipfix3.*","visible:=True","index:=1")
Err.Clear
objDueDate.Set strDueDateEdited
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set duedate for care plan "&" Error returned: " & Err.Description
	Call WriteToLog("Fail","Expected Result: User should be able to set duedate for careplan.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Set duedate for Patient care plan")
Wait 1

'Set required Behavioral Plan 
Set objBepln = Nothing
Execute "Set objBepln ="&Environment("WE_PatCaPlnBePln") 'BehavioralPlan text	
Err.Clear
objBepln.Set strBehavioralPlanTextEdited
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set required Behavioral Plan "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to set required Behavioral Plan.  Actual Result: "&strOutErrorDesc)
	Call Terminator		
End If
Call WriteToLog("PASS","Populated BehavioralPlan textbox with required value")
Wait 1

'Set required value for Engagement Plan
Set objEngagementPlan = Nothing
Execute "Set objEngagementPlan ="&Environment("WE_EngagementPlan") 'Engagement plan text
Err.Clear
objEngagementPlan.Set strEngagementPalnTextEdited
If err.number <> 0 Then
	strOutErrorDesc = "Unable to set required Enagagement Plan "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to set required Enagagement Plan.  Actual Result: "&strOutErrorDesc)
	Call Terminator		
End If
Call WriteToLog("PASS","Populated EngagementPlan textbox with required value")
Wait 1

'set Barriers for editing
For BarrierNumber = 0 To 6 Step 1
	Execute "Set objPage = Nothing"
	Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
	Set objBarrierCB = objPage.WebElement("class:=check-no","html tag:=DIV","visible:=True","Index:="&BarrierNumber)
	err.clear
	objBarrierCB.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set Barriers "&" Error returned: " & Err.Description
		Call WriteToLog("Fail", "Expected Result: User should be able to set required Barriers for edited care plan.  Actual Result: "&strOutErrorDesc)
		Call Terminator			
	End If
	
Next
Call WriteToLog("PASS","Set required Barriers for edited care plan")
Wait 1

Err.clear
'Select values for ChangeOptionQuestions for editing
For i=1 to 9 Step 4
	Execute "Set objPage = Nothing"
	Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
	Set objChOpQues = objPage.WebElement("html tag:=DIV","outerhtml:=.*ChangeOptionOnQuestion.*","visible:=True","index:="&i)
	If instr(1,objChOpQues.GetROPROPERTY("class"),"blueradio",1) Then
		print "already checked"
	Else
		Err.clear
		objChOpQues.Click
	End If	
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to select ChangeOptionQuestions radio btns: "&" Error returned: " & Err.Description
		Call WriteToLog("Fail", "Expected Result: User should be able to select ChangeOptionQuestions radio btns.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
Next
Call WriteToLog("PASS","Selected change option questions for edited care plan")
Wait 1

'Select 'no' option for self management question and set required free form response
Execute "Set objPage = Nothing"
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
Set objSelfMangNo = objPage.WebElement("html tag:=DIV","outerhtml:=.*data-capella-automation-id=""3_No.*","visible:=True","index:=1")
Err.clear
objSelfMangNo.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click 'No' option for Self Management Question "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to click 'No' option for Self Management Question.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Clicked required option for Self Management Question")
Wait 2

For FFrespCB = 0 To 2 Step 1
	Execute "Set objPage = Nothing"
	Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
	Set objFFrespCB = objPage.WebEdit("html tag:=INPUT","name:=WebEdit","outerhtml:=.*FreeFormResponse.*","type:=text","visible:=True","index:="&FFrespCB)
	If objFFrespCB.Exist Then
		objFFrespCB.Set "Response"&FFrespCB
	End If
Next
Call WriteToLog("PASS","Set required response for Self Management Question")

Set objPage = Nothing
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
'set Barriers for edited care plan
For BarrierNumber = 0 To 8 Step 1
	Set objBarrierCB = objPage.WebElement("class:=check-no","html tag:=DIV","visible:=True","Index:="&BarrierNumber)
	err.clear
	objBarrierCB.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set Barriers "&" Error returned: " & Err.Description
		Call WriteToLog("Fail", "Expected Result: User should be able to set required Barriers for edited care plan.  Actual Result: "&strOutErrorDesc)
		Call Terminator		
	End If
Next
Call WriteToLog("PASS","Set required Barriers for care plan")

'Save edited care plan
Set objSaveCPbtn = Nothing
Execute "Set objSaveCPbtn ="&Environment("WE_PatCaPlnSave") 'Save carepaln button
blnSaveClicked = ClickButton("Save",objSaveCPbtn,strOutErrorDesc)
If not blnSaveClicked Then
	strOutErrorDesc = "Unable to Click Save care plan button "&" Error returned: " & Err.Description
	Call WriteToLog("Fail", "Expected Result: User should be able to Save care plan.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("PASS","Saved edited care paln with with required values")
Wait 2

Call waitTillLoads("Saving Patient Care Plan...")
Call waitTillLoads("Loading...")
Wait 2

'Spell check 
strSpellChk = CarePlanNoteSpellCheck()	
If strSpellChk Then
	Call WriteToLog("PASS","Spell check done successfully")
Else
	strOutErrorDesc = "Spell check unsuccessful"
	Call WriteToLog("Fail", "Expected Result:Should have successful spell check.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If

'Logout
Call WriteToLog("Info","------------Logout of application------------")
Call Logout()
Wait 2

'set objects free
Execute "Set objPage = Nothing"
Execute "Set objAddCPbtn = Nothing"
Execute "Set objCaPlnTpc = Nothing"
Execute "Set objPatitentCarePlanDueDateEditbox = Nothing"
Execute "Set objStatus = Nothing"
Execute "Set objCliRelvn = Nothing"
Execute "Set objCPname = Nothing"
Execute "Set objBepln = Nothing"
Execute "Set objSelManTB = Nothing"
Execute "Set objSaveCPbtn = Nothing"
Execute "Set objEditCarePlanBtn = Nothing"
Execute "Set objEngagementPlan = Nothing"
Execute "Set objPatCaPln = Nothing"
Execute "Set objPatientListScrollbar = Nothing"
Execute "Set objMyPatientsMainTab = Nothing"
Execute "Set objImportanceLevelDD = Nothing"
Execute "Set objConfidenceLevelDD = Nothing"
Set objStartDate = Nothing
Set objDueDate = Nothing

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()


Function CarePlanNoteSpellCheck()

	On Error Resume Next
	Err.Clear	
	CarePlanNoteSpellCheck = False
	Set objMenuOfActionsArrow = Nothing
	Set objContactRecapLink = Nothing
			
	Err.Clear
	Execute "Set objPage = Nothing"
	Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
	Set objMenuOfActionsArrow = objPage.Image("class:=a-2 left moa-ribbon-expand-collapse-img","file name:=arrow-right\.png","html tag:=IMG","image type:=Plain Image","visible:=True")
	objMenuOfActionsArrow.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click MenuOfActions Arrow : "&" Error returned: " & Err.Description
			Call WriteToLog("Fail","Expected Result: User should be able to click MenuOfActions Arrow.  Actual Result: "&strOutErrorDesc)
			Call Terminator
		End If
	Call WriteToLog("PASS","Clicked click Menu of Actions arrow button")
	Wait 1
	
	Err.Clear	
	Execute "Set objPage = Nothing"
	Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
	Set objContactRecapLink = objPage.WebElement("class:=col-md-1 padding-top-5px","html tag:=DIV","outerhtml:=.*onExpandClick.*","visible:=True")
	objContactRecapLink.Click
	If err.number <> 0 Then
			strOutErrorDesc = "Unable to click Contact Recap Link : "&" Error returned: " & Err.Description
			Call WriteToLog("Fail","Expected Result: User should be able to click Contact Recap Link.  Actual Result: "&strOutErrorDesc)
			Call Terminator
		End If
	Call WriteToLog("PASS","Clicked Contact Recap Link")
	
	For j=0 To 12 Step 1
		'Create object for EditContact button
		Execute "Set objPage = Nothing"
		Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
		Set objEC = objPage.WebButton("html tag:=BUTTON","name:=Edit Topics ","outerhtml:=.*data-capella-automation-id=""Recap_Edit_Topics.*","innertext:=Edit Topics ","outertext:=Edit Topics ","visible:=True","index:="&j)
		If objEC.Exist(5) Then
			ecb=ecb+1
		Else
			strOutErrorDesc = "Unable to find change contact button: "&" Error returned: " & Err.Description
			Exit For
		End If
	Next
	
	For i = 0 To ecb-1 Step 1
		'Create object for ContactMethod NoteTxtArea
		Execute "Set objPage = Nothing"
		Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
		Set objNote = objPage.WebEdit("height:=300","html tag:=TEXTAREA","name:=WebEdit","outerhtml:=.*recap-textbox.*","type:=textarea","visible:=True","index:="&i)
		'Spell Check the note
		If Instr(1,objNote.GetROProperty("outertext"),"mangement",1) Then
			strOutErrorDesc = "Spelling is incorrect, 'management' is spelled incorrectly as 'mangement' in 'Member Care Plan note'"
			Call WriteToLog("Fail","Expected Result: Should have correctly spelled 'management' in 'Member Care Plan note'.  Actual Result: "&strOutErrorDesc)
			Call Terminator
		End If
	Next
	
	CarePlanNoteSpellCheck = True
	
End Function

Function selectClinicalRelevance(ByVal objComboBox, ByVal itemToClick)
	On Error Resume Next
	Err.Clear	
	selectClinicalRelevance = true
	
	Dim isListItem : isListItem = True
	Set objPageCR = getPageObject()	
	'objComboBox.highlight
	
	Dim objClass
	objClass = objComboBox.getROProperty("micclass")

	objComboBox.Click
			
	wait 1
	Set objDropDown = objPageCR.WebElement("class:=dropdown-menu.*","html tag:=UL","visible:=true")
	Set itemDesc = Description.Create
	itemDesc("micclass").Value = "Link"
	itemDesc("class").Value = ".*ng-binding.*"
	itemDesc("html tag").Value = "A"
	itemDesc("text").Value = ".*" & itemToClick & ".*"
	itemDesc("text").regularexpression = true
	
	Set objItems = ObjDropDown.ChildObjects(itemDesc)
	If objItems.Count = 0 Then
		Set objItems = Nothing
		Set itemDesc = Description.Create
		itemDesc("micclass").Value = "WebElement"
		itemDesc("html tag").Value = "A"
		itemDesc("innertext").Value = ".*" & itemToClick & ".*"
		itemDesc("innertext").regularexpression = true
		
		Set objItems = ObjDropDown.ChildObjects(itemDesc)
		
		isListItem = False
	End If	
	
	if objItems.Count = 0 Then
		Print "No such item exists"
		sendKeys("{ESC}")
		selectComboBoxItem = false
		Set objItems = Nothing
		Set objDropDown = Nothing
		Set objCombo = Nothing
		Set objPageCR = Nothing
		Exit Function
	End If
	Dim clicked : clicked = false
	
	If isListItem Then
		For i = 0 To objItems.Count - 1
			uitext = objItems(i).getROProperty("text")
			If Ucase(trim(uitext)) = Ucase(trim(itemToClick)) Then
				objItems(i).Click
				clicked = true
				Exit For
			End If
		Next
	Else
		For i = 0 To objItems.Count - 1
			uitext = objItems(i).getROProperty("innertext")
			If Ucase(trim(uitext)) = Ucase(trim(itemToClick)) Then
				objItems(i).Click
				clicked = true
				Exit For
			End If
		Next
	End If
	

	If not clicked Then
		Print "Item does not exist to click"
		sendKeys("{ESC}")
		selectClinicalRelevance = false
	End If

	wait 2
	Set objItems = Nothing
	Set objDropDown = Nothing
	Set objCombo = Nothing
	Set objPageCR = Nothing
	
End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function
