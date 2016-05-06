'***********************************************************************************************************************************************************************
' TestCase Name				: Print Reports dialog
' Purpose of TC			    : This script is to verify the functionality of the Print Reports Dialog.
' Pre-requisites(if any)    : None
' Author                    : Sharmila
' Date                      : 19-OCT-2015
'***********************************************************************************************************************************************************************

''***********************************************************************************************************************************************************************
'Initialization steps for current script
''***********************************************************************************************************************************************************************
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

intWaitTime =Environment.Value("WaitTime") 

Set objFso = Nothing

Call Initialization() 
strOutTestName = Environment.Value("TestCaseName")
strTestDataFileName = Environment.Value("PROJECT_FOLDER") & "\Testdata\" & Environment.Value("TestDataFileName")

'Load test data for the test case
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Print_Reports", strOutTestName, strOutErrorDesc) 
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
'Variable Initialization
'=========================
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData") 			'Fetch patient name from test data
strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")					'Fetch member id from the test data



'=========================================================
'Objects Initiallization
'=========================================================

Execute "Set objPrintReportIcon = "  &Environment.Value("WEL_PrintReportIcon") 'Object for Print Report Icon 
Execute "Set objPrintReportScreenTitle= "  &Environment.Value("WEL_PrintReport_ScreenTitle") 'Object for Print Report Dialog
Execute "Set objCancelButton= "  &Environment.Value("WE_Cancel_Button") 'Object for Cancel button
Execute "Set objProviderCareReport_RadioButton= "  &Environment.Value("WEL_ProviderCareReport_RadioButton") 'object for Provider Care Report Radio Button
Execute "Set objProviderCareReport_Dropdown= "  &Environment.Value("WB_ProviderCare_Dropdown") 'object for Provider Care Report drop down
Execute "Set objOKButton= "  &Environment.Value("WEL_PrintReportOK_Button") 'object for Print Report OK Button
Execute "Set objPrintPreviewDialog= "  &Environment.Value("WEL_PrintPreview") 'object for Print Preview Dialog title
Execute "Set objPrintPreviewClose= "  &Environment.Value("IMG_PrintPreview_Close") 'object for Print Preview Dialog close button

'#################################################	Start: Test Case Execution	#################################################
'==========================================================================================================
'Login to Capella, verify the successful loading of the dashboard page and verify My Patient Census widget
'==========================================================================================================
Call WriteToLog("Info","==========Testcase - Login to Capella, verify the successful loading of the dashboard page and verify My Patient Census widget==========")


'Login to Capella

isPass = Login("vhn")
If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHN role.") 
	Call Logout()
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHN role")

'Close all open patient     
isPass = CloseAllOpenPatient(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'Select user roster
isPass = SelectUserRoster(strOutErrorDesc)
If Not isPass Then
	strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'==================================
'Open patient from global search
'==================================
Call WriteToLog("Info","==========Testcase - Open a patient from Global Search.==========")


'isPass = OpenPatientProfileFromActionItemsList(strPatientName,strOutErrorDesc)
'If Not isPass Then
'	Call WriteToLog("Fail", "Expected Result: Patient Found in Action Item; Actual Result: Patient not found " & strPatientName)
'	Call WriteLogFooter()
'	ExitAction
'End If


isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", strOutErrorDesc)
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Wait 2
waitTillLoads "Loading..."
wait 2


'==============================
'Click on Print report button 
'==============================
Call WriteToLog("Info","==========Testcase - Verify the Print Report Icon exists and Click on the Icon==========")    

If Not waitUntilExist(objPrintReportIcon, 10) Then
	Call WriteToLog("Fail","Expected Result: Print Report Icon exists; Actual Result:Unable to Click on Print Report Icon: "&strOutErrorDesc)
    Call WriteLogFooter()
    ExitAction
End if

Call WriteToLog("Pass","Print Report Icon exists on the screen")   

blnReturnValue = ClickButton("Print Report button",objPrintReportIcon,strOutErrorDesc)
Wait 2
waitTillLoads "Loading..."
wait 2
If Not blnReturnValue Then
    Call WriteToLog("Fail","Expected Result: Click on Print Report Icon; Actual Result: Unable to Click on Print Report Icon: "&strOutErrorDesc)
    Call WriteLogFooter()
    ExitAction
End If

Call WriteToLog("Pass","User clicked on the Print Report Icon Successfully")   
'==========================================================
'Verify that Print Report Screen open successfully
'==========================================================

If not waitUntilExist(objPrintReportScreenTitle, 10) Then
    Call WriteToLog("Fail","Expected Result: Print Report Dialog Opens; Actual Result: Unable to open Print Report Dialog")
    Call WriteLogFooter()
    ExitAction
End If

objPrintReportScreenTitle.highlight
Call WriteToLog("Pass","Print Report screen opened successfully")    


'=============================================================================
'Clicking on the cancel button, should close the Print Report dialog
'=============================================================================
Call WriteToLog("Info","==========Testcase - Clicking on the cancel button, should close the Print Report dialog==========")    

''==========================
''Click the Cancel button
''==========================
If not waitUntilExist(objCancelButton, 10) Then
    Call WriteToLog("Fail","Expected Result: Cancel Button Exists; Actual Result: Cancel button doesnot exists")
    Call WriteLogFooter()
    ExitAction
End If

objCancelButton.click
Wait 2
waitTillLoads "Loading..."
wait 2

Call WriteToLog("Pass","Print Report screen disappears after clicking the cancel button")    

Set objPrintReportScreenTitle = nothing
Set objPrintReportIcon = nothing

'

'==========================================================================================
'Clicking on the each of the radio button Options, and verify their functionality
'========================================================================================
Call WriteToLog("Info","==========Testcase -Clicking on the each of the radio button Options, and verify their functionality==========")    

'================================================================================================================================================
' ******* If there is any addition to the radio button, please increase the count from 11 to the number of radio buttons added. **********
'================================================================================================================================================

For RadiobuttonCount = 1 To 11 Step 1
	
	'For each radio button option call this function and pass the radio button name.
	RadioButton = "RadioButton"&RadiobuttonCount
	strRadioButtonName = DataTable.Value(RadioButton,"CurrentTestCaseData")					'Fetch Radiobutton data id from the test data and open the print report dialog
	
	blnReturnValue = VerifyPrintReportOptions(strRadioButtonName)
	If not blnReturnValue Then
		Call WriteToLog("Fail",strRadioButtonName &" Radio button option for Failed to work as expected.")   
	Else
		Call WriteToLog("Pass", strRadioButtonName &" Report functionality worked successfully .") 
	End If
	
Next

'==========================================================================================
'Clicking on the each of the radio button Options, and verify their functionality
'==========================================================================================
Call WriteToLog("Info","All functionality for this Print Report dialog are verified, Logout of the application and close the browser.")    
Call Logout
CloseAllBrowsers
Call WriteLogFooter()




Function VerifyPrintReportOptions(ByVal StrRadiobuttonOption)
	
	VerifyPrintReportOptions = false
	
	Execute "Set objPrintReportIcon = "  &Environment.Value("WEL_PrintReportIcon") 'Object for Print Report Icon 
	Execute "Set objPrintReportScreenTitle= "  &Environment.Value("WEL_PrintReport_ScreenTitle") 'Object for Print Report Dialog
	Execute "Set objProviderCareReport_RadioButton= "  &Environment.Value("WEL_ProviderCareReport_RadioButton") 'object for Provider Care Report Radio Button
	Execute "Set obj_Dropdown = "  &Environment.Value("WB_ProviderCare_Dropdown") 'object for Provider Care Report drop down	
	Execute "Set objOKButton= "  &Environment.Value("WEL_PrintReportOK_Button") 'object for Print Report OK Button
	Execute "Set objPrintPreviewDialog= "  &Environment.Value("WEL_PrintPreview") 'object for Print Preview Dialog title
	Execute "Set objPrintPreviewClose= "  &Environment.Value("IMG_PrintPreview_Close") 'object for Print Preview Dialog close button
	Execute "Set objIntegratedcarereport_RadioButton= "  &Environment.Value("WEL_Integratedcarereport_RadioButton") 'object for Integrated care report Radio Button
	Execute "Set objICR_PatientRadioButton= "  &Environment.Value("WEL_Integratedcarereport_Patient_RadioButton") 'object for Patient Radio Button when you choose Integrated care report Radio Button
	
	Execute "Set objPatientProfileReport_RadioButton= "  &Environment.Value("WEL_PatientProfileReport_RadioButton") 'object for Patient Profile Report Radio Button
	Execute "Set objHealthRiskAssessment_RadioButton= "  &Environment.Value("WEL_HealthRiskAssessment_RadioButton") 'object for Health Risk Assessment Radio Button
	Execute "Set objPatientCareReport_RadioButton= "  &Environment.Value("WEL_PatientCareReport_RadioButton") 'object for Patient Care Report Radio Button
	Execute "Set objPatientScorecardReport_RadioButton= "  &Environment.Value("WEL_PatientScorecardReport_RadioButton") 'object for Patient Scorecard Report Radio Button
	Execute "Set objSBARReport_RadioButton= "  &Environment.Value("WEL_SBARReport_RadioButton") 'object for SBAR Report Radio Button
	Execute "Set objTeamRosterReport_RadioButton= "  &Environment.Value("WEL_TeamRosterReport_RadioButton") 'object for Team Roster Report Radio Button
	Execute "Set objGamePlanReport_RadioButton= "  &Environment.Value("WEL_GamePlanReport_RadioButton") 'object for Game Plan Report Radio Button
	Execute "Set objFalconInterfaceReport_RadioButton= "  &Environment.Value("WEL_FalconInterfaceReport_RadioButton") 'object for Falcon Interface Report Radio Button
	Execute "Set objMedicationList_RadioButton= "  &Environment.Value("WEL_MedicationList_RadioButton") 'object for Medication List Radio Button
	Execute "Set objCancelButton= "  &Environment.Value("WE_Cancel_Button") 'Object for Cancel button
	Execute "Set objErrorFrame= "  &Environment.Value("WEL_ErrorFrame") 'Object for Error Frame (An Internal Error occured in the print report window)
	
	'==============================
	'Click on Print report button 
	'==============================
	blnReturnValue = ClickButton("Print Report button",objPrintReportIcon,strOutErrorDesc)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If Not blnReturnValue Then
	    Call WriteToLog("Fail","Unable to Click on Print report Button: "&strOutErrorDesc)
	    Exit Function
	End If
	
	'==========================================================
	'Verify that Print Report Screen open successfully
	'==========================================================
	If not waitUntilExist(objPrintReportScreenTitle, 10) Then
	    Call WriteToLog("Fail","Expected Result: Print Report Dialog Opens; Actual Result: Unable to open Print Report Dialog")
	    Exit Function
	End If
	
	objPrintReportScreenTitle.highlight
	Call WriteToLog("Pass","Print Report screen opened successfully")
	
	Select Case StrRadiobuttonOption
		
		Case "Provider Care Report"
		
				'================================================
				'Verify the Provider Care Report Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Provider Care Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objProviderCareReport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Provider Care Report Radio button exists; Actual Result: Provider Care Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objProviderCareReport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Provider Care Report Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the Provider Care Report Radio button.")				
				
				'When clicked on the Radio button, the drop down should display
				If not waitUntilExist(obj_Dropdown, 10) Then
				    Call WriteToLog("Fail","Expected Result: Provider Care Report drop down exists; Actual Result: Provider Care Report drop down does not exists")
				    Exit Function
				End If
				
				Call WriteToLog("Pass","Provider Care Report drop down is displayed, when clicked on the radio button")
				
				'Select the value of the drop down.
				Call selectComboBoxItem(obj_Dropdown, "VHN")
				
				wait intWaitTime/4
				
		Case "Integrated Care Report"	

				'================================================
				'Verify the Integrated Care Report Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Integrated Care Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objIntegratedcarereport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Integrated Care Report Radio button exists; Actual Result: Integrated Care Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objIntegratedcarereport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Integrated Care Report is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the Integrated Care Report Radio button.")		
				
				err.clear
				objICR_PatientRadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Patient Radio button under ICR is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				
				Call WriteToLog("Pass","Clicked on the Patient option under Integrated Care Report Radio button.")	
				
				wait intWaitTime/4				
				
		Case "Patient Profile Report"	
				
				'================================================
				'Verify the Patient Profile Report Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Patient Profile Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objPatientProfileReport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Patient Profile Report Radio button exists; Actual Result: Patient Profile Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objPatientProfileReport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Patient Profile Report Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				
				Call WriteToLog("Pass","Clicked on the Patient Profile Report Radio button.")	
				
								
		Case "Health Risk Assessment"
				
				'================================================
				'Verify the Health Risk Assessment Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Health Risk Assessment radio button in the Print Report dialog==========") 
				
				'open database connection
				isPass = ConnectDB()
				If Not isPass Then
					Call WriteToLog("Fail", "Connect to Database failed.")
					Exit Function
				End If
				'strMemberID = "178108"
				'Query to retrieve the records from the HRA table in the database.
				
				
				strSQLQuery = "SELECT ORG_Category From org_organization WHERE ORG_UID in (Select MRP_INIT_ORG_UID from mrp_mem_referral_period where mrp_mem_uid IN (select mem_uid from mem_member where mem_id = '" & strMemberID &"'))"
				blnReturnValue = RunQueryRetrieveRecordSet(strSQLQuery)
				If blnReturnValue Then
					strCheckSNPMember = objDBRecordSet("ORG_Category")
				End If
				If strCheckSNPMember = "SNP" Then
					
					If not waitUntilExist(objHealthRiskAssessment_RadioButton, 10) Then
					    Call WriteToLog("Fail","This is a SNP Patient, this patient does not have Health Risk Assessment Radio Button.")
					    Exit Function
					End If
				Else
					If not waitUntilExist(objHealthRiskAssessment_RadioButton, 10) Then
					    Call WriteToLog("Pass","This is not a SNP Patient, so this patient will not have Health Risk Assessment Radio Button.")
					    VerifyPrintReportOptions = true
					    Exit Function
					End If
				End If	

					
				err.clear
				objHealthRiskAssessment_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Health Risk Assessment Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the Health Risk Assessment Radio button.")				
				
				
				'=========================================================================================================
				'Read the database for the number of rows for that member in the HRA table for that referral period.
				'=========================================================================================================
				Call WriteToLog("Info","==========Testcase - Read the database for the HRA Records of that member and compare it with the drop down values. ==========")
				
				'open database connection
				isPass = ConnectDB()
				If Not isPass Then
					Call WriteToLog("Fail", "Connect to Database failed.")
					Exit Function
				End If
				'strMemberID = "178108"
				'Query to retrieve the records from the HRA table in the database.
				strSQLQuery = "select LOOKUP_VALUE_TEXT, HRA_DATE_END from HRA_HEALTH_RISK_ASSESSMENT, LOOKUP_VALUES Where HRA_MEM_UID IN (Select mem_uid from mem_member where mem_id = '" & strMemberID & "') AND HRA_STATUS IN ('C','I') AND HRA_TYPE = LOOKUP_VALUE_CODE AND LOOKUP_VALUE_TYPE_UID = '217' AND TRUNC(HRA_DATE_BEGIN) >= (SELECT TRUNC(MAX(MRP_REFERRAL_DATE)) FROM MRP_MEM_REFERRAL_PERIOD WHERE MRP_MEM_UID=HRA_MEM_UID) order by HRA_DATE_END Desc"
				isPass = RunQueryRetrieveRecordSet(strSQLQuery)
				If isPass Then
					err.clear
					If not objDBRecordSet.EOF Then
						arrDBRecords = objDBRecordSet.getRows()
					Else
						call WriteToLog("Pass", "There is no HRA Complete/InComplete record for this member.")
						obj_Dropdown.click
						
						'Verify the dropdown values are blank
						Set objPage = getPageObject()
						Set objDropDownValues = objPage.WebElement("class:=dropdown-menu.*","html tag:=UL","visible:=true")
						strBlankDropdwonValue = objDropDownValues.GetROProperty("innertext")
						If strBlankDropdwonValue ="" Then
							call WriteToLog("Pass", "Dropdown values for Report Dates under HRA Radio button are blank.")
						End If
						
						Exit Function
					End if
					If err.number <> 0 Then
						call WriteToLog("Fail", "Error in retrieving the Dataset")
						Exit Function
					End If
				Else
					call WriteToLog("Fail", "Error in executing the query")
					Exit Function
				End If
				
				Call CloseDBConnection()
				
				Call WriteToLog("Pass","==========Database values for that member in the HRA table were retrieved successfully. ==========")
				
				intArrayCount = Ubound(arrDBRecords)
				
				If intArrayCount <> 0 Then
				
					For i = 0 To Ubound(arrDBRecords,2) Step 1					
					
						strDropdownValue = arrDBRecords(0,i) & " " & DateFormat(DateValue(arrDBRecords(1,i)))
						blnReturnValue = validateValueExistInDropDown(obj_Dropdown, strDropdownValue)
						
						If not blnReturnValue Then
							Call WriteToLog("Fail","Database Value: '" &strDropdownValue&"' and the Dropdown values are not matching for the referral period.")	
						Else 	
							Call WriteToLog("Pass","Database Value: '" &strDropdownValue&"' and the Dropdown values are matching.")	
						End if
					
		    		Next
				
				Else
					
					Call WriteToLog("Pass","There is no HRA Complete/InComplete record for this member.")	
				
				End if
				
				'Verify the Recent Screenings value is also exist in the drop down
				
				blnReturnValue = validateValueExistInDropDown(obj_Dropdown, "Recent Screenings")
						
				If not blnReturnValue Then
					Call WriteToLog("Fail","Recent Screenings value doesnot exist in the HRA dropdown")	
				Else 	
					Call WriteToLog("Pass","Recent Screenings value exists in the HRA dropdown")	
				End if
				
				StrRadiobuttonOption = "Health Risk Assessment Report"
			
				
				
		Case "Patient Care Report"
		
				'================================================
				'Verify the Patient Profile Report Radio button
				'================================================
		
				Call WriteToLog("Info","==========Testcase - Verify the Patient Care Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objPatientCareReport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Patient Care Report Radio button exists; Actual Result: Patient Care Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objPatientCareReport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Patient Care Report Radio button is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the Patient Care Report Radio button.")				
				
				'When clicked on the Radio button, the drop down should display
				If not waitUntilExist(obj_Dropdown, 10) Then
				    Call WriteToLog("Fail","Expected Result: Patient Care Report drop down exists; Actual Result: Patient Care Report drop down does not exists")
				    Exit Function
				End If
				
				Call WriteToLog("Pass","Patient Care Report drop down is displayed, when clicked on the radio button")
				
				'Select the value of the drop down. Same properties are used for drop down objects under Provider Care Report and Patient Care Report.
				Call selectComboBoxItem(obj_Dropdown, "English")
				
				StrRadiobuttonOption = "Patient Care Report (English)"
				
				wait intWaitTime/4
				
				
		Case "Patient Scorecard Report"
		
				'================================================
				'Verify the Patient Scorecard Report Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Patient Scorecard Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objPatientScorecardReport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Patient Scorecard Report Radio button exists; Actual Result: Patient Scorecard Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objPatientScorecardReport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Patient Scorecard Report Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				
				Call WriteToLog("Pass","Clicked on the Patient Scorecard Report Radio button.")	
				
				
		Case "SBAR Report" 
		
				'================================================
				'Verify the SBAR Report Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the SBAR Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objSBARReport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: SBAR Report Radio button exists; Actual Result: SBAR Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objSBARReport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: SBAR Report Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the SBAR Report Radio button.")	
				
		Case "Team Roster Report"
		
				'================================================
				'Verify the Team Roster Report Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Team Roster Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objTeamRosterReport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Team Roster Report Radio button exists; Actual Result: Team Roster Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objTeamRosterReport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Team Roster Report Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the Team Roster Report Radio button.")	
				
				
		Case "Game Plan Report"
		
				'================================================
				'Verify the Game Plan Report Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Game Plan Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objGamePlanReport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Game Plan Report Radio button exists; Actual Result: Game Plan Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objGamePlanReport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Game Plan Report Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the Game Plan Report Radio button.")	
				
				
		Case "Falcon Interface Report"
		
				'================================================
				'Verify the Falcon Interface Report Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Falcon Interface Report radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objFalconInterfaceReport_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Falcon Interface Report Radio button exists; Actual Result: Falcon Interface Report Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objFalconInterfaceReport_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Falcon Interface Report Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the Falcon Interface Report Radio button.")	
				
				
		Case "Medication List"
		
				'================================================
				'Verify the Medication List Radio button
				'================================================
				Call WriteToLog("Info","==========Testcase - Verify the Medication List radio button in the Print Report dialog==========")    
				
				If not waitUntilExist(objMedicationList_RadioButton, 10) Then
				    Call WriteToLog("Fail","Expected Result: Medication List Radio button exists; Actual Result: Medication List Radio button does not exists")
				    Exit Function
				End If
				
				err.clear
				objMedicationList_RadioButton.click
				If err.number <> 0 Then
					Call WriteToLog("Fail","Expected Result: Medication List Radio is clicked; Actual Result: Unable to click on the radio button.")
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked on the Medication List Radio button.")	
		
				StrRadiobuttonOption = "Medication List Report"
	End Select
	

	'Click on the OK Button
	If Not waitUntilExist(objOKButton, 10) Then
	    Call WriteToLog("Fail","Expected Result: OK button exists; Actual Result: OK button does not exists")
	    Exit Function
	End If
	
		
	objOKButton.highlight
	blnReturnValue = ClickButton("OK",objOKButton,strOutErrorDesc)
	
	wait intWaitTime/2
	
	If Not blnReturnValue Then
	    Call WriteToLog("Fail","Unable to Click on OK Button: "&strOutErrorDesc)
	    Exit Function
	End If
	
	Call WriteToLog("Pass","Ok button was clicked successfully.")
	
	
	'==================================================================
	'Verify the Print Preview Dialog loads and close the dialog
	'====================================================================
	Call WriteToLog("Info","==========Testcase - Verify the Print Preview Dialog loads and close the dialog==========")    
	
	If not waitUntilExist(objPrintPreviewDialog, 10) Then
	    Call WriteToLog("Fail","Expected Result: Print Preview Dialog loads; Actual Result: Print Preview Dialog is not loading")
	    Exit Function
	End If
	
	StrPrintPreviewScreenTitle = objPrintPreviewDialog.GetROProperty("innertext")
	
	If instr(StrRadiobuttonOption, Trim(StrPrintPreviewScreenTitle)) >0 Then
		Call WriteToLog("Pass","Preivew Dialog for" &StrRadiobuttonOption& ", Opened successfully with the title: "&StrPrintPreviewScreenTitle)
		
		' Check the Window is not displaying Internal error message
		If not waitUntilExist(objErrorFrame,10) Then
			Call WriteToLog("Pass","Report loaded successfully in the preview panel. ")
		Else
		    Call WriteToLog("Fail","Expected Result: Report loads in the Preview panel. Actual Result: An Intenal Error Occured.Preview panel did not load the report. ")
		End If
		
		'Close the report
		objPrintPreviewClose.Click
		Wait 2
		waitTillLoads "Loading..."
		wait 2
	    If err.number <> 0 Then
	        Call WriteToLog("Fail","Expected Result: Print Preivew dialog closes; Actual Result: Error closing preview dialog. ")
			Exit Function
	    End If
	    Call WriteToLog("Pass","Preivew Dialog for Provider Care Report, closed successfully. ")
	Else
		Call WriteToLog("Fail","Expected Result: Preivew Dialog for Provider Care Report, Opened successfully; Actual Result: Error openeing preview dialog. ")
		Exit Function
	End If
	
	VerifyPrintReportOptions = True
	
	Execute "Set objPrintReportIcon = Nothing" 
	Execute "Set objPrintReportScreenTitle= Nothing"
	Execute "Set objProviderCareReport_RadioButton= Nothing"
	Execute "Set obj_Dropdown = Nothing"
	Execute "Set objOKButton= Nothing"
	Execute "Set objPrintPreviewDialog= Nothing"
	Execute "Set objPrintPreviewClose= Nothing"
	Execute "Set objIntegratedcarereport_RadioButton= Nothing"
	Execute "Set objICR_PatientRadioButton= Nothing"
	
	Execute "Set objPatientProfileReport_RadioButton= Nothing"
	Execute "Set objHealthRiskAssessment_RadioButton= Nothing"
	Execute "Set objPatientCareReport_RadioButton= Nothing"
	Execute "Set objPatientScorecardReport_RadioButton= Nothing"
	Execute "Set objSBARReport_RadioButton= Nothing"
	Execute "Set objTeamRosterReport_RadioButton= Nothing"
	Execute "Set objGamePlanReport_RadioButton= Nothing"
	Execute "Set objFalconInterfaceReport_RadioButton= Nothing"
	Execute "Set objMedicationList_RadioButton= Nothing"
	Execute "Set objCancelButton= Nothing"
	Execute "Set objErrorFrame= Nothing"
	
	
End Function

