''**************************************************************************************************************************************************************************
' TestCase Name			: ReviewMedications
' Purpose of TC			: Validate Medication review columns on Adding new medication, Editing existing medications, Cancelling medication, Switching screenins; also validating sorting oder of review check boxes. 
' Author                : Gregory
' Date                  : 25 June 2015
' Date Modified			: 6 October 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04747
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ReviewMedications", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'------------------------
' Variable initialization
'------------------------
strLoginUser = Trim(DataTable.Value("User","CurrentTestCaseData")) 
strPatientName =DataTable.Value("PatientName","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
strLabelName = DataTable.Value("LabelName","CurrentTestCaseData") 
strNote = DataTable.Value("Note","CurrentTestCaseData") 
dtMedReviewDate = DataTable.Value("MedReviewDate","CurrentTestCaseData") 
dtWrittenDate = DataTable.Value("WrittenDate","CurrentTestCaseData")
dtFilledDate = DataTable.Value("FilledDate","CurrentTestCaseData")
strFrequencyValue = DataTable.Value("FrequencyValue","CurrentTestCaseData")
intMedTableColCount = DataTable.Value("MedicationTableColumnCount","CurrentTestCaseData")

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage = "&Environment("WPG_AppParent") 'PageObject	
Execute "Set SDMBOFDpptle = "&Environment("WEL_SDMBOFDpptle") 'SomeDataMayBeOutOfDate popup title
Execute "Set objMedMagtitle = "&Environment("WEL_MedMagTitle")	'Medications Management screen title
Execute "Set objESAcb = "&Environment("WEL_ESAcb") 'ESA chk box
Execute "Set objLbNaDD = "&Environment("WEL_LbNaDD") 'LabelNameDD name
Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
Execute "Set objFilledDate = "&Environment("WE_FilledDate")	'Medications FilledDate
Execute "Set objFreq = "&Environment("WEL_MedFreq") 'Frequency for medications
Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
Execute "Set objMedAddBtn = " &Environment("WEL_MedAddBtn") 'Medication Add btn
Execute "Set objFreqLst = " &Environment("WEL_FreqLst") 'Frequency List
Execute "Set objRxNumberTxt = "&Environment("WE_RxNumberTxt") 'RxNumber editbox
Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn
Execute "Set objMedicationReviewAdd = "&Environment("WB_MedicationReviewAdd") 'Review add btn
Execute "Set objMedReviewDate = "&Environment("WE_MedReviewDate") 'Review date btn
Execute "Set objMedReviewSave = "&Environment("WEL_MedReviewSave") 'Review save btn
Execute "Set objPharmacistMedReviewTab = "&Environment("WEL_PharmacistMedReviewTab") 'Phamacist med review tab
Execute "Set objReviewTab = "&Environment("WEL_ReviewTab") 'Review tab
Execute "Set objMedTitleTable = "&Environment("WT_MedTitleTable") 'Mediaction table title web table
Execute "Set objOrderArrow = "&Environment("WEL_OrderArrow") 'Arrow btn in review header
Set objReviewTabForMedTable = objMedTitleTable.Link("html tag:=A","outertext:=Reviewed","visible:=True") ' Review header of Medication label name table

'-----------------------EXECUTION----------------------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
Err.Clear

'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

'Select patient from MyPatient list
Call WriteToLog("Info","----------------Select required patient from MyPatient List----------------")
blnSelectPatientFromPatientList = SelectPatientFromPatientList(strUser, strPatientName)
If blnSelectPatientFromPatientList Then
	Call WriteToLog("Pass","Selected required patient from MyPatient list")
Else
	strOutErrorDesc = "Unable to select required patient"
	Call WriteToLog("Fail","Expected Result: Should be able to select required patient from MyPatient list.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Wait 2

'Navigate to ClinicalManagement > Medications
Call clickOnSubMenu_WE("Clinical Management->Medications")
wait 5

Call waitTillLoads("Loading Problems...")
Wait 2

'Close all available popups
Call ClosePopups()

'Check whether user landed on Medications Management screen
If not objMedMagtitle.Exist(3) Then
	Call WriteToLog("Fail","Expected Result: User should be on Medications screen.  Actual Result: Unable to land on Medications screen "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass","Landed on Medications screen")
wait 2	

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validating Review check boxes on Medication add
Call WriteToLog("Info","----------------Validating Review check boxes on Medication add----------------") 

'Checking review chk box, if it is available under review col of mediaction lable table
Set objMedTable = objPage.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intMedTableColCount,"name:=WebTable","visible:=True")
If objMedTable.Exist(1) Then
	strRCBstatusNew = objMedTable.ChildItem(1,1,"WebElement",0).GetROProperty("outerhtml")
	intChkStatusNew = Instr(1,strRCBstatusNew,"check-yes ng-hide",1)
	intMedTableRowCount = objMedTable.RowCount
	If intMedTableRowCount > 0 AND intChkStatusNew > 0 Then 
		Err.clear
		objMedTable.ChildItem(1,1,"WebElement",0).Click
	End If
End If

If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to select existing review check box.  Actual Result: Unable to select existing review check box "&Err.Description)
	Call Terminator
ElseIf intChkStatusNew <= 0 Then
	Call WriteToLog("Pass","There are no review check boxes existing")
Else
	Call WriteToLog("Pass","Selected existing review check box")
End If

'Clk Medications Add button
Err.Clear
blnClickAdd = ClickButton("Add",objMedAddBtn,strOutErrorDesc)
If not blnClickAdd Then
	Call WriteToLog("Fail","Expected Result: Should be able to clk on Add btn.  Actual Result: Unable to click Add button for medications")
	Call Terminator
End If
Call WriteToLog("Pass","Clicked Add button for medications")
wait 2

'get the RxNumber for new medication
strRxNumber = Trim(objRxNumberTxt.GetROProperty("value"))
If strRxNumber = "" Then
	Call WriteToLog("Fail","Expected Result: User should be able to retrieve RxNumber for new medication.  Actual Result: Unable to retrieve RxNumber for new medication")
	Call Terminator
End If
Call WriteToLog("Pass","Saved RxNumber for new medication")
wait 1		

Err.clear
'Chk on ESA chkbox
objESAcb.Click
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: User should be able to click ESA chkbox.  Actual Result: Unable to click ESA checkbox "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass","Checked ESA checkbok")
Wait 1		
	
'Select Label	
blnLabel = selectComboBoxItem(objLbNaDD, strLabelName)
If Not blnLabel Then
	strOutErrorDesc = "Select Label returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", "Expected Result: Should be able to select label; Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Selected required label")
wait 1

err.clear
'Value for Medications WrittenDate 
objWrittenDate.Set dtWrittenDate
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Written Date should be set.  Actual Result: Unable to set written date "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass","Written date is set")
wait 1

err.clear
'Value for Medications FilledDate 
objFilledDate.Set dtFilledDate
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Filled date should be set.  Actual Result: Unable to set filled date "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass","Filled date is set")
Wait 1	

'Select required frequency
blnFreqSelect = selectComboBoxItem(objFreq, strFrequencyValue)
If not blnFreqSelect Then	
    Call WriteToLog("Fail","Expected Result: '"&strFrequencyValue&"' frequency value should be available under Frequeny dropdown; Actual Result: "&Err.Description)
	Call Terminator
End If 
Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is available under Frequeny dropdown")	
wait 1

'Save new Medication
Call WriteToLog("Info","----Save Medication with value taken from frequency list----")
Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
'Save new Medication
blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
If not blnClickSave Then
	Call WriteToLog("Fail","Expected Result: Should be able to save medication. Actual Result: Unable to save medication. "&strOutErrorDesc)
	Call Terminator
End If 
Call WriteToLog("Pass","Saved newly added medication")

WaitForProcessing()
Wait 2

Err.Clear
Set objMedTable = Nothing
strRCBstatusAtAdd = ""
intCkdStatusAtAdd = 0
intChkStatusAtAddValue = 0
Set objMedTable = objPage.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intMedTableColCount,"name:=WebTable","visible:=True")
intMedTableRowCount = objMedTable.RowCount

'if there were medications (i.e intChkStatusNew > 0) prior to this new medication added now, then only check whether med review chkboxes are not cleared at adding new medication
If intChkStatusNew > 0 Then

	For rcMedTable = 1 To intMedTableRowCount Step 1
		strRCBstatusAtAdd = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
		intChkStatusAtAdd = Instr(1,strRCBstatusAtAdd,"check-yes ng-hide",1)
		If intChkStatusAtAdd > 0 Then
			intChkStatusAtAddValue = intChkStatusAtAddValue+1
		End If
	Next
	
	If intChkStatusAtAddValue = intMedTableRowCount Then
		Call WriteToLog("Fail","Expected Result: Checkboxes should not be cleared after adding new medication. Actual Result: Some Checkboxes are cleared after adding new medication ")
		Call Terminator
	ElseIf intChkStatusAtAddValue < intMedTableRowCount Then
		Call WriteToLog("Pass","Med Review checkboxes which were selected earlier are not cleared after adding new medication")
	End If	
'if there were no medications (i.e intChkStatusNew < = 0) prior to this new medication added now, then only check the availability of review chkboxes at adding new medication
End If
Call WriteToLog("Pass","Med Review checkboxes available at adding new medication")
Wait 1

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validating Medication Review header and order of check boxes
Call WriteToLog("Info","--------------------------Validating Medication Review header and order of check boxes----------------------------")

RxNumber = strRxNumber
Set objMedTable = Nothing
Set objMedTable = objPage.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intMedTableColCount,"name:=WebTable","visible:=True")
intMedTableRowCount = objMedTable.RowCount
For intMedTableRow =1 To intMedTableRowCount Step 1
	Setting.WebPackage("ReplayType") = 2
	objMedTable.ChildItem(intMedTableRow,2,"WebElement",0).FireEvent "onClick"
	Setting.WebPackage("ReplayType") = 1
	If objPage.WebElement("class:=left font-weight-bold ng-binding","html tag:=SPAN","outertext:="&RxNumber,"visible:=True").Exist(1) Then
		Err.Clear
		objMedTable.ChildItem(intMedTableRow,1,"WebElement",0).Click
	End If
Next

If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: User should be able to click medication review chkbox. Actual Result: Unable to click medication review chkbox "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked medication review chkbox of required medication")
Wait 1

'Getting Label Count (and Names) of Checked and Unchecked medications
Err.Clear
Dim arrckdLabelName()
intMedTableRow = 1
j=0
For intMedTableRow = 1 To intMedTableRowCount Step 1
	strRCBstatus = objMedTable.ChildItem(intMedTableRow,1,"WebElement",0).GetROProperty("outerhtml")
	If Instr(1,strRCBstatus,"ng-hide",1) Then
		'print "Unckd"
	Else
		ReDim Preserve arrckdLabelName(j)
		arrckdLabelName(j) = Trim(objMedTable.ChildItem(intMedTableRow,2,"WebElement",0).GetROProperty("outertext"))
		j=j+1
		'print "Ckd"
	End If
Next

intCkdLabelCount = Ubound(arrckdLabelName)+1
intUnCkdLabelCount = intMedTableRowCount-intCkdLabelCount 

Err.clear
Do Until objOrderArrow.Exist(1)
	Setting.WebPackage("ReplayType") = 2
	objReviewTabForMedTable.FireEvent "onClick"
	Setting.WebPackage("ReplayType") = 1
Loop 

If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: User should be able to click medication review header sorting arrow btn . Actual Result: Unable to click medication review header sorting arrow btn "&Err.Description)
	Call Terminator
Else 
	Call WriteToLog("Pass","Medication review header is properly displayed, sorting arrow button on header is active and is clicked for sorting")
End If

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validating Medication Review check boxes oder - Ascending
Call WriteToLog("Info","--------------------------Validating Medication Review check boxes oder - Ascending----------------------------")
'Check checkBox order ascending 
UnCkdCount = 0
For ordercount = 1 To intUnCkdLabelCount Step 1
	strRCBstatus = objMedTable.ChildItem(ordercount,1,"WebElement",0).GetROProperty("outerhtml")
	If Instr(1,strRCBstatus,"ng-hide",1) Then
		UnCkdCount = UnCkdCount+1
	End If
Next

If UnCkdCount = intUnCkdLabelCount Then
	Call WriteToLog("Pass","Validated medication review check boxes ascending order")
Else
	Call WriteToLog("Fail","Expected Result: Medication review check boxes should be sorted in ascending order. Actual Result: Medication review check boxes are NOT sorted in ascending order ")
	Call Terminator	
End If
Wait 1

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validating Medication Review check boxes - Descending
Call WriteToLog("Info","--------------------------Validating Medication Review check boxes - Descending----------------------------")
'Check checkBox order descending 
objReviewTabForMedTable.Click
CkdCount = 0
For ordercount = 1 To intCkdLabelCount Step 1
	strRCBstatus = objMedTable.ChildItem(ordercount,1,"WebElement",0).GetROProperty("outerhtml")
	If not Instr(1,strRCBstatus,"ng-hide",1) Then
		CkdCount = CkdCount+1
	End If
Next
If CkdCount = intCkdLabelCount Then
	Call WriteToLog("Pass","Validated medication review check boxes descending order")
Else
	Call WriteToLog("Fail","Expected Result: Medication review check boxes should be sorted in descending order. Actual Result: Medication review check boxes are NOT sorted in descending order ")
	Call Terminator		
End If
wait 2

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validating Medication Review check boxes - Descending
Call WriteToLog("Info","--------------------------Validating Medication Review check boxes - After completing review----------------------------")
'Clk on Med Review add btn
Err.Clear
objMedicationReviewAdd.Click
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to clk on Medication Review Add button.  Actual Result: Unable to clk on Medication Review Add button "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass","Medication Review Add button is clicked")
wait 2

Call waitTillLoads("Loading...")
Wait 2

'Set Med Review date
Err.Clear
objMedReviewDate.Set dtMedReviewDate
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result:Med Review date should be set.  Actual Result: Unable to set Med Review date "&Err.Description)
	Call Terminator
Else 
	Call WriteToLog("Pass","Med Review date is set")
End If
Wait 1

'Clk on Med Review save btn
Err.Clear
objMedReviewSave.Click
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to clk on Medication Review Save button.  Actual Result: Unable to clk on Medication Review Save button "&Err.Description)
	Call Terminator
Else 
	Call WriteToLog("Pass","Medication Review Save button is clicked")
End If
wait 2

Call waitTillLoads("Loading...")
Wait 2

Err.Clear
strRCBstatus1 = ""
intCkdStatus1 = 0
intChkStatus1value = 0
For rcMedTable = 1 To intMedTableRowCount Step 1
	strRCBstatus1 = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
	intCkdStatus1 = Instr(1,strRCBstatus1,"check-yes ng-hide",1)
	If intCkdStatus1 > 0 Then
		intChkStatus1value = intChkStatus1value+1
	End If
Next

If intChkStatus1value = 0 OR intChkStatus1value = "" Then
	Call WriteToLog("Pass","Med Review Checkboxes are cleared after reviewing medication")
ElseIf intChkStatus1value < intMedTableRowCount Then
	Call WriteToLog("Fail","Expected Result: Checkboxes should be cleared after reviewing medication. Actual Result: Some Checkboxes are not cleared after reviewing medication")
	Call Terminator
End If
	
'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validating Medication Review check boxes while editing existing medication
Call WriteToLog("Info","--------------------------Validating Medication Review check boxes while editing existing medication----------------------------")
'click required review chk box
Set objMedTable = Nothing
Set objMedTable = objPage.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intMedTableColCount,"name:=WebTable","visible:=True")
intMedTableRowCount = objMedTable.RowCount
For intMedTableRow =1 To intMedTableRowCount Step 1
	Setting.WebPackage("ReplayType") = 2
	objMedTable.ChildItem(intMedTableRow,2,"WebElement",0).FireEvent "onClick"
	Setting.WebPackage("ReplayType") = 1
	err.clear
	If objPage.WebElement("class:=left font-weight-bold ng-binding","html tag:=SPAN","outertext:="&RxNumber,"visible:=True").Exist(1) Then
		objMedTable.ChildItem(intMedTableRow,1,"WebElement",0).Click
	End If
Next

Err.Clear
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: User should be able to click medication review chkbox. Actual Result: Unable to click medication review chkbox "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked medication review chkbox of required medication")
Wait 2

'Click on Edit button
blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
If not blnClickEdit Then
	Call WriteToLog("Fail","ExpectedResult: Edit btn should be clicked.  ActualResult:  Unable to click Medication Edit Btn: "&Err.Description)
	Call Terminator
End If 
Call WriteToLog("Pass","Clicked Medication Edit Btn")
Wait 2

'Select required frequency
Execute "Set objFreq = Nothing"
Execute "Set objFreq = "&Environment("WEL_MedFreq") 'Frequency for medications
blnFreqSelect = selectComboBoxItem(objFreq, strFrequencyValue)
If not blnFreqSelect Then	
    Call WriteToLog("Fail","Expected Result: '"&strFrequencyValue&"' frequency value should be available under Frequeny dropdown; Actual Result: "&Err.Description)
	Call Terminator
End If 
Call WriteToLog("Pass","'"&strFrequencyValue&"' frequency value is available under Frequeny dropdown")	
wait 1

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Saving edited medication
Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
If not blnClickSave Then
	Call WriteToLog("Fail","Expected Result: Should be able to save medication. Actual Result: Unable to save medication. "&strOutErrorDesc)
	Call Terminator
End If 
Call WriteToLog("Pass","Saved newly added medication")
wait 2

WaitForProcessing()
Wait 2

Set objMedTable = Nothing
Set objMedTable = objPage.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intMedTableColCount,"name:=WebTable","visible:=True")
intMedTableRowCount = objMedTable.RowCount

Err.Clear
strRCBstatus2 = ""
intCkdStatus2 = 0
intChkStatus2value = 0
For rcMedTable = 1 To intMedTableRowCount Step 1
	strRCBstatus2 = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
	intChkStatus2 = Instr(1,strRCBstatus2,"check-yes ng-hide",1)
	If intChkStatus2 > 0 Then
		intChkStatus2value = intChkStatus2value+1
	End If
Next

If intChkStatus2value = intMedTableRowCount Then
	Call WriteToLog("Fail","Expected Result: Checkboxes should not be cleared after editing existing medication. Actual Result: Some Checkboxes are cleared after editing existing medication ")
	Call Terminator
ElseIf intChkStatus2value < intMedTableRowCount Then
	Call WriteToLog("Pass","Med Review Checkboxes are not cleared after editing existing medication")
End If

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validating Medication Review check boxes while Cancelling patient medication
Call WriteToLog("Info","--------------------------Validating Medication Review check boxes while Cancelling patient medication----------------------------")

'Clk Medications Add button 
Set objMedAddBtn = Nothing
Execute "Set objMedAddBtn = " &Environment("WEL_MedAddBtn") 'Medication Add btn
blnClickAdd = ClickButton("Add",objMedAddBtn,strOutErrorDesc)
If not blnClickAdd Then
	Call WriteToLog("Fail","Expected Result: Should be able to clk on Add btn.  Actual Result: Unable to click Add button for medications "&Err.Description)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked Add button for medications")
Wait 2

'Click on Cancel button
Set objCancelMed = Nothing
Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn
blnClickedCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
If not blnClickedCancel Then
	Call WriteToLog("Fail","Expected Result: Should be able to clk on Cancel btn.  Actual Result: Unable to click Cancel button for medications "&Err.Description)
	Call Terminator
End If 
Call WriteToLog("Pass","Clicked Cancel button for medications")
Wait 2

Set objMedTable = Nothing
Set objMedTable = objPage.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intMedTableColCount,"name:=WebTable","visible:=True")
Err.Clear
strRCBstatus3 = ""
intCkdStatus3 = 0
intCkdStatus3value = 0
For rcMedTable = 1 To intMedTableRowCount Step 1
	strRCBstatus3 = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
	intChkStatus3 = Instr(1,strRCBstatus3,"check-yes ng-hide",1)
	If intChkStatus3 > 0 Then
		intCkdStatus3value = intCkdStatus3value+1
	End If
Next

If intCkdStatus3value = intMedTableRowCount Then
	Call WriteToLog("Fail","Expected Result: Checkboxes should not be cleared after cancelling existing medication. Actual Result: Some Checkboxes are cleared after cancelling medication ")
	Call Terminator
ElseIf intCkdStatus3value < intMedTableRowCount Then	
	Call WriteToLog("Pass","Med Review Checkboxes are not cleared after cancelling medication add/edit")
End If
Wait 5

'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Validating Medication Review check boxes while switching screens
Call WriteToLog("Info","--------------------------Validating Medication Review check boxes while switching screens----------------------------")
'Click on Pharmacist med review tab
Err.Clear
objPharmacistMedReviewTab.Click
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to clk on Pharmacist MedReview tab.  Actual Result: Unable to click Pharmacist MedReview tab "&Err.Description)
	Call Terminator
Else 
	Call WriteToLog("Pass","Clicked 'Pharmacist MedReview' tab")
End If
wait 5

Call waitTillLoads("Loading...")
Wait 2
Call ClosePopups()

'cLick on Review tab
Err.Clear
objReviewTab.Click
If err.number <> 0 Then
	Call WriteToLog("Fail","Expected Result: Should be able to clk on Review tab.  Actual Result: Unable to click Review tab "&Err.Description)
	Call Terminator
Else 
	Call WriteToLog("Pass","Clicked 'Review' tab")
End If
wait 5

Call waitTillLoads("Loading...")
Wait 2
Call ClosePopups()

Set objMedTable = Nothing
Set objMedTable = objPage.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intMedTableColCount,"name:=WebTable","visible:=True")
Err.Clear
strRCBstatus4 = ""
intCkdStatus4 = 0
intCkdStatus4value = 0
For rcMedTable = 1 To intMedTableRowCount Step 1
	strRCBstatus4 = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
	intChkStatus4 = Instr(1,strRCBstatus4,"check-yes ng-hide",1)
	If intChkStatus4 > 0 Then
		intCkdStatus4value = intCkdStatus4value+1
	End If
Next

If intCkdStatus4value = intMedTableRowCount Then
	Call WriteToLog("Fail","Expected Result: Checkboxes should not be cleared after switching screens. Actual Result: Some Checkboxes are cleared after switching screens ")
	Call Terminator
ElseIf intCkdStatus4value < intMedTableRowCount Then	
	Call WriteToLog("Pass","Checkboxes are not be cleared after switching screens")
End If

Wait 5

'Logout
Call WriteToLog("Info","----------------Logout of application----------------")
Call Logout()
Wait 2

'Set objects free
Execute "Set objPage = Nothing"
Execute "Set SDMBOFDpptle = Nothing"
Execute "Set objMedMagtitle = Nothing"
Execute "Set objESAcb = Nothing"
Execute "Set objLbNaDD = Nothing"
Execute "Set objWrittenDate = Nothing"
Execute "Set objFilledDate = Nothing"
Execute "Set objFreq = Nothing"
Execute "Set objEditMed = Nothing"
Execute "Set objMedAddBtn = Nothing"
Execute "Set objFreqLst = Nothing"
Execute "Set objRxNumberTxt = Nothing"
Execute "Set objEditMed = Nothing"
Execute "Set objMedSavbtn = Nothing"
Execute "Set objCancelMed = Nothing"
Execute "Set objMedicationReviewAdd = Nothing"
Execute "Set objMedReviewDate = Nothing"
Execute "Set objMedReviewSave = Nothing"
Execute "Set objPharmacistMedReviewTab = Nothing"
Execute "Set objReviewTab = Nothing"
Execute "Set objMedTitleTable = Nothing"
Execute "Set objOrderArrow = Nothing"
Set objReviewTabForMedTable = Nothing


'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()

'------------------------------------------------------------------------------------------------------------------------------------------------
'Specific function related to this script

Function ClosePopups()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	Call checkForPopup("Some Date May Be Out of Date", "Ok", "", strOutErrorDesc)
	Err.Clear
	strOutErrorDesc = ""
	Wait 2
	
	Call checkForPopup("Disclaimer", "Ok", "", strOutErrorDesc)
	Err.Clear
	strOutErrorDesc = ""
	Wait 2
	
	Call checkForPopup("Some Date May Be Out of Date", "Ok", "", strOutErrorDesc)
	strOutErrorDesc = ""
	Err.Clear
	Wait 2
	
End Function

	
Function WaitForProcessing()
	wt = 0
	Do While objPage.WebElement("class:=please-wait-style loading.*","html tag:=SPAN","outertext:=Processing.*","visible:=True").Exist(1)
		Wait 1
		wt = wt + 1
		If wt = 60 Then
			Exit Do
		End If
	Loop
End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
	
End Function

Function clickOnSubMenu_WE(ByVal menu)

	On Error Resume Next
	Err.Clear	
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


