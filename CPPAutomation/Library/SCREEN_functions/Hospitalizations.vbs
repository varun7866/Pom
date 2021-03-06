'Starts - FUNCTIONS REQUIRED FOR HOSPITALIZATIONS > REVIEW SCREEN AUTOMATION SCRIPT---------------------------------------------------------------------------------------------------

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: NavigateToHospRwScr
'Purpose: Validate - Navigation to Hospitalizations > Hospitalization Management > Review screen
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function NavigateToHospRwScr(strOutErrorDesc)

	On Error Resume Next
	Err.Clear	
	strOutErrorDesc = ""
	NavigateToHospRwScr = False
	
	Call WriteToLog("Info","Navigate to Hospitalizations > Hospitalization Management > Review screen")
	
	'Validation - Navigation Hospitalizations > Hospitalization Management > Review screen
	
	blnScreenNavigation = clickOnSubMenu_WE("Clinical Management->Hospitalizations")
	If not blnScreenNavigation Then
		Call WriteToLog("Fail","Unable to navigate to Hospitalizations screens "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Navigated to Hospitalizations screens")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1	
	
	'Click on Review tab
	Execute "Set objHospitalizationsReviewTab = "&Environment("WE_HospitalizationReviewTab")
	blnClickedHospitalizationsReviewTab = ClickButton("Review",objHospitalizationsReviewTab,strOutErrorDesc)
	If not blnClickedHospitalizationsReviewTab Then
		Call WriteToLog("Fail","Unable to click Hospitalizations > Review tab. "&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Clicked Hospitalizations > Review tab")
	Execute "Set objHospitalizationsReviewTab = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	Execute "Set objHospitalizationHeader = " & Environment("WEL_HospitalizationHeader")
	Execute "Set objHospitalizationReviewHeader = " & Environment("WEL_HospitalizationReviewHeader")
	If not objHospitalizationHeader.Exist(5) AND objHospitalizationReviewHeader.Exist(5) Then
		strOutErrorDesc = "User didn't navigate to Hospitalization screens"
		Exit Function
	End If
	Call WriteToLog("Pass","Validated user navigation to Hospitalization screens")
		
	NavigateToHospRwScr = True
	
	Set objPage = Nothing
	Err.Clear
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: PreliminaryScenarios
'Purpose: Validate - Availablity of Hospitalization Management > Review screen all sections
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function PreliminaryScenarios(strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PriliminaryScenarios = False

	Call WriteToLog("Info","Preliminary Scenarios")
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Availability of 'Length of Stay' section
	Execute "Set objLengthOfStayHeader = " & Environment("WEL_LengthOfStayHeader")
	If not objLengthOfStayHeader.Exist(1) Then
		Call WriteToLog("Fail","'Length of Stay' section is not available")		
	End If
	Call WriteToLog("Pass","'Length of Stay' section is available")
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Availability of 'Admittance' section
	Execute "Set objAdmittanceHeader = " & Environment("WEL_AdmittanceHeader")
	If not objAdmittanceHeader.Exist(1) Then
		Call WriteToLog("Fail","'Admittance' section is not available")
	End If
	Call WriteToLog("Pass","'Admittance' section is available")
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Availability of 'Transfer' section
	Execute "Set objTransferHeader = " & Environment("WEL_TransferHeader")
	If not objTransferHeader.Exist(1) Then
		Call WriteToLog("Fail","'Transfer' section is not available")
	End If
	Call WriteToLog("Pass","'Transfer' section is available")
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Availability of 'Discharge' section
	Execute "Set objDischargeHeader = " & Environment("WEL_DischargeHeader")
	If not objDischargeHeader.Exist(1) Then
		Call WriteToLog("Fail","'Discharge' section is not available")
	End If
	Call WriteToLog("Pass","'Discharge' section is available")
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Availability of 'Related Diagnoses' section
	Execute "Set objRelatedDiagnosesHeader = " & Environment("WEL_RelatedDiagnosesHeader")
	If not objRelatedDiagnosesHeader.Exist(1) Then
		Call WriteToLog("Fail","'Related Diagnoses' section is not available")
	End If
	Call WriteToLog("Pass","'Related Diagnoses' section is available")
	
	'Validation - Availability of 'Related Diagnoses' section Medication TextBox
	Execute "Set objRelatedDiagnosesMedTxBx = " & Environment("WE_RD_Med_TxBx")
	If not objRelatedDiagnosesMedTxBx.Exist(1) Then
		Call WriteToLog("Fail","'Related Diagnoses' section Medidation TextBox is not available")
	End If
	Call WriteToLog("Pass","'Related Diagnoses' section Medidation TextBox is available")	
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Availability of 'HospitalizationHistory' section
	Execute "Set objHospitalizationHistoryTableHeader = " & Environment("WEL_HospitalizationHistoryTableHeader")	
	If not objHospitalizationHistoryTableHeader.Exist(1) Then
		Call WriteToLog("Fail","'HospitalizationHistory' table is not available")
	End If
	Call WriteToLog("Pass","'HospitalizationHistory' table is available")
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	PreliminaryScenarios = True
	
	Execute "Set objHospitalizationHeader = Nothing"
	Execute "Set objLengthOfStayHeader = Nothing"
	Execute "Set objAdmittanceHeader = Nothing"
	Execute "Set objTransferHeader = Nothing"
	Execute "Set objDischargeHeader = Nothing"
	Execute "Set objRelatedDiagnosesHeader = Nothing"
	Execute "Set objRelatedDiagnosesMedTxBx = Nothing"
	Execute "Set objHospitalizationHistoryTableHeader = Nothing"
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Admittance_AllFields
'Purpose: Validate - Availability of all Admittance section fields and data entry into all fields
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Admittance_AllFields(ByVal dtAdmitDate, ByVal dtNotificationDate, ByVal strAdmitType, ByVal strNotifiedBy, ByVal strSourceOfAdmit, strOutErrorDesc)	
	
	On Error Resume Next
	strOutErrorDesc = ""
	Admittance_AllFields = False
	Err.Clear
	
	Call WriteToLog("Info","Admittance with all fields")
	
	strFacilityName = "Facility Name"
	lngFacilityPhone = 1231231230
	lngFacilityFax = 1231231231
	strLocPriorToHospVisit = "Community"
	strPrimaryDiagnosis = "Cardiovascular"
	strRelatedSubCategory = "CHF"
	strReAdmitReason = "Unrelated Readmission"
	strAdmittingDiagnosisTxt = "Admitting Diagnostics text"
	strWorkingDiagnosisTxt = "Working Diagnostics text"
	strAvoidableAdmissionComment = "Avoidable Admission"
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Add' button avaiability and button functionality
	Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
	If not objAddBtn.Object.isDisabled Then
		Err.Clear
		objAddBtn.highlight
		blnAddClicked = ClickButton("Add",objAddBtn,strOutErrorDesc)
		If not blnAddClicked Then
			strOutErrorDesc = "Unable to click Add button for hospitalization "& strOutErrorDesc
			Exit Function	
		End If
	End If
	Call WriteToLog("Pass","'Add' button is available and validated button functionality")	
	Execute "Set objAddBtn = Nothing"
	wait 5	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Admit Date' edit box availability and setting required date
	Execute "Set objAdmitDateTxt = " & Environment("WE_AdmitDateTxt") 'Admit date text box
	If not objAdmitDateTxt.Object.isDisabled Then
		Err.Clear
		objAdmitDateTxt.Set dtAdmitDate
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
			Exit Function	
		Else 
			Call WriteToLog("Pass","Admit Date field is available and admit date is set")
		End If
	End If	
	Execute "Set objAdmitDateTxt = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Notification Date' edit box availability and setting required date
	Err.Clear
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Notification Date field is available and admit notification date is set")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Facility Name' edit box availability and setting required value
	Execute "Set objFacilityName = " & Environment("WE_FacilityName") 'FacilityName
	Err.Clear
	objFacilityName.Set strFacilityName 
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to set Facility name. "&Err.Description)
	End If
	Call WriteToLog("Pass","Facility name field is available and facility name is set")
	Execute "Set objFacilityName = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Facility Phone' edit box availability and setting required value
	Execute "Set objFacilityPhone = " & Environment("WE_FacilityPhone") 'FacilityPhone
	Err.Clear
	objFacilityPhone.Set lngFacilityPhone
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to set Facility phone. "&Err.Description)
	End If
	Call WriteToLog("Pass","Facility phone field is available and facility phone is set")	
	Execute "Set objFacilityPhone = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Facility Fax' edit box availability and setting required value
	Execute "Set objFacilityFax = " & Environment("WE_FacilityFax") 'FacilityFax
	Err.Clear
	objFacilityFax.Set lngFacilityFax
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to set Facility fax. "&Err.Description)
	End If
	Call WriteToLog("Pass","Facility fax field is available and facility fax is set")
	Execute "Set objFacilityFax = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Notified By' drop down availability and selection of required value
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
	objNotifiedByDD.highlight
	blnNotification = selectComboBoxItem(objNotifiedByDD, strNotifiedBy)
	If Not blnNotification Then
		strOutErrorDesc = "Unable to select required 'NotifiedBy'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Notified By' drop down is available and selected required 'Notified By' value")
	Execute "Set objNotifiedByDD = Nothing"
	wait 0,500
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Adimit Type' drop down availability and selection of required value
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
	objAdmitTypeDD.highlight
	blnAdmitType = selectComboBoxItem(objAdmitTypeDD, strAdmitType)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to select required admit type. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Admit Type' drop down is available and selected required 'Admit Type'")
	Execute "Set objAdmitTypeDD = Nothing"
	wait 0,500
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Source of Admit' drop down availability and selection of required value
	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
	objSourceOfAdmitDD.highlight
	blnSourceOfAdmit = selectComboBoxItem(objSourceOfAdmitDD, strSourceOfAdmit)
	If Not blnSourceOfAdmit Then
		strOutErrorDesc = "SourceOfAdmit selection returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Source of Admit' drop down is available and selected required SourceOfAdmit")
	Execute "Set objSourceOfAdmitDD = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Location Prior to Hospital Admit' drop down availability and selection of required value	
'	Execute "Set objPageAdmitPatient = Nothing"
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_LocPriorToHospVisit_DD = objPageAdmitPatient.WebButton("class:=btn btn-default dropdown-toggle dropdowndefault","html tag:=BUTTON","type:=button","visible:=True","index:=4") 'LocationPriorToHospitalVisit
	Execute "Set objAdmit_LocPriorToHospVisit_DD = " & Environment("WEL_LocPriorHospVisit")
	objAdmit_LocPriorToHospVisit_DD.highlight
	blnLocPriorToHospVisit = selectComboBoxItem(objAdmit_LocPriorToHospVisit_DD, strLocPriorToHospVisit)
	If Not blnLocPriorToHospVisit Then
		Call WriteToLog("Fail","Unable to select required 'Location Prior to Hospital Admit'. "&strOutErrorDesc)
	End If
	Call WriteToLog("Pass","'Location Prior to Hospital Admit' drop down is available and selected required value")
	Execute "Set objPageAdmitPatient = Nothing"
	Set objAdmit_LocPriorToHospVisit_DD = Nothing
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Primary Diagnosis' drop down availability and selection of required value
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_PrimaryDiagnosis_DD = objPageAdmitPatient.WebButton("class:=btn btn-default dropdown-toggle dropdowndefault","html tag:=BUTTON","type:=button","visible:=True","index:=5") 'PrimaryDiagnosis
	Execute "Set objAdmit_PrimaryDiagnosis_DD = " & Environment("WEL_PrimaryDiagnosis")
	objAdmit_PrimaryDiagnosis_DD.highlight
	blnPageAdmitPatient = selectComboBoxItem(objAdmit_PrimaryDiagnosis_DD, strPrimaryDiagnosis)
	If Not blnPageAdmitPatient Then
		Call WriteToLog("Fail","Unable to select required 'primary diagnosis'. "&strOutErrorDesc)
	End If
	Call WriteToLog("Pass","'Primary Diagnosis' drop down is available and selected required value")
	Execute "Set objPageAdmitPatient = Nothing"
	Set objAdmit_PrimaryDiagnosis_DD = Nothing
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Related Subcategory' drop down availability and selection of required value
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_RelatedSubCategory_DD = objPageAdmitPatient.WebButton("class:=btn btn-default dropdown-toggle dropdowndefault","html tag:=BUTTON","type:=button","visible:=True","index:=6") 'RelatedSubCategory
	Execute "Set objAdmit_RelatedSubCategory_DD = " & Environment("WEL_RelatedSubCategory")
	objAdmit_RelatedSubCategory_DD.highlight
	blnRelatedSubCategory = selectComboBoxItem(objAdmit_RelatedSubCategory_DD, strRelatedSubCategory)
	If Not blnRelatedSubCategory Then
		Call WriteToLog("Fail","Unable to select required 'related sub category'. "&strOutErrorDesc)
	End If
	Call WriteToLog("Pass","'Related Subcategory' drop down is available and selected required value")
	Execute "Set objPageAdmitPatient = Nothing"
	Set objAdmit_RelatedSubCategory_DD = Nothing
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	If objAdmit_ReadmitSpace is checked  Then

	'Validation - 'Readmit' space availability 
	Execute "Set objReadmitSpace = " & Environment("WEL_ReadmitSpace") 'Readmit space
	If not objReadmitSpace.Exist(.1) then 
		Call WriteToLog("Fail","Re-admid space not exists")
	End If 	
	Call WriteToLog("Pass","Re-admid space is availabale")	
	Execute "Set objReadmitSpace = Nothing"
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Readmit Reason' drop down availability
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_Reason_DD = objPageAdmitPatient.WebButton("html tag:=BUTTON","outerhtml:=.*HospitalizationModel.*","type:=button","visible:=True","index:=4") 'Reason
	Execute "Set objAdmit_Reason_DD = " & Environment("WEL_ReAdmitReason") 
	If not objAdmit_Reason_DD.Exist(1) Then
		Call WriteToLog("Fail","'Readmit Reason' drop down is not available")
	End If
	Call WriteToLog("Pass","'Readmit Reason' drop down is available and selected required value")
	Set objAdmit_Reason_DD = Nothing
	wait 0,250
			
'		blnReturnValue = selectComboBoxItem(objAdmit_Reason_DD, strReAdmitReason)
'		If Not blnRelatedSubCategory Then
'			Call WriteToLog("Fail","Unable to select re-admit reason. "&strOutErrorDesc)
'		End If
'		Call WriteToLog("Pass","'Readmit Reason' drop down is available and selected required value")
'		Set objAdmit_Reason_DD = Nothing
'		wait 0,250
'	End If	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Admitting Diagnosis' edit box availability and setting required data
	Err.Clear
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
	objAdmittingDiagnosisTxt.Set strAdmittingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for AdmittingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Admitting Diagnosis' field is available and required value is set")
	End If
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	wait 0,500	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Working Diagnosis' edit box availability and setting required data
	Err.Clear
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
	objWorkingDiagnosisTxt.Set strWorkingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for WorkingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Working Diagnosis' field is available and required value is set")
	End If
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	wait 0,500
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation -'Planned Admission' check box availability and checking
	Execute "Set objPlannedAdmission = " & Environment("WE_PlannedAdmission") 'Planned Admission cb
	Err.clear
	objPlannedAdmission.Click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to check Planned Admission check box. "&Err.Description)
	End If
	Call WriteToLog("Pass","'Planned Admission' check box is available and is checked")
	Execute "Set objPlannedAdmission = Nothing"
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Verbal Contact' check box availability and checking
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_VerbalContact_CB = objPageAdmitPatient.WebElement("class:=screening-check-box-no float-left   whitebg","html tag:=DIV","visible:=True","index:=1") 'verbal contact cb
	Execute "Set objAdmit_VerbalContact_CB = " & Environment("WEL_Admit_VerbalContact_CB") 
	Err.clear
	objAdmit_VerbalContact_CB.Click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to check VerbalContact check box. "&Err.Description)
	End If
	Call WriteToLog("Pass","'Verbal Contact' check box is available and is checked")
	Execute "Set objPageAdmitPatient = Nothing"
	Set objAdmit_VerbalContact_CB = Nothing
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Avoidable Admission' check box availability and checking
	Execute "Set objAvoidableAdmission_Unchecked = " & Environment("WE_AvoidableAdmission_Unchecked")
	Execute "Set objAvoidableAdmission_Checked = " & Environment("WE_AvoidableAdmission_Checked")
	Err.clear
	If objAvoidableAdmission_Unchecked.Exist(1) Then
		objAvoidableAdmission_Unchecked.Click
		If Err.Number <> 0 Then
			Call WriteToLog("Fail","Unable to check AvoidableAdmission check box. "&Err.Description)
		End If
		Call WriteToLog("Pass","'Avoidable Admission' check box is available and is checked")
	ElseIf objAvoidableAdmission_Checked.Exist(1) Then
		Call WriteToLog("Pass","'Avoidable Admission' check box is available and is already checked")
	Else
		Call WriteToLog("Fail","Unable to find AvoidableAdmission check box. "&Err.Description)
	End If
	
	Execute "Set objAvoidableAdmission_Unchecked = Nothing"
	Execute "Set objAvoidableAdmission_Unchecked = " & Environment("WE_AvoidableAdmission_Unchecked")
	
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Avoidable Admission' comment field availability and setting required value
	Execute "Set objAdmit_AvoidableAdmission_TB = "&Environment("WE_AvoidableAdmitComment")	
	Err.Clear
	objAdmit_AvoidableAdmission_TB.Set strAvoidableAdmissionComment
	If Err.Number <> 0 Then 
		strOutErrorDesc = "Unable to set 'AvoidableAdmission' comment"&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","'Avoidable Admission' comment is set")
	End If	
	Execute "Set objAdmit_AvoidableAdmission_TB = Nothing"
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Length of Stay' section shows 0 Days before saving admittance
	Execute "Set objLenghtOfStayBeforeAdmit0Days = " & Environment("WE_LenghtOfStayBeforeAdmit0Days")
	If not objLenghtOfStayBeforeAdmit0Days.Exist(1) Then
		Call WriteToLog("Fail","'Length of Stay' section is not showing '0 Days' before hospital admit")		
	End If
	Call WriteToLog("Pass","'Length of Stay' section showing '0 Days' before hospital admit")
	Execute "Set objLenghtOfStayBeforeAdmit0Days = Nothing"
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Save' button availability and status
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	If not objSaveBtn.Exist(1) OR objSaveBtn.Object.isDisabled Then
		strOutErrorDesc = "'Save' button for hospitalization is disabled/not existing after entering admittance fileds"& strOutErrorDesc
		Exit Function	
	End If
	Call WriteToLog("Pass","'Save' button for hospitalization is available and is enabled after entering admittance fileds")
	Execute "Set objSaveBtn = Nothing"
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	Admittance_AllFields = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: AdmitDateScenariosPreliminary
'Purpose: Validate - Admission without providing AdmitDate, AdmitDate < 366 days to sys date, AdmitDate > sys date, AdmitDate > AdmitNotificationDate, Provide AdmitDate <= AdmitNotificationDate  
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function AdmitDateScenariosPreliminary(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	AdmitDateScenariosPreliminary = False
	
	Call WriteToLog("Info","AdmitDate Scenarios Preliminary")
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save admission without providing AdmitDate - validate error msg box
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set ""
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to clear AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Cleared Admit Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	Wait 0,250
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnAdmitDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'AdmitDate' should be set to 'a valid value' for this operation", strOutErrorDesc)
	If not blnAdmitDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission without providing AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission without providing AdmitDate")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save admission providing AdmitDate < 366 days to sys date - validate error msg box
	dtAdmitDate = DateAdd("d",-370,Date)
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set dtAdmitDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Admit Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnAdmitDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'AdmitDate' cannot be older than 366 days from today's date and cannot be greater than today's date", strOutErrorDesc)
	If not blnAdmitDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing AdmitDate older than 366 days from sys date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing AdmitDate older than 366 days from sys date")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save admission providing AdmitDate > sys date - validate error msg box
	dtAdmitDate = DateAdd("d",5,Date)
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set dtAdmitDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Admit Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	
	'Clk Save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnAdmitDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'AdmitDate' cannot be older than 366 days from today's date and cannot be greater than today's date", strOutErrorDesc)
	If not blnAdmitDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing AdmitDate greater than sys date "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing AdmitDate greater than sys date")
	End If
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save admission providing AdmitDate > AdmitNotificationDate - validate error msg box
	dtAdmitDate = DateAdd("d",-1,Date)
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set dtAdmitDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set AdmitNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Admit Notification Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	Wait 0,250
	
	dtNotificationDate = DateAdd("d",-2,Date)
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Set Notification Date")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'validate err msg box
	blnAdmitDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'DateNotified' can not be earlier than 'AdmitDate'", strOutErrorDesc)
	If not blnAdmitDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing AdmitDate greater than Admit Notification date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing AdmitDate greater than Admit Notification date")
	End If
	Wait 1	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Provide AdmitDate <= AdmitNotificationDate
	dtAdmitDate = DateAdd("d",-2,Date)
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set dtAdmitDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Admit Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	Wait 0,250
	
	dtNotificationDate = DateAdd("d",-2,Date)
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Set Notification Date")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	AdmitDateScenariosPreliminary = True	
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: AdmitNotificationDateScenariosPreliminary
'Purpose: Validate - Admission without providing AdmitNotificationDate,  AdmitNotificationDate < AdmitDate, AdmitNotificationDate older than 7 days from sys date, AdmitNotificationDate greater than sys date, Provide AdmitNotificationDate less than sys date (not less than 7 days) and >= to admit date   
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function AdmitNotificationDateScenariosPreliminary(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	AdmitNotificationDateScenariosPreliminary = False
	
	Call WriteToLog("Info","AdmitNotificationDate Scenarios Preliminary")
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save admission without providing Admit Notification Date - validate error msg box
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set ""
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to clear AdmitNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Cleared Admit Notification Date")
	End If	
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnAdmitNotificationDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'DateNotified' should be set to 'a valid value' for this operation", strOutErrorDesc)
	If not blnAdmitNotificationDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission without providing AdmitNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission without providing AdmitNotificationDate")
	End If	
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save admission providing AdmitNotificationDate < AdmitDate - validate error msg box
	dtAdmitDate = DateAdd("d",-2,Date)
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set dtAdmitDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Admit Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	Wait 0,250
	
	dtNotificationDate = DateAdd("d",-4,Date)
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Set Notification Date")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'validate err msg box
	blnAdmitNotificationDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'DateNotified' can not be earlier than 'AdmitDate'", strOutErrorDesc)
	If not blnAdmitNotificationDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing AdmitNotificationDate earlier than 'AdmitDate'"&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing 'AdmitNotificationDate' earlier than 'AdmitDate'")
	End If	
	Wait 0,250	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save admission providing AdmitNotificationDate older than 7 days from sys date
	dtAdmitDate = DateAdd("d",-9,Date)
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set dtAdmitDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Admit Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	Wait 0,250
	
	dtNotificationDate = DateAdd("d",-9,Date)
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Set Notification Date")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnAdmitNotificationDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'DateNotified' cannot be older than 7 days from today's date and cannot be greater than today's date", strOutErrorDesc)
	If not blnAdmitNotificationDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing AdmitNotificationDate older than 7 days from sys date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing AdmitNotificationDate older than 7 days from sys date")
	End If	
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save admission providing AdmitNotificationDate greater than sys date - err msg validation
	dtAdmitDate = DateAdd("d",-2,Date)
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set dtAdmitDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Admit Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	Wait 0,250
	
	dtNotificationDate = DateAdd("d",2,Date)
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Set Notification Date")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnAdmitNotificationDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'DateNotified' cannot be older than 7 days from today's date and cannot be greater than today's date", strOutErrorDesc)
	If not blnAdmitNotificationDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing AdmitNotificationDate greater than sys date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing AdmitNotificationDate greater than sys date")
	End If	
	Wait 0,250	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Provide AdmitNotificationDate less than sys date (not less than 7 days) and >= to admit date 
	dtAdmitDate = DateAdd("d",-3,Date)
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear
	objAdmitDate.Set dtAdmitDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Admit Date")
	End If
	Execute "Set objAdmitCalendarBtn = Nothing"
	Wait 0,250
	
	dtNotificationDate = DateAdd("d",-3,Date)
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Set Notification Date")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	AdmitNotificationDateScenariosPreliminary = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: OtherAdmitMandatoryScenarios
'Purpose: Validate - Admission by setting 'Notified By', 'Admit Type', 'Source of Admit', 'Admitting Diagnosis', Working Diagnosis', 'Avoidable Admission' to invalid values
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function OtherAdmitMandatoryScenarios(strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	OtherAdmitMandatoryScenarios = False
	
	strInvalidValue = "Select a value" 
	strNotifiedBy = "Dialysis Center"
	strAdmitType = "Hospital Admit"
	strSourceOfAdmit = "Observation"	
	strAdmittingDiagnosisTxt = "Admitting Diagnosis"
	strWorkingDiagnosisTxt = "Working Diagnosis"
	strAvoidableAdmissionComment = "Avoidable Admission"
	
	Call WriteToLog("Info","Other AdmitMandatory Scenarios Preliminary")
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Set 'Notified By' to invalid value and try to save admittance - validate error msg box
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
	objNotifiedByDD.highlight
	blnNotification = selectComboBoxItem(objNotifiedByDD, strInvalidValue)
	If Not blnNotification Then
		strOutErrorDesc = "Unable to clear 'Notified By'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Cleared 'Notified By'")
	Execute "Set objNotifiedByDD = Nothing"
	wait 1
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate message box
	blnOtherScenariosPP = checkForPopup("Invalid Data", "Ok", "Field 'NotifiedBy' of 'ptDischargePlan' entity should be set", strOutErrorDesc)
	If not blnOtherScenariosPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission without providing Notified By value "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission without providing Notified By value")
	End If
	Wait 1
	
	'Provide valid value
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
	objNotifiedByDD.highlight
	blnNotification = selectComboBoxItem(objNotifiedByDD, strNotifiedBy)
	If Not blnNotification Then
		strOutErrorDesc = "Unable to select 'Notified By' value from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Notified By' value is selected from dropdown")
	Execute "Set objNotifiedByDD = Nothing"
	wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Set 'Admit Type' to invalid value and try to save admittance - validate error msg box
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
	objAdmitTypeDD.highlight
	blnAdmitType = selectComboBoxItem(objAdmitTypeDD, strInvalidValue)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to clear admit type. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Cleared Admit Type")
	Execute "Set objAdmitTypeDD = Nothing"
	wait 1
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Vlidate msg box
	blnOtherScenariosPP = checkForPopup("Invalid Data", "Ok", "not a valid value for NatureOfAdmit", strOutErrorDesc)
	If not blnOtherScenariosPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission without providing Notified By value "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission without providing Notified By value")
	End If
	Wait 1	
	
	'Provide valid value
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
	objAdmitTypeDD.highlight
	blnAdmitType = selectComboBoxItem(objAdmitTypeDD, strAdmitType)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to select required admit type. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Selected Admit Type")
	Execute "Set objAdmitTypeDD = Nothing"
	wait 1	
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Set Source of Admit' to invalid value and try to save admittance - validate error msg box
	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
	objSourceOfAdmitDD.highlight
	blnAdmitType = selectComboBoxItem(objSourceOfAdmitDD, strInvalidValue)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to clear Source of Admit. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Cleared Source of Admit")
	Execute "Set objSourceOfAdmitDD = Nothing"
	wait 1
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate msg box
	blnOtherScenariosPP = checkForPopup("Invalid Data", "Ok", "Field 'NatureOfAdmit' of 'ptDischargePlan' entity should be set", strOutErrorDesc)
	If not blnOtherScenariosPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission without providing Notified By value "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission without providing Notified By value")
	End If
	Wait 1	
	
	'Provide valid value
	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
	objSourceOfAdmitDD.highlight
	blnAdmitType = selectComboBoxItem(objSourceOfAdmitDD, strSourceOfAdmit)
	If Not blnAdmitType Then
		strOutErrorDesc = "Admit Type selection returned error: "&strOutErrorDesc
		strOutErrorDesc = "Unable to select required admit type.  Actual Result: " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Selected Source of Admit")
	Execute "Set objSourceOfAdmitDD = Nothing"
	wait 1
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Clear 'Admitting Diagnosis' and try to save - validate error msg box
	Err.Clear
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
	objAdmittingDiagnosisTxt.Set ""
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to clear AdmittingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Admitting Diagnosis' field is cleared")
	End If
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	wait 0,500
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnOtherScenariosPP = checkForPopup("Invalid Data", "Ok", "Field 'AdmittingDXDesc' of 'ptDischargePlan' entity should be set to 'a valid value.' for this operation", strOutErrorDesc)
	If not blnOtherScenariosPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission without providing 'Admitting Diagnosis' value "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Message box is available when tried to save admission without providing 'Admitting Diagnosis' value")
	End If
	Wait 1	
	
	'Provide valide value
	Err.Clear
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
	objAdmittingDiagnosisTxt.Set strAdmittingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for AdmittingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Admitting Diagnosis' field is available and required value is set")
	End If
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	wait 0,500
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Clear 'Working Diagnosis' and try to save - validate error msg box
	Err.Clear
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
	objWorkingDiagnosisTxt.Set ""
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to clear WorkingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Working Diagnosis' field is cleared")
	End If
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	wait 0,500
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnOtherScenariosPP = checkForPopup("Invalid Data", "Ok", "Field 'WorkingDiagnosis' of 'ptDischargePlan' entity should be set to 'a valid value.' for this operation", strOutErrorDesc)
	If not blnOtherScenariosPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission without providing 'Working Diagnosis' value "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Message box is available when tried to save admission without providing 'Working Diagnosis' value")
	End If
	Wait 1
	
	'Provide valide value
	Err.Clear
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
	objWorkingDiagnosisTxt.Set strWorkingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for WorkingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Working Diagnosis' field is available and required value is set")
	End If
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	wait 0,500
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - Check 'Avoidable Admission' and  try to save without providing comment  - Error pop validation
'	'Execute "Set objAvoidableAdmission_Checked = " & Environment("WE_AvoidableAdmission_Checked")
'	Execute "Set objAvoidableAdmission_Unchecked = " & Environment("WE_AvoidableAdmission_Unchecked")
'	If objAvoidableAdmission_Unchecked.Exist(1) Then
'		Err.Clear
'		objAvoidableAdmission_Unchecked.Click
'		If Err.number <> 0 Then
'			strOutErrorDesc = "Unable to check AvoidableAdmission check box. "&Err.Description
'			Exit Function	
'		Else 
'			Call WriteToLog("Pass","Checked AvoidableAdmission check box")
'		End If
'		Execute "Set objAvoidableAdmission_Unchecked = Nothing"
'		wait 0,500
'	End If
	
	'Clear Avoidable admittance comment
	Execute "Set objAdmit_AvoidableAdmission_TB = "&Environment("WE_AvoidableAdmitComment")	
	Err.Clear
	objAdmit_AvoidableAdmission_TB.Set ""
	If Err.Number <> 0 Then 
		strOutErrorDesc = "Unable to clear Avoidable Admission comment"&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Cleared 'Avoidable Admission' comment")
	End If	
	Execute "Set objAdmit_AvoidableAdmission_TB = Nothing"
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked Then
		strOutErrorDesc = "Unable to click Save button for hospitalization "& strOutErrorDesc
		Exit Function	
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnAvoidableAdmissionScenarioPP = checkForPopup("Hospitalization", "Ok", "Please enter Avoidable Admission Comments", strOutErrorDesc)
	If not blnAvoidableAdmissionScenarioPP Then
		strOutErrorDesc = "Message box is not available when Avoidable Admission comment is not provied  "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Message box is available when Avoidable Admission comment is not provied")
	End If	
	
	'Validation - Check Avoidable Admission and provide comment
	Execute "Set objAdmit_AvoidableAdmission_TB = "&Environment("WE_AvoidableAdmitComment")	
	Err.Clear
	objAdmit_AvoidableAdmission_TB.Set strAvoidableAdmissionComment
	If Err.Number <> 0 Then 
		strOutErrorDesc = "Unable to set AvoidableAdmissionComment"&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Avoidable Admission Comment is set")
	End If	
	Execute "Set objAdmit_AvoidableAdmission_TB = Nothing"
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	OtherAdmitMandatoryScenarios = True	
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: SaveFunctionality
'Purpose: Validate - Save functionality for Admittance, Discharge and Transfer
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function SaveFunctionality(ByVal strFunctionality)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	SaveFunctionality = False
	
	'Click on Save button for hospitalization
	Err.Clear
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked Then
		strOutErrorDesc = "Unable to click Save button for hospitalization "& strOutErrorDesc
		Exit Function	
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Updating Record...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
		
	strFunctionality = Trim(LCase(strFunctionality))
	If Instr(1,strFunctionality,"admit",1) Then
		'Validate - 'Record has been updated successfully' message box at saving admission
		blnRecordUpdatedPopup = checkForPopup("Hospitalization", "Ok", "Record has been added successfully", strOutErrorDesc)
		If not blnRecordUpdatedPopup Then
			strOutErrorDesc = "Unable to validate record added popup "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass","Hospital admit is saved and validated record added popup")	
		Wait 1	
	ElseIf Instr(1,strFunctionality,"transfer",1) Then	
		'Check for 'Record has been updated successfully' popup
		blnRecordUpdatedPopup = checkForPopup("Hospitalization", "Ok", "Record has been updated successfully", strOutErrorDesc)
		If not blnRecordUpdatedPopup Then
			strOutErrorDesc = "Unable to validate record updated popup "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass","Transfer is saved and validated record updated popup")	
		Wait 1				
	ElseIf Instr(1,strFunctionality,"discharge",1) Then	
		'Check for 'Record has been updated successfully' popup
		blnRecordUpdatedPopup = checkForPopup("Hospitalization", "Ok", "Record has been updated successfully", strOutErrorDesc)
		If not blnRecordUpdatedPopup Then
			strOutErrorDesc = "Unable to validate record updated popup "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass","Validated record updated popup")	
		Wait 1	
	End If
	
	SaveFunctionality = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: AdmittanceFieldsStatusAfterAdmission
'Purpose: Validate - All admittance fileds after admittance
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function AdmittanceFieldsStatusAfterAdmission(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	Call WriteToLog("Info","Admittance Fields Status After Admission")

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Add' button status after admittance (should be disabled)
	Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
	If not objAddBtn.Object.isDisabled Then
		Call WriteToLog("Fail","Add button is not disabled after admittance")
	End If
	Call WriteToLog("Pass","'Add' button is disabled after admittance")
	Execute "Set objAddBtn = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Admit Date' status after admittance (should be disabled)
	Execute "Set objAdmitDateTxt = " & Environment("WE_AdmitDateTxt") 'Admit date text box
	If not objAdmitDateTxt.Object.isDisabled Then
		Call WriteToLog("Fail","Admit Date is not disabled after admittance")
	End If
	Call WriteToLog("Pass","'Admit Date' is disabled after admittance")
	Execute "Set objAdmitDateTxt = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Admit Notification Date' status after admittance (should be enabled)
	Err.Clear
	Execute "Set objAdmitNotificationDateTxt = " & Environment("WE_AdmitNotificationDateTxBx_AfAd")
	If objAdmitNotificationDateTxt.Object.isDisabled Then
		Call WriteToLog("Fail","Admit Notification Date is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Admit Notification Date' is not disabled after admittance as expected")
	Execute "Set objAdmitNotificationDateTxt = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Facility Name' status after admittance (should be enabled)
	Execute "Set objFacilityName = " & Environment("WE_FacilityName") 'FacilityName
	If objFacilityName.Object.isDisabled Then
		Call WriteToLog("Fail","Facility Name is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Facility Name' is not disabled after admittance as expected")
	Execute "Set objFacilityName = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Facility Phone' status after admittance (should be enabled)
	Execute "Set objFacilityPhone = " & Environment("WE_FacilityPhone") 'FacilityPhone
	If objFacilityPhone.Object.isDisabled Then
		Call WriteToLog("Fail","Facility Phone is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Facility Phone' is not disabled after admittance as expected")
	Execute "Set objFacilityPhone = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Facility Fax' status after admittance (should be enabled)
	Execute "Set objFacilityFax = " & Environment("WE_FacilityFax") 'FacilityFax
	If objFacilityFax.Object.isDisabled Then
		Call WriteToLog("Fail","Facility Fax is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Facility Fax' is not disabled after admittance as expected")
	Execute "Set objFacilityFax = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - 'Notified By' drop down status after admittance (should be enabled)
'	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
'	If objNotifiedByDD.Object.isDisabled Then
'		Call WriteToLog("Fail","Notified By is disabled after admittance")
'	End If
'	Call WriteToLog("Pass","'Notified By' is not disabled after admittance as expected")
'	Execute "Set objNotifiedByDD = Nothing"
'	wait 0,100

	'Validation - 'Notified By' drop down status after admittance (should be enabled)
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
'	objNotifiedByDD.highlight
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objNotifiedByDD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If objNotifiedByDD.Object.isDisabled Then
		Call WriteToLog("Fail","Notified By is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Notified By' is not disabled after admittance as expected")
	Execute "Set objNotifiedByDD = Nothing"
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - 'Adimit Type' drop down status after admittance (should be disabled)
'	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Admit Type dropdown
'	If not objAdmitTypeDD.Object.isDisabled Then
'		Call WriteToLog("Fail","Adimit Type is not disabled after admittance")
'	End If
'	Call WriteToLog("Pass","'Adimit Type' is disabled after admittance as expected")
'	Execute "Set objAdmitTypeDD = Nothing"
'	wait 0,100

	'Validation - 'Adimit Type' drop down status after admittance (should be disabled)
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
'	objAdmitTypeDD.highlight
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objAdmitTypeDD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If not objAdmitTypeDD.Object.isDisabled Then
		Call WriteToLog("Fail","Adimit Type is not disabled after admittance")
	End If
	Call WriteToLog("Pass","'Adimit Type' is disabled after admittance as expected")
	Execute "Set objAdmitTypeDD = Nothing"
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - 'Source of Admit' drop down status after admittance (should be enabled)
'	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
'	If objSourceOfAdmitDD.Object.isDisabled Then
'		Call WriteToLog("Fail","Source of Admit is disabled after admittance")
'	End If
'	Call WriteToLog("Pass","'Source of Admit' is not disabled after admittance as expected")
'	Execute "Set objSourceOfAdmitDD = Nothing"
'	wait 0,100

	'Validation - 'Source of Admit' drop down status after admittance (should be enabled)
	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
'	objSourceOfAdmitDD.highlight
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objSourceOfAdmitDD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If objSourceOfAdmitDD.Object.isDisabled Then
		Call WriteToLog("Fail","Source of Admit is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Source of Admit' is not disabled after admittance as expected")
	Execute "Set objSourceOfAdmitDD = Nothing"
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,100

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Location Prior to Hospital Admit' drop down status after admittance (should be enabled)
'	Execute "Set objPageAdmitPatient = Nothing"
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_LocPriorToHospVisit_DD = objPageAdmitPatient.WebButton("class:=btn btn-default dropdown-toggle dropdowndefault","html tag:=BUTTON","type:=button","visible:=True","index:=4") 'LocationPriorToHospitalVisit
	
	Execute "Set objAdmit_LocPriorToHospVisit_DD = " & Environment("WEL_LocPriorHospVisit")
	objAdmit_LocPriorToHospVisit_DD.highlight
	If objAdmit_LocPriorToHospVisit_DD.Object.isDisabled Then
		Call WriteToLog("Fail","Location Prior to Hospital Admit is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Location Prior to Hospital Admit' is not disabled after admittance as expected")
	Execute "Set objPageAdmitPatient = Nothing"
	Set objAdmit_LocPriorToHospVisit_DD = Nothing
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Primary Diagnosis' drop down status after admittance (should be enabled)
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_PrimaryDiagnosis_DD = objPageAdmitPatient.WebButton("class:=btn btn-default dropdown-toggle dropdowndefault","html tag:=BUTTON","type:=button","visible:=True","index:=5") 'PrimaryDiagnosis

'	Execute "Set objAdmit_PrimaryDiagnosis_DD = " & Environment("WEL_PrimaryDiagnosis")
'	If objAdmit_PrimaryDiagnosis_DD.Object.isDisabled Then
'		Call WriteToLog("Fail","Primary Diagnosis is disabled after admittance")
'	End If
'	Call WriteToLog("Pass","'Primary Diagnosis' is not disabled after admittance as expected")
'	Execute "Set objPageAdmitPatient = Nothing"
'	Set objAdmit_PrimaryDiagnosis_DD = Nothing
'	wait 0,100

	Execute "Set objAdmit_PrimaryDiagnosis_DD = " & Environment("WEL_PrimaryDiagnosis")
'	objAdmit_PrimaryDiagnosis_DD.highlight
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objAdmit_PrimaryDiagnosis_DD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If objAdmit_PrimaryDiagnosis_DD.Object.isDisabled Then
		Call WriteToLog("Fail","Primary Diagnosis is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Primary Diagnosis' is not disabled after admittance as expected")
	Set objAdmit_PrimaryDiagnosis_DD = Nothing
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Related Subcategory' drop down status after admittance (should be enabled)
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_RelatedSubCategory_DD = objPageAdmitPatient.WebButton("class:=btn btn-default dropdown-toggle dropdowndefault","html tag:=BUTTON","type:=button","visible:=True","index:=6") 'RelatedSubCategory

'	Execute "Set objAdmit_RelatedSubCategory_DD = " & Environment("WEL_RelatedSubCategory")
'	If objAdmit_RelatedSubCategory_DD.Object.isDisabled Then
'		Call WriteToLog("Fail","Related Subcategory is disabled after admittance")
'	End If
'	Call WriteToLog("Pass","'Related Subcategory' is not disabled after admittance as expected")
'	Execute "Set objPageAdmitPatient = Nothing"
'	Set objAdmit_RelatedSubCategory_DD = Nothing
'	wait 0,100

	Execute "Set objAdmit_RelatedSubCategory_DD = " & Environment("WEL_RelatedSubCategory")
	objAdmit_RelatedSubCategory_DD.highlight
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objAdmit_RelatedSubCategory_DD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If objAdmit_RelatedSubCategory_DD.Object.isDisabled Then
		Call WriteToLog("Fail","Related Subcategory is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Related Subcategory' is not disabled after admittance as expected")
	Set objAdmit_RelatedSubCategory_DD = Nothing
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Readmit Reason' drop down status after admittance (should be enabled)
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_Reason_DD = objPageAdmitPatient.WebButton("html tag:=BUTTON","outerhtml:=.*HospitalizationModel.*","type:=button","visible:=True","index:=4") 'Reason

'	Execute "Set objAdmit_Reason_DD = " & Environment("WEL_ReAdmitReason") 
'	If objAdmit_Reason_DD.Object.isDisabled Then
'		Call WriteToLog("Fail","Readmit Reason is disabled after admittance")
'	End If
'	Call WriteToLog("Pass","'Readmit Reason' is not disabled after admittance as expected")
'	Set objAdmit_Reason_DD = Nothing
'	wait 0,100

	Execute "Set objAdmit_Reason_DD = " & Environment("WEL_ReAdmitReason") 
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objAdmit_Reason_DD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If objAdmit_Reason_DD.Object.isDisabled Then
		Call WriteToLog("Fail","Readmit Reason is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Readmit Reason' is not disabled after admittance as expected")
	Set objAdmit_Reason_DD = Nothing
	wait 0,100
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Admitting Diagnosis' edit box status after admittance (should be enabled)
	Err.Clear
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
	If objAdmittingDiagnosisTxt.Object.isDisabled Then
		Call WriteToLog("Fail","Admitting Diagnosis is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Admitting Diagnosis' is not disabled after admittance as expected")
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	wait 0,100	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Working Diagnosis' edit box status after admittance (should be enabled)
	Err.Clear
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
	If objWorkingDiagnosisTxt.Object.isDisabled Then
		Call WriteToLog("Fail","Working Diagnosis is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Working Diagnosis' is not disabled after admittance as expected")
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation -'Planned Admission' check box status after admittance (should be enabled)
	Execute "Set objPlannedAdmission = " & Environment("WE_PlannedAdmission") 'Planned Admission cb
	If objPlannedAdmission.Object.isDisabled Then
		Call WriteToLog("Fail","Planned Admission is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Planned Admission' is not disabled after admittance as expected")
	Execute "Set objPlannedAdmission = Nothing"
	Wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Verbal Contact' check box status after admittance (should be enabled)
'	Execute "Set objPageAdmitPatient = " & Environment("WPG_AppParent") 'Page object
'	Set objAdmit_VerbalContact_CB = objPageAdmitPatient.WebElement("class:=screening-check-box-no float-left   whitebg","html tag:=DIV","visible:=True","index:=1") 'verbal contact cb
	Execute "Set objAdmit_VerbalContact_CB = " & Environment("WEL_Admit_VerbalContact_CB") 
	If objAdmit_VerbalContact_CB.Object.isDisabled Then
		Call WriteToLog("Fail","Verbal Contact is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Verbal Contact' is not disabled after admittance as expected")
	Execute "Set objPageAdmitPatient = Nothing"
	Set objAdmit_VerbalContact_CB = Nothing
	Wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Avoidable Admission' check box status after admittance (should be enabled)
	Execute "Set objAvoidableAdmission_Unchecked = " & Environment("WE_AvoidableAdmission_Unchecked")
	Execute "Set objAvoidableAdmission_Checked = " & Environment("WE_AvoidableAdmission_Checked")
	Err.clear
	If objAvoidableAdmission_Unchecked.Exist(1) Then
		If objAvoidableAdmission_Unchecked.Object.isDisabled Then
			Call WriteToLog("Fail","AvoidableAdmission check box is disabled after admittance")
		End If
		Call WriteToLog("Pass","'Avoidable Admission' check box is not disabled after admittance as expected")
	ElseIf objAvoidableAdmission_Checked.Exist(1) Then
		If objAvoidableAdmission_Checked.Object.isDisabled Then
			Call WriteToLog("Fail","AvoidableAdmission check box is disabled after admittance")
		End If
		Call WriteToLog("Pass","'Avoidable Admission' check box is not disabled after admittance as expected")
	End If	
	Execute "Set objAvoidableAdmission_Unchecked = Nothing"
	Execute "Set objAvoidableAdmission_Unchecked = " & Environment("WE_AvoidableAdmission_Unchecked")
	
	Wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Avoidable Admission' comment field status after admittance (should be enabled)
	Execute "Set objAdmit_AvoidableAdmission_TB = "&Environment("WE_AvoidableAdmitComment")	
	If objAdmit_AvoidableAdmission_TB.Object.isDisabled Then
		Call WriteToLog("Fail","Avoidable Admission comment is disabled after admittance")
	End If
	Call WriteToLog("Pass","'Avoidable Admission' comment is not disabled after admittance as expected")
	Execute "Set objAdmit_AvoidableAdmission_TB = Nothing"
	Wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: HistoryTableValidation
'Purpose: Validate - Hospitalization History Table entries after admittance, discharge
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function HistoryTableValidation(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	HistoryTableValidation = False
	
	Call WriteToLog("Info","History Table Validation")
	
	'Clk on Hospitalization History table expand arrow image
	Execute "Set objHospHistoryArrow = " & Environment("WI_HospHistoryArrow")
	If objHospHistoryArrow.Exist(1) Then	
		Err.Clear
		objHospHistoryArrow.Click
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to click Hospitalization History up arrow "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked Hospitalization History up arrow")
	End If
	Execute "Set objHospHistoryArrow = Nothing"
	Wait 2
	
	'Admit date, AdmitNotification date, Discharge date, from history table
	Execute "Set objHosHistoryTable = " & Environment("WT_HosHistoryTable")
	
	dtAdmitDate_HT = DateFormat(CDate(Trim(objHosHistoryTable.GetCellData(1,1))))
	dtDischargeDate_HT = DateFormat(CDate(Trim(objHosHistoryTable.GetCellData(1,2))))
	strFacilityName_HT = Trim(objHosHistoryTable.GetCellData(1,3))
	strAdmittingDiagnosis_HT = Trim(objHosHistoryTable.GetCellData(1,4))
	strWorkingDiagnosis_HT = Trim(objHosHistoryTable.GetCellData(1,5))
	
	Execute "Set objHosHistoryTable = Nothing"
	
	'Admit, AdmitNitification, Discharge dates from respective screen sections
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	Execute "Set objDischargeDateFieldVal = " & Environment("WE_DischargeDateTxt") 
	Execute "Set objFacilityName = " & Environment("WE_FacilityName")
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt")
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt")
	
	dtAdmitDate_SN = Trim(objAdmitDateFieldVal.GetROProperty("value"))
	dtDischargeDate_SN = Trim(objDischargeDateFieldVal.GetROProperty("value"))
	strFacilityName_SN = Trim(objFacilityName.GetROProperty("value"))
	strAdmittingDiagnosis_SN = Trim(objAdmittingDiagnosisTxt.GetROProperty("value"))
	strWorkingDiagnosis_SN = Trim(objWorkingDiagnosisTxt.GetROProperty("value"))
	
	Execute "Set objAdmitDateFieldVal = Nothing"
	Execute "Set objFacilityName = Nothing"
	Execute "Set objDischargeDateFieldVal = Nothing"
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Historty table populated with AdmitDate after admission
	If Instr(1,dtAdmitDate_HT,dtAdmitDate_SN,1) Then 	
		Call WriteToLog("Pass","Hospitalization History table is populated with AdmitDate after admission")	
	Else
		Call WriteToLog("Fail","Hospitalization History table is not populated/populated with wrong AdmitDate")	
	End If
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Historty table DischargeDate entry before/after discharge
	If dtDischargeDate_HT = Empty Then
		dtDischargeDate_HT = ""
		If dtDischargeDate_HT = dtDischargeDate_SN Then 	
			Call WriteToLog("Pass","Hospitalization History table is not populated with DischargeDate as discharge is not done")	
		Else
			Call WriteToLog("Fail","Hospitalization History table is populated with wrong DischargeDate")	
		End If
	Else
		If dtDischargeDate_HT = dtDischargeDate_SN Then 	
			Call WriteToLog("Pass","Hospitalization History table is populated with DischargeDate after discharge")	
		Else
			Call WriteToLog("Fail","Hospitalization History table is not populated/populated with wrong with DischargeDate")	
		End If
	End If

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Historty table populated with FacilityName after admission
	If strFacilityName_HT = Empty Then
		strFacilityName_HT = ""
		If strFacilityName_HT = strFacilityName_SN Then 	
			Call WriteToLog("Pass","Hospitalization History table is not populated with FacilityName as it is not provoded during admission")	
		Else
			Call WriteToLog("Fail","Hospitalization History table is populated with wrong FacilityName")	
		End If
	Else
		If strFacilityName_HT = strFacilityName_SN Then 	
			Call WriteToLog("Pass","Hospitalization History table is populated with FacilityName after admission")	
		Else
			Call WriteToLog("Fail","Hospitalization History table is not populated/populated with wrong FacilityName")	
		End If
	End If
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Historty table populated with AdmittingDiagnosis after admission
	If Instr(1,strAdmittingDiagnosis_HT,strAdmittingDiagnosis_SN,1) Then 	
		Call WriteToLog("Pass","Hospitalization History table is populated with AdmittingDiagnosis after admission")	
	Else
		Call WriteToLog("Fail","Hospitalization History table is not populated/populated with wrong AdmittingDiagnosis")	
	End If
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Historty table populated with WorkingDiagnosis after admission
	If Instr(1,strWorkingDiagnosis_HT,strWorkingDiagnosis_SN,1) Then 	
		Call WriteToLog("Pass","Hospitalization History table is populated with WorkingDiagnosis after admission")	
	Else
		Call WriteToLog("Fail","Hospitalization History table is not populated/populated with wrong WorkingDiagnosis")	
	End If
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'Close history table
	Execute "Set objHospHistoryDownArrow = " & Environment("WI_HospHistoryDownArrow") 
	If objHospHistoryDownArrow.Exist(1) Then
		Err.Clear
		objHospHistoryDownArrow.Click
		If Err.number <> 0 Then
			Call WriteToLog("Fail","Unable to click Hospitalization History down arrow "&Err.Description)
		End If
		Call WriteToLog("Pass","Clicked Hospitalization History down arrow")
		Wait 1
	End If
	Execute "Set objHospHistoryDownArrow = Nothing"
		
	HistoryTableValidation= True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: TranferScenariosPreliminary
'Purpose: Validate - Transer by providing TransferDate < 366 days to sys date, TransferDate > sys date, TransferDate < Admit date, Transfer date less than sys date but not less than admit date. Also validate 'Transfer Facility name' and 'Transfer Facility phone' fields
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function TranferScenariosPreliminary(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TranferScenariosPreliminary = False
	
	Call WriteToLog("Info","Tranfer Scenarios Preliminary")
	
	strTransferFacilityName = "Facility Name"
	lngTransferFacilityPhone = 1233211230

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save transfer providing TransferDate < 366 days to sys date - validate error msg box
	dtTransferDate = DateAdd("d",-370,Date)
	Execute "Set objTrasferDate = "&Environment("WE_TransferDateTxBx")
	Err.Clear
	objTrasferDate.Set dtTransferDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set dtTransferDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Transfer Date")
	End If
	Execute "Set objTransferCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnTransferDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'TransferDate' cannot be older than 366 days from today's date and cannot be greater than today's date", strOutErrorDesc)
	If not blnTransferDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save Transfer providing TransferDate older than 366 days from sys date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save Transfer providing TransferDate older than 366 days from sys date")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save transfer providing TransferDate > sys date - validate error msg box
	dtTransferDate = DateAdd("d",2,Date)
	Execute "Set objTrasferDate = "&Environment("WE_TransferDateTxBx")
	Err.Clear
	objTrasferDate.Set dtTransferDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set dtTransferDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Transfer Date")
	End If
	Execute "Set objTransferCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnTransferDateScenarioPP = checkForPopup("Invalid Data", "Ok", "Field 'TransferDate' of 'ptDischargePlan' entity cannot be set to a future date", strOutErrorDesc)
	If not blnTransferDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save Transfer providing TransferDate greater than sys date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save Transfer providing TransferDate greater than sys date")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save transfer providing TransferDate < Admit date - validate error msg box
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtTransferDate = DateAdd("d",-2,dtAdmitDateUI)
	Execute "Set objTrasferDate = "&Environment("WE_TransferDateTxBx")
	Err.Clear
	objTrasferDate.Set dtTransferDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set dtTransferDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Transfer Date")
	End If
	Execute "Set objAdmitDateFieldVal = Nothing"
	Execute "Set objTransferCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnTransferDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'TransferDate' can not be lesser than 'AdmitDate'", strOutErrorDesc)
	If not blnTransferDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save Transfer providing TransferDate less than Admit date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save Transfer providing TransferDate less than Admit date")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Transfer Facility name' edit box availability and setting required value
	Execute "Set objTransferFacilityName = " & Environment("WE_TransferFacilityName")
	Err.Clear
	objTransferFacilityName.Set strTransferFacilityName
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to set Transfer facility name. "&Err.Description)
	End If
	Call WriteToLog("Pass","Transfer facility name field is available and facility name is set")
	Execute "Set objTransferFacilityName = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Transfer Facility phone' edit box availability and setting required value
	Execute "Set objTransferFacilityPhone = " & Environment("WE_TransferFacilityPhone")
	Err.Clear
	objTransferFacilityPhone.Set lngTransferFacilityPhone
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to set Transfer facility phone. "&Err.Description)
	End If
	Call WriteToLog("Pass","Transfer facility phone field is available and facility phone is set")
	Execute "Set objTransferFacilityPhone = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save and validate message box for Transfer	
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtTransferDate = dtAdmitDateUI
	Execute "Set objTrasferDate = "&Environment("WE_TransferDateTxBx")
	Err.Clear
	objTrasferDate.Set dtTransferDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set dtTransferDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Transfer Date")
	End If
	Execute "Set objAdmitDateFieldVal = Nothing"
	Execute "Set objTransferCalendarBtn = Nothing"
	Wait 0,250	
	
	'Save tranfer record
	blnSaveTransfer = SaveFunctionality("Transfer")
	If Not blnSaveTransfer Then
		strOutErrorDesc = "Transfer is not saved. "&strOutErrorDesc
		Exit Function
	End If
	Wait 1	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	TranferScenariosPreliminary = True	

End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: TransferFieldsStatusAfterTransfer
'Purpose: Validate - All transfer fileds after transfer
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function TransferFieldsStatusAfterTransfer(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	Call WriteToLog("Info","Transfer Fields Status After Transfer")
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - TransferDate field status after transfer (should be disabled)
	Execute "Set objTransferDateTxBx = " & Environment("WE_TransferDateTxBx")
	If not objTransferDateTxBx.Object.isDisabled Then
		Call WriteToLog("Fail","TransferDate field is not disabled after transfer")
	End If
	Call WriteToLog("Pass","'TransferDate' field is disabled after transfer as expected")
	Execute "Set objTransferDateTxBx = Nothing"
	Wait 0,100	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Transfer Facility Name' edit box status after transfer (should be enabled)
	Execute "Set objTransferFacilityName = " & Environment("WE_TransferFacilityName")
	If objTransferFacilityName.Object.isDisabled Then
		Call WriteToLog("Fail","Transfer Facility Name is disabled after transfer")
	End If
	Call WriteToLog("Pass","'Transfer Facility Name' is not disabled after transfer as expected")
	Execute "Set objTransferFacilityName = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Transfer Facility phone' edit box availability and setting required value
	Execute "Set objTransferFacilityPhone = " & Environment("WE_TransferFacilityPhone")
	If objTransferFacilityPhone.Object.isDisabled Then
		Call WriteToLog("Fail","Transfer Facility phone is disabled after transfer")
	End If
	Call WriteToLog("Pass","'Transfer Facility Phone' is not disabled after transfer as expected")
	Execute "Set objTransferFacilityPhone = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Discharge_AllFields
'Purpose: Validate - Availability of all Discharge section fields and data entry into all fields
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Discharge_AllFields(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	Discharge_AllFields = False
	
	Call WriteToLog("Info","Discharge with all fields")	
	
	strDisposition = "Home"
	strHomeHealthName = "HomeHealth"
	strHomeHealthReason = "Comorbid Management"
	strDischargeDiagnosis = "Discharge Diagnosis"
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Discharge Date' edit box availability and setting required date
	Err.Clear
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargeDate = dtAdmitDateUI
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then		
		strOutErrorDesc = "Unable to set Discharge Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Date field is available and Discharge date is set")
	End If
	Execute "Set objAdmitDateFieldVal = Nothing"
	Execute "Set objDischargeCalendarBtn = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Discharge Notification Date' edit box availability and setting required date
	Err.Clear
	dtDischargeNotificationDate = dtDischargeDate
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear 
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Discharge Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Notification Date field is available and Discharge Notification date is set")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Discharge Plan Date' edit box availability and setting required date
	Err.Clear
	dtDischargePlanDate = dtDischargeDate
	Execute "Set objDischargePlanDate = "&Environment("WE_PlanDateTxBx")
	Err.Clear
	objDischargePlanDate.Set dtDischargePlanDate
	If Err.Number <> 0  Then
		strOutErrorDesc = "Unable to set Discharge Plan Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Plan Date field is available and Discharge Plan date is set")
	End If
	Execute "Set objPlanDateCalendarBtn = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Patient Refused Plan' radio buttons availability and selecting required value
	Execute "Set objPlanRefusedRadio_No = " & Environment("WEL_PlanRefusedRadio_No")
	Execute "Set objPlanRefusedRadio_Yes = " & Environment("WEL_PlanRefusedRadio_Yes")
	If objPlanRefusedRadio_No.Exist(1) AND objPlanRefusedRadio_Yes.Exist(1) Then
		Call WriteToLog("Pass","Both yes,no 'Patient Refused Plan' radio buttons are available")
	Else
		Call WriteToLog("Fail","Both yes,no 'Patient Refused Plan' radio buttons are not available")
	End If
		
	Err.Clear
	Execute "Set objPlanRefusedRadio_No = Nothing"
	Execute "Set objPlanRefusedRadio_No = " & Environment("WEL_PlanRefusedRadio_No")
	objPlanRefusedRadio_No.Click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to select required 'Patient Refused Plan' radio button. "&Err.Description)
	End If
	Call WriteToLog("Pass","Selected required 'Patient Refused Plan' radio button")
	Execute "Set objPlanRefusedRadio_No = Nothing"
	Execute "Set objPlanRefusedRadio_Yes = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Disposition' drop down availability and selection of required value
	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
	objDispositionDD.highlight
	blnDisposition = selectComboBoxItem(objDispositionDD, strDisposition)
	If Not blnDisposition Then
		strOutErrorDesc = "Unable to select required 'Disposition'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Disposition' drop down is available and selected required 'Disposition' value")
	Execute "Set objDispositionDD = Nothing"
	wait 0,500
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Home Health Name' edit box availability and setting required value
	Execute "Set objHomeHealthName = " & Environment("WE_HomeHealthName")
	Err.Clear
	objHomeHealthName.Set strHomeHealthName 
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to set 'Home Health Name'. "&Err.Description)
	End If
	Call WriteToLog("Pass","'Home Health Name' field is available and 'Home Health Name' is set")
	Execute "Set objHomeHealthName = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Home Health Reason' drop down availability and selection of required value
'	Execute "Set objPage_H_D = " & Environment("WPG_AppParent") 'Page object
'	Set objHomeHealthReason = objPage_H_D.WebButton("html tag:=BUTTON","type:=button","outerhtml:=.*pull-left dropdowname.*","visible:=True","index:=6")
	Execute "Set objHomeHealthReason = " & Environment("WEL_HomeHealthReason")
	objHomeHealthReason.highlight
	blnHomeHealthReason = selectComboBoxItem(objHomeHealthReason, strHomeHealthReason)
	If Not blnHomeHealthReason Then
		Call WriteToLog("Fail","Unable to select required 'Home Health Reason'. "&strOutErrorDesc)
	End If
	Call WriteToLog("Pass","'Home Health Reason' drop down is available and selected required 'Home Health Reason' value")
	Execute "Set objPage_H_D = Nothing"
	Set objHomeHealthReason = Nothing
	wait 0,500
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Medical Equipment' radio buttons availability and selecting required value
	Execute "Set objMedicalEquipment_Yes = " & Environment("WEL_MedicalEquipment_Yes")
	Execute "Set objMedicalEquipment_No = " & Environment("WEL_MedicalEquipment_No")
	If objMedicalEquipment_Yes.Exist(1) AND objMedicalEquipment_No.Exist(1) Then
		Call WriteToLog("Pass","Both yes,no 'Medical Equipment' radio buttons are available")
	Else
		Call WriteToLog("Fail","Both yes,no 'Medical Equipment' radio buttons are not available")
	End If
		
	Err.Clear
	Execute "Set objMedicalEquipment_No = Nothing"
	Execute "Set objMedicalEquipment_No = " & Environment("WEL_MedicalEquipment_No")
	objMedicalEquipment_No.Click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to select required 'Medical Equipment' radio button. "&Err.Description)
	End If
	Call WriteToLog("Pass","Selected required 'Medical Equipment' radio button")
	Execute "Set objMedicalEquipment_Yes = Nothing"
	Execute "Set objMedicalEquipment_No = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Discharge Diagnosis' edit box availability and setting required value
	Execute "Set objDischargeDiagnosis = " & Environment("WE_DischargeDiagnosis")
	Err.Clear
	objDischargeDiagnosis.Set strDischargeDiagnosis 
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to set 'Discharge Diagnosis'. "&Err.Description)
	End If
	Call WriteToLog("Pass","'Discharge Diagnosis' field is available and 'Discharge Diagnosis' is set")
	Execute "Set objDischargeDiagnosis = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Save' button availability and status
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	If not objSaveBtn.Exist(1) OR objSaveBtn.Object.isDisabled Then
		strOutErrorDesc = "'Save' button for hospitalization is disabled/not existing after entering admittance fileds"& strOutErrorDesc
		Exit Function	
	End If
	Call WriteToLog("Pass","'Save' button for hospitalization is available and is enabled after entering admittance fileds")
	Execute "Set objSaveBtn = Nothing"
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	Discharge_AllFields = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: DischargeDateScenariosPreliminary
'Purpose: Validate - Discharge without DischargeDate, DischargeDate > sys date, DischargeDate < 366 days to sys date, DischargeDate < AdmitDate, DischargeDate >= AdmitDate, but <= sys date
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function DischargeDateScenariosPreliminary(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	DischargeDateScenariosPreliminary = False
	
	Call WriteToLog("Info","Discharge Date Scenarios Preliminary")	
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge without providing DischargeDate - validate error msg box
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set ""
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to clear DischargeDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Cleared Discharge Date")
	End If
	Execute "Set objDischargeCalendarBtn = Nothing"
	Wait 0,250
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnDischargeDateScenarioPP = checkForPopup("Invalid Data", "Ok", "Discharge Date is required. Please Select a valid value", strOutErrorDesc)
	If not blnDischargeDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save discharge without providing DischargeDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save discharge without providing DischargeDate")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge providing DischargeDate > sys date - validate error msg box
	dtDischargeDate = DateAdd("d",5,Date)
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set DischargeDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Discharge Date")
	End If
	Execute "Set objDischargeCalendarBtn = Nothing"
	
	'Clk Save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnDischargeDateScenarioPP = checkForPopup("Invalid Data", "Ok", "Field 'DischargeDate' of 'ptDischargePlan' entity cannot be set to a future date", strOutErrorDesc)
	If not blnDischargeDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing AdmitDate greater than sys date "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing AdmitDate greater than sys date")
	End If
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge providing DischargeDate < 366 days to sys date - validate error msg box
	dtDischargeDate = DateAdd("d",-370,Date)
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set DischargeDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Discharge Date")
	End If
	Execute "Set objDischargeCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnDischargeDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'DischargeDate' cannot be older than 366 days from today's date and cannot be greater than today's date", strOutErrorDesc)
	If not blnDischargeDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing DischargeDate older than 366 days from sys date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing DischargeDate older than 366 days from sys date")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save discharge providing DischargeDate < AdmitDate - validate error msg box
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargeDate = DateAdd("d",-2,dtAdmitDateUI)
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set DischargeDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Discharge Date")
	End If
	Execute "Set objDischargeCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'validate err msg box
	blnDischargeDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'DischargeDate' can not be earlier than 'AdmitDate'", strOutErrorDesc)
	If not blnDischargeDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save discharge providing Discharge date less than Admit date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save discharge providing Discharge date less than Admit date")
	End If
	Wait 1	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Provide DischargeDate >= AdmitDate, but <= sys date
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargeDate = dtAdmitDateUI
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set DischargeDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Discharge Date")
	End If
	Execute "Set objDischargeCalendarBtn = Nothing"
	Wait 0,250	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	DischargeDateScenariosPreliminary = True	
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: DischargeNotificationDateScenariosPreliminary
'Purpose: Validate - Discharge without DischargeNotificationDate, DischargeNotificationDate > sys date, DischargeNotificationDate < AdmitDate, DischargeNotificationDate < DischargeDate, Discharge Notification date greater than Discharge date, but <= sys date
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function DischargeNotificationDateScenariosPreliminary(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	DischargeNotificationDateScenariosPreliminary = False
	
	Call WriteToLog("Info","Discharge Notification Date Scenarios Preliminary")	
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge without providing DischargeNotificationDate - validate error msg box
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear
	objDischargeNotificationDate.Set ""
	If Err.Number <> 0 Then		
		strOutErrorDesc = "Unable to clear DischargeNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Cleared Discharge Notification date")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	Wait 0,250
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnDischargeDateNotificationScenarioPP = checkForPopup("Invalid Data", "Ok", "Discharge Notification Date is required. Please Select a valid value", strOutErrorDesc)
	If not blnDischargeDateNotificationScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save discharge without providing DischargeNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save discharge without providing DischargeNotificationDate")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge providing DischargeNotificationDate > sys date - validate error msg box
	dtDischargeNotificationDate = DateAdd("d",5,Date)
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then		
		strOutErrorDesc = "Unable to set DischargeNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Discharge Notification Date")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	
	'Clk Save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnDischargeDateNotificationScenarioPP = checkForPopup("Invalid Data", "Ok", "Field 'DischargeNotificationDate' of 'ptDischargePlan' entity cannot be set to a future date", strOutErrorDesc)
	If not blnDischargeDateNotificationScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save admission providing DischargeNotificationDate greater than sys date "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admission providing DischargeNotificationDate greater than sys date")
	End If
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save discharge providing DischargeNotificationDate < AdmitDate - validate error msg box
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargeNotificationDate = DateAdd("d",-2,dtAdmitDateUI)
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then		
		strOutErrorDesc = "Unable to set DischargeNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set DischargeNotification date")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'validate err msg box
	blnDischargeDateNotificationScenarioPP = checkForPopup("Invalid Data", "Ok", "'DischargeNotificationDate' can not be lesser than 'AdmitDate'", strOutErrorDesc)
	If not blnDischargeDateNotificationScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save discharge providing Discharge Notification date less than Admit date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save discharge providingDischarge Notification date less than Admit date")
	End If
	Wait 1	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge providing Discharge Notification date less than Discharge date - validate error msg box
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargeDate = dtAdmitDateUI
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set DischargeDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Discharge Date")
	End If
	Execute "Set objDischargeCalendarBtn = Nothing"
	Wait 0,250	
	
	dtDischargeNotificationDate = DateAdd("d",-2,dtDischargeDate)
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then		
		strOutErrorDesc = "Unable to set DischargeNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set DischargeNotification date")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	Wait 0,250
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'validate err msg box
	blnDischargeDateNotificationScenarioPP = checkForPopup("Invalid Data", "Ok", "The discharge notification date cannot be earlier than the discharge date", strOutErrorDesc)
	If not blnDischargeDateNotificationScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save discharge providing Discharge Notification date less than Discharge date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save discharge providingDischarge Notification date less than Discharge date")
	End If
	Wait 1	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Provide Discharge Notification date greater than Discharge date, but <= sys date
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargeDate = dtAdmitDateUI
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set DischargeDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Discharge Date")
	End If
	Execute "Set objDischargeCalendarBtn = Nothing"
	Wait 0,250	
	
	dtDischargeNotificationDate = DateAdd("d",1,dtDischargeDate)
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then		
		strOutErrorDesc = "Unable to set DischargeNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set DischargeNotification date")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	Wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	DischargeNotificationDateScenariosPreliminary = True	
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: DischargePlanDateScenariosPreliminary
'Purpose: Validate - Discharge with DischargePlan date > sys date, Discharge Plan date less than Admit date,  Discharge Plan date equal to Discharge Notification date, but <= sys date 
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function DischargePlanDateScenariosPreliminary(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	DischargePlanDateScenariosPreliminary = False
	
	Call WriteToLog("Info","Discharge Plan Date Scenarios Preliminary")	

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge providing DischargePlanDate > sys date - validate error msg box
	Err.Clear
	dtDischargePlanDate = DateAdd("d",2,Date)
	Execute "Set objDischargePlanDate = "&Environment("WE_PlanDateTxBx")
	Err.Clear
	objDischargePlanDate.Set dtDischargePlanDate
	If Err.Number <> 0 Then		
		strOutErrorDesc = "Unable to set Discharge Plan Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Plan date is set")
	End If
	Execute "Set objPlanDateCalendarBtn = Nothing"
	wait 0,250
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnDischargePlanDateScenarioPP = checkForPopup("Invalid Data", "Ok", "Field 'DischargePlanInitDate' of 'ptDischargePlan' entity cannot be set to a future date", strOutErrorDesc)
	If not blnDischargePlanDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save discharge providing DischargePlanDate > sys date "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save discharge providing DischargePlanDate > sys date")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge providing Discharge Plan date less than Admit date - validate error msg box
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargePlanDate = DateAdd("d",-2,dtAdmitDateUI)
	Execute "Set objDischargePlanDate = "&Environment("WE_PlanDateTxBx")
	Err.Clear 
	objDischargePlanDate.Set dtDischargePlanDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Discharge Plan Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Plan date is set")
	End If
	Execute "Set objPlanDateCalendarBtn = Nothing"
	wait 0,250
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnDischargePlanDateScenarioPP = checkForPopup("Invalid Data", "Ok", "'DischargePlanInitDate' can not be lesser than 'AdmitDate'", strOutErrorDesc)
	If not blnDischargePlanDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save discharge providing DischargePlanDate < AdmitDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save discharge providing DischargePlanDate < AdmitDate")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Provide Discharge Plan date equal to Discharge Notification date, but <= sys date	
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	dtAdmitDateUI = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargeNotificationDate = DateAdd("d",1,dtAdmitDateUI)
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear 
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set DischargeNotificationDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set DischargeNotification date")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	Wait 0,250
		
	dtDischargePlanDate = dtDischargeNotificationDate
	Execute "Set objDischargePlanDate = "&Environment("WE_PlanDateTxBx")
	Err.Clear
	objDischargePlanDate.Set dtDischargePlanDate
	If Err.Number <> 0 Then	
		strOutErrorDesc = "Unable to set Discharge Plan Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Plan date is set")
	End If
	Execute "Set objPlanDateCalendarBtn = Nothing"
	wait 0,250	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	DischargePlanDateScenariosPreliminary = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: OtherDischargeMandatoryScenarios
'Purpose: Validate - Discharge by setting 'Disposition' to invalid value and clearing all 'Related Diagnoses' check boxes
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function OtherDischargeMandatoryScenarios(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	OtherDischargeMandatoryScenarios = False
	
	strDispositionInvalid = "Select a value"
	strDisposition = "Home"
	
	Call WriteToLog("Info","Other DischargeMandatory Scenarios")	
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save discharge with invalid 'Disposition' drop down value
	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
	objDispositionDD.highlight
	blnDisposition = selectComboBoxItem(objDispositionDD, strDispositionInvalid)
	If Not blnDisposition Then
		strOutErrorDesc = "Unable to select required 'Disposition'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Disposition' drop down is available and selected required 'Disposition' value")
	Execute "Set objDispositionDD = Nothing"
	wait 0,500
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnDischargePlanDateScenarioPP = checkForPopup("Invalid Data", "Ok", "Disposition is required.Please Select a valid value", strOutErrorDesc)
	If not blnDischargePlanDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save discharge with invalid 'Disposition' value. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save discharge with invalid 'Disposition' value")
	End If	
	Wait 1
	
	'Provide valid value
	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
	objDispositionDD.highlight
	blnDisposition = selectComboBoxItem(objDispositionDD, strDisposition)
	If Not blnDisposition Then
		strOutErrorDesc = "Unable to select required 'Disposition'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Disposition' drop down is available and selected required 'Disposition' value")
	Execute "Set objDispositionDD = Nothing"
	wait 0,500	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - Save discharge without providing 'Related Diagnoses' - Err msg validation
'	'Clearing 'RelatedDiagnoses' check boxes	
'	For iRD_Checked = 0 To 50 Step 1
'		Execute "Set objPage_H_RD = " & Environment("WPG_AppParent")
'		Set objRD_Checked = objPage_H_RD.WebElement("class:=screening-check-box-yes.*","html tag:=DIV","outerhtml:=.*data-capella-automation-id=""Hospitalization Management_Review_Related_Diagnoses_Checked_"&iRD_Checked&".*","visible:=True")
'		If objRD_Checked.Exist(1/50) Then
'			Err.Clear
'			objRD_Checked.click
'			If Err.Number <> 0  Then
'				strOutErrorDesc = "Unable to clear Related Diagnosis check box"
'				Exit Function
'			End If
'		End If
'		Execute "Set objPage_H_RD = Nothing"
'		Set objRD_Checked = Nothing
'	Next
'	Call WriteToLog("Pass","Cleared RelatedDiagnoses check boxes")
'	Execute "Set objPage_H_RD = Nothing"
'	Set objRD_Checked = Nothing
	
	'Clk save btn
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 3
	Call waitTillLoads("Loading...")
	
	'Validate err msg box
	blnTransferDateScenarioPP = checkForPopup("Invalid Data", "Ok", "Atleast one Related Diagnosis is required", strOutErrorDesc)
	If not blnTransferDateScenarioPP Then
		strOutErrorDesc = "Messagebox is not available when tried to save Transfer without providing 'Related Diagnoses'. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save Transfer without providing 'Related Diagnoses'")
	End If	
	Wait 1
	
	'Check any Related diagnoses
	For iRD = 0 To 3 Step 1
		Execute "Set objPage_H_RD = "&Environment("WPG_AppParent")
'		Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("class:=screening-check-box-no.*","html id:=dig-selected-"&iRD,"html tag:=DIV","visible:=True")
		Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("html id:=Hospitalization_Review_DomainDeleted_"&iRD&"_Div","visible:=True")
		Err.Clear
		objRelatedDiagnosesCB.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to select checkbox for RelatedDiagnosis: "&" Error returned: " & Err.Description
			Exit Function
		End If	
		Execute "Set objPage_H_RD = Nothing"
		Set objRelatedDiagnosesCB = Nothing		
	Next
	Call WriteToLog("Pass","Checked RelatedDiagnoses check boxes")
	Execute "Set objPage_H_RD = Nothing"
	Set objRelatedDiagnosesCB = Nothing
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	OtherDischargeMandatoryScenarios = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: DischargeFieldsStatusAfterDischarge
'Purpose: Validate - All discharge fileds after discharge
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function DischargeFieldsStatusAfterDischarge(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	Call WriteToLog("Info","Discharge fields after discharge")		
		
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - DischargeDate field status after transfer (should be disabled)
	Execute "Set objDischargeDateTxBx = " & Environment("WE_DischargeDateTxt")
	If not objDischargeDateTxBx.Object.isDisabled Then
		Call WriteToLog("Fail","DischargeDate field is not disabled after discharge")
	End If
	Call WriteToLog("Pass","'DischargeDate' field is disabled after discharge")
	Execute "Set objDischargeDateTxBx = Nothing"
	Wait 0,100	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - DischargeNotificationDate field status after transfer (should be enabled)
	Execute "Set objDischargeNotificationDateTxBx = " & Environment("WE_DischargeNotificationDateTxt")
	If objDischargeNotificationDateTxBx.Object.isDisabled Then
		Call WriteToLog("Fail","DischargeNotificationDate field is disabled after discharge")
	End If
	Call WriteToLog("Pass","'DischargeNotificationDate' field is not disabled after discharge as expected")
	Execute "Set objDischargeNotificationDateTxBx = Nothing"
	Wait 0,100	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - DischargePlanDate field status after transfer (should be enabled)
	Execute "Set objDischargePlanDateTxBx = " & Environment("WE_PlanDateTxBx")
	If objDischargePlanDateTxBx.Object.isDisabled Then
		Call WriteToLog("Fail","DischargePlanDate field is disabled after discharge")
	End If
	Call WriteToLog("Pass","'DischargePlanDate' field is not disabled after discharge as expected")
	Execute "Set objDischargePlanDateTxBx = Nothing"
	Wait 0,100	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Patient Refused Plan' radio buttons status after discharge (should be enabled)
	Execute "Set objPlanRefusedRadio_No = " & Environment("WEL_PlanRefusedRadio_No")
	Execute "Set objPlanRefusedRadio_Yes = " & Environment("WEL_PlanRefusedRadio_Yes")
	If not objPlanRefusedRadio_No.Object.isDisabled AND not objPlanRefusedRadio_Yes.Object.isDisabled Then
		Call WriteToLog("Pass","Both yes,no 'Patient Refused Plan' radio buttons are not disabled after discharge as expected")
	Else
		Call WriteToLog("Fail","'Patient Refused Plan' radio buttons are disabled after discharge")
	End If
	Execute "Set objPlanRefusedRadio_No = Nothing"
	Execute "Set objPlanRefusedRadio_Yes =Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - 'Disposition' drop down status after discharge (should be enabled)
'	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
'	If objDispositionDD.Object.isDisabled Then
'		Call WriteToLog("Fail","Disposition drop down is disabled after discharge")
'	End If
'	Call WriteToLog("Pass","'Disposition' drop down is not disabled after discharge as expected")
'	Execute "Set objDispositionDD = Nothing"
'	Wait 0,100	

	'Validation - 'Disposition' drop down status after discharge (should be enabled)
	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
'	objDispositionDD.highlight
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objDispositionDD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If objDispositionDD.Object.isDisabled Then
		Call WriteToLog("Fail","Disposition drop down is disabled after discharge")
	End If
	Call WriteToLog("Pass","'Disposition' drop down is not disabled after discharge as expected")
	Execute "Set objDispositionDD = Nothing"
	Wait 0,100	
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Home Health Name' edit box availability and setting required value
	Execute "Set objHomeHealthName = " & Environment("WE_HomeHealthName")
	If objHomeHealthName.Object.isDisabled Then
		Call WriteToLog("Fail","Home Health Name is disabled after discharge")
	End If
	Call WriteToLog("Pass","'Home Health Name' is not disabled after discharge as expected")
	Execute "Set objHomeHealthName = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Home Health Reason' drop down status after discharge (should be enabled)
'	Execute "Set objPage_H_DA = " & Environment("WPG_AppParent") 'Page object
'	Set objDischargeSection = objPage_H_DA.WebElement("html tag:=DIV","innertext:=Discharge DatePatient Refused PlanNoYes   Disposition.*","visible:=True")
'	Set objHomeHealthReason = objDischargeSection.WebButton("html tag:=BUTTON","type:=button","outerhtml:=.*pull-left dropdowname.*","visible:=True","index:=1")

'	Execute "Set objHomeHealthReason = " & Environment("WEL_HomeHealthReason")
'	If objHomeHealthReason.Object.isDisabled Then
'		Call WriteToLog("Fail","Home Health Reason is disabled after discharge")
'	End If
'	Call WriteToLog("Pass","'Home Health Reason' is not disabled after discharge as expected")
'	Execute "Set objPage_H_DA = Nothing"
'	Set objDischargeSection = Nothing
'	Set objHomeHealthReason = Nothing	
'	wait 0,100

	Execute "Set objHomeHealthReason = " & Environment("WEL_HomeHealthReason")
	objHomeHealthReason.highlight
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objHomeHealthReason.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If objHomeHealthReason.Object.isDisabled Then
		Call WriteToLog("Fail","Home Health Reason is disabled after discharge")
	End If
	Call WriteToLog("Pass","'Home Health Reason' is not disabled after discharge as expected")
	Execute "Set objPage_H_DA = Nothing"
	Set objHomeHealthReason = Nothing	
	wait 0,100
	Set oDD_Desc = Nothing
	Set objDD_Btn = Nothing	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Medical Equipment' radio buttons status after discharge (should be enabled)
	Execute "Set objMedicalEquipment_Yes = " & Environment("WEL_MedicalEquipment_Yes")
	Execute "Set objMedicalEquipment_No = " & Environment("WEL_MedicalEquipment_No")
	If not objMedicalEquipment_Yes.Object.isDisabled AND not objMedicalEquipment_No.Object.isDisabled Then
		Call WriteToLog("Pass","Both yes,no 'Medical Equipment' radio buttons are not disabled after discharge")
	Else
		Call WriteToLog("Fail","Both yes,no 'Medical Equipment' radio buttons are disabled after discharge")
	End If
	Execute "Set objMedicalEquipment_Yes = Nothing"
	Execute "Set objMedicalEquipment_No = Nothing"
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'Discharge Diagnosis' edit box status after discharge (should be enabled)
	Execute "Set objDischargeDiagnosis = " & Environment("WE_DischargeDiagnosis")
	If objDischargeDiagnosis.Object.isDisabled Then
		Call WriteToLog("Fail","Discharge Diagnosis is disabled after discharge")
	End If
	Call WriteToLog("Pass","'Discharge Diagnosis' is not disabled after discharge as expected")
	Execute "Set objDischargeDiagnosis = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: OtherAdmitMandatoryScenarios
'Purpose: Validate - Length of stay after discharge
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function LengthofStayAfterDischarge(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	LengthofStayAfterDischarge = False
	
	Call WriteToLog("Info","Length of Stay After Discharge")	
	
	'get length of stay from sreen section
	Execute "Set objLengthOfStayValue = " & Environment("WEL_LengthOfStayValue") 
	objLengthOfStayValue.highlight
	strLengthOfSaty_AfterDischarge = objLengthOfStayValue.GetROProperty("outertext")
	
	For iLS = 1 To Len(strLengthOfSaty_AfterDischarge) Step 1
		LS = Mid(strLengthOfSaty_AfterDischarge,iLS,1) 
		If IsNumeric(LS) Then
			intLS = Trim(LS)
			Exit For
		End If
	Next
	
	'get admit and discharge dates provided previously and calculate required length of stay
	Execute "Set objAdmitDateFieldVal = " & Environment("WE_AdmitDateTxt")
	Execute "Set objDischargeDateFieldVal = " & Environment("WE_DischargeDateTxt")
	
	dtAdmitDate_SN = CDate(Trim(objAdmitDateFieldVal.GetROProperty("value")))
	dtDischargeDate_SN = CDate(Trim(objDischargeDateFieldVal.GetROProperty("value")))
	
	intLSRequired = DateDiff("d",dtAdmitDate_SN,dtDischargeDate_SN)+1
	
	'Validation - Length of stay after discharge
	If  StrComp(intLSRequired, LS, 1) = 0 Then
		Call WriteToLog("Pass","Value for Length of Stay is displayed as expected after discharge")
	Else
		Call WriteToLog("Fail","Value for Length of Stay is not displayed after discharge")
	End If
	
	Execute "Set objAdmitDateFieldVal = Nothing"
	Execute "Set objDischargeDateFieldVal = Nothing"
	Execute "Set objLengthOfStayValue = Nothing"
	
	LengthofStayAfterDischarge = True
		
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: AdmitDateScenariosWithType
'Purpose: Validate - Save admittance with admit date less than discharge date, Save admittance with same Admit Date and Admit Type
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function AdmitDateScenariosWithType(strOutErrorDesc)

	On Error Resume Next
	strOutErrorDesc = ""
	AdmitDateScenariosWithType = False
	Err.Clear

	Call WriteToLog("Info","Admit Date Scenarios With Type")
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save admittance with admit date less than discharge date - error message validation 
	
	strAdmitType = "Hospital Admit"
	strNotifiedBy = "Dialysis Center"
	strSourceOfAdmit = "Elective Admit"
	strAdmittingDiagnosisTxt = "Admitting Diagnostics text"
	strWorkingDiagnosisTxt = "Working Diagnostics text"
	
	'Click 'Add' button if enabled
	Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
	If not objAddBtn.Object.isDisabled Then
		Err.Clear
		blnAddClicked = ClickButton("Add",objAddBtn,strOutErrorDesc)
		If not blnAddClicked Then
			strOutErrorDesc = "Unable to click Add button for hospitalization "& strOutErrorDesc
			Exit Function	
		End If
	End If
	Execute "Set objAddBtn = Nothing"
	wait 5	
		
	dtLastAdmitDischargeDatesFromHistoryTable = LastAdmitDischargeDatesFromHistoryTable()
	dtLastDischarged = Trim(Split(dtLastAdmitDischargeDatesFromHistoryTable,",",-1,1)(1))
	dtAdmitDate_D = DateAdd("d",-1,dtLastDischarged)
	
	'Provide 'Admit Date'
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear 
	objAdmitDate.Set dtAdmitDate_D
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Date is set")
	End If
	wait 0,250
	
	'Provide 'Admit Notification Date'
	Err.Clear	
	dtNotificationDate = dtAdmitDate_D
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Notification Date is set")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	wait 0,250
	
	'Select 'Notified By'
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
	objNotifiedByDD.highlight
	blnNotification = selectComboBoxItem(objNotifiedByDD, strNotifiedBy)
	If Not blnNotification Then
		strOutErrorDesc = "Unable to select required 'NotifiedBy'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Notified By' is selected")
	Execute "Set objNotifiedByDD = Nothing"
	wait 0,500
	
	'Select 'Adimit Type'
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
	objAdmitTypeDD.highlight
	blnAdmitType = selectComboBoxItem(objAdmitTypeDD, strAdmitType)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to select required admit type. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Admit Type' is selected")
	Execute "Set objAdmitTypeDD = Nothing"
	wait 0,500
	
	'Select 'Source of Admit'
	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
	objSourceOfAdmitDD.highlight
	blnSourceOfAdmit = selectComboBoxItem(objSourceOfAdmitDD, strSourceOfAdmit)
	If Not blnSourceOfAdmit Then
		strOutErrorDesc = "SourceOfAdmit selection returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Source of Admit' is selected")
	Execute "Set objSourceOfAdmitDD = Nothing"
	wait 0,250	
	
	'Povide 'Admitting Diagnosis'
	Err.Clear
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
	objAdmittingDiagnosisTxt.Set strAdmittingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for AdmittingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Admitting Diagnosis' is set")
	End If
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	wait 0,500	
	
	'Provide 'Working Diagnosis'
	Err.Clear
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
	objWorkingDiagnosisTxt.Set strWorkingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for WorkingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Working Diagnosis' is set")
	End If
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	wait 0,500
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnAdmitDateScenarioPP_S = checkForPopup("Invalid Data", "Ok", "Admit Date should be greater than or equal to last discharge date", strOutErrorDesc)
	If not blnAdmitDateScenarioPP_S Then
		strOutErrorDesc = "Messagebox is not available when tried to save admittance with admit date less than discharge date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admittance with admit date less than discharge date")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	blnAdmitDateScenariosWithType2 = AdmitDateScenariosWithType2(strOutErrorDesc)
	If blnAdmitDateScenariosWithType2 Then
		AdmitDateScenariosWithType = True
		Exit Function
	Else
		Exit Function
	End If	
	
End Function

Function AdmitDateScenariosWithType2(strOutErrorDesc)

	On Error Resume Next
	strOutErrorDesc = ""
	AdmitDateScenariosWithType2 = False
	Err.Clear
	
	Execute "Set objHospHistoryArrow = " & Environment("WI_HospHistoryArrow")
	If objHospHistoryArrow.Exist(1) Then	
		objHospHistoryArrow.Click
	End If
	Execute "Set objHospHistoryArrow = Nothing"
	Wait 1
	
	strAdmitType = "Hospital Admit"
	strNotifiedBy = "Dialysis Center"
	strSourceOfAdmit = "Elective Admit"
	strAdmittingDiagnosisTxt = "Admitting Diagnostics text"
	strWorkingDiagnosisTxt = "Working Diagnostics text"
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save admittance with same Admit Date and Admit Type - error message validation 
	
	strAdmitType = "Hospital Admit"
	strNotifiedBy = "Dialysis Center"
	strSourceOfAdmit = "Elective Admit"
	strAdmittingDiagnosisTxt = "Admitting Diagnostics text"
	strWorkingDiagnosisTxt = "Working Diagnostics text"
	
	'Click 'Add' button if enabled
	Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
	If not objAddBtn.Object.isDisabled Then
		Err.Clear
		blnAddClicked = ClickButton("Add",objAddBtn,strOutErrorDesc)
		If not blnAddClicked Then
			strOutErrorDesc = "Unable to click Add button for hospitalization "& strOutErrorDesc
			Exit Function	
		End If
	End If
	Execute "Set objAddBtn = Nothing"
	wait 5	
	
	dtLastAdmitDischargeDatesFromHistoryTable = LastAdmitDischargeDatesFromHistoryTable()
	dtLastAdmitted = Trim(Split(dtLastAdmitDischargeDatesFromHistoryTable,",",-1,1)(0))
	dtAdmitDate_A = dtLastAdmitted
	
	'Provide 'Admit Date'
	Execute "Set objAdmitDate = "&Environment("WE_AdmitDateTxt")
	Err.Clear 
	objAdmitDate.Set dtAdmitDate_A
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Date is set")
	End If
	wait 0,250
	
	'Provide 'Admit Notification Date'
	dtNotificationDate = dtAdmitDate_A
	Err.Clear
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Notification Date is set")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	wait 0,250
	
	'Select 'Notified By'
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
	blnNotification = selectComboBoxItem(objNotifiedByDD, strNotifiedBy)
	If Not blnNotification Then
		strOutErrorDesc = "Unable to select required 'NotifiedBy'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Notified By' is selected")
	Execute "Set objNotifiedByDD = Nothing"
	wait 0,500
	
	'Select 'Adimit Type'
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
	objAdmitTypeDD.highlight
	blnAdmitType = selectComboBoxItem(objAdmitTypeDD, strAdmitType)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to select required admit type. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Admit Type' is selected")
	Execute "Set objAdmitTypeDD = Nothing"
	wait 0,500
	
	'Select 'Source of Admit'
	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
	objSourceOfAdmitDD.highlight
	blnSourceOfAdmit = selectComboBoxItem(objSourceOfAdmitDD, strSourceOfAdmit)
	If Not blnSourceOfAdmit Then
		strOutErrorDesc = "SourceOfAdmit selection returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Source of Admit' is selected")
	Execute "Set objSourceOfAdmitDD = Nothing"
	wait 0,250	
	
	'Povide 'Admitting Diagnosis'
	Err.Clear
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
	objAdmittingDiagnosisTxt.Set strAdmittingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for AdmittingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Admitting Diagnosis' is set")
	End If
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	wait 0,500	
	
	'Provide 'Working Diagnosis'
	Err.Clear
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
	objWorkingDiagnosisTxt.Set strWorkingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for WorkingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Working Diagnosis' is set")
	End If
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	wait 0,500
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnAdmitDateScenarioPP_S = checkForPopup("Invalid Data", "Ok", "A hospitalization record already exists for this member with the same Admit Date and Admit Type", strOutErrorDesc)
	If not blnAdmitDateScenarioPP_S Then
		strOutErrorDesc = "Messagebox is not available when tried to save admittance with same admit type and admit date. "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save admittance with same admit type and admit date")
	End If	
	Wait 1
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	AdmitDateScenariosWithType2 = True
	
	
End Function


'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: LastAdmitDischargeDatesFromHistoryTable
'Purpose: Validate - Last Admit and Discharge dates from HistoryTable
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function LastAdmitDischargeDatesFromHistoryTable()

	On Error Resume Next
	strOutErrorDesc = ""
	LastAdmitDischargeDatesFromHistoryTable = ""
	Err.Clear
	
	'Clk on Hospitalization History table expand arrow image if available	
	Execute "Set objHospHistoryDownArrow = " & Environment("WI_HospHistoryDownArrow") 	
	If not objHospHistoryDownArrow.Exist(2) Then
		Execute "Set objHospHistoryArrow = " & Environment("WI_HospHistoryArrow")
		Err.Clear
		objHospHistoryArrow.Click
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to click Hospitalization History up arrow "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked Hospitalization History up arrow")	
		Wait 2
	End If
	Execute "Set objHospHistoryDownArrow = Nothing"	
	
	'Get row count of history table
	Execute "Set objHosHistoryTable = " & Environment("WT_HosHistoryTable")		
	intHT_RC = objHosHistoryTable.RowCount	
		
	'Sort admit dates from history table in descending order
	For iHT_RC = 1 To intHT_RC Step 1	
		ReDim Preserve arrAdmitDates(intHT_RC)
		arrAdmitDates(iHT_RC-1) = DateValue(Trim(objHosHistoryTable.GetCellData(iHT_RC,1)))		
		For HT_ad = UBound(arrAdmitDates)-1 To 0 Step -1
		    For HT_adt= 0 to HT_ad
		        If arrAdmitDates(HT_adt)<arrAdmitDates(HT_adt+1) then
		            temp=arrAdmitDates(HT_adt+1)
		            arrAdmitDates(HT_adt+1)=arrAdmitDates(HT_adt)
		            arrAdmitDates(HT_adt)=temp
		        End If
		    Next
		Next 		
	Next
	
	Dim dtLastAdmitDateFromHistoryTable : dtLastAdmitDateFromHistoryTable = arrAdmitDates(0)
	
	dtLastDischargeDateFromHistoryTable = ""
	c = 0
	finite = 0
	
	Do Until (dtLastDischargeDateFromHistoryTable <> "" OR finite = 2)	
		dtLastDischargedAdmitDateFromHistoryTable = arrAdmitDates(c)
		Execute "Set objHosHistoryTable = Nothing"
		Execute "Set objHosHistoryTable = " & Environment("WT_HosHistoryTable")		
		intLastAdmitRow = objHosHistoryTable.GetRowWithCellText(dtLastDischargedAdmitDateFromHistoryTable)	
		dtLastDischargeDateFromHistoryTable = Trim(objHosHistoryTable.GetCellData(intLastAdmitRow,2))
		c = c+1
		finite = finite+1
	Loop	
	
	'Close history table
	Execute "Set objHospHistoryDownArrow = " & Environment("WI_HospHistoryDownArrow") 
	If objHospHistoryDownArrow.Exist(1) Then		
		Err.Clear
		objHospHistoryDownArrow.Click
		If Err.number <> 0 Then
			Call WriteToLog("Fail","Unable to click Hospitalization History down arrow "&Err.Description)
		End If
	End If
	Call WriteToLog("Pass","Clicked Hospitalization History down arrow")
	Wait 1
	
	LastAdmitDischargeDatesFromHistoryTable = dtLastAdmitDateFromHistoryTable&","&dtLastDischargeDateFromHistoryTable
	
	Execute "Set objHospHistoryArrow = Nothing"
	Execute "Set objHosHistoryTable = Nothing"
	Execute "Set objHospHistoryDownArrow = Nothing"
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Admittance_EDvisit
'Purpose: Validate - Save admittance with same Admit Date but with different Admit Type, 'NotifiedBy', 'Source of Admit', '(Readmit) Reason', 'Disposition' dropdown status, 'DischargeDateField' status,  'Patient Refused Plan', 'Medical Equipment' radio buttons status - during EDvist admittance, Save ED Visit' Admittance with 'HomeHealthName' and 'HomeHealthReason'
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Admittance_EDvisit(strOutErrorDesc)
		
	On Error Resume Next
	strOutErrorDesc = ""
	Admittance_EDvisit = False
	Err.Clear
	
	Call WriteToLog("Info","Admittance with ED Visit as Admit Type")
	
	strAdmitType = "ED Visit"
	strAdmittingDiagnosisTxt = "Admitting Diagnostics text"
	strWorkingDiagnosisTxt = "Working Diagnostics text"
	
	'Click 'Add' button if enabled
	Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
	If not objAddBtn.Object.isDisabled Then
		Err.Clear
		blnAddClicked = ClickButton("Add",objAddBtn,strOutErrorDesc)
		If not blnAddClicked Then
			strOutErrorDesc = "Unable to click Add button for hospitalization "& strOutErrorDesc
			Exit Function	
		End If
	End If
	Execute "Set objAddBtn = Nothing"
	wait 5	
		
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save admittance with same Admit Date but with different Admit Type (admit date = discharge date scenario is also covered as this admit date = last discharge date)
	
	dtLastAdmitDischargeDatesFromHistoryTable = LastAdmitDischargeDatesFromHistoryTable()
	dtLastAdmitted = Trim(Split(dtLastAdmitDischargeDatesFromHistoryTable,",",-1,1)(0))
	dtAdmitDate_ED = dtLastAdmitted
	
	'Provide 'Admit Date'
	Execute "Set objAdmitDate = "&Environment("dtAdmitDate_ED")
	Err.Clear 
	objAdmitDate.Set dtAdmitDate_ED
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Date is set")
	End If
	wait 0,250
	
	'Provide 'Admit Notification Date'
	Err.Clear	
	dtNotificationDate = dtAdmitDate_ED
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Notification Date is set")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	wait 0,250
	
	'Select 'Adimit Type'
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
	objAdmitTypeDD.highlight
	blnAdmitType = selectComboBoxItem(objAdmitTypeDD, strAdmitType)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to select required admit type. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Admit Type' is selected")
	Execute "Set objAdmitTypeDD = Nothing"
	wait 0,500
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - When 'AdmitType' is selected as 'ED Visit', 'NotifiedBy' dropdown is disabled	
'	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
'	If Not objNotifiedByDD.Object.isDisabled Then
'		Call WriteToLog("Fail", "When 'AdmitType' is selected as 'ED Visit', 'NotifiedBy' dropdown not is disabled")
'	End If
'	Call WriteToLog("Pass","When 'AdmitType' is selected as 'ED Visit', 'NotifiedBy' dropdown is disabled")
'	Execute "Set objNotifiedByDD = Nothing"
'	wait 0,250

	'Validation - When 'AdmitType' is selected as 'ED Visit', 'NotifiedBy' dropdown is disabled	
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objNotifiedByDD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If not objNotifiedByDD.Object.isDisabled Then
		Call WriteToLog("Fail", "When 'AdmitType' is selected as 'ED Visit', 'NotifiedBy' dropdown not is disabled")
	End If
	Call WriteToLog("Pass","When 'AdmitType' is selected as 'ED Visit', 'NotifiedBy' dropdown is disabled")
	Execute "Set objNotifiedByDD = Nothing"
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - 'Source of Admit' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'
'	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
'	If Not objSourceOfAdmitDD.Object.isDisabled Then
'		Call WriteToLog("Fail","'Source of Admit' dropdown is not disabled when 'AdmitType' is selected as 'ED Visit'")
'	End If
'	Call WriteToLog("Pass","'Source of Admit' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'")
'	Execute "Set objSourceOfAdmitDD = Nothing"
'	wait 0,250	

	'Validation - 'Source of Admit' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'
	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
'	objSourceOfAdmitDD.highlight
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objSourceOfAdmitDD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If not objSourceOfAdmitDD.Object.isDisabled Then
		Call WriteToLog("Fail","'Source of Admit' dropdown is not disabled when 'AdmitType' is selected as 'ED Visit'")
	End If
	Call WriteToLog("Pass","'Source of Admit' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'")
	Execute "Set objSourceOfAdmitDD = Nothing"
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,250	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - '(Readmit) Reason' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'
'	Execute "Set objPageAdmitPatient_ED = " & Environment("WPG_AppParent") 'Page object
'	Set objReadmitReason_ED = objPageAdmitPatient_ED.WebButton("html tag:=BUTTON","outerhtml:=.*HospitalizationModel.*","type:=button","visible:=True","index:=4") 
'	If Not objReadmitReason_ED.Object.isDisabled Then
'		Call WriteToLog("Fail","''(Readmit) Reason' dropdown is not disabled when 'AdmitType' is selected as 'ED Visit'")
'	End If
'	Call WriteToLog("Pass","'(Readmit) Reason' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'")
'	Execute "Set objSourceOfAdmitDD = Nothing"
'	wait 0,250	

	'Validation - '(Readmit) Reason' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'
	Execute "Set objAdmit_Reason_DD = " & Environment("WEL_ReAdmitReason") 
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objAdmit_Reason_DD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If not objAdmit_Reason_DD.Object.isDisabled Then
		Call WriteToLog("Fail","''(Readmit) Reason' dropdown is not disabled when 'AdmitType' is selected as 'ED Visit'")
	End If
	Call WriteToLog("Pass","'(Readmit) Reason' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'")
	Execute "Set objAdmit_Reason_DD = Nothing"
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,250	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'Povide 'Admitting Diagnosis'
	Err.Clear
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
	objAdmittingDiagnosisTxt.Set strAdmittingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for AdmittingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Admitting Diagnosis' is set")
	End If
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	wait 0,500	
	
	'Provide 'Working Diagnosis'
	Err.Clear
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
	objWorkingDiagnosisTxt.Set strWorkingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for WorkingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Working Diagnosis' is set")
	End If
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	wait 0,500
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - 'DischargeDateField' field is auto-populated with Admit date when 'AdmitType' is selected as 'ED Visit'
	Execute "Set objDischargeDateFieldVal = " & Environment("WE_DischargeDateTxt") 
	dtDischarge = Trim(objDischargeDateFieldVal.GetROProperty("value"))
	dtAdmitDate_ED_T = DateFormat(CDate(dtAdmitDate_ED))
	If Instr(1,dtDischarge,Trim(dtAdmitDate_ED_T),1) > 0 Then
		Call WriteToLog("Pass","'DischargeDateField' field is auto-populated with Admit date when 'AdmitType' is selected as 'ED Visit'")
	Else
		Call WriteToLog("Fail","'DischargeDateField' field is not auto-populated with Admit date when 'AdmitType' is selected as 'ED Visit'")
	End If 
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	Err.Clear
	dtDischargeNotificationDate = dtAdmitDate_ED
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear 
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Discharge Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Notification Date field is available and Discharge Notification date is set")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	wait 0,250
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - 'Patient Refused Plan' radio buttons are disabled when 'AdmitType' is selected as 'ED Visit'
'	Execute "Set objPlanRefusedRadio_No = " & Environment("WEL_PlanRefusedRadio_No")
'	Execute "Set objPlanRefusedRadio_Yes = " & Environment("WEL_PlanRefusedRadio_Yes")
'	If objPlanRefusedRadio_No.Object.isDisabled AND objPlanRefusedRadio_Yes.Object.isDisabled Then
'		Call WriteToLog("Pass","'Patient Refused Plan' radio buttons are disabled when 'AdmitType' is selected as 'ED Visit'")
'	Else
'		Call WriteToLog("Fail","'Patient Refused Plan' radio buttons are not disabled when 'AdmitType' is selected as 'ED Visit'")
'	End If
'	wait 0,100

	'Validation - 'Patient Refused Plan' radio buttons are disabled when 'AdmitType' is selected as 'ED Visit'
	Execute "Set objPatientRefusedPlan_Status = " & Environment("WE_PatientRefusedPlan_Status")
	strPatientRefusedPlan_Status = Lcase(objPatientRefusedPlan_Status.GetROProperty("class"))
	If Instr(1,strPatientRefusedPlan_Status,"disabled",1) Then
		Call WriteToLog("Pass","'Patient Refused Plan' radio buttons are disabled when 'AdmitType' is selected as 'ED Visit'")
	Else
		Call WriteToLog("Fail","'Patient Refused Plan' radio buttons are not disabled when 'AdmitType' is selected as 'ED Visit'")
	End If
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - 'Disposition' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'
'	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
'	If not objDispositionDD.Object.isDisabled Then
'		Call WriteToLog("Fail","'Disposition' dropdown is not disabled when 'AdmitType' is selected as 'ED Visit'")
'	End If
'	Call WriteToLog("Pass","'Disposition' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'")
'	wait 0,100

	'Validation - 'Disposition' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'
'	objDispositionDD.highlight
	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
'	Set oDD_Desc = Description.Create	
'	oDD_Desc("micclass").Value = "WebButton"
'	Set objDD_Btn = objDispositionDD.ChildObjects(oDD_Desc)
'	objDD_Btn(0).highlight
	If not objDispositionDD.Object.isDisabled Then
		Call WriteToLog("Fail","'Disposition' dropdown is not disabled when 'AdmitType' is selected as 'ED Visit'")
	End If
	Call WriteToLog("Pass","'Disposition' dropdown is disabled when 'AdmitType' is selected as 'ED Visit'")
	Execute "Set objDispositionDD = Nothing"
	Set oDD_Desc = Nothing
	Set objDD_Btn =Nothing
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validation - 'Medical Equipment' radio buttons are disabled when 'AdmitType' is selected as 'ED Visit'
'	Execute "Set objMedicalEquipment_Yes = " & Environment("WEL_MedicalEquipment_Yes")
'	Execute "Set objMedicalEquipment_No = " & Environment("WEL_MedicalEquipment_No")
'	If objMedicalEquipment_Yes.Object.isDisabled AND objMedicalEquipment_No.Object.isDisabled Then
'		Call WriteToLog("Pass","'Medical Equipment' radio buttons are disabled when 'AdmitType' is selected as 'ED Visit'")
'	Else
'		Call WriteToLog("Fail","'Medical Equipment' radio buttons are not disabled when 'AdmitType' is selected as 'ED Visit'")
'	End If
'	wait 0,100

	'Validation - 'Medical Equipment' radio buttons are disabled when 'AdmitType' is selected as 'ED Visit'
	Execute "Set objMedicalEquipment_Status = " & Environment("WE_MedicalEquipment_Status")
	strMedicalEquipment_Status = Lcase(objMedicalEquipment_Status.GetROProperty("class"))
	If Instr(1,strMedicalEquipment_Status,"disabled",1) Then
		Call WriteToLog("Pass","'Medical Equipment' radio buttons are disabled when 'AdmitType' is selected as 'ED Visit'")
	Else
		Call WriteToLog("Fail","'Medical Equipment' radio buttons are not disabled when 'AdmitType' is selected as 'ED Visit'")
	End If
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save ED Visit' Admittance with 'HomeHealthName' value. - Error message validation
	Execute "Set objHomeHealthName = " & Environment("WE_HomeHealthName")
	strHomeHealthName = "HomeHealth"
	Err.Clear
	objHomeHealthName.Set strHomeHealthName 
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to set 'Home Health Name'. "&Err.Description)
	End If
	Call WriteToLog("Pass","'Home Health Name' value is set")
	Execute "Set objHomeHealthName = Nothing"
	wait 0,100
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnEDvistScenarioPP = checkForPopup("Invalid Data", "Ok", "'HomeHealthName' should not be set", strOutErrorDesc)
	If not blnEDvistScenarioPP Then
		Call WriteToLog("Fail","Messagebox is not available when tried to save ED Visit admittance with HomeHealthName value. "&strOutErrorDesc)
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save ED Visit admittance with HomeHealthName value")
	End If	
	Wait 1
	
	'Clear 'HomeHealthName' 
	Execute "Set objHomeHealthName = " & Environment("WE_HomeHealthName")
	Err.Clear
	objHomeHealthName.Set "" 
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Unable to clear 'Home Health Name'. "&Err.Description)
	End If
	Call WriteToLog("Pass","'Home Health Name' value is cleared")
	Execute "Set objHomeHealthName = Nothing"
	wait 0,100
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Save ED Visit' Admittance with 'HomeHealthReason' value. - Error message validation
'	Execute "Set objPage_H_ED = " & Environment("WPG_AppParent") 'Page object
'	Set objDischargeSection = objPage_H_ED.WebElement("html tag:=DIV","innertext:=Discharge DatePatient Refused PlanNoYes   Disposition.*","visible:=True")
'	Set objHomeHealthReason = objDischargeSection.WebButton("html tag:=BUTTON","type:=button","outerhtml:=.*pull-left dropdowname.*","visible:=True")
	Execute "Set objHomeHealthReason = " & Environment("WEL_HomeHealthReason")
	objHomeHealthReason.highlight
	strHomeHealthReason = "Comorbid Management"
	blnHomeHealthReason = selectComboBoxItem(objHomeHealthReason, strHomeHealthReason)
	If Not blnHomeHealthReason Then
		Call WriteToLog("Fail","Unable to select required 'Home Health Reason'. "&strOutErrorDesc)
	End If
	Call WriteToLog("Pass","'Home Health Reason' drop down is available and selected required 'Home Health Reason' value")
	Execute "Set objPage_H_ED = Nothing"
	Set objDischargeSection = Nothing
	Set objHomeHealthReason = Nothing
	wait 0,500
	
	'Click save button
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked then
		strOutErrorDesc = "Unable to click on save button "&strOutErrorDesc
		Exit Function
	End If
	Execute "Set objSaveBtn = Nothing"
	Wait 2	
	Call waitTillLoads("Loading...")
	
	'Validate error msg box
	blnEDvistScenarioPP = checkForPopup("Invalid Data", "Ok", "'HomeHealthReason' should not be set", strOutErrorDesc)
	If not blnEDvistScenarioPP Then
		Call WriteToLog("Fail","Messagebox is not available when tried to save ED Visit admittance with HomeHealthReason value. "&strOutErrorDesc)
	Else 
		Call WriteToLog("Pass","Messagebox is available when tried to save ED Visit admittance with HomeHealthReason value")
	End If	
	Wait 1
	
	'Clear HomeHealthReason
'	Execute "Set objPage_H_ED = " & Environment("WPG_AppParent") 'Page object
'	Set objDischargeSection = objPage_H_ED.WebElement("html tag:=DIV","innertext:=Discharge DatePatient Refused PlanNoYes   Disposition.*","visible:=True")
'	Set objHomeHealthReason = objDischargeSection.WebButton("html tag:=BUTTON","type:=button","outerhtml:=.*pull-left dropdowname.*","visible:=True")
	Execute "Set objHomeHealthReason = " & Environment("WEL_HomeHealthReason")
	objHomeHealthReason.highlight
	blnHomeHealthReason = selectComboBoxItem(objHomeHealthReason, "Select a value")
	If Not blnHomeHealthReason Then
		Call WriteToLog("Fail","Unable to clear 'Home Health Reason'. "&strOutErrorDesc)
	End If
	Call WriteToLog("Pass","'Home Health Reason' drop down is cleared")
	
	Execute "Set objPage_H_ED = Nothing"
	Set objDischargeSection = Nothing
	Set objHomeHealthReason = Nothing
	wait 0,500
	
	
	'Check any Related diagnoses
	For iRD = 0 To 3 Step 1
		Execute "Set objPage_H_RD = "&Environment("WPG_AppParent")
'		Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("class:=screening-check-box-no.*","html id:=dig-selected-"&iRD,"html tag:=DIV","visible:=True")
		Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("html id:=Hospitalization_Review_DomainDeleted_"&iRD&"_Div","visible:=True")
		Err.Clear
		objRelatedDiagnosesCB.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to select checkbox for RelatedDiagnosis: "&" Error returned: " & Err.Description
			Exit Function
		End If	
		Execute "Set objPage_H_RD = Nothing"
		Set objRelatedDiagnosesCB = Nothing		
	Next
	Call WriteToLog("Pass","Checked RelatedDiagnoses check boxes")
	Execute "Set objPage_H_RD = Nothing"
	Set objRelatedDiagnosesCB = Nothing
		
	'Save ED Visit admittance
	blnSaveAdmittance = SaveFunctionality("Admit")
	If Not blnSaveAdmittance Then
		strOutErrorDesc = "Hospital admittance is not saved. "&strOutErrorDesc
		Exit Function	
	End If
	wait 0,250	
	
	Admittance_EDvisit = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: Admittance_MandatoryFields
'Purpose: Validate - Save admittance by providing values for only mandatory fields, admitdate = sys date, admit notification date = sys date, admitnotificationdate = admitdate, Admit patient more than one time with same admit type (but admit date different)
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Admittance_MandatoryFields(ByVal dtAdmitDate, ByVal dtNotificationDate, ByVal strAdmitType, ByVal strNotifiedBy, ByVal strSourceOfAdmit, strOutErrorDesc)	
	
	On Error Resume Next
	strOutErrorDesc = ""
	Admittance_MandatoryFields = False
	Err.Clear
	
	Call WriteToLog("Info","Admittance with only mandatory fields")
	
	strAdmittingDiagnosisTxt = "Admitting Diagnostics text"
	strWorkingDiagnosisTxt = "Working Diagnostics text"
		
	'Validate Admittance with only mandatory fields - 'Admit Date', 'Notification Date', 'Notified By', Admit Type', 'Source of Admit', 'Admitting Diagnosis' and 'Working Diagnosis'.

	'Click 'Add' button if enabled
	Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
	If not objAddBtn.Object.isDisabled Then
		Err.Clear
		blnAddClicked = ClickButton("Add",objAddBtn,strOutErrorDesc)
		If not blnAddClicked Then
			strOutErrorDesc = "Unable to click Add button for hospitalization "& strOutErrorDesc
			Exit Function	
		End If
	End If
	Execute "Set objAddBtn = Nothing"
	wait 5	
		
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save admittance with same Admit Date equal to sys date

	Execute "Set objAdmitDateTxt = " & Environment("WE_AdmitDateTxt") 'Admit date text box
	If not objAdmitDateTxt.Object.isDisabled Then
		Err.Clear
		Execute "Set objAdmitDate = "&Environment("dtAdmitDate_ED")
		Err.Clear 
		objAdmitDate.Set dtAdmitDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
			Exit Function	
		Else 
			Call WriteToLog("Pass","Admit Date is set")
		End If
	End If	
	Execute "Set objAdmitDateTxt = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save admittance with same Admit Notification Date equal to sys date
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then	
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Notification Date is set")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	wait 0,250
	
	'Select 'Notified By'
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
	blnNotification = selectComboBoxItem(objNotifiedByDD, strNotifiedBy)
	If Not blnNotification Then
		strOutErrorDesc = "Unable to select required 'NotifiedBy'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Notified By' is selected")
	Execute "Set objNotifiedByDD = Nothing"
	wait 0,500
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Save admittance with same Admit Type but with different Admit Date
	
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
	objAdmitTypeDD.highlight
	blnAdmitType = selectComboBoxItem(objAdmitTypeDD, strAdmitType)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to select required admit type. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Admit Type' is selected")
	Execute "Set objAdmitTypeDD = Nothing"
	wait 0,500
	
	'Select 'Source of Admit'
	Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
	objSourceOfAdmitDD.highlight
	blnSourceOfAdmit = selectComboBoxItem(objSourceOfAdmitDD, strSourceOfAdmit)
	If Not blnSourceOfAdmit Then
		strOutErrorDesc = "SourceOfAdmit selection returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","'Source of Admit' is selected")
	Execute "Set objSourceOfAdmitDD = Nothing"
	wait 0,250	
	
	'Povide 'Admitting Diagnosis'
	Err.Clear
	Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
	objAdmittingDiagnosisTxt.Set strAdmittingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for AdmittingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Admitting Diagnosis' is set")
	End If
	Execute "Set objAdmittingDiagnosisTxt = Nothing"
	wait 0,500	
	
	'Provide 'Working Diagnosis'
	Err.Clear
	Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
	objWorkingDiagnosisTxt.Set strWorkingDiagnosisTxt
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set value for WorkingDiagnosis "&Err.Description
		Exit Function	
	Else 
		Call WriteToLog("Pass","'Working Diagnosis' is set")
	End If
	Execute "Set objWorkingDiagnosisTxt = Nothing"
	wait 0,500
	
	'Save admittance
	blnSaveAdmittance = SaveFunctionality("Admit")
	If Not blnSaveAdmittance Then
		strOutErrorDesc = "Hospital admittance is not saved. "&strOutErrorDesc
		Exit Function	
	End If
	wait 0,250	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validation - Readmit check box is checked when saved admittance with same Admit Type but with different Admit Date
	Execute "Set objReadmitCB_checked = " & Environment("WEL_ReadmitCB_checked")
	If objReadmitCB_checked.Exist(5) Then
		Call WriteToLog("Pass","Readmit check box is checked when saved admittance with same Admit Type but with different Admit Date")
	Else
		Call WriteToLog("Fail","Readmit check box is not checked when saved admittance with same Admit Type but with different Admit Date")
	End If
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	Admittance_MandatoryFields = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: TransferPatient
'Purpose: Validate - Perform transform with sys date and admit date with only mandatory fields
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function TransferPatient(ByVal dtTransfer)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TransferPatient = False
	
	Call WriteToLog("Info","Tranfer Patient")

	dtTransferDate = dtTransfer
	Execute "Set objTrasferDate = "&Environment("WE_TransferDateTxBx")
	Err.Clear 
	objTrasferDate.Set dtTransferDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set dtTransferDate "&strOutErrorDesc
		Exit Function
	Else 
		Call WriteToLog("Pass","Set Transfer Date")
	End If
	Execute "Set objTransferCalendarBtn = Nothing"
	Wait 0,250
	
	'Save tranfer record
	blnSaveTransfer = SaveFunctionality("Transfer")
	If Not blnSaveTransfer Then
		strOutErrorDesc = "Transfer is not saved. "&strOutErrorDesc
		Exit Function
	End If
	Wait 1	
	
	TransferPatient = True
	
End Function

'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Function Name: OtherAdmitMandatoryScenarios
'Purpose: Validate - Dischage fields with sys date scenarios
'Author: Gregory
'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Discharge_Final(strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	Discharge_Final = False
	
	dtDischargeDate = Date
	dtDischargeNotificationDate = Date
	dtDischargePlanDate = Date
	strDisposition = "Home"
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Discharge with Discharge date equal to sys date
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear 
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Discharge Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge date equal to sys date is set")
	End If
	Execute "Set objDischargeCalendarBtn = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Discharge with Discharge Notification date equal to Admit date
	'Validation - Discharge with Discharge Notification date equal to Discharge date
	'Validation - Discharge with Discharge Notification date equal to sys date
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear 
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Discharge Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Notification date equal to Admit date, discharge date and sys date is set")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	wait 0,250	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Discharge with Discharge Plan date equal to Discharge date
	'Validation - Discharge with Discharge Plan date equal to sys date
	Execute "Set objDischargePlanDate = "&Environment("WE_PlanDateTxBx")
	Err.Clear 
	objDischargePlanDate.Set dtDischargePlanDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Discharge Plan Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Plan Date equal to discharge date and sys date is set")
	End If
	Execute "Set objPlanDateCalendarBtn = Nothing"
	wait 0,250
	'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'select disposition
	objDispositionDD.highlight
	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
	blnDisposition = selectComboBoxItem(objDispositionDD, strDisposition)
	If Not blnDisposition Then
		strOutErrorDesc = "Unable to select required 'Disposition'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Selected required 'Disposition' value")
	Execute "Set objDispositionDD = Nothing"
	wait 0,250
	
	'Check any Related diagnoses
	For iRD = 0 To 7 Step 1
		Execute "Set objPage_H_RD = "&Environment("WPG_AppParent")
'		Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("class:=screening-check-box-no.*","html id:=dig-selected-"&iRD,"html tag:=DIV","visible:=True")
		Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("html id:=Hospitalization_Review_DomainDeleted_"&iRD&"_Div","visible:=True")
		Err.Clear
		objRelatedDiagnosesCB.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to select checkbox for RelatedDiagnosis: "&" Error returned: " & Err.Description
			Exit Function
		End If	
		Execute "Set objPage_H_RD = Nothing"
		Set objRelatedDiagnosesCB = Nothing		
	Next
	Call WriteToLog("Pass","Checked RelatedDiagnoses check boxes")
	Execute "Set objPage_H_RD = Nothing"
	Set objRelatedDiagnosesCB = Nothing
	Wait 0,250
			
	'save discharge
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	If not objSaveBtn.Exist(1) OR objSaveBtn.Object.isDisabled Then
		strOutErrorDesc = "'Save' button for hospitalization is disabled/not existing after entering admittance fileds"& strOutErrorDesc
		Exit Function	
	End If
	Call WriteToLog("Pass","'Save' button for hospitalization is available and is enabled after entering admittance fileds")
	Execute "Set objSaveBtn = Nothing"
	Wait 0,250
	
	blnSaveTransfer = SaveFunctionality("Discharge")
	If Not blnSaveTransfer Then
		strOutErrorDesc = "Discharge is not saved. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Discharge is saved")
	Wait 1		

	Discharge_Final = True
	
End Function

'Ends - FUNCTIONS REQUIRED FOR HOSPITALIZATIONS > REVIEW SCREEN AUTOMATION SCRIPT-----------------------------------------------------------------------------------------------------
