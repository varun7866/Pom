'Starts - FUNCTIONS REQUIRED FOR MEDICATION SCREEN AUTOMATION SCRIPT-------------------------------------------

'-----------------------------------------------
'Function Name: PrimaryStepsForMedAdd
'Purpose: Add priliminary steps for medication
'Author: Gregory
'-----------------------------------------------
Function PrimaryStepsForMedAdd(ByVal strESA, ByVal strLabelName, strOutErrorDesc)

	On Error Resume Next
	PrimaryStepsForMedAdd = ""
	strOutErrorDesc = ""
	Err.Clear
	
	Execute "Set objPageMed_PSA = "&Environment("WPG_AppParent") 'PageObject	
	Execute "Set objMedAddBtn_PSA = "&Environment("WEL_MedAddBtn") ''Medications Add Button
	Execute "Set objRxNumberTxt_PSA = "&Environment("WE_RxNumberTxt") 'RxNumber
	Execute "Set objESAcb_PSA = "&Environment("WEL_ESAcb") 'ESA chk box	
	Execute "Set objESALbNaDD_PSA = "&Environment("WEL_LbNaDD") 'ESALabelNameDD
	Execute "Set objLbNaDD_PSA = "&Environment("WE_MedScr_LabelName") 'LabelNameDD
	
	'Clk Medications Add button
	Err.Clear
	objMedAddBtn_PSA.Highlight
	blnClickAdd = ClickButton("Add",objMedAddBtn_PSA,strOutErrorDesc)
	If not blnClickAdd Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Get the RxNumber for new medication
	objRxNumberTxt_PSA.highlight
	strRxNumber = Trim(objRxNumberTxt_PSA.GetROProperty("value"))
	If strRxNumber = "" Then
		strOutErrorDesc = "Unable to retrieve RxNumber for added medication"
		Exit Function
	End If
	Call WriteToLog("Pass","Retrieved RxNumber '"&strRxNumber&"' for new medication")
	wait 0,250
	
	If lcase(Trim(strESA)) = "yes" Then
		Err.clear	
		objESAcb_PSA.Click
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to click ESA checkbox "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Checked ESA checkbok")
		Wait 0,500
		
		'Select Label	
		blnLabel = selectComboBoxItem(objESALbNaDD_PSA, strLabelName)
		If Not blnLabel Then
			strOutErrorDesc = "Unable to select label for medication"
			Exit Function
		End If
		Call WriteToLog("Pass","Selected required label '"&strLabelName&"' for medication")
		wait 0,500		
		
	ElseIf lcase(Trim(strESA)) = "no" Then	
		blnSelectDropdownItemBySendingKeys = SelectDropdownItemBySendingKeys("Label", objLbNaDD_PSA, strLabelName, strOutErrorDesc)
		If not blnSelectDropdownItemBySendingKeys Then
		'----------------------Handle issue: somes first letter which was is send to UI is getting cleared. So clear dropdown and send again.
			objLbNaDD_PSA.Set ""
			blnSelectDropdownItemBySendingKeys = SelectDropdownItemBySendingKeys("Label", objLbNaDD_PSA, strLabelName, strOutErrorDesc)
				If not blnSelectDropdownItemBySendingKeys Then
					strOutErrorDesc = "Unable to select Label value. "&strOutErrorDesc
					Exit Function
				End If
		'-----------------------------------------------------------------------------------------------------------------------------------------------------------
		End If
		Wait 1
	End If
	
	PrimaryStepsForMedAdd = strRxNumber
	
	Execute "Set objPageMed_PSA = "&Environment("WPG_AppParent") 'PageObject	
	Execute "Set objMedAddBtn_PSA = "&Environment("WEL_MedAddBtn") ''Medications Add Button
	Execute "Set objESAcb_PSA = "&Environment("WEL_ESAcb") 'ESA chk box
	Execute "Set objLbNaDD_PSA = "&Environment("WEL_LbNaDD") 'LabelNameDD
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: AddMedicationWithAllDetails
'Purpose: Add a medication providing values for all fields present
'Author: Gregory
'-----------------------------------------------
Function AddMedicationWithAllDetails(ByVal strMedicationDetails, ByVal dtWrittenDate, ByVal dtFilledDate, strOutErrorDesc)	   
	  
	On Error Resume Next
	Err.Clear
	AddMedicationWithAllDetails = ""
	strOutErrorDesc = ""
	
	Execute "Set objPageMedPane = "&Environment("WPG_AppParent") 'PageObject	
	Execute "Set objMedAddBtn = "&Environment("WEL_MedAddBtn") ''Medications Add Button
	Execute "Set objESAcb = "&Environment("WEL_ESAcb") 'ESA chk box
	Execute "Set objLbNaDD = "&Environment("WEL_LbNaDD") 'LabelNameDD
	Execute "Set objRxNumberTxt = "&Environment("WE_RxNumberTxt") 'RxNumber
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objSource = "&Environment("WB_MedScr_Source") 
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
'	Execute "Set objDisclaimerOK = "&Environment("WB_DisclaimerOK") 'Medications Save Btn	
	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
	Execute "Set objPhone = "&Environment("WE_MedScr_Phone")
	Execute "Set objCity = "&Environment("WE_MedScr_City")
	Execute "Set objState = "&Environment("WB_MedScr_State")
	Execute "Set objZip = "&Environment("WE_MedScr_Zip")
	Execute "Set objIndication = "&Environment("WE_MedScr_Indication")
	Execute "Set objSubstitute = "&Environment("WE_MedScr_Substitute")
	Execute "Set objOrderNotes = "&Environment("WE_MedScr_OrderNotes")
	Execute "Set objPharmName = "&Environment("WE_MedScr_PharmName")
	Execute "Set objPrescNPI = "&Environment("WE_MedScr_PrescNPI")
	Execute "Set objPrescName = "&Environment("WE_MedScr_PrescName")
	Execute "Set objMapDiagnosis = "&Environment("WE_MedScr_MapDiagnosis")		
	Set objUnit = objPageMedPane.WebButton("html id:=unit-dropdown","html tag:=BUTTON","outerhtml:=.*unit-dropdown.*","type:=button","visible:=True","index:=1")

	arrMedicationDetails = Split(strMedicationDetails,",",-1,1)
	
	strESA = arrMedicationDetails(0)
	strLabelName = arrMedicationDetails(1)	
	intRefillNumber = arrMedicationDetails(2)
	intMaxRefills = arrMedicationDetails(3)
	intQuantity = arrMedicationDetails(4)
	intDose = arrMedicationDetails(5)
	strUnit = arrMedicationDetails(6)
	strFrequencyValue = arrMedicationDetails(7)
	intDaysSupply = arrMedicationDetails(8)
	strRoute = arrMedicationDetails(9)
	lngPhone = arrMedicationDetails(10)
	strSource = arrMedicationDetails(11)
	strCity = arrMedicationDetails(12)
	strState = arrMedicationDetails(13)
	lngZip = arrMedicationDetails(14)
	strIndication = arrMedicationDetails(15)
	strSubstitute = arrMedicationDetails(16)
	strOrderNotes = arrMedicationDetails(17)
	strPharmName = arrMedicationDetails(18)
	strPrescNPI = arrMedicationDetails(19)
	strPrescName = arrMedicationDetails(20)
	
	If dtWrittenDate = "" OR lcase(Trim(dtWrittenDate)) = "na" Then
		dtWrittenDate = DateAdd("d",-1,Date)
	End If
	
	If dtFilledDate = "" OR lcase(Trim(dtFilledDate)) = "na" Then
		dtFilledDate = DateAdd("d",-1,Date)
	End If
	
	Call WriteToLog("Info","---Validation - Add button functionality---") 
	strRxNumber = PrimaryStepsForMedAdd(strESA, strLabelName, strOutErrorDesc)
	If strRxNumber = "" Then
		strOutErrorDesc = "Unable to complete priliminary steps for adding medication. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated Add button functionality and Completed priliminary steps for adding medication")
	Wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500

	'Set Refill Number
	blnMedPaneValues = MedPaneValues("RefillNumber", intRefillNumber, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Refill Number")
	End If
	wait 0,500
		
	'Set Max Refill
	blnMedPaneValues = MedPaneValues("maxRefill", intMaxRefills, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)		
	'	Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Max Refills")
	End If
	wait 0,500
	
	'Set quantity
	blnMedPaneValues = MedPaneValues("Quantity", intQuantity, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Quantity")
	End If
	wait 0,500
		
	'Set dose value
	blnMedPaneValues = MedPaneValues("dose", intDose, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500		
	
	'Select Unit	
	blnUnit = selectComboBoxItem(objUnit, strUnit)
	If not blnUnit Then
		strOutErrorDesc = "Unable to select Unit value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Unit")
	End If
	wait 0,500
	
	'Select frequency
	blnFrequency = selectComboBoxItem(objMedFreq, strFrequencyValue)
	If not blnFrequency Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
		
	'Set Days supply
	blnMedPaneValues = MedPaneValues("daySupply", intDaysSupply, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Days Supply")
	End If
	wait 0,500
	
	'Select Route
	blnRoute = selectComboBoxItem(objRoute,strRoute)
	If not blnRoute Then
		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Route")
	End If
	wait 0,500

	'Select Source
	blnSource = selectComboBoxItem(objSource, strSource)
	If not blnSource Then
		strOutErrorDesc = "Unable to select Source value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Selected Source as '"&strSource&"'")
	End If
	wait 0,500
	
	'Set PrescNPI value
	Err.Clear
	objPrescNPI.Set strPrescNPI
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set PrescNPI value. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set PrescNPI value")
	End If
	wait 0,500
	
	'Set PrescName
	Err.Clear
	objPrescName.Set strPrescName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set PrescName value. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set PrescName value")
	End If
	wait 0,500
	
	'Set PharmName
	Err.Clear
	objPharmName.Set strPharmName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set PharmName value. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set PharmName value")
	End If
	wait 0,500
	
	'Set phone number
	Err.Clear
	objPhone.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Phone text box. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Wait 0,500
		sendkeys lngPhone
		Call WriteToLog("Pass","Successfully set Phone number")
	End If
	Wait 0,500
	
	'Set city
	Err.Clear
	objCity.Set strCity
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set value for City. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set City value")
	End If
	Wait 0,500
	
	'Select state
	blnState = selectComboBoxItem(objState, strState)
	If not blnState Then
		strOutErrorDesc = "Unable to select State value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for State")
	End If
	wait 0,500
	
	'Set zip
	Err.Clear
	objZip.Set lngZip
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set value for Zip. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set Zip value")
	End If
	Wait 0,500
	
	'Select indication value
	blnSelectDropdownItemBySendingKeys = SelectDropdownItemBySendingKeys("Indication",objIndication,strIndication,strOutErrorDesc)
	If not blnSelectDropdownItemBySendingKeys Then
		strOutErrorDesc = "Unable to select Indication value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	End If
	Wait 2
	
	'Validate MapDiagnosis value
	If Instr(1,strIndication,Trim(objMapDiagnosis.GetROProperty("outertext")),1) <= 0 Then
		strOutErrorDesc = "Map Diagnosis value is not shown as expected"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Map Diagnosis value is shown as expected")	
	End If
	Wait 0,500
	
	'Select substitute value
	blnSelectDropdownItemBySendingKeys = SelectDropdownItemBySendingKeys("Substitute",objSubstitute,strSubstitute,strOutErrorDesc)
	If not blnSelectDropdownItemBySendingKeys Then
		strOutErrorDesc = "Unable to select Substitute value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	End If
	Wait 0,500
	
	'Set value for order notes
	Err.Clear
	objOrderNotes.Set strOrderNotes
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set value for OrderNotes. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set Order Notes value")
	End If
	Wait 0,500
	
	'Save Medication
	Call WriteToLog("Info","---Validation - Save button functionality---") 
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Validated Save button functionality and Saved newly added medication")

	'Wait for processing
	Call WaitForProcessing()
	
	AddMedicationWithAllDetails = Trim(Replace(strRxNumber,".*","",1,-1,1))
	
	Execute "Set objPageMedPane = Nothing"
	Execute "Set objMedAddBtn = Nothing"
	Execute "Set objESAcb = Nothing"
	Execute "Set objLbNaDD = Nothing"
	Execute "Set objRxNumberTxt = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objSource = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objDisclaimerOK = Nothing"
	Execute "Set objRoute = Nothing"
	Execute "Set objPhone = Nothing"
	Execute "Set objCity = Nothing"
	Execute "Set objState = Nothing"
	Execute "Set objZip = Nothing"
	Execute "Set objIndication = Nothing"
	Execute "Set objSubstitute = Nothing"
	Execute "Set objOrderNotes = Nothing"
	Execute "Set objPharmName = Nothing"
	Execute "Set objPrescNPI = Nothing"
	Execute "Set objPrescName = Nothing"
	Execute "Set objMapDiagnosis = Nothing"
	Set objUnit = Nothing
	 
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: ValidateAllMedicationEntries
'Purpose: Validate entered medication values
'Author: Gregory
'-----------------------------------------------
Function ValidateAllMedicationEntries(ByVal strMedicationDetails, ByVal dtWrittenDate, ByVal dtFilledDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	arrAllMedicationDetails = Split(strMedicationDetails,",",-1,1)
	
	strESA = arrAllMedicationDetails(0)
	strLabelName = arrAllMedicationDetails(1)	
	intRefillNumber = arrAllMedicationDetails(2)
	intMaxRefills = arrAllMedicationDetails(3)
	intQuantity = arrAllMedicationDetails(4)
	intDose = arrAllMedicationDetails(5)
	strUnit = arrAllMedicationDetails(6)
	strFrequencyValue = arrAllMedicationDetails(7)
	intDaysSupply = arrAllMedicationDetails(8)
	strRoute = arrAllMedicationDetails(9)
	lngPhone = arrAllMedicationDetails(10)
	strSource = arrAllMedicationDetails(11)
	strCity = arrAllMedicationDetails(12)
	strState = arrAllMedicationDetails(13)
	lngZip = arrAllMedicationDetails(14)
	strIndication = arrAllMedicationDetails(15)
	strSubstitute = arrAllMedicationDetails(16)
	strOrderNotes = arrAllMedicationDetails(17)
	strPharmName = arrAllMedicationDetails(18)
	strPrescNPI = arrAllMedicationDetails(19)
	strPrescName = arrAllMedicationDetails(20)

	'Validate lable name
	blnValidateLabelName = ValidateMedicationEntry(strLabelName)
	If not blnValidateLabelName Then
		strOutErrorDesc = "Label Name is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Label Name in saved medication entry")
	End If
	Wait 0,250
	
	'Validate written date
	dtWrittenDate = DateFormat(dtWrittenDate)
	blnValidateWrittenDate = ValidateMedicationEntry(dtWrittenDate)	
	If not blnValidateWrittenDate Then
		strOutErrorDesc = "Written date is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Written date in saved medication entry")
	End If
	Wait 0,250
	
	'Validate filled date
	dtFilledDate = DateFormat(dtFilledDate)
	blnValidateFilledDate = ValidateMedicationEntry(dtFilledDate)
	If not blnValidateFilledDate Then
		strOutErrorDesc = "Filled date is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Filled date in saved medication entry")
	End If
	Wait 0,250
	
	'Validate refill number
	blnValidateRefillNumber = ValidateMedicationEntry(intRefillNumber)
	If not blnValidateRefillNumber Then
		strOutErrorDesc = "Refill Number is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Refill Number in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Max Refills
	blnValidateMaxRefills = ValidateMedicationEntry(intMaxRefills)
	If not blnValidateMaxRefills Then
		strOutErrorDesc = "Max Refills is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Max Refills in saved medication entry")
	End If
	Wait 0,250
	
	'Validate quantity
	blnValidateQuantity = ValidateMedicationEntry(intQuantity)
	If not blnValidateQuantity Then
		strOutErrorDesc = "Quantity is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Quantity in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Dose value
	blnValidateDose = ValidateMedicationEntry(intDose)
	If not blnValidateDose Then
		strOutErrorDesc = "Dose is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Dose in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Unit
	blnValidateUnit = ValidateMedicationEntry(strUnit)
	If not blnValidateUnit Then
		strOutErrorDesc = "Unit is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Unit in saved medication entry")
	End If
	Wait 0,250
	
	'Validate frequency value
	blnValidateFrequencyValue = ValidateMedicationEntry(strFrequencyValue)
	If not blnValidateFrequencyValue Then
		strOutErrorDesc = "Frequency is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Frequency in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Days supply
	blnValidateDaysSupply = ValidateMedicationEntry(intDaysSupply)
	If not blnValidateDaysSupply Then
		strOutErrorDesc = "Days Supply is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Days Supply in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Route
	blnValidateRoute = ValidateMedicationEntry(strRoute)
	If not blnValidateRoute Then
		strOutErrorDesc = "Route is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Route in saved medication entry")
	End If
	Wait 0,250
	
	'Validate phone number
	blnValidatePhone = ValidateMedicationEntry(lngPhone)
	If not blnValidatePhone Then
		strOutErrorDesc = "Phone is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Phone in saved medication entry")
	End If
	Wait 0,250
	
	'Validate source
	blnValidateSource = ValidateMedicationEntry(strSource)
	If not blnValidateSource Then
		strOutErrorDesc = "Source is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Source in saved medication entry")
	End If
	Wait 0,250
	
	'ValidateAddress
	blnValidateCity = ValidateMedicationEntry(strCity)
	If not blnValidateCity Then
		strOutErrorDesc = "City is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated City in saved medication entry")
	End If
	Wait 0,250	
'	blnValidateState = ValidateMedicationEntry(strState)
'	If not blnValidateState Then
'		strOutErrorDesc = "State is not available in saved medication entry"
'		Call WriteToLog("Fail",strOutErrorDesc)
'	'	Exit Function
'	Else
'		Call WriteToLog("Pass","Validated State in saved medication entry")
'	End If
	Wait 0,250	
	blnValidateZip = ValidateMedicationEntry(lngZip)
	If not blnValidateZip Then
		strOutErrorDesc = "Zip is note available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Zip in saved medication entry")
	End If
	Wait 0,250
	
	'Validate indication
	blnValidateIndication = ValidateMedicationEntry(strIndication)
	If not blnValidateIndication Then
		strOutErrorDesc = "Indication is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Indication in saved medication entry")
	End If
	Wait 0,250
	
	'Validate substitute
	blnValidateSubstitute = ValidateMedicationEntry(strSubstitute)
	If not blnValidateSubstitute Then
		strOutErrorDesc = "Substitute is note available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Substitute in saved medication entry")
	End If
	Wait 0,250
	
	'Validate order notes
	blnValidateOrderNotes = ValidateMedicationEntry(strOrderNotes)
	If not blnValidateOrderNotes Then
		strOutErrorDesc = "OrderNotes is note available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated OrderNotes in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Pharm Name
	blnValidatePharmName = ValidateMedicationEntry(strPharmName)
	If not blnValidatePharmName Then
		strOutErrorDesc = "Pharm Name is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Pharm Name in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Presc NPI
	blnValidatePrescNPI = ValidateMedicationEntry(strPrescNPI)
	If not blnValidatePrescNPI Then
		strOutErrorDesc = "PrescNPI is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated PrescNPI in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Presc Name
	blnValidatePrescName= ValidateMedicationEntry(strPrescName)
	If not blnValidatePrescName Then
		strOutErrorDesc = "PrescName is note available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Presc Name in saved medication entry")
	End If
	Wait 0,250		
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: ValidateMedicationEntry
'Purpose: Validate each entry
'Author: Gregory
'-----------------------------------------------
Function ValidateMedicationEntry(ByVal ValidateValue)

	On Error Resume Next
	Err.Clear
	ValidateMedicationEntry = False
	
	Execute "Set objMedDetails = "&Environment("WE_MedScr_MedDetails")	
	strMedDetails = Trim(objMedDetails.GetROProperty("outertext"))
	If Instr(1,strMedDetails,ValidateValue,1) > 0 Then
		ValidateMedicationEntry = True
	End If
	
	Execute "Set objMedDetails = Nothing"
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: MedPaneValues
'Purpose: Get objects in med screen and provide values
'Author: Gregory
'-----------------------------------------------
Function MedPaneValues(ByVal strSelectItem, ByVal intValue, strOutErrorDesc)	

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	MedPaneValues = False
	
	Execute "Set objMedPane_Page = "&Environment("WPG_AppParent")
	strCommonTBpart = ""
	Set oDescMed = Description.Create
	oDescMed("micclass").value = "WebElement"
	oDescMed("class").value = "k-numeric-wrap.*"
	oDescMed("class").RegularExpression = True
	oDescMed("html tag").value = "SPAN"
	oDescMed("innerhtml").value = ".*"& strSelectItem &".*"
	oDescMed("innerhtml").RegularExpression = True
	oDescMed("visible").value = True
	
	Set objRequiredTextBox = objMedPane_Page.ChildObjects(oDescMed)
	intRequiredTextBoxCount = objRequiredTextBox.Count
	
	If intRequiredTextBoxCount = 0 Then
		strOutErrorDesc = strSelectItem&" text box is not available in medications pane"
		Exit Function
	ElseIf intRequiredTextBoxCount > 1 Then
		strOutErrorDesc = "More than one text box with similar properties exist in medications pane"
		Exit Function
	End If
	
	For mtb = 0 To intRequiredTextBoxCount-1 Step 1
		objRequiredTextBox(mtb).highlight
		Err.Clear
		objRequiredTextBox(mtb).WebEdit("html tag:=INPUT","name:=WebEdit","visible:=True").Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click required text box"
			Exit Function
		End If
		
		Wait 0,500
		If Instr(1,strSelectItem,"dose",1) > 0 Then
			For d = 1 To 4 Step 1
				sendkeys ("{DEL}")
				sendkeys ("{BKSP}")
				Wait 0,50				
			Next
			sendkeys intValue
		Else
			sendkeys intValue
		End If
		Wait 0,500	
		
	Next
	
	MedPaneValues = True
	
	Set objMedPane_Page = Nothing
	Set oDescMed = Nothing
	Set objRequiredTextBox = Nothing	

End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: SelectDropdownItemBySendingKeys
'Purpose: Select dropdown value by sending each char
'Author: Gregory
'-----------------------------------------------
Function SelectDropdownItemBySendingKeys(ByVal strDDname, ByVal objDD, ByVal strItem, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	SelectDropdownItemBySendingKeys = False
	
	Execute "Set objPageMedPane_SK = "&Environment("WPG_AppParent")	
	Err.Clear
	objDD.highlight
	objDD.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to clcik "&strDDname&" dropdown"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked on "&strDDname&" dropdown")
	Wait 0,250
	
	'Keep Label empty
	For d = 1 To 50 Step 1
		sendkeys ("{DEL}")
		sendkeys ("{BKSP}")
		Wait 0,50				
	Next
	Wait 0,250
	
	For i = 1 To len(strItem)
		ch = Mid(strItem, i, 1)
		sendKeys ch
		Err.Clear
		
		If Instr(1,strDDname,"Indication",1) Then
			Set objList = objPageMedPane_SK.WebElement("class:=k-list-container k-popup k-group k-reset k-state-border-down", "html id:=ind1-list")
		ElseIf Instr(1,strDDname,"Substitute",1) Then
			Set objList = objPageMedPane.WebElement("class:=k-list-container k-popup k-group k-reset k-state-border-down", "html id:=sub1-list")
		ElseIf Instr(1,strDDname,"Label",1) Then
			Set objList = objPageMedPane_SK.WebElement("class:=k-list-container.*","html tag:=DIV","html id:=drug-list","visible:=True")
		ElseIf Instr(1,strDDname,"Allergy",1) Then
			Set objList = objPageMedPane_SK.WebElement("class:=k-list-container k-popup k-group k-reset k-state-border-up", "html id:=allergyName-list")
		ElseIf Instr(1,strDDname,"EditInd",1) Then
			Set objList = objPageMedPane_SK.WebElement("class:=k-list-container k-popup k-group k-reset k-state-border-down", "html id:=ind2-list")
		ElseIf Instr(1,strDDname,"EditSub",1) Then
			Set objList = objPageMedPane_SK.WebElement("class:=k-list-container k-popup k-group k-reset k-state-border-down", "html id:=sub2-list")
		End If		
		
		isFound = false
		If objList.Exist(5) Then
			Call WriteToLog("Pass", strDDname&" dropdown list is available")
			objList.highlight
			Set itemDesc = Description.Create
			itemDesc("micclass").Value = "WebElement"
			itemDesc("class").Value = "k-item.*"
			
			Set objItem = objList.ChildObjects(itemDesc)
			For j = 0 To objItem.Count - 1
				item = objItem(j).getROProperty("outertext")
				
				If item = strItem Then
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
		Call WriteToLog("Pass","Selected "&strItem&" from "&strDDname&" dropdown")
		SelectDropdownItemBySendingKeys = True
	Else
		strOutErrorDesc  strItem&" is not present in "&strDDname&" dropdown"
		Exit Function
	End If
	wait 1		
	
	Set objPageMedPane_SK = Nothing
	Set objDD = Nothing
	Set objList = Nothing
	Set itemDesc = Nothing
		
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: Add_Validation_Mandatory_Duplicate_Written_Filled
'Purpose: Validate Mandatory, duplicate, written filled date scenarios
'Author: Gregory
'-----------------------------------------------
Function Add_Validation_Mandatory_Duplicate_Written_Filled(strOutErrorDesc)
	   
	On Error Resume Next
	Add_Validation_Mandatory_Duplicate_Written_Filled = ""
	strOutErrorDesc = ""
	Err.Clear

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add medication without mandatory field (frequency)
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add medication without mandatory field (frequency)- Should not be able to save- error message validation---") 
	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved newly added medication")
	Wait 2
	
	blnDateValidationErrorPP = checkForPopup("Error", "Ok", "Frequency is Required", strOutErrorDesc)
	If not blnDateValidationErrorPP Then
		strOutErrorDesc = "Unable to validate error popup message for add medication without mandatory field (frequency)"&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error popup message while user tried to add medication without mandatory field (frequency)")
	Wait 1
		
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add medication with Written date > sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---'Validation - Add medication with Written date greater than sys date-Should not be able to save- error message validation--") 
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	
	'Clk Medications Cancel button
	Call WriteToLog("Info","---Validation - Cancel button functonality---") 
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1

	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated Cancel button functionality and completed Priliminary steps for adding another medication")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved newly added medication")
	Wait 2
	
	blnDateValidationErrorPP = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
	If not blnDateValidationErrorPP Then
		strOutErrorDesc = "Unable to validate error message for written date as future date on adding medication"&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message while user tried to add medication with written date as future date")
	Wait 1
		
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add medication with Filled date > sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add medication with Filled date greater than sys date-Should not be able to save- error message validation--") 
	Execute "Set objCancelMed = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",1,Date)
	
	'Clk Medications Cancel button
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1

	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved newly added medication")
	Wait 2
	
	blnDateValidationErrorPP = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
	If not blnDateValidationErrorPP Then
		strOutErrorDesc = "Unable to validate error message for filled date as future date on adding medication"&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message while user tried to add medication with filled date as future date")
	Wait 1

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add medication with Written date less than 365 days from sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---'Validation - Add medication with Written date less than 365 days from sys date-Should not be able to save- error message validation---") 
	Execute "Set objCancelMed = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",-370,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	
	'Clk Medications Cancel button
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1

	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved newly added medication")
	Wait 2
	
	blnDateValidationErrorPP = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
	If not blnDateValidationErrorPP Then
		strOutErrorDesc = "Unable to validate error message for written date as future date on adding medication "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message while user tried to add medication with written date as future date")
	Wait 1
		
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add medication with Filled date less than 365 days from sys date
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add medication with Filled date less than 365 days from sys date-Should not be able to save- error message validation---") 
	Execute "Set objCancelMed = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-370,Date)
	
	'Clk Medications Cancel button
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1

	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved newly added medication")
	Wait 2
	
	blnDateValidationErrorPP = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
	If not blnDateValidationErrorPP Then
		strOutErrorDesc = "Unable to validate error message for filled date as future date on adding medication"&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated popup message while user tried to add medication with filled date as future date")
	Wait 1	
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add medication without Label
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add medication without mandatory field (Label)- Should not be able to save- error message validation---") 
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objMedAddBtn_L = "&Environment("WEL_MedAddBtn") ''Medications Add Button
	Execute "Set objMedAddBtn = "&Environment("WEL_MedAddBtn") ''Medications Add Button
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	
	'Clk Medications Cancel button
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1

	'Clk Medications Add button
	Err.Clear
	blnClickAdd = ClickButton("Add",objMedAddBtn_L,strOutErrorDesc)
	If not blnClickAdd Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved newly added medication")
	Wait 2
	
	blnDateValidationErrorPP = checkForPopup("Invalid Data", "Ok", "Validation Error", strOutErrorDesc)
	If not blnDateValidationErrorPP Then
		strOutErrorDesc = "Unable to validate error message for written date as future date on adding medication"&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message while user tried to add medication with written date as future date")
	Wait 1
		
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add medication with only mandatory fields
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add medication with only mandatory fields-Should be able to save---") 	
	
	For dm = 1 To 2 Step 1
	
		If dm = 2 Then
			'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			'*Validation - 'Add duplicate medication
			'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			Call WriteToLog("Info","---Validation - Add duplicate medication-Should be able to save---") 	
		End If	
		
		Execute "Set objCancelMed = Nothing"
		Execute "Set objWrittenDate = Nothing"
		Execute "Set objFilledDate = Nothing"
		Execute "Set objMedFreq = Nothing"
		Execute "Set objMedSavbtn = Nothing"
		Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
		Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
		Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
		Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
		Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
		dtWrittenDate = DateAdd("d",-1,Date)
		dtFilledDate = DateAdd("d",-1,Date)
			
		If dm = 1 Then				
			'Clk Medications Cancel button
			Err.Clear
			blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
			If not blnClickCancel Then
				strOutErrorDesc = "Unable to click cancel button for adding new medication"
				Exit Function
			End If
			Wait 1		
		End If
	
		strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
		If strPrimaryStepsForMedAdd = "" Then
			strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
		wait 0,500
		
		'Value for Medications WrittenDate
		Err.clear
		objWrittenDate.Set dtWrittenDate
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to set written date "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Written date is set for medication")
		Wait 0,500
		
		'Value for Medications FilledDate 
		Err.clear
		objFilledDate.Set dtFilledDate
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to set filled date "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Filled date is set for medication")
		Wait 0,500
		
		'Select required frequency
		blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
		If not blnFreqSelect Then	
		   	strOutErrorDesc = "Unable to select frequency value from dropdown"
			Exit Function
		End If 
		Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
		Wait 0,500
		
		'Save new Medication
		blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
		If not blnClickSave Then
			strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
			Exit Function
		End If 
	
		If dm = 2 Then
			Call WriteToLog("Pass","Validated duplicate medication add") 	
		Else
			Call WriteToLog("Pass","Validated medication add with only mandatory fields")
		End If
		Wait 1		
			
		'Wait for processing
		Call WaitForProcessing()
		
		Execute "Set objPageMedPane_AVMWF = Nothing"	
		Execute "Set objMedAddBtn_L = Nothing"
		Execute "Set objWrittenDate = Nothing"
		Execute "Set objFilledDate = Nothing"
		Execute "Set objMedFreq = Nothing"
		Execute "Set objMedSavbtn = Nothing"
		
	 Next
	 
	 Add_Validation_Mandatory_Duplicate_Written_Filled = strPrimaryStepsForMedAdd
	 
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: Add_Validation_NonESA_Dose_Frequency_Route
'Purpose: Validate esa, nonesa,dose, frequency, route scenarios
'Author: Gregory
'-----------------------------------------------
Function Add_Validation_NonESA_Dose_Frequency_Route(strOutErrorDesc)

	On Error Resume Next
	Add_Validation_NonESA_Dose_Frequency_Route = ""
	strOutErrorDesc = ""
	Err.Clear
	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add ESA medication without providing Dose. Should be able to save.
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation -Add ESA medication without providing Dose. Should be able to save---") 
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	strLabel = "Epogen"
	strFrequency = "AS NEEDED"
	
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes",strLabel,strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, strFrequency)
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500	
	
	'Remove default value of Dose - keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved ESA medication without providing Dose")
	Wait 2
	
	'Wait for processing
	Call WaitForProcessing()
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add NonESA medication with frequency other than 'SLIDE SCALE'- without providing Dose. Error message validation
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add NonESA medication with frequency other than 'SLIDE SCALE' and without providing Dose - Error popup should be available---") 
	
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	strLabel = "Ace Aerosol Cloud Enhancer Miscellaneous"
	strFrequency = "AS NEEDED"
	
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("No",strLabel,strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, strFrequency)
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500	
	
	'Remove default value of Dose - keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Wait 2
	
	blnDateValidationErrorPP = checkForPopup("Error", "Ok", "Dose is Required", strOutErrorDesc)
	If not blnDateValidationErrorPP Then
		strOutErrorDesc = "Unable to validate error message for add medication without mandatory field (frequency)"&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message while user tried to add medication without mandatory field (frequency)")
	Wait 1
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add NonESA medication with Route other than 'TP' and without providing Dose. Error message validation
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add NonESA medication with Route other than 'TP' and without providing Dose - Error popup should be available---") 
	
	Execute "Set objCancelMed = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	strLabel = "Ace Aerosol Cloud Enhancer Miscellaneous"
	strFrequency = "AS NEEDED"
	strRoute = "DT"

	'Clk Medications Cancel button
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1
	
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("No",strLabel,strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Remove default value of Dose - keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, strFrequency)
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500	
	
	'Select Route
	blnRoute = selectComboBoxItem(objRoute, strRoute)
	If not blnRoute Then
		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Route")
	End If
	wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Wait 2
	
	blnDateValidationErrorPP = checkForPopup("Error", "Ok", "Dose is Required", strOutErrorDesc)
	If not blnDateValidationErrorPP Then
		strOutErrorDesc = "Unable to validate error message for add medication without mandatory field (frequency)"&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message while user tried to add medication without mandatory field (frequency)")
	Wait 1
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add NonESA medication with Route as 'TP' and without providing Dose.
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add NonESA medication with Route as 'TP' and without providing Dose - should be able to save medication---") 
	
	Execute "Set objCancelMed = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objRoute = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	strLabel = "Ace Aerosol Cloud Enhancer Miscellaneous"
	strFrequency = "AS NEEDED"
	strRoute = "TP"

	'Clk Medications Cancel button
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1
	
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("No",strLabel,strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Remove default value of Dose- keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, strFrequency)
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500	
	
	'Select Route
	blnRoute = selectComboBoxItem(objRoute, strRoute)
	If not blnRoute Then
		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Route")
	End If
	wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved NonESA medication with Route as 'TP' and without providing Dose")
	
	'Wait for processing
	Call WaitForProcessing()
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add NonESA medication with frequency as 'SLIDE SCALE' and without providing Dose.
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add NonESA medication with frequency as 'SLIDE SCALE' and without providing Dose - should be able to save medication---") 

	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	strFrequency = "SLIDING SCALE"
	
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("No",strLabel,strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, strFrequency)
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500	
	
	'Remove default value - keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved NonESA medication with frequency as 'SLIDE SCALE' and without providing Dose")
	
	'Wait for processing
	Call WaitForProcessing()
	
	Add_Validation_NonESA_Dose_Frequency_Route = strPrimaryStepsForMedAdd
	
	Execute "Set objPageMedPane_AVNFR = Nothing"	
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: SelectSpecificMedicationFromMedTable
'Purpose: select specific medication from med table
'Author: Gregory
'-----------------------------------------------
Function SelectSpecificMedicationFromMedTable(ByVal strRxNumber,strOutErrorDesc)

	On Error Resume Next
	SelectSpecificMedicationFromMedTable = False
	strOutErrorDesc = ""
	Err.Clear
	
	Execute "Set objPageMedPane_SSMFMT = "&Environment("WPG_AppParent") 'PageObject		
	Execute "Set objMedTable_SSMFMT = "&Environment("WT_MedicationReviewMedTable") 'Medication Table in 'Clinical Management > Mecication > Review' screen		
	objMedTable_SSMFMT.highlight
	intTotalLabels = objMedTable_SSMFMT.RowCount
	
	For intFinite = 1 To 2 Step 1		
		
		For intLabels = 1 To intTotalLabels Step 1
		
			Setting.WebPackage("ReplayType") = 2
			Err.Clear
			objMedTable_SSMFMT.ChildItem(intLabels,3,"WebElement",0).FireEvent "onClick"	'intLabel represents RowNumber, 3 represents LabelName ColumnNumber
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to click on medicine labels in Medication list table. "&Err.Description
				Exit Function
			End If 			
	'----------------------------------------------------------
			Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
			If objEditMed.Exist(1/4) Then
				objEditMed.Click				
				Set RxObject = getPageObject().WebElement("html tag:=SPAN","outertext:="&strRxNumber,"visible:=True")
				If RxObject.Exist(1/4) Then	
					Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
					objCancelMed.Click		
					SelectSpecificMedicationFromMedTable = True
					Exit Function
				End If
				Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
				objCancelMed.Click	
			End If
	'----------------------------------------------------------		
			MedSelectFlag = False
			Execute "Set objMedicationData = "&Environment("WT_MedicationData")
			strMedicationData = objMedicationData.GetROProperty("outertext")
			If Instr(1,strMedicationData,strRxNumber,1) > 0 Then
				MedSelectFlag = True
				Exit For
			End If 
			Execute "Set objMedicationData = Nothing"
	
		Next
		
		If MedSelectFlag Then
			Exit For
		End If
		Wait 3
	Next
	
	If MedSelectFlag Then
		SelectSpecificMedicationFromMedTable = True
	Else
		strOutErrorDesc = "Required medication is not present under Medication Table"
		Exit Function
	End If
	Wait 1
	
	Execute "Set objPageMedPane_SSMFMT = Nothing"
	Set objMedTable_SSMFMT = Nothing
	
End Function

'--------------------------------------------------------

'-----------------------------------------------
'Function Name: Add_Validation_Discontinued
'Purpose: validate discontinue senarios
'Author: Gregory
'-----------------------------------------------
Function Add_Validation_Discontinued(ByVal dtDiscontinuedDate, strOutErrorDesc)

	On Error Resume Next
	Add_Validation_Discontinued = ""
	strOutErrorDesc = ""
	Err.Clear	

	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objDiscontinueReason = " &Environment("WE_DicontinueReason") 'Discontinue Reason
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	strLabel = "Epogen"
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)

	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes",strLabel,strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	Err.Clear
	Execute "Set objAdd_DiscontinuedDate = " &Environment("WE_MedScr_Add_DicontinueDate") 'Discountinued Date at medication add
	objAdd_DiscontinuedDate.Set dtDiscontinuedDate	
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Expected Result:Discontinued Date field is set; Actual Result: Discontinued Date field was not set ")
		Exit Function
	End If
	Wait 1
		
	Err.Clear
	objDiscontinueReason.Set "Discontinue Medication"
'	objDiscontinueReason.click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail","Expected Result:Discontinued Date field is set; Actual Result: Discontinued Date field was not set ")
		Exit Function
	End If
	Wait 1
		
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 

	Call WriteToLog("Pass","Validated medication add with only mandatory fields")
	Wait 1		

	'Wait for processing
	Call WaitForProcessing()
	
	Add_Validation_Discontinued = strPrimaryStepsForMedAdd
	
	Execute "Set objPageMedPane_AVD = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objAdd_DiscontinuedDate = Nothing"
	Execute "Set objDiscontinueReason = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"	
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: ValidateMedicationStatus
'Purpose: validate status of medications
'Author: Gregory
'-----------------------------------------------
Function ValidateMedicationStatus(ByVal strStatus, ByVal strMedicationRxNumber, strOutErrorDesc)

	On Error Resume Next
	ValidateMedicationStatus = ""
	strOutErrorDesc = ""
	Err.Clear
	
	Execute "Set objMedStatusDD = "&Environment("WE_MedScr_MedStatusDD") 'Medications Status dropdown
	objMedStatusDD.highlight
	
	'Select required status of medications
	blnReturnValue = selectComboBoxItem(objMedStatusDD, strStatus)
	If not blnReturnValue Then
		strOutErrorDesc = "Unable to select '"&strStatus&"' medication from medication status dropdown"
		Exit Function
	End If
	Call WriteToLog("Pass","Selected '"&strStatus&"' medication from medication status dropdown")
	Wait 2
	
	'Validate medication in the medication table with required status
	blnSelectSpecificMedicationFromMedTable = SelectSpecificMedicationFromMedTable(strMedicationRxNumber,strOutErrorDesc)
	If not blnSelectSpecificMedicationFromMedTable Then 
		ValidateMedicationStatus = "Medication with RxNumber '"&strMedicationRxNumber&"' is NOT available under '"&strStatus&"' medications in MedicationListTable"
	Else
		ValidateMedicationStatus = "Medication with RxNumber '"&strMedicationRxNumber&"' is available under '"&strStatus&"' medications in MedicationListTable"
	End If
	Wait 0,500

	Execute "Set objMedStatusDD = Nothing"
		
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: Add_Validation_MedicationHistoryNotKnown
'Purpose: validate MedicationHistoryNotKnown scenarios
'Author: Gregory
'-----------------------------------------------
Function Add_Validation_MedicationHistoryNotKnown(strOutErrorDesc)

	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
	Add_Validation_MedicationHistoryNotKnown = ""
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add 'Medication History Not Known' while there are active medications. Error message validation
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Trying to add 'Medication History Not Known' while there are active medications
	Call WriteToLog("Info","---Validation -Trying to add 'Medication History Not Known' while there are active medications- Error message validation---")
	
	strLabel = "Medication History Not Known"
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes",strLabel,strOutErrorDesc)

	'Validate error message when tried to add 'Medication History Not Known' while there are active medications
	strValidationMessage = "There is an ACTIVE medication available, you can not add medication record of 'Medication History Not Known"
	blnReturnValue = checkForPopup("Error", "Ok", strValidationMessage , strOutErrorDesc)
	
	If blnReturnValue Then
		Call WriteToLog("Pass","Validated error popup while tried to add 'Medication History Not Known' while there are active medications")
	Else
		strOutErrorDesc = "Unable to validate error popup when tried to add 'Medication History Not Known' while there are active medications"	
		Exit Function
	End If
	Wait 1
		
	'Click Cancel button
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	blnReturnValue = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "Unable to click on Cancel button. "&strOutErrorDesc
		Exit Function
	End If
	wait 1
	
	'Select 'Active' medication status
	Execute "Set objMedStatusDD_MHNKW = "&Environment("WE_MedScr_MedStatusDD") 'Medications Status dropdown
	objMedStatusDD_MHNKW.highlight	
	blnReturnValue = selectComboBoxItem(objMedStatusDD_MHNKW, "Active")
	If not blnReturnValue Then
		strOutErrorDesc = "Unable to select 'Active' medication status from medication status dropdown"
		Exit Function
	End If
	Call WriteToLog("Pass","Selected 'Active' medication status from medication status dropdown")
	Wait 2

	'Discontinue all active medications
	Call WriteToLog("Info","---Discontinue all active medications---")
	
'	Execute "Set objMedicationTable_MHNKW = "&Environment("WT_MedicationTable") 
	Execute "Set objMedicationTable_MHNKW = "&Environment("WT_MedicationReviewMedTable") 
	intTotalLabels = objMedicationTable_MHNKW.RowCount	
		
	For intLabels = 1 To intTotalLabels Step 1	
		Err.Clear
		objMedicationTable_MHNKW.highlight
		
		Setting.WebPackage("ReplayType") = 2
'		objMedicationTable_MHNKW.ChildItem(1,2,"WebElement",0).FireEvent "onClick"
		objMedicationTable_MHNKW.ChildItem(1,3,"WebElement",0).FireEvent "onClick"
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click on medicine labels in Medication list table"
			Exit Function
		End If 
		Setting.WebPackage("ReplayType") = 1
		
		dtDiscontinuedDate = DateAdd("d",-1,Date)
		strDiscontinuedReason = "Reason for discontinued"
		blnDiscontinueMedication = DiscontinueMedication(dtDiscontinuedDate,strDiscontinuedReason,strOutErrorDesc)
		If not blnDiscontinueMedication Then
			strOutErrorDesc = "Medication "&intLabels&" is not discontinued. "&Err.Description
			Exit Function
		Else 
			Call WriteToLog("PASS","Medication "&intLabels&" is discontinued.")	
		End If	
		
		Execute "Set objMedicationTable_MHNKW = Nothing"
'		Execute "Set objMedicationTable_MHNKW = "&Environment("WT_MedicationTable") 
		Execute "Set objMedicationTable_MHNKW = "&Environment("WT_MedicationReviewMedTable") 
		Wait 1
		
	Next
	Call WriteToLog("Pass","Successfully discontinued all active medications")
	Wait 1
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add 'Medication History Not Known' after discontinuing all active medications
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	Call WriteToLog("Info","---Validation -Add 'Medication History Not Known' discontinuing all active medications---")
	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn

	strLabel = "Medication History Not Known"
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	strFrequency = "AS NEEDED"

	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes",strLabel,strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500

	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500

	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500

	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, strFrequency)
	If not blnFreqSelect Then	
		strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500

	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Added 'Medication History Not Known' discontinuing all active medications")
	Wait 2
	
	'Wait for processing
	Call WaitForProcessing()

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add new medication when 'Medication History Not Known' is present - Error messsage validation
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Trying to add new medication when 'Medication History Not Known' is present-Error messsage validation--") 	
	
	Execute "Set objMedAddBtn_DM= "&Environment("WEL_MedAddBtn") ''Medications Add Button
	'Clk Medications Add button
	Err.Clear
	blnClickAdd = ClickButton("Add",objMedAddBtn_PSA,strOutErrorDesc)
	If not blnClickAdd Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Validate error message when tried to add new medication when 'Medication History Not Known' is present
	strValidationMessage = "An ACTIVE record of 'Medication History Not Known' already exists, you cannot add a new medication without discontinuing 'Medication History Not Known'"
	blnReturnValue = checkForPopup("Error", "Ok", strValidationMessage , strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Validated error popup while tried to add new medication when 'Medication History Not Known' was present")
	Else
		strOutErrorDesc = "Unable to validate error popup while tried to add new medication when 'Medication History Not Known' was present"	
		Exit Function
	End If
	Wait 1
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - Add new medication after discontinuing 'Medication History Not Known'
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Add medication after discontinuing 'Medication History Not Known'---") 	
	
	dtDiscontinuedDate = DateAdd("d",-1,Date)
	strDiscontinuedReason = "Reason for discontinued"
	blnDiscontinueMedication = DiscontinueMedication(dtDiscontinuedDate,strDiscontinuedReason,strOutErrorDesc)
	If not blnDiscontinueMedication Then
		strOutErrorDesc = "Medication "&intLabels&" is not discontinued. "&Err.Description
		Exit Function
	Else 
		Call WriteToLog("PASS","Medication "&intLabels&" is discontinued.")	
	End If	
	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
		
	'Clk Medications Cancel button
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1

	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 

	Call WriteToLog("Pass","Validated medication add with only mandatory fields")
	Wait 1		
	
	Add_Validation_MedicationHistoryNotKnown = strPrimaryStepsForMedAdd

	'Wait for processing
	Call WaitForProcessing()
	
	Execute "Set objPageMedPane_MHNKW = Nothing"
	Execute "Set objMedicationTable_MHNKW = Nothing"
	Execute "Set objMedStatusDD_MHNKW = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objCancelMed = Nothing"
	Execute "Set objMedSavbtn = Nothing"
		
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: DiscontinueMedication
'Purpose: Discontinue Medication with date and reason
'Author: Gregory
'-----------------------------------------------
Function DiscontinueMedication(ByVal dtDiscontinuedDate,ByVal strDiscontinuedReason, strOutErrorDesc)	
		
	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
	DiscontinueMedication = False

	Execute "Set objDiscontinuedDate = " &Environment("WE_DicontinueDate") 'Discountinued Date
	Execute "Set objDiscontinueReason = " &Environment("WE_DicontinueReason") 'Discontinue Reason
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn		
	
	'Clk Medications Edit button
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	objEditMed.highlight
	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
	If not blnClickEdit Then
		strOutErrorDesc = "Unable to click Edit button. "&strOutErrorDesc
		Exit Function
	End If
	wait 2
	
	Err.Clear
	objDiscontinuedDate.Set dtDiscontinuedDate	
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set discontinued date"
		Exit Function
	End If
	Call WriteToLog("Pass","Discontinued date is set as "&dtDiscontinuedDate)
	wait 0,500
	
	Err.Clear
	objDiscontinueReason.Set strDiscontinuedReason
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set discontinued reason"
		Exit Function
	End If
	Call WriteToLog("Pass","Discontinued reason is set")
	wait 0,500		
	
	'Clk Save button for medications.
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	blnReturnValue = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "Unable to click on Save button. "&strOutErrorDesc
		Exit Function
	End If
	
	'Wait for processing
	Call WaitForProcessing()
	
	DiscontinueMedication = True
	
	Set objEditMed = Nothing
	Set objDiscontinuedDate = Nothing
	Set objDiscontinueReason = Nothing

End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: ValidateAllEditedMedicationEntries
'Purpose: Validate All Edited Medication Entries
'Author: Gregory
'-----------------------------------------------
Function ValidateAllEditedMedicationEntries(ByVal strMedicationEditDetails, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	
	arrMedicationEditDetails = Split(strMedicationEditDetails,",",-1,1)
	
	strDiscontinuedReason = arrMedicationEditDetails(0)
	intDose = arrMedicationEditDetails(1)
	strUnit = arrMedicationEditDetails(2)
	strFrequencyValue = arrMedicationEditDetails(3)
	strRoute = arrMedicationEditDetails(4)
	strPrescName = arrMedicationEditDetails(5)
	strPrescNPI = arrMedicationEditDetails(6)
	strIndication = arrMedicationEditDetails(7)
	strSubstitute = arrMedicationEditDetails(8)
	strOrderNotes = arrMedicationEditDetails(9)
	
	'Validate Dose value
	blnValidateDose = ValidateMedicationEntry(intDose)
	If not blnValidateDose Then
		strOutErrorDesc = "Dose is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Dose in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Unit
	blnValidateUnit = ValidateMedicationEntry(strUnit)
	If not blnValidateUnit Then
		strOutErrorDesc = "Unit is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Unit in saved medication entry")
	End If
	Wait 0,250
	
	'Validate frequency value
	blnValidateFrequencyValue = ValidateMedicationEntry(strFrequencyValue)
	If not blnValidateFrequencyValue Then
		strOutErrorDesc = "Frequency is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Frequency in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Route
	blnValidateRoute = ValidateMedicationEntry(strRoute)
	If not blnValidateRoute Then
		strOutErrorDesc = "Route is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Validated Route in saved medication entry")
	End If
	Wait 0,250
	
	'Validate indication
	blnValidateIndication = ValidateMedicationEntry(strIndication)
	If not blnValidateIndication Then
		strOutErrorDesc = "Indication is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Indication in saved medication entry")
	End If
	Wait 0,250
	
	'Validate substitute
	blnValidateSubstitute = ValidateMedicationEntry(strSubstitute)
	If not blnValidateSubstitute Then
		strOutErrorDesc = "Substitute is note available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Substitute in saved medication entry")
	End If
	Wait 0,250
	
	'Validate order notes
	blnValidateOrderNotes = ValidateMedicationEntry(strOrderNotes)
	If not blnValidateOrderNotes Then
		strOutErrorDesc = "OrderNotes is note available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated OrderNotes in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Presc NPI
	blnValidatePrescNPI = ValidateMedicationEntry(strPrescNPI)
	If not blnValidatePrescNPI Then
		strOutErrorDesc = "PrescNPI is not available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated PrescNPI in saved medication entry")
	End If
	Wait 0,250
	
	'Validate Presc Name
	blnValidatePrescName= ValidateMedicationEntry(strPrescName)
	If not blnValidatePrescName Then
		strOutErrorDesc = "PrescName is note available in saved medication entry"
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Validated Presc Name in saved medication entry")
	End If
	Wait 0,250	

End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: EditMedicationWithAllDetails
'Purpose: Edit Medication With All Details
'Author: Gregory
'-----------------------------------------------
Function EditMedicationWithAllDetails(ByVal strMedicationEditDetails, ByVal dtDiscontinuedDate, strOutErrorDesc)	   
	  
	On Error Resume Next
	Err.Clear
	EditMedicationWithAllDetails = False
	strOutErrorDesc = ""
	
	Execute "Set objPageMedPane_Edit = "&Environment("WPG_AppParent") 'PageObject
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications		
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn	
	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
	Execute "Set objIndication = "&Environment("WE_MedScr_Indication_Ed")
	Execute "Set objSubstitute = "&Environment("WE_MedScr_Substitute_Ed")
	Execute "Set objOrderNotes = "&Environment("WE_MedScr_OrderNotes")
	Execute "Set objPrescNPI = "&Environment("WE_MedScr_PrescNPI")
	Execute "Set objPrescName = "&Environment("WE_MedScr_PrescName")
	Execute "Set objMapDiagnosis = "&Environment("WE_MedScr_MapDiagnosis_Ed")	
	
	Set objUnit = objPageMedPane_Edit.WebElement("class:=pull-right caretbutton","html tag:=DIV","visible:=True","index:=2")

	arrMedicationEditDetails = Split(strMedicationEditDetails,",",-1,1)
	
	strDiscontinuedReason = arrMedicationEditDetails(0)
	intDose = arrMedicationEditDetails(1)
	strUnit = arrMedicationEditDetails(2)
	strFrequencyValue = arrMedicationEditDetails(3)
	strRoute = arrMedicationEditDetails(4)
	strPrescName = arrMedicationEditDetails(5)
	strPrescNPI = arrMedicationEditDetails(6)
	strIndication = arrMedicationEditDetails(7)
	strSubstitute = arrMedicationEditDetails(8)
	strOrderNotes = arrMedicationEditDetails(9)

	Call WriteToLog("Info","---Validation - Edit button functionality---")
	'Clk Medications Edit button
	Err.Clear
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	objEditMed.highlight
	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
	If not blnClickEdit Then
		strOutErrorDesc = "Unable to click Edit button. "&strOutErrorDesc
		Exit Function
	End If
	wait 2	
	Call WriteToLog("Pass","Valdated edit button functionality")
	
	'Set dose value
	blnMedPaneValues = MedPaneValues("dose", intDose, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500		
	
	'Select Unit	
	objUnit.highlight
	blnUnit = selectComboBoxItem(objUnit, strUnit)
	If not blnUnit Then
		strOutErrorDesc = "Unable to select Unit value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Unit")
	End If
	wait 0,500
	
	'Select frequency
	blnFrequency = selectComboBoxItem(objMedFreq, strFrequencyValue)
	If not blnFrequency Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
		
	'Select Route
	blnRoute = selectComboBoxItem(objRoute,strRoute)
	If not blnRoute Then
		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Route")
	End If
	wait 0,500

	'Set PrescNPI value
	Err.Clear
	objPrescNPI.Set strPrescNPI
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set PrescNPI value. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set PrescNPI value")
	End If
	wait 0,500
	
	'Set PrescName
	Err.Clear
	objPrescName.Set strPrescName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set PrescName value. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set PrescName value")
	End If
	wait 0,500	

	'Select indication value
	objIndication.Click
	For d = 1 To 50 Step 1
		sendkeys ("{DEL}")
	Next
	Wait 1
	blnSelectDropdownItemBySendingKeys = SelectDropdownItemBySendingKeys("EditInd",objIndication,strIndication,strOutErrorDesc)
	If not blnSelectDropdownItemBySendingKeys Then
		strOutErrorDesc = "Unable to select Indication value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	End If
	Wait 0,500
	
	'Validate MapDiagnosis value
	If Instr(1,strIndication,Trim(objMapDiagnosis.GetROProperty("outertext")),1) <= 0 Then
		strOutErrorDesc = "Map Diagnosis value is not shown as expected"
		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
	Else
		Call WriteToLog("Pass","Map Diagnosis value is shown as expected")	
	End If
	Wait 0,500
	
	'Select substitute value
	objSubstitute.Click
	For d = 1 To 50 Step 1
		sendkeys ("{DEL}")
	Next
	Wait 1
	blnSelectDropdownItemBySendingKeys = SelectDropdownItemBySendingKeys("EditSub",objSubstitute,strSubstitute,strOutErrorDesc)
	If not blnSelectDropdownItemBySendingKeys Then
		strOutErrorDesc = "Unable to select Substitute value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	End If
	Wait 0,500
	
	'Set value for order notes
	Err.Clear
	objOrderNotes.Set strOrderNotes
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set value for OrderNotes. "&Err.Description
		Call WriteToLog("Fail",strOutErrorDesc)
	'	Exit Function
	Else
		Call WriteToLog("Pass","Successfully set Order Notes value")
	End If
	Wait 0,500
	
	'Save Medication
	Call WriteToLog("Info","---Validation - Save button functionality---") 
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Validated Save button functionality and Saved newly added medication")
	
	'Wait for processing
	Call WaitForProcessing()
	
	EditMedicationWithAllDetails = True
	
	Execute "Set objPageMedPane_Edit = Nothing"
	Execute "Set objEditMed = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objRoute = Nothing"
	Execute "Set objIndication = Nothing"
	Execute "Set objSubstitute = Nothing"
	Execute "Set objOrderNotes = Nothing"
	Execute "Set objPrescNPI = Nothing"
	Execute "Set objPrescName = Nothing"
	Execute "Set objMapDiagnosis = Nothing"
	Set objUnit = Nothing
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: Edit_Validation_Discontinued
'Purpose: Edit discont scenarios
'Author: Gregory
'-----------------------------------------------
Function Edit_Validation_Discontinued(ByVal strRxNumberForEdit, ByVal dtDiscontinuedDate, ByVal strDiscontinuedReason, strOutErrorDesc)

	On Error Resume Next
	Edit_Validation_Discontinued = ""
	strOutErrorDesc = ""
	Err.Clear	
	
	Execute "Set objPageMedPane_Edit_AVD = "&Environment("WPG_AppParent") 'PageObject
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn	
	
	'Select required medication under active medication list
	strToBeEditedMedication = ValidateMedicationStatus("Active",strRxNumberForEdit,strOutErrorDesc)
	If Instr(1,strToBeEditedMedication,"NOT available",1) > 0 Then
		strOutErrorDesc = "Unable to select medication to be edited from active list of Medications"
	Else
		Call WriteToLog("Pass","Selected medication to be edited from active list of Medications")
	End If
	Wait 1
	
	'Clk Medications Edit button
	Err.Clear	
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	objEditMed.highlight
	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
	If not blnClickEdit Then
		strOutErrorDesc = "Unable to click Edit button. "&strOutErrorDesc
		Exit Function
	End If
	wait 2
	
	Err.Clear
	Execute "Set objEdit_DiscontinuedDate = " &Environment("WE_DicontinueDate") 'Discountinued Date at medication edit
	objEdit_DiscontinuedDate.Set dtDiscontinuedDate	
	If Err.Number <> 0 Then
		strOutErrorDesc ="Unable to set Discontinued Date"
		Exit Function
	End If
	Call WriteToLog("Pass","Edited Discontinued Date to "&dtDiscontinuedDate)
	Wait 1
		
	Err.Clear
	Execute "Set objDiscontinueReason = " &Environment("WE_DicontinueReason") 'Discontinue Reason
	objDiscontinueReason.Set strDiscontinuedReason
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Discontinued Reason"
		Exit Function
	End If
	Call WriteToLog("Pass","Edited Discontinued Reason to "&strDiscontinuedReason)
	Wait 1
	
	'Save Medication
	Call WriteToLog("Info","---Validation - Save button functionality---") 
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 

	Edit_Validation_Discontinued = strRxNumberForEdit
	
	'Wait for processing
	Call WaitForProcessing()
	
	Execute "Set objPageMedPane_Edit_AVD = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objEdit_DiscontinuedDate = Nothing"
	Execute "Set objDiscontinueReason = Nothing"
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: Edit_Mandatory_Frequency_Dose_Route
'Purpose: validate -Edit mandatory, freq, dose, route, scenarios
'Author: Gregory
'-----------------------------------------------
Function Edit_Mandatory_Frequency_Dose_Route(strOutErrorDesc)

	On Error Resume Next
	Edit_Mandatory_Frequency_Dose_Route = False
	strOutErrorDesc = ""
	Err.Clear	
	
	'---------------------------------------------------------
	'Validate - Edit ESA medication without dose - should save
	'---------------------------------------------------------
	Call WriteToLog("Info","---Validation - Edit ESA medication without dose - should save medication---") 
	
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
		
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	
	'Wait for processing
	Call WaitForProcessing()
	
	'select medication for edit
	strRxNumber = strPrimaryStepsForMedAdd
	blnSelectSpecificMedicationFromMedTable = SelectSpecificMedicationFromMedTable(strRxNumber,strOutErrorDesc)
	If not blnSelectSpecificMedicationFromMedTable  Then
		strOutErrorDesc = "Unable to select medication for edit"
		Exit Function
	End If
	Call WriteToLog("Pass","Selected medication for editing")	
	Wait 1

	'Clk Medications Edit button
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	objEditMed.highlight
	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
	If not blnClickEdit Then
		strOutErrorDesc = "Unable to click Edit button. "&strOutErrorDesc
		Exit Function
	End If
	wait 2	
	
	'Remove default value of Dose - keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Cleared Dose value")
	End If
	wait 0,500	
	
	sedkeys("{TAB}")
	Wait 0,500
	
	'Save Medication
	Execute "Set objMedSavbtn = Nothing"	
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	Call WriteToLog("Info","---Validation - Save button functionality---") 
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Wait 2
	
	'Wait for processing
	Call WaitForProcessing()
	
	'------------------------------------------------------------------------------------------------------------
	'Validate - Edit nonESA medication without dose and Route not as 'TP'- should not save - error msg validation
	'------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Edit nonESA medication without dose and Route not as 'TP'- should not save - error msg validation---") 
	
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objRoute = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	Execute "Set objEditMed = Nothing"
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
	strLabel = "Ace Aerosol Cloud Enhancer Miscellaneous"
	
	'Clk Medications Cancel button
	Err.Clear
	If objCancelMed.Exist(1) Then	
		blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
		If not blnClickCancel Then
			strOutErrorDesc = "Unable to click Cancel button"
			Exit Function
		End If
	End If
	Wait 1
	
	'Add nonESA medication with dose value 1
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("No",strLabel,strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Value for dose
	blnMedPaneValues = MedPaneValues("dose",1, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500	
	
	'Select Route
	blnRoute = selectComboBoxItem(objRoute, "TP")
	If not blnRoute Then
		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Route")
	End If
	wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved NonESA medication with Route as 'TP' and without providing Dose")
	
	'Wait for processing
	Call WaitForProcessing()	
	
	'select medication for edit
	strRxNumber = strPrimaryStepsForMedAdd
	blnSelectSpecificMedicationFromMedTable = SelectSpecificMedicationFromMedTable(strRxNumber,strOutErrorDesc)
	If not blnSelectSpecificMedicationFromMedTable  Then
		strOutErrorDesc = "Unable to select medication for edit"
		Exit Function
	End If
	Call WriteToLog("Pass","Selected medication for editing")	
	Wait 1
	
	'Clk Medications Edit button
	Err.Clear
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	objEditMed.highlight
	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
	If not blnClickEdit Then
		strOutErrorDesc = "Unable to click Edit button. "&strOutErrorDesc
		Exit Function
	End If
	wait 2	
	
	'Remove default value of Dose - keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Select Route (not tp)
	Execute "Set objRoute = Nothing"
	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
	blnRoute = selectComboBoxItem(objRoute, "SL")
	If not blnRoute Then
		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Route")
	End If
	wait 0,500
	
	'Save Medication
	Execute "Set objMedSavbtn = Nothing"	
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	Call WriteToLog("Info","---Validation - Save button functionality---") 
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Wait 2
	
		blnDateValidationErrorPP = checkForPopup("Error", "Ok", "Dose is Required", strOutErrorDesc)
		If not blnDateValidationErrorPP Then
			strOutErrorDesc = "Unable to validate error message for edited medication(having Frequency not as SLIDING SCALE and Route not as TP) by removing Dose value"
			Exit Function
		End If
		Call WriteToLog("Pass","Validated error message for edited medication(having Frequency not as SLIDING SCALE and Route not as TP) by removing Dose value")
		Wait 1
		
	'---------------------------------------------------------------------------------------------------------------------------
	'Validate - Edit nonESA medication without dose and Frequency not as 'SLIDING SCALE'- should not save - error msg validation
	'---------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Edit nonESA medication without dose and Frequency not as 'SLIDING SCALE'- should not save - error msg validation---") 	
	
	'Clk Medications Cancel button
	Execute "Set objCancelMed = Nothing"
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1
	
	Execute "Set objEditMed = Nothing"
	Err.Clear
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	objEditMed.highlight
	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
	If not blnClickEdit Then
		strOutErrorDesc = "Unable to click Edit button. "&strOutErrorDesc
		Exit Function
	End If
	wait 2	
	
	'Remove default value of Dose - keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Select frequency (not sliding scale)	
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500	
	
	'Select Route (not tp)
	Execute "Set objRoute = Nothing"
	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
	blnRoute = selectComboBoxItem(objRoute, "SL")
	If not blnRoute Then
		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Route")
	End If
	wait 0,500
	
	'Save Medication
	Execute "Set objMedSavbtn = Nothing"	
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	Call WriteToLog("Info","---Validation - Save button functionality---") 
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Wait 2
	
		blnDateValidationErrorPP = checkForPopup("Error", "Ok", "Dose is Required", strOutErrorDesc)
		If not blnDateValidationErrorPP Then
			strOutErrorDesc = "Unable to validate error message for edited medication(having Frequency not as SLIDING SCALE and Route not as TP) by removing Dose value"
			Exit Function
		End If
		Call WriteToLog("Pass","Validated error message for edited medication(having Frequency not as SLIDING SCALE and Route not as TP) by removing Dose value")
		Wait 1

	'---------------------------------------------------------------------------------------------------------------------------
	'Validate - Edit nonESA medication without dose and Route as TP- should not save - error msg validation
	'---------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validation - Edit nonESA medication without dose and Route as TP- should not save - error msg validation---") 
	'Clk Medications Cancel button
	Execute "Set objCancelMed = Nothing"
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn	
	Err.Clear
	blnClickCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickCancel Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	Wait 1
	
	Execute "Set objEditMed = Nothing"
	Err.Clear
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	objEditMed.highlight
	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
	If not blnClickEdit Then
		strOutErrorDesc = "Unable to click Edit button. "&strOutErrorDesc
		Exit Function
	End If
	wait 2	
	
	'Remove default value of Dose - keep dose as empty
	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
	If not blnMedPaneValues Then
		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Provided required value for Dose")
	End If
	wait 0,500	
	
	'Select frequency	
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500	
	
	'Select Route
	Execute "Set objRoute = Nothing"
	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
	blnRoute = selectComboBoxItem(objRoute, "TP")
	If not blnRoute Then
		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
		Call WriteToLog("Fail",strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("Pass","Selected required value for Route")
	End If
	wait 0,500
	
	'Save Medication
	Execute "Set objMedSavbtn = Nothing"	
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	Call WriteToLog("Info","---Validation - Save button functionality---") 
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Wait 2
	
	'Wait for processing
	Call WaitForProcessing()		
		
		'FREQUENCY DROPDOWN IS NOT FUNCTIONING PROPERLY FOR THE TOOL
		
'	'---------------------------------------------------------------------------------------------------------------------------
'	'Validate - Edit nonESA medication without dose and Frequency as 'SLIDING SCALE'- should not save - error msg validation
'	'---------------------------------------------------------------------------------------------------------------------------
'	Call WriteToLog("Info","---Validation - Edit nonESA medication without dose and Frequency as 'SLIDING SCALE'- should not save - error msg validation---")
'	
'	'select medication for edit
'	strRxNumber = strPrimaryStepsForMedAdd
'	blnSelectSpecificMedicationFromMedTable = SelectSpecificMedicationFromMedTable(strRxNumber,strOutErrorDesc)
'	If not blnSelectSpecificMedicationFromMedTable  Then
'		strOutErrorDesc = "Unable to select medication for edit"
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Selected medication for editing")	
'	Wait 1
'	
'	Execute "Set objEditMed = Nothing"
'	Err.Clear
'	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
'	objEditMed.highlight
'	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
'	If not blnClickEdit Then
'		strOutErrorDesc = "Unable to click Edit button. "&strOutErrorDesc
'		Exit Function
'	End If
'	wait 2	
'	
'	'Remove default value of Dose - keep dose as empty
'	blnMedPaneValues = MedPaneValues("dose",, strOutErrorDesc)
'	If not blnMedPaneValues Then
'		strOutErrorDesc = "Unable to provide values for required textbox. "&strOutErrorDesc
'		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
'	Else
'		Call WriteToLog("Pass","Provided required value for Dose")
'	End If
'	wait 0,500	
'	
'	'Select frequency	
'	Execute "Set objMedFreq = Nothing"
'	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
'	Execute "Set objMedFreqDDlist = "&Environment("WE_MedFrequencyDDlist")
'	strFreqToSelect = "SLIDING SCALE"
'	
'	blnSelectFrequencyFromLongDD = SelectFrequencyFromLongDD(objMedFreq,objMedFreqDDlist,strFreqToSelect)	
''	blnFreqSelect = selectComboBoxItem(objMedFreq, "SLIDING SCALE")
''	If not blnFreqSelect Then	
'	If not blnSelectFrequencyFromLongDD Then	
'	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
'		Exit Function
'	End If 
'	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
'	Wait 0,500	
'	
'	'Select Route
'	Execute "Set objRoute = Nothing"
'	Execute "Set objRoute = "&Environment("WB_MedScr_Route")
'	blnRoute = selectComboBoxItem(objRoute, "SL")
'	If not blnRoute Then
'		strOutErrorDesc = "Unable to select Route value. "&strOutErrorDesc
'		Call WriteToLog("Fail",strOutErrorDesc)
'		Exit Function
'	Else
'		Call WriteToLog("Pass","Selected required value for Route")
'	End If
'	wait 0,500
'	
'	'Save Medication
'	Execute "Set objMedSavbtn = Nothing"	
'	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
'	Call WriteToLog("Info","---Validation - Save button functionality---") 
'	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
'	If not blnClickSave Then
'		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
'		Exit Function
'	End If 
'	Wait 2
'	
'	'Wait for processing
'	Call WaitForProcessing()
	
	
	Edit_Mandatory_Frequency_Dose_Route = True
		
	Execute "Set objEditMed = Nothing"
	Execute "Set objCancelMed = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objRoute = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: ValidateReviewFunctionality
'Purpose: validate -Review medication
'Author: Gregory
'-----------------------------------------------
Function ValidateReviewFunctionality(strOutErrorDesc)

	On Error Resume Next
	ValidateReviewFunctionality = False
	strOutErrorDesc = ""
	Err.Clear
	
	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject
	
	'Validating Review check boxes on Medication add
	'----------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Validating Review check boxes on Medication add---") 

	'Checking review chk box, if it is available under review col of mediaction lable table
	'Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
	Execute "Set objMedTable = "&Environment("WT_MedicationReviewMedTable")
	If objMedTable.Exist(2) Then
		strRCBstatusNew = objMedTable.ChildItem(1,1,"WebElement",0).GetROProperty("outerhtml")
		intChkStatusNew = Instr(1,strRCBstatusNew,"check-yes ng-hide",1)
		intMedTableRowCount = objMedTable.RowCount
		If intMedTableRowCount > 0 AND intChkStatusNew > 0 Then 
			Err.clear
			objMedTable.ChildItem(1,1,"WebElement",0).Click
		End If
	End If
	
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to select existing review check box "&Err.Description
		Exit Function
	ElseIf intChkStatusNew <= 0 Then
		Call WriteToLog("Pass","There are no review check boxes existing")
	Else
		Call WriteToLog("Pass","Selected existing review check box")
	End If

	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	dtWrittenDate = DateAdd("d",-1,Date)
	dtFilledDate = DateAdd("d",-1,Date)
		
	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
	If strPrimaryStepsForMedAdd = "" Then
		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
	wait 0,500
	
	'Value for Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set for medication")
	Wait 0,500
	
	'Select required frequency
	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 

	'Wait for processing
	Call WaitForProcessing()	
	
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	
	Err.Clear
	Execute "Set objPage_Review = Nothing"	
	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject	
	Set objMedTable = Nothing
	strRCBstatusAtAdd = ""
	intCkdStatusAtAdd = 0
	intChkStatusAtAddValue = 0
	'Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
	Execute "Set objMedTable = "&Environment("WT_MedicationReviewMedTable")
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
			strOutErrorDesc = "Some Checkboxes are cleared after adding new medication"
			Exit Function
		ElseIf intChkStatusAtAddValue < intMedTableRowCount Then
			Call WriteToLog("Pass","Med Review checkboxes which were selected earlier are not cleared after adding new medication")
		End If	
	'if there were no medications (i.e intChkStatusNew < = 0) prior to this new medication added now, then only check the availability of review chkboxes at adding new medication
	End If
	Call WriteToLog("Pass","Med Review checkboxes available at adding new medication")
	Wait 1
	
	'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validating Medication Review header and order of check boxes
	Call WriteToLog("Info","---Validating Medication Review header and order of check boxes---")
	
	RxNumber = strPrimaryStepsForMedAdd
	Execute "Set objPage_Review = Nothing"	
	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject	
	Set objMedTable = Nothing
	'Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
	Execute "Set objMedTable = "&Environment("WT_MedicationReviewMedTable")
	intMedTableRowCount = objMedTable.RowCount
	For intMedTableRow =1 To intMedTableRowCount Step 1
		Setting.WebPackage("ReplayType") = 2
		objMedTable.ChildItem(intMedTableRow,3,"WebElement",0).FireEvent "onClick"
		Setting.WebPackage("ReplayType") = 1
		If objPage_Review.WebElement("class:=left font-weight-bold ng-binding","html tag:=SPAN","outertext:="&RxNumber,"visible:=True").Exist(0.25) Then
			Err.Clear
			objMedTable.ChildItem(intMedTableRow,1,"WebElement",0).Click
		End If
	Next
	
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click medication review chkbox "&Err.Description
		Exit Function
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
			arrckdLabelName(j) = Trim(objMedTable.ChildItem(intMedTableRow,3,"WebElement",0).GetROProperty("outertext"))
			j=j+1
			'print "Ckd"
		End If
	Next
	
	intCkdLabelCount = Ubound(arrckdLabelName)+1
	intUnCkdLabelCount = intMedTableRowCount-intCkdLabelCount 
	
	Err.clear
	Execute "Set objMedTitleTable = "&Environment("WT_MedTitleTable") 'Mediaction table title web table
	Set objReviewTabForMedTable = objMedTitleTable.Link("html tag:=A","outertext:=Reviewed","visible:=True") ' Review header of Medication label name table
	Execute "Set objOrderArrow = "&Environment("WEL_OrderArrow") 'Arrow btn in review header
	Do Until objOrderArrow.Exist(1)
		Setting.WebPackage("ReplayType") = 2
		objReviewTabForMedTable.FireEvent "onClick"
		Setting.WebPackage("ReplayType") = 1
	Loop 
	
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click medication review header sorting arrow btn "&Err.Description
		Exit Function
	Else 
		Call WriteToLog("Pass","Medication review header is properly displayed, sorting arrow button on header is active and is clicked for sorting")
	End If
	
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validating Medication Review check boxes oder - Ascending
	Call WriteToLog("Info","---Validating Medication Review check boxes oder - Ascending---")
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
		strOutErrorDesc = "Medication review check boxes are NOT sorted in ascending order"
		Exit Function	
	End If
	Wait 1
	
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validating Medication Review check boxes - Descending
	Call WriteToLog("Info","---Validating Medication Review check boxes - Descending---")
	
	Execute "Set objMedTitleTable = Nothing"
	Set objReviewTabForMedTable = Nothing
	Execute "Set objMedTitleTable = "&Environment("WT_MedTitleTable") 'Mediaction table title web table
	Set objReviewTabForMedTable = objMedTitleTable.Link("html tag:=A","outertext:=Reviewed","visible:=True") ' Review header of Medication label name table
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
		strOutErrorDesc = "Medication review check boxes are NOT sorted in descending order"
		Exit Function	
	End If
	wait 2
	
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validating Medication Review check boxes - After completing review
	Call WriteToLog("Info","---Validating Medication Review check boxes - After completing review---")
	'Clk on Med Review add btn
	Err.Clear
	Execute "Set objMedicationReviewAdd = "&Environment("WB_MedicationReviewAdd") 'Review add btn
	objMedicationReviewAdd.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to clk on Medication Review Add button "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Medication Review Add button is clicked")
	wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2
	
	'Set Med Review date
	Err.Clear
	Execute "Set objMedReviewDate = "&Environment("WE_MedReviewDate") 'Review date btn
	objMedReviewDate.Set dtMedReviewDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set Med Review date "&Err.Description
		Exit Function
	Else 
		Call WriteToLog("Pass","Med Review date is set")
	End If
	Wait 1
	
	'Clk on Med Review save btn
	Err.Clear
	Execute "Set objMedReviewSave = "&Environment("WEL_MedReviewSave") 'Review save btn
	objMedReviewSave.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to clk on Medication Review Save button "&Err.Description
		Exit Function
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
		strOutErrorDesc = "Some Checkboxes are not cleared after reviewing medication"
		Exit Function
	End If
	Wait 1	
		

	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Re-check review check boxes for validating review cgech box status after medication edit 
	'Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
	Execute "Set objMedTable = "&Environment("WT_MedicationReviewMedTable")
	If objMedTable.Exist(2) Then
		strRCBstatusNew = objMedTable.ChildItem(1,1,"WebElement",0).GetROProperty("outerhtml")
		intChkStatusNew = Instr(1,strRCBstatusNew,"check-yes ng-hide",1)
		intMedTableRowCount = objMedTable.RowCount
		If intMedTableRowCount > 0 AND intChkStatusNew > 0 Then 
			Err.clear
			objMedTable.ChildItem(1,1,"WebElement",0).Click
		End If
	End If
	Wait 1
	
	'Validating Medication Review check boxes while editing existing medication (should not be cleared)
	Call WriteToLog("Info","---Validating Medication Review check boxes while editing existing medication---")
	'click required review chk box
	
	Set objMedTable = Nothing
	Execute "Set objPage_Review = Nothing"	
	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject	
	'Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
	Execute "Set objMedTable = "&Environment("WT_MedicationReviewMedTable")
	intMedTableRowCount = objMedTable.RowCount
	For intMedTableRow =1 To intMedTableRowCount Step 1
		Setting.WebPackage("ReplayType") = 2
		objMedTable.ChildItem(intMedTableRow,3,"WebElement",0).FireEvent "onClick"
		Setting.WebPackage("ReplayType") = 1
		err.clear
		If objPage_Review.WebElement("class:=left font-weight-bold ng-binding","html tag:=SPAN","outertext:="&RxNumber,"visible:=True").Exist(0.25) Then
			objMedTable.ChildItem(intMedTableRow,1,"WebElement",0).Click
		End If
	Next

	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click medication review chkbox "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked medication review chkbox of required medication")
	Wait 2
	
	'Click on Edit button
	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
	objEditMed.highlight
	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
	If not blnClickEdit Then
		strOutErrorDesc = "Unable to click Medication Edit Btn: "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Clicked Medication Edit Btn")
	Wait 2
	
	'Select required frequency
	Execute "Set objFreq = Nothing"
	Execute "Set objFreq = "&Environment("WEL_MedFreq") 'Frequency for medications
	blnFreqSelect = selectComboBoxItem(objFreq, "AS NEEDED")
	If not blnFreqSelect Then	
	    strOutErrorDesc = "Unable to select frequency"
		Exit Function
	End If 
	Call WriteToLog("Pass","Selected frequency value for editing medication")	
	wait 1
	
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Saving edited medication
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to save medication. "&strOutErrorDesc
		Call Terminator
	End If 
	Call WriteToLog("Pass","Saved newly added medication")
	wait 2
	
	WaitForProcessing()
	Wait 2
	
	Set objMedTable = Nothing
	Execute "Set objPage_Review = Nothing"	
	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject
	'Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
	Execute "Set objMedTable = "&Environment("WT_MedicationReviewMedTable")
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
		strOutErrorDesc = "Some Checkboxes are cleared after editing existing medication"
		Exit Function
	ElseIf intChkStatus2value < intMedTableRowCount Then
		Call WriteToLog("Pass","Med Review Checkboxes are not cleared after editing existing medication")
	End If
	
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validating Medication Review check boxes while Cancelling patient medication
	Call WriteToLog("Info","---Validating Medication Review check boxes while Cancelling patient medication---")
	
	'Clk Medications Add button 
	Set objMedAddBtn = Nothing
	Execute "Set objMedAddBtn = " &Environment("WEL_MedAddBtn") 'Medication Add btn
	blnClickAdd = ClickButton("Add",objMedAddBtn,strOutErrorDesc)
	If not blnClickAdd Then
		strOutErrorDesc = "Unable to click Add button for medications "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Add button for medications")
	Wait 2
	
	'Click on Cancel button
	Set objCancelMed = Nothing
	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn
	blnClickedCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
	If not blnClickedCancel Then
		strOutErrorDesc = "Unable to click Cancel button for medications "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Clicked Cancel button for medications")
	Wait 2
	
	Set objMedTable = Nothing
	Execute "Set objPage_Review = Nothing"	
	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject
	'Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
	Execute "Set objMedTable = "&Environment("WT_MedicationReviewMedTable")
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
		strOutErrorDesc = "Some Checkboxes are cleared after cancelling medication"
		Exit Function
	ElseIf intCkdStatus3value < intMedTableRowCount Then	
		Call WriteToLog("Pass","Med Review Checkboxes are not cleared after cancelling medication add/edit")
	End If
	Wait 5
	
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'Validating Medication Review check boxes while switching screens
	Call WriteToLog("Info","---Validating Medication Review check boxes while switching screens---")
	'Click on Pharmacist med review tab
	Err.Clear
	Execute "Set objPharmacistMedReviewTab = "&Environment("WEL_PharmacistMedReviewTab") 'Phamacist med review tab
	objPharmacistMedReviewTab.Click
	If err.number <> 0 Then
		strOutErrorDesc ="Unable to click Pharmacist MedReview tab "&Err.Description
		Exit Function
	Else 
		Call WriteToLog("Pass","Clicked 'Pharmacist MedReview' tab")
	End If
	wait 5
	
	Call waitTillLoads("Loading...")
	Wait 2
	Call ClosePopups()
	
	'cLick on Review tab
	Err.Clear
	Execute "Set objReviewTab = "&Environment("WEL_ReviewTab") 'Review tab
	objReviewTab.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click Review tab "&Err.Description
		Exit Function
	Else 
		Call WriteToLog("Pass","Clicked 'Review' tab")
	End If
	wait 5
	
	Call waitTillLoads("Loading...")
	Wait 2
	Call ClosePopups()
	
	Set objMedTable = Nothing
	Execute "Set objPage_Review = Nothing"	
	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject
	'Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
	Execute "Set objMedTable = "&Environment("WT_MedicationReviewMedTable")
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
		strOutErrorDesc = "Some Checkboxes are cleared after switching screens"
		Call Terminator
	ElseIf intCkdStatus4value < intMedTableRowCount Then	
		Call WriteToLog("Pass","Checkboxes are not be cleared after switching screens")
	End If
	
	Wait 5

	ValidateReviewFunctionality = True

	Execute "Set objPage_Review = Nothing"		
	Execute "Set objEditMed = Nothing"
	Execute "Set objMedAddBtn = Nothing"
	Execute "Set objCancelMed = Nothing"
	Execute "Set objMedicationReviewAdd = Nothing"
	Execute "Set objMedReviewDate = Nothing"
	Execute "Set objMedReviewSave = Nothing"
	Execute "Set objPharmacistMedReviewTab = Nothing"
	Execute "Set objReviewTab = Nothing"
	Execute "Set objOrderArrow = Nothing"
	Execute "Set objMedTitleTable = Nothing"
	Set objReviewTabForMedTable = Nothing	

End Function
'Function ValidateReviewFunctionality(strOutErrorDesc)
'
'	On Error Resume Next
'	ValidateReviewFunctionality = False
'	strOutErrorDesc = ""
'	Err.Clear
'	
'	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject	
'	
'	'Validating Review check boxes on Medication add
'	'----------------------------------------------------------------------------------------------------------------
'	Call WriteToLog("Info","---Validating Review check boxes on Medication add---") 
'
'	'Checking review chk box, if it is available under review col of mediaction lable table
'	Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
'	If objMedTable.Exist(2) Then
'		strRCBstatusNew = objMedTable.ChildItem(1,1,"WebElement",0).GetROProperty("outerhtml")
'		intChkStatusNew = Instr(1,strRCBstatusNew,"check-yes ng-hide",1)
'		intMedTableRowCount = objMedTable.RowCount
'		If intMedTableRowCount > 0 AND intChkStatusNew > 0 Then 
'			Err.clear
'			objMedTable.ChildItem(1,1,"WebElement",0).Click
'		End If
'	End If
'	
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to select existing review check box "&Err.Description
'		Exit Function
'	ElseIf intChkStatusNew <= 0 Then
'		Call WriteToLog("Pass","There are no review check boxes existing")
'	Else
'		Call WriteToLog("Pass","Selected existing review check box")
'	End If
'
'	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
'	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
'	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
'	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
'	dtWrittenDate = DateAdd("d",-1,Date)
'	dtFilledDate = DateAdd("d",-1,Date)
'		
'	strPrimaryStepsForMedAdd = PrimaryStepsForMedAdd("Yes","Epogen",strOutErrorDesc)
'	If strPrimaryStepsForMedAdd = "" Then
'		strOutErrorDesc = "Unable to complete prilimary stepts for medication add. "&strOutErrorDesc
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Priliminary steps for adding medication done successfully")
'	wait 0,500
'	
'	'Value for Medications WrittenDate
'	Err.clear
'	objWrittenDate.Set dtWrittenDate
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to set written date "&Err.Description
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Written date is set for medication")
'	Wait 0,500
'	
'	'Value for Medications FilledDate 
'	Err.clear
'	objFilledDate.Set dtFilledDate
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to set filled date "&Err.Description
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Filled date is set for medication")
'	Wait 0,500
'	
'	'Select required frequency
'	blnFreqSelect = selectComboBoxItem(objMedFreq, "AS NEEDED")
'	If not blnFreqSelect Then	
'	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
'		Exit Function
'	End If 
'	Call WriteToLog("Pass","' "&strFrequencyValue&"' frequency value is selected for new medication")	
'	Wait 0,500
'	
'	'Save new Medication
'	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
'	If not blnClickSave Then
'		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
'		Exit Function
'	End If 
'
'	'Wait for processing
'	Call WaitForProcessing()	
'	
'	Execute "Set objWrittenDate = Nothing"
'	Execute "Set objFilledDate = Nothing"
'	Execute "Set objMedFreq = Nothing"
'	Execute "Set objMedSavbtn = Nothing"
'	
'	Err.Clear
'	Execute "Set objPage_Review = Nothing"	
'	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject	
'	Set objMedTable = Nothing
'	strRCBstatusAtAdd = ""
'	intCkdStatusAtAdd = 0
'	intChkStatusAtAddValue = 0
'	Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
'	intMedTableRowCount = objMedTable.RowCount
'	
'	'if there were medications (i.e intChkStatusNew > 0) prior to this new medication added now, then only check whether med review chkboxes are not cleared at adding new medication
'	If intChkStatusNew > 0 Then
'	
'		For rcMedTable = 1 To intMedTableRowCount Step 1
'			strRCBstatusAtAdd = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
'			intChkStatusAtAdd = Instr(1,strRCBstatusAtAdd,"check-yes ng-hide",1)
'			If intChkStatusAtAdd > 0 Then
'				intChkStatusAtAddValue = intChkStatusAtAddValue+1
'			End If
'		Next
'		
'		If intChkStatusAtAddValue = intMedTableRowCount Then
'			strOutErrorDesc = "Some Checkboxes are cleared after adding new medication"
'			Exit Function
'		ElseIf intChkStatusAtAddValue < intMedTableRowCount Then
'			Call WriteToLog("Pass","Med Review checkboxes which were selected earlier are not cleared after adding new medication")
'		End If	
'	'if there were no medications (i.e intChkStatusNew < = 0) prior to this new medication added now, then only check the availability of review chkboxes at adding new medication
'	End If
'	Call WriteToLog("Pass","Med Review checkboxes available at adding new medication")
'	Wait 1
'	
'	'-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validating Medication Review header and order of check boxes
'	Call WriteToLog("Info","---Validating Medication Review header and order of check boxes---")
'	
'	RxNumber = strPrimaryStepsForMedAdd
'	Execute "Set objPage_Review = Nothing"	
'	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject	
'	Set objMedTable = Nothing
'	Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
'	intMedTableRowCount = objMedTable.RowCount
'	For intMedTableRow =1 To intMedTableRowCount Step 1
'		Setting.WebPackage("ReplayType") = 2
'		objMedTable.ChildItem(intMedTableRow,2,"WebElement",0).FireEvent "onClick"
'		Setting.WebPackage("ReplayType") = 1
'		If objPage_Review.WebElement("class:=left font-weight-bold ng-binding","html tag:=SPAN","outertext:="&RxNumber,"visible:=True").Exist(0.25) Then
'			Err.Clear
'			objMedTable.ChildItem(intMedTableRow,1,"WebElement",0).Click
'		End If
'	Next
'	
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to click medication review chkbox "&Err.Description
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Clicked medication review chkbox of required medication")
'	Wait 1
'	
'	'Getting Label Count (and Names) of Checked and Unchecked medications
'	Err.Clear
'	Dim arrckdLabelName()
'	intMedTableRow = 1
'	j=0
'	For intMedTableRow = 1 To intMedTableRowCount Step 1
'		strRCBstatus = objMedTable.ChildItem(intMedTableRow,1,"WebElement",0).GetROProperty("outerhtml")
'		If Instr(1,strRCBstatus,"ng-hide",1) Then
'			'print "Unckd"
'		Else
'			ReDim Preserve arrckdLabelName(j)
'			arrckdLabelName(j) = Trim(objMedTable.ChildItem(intMedTableRow,2,"WebElement",0).GetROProperty("outertext"))
'			j=j+1
'			'print "Ckd"
'		End If
'	Next
'	
'	intCkdLabelCount = Ubound(arrckdLabelName)+1
'	intUnCkdLabelCount = intMedTableRowCount-intCkdLabelCount 
'	
'	Err.clear
'	Execute "Set objMedTitleTable = "&Environment("WT_MedTitleTable") 'Mediaction table title web table
'	Set objReviewTabForMedTable = objMedTitleTable.Link("html tag:=A","outertext:=Reviewed","visible:=True") ' Review header of Medication label name table
'	Execute "Set objOrderArrow = "&Environment("WEL_OrderArrow") 'Arrow btn in review header
'	Do Until objOrderArrow.Exist(1)
'		Setting.WebPackage("ReplayType") = 2
'		objReviewTabForMedTable.FireEvent "onClick"
'		Setting.WebPackage("ReplayType") = 1
'	Loop 
'	
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to click medication review header sorting arrow btn "&Err.Description
'		Exit Function
'	Else 
'		Call WriteToLog("Pass","Medication review header is properly displayed, sorting arrow button on header is active and is clicked for sorting")
'	End If
'	
'	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validating Medication Review check boxes oder - Ascending
'	Call WriteToLog("Info","---Validating Medication Review check boxes oder - Ascending---")
'	'Check checkBox order ascending 
'	UnCkdCount = 0
'	For ordercount = 1 To intUnCkdLabelCount Step 1
'		strRCBstatus = objMedTable.ChildItem(ordercount,1,"WebElement",0).GetROProperty("outerhtml")
'		If Instr(1,strRCBstatus,"ng-hide",1) Then
'			UnCkdCount = UnCkdCount+1
'		End If
'	Next
'	
'	If UnCkdCount = intUnCkdLabelCount Then
'		Call WriteToLog("Pass","Validated medication review check boxes ascending order")
'	Else
'		strOutErrorDesc = "Medication review check boxes are NOT sorted in ascending order"
'		Exit Function	
'	End If
'	Wait 1
'	
'	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validating Medication Review check boxes - Descending
'	Call WriteToLog("Info","---Validating Medication Review check boxes - Descending---")
'	
'	Execute "Set objMedTitleTable = Nothing"
'	Set objReviewTabForMedTable = Nothing
'	Execute "Set objMedTitleTable = "&Environment("WT_MedTitleTable") 'Mediaction table title web table
'	Set objReviewTabForMedTable = objMedTitleTable.Link("html tag:=A","outertext:=Reviewed","visible:=True") ' Review header of Medication label name table
'	'Check checkBox order descending 
'	objReviewTabForMedTable.Click
'	CkdCount = 0
'	For ordercount = 1 To intCkdLabelCount Step 1
'		strRCBstatus = objMedTable.ChildItem(ordercount,1,"WebElement",0).GetROProperty("outerhtml")
'		If not Instr(1,strRCBstatus,"ng-hide",1) Then
'			CkdCount = CkdCount+1
'		End If
'	Next
'	If CkdCount = intCkdLabelCount Then
'		Call WriteToLog("Pass","Validated medication review check boxes descending order")
'	Else
'		strOutErrorDesc = "Medication review check boxes are NOT sorted in descending order"
'		Exit Function	
'	End If
'	wait 2
'	
'	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validating Medication Review check boxes - After completing review
'	Call WriteToLog("Info","---Validating Medication Review check boxes - After completing review---")
'	'Clk on Med Review add btn
'	Err.Clear
'	Execute "Set objMedicationReviewAdd = "&Environment("WB_MedicationReviewAdd") 'Review add btn
'	objMedicationReviewAdd.Click
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to clk on Medication Review Add button "&Err.Description
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Medication Review Add button is clicked")
'	wait 2
'	
'	Call waitTillLoads("Loading...")
'	Wait 2
'	
'	'Set Med Review date
'	Err.Clear
'	Execute "Set objMedReviewDate = "&Environment("WE_MedReviewDate") 'Review date btn
'	objMedReviewDate.Set dtMedReviewDate
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to set Med Review date "&Err.Description
'		Exit Function
'	Else 
'		Call WriteToLog("Pass","Med Review date is set")
'	End If
'	Wait 1
'	
'	'Clk on Med Review save btn
'	Err.Clear
'	Execute "Set objMedReviewSave = "&Environment("WEL_MedReviewSave") 'Review save btn
'	objMedReviewSave.Click
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to clk on Medication Review Save button "&Err.Description
'		Exit Function
'	Else 
'		Call WriteToLog("Pass","Medication Review Save button is clicked")
'	End If
'	wait 2
'	
'	Call waitTillLoads("Loading...")
'	Wait 2
'	
'	Err.Clear
'	strRCBstatus1 = ""
'	intCkdStatus1 = 0
'	intChkStatus1value = 0
'	For rcMedTable = 1 To intMedTableRowCount Step 1
'		strRCBstatus1 = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
'		intCkdStatus1 = Instr(1,strRCBstatus1,"check-yes ng-hide",1)
'		If intCkdStatus1 > 0 Then
'			intChkStatus1value = intChkStatus1value+1
'		End If
'	Next
'	
'	If intChkStatus1value = 0 OR intChkStatus1value = "" Then
'		Call WriteToLog("Pass","Med Review Checkboxes are cleared after reviewing medication")
'	ElseIf intChkStatus1value < intMedTableRowCount Then
'		strOutErrorDesc = "Some Checkboxes are not cleared after reviewing medication"
'		Exit Function
'	End If
'	Wait 1	
'		
'
'	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Re-check review check boxes for validating review cgech box status after medication edit 
'	Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
'	If objMedTable.Exist(2) Then
'		strRCBstatusNew = objMedTable.ChildItem(1,1,"WebElement",0).GetROProperty("outerhtml")
'		intChkStatusNew = Instr(1,strRCBstatusNew,"check-yes ng-hide",1)
'		intMedTableRowCount = objMedTable.RowCount
'		If intMedTableRowCount > 0 AND intChkStatusNew > 0 Then 
'			Err.clear
'			objMedTable.ChildItem(1,1,"WebElement",0).Click
'		End If
'	End If
'	Wait 1
'	
'	'Validating Medication Review check boxes while editing existing medication (should not be cleared)
'	Call WriteToLog("Info","---Validating Medication Review check boxes while editing existing medication---")
'	'click required review chk box
'	
'	Set objMedTable = Nothing
'	Execute "Set objPage_Review = Nothing"	
'	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject	
'	Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
'	intMedTableRowCount = objMedTable.RowCount
'	For intMedTableRow =1 To intMedTableRowCount Step 1
'		Setting.WebPackage("ReplayType") = 2
'		objMedTable.ChildItem(intMedTableRow,2,"WebElement",0).FireEvent "onClick"
'		Setting.WebPackage("ReplayType") = 1
'		err.clear
'		If objPage_Review.WebElement("class:=left font-weight-bold ng-binding","html tag:=SPAN","outertext:="&RxNumber,"visible:=True").Exist(0.25) Then
'			objMedTable.ChildItem(intMedTableRow,1,"WebElement",0).Click
'		End If
'	Next
'
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to click medication review chkbox "&Err.Description
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Clicked medication review chkbox of required medication")
'	Wait 2
'	
'	'Click on Edit button
'	Execute "Set objEditMed = "&Environment("WEL_MedEdit") 'Edit button for medications	
'	objEditMed.highlight
'	blnClickEdit = ClickButton("Edit",objEditMed,strOutErrorDesc)
'	If not blnClickEdit Then
'		strOutErrorDesc = "Unable to click Medication Edit Btn: "&Err.Description
'		Exit Function
'	End If 
'	Call WriteToLog("Pass","Clicked Medication Edit Btn")
'	Wait 2
'	
'	'Select required frequency
'	Execute "Set objFreq = Nothing"
'	Execute "Set objFreq = "&Environment("WEL_MedFreq") 'Frequency for medications
'	blnFreqSelect = selectComboBoxItem(objFreq, "AS NEEDED")
'	If not blnFreqSelect Then	
'	    strOutErrorDesc = "Unable to select frequency"
'		Exit Function
'	End If 
'	Call WriteToLog("Pass","Selected frequency value for editing medication")	
'	wait 1
'	
'	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Saving edited medication
'	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
'	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
'	If not blnClickSave Then
'		strOutErrorDesc = "Unable to save medication. "&strOutErrorDesc
'		Call Terminator
'	End If 
'	Call WriteToLog("Pass","Saved newly added medication")
'	wait 2
'	
'	WaitForProcessing()
'	Wait 2
'	
'	Set objMedTable = Nothing
'	Execute "Set objPage_Review = Nothing"	
'	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject
'	Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
'	intMedTableRowCount = objMedTable.RowCount
'	
'	Err.Clear
'	strRCBstatus2 = ""
'	intCkdStatus2 = 0
'	intChkStatus2value = 0
'	For rcMedTable = 1 To intMedTableRowCount Step 1
'		strRCBstatus2 = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
'		intChkStatus2 = Instr(1,strRCBstatus2,"check-yes ng-hide",1)
'		If intChkStatus2 > 0 Then
'			intChkStatus2value = intChkStatus2value+1
'		End If
'	Next
'	
'	If intChkStatus2value = intMedTableRowCount Then
'		strOutErrorDesc = "Some Checkboxes are cleared after editing existing medication"
'		Exit Function
'	ElseIf intChkStatus2value < intMedTableRowCount Then
'		Call WriteToLog("Pass","Med Review Checkboxes are not cleared after editing existing medication")
'	End If
'	
'	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validating Medication Review check boxes while Cancelling patient medication
'	Call WriteToLog("Info","---Validating Medication Review check boxes while Cancelling patient medication---")
'	
'	'Clk Medications Add button 
'	Set objMedAddBtn = Nothing
'	Execute "Set objMedAddBtn = " &Environment("WEL_MedAddBtn") 'Medication Add btn
'	blnClickAdd = ClickButton("Add",objMedAddBtn,strOutErrorDesc)
'	If not blnClickAdd Then
'		strOutErrorDesc = "Unable to click Add button for medications "&Err.Description
'		Exit Function
'	End If
'	Call WriteToLog("Pass","Clicked Add button for medications")
'	Wait 2
'	
'	'Click on Cancel button
'	Set objCancelMed = Nothing
'	Execute "Set objCancelMed = "&Environment("WEL_CancelMed") 'Cancel btn
'	blnClickedCancel = ClickButton("Cancel",objCancelMed,strOutErrorDesc)
'	If not blnClickedCancel Then
'		strOutErrorDesc = "Unable to click Cancel button for medications "&Err.Description
'		Exit Function
'	End If 
'	Call WriteToLog("Pass","Clicked Cancel button for medications")
'	Wait 2
'	
'	Set objMedTable = Nothing
'	Execute "Set objPage_Review = Nothing"	
'	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject
'	Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
'	Err.Clear
'	strRCBstatus3 = ""
'	intCkdStatus3 = 0
'	intCkdStatus3value = 0
'	For rcMedTable = 1 To intMedTableRowCount Step 1
'		strRCBstatus3 = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
'		intChkStatus3 = Instr(1,strRCBstatus3,"check-yes ng-hide",1)
'		If intChkStatus3 > 0 Then
'			intCkdStatus3value = intCkdStatus3value+1
'		End If
'	Next
'	
'	If intCkdStatus3value = intMedTableRowCount Then
'		strOutErrorDesc = "Some Checkboxes are cleared after cancelling medication"
'		Exit Function
'	ElseIf intCkdStatus3value < intMedTableRowCount Then	
'		Call WriteToLog("Pass","Med Review Checkboxes are not cleared after cancelling medication add/edit")
'	End If
'	Wait 5
'	
'	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------
'	'Validating Medication Review check boxes while switching screens
'	Call WriteToLog("Info","---Validating Medication Review check boxes while switching screens---")
'	'Click on Pharmacist med review tab
'	Err.Clear
'	Execute "Set objPharmacistMedReviewTab = "&Environment("WEL_PharmacistMedReviewTab") 'Phamacist med review tab
'	objPharmacistMedReviewTab.Click
'	If err.number <> 0 Then
'		strOutErrorDesc ="Unable to click Pharmacist MedReview tab "&Err.Description
'		Exit Function
'	Else 
'		Call WriteToLog("Pass","Clicked 'Pharmacist MedReview' tab")
'	End If
'	wait 5
'	
'	Call waitTillLoads("Loading...")
'	Wait 2
'	Call ClosePopups()
'	
'	'cLick on Review tab
'	Err.Clear
'	Execute "Set objReviewTab = "&Environment("WEL_ReviewTab") 'Review tab
'	objReviewTab.Click
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to click Review tab "&Err.Description
'		Exit Function
'	Else 
'		Call WriteToLog("Pass","Clicked 'Review' tab")
'	End If
'	wait 5
'	
'	Call waitTillLoads("Loading...")
'	Wait 2
'	Call ClosePopups()
'	
'	Set objMedTable = Nothing
'	Execute "Set objPage_Review = Nothing"	
'	Execute "Set objPage_Review = "&Environment("WPG_AppParent") 'PageObject
'	Set objMedTable = objPage_Review.WebTable("class:=k-selectable","html tag:=TABLE","cols:=9","name:=WebTable","visible:=True")
'	Err.Clear
'	strRCBstatus4 = ""
'	intCkdStatus4 = 0
'	intCkdStatus4value = 0
'	For rcMedTable = 1 To intMedTableRowCount Step 1
'		strRCBstatus4 = objMedTable.ChildItem(rcMedTable,1,"WebElement",0).GetROProperty("outerhtml")
'		intChkStatus4 = Instr(1,strRCBstatus4,"check-yes ng-hide",1)
'		If intChkStatus4 > 0 Then
'			intCkdStatus4value = intCkdStatus4value+1
'		End If
'	Next
'	
'	If intCkdStatus4value = intMedTableRowCount Then
'		strOutErrorDesc = "Some Checkboxes are cleared after switching screens"
'		Call Terminator
'	ElseIf intCkdStatus4value < intMedTableRowCount Then	
'		Call WriteToLog("Pass","Checkboxes are not be cleared after switching screens")
'	End If
'	
'	Wait 5
'
'	ValidateReviewFunctionality = True
'
'	Execute "Set objPage_Review = Nothing"		
'	Execute "Set objEditMed = Nothing"
'	Execute "Set objMedAddBtn = Nothing"
'	Execute "Set objCancelMed = Nothing"
'	Execute "Set objMedicationReviewAdd = Nothing"
'	Execute "Set objMedReviewDate = Nothing"
'	Execute "Set objMedReviewSave = Nothing"
'	Execute "Set objPharmacistMedReviewTab = Nothing"
'	Execute "Set objReviewTab = Nothing"
'	Execute "Set objOrderArrow = Nothing"
'	Execute "Set objMedTitleTable = Nothing"
'	Set objReviewTabForMedTable = Nothing	
'
'End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: DeleteAllAllergies
'Purpose: validate -DeleteAllAllergies
'Author: Gregory
'-----------------------------------------------
Function DeleteAllAllergies()

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	DeleteAllAllergies = False

	Execute "Set objAllergyTable = " &Environment("WT_AgyoldTbl") 'AllergyTable 	
	intAllergyTableRC = objAllergyTable.RowCount
	Call WriteToLog("Pass", "Allergy table contains "&intAllergyTableRC&" allergy details")
	
	Do Until intAllergyTableRC = 0 
	
		Err.Clear
		Set objAllergyDelIcon = objAllergyTable.ChildItem(1,4,"WebElement",0)		
		Err.Clear
		objAllergyDelIcon.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click Delete Allergy Icon : "&" Error returned: " & Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked delete allergy icon")
		Wait 1
		
		'Check whether DeleteAllergy popup exists or not
		blnDeleteAllergyPPok = checkForPopup("Allergy", "Yes", "Are you sure", strOutErrorDesc)
		If not blnDeleteAllergyPPok Then
			strOutErrorDesc = "Delete Allerygy popup is not displayed/not clicked OK"
	  		Exit Function
		End If
		Call WriteToLog("Pass", "Validated allergy deleted message")
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 1
		
		Execute "Set objAllergyTable = Nothing"
		Execute "Set objAllergyTable = " &Environment("WT_AgyoldTbl") 'AllergyTable 	
		intAllergyTableRC = objAllergyTable.RowCount
		If Err.Number <> 0 OR not objAllergyTable.Exist(2) Then
			intAllergyTableRC = 0
		End If

	 Loop
		 
	DeleteAllAllergies = True
	
	Err.Clear
	Execute "Set objAllergyTable = Nothing"
	Execute "Set objAllergyMedDelIcon = Nothing"
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: AllergyDetails
'Purpose: validate -add allergy with all details
'Author: Gregory
'-----------------------------------------------
Function AllergyDetails(ByVal strAllergyClass, ByVal strAllergy, ByVal strSymptom, strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	AllergyTypeSelection = false
	
	Execute "Set objPageMed = "&Environment("WPG_AppParent") 
	Execute "Set objAllergyAddBtn = " & Environment("WB_AddAllerg")
	Set objAllergyTypeTableIcon = objPageMed.WebElement("html tag:=TD","innerhtml:=.*data-capella-automation-id=""label-dataItem\.AllergyType.*","visible:=True")
	Set objAllergyClassDD = objPageMed.WebElement("class:=k-dropdown-wrap.*","html tag:=SPAN","outertext:=AllergyClassselect","visible:=True")
	Set objAllergyDDlist = objPageMed.WebElement("html tag:=DIV","outerhtml:=.*class=""k-list k-reset"" id=""medicationAllergyTpeDD_listbox.*","outertext:=AllergyClassMedication","visible:=True")
	Execute "Set objAlrgyNamTxtBx = " & Environment("WEL_AlrgyNamTxtBx")
	Set objSymptonTextSpace = objPageMed.WebElement("html tag:=TD","outerhtml:=.*data-capella-automation-id=""label-dataItem\.Symptom.*","visible:=True")
	Set objSymptomTxBx= objPage.WebEdit("class:=k-input k-textbox","html tag:=INPUT","outerhtml:=.*input name=""Symptom.*","visible:=True")
	Execute "Set objAlgrySavebtn = " & Environment("WI_AlgrySavebtn")
	
	'Clk Medications Add button for Allergy
	Err.Clear
	blnClickAdd = ClickButton("Add",objAllergyAddBtn,strOutErrorDesc)
	If not blnClickAdd Then
		strOutErrorDesc = "Unable to click Add button for adding new allergy"
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1	
	
	If not strAllergyClass = "" OR not lcase(trim(strAllergyClass)) = "na" Then
	
		Execute "Set objAllergyTable = " &Environment("WT_AgyoldTbl") 'AllergyTable 
		If objAllergyTable.Exist(2) Then				
			intRC = objAllergyTable.RowCount			
			Set objAllergyTypeTableIcon = Nothing
			Set objAllergyClassDD = Nothing
			Set objAlrgyNamTxtBx = Nothing
			Set objSymptonTextSpace = Nothing
			Set objSymptomTxBx= Nothing
			Set objAlgrySavebtn = Nothing			
			Set objAllergyTypeTableIcon = objPageMed.WebElement("html tag:=TD","innerhtml:=.*data-capella-automation-id=""label-dataItem\.AllergyType.*","visible:=True","index:="&intRC-1)
			Set objAllergyClassDD = objPageMed.WebElement("class:=k-dropdown-wrap.*","html tag:=SPAN","outertext:=AllergyClassselect","visible:=True","index:="&intRC-1)
			Set objAlrgyNamTxtBx = objPageMed.WebElement("html tag:=TD","innerhtml:=.*AllergyName.*","innertext:=","outerhtml:=.*AllergyName.*","outertext:=","visible:=True","index:="&intRC-1)
			Set objSymptonTextSpace = objPageMed.WebElement("html tag:=TD","outerhtml:=.*data-capella-automation-id=""label-dataItem\.Symptom.*","visible:=True","index:="&intRC-1)
			Set objSymptomTxBx= objPageMed.WebEdit("class:=k-input k-textbox","html tag:=INPUT","outerhtml:=.*Symptom.*","visible:=True","index:="&intRC-1)
'			Set objAlgrySavebtn = objPageMed.Image("file name:=icon_vh_saveSmall.*","html tag:=IMG","name:=Image","outerhtml:=.*saveAllergy.*","visible:=True")
			Execute "Set objAlgrySavebtn = " & Environment("WI_AlgrySavebtn")
		End If

		Err.Clear
		objAllergyTypeTableIcon.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click AllergyTypeTableIcon"
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked AllergyTypeTable icon")
		Wait 1
		
		Err.Clear
		objAllergyClassDD.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click AllergyClass dropdown"
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked AllergyClass dropdown")
		Wait 1
			
		Set AgyTp = Description.Create
		AgyTp("micclass").Value = "WebElement"
		AgyTp("class").Value = "k-item.*"
		AgyTp("class").regularexpression = true
		AgyTp("html tag").Value = "LI"
		AgyTp("outertext").Value = ".*" & strAllergyClass & ".*"
		AgyTp("outertext").regularexpression = true
		Set objAllergyType = objAllergyDDlist.ChildObjects(AgyTp)
		
		For iAgTy = 0 To objAllergyType.Count-1 Step 1
			Err.Clear
			objAllergyType(iAgTy).Click
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to select allergy type"
				Exit Function
			End If
			Call WriteToLog("Pass", "Selected "&strAllergyClass&" as allergy class")
			Exit For
		Next
		
		Wait 1
	
	End If
	
	Wait 1
	blnSelectDropdownItemBySendingKeys = SelectDropdownItemBySendingKeys("Allergy",objAlrgyNamTxtBx,strAllergy,strOutErrorDesc)
	If blnSelectDropdownItemBySendingKeys Then
		Call WriteToLog("Pass","Selected "&strAllergy&" from allergy dropdown")
	Else
		strOutErrorDesc = strAllergy&" is not present in allergy dropdown"
		Exit Function
	End If
	wait 1
	
	Set Wshell = CreateObject("WScript.Shell")
	Wshell.SendKeys"{TAB}"
	Wait 1
	
	If not strSymptom = "" OR not lcase(trim(strSymptom)) = "na" Then
	
		Err.Clear
		objSymptonTextSpace.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click SymptonTextSpace"
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked SymptonText space")
		Wait 1
		
		Err.Clear
		objSymptomTxBx.Set strSymptom
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set Sympton"
			Exit Function
		End If
		Call WriteToLog("Pass","Symptom is set as "&strSymptom)
		Wait 1
		
	End If
	
	'Save allergy
	blnClickSave = ClickButton("Save",objAlgrySavebtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for allergy "&Err.Description
		Exit Function
	End If 
	wait 1
	WaitTillLoads "Loading..."
	wait 1
	
	blnSavePP = checkForPopup("Save Allergy ?", "Yes", "Do you want to save allergy choosen ?", strOutErrorDesc)
	If not blnSavePP Then
		strOutErrorDesc = "Failed to save the allergy"
		Exit Function
	End If	
	Call WriteToLog("Pass","Save allergy pop is validated")
	wait 2
	WaitTillLoads "Loading..."
	wait 1
	
	blnSavePPok = checkForPopup("Changes Saved", "Ok", "Changes saved successfully.", strOutErrorDesc)
	If not blnSavePPok Then
		strOutErrorDesc = "Failed to save the allergy"
		Exit Function
	End If	
	Call WriteToLog("Pass", "Allergy saved successfully.")
	
	AllergyDetails = True

	wait 2
	Set objItems = Nothing
	Set objDropDown = Nothing
	Set objCombo = Nothing
	Set objPageMed = Nothing
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: DeleteAllergy
'Purpose: validate -DeleteAllergy
'Author: Gregory
'-----------------------------------------------
Function DeleteAllergy(ByVal strAllergy, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	DeleteAllergy = False
	
	Execute "Set objAllergyTable = " &Environment("WT_AgyoldTbl") 'AllergyTable 	
	intAllergyTableRC = objAllergyTable.RowCount
	Call WriteToLog("Pass", "Allergy table contains "&intAllergyTableRC&" allergy details")
	
	For r = 1 To intAllergyTableRC Step 1
	
		strAllergyInTable = objAllergyTable.CellText(r,2)
		If instr(1,strAllergyInTable,strAllergy,1) > 0 Then
		
			Set objAllergyDelIcon = objAllergyTable.ChildItem(r,4,"WebElement",0)		
			Err.Clear
			objAllergyDelIcon.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Delete Allergy icon : "&" Error returned: " & Err.Description
				Exit Function
			End If
			Call WriteToLog("Pass", "Clicked delete allergy icon for '"&strAllergy&"' allergy")
			Wait 1
			
			'Check whether DeleteAllergy popup exists or not
			blnDeleteAllergyMedicationPPok = checkForPopup("Allergy", "Yes", "Are you sure", strOutErrorDesc)
			If not blnDeleteAllergyMedicationPPok Then
				strOutErrorDesc = "Delete Allerygy popup is not displayed/not clicked OK"
		  		Exit Function
			End If
			Call WriteToLog("Pass", "Validated allergy deleted message")
			Wait 2
			Call waitTillLoads("Loading...")
			Wait 1
			
			Exit For
			
		End If
						
	Next
	
	DeleteAllergy = True
	
	Execute "Set objAllergyTable = Nothing"
	Execute "Set objAllergyMedDelIcon = Nothing"
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: AllergySort
'Purpose: validate -AllergySort
'Author: Gregory
'-----------------------------------------------
Function AllergySort(ByVal strAllergyType, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	AllergySort = False
	
	set objPageAllergy = getPageObject()	
	Set objAllergySortDD = objPageAllergy.WebButton("class:=btn btn-default dropdown-toggle dropdowndefault","html id:=allergy-dropdown","type:=button","visible:=True")
	
	Execute "Set objAllergyTable = " &Environment("WT_AgyoldTbl") 'AllergyTable 
	
		blnReturnValue = selectComboBoxItem(objAllergySortDD, strAllergyType)
		If not blnReturnValue Then
			strOutErrorDesc = "Unable to select '"&strAllergyType&"' from allergy typedropdown."
			Exit Function
		End If
		Call WriteToLog("Pass","Selected '"&strAllergyType&"' from allergy type dropdown")
		Wait 1
		
		If objAllergyTable.Exist(2) Then				
			
			intAllergyTableRC = objAllergyTable.RowCount
			Call WriteToLog("Pass", "Allergy table contains "&intAllergyTableRC&" allergy details")
			Dim intAllergyCount : intAllergyCount = 0
			
			For r = 1 To intAllergyTableRC Step 1
				strAllergyType = objAllergyTable.CellText(r,1)
				If instr(1,strAllergyType,strAllergyType,1) > 0 Then
					intAllergyCount = intAllergyCount+1
				End If
			Next
			
			If intAllergyCount = intAllergyTableRC Then
				AllergySort = True
				Call WriteToLog("Pass", "Validated Allergy drop down sorting - Allergy table contains details for "&intAllergyTableRC&" allergy(s) of type - "&strAllergyType)
			Else
				strOutErrorDesc = "Allergy sort dropdown validation failed"
				Exit Function
			End If
			
		End If	
		
	Wait 2
	
	set objPageAllergy = Nothing
	Set objAllergySortDD = Nothing
	Execute "Set objAllergyTable = Nothing"

End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: Allergy_Validation_Mandatory
'Purpose: validate -mandatory field
'Author: Gregory
'-----------------------------------------------
Function Allergy_Validation_Mandatory(strOutErrorDesc)	

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	Allergy_Validation_Mandatory = false
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add allergy (of allergy type) without mandatory field (name) - error message validation
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Add allergy (of allergy type) without mandatory field (name) - error message validation---") 
	
	blnAllergyDetails = AllergyDetails("Allergy","",strSymptom,strOutErrorDesc)

	Execute "Set objPageAllergy = "&Environment("WPG_AppParent") 
'	Set objAlgrySavebtn = objPageAllergy.Image("file name:=icon_vh_saveSmall.*","html tag:=IMG","name:=Image","outerhtml:=.*saveAllergy.*","visible:=True")
	Execute "Set objAlgrySavebtn = " & Environment("WI_AlgrySavebtn")

	Set Wshell = CreateObject("WScript.Shell")
	Wshell.SendKeys"{TAB}"
	Wait 1
	'Save allergy
	blnClickSave = ClickButton("Save",objAlgrySavebtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for allergy "&Err.Description
		Exit Function
	End If 
	wait 1
	
	WaitTillLoads "Loading..."
	wait 1
	
	blnSavePP = checkForPopup("Save Allergy ?", "Yes", "Do you want to save allergy choosen ?", strOutErrorDesc)
	If not blnSavePP Then
		strOutErrorDesc = "Failed to save the allergy"
		Exit Function
	End If	
	Call WriteToLog("Pass","Save allergy pop is validated")
	wait 2
	WaitTillLoads "Loading..."
	wait 1
	
	blnSavePP = checkForPopup("Invalid Data", "OK", "Validation Error", strOutErrorDesc)
	If not blnSavePP Then
		strOutErrorDesc = "Failed to validate Error popup when tried to save allergy of allergy type without mandatory field (Name)"
		Exit Function
	End If	
	Call WriteToLog("Pass","Validated Error popup when tried to save allergy of allergy type without mandatory field (Name)")
	wait 2
	
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'*Validation - 'Add allergy (of medication type) without mandatory field (name) - error message validation
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","---Add allergy (of medication type) without mandatory field (name) - error message validation---") 
	
	blnAllergyDetails = AllergyDetails("Medication","",strSymptom,strOutErrorDesc)

	Execute "Set objPageAllergy = Nothing"
	Set objAlgrySavebtn = Nothing	
	Execute "Set objPageAllergy = "&Environment("WPG_AppParent") 
	Execute "Set objAlgrySavebtn = " & Environment("WI_AlgrySavebtn")
'	Set objAlgrySavebtn = objPageAllergy.Image("file name:=icon_vh_saveSmall.*","html tag:=IMG","name:=Image","outerhtml:=.*saveAllergy.*","visible:=True")

	Set Wshell = CreateObject("WScript.Shell")
	Wshell.SendKeys"{TAB}"
	Wait 1
	
	'Save allergy
	blnClickSave = ClickButton("Save",objAlgrySavebtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for allergy "&Err.Description
'		Exit Function
	End If 
	wait 1
	
	WaitTillLoads "Loading..."
	wait 1
	
	blnSavePP = checkForPopup("Save Allergy ?", "Yes", "Do you want to save allergy choosen ?", strOutErrorDesc)
	If not blnSavePP Then
		strOutErrorDesc = "Failed to save the allergy"
		Exit Function
	End If	
	Call WriteToLog("Pass","Save allergy pop is validated")
	wait 2
	WaitTillLoads "Loading..."
	wait 1
	
	blnSavePP = checkForPopup("Invalid Data", "OK", "Validation Error", strOutErrorDesc)
	If not blnSavePP Then
		strOutErrorDesc = "Failed to validate Error popup when tried to save allergy of allergy type without mandatory field (Name)"
		Exit Function
	End If	
	Call WriteToLog("Pass","Validated Error popup when tried to save allergy of medication type without mandatory field (Name)")
	wait 2
	
	Allergy_Validation_Mandatory = True
	
	Execute "Set objPageAllergy = Nothing"
	Set objAlgrySavebtn = Nothing	
	
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: WaitForProcessing
'Purpose: wait for processing
'Author: Gregory
'-----------------------------------------------
Function WaitForProcessing()
	Wait 2
	Dim wt : wt = 0
	Execute "Set objPageMedPane_WFP = "&Environment("WPG_AppParent")	
	Do While objPageMedPane_WFP.WebElement("class:=please-wait-style loading.*","html tag:=SPAN","outertext:=Processing.*","visible:=True").Exist(1)
		Wait 0,500
		wt = wt + 1
		If wt = 200 Then
			Exit Do
		End If
	Loop
	Wait 1
End Function
'--------------------------------------------------------

'-----------------------------------------------
'Function Name: ClosePopups
'Purpose: close all popups in med screen
'Author: Gregory
'-----------------------------------------------
Function ClosePopups()
	
	On Error Resume Next
	Err.Clear

	'Close all available popups
	Call checkForPopup("Some Data May Be Out of Date", "Ok", "", strOutErrorDesc)
	Err.Clear
	strOutErrorDesc = ""
	Wait 2
	Call waitTillLoads("Loading...")
	
	Execute "Set SDMBOFDpptleOK = "&Environment("WB_SDMBOFDpptleOK")
	If SDMBOFDpptleOK.Exist(2) Then
		SDMBOFDpptleOK.Click
		Wait 2
	End If
	
	Call checkForPopup("Disclaimer", "Ok", "", strOutErrorDesc)
	Err.Clear
	strOutErrorDesc = ""
	Wait 2
	Call waitTillLoads("Loading...")
	
	Execute "Set objDisOK = "&Environment("WB_DisclaimerOK")
	If objDisOK.Exist(2) Then
		objDisOK.Click
		Wait 2
	End If
	Call waitTillLoads("Loading...")
	
	'sometimes 'Some Data May Be Out of Date' again appears
	Call checkForPopup("Some Data May Be Out of Date", "Ok", "", strOutErrorDesc)
	Err.Clear
	strOutErrorDesc = ""
	Wait 2
	Call waitTillLoads("Loading...")
	
	Execute "Set objDisOK = Nothing"
	Execute "Set SDMBOFDpptleOK = Nothing"
	
End Function


Function SelectFrequencyFromLongDD(ByVal objDD, ByVal objDDlist, ByVal strItemToSelect)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	SelectFrequencyFromLongDD = False
	
	objDD.highlight
	Err.Clear
'	objDD.Click
	
	Setting.Webpackage("ReplayType")=2
	objDD.FireEvent "onClick"
	Setting.Webpackage("ReplayType")=1	
	
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click required dropdown"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked required dropdown")
	Wait 1
	
	Set oDescExt = Description.Create
	oDescExt("micclass").value = "Link"
	Set objDropDownListItems = objDDlist.ChildObjects(oDescExt)
	intDropDownListItemCount = objDropDownListItems.count
	For intDDitem = 0 To intDropDownListItemCount-1 Step 1 
		Set objRequiredDropDownItem = objDropDownListItems(intDDitem)
		sendKeys("{DOWN}")
		If Instr(1,objRequiredDropDownItem.GetROProperty("outertext"),strItemToSelect,1) > 0 Then
			Err.Clear			
			Setting.Webpackage("ReplayType")=2
			objRequiredDropDownItem.FireEvent "onClick"
			Setting.Webpackage("ReplayType")=1			
'			objRequiredDropDownItem.click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to select '"&strItemToSelect&"' from dropdown. "&Err.Description
				Exit Function
		    End If
		    Call WriteToLog("Pass","Selected '"&strItemToSelect&"' from dropdown")
			Exit For
		End if
		Wait 0,50
	Next
	
	SelectFrequencyFromLongDD = True
	
	Set objDD = Nothing
	Set objDDlist = Nothing
	Set oDescExt = Nothing
	Set objRequiredDropDownItem = Nothing	
	
End Function

'Ends - FUNCTIONS REQUIRED FOR MEDICATION SCREEN AUTOMATION SCRIPT-------------------------------------------
