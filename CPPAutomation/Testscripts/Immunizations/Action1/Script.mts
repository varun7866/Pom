' TestCase Name			: Immunizations
' Purpose of TC			: To perform Immunizations
' Author                : Sudheer
' Date					: 17-Sep-2015
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Immunizations", strOutTestName, strOutErrorDesc) 
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
	Execute "Set objLastInfluVacDate = " & Environment("WE_LastInfluVaccineDate")
	Execute "Set objInfluSource = " & Environment("WE_InfluSource")
	Execute "Set objInfluGiven = " & Environment("WE_InfluGiven")
	Execute "Set objLastPneumVacDate = " & Environment("WE_LastPneumVaccineDate")
	Execute "Set objPneumSource = " & Environment("WE_PneumSource")
	Execute "Set objPneumGiven = " & Environment("WE_PneumGiven")
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
Dim isRun
isRun = false
intRowCount = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCount step 1
	DataTable.SetCurrentRow(RowNumber)
	
	runflag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
	
	If trim(lcase(runflag)) = "y" Then
		'close all open patients
		isRun = true
'		isPass = CloseAllOpenPatient(strOutErrorDesc)
'		If Not isPass Then
'			strOutErrorDesc = "CloseAllOpenPatient returned error: " & strOutErrorDesc
'			Call WriteToLog("Fail", strOutErrorDesc)
'			Logout
'			CloseAllBrowsers
'			Call WriteLogFooter()
'			ExitAction
'		End If
	
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
		
		'wait till the member loads
'		wait 2
'		waitTillLoads "Loading..."
'		wait 2
		
		Call WriteToLog("info", "Test Case - Pain Assessment Screening for the member id - " & strMemberID)
		
		isPass = immunizations()
		If Not isPass Then
			Call WriteToLog("Fail", "Adding Immunization failed for the member - " & strMemberID)
		End If
	End If	
Next

If not isRun Then
	Call WriteToLog("info", "There are rows marked Y(Yes) for execution.")
End If

'killAllObjects
'Logout
'CloseAllBrowsers
'WriteLogFooter


Function immunizations()
	immunizations = false
	intWaitTime = 5
	
	'click on Immunizations
'	clickOnSubMenu("Clinical Management->Immunizations")
'		
'	wait 2
'	waitTillLoads "Loading..."
'	wait 2
	
	loadObjects
'	intWaitTime = 5
'	'validate the item titles - Last Influenza Vaccine Date
'	Call WriteToLog("info", "Test Case - Verify Last Influenza Vaccine Date  exists")
'	If CheckObjectExistence(objLastInfluVacDate,intWaitTime) Then
'		Call WriteToLog("Pass","Last Influenza Vaccine Date  title exists")		
'	Else
'		Call WriteToLog("Fail","Last Influenza Vaccine Date  title does not exists")	
'	End If
'	'validate the item titles - Influenza Source
'	Call WriteToLog("info", "Test Case - Verify Influenza Source exists")
'	If CheckObjectExistence(objInfluSource,intWaitTime) Then
'		Call WriteToLog("Pass","Influenza Source title exists")		
'	Else
'		Call WriteToLog("Fail","Influenza Source title does not exists")	
'	End If
'	'validate the item titles - Influenza Given
'	Call WriteToLog("info", "Test Case - Verify Influenza Given exists")
'	If CheckObjectExistence(objInfluGiven,intWaitTime) Then
'		Call WriteToLog("Pass","Influenza Given title exists")		
'	Else
'		Call WriteToLog("Fail","Influenza Given title does not exists")	
'	End If
'	'validate the item titles - Last Pneumoccocal Vaccine Date 
'	Call WriteToLog("info", "Test Case - Verify Last Pneumoccocal Vaccine Date   exists")
'	If CheckObjectExistence(objLastPneumVacDate,intWaitTime) Then
'		Call WriteToLog("Pass","Last Pneumoccocal Vaccine Date title exists")		
'	Else
'		Call WriteToLog("Fail","Last Pneumoccocal Vaccine Date title does not exists")	
'	End If
'	'validate the item titles - Pneumoccocal Source
'	Call WriteToLog("info", "Test Case - Verify Pneumoccocal Source exists")
'	If CheckObjectExistence(objPneumSource,intWaitTime) Then
'		Call WriteToLog("Pass","Pneumoccocal Source title exists")		
'	Else
'		Call WriteToLog("Fail","Pneumoccocal Source title does not exists")	
'	End If
'	'validate the item titles - Pneumoccocal Given
'	Call WriteToLog("info", "Test Case - Verify Pneumoccocal Given exists")
'	If CheckObjectExistence(objPneumGiven,intWaitTime) Then
'		Call WriteToLog("Pass","Pneumoccocal Given title exists")		
'	Else
'		Call WriteToLog("Fail","Pneumoccocal Given title does not exists")	
'	End If
'	
'	
'	'verify Type drop down values
'	Execute "Set objTypeDD = " & Environment("WB_Immunization_Type")
'	isPass = validateValueExistInDropDown(objTypeDD, "Hepatitis B")
'	If not isPass Then
'		Call WriteToLog("Fail", "Type 'Hepatitis B' is not exist in Type drop down.")
'	Else
'		Call WriteToLog("Pass", "Type 'Hepatitis B' is exist in Type drop down.")
'	End If	
'	isPass = validateValueExistInDropDown(objTypeDD, "Influenza Vaccine")
'	If not isPass Then
'		Call WriteToLog("Fail", "Type 'Influenza Vaccine' is not exist in Type drop down.")
'	Else
'		Call WriteToLog("Pass", "Type 'Influenza Vaccine' is exist in Type drop down.")
'	End If
'	
'	wait 2
'	waitTillLoads "Loading..."
'	wait 2
'	
'	isPass = validateValueExistInDropDown(objTypeDD, "Pneumococcal Vaccine")
'	If not isPass Then
'		Call WriteToLog("Fail", "Type 'Pneumococcal Vaccine' is not exist in Type drop down.")
'	Else
'		Call WriteToLog("Pass", "Type 'Pneumococcal Vaccine' is exist in Type drop down.")
'	End If
'	
'	wait 2
'	waitTillLoads "Loading..."
'	wait 2
'	
'	isPass = validateValueExistInDropDown(objTypeDD, "Tetanus-Diphtheria Booster")Tetanus-Diphtheria Booster
'	If not isPass Then
'		Call WriteToLog("Fail", "Type 'Tetanus-Diphtheria Booster' is not exist in Type drop down.")
'	Else
'		Call WriteToLog("Pass", "Type 'Tetanus-Diphtheria Booster' is exist in Type drop down.")
'	End If
'	
	'validate Hepatitis B workflow
	Call WriteToLog("info", "Test Case - validate Hepatitis B type")
	Execute "Set objTypeDD = " & Environment("WB_Immunization_Type")
	isPass = selectComboBoxItem(objTypeDD, "Hepatitis B")
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select 'Hepatitis B' in type drop down.")
		Exit Function
	End If
	
	wait 2
	
	'verify add button enabled
	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
	If NOT objAddBtn.Object.isDisabled then
		Call WriteToLog("Pass", "Add button is enabled as expected after selecting Hepatitis B type.")
	Else
		Call WriteToLog("Fail", "Add button should be enabled after selecting Hepatitis B type.")
	End If
	'verify brand name drop down values for type hepatitis B
	Execute "Set objBrandNameDD = " & Environment("WB_Immunization_BrandName")
'	isPass = validateValuesExistInDropDown(objBrandNameDD, "Afluria;Flucelvax;Flulaval;Fluvirin;Fluzone;Other;Unknown")
	isPass = validateValuesExistInDropDown(objBrandNameDD, "Unknown")
	If not isPass Then
		Call WriteToLog("Fail", "Failed to verify brand name drop down.")
		Exit Function
	End If
	'select unknown in given drop down
	isPass = selectComboBoxItem(objBrandNameDD, "Unknown")
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select 'Unknown' in Brand Name drop down.")
		Exit Function
	End If
	
	'select yes in given
	Execute "Set objGivenDD = " & Environment.Value("WB_Immunization_Given")
	isPass = selectComboBoxItem(objGivenDD, "Yes")
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select 'Yes' in Given drop down.")
		Exit Function
	End If
	
	'verify Reason Not given is disabled
	Set objReasonNotKnownDD = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("class:=btn btn-default.*", "html id:=immunizationreasonnotgiven-dropdown")
	If objReasonNotKnownDD.Object.isDisabled Then
		Call WriteToLog("Pass", "Reason Not known drop down is disabled as expected when Given is 'Yes'")
	Else
		Call WriteToLog("Fail", "Reason Not known drop down is NOT disabled as expected when Given is 'Yes'")
	End If
	
	'validate if today's date is selected by default
	Set objDate = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("placeholder:=<MM/dd/yyyy>")
	dater = objDate.getROProperty("value")
	
	If CDate(dater) = date Then
		Call WriteToLog("Pass", "Default date is - " & dater & " as expected.")
	Else
		Call WriteToLog("Fail", "Default date is - " & dater & ", but expected is today's date.")
	End If
	
	'verify Add button is enabled
	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
	If NOT objAddBtn.Object.isDisabled then
		Call WriteToLog("Pass", "Add button is enabled as expected after all values selected for Hepatitis B type.")
	Else
		Call WriteToLog("Fail", "Add button should be enabled after all values selected for Hepatitis B type.")
	End If
	
	'change Given to No
	Execute "Set objGivenDD = " & Environment.Value("WB_Immunization_Given")
	isPass = selectComboBoxItem(objGivenDD, "No")
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select 'No' in Given drop down.")
		Exit Function
	End If
	
	wait 2
	'verify Reason Not known is enabled
	Set objReasonNotKnownDD = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("class:=btn btn-default.*", "html id:=immunizationreasonnotgiven-dropdown")
	If Not objReasonNotKnownDD.Object.isDisabled Then
		Call WriteToLog("Pass", "Reason Not known drop down is enabled as expected when Given is 'No'")
	Else
		Call WriteToLog("Fail", "Reason Not known drop down is NOT enabled as expected when Given is 'No'")
	End If
	
	'verify add button is disabled
	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
	If objAddBtn.Object.isDisabled then
		Call WriteToLog("Pass", "Add button is disabled as expected after selecting No for Given.")
	Else
		Call WriteToLog("Fail", "Add button should be disabled after selecting No for Given")
	End If
	
	'select reason not known 
	isPass = selectComboBoxItem(objReasonNotKnownDD, "Allergic")
	'validate if today's date is selected by default
	Set objDate = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("placeholder:=<MM/dd/yyyy>")
	dater = objDate.getROProperty("value")
	
	If CDate(dater) = date Then
		Call WriteToLog("Pass", "Default date is - " & dater & " as expected.")
	Else
		Call WriteToLog("Fail", "Default date is - " & dater & ", but expected is today's date.")
	End If
	
	wait 2
	'verify Add button is enabled
	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
	If Not objAddBtn.Object.isDisabled then
		Call WriteToLog("Pass", "Add button is enabled as expected after all values selected for Hepatitis B type.")
	Else
		Call WriteToLog("Fail", "Add button should be enabled after all values selected for Hepatitis B type.")
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	isPass = addImmunizations("Hepatitis B", "Unknown", "No", "Allergic", "", date - 9)
	'end of validate Hepatitis B workflow
	
	'validate workflow for Tetanus-Diptheria Booster
'	Call WriteToLog("info", "Test Case - validate Tetanus-Diphtheria Booster type")
'	Execute "Set objTypeDD = " & Environment("WB_Immunization_Type")
'	isPass = selectComboBoxItem(objTypeDD, "Tetanus-Diphtheria Booster")
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to select 'Tetanus-Diphtheria Booster' in type drop down.")
'		Exit Function
'	End If
'	
'	wait 2
'	
'	'verify add button enabled
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If NOT objAddBtn.Object.isDisabled then
'		Call WriteToLog("Pass", "Add button is enabled as expected after selecting Hepatitis B type.")
'	Else
'		Call WriteToLog("Fail", "Add button should be enabled after selecting Hepatitis B type.")
'	End If
'	
'	'verify brand name drop down values for type hepatitis B
'	Execute "Set objBrandNameDD = " & Environment("WB_Immunization_BrandName")
''	isPass = validateValuesExistInDropDown(objBrandNameDD, "Afluria;Flucelvax;Flulaval;Fluvirin;Fluzone;Other;Unknown")
'	isPass = validateValuesExistInDropDown(objBrandNameDD, "Unknown")
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to verify brand name drop down.")
'		Exit Function
'	End If
'	'select unknown in given drop down
'	isPass = selectComboBoxItem(objBrandNameDD, "Unknown")
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to select 'Unknown' in Brand Name drop down.")
'		Exit Function
'	End If
'	
'	'select yes in given
'	Execute "Set objGivenDD = " & Environment.Value("WB_Immunization_Given")
'	isPass = selectComboBoxItem(objGivenDD, "Yes")
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to select 'Yes' in Given drop down.")
'		Exit Function
'	End If
'	
'	'verify Reason Not given is disabled
'	Set objReasonNotKnownDD = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("class:=btn btn-default.*", "html id:=immunizationreasonnotgiven-dropdown")
'	If objReasonNotKnownDD.Object.isDisabled Then
'		Call WriteToLog("Pass", "Reason Not known drop down is disabled as expected when Given is 'Yes'")
'	Else
'		Call WriteToLog("Fail", "Reason Not known drop down is NOT disabled as expected when Given is 'Yes'")
'	End If
'	
'	'validate if today's date is selected by default
'	Set objDate = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("placeholder:=<MM/dd/yyyy>")
'	dater = objDate.getROProperty("value")
'	
'	If CDate(dater) = date Then
'		Call WriteToLog("Pass", "Default date is - " & dater & " as expected.")
'	Else
'		Call WriteToLog("Fail", "Default date is - " & dater & ", but expected is today's date.")
'	End If
'	
'	'verify Add button is enabled
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If NOT objAddBtn.Object.isDisabled then
'		Call WriteToLog("Pass", "Add button is enabled as expected after all values selected for Hepatitis B type.")
'	Else
'		Call WriteToLog("Fail", "Add button should be enabled after all values selected for Hepatitis B type.")
'	End If
'	
'	'change Given to No
'	Execute "Set objGivenDD = " & Environment.Value("WB_Immunization_Given")
'	isPass = selectComboBoxItem(objGivenDD, "No")
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to select 'No' in Given drop down.")
'		Exit Function
'	End If
'	
'	wait 2
'	'verify Reason Not known is enabled
'	Set objReasonNotKnownDD = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("class:=btn btn-default.*", "html id:=immunizationreasonnotgiven-dropdown")
'	If Not objReasonNotKnownDD.Object.isDisabled Then
'		Call WriteToLog("Pass", "Reason Not known drop down is enabled as expected when Given is 'No'")
'	Else
'		Call WriteToLog("Fail", "Reason Not known drop down is NOT enabled as expected when Given is 'No'")
'	End If
'	
'	'verify add button is disabled
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If objAddBtn.Object.isDisabled then
'		Call WriteToLog("Pass", "Add button is disabled as expected after selecting No for Given.")
'	Else
'		Call WriteToLog("Fail", "Add button should be disabled after selecting No for Given")
'	End If
'	
'	'select reason not known 
'	isPass = selectComboBoxItem(objReasonNotKnownDD, "Medically Contraindicated")
'	'validate if today's date is selected by default
'	Set objDate = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("placeholder:=<MM/dd/yyyy>")
'	dater = objDate.getROProperty("value")
'	
'	If CDate(dater) = date Then
'		Call WriteToLog("Pass", "Default date is - " & dater & " as expected.")
'	Else
'		Call WriteToLog("Fail", "Default date is - " & dater & ", but expected is today's date.")
'	End If
'	wait 2
'	'verify add button is disabled
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If objAddBtn.Object.isDisabled then
'		Call WriteToLog("Pass", "Add button is disabled as expected after selecting No for Given.")
'	Else
'		Call WriteToLog("Fail", "Add button should be disabled after selecting No for Given")
'	End If
'	
'	'validate Med. Contr. Detail field
'	Execute "Set objMedContDetail = " & Environment("WE_Immunization_MedContrDetail")
'	If Not objMedContDetail.Exist(2) Then
'		Call WriteToLog("Fail", "Med. Contr. Detail field does not exist.")
'	End If
'	objMedContDetail.Set "Testing..."
'	wait 2
'	'verify Add button is enabled
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If Not objAddBtn.Object.isDisabled then
'		Call WriteToLog("Pass", "Add button is enabled as expected after all values selected for Tetanus-Diphtheria Booster type.")
'	Else
'		Call WriteToLog("Fail", "Add button should be enabled after all values selected for Tetanus-Diphtheria Booster type.")
'		Exit Function
'	End If
'	
'	isPass = addImmunizations("Tetanus-Diphtheria Booster", "Unknown", "No", "Allergic", "", date - 10)
	'end of validate Tetanus-Diptheria Booster
	
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If not objAddBtn.Exist(2) then
'		Call WriteToLog("Pass", "Add button is disabled as expected before selecting Given.")
'	Else
'		Call WriteToLog("Fail", "Add button should be disabled before selecting Given")
'	End If
'	
'	Execute "Set objGivenDD = " & Environment.Value("WB_Immunization_Given")
'	isPass = selectComboBoxItem(objGivenDD, "Yes")
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to select 'Yes' in Given drop down.")
'		Exit Function
'	End If
'	
'	wait 2
'	
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If objAddBtn.Exist(2) then
'		Call WriteToLog("Pass", "Add button is enabled as expected after selecting Given")
'	Else
'		Call WriteToLog("Fail", "Add button should be enabled after selecting Given")
'	End If
'	
'	'verify Reason Not Known dropdown is disabled
'	Set objReasonNotKnownDD = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("class:=btn btn-default.*", "html id:=immunizationreasonnotgiven-dropdown")
'	If objReasonNotKnownDD.Object.isDisabled Then
'		Call WriteToLog("Pass", "Reason Not known drop down is disabled as expected when Given is 'Yes'")
'	Else
'		Call WriteToLog("Fail", "Reason Not known drop down is NOT disabled as expected when Given is 'Yes'")
'	End If
'	
'	isPass = selectComboBoxItem(objGivenDD, "No")
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to select 'Yes' in Given drop down.")
'		Exit Function
'	End If
'	
'	wait 2
'	
'	If Not objReasonNotKnownDD.Object.isDisabled Then
'		Call WriteToLog("Pass", "Reason Not known drop down is enabled as expected when Given is 'No'")
'	Else
'		Call WriteToLog("Fail", "Reason Not known drop down is NOT enabled as expected when Given is 'No'")
'	End If
'	
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If not objAddBtn.Exist(2) then
'		Call WriteToLog("Pass", "Add button is disabled as expected after selecting Given as 'No'")
'	Else
'		Call WriteToLog("Fail", "Add button should be disabled after selecting Given as 'No'")
'	End If
'	
'	'validate Reason Not Known drop down values to be - Allergic, Medically Contraindicated, Not Available, Patient Refused
'	isPass = validateValueExistInDropDown(objReasonNotKnownDD, "Allergic")
'	If not isPass Then
'		Call WriteToLog("Fail", "Type 'Allergic' is not exist in Type drop down.")
'	Else
'		Call WriteToLog("Pass", "Type 'Allergic' is exist in Type drop down.")
'	End If
'	
'	isPass = validateValueExistInDropDown(objReasonNotKnownDD, "Medically Contraindicated")
'	If not isPass Then
'		Call WriteToLog("Fail", "Type 'Medically Contraindicated' is not exist in Type drop down.")
'	Else
'		Call WriteToLog("Pass", "Type 'Medically Contraindicated' is exist in Type drop down.")
'	End If
'	
'	isPass = validateValueExistInDropDown(objReasonNotKnownDD, "Not Available")
'	If not isPass Then
'		Call WriteToLog("Fail", "Type 'Not Available' is not exist in Type drop down.")
'	Else
'		Call WriteToLog("Pass", "Type 'Not Available' is exist in Type drop down.")
'	End If
'	
'	isPass = validateValueExistInDropDown(objReasonNotKnownDD, "Patient Refused")
'	If not isPass Then
'		Call WriteToLog("Fail", "Type 'Patient Refused' is not exist in Type drop down.")
'	Else
'		Call WriteToLog("Pass", "Type 'Patient Refused' is exist in Type drop down.")
'	End If
'	
'	'update date
'	Set objDate = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("html tag:=INPUT", "class:=form-control.*")
'	objDate.Set date - 3
'	
'	'click on add button
'	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
'	If objAddBtn.Exist(2) then
'		Call WriteToLog("Pass", "Add button is enabled as expected.")
'	Else
'		Call WriteToLog("Fail", "Add button should be enabled.")
'	End If
'	
'	isPass = ClickButton("Add", objAddBtn, strOutErrorDesc)
'	If not isPass Then
'		Call WriteToLog("Fail", "Failed to click on Add butoton")
'		Exit Function
'	End If
'	
'	wait 2
'	waitTillLoads "Loading..."
'	wait 2
	
'	isPass = checkForPopup("", "Ok", "Immunizations has been saved successfully", strOutErrorDesc)
'	
'	wait 2
'	waitTillLoads "Loading..."
'	wait 2
	
'	verifyImmunizationHistory "Hepatitis B", "No", "Patient Refused", "VHN", date - 1
'	verifyImmunizationHistory "Pneumococcal Vaccine", "Yes", "", "VHN", "11/10/2015"
End Function

Function verifyImmunizationHistory(ByVal descrip, ByVal givenVal, ByVal reasonNotKnown, ByVal reqSource, ByVal reqDate)
'	On Error Resume Next
'	Err.Clear
	verifyImmunizationHistory = false
	Execute "Set objImm_ScrHistUpArw = " & Environment("WB_Immunization_History_UpArrow")
	objImm_ScrHistUpArw.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Set objTable = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebTable("class:=k-selectable", "cols:=6")
	
	If not objTable.Exist(2) Then
		Call WriteToLog("Fail", "History table is not loaded")
		Exit Function
	End If
	
'	Dim reqDescrip
'	Select Case descrip
'		Case "Hepatitis B"
'			reqDescrip = "HEPB"
'		Case ""
'			reqDescrip = "DPT" 
'	End Select
	reqDescrip = descrip
	Dim isFound : isFound = false
	maxRows = objTable.GetROProperty("rows")
	For curRow = 1 To maxRows
		descrip = objTable.GetCellData(curRow,2)
		dateVal = objTable.GetCellData(curRow, 6)
		If descrip = reqDescrip and CDate(dateVal) = CDate(reqDate) Then
			isFound = true
			givenValue = objTable.GetCellData(curRow, 3)
			reason = objTable.GetCellData(curRow, 4)
			sourceVal = objTable.GetCellData(curRow, 5)
						
			'validate given value in history
			If givenVal = givenValue Then
				Call WriteToLog("Pass", "Given value is '" & givenValue & "' for the type '" & descrip & "' and date '" & reqDate & "' as expected.")
			Else
				Call WriteToLog("Fail", "Given value is '" & givenValue & "', but expected is '" & givenVal & "' for the type '" & descrip & "' and date '" & reqDate & "'.")
			End If
			'validate reason not known value in history
			If reason = reasonNotKnown Then
				Call WriteToLog("Pass", "Reason Not Given value is '" & reasonNotKnown & "' for the type '" & descrip & "' and date '" & reqDate & "' as expected.")
			Else
				Call WriteToLog("Fail", "Reason Not Given value is '" & reason & "', but expected is '" & reasonNotKnown & "' for the type '" & descrip & "' and date '" & reqDate & "'.")
			End If
			'validate source in history
			If sourceVal = reqSource Then
				Call WriteToLog("Pass", "Source value is '" & sourceVal & "' for the type '" & descrip & "' and date '" & reqDate & "' as expected.")
			Else
				Call WriteToLog("Fail", "Source value is '" & sourceVal & "', but expected is '" & reqSource & "' for the type '" & descrip & "' and date '" & reqDate & "'.")
			End If
			
			Select Case descrip
				Case "Pneumococcal Vaccine"
					if objTable.ChildItem(curRow, 1, "Link", 0).Exist(2) Then
						objTable.ChildItem(curRow, 1, "Link", 0).Click
						wait 1
						
						Set objPage = getPageObject()
						Set oDesc = Description.Create
						oDesc("micclass").Value = "WebElement"
						oDesc("class").Value = "pathQuestions ng-scope"
						
						Set oQuestion = objPage.ChildObjects(oDesc)
						For i = 0 To oQuestion.Count - 1
							oQuestion(i).WebElement("class:=pathQues ng-binding").GetROProperty("innerhtml")
							
						Next
					End If
			End Select
			
			Exit For
		End If
	Next
	
	If not isFound  Then
		Call WriteToLog("Fail", "History NOT found for the required type '" & reqDescrip & "' and date '" & reqDate & "'.")
		Exit Function
	End If
	
	Execute "Set objImm_ScrHistDwnArw = " & Environment("WB_Immunization_History_DownArrow")
	objImm_ScrHistDwnArw.Click
	
	verifyImmunizationHistory = true
	
End Function

Function addImmunizations(ByVal immType, ByVal brandName, ByVal given, ByVal reasonNotGiven, ByVal medContrDetails, ByVal dated)
	On Error Resume Next
	Err.Clear
	addImmunizations = false
	
	Execute "Set objTypeDD = " & Environment("WB_Immunization_Type")
	isPass = selectComboBoxItem(objTypeDD, immType)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select '" & immType & "' in type drop down.")
		Exit Function
	End If
	
	wait 2
	
	Execute "Set objBrandNameDD = " & Environment("WB_Immunization_BrandName")
	'select brand name in brand name drop down
	isPass = selectComboBoxItem(objBrandNameDD, brandName)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select 'Unknown' in Brand Name drop down.")
		Exit Function
	End If
	
	'select in given
	Execute "Set objGivenDD = " & Environment.Value("WB_Immunization_Given")
	isPass = selectComboBoxItem(objGivenDD, given)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select '" & given & "' in Given drop down.")
		Exit Function
	End If
	
	'select reason not given 
	Set objReasonNotKnownDD = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("class:=btn btn-default.*", "html id:=immunizationreasonnotgiven-dropdown")	
	isPass = selectComboBoxItem(objReasonNotKnownDD, reasonNotGiven)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select '" & reasonNotGiven & "' in Reason Not Given drop down.")
		Exit Function
	End If
	
	If reasonNotGiven = "Medically Contraindicated" Then
		'validate Med. Contr. Detail field
		Execute "Set objMedContDetail = " & Environment("WE_Immunization_MedContrDetail")
		If Not objMedContDetail.Exist(2) Then
			Call WriteToLog("Fail", "Med. Contr. Detail field does not exist.")
		End If
		objMedContDetail.Set "Testing..."
	End If
	
	'validate if today's date is selected by default
'	Set objDate = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebEdit("placeholder:=<MM/dd/yyyy>")
'	objDate.Set dated
	Set objCal = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("class:=btn btn-default btn-dt-icon", "html tag:=BUTTON")
	strMonth = getMonth(Month(Cdate(dated)))
	If strMonth = "NA" Then
		Call WriteToLog("Fail", "Failed to retrieve the month for the date - '" & dated & "'")
		Exit Function
	End If
	
	isPass = calendarFunction(objCal, Day(CDate(dated)), strMonth, Year(CDate(dated)))
	wait 2
	'verify Add button is enabled
	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
	If objAddBtn.Object.isDisabled then
		Call WriteToLog("Fail", "Add button should be enabled after all values selected for Tetanus-Diphtheria Booster type.")
		Exit Function
	End If
	
	'click on add button
	Execute "Set objAddBtn = " & Environment("WE_Immunization_AddButton")
	isPass = ClickButton("Add", objAddBtn, strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to click on Add button.")
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	isPass = checkForPopup("", "Ok", "Immunizations has been saved successfully", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to find the message box.")
		Exit Function
	End If
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	isPass = verifyImmunizationHistory(immType, given, reasonNotGiven, "VHN", dated)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to verify immunization history")
		Exit Function
	End If
	addImmunizations = true
End Function

Function getMonth(ByVal mon)
	Dim mont
	mont = "NA"
	Select Case mon
		Case "01"
			mont = "January"
		Case "02"
			mont = "February"
		Case "03"
			mont = "March"
		Case "04"
			mont = "April"	
		Case "05"
			mont = "May"
		Case "06"
			mont = "June"
		Case "07"
			mont = "July"
		Case "08"
			mont = "August"
		Case "09"
			mont = "September"
		Case "10"
			mont = "October"
		Case "11"
			mont = "November"
		Case "12"
			mont = "December"
		
	End Select
	
	getMonth = mont
End Function
