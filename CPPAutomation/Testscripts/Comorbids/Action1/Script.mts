' TestCase Name			: Comorbids
' Purpose of TC			: All actions regarding Comorbids
' Author                : Swetha
' Date					: 11-Sep-2015
' Comments				: 
'**************************************************************************************************************************************************************************
''***********************************************************************************************************************************************************************
'Initialization steps for current script
''***********************************************************************************************************************************************************************
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Comorbids", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

''***********************************************************************************************************************************************************************
'End of Initialization steps for the current script
''***********************************************************************************************************************************************************************

'=========================
' Variable initialization
'=========================
 strExpectedComorbidHitoryColumnNames = DataTable.Value("ComorbidHitoryTableColumnName","CurrentTestCaseData") 'Comorbid history column header
 arrExpectedComorbidHitoryColumnNames = Split(strExpectedComorbidHitoryColumnNames,";") 'Split the columns name
 strComplaintTitle = DataTable.Value("NewNoteTitle","CurrentTestCaseData")
 strComplaintDescription = DataTable.Value("NewNoteDescription","CurrentTestCaseData")
 strChangeComplaintTitle =  DataTable.Value("ChangeNoteTitle","CurrentTestCaseData")
 strChangeComplaintDescription = DataTable.Value("ChangeNoteDescription","CurrentTestCaseData")
 strComorbidType =  DataTable.Value("ComorbidType","CurrentTestCaseData")
 strComorbidTypeDepression =  DataTable.Value("ComorbidTypeDepression","CurrentTestCaseData")
 strProvider = DataTable.Value("Provider","CurrentTestCaseData")
 strExpectedComorbidGroup = DataTable.Value("ExpectedComorbidGroup","CurrentTestCaseData")
 strExpectedComorbidGroupDep  = DataTable.Value("ExpectedComorbidGroupDep","CurrentTestCaseData")
 strComorbidMessage = DataTable.Value("ComorbidMessage","CurrentTestCaseData")
 strErrorPopupTitle = DataTable.Value("ErrorPopupTitle","CurrentTestCaseData")
 strErrorPopupText = DataTable.Value("ErrorPopupText","CurrentTestCaseData")
 


'=====================================
' Objects required for test execution
'=====================================
 Execute "Set objComorbidHistoryExpandIcon = "  &Environment("WI_ComorbidHistoryExpand_Icon")
 Execute "Set objComorbidHistoryTableHeader = "  &Environment("WT_ComorbidHistoryTableHeader")
 Execute "Set objAscendingOrderIcon = "  &Environment("WEL_TableAscendingOrder_Icon")
 Execute "Set objComplaintsAddButton = " & Environment("WB_Comorbid_Complaints_AddButton")
 Execute "Set objComplaintsList = " & Environment("WEL_Comorbid_ActiveComplaintsList")
 Execute "Set objComplaintsHistory =" & Environment("WEL_Comorbid_ComplaintsHistory")
 Execute "Set objComplaintHistoryTable =" & Environment("WEL_Comorbid_ComplaintsHistoryTable")
 Execute "Set objEditComplaintIcon = " & Environment("WI_Comorbid_EditIcon")
 Execute "Set objDeleteComplaintIcon = " & Environment("WI_Comorbid_DeleteIcon")
 Execute "Set objComorbidGroup = " & Environment("WE_ComorbidGroup")
 Execute "Set objComorbidListTable = " & Environment("WB_ComorbidListTable")

'=====================================
' start test execution
'=====================================
'Login to Capella

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHES role")

'Close all open patient     
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'Select user roster
isPass = SelectUserRoster(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'==============================
'Open patient from action item
'==============================
strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	Call WriteToLog("Fail", "selectPatientFromGlobalSearch return: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

wait 2
waitTillLoads "Loading..."
wait 2

'==============================
'Navigate to comorbids screen
'==============================
Call clickOnSubMenu("Clinical Management->Comorbids")

wait 2
waitTillLoads "Loading..."
wait 2

'=====================================
'Click on comorbid history expand icon
'=====================================

blnReturnValue = ClickButton("Comorbids History Expand Icon",objComorbidHistoryExpandIcon,strOutErrorDesc) 'Click on comorbid history expand icon
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton returned error: "&strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'=======================================================================================================================
'Verify the coulumn header should be in sequence of a. Comorbid Type, b. Comorbid Group c. Reported Date , d. Onset Date
'=======================================================================================================================
If CheckObjectExistence(objComorbidHistoryTableHeader,intWaitTime) Then
	strActualComorbidHistoryTableHeader = objComorbidHistoryTableHeader.GetROProperty("column names")
	arrActualComorbidHistoryTableHeader = Split(strActualComorbidHistoryTableHeader,";")
	
	'=========================================================================
	'Verify that comorbid history table should contain the columns more than 0
	'=========================================================================
	If Ubound(arrActualComorbidHistoryTableHeader) < 0 Then
		Call WriteToLog("Fail","Comorbid history table does not contain the column header seprated by ;")
		Call WriteLogFooter()
		ExitAction	
	End If
	
	'=========================================================
	'Verify the expetecd column and actual column are the same
	'=========================================================
	For i = 0 To Ubound(arrExpectedComorbidHitoryColumnNames) Step 1
		If StrComp(arrExpectedComorbidHitoryColumnNames(i),arrActualComorbidHistoryTableHeader(i),1) = 0 Then
			Call WriteToLog("Pass","Default position of column "& arrActualComorbidHistoryTableHeader(i) & " is as expected")
		Else
			Call WriteToLog("Fail","Default position of column "& arrActualComorbidHistoryTableHeader(i) & " is not as expected and the correct column at thic position should be "& arrExpectedComorbidHitoryColumnNames(i))
			Call WriteLogFooter()
			ExitAction		
		End If
	Next
Else
	Call WriteToLog("Fail","Comorbid history table header does not exist")
	Call WriteLogFooter()
	ExitAction	
End If

'======================================================================
'Verify that the user should be able to click on all column headers.
'======================================================================
For i = 1 To objComorbidHistoryTableHeader.GetROProperty("cols") Step 1
	Set objComorbidHistoryTableHeaderLink = objComorbidHistoryTableHeader.ChildItem(1, i, "Link", 0)
	If objComorbidHistoryTableHeaderLink.Exist(intWaitTime) Then
		Err.Clear
		objComorbidHistoryTableHeaderLink.Click
		If Err.Number > 0 Then
			Call WriteToLog("Fail", i & " column is not clickable") 	
		End If
		
		'==================================================================================
		'Verify that ascending order icon should be present after clicking on Column header
		'==================================================================================

		If objAscendingOrderIcon.Exist(intWaitTime) Then
			Call WriteToLog("Pass","User is able to click on column "&arrActualComorbidHistoryTableHeader(i-1)&" successfully")
		Else
			Call WriteToLog("Fail","User is not able to click on column "&arrActualComorbidHistoryTableHeader(i-1))		
		End If
	Else
		Call WriteToLog("Fail","Comorbid history column header does not exist for column: "&i)		
	End If
Next

'Click on comorbid history expand icon
blnReturnValue = ClickButton("Comorbids History Expand Icon",objComorbidHistoryExpandIcon,strOutErrorDesc) 

'***********************
'Complaints list
'***********************

'=======================================================
'Verify that Add button exist in Complaints list
'=======================================================
If CheckObjectExistence(objComplaintsAddButton,intWaitTime/2) Then
	Call WriteToLog("Pass","Add button exist in complaints list")
Else
	Call WriteToLog("Fail","Add button does not exist in complaints list")
	Call WriteLogFooter()
	ExitAction
End If

'========================================================================================
'Verify that Comorbid screen should contain Complaint List with active complaints count
'========================================================================================
If CheckObjectExistence(objComplaintsList,intWaitTime) Then
	
	Call WriteToLog("Pass","Complaints List exist on comorbids screen")
	
	'==================================
	'Verify the active Complaints count
	'==================================
	strComplaintsList = objComplaintsList.GetROProperty("innertext")
	arrComplaintsList = Split(strComplaintsList,"(")
	intActiveComplaints = Split(arrComplaintsList(1),")")
	
	If IsNumeric(intActiveComplaints(0)) Then
		Call WriteToLog("Pass","Complaints list has "&Trim(intActiveComplaints(0))&" active complaints")
	Else	
		Call WriteToLog("Fail","Complaints list has not inactive complaints in numeric value")
		Logout
		Closeallbrowsers
		Call WriteLogFooter()
		ExitAction
	End If
Else
	Call WriteToLog("Fail","Complaints List does not exist on comorbids screen")
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction
End If

'================================================================================================
'Verify that Complaints History widget is in Collapse mode with inactive complaints history count
'================================================================================================
If CheckObjectExistence(objComplaintsHistory,intWaitTime/2) and not CheckObjectExistence(objComplaintHistoryTable,intWaitTime/2) Then
	Call WriteToLog("Pass","Complaints history widget is in collapse mode.")
	
	'============================
	'Verify the inactive count
	'============================
	strComplaintsHistory = objComplaintsHistory.GetROProperty("innertext")
	arrComplaintsHitory = Split(strComplaintsHistory,"(")
	intInactiveComplaints = Split(arrComplaintsHitory(1),")")
	
	If IsNumeric(intInactiveComplaints(0)) Then
		Call WriteToLog("Pass","Complaints history has "&intInactiveComplaints(0)&" inactive complaints")
	Else	
		Call WriteToLog("Fail","Complaints history has not inactive complaints in numeric value")
		Logout
		Closeallbrowsers
		Call WriteLogFooter()
		ExitAction
	End If
Else
	Call WriteToLog("Fail","Complaints history widget is not in collapse mode.")
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction
End If

'=================================================================================================================================
'Verify that on Click of Add button, New blank Note should be  displayed in Complaints widget  with Date , Save and cancel button.
'==================================================================================================================================
blnReturnValue = ClickButton("Add",objComplaintsAddButton,strOutErrorDesc)
If not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction	
End If	

'===================================================================
'Verify the component of new note eg - Date, Save and Cancel
'===================================================================
blnReturnValue = VerifyNewNoteComponentForComplaintsList(strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","New blank Note is getting displayed in Complaints widget with Date,Save and cancel button.")
Else
	Call WriteToLog("Fail","VerifyNewNoteComponentForComplaintsList returned: "&strOutErrorDesc)
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction		
End If

'=========================================================================
'Add complaint to the active complaints list if complaint are less than 2
'=========================================================================
Set objExpandActiveComplaintsIcon = GetChildObject("micclass;html tag;innertext","WebElement;SPAN;►")
If objExpandActiveComplaintsIcon.Count <=4 Then
	For i = 0 To 4- objExpandActiveComplaintsIcon.Count Step 1
		blnReturnValue = AddComplaintsToComorbids(strComplaintTitle,strComplaintDescription,strOutErrorDesc)
		If blnReturnValue Then
			Call WriteToLog("Pass","Complaint is Added succcessfully")
		Else
			Call WriteToLog("Fail","AddComplaintsToComorbids returns: "&strOutErrorDesc)
			Logout
			Closeallbrowsers
			Call WriteLogFooter()
			ExitAction
		End If
	Next
End If

'================================================
'Edit the Complaint from active complaints list
'=================================================
Set objExpandActiveComplaintsIcon = GetChildObject("micclass;html tag;innertext","WebElement;SPAN;►")
For i = 0 To objExpandActiveComplaintsIcon.Count -1  Step 1
	If objExpandActiveComplaintsIcon(i).Exist(2) Then
		Err.Clear
		'========================================
		'Click on expand of first complaints icon
		'========================================
		objExpandActiveComplaintsIcon(i).Click
		Wait intWaitTime/2
		If Err.Number = 0 Then
			Call WriteToLog("Pass",i+1&" Complaint expand icon click successfully")
			Wait intWaitTime/2
		Else
			Call WriteToLog("Fail","Complaint expand icon does not click successfully. Error Returned: "&Err.Description)
			Call WriteLogFooter()
			ExitAction		
		End If
		
		'===============================================================
		'Verify that edit complaints icon exist and clicked successfully
		'===============================================================
		If CheckObjectExistence(objEditComplaintIcon,intWaitTime/2) Then
			Call WriteToLog("Pass",i+1&" Edit complaints icon exist")
			
			'==================================
			'Click on Edit complaints button
			'==================================
			Err.Clear
			objEditComplaintIcon.Click
			If Err.Number = 0 Then
				Call WriteToLog("Pass",i+1&" Edit complaints icon click successfully")
			Else
				Call WriteToLog("Fail","Edit complaints icon does not click successfully. Error Returned: "&Err.Description)
				Logout
				Closeallbrowsers
				Call WriteLogFooter()
				ExitAction		
			End If 
		Else
			Call WriteToLog("Fail","Edit complaints icon does not exist")
			Call WriteLogFooter()
			ExitAction	
		End If
	Else
		Call WriteToLog("Fail","Complaint expand icon does not exist")
		Logout
		Closeallbrowsers
		Call WriteLogFooter()
		ExitAction	
	End If
Next

'=========================
'Edit title of complaint
'=========================
Set objComplaintsTitle = GetChildObject("class;html tag;value","complaint_title_div complaint-textbox.*;DIV;"&strComplaintTitle)
For j = 0 To objComplaintsTitle.Count-1 Step 1
	If objComplaintsTitle(j).Exist(10) Then
	objComplaintsTitle(j).Set strChangeComplaintTitle
	
		'Verify that complaint title changed set successfully
		strChangesTitle = objComplaintsTitle(j).GetROProperty("innertext")
		If StrComp(strChangesTitle,strChangeComplaintTitle,vbTextCompare) = 0 Then
			Call WriteToLog("Pass","Complaints title changed successfully")
		Else
			Call WriteToLog("Fail","Complaints title does not changed successfully")
		End If
	Else
		Call WriteToLog("Fail","Complaints title edit field does not exist")
		Logout
		Closeallbrowsers
		Call WriteLogFooter()
		ExitAction		
	End If
Next

'==============================	
'Edit description to complaints
'==============================
Set objComplaintsDescription = GetChildObject("class;html tag;value","complaint_detail_div complaint-textbox.*;DIV;"&strComplaintDescription)
For k = 0 To objComplaintsDescription.Count-1 Step 1
	If objComplaintsDescription(k).Exist(10) Then
		objComplaintsDescription(k).Set strChangeComplaintDescription
		
		'Verify that complaint description changed set successfully
		strChangeDescription = objComplaintsDescription(k).GetROProperty("innertext")
		If StrComp(strChangeDescription,strChangeComplaintDescription,vbTextCompare) = 0 Then
			Call WriteToLog("Pass","Complaints description changed successfully")
		Else
			Call WriteToLog("Fail","Complaints description does not changed successfully")
		End If
	Else
		Call WriteToLog("Fail","Complaints description edit field does not exist")
		Logout
		Closeallbrowsers
		Call WriteLogFooter()
		ExitAction		
	End If
Next

'=====================
'Click on save button
'=====================
Set objSaveButton = GetChildObject("html tag;outerhtml","IMG;.*Complaints List.*")
'Set objSaveButton = GetChildObject("micclass;title","Image;Save Complaint")
For i = 0 To objSaveButton.Count - 1 Step 1
	If objSaveButton(i).Exist(10) Then
		objSaveButton(i).Click
		Wait 1
	Else
		Call WriteToLog("Fail","Save complaints button does not exist in complain list section")
		Logout
		Closeallbrowsers
		Call WriteLogFooter()
		ExitAction		
	End If
Next

'===============================================================================================================================
'Verify that Complaints from complaints list is not deleted and complaints History inactive count is not increased or decreased
'===============================================================================================================================
intInactiveComplaints = GetCountOfInactiveComplaints(strOutErrorDesc)
If not IsNumeric(intInactiveComplaints) Then
	Call WriteToLog("Fail","Function GetCountOfInactiveComplaints returns: "&strOurErrorDesc)
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction
End If
	
'=========================================================================
'Verify that Delete complaints icon exist and clicked successfully
'=========================================================================
	'Delete the Complaint from active complaints list
	Set objComplaintsItems = GetChildObject("micclass;html tag;class","WebElement;LI;.*listItemOfComplaint.*")
	Set objExpandActiveComplaintsIcon = GetChildObject("micclass;html tag;innertext","WebElement;SPAN;►")
	For i = 0 To objComplaintsItems.count-1 Step 1

        strComplaintsText = objComplaintsItems(i).GetROProperty("innertext")
		If InStr(1,strComplaintsText,strChangeComplaintTitle,1) > 0 Then
			
			If objExpandActiveComplaintsIcon(i).Exist(2) Then
				Err.Clear
				'Click on expand of first complaints icon
				objExpandActiveComplaintsIcon(i).Click
				If Err.Number = 0 Then
					Call WriteToLog("Pass","Complaint expand icon click successfully")
				Else
					strOutErrorDesc = "Complaint expand icon does not click successfully"
				End If
			Else
				strOutErrorDesc = "Complaint expand icon does not exist"
			End If
			
			'Delete complaints icon exist and clicked successfully
			Set objDeleteComplaintIcon = GetChildObject("micclass;class;file name;html tag","Image;.*complainListIcons.*;icon_vh_closeSmall\.png;IMG")
			blnReturnValue = objDeleteComplaintIcon(0).Exist
			If blnReturnValue Then
				Call WriteToLog("Pass","Delete complaints icon exist")	
				Err.Clear
				
				'Click on Delete complaints button
				objDeleteComplaintIcon(0).Click
				If Err.Number = 0 Then
					Call WriteToLog("Pass","Delete complaints icon click successfully")
				Else
					strOutErrorDesc = "Delete complaints icon does not click successfully"
				End If 
			Else
				strOutErrorDesc = "Delete complaints icon does not exist"
			End If
			
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			
			Call clickOnComorbidsMessageBox("Comorbids", "Yes", "Are you sure", strOutErrorDesc)
			
			Exit For 
		End If
				
	Next 


'=================================================
'Verify that complaints items deleted successfully
'=================================================
Set objComplaintsItems = GetChildObject("micclass;html tag;class","WebElement;LI;.*listItemOfComplaint.*")
If objComplaintsItems.Count = 0 Then
	Call WriteToLog("Pass","Complaint item deleted successfully")
Elseif	objComplaintsItems.Count > 0 Then
	For i = 0 To objComplaintsItems.Count-1 Step 1
		strComplaintsText = objComplaintsItems(i).GetROProperty("innertext")
		If InStr(1,strComplaintsText,strChangeComplaintTitle,1) > 0 Then
			Call WriteToLog("Pass","Complaint item deleted successfully")
		Else
			Call WriteToLog("Fail","Complaint item not deleted successfully")
			Logout
			Closeallbrowsers
			Call WriteLogFooter()
			ExitAction			
		End If
	Next
End If

intInactiveComplaintsNow = GetCountOfInactiveComplaints(strOutErrorDesc)
If Not IsNumeric(intInactiveComplaintsNow) Then
	Call WriteToLog("Fail","Function GetCountOfInactiveComplaints returns: "&strOutErrorDesc)
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction
End If

'verify the inactive count which has increased

If intInactiveComplaints = intInactiveComplaintsNow Then
	Call WriteToLog("Fail","Complaints history inactive count is changed from "& intInactiveComplaints&" to "& intInactiveComplaintsNow)
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction
Else	
	Call WriteToLog("Pass","Complaints history inactive count is not changed")
End If

'****************************************************************************************************************************************************************
'verify that  data in Complaint History should get filtered in ascending or descending order by filtering following columns: a. Date b. Title c. Complaint
'****************************************************************************************************************************************************************

'Click on Complaint history section to open it
blnReturnValue = ClickButton("Complaint History section",objComplaintsHistory,strOutErrorDesc)
If Not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton return error: "&strOutErrorDesc)
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction
End If	

'===========================================
'Verify that Complaint history is expandible
'===========================================
If objComplaintsHistory.Exist(3) and objComplaintHistoryTable.Exist(3)Then
	Call WriteToLog("Pass","Complaints history widget can be expanded")
Else
	Call WriteToLog("Fail","Complaints history widget can not be expanded")
	Logout
	Closeallbrowsers
	Call WriteLogFooter()
	ExitAction
End If

'===============================================
'Get the column count of Complants history table
'==============================================
Set odesc = description.create
odesc("micclass").value = "WebTable"
Set objTables = objComplaintHistoryTable.ChildObjects(odesc)
intNoOfColumns = objTables(0).GetROProperty("cols")

'intNoOfColumns = objComplaintHistoryTable.GetROProperty("cols")
strCoulumnNameToCheckAscDescOrder = DataTable.Value("ColumnNameToCheckAscDescOrder","CurrentTestCaseData")
arrCoulumnNameToCheckAscDescOrder = Split(strCoulumnNameToCheckAscDescOrder,";")

'==========================================================
'Identifying the column number of Complaints history table
'==========================================================
For intColumnNumber= 1 To intNoOfColumns Step 1
	strColumnHeader = objTables(0).GetCellData(1,intColumnNumber)
	If strColumnHeader = arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1) Then
		set strColumnHeaderName = objTables(0).ChildItem(1,intColumnNumber,"Link",0)
		If strColumnHeaderName.Exist(3) Then
			Err.clear
			strColumnHeaderName.click	 
			If Err.Number = 0 Then
				Call WriteToLog("Pass","Select(Click on) "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1)&" column")
			Else
				Call WriteToLog("Fail","Select(Click on) "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1)&" column. Error returned: "&Err.Description)
				Logout
				Closeallbrowsers
				Call WriteLogFooter()
				ExitAction
			End If
		Else
			Call WriteToLog("Fail","Object creation for "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1)&" Column")
		End If
		
		'=========================================================================
		'An up arrow should be displayed while sorting the data in ascending order.
		'=========================================================================
		Execute "Set objComplaintsHistoryColumnNameUp = " & Environment("WE_TableAscendingOrder_Icon")
		Execute "Set objComplaintsHistoryColumnNameDown = " & Environment("WE_TableDescendingOrder_Icon")
		
		If objComplaintsHistoryColumnNameUp.Exist(5) Then
			Call WriteToLog("Pass","An up arrow is displayed while sorting the  data in ascending order for column: "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1))
		Else
			Call WriteToLog("Fail","An up arrow is not displayed while sorting the  data in ascending order for column: "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1))
			Logout
			Closeallbrowsers
			Call WriteLogFooter()	
		End If
		
		'====================================
		'Select(Click on) status column again
		'====================================
		set strColumnHeaderName = objTables(0).ChildItem(1,intColumnNumber,"Link",0)
		If strColumnHeaderName.Exist(3) Then
			Err.clear
			strColumnHeaderName.click	 
			If Err.Number = 0 Then
				Call WriteToLog("Pass","Select(Click on) "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1)&" column again")
			Else
				Call WriteToLog("Fail","Select(Click on) "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1)&" column again. Error returned: "&Err.Description)
				Logout
				Closeallbrowsers
				Call WriteLogFooter()
			End If
		Else
			Call WriteToLog("Fail","Object creation for "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1)&" Column")
		End If
		'============================================================================
		'Down  arrow should be displayed while sorting the  data in descending order.
		'=============================================================================
		If objComplaintsHistoryColumnNameDown.Exist(5) Then
			Call WriteToLog("Pass","Down  arrow is displayed while sorting the  data in descending order for column: "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1))
		Else
			Call WriteToLog("Fail","Down  arrow is not displayed while sorting the  data in descending order for column: "&arrCoulumnNameToCheckAscDescOrder(intColumnNumber-1))
			Logout
			Closeallbrowsers
			Call WriteLogFooter()
			ExitAction			
		End If	
	End If
Next

'Collapse the complaints history widget
blnReturnValue = ClickButton("Complaint History section",objComplaintsHistory,strOutErrorDesc)


'***********************************************************
'Comorbids list
'***********************************************************

'==============================
'Add new Comorbid type
'=============================
Call WriteToLog("info", "Test Case - Add a new Comorbid and verify")

'before adding deactivate the comorbid if it already exists
Execute "Set objComorbidListTable = " & Environment("WB_ComorbidListTable")
maxRows = CInt(objComorbidListTable.getROproperty("rows"))

For row = 1 To maxRows
	cType = objComorbidListTable.GetCellData(row, 1)
	If strComorbidType = trim(cType) Then
		isPass = deactivateComorbid(strComorbidType, row)
		If Not isPass Then
			Logout
			closeAllBrowsers
			WriteLogFooter
			ExitAction
		End If
	End If
Next

Execute "Set objAddButton = " & Environment("WB_ComorbidDetailsAdd")
objAddButton.Click

wait 2
Call waitTillLoads("Loading...")


Dim reqComorbid

Execute "Set objComorbidType = " & Environment("WB_ComorbidType")
Call selectComboBoxItem(objComorbidType, strComorbidType)
reqComorbid = strComorbidType	'"Asthma"

Execute "Set objProvider = " & Environment("WB_ComorbidProvider")
Call selectComboBoxItem(objProvider, strProvider)


wait 2

Execute "Set objSaveButton = " & Environment("WB_ComorbidDetailsSave")
objSaveButton.Click

wait 2
Call waitTillLoads("Loading...")

Execute "Set objComorbidListTable = " & Environment("WB_ComorbidListTable")

If not waitUntilExist(objComorbidListTable,10) Then
	
End If
Dim tabVal
tabVal = objComorbidListTable.getCellData(1, 1)
If trim(tabVal) = reqComorbid then
	Call WriteToLog("Pass", "The comorbid type'" & reqComorbid & "'is added")
Else
	Call WriteToLog("Fail", "The comorbid type" & reqComorbid & "' was not added, but the value in table is - '" & tabVal & "'")
	Logout
	Closeallbrowsers
	writelogfooter
	ExitAction
End If

'	Verify the comorbids group
strComorbidGroup = 	objComorbidListTable.getCellData(1, 2)	'objComorbidGroup.GetROProperty("innertext")
If StrComp(strComorbidGroup,strExpectedComorbidGroup,vbTextCompare) = 0 Then
	Call WriteToLog("Pass","Comorbids group displayed is correct")
Else
	Call WriteToLog("Fail","Comorbids group displayed is not correct")
End If

'================================================================
'Verify the text message when you select Comorbid type depression
'================================================================
Call WriteToLog("info", "Test Case - Add Comorbid Depression and verify the text message below comorbid type")

Execute "Set objAddButton = " & Environment("WB_ComorbidDetailsAdd")
objAddButton.Click

wait 2
Call waitTillLoads("Loading...")

Execute "Set objComorbidType = " & Environment("WB_ComorbidType")
Call selectComboBoxItem(objComorbidType, strComorbidTypeDepression)

wait 2
'Verify the message displayed when depression is selected as the comorbids type
Execute "Set objComorbidMessage = " & Environment("WB_ComorbidMessage")
strMessage = objComorbidMessage.GetROProperty("innertext")

If StrComp(strMessage, StrComorbidMessage, vbTextCompare) = 0 Then
	Call WriteToLog("Pass","Comorbids Message displayed for Depression is correct")
Else
	Call WriteToLog("Fail","Comorbids Message displayed for Depression is not correct")
	Logout
	Closeallbrowsers
	writelogfooter
	ExitAction
End If

wait 2
	
'Verify the Comorbids group for Depression comorbid type
Execute "Set objComorbidGroup = " & Environment("WE_ComorbidGroup")
strComorbidGroup = objComorbidGroup.GetROProperty("innertext")
If StrComp(strComorbidGroup,strExpectedComorbidGroupDep,vbTextCompare) = 0 Then
	Call WriteToLog("Pass","Comorbids group displayed is correct")
Else
	Call WriteToLog("Fail","Comorbids group displayed is not correct")
End If

Execute "Set objCancelButton = " & Environment("WB_ComorbidDetailsCancel")
objCancelButton.Click

'================================
'Add the same Comorbid type again
'================================
Call WriteToLog("info", "Test Case - Add the same comorbid and verify the error")


Execute "Set objAddButton = " & Environment("WB_ComorbidDetailsAdd")
objAddButton.Click

wait 2
Call waitTillLoads("Loading...")

Execute "Set objComorbidType = " & Environment("WB_ComorbidType")
Call selectComboBoxItem(objComorbidType, strComorbidType)
reqComorbid = strComorbidType	'"Asthma"

Execute "Set objProvider = " & Environment("WB_ComorbidProvider")
Call selectComboBoxItem(objProvider, strProvider)


wait 2

Execute "Set objSaveButton = " & Environment("WB_ComorbidDetailsSave")
objSaveButton.Click

wait 2
waitTillLoads "Saving..."
wait 2
	
'========================
'Validate the error popup
'=========================

blnReturnValue = clickOnMessageBox(strErrorPopupTitle, "OK", strErrorPopupText, strOutErrorDesc)
If blnReturnValue Then
	Call WriteToLog("Pass","Popup with title: "&strErrorPopupTitle& " and stating message: "&strErrorPopupText&" was displayed")
Else
	Call WriteToLog("Fail","Popup with title: "&strErrorPopupTitle& " and stating message: "&strErrorPopupText&" was not found")
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

wait 2
waitTillLoads "Saving..."
wait 2

'===================================
'Validate the active comorbids count
'===================================

Set objHeader = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("class:=row displayComorbidsRows headingDisplayComorbids")

Set oDesc = Description.Create
oDesc("micclass").Value = "WebElement"
oDesc("class").Value = "comorbidSectionsListCount.*"

Set objActiveCount = objHeader.ChildObjects(oDesc)
strActiveComorbidCount = objActiveCount(0).getROProperty("innertext")
intActiveComorbidCount = cint(strActiveComorbidCount)

Set objActiveCount = Nothing
Set objHeader = Nothing
Set oDesc = Nothing


Dim intComorbidsTableCount

intComorbidsTableCount = objComorbidListTable.RowCount
	
If intActiveComorbidCount = intComorbidsTableCount Then
	Call WriteToLog("Pass","Active comorbids count is "&intComorbidsTableCount&"")	
Else
	Call WriteToLog("Fail","Comorbids count does not match")
	Logout
	CloseAllBrowsers
 	Call WriteLogFooter()
	ExitAction
End If
	
'======================	
'Delete added comorbid
'======================
Dim reqReportDate
Execute "Set objComorbidListTable = " & Environment("WB_ComorbidListTable")
maxRows = CInt(objComorbidListTable.getROproperty("rows"))

For row = 1 To maxRows
	cType = objComorbidListTable.GetCellData(row, 1)
	If strComorbidType = trim(cType) Then
		reqReportDate = objComorbidListTable.GetCellData(row,4)
		isPass = deactivateComorbid(strComorbidType, row)
		If Not isPass Then
			Logout
			closeAllBrowsers
			WriteLogFooter
			ExitAction
		End If
	End If
Next

'============================================================================
'Validate the active and inactive comorbids count after deleting the comorbid
'============================================================================
Call WriteToLog("info", "Test Case - Validate the active and inactive comorbids count after deleting the comorbid")

Set objHeader = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("class:=row displayComorbidsRows headingDisplayComorbids")

Set oDesc = Description.Create
oDesc("micclass").Value = "WebElement"
oDesc("class").Value = "comorbidSectionsListCount.*"

Set objActiveCount = objHeader.ChildObjects(oDesc)
objActiveCount(0).highlight
strActiveComorbidCount2 = objActiveCount(0).getROProperty("innertext")
intActiveComorbidCount2 = cint(strActiveComorbidCount2)

Set objActiveCount = Nothing
Set objHeader = Nothing
Set oDesc = Nothing

'intComorbidsTableCount2 = objComorbidListTable.RowCount
If intActiveComorbidCount2 < intActiveComorbidCount Then
	Call WriteToLog("Pass","Active comorbids count after deleting the comorbid is "&intActiveComorbidCount2&" from "&intActiveComorbidCount&"")	
Else
	Call WriteToLog("Fail","Comorbids count does not match")
	Logout
	CloseAllBrowsers
 	Call WriteLogFooter()
	ExitAction
End If

'============================
'Verify the inactive count
'============================
Execute "set objComorbidHistory = " & Environment("WE_Comorbid_ComorbidHistory")
strComorbidHistory = objComorbidHistory.GetROProperty("innertext")
arrComorbidHitory = Split(strComorbidHistory,"(")
intInactiveComorbid = Split(arrComorbidHitory(1),")")

If IsNumeric(intInactiveComorbid(0)) Then
	Call WriteToLog("Pass","Comorbid history has "&intInactiveComorbid(0)&" inactive comorbids")
Else	
	Call WriteToLog("Fail","Comorbid history has not inactive complaints in numeric value")
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

On Error Resume Next
Err.Clear

reqComorbidType = reqComorbid
'reqReportDate = "02/16/2016"

Set objTable = getPageObject().WebTable("class:=k-selectable", "cols:=4")
maxRows = CInt(objTable.getroproperty("rows"))

Dim isFound : isFound = false
For row = 1 to maxRows
	cType = objTable.GetCellData(row, 1)
	reportDate = objTable.GetCellData(row, 3)
	
	If trim(cType) = reqComorbidType and CDate(reportDate) = CDate(reqReportDate) Then
		isFound = true
		Exit For
	End If
Next

If isFound Then
	Call WriteToLog("Pass", "Recently deactivated comorbid is found in the Comorbid History table")
Else
	Call WriteToLog("Fail", "Recently deactivated comorbid is NOT found in the Comorbid History table")
End If

On Error Resume Next
Err.Clear
'validate review functionality
Call WriteToLog("info", "Test Case - validate review functionality")
Set objPage = getPageObject()

Set objReviewAddButton = objPage.WebButton("outerhtml:=.*data-capella-automation-id=""_Add"".*", "html id:=lastComorbidBtn")	'"class:=btn btn-success.*",

If CheckObjectExistence(objReviewAddButton, 10) Then
	Call writeToLog("Pass", "The Review Add button exists")
Else
	Call writeToLog("Fail", "The Review Add button does not exist as expected")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If
Err.Clear
Set objLastReview = objPage.WebElement("html tag:=SPAN", "innertext:=.*Last Comorbid Review.*")
If CheckObjectExistence(objLastReview, 10) Then
	Call writeToLog("Pass", "The Last Comorbid Review text exists")
Else
	Call writeToLog("Fail", "The Last Comorbid Review text does not exist as expected")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If

x = objPage.WebElement("class:=.*", "html tag:=SPAN", "outertext:=None.*").GetROProperty("outertext")
If len(x) > 5 Then
	revDate = mid(x, 5)
	Call writeToLog("Pass", "Its already reviewed on - " & revDate)
else
	Call writeToLog("Pass", "It is not yet reviewed.")
End If

objReviewAddButton.Click

wait 1
waitTillLoads "Loading..."
wait 1

Set objComorbidReviewTitle = objPage.WebElement("class:=title-gradient.*", "outertext:=.*Comorbid Review.*", "html tag:=DIV")
If CheckObjectExistence(objComorbidReviewTitle, 10) Then
	Call writeToLog("Pass", "The Last Comorbid Review text exists")
Else
	Call writeToLog("Fail", "The Last Comorbid Review text does not exist as expected")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If
objComorbidReviewTitle.highlight

Set objComrbidRevMsgBox = objPage.WebElement("class:=popup-grad.*")
objComrbidRevMsgBox.highlight
Set objCalEdit = objComrbidRevMsgBox.WebEdit("class:=form-control.*", "html id:=cal")
objCalEdit.Set date - 7
Set objCalEdit = Nothing
objComrbidRevMsgBox.WebElement("class:=btn btn-success.*", "html tag:=DIV", "outertext:= Save").Click
Set objComrbidRevMsgBox = Nothing


wait 2
waitTillLoads "Loading..."
wait 2

x = objPage.WebElement("class:=ng-binding.*", "html tag:=SPAN", "outertext:=None.*").GetROProperty("outertext")
If len(x) > 5 Then
	revDate = mid(x, 5)
	Call writeToLog("Pass","Comorbid review is done on " & revDate)
else
	Call writeToLog("False","Comorbid review is done on " & revDate)
End If

Set objComorbidReviewTitle = Nothing
Set objLastReview = Nothing
Set objReviewAddButton = Nothing
Set objPage = Nothing

'logout of the application
Logout()
CloseAllBrowsers
'kill all the used objects.
killAllObjects
Call WriteLogFooter()

Function killAllObjects()

	Execute "Set objPage = Nothing"
	Execute "Set objReviewOrder = Nothing"
	Execute "Set objSelectTable = Nothing"
	Execute "Set objDateRequested = Nothing"   
	Execute "Set objMaterialFulfillmentTitle = Nothing" 
	Execute "Set objCompleteOrder= Nothing"
	Execute "Set objDateFulfilled= Nothing"
	Execute "Set objDomainDropDown= Nothing"
	Execute "Set objFulfilledBy= Nothing"
	Execute "Set objFollowUpNO= Nothing"
	Execute "Set objFollowUpYES=  Nothing"
	
End Function


Function deactivateComorbid(ByVal strComorbidType, ByVal rowNum)
	
	deactivateComorbid = false
	objComorbidListTable.ChildItem(rowNum, 6, "WebElement", 0).click
	
	wait 1
	waitTillLoads "Loading..."
	wait 1
	
	blnReturnValue = checkForPopup("Comorbids", "Yes", "Are you sure you want to deactivate this Comorbid?", strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Comorbid " & strComorbidType & " is deleted")
	Else
		Call WriteToLog("Fail","Unable to delete the comorbid " & strComorbidType)
		Exit Function
	End If
	
	wait 1
	waitTillLoads "Loading..."
	wait 1
	
	deactivateComorbid = true
	
End Function
