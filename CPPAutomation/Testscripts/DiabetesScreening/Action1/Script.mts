''***********************************************************************************************************************************************************************
'' ScriptName Name                : Diabetes Management Screening
'' Inputs                         : 
'' Author                         : Swetha
''***********************************************************************************************************************************************************************
''***********************************************************************************************************************************************************************
'Initialization steps for current script
''***********************************************************************************************************************************************************************
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True     'Import environment file
'Environment.LoadFromFile "C:\Project_Management\2.Automation\workflow_automation\Configuration\DaVita-Capella_Configuration.xml",True 
'MsgBox Environment.ExternalFileName
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "DiabetesScreening", strOutTestName, strOutErrorDesc) 
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
 strScreenName = "Diabetes Management" 'DataTable.Value("ScreenName","CurrentTestCaseData") 'Screening name
 strDiabetesScreeningTypeADF = DataTable.Value("DiabetesScreeningTypeADF","CurrentTestCaseData") 'Screening type Annual Diabetic Foot Exam
 strDiabetesScreeningTypeDR  = DataTable.Value("DiabetesScreeningTypeDR","CurrentTestCaseData") 'Screening type Diabetic-Retinal Exam
 strDiabetesScreeningResultsAb = DataTable.Value("DiabetesResultsTypeAb","CurrentTestCaseData") 'Screening Result Abnormal
 strDiabetesScreeningResultsPR = DataTable.Value("DiabetesResultsTypePR","CurrentTestCaseData") 'Screening Result Patient refused 
 strDiabetesScreeningResultsNR = DataTable.Value("DiabetesResultsTypeNR","CurrentTestCaseData") 'Screening Result Patient refused 
 dtScreeningDate = DataTable.Value("DateSelectedAbnormal","CurrentTestCaseData")
 dtScreeningDatePR = DataTable.Value("DateSelectedPR","CurrentTestCaseData")
 dtScreeningDateDRAb = DataTable.Value("DateSelectedDRAbnormal","CurrentTestCaseData")
 dtScreeningDateSame = DataTable.Value("DateSelectedSame","CurrentTestCaseData")

''=====================================
'' Objects required for test execution
''=====================================

 Execute "Set objAddButton = " & Environment("WE_DiabetesScreening_Add")

'=====================================
' start test execution
'=====================================
'Login to Capella

isPass = Login("vhn")
If not isPass Then
    Call WriteToLog("Fail","Failed to Login to VHN role.")
    Logout
    Closeallbrowsers
    Call WriteLogFooter()
    ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHES role")

'Close all open patient     
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
    strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
    Call WriteToLog("Fail", strOutErrorDesc)
    Logout
    Closeallbrowsers
    Call WriteLogFooter()
    ExitAction
End If

'Select user roster
isPass = SelectUserRoster(strOutErrorDesc)
If Not isPass Then
    strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
    Call WriteToLog("Fail", strOutErrorDesc)
    Logout
    Closeallbrowsers
    Call WriteLogFooter()
    ExitAction
End If

'==============================
'Open patient from global search
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

'=======================================
'Navigate to Diabeties Management screen
'=======================================

Call WriteToLog("info", "Test Case - Open a patient and navigate to diabeties screening page")

Call clickOnSubMenu("Clinical Management->Diabetes")

wait 2
Call waitTillLoads("Loading...")
wait 2

'Create Object required for existance check of Pathway tab existence on screen

Execute "Set objScreeningTab = "  &Environment("WEL_DiabetesManagement_ScreeningTab") 
If CheckObjectExistence(objScreeningTab,intWaitTime) Then
    Call WriteToLog("Pass","Pathway tab exist on screen name: "&strScreenName)
Else
    Call WriteToLog("Fail","Pathway tab does not exist on screen name: "&strScreenName)
    Logout
    Closeallbrowsers
    Call WriteLogFooter()
    ExitAction
End If

'Click on Pathway tab on screen
blnReturnValue = ClickButton("Screening Tab",objScreeningTab,strOutErrorDesc)
If not blnReturnValue Then
    Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
    Logout
    Closeallbrowsers
    Call WriteLogFooter()
    ExitAction
End If

Wait intWaitTime 'Wait time for applicaton sync

'==========================================================
'Verify the Annual Diabetic Screening with Abnormal results
'==========================================================

Call WriteToLog("info", "Test Case - Add Annual diabetic foot exam and result Abnormal")

Execute "Set objDiabetesScreeningType = " & Environment("WB_DiabetesScreening_Type")
Call selectComboBoxItem(objDiabetesScreeningType, strDiabetesScreeningTypeADF)

Execute "Set objDiabetesScreeningResults = " & Environment("WB_DiabetesScreening_Results")
Call selectComboBoxItem(objDiabetesScreeningResults, strDiabetesScreeningResultsAb)

Execute "Set objDiabetesScreeningAbnormalities = " & Environment("WE_DiabetesScreening_Abnormalities")
Set objRowDescription = Description.Create
objRowDescription("micclass").value = "WebElement"
objRowDescription("html tag").value = "DIV"
objRowDescription("class").value = "col-xs-12 nopadding.*"
Set objAbnormalityRow = objDiabetesScreeningAbnormalities.ChildObjects(objRowDescription)
        
For i=0 to objAbnormalityRow.count-1
    StrAbnormality = objAbnormalityRow(i).GetROProperty("innertext")
    If ((trim(StrAbnormality)) = "Bunions") Then 'lcase(StrBunions)) Then
        Set objRowCheckbox = Description.Create
        objRowCheckbox("micclass").value = "WebElement"
        objRowCheckbox("html tag").value = "DIV"
        objRowCheckbox("class").value = "acp-chkbox left.*"
        Set objAbnormalityRowCheckBox = objAbnormalityRow(i).ChildObjects(objRowCheckbox)
        objAbnormalityRowCheckBox(0).click
    ElseIf ((trim(StrAbnormality)) = "Ingrown Toenails") Then 'lcase(StrBunions)) Then
        Set objRowCheckbox = Description.Create
        objRowCheckbox("micclass").value = "WebElement"
        objRowCheckbox("html tag").value = "DIV"
        objRowCheckbox("class").value = "acp-chkbox left.*"
        Set objAbnormalityRowCheckBox = objAbnormalityRow(i).ChildObjects(objRowCheckbox)
        objAbnormalityRowCheckBox(0).click
    End If
Next

Set objDateSelection = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("class:=.*ng-valid-date.*","html tag:=INPUT","visible:=True")
objDateSelection.Set dtScreeningDate 
 
Execute "Set objCancelButton = " & Environment("WE_DiabetesScreening_Cancel")
objCancelButton.Click
        
'===========================
'Validate the popup message
'===========================

Call WriteToLog("info", "Test Case - Verify the pop up after clicking on the cancel button")

blnReturnValue = checkForPopup("", "NO", "Your current changes will be lost. Do you want to continue?", strOutErrorDesc)
If blnReturnValue Then
    strScreeningType = objDiabetesScreeningType.GetROProperty("innertext")
    If (strDiabetesScreeningTypeADF = trim(strScreeningType)) Then
        Call WriteToLog("Pass","Changes are not deleted and Screening type selected is still: "&strScreeningType)
    Else
        Call WriteToLog("Fail","Changes are deleted")
        Logout
        Closeallbrowsers
        Call WriteLogFooter()
        ExitAction
    End If
End If

''=============================================
''Click on the Add button and verify the popup
''=============================================

Call WriteToLog("info", "Test Case - Add the screening and verify in screening history")

objAddButton.Click

Call waitTillLoads("Loading...")

blnReturnValue = checkForPopup("", "OK", "Diabetic Screening has been saved successfully", strOutErrorDesc)
If blnReturnValue Then
    Call WriteToLog("Pass","Diabetic screening has been saved")
Else
    Call WriteToLog("Fail","Pop up did not show up")
End If
    

'==========================================================
'Verify that Screening History widget is in Collapse mode 
'==========================================================
Call validateInHistory(strDiabetesScreeningTypeADF, strDiabetesScreeningResultsAb, dtScreeningDate)
    
'==========================================================
'Verify the same screening with different results
'==========================================================
Call WriteToLog("info", "Test Case - Add the same screening with diffrent results")
    
Call selectComboBoxItem(objDiabetesScreeningType, strDiabetesScreeningTypeADF)
Call selectComboBoxItem(objDiabetesScreeningResults, strDiabetesScreeningResultsPR)

Execute "Set objDiabetesScreeningRefusedReason = " & Environment("WE_DiabetesScreening_RefusedReason")
Set objRowDescription = Description.Create
objRowDescription("micclass").value = "WebElement"
objRowDescription("html tag").value = "DIV"
objRowDescription("class").value = "col-xs-12 nopadding"
Set objRefusedReasonRow = objDiabetesScreeningRefusedReason.ChildObjects(objRowDescription)
        
For i=0 to objRefusedReasonRow.count-1
    StrRefusedReasonRow = objRefusedReasonRow(i).GetROProperty("innertext")
    If ((trim(StrRefusedReasonRow)) = "Financial Reasons") Then 'lcase(StrBunions)) Then
        Set objRowCheckbox = Description.Create
        objRowCheckbox("micclass").value = "WebElement"
        objRowCheckbox("html tag").value = "DIV"
        objRowCheckbox("class").value = "acp-chkbox left.*"
        Set objRefusedReasonRowCheckBox = objRefusedReasonRow(i).ChildObjects(objRowCheckbox)
        objRefusedReasonRowCheckBox(0).click
    ElseIf ((trim(StrRefusedReasonRow)) = "Transportation Concerns") Then 'lcase(StrBunions)) Then
        Set objRowCheckbox = Description.Create
        objRowCheckbox("micclass").value = "WebElement"
        objRowCheckbox("html tag").value = "DIV"
        objRowCheckbox("class").value = "acp-chkbox left.*"
        Set objRefusedReasonRowCheckBox = objRefusedReasonRow(i).ChildObjects(objRowCheckbox)
        objRefusedReasonRowCheckBox(0).click
    End If
Next

Set objDateSelection1 = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("class:=.*ng-valid-date.*","html tag:=INPUT","visible:=True")
objDateSelection1.Set dtScreeningDatePR

'=============================================
'Click on the Add button and verify the popup
'============================================
objAddButton.Click

wait 2
Call waitTillLoads("Loading...")
wait 2

blnReturnValue = checkForPopup("", "OK", "Diabetic Screening has been saved successfully", strOutErrorDesc)
If blnReturnValue Then
    Call WriteToLog("Pass","Diabetic screening with result as Patient Refused has been saved")
Else
    Call WriteToLog("Fail","Pop up did not show up")
End If
   
'==========================================================
'Verify that Screening History widget is in Collapse mode 
'==========================================================
Call validateInHistory(strDiabetesScreeningTypeADF, strDiabetesScreeningResultsPR, dtScreeningDatePR)
'========================================================================================
'Verify the Annual Diabetic Screening with Normal results added on the same day
'========================================================================================

Call WriteToLog("info", "Test Case - Add the screening on the same date and verify the error")

Call selectComboBoxItem(objDiabetesScreeningType, strDiabetesScreeningTypeADF)

Call selectComboBoxItem(objDiabetesScreeningResults, strDiabetesScreeningResultsNR)

Set objDateSelection2 = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("class:=.*ng-valid-date.*","html tag:=INPUT","visible:=True")
objDateSelection2.Set dtScreeningDateSame

'=============================================
'Click on the Add button and verify the popup
'=============================================

objAddButton.Click

wait 2
Call waitTillLoads("Loading...")
wait 2

blnReturnValue = checkForPopup("Invalid Data", "OK", "Validation Error", strOutErrorDesc)
If blnReturnValue Then
    Call WriteToLog("Pass","The error showing screening cannot be added on the same day is displayed")
Else
    Call WriteToLog("Fail","Pop up did not show up")
    Logout
    Closeallbrowsers
    Call WriteLogFooter()
    ExitAction
End If    
    
    
'==================================================================================================
'------------------------------------Diabetic Retinal Exam------------------------------------------
'==================================================================================================
Call WriteToLog("info", "Test Case - Add Diabetic retinal exam and result Abnormal and complete pathway")
    
Call selectComboBoxItem(objDiabetesScreeningType, strDiabetesScreeningTypeDR)
wait 2
Call waitTillLoads("Loading...")
wait 2
Call selectComboBoxItem(objDiabetesScreeningResults, strDiabetesScreeningResultsAb)
wait 2
Call waitTillLoads("Loading...")
wait 2
Execute "Set objDiabetesScreeningAbnormalities = " & Environment("WE_DiabetesScreening_Abnormalities")
        Set objRowDescription = Description.Create
        objRowDescription("micclass").value = "WebElement"
        objRowDescription("html tag").value = "DIV"
        objRowDescription("class").value = "col-xs-12 nopadding.*"
        Set objAbnormalityDRRow = objDiabetesScreeningAbnormalities.ChildObjects(objRowDescription)
        
For i=0 to objAbnormalityDRRow.count-1
    StrAbnormalityDR = objAbnormalityDRRow(i).GetROProperty("innertext")
    If ((trim(StrAbnormalityDR)) = "Cataract") Then 
        Set objRowCheckbox = Description.Create
        objRowCheckbox("micclass").value = "WebElement"
        objRowCheckbox("html tag").value = "DIV"
        objRowCheckbox("class").value = "acp-chkbox left.*"
        Set objAbnormalityDRRowCheckBox = objAbnormalityDRRow(i).ChildObjects(objRowCheckbox)
        objAbnormalityDRRowCheckBox(0).click
    ElseIf ((trim(StrAbnormalityDR)) = "Retinopathy") Then
        Set objRowCheckbox = Description.Create
        objRowCheckbox("micclass").value = "WebElement"
        objRowCheckbox("html tag").value = "DIV"
        objRowCheckbox("class").value = "acp-chkbox left.*"
        Set objAbnormalityDRRowCheckBox = objAbnormalityDRRow(i).ChildObjects(objRowCheckbox)
        objAbnormalityDRRowCheckBox(0).click
    End If
Next

Set objDateSelection = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("class:=.*ng-valid-date.*","html tag:=INPUT","visible:=True")
objDateSelection.Set dtScreeningDateDRAb

'===========================================================================
'Click on the Add button without completing the pathway and verify the popup
'===========================================================================
objAddButton.Click

wait 2
Call waitTillLoads("Loading...")
wait 2

blnReturnValue = checkForPopup("Error", "OK", "Please complete the pathway", strOutErrorDesc)
If blnReturnValue Then
    Call WriteToLog("Pass","Please complete the pathway error showed up")
Else
    Call WriteToLog("Fail","Please complete the pathway error pop up did not show up")
End If

'============================================================
'Complete the pathway for Diabetic Retinal Exam 
'============================================================

Set objPage = getPageObject()
Set objOption = Description.Create
objOption("micclass").value = "WebElement"
objOption("class").value = "acp-radio"

Set objOptions = objPage.ChildObjects(objOption)

objOptions(0).click

' Add the screening after the pathway is complete

objAddButton.Click

wait 2
Call waitTillLoads("Loading...")
wait 2

blnReturnValue = checkForPopup("", "OK", "Diabetic Screening has been saved successfully", strOutErrorDesc)
If blnReturnValue Then
    Call WriteToLog("Pass","Diabetic screening with result as Abnormal has been saved")
Else
    Call WriteToLog("Fail","Pop up did not show up")
End If

'============================================================
'Verify the recently added screening in the Screening History 
'============================================================
Call validateInHistory(strDiabetesScreeningTypeDR, strDiabetesScreeningResultsAb, dtScreeningDateDRAb)
'#################################################    End: Test Case Execution  #################################################

'logout of the application
 Logout
 Closeallbrowsers
 Call WriteLogFooter()

'kill all the used objects.
killAllObjects

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


Function validateInHistory(ByVal reqType, ByVal results, ByVal reqDate)
	validateInHistory = false
	Execute "Set objScreeningHistory = " & Environment("WE_Diabetes_ScreeningHistory")
	objScreeningHistory.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Set objTable = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebTable("class:=k-selectable", "cols:=7")
	
	If not objTable.Exist(2) Then
		Call WriteToLog("Fail", "History table is not loaded")
		Exit Function
	End If
	
	reqDescrip = descrip
	Dim isFound : isFound = false
	maxRows = objTable.GetROProperty("rows")
	For curRow = 1 To maxRows
		descrip = objTable.GetCellData(curRow,2)
		dateVal = objTable.GetCellData(curRow, 7)
		If trim(descrip) = reqType and CDate(trim(dateVal)) = CDate(reqDate) Then
			isFound = true
			tabResults = objTable.GetCellData(curRow, 3)
									
			'validate given value in history
			If trim(tabResults) = results Then
				Call WriteToLog("Pass", "The type '" & reqType & "' for the date '" & reqDate & "' with the results '" & results & "' is updated in history.")
			Else
				Call WriteToLog("Fail", "The type '" & reqType & "' for the date '" & reqDate & "' with the results '" & results & "' is NOT updated in history.")
			End If
			
			Exit For
		End If
	Next
	
	If not isFound  Then
		Call WriteToLog("Fail", "History NOT found for the required type '" & reqType & "' and date '" & reqDate & "'.")
		Exit Function
	End If
	
	objScreeningHistory.Click
	
	validateInHistory = true
End Function

