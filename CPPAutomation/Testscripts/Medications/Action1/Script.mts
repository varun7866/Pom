'**************************************************************************************************************************************************************************
' TestCase Name	: Medications
' Purpose of TC	: Validate functionalities of 'Medications Management > Review' screen
' Author        : Gregory
' Date          : December 04, 2105
' Comments 		:  
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

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Medications", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Set objFso = CreateObject("Scripting.FileSystemObject")
SCREEN_Library = Environment.Value("PROJECT_FOLDER") & "\Library\SCREEN_functions"
For each SCREENlibfile in objFso.GetFolder(SCREEN_Library).Files
	If UCase(objFso.GetExtensionName(SCREENlibfile.Name)) = "VBS" Then
		LoadFunctionLibrary SCREENlibfile.Path
	End If
Next
Set objFso = Nothing

'-----------------------------------------------------------------
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)
	
'------------------------
' Variable initialization
'------------------------
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
lngMemberID = DataTable.Value("MemberID","CurrentTestCaseData")

''-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
'
'On Error Resume Next
'Err.Clear
''If not Lcase(strExecutionFlag) = "y" Then Exit Do
'Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientName&"'----------------") 
'
''Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
'blnNavigator = Navigator("vhn", strOutErrorDesc)
'If not blnNavigator Then
'	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
'	Call Terminator											
'End If
'Call WriteToLog("Pass","Navigated to user dashboard")
'
'''Select patient from MyPatient list
''Call WriteToLog("Info","----------------Select required patient from MyPatient List----------------")
''blnSelectPatientFromPatientList = SelectPatientFromPatientList(strUser, strPatientName)
''If blnSelectPatientFromPatientList Then
''	Call WriteToLog("Pass","Selected required patient from MyPatient list")
''Else
''	strOutErrorDesc = "Unable to select required patient"
''	Call WriteToLog("Fail","Expected Result: Should be able to select required patient from MyPatient list.  Actual Result: "&strOutErrorDesc)
''	Call Terminator
''End If
'
'Call WriteToLog("Info","----------------Select required patient through Global Search----------------")
'blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
'If Not blnGlobalSearchUsingMemID Then
'	strOutErrorDesc = "Select patient through global search returned error: "&strOutErrorDesc
'	Call WriteToLog("Fail", "Expected Result: User should be able to select patient through global search; Actual Result: "&strOutErrorDesc)
'	Call Terminator
'End If
'Call WriteToLog("Pass","Successfully selected required patient through global search")
'Wait 3
'
'Call waitTillLoads("Loading...")
'Wait 1
'
''Handle navigation error if exists
'blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
'If not blnHandleWrongDashboardNavigation Then
'    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
'End If
'Call WriteToLog("Pass","Provided proper navigation after patient selection")
'
''Navigate to ClinicalManagement > Medications
'blnScreenNavigation = clickOnSubMenu_WE("Clinical Management->Medications")
'If not blnScreenNavigation Then
'	Call WriteToLog("Fail","Unable to navigate to Medication screens "&strOutErrorDesc)
'	Call Terminator
'End If
'Call WriteToLog("Pass","Navigated to Medication screens")
'wait 3
'
'Call waitTillLoads("Loading...")
'Wait 1
'
'Call ClosePopups()
'
''Click on Review tab
'Execute "Set objMedicationsReviewTab = "&Environment("WE_MedicationReviewTab")
'blnClickedMedicationsReviewTab = ClickButton("Review",objMedicationsReviewTab,strOutErrorDesc)
'If not blnClickedMedicationsReviewTab Then
'	Call WriteToLog("Fail","Unable to click Medications > Review tab. "&strOutErrorDesc)
'	Call Terminator											
'End If
'Call WriteToLog("Pass","Clicked Medications > Review tab")
'Execute "Set objMedicationsReviewTab = Nothing"
'Wait 2
'Call waitTillLoads("Loading...")
'Wait 1
'
'Call ClosePopups()
'
''Check whether user landed on Medications Management screen
'Execute "Set objMedMagtitle = "&Environment("WEL_MedMagTitle")	'Medications Management screen title
'If not objMedMagtitle.Exist(3) Then
'	Call WriteToLog("Fail","Expected Result: User should be on Medications screen.  Actual Result: Unable to land on Medications screen "&Err.Description)
'	Call Terminator
'End If
'Call WriteToLog("Pass","Landed on Medications screen")
'Execute "Set objMedMagtitle = Nothing"
'wait 1

''------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
''*Validation 1==============================================Validate Medication add by providing values for all fields
''------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
''strMedicationDetails = "yes,Hematide,4,3,2,1,GTTS,AS NEEDED,5,DT,(123)456-7890,Patient Reported,Alpine,CA,91901,Acute Abdominal Pain,Afrin Allergy Nasal Solution 0.5 %,MedicationScreen testing,Pharm1,Testing1,Med1"
'strMedicationDetails = "yes,Hematide,4,3,2,1,GTTS,AS NEEDED,5,DT,(123)456-7890,Pharmacist Recommended,Alpine,CA,91901,Acute Abdominal Pain,Afrin Allergy Nasal Solution 0.5 %,MedicationScreen testing,Pharm1,Testing1,Med1"
'dtWrittenDate = DateAdd("d",-1,Date)
'dtFilledDate = DateAdd("d",-1,Date)
'Call WriteToLog("Info","---Validate Medication add by providing values for all fields---") 
'strAddedMedicationRx = AddMedicationWithAllDetails(strMedicationDetails,dtWrittenDate,dtFilledDate,strOutErrorDesc)	
'If strAddedMedicationRx = "" Then
'	Call WriteToLog("Fail","Expected Result: Should be able to add new medication by providing values to all the fields. Actual Result: Unable to add required medication. "&strOutErrorDesc)
'	Call Terminator
'Else
'	Call WriteToLog("Pass","Successfully added new medication by providing values to all the fields")
'End If
''------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
'
''*==============================================Validate availability of newly added medication in Medication table under active medications. Select the medication for validating all entries made during mediation add
'Call WriteToLog("Info","---Validate - Availability of newly added medication without discontinue date under active list of Medications - Should be available---") 
''------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
''*Validation 2 - This medication should be available under Active list of Medications
''------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





'Execute "Set objMedicationReviewMedTable = "&Environment("WT_MedicationReviewMedTable")
'objMedicationReviewMedTable.highlight
'
'strRxNumber = "D011916215931"
'Execute "Set objMedDetails = "&Environment("WE_MedScr_MedDetails")
'strMedicationDetails = LCase(Replace(objMedDetails.GetROProperty("outertext")," ","",1,-1,1))
'strRequiredRxNumber = "rxnumber"&LCase(Trim(strRxNumber))
'If Instr(1,strMedicationDetails,strRequiredRxNumber,1) Then
'	msgbox "t"
'End If
'Execute "Set objMedDetails = Nothing"


strAddedMedicationRx =  "D011916215931"
blnSelectSpecificMedicationFromMedTable = SelectSpecificMedicationFromMedTable(strAddedMedicationRx,strOutErrorDesc)
	strValidateMedicationStatus = ValidateMedicationStatus("Active",strAddedMedicationRx,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Newly added medication is NOT available under active list of Medications")
	Call Terminator
Else
	Call WriteToLog("Pass","Newly added medication is available under active list of Medications")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 3 - This medication should NOT be available under discontinued list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate - Availability of newly added medication without discontinue date under discontinued list of Medications - Should NOT be available---") 
strValidateMedicationStatus = ValidateMedicationStatus("Discontinued",strAddedMedicationRx,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Pass","Newly added medication is NOT available under discontinued list of Medications")
Else
	Call WriteToLog("Fail","Newly added medication is available under discontinued list of Medications")
	Call Terminator
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 4 - This medication should be available under All medications list
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate - Availability of newly added medication without discontinue date under 'All' list of Medications - Should be available---") 
strValidateMedicationStatus = ValidateMedicationStatus("All",strAddedMedicationRx,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Newly added medication is NOT available under All medications list")
	Call Terminator
Else
	Call WriteToLog("Pass","Newly added medication is available under All medications list")
End If
Wait 1

'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 5 ============================================== Validate all entries provided during adding the medication
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate all entries for the newly added medication---") 
Call WriteToLog("Pass","Selected newly added medication from Medication Table")
Call ValidateAllMedicationEntries(strMedicationDetails, dtWrittenDate, dtFilledDate, strOutErrorDesc)
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 6 ============================================== Medication Edit (all fields)
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate editing all entries for the newly added medication---") 
blnSelectSpecificMedicationFromMedTable = SelectSpecificMedicationFromMedTable(strAddedMedicationRx,strOutErrorDesc)
If not blnSelectSpecificMedicationFromMedTable Then 
	ValidateMedicationStatus = "Medication with RxNumber '"&strAddedMedicationRx&"' is NOT available in MedicationListTable"
Else
	Call WriteToLog("Pass", "Medication with RxNumber '"&strAddedMedicationRx&"' is selected for editing")
End If
wait 1

'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1

strMedicationEditDetails = "Reason Discontinued,1,GTTS,AFTER EATING,AO,PrescEt,PrescNm,Allergen Immunotherapy,Actifed Cold/Allergy Oral Tablet 4-10 MG,OrNotes"
dtDiscontinuedDate = DateAdd("d",2,Date)
blnEditMedicationWithAllDetails = EditMedicationWithAllDetails(strMedicationEditDetails, dtDiscontinuedDate, strOutErrorDesc)
If not blnEditMedicationWithAllDetails Then
	Call WriteToLog("Fail","Unable to edit medication. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Edited medication with all fields")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 7 ============================================== This edited medication should be available under Active list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate - Edited medication without discontinuing should be available under Active list of Medications---")
strValidateEditedMedicationStatus = ValidateMedicationStatus("Active",strAddedMedicationRx,strOutErrorDesc)
If Instr(1,strValidateEditedMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Edited medication is NOT available under active list of Medications")
	Call Terminator
Else
	Call WriteToLog("Pass","Edited medication is available under active list of Medications")
End If
Wait 1

'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 8 ============================================== Validate all entries provided during edting medication
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate all entries for the edited medication---") 
Call WriteToLog("Pass","Selected newly added medication from Medication Table")
Call ValidateAllEditedMedicationEntries(strMedicationEditDetails, strOutErrorDesc)


'*===============================================Edit medication with discontinued date less than sys date
'*Edit medication with discontinued date less than sys date - This medication should be available under Discontinued list of Medications, and NOT under Active list
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued date less than sys date---") 
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 9 ============================================== Edit medication with discontinued date less than sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strRxNumberForEdit = strAddedMedicationRx
dtDiscontinuedDate = DateAdd("d",-2,Date)
strDiscontinuedReason = "Discont Reason"
strEdit_Validation_Discontinued = Edit_Validation_Discontinued(strRxNumberForEdit,dtDiscontinuedDate,strDiscontinuedReason, strOutErrorDesc)
If strEdit_Validation_Discontinued = "" Then
	Call WriteToLog("Fail","Unable to edit medication with disconinued date less than sys date. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Successfully edited medication with disconinued date less than sys date")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 10 ==============================================  This medication should NOT be available under Active list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued date less than sys date - This medication should NOT be available under Active list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Active",strEdit_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Pass","Medication which is edited with discontinued date less than sys date is NOT available under Active list of Medications")
Else
	Call WriteToLog("Fail","Medication which is edited with discontinued date less than sys date is available under Active list of Medications")
	Call Terminator
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1	

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 11 ==============================================  This medication should be available under Discontinued list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued date less than sys date - This medication should be available under Discontinued list of Medications---") 
FlagForDiscontinuedEditValidation = False
strValidateMedicationStatus = ValidateMedicationStatus("Discontinued",strEdit_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Medication which is edited with discontinued date less than sys date is NOT available under discontinued list of Medications")
	Call Terminator
Else
	FlagForDiscontinuedEditValidation = True
	Call WriteToLog("Pass","Medication which is edited with discontinued date less than sys date is available under discontinued list of Medications")
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1	

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'*===============================================Add_Validation_Mandatory_Duplicate_Written_Filled
'*Validation 12 ==============================================   Add medication without mandatory field (frequency)- Should not be able to save- error message validation
'*Validation 13 ==============================================   Add medication with Written date greater than sys date-Should not be able to save- error message validation
'*Validation 14 ==============================================   Add medication with Filled date greater than sys date-Should not be able to save- error message validation
'*Validation 15 ==============================================   Add medication with Written date less than 365 days from sys date-Should not be able to save- error message validation
'*Validation 16 ==============================================   Add medication with Filled date less than 365 days from sys date-Should not be able to save- error message validation
'*Validation 17 ==============================================   Add medication without mandatory field (Label)- Should not be able to save- error message validation
'*Validation 18 ==============================================   Add medication with only mandatory fields-Should be able to save
'*Validation 19 ==============================================   Add duplicate medication-Should be able to save

strMedicationRxNumber = Add_Validation_Mandatory_Duplicate_Written_Filled(strOutErrorDesc)
If strMedicationRxNumber = "" Then 
	Call WriteToLog("Fail","Expected Result: Unable to perform validations. "&strOutErrorDesc)
	Call Terminator
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
'*Validation - Edit medication with discontinued date greater than sys date - This medication should be available under Active list of Medications and NOT under Discontinued list
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued greater than sys date---") 
strRxNumberForEdit = strMedicationRxNumber
'*Validation 20 ==============================================  Edit medication with discontinued date greater than sys date
dtDiscontinuedDate = DateAdd("d",2,Date)
strDiscontinuedReason = "Discont Reason"
strEdit_Validation_Discontinued = Edit_Validation_Discontinued(strRxNumberForEdit,dtDiscontinuedDate,strDiscontinuedReason, strOutErrorDesc)
If strEdit_Validation_Discontinued = "" Then
	Call WriteToLog("Fail","Unable to Edit new medication with disconinued date greater than sys date. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Successfully Edited new medication with disconinued greater than sys date")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 21 ==============================================   This medication should be available under Active list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued date greater than sys date - This medication should be available under Active list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Active",strEdit_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Medication which is Edited with discontinued date greater than sys date is NOT available under active list of Medications")
	Call Terminator
Else
	Call WriteToLog("Pass","Medication which is Edited with discontinued date greater than sys date is available under active list of Medications")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 22 ==============================================   - This medication should NOT be available under discontinued list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued date greater than sys date - This medication should NOT be available under Discontinued list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Discontinued",strEdit_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Pass","Medication which is Edited with discontinued date greater than sys date is NOT available under discontinued list of Medications")
Else
	Call WriteToLog("Fail","Medication which is Edited with discontinued date greater than sys date is available under discontinued list of Medications")
	Call Terminator
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1

'''uncomment only if script is being executed afternoon- offshore
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
'Edit medication with discontinued date equal to sys date - This medication should be available under Discontinued list of Medications and NOT under Active medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued date equal to sys date---") 
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 23 ==============================================  Edit medication with discontinued date equal to sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
strRxNumberForEdit = strMedicationRxNumber
dtDiscontinuedDate = Date
strDiscontinuedReason = "Discont Reason"
strEdit_Validation_Discontinued = Edit_Validation_Discontinued(strRxNumberForEdit,dtDiscontinuedDate,strDiscontinuedReason, strOutErrorDesc)
If strEdit_Validation_Discontinued = "" Then
	Call WriteToLog("Fail","Unable to Edit new medication with disconinued date equal to sys date. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Successfully Edited new medication with disconinued date equal to sys date")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 24 ==============================================   This medication should NOT be available under Active list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued date equal to sys date - This medication should be available under Discontinued list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Active",strEdit_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Pass","Medication which is Edited with discontinued date equal to sys date is NOT available under Active list of Medications")
Else
	Call WriteToLog("Fail","Medication which is Edited with discontinued date equal to sys date is available under Active list of Medications")
	Call Terminator
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1	

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 25 ==============================================   This medication should be available under Discontinued list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Edit medication with discontinued date equal to sys date - This medication should NOT be under Active medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Discontinued",strEdit_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Medication which is Edited with discontinued date equal to sys date is NOT available under discontinued list of Medications")
	Call Terminator
Else
	Call WriteToLog("Pass","Medication which is Edited with discontinued date equal to sys date is available under discontinued list of Medications")
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1	

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'*===============================================Add_Validation_NonESA_Dose_Frequency_Route
'*Validation 26 ============================================== Add ESA medication without providing Dose. Should be able to save
'*Validation 27 ============================================== Add NonESA medication with frequency other than 'SLIDE SCALE' and without providing Dose - Error popup should be available
'*Validation 28 ============================================== Add NonESA medication with Route other than 'TP' and without providing Dose - Error popup should be available
'*Validation 29 ============================================== Add NonESA medication with Route as 'TP' and without providing Dose - should be able to save medication
'*Validation 30 ============================================== Add NonESA medication with frequency as 'SLIDE SCALE' and without providing Dose - should be able to save medication

strAdd_Validation_NonESA_Dose_Frequency_Route = Add_Validation_NonESA_Dose_Frequency_Route(strOutErrorDesc)
If strAdd_Validation_NonESA_Dose_Frequency_Route = "" Then 
	Call WriteToLog("Fail","Expected Result: Unable to perform validations. "&strOutErrorDesc)
	Call Terminator
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			

'*===============================================Add medication with discontinued date less than / equal to / greater than sys date
'*Add medication with discontinued date less than sys date - This medication should be available under Discontinued list of Medications, and NOT under Active list
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued date less than sys date---") 
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 31 ============================================== Add medication with discontinued date less than sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dtDiscontinuedDate = DateAdd("d",-2,Date)
strAdd_Validation_Discontinued = Add_Validation_Discontinued(dtDiscontinuedDate, strOutErrorDesc)
If strAdd_Validation_Discontinued = "" Then
	Call WriteToLog("Fail","Unable to add new medication with disconinued date less than sys date. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Successfully added new medication with disconinued date less than sys date")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 32 ==============================================  This medication should NOT be available under Active list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued date less than sys date-This medication should NOT be available under Active list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Active",strAdd_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Pass","Medication which is added with discontinued date less than sys date is NOT available under Active list of Medications")
Else
	Call WriteToLog("Fail","Medication which is added with discontinued date less than sys date is available under Active list of Medications")
	Call Terminator
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1	

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 33 ==============================================  This medication should be available under Discontinued list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued date less than sys date-This medication should be available under Discontinued list of Medications---")
FlagForDiscontinuedEditValidation = False
strValidateMedicationStatus = ValidateMedicationStatus("Discontinued",strAdd_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Medication which is added with discontinued date less than sys date is NOT available under discontinued list of Medications")
	Call Terminator
Else
	FlagForDiscontinuedEditValidation = True
	Call WriteToLog("Pass","Medication which is added with discontinued date less than sys date is available under discontinued list of Medications")
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1	

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 34 ==============================================  For discontinued medication 'Edit' option should not be available
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - For discontinued medication 'Edit' option should not be available---")
If FlagForDiscontinuedEditValidation Then
	Execute "Set objEditMed_Validation = "&Environment("WEL_MedEdit") 'Edit button for medications	
	If objEditMed_Validation.Exist(2) Then
		Call WriteToLog("Fail","For Discontinued medication 'Edit' option is available")
		Call Terminator
	Else
		Call WriteToLog("Pass","For Discontinued medication 'Edit' option is NOT available")	
	End If
Else
	Call WriteToLog("Fail","Unable to validate 'For discontinued medication 'Edit' option should not be available' functionality. "&strOutErrorDesc)
	Call Terminator
End If
Execute "Set objEditMed_Validation = Nothing"

'''uncomment only if script is being executed afternoon- offshore
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
'Add medication with discontinued date equal to sys date - This medication should be available under Discontinued list of Medications and NOT under Active medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued date equal to sys date-This medication should be available under Discontinued list of Medications---") 

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 35 ============================================== Add medication with discontinued date equal to sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dtDiscontinuedDate = Date
Call WriteToLog("Info","---Validation - Add medication with discontinued date equal to sys date--")
strAdd_Validation_Discontinued = Add_Validation_Discontinued(dtDiscontinuedDate, strOutErrorDesc)
If strAdd_Validation_Discontinued = "" Then
	Call WriteToLog("Fail","Unable to add new medication with disconinued date equal to sys date. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Successfully added new medication with disconinued date equal to sys date")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 36 ==============================================  This medication should NOT be available under Active list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued date equal to sys date-This medication should NOT be available under Active list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Active",strAdd_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Pass","Medication which is added with discontinued date equal to sys date is NOT available under Active list of Medications")
Else
	Call WriteToLog("Fail","Medication which is added with discontinued date equal to sys date is available under Active list of Medications")
	Call Terminator
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1	

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 37 ==============================================  This medication should be available under Discontinued list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued date equal to sys date-This medication should be available under Discontinued list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Discontinued",strAdd_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Medication which is added with discontinued date equal to sys date is NOT available under discontinued list of Medications")
	Call Terminator
Else
	Call WriteToLog("Pass","Medication which is added with discontinued date equal to sys date is available under discontinued list of Medications")
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1	

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
'*Validation - Add medication with discontinued date greater than sys date - This medication should be available under Active list of Medications and NOT under Discontinued list
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued greater than sys date---") 
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 38 ============================================== Add medication with discontinued date greater than sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dtDiscontinuedDate = DateAdd("d",2,Date)
strAdd_Validation_Discontinued = Add_Validation_Discontinued(dtDiscontinuedDate, strOutErrorDesc)
If strAdd_Validation_Discontinued = "" Then
	Call WriteToLog("Fail","Unable to add new medication with disconinued date greater than sys date. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Successfully added new medication with disconinued greater than sys date")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 39 ==============================================  This medication should be available under Active list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued greater than sys date-This medication should be available under Active list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Active",strAdd_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Fail","Medication which is added with discontinued date greater than sys date is NOT available under active list of Medications")
	Call Terminator
Else
	Call WriteToLog("Pass","Medication which is added with discontinued date greater than sys date is available under active list of Medications")
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 40 ==============================================  This medication should NOT be available under discontinued list of Medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation - Add medication with discontinued greater than sys date-This medication should NOT be available under Discontinued list of Medications---") 
strValidateMedicationStatus = ValidateMedicationStatus("Discontinued",strAdd_Validation_Discontinued,strOutErrorDesc)
If Instr(1,strValidateMedicationStatus,"NOT available",1) > 0 Then
	Call WriteToLog("Pass","Medication which is added with discontinued date greater than sys date is NOT available under discontinued list of Medications")
Else
	Call WriteToLog("Fail","Medication which is added with discontinued date greater than sys date is available under discontinued list of Medications")
	Call Terminator
End If
Wait 1
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'*===============================================Add_Validation_MedicationHistoryNotKnown
'*Validation 41 ============================================== Trying to add 'Medication History Not Known' while there are active medications- Error message validation
'*Validation 42 ============================================== Add 'Medication History Not Known' discontinuing all active medications
'*Validation 43 ============================================== Trying to add new medication when 'Medication History Not Known' is present-Error messsage validation
'*Validation 44 ============================================== Add medication after discontinuing 'Medication History Not Known'

strAdd_Validation_MedicationHistoryNotKnown = Add_Validation_MedicationHistoryNotKnown(strOutErrorDesc)
If strAdd_Validation_MedicationHistoryNotKnown = "" Then
	Call WriteToLog("Fail","Medication which is added with discontinued date greater than sys date is NOT available under active list of Medications")
	Call Terminator
Else
	Call WriteToLog("Pass","Medication which is added with discontinued date greater than sys date is available under active list of Medications")
End If
Wait 1

'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'*==============================================Edit_Mandatory_Frequency_Dose_Route
'*Validation 45 ============================================== Edit ESA medication without dose - should save
'*Validation 46 ============================================== Edit nonESA medication without dose and Route not as 'TP'- should not save - error msg validation
'*Validation 47 ==============================================  Edit nonESA medication without dose and Frequency not as 'SLIDING SCALE'- should not save - error msg validation
'*Validation 48 ==============================================  Edit nonESA medication without dose and Route as TP - should not save - error msg validation
'*Validation 49 ============================================== Edit nonESA medication without dose and Frequency as 'SLIDING SCALE'- should not save - error msg validation

blnEdit_Mandatory_Frequency_Dose_Route = Edit_Mandatory_Frequency_Dose_Route(strOutErrorDesc)
If not blnEdit_Mandatory_Frequency_Dose_Route  Then
	Call WriteToLog("Fail","Unable to validate editing. "& strOutErrorDesc)
	Call Terminator
End If
'===============================================

'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1
''---------------------------------------------------------------
'
''REVIEW
''*Validation 50 ============================================== Review check boxes on Medication add
''*Validation 51 ============================================== Medication Review header and order of check boxes
''*Validation 52 ============================================== Medication Review check boxes oder - Ascending
''*Validation 53 ============================================== Medication Review check boxes - Descending
''*Validation 54 ============================================== Medication Review check boxes - After completing review
''*Validation 55 ============================================== Medication Review check boxes while editing existing medication
''*Validation 56 ============================================== Medication Review check boxes while Cancelling patient medication
''*Validation 57 ============================================== Medication Review check boxes while switching screens

blnValidateReviewFunctionality = ValidateReviewFunctionality(strOutErrorDesc)
If not blnValidateReviewFunctionality Then
	Call WriteToLog("Fail","Unable to validate Review check functionalityg "&strOutErrorDesc)
	Call Terminator											
End If

'MEDICATION SCREENING======================================================================================================================================================================================
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 58 ============================================== Medication screening
'------------------------------------------------ ------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validation- Medication screening---")
Execute "Set objPage_MS = "&Environment("WPG_AppParent") 'PageObject
Set objPerformMedScreening = objPage_MS.WebButton("html tag:=BUTTON","name:= Perform Screening ","outertext:= Perform Screening ","visible:=True")
dtMedScrnDate = DateFormat(Date)
Execute "Set objPage_MS = Nothing"
Execute "Set objPage_MS = "&Environment("WPG_AppParent") 'PageObject
Set objMedScreeningMsg = objPage_MS.WebElement("html tag:=B","outertext:=Last screened at: "&dtMedScrnDate&".*","visible:=True")
blnMedScreening = ClickButton("Review",objPerformMedScreening,strOutErrorDesc)
If not blnMedScreening Then
	Call WriteToLog("Fail","Expected Result: Should be able to perform medication screening.  Actual Result: Unable to perform screening "&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Performed medication screening")

Wait 2
Call waitTillLoads("Loading...")
Wait 2

If not objMedScreeningMsg.Exist(60) Then
	Call WriteToLog("Fail","Expected Result: Medication screening message should be available.  Actual Result: Medication screening message is not available")
	Call Terminator											
End If
Call WriteToLog("Pass","Medication screening message is available")
Execute "Set objPage_MS = Nothing"
Set objPerformMedScreening = Nothing

'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1
'======================================================================================================================================================================================

'PROBLEMS SECTION ======================================================================================================================================================================================
'------------------------------------------------------------------------------------------
'*Validation 59 ============================================== Availability of Problems section
'------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate - Availability of Problems section---") 
Execute "Set objPage_Pb = "&Environment("WPG_AppParent") 'PageObject
blnProblemsSection  = objPage_Pb.WebElement("class:=.*percent accord-label.*","html tag:=DIV","innertext:=Problems ","outertext:=Problems ","visible:=True").Exist(5)
If not blnProblemsSection Then
	Call WriteToLog("Unable to find Problems section."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Problems section is available in Mecications screen")
'======================================================================================================================================================================================


'ALLERGY SECTION ======================================================================================================================================================================================
'-------------60----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 59 ==============================================  deletion of allergies
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'As the screen shrinks (unknown reason) get it to the real form by sending 'Tab' key
For tab = 1 To 10 Step 1
	sendkeys("{TAB}")
Next
Wait 1
Call WriteToLog("Info","---Validate deletion of allergies---") 
blnDeleteAllAllergies = DeleteAllAllergies()
If not blnDeleteAllAllergies Then
	Call WriteToLog("Fail","Expected Result: Should be able to delete all existing allergies. Actual Result: Unable to delete all existing allergies "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Deleted all existing allergies")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 61 ==============================================  Validate addition of Allergy
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate addition of Allergy---") 
strAllergyClass = "Allergy"
strAllergy = "Allopurinol"
strSymptom = "HeadAche"
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to add allergy of class 'Allergy'. Actual Result: Unable to add allergy "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Validated adding new allergy of class 'Allergy' with all required values")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 62 ==============================================  Validate deletion of a specfic allergy
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate deletion of a specfic allergy---") 
strDeleteAllergy = "Allopurinol"
blnDeleteAllergy = DeleteAllergy(strDeleteAllergy,strOutErrorDesc)
If not blnDeleteAllergy Then
	Call WriteToLog("Fail","Expected Result: Should be able to delete specific allergy of class 'Allergy'. Actual Result: Unable to delete allergy "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Validated deletion of specific allergy of class 'Allergy'")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 63 ==============================================  Validate addition of Mediction type allergy
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate addition of Mediction type allergy---") 
strAllergyClass = "Medication"
strAllergy = "ACE Elbow Support Medium Miscellaneous"
strSymptom = "HeadAche"
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to add allergy of class 'Medication'. Actual Result: Unable to add allergy "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Validated adding new allergy of class 'Medication' with all required values")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 64 ==============================================  Validate deletion of a specfic Medication type allergy
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate deletion of a specfic Medication type allergy---") 
strDeleteAllergy = "ACE Elbow Support Medium Miscellaneous"
blnDeleteAllergy = DeleteAllergy(strDeleteAllergy,strOutErrorDesc)
If not blnDeleteAllergy Then
	Call WriteToLog("Fail","Expected Result: Should be able to delete specific allergy of class 'Medication'. Actual Result: Unable to delete allergy "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Validated deletion of specific allergy of class 'Medication'")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 65 ==============================================  User cannot add duplicate allergy 
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate - User cannot add duplicate allergy---") 
strAllergyClass = "Allergy"
strAllergy = "Allopurinol"
strSymptom = "HeadAche"
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to add allergy of 'Allergy' class. Actual Result: Unable to add allergy "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Added new allergy of 'Allergy' class with required values")
End If

'trying to add duplicate allergy - allergy type
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)

blnDuplicateRestricted = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
If not blnDuplicateRestricted Then
	Call WriteToLog("Fail","Expected Result: Validation Error should be available when attepmts to add duplicate allergy of 'Allergy' class. Actual Result: Validation Error is not available "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Validation error message is available when tried to add duplicate allergy of 'Allergy' class")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 66 ==============================================  User cannot add duplicate Medication type allergy
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate - User cannot add duplicate Medication type allergy---") 
strAllergyClass = "Medication"
strAllergy = "ACE Elbow Support Medium Miscellaneous"
strSymptom = "HeadAche"
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to add allergy of 'Medication' class. Actual Result: Unable to add allergy "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Added new allergy of 'Medication' class with required values")
End If

'trying to add duplicate allergy - medication type
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)

blnDuplicateRestricted = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
If not blnDuplicateRestricted Then
	Call WriteToLog("Fail","Expected Result: Validation Error should be available when user attepmts to add duplicate allergy of 'Medication' class. Actual Result: Validation Error is not available "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Validation error message is available when tried to add duplicate allergy of 'Medication' class")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 67 ==============================================  User is able to add any other Allergy even if the 'Allergy History Not Known' allergy is active
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate - User is able to add any other Allergy even if the 'Allergy History Not Known' allergy is active---") 
strAllergyClass = "Allergy"
strAllergy = "Allergy History Not Known"
strSymptom = "HeadAche"
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to add 'Allergy History Not Known' allergy . Actual Result: Unable to add allergy "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Added 'Allergy History Not Known' allergy ")
End If

strAllergyClass = "Allergy"
strAllergy = "No Known Latex Allergy"
strSymptom = "HeadAche"
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to new allergy even if the 'Allergy History Not Known' allergy is active. Actual Result: Unable to add allergy "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","User is able to able new allergy even if the 'Allergy History Not Known' allergy is active")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 68 ==============================================  In order to add a 'No known drug allergy record' user should first delete all the 'Known drug allergy record(s)' 
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","--Validate - In order to add a 'No known drug allergy record' user should first delete all the 'Known drug allergy record(s)'---") 
strAllergyClass = "Allergy"
strAllergy = "No Known Drug Allergy"
strSymptom = "HeadAche"

'trying to add 'No known drug allergy record' while there are 'known allergy records'
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)

blnStatus = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
If not blnStatus Then
	Call WriteToLog("Fail","Expected Result: Validation Error should be available when user attepmts to add a 'No known drug allergy record' without deleting all the 'Known drug allergy record(s)'. Actual Result: Validation Error is not available "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Validation Error is available when user attepmts to add 'No known drug allergy record' without deleting all the 'Known drug allergy record(s)'")
End If

blnDeleteAllAllergies = DeleteAllAllergies()
If not blnDeleteAllAllergies Then
	Call WriteToLog("Fail","Expected Result: Should be able to delete all 'Known drug allergy record(s)'. Actual Result: Unable to delete. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Deleted all known drug allergy record(s)")
End If

blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to add 'No known drug allergy record'. Actual Result: Unable to add allergy. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","User is able to add 'No known drug allergy record' after deleting all 'Known drug allergy record(s)'")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 69 ==============================================  In order to add a 'known drug allergy record' user should first delete the 'No Known drug allergy record'
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate - In order to add a 'known drug allergy record' user should first delete the 'No Known drug allergy record'---") 
strAllergyClass = "Allergy"
strAllergy = "Allopurinol"
strSymptom = "HeadAche"

'trying to add 'known drug allergy record' while there is 'No known allergy records'
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)

blnStatus = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
If not blnStatus Then
	Call WriteToLog("Fail","Expected Result: Validation Error should be available when user attepmts to add a 'known drug allergy record' without deleting all the 'No known drug allergy record'. Actual Result: Validation Error is not available "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Validation Error is available when user attepmts to add a 'Known drug allergy record' without deleting the 'No known drug allergy record'")
End If

blnDeleteAllAllergies = DeleteAllAllergies()
If not blnDeleteAllAllergies Then
	Call WriteToLog("Fail","Expected Result: Should be able to delete 'No Known drug allergy record'. Actual Result: Unable to delete "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","Deleted 'No Known drug allergy record'")
End If

'Add 'Allergy' class allergy after deleting 'No Known drug allergy record'
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to add 'Known drug allergy record' (of class 'Allergy') after deleting 'No known drug allergy record. Actual Result: Unable to add allergy. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","User is able to add 'Known drug allergy record' (of class 'Allergy') after deleting 'No known drug allergy record'")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 70 ==============================================  'Add 'Medication' class allergy after deleting 'No Known drug allergy record'
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate-'Add 'Medication' class allergy after deleting 'No Known drug allergy record'---") 
strAllergyClass = "Medication"
strAllergy = "ACE Elbow Support Medium Miscellaneous"
strSymptom = "HeadAche"
blnAllergyDetails = AllergyDetails(strAllergyClass,strAllergy,strSymptom,strOutErrorDesc)
If not blnAllergyDetails Then
	Call WriteToLog("Fail","Expected Result: Should be able to add 'Known drug allergy record' (of class 'Medication') after deleting 'No known drug allergy record'. Actual Result: Unable to add allergy. "&strOutErrorDesc)
	Call Terminator
Else
	Call WriteToLog("Pass","User is able to add 'Known drug allergy record' (of class 'Medication') after deleting 'No known drug allergy record'")
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 71 ==============================================  'Add allergy (of allergy type) without mandatory field (name) - error message validation
'*Validation 72 ==============================================  Add allergy (of medication type) without mandatory field (name) - error message validation
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
blnAllergy_Validation_Mandatory = Allergy_Validation_Mandatory(strOutErrorDesc)
If not blnAllergy_Validation_Mandatory Then
	Call WriteToLog("Fail","Unabl to validate mandatory field scenarios."&strOutErrorDesc)
	Call Terminator											
End If
Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 73 ==============================================  Allergy dropdown sorting - for Allergy of Allergy type
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate Allergy dropdown sorting - for Allergy of Allergy type---") 
blnAllergySort = AllergySort("AllergyClass", strOutErrorDesc)
If not blnAllergySort Then
	Call WriteToLog("Fail","Expected Result: Should be able to validate Allergy dropdown sorting - for Allergy of Allergy type. Actual Result: Unable to validate. "&strOutErrorDesc)
	Call Terminator
End If

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'*Validation 74 ==============================================  Validate Allergy dropdown sorting - for Allergy of Medication type
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Call WriteToLog("Info","---Validate Allergy dropdown sorting - for Allergy of Medication type---") 
blnAllergySort = AllergySort("Medication", strOutErrorDesc)
If not blnAllergySort Then
	Call WriteToLog("Fail","Expected Result: Should be able to validate Allergy dropdown sorting - for Allergy of Medication type. Actual Result: Unable to validate. "&strOutErrorDesc)
	Call Terminator
End If
Wait 1
'======================================================================================================================================================================================

'---------------------
'Logout of application
''---------------------
Call WriteToLog("Info","-------------Logout from application-------------")
Call Logout()

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
