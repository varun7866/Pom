'**************************************************************************************************************************************************************************
' TestCase Name				: PatientAssignmentValidation
' Purpose of TC				: Validate newly created SNP patient's status, VHN assignment, Comorbid addition
' Author               		: Gregory
' Date                 		: 16 October 2015
' Modified By				: Amar (for ESCO) on 29 October 2015
' Environment				: QA/Train/Stage (url as described in Config file)
' Comments					: This script covers certain test case scenarios corresponding to userstory : B-05059 
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "PatientAssignmentValidation", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Get all required scenarios
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)

'------------------------
' Variable initialization
'------------------------
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
strPersonalDetails = DataTable.Value("PersonalDetails","CurrentTestCaseData")
strAddressDetails = DataTable.Value("AddressDetails","CurrentTestCaseData")
strMedicalDetails = DataTable.Value("MedicalDetails","CurrentTestCaseData")
strComorbidType = DataTable.Value("ComorbidType","CurrentTestCaseData") 'Diabetes Type 1 or Diabetes Type 2
dtReportedDate = DataTable.Value("ReportedDate","CurrentTestCaseData")
strValidation = DataTable.Value("Validation","CurrentTestCaseData")
strRequiredAssignedVHN = DataTable.Value("AssignedVHN","CurrentTestCaseData")

'-----------------
' Objects required
'-----------------
Execute "Set objPage = " &Environment("WPG_AppParent")'Page object	
Execute "Set objGloSearch = " &Environment("WE_GloSearch")'GlobalSearch TxtField	
Execute "Set objGlobalSearchIcon = " &Environment("WI_GlobalSearchIcon")'GlobalSearch icon	
Execute "Set objGloSearchGrid = " &Environment("WEL_GloSearchGrid")'PatientSearchResult popup OK btn
Execute "Set objPSResOK = " &Environment("WB_PSResOK")'PatientSearchResult popup OK btn
Execute "Set objComorbidReportedDt = " &Environment("WB_ComorbidReportedDt")'PatientSearchResult popup OK btn
Execute "Set objAddButton = " & Environment("WB_ComorbidDetailsAdd")'Comorbid Add button
Execute "Set objComorbidType = " & Environment("WB_ComorbidType")'Comorbid Type dropdown
Execute "Set objProvider = " & Environment("WB_ComorbidProvider")'Provider dropdown
Execute "Set objComorbidListTable = " & Environment("WB_ComorbidListTable")'Comorbid List Table
Execute "Set objSaveButton = " & Environment("WB_ComorbidDetailsSave")'Comorbid Save button

'Execution as required
If not Lcase(strExecutionFlag) = "y" Then Exit Do

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
	intIteration = intIteration+1
	Call WriteToLog("Info","----------------Iteration count: "&intIteration&" ----------------") 
	On Error Resume Next
	Err.Clear
	
	'-------------------------------
	'Close all open patients from DB
	Call closePatientsFromDB("eps")
	'-------------------------------
	
	'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("eps", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")	
	
	'Create newpatient
	strNewPatientDetails = ""
	strNewPatientDetails = CreateNewPatientFromEPS(strPersonalDetails,"NA",strMedicalDetails,strOutErrorDesc)
	If strNewPatientDetails = "" Then
		Call WriteToLog("Fail","Expected Result: User should be able to create new SNP patient in EPS. Actual Result: Unable to  create new SNP patient in EPS."&strOutErrorDesc)
		Call Terminator											
	End If
	
	strPatientName = Split(strNewPatientDetails,"|",-1,1)(0)
	lngMemberID = Split(strNewPatientDetails,"|",-1,1)(1)
	strEligibilityStatus = Split(strNewPatientDetails,"|",-1,1)(2)
	
	Call WriteToLog("Pass","Created new patient in EPS with name: '"&strPatientName&"', MemberID: '"&lngMemberID&"' and Eligibility status: '"&strEligibilityStatus&"'")	
	
	strPatientFirstName = Split(strPatientName,", ",-1,1)(1)
	strPatientSecondName = Split(strPatientName,", ",-1,1)(0)
	
	'Test case: SNP member should be created with Enrolled Status
	If lcase(strEligibilityStatus)  = "enrolled" Then
		Call WriteToLog("Pass", "SNP patient is created with 'Enrolled' status as expected")
	Else
		Call WriteToLog("Fail", "Unable to create new SNP patient with 'Enrolled' status. Actual Result: New SNP patient is created with '"&strEligibilityStatus&"' status")
		Call Terminator
	End If
	
'------------------------------------------------------------------------------------------------
	'logout of application
	Call WriteToLog("Info","-------------------Logout of application-------------------")
	Call Logout()
	Wait 5
	
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
'------------------------------------------------------------------------------------------------
	
	'Testcase: New SNP patient VHN assignment validation-----------------------------------------
	
	'Set patient MemID in global search search field
	Err.Clear	
	objGloSearch.Set lngMemberID
	If Err.number <> 0 Then
		Call WriteToLog("Fail", "Unable to set patient member ID in global search field: "&Err.Description)
		Call Terminator
	End If
	Call WriteToLog("Pass", "Patient member ID is set in global search field")
	Wait 1			
	
	'Clk on global search icon
	Err.Clear	
	objGlobalSearchIcon.Click
	If Err.number <> 0 Then
		Call WriteToLog("Fail", "Unable to click on global search icon: "&Err.Description)
		Call Terminator
	End If
	Call WriteToLog("Pass", "Clicked global search icon")
	Wait 3
	Call waitTillLoads("Searching...")
	
	'Verify if no matching results found message box existed if no patient found
    blnNoResultPopup = checkForPopup("Error", "Ok", "No matching results found", strOutErrorDesc)
    If blnNoResultPopup Then
		Call WriteToLog("Fail", "Invalid Member ID")
		Call Terminator
	End If
    
    'Check whether PatientSearchResult popup is available
    If not objGloSearchGrid.Exist(10) Then
		Call WriteToLog("Fail", "Unable to find PatientSearchResult popup")
		Call Terminator
	End If
 	Call WriteToLog("Pass", "Patient Search Result popup is available")
  
  	'getting patinet details from Patient seacrh popup
  	strPatientDetails = objPage.WebTable("class:=k-selectable","column names:=.*"&lngMemberID&".*","name:=WebTable","visible:=True").GetROProperty("column names")
    arrPatientDetails = Split(strPatientDetails,";",-1,1)
	strAssignedVHN = Trim(arrPatientDetails(4)) 'Assigned VHN's name is shown in 5th coulmn of Patient seacrh popup
	
	If lcase(strValidation) = "snp" Then
		
		'Validating VHN assignment
		If strAssignedVHN = "" Then
			Call WriteToLog("Fail", "Expected Result: Appropriate VHN assignment should happen for the newly created SNP patient. Actual Result: VHN assignment not available for the newly created SNP patient")
			Call Terminator	
		End If
		Call WriteToLog("Pass", "Newly created SNP patient has appropriate VHN assignment")
		
		'Clk on OK of search popup
		blnGridOKClicked = ClickButton("OK",objPSResOK,strOutErrorDesc)
		If not blnGridOKClicked Then
			Call WriteToLog("Fail","Click OK of search popup return: "&strOutErrorDesc)
			Call Terminator	
		End If	
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 2
		
		'Handle navigation error if exists
		blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
		If not blnHandleWrongDashboardNavigation Then
		    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
		End If
		Call WriteToLog("Pass","Provided proper navigation after patient selection")
		Wait 2
			
		'Testcase: Comorbid add for SNP patient validation-------------------------------------------
		'Navigate to ClinicalManagement > Comorbids
		blnScreenNavigation = clickOnSubMenu_WE("Clinical Management->Comorbids")
		If not blnScreenNavigation Then
			Call WriteToLog("Fail","Unable to navigate to Clinical Management > Comorbids screen "&strOutErrorDesc)
			Call Terminator
		End If
		Call WriteToLog("Pass","Navigated to Clinical Management > Comorbids screen")
		wait 5
		Call waitTillLoads("Loading...")
		Wait 1
		
		'Click on Comorbid add button	
		blnAddClicked = ClickButton("Add",objAddButton,strOutErrorDesc)
		If not blnAddClicked Then
			Call WriteToLog("Fail","Expected Result: Should be able to click Comorbid Add button. Actual Result:Click Comorbid Add button return: "&strOutErrorDesc)
			Call Terminator	
		End If
		wait 2
		Call waitTillLoads("Loading...")	
		Wait 1
		
		'Set Reported Date as required
		If Trim(LCase(dtReportedDate)) <> "na" Then	
			Err.Clear
			objComorbidReportedDt.Set dtReportedDate
			If Err.Number <> 0 Then
				Call WriteToLog("Fail","Expected Result: Should be able to set Reported Date. Actual Result: Unable to set Reported Date: "&Err.Description)
				Call Terminator	
			End If
			Call WriteToLog("Pass", "Reported Date is set as '"&dtReportedDate&"'")
		End If
		
		'Select required Comorbid type from ComorbidType dropdown
		blnComorbidType = selectComboBoxItem(objComorbidType, strComorbidType)
		If not blnComorbidType Then
			Call WriteToLog("Fail","Expected Result: Should be able to select '"&strComorbidType&"' from Comorbid Type dropdown. Actual Result: '"&strComorbidType&"' is not selected. " & strOutErrorDesc)
			Call Terminator	
		End If
		Call WriteToLog("Pass", "'"&strComorbidType&"' is selected from Comorbid Type dropdown")
		Wait 1
		
		'Select assigned Provider from Provider dropdown
		strProvider = strAssignedVHN 
	    blnProvider = SelectComboBoxItemSpecific(objProvider, strProvider)
		If not blnProvider Then
			Call WriteToLog("Fail","Expected Result: Should be able to select '"&strProvider&"' from Provider dropdown. Actual Result: '"&strProvider&"' is not selected. " & strOutErrorDesc)
			Call Terminator	
		End If
		Call WriteToLog("Pass", "'"&strProvider&"' is selected from Provider dropdown")
		Wait 2
	
		'Clk on Save button
		blnSaveClicked = ClickButton("Save",objSaveButton,strOutErrorDesc)
		If not blnSaveClicked Then
			Call WriteToLog("Fail","Expected Result: Should be able to click Comorbid Add button. Actual Result:Click Comorbid Add button return: "&strOutErrorDesc)
			Call Terminator	
		End If
		wait 2
		Call waitTillLoads("Loading...")
		Wait 1
	
		'Check newly added comorbid is available in Comorbid list table
		strComorbidTypeFromTable = objComorbidListTable.getCellData(1, 1)
		If Trim(strComorbidTypeFromTable) <> Trim(strComorbidType) then
			Call WriteToLog("Fail","Expected Result: '"&strComorbidType&"' should be added to 'Comorbid List Table'. Actual Result: '"&strComorbidType&"' is NOT added to 'Comorbid List Table'")
			Call Terminator	
		End If
		Call WriteToLog("Pass", "'"&strComorbidType&"' is be added to 'Comorbid List Table'")
	
	Else
	
'		'Validating VHN assignment
'		If strAssignedVHN = strRequiredAssignedVHN Then
'			Call WriteToLog("Fail", "Expected Result: Appropriate VHN assignment should happen for the newly created SNP patient. Actual Result: VHN assignment not available for the newly created SNP patient")
'			Call Terminator		
'		End If
'		Call WriteToLog("Pass", "Newly created SNP patient has appropriate VHN assignment")

		strAssignedVHN = Replace(strAssignedVHN," ","",1,-1,1)
		strAssignedVHN = Replace(strAssignedVHN,",","",1,-1,1)
		strRequiredAssignedVHN = Replace(strRequiredAssignedVHN," ","",1,-1,1)
		strRequiredAssignedVHN = Replace(strRequiredAssignedVHN,",","",1,-1,1)
		If Instr(1,strAssignedVHN,strRequiredAssignedVHN,1) > 0 Then
			Call WriteToLog("Pass", "Newly created SNP patient has appropriate VHN assignment")
		else	
			Call WriteToLog("Fail", "Expected Result: Appropriate VHN assignment should happen for the newly created SNP patient. Actual Result: VHN assignment not available for the newly created SNP patient")
			Call Terminator		
		End If
				
		'Clk on OK of search popup
		blnGridOKClicked = ClickButton("OK",objPSResOK,strOutErrorDesc)
		If not blnGridOKClicked Then
			Call WriteToLog("Fail","Click OK of search popup return: "&strOutErrorDesc)
			Call Terminator	
		End If	
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 2
	
	End If		

	'logout
	Call WriteToLog("Info","-------------------Logout of application-------------------")
	Call Logout()
	Wait 2

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
