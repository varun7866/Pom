' TestCase Name			: CreateNewPatient
' Purpose of TC			: To verify all the functionality of the Matrial Fulfillment screen, Including placing order for Medicla Authorization Form.
' Author                : Sudheer
' Comments				: Script will be modified as per user story change.
'**************************************************************************************************************************************************************************
'***********************************************************************************************************************************************************************
'Initialization steps for current script
'***********************************************************************************************************************************************************************
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file
Environment.LoadFromFile "C:\Project_Management\2.Automation\workflow_automation\Configuration\DaVita-Capella_Configuration.xml",True 
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "CreateNewPatient", strOutTestName, strOutErrorDesc) 
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
' start test execution
'=====================================
Set objFso = CreateObject("Scripting.FileSystemObject")
consentsLibFolder = Environment.Value("PROJECT_FOLDER") & "\Library\consents_functions"
For each objFile in objFso.GetFolder(consentsLibFolder).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" Then
		LoadFunctionLibrary objFile.Path
	End If
Next
Set objFso = Nothing

Call WriteToLog("info", "Test case - Create a new patient using EPS role")
'Login to Capella as EPS
isPass = Login("eps")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to EPS role.")
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

'close all open patients
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into EPS role")

Call clickOnMainMenu("My Dashboard")
wait 2
Call waitTillLoads("Loading...")
wait 2

strMember = createNewPatient()

Print strMember

If trim(strMember) = "" or trim(strMember) = "NA" Then
	Call WriteToLog("Fail", "There was an error retrieving member id.")
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If
'Call WriteToLog("Pass", "A new patient has been created with member Id - '" & strMember & "'")

strEnrollmentStatus = DataTable.Value("ExpectedEPSStatus", "CurrentTestCaseData")
If strEnrollmentStatus = "Enrolled" Then
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction
End If
Logout
CloseAllBrowsers

Call WriteToLog("info", "Test case - Do Enrollment Screening, so the eligibility status changes to 'Enrolled'")
'Login to Capella as VHES
isPass = Login("vhes")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHES role.")
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHES role")
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'Search for the patient
selectPatientFromGlobalSearch strMember
wait 2
Call waitTillLoads("Loading...")

'Do enrollment screening for the patient
Call clickOnSubMenu("Screenings->Enrollment Screening")

wait 2
Call waitTillLoads("Loading...")
isPass = enrollmentScreening()
If not isPass Then
	Logout
	CloseAllBrowsers
	WriteLogFooter
End If

'verify status changed to Enrolled
wait 2
waitTillLoads "Loading..."
wait 2

Call clickOnSubMenu("Member Info->Patient Info")

wait 2
waitTillLoads "Loading..."
wait 2

Execute "Set objEnrollmentStatus = " & Environment("WEL_EnrollStatus")
If not objEnrollmentStatus.Exist(intWaitTime) Then
	Call WriteToLog("Fail", "Status field on Enrollment screen does not exist")
End If

'Check the patient status should be reffered 
strEnrollmentStatus = "Enrolled"
strPatientStatus = objEnrollmentStatus.getRoProperty("innertext")
If Trim(strPatientStatus) = Trim(strEnrollmentStatus) Then
	Call WriteToLog("Pass","Patient eligibility status is changed as expected to - " & strPatientStatus)
Else	
	Call WriteToLog("Fail","Patient eligibility status is changed to Enrolled as expected. It is - "& strPatientStatus)
End If

Logout
CloseAllBrowsers

Call WriteToLog("info", "Test case - Complete the initial IPE tasks using VHN role")
'Login to Capella as VHN
isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

'close all open patients
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

isPass = selectPatientFromGlobalSearch(strMember)
If Not isPass Then
	strOutErrorDesc = "selectPatientFromGlobalSearch returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

'click on Menu of Actions panel
Set objPage = getPageObject()
Set objMOARightArrow = objPage.Image("class:=a-2 left moa-ribbon-expand-collapse-img")
objMOARightArrow.highlight
objMOARightArrow.Click
Set objMOARightArrow = Nothing
wait 1
Set objMOAPanel = objPage.WebElement("class:=moa-container background row height-100-percent action-item-border remove-margin moa-background ng-scope")
objMOAPanel.highlight

Set moaIndividualDesc = Description.Create
moaIndividualDesc("micclass").Value = "WebElement"
moaIndividualDesc("class").Value = "moa-item.*"

Set objMOAIndi = objMOAPanel.ChildObjects(moaIndividualDesc)
Print objMOAIndi.Count

Dim objReqTab
Dim isFound : isFound = false
For i = 0 To objMOAIndi.Count - 1
	objMOAIndi(i).highlight
	outerText = objMOAIndi(i).getROProperty("outertext")
	If instr(lcase(outerText), "patient assessment") > 0 Then
		Print objMOAIndi(i).getROProperty("outertext")
		isFound = true
		Set objReqTab = objMOAIndi(i)
		Exit For
	End If
Next

If not isFound Then
	'exit function
End If

objReqTab.highlight
outerText = trim(objReqTab.getROProperty("outertext"))
outerText = Split(outerText, " ")
noOfTasks = outerText(Ubound(outerText))
Print noOfTasks

If noOfTasks = 0 Then
	Call WriteToLog("Fail", "There are no tasks to perform")
Else
	Call WriteToLog("Pass", "There are " & noOfTasks & " open tasks.")
End If

'click on the arrow to expand
objReqTab.Image("class:=moa-expand-collapse-img moa-tile-img").Click

wait 2

Set objDescPanel = objReqTab.WebElement("class:=moa-description moa-group-description.*")
Set taskDesc = Description.Create
taskDesc("micclass").Value = "WebElement"
taskDesc("html id").Value = "closeTaskId-.*"

Set objTask = objDescPanel.ChildObjects(taskDesc)

For k = 0 To objTask.Count - 1
	task = objTask(k).getROPRoperty("outertext")
	Select Case trim(task)
		Case "*Initial Medications Required"
			Print task
			objTask(k).Click
			wait 2
			waitTillLoads "Loading..."
			wait 2
			isPass = medicationsManagement()
		Case "*Initial Allergies Record"
			Print task
			objTask(k).Click
			wait 2
			waitTillLoads "Loading..."
			wait 2
			isPass = addAllergiesRecord()
		Case "*Initial IPE Base Line due"
			Print task
			objTask(k).Click
			wait 2
			waitTillLoads "Loading..."
			wait 2
			isPass = patientAssessmentBaseLine()
		Case "*IPE Minimum Data Due"
			Print task
			objTask(k).Click
			wait 2
			waitTillLoads "Loading..."
			wait 2
'			isPass = addAllergiesRecord()
	End Select
Next

'click on the arrow to collapse
objReqTab.Image("class:=moa-expand-collapse-img moa-tile-img").Click
Set objPage = getPageObject()
Set objMOALeftArrow = objPage.Image("file name:=arrow-left-white.png")
objMOALeftArrow.highlight
objMOALeftArrow.Click

Set objMOALeftArrow = Nothing
Set objReqTab = Nothing
Set objMOAPanel = Nothing
Set objPage = Nothing

'close all open patients
Call writetolog("info", "Test Case - Close and re-open the patient to verify if all IPE tasks are cleared and eligibility status changed to Assessed")
isPass = CloseAllOpenPatient(strOutErrorDesc)

selectPatientFromGlobalSearch strMember

Set objPage = getPageObject()
Set objMOARightArrow = objPage.Image("class:=a-2 left moa-ribbon-expand-collapse-img")
objMOARightArrow.highlight
objMOARightArrow.Click
Set objMOARightArrow = Nothing
wait 1
Set objMOAPanel = objPage.WebElement("class:=moa-container background row height-100-percent action-item-border remove-margin moa-background ng-scope")
objMOAPanel.highlight

Set moaIndividualDesc = Description.Create
moaIndividualDesc("micclass").Value = "WebElement"
moaIndividualDesc("class").Value = "moa-item.*"

Set objMOAIndi = objMOAPanel.ChildObjects(moaIndividualDesc)
Print objMOAIndi.Count

isFound = false
For i = 0 To objMOAIndi.Count - 1
	objMOAIndi(i).highlight
	outerText = objMOAIndi(i).getROProperty("outertext")
	If instr(lcase(outerText), "patient assessment") > 0 Then
		Print objMOAIndi(i).getROProperty("outertext")
		isFound = true
		Set objReqTab = objMOAIndi(i)
		Exit For
	End If
Next

If not isFound Then
	'exit function
End If

objReqTab.highlight
outerText = trim(objReqTab.getROProperty("outertext"))
outerText = Split(outerText, " ")
noOfTasks = outerText(Ubound(outerText))

If noOfTasks = 0 Then
	Call WriteToLog("Pass", "All the initial tasks are cleared.")
Else
	Call WriteToLog("Fail", "Not all the initial tasks are cleared.")
End If

'verify status changed to Enrolled
wait 2
waitTillLoads "Loading..."
wait 2

Call clickOnSubMenu("Member Info->Patient Info")

wait 2
waitTillLoads "Loading..."
wait 2

Execute "Set objEnrollmentStatus = " & Environment("WEL_EnrollStatus")
If not objEnrollmentStatus.Exist(intWaitTime) Then
	Call WriteToLog("Fail", "Status field on Patinet Info screen does not exist")
End If

'Check the patient status should be assessed 
strEnrollmentStatus = "Assessed"
strPatientStatus = objEnrollmentStatus.getRoProperty("innertext")
If Trim(strPatientStatus) = Trim(strEnrollmentStatus) Then
	Call WriteToLog("Pass","Patient eligibility status changed successfully to " & strPatientStatus )
Else	
	Call WriteToLog("Fail","Patient is not enrolled successfully.It is giving status " & strPatientStatus)
End If

Logout
CloseAllBrowsers
WriteLogFooter


Function patientAssessmentBaseLine()
	On Error Resume Next
	Err.Clear
	patientAssessmentBaseLine = false
	
	wait 2
	waitTillLoads "Loading..."
	wait 1
	'===============================================================
	'Verify that Patient Assessment screen open successfully
	'===============================================================
	Execute "Set objPatientAssessmentScreenTitle = "  &Environment("WEL_PatientAssessment_ScreenTitle") 'Diabetes management screen title
	If Not CheckObjectExistence(objPatientAssessmentScreenTitle, 10) Then
		Call WriteToLog("Fail","Patient Assessment screen not opened successfully")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Patient Assessment screen opened successfully")
	
	'==================================
	'Click on baseline section to open
	'==================================
	Execute "Set objBaselineSection = "& Environment("WEL_Baseline_Section")
	If Not CheckObjectExistence(objBaselineSection, 10) Then
		Call WriteToLog("Fail","Baseline Section does not exist in Patient Assessment screen")
		Exit Function
	End If
	Call WriteToLog("Pass","Baseline Section exist in Patient Assessment screen")
	
	objBaselineSection.Click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail", "Failed to click on Baseline tab")
'		Exit Function
	End If
	
	'validate assessment date is by default todays date
	Execute "Set objAssesmentDate = "& Environment("WE_PatientAssessment_AssessmentDate")
	dater = objAssesmentDate.getROProperty("value")
	dater = CDate(dater)
	If dater = date() Then
		Call WriteToLog("Pass", "Assessment date is by default today's date as required.")
	Else
		Call WriteToLog("Fail", "Assessment date is not by default today's date as required. Date is " & dater)
	End If
	
	'=================================
	'Set Date of First ever Dialysis:
	'=================================
	Execute "Set objFirstEverDialysisDate = "& Environment("WE_PatientAssessment_FirstEverDialysisDate")
	objFirstEverDialysisDate.Set date()
	If Err.Number <>0 Then
		Call WriteToLog("Fail","First Ever Dialysis date does not set successfuly. Error Returned: " & Err.Description)
		Exit Function
	End If
	
	'=========================================
	'Set First ever Dialysis from the dropdown
	'=========================================
	Execute "Set objPatientAssessment_SettingofFirsteverDialysis = " & Environment("WB_PatientAssessment_SettingofFirsteverDialysis")
	isPass = selectComboBoxItem(objPatientAssessment_SettingofFirsteverDialysis, "Inpatient")
	
	'==================================
	'Set Date of First chronic Dialysis
	'==================================
	Execute "Set objFirstchronicDialysisDate = "& Environment("WE_PatientAssessment_FirstChronicDialysisDate")
	objFirstchronicDialysisDate.Set date()
	If Err.Number <>0 Then
		Call WriteToLog("Fail", Err.Description)
		Exit Function
	End If

	Execute "Set objPatientAssessment_PrimaryCausesOfRenalDisease = " & Environment("WB_PatientAssessment_PrimaryCausesOfRenalDisease")
	isPass = selectComboBoxItem(objPatientAssessment_PrimaryCausesOfRenalDisease, "0429A-AIDS NEPHROPATHY")
	
	'=============================================================
	'Select the value for hearing impairement
	'=============================================================
	Execute "Set objHearingImpairement = "& Environment("WB_PatientAssessment_HearingImpairement")
	objHearingImpairement.highlight
	isPass = selectComboBoxItem(objHearingImpairement, "Deaf")
	
	'=============================================================
	'Select the value for vision impairement
	'=============================================================
	Execute "Set objVisionImpairement = "& Environment("WB_PatientAssessment_VisionImpairement")
	objVisionImpairement.highlight
	isPass = selectComboBoxItem(objVisionImpairement, "Blind")
	
	wait 2
	
	'click on save button
	Execute "Set objSave = " & Environment("WEL_PatientAssessment_SaveButton")
	objSave.highlight
	objSave.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'click on Ok on message box
	isPass = checkForPopup("Patient Assessment", "Ok", "Patient Assessment has been saved successfully", strOutErrorDesc)
	
	patientAssessmentBaseLine = true
End Function


Function addAllergiesRecord()
	On Error Resume Next
	Err.Clear
	addAllergiesRecord = false
	
	'click on message box
	isPass = checkForPopup("Some Data May Be Out of Date", "Ok", "The information contained", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("info", strOutErrorDesc)
'		Exit Function
	End If
	wait 1
	isPass = checkForPopup("Disclaimer", "Ok", "The information contained", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("info", strOutErrorDesc)
'		Exit Function
	End If
	
	'Check whether user landed on Medications Management screen
	Execute "Set objMedMagtitle = "&Environment("WEL_MedMagTitle")	'Medications Management screen title
	If not objMedMagtitle.Exist(3) Then
		Call WriteToLog("Fail","Expected Result: User should be on Medications screen.  Actual Result: Unable to land on Medications screen "&Err.Description)
		Call WriteLogFooter()
		ExitAction
	Else
		Call WriteToLog("PASS","Landed on Medications screen")
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Execute "Set objAllergyAddBtn = " & Environment("WB_AddAllerg")
	objAllergyAddBtn.Click
	
	Execute "Set objAlrgyNamTxtBx = " & Environment("WEL_AlrgyNamTxtBx")
	objAlrgyNamTxtBx.highlight
	objAlrgyNamTxtBx.Click
	
	Execute "Set objAlrgyNamEdBx = " & Environment("WE_AlrgyNamEdBx")
	allergy = "Eggs or Egg-derived Products"
	
	For i = 1 To len(allergy)
		ch = Mid(allergy, i, 1)
		sendKeys ch
		Err.Clear
		Set objList = Browser("creationtime:=1").Page("title:=DaVita VillageHealth Capella").WebElement("class:=k-list-container k-popup k-group k-reset k-state-border-up", "html id:=allergyName-list")
		isFound = false
		If Not objList.Exist(3) Then
		Else
			objList.highlight
		
			Set itemDesc = Description.Create
			itemDesc("micclass").Value = "WebElement"
			itemDesc("class").Value = "k-item.*"
			
			Set objItem = objList.ChildObjects(itemDesc)
			For j = 0 To objItem.Count - 1
				Print objItem(j).getROProperty("outertext")
				item = objItem(j).getROProperty("outertext")
				
				If item = allergy Then
					objItem(j).click
					isFound = true
					Exit For
				End If
			Next
		End If
		If isFound Then
			Exit For
		End If
		Set objList = Nothing
	Next
	wait 1
	
	Execute "Set objAlgrySavebtn = " & Environment("WI_AlgrySavebtn")
	objAlgrySavebtn.Click
	
	wait 1
	WaitTillLoads "Loading..."
	wait 1
	
	isPass = checkForPopup("Save Allergy ?", "Yes", "Do you want to save allergy choosen ?", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to save the allergy")
		Exit Function
	End If
	
	wait 2
	WaitTillLoads "Loading..."
	wait 1
	
	isPass = checkForPopup("Changes Saved", "Ok", "Changes saved successfully.", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to save the allergy")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Allergy saved successfully.")
	
	addAllergiesRecord = true
End Function

Function medicationsManagement()
	On Error Resume Next
	Err.Clear
	medicationsManagement = false
	'click on message box
	isPass = checkForPopup("Some Data May Be Out of Date", "Ok", "The information contained", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", strOutErrorDesc)
'		Exit Function
	End If
	wait 1
	isPass = checkForPopup("Disclaimer", "Ok", "The information contained", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", strOutErrorDesc)
		Exit Function
	End If
	
	'Check whether user landed on Medications Management screen
	Execute "Set objMedMagtitle = "&Environment("WEL_MedMagTitle")	'Medications Management screen title
	If not objMedMagtitle.Exist(3) Then
		Call WriteToLog("Fail","Expected Result: User should be on Medications screen.  Actual Result: Unable to land on Medications screen "&Err.Description)
		Call WriteLogFooter()
		ExitAction
	Else
		Call WriteToLog("PASS","Landed on Medications screen")
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'verify no medications on file
	Set objPage = getPageObject()
	Set noMeds = objPage.WebElement("class:=no-data", "innerhtml:=No Medications on File")
	noMeds.highlight
	
	If not noMeds.Exist(1) Then
		Call WriteToLog("Fail", "No Medications on File is expected. But not present.")
		Exit Function
	End If
	Set noMeds = Nothing
	Set objPage = Nothing
	'click on Add Button
	Execute "Set objAddBtn = " & Environment("WEL_MedAddBtn")
	objAddBtn.Click
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'Chk on ESA chkbox
	Execute "Set objESAcb = "&Environment("WEL_ESAcb") 'ESA chk box
	objESAcb.Click
	If err.number <> 0 Then
		Call WriteToLog("Fail", Err.Description)
		Exit Function
	End If
	Call WriteToLog("PASS","Checked ESA checkbok")
	
	'Select required Label from Label DropDown
	Execute "Set objLbNaDD = "&Environment("WEL_LbNaDD") 'LabelNameDD name
	isPass = selectComboBoxItem(objLbNaDD, "Epogen")
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select Label Name")
		Exit Function
	End If	
	
	Call WriteToLog("PASS","Selected required medicine from Label Name dropdown")
	
	'select frequency
	Execute "Set objFreq = "&Environment("WEL_MedFreq") 'Frequency for medications
	isPass = selectComboBoxItem(objFreq, "AFTER EATING")
	If not isPass Then
		Call WriteToLog("Fail", "Failed to select frequency")
		Exit Function
	End If
	
	Call WriteToLog("PASS","Frequency is selected.")
	
	Err.Clear
	'select dose
'	Execute "Set objMedicationsDose = "&Environment("WEL_MedicationsDose") 'Medications Dose
'	objMedicationsDose.highlight
'	Set objUpArrow = objMedicationsDose.WebElement("innerhtml:=Increase value", "class:=k-icon k-i-arrow-n")
'	objUpArrow.Click
'	objUpArrow.Click
'	objUpArrow.Click
'	objUpArrow.Click
'	If Err.Number <> 0 Then
'		Call WriteToLog("Fail", "Failed to select dose")
'		Exit Function
'	End If
'	
'	Call WriteToLog("PASS","Dose is selected.")
	Err.clear
	'Clk Save icon for medications.
	Execute "Set objMedSavIcn = " &Environment("WEL_MedicationSaveIcon") 
	objMedSavIcn.Click
	If err.number <> 0 Then
		Call WriteToLog("Fail", Err.Description)
		Exit Function
	End If
	
	Call WriteToLog("PASS","Saved medication with value taken from new frequency list")
	
	wait 2
	WaitTillLoads "Saving..."
	wait 2
	
	medicationsManagement = true
End Function
