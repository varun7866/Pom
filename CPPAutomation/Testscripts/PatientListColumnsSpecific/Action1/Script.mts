 '**************************************************************************************************************************************************************************
' TestCase Name			: PatientListColumnsSpecific
' Purpose of TC			: Validate Last Completed and Last Attempted columns in Patient list grid for patients who need not require additon of new contact method,
'						: Sorting of contact date fields in Patient list grid
' Author                : Gregory
' Date                  : 08 July 2015
' Date Modified			: 08 October 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04753
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PatientListColumnsSpecific", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'-----------------------------------------------------------------
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)

'------------------------
' Variable initialization
'------------------------
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
intPatientListColCount = DataTable.Value("PatientListColCount","CurrentTestCaseData") '4
intPatientListNameCol = DataTable.Value("PatientListNameCol","CurrentTestCaseData") '3
intLastAttemptedColumnNumber = DataTable.Value("LastAttemptedColumnNumber","CurrentTestCaseData") '12
intLastCompletedColumnNumber = DataTable.Value("LastCompletedColumnNumber","CurrentTestCaseData") '13
dtExistingContactAttemptedDate = DataTable.Value("ExistingContactAttemptedDate","CurrentTestCaseData")
dtExistingContactAttemptedDate = Split(dtExistingContactAttemptedDate," ",-1,1)(0)
If LCase(Trim(dtExistingContactAttemptedDate)) = "na" Then
	dtExistingContactAttemptedDate = DateFormat(Date)	
End If
dtExistingContactCompletedDate = DataTable.Value("ExistingContactCompletedDate","CurrentTestCaseData") 
dtExistingContactCompletedDate = Split(dtExistingContactCompletedDate," ",-1,1)(0)
If LCase(Trim(dtExistingContactCompletedDate)) = "na" Then
	dtExistingContactCompletedDate = DateFormat(Date)	
End If
strAnyPreviousContacts = DataTable.Value("AnyPreviousContacts","CurrentTestCaseData")
strReopenedWithin90daysOfTermination = DataTable.Value("ReopenedWithin90daysOfTermination","CurrentTestCaseData")
strReopenedAfter90daysOfTermination = DataTable.Value("ReopenedAfter90daysOfTermination","CurrentTestCaseData")

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage ="&Environment("WPG_AppParent")	'page object
Execute "Set objMyPatientsMajorTab ="&Environment("WL_MyPatientsMajorTab") 'MyPatients tab
Execute "Set objMyPatientsMainTab = "&Environment("WL_MyPatientsMainTab") 'My Patients tab
Execute "Set objLADColHeader = "&Environment("WL_LADColHeader") ' Last Attempted Contact date header
Execute "Set objLCDColHeader = "&Environment("WL_LCDColHeader") ' Last Completed Contact date header
Execute "Set objPatientListGridTableRight = "&Environment("WT_PatientListGridTableRight") 'PatientList Grid TableRight side
Execute "Set objPageCCM ="&Environment("WPG_AppParent")	'page object
Execute "Set objCMExternalTeamdd ="&Environment("WB_CMExternalTeamdd") 'Choose Contact Method External Team dropdown
Execute "Set objCMInternalTeamdd ="&Environment("WB_CMInternalTeamdd") 'Choose Contact Method Internal Team dropdown
Execute "Set objResolutionDD = " &Environment("WEL_ACMResolutionDD") 'Resolution

'Getting equired iterations
If not Lcase(strExecutionFlag) = "y" Then Exit Do
Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"'----------------") 

'variables in usable format
If dtExistingContactAttemptedDate <> "" Then
	dtExistingContactAttemptedDate = DateFormat(dtExistingContactAttemptedDate)
End If
If dtExistingContactCompletedDate <> "" Then
	dtExistingContactCompletedDate = DateFormat(dtExistingContactCompletedDate)
End If

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
Err.Clear

'-------------------------------
'Close all open patients from DB
Call closePatientsFromDB("vhn")
'-------------------------------

'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

Call WriteToLog("Info","----------------Validating contact date columns in 'Patient List' grid----------------") 
'Click on MyPatients Tab
objMyPatientsMajorTab.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click MyPatients Tab: "& Err.Description
	Call WriteToLog("Fail","Expected Result: Should be able to click MyPatients Tab. Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked MyPatients Tab")
wait 2

Call waitTillLoads("Loading...")
wait 2

Execute "Set objAllMyPatients ="&Environment("WB_AllMyPatients")
blnAllMyPatientsClicked = ClickButton("All My Patients",objAllMyPatients,strOutErrorDesc)
If not blnAllMyPatientsClicked Then
	Call WriteToLog("Fail","Expected Result: Should be able to click AllMyPatients button. Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked 'All My Patients' button")
Wait 2
Call waitTillLoads("Loading...")
wait 2
Execute "Set objAllMyPatients = Nothing"

intPatientListColCount = 4
intPatientListNameCol = 3

Set objPatientListTable = Nothing
Set objPatientListTable = objPage.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intPatientListColCount,"visible:=True")
intPatientListTableRowCount =  objPatientListTable.RowCount
strNameFromPatientList = Replace(strPatientName,".*","",1,-1,1)

For PLTablerows = 1 To intPatientListTableRowCount Step 1
	If Trim(objPatientListTable.GetCellData(PLTablerows,intPatientListNameCol)) = Trim(strNameFromPatientList) Then
		intPatientRowNumber = PLTablerows
		Exit For
	End If
Next

If intPatientRowNumber > 0 Then
	Call WriteToLog("Pass","Retrieved "&strNameFromPatientList&"'s position as in MyPatient's list")
Else
	Call WriteToLog("Fail","Expected Result: Should be able to retrieve '"&strNameFromPatientList&"'s position from 'MyPatient's list.  Actual Result: Unable to retrieve '"&strNameFromPatientList&"'s position from 'MyPatient's list")
	Call Terminator
End If

ReqdRowNumber = intPatientRowNumber

'Validation of dates
dtLADfromPatientGrid = Trim(objPatientListGridTableRight.ChildItem(intPatientRowNumber,intLastAttemptedColumnNumber,"WebElement",0).GetROProperty("outertext"))
dtLCDfromPatientGrid = Trim(objPatientListGridTableRight.ChildItem(intPatientRowNumber,intLastCompletedColumnNumber,"WebElement",0).GetROProperty("outertext"))

If Ucase(Trim(strAnyPreviousContacts)) = "NO" Then	
	dtExistingContactAttemptedDate = ""	
	dtExistingContactCompletedDate = ""
End If

If Ucase(Trim(strReopenedWithin90daysOfTermination)) = "NO" Then	
	dtExistingContactAttemptedDate = ""	
	dtExistingContactCompletedDate = ""
End If

If Ucase(Trim(strReopenedAfter90daysOfTermination)) = "YES" Then	
	dtExistingContactAttemptedDate = ""	
	dtExistingContactCompletedDate = ""
End If

If Trim(dtExistingContactAttemptedDate) = dtLADfromPatientGrid Then
	Call WriteToLog("Pass","'Last Attempted Contact' date is displayed in MyPatients grid based on filters and is in required format")
Else
	Call WriteToLog("Fail","Expected Result: 'Last Attempted Contact' date should be displayed in MyPatients grid based on filters and should be in required format.  Actual Result: Last Attempted Contact date is NOT displayed in MyPatients grid as expected")
	Call Terminator	
End If

If Trim(dtExistingContactCompletedDate) = dtLCDfromPatientGrid Then
	Call WriteToLog("Pass","'Last Completed Contact' date is displayed in MyPatients grid based on filters and is in required format")
Else
	Call WriteToLog("Fail","Expected Result: 'Last Completed Contact' date should be displayed in MyPatients grid based on filters and should be in required format.  Actual Result: Last Completed Contact date is NOT displayed in MyPatients grid as expected")
	Call Terminator	
End If

'Validate SORTING FUNCTIONALITY of contact date columns of MyPatient list grid-----------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","Validated sorting functionality of Last Attempted Contact date column of MyPatient list grid")
'---------------------------------------------------------------------------LAST ATTEMPTED CONTACT COLUMN------------------------------------------------------------------------------
Set objCDsortarrow = objPage.WebElement("class:=k-icon k-i-arrow-n","html tag:=SPAN","visible:=True")
Set objLADColHeader = Nothing
Set objPatientListGridTableRight = Nothing
Execute "Set objLADColHeader = "&Environment("WL_LADColHeader") ' Last Attempted Contact date header
Execute "Set objPatientListGridTableRight = "&Environment("WT_PatientListGridTableRight") 'PatientList Grid TableRight side

'Retrieving Last Attempted dates from MyPatient list (which is now in DEFAULT format (i.e., not sorted)
intMyPatientListRC = objPatientListGridTableRight.RowCount
Dim arrDEFAULTLACvalsFromPL()
intListRC=""

For intListRC = 1 To intMyPatientListRC Step 1
	ReDim Preserve arrDEFAULTLACvalsFromPL(intMyPatientListRC-1)
	arrDEFAULTLACvalsFromPL(intListRC-1) = objPatientListGridTableRight.ChildItem(intListRC,intLastAttemptedColumnNumber,"WebElement",0).GetROProperty("outertext")
Next

If Ubound(arrDEFAULTLACvalsFromPL) < 0  Then
	Call WriteToLog("Fail","Expected Result: Should be able to retrieve Last Attempted dates from MyPatient list.  Actual Result: Unable to retrieve Last Attempted dates from MyPatient list")
	Call Terminator
Else 
	Call WriteToLog("Pass","Successfully validated default order for Last Attempted Contact column of MyPatient grid and retrieved Last Attempted dates from MyPatient list")
End If
Wait 1

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validate ASCENDING order of Last Attempted Contact date column of MyPatient list

'Sorting Last Attempted Contact date column of MyPatient list in ASCENDING order by script
a=0
j=0
for a = UBound(arrDEFAULTLACvalsFromPL)-1 To 0 Step -1
    for j= 0 to a
        if arrDEFAULTLACvalsFromPL(j)>arrDEFAULTLACvalsFromPL(j+1) then
            temp=arrDEFAULTLACvalsFromPL(j+1)
            arrDEFAULTLACvalsFromPL(j+1)=arrDEFAULTLACvalsFromPL(j)
            arrDEFAULTLACvalsFromPL(j)=temp
        end if
    next
next
Err.Clear
'Clk for getting LAC col in ASCENDING order
Setting.WebPackage("ReplayType") = 2
objLADColHeader.FireEvent "onClick"
Setting.WebPackage("ReplayType") = 1
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to click on Last Attemptemd Contact column hearder for sorting in ascending order.  Actual Result: Unable to click on Last Attemptem Contact colum hearder for sorting in ascending order")
	Call Terminator	
Else 
	Call WriteToLog("Pass","Clicked on Last Attemptemd Contact column hearder for sorting in ascending order")
End If

Wait 5
'Retrieving Last Attempted dates from MyPatient list (which is now in Ascending format as we clicked on LAC header)
Dim arrASCENDINGLACvalsFromPL()
intListRC=""
For intListRC = 1 To intMyPatientListRC Step 1
	ReDim Preserve arrASCENDINGLACvalsFromPL(intMyPatientListRC-1)
	arrASCENDINGLACvalsFromPL(intListRC-1) = objPatientListGridTableRight.ChildItem(intListRC,intLastAttemptedColumnNumber,"WebElement",0).GetROProperty("outertext")
Next

'validate ASCENDING-------------------------
'Comparing both arrays (i.e., array sorted in ascending order by Script and array sorted in ascending order by UI click)
For cmp1 = 0 To UBound(arrDEFAULTLACvalsFromPL) - 1
    FlagFound1 = False
    For cmp2 = 0 To UBound(arrASCENDINGLACvalsFromPL) - 1
        If Instr(1,arrDEFAULTLACvalsFromPL(cmp1),arrASCENDINGLACvalsFromPL(cmp2),1) > 0 Then
            FlagFound1 = True
        End If
    Next 
    If Not FlagFound1 Then
        Print arrDEFAULTLACvalsFromPL(cmp1) & "not found"
    End If
Next 

If FlagFound1 Then
	Call WriteToLog("Pass","Successfully validated ascending order sorting for Last Attempted Contact column of MyPatient grid.")
Else
	Call WriteToLog("Fail","Expected Result: Last Attempted Contact column of MyPatient grid should be sorted in ascending order.  Actual Result: Last Attempted Contact column of MyPatient grid is NOT sorted in ascending order.")
	Call Terminator
End If

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validate DESCENDING order of Last Attempted Contact date column of MyPatient list

'Sorting Last Attempted Contact date column of MyPatient list in DESCENDING order by script
a=0
j=0
for a = UBound(arrDEFAULTLACvalsFromPL)-1 To 0 Step -1
    for j= 0 to a
        if arrDEFAULTLACvalsFromPL(j)<arrDEFAULTLACvalsFromPL(j+1) then
            temp=arrDEFAULTLACvalsFromPL(j+1)
            arrDEFAULTLACvalsFromPL(j+1)=arrDEFAULTLACvalsFromPL(j)
            arrDEFAULTLACvalsFromPL(j)=temp
        end if
    next
next

Err.Clear
'Clk on LAC sorting arrow
Setting.WebPackage("ReplayType") = 2
objCDsortarrow.FireEvent "onClick"
Setting.WebPackage("ReplayType") = 1
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to click on Last Attempted Contact column hearder arrow for sorting in descending order.  Actual Result: Unable to click on Last Attempted Contact colum hearder arrow for sorting in descending order")
	Call Terminator	
Else 
	Call WriteToLog("Pass","Clicked on Last Attemptemd Contact column hearder arrow for sorting in descending order")
End If

Wait 5
'Retrieving Last Attempted dates from MyPatient list (which is now in Descending format as we clicked on LAC header sorting arrow)
Dim arrDESCENDINGLACvalsFromPL()
intListRC=""
For intListRC = 1 To intMyPatientListRC Step 1
	ReDim Preserve arrDESCENDINGLACvalsFromPL(intMyPatientListRC-1)
	arrDESCENDINGLACvalsFromPL(intListRC-1) = objPatientListGridTableRight.ChildItem(intListRC,intLastAttemptedColumnNumber,"WebElement",0).GetROProperty("outertext")
Next

If Ubound(arrDESCENDINGLACvalsFromPL) < 0  Then
	Call WriteToLog("Fail","Expected Result: Should be able to retrieve Last Attempted dates from MyPatient list.  Actual Result: Unable to retrieve Last Attempted dates from MyPatient list")
	Call Terminator
Else 
	Call WriteToLog("Pass","Retrieved Last Attempted dates from MyPatient list")
End If

'validate DESCENDING-------------------------
'Comparing both arrays (i.e., array sorted in ascending order by Script and array sorted in descending order by UI click)
cmp1 =""
cmp2 =""
For cmp1 = 0 To UBound(arrDEFAULTLACvalsFromPL) - 1
    FlagFound2 = False
    For cmp2 = 0 To UBound(arrDESCENDINGLACvalsFromPL) - 1
    	If Instr(1,arrDESCENDINGLACvalsFromPL(cmp2),arrDEFAULTLACvalsFromPL(cmp1),1) > 0 Then
            FlagFound2 = True
        End If
    Next 
    If Not FlagFound2 Then
        Print arrDEFAULTLACvalsFromPL(cmp1) & "not found"
    End If
Next 

If FlagFound2 Then
	Call WriteToLog("Pass","Successfully validated descending order sorting for Last Attempted Contact column of MyPatient grid.")
Else
	Call WriteToLog("Fail","Expected Result: Last Attempted Contact column of MyPatient grid should be sorted in descending order.  Actual Result: Last Attempted Contact column of MyPatient grid is NOT sorted in descending order.")
	Call Terminator
End If

'---------------------------------------------------------------------------LAST COMPLETED CONTACT COLUMN------------------------------------------------------------------------------
Call WriteToLog("Info","Validated sorting functionality of Last Completed Contact date column of MyPatient list grid")

Set objCDsortarrow = Nothing
Set objLCDColHeader = Nothing
Set objPatientListGridTableRight = Nothing
Set objCDsortarrow = objPage.WebElement("class:=k-icon k-i-arrow-n","html tag:=SPAN","visible:=True")
Execute "Set objLCDColHeader = "&Environment("WL_LCDColHeader") ' Last Completed Contact date header
Execute "Set objPatientListGridTableRight = "&Environment("WT_PatientListGridTableRight") 'PatientList Grid TableRight side

'Retrieving Last Completed dates from MyPatient list (which is now in DEFAULT format (i.e., not sorted)
intMyPatientListRC = objPatientListGridTableRight.RowCount
Dim arrDEFAULTLCCvalsFromPL()
intListRC=""
For intListRC = 1 To intMyPatientListRC Step 1
	ReDim Preserve arrDEFAULTLCCvalsFromPL(intMyPatientListRC-1)
	arrDEFAULTLCCvalsFromPL(intListRC-1) = objPatientListGridTableRight.ChildItem(intListRC,intLastCompletedColumnNumber,"WebElement",0).GetROProperty("outertext")
Next
If Ubound(arrDEFAULTLCCvalsFromPL) < 0  Then
	Call WriteToLog("Fail","Expected Result: Should be able to retrieve Last Completed dates from MyPatient list.  Actual Result: Unable to retrieve Last Completed dates from MyPatient list")
	Call Terminator
Else 
	Call WriteToLog("Pass","Successfully validated default order for Last Completed Contact column of MyPatient grid and retrieved Last Completed dates from MyPatient list")
End If

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validate ASCENDING order of Last Completed Contact date column of MyPatient list

'Sorting Last Completed Contact date column of MyPatient list in ASCENDING order by script
a=0
j=0
for a = UBound(arrDEFAULTLCCvalsFromPL)-1 To 0 Step -1
    for j= 0 to a
        if arrDEFAULTLCCvalsFromPL(j)>arrDEFAULTLCCvalsFromPL(j+1) then
            temp=arrDEFAULTLCCvalsFromPL(j+1)
            arrDEFAULTLCCvalsFromPL(j+1)=arrDEFAULTLCCvalsFromPL(j)
            arrDEFAULTLCCvalsFromPL(j)=temp
        end if
    next
next

Err.Clear
'Clk for getting LCC col in ASCENDING order
Setting.WebPackage("ReplayType") = 2
objLCDColHeader.FireEvent "onClick"
Setting.WebPackage("ReplayType") = 1
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to click on Last Completed Contact column hearder for sorting in ascending order.  Actual Result: Unable to click on Last Completed Contact column hearder for sorting in ascending order")
	Call Terminator
Else 
	Call WriteToLog("Pass","Clicked on Last Completed Contact column hearder for sorting in ascending order")
End If

Wait 5
'Retrieving Last Completed dates from MyPatient list (which is now in Ascending format as we clicked on LCC header)
Dim arrASCENDINGLCCvalsFromPL()
intListRC=""
For intListRC = 1 To intMyPatientListRC Step 1
	ReDim Preserve arrASCENDINGLCCvalsFromPL(intMyPatientListRC-1)
	arrASCENDINGLCCvalsFromPL(intListRC-1) = objPatientListGridTableRight.ChildItem(intListRC,intLastCompletedColumnNumber,"WebElement",0).GetROProperty("outertext")
Next

If Ubound(arrASCENDINGLCCvalsFromPL) < 0  Then
	Call WriteToLog("Fail","Expected Result: Should be able to retrieve Last Completed dates from MyPatient list.  Actual Result: Unable to retrieve Last Completed dates from MyPatient list")
	Call Terminator
Else 
	Call WriteToLog("Pass","Retrieved Last Completed dates from MyPatient list")
End If

'validate ASCENDING-------------------------
'Comparing both arrays (i.e., array sorted in ascending order by Script and array sorted in ascending order by UI click)
For cmp1 = 0 To UBound(arrDEFAULTLCCvalsFromPL) - 1
    FlagFound3 = False
    For cmp2 = 0 To UBound(arrASCENDINGLCCvalsFromPL) - 1
    	If Instr(1,arrDEFAULTLCCvalsFromPL(cmp1),arrASCENDINGLCCvalsFromPL(cmp2),1) > 0 Then
           FlagFound3 = True
    	End If
    Next 
    If Not FlagFound3 Then
        Print arrDEFAULTLCCvalsFromPL(cmp1) & "not found"
    End If
Next 

If FlagFound3 Then
	If FlagFound3 Then
		Call WriteToLog("Pass","Successfully validated ascending order sorting for Last Completed Contact column of MyPatient grid.")
	Else
		Call WriteToLog("Fail","Expected Result: Last Completed Contact column of MyPatient grid should be sorted in ascending order.  Actual Result: Last Completed Contact column of MyPatient grid is NOT sorted in ascending order.")
		Call Terminator	
	End If
End If

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validate DESCENDING order of Last Completed Contact date column of MyPatient list

'Sorting Last Completed Contact date column of MyPatient list in DESCENDING order by script
a=0
j=0
for a = UBound(arrDEFAULTLCCvalsFromPL)-1 To 0 Step -1
    for j= 0 to a
        if arrDEFAULTLCCvalsFromPL(j)<arrDEFAULTLCCvalsFromPL(j+1) then
            temp=arrDEFAULTLCCvalsFromPL(j+1)
            arrDEFAULTLCCvalsFromPL(j+1)=arrDEFAULTLCCvalsFromPL(j)
            arrDEFAULTLCCvalsFromPL(j)=temp
        end if
    next
next
Err.Clear
'Clk on LCC sorting arrow
Setting.WebPackage("ReplayType") = 2
objCDsortarrow.FireEvent "onClick"
Setting.WebPackage("ReplayType") = 1
If Err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to click on Last Completed Contact column hearder arrow for sorting in descending order.  Actual Result: Unable to click on Last Completed Contact column hearder arrow for sorting in descending order")
	Call Terminator
Else 
	Call WriteToLog("Pass","Clicked on Last Completed Contact column hearder arrow for sorting in descending order")
End If

Wait 5
'Retrieving Last Completed dates from MyPatient list (which is now in Descending format as we clicked on LCC header sorting arrow)
Dim arrDESCENDINGLCCvalsFromPL()
intListRC=""
For intListRC = 1 To intMyPatientListRC Step 1
	ReDim Preserve arrDESCENDINGLCCvalsFromPL(intMyPatientListRC-1)
	arrDESCENDINGLCCvalsFromPL(intListRC-1) = objPatientListGridTableRight.ChildItem(intListRC,intLastCompletedColumnNumber,"WebElement",0).GetROProperty("outertext")
Next

If Ubound(arrDESCENDINGLCCvalsFromPL) < 0  Then
	Call WriteToLog("Fail","Expected Result: Should be able to retrieve Last Attempted dates from MyPatient list.  Actual Result: Unable to retrieve Last Attempted dates from MyPatient list")
	Call Terminator
Else 
	Call WriteToLog("Pass","Retrieved Last Completed dates from MyPatient list")
End If

'validate DESCENDING-------------------------
'Comparing both arrays (i.e., array sorted in descending order by Script and array sorted in ascending order by UI click)
cmp1 =""
cmp2 =""
For cmp1 = 0 To UBound(arrDEFAULTLCCvalsFromPL) - 1
    FlagFound4 = False
    For cmp2 = 0 To UBound(arrDESCENDINGLCCvalsFromPL) - 1
    	If Instr(1,arrDESCENDINGLCCvalsFromPL(cmp2),arrDEFAULTLCCvalsFromPL(cmp1),1) > 0 Then
            FlagFound4 = True
            Exit For
        End If
    Next 
    If Not FlagFound4 Then
        Print arrDEFAULTLCCvalsFromPL(cmp1) & "not found"
    End If
    
    If FlagFound4 Then
        Exit For
    End If
Next 

If FlagFound4 Then
	Call WriteToLog("Pass","Successfully validated descending order sorting for Last Completed Contact column of MyPatient grid.")
Else
	Call WriteToLog("Fail","Expected Result: Last Completed Contact column of MyPatient grid should be sorted in descending order.  Actual Result: Last Completed Contact column of MyPatient grid is NOT sorted in descending order.")
	Call Terminator	
End If
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("Info","----------------Logout of application----------------") 
Call Logout()
Wait 2

'Set objects free
Set objPage = Nothing
Set objMyPatientsMajorTab = Nothing
Set objMyPatientsMainTab = Nothing
Set objLADColHeader = Nothing
Set objLCDColHeader = Nothing 
Set objPatientListGridTableRight = Nothing

'Iteration loop
Loop While False: Next
wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function
