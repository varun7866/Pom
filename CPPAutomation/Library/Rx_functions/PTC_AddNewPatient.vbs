'===========================================================================================================================================================
'Function Name       :	AddNewPatient
'Purpose of Function :	To add a new patient from the PTC dashboard
'Input Arguments     :	None
'Output Arguments    :	String value gives the implemented freq list
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Pre-requisite		 :  This function occurs for adding a new patient
'Example of Call     :	AddNewPatient(strOutErrorDesc)
'Author				 :  Sharmila
'Date				 :	27-July-2015
'===========================================================================================================================================================
Function AddNewPatient (strOutErrorDesc)

	strOutErrorDesc = ""
	Err.Clear
    On Error Resume Next
	AddNewPatient = False


	Execute "Set objAddress  = " & Environment("WE_Address")
	Execute "Set objCity  = " & Environment("WE_City")
	Execute "Set objState  = " & Environment("WB_StateDropDown")
	Execute "Set objZip  = " & Environment("WE_Zip")
	Execute "Set objHomePhone  = " & Environment("WE_HomePhone")
	Execute "Set objPrimaryPhone  = " & Environment("WB_PrimaryPhoneDropDown")
	Execute "Set objLanguage  = " & Environment("WB_LanguageDropDown")
	Execute "Set objGender  = " & Environment("WB_GenderDropDown")
	Execute "Set objGroupPolicyNumber   = " & Environment("WE_GroupPloicy")
	Execute "Set objSaveNewPatientData   = " & Environment("WEL_NewPatientSaveBtn")
	Execute "Set objAddProgramBtn = " & Environment("WB_AddProgramBtn")
	Execute "Set objPage = " & Environment("WPG_AppParent")

	'Complete the Referral Management, before updating other fields.
	blnReturnValue = PTCReferralManagement(strOutErrorDesc)
	If not blnReturnValue Then
		Call WriteToLog("Fail","Expected Result: Referral Management should be completed successfully; Actual Result: Error in completing Referral Management: "& strOutErrorDesc)
		Exit Function
	End If

	'Set address to Address field
	strAddress = "Test Address"
	Err.Clear
	objAddress.set strAddress
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strAddress & "is set to Address field")
	Else
		Call WriteToLog("Fail", strAddress & "is not set to Address field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Set value to City field
	strCity = "Alpine"
	Err.Clear
	objCity.set strCity
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strCity & "is set to City field")
	Else
		Call WriteToLog("Fail", strCity & "is not set to City field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Select value from State dropdown
	strStateValue = "California"
	blnReturnValue = selectComboBoxItem(objState, strStateValue)
	If blnReturnValue Then
		Call WriteToLog("Pass", strStateValue & " value is selected from Equipment Type field.")
	Else
		Call WriteToLog("Fail", strStateValue & "value is not selected from Equipment Type field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Set value to Zip field
	strZipValue = "91901"
	Err.Clear
	objZip.set strZipValue
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strZipValue & "is set to Zip field")
	Else
		Call WriteToLog("Fail", strZipValue & "is not set to Zip field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Set value to Home Phone field
	Err.Clear
	strHomePhone = "(123)456-7891"
	objHomePhone.set strHomePhone
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strHomePhone & "is set to Home Phone field")
	Else
		Call WriteToLog("Fail", strHomePhone & "is not set to Home Phone field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Select value from Primary Phone field
	strPrimaryPhone = "Home"
	blnReturnValue = selectComboBoxItem(objPrimaryPhone, strPrimaryPhone)
	If blnReturnValue Then
		Call WriteToLog("Pass", strPrimaryPhone & " value is selected from Primary Phone field.")
	Else
		Call WriteToLog("Fail", strPrimaryPhone & "value is not selected from Primary Phone field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Select value from Language field
	strLanguage = "English"
	blnReturnValue = selectComboBoxItem(objLanguage, strLanguage)
	If blnReturnValue Then
		Call WriteToLog("Pass", strLanguage & " value is selected from Language field.")
	Else
		Call WriteToLog("Fail", strLanguage & "value is not selected from Language field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Select value from Gender field
	strGender = "Male"
	blnReturnValue = selectComboBoxItem(objGender, strGender)
	If blnReturnValue Then
		Call WriteToLog("Pass", strGender & " value is selected from Gender field.")
	Else
		Call WriteToLog("Fail", strGender & "value is not selected from Gender field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Set Policy Number to Group/Policy Number field
	Err.Clear
	strGroupPolicyNumber = "123545"
	objGroupPolicyNumber.set strGroupPolicyNumber
	If Err.Number = 0 Then
		Call WriteToLog("Pass",strGroupPolicyNumber & "is set to Group/Policy Number field")
	Else
		Call WriteToLog("Fail", strGroupPolicyNumber & "is not set to Group/Policy Number field. Error Returned :-" & strOutErrorDesc)
		Exit Function
	End If
	
	'Click on the Save button
	blnReturnValue = ClickButton("Save",objSaveNewPatientData,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: Save button clicked;Actual result:Erron clicking button:  " & strOutErrorDesc)
		Exit Function
	End If
	
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	'====================================================================================
	'Testcase - Click on the Save button, without adding the Program.
	'====================================================================================
	Call WriteToLog("Info","==========Testcase - Click on the Save button, without adding the Program.==========")
	
	strValidationMessage = "'Program' should not be null "
	
	
	'click on Complete order button will thrown an error since there date fulfilled is less than date requested.
	blnReturnValue = checkForPopup("Invalid Data", "Ok", strValidationMessage , strOutErrorDesc)
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	If blnReturnValue Then
		Call WriteToLog("Pass","Validation Error:'Program' should not be null should be displayed.")
	Else
		Call WriteToLog("Fail","Expected Result: Popup message for Program is null should be displayed; Actual Result: " & strOutErrorDesc)	
		Exit Function
	End If	
	
	'=============================================================
	'Testcase - Click on the Add Program Button and Add Program
	'=============================================================
	Call WriteToLog("Info","==========Testcase - Click on the Add Program Button and Add Program==========")
	
	'Click on the Add Program button
	blnReturnValue = ClickButton("Add Program",objAddProgramBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Reult: Add Program button was clicked successfully; Actual Result: AddProgram button returned error:  " & strOutErrorDesc)
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Add Program button was clicked successfully")
	
	blnblnReturnValue = AddPTCProgram(strOutErrorDesc)
	
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Reult: Program is added successfully; Actual Result: Unable to Add Program; Error Returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Program was added to the member added successfully")
	
	'Click on the Save button after adding the program
	blnReturnValue = ClickButton("Save",objSaveNewPatientData,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "ClickButton returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	'Check the message box having title as "The Changes have been saved successfully" 
	strMessageTitle = "The Changes have been saved successfully"
	strMessageBoxText = "Member added successfully."
	blnReturnValue = checkForPopup(strMessageTitle, "Ok", strMessageBoxText, strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "CheckMessageBoxExist returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	AddNewPatient = true
	
	Execute "Set objAddress  = Nothing" 
	Execute "Set objCity  = Nothing" 
	Execute "Set objState  = Nothing" 
	Execute "Set objZip  = Nothing" 
	Execute "Set objHomePhone  = Nothing" 
	Execute "Set objPrimaryPhone  = Nothing" 
	Execute "Set objLanguage  = Nothing" 
	Execute "Set objGender  = Nothing" 
	Execute "Set objGroupPolicyNumber = Nothing" 
	Execute "Set objSaveNewPatientData = Nothing" 
	Execute "Set objProgramDropdown = Nothing"
	Execute "Set objReasonDropdown = Nothing"
	Execute "Set objStartDate = Nothing"
	Execute "Set objProgramSaveBtn = Nothing"
	
End Function

'===========================================================================================================================================================
'Function Name       :	AddPTCProgram
'Purpose of Function :	To add a program for a member from PTC
'Input Arguments     :	None
'Output Arguments    :	Returns boolean value
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Pre-requisite		 :  This function occurs for adding a new patient
'Example of Call     :	AddPTCProgram(strOutErrorDesc)
'Author				 :  Sharmila
'Date				 :	27-July-2015
'===========================================================================================================================================================
Function AddPTCProgram(StrOutErrorDesc)
	
	strOutErrorDesc = ""
	Err.Clear
    On Error Resume Next
	AddProgram = False
	
	Execute "Set objPage = " & Environment("WPG_AppParent")
	Execute "Set objProgramDropdown = " & Environment("WEL_ProgramDropDown")
	Execute "Set objReasonDropdown = " & Environment("WEL_ReasonDropDown")
	Execute "Set objStartDate = " & Environment("WE_StartDate")
	Execute "Set objProgramSaveBtn = " & Environment("WB_SaveProgramButton")

	strProgram = DataTable.Value("Program", "CurrentTestCaseData")
	strReason = DataTable.Value("Reason", "CurrentTestCaseData")


	'Click on the Program drop down.
	Set objDropDown = Description.Create
	objDropDown("micclass").Value = "WebButton"
	objDropDown("html id").Value = "resone"
	Set objDDProgram = objProgramDropdown.ChildObjects(objDropDown)
	
		
	blnReturnValue = selectComboBoxItem(objDDProgram(0), strProgram)
	If blnReturnValue Then
		Call WriteToLog("Pass", strProgram & " value is selected from Program field.")
	Else
		Call WriteToLog("Fail", "Expected result: "&strProgram & " value is selected from Program field. Actual Reuslt: Value is not selected from Program field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Click on the Reason drop down.
	Set objDropDownReason = Description.Create
	objDropDownReason("micclass").Value = "WebButton"
	objDropDownReason("html id").Value = "resone"
	Set objDDReason = objReasonDropdown.ChildObjects(objDropDownReason)
	
	'Select Reason Drop down
	blnReturnValue = selectComboBoxItem(objDDReason(0), strReason)
	If blnReturnValue Then
		Call WriteToLog("Pass", strReason & " value is selected from Reason field.")
	Else
		Call WriteToLog("Fail", "Expected result: "&strReason & " value is selected from Reason field. Actual Reuslt: Value is not selected from Reason field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'Set Start Date for the program
	Set objpage = Nothing
    Set objpage = getPageObject()
    objpage.Sync
	Set dateDesc = Description.Create
    dateDesc("micclass").Value = "WebEdit"
    dateDesc("placeholder").Value = "<MM/dd/yyyy>"
    Set objDate = objPage.ChildObjects(dateDesc)
    For i = 0 To objDate.Count - 1
        outerhtml = objDate(i).GetROPRoperty("outerhtml")
       	Print outerhtml
        If instr(outerhtml, "addProgram.myDate") > 0 Then
            objDate(i).highlight
            objDate(i).Set date 
        End If
    Next 
    
    Set dateDesc = Nothing
    Set objDate = Nothing

	'click on the Save button in Add Program
	objProgramSaveBtn.highlight
	If not waitUntilExist(objProgramSaveBtn,10) Then
		Call WriteToLog("Fail", "Expected Result:Start Date field is found; Actual Result:Unable to find the Start Date field; Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	
	blnReturnValue = ClickButton("Save",objProgramSaveBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Reult: Save Program button was clicked successfully; Actual Result: Save button returned error:  " & strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2

	AddProgram = True
	
	Execute "Set objDropDown = Nothing"
	Execute "Set objDDProgram = Nothing"
	Execute "Set objDropDownReason = Nothing"
	Execute "Set objDDReason = Nothing"
	Execute "Set objProgramDropdown = Nothing"
	Execute "Set objReasonDropdown = Nothing"
	Execute "Set objStartDate = Nothing"
	Execute "Set objProgramSaveBtn = Nothing"
	
	
End Function

'===========================================================================================================================================================
'Function Name       :	PTCReferralManagement
'Purpose of Function :	To complete a Referral Management information while adding a new patient from PTC dashboard
'Input Arguments     :	None
'Output Arguments    :	Returns boolean value
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Pre-requisite		 :  This function occurs for adding a new patient
'Example of Call     :	PTCReferralManagement(strOutErrorDesc)
'Author				 :  Sharmila
'Date				 :	27-July-2015
'===========================================================================================================================================================
Function PTCReferralManagement(strOutErrorDesc)

	strOutErrorDesc = ""
	Err.Clear
    On Error Resume Next
	PTCReferralManagement = False


	Execute "Set objReferralManagementTitle = " & Environment("WEL_ReferralManagementTitle")
	Execute "Set objReferralDate = " & Environment("WE_ReferralDate")
	Execute "Set objReferralReceivedDate = " & Environment("WE_ReferralReceivedDate")
	Execute "Set objApplicationDate = " & Environment("WE_ApplicationDate")
	Execute "Set objPayor = " & Environment("WB_PayorDropDown")
	Execute "Set objSaveBtn = " & Environment("WB_NewReferralSave")

	'=============================================
	'Verify the Referral Management Screen Loads
	'=============================================
	Call WriteToLog("Info","==========Testcase - Verify the Referral Management Screen Loads. ==========")
	
	If waitUntilExist(objReferralManagementTitle, 10) Then
		objReferralManagementTitle.highlight
		Call WriteToLog("Pass","Referral Management Screen opened successfully")
	Else
		Call WriteToLog("Fail","Expected Result: Open Referral Management Screen; Actual Result: Unable to open Referral Management Screen")
		Exit Function
	End If
	
	'Set Referral Date
	If waitUntilExist(objReferralDate, 10) Then
		objReferralDate.Set date-5
	End If
	
	
	'Set Referral Received Date
	If waitUntilExist(objReferralReceivedDate, 10) Then
		objReferralReceivedDate.Set date-5
	End If
	
	
	'Set Referral Application Date
	If waitUntilExist(objApplicationDate, 10) Then
		objApplicationDate.Set date-5
	End If
	
	
	'=====================================================
	'Verify the BY default Payor is VillageHealth Program
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify the BY default Payor is VillageHealth Program. ==========")
	If waitUntilExist(objPayor, 10) Then
		strPayorValue = objPayor.getROProperty("innertext")
		If instr(strPayorValue, "VILLAGEHEALTH PROGRAM") > 0 Then
			Call WriteToLog("Pass","By default VillageHealth Program is displayed")
		End If
	Else
		Call WriteToLog("Fail","Expected Result: By default payor should be VillageHealth Program; Actual Result: VillageHealth Program is not set as default payor")
		Exit Function
	End If
	
	'=====================================================
	'Verify the BY default Disease State is ESRD
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify BY default Disease State is ESRD. ==========")
	
	
	Set objDiseaseState = getComboBoxReferralManagement("Disease State")
	strDiseaseStateValue = objDiseaseState.getROProperty("innertext")
	If instr(strDiseaseStateValue, "ESRD") > 0 Then
		Call WriteToLog("Pass","BY default Disease State is ESRD")
	Else
		Call WriteToLog("Fail","Expected Result: BY default Disease State should be ESRD; Actual Result: ESRD is not set as default for Disease State")
	End If
	
	'=====================================================
	'User should be able to select other Disease State
	'=====================================================
	Call WriteToLog("Info","==========Testcase - User should be able to select other Disease State. ==========")
	
	
	blnReturnValue = selectComboBoxItem(objDiseaseState, "CKD")
	If blnReturnValue Then
		Call WriteToLog("Pass", "Value is selected for Disease State field.")
	Else
		Call WriteToLog("Fail", "Expected Result: Value is selected for Disease State Field; Actual Result: Value is not selected from Disease State field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	'=====================================================
	'Verify BY default Line of Business is POS
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify BY default Line of Business is POS. ==========")
	
	
	Set objLOB = getComboBoxReferralManagement("Line Of Buisness")
	strLOBValue = objLOB.getROProperty("innertext")
	If instr(strLOBValue, "POS") > 0 Then
		Call WriteToLog("Pass","BY default Line Of Buisness is POS")
	Else
		Call WriteToLog("Fail","Expected Result: BY default Line of Business should be POS; Actual Result: POS is not set as default for Line Of Business")
	End If
	
	
	'=====================================================
	'User should be able to select other Line Of Business
	'=====================================================
	Call WriteToLog("Info","==========Testcase - User should be able to select other Line Of Business. ==========")
	
	blnReturnValue = selectComboBoxItem(objLOB, "ASO")
	If blnReturnValue Then
		Call WriteToLog("Pass", "Value is selected from Line Of Business field.")
	Else
		Call WriteToLog("Fail", "Expected Result: Value is selected for Line Of Business Field; Actual Result: Value is not selected from Line Of Business field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	
	'=====================================================
	'Verify BY default Service Type is Telephonic
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify BY default Service Type is Telephonic. ==========")
	
	
	Set objServiceType = getComboBoxReferralManagement("ServiceType")
	strServiceTypeValue = objServiceType.getROProperty("innertext")
	If instr(strServiceTypeValue, "Telephonic") > 0 Then
		Call WriteToLog("Pass","BY default Service Type is Telephonic")
	Else
		Call WriteToLog("Fail","Expected Result: BY default Service Type should be Telephonic; Actual Result: Telephonic is not set as default for Service Type")
	End If
	
	
	'=============================================================
	'User should be able to select other values for Service Type
	'=============================================================
	Call WriteToLog("Info","==========Testcase - User should be able to select other values for Service Type. ==========")
	
	blnReturnValue = selectComboBoxItem(objServiceType, "Field")
	If blnReturnValue Then
		Call WriteToLog("Pass", "Value is selected from Service Type field.")
	Else
		Call WriteToLog("Fail", "Expected Result: Value is selected for Disease State Field; Actual Result: Value is not selected from Service Type field. Error returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	'=====================================================
	'Verify BY default Referral Source is Payor Refer File
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify BY default Referral Source is Payor Refer File. ==========")
	
	
	Set objSource = getComboBoxReferralManagement("Source")
	strSourceValue = objSource.getROProperty("innertext")
	If instr(strSourceValue, "Payor Refer File") > 0 Then
		Call WriteToLog("Pass","BY default Source is Payor Refer File")
	Else
		Call WriteToLog("Fail","Expected Result: BY default Source should be Payor Refer File; Actual Result: Payor Refer File is not set as default for Source field")
	End If
	
	'Set the referral source as Case Manager and check the other fields
	blnReturnValue = ValidateReferralSource("Case Manager", strOutErrorDesc )
	If Not blnReturnValue Then
		Call WriteToLog("Fail","Values were not set for Referral Source- Case Manager: "&strOutErrorDesc)
		Exit Function		
	End If
	
	'Set the referral source as Payor representative and check the other fields
	blnReturnValue = ValidateReferralSource("Payor Representative", strOutErrorDesc )
	If Not blnReturnValue Then
		Call WriteToLog("Fail","Values were not set for Referral Source- Case Manager: "&strOutErrorDesc)
		Exit Function	
	End If
	
	'Set the referral source as Personal Nurse and check the other fields
	blnReturnValue = ValidateReferralSource("Personal Nurse", strOutErrorDesc )
	If Not blnReturnValue Then
		Call WriteToLog("Fail","Values were not set for Referral Source- Personal Nurse: "&strOutErrorDesc)
		Exit Function		
	End If
	
	'Set the referral source as Special Project and check the other fields
	blnReturnValue = ValidateReferralSource("Special Project", strOutErrorDesc )
	If Not blnReturnValue Then
		Call WriteToLog("Fail","Values were not set for Referral Source- Case Manager: "&strOutErrorDesc)
		Exit Function		
	End If
	
	'Set the referral source as VillageHealth and check the other fields
	blnReturnValue = ValidateReferralSource("VillageHealth", strOutErrorDesc )
	If Not blnReturnValue Then
		Call WriteToLog("Fail","Values were not set for Referral Source- Case Manager: "&strOutErrorDesc)
		Exit Function		
	End If
	
	'Set the referral source as Provider and check the other fields
	blnReturnValue = ValidateReferralSource("Provider", strOutErrorDesc )
	If Not blnReturnValue Then
		Call WriteToLog("Fail","Values were not set for Referral Source- Case Manager: "&strOutErrorDesc)
		Exit Function		
	End If
	
	'===========================================================
	'Click on the Save button in the Referral Management Screen
	'===========================================================
	Call WriteToLog("Info","==========Testcase - Click on the Save button in the Referral Management Screen. ==========")
	
	blnReturnValue = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: User was able to click on the Save button; Actual Result: User was unable to click on the Save button. Error Returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2

	PTCReferralManagement = true
	
	Execute "Set objReferralManagementTitle = Nothing" 
	Execute "Set objReferralDate = Nothing"
	Execute "Set objReferralReceivedDate = Nothing"
	Execute "Set objApplicationDate = Nothing"
	Execute "Set objPayor = Nothing"
	Execute "Set objSaveBtn = Nothing"

End Function

'===========================================================================================================================================================
'Function Name       :	terminateProgram
'Purpose of Function :	To terminate the program in PTC
'Input Arguments     :	Patient First Name, Last Name, Date of Birth
'Output Arguments    :	Returns boolean value
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Pre-requisite		 :  This function occurs for adding a new patient
'Example of Call     :	isPass = terminateProgram(strPatientFirstName, strPatientLastName, strPatientDOB)
'Author				 :  Sudheer
'Date				 :	04-August-2015
'===========================================================================================================================================================
Function terminateProgram(ByVal strPatientFirstName, ByVal strPatientLastName, ByVal strPatientDOB)
	On Error Resume Next
	Err.Clear
	terminateProgram = false
		
	'Close all open patient     
	isPass = CloseAllOpenPatient(strOutErrorDesc)
	If Not isPass Then
		strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
		Call WriteToLog("Fail", strOutErrorDesc)
		Exit Function
	End If
	
	Call clickOnMainMenu("My Dashboard")
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Call WriteToLog("Info","==========Testcase - Verify that Add New Patient Button exists on the PTC Dashboard.==========")
	
	Execute "Set objPatientInfoScreenTitle = " & Environment("WEL_PatientInfo_Title")
	Execute "Set objPatientFirstName = " & Environment("WE_PatientInfo_FirstName")
	Execute "Set objPatientLastName = " & Environment("WE_PatientInfo_LastName")
	Execute "Set objPatientDOB = " & Environment("WE_PatientInfo_DOB")
	Execute "Set objAddNewPatientButton = " & Environment("WB_AddNewPatient_Button")
	'Verify AddNewPatient Button exists
	If waitUntilExist(objAddNewPatientButton, 10) Then
		Call WriteToLog("Pass", "AddNewPatient button exists")	
	Else
		Call WriteToLog("Fail","Expected Result: AddNewPatient button exist; Actual Result: AddNewPatient button does not exist")
		Exit Function
	End If
	
	'Click on the Ok button of Complete Order pop up
	blnReturnValue = ClickButton("Add New Patient",objAddNewPatientButton,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: Click on the AddNewPatient button; Actual Result: " & strOutErrorDesc)
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	Call WriteToLog("Pass", "AddNewPatient button was clicked successfully")	
	
	'====================================================
	'Verify that Patient Info screen open successfully
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify that Patient Info screen open successfully. ==========")
	
	If waitUntilExist(objPatientInfoScreenTitle, 10) Then
		objPatientInfoScreenTitle.highlight
		Call WriteToLog("Pass","Patient Info Screen opened successfully")
	Else
		Call WriteToLog("Fail","Expected Result: Open Patient Info Screen; Actual Result: Unable to open Patient Info Screen")
		Exit Function
	End If
	
	'==================================================================
	'Search for the patient with FirstName, LastName and DateOfBirth
	'==================================================================
	Call WriteToLog("Info","==========Testcase - Search for the patient with FirstName, LastName and DateOfBirth. ==========")
	
	'Set value for FirstName
	If waitUntilExist(objPatientFirstName, 10) Then
		objPatientFirstName.set strPatientFirstName
	End If
	
	'Set value for LastName
	If waitUntilExist(objPatientLastName, 10) Then
		objPatientLastName.set strPatientLastName
	End If
	
	'Set value for DOB
	If waitUntilExist(objPatientDOB, 10) Then
		objPatientDOB.set strPatientDOB
	End If
	
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	'verify if no matching results found message box existed if no patient found
	isPass = checkForPopup("Error", "Ok", "No matching results found", strOutErrorDesc)
	If isPass Then
	    strOutErrorDesc = "Invalid Member ID"
	    Call WriteToLog("Fail", "The member created was not found during the search.")
	    Exit Function
	End If
	
	'Chk whether PatientSearchResult popup is available
	Execute "Set objPatSeResPP = " & Environment("WEL_PatientSearchResults")
	If not objPatSeResPP.Exist(5) Then
	    Set objPatSeResPP = Nothing    'kill the object
	    strOutErrorDesc = "Unable to find PatientSearchResult popup"
	    Call WriteToLog("Fail", strOutErrorDesc)
	    Exit Function
	End If
	Set objPatSeResPP = Nothing    'kill the object
	Dim reqColumn
	If isMemberId Then
	    reqColumn = 1
	Else 
	    reqColumn = 2
	End If
	
	Set objPage = getPageObject()
	objPage.highlight
	Set objGlobalSearchGrid = objPage.WebElement("html id:=memberSearchResultslist")
	objGlobalSearchGrid.highlight
	
	name = strPatientFirstName & " " & strPatientLastName
	
	Set objtable = objGlobalSearchGrid.WebTable("class:=k-selectable")
	objtable.highlight
	For i = 1 To objtable.getRoProperty("rows")
	    x = objtable.getCellData(i, 3)
	    If lcase(x) = lcase(name) Then
	    	objtable.ChildItem(i, 0, "WebElement", 2).highlight
	        objtable.ChildItem(i, 0, "WebElement", 2).Click
	        Exit For
	    End If
	Next
	wait 2
	'Clk OK for required patient
	Execute "Set PSView = " & Environment("WB_PatientSearchView")
	PSView.highlight
	PSView.Click
	If err.number <> 0 Then
	    Set PSView = Nothing    'kill the object
	    strOutErrorDesc = "Unable to click OK in PatientSearchResult popup : "&" Error returned: " & Err.Description
	    Call WriteToLog("Fail", strOutErrorDesc)
	   	Exit Function
	End If
	Set PSView = Nothing    'kill the object
	
	Set objGlobalSearchGrid = Nothing
	Set tableDesc = Nothing
	Set objtable = Nothing
	Set objPage = Nothing
	
	wait 2
	waitTillLoads "Loading"
	wait 2
	
	'===============================================================
	'Verify that Patient info screen open successfully
	'===============================================================
	'verify patient info screen open successfully
	Execute "Set objPatientInfoScreenTitle = " & Environment("WEL_PatientInfoScreenTitle")
	objPatientInfoScreenTitle.highlight
	
	If CheckObjectExistence(objPatientInfoScreenTitle,20) Then
		Call WriteToLog("Pass","Patient info screen opened successfully")
	Else
		Call WriteToLog("Fail","Patient info screen not opened successfully")
		Exit Function
	End If
	
	Execute "Set objPatientInfoScreenTitle = Nothing"
	
	Set objPage = getPageObject()
	Set objTable = objPage.Webtable("class:=k-selectable", "cols:=6")
	Set objClose = objTable.childitem(1,6, "Image", 0)
	objClose.click
	
	Set objTable = Nothing
	Set objPage = Nothing
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Execute "Set objterminateProgram = " & Environment("WEL_TerminateProgramWindow")
	If not objterminateProgram.WaitProperty("visible", true, 5000) Then
		Call WriteToLog("Fail", "Failed to open the Terminate Program window")
		Exit Function
	End if
	
	'select reason
	Execute "Set objReasonDropDown = " & Environment("WB_TerminateProgramReasonDropDown")
	isPass = selectComboBoxItem(objReasonDropDown, "Patient Request")
	Set objDropDown = Nothing
	
	'select date
	Set objPage = getPageObject()
	Set objCal = objPage.WebEdit("class:=.*ip-cal-0.*", "index:=2")
	objCal.Set date - 3
	Set objPage = Nothing
	Set objCal = Nothing
	
	'click on save button
	Execute "Set objSaveBtn = " & Environment("WB_ProgramTerminateSave")
	objSaveBtn.Click
	
	wait 5
	Call waitTillLoads("Loading...")
	wait 2
	
	'click yes on message box
	isPass = checkForPopup("Terminate Program", "Yes", "This action will terminate the patient. Are you sure you want to continue ?", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to terminate the patient.")
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 5
	
	'validate if status changed to termed
	Set objPage = getPageObject()
	objPage.highlight
	Set objStatus = objPage.WebElement("class:=col-md-7.*", "outerhtml:=.*CurrentEligibilityStatus.*")
	objStatus.highlight
	
	status = objStatus.getROProperty("outertext")
	Print status
	Set objStatus = Nothing
	Set objPage = Nothing
	
	
	If lcase(trim(status)) <> "termed" Then
		Call WriteToLog("Fail", "Patient status is not termed as expected. Status is " & status)
		Exit Function
	End If
	
	terminateProgram = true

End Function
'===========================================================================================================================================================
'Function Name       :	ValidateReferralSource
'Purpose of Function :	To validate Referral Source information while adding a new patient from PTC dashboard
'Input Arguments     :	Referral Source Value (Eg: Provider. Claims, Special Project.. etc)
'Output Arguments    :	Returns boolean value
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Pre-requisite		 :  This function occurs for adding a new patient
'Example of Call     :	ValidateReferralSource("Special Project", strOutErrorDesc )
'Author				 :  Sharmila
'Date				 :	27-July-2015
'===========================================================================================================================================================
Function ValidateReferralSource(ByVal strReferralSourceValue, strOutErrorDesc)
	strOutErrorDesc = ""
	Err.Clear
    On Error Resume Next
	ValidateReferralSource = False
	
	
	Execute "Set objReferrerName = " & Environment("WEL_ReferrerName")
	Execute "Set objReferrerPhone = " & Environment("WEL_ReferrerPhone")
	Execute "Set objReferrerExt = " & Environment("WEL_ReferrerExt")
	Execute "Set objProjectName = " & Environment("WEL_ProjectName")
	Execute "Set objSearchUser = " & Environment("WE_SearchTextbox")
	Execute "Set objSearchButton = " & Environment("WB_SearchButton")
	Execute "Set objVHNPatientsGrid = " & Environment("WEL_VHNPatientsGrid")
	Execute "Set objVHNPatientsTable = " & Environment("WT_VHNPatientsTable")	
	Execute "Set objSelectUserButton = " & Environment("WB_SelectUserButton")
	Set objSource = getComboBoxReferralManagement("Source")
	
	Call WriteToLog("Info","==========Testcase - User should be able to select other values for Referral Source "&strReferralSourceValue&" ==========")
	blnReturnValue = selectComboBoxItem(objSource, strReferralSourceValue)
	If blnReturnValue Then
	 'Based on the selection of the source, other fields should be displayed
		Select Case strReferralSourceValue
			Case "Case Manager","Personal Nurse","Payor Representative"
			'Referral Source is Case Manager or Personal Nurse or Payor Representative,  Referrer Name, Phone and Ext fields should be displayed.
				If waitUntilExist(objReferrerName,10) And waitUntilExist(objReferrerPhone,10) And waitUntilExist(objReferrerExt,10) Then
					Call WriteToLog("Pass", "When the Source is " &strReferralSourceValue & "Referrer Name, Phone and Ext fields are displayed")
				Else
					Call WriteToLog("Fail", "Expected Result: When the Source is "&strReferralSourceValue&", Referrer Name, Phone and Ext fields should be displayed; Actual Result:Referrer Name, Phone and Ext fields are not displayed, when the Source is "&strReferralSourceValue&".")
				End If
				
			Case "Provider"
			'Referral Source is Provider,  Referrer Name, Phone and Ext fields should not be displayed.
'				If waitUntilExist(objReferrerName,10) And waitUntilExist(objReferrerPhone,10) And waitUntilExist(objReferrerExt,10) Then
'					Call WriteToLog("Fail", "Expected Result: When the Source is "&strReferralSourceValue&", No other fields should be displayed; Actual Result: When the Source is "&strReferralSourceValue&", Referrer Name, Phone and Ext fields are displayed")
'				Else
'					Call WriteToLog("Pass", "When the Source is "&strReferralSourceValue&", Referrer Name, Phone and Ext fields are not displayed")
'				End If
				
			Case "Special Project"
			'Referral Source is Provider,  ProjectName field should be displayed.
				objProjectName.highlight
				If not waitUntilExist(objProjectName,10) Then
					Call WriteToLog("Fail", "Expected Result: When the Source is "&strReferralSourceValue&", Project Name field should be displayed; Actual Result:Project Name field is not displayed, when the Source is "&strReferralSourceValue&".")
					Exit Function
				End If
				Call WriteToLog("Pass", "When the Source is "&strReferralSourceValue&", Project Name field is displayed")
				
			Case "VillageHealth"
			'Referral Source is VillageHealth, Search field should be displayed.	
				'objSearchUser.highlight
				If not waitUntilExist(objSearchUser,10) Then
					Call WriteToLog("Fail", "Expected Result: When the Source is VillageHealth, Search User field should be displayed; Actual Result:Search User field is not displayed, when the Source is VillageHealth")
					Exit Function
				End If
				Call WriteToLog("Pass", "Search User Text box is displayed")
				objSearchUser.set "LID"
				isPass = ClickButton("Search",objSearchButton,strOutErrorDesc)
				If not(isPass) Then
					Call WriteToLog("Fail", "Expected Result: User was able to click on the Search button; Actual Result: User was unable to click on the Search button. Error Returned: " & strOutErrorDesc)
					Exit Function
				End If
				Call WriteToLog("Pass", "Search button was clicked successfully")
				If waitUntilExist(objVHNPatientsGrid,10) Then
					Call WriteToLog("Pass", "VHN Data grid is displayed.")
					Set objtable = objVHNPatientsGrid.WebTable("class:=k-selectable")
   					objtable.highlight
					intRows = objtable.GetROProperty("rows")
					If intRows <> 0 Then
						objtable.ChildItem(1,1,"WebElement",1).Click
					End If		
					objSelectUserButton.highlight				
					isPass = ClickButton("Select User", objSelectUserButton, strOutErrorDesc)
					If Not isPass Then
						strOutErrorDesc = "ClickButton returned error: "&strOutErrorDesc
						Exit Function
					End If
				Else
					Call WriteToLog("Fail", "Expected Result: Serched Values are displayed in the Grid; Actual Result:There was no data for the search")
					Exit Function
				End If
				
		End Select
		
	Else
		Call WriteToLog("Fail", "Expected Result: Value is selected for Source Field; Actual Result: Value is not selected from Source field. Error returned: " & strOutErrorDesc)
		Exit function 
	End If
	ValidateReferralSource = True
	strReferralSourceValue = ""
	Execute "Set objSource = Nothing"
	Execute "Set objReferrerName = Nothing"
	Execute "Set objReferrerPhone = Nothing"
	Execute "Set objReferrerExt = Nothing"
	Execute "Set objProjectName = Nothing"
	Execute "Set objSearchUser = Nothing"
	Execute "Set objSearchButton = Nothing"
	Execute "Set objVHNPatientsGrid = Nothing"
	Execute "Set objSelectUserButton = Nothing"
	
End Function

'===========================================================================================================================================================
'Function Name       :	validateCreatedPatient
'Purpose of Function :	To validate Referral Source information while adding a new patient from PTC dashboard
'Input Arguments     :	Referral Source Value (Eg: Provider. Claims, Special Project.. etc)
'Output Arguments    :	Returns boolean value
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Pre-requisite		 :  This function occurs for adding a new patient
'Example of Call     :	ValidateReferralSource("Special Project", strOutErrorDesc )
'Author				 :  Sharmila
'Date				 :	27-July-2015
'===========================================================================================================================================================
Function validateCreatedPatient(ByVal strPatientFirstName, ByVal strPatientLastName, ByVal strPatientDOB)
	
	strAddressTabName = DataTable.Value("AddressTabName","CurrentTestCaseData")  						'Fetch Address history tabs names form test data sheet
	strDemogrphicDetailsLabelName = DataTable.Value("DemogrphicDetailsLabelName","CurrentTestCaseData") 'Fetch Demographic details tag name from test data
	strAddressLabelName = DataTable.Value("AddressLabelName","CurrentTestCaseData")
	strAddressLabelNameForTemporaryAddress = DataTable.Value("AddressLabelNameForTemporaryAddress","CurrentTestCaseData")
	strDemogrphicDetailsFieldName = DataTable.Value("DemogrphicDetailsFieldName","CurrentTestCaseData")
	strAddressField = DataTable.Value("Address","CurrentTestCaseData")
	strAptORSuitField = DataTable.Value("AptORSuit","CurrentTestCaseData")
	strAddressValue = DataTable.Value("AddressValue","CurrentTestCaseData")
	strAptORSuitValue = DataTable.Value("AptORSuitValue","CurrentTestCaseData")
	strPopupTitle = DataTable.Value("PopupTitle","CurrentTestCaseData")
	strPopupText = DataTable.Value("SavePopupText","CurrentTestCaseData")
	
	validateCreatedPatient = false
	'Login to Capella as PTC
'	isPass = Login("ptc")
'	If not isPass Then
'		Call WriteToLog("Fail","Failed to Login to PTC role.")
'		Exit Function
'	End If
	
	'Close all open patient     
	isPass = CloseAllOpenPatient(strOutErrorDesc)
	If Not isPass Then
		strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
		Call WriteToLog("Fail", strOutErrorDesc)
		Exit Function
	End If
	
	Call clickOnMainMenu("My Dashboard")
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	Call WriteToLog("Info","==========Testcase - Verify that Add New Patient Button exists on the PTC Dashboard.==========")
	
	Execute "Set objPatientInfoScreenTitle = " & Environment("WEL_PatientInfo_Title")
	Execute "Set objPatientFirstName = " & Environment("WE_PatientInfo_FirstName")
	Execute "Set objPatientLastName = " & Environment("WE_PatientInfo_LastName")
	Execute "Set objPatientDOB = " & Environment("WE_PatientInfo_DOB")
	Execute "Set objAddNewPatientButton = " & Environment("WB_AddNewPatient_Button")
	'Verify AddNewPatient Button exists
	If waitUntilExist(objAddNewPatientButton, 10) Then
		Call WriteToLog("Pass", "AddNewPatient button exists")	
	Else
		Call WriteToLog("Fail","Expected Result: AddNewPatient button exist; Actual Result: AddNewPatient button does not exist")
		Exit Function
	End If
	
	'Click on the Ok button of Complete Order pop up
	blnReturnValue = ClickButton("Add New Patient",objAddNewPatientButton,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: Click on the AddNewPatient button; Actual Result: " & strOutErrorDesc)
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	Call WriteToLog("Pass", "AddNewPatient button was clicked successfully")	
	
	'====================================================
	'Verify that Patient Info screen open successfully
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify that Patient Info screen open successfully. ==========")
	
	If waitUntilExist(objPatientInfoScreenTitle, 10) Then
		objPatientInfoScreenTitle.highlight
		Call WriteToLog("Pass","Patient Info Screen opened successfully")
	Else
		Call WriteToLog("Fail","Expected Result: Open Patient Info Screen; Actual Result: Unable to open Patient Info Screen")
		Exit Function
	End If
	
	'==================================================================
	'Search for the patient with FirstName, LastName and DateOfBirth
	'==================================================================
	Call WriteToLog("Info","==========Testcase - Search for the patient with FirstName, LastName and DateOfBirth. ==========")
	
	'Set value for FirstName
	If waitUntilExist(objPatientFirstName, 10) Then
		objPatientFirstName.set strPatientFirstName
	End If
	
	'Set value for LastName
	If waitUntilExist(objPatientLastName, 10) Then
		objPatientLastName.set strPatientLastName
	End If
	
	'Set value for DOB
	If waitUntilExist(objPatientDOB, 10) Then
		objPatientDOB.set strPatientDOB
	End If
	
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	'verify if no matching results found message box existed if no patient found
	isPass = checkForPopup("Error", "Ok", "No matching results found", strOutErrorDesc)
	If isPass Then
	    strOutErrorDesc = "Invalid Member ID"
	    Call WriteToLog("Fail", "The member created was not found during the search.")
	    Exit Function
	End If
	
	'Chk whether PatientSearchResult popup is available
	Set objPatSeResPP = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("html tag:=DIV","innerhtml:=.*Patient Search Results.*","innertext:=Patient Search Results.*","outerhtml:=.*Patient Search Results.*","visible:=True")
	If not objPatSeResPP.Exist(5) Then
	    Set objPatSeResPP = Nothing    'kill the object
	    strOutErrorDesc = "Unable to find PatientSearchResult popup"
	    Call WriteToLog("Fail", strOutErrorDesc)
	    Exit Function
	End If
	Set objPatSeResPP = Nothing    'kill the object
	Dim reqColumn
	If isMemberId Then
	    reqColumn = 1
	Else 
	    reqColumn = 2
	End If
	
	Set objPage = getPageObject()
	objPage.highlight
	Set objGlobalSearchGrid = objPage.WebElement("html id:=memberSearchResultslist")
	objGlobalSearchGrid.highlight
	
	name = strPatientFirstName & " " & strPatientLastName
	
	Set objtable = objGlobalSearchGrid.WebTable("class:=k-selectable")
	objtable.highlight
	For i = 1 To objtable.getRoProperty("rows")
	    x = objtable.getCellData(i, 3)
	    If lcase(x) = lcase(name) Then
	    	objtable.ChildItem(i, 0, "WebElement", 2).highlight
	        objtable.ChildItem(i, 0, "WebElement", 2).Click
	        Exit For
	    End If
	Next
	wait 2
	'Clk OK for required patient
	Set PSResOK = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("html tag:=BUTTON","name:=.*View.*","innertext:=.*View.*", "innerhtml:=.*View.*", "visible:=True", "type:=submit", "value:=View")
	PSResOK.highlight
	PSResOK.Click
	If err.number <> 0 Then
	    Set PSResOK = Nothing    'kill the object
	    strOutErrorDesc = "Unable to click OK in PatientSearchResult popup : "&" Error returned: " & Err.Description
	    Call WriteToLog("Fail", strOutErrorDesc)
	   	Exit Function
	End If
	Set PSResOK = Nothing    'kill the object
	
	Set objGlobalSearchGrid = Nothing
	Set tableDesc = Nothing
	Set objtable = Nothing
	Set objPage = Nothing
	
	wait 2
	waitTillLoads "Loading"
	wait 2
	
	'===============================================================
	'Verify that Patient info screen open successfully
	'===============================================================
	'verify patient info screen open successfully
	Execute "Set objPatientInfoScreenTitle = " & Environment("WEL_PatientInfoScreenTitle")
	objPatientInfoScreenTitle.highlight
	
	If CheckObjectExistence(objPatientInfoScreenTitle,20) Then
		Call WriteToLog("Pass","Patient info screen opened successfully")
	Else
		Call WriteToLog("Fail","Patient info screen not opened successfully")
		Exit Function
	End If
	
	Execute "Set objPatientInfoScreenTitle = Nothing"
	
	'=========================================================================================
	'Verify that Patient info should contain three tab mailing,Home,Temporary type of address
	'=========================================================================================
	'Create Object required for existence check of Type of Address tab in patient screen
	Execute "Set objDemographicAddressTab = "  & Environment("WEL_PatientInfo_DemographicAddressTab")
	arrAddressTabs = Split(strAddressTabName,";")
	arrAddressTabLabel = Split(strAddressLabelName,";")
	For i = 0 To Ubound(arrAddressTabs) Step 1
		objDemographicAddressTab.SetTOProperty "innertext",arrAddressTabs(i)
		If CheckObjectExistence(objDemographicAddressTab,5) Then
			Call WriteToLog("Pass",arrAddressTabs(i) & " tab exist on patient info screen")
		Else
			Call WriteToLog("Fail",arrAddressTabs(i) & " tab does not exist on patient info screen")	
		End If
		
		'Click on type of address tab
		blnReturnValue = ClickButton(arrAddressTabs(i) & " Tab",objDemographicAddressTab,strOutErrorDesc)
		If Not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "& strOutErrorDesc)
			Exit Function
		End If
		
		Execute "Set objDemographicDetailsLabel = "  & Environment("WEL_PatientInfo_DemographicDetailsLabel")
		If StrComp(Trim(arrAddressTabs(i)),"Temporary",1) = 0 Then
			arrAddressLabel = Split(strAddressLabelNameForTemporaryAddress,";",-1,vbtextCompare)
			
			For j = 0 To UBound(arrAddressLabel) Step 1
				objDemographicDetailsLabel.SetTOProperty "innertext",arrAddressLabel(j)
				If CheckObjectExistence(objDemographicDetailsLabel,5) Then
					Call WriteToLog("Pass",arrAddressLabel(j) & " Label exist on patient info screen: "& arrAddressTabs(i) & "tab")
				Else
					Call WriteToLog("Fail",arrAddressLabel(j) & " tab does not exist on patient info screen: "& arrAddressTabs(i) & "tab")	
				End If
			Next
		Else
			objDemographicDetailsLabel.SetTOProperty "innertext",strAddressLabelName
			If CheckObjectExistence(objDemographicDetailsLabel,5) Then
				Call WriteToLog("Pass",strAddressLabelName & " Label exist on patient info screen: "& arrAddressTabs(i) & " tab")
			Else
				Call WriteToLog("Fail",strAddressLabelName & " tab does not exist on patient info screen: "& arrAddressTabs(i) & " tab")	
			End If
		End If
	Next
	
	'===============================================================================================
	'Verify that Mailing address should contains below fields:
	'Name;Birthdate;Home Phone;Work Phone;Mobile Phone;Fax;Email;Language;Contact Pref. Day;
	'Contact Pref. Time;Gender;Marital Status;Race;Ethnicity;Working Status
	'===============================================================================================
	Execute "Set objDemographicDetailsLabel = "  & Environment("WEL_PatientInfo_DemographicDetailsLabel")
	arrDemogrphicDetailsLabelName= Split(strDemogrphicDetailsLabelName,";",-1,vbtextCompare)
	For i = 0 To UBound(arrDemogrphicDetailsLabelName) Step 1
		objDemographicDetailsLabel.SetTOProperty "innertext",arrDemogrphicDetailsLabelName(i)
		If CheckObjectExistence(objDemographicDetailsLabel,5) Then
			Call WriteToLog("Pass",arrDemogrphicDetailsLabelName(i) & ": Label exist on patient info screen")
		Else
			Call WriteToLog("Fail",arrDemogrphicDetailsLabelName(i) & ": Label does not exist on patient info screen")	
		End If
	Next
	
	'==========================
	'Get the value of address
	'==========================
	Execute "Set objAddressSection = "  &Environment("WEL_PatientInfo_DemographicAddressSection")
	objAddressSection.SetTOProperty "innertext",strAddressLabelName&".*"
	If CheckObjectExistence(objAddressSection,10) Then
		Call WriteToLog("Pass","Address section exist on patient info screen")
	Else
		Call WriteToLog("Fail","Address section does not exist on patient info scree")
		Exit Function
	End If
	
	'=======================================
	'Click the Address tab in reverse order
	'=======================================
	For i = Ubound(arrAddressTabs) To LBound(arrAddressTabs) Step 1
		objDemographicAddressTab.SetTOProperty "innertext",arrAddressTabs(i)
		blnReturnValue = ClickButton(strAddressLabelName & " Tab",objDemographicAddressTab,strOutErrorDesc)
		If Not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "& strOutErrorDesc)
			Exit Function
		End If
	Next
	
	'Save the old address in a variable
	strOldAdress = objAddressSection.GetROProperty("innertext")
	
	'=====================================================
	'Click on edit button to edit the demographic details
	'=====================================================
	Execute "Set objEditButton = "  &Environment("WB_PatientInfo_DemographicEditButton")
	If CheckObjectExistence(objEditButton,5) Then
		Call WriteToLog("Pass","Edit button exist on patient info screen")
	Else
		Call WriteToLog("Fail","Edit button does not exist on patient info screen")
		Exit Function
	End If
	
	blnReturnValue = ClickButton("Edit button",objEditButton,strOutErrorDesc)
	If not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton return: "& strOutErrorDesc)
		Exit Function
	End If
	
	Wait intWaitTime 'Wait time to synce the application
	'==========================================================================================================================================
	'Verify that after clicking on Edit button below field are displayed: First name,Last Name,Adress,Apt/Suit,City,Zip,Home phone,work phone,
	'mobile phone,Fax,email.
	'==========================================================================================================================================
	arrDemogrphicDetailsFieldName = Split(strDemogrphicDetailsFieldName,";",-1,vbTextCompare)
	Execute "Set objDemographicDetailsFields = "  & Environment("WE_PatientInfo_DemographicDetailsFields")
	For i = 0 To UBound(arrDemogrphicDetailsFieldName) Step 1
		objDemographicDetailsFields.SetTOProperty "name",arrDemogrphicDetailsFieldName(i) & ".*"
		If CheckObjectExistence(objDemographicDetailsFields,2) Then
			Call WriteToLog("Pass",arrDemogrphicDetailsFieldName(i) & ": field exist on patient info screen")
		Else
			Call WriteToLog("Fail",arrDemogrphicDetailsFieldName(i) & ": field does not exist on patient info screen")	
		End If
		
		If arrDemogrphicDetailsFieldName(i) = strAddressField Then
			objDemographicDetailsFields.Set strAddressValue
		End If
		
		If arrDemogrphicDetailsFieldName(i) = strAptORSuitField Then
			objDemographicDetailsFields.Set strAptORSuitValue
		End If
	Next
	
	'===============================================================================
	'Verify that after clicking on Edit button Save and Cancel button should display
	'===============================================================================
	Execute "Set objSaveButton = "  &Environment("WB_PatientInfo_DemographicSaveButton")
	If CheckObjectExistence(objSaveButton,10) Then
		Call WriteToLog("Pass","Save button exist on patient info screen")
	Else
		Call WriteToLog("Fail","Save button does not exist on patient info screen")
		Exit Function
	End If
	
	Execute "Set objCancelButton = "  &Environment("WB_PatientInfo_DemographicCancelButton")
	If CheckObjectExistence(objCancelButton,10) Then
		Call WriteToLog("Pass","Cancel button exist on patient info screen")
	Else
		Call WriteToLog("Fail","Cancel button does not exist on patient info screen")
		Exit Function
	End If
	
	'============================================
	'Click on save button to save the change data
	'============================================
	blnReturnValue = ClickButton("Save button",objSaveButton,strOutErrorDesc)
	If not blnReturnValue Then
		Call WriteToLog("Fail","ClickButton return: "& strOutErrorDesc)
		Exit Function
	End If
	
	'wait for application to syn
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	'====================================================================================================
	'Verify that Success message stating 'Your Changes have been saved successfully' should get displayed
	'====================================================================================================
	blnReturnValue = checkForPopup(strPopupTitle, "Ok", strPopupText, strOutErrorDesc)
	If not blnReturnValue Then
		Call WriteToLog("Fail","CheckMessageBoxExist return: "&strOutErrorDesc)
		Exit Function
	End If
		
	'=====================================================
	'Again change the address tab click in reverse order
	'=====================================================
	For i = Ubound(arrAddressTabs) To LBound(arrAddressTabs) Step -1
		Print arrAddressTabs(i)
		objDemographicAddressTab.SetTOProperty "innertext",arrAddressTabs(i)
		blnReturnValue = ClickButton(strAddressLabelName & " Tab",objDemographicAddressTab,strOutErrorDesc)
		If Not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "& strOutErrorDesc)
			Exit Function
		End If
	Next
	
	'============================================================
	'Verify that after changing the address Address section exist
	'============================================================
	If CheckObjectExistence(objAddressSection,10) Then
		Call WriteToLog("Pass","Address section exist on patient info screen after changing the address")
	Else
		Call WriteToLog("Fail","Address section does not exist on patient info screen after changing the address")
		Exit Function
	End If
	
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	'===================================
	'Save the new address in a variable
	'====================================
	strNewAddress = objAddressSection.GetROProperty("innertext")
	
	'Verify that address of patient changed
	If StrComp(strNewAddress,strOldAddress,vbTextCompare) Then
		Call WriteToLog("Pass","Address changed successfully")
	Else
		Call WriteToLog("Fail","Address does not changed")
	End If
	
	validateCreatedPatient = true
	Set objPage = Nothing
End Function


Function reopenTermedPatient(ByVal strPatientFirstName, ByVal strPatientLastName, ByVal strPatientDOB, strOutErrorDesc )

	reopenTermedPatient = false
	'Login to Capella
	Call WriteToLog("Info","==========Testcase - Login to Capella as PTC User.==========")
	
	isPass = Login("PTC")
	If not isPass Then
		Call WriteToLog("Fail","Expected Result: Successfully login to capella; Actual Result: Failed to Login to Capella as PTC User.")
		Exit Function
	End If
	
	Call WriteToLog("Pass","Successfully logged into Capella as PTC User")
	
	'Close all open patient     
	isPass = CloseAllOpenPatient(strOutErrorDesc)
	If Not isPass Then
		strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
		Call WriteToLog("Fail", "Expected Result: Close all the open patients; Actual Result: "&strOutErrorDesc)
		Exit Function
	End If
	
	'Select user roster
	isPass = SelectUserRoster(strOutErrorDesc)
	If Not isPass Then
		strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
		Call WriteToLog("Fail", "Expected Result: Verify the roster is PTC; Actual Result: "&strOutErrorDesc)
		Exit Function
	End If

	wait 5
	Execute "Set objPatientInfoScreenTitle = " & Environment("WEL_PatientInfo_Title")
	Execute "Set objPatientFirstName = " & Environment("WE_PatientInfo_FirstName")
	Execute "Set objPatientLastName = " & Environment("WE_PatientInfo_LastName")
	Execute "Set objPatientDOB = " & Environment("WE_PatientInfo_DOB")
	Execute "Set objAddNewPatientButton = " & Environment("WB_AddNewPatient_Button")
	'===============================================================
	'Verify that Add New Patient Button exists on the PTC Dashboard.
	'===============================================================
	Call WriteToLog("Info","==========Testcase - Verify that Add New Patient Button exists on the PTC Dashboard.==========")
	
	'Verify AddNewPatient Button exists
	If waitUntilExist(objAddNewPatientButton, 10) Then
		Call WriteToLog("Pass", "AddNewPatient button exists")	
	Else
		Call WriteToLog("Fail","Expected Result: AddNewPatient button exist; Actual Result: AddNewPatient button does not exist")
		Exit Function
	End If
	
	'Click on the Ok button of Complete Order pop up
	blnReturnValue = ClickButton("Add New Patient",objAddNewPatientButton,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: Click on the AddNewPatient button; Actual Result: " & strOutErrorDesc)
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	Call WriteToLog("Pass", "AddNewPatient button was clicked successfully")	
	
	'====================================================
	'Verify that Patient Info screen open successfully
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify that Patient Info screen open successfully. ==========")
	
	If waitUntilExist(objPatientInfoScreenTitle, 10) Then
		objPatientInfoScreenTitle.highlight
		Call WriteToLog("Pass","Patient Info Screen opened successfully")
	Else
		Call WriteToLog("Fail","Expected Result: Open Patient Info Screen; Actual Result: Unable to open Patient Info Screen")
		Exit Function
	End If
	
	'==================================================================
	'Search for the patient with FirstName, LastName and DateOfBirth
	'==================================================================
	Call WriteToLog("Info","==========Testcase - Search for the patient with FirstName, LastName and DateOfBirth. ==========")
	
	'Set value for FirstName
	If waitUntilExist(objPatientFirstName, 10) Then
		objPatientFirstName.set strPatientFirstName
	End If
	
	'Set value for LastName
	If waitUntilExist(objPatientLastName, 10) Then
		objPatientLastName.set strPatientLastName
	End If
	
	'Set value for DOB
	If waitUntilExist(objPatientDOB, 10) Then
		objPatientDOB.set strPatientDOB
	End If
	
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	'verify if no matching results found message box existed if no patient found
	isPass = checkForPopup("Error", "Ok", "No matching results found", strOutErrorDesc)
	If isPass Then
	    strOutErrorDesc = "Invalid Member ID"
	    Call WriteToLog("Fail", "The member created was not found during the search.")
	    Exit Function
	End If
	
	'Chk whether PatientSearchResult popup is available
	Set objPatSeResPP = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("html tag:=DIV","innerhtml:=.*Patient Search Results.*","innertext:=Patient Search Results.*","outerhtml:=.*Patient Search Results.*","visible:=True")
	If not objPatSeResPP.Exist(5) Then
	    Set objPatSeResPP = Nothing    'kill the object
	    strOutErrorDesc = "Unable to find PatientSearchResult popup"
	    Exit Function
	End If
	Set objPatSeResPP = Nothing    'kill the object
	Dim reqColumn
	If isMemberId Then
	    reqColumn = 1
	Else 
	    reqColumn = 2
	End If
	
	Set objPage = getPageObject()
	objPage.highlight
	Set objGlobalSearchGrid = objPage.WebElement("html id:=memberSearchResultslist")
	objGlobalSearchGrid.highlight
	
	name = strPatientFirstName & " " & strPatientLastName
	
	Set objtable = objGlobalSearchGrid.WebTable("class:=k-selectable")
	objtable.highlight
	For i = 1 To objtable.getRoProperty("rows")
	    x = objtable.getCellData(i, 3)
	    If lcase(x) = lcase(name) Then
	    	objtable.ChildItem(i, 0, "WebElement", 2).highlight
	        objtable.ChildItem(i, 0, "WebElement", 2).Click
	        Exit For
	    End If
	Next
	wait 2
	'Clk OK for required patient
	Set PSResOK = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebButton("html tag:=BUTTON","name:=.*Re-open Patient.*","innertext:=.*Re-open Patient.*", "innerhtml:=.*Re-open Patient.*", "visible:=True", "type:=submit", "value:=Re-open Patient")
	PSResOK.highlight
	PSResOK.Click
	If err.number <> 0 Then
	    Set PSResOK = Nothing    'kill the object
	    strOutErrorDesc = "Unable to click OK in PatientSearchResult popup : "&" Error returned: " & Err.Description
	    Call WriteToLog("Fail", strOutErrorDesc)
	   	Exit Function
	End If
	Set PSResOK = Nothing    'kill the object
	
	Set objGlobalSearchGrid = Nothing
	Set tableDesc = Nothing
	Set objtable = Nothing
	Set objPage = Nothing
	
	wait 2
	waitTillLoads "Loading"
	wait 5
	
	'follow the add new patient logic
	'Referral Management
	Err.Clear
    On Error Resume Next

	Execute "Set objReferralManagementTitle = " & Environment("WEL_ReferralManagementTitle")
	Execute "Set objReferralDate = " & Environment("WE_ReferralDate")
	Execute "Set objReferralReceivedDate = " & Environment("WE_ReferralReceivedDate")
	Execute "Set objApplicationDate = " & Environment("WE_ApplicationDate")
	Execute "Set objPayor = " & Environment("WB_PayorDropDown")
	Execute "Set objSaveBtn = " & Environment("WB_NewReferralSave")

	'=============================================
	'Verify the Referral Management Screen Loads
	'=============================================
	Call WriteToLog("Info","==========Testcase - Verify the Referral Management Screen Loads. ==========")
	
	If waitUntilExist(objReferralManagementTitle, 10) Then
		objReferralManagementTitle.highlight
		Call WriteToLog("Pass","Referral Management Screen opened successfully")
	Else
		Call WriteToLog("Fail","Expected Result: Open Referral Management Screen; Actual Result: Unable to open Referral Management Screen")
		Exit Function
	End If
	
	'Set Referral Date
'	If waitUntilExist(objReferralDate, 10) Then
'		objReferralDate.Set date
'	End If
'	
'	
'	'Set Referral Received Date
'	If waitUntilExist(objReferralReceivedDate, 10) Then
'		objReferralReceivedDate.Set date
'	End If
'	
'	
'	'Set Referral Application Date
'	If waitUntilExist(objApplicationDate, 10) Then
'		objApplicationDate.Set date
'	End If
	
	
	'=====================================================
	'Verify the BY default Payor is VillageHealth Program
	'=====================================================
	
	Call WriteToLog("Info","==========Testcase - Verify the BY default Payor is VillageHealth Program. ==========")
	If waitUntilExist(objPayor, 10) Then
		strPayorValue = objPayor.getROProperty("innertext")
		If instr(strPayorValue, "VILLAGEHEALTH PROGRAM") > 0 Then
			Call WriteToLog("Pass","By default VillageHealth Program is displayed")
		End If
	Else
		Call WriteToLog("Fail","Expected Result: By default payor should be VillageHealth Program; Actual Result: VillageHealth Program is not set as default payor")
		Exit Function
	End If
	
	'=====================================================
	'Verify the Disease State is ESRD
	'=====================================================
	Call WriteToLog("Info","==========Testcase - Verify Disease State is ESRD. ==========")
	
	
	Set objDiseaseState = getComboBoxReferralManagement("Disease State")
	strDiseaseStateValue = objDiseaseState.getROProperty("innertext")
	If instr(strDiseaseStateValue, "ESRD") > 0 Then
		Call WriteToLog("Pass","Disease State is ESRD as expected")
	Else
		Call WriteToLog("Fail","Expected Result: Disease State should be ESRD. Actual Result: " & strDiseaseStateValue)
	End If
	
	'=====================================================
	'Verify Line of Business is POS
	'=====================================================
	
	Call WriteToLog("Info","==========Testcase - Verify Line of Business is POS. ==========")
	
	
	Set objLOB = getComboBoxReferralManagement("Line Of Buisness")
	strLOBValue = objLOB.getROProperty("innertext")
	If instr(strLOBValue, "POS") > 0 Then
		Call WriteToLog("Pass","Line Of Buisness is POS")
	Else
		Call WriteToLog("Fail","Expected Result: Line of Business should be POS.Actual Result: "& strLOBValue)
	End If
		
	'=====================================================
	'Verify Service Type is Telephonic
	'=====================================================
	
	Call WriteToLog("Info","==========Testcase - Verify Service Type is Field. ==========")
	
	
	Set objServiceType = getComboBoxReferralManagement("ServiceType")
	strServiceTypeValue = objServiceType.getROProperty("innertext")
	If instr(strServiceTypeValue, "Telephonic") > 0 Then
		Call WriteToLog("Pass","Service Type is Telephonic")
	Else
		Call WriteToLog("Fail","Expected Result: Service Type should be Telephonic.Actual Result: " & strServiceTypeValue)
	End If
	
	'=====================================================
	'Verify Referral Source is Payor Refer File
	'=====================================================
	
	Call WriteToLog("Info","==========Testcase - Verify Referral Source is Payor Refer File. ==========")
	
	
	Set objSource = getComboBoxReferralManagement("Source")
	strSourceValue = objSource.getROProperty("innertext")
	If instr(strSourceValue, "Payor Refer File") > 0 Then
		Call WriteToLog("Pass","Source is Payor Refer File")
	Else
		Call WriteToLog("Fail","Expected Result: Source should be Payor Refer File.Actual Result: " & strSourceValue)
	End If
	
	'===========================================================
	'Click on the Save button in the Referral Management Screen
	'===========================================================
	Call WriteToLog("Info","==========Testcase - Click on the Save button in the Referral Management Screen. ==========")
	
	blnReturnValue = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Result: User was able to click on the Save button; Actual Result: User was unable to click on the Save button. Error Returned: " & strOutErrorDesc)
		Exit Function
	End If
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	isPass = checkForPopup("The Changes have been saved successfully", "Ok", "Member re-opened successfully.", strOutErrorDesc)
	If not isPass Then
		strOutErrorDesc = "Error closing the message box"
		Exit Function
	End If
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	'add program
	Call WriteToLog("Pass", "Add Program button was clicked successfully")
	
	blnblnReturnValue = AddPTCProgram(strOutErrorDesc)
	
	If not(blnReturnValue) Then
		Call WriteToLog("Fail", "Expected Reult: Program is added successfully; Actual Result: Unable to Add Program; Error Returned:  " & strOutErrorDesc)
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Program was added to the member added successfully")
	
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	
	Set objPage = getPageObject()
	objPage.highlight
	Set objStatus = objPage.WebElement("class:=col-md-7.*", "outerhtml:=.*CurrentEligibilityStatus.*")
	objStatus.highlight
	
	status = objStatus.getROProperty("outertext")
	Print status
	Set objStatus = Nothing
	Set objPage = Nothing
	
	
	If lcase(trim(status)) <> "enrolled" Then
		Call WriteToLog("Fail", "Patient status is not Enrolled as expected. Status is " & status)
		Exit Function
	End If
	
	
	Execute "Set objReferralManagementTitle = Nothing" 
	Execute "Set objReferralDate = Nothing"
	Execute "Set objReferralReceivedDate = Nothing"
	Execute "Set objApplicationDate = Nothing"
	Execute "Set objPayor = Nothing"
	Execute "Set objSaveBtn = Nothing"

	reopenTermedPatient = true
	
	
End Function
