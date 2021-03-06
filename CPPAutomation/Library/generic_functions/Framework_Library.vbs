'##################################################################################################################################
'Function Name       :	getPageObject
'Purpose of Function :	To return page object of Capella premium web application
'Input Arguments     :	None
'Output Arguments    :	None
'Example of Call     :	Call getPageObject()
'Author              :	Sudheer
'Date                :	06-April-2015
'##################################################################################################################################
Function getPageObject()	
'	oUrl = getConfigFileValue("strURL")
'	openUrl = Mid(oUrl, 1, Instr(lcase(oUrl), "index") - 1) & "IndexShell.html"
'	openUrl = Mid(oUrl, 1, Instr(lcase(oUrl), ".com") + 4) & ".*"	
'	Set getPageObject = Browser("name:=DaVita VillageHealth Capella", "openurl:=" & openUrl & ".*").Page("title:=DaVita VillageHealth Capella")
	Set getPageObject = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
End Function

Function getTestCasesToExecute()
	On Error Resume Next
	Err.Clear
	
	'get object description from object mapping document
	strSQL = "SELECT * FROM [Main$]"
	Dim testCasesToExecute()
	
	Set rs = CreateObject("ADODB.Recordset")
	rs.Open strSQL, DBConnection_TestData, adOpenStatic, adLockOptimistic, adCmdText
	
	Dim runFlag : runFlag = ""
	Dim cnt : cnt = 0
	Do While not rs.eof
	
		runFlag = rs.Fields.Item("Run?").Value
		testScriptnames = rs.Fields.Item("ScriptName").Value
		If Ucase(runFlag) = "Y" Then
			ReDim Preserve testCasesToExecute(cnt)
			testCasesToExecute(cnt) = testScriptnames
			cnt = cnt + 1
		End If
		rs.MoveNext 
		
	Loop
	
	getTestCasesToExecute = testCasesToExecute
	Set rs = Nothing
	
	If Err.Number <> 0 Then   
		MsgBox err.description
		Err.Clear
		Exit Function
	End If
	
End Function


Function getObjectFromRepository(ByVal ObjectID)
	On Error Resume Next
	Err.Clear
	
	'get object description from object mapping document
	strSQL = "SELECT * FROM [ObjectMapping$] WHERE ObjectID = '" & ObjectID & "'"
	
	Set rs = CreateObject("ADODB.Recordset")
	rs.Open strSQL, DBConnection_Repository, adOpenStatic, adLockOptimistic, adCmdText
	
	Dim objectDesc : objectDesc = ""
	
	Do While not rs.eof
	
		objectDesc = rs.Fields.Item("ObjectDescriptionProperty").Value
		rs.MoveNext 
		
	Loop
	
	getObjectFromRepository = objectDesc
	Set rs = Nothing
	
	If Err.Number <> 0 Then   
		MsgBox err.description
		Err.Clear
		Exit Function
	End If
	
End Function

'##################################################################################################################################
'Function Name       :	clickOnMainMenu
'Purpose of Function :	To click on main menu of Capella premium app
'Input Arguments     :	menu
'Output Arguments    :	None
'Example of Call     :	Call clickOnMainMenu("My Dashboard")
'Author              :	Sudheer
'Date                :	14-April-2015
'##################################################################################################################################
Function clickOnMainMenu(ByVal menu)
	On Error Resume Next
	Err.Clear
	clickOnMainMenu = False
	Set objPage = getPageObject()
	objPage.highlight
	Set menuDesc = Description.Create
	menuDesc("micclass").Value = "WebElement"
	menuDesc("attribute/data-capella-automation-id").Value = "label-menu.Text"
	menuDesc("html tag").Value = "SPAN"
	menuDesc("innertext").Value = ".*" & Trim(menu) & ".*"
	
	Set objMenu = objPage.Link(menuDesc)
	
	Err.Clear
	objMenu.Click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail", "Unable to click " & menu & " due to error. " & Err.Description)
		Exit Function
	End If
    Call WriteToLog("info", "Clicked on the main menu '" & trim(menu) & "'.")
	Set menuDesc = Nothing
	Set objPage = Nothing
	Set objMenu = Nothing
	clickOnMainMenu = True
	Err.Clear
	
End Function

'##################################################################################################################################
'Function Name       :	clickOnSubMenu
'Purpose of Function :	To click on sub menus
'Input Arguments     :	menu
'Output Arguments    :	None
'Example of Call     :	Call clickOnSubMenu("Screenings->ADL Screening")
'Author              :	Sudheer
'Date                :	14-April-2015
'##################################################################################################################################
Function clickOnSubMenu(ByVal menu)
	On Error Resume Next
	Err.Clear
	Set objPage = getPageObject()
	
	menuArr = Split(menu,"->")
	
	For i = 0 To UBound(menuArr)
		Set menuDesc = Description.Create
		menuDesc("micclass").Value = "Link"
'		menuDesc("class").Value = "dropdown-.*"
'		menuDesc("class").regularExpression = True
		menuDesc("html tag").Value = "A"
		menuDesc("innertext").Value = ".*" & trim(menuArr(i)) & ".*"
		menuDesc("innertext").regularexpression = true
		
		Set objMenu = objPage.ChildObjects(menuDesc)
		If objMenu.Count = 2 Then
			objMenu(1).Click
		Else
			objMenu(0).Click
		End If
		
		Set menuDesc = Nothing
		Set objMenu = Nothing
	Next
	
	Call WriteToLog("info", "Clicked on the submenu '" & Trim(menu) & "'.")
	
	Set objPage = Nothing
	Err.Clear
End Function

'##################################################################################################################################
'Function Name       :	waitUntilExist
'Purpose of Function :	To wait till the max wait time is reached to find the object exist.
'Input Arguments     :	objObject, maxWait
'Output Arguments    :	None
'Example of Call     :	Call waitUntilExist(objEnrollmentLabel, 10)
'Author              :	Sudheer
'Date                :	15-April-2015
'##################################################################################################################################
Function waitUntilExist(ByVal objObject, ByVal maxWait)
	On Error Resume Next
	Err.Clear
'	Set objObject = Eval(strObject)
	Dim count : count = 0
	
	waitUntilExist = True
'	If not isObject(objObject) Then
'		waitUntilExist = False
'		Exit Function
'	End If
	
	Do while objObject.Exist(1) = False
		wait 1
		If count > maxWait Then
			waitUntilExist = False
			Exit Do
		End If
		count = count + 1
	Loop
	
	Set objObject = Nothing
End Function

'##################################################################################################################################
'Function Name       :	CloseAllBrowsers
'Purpose of Function :	To close all open IE browsers
'Input Arguments     :	None
'Output Arguments    :	None
'Example of Call     :	Call CloseAllBrowsers()
'Author              :	Sudheer
'Date                :	06-April-2015
'##################################################################################################################################
Public Function CloseAllBrowsers()
SystemUtil.CloseProcessByName "iexplore.exe"
'	Dim oDesc, colBrowser,intBrowserIndex
'	
'	On Error Resume Next
'	'Create a description object
'	Set oDesc = Description.Create
'	oDesc( "micclass" ).Value = "Browser"
'	Set colBrowser = Desktop.ChildObjects(oDesc)
'	
'	If colBrowser.Count > 0 Then 
'		For intBrowserIndex = 0 to colBrowser.Count - 1
'			colBrowser(intBrowserIndex).Close
'			'Closing Warning popup (if occured as a result of failure of just previous iteration or script)
'			CloseWarningPPatFailure()
'			Wait 1
'		Next
'	End If
'	
'	If Err.Number <> 0 Then   
'		Err.Clear
'	End If 
'	
'	Set oDesc = Nothing
'	Set colBrowser = Nothing
End Function

'##################################################################################################################################
'Function Name       :	getComboBoxSelectedValue
'Purpose of Function :	To get selected item from a drop down
'Input Arguments     :	objComboBox
'Output Arguments    :	None
'Example of Call     :	selectedVal = getComboBoxSelectedValue(objSelectPayor)
'Author              :	Sudheer
'Date                :	17-May-2016
'##################################################################################################################################
Function getComboBoxSelectedValue(ByVal objComboBox)
	
	On Error Resume Next
	Err.Clear
	
	getComboBoxSelectedValue = ""
	
	If Not CheckObjectExistence(objComboBox, 4) Then
		Exit Function
	End If
	
	selectedValue = objComboBox.getROProperty("innertext")
	
	getComboBoxSelectedValue = selectedValue
	
End Function

'##################################################################################################################################
'Function Name       :	selectComboBoxItem
'Purpose of Function :	To select an item from a drop down
'Input Arguments     :	objComboBox, itemToClick
'Output Arguments    :	None
'Example of Call     :	Call selectComboBoxItem(objSelectPayor, "Humana")
'Author              :	Sudheer
'Date                :	16-April-2015
'##################################################################################################################################
Function selectComboBoxItem(ByVal objComboBox, ByVal itemToClick)
	On Error Resume Next
	Err.Clear
	
	selectComboBoxItem = true
	
	Dim isListItem : isListItem = True
	Set objPage = getPageObject()	
	'objComboBox.highlight
	
	Dim objClass
	objClass = objComboBox.getROProperty("micclass")
	
	Select Case objClass
		
		Case "WebElement"
			intX = objComboBox.GetROProperty("abs_x") + 20
			intY = objComboBox.GetROProperty("abs_y") + 20
			
			Set ObjectName = CreateObject("Mercury.DeviceReplay")
			ObjectName.MouseMove intX,intY
			wait 3
			
			ObjectName.MouseClick intX, intY, 0
			If Err.Number <> 0 Then
'				MsgBox Err.Description
				Call WriteToLog("Fail", "Unable to click on the dropdown. Error returned: " & Err.Description)
				Set objPage = Nothing
				Set objClass = Nothing
				Set ObjectName = Nothing
				selectComboBoxItem = false
			End If
			
			Set ObjectName = Nothing
			Set objClass = Nothing
			
		Case "WebButton"
			objComboBox.Click
			
	End Select
	
	wait 2
	Set objDropDown = objPage.WebElement("class:=dropdown-menu.*","html tag:=UL","visible:=true")
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
		itemDesc("micclass").Value = "Link"
		itemDesc("class").Value = ".*"
		itemDesc("html tag").Value = "A"
		itemDesc("text").Value = ".*" & itemToClick & ".*"
		itemDesc("text").regularexpression = true
		
		Set objItems = ObjDropDown.ChildObjects(itemDesc)
	End If
	If objItems.Count = 0 Then
		Set objItems = Nothing
		Set itemDesc = Description.Create
		itemDesc("micclass").Value = "WebElement"
		itemDesc("class").Value = "ng-binding.*"
		itemDesc("html tag").Value = "A"
		itemDesc("innertext").Value = ".*" & itemToClick & ".*"
		itemDesc("innertext").regularexpression = true
		
		Set objItems = ObjDropDown.ChildObjects(itemDesc)
		
		isListItem = False
	End If	
	
	If objItems.Count = 0 Then
		Set objItems = Nothing
		Set itemDesc = Description.Create
		itemDesc("micclass").Value = "WebElement"
		itemDesc("class").Value = ".*"
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
		Set objPage = Nothing
		Exit Function
	End If
	Dim clicked : clicked = false
	
	If isListItem Then
		If objItems.Count = 1 Then
			For i = 0 To objItems.Count - 1
				uitext = objItems(i).getROProperty("text")
				If Instr(Ucase(trim(uitext)), Ucase(trim(itemToClick))) > 0 Then
					objItems(i).Click
					clicked = true
					Exit For
				End If
			Next
		Else
			For i = 0 To objItems.Count - 1
				uitext = objItems(i).getROProperty("text")
				If Ucase(trim(uitext)) = Ucase(trim(itemToClick)) Then
					objItems(i).Click
					clicked = true
					Exit For
				End If
			Next
		End If
		
	Else
		If objItemsCount = 1 Then
			For i = 0 To objItems.Count - 1
				uitext = objItems(i).getROProperty("innertext")
				If Instr(Ucase(trim(uitext)), Ucase(trim(itemToClick))) > 0 Then
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
		
	End If
	

	If not clicked Then
		Print "Item does not exist to click"
		sendKeys("{ESC}")
		selectComboBoxItem = false
	End If
'	Set objItem = objDropDown.Link(itemDesc)
'	objItem.Click
	wait 2
	Set objItems = Nothing
	Set objDropDown = Nothing
	Set objCombo = Nothing
	Set objPage = Nothing
	
End Function

'##################################################################################################################################
'Function Name       :	validateValueExistInDropDown
'Purpose of Function :	To validate if an item exists in the drop down or not
'Input Arguments     :	objComboBox, itemToValidate
'Output Arguments    :	None
'Example of Call     :	isPass = validateValueExistInDropDown(objCombo, "Insurance Verification")
'Author              :	Sudheer
'Date                :	27-May-2015
'##################################################################################################################################
Function validateValueExistInDropDown(ByVal objComboBox, ByVal itemToValidate)
	On Error Resume Next
	Err.Clear
	
	validateValueExistInDropDown = false
	
	Dim isListItem : isListItem = True
	Set objPage = getPageObject()	
	objComboBox.highlight
	
	Dim objClass
	objClass = objComboBox.getROProperty("micclass")
	
	Select Case objClass
		
		Case "WebElement"
			intX = objComboBox.GetROProperty("abs_x") + 20
			intY = objComboBox.GetROProperty("abs_y") + 20
			
			Set ObjectName = CreateObject("Mercury.DeviceReplay")
			ObjectName.MouseMove intX,intY
			wait 3
			
			ObjectName.MouseClick intX, intY, 0
			If Err.Number <> 0 Then
'				MsgBox Err.Description
				Call WriteToLog("Fail", "Unable to click on the dropdown. Error returned: " & Err.Description)
				Set objPage = Nothing
				Set objClass = Nothing
				Set ObjectName = Nothing
				validateValueExistInDropDown = false
			End If
			
			Set ObjectName = Nothing
			Set objClass = Nothing
			
		Case "WebButton"
			objComboBox.Click
			
	End Select
	
	wait 2
	Set objDropDown = objPage.WebElement("class:=dropdown-menu.*","html tag:=UL","visible:=true")
	
	Set itemDesc = Description.Create
	itemDesc("micclass").Value = "Link"
	itemDesc("class").Value = "ng-binding.*"
	itemDesc("html tag").Value = "A"
	itemDesc("text").Value = ".*" & itemToValidate & ".*"
	itemDesc("text").regularexpression = true
	
	Set objItems = ObjDropDown.ChildObjects(itemDesc)
	If objItems.Count = 0 Then
		Set objItems = Nothing
		Set itemDesc = Description.Create
		itemDesc("micclass").Value = "Link"
		itemDesc("class").Value = ".*"
		itemDesc("html tag").Value = "A"
		itemDesc("text").Value = ".*" & itemToValidate & ".*"
		itemDesc("text").regularexpression = true
		
		Set objItems = ObjDropDown.ChildObjects(itemDesc)
	End If
	
    If objItems.Count = 0 Then
		Set objItems = Nothing
		Set itemDesc = Description.Create
		itemDesc("micclass").Value = "WebElement"
		itemDesc("class").Value = "ng-binding.*"
		itemDesc("html tag").Value = "A"
		itemDesc("innertext").Value = ".*" & itemToValidate & ".*"
		itemDesc("innertext").regularexpression = true
		
		Set objItems = ObjDropDown.ChildObjects(itemDesc)
		
		isListItem = False
	End If	
	
	if objItems.Count = 0 Then
		Print "No such item exists"
		Set objItems = Nothing
		Set objDropDown = Nothing
		Set objComboBox = Nothing
		Set objPage = Nothing
'		Exit Function
	End If
	Dim isExit : isExit = false
	
	If isListItem Then
		For i = 0 To objItems.Count - 1
			uitext = objItems(i).getROProperty("text")
			If Ucase(trim(uitext)) = Ucase(trim(itemToValidate)) Then
				objItems(i).Click
				validateValueExistInDropDown = true
			End If
		Next
	Else
		For i = 0 To objItems.Count - 1
			uitext = objItems(i).getROProperty("innertext")
			If Ucase(trim(uitext)) = Ucase(trim(itemToValidate)) Then
				objItems(i).Click
				validateValueExistInDropDown = true
			End If
		Next
	End If
	
	wait 2
	
	Set objItems = Nothing
	Set objDropDown = Nothing
	Set objComboBox = Nothing
	Set objPage = Nothing
End Function

Function validateValuesExistInDropDown(ByVal objComboBox, ByVal itemsToValidate)
	On Error Resume Next
	Err.Clear
	
	validateValueExistInDropDown = false
	
	Dim isListItem : isListItem = True
	Set objPage = getPageObject()	
	objComboBox.highlight
	
	Dim objClass
	objClass = objComboBox.getROProperty("micclass")
	
	Select Case objClass
		
		Case "WebElement"
			intX = objComboBox.GetROProperty("abs_x") + 20
			intY = objComboBox.GetROProperty("abs_y") + 20
			
			Set ObjectName = CreateObject("Mercury.DeviceReplay")
			ObjectName.MouseMove intX,intY
			wait 3
			
			ObjectName.MouseClick intX, intY, 0
			If Err.Number <> 0 Then
'				MsgBox Err.Description
				Call WriteToLog("Fail", "Unable to click on the dropdown. Error returned: " & Err.Description)
				Set objPage = Nothing
				Set objClass = Nothing
				Set ObjectName = Nothing
				validateValueExistInDropDown = false
			End If
			
			Set ObjectName = Nothing
			Set objClass = Nothing
			
		Case "WebButton"
			objComboBox.Click
			
	End Select
	
	wait 2
	Set objDropDown = objPage.WebElement("class:=dropdown-menu.*","html tag:=UL","visible:=true")
	
	itemToValidate = Split(itemsToValidate, ";")
	For i = 0 To UBound(itemToValidate)
		Set itemDesc = Description.Create
		itemDesc("micclass").Value = "Link"
		itemDesc("class").Value = "ng-binding.*"
		itemDesc("html tag").Value = "A"
		itemDesc("text").Value = ".*" & itemToValidate(i) & ".*"
		itemDesc("text").regularexpression = true
		
		Set objItems = ObjDropDown.ChildObjects(itemDesc)
		If objItems.Count = 0 Then
			Set objItems = Nothing
			Set itemDesc = Description.Create
			itemDesc("micclass").Value = "Link"
			itemDesc("class").Value = ".*"
			itemDesc("html tag").Value = "A"
			itemDesc("text").Value = ".*" & itemToClick & ".*"
			itemDesc("text").regularexpression = true
			
			Set objItems = ObjDropDown.ChildObjects(itemDesc)
		End If
		If objItems.Count = 0 Then
			Set objItems = Nothing
			Set itemDesc = Description.Create
			itemDesc("micclass").Value = "WebElement"
			itemDesc("class").Value = "ng-binding.*"
			itemDesc("html tag").Value = "A"
			itemDesc("innertext").Value = ".*" & itemToValidate(i) & ".*"
			itemDesc("innertext").regularexpression = true
			
			Set objItems = ObjDropDown.ChildObjects(itemDesc)
			
			isListItem = False
		End If	
		
		if objItems.Count = 0 Then
			Call WriteToLog("Fail", itemToValidate(i) & " does not exist in the drop down")
			Print itemToValidate(i) & " does not exist in the drop down"
			Set objItems = Nothing
			Set objDropDown = Nothing
			Set objComboBox = Nothing
			Set objPage = Nothing
	'		Exit Function
		End If
		Dim isExit : isExit = false
		
		If isListItem Then
			For j = 0 To objItems.Count - 1
				uitext = objItems(j).getROProperty("text")
				If Ucase(trim(uitext)) = Ucase(trim(itemToValidate)) Then
					Call WriteToLog("Pass", itemToValidate(i) & " exist in the drop down")
					Print itemToValidate(i) & " exist in the drop down"
					validateValuesExistInDropDown = true
				End If
			Next
		Else
			For j = 0 To objItems.Count - 1
				uitext = objItems(j).getROProperty("innertext")
				If Ucase(trim(uitext)) = Ucase(trim(itemToValidate)) Then
					Call WriteToLog("Pass", itemToValidate(i) & " exist in the drop down")
					Print itemToValidate(i) & " exist in the drop down"
					validateValuesExistInDropDown = true
				End If
			Next
		End If
		
		wait 2
	Next
	
	
	Set objItems = Nothing
	Set objDropDown = Nothing
	Set objComboBox = Nothing
	Set objPage = Nothing
End Function

'#######################################################################################################################################################################################################
'Function Name		 :	ClickButton
'Purpose of Function :	Clicks on a Particular Button
'Input Arguments	 :	strButtonName -> The Button which has to be clicked
'Output Arguments	 :	strOutErrorDesc : String value which contains detail error message occurred (if any) during function execution
'Example of Call	 :	blnButtonClicked = ClickButton("Add",objAddButton,strOutErrorDesc")
'Author				 :	Masood Ali
'#######################################################################################################################################################################################################

Function ClickButton(ByVal strButtonName,objButton,strOutErrorDesc)

	strOutErrorDesc =""
	Err.Clear
	On Error Resume Next
	ClickButton = False
	
   	'Check button existence
   	blnReturnValue = waitUntilExist(objButton, 10)
  	If blnReturnValue Then
		'Perform click
		objButton.Click
		If Err.Number = 0 Then
			Call WriteToLog("Pass",strButtonName&" clicked successfully")
		Else
			strOutErrorDesc = strButtonName&" does not clicked successfully. Error Returned: "&Err.Description
			Exit Function	
		End If		
	Else
		ClickButton= blnReturnValue
		strOutErrorDesc = strButtonName&" object does not exist."
		Exit function
   	End If 
   	
   	ClickButton = True
   	
End Function



'##########################################################################################################################################
'Function Name       :	LoadCurrentTestCaseData
'Purpose of Function :	To load test data of the test case being executed into QTP datatable
'Input Arguments     :	strInWorksheetName: String value representing name of the worksheet inside TestData.xls.
'					 :					    strInWorksheetName is space and spelling sensitive.
'					 :	strInTestCaseName: String value representing name of the testcase being executed
'					 :					   strInTestCaseName is space and spelling sensitive.
'					 :	strInTestDataFileName: String value representing name of the Testdata sheet along with file extension
'					 :						   strInTestDataFileName is space and spelling sensitive.
'Output Arguments    :	strOutErrorDesc: String value which contains detail error message occurred (if any) during function execution
'Example of Call     :	strReturnValue = LoadCurrentTestCaseData ( "Testdata.xls", "Login", "AT-01015_Login", strOutErrorDesc)
'Author              :	Kushal Parab
'Date                : 	12-Sep-2014
'##########################################################################################################################################

Function LoadCurrentTestCaseData(ByVal strInTestDataFileName, ByVal strInWorksheetName, ByVal strInTestCaseName, strOutErrorDesc)
	LoadCurrentTestCaseData = FALSE
	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
	intUsedRangeRowCount = 0
	iRow = 0
	intFirstRow = 0
	i = 0
	intLastRow = 0
	intIndex = 0
	j = 0
	Dim arrRowValues()
	
	'Delete 'CurrentTestCaseData' datable sheet if exist
    Set objDataTableSheet = DataTable.GetSheet("CurrentTestCaseData")
    If err.number = 0 Then 
    	DataTable.DeleteSheet("CurrentTestCaseData")
	Else
		Err.Clear	'If Sheet doesn't exist then obviously Error will be returned. So clearing Err object
	End If
	
	'Create Excel application object
	Set objExcel = CreateObject("Excel.Application")
	objExcel.DisplayAlerts = False
	objExcel.Visible = False
	
	'Get complete path of the file
	If Trim(strInTestDataFileName) <> "" Then	
		strTestDataFilePath = PathFinder.Locate(Trim(strInTestDataFileName))
	Else
		strOutErrorDesc = "TestData file name cannot be blank"
		objExcel.quit
		Set strCells = nothing
		Set objWorksheet = nothing
		Set objExcelBook = nothing
		Set objExcel = nothing
		Exit Function
	End If
	
	'Open TestData workbook
	Set objExcelBook = objExcel.WorkBooks.Open(strTestDataFilePath)
	'If Workbook not found report error and exit from the function
	If Err.Number <> 0 Then
		strOutErrorDesc = "Testdata file '" & strInTestDataFileName & "' not found. Error returned: " & Err.Description
		objExcel.Workbooks.Close
		objExcel.quit
		Set strCells = nothing
		Set objWorksheet = nothing
		Set objExcelBook = nothing
		Set objExcel = nothing
		Exit Function
	End If
	
	'Create Worksheet object
	Set objWorksheet = objExcel.Sheets.Item(Trim(Lcase(strInWorksheetName)))
	'If worksheet not found report error and exit from the function
	If Err.Number <> 0 Then
		strOutErrorDesc = "Failed to retrieve worksheet '" & strInWorksheetName & "' inside " & strTestDataFilePath & "."
		objExcel.Workbooks.Close
		objExcel.quit
		Set strCells = nothing
		Set objWorksheet = nothing
		Set objExcelBook = nothing
		Set objExcel = nothing
		Exit Function
	End If
	
	'Activate worksheet
	objWorksheet.Activate
	
	'Get UsedRange for Row in the activated worksheet
	intUsedRangeRowCount = objWorksheet.UsedRange.Rows.Count
	'Iterate over each Row of Column 'A' to search for the name of test case contained in variable 'strInTestCaseName'
	For iRow = 1 to intUsedRangeRowCount
		If Lcase(Trim(objWorksheet.Cells(iRow,1).Value)) = Lcase(Trim(strInTestCaseName)) Then
			intFirstRow = iRow	'Store first row# where test data for an test case is found
			For i = intFirstRow to intUsedRangeRowCount	'Begin search from row # "intRowFound" and find row where column 'B' is blank (incase multiple test data is specified for test case)
				If Trim(objWorksheet.Cells(i,2).Value) = "" Then
					intLastRow = i - 1
					Exit For
				End If
			Next
			If i > intUsedRangeRowCount Then
				intLastRow = intUsedRangeRowCount
				Exit For
			End If
		End If
		If intLastRow > 0 Then	'Once last row is found exit for loop
			Exit For
		End If
	Next
	
	If iRow > intUsedRangeRowCount Then
		strOutErrorDesc = "Test data for Test case '" & strInTestCaseName & "' not found in worksheet '" & strInWorksheetName & "' inside TestData"
		objExcel.Workbooks.Close
		objExcel.quit
		Set strCells = nothing
		Set objWorksheet = nothing
		Set objExcelBook = nothing
		Set objExcel = nothing
		Exit Function
	End If
	
	'Add a datatable sheet in QTP
	DataTable.AddSheet("CurrentTestCaseData")
	
	'First row number
	a = intFirstRow
	
	'Last row number
	b = intLastRow
	
	'Total number of rows to be added in QTP datatable
	intSetRow = intLastRow - intFirstRow
	
	'Add Column and Column value to QTP Datatable
	intColumnsCount = objWorksheet.UsedRange.Columns.Count
	Set strCells = objWorksheet.Cells
	
	'Iterate through columns		
	For intColumn = 2 To intColumnsCount
		strColumnName = strCells(intFirstRow-1,intColumn)	'Get name of the column
		If Trim(strColumnName) <> "" Then	'Check if column name is not blank
			DataTable.GetSheet("CurrentTestCaseData").AddParameter strColumnName , "tempdata"	'Add temperoray data
			intIndex = 0
			For intRows = intFirstRow To intLastRow Step 1
				intIndex = intIndex + 1	'Increment index by 1							
				strColumnValue = strCells(intRows,intColumn)	'Get Parameter value
				ReDim Preserve arrRowValues(intIndex-1)	'Start array from 0 index
				arrRowValues(intIndex-1) = strColumnValue	'Store parameter value in array
			Next
			'Add parameter value in data table for 'j' rows
			For j = Lbound(arrRowValues) To Ubound(arrRowValues) Step 1
				DataTable.SetCurrentRow(j+1)
				DataTable.Value(strColumnName,"CurrentTestCaseData") = CStr(arrRowValues(j))
			Next
		End If		
	Next	
	DataTable.SetCurrentRow(1)
	
	'Kill excel objects
	objExcel.Workbooks.Close
	objExcel.quit
	Set strCells = nothing
	Set objWorksheet = nothing
	Set objExcelBook = nothing
	Set objExcel = nothing
	
	LoadCurrentTestCaseData = TRUE
End Function

'##################################################################################################################################
'Function Name       :	getConfigFileValue
'Purpose of Function :	To get the value of variable from configuration file
'Input Arguments     :	strVHESPassword
'Output Arguments    :	None
'Example of Call     :	Call getConfigFileValue("strVHESPassword")
'Author              :	Sudheer
'Date                :	27-April-2015
'##################################################################################################################################
Function getConfigFileValue(ByVal name)
	On Error Resume Next
	Err.Clear
	
	Dim XMLFileName
	If Environment.Value("PROJECT_FOLDER") = "" Then
		If err.Number <> 0 Then
			Err.Clear
			Set objFso = CreateObject("Scripting.FileSystemObject")
			driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
			Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)
			Set objFso = Nothing
		End If
	End If	
	XMLFileName = Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml"
	Set xmlDoc = CreateObject("MSXML2.DomDocument")
	xmlDoc.load(XMLFileName)
	Set colNodes = xmlDoc.selectNodes("/Environment/Variable")
	
	Dim reqValue
	reqValue = ""
	
	For each objNode in colNodes
		If Ucase(objNode.SelectSingleNode("Name").text) = UCase(name) Then
			reqValue = objNode.SelectSingleNode("Value").text
		End If 
	Next
	
	getConfigFileValue = reqValue
	Set colNodes = Nothing
	Set xmlDoc = Nothing
	
End Function

'##################################################################################################################################
'Function Name       :	CheckObjectExistence
'Purpose of Function :	To check the existance of an object on the page and wait till the max wait if the object not found
'Input Arguments     :	Object, MaxTime
'Output Arguments    :	None
'Example of Call     :	Call CheckObjectExistence(objEnrollment, 10)
'Author              :	Piyush
'Date                :	27-October-2014
'##################################################################################################################################
Function CheckObjectExistence(Object,MaxTime)
	counter=0
	CheckObjectExistence=False
	Do Until Object.Exist(1)
		counter=counter+1	
		If counter> MaxTime Then
			Exit Function
		End If
	Loop 
	CheckObjectExistence=True
End Function

Function GetChildObject(ByVal strPropertyName,ByVal strPropertyValue)
    
    Err.Clear
    On Error Resume Next
    
    Set objDesc = Description.Create()
    
    arrPropertyNames = Split(strPropertyName,";")
    arrPropertyValues = Split(strPropertyValue,";")
    If Ubound(arrPropertyNames) = Ubound(arrPropertyValues)  Then
        For i = 0 To Ubound(arrPropertyNames) Step 1
             objDesc(arrPropertyNames(i)).Value = arrPropertyValues(i)
        Next
        
        Set objParent = ReturnObject("BrowserWelcomeLogin","")
        Set GetChildObject = objParent.ChildObjects(objDesc)
    Else
        Call WriteToLog("Fail","Property name are not match property values")
        Exit Function
    End If
    
End Function

Function ReturnObject (ByVal strKey, ByVal strParam)
	wait 2
    Select Case strKey
        
        Case "BrowserWelcomeLogin"
            Set ReturnObject = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
            
        Case "BrowserActionItemPatient"
            Set objBrowser = ReturnObject("BrowserWelcomeLogin","")    
            Set ReturnObject = objBrowser.WebElement("html tag:=DIV","class:=.*detailView-patient-title-name.*","innertext:=.*"&strParam&".*")

        
        Case "BrowserSpanWebElement"
            Set objBrowser = ReturnObject("BrowserWelcomeLogin","")
            Set ReturnObject = objBrowser.WebElement("html tag:=SPAN","innertext:="&strParam)
        
        Case "Insight"
             Set ReturnObject = Browser("Insight_Browser")
             
         Case "PeiChart"
            Set objInsight = ReturnObject("Insight","")
            Set ReturnObject = objInsight.InsightObject("PatientCensusPeiChart")

        Case "LegendsCategories"
            Set objInsight = ReturnObject("Insight","")
            Set ReturnObject = objInsight.InsightObject("PatientCensus_"&strParam)
            
        Case "LegendsDisabled"
            Set objInsight = ReturnObject("Insight","")
            Set ReturnObject = objInsight.InsightObject("PatientCensus_"&strParam&"_"&"Disabled")

        Case "NotesSection"
            Set objInsight = ReturnObject("Insight","")
            Set ReturnObject = objInsight.InsightObject("NoteSection")
        
        Case "NotesSectionIcons"
            Set objInsight = ReturnObject("Insight","")
            Set ReturnObject = objInsight.InsightObject("Note_"&strParam)
            
        Case "OpenCallList"
        	Set ReturnObject = getPageObject().WebElement("html tag:=DIV","class:=.*open-call-list-patient-name.*","innertext:=.*" & strParam & ".*")
        
    End Select
    
End Function

Function CheckMessageBoxExist(ByVal objTitle,ByVal strMessageBoxTitle,ByVal objText,ByVal strMessageBoxText,ByVal strButtonName,ByVal strCheckexistenceFlag,strOutErrorDesc)
    
    strOutErrorDesc = ""
    Err.Clear
    On Error Resume Next
    CheckMessageBoxExist = False
    
    If Trim(Lcase(strCheckexistenceFlag)) = "yes" Then    'Scenario where user wants to check if message box exist
        
        'Check whether message box title need to verify or not
        If strMessageBoxTitle <> "" Then
            'Set innertext property for message box title
            objTitle.SetTOProperty "innertext",strMessageBoxTitle    
            If not objTitle.WaitProperty("visible",True,60000) Then
                strOutErrorDesc = "Alert with title '" & strMessageBoxTitle & "' is not visible"
                'Exit Function
            End If
        End If
        
        'Check whether message box text need to verify or not
        If strMessageBoxText <> "" Then
            'Set innertext property for popup text
            objText.SetTOProperty "innertext",strMessageBoxText
            If not objText.WaitProperty("visible",True,60000) Then
                strOutErrorDesc = "Alert with message '" & strMessageBoxText & "' is not visible"
                Exit Function
            End If
        End If
        
        'Verify that specified button exist on message box
        arrButtonObject = Split(strButtonName,"|")
        For i = Lbound(arrButtonObject) To Ubound(arrButtonObject) Step 1
            Execute "Set objButton = " & Environment.Value("DictObject").Item(Trim(arrButtonObject(i)))
            If not objButton.Exist(2) Then
                j = j + 1    'counter
                strBtnNotFound = strBtnNotFound & arrButtonObject(i) & ","
            End If
        Next
        
        If j > 0 Then
            strOutErrorDesc = "Button(s) " & Trim(strBtnNotFound) & " not found on popup box"
            Exit Function
        End If
    End If
    
    If Trim(Lcase(strCheckexistenceFlag)) = "no" Then    'Scenario where user wants to check if message box does not exist
        'Set innertext property for message box title
        objTitle.SetTOProperty "innertext",strMessageBoxTitle    
        If CheckObjectExistence(objTitle,intWaitTime*2) Then
            strOutErrorDesc = "Alert with title '" & strMessageBoxTitle & "' is visible"
            Exit Function
        End If
    End If
    
    CheckMessageBoxExist = True
End Function

'##################################################################################################################################
'Function Name       :	IsArrayEmpty
'Purpose of Function :	To check if the array is empty or not
'Input Arguments     :	array
'Output Arguments    :	None
'Example of Call     :	Call isArrayEmpty(arrValue)
'Author              :	Sudheer
'Date                :	10-June-2015
'##################################################################################################################################
Function IsArrayEmpty(ByVal arr)

	On Error Resume Next
    Err.Clear
    If Len(Join(arr,"")) = 0 Then        
        IsArrayEmpty = True    
    Else        
        IsArrayEmpty = False    
    End If
    
End Function

Function getComboBoxReferralManagement(ByVal fieldName)

	fieldName = Replace(fieldName, " ", "")
	Set objReferralPane = getPageObject().WebElement("html id:=ReferralEdit")
	Set objDropDown = Description.Create
	objDropDown("micclass").Value = "WebButton"
	objDropDown("html id").Value = "sideDropDown"
	Set objDD = objReferralPane.ChildObjects(objDropDown)
	For i = 0 To objDD.Count - 1
		outerhtml = objDD(i).GetROProperty("outerhtml")
		
		If instr(outerhtml, fieldName) > 0 Then
			Set getComboBoxReferralManagement = objDD(i)
		End If
	Next
	
	Set objReferralPane = Nothing
	Set objDropDown = Nothing
	Set objDD = Nothing
End Function

Function sendKeys(ByVal keyVal)
	Set WshShell = CreateObject("WScript.Shell")
	WshShell.SendKeys keyVal
	Set WshShell = Nothing    
End Function

'--------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function (selectComboBoxItem) modified: Gregory 
'--------------------------------------------------------------------------------------------------------------------------------------------------------------------	
Function SelectComboBoxItemSpecific(ByVal objComboBox, ByVal itemToClick)
	On Error Resume Next
	Err.Clear
	
	SelectComboBoxItemSpecific = true
	
	Dim isListItem : isListItem = True
	Set objPage = getPageObject()	
	
	Dim objClass
	objClass = objComboBox.getROProperty("micclass")
	
	Select Case objClass
		
		Case "WebElement"
			intX = objComboBox.GetROProperty("abs_x") + 20
			intY = objComboBox.GetROProperty("abs_y") + 20
			
			Set ObjectName = CreateObject("Mercury.DeviceReplay")
			ObjectName.MouseMove intX,intY
			wait 3
			
			ObjectName.MouseClick intX, intY, 0
			If Err.Number <> 0 Then
				Call WriteToLog("Fail", "Unable to click on the dropdown. Error returned: " & Err.Description)
				Set objPage = Nothing
				Set objClass = Nothing
				Set ObjectName = Nothing
				SelectComboBoxItemSpecific = false
			End If
			
			Set ObjectName = Nothing
			Set objClass = Nothing
			
		Case "WebButton"
			objComboBox.Click
			
	End Select
	
	wait 2
	Set objDropDown = objPage.WebElement("class:=dropdown-menu.*","html tag:=UL","visible:=true")
	
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
		itemDesc("class").Value = "ng-binding.*"
		itemDesc("html tag").Value = "A"
		itemDesc("innertext").Value = ".*" & itemToClick & ".*"
		itemDesc("innertext").regularexpression = true
		
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
	End If	
	
	if objItems.Count = 0 Then
		Print "No such item exists"
		sendKeys("{ESC}")
		SelectComboBoxItemSpecific = false
		Set objItems = Nothing
		Set objDropDown = Nothing
		Set objCombo = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	Dim clicked : clicked = false
	
	If isListItem Then
		For i = 0 To objItems.Count - 1
			uitext = objItems(i).getROProperty("text")
			If Instr(1,Ucase(trim(uitext)),Ucase(trim(itemToClick)),1) Then
				objItems(i).Click
				clicked = true
				Exit For
			End If
		Next
	Else
		For i = 0 To objItems.Count - 1
			uitext = objItems(i).getROProperty("innertext")
			If Instr(1,Ucase(trim(uitext)),Ucase(trim(itemToClick)),1) Then
				objItems(i).Click
				clicked = true
				Exit For
			End If
		Next
	End If
	

	If not clicked Then
		Print "Item does not exist to click"
		sendKeys("{ESC}")
		SelectComboBoxItemSpecific = false
	End If

	wait 2
	Set objItems = Nothing
	Set objDropDown = Nothing
	Set objCombo = Nothing
	Set objPage = Nothing
	
End Function

'--------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function to get specific fields in PHM intervention pane
'Author: Gregory
'--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function getComboBoxPHMInterventionPane(ByVal fieldName)

	fieldName = Replace(fieldName, " ", "")
	Set objPHMInterventionPane = getPageObject().WebElement("class:=.*pmd-intervention-parent.*","html tag:=DIV","visible:=True")
	Set objDropDown = Description.Create
	objDropDown("micclass").Value = "WebButton"
	objDropDown("html id").Value = "sideDropDown"
	Set objDD = objPHMInterventionPane.ChildObjects(objDropDown)
	For i = 0 To objDD.Count - 1
		outerhtml = objDD(i).GetROProperty("outerhtml")
		
		If instr(outerhtml, fieldName) > 0 Then
			Set getComboBoxPHMInterventionPane = objDD(i)
			Exit Function
		Else 
			getComboBoxPHMInterventionPane = ""
		End If
	Next
	
	If getComboBoxPHMInterventionPane = "" Then
		Set objDropDown = Description.Create
		objDropDown("micclass").Value = "WebEdit"
		objDropDown("html tag").Value = "INPUT"
		Set objDD = objPHMInterventionPane.ChildObjects(objDropDown)
		For i = 0 To objDD.Count - 1
			outerhtml = objDD(i).GetROProperty("outerhtml")
			
			If instr(outerhtml, fieldName) > 0 Then
				Set getComboBoxPHMInterventionPane = objDD(i)
				Exit Function
			Else 
				getComboBoxPHMInterventionPane = ""
			End If
		Next
	End If
	
	Set objPHMInterventionPane = Nothing
	Set objDropDown = Nothing
	Set objDD = Nothing
End Function


'====================================================================
'Modified 'clickOnSubMenu' function as per object change
'====================================================================
Function clickOnSubMenu_WE(ByVal menu)
	On Error Resume Next
	Err.Clear	
	clickOnSubMenu_WE = False
	Set objPage = getPageObject()
	
	menuArr = Split(menu,"->")
	
	For i = 0 To UBound(menuArr)
		Set menuDesc = Description.Create
		menuDesc("micclass").Value = "WebElement"
		menuDesc("html tag").Value = "A"
		menuDesc("innertext").Value = ".*" & trim(menuArr(i)) & ".*"
		menuDesc("innertext").regularexpression = true
		
		Set objMenu = objPage.ChildObjects(menuDesc)
		If objMenu.Count = 2 Then
			Err.Clear
			objMenu(1).Click
			If Err.Number <> 0 Then
				Call WriteToLog("Fail", "Failed to click on sub menu " & menu & ". " & Err.Description)
				Exit Function
			End If
		Else
			objMenu(0).Click
			If Err.Number <> 0 Then
				Call WriteToLog("Fail", "Failed to click on sub menu " & menu & ". " & Err.Description)
				Exit Function
			End If
		End If
		
		Set menuDesc = Nothing
		Set objMenu = Nothing
	Next
	
	Set objPage = Nothing
	Err.Clear
	clickOnSubMenu_WE = True
	Call WriteToLog("info", "Clicked on the submenu '" & Trim(menu) & "'.")
	
	Wait 3
	Call waitTillLoads("Loading...")
	Wait 2
End Function


'==========================================================================================================================================================================================
'Function Name       :	WriteOutputToText
'Purpose of Function :	Write script out put to external text file
'Input Arguments     :	strText: text to be written to the external text file
'					 :	TextFilePath: path for external text file
'Output Arguments    :	NA
'Example of Call     :	Call WriteOutputToText("some value", "D:\FolderName")
'Author	      		 :	Gregory
'Date				 :	December 08, 2015
'==========================================================================================================================================================================================

Function WriteOutputToText(ByVal strText, ByVal TextFilePath)
	
	On Error Resume Next
	Err.Clear
	
    Set objFso = CreateObject("Scripting.FileSystemObject")
      
    If objFso.FileExists(TextFilePath) Then
       Set TextFile = objFso.OpenTextFile(TextFilePath, 8, True)
       TextFile.WriteLine(strText)
  	Else
       Set TextFile = objFso.CreateTextFile(TextFilePath)
      TextFile.WriteLine(strText)
  	End If
  	
	TextFile.Close
    
    Set objFso = Nothing
    Set TextFile = Nothing

End Function
'==========================================================================================================================================================================================
'Function Name       :	SelectDDitemBySendingKeys
'Purpose of Function :	To select required dropdown item by sending each character of the required item
'Input Arguments     :	objDD: object for the dropdown from which item to be selected
'					 :	objDDlist: object for the opened list of dropdown
'			 		 :	strDDitem: string value representing the item to be selected
'Output Arguments    :	boolean value representing status of item selection
'Example of Call     :	blnSelectDDitemBySendingKeys = SelectDDitemBySendingKeys(objIndicationDD,objIndicationDDlist,strIndication,strOutErrorDesc)
'Author	      		 :	Gregory
'Date				 :	March 22, 2016
'==========================================================================================================================================================================================

Function SelectDDitemBySendingKeys(ByVal objDD, ByVal objDDlist, ByVal strDDitem, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	SelectDDitemBySendingKeys = False

	objDD.highlight
	Err.Clear
	objDD.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click specified dropdown. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked dropdown")
	
	'Clear previous entries (if existing) in dropdown
	For d = 1 To 50 Step 1
		sendkeys ("{DEL}")
		Wait 0,50				
	Next
	Wait 0,250
	
	For i = 1 To len(strDDitem)
	
		ch = Mid(strDDitem, i, 1)
		
		sendKeys ch
		
		Err.Clear	
		
		isFound = false
		If objDDlist.Exist(5) Then
			Call WriteToLog("Pass", "Dropdown list is available")
			objList.highlight
			Set itemDesc = Description.Create
			itemDesc("micclass").Value = "WebElement"
			itemDesc("html tag").Value = "LI"
'			itemDesc("class").Value = "k-item.*"
			
			
			Set objItem = objDDlist.ChildObjects(itemDesc)
			For j = 0 To objItem.Count - 1
				item = objItem(j).getROProperty("outertext")
				
				If LCase(Trim(item)) = LCase(Trim(strDDitem)) Then
					Err.Clear
					Setting.WebPackage("ReplayType") = 2
					objItem(j).FireEvent "onClick"
					Setting.WebPackage("ReplayType") = 1
					isFound = true
					Exit For
				End If
			Next
		End If		
		Set objList = Nothing
		
		If isFound = true Then
			Exit For
		End If
	Next
		
	If isFound Then
		Call WriteToLog("Pass","Selected "&strDDitem&" from dropdown")
		SelectDDitemBySendingKeys = True
	Else
		strOutErrorDesc  strDDtem&" is not present in dropdown"
		Exit Function
	End If
	wait 1		

		
End Function

'==========================================================================================================================================================================================
'Function Name       :	GetDocumentContent
'Purpose of Function :	Get the content of documents/reports
'Input Arguments     :	objDocument: document/report object
'Output Arguments    :	content of the document/report
'Example of Call     :	
'						Set objPatientCareReport = getPageObject().WinObject("object class:=AVL_AVView","text:=AVPageView")
'						strPatientCareReportContent = GetDocumentContent(objPatientCareReport)
'Author	      		 :	Gregory
'Date				 :	March 21, 2016
'==========================================================================================================================================================================================

Function GetDocumentContent(ByVal objDocument)
	
	objDocument.Type micCtrlDwn + "a" + micCtrlUp
	Wait 1
	objDocument.Type micCtrlDwn + "c" + micCtrlUp
	Wait 1
	
	Set oClipBoard = CreateObject("Mercury.Clipboard" )
	GetDocumentContent = oClipBoard.GetText
	
	Set oClipBoard = Nothing
	
End Function