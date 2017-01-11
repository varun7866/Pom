' TestCase Name			: Snippets
' Purpose of TC			: To validate the new snippet feature
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Snippets", strOutTestName, strOutErrorDesc) 
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
'start test execution
'=====================================
Call WriteToLog("info", "Test case - Create a new patient using VHN role")
'Login to Capella as VHN
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	Logout
	CloseAllBrowsers
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
		
		Call WriteToLog("info", "Test Case - Validate Snippets for the member id - " & strMemberID)
		
		isPass = validateSnippets()
		If Not isPass Then
			Call WriteToLog("Fail", "Validate Snippets failed for the member - " & strMemberID )
		Else
			Call WriteToLog("Pass", "Validate Snippets succesfully completed for the member - " & strMemberID )
		End If
	End If	
Next

If not isRun Then
	Call WriteToLog("info", "There are No rows marked Y(Yes) for execution.")
End If

Logout
CloseAllBrowsers
WriteLogFooter

Function validateSnippets()
	On Error Resume Next
	Err.Clear
	
	validateSnippets = false
	
	'navigate to Recap screen
	Set objPatientPanel = getPageObject().WebElement("class:=.*patient-name.*", "index:=0")
	objPatientPanel.WebElement("html tag:=DIV", "index:=0").click
	
	wait 2
	waitTillLoads "Loading..."
	wait 1
	
	Set obj = getPageObject().WebElement("class:=.*patient-name.*", "index:=1")
	obj.WebElement("html tag:=SPAN", "index:=0").Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 1
	
	Execute "Set objMySnippets = " & Environment("WEL_Snippet_MySnippets")
	If not CheckObjectExistence(objMySnippets, 5) Then
		Call WriteToLog("Fail", "My Snippets does not exist")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "My Snippets exist")
	
	Call WriteToLog("info", "Test Case - Validate Edit and Create Snippet buttons")	
	'validate existance of Edit and Create Snippet buttons
	Execute "Set objEditBtn = " & Environment("WB_Snippet_EditButton")
	If not CheckObjectExistence(objEditBtn, 5) Then
		Call WriteToLog("Fail", "Edit Button does not exist")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Edit Button exist")
	
	Execute "Set objCreateSnippetBtn = " & Environment("WB_Snippet_CreateSnippetButton")
	If not CheckObjectExistence(objCreateSnippetBtn, 5) Then
		Call WriteToLog("Fail", "Create Snippet Button does not exist")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Create Snippet Button exist")
	
	Call WriteToLog("info", "Test Case - Validate Delete Snippet functionality")	
	
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("html id").Value = "Recap_Snippet_SnippetText_Draggable"
	
	Set objSnippetDrag = getPageObject().ChildObjects(oDesc)
	
	'delete all existing snippets
	objEditBtn.Click
	wait 2
	
	for i = 0 to objSnippetDrag.Count - 1
		Set delDesc = Description.Create
		delDesc("micclass").Value = "WebElement"
		delDesc("html id").Value = "Recap_Snippet_DeleteSnippet_Span"
		
		Set objDelete = getPageObject().ChildObjects(delDesc)
		
		intX = objDelete(0).GetROProperty("abs_x") + objDelete(0).GetROProperty("width")/2
		intY = objDelete(0).GetROProperty("abs_y") + objDelete(0).GetROProperty("height")/2
			
		Set ObjectName = CreateObject("Mercury.DeviceReplay")
		ObjectName.MouseMove intX,intY
		wait 3
		
		ObjectName.MouseClick intX, intY, 0
		If Err.Number <> 0 Then
			Call WriteToLog("Fail", "Unable to delete the snippet. Error returned: " & Err.Description)
			Err.Clear
		End If
		
		Set ObjectName = Nothing
		Set objDelete = Nothing
		Set delDesc = Nothing
		wait 2
	Next
	Set objSnippetDrag = Nothing
	Set oDesc = Nothing
	
	Execute "Set objDoneBtn = " & Environment("WB_Snippet_DoneButton")
	objDoneBtn.Click
	
	Call WriteToLog("Pass", "Delete functionality verified.")
	
	wait 2
	
	Call WriteToLog("info", "Test Case - Validate Create Snippet functionality")	
	
	'create snippet
	objCreateSnippetBtn.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Execute "Set  objNewSnippet = " & Environment("WE_Snippet_NewSnippet")
	If not CheckObjectExistence(objNewSnippet, 5) Then
		Call WriteToLog("Fail", "New Snippet text area does not exist")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "New Snippet text area exist")
	
	Execute "Set objSave = " & Environment("WB_Snippet_NewSnippet_Save")
	If not CheckObjectExistence(objSave, 5) Then
		Call WriteToLog("Fail", "Save button does not exist")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Save button exist")
	
	Execute "Set objCancel = " & Environment("WB_Snippet_NewSnippet_Cancel")
	If not CheckObjectExistence(objCancel, 5) Then
		Call WriteToLog("Fail", "Cancel button does not exist")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Cancel button exist")
	
	objNewSnippet.Set "Testing"
	objSave.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'validate if snippet is created
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("html id").Value = "Recap_Snippet_SnippetText_Draggable"
	
	Set objSnippetDrag = getPageObject().ChildObjects(oDesc)
	
	If objSnippetDrag.Count < 1 Then
		Call WriteToLog("Fail", "Failed to create Snippet")
		Exit Function
	Else
		Set textDesc = Description.Create
		textDesc("micclass").Value = "WebElement"
		textDesc("attribute/data-capella-automation-id").Value = "label-snippet.Text"
		
		Set objText = objSnippetDrag(0).WebElement(textDesc)
		snippetText = objText.getROPRoperty("innertext")
		Call WriteToLog("Pass", "Snippet created successfully with text as - '" & snippetText & "'")
	End If
	
	'validate edit created snippet
	Call WriteToLog("info", "Test Case - Validate Edit Snippet functionality")	
	
	objEditBtn.Click
	Execute "Set objSnippetTextArea = " & Environment("WEL_Snippet_Snippet_TextArea")
	objSnippetTextArea.Set "Edit Snippet"
	objDoneBtn.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("html id").Value = "Recap_Snippet_SnippetText_Draggable"
	
	Set objSnippetDrag = getPageObject().ChildObjects(oDesc)
	
	If Not objSnippetDrag.Count = 1 Then
		Call WriteToLog("Fail", "Failed to create Snippet")
		Exit Function
	Else
		Set textDesc = Description.Create
		textDesc("micclass").Value = "WebElement"
		textDesc("attribute/data-capella-automation-id").Value = "label-snippet.Text"
		
		Set objText = objSnippetDrag(0).WebElement(textDesc)
		snippetText = objText.getROPRoperty("innertext")
		
		If snippetText = "Edit Snippet" Then
			Call WriteToLog("Pass", "Snippet editted successfully with text as - '" & snippetText & "'")
		Else
			Call WriteToLog("Fail", "Snippet could not be editted. Text is - '" & snippetText & "'")
		End If
	End If
		
	'validate drag and drop functionality
	Call WriteToLog("info", "Test Case - Validate Drag and Drop functionality")	
	
	Execute "Set objContact = " & Environment("WEL_Contact_TextArea")
	objContact.Set ""
	wait 2
	
	toX = objContact.GetROProperty("abs_x")
	toY = objContact.GetROProperty("abs_y")
	
	Execute "Set obj = " & Environment("WEL_Recap_DraggableSnippet")
	obj.highlight
		
	getX = obj.GetROProperty("abs_x")
	getY = obj.GetROProperty("abs_y")
	
	obj.Drag getX + 10, getY + 10
	obj.Drop toX + 10, toY + 10
	
	wait 2
	
	draggedText = objContact.GetROProperty("innertext")
	If draggedText = "Edit Snippet" Then
		Call WriteToLog("Pass", "Drag and drop functionality working successfully.")
	Else
		Call WriteToLog("Fail", "Failed to validate Drag and drop functionality.")
	End If
	
	validateSnippets = true
End Function
