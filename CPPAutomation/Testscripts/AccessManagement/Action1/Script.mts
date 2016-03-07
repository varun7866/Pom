'***********************************************************************************************************************************************************************
' TestCase Name				: AccessManagement
' Purpose of TC			    : This script covers only Access Information Tab
'							: This script is based on the SNPs Project covers only Access Information tab.
'							: Scenario 1 - Verify there is any Active Accees
'							  Scenario 2 - When there is a already an Active Access, User cannot add a new Access, it should thrown an error.
'							  Scenario 3 - Verify editing the Active Access to Termed
'							  Scenario 4 - Add New Access
'							  Scenario 5 - Verfiy the Access History for Newly added Access
'							  Scenario 6 - When user adds, more than 3 Inactive Access, it should display an error message. 
'							  Scenario 7 - If there is any active VAP Plan, stop the existing plan and add a new VAP Plan.
'							  Scenario 8 - Complete all the Steps in the VAP Plan.
' Pre-requisites(if any)    : None
' Author                    : Sharmila
' Date                      : 29-JUL-2015
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "AccessManagement", strOutTestName, strOutErrorDesc) 
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
'Variable Initialization
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData") 			'Fetch patient name from test data

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
	Logout
	CloseAllBrowsers
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

'==============================
'Open patient from global search
'==============================
Call WriteToLog("Info","==========Testcase - Open a patient from Global Search.==========")

strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	strOutErrorDesc = "Failed to select required member from Global Search"
	Call WriteToLog("Fail", strOutErrorDesc)
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

wait 2
waitTillLoads "Loading..."
wait 2

'=========================================================
'Select Access screen from the Clinical management menu
'=========================================================
Call clickOnSubMenu("Clinical Management->Access")

wait intWaitTime/4
waitTillLoads "Loading..."
wait 2

'===========================================================================================
' Call the function AccessInformation, which does all the validation for adding the Access. 
' All the function are located at the Library --> AppSpecific Functions
'===========================================================================================
blnReturnValue = AccessInformation(strOutErrorDesc)
If not blnReturnValue Then
	Call WriteToLog("Fail","Failed to verify Access Management functionalities")
	Call Logout()
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Access Management functionalities were verified successfully")


'===========================================================================================
' Call the function VascularAccessPlan, which does all the validation for adding the Access. 
'===========================================================================================
blnReturnValue = VascularAccessPlan(strOutErrorDesc)
If not blnReturnValue Then
	Call WriteToLog("Fail","Expected Result: Verify VAAP functionalities; Actual Result: Failed to verify Vascular Access Plan functionalities")
	Call Logout()
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Vascular Access Plan functionalities were verified successfully")


'=================================
'Logout from Capella Application
'=================================
Call Logout()
CloseAllBrowsers


'============================
'Summarize execution status
'============================
Call WriteLogFooter()



'#######################################################################################################################################################################################################
'Function Name		 : VascularAccessPlan
'Purpose of Function : Purpose of this function is to create the functionality of the Vascular Access plan
'Input Arguments	 : N/A
'Output Arguments	 : N/A
'Example of Call	 : blnReturnValue = VascularAccessPlan()
'Author				 : Sharmila (Script from Citious Tech, later modified).
'Date				 : 20-Jan-2016
'##################################################################################################################################################################################

Function VascularAccessPlan(strOutErrorDesc)
	
	Err.clear
	VascularAccessPlan = false
	On Error Resume Next
	strOutErrorDesc =""
	
	
	'============================
	' Variable initialization
	'============================
	strDesiredPermanentValue =  Datatable.Value("DesiredPermanentAccessValue","CurrentTestCaseData") 'Desired Permanent Access Value
	strStopReason = Datatable.Value("StopReason","CurrentTestCaseData")				'Stop Reason Value
	strDelayReason = Datatable.Value("DelayReason","CurrentTestCaseData")			'Delay Reason Value
	strSideValue = DataTable.Value("SideValue","CurrentTestCaseData")			  	'Side value
	strRegionValue = DataTable.Value("RegionValue","CurrentTestCaseData")			'Reason value
	strExtremityValue = DataTable.Value("ExtremityValue","CurrentTestCaseData")	  	'Extremity Value
	strPopupTitle = DataTable.Value("PopupTitle","CurrentTestCaseData")	  			'Popup Title
	strSavePopupText = DataTable.Value("ChangesSaveText","CurrentTestCaseData") 	'Changes Saved Text
		
	
	'=====================================
	'Objects required for test execution
	'=====================================
	
	Execute "Set objVascularAccessPlanTab = " & Environment.Value("WEL_Access_VascularAccessPlanTab") 'object for Vascular Access Plan Tab
	Execute "Set objNewPlanButton = " & Environment.Value("WB_Access_NewPlanButton") 	'object for New Plan button
	Execute "Set objPlanStartDate = " & Environment.Value("WE_Acess_PlanStartDate")		'object for Plan Start Date
	Execute "Set objStopButton = " & Environment.Value("WB_Acess_stopButton")			'object for Stop Button
	Execute "Set objStopDate = " & Environment.Value("WE_Acess_StopDate")				'object for Stop Date button
	Execute "Set objAgreedRadioButton = " & Environment.Value("WE_Access_AgreedRadioButton")	'object for Patient Agreed Radio button
	Execute "Set objAgreedDatefield = " & Environment.Value("WE_Access_AgreedDatefield")		'object for Agreed Date field
	Execute "Set objSaveButton = " & Environment.Value("WB_Access_SaveButton")				'object for Save button
	Execute "Set objAnticipatedCompleteDate = " & Environment.Value("WE_Access_AniticipatedCompleteDate")		'object for Anticipated Comlete Date
	Execute "Set objAppointmentDate = " & Environment.Value("WE_Access_AppointmentDate")		'object for Appointment Date field
	Execute "Set objCompleteDate = " & Environment.Value("WE_Access_CompletionDate")			'object for Complete Date field	
	Execute "Set objDelayReason = " & Environment.Value("WB_Access_DelayReason") 'Object for Delay Reason dropdown
	Execute "Set objVAPSideDropDown = " & Environment.Value("WB_Access_VAPSideDropDown") 'Object for VAP Side dropdown - Step 4
	Execute "Set objVAPRegionDropDown = " & Environment.Value("WB_Access_VAPRegionDropDown") 'Object for VAP Region dropdown - Step 4
	Execute "Set objVAPExtremityDropDown = " & Environment.Value("WB_Access_VAPExtremityDropDown") 'Object for VAP Extremity dropdown - Step 4
	Execute "Set objSkipStep = " & Environment.Value("WE_Access_SkipStep") 'Object for Skip Step checkbox

	
	
	'Check the Vascular Access tab exist or not on Access Management screen 
	objVascularAccessPlanTab.highlight
	If not waitUntilExist(objVascularAccessPlanTab, intWaitTime/2) Then
		Call WriteToLog("Fail", "Vascular Access tab does not exist on the Acess screen " & strOutErrorDesc)
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Vascular Access tab exist on the Access screen " & strOutErrorDesc)
	Err.Clear	
	'Expand Vascular Access tab
	objVascularAccessPlanTab.Click
	If Err.Number = 0 Then
		Call WriteToLog("Pass","Vascular Access tab expanded successfully")
	Else
		Call WriteToLog("Fail", "Expected Result:Vascular tab is expanded;Actual Result: Vascular Access tab is not expanded successfully")
		Exit Function
	End If
	
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'Check the existence of  New Plan button
	If not waitUntilExist(objNewPlanButton,intWaitTime/4) Then
		Call WriteToLog("Fail", "Expected Result: New Plan button exists;Actual Result:New Plan button does not exist")
		Exit Function
	End If
	
	Call WriteToLog("Pass", "New Plan button exist")
	
	'Check New Plan Button enable or not
	'Start date should not be older than 7 days from today's date and should not be greater than today's date

	strPlanStartDate = Date 
	strStopDate = DateAdd("d",4,Date)
	
	strClassOfNewPlanButton = objNewPlanButton.object.getAttribute("class")
	blnReturnValue = Instr(1,strClassOfNewPlanButton,"disabled",0)
	If blnReturnValue = 0  Then
		Call WriteToLog("Pass", "New Plan Button is enabled")
		blnReturnValue = AddNewPlanForVascularAccessPlan(strPlanStartDate,strDesiredPermanentValue,strOutErrorDesc)
		
		If not(blnReturnValue) Then
			Call WriteToLog("Fail", "Expected Result:Vascular Plan is added; Actual Result:Vascular Plan is not started successfully. Error Returned :-" & strOutErrorDesc )
			Exit Function
		End If
	Else
		Call WriteToLog("Pass", "New Plan Button is disabled")
		'Stop plan which is started already	
		blnReturnValue = ToStopPlanOfVascularAcessManagement(strStopDate ,strStopReason,strOutErrorDesc)
		If not(blnReturnValue) Then
			Call WriteToLog("Fail", "Expected Result:Vascular Plan is stopped; Actual Result: Vascular Plan is not stopped successfully. Error Returned :-" & strOutErrorDesc)
			Exit Function
		End If	
		
		'Check the existence of the New Plan Button	
		If objNewPlanButton.Exist(2) Then
			Call WriteToLog("Pass", "New Plan button exist")
		Else
			Call WriteToLog("Fail", "Expected Result: New Plan button exist; Actual Result: New Plan button does not exist")
			Exit Function
		End If
	
		'Add new plan to the Vascular Access plan 	
		strDisableNewPlanButton = objNewPlanButton.getRoProperty("Disabled")
		If strDisableNewPlanButton = 0  Then
			Call WriteToLog("Pass", "New Plan Button is enabled")
			blnReturnValue = AddNewPlanForVascularAccessPlan(strPlanStartDate,strDesiredPermanentValue,strOutErrorDesc)
			If not(blnReturnValue) Then
				Call WriteToLog("Fail", "Expected Result:Vascular Plan is added; Actual Result:Vascular Plan is not started successfully. Error Returned :-" & strOutErrorDesc)
				Exit Function
			End If	
		End If
		
	End If
	
	'===========================================================
	'Verify the Steps once the Vascular Access Plan is added
	'===========================================================
	
	Call WriteToLog("info", "=============Testcase - Verify the Steps once the Vascular Access Plan is added. ================")
	
	
	Set objPage = getPageObject()
	Set oDescVAPPlan = Description.Create
	oDescVAPPlan("micclass").Value = "WebElement"
	oDescVAPPlan("attribute/data-capella-automation-id").Value = "Access Management_Review_itemS\.DisplayOrder.*"
	objPage.highlight
	Set objVAPPlanSteps = objPage.ChildObjects(oDescVAPPlan)
	Print objVAPPlanSteps.Count
	
	For VapStepCount = 0 To objVAPPlanSteps.Count-1 Step 1
		
		Err.clear	
		Set objVAPStep = getPageObject.WebElement("attribute/data-capella-automation-id:=Access Management_Review_itemS\.DisplayOrder_" &VapStepCount& "")
		objVAPStep.highlight
		objVAPStep.click
		If Err.Number = 0  Then
			Call WriteToLog("Pass","Step: " &VapStepCount+1 & " was Clicked successfully")
		Else
			Call WriteToLog("Fail", "Expected Result: Corresponding Step is selected; Actual Result: Unable to click on Step: " &VapStepCount+1 & Err.Description)
		End If
		Select Case VapStepCount
				
				Case "0"
				
					Err.clear	
					'================================================
					'Verify the Step 1 functionality
					'================================================
					Call WriteToLog("Info","==========Testcase - Verify the Step 1 functionality of the Vascular Access Plan==========")    
					
					
					objAnticipatedCompleteDate.highlight
					
					If objAnticipatedCompleteDate.Exist(10) Then
						
						strAnticipatedDate = MID (objAnticipatedCompleteDate.getROPoperty("innertext"), 26, 10)
						print strAnticipatedDate
						
					End IF
					
					'================================================
					'Verify the Anticipated Complete Date
					'================================================	
					Call WriteToLog("Info","==========Testcase - Verify the Anticipated Complete Date in Step 1 functionality ==========")   

					
					'Check Agreed radio button existence and click on the radio button
					If objAgreedRadioButton.Exist(10) Then						
						objAgreedRadioButton.click						
					Else
						Call WriteToLog("Fail", "Expected Result:  Agreed Radio button does not exist; Actual Result: Agreed Radio button does not exist")
						Exit Function
					End If
					
									
					'Check the Existence of Agreed Date Edit box and set the value
					If objAgreedDatefield.Exist(10) Then
						objAgreedDatefield.set strPlanStartDate
					Else
						Call WriteToLog("Fail", "Expected Result: Agreed Date Edit box exists; Actual Result: Agreed Date Edit box does not exist")
						Exit Function
					End If
					
					Err.clear				
					'Click on the Save button
					If objSaveButton.Exist(10) Then

						objSaveButton.click
						If Err.Number = 0  Then
							Call WriteToLog("Pass","Step 1: Patient Acceptance is saved successfully")
						Else
							Call WriteToLog("Fail", "Expected Result: Patient Acceptance is saved; Actual Result: Step 1: Patient Acceptance is not saved successfully")
							
						End If
					Else
						Call WriteToLog("Fail", "Save button does not exist")
						Exit Function
					End If
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					'Message box should be displayed, when clicked on the save button.
					blnReturnValue = checkForPopup("Changes Saved", "Ok", "Changes saved successfully.", strOutErrorDesc)
	
					If blnReturnValue Then
						Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
					Else
						Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
						Exit Function
					End If	
				
			Case "1" 'Step 2 -Vessel Mapping Step

					Err.clear	
					'================================================
					'Verify the Step 2 functionality
					'================================================
					Call WriteToLog("Info","==========Testcase - Verify the Step 2-Vessel Mapping functionality of the Vascular Access Plan==========")    
					
												
					'Check the Existence of Appointment Date field and set the value
					If objAppointmentDate.Exist(10) Then
						objAppointmentDate.set strPlanStartDate
					Else
						Call WriteToLog("Fail", "Appointment Date field does not exist")
						Exit Function
					End If
					
					
													
					'Check the Existence of Complete Date field and set the value
					If objCompleteDate.Exist(10) Then
						objCompleteDate.set strPlanStartDate
					Else
						Call WriteToLog("Fail", "Complete Date field does not exist")
						Exit Function
					End If
					
					
					Err.clear				
					'Click on the Save button
					If objSaveButton.Exist(10) Then

						objSaveButton.click
						If Err.Number = 0  Then
							Call WriteToLog("Pass","Step 2: Vessel Mapping is saved successfully")
						Else
							Call WriteToLog("Fail", "Expected Result:Vessel Mapping is saved; Actual Result: Step 2: Vessel Mapping is not saved successfully")
							
						End If
					Else
						Call WriteToLog("Fail", "Save button does not exist")
						Exit Function
					End If
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					'Message box should be displayed, when clicked on the save button.
					blnReturnValue = checkForPopup("Changes Saved", "Ok", "Changes saved successfully.", strOutErrorDesc)
	
					If blnReturnValue Then
						Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
					Else
						Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
						Exit Function
					End If	
					
			Case "2" 'Step 3 -Surgical Evaluation

					Err.clear	
					'=======================================================
					'Verify the Step 3-Surgical Evaluation functionality
					'=======================================================
					Call WriteToLog("Info","==========Testcase - Verify the Step 3-Surgical Evaluation functionality of the Vascular Access Plan==========")    
					
												
					'Check the Existence of Appointment Date field and set the value
					If objAppointmentDate.Exist(10) Then
						objAppointmentDate.set strPlanStartDate
					Else
						Call WriteToLog("Fail", "Appointment Date field does not exist")
						Exit Function
					End If
					
																		
					'Check the Existence of Complete Date field and set the value
					If objCompleteDate.Exist(10) Then
						objCompleteDate.set strPlanStartDate
					Else
						Call WriteToLog("Fail", "Complete Date field does not exist")
						Exit Function
					End If
					
					
					'Select the value for the Side drop dowm
					blnReturnValue =  selectComboBoxItem(objDelayReason, strDelayReason)
	
					If not(blnReturnValue) Then
						Call WriteToLog("Fail", "Delay Reason is not selected from dropdown. Error Returned:-" & strOutErrorDesc)
						Exit Function	
					End If
					
					
					Err.clear				
					'Click on the Save button
					If objSaveButton.Exist(10) Then

						objSaveButton.click
						If Err.Number = 0  Then
							Call WriteToLog("Pass","Step 3-Surgical Evaluation is saved successfully")
						Else
							Call WriteToLog("Fail", "Expected Result:Surgical Evaluation is saved; Actual Result: Step 3-Surgical Evaluation is not saved successfully")
							
						End If
					Else
						Call WriteToLog("Fail", "Save button does not exist")
						Exit Function
					End If
					
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					'Message box should be displayed, when clicked on the save button.
					blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)
	
					If blnReturnValue Then
						Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
					Else
						Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
						Exit Function
					End If	
	
			
			Case "3" 'Step 4 -Surgical Procedure functionality

					Err.clear	
					'======================================================
					'Verify the Step 4-Surgical Procedure functionality
					'======================================================
					Call WriteToLog("Info","==========Testcase - Verify the Step 4-Surgical Procedure functionality of the Vascular Access Plan==========")    
					
												
					'Check the Existence of Appointment Date field and set the value
					If objAppointmentDate.Exist(10) Then
						objAppointmentDate.set strPlanStartDate
					Else
						Call WriteToLog("Fail", "Appointment Date field does not exist")
						Exit Function
					End If
					
																		
					'Check the Existence of Complete Date field and set the value
					If objCompleteDate.Exist(10) Then
						objCompleteDate.set strPlanStartDate
					Else
						Call WriteToLog("Fail", "Complete Date field does not exist")
						Exit Function
					End If
					
					
					'Select the value for the Side drop dowm
					blnReturnValue =  selectComboBoxItem(objVAPSideDropDown, strSideValue)
	
					If not(blnReturnValue) Then
						Call WriteToLog("Fail", "Side Value is not selected from Side dropdown. Error Returned:-" & strOutErrorDesc)
					End If
					
					
					'Select the value for the Region drop dowm
					blnReturnValue =  selectComboBoxItem(objVAPRegionDropDown, strRegionValue)
	
					If not(blnReturnValue) Then
						Call WriteToLog("Fail", "Region Value is not selected from Region dropdown. Error Returned:-" & strOutErrorDesc)
					End If
					
					
					'Select the value for the Extremity drop dowm
					blnReturnValue =  selectComboBoxItem(objVAPExtremityDropDown, strExtremityValue)
	
					If not(blnReturnValue) Then
						Call WriteToLog("Fail", "Extremity Value is not selected from Extremity dropdown. Error Returned:-" & strOutErrorDesc)
					End If
					
					
					Err.clear				
					'Click on the Save button
					If objSaveButton.Exist(10) Then

						objSaveButton.click
						If Err.Number = 0  Then
							Call WriteToLog("Pass","Step 4-Surgical Procedure is saved successfully")
						Else
							Call WriteToLog("Fail", "Expected Result: Step 4-Surgical Procedure is saved. Actual Result: Step 4-Surgical Procedure is not saved successfully")
							
						End If
					Else
						Call WriteToLog("Fail", "Save button does not exist")
						Exit Function
					End If
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					'Message box should be displayed, when clicked on the save button.
					blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)
	
					If blnReturnValue Then
						Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
					Else
						Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
						Exit Function
					End If	
			
			Case "4" 'Step 5 -Evaluation for Maturation

				Err.clear	
				'======================================================
				'Verify the Step 5 -Evaluation for Maturation functionality
				'======================================================
				Call WriteToLog("Info","==========Testcase - Verify the Step 5-Evaluation for Maturation of the Vascular Access Plan==========")    
				
				objSkipStep.highlight							
				'Check the Existence of Skip Step Checkbox field and set the value
				If objSkipStep.Exist(10) Then
					objSkipStep.click
					If Err.Number = 0  Then
						Call WriteToLog("Pass","Skip Step Checkbox was selected")
					Else
						Call WriteToLog("Fail", "Skip Step Checkbox was selected")
						
					End If
					
				Else
					Call WriteToLog("Fail", "Skip Step Checkbox does not exist" &Err.Description)
					Exit Function
				End If
				
				
								
				Err.clear				
				'Click on the Save button
				If objSaveButton.Exist(10) Then

					objSaveButton.click
					If Err.Number = 0  Then
						Call WriteToLog("Pass","Step 5 -Evaluation for Maturation is saved successfully")
					Else
						Call WriteToLog("Fail", "Expected Result: Step 5 -Evaluation for Maturation is saved; Actual Result:Step 5 -Evaluation for Maturation is not saved successfully")
						
					End If
				Else
					Call WriteToLog("Fail", "Save button does not exist")
					Exit Function
				End If
				Wait 2
				waitTillLoads "Loading..."
				wait 2
				
				
				'Message box "Is another Surgical Procedure required?" should be displayed, when clicked on the save button, Click "No" on the message box.
				blnReturnValue = checkForPopup("Access Management", "No", "Is another Surgical Procedure required?", strOutErrorDesc)

				If blnReturnValue Then
					Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
				Else
					Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
					Exit Function
				End If	
		
				Wait 2
				waitTillLoads "Loading..."
				wait 2
				
				'Message box should be displayed, when clicked on the save button.
				blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)

				If blnReturnValue Then
					Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
				Else
					Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
					Exit Function
				End If	
		
		Case "5" 'Step 6 -1st Cannulation

				Err.clear	
				'===========================================================
				'Verify the Step 6 -1st Cannulation functionality
				'===========================================================
				Call WriteToLog("Info","==========Testcase - Verify the Verify the Step 6 -1st Cannulation functionality of the Vascular Access Plan==========")    
		
														
				'Check the Existence of Appointment Date field and set the value
				If objAppointmentDate.Exist(10) Then
					objAppointmentDate.set strPlanStartDate
				Else
					Call WriteToLog("Fail", "Appointment Date field does not exist")
					Exit Function
				End If
				
																	
				'Check the Existence of Complete Date field and set the value
				If objCompleteDate.Exist(10) Then
					objCompleteDate.set strPlanStartDate
				Else
					Call WriteToLog("Fail", "Complete Date field does not exist")
					Exit Function
				End If
				
				
								
				Err.clear				
				'Click on the Save button
				If objSaveButton.Exist(10) Then

					objSaveButton.click
					If Err.Number = 0  Then
						Call WriteToLog("Pass","Step 6 -1st Cannulation is saved successfully")
					Else
						Call WriteToLog("Fail", "Expected Result: Step 6 -1st Cannulation is saved; Actual Result:Step 6 -1st Cannulation is not saved successfully")
						
					End If
				Else
					Call WriteToLog("Fail", "Save button does not exist")
					Exit Function
				End If
				Wait 2
				waitTillLoads "Loading..."
				wait 2
				
				
				'Message box "Is another Surgical Procedure required?" should be displayed, when clicked on the save button.
				blnReturnValue = checkForPopup("Access Management", "No", "Is another Surgical Procedure required?", strOutErrorDesc)

				If blnReturnValue Then
					Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
				Else
					Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
					Exit Function
				End If	
		
				Wait 2
				waitTillLoads "Loading..."
				wait 2
				
				'Message box should be displayed, when clicked on the save button.
				blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)

				If blnReturnValue Then
					Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
				Else
					Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
					Exit Function
				End If	
				
				
		Case "6" 'Step 7 -CVC Out

				Err.clear	
				'===========================================================
				'Verify the Step 7 -CVC Out functionality
				'===========================================================
				Call WriteToLog("Info","==========Testcase - Verify the Step 7 -CVC Out functionality of the Vascular Access Plan==========")    
		
														
				'Check the Existence of Appointment Date field and set the value
				If objAppointmentDate.Exist(10) Then
					objAppointmentDate.set strPlanStartDate
				Else
					Call WriteToLog("Fail", "Appointment Date field does not exist")
					Exit Function
				End If
				
																	
				'Check the Existence of Complete Date field and set the value
				If objCompleteDate.Exist(10) Then
					objCompleteDate.set strPlanStartDate
				Else
					Call WriteToLog("Fail", "Complete Date field does not exist")
					Exit Function
				End If
				
				
								
				Err.clear				
				'Click on the Save button
				If objSaveButton.Exist(10) Then

					objSaveButton.click
					If Err.Number = 0  Then
						Call WriteToLog("Pass","Step 7 -CVC Out is saved successfully")
					Else
						Call WriteToLog("Fail", "Expected Result: Step 7 -CVC Out is saved; Actual Result: Step 7 -CVC Out is not saved successfully")
						
					End If
				Else
					Call WriteToLog("Fail", "Save button does not exist")
					Exit Function
				End If
				Wait 2
				waitTillLoads "Loading..."
				wait 2
				
				
							
				'Message box should be displayed, when clicked on the save button.
				blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)

				If blnReturnValue Then
					Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
				Else
					Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
					Exit Function
				End If	
	
		End Select
		
		
		Set objVAPStep = Nothing
		
		
	Next
	
	
	'===============================
	'Kill the objects
	'===============================
	
	Execute "Set objVascularAccessPlanTab = Nothing" 
	Execute "Set objNewPlanButton = Nothing" 
	Execute "Set objPlanStartDate = Nothing"
	Execute "Set objStopButton = Nothing" 
	Execute "Set objStopDate = Nothing" 
	Execute "Set objAgreedRadioButton = Nothing" 
	Execute "Set objAgreedDatefield = Nothing" 
	Execute "Set objSaveButton = Nothing" 
	Execute "Set objChangesSavedOk = Nothing" 
	Execute "Set objAnticipatedCompleteDate = Nothing" 
	Execute "Set objAppointmentDate = Nothing" 
	Execute "Set objCompleteDate = Nothing" 	
	Execute "Set objDelayReason = Nothing" 
	Execute "Set objVAPSideDropDown = Nothing" 
	Execute "Set objVAPRegionDropDown = Nothing" 
	Execute "Set objVAPExtremityDropDown = Nothing" 
	Execute "Set objSkipStep = Nothing" 	
	
	
	VascularAccessPlan = True
	
	
End Function

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'#######################################################################################################################################################################################################
'Function Name		 : AddNewPlanForVascularAccessPlan
'Purpose of Function : Purpose of this function is to Add the Vascular Access plan
'Input Arguments	 : strPlanStartDate:-Plan Start date for Vascular Access plan
'					 : strDesiredPermanentValue:- Desired Permanent Access value for Vascular Access plan
'Output Arguments	 : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call	 : blnReturnValue = AddNewPlanForVascularAccessPlan (strPlanStartDate,strDesiredPermanentValue,strOutErrorDesc)
'Author				 : Sharmila (Script from Citious Tech, later modified).
'Date				 : 20-Jan-2016
'##################################################################################################################################################################################

Function AddNewPlanForVascularAccessPlan(ByVal strPlanStartDate,ByVal strDesiredPermanentValue,strOutErrorDesc)
	
	 Err.Clear
	 strOutErrorDesc = ""
	 On Error Resume Next
	 AddNewPlanForVascularAccessPlan = False
	 
	'=====================================
	'Objects required for test execution
	'=====================================
	 
	'Create object required for ToStopPlanOfVascularAcessManagement function	
	Execute "Set objNewPlanButton = " & Environment.Value("WB_Access_NewPlanButton") 'object for New Plan button
	Execute "Set objPlanStartDate = " & Environment.Value("WE_Access_PlanStartDate")'object for Plan Start Date
	Execute "Set objDesiredPermanentAccessButton = " & Environment.Value("WB_Access_DesiredPermanentAccess") 'object for Desired Permanent Access button
	Execute "Set objDesiredPermanentDropdown = " & Environment.Value("WEL_Access_DesiredPermanentDropdown") 'object for Desired Permanent drop down
	Execute "Set objStartPlanOkButton = " & Environment.Value("WB_Access_StartPlanOkButton") 'object for Start plan ok button
	Execute "Set objOkButton = " & Environment.Value("WB_Access_ChangesSavedOk") 'object for Messagebox ok button
	Execute "Set objStartPlanStepsBox = " & Environment.Value("WEL_Access_StartPlanStepsBox") 'object for Start plan Steps box
	
	'Click on the New Plan Button
	
	'Expand Vascular Access tab
	objNewPlanButton.Click
	If Err.Number = 0 Then
		Call WriteToLog("Pass","Clicked on the New Plan button")
	Else
		Call WriteToLog("Fail", "Expected Result:Clicked on the New Plan button; Actual Result: Unable to click on the New Plan button")
		Exit Function
	End If
	
	
	'Check  Plan Start Date field existence	 
	 objPlanStartDate.highlight
	 

	 If objPlanStartDate.Exist(2) Then
	 	objPlanStartDate.Set strPlanStartDate
	 	Call WriteToLog("Pass", "Plan Start Date edit box exist")
	 Else
		Call WriteToLog("Fail", "Plan Start Date edit box does not exist")
		Exit Function	
	 End If 
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	'Check Desired Permanent Access button field exist or not 	
	If objDesiredPermanentAccessButton.Exist(2) Then
		Call WriteToLog("Pass", "Desired Permanent Access field is exist")
	Else
		Call WriteToLog("Fail","Desired Permanent Access field does not exist")
		Exit Function	
	End If
	
	objDesiredPermanentAccessButton.highlight	
	
	
	'Select the value for combo box item for Desired Permanent Access 
	blnReturnValue =  selectComboBoxItem(objDesiredPermanentAccessButton, strDesiredPermanentValue)
	
	If blnReturnValue Then
		Call WriteToLog("Pass","Desired permanent access dropdown value is selected.")
	Else
		Call WriteToLog("Fail","Expected Result:Desired permanent access dropdown value is selected; Actual Result: Error selecting dropdown values for Desired permanent access.")
		Exit Function
	End If

	
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	
	
	'Click on the Ok button on Start Plan dialog
	blnReturnValue = ClickButton("Ok",objStartPlanOkButton,strOutErrorDescButton)
	If not blnReturnValue Then
		strOutErrorDesc = strOutErrorDescButton
		Exit Function
	End If
	
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	
	blnReturnValue = checkForPopup("Changes Saved", "Ok", "Changes saved successfully.", strOutErrorDesc)
	
	If blnReturnValue Then
		Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
	Else
		Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
		Exit Function
	End If

	'====================
	'Kill the objects
	'====================
	
	Execute "Set objNewPlanButton = Nothing" 
	Execute "Set objPlanStartDate = Nothing" 
	Execute "Set objDesiredPermanentAccessButton = Nothing" 
	Execute "Set objDesiredPermanentDropdown = Nothing" 
	Execute "Set objStartPlanOkButton = Nothing" 
	Execute "Set objOkButton = Nothing"
	Execute "Set objStartPlanStepsBox = Nothing" 



	AddNewPlanForVascularAccessPlan = True
	
End Function

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'#######################################################################################################################################################################################################
'Function Name		 : ToStopPlanOfVascularAcessManagement
'Purpose of Function : Purpose of this function is to stop the Vascular Access plan
'Input Arguments	 : strStopDate:-Stop date fpr Vascular Access plan
'					 : strStopReason:- Reason for stopping Vascular Access plan
'Output Arguments	 : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call	 : blnReturnValue = ToStopPlanOfVascularAcessManagement (strStopDate,strStopReason,strOutErrorDesc)
'Author				 : Sharmila
'Date				 : 29-Jan-2016
'######################################################################################################################################################################################

Function ToStopPlanOfVascularAcessManagement(Byval strStopDate , ByVal strStopReason,strOutErrorDesc)

	 Err.Clear
	 On Error Resume Next
	 ToStopPlanOfVascularAcessManagement = False
	 
	 
	'=====================================
	'Objects required for test execution
	'=====================================
	 
	Execute "Set objStopButton = " & Environment.Value("WB_Acess_stopButton") 		'object for Stop button in VAP
	Execute "Set objStopDate = " & Environment.Value("WE_Acess_StopDate")			'object for Stop Date field
	Execute "Set objStopReason = " & Environment.Value("WB_Access_StopReason")		'object for Stop Reason dropdown
	Execute "Set objOkButton = " & Environment.Value("WB_Access_ChangesOkButton")	'object for OK button
	Execute "Set objStopPlanPopupStop = " & Environment.Value("WB_Acess_StopPlanPopupStop")	'object for Stop button on the Stop popup
	
	
	'Check Stop button exist or not 	
	If objStopButton.Exist(2) Then
		Call WriteToLog("Pass", "Stop button exists")
	Else
		Call WriteToLog("Fail", "Expected Result: Stop button exists; Actual Result: Stop button does not exist")
		Exit Function	
	End If 
	
	'Check Stop button is enable or not	
	strDisable = objStopButton.getRoProperty("disabled")
	If strDisable = 0  Then
		Call WriteToLog("Pass", "Stop Plan button is enabled")	
	Else
		Call WriteToLog("Fail", "Expected Result:Stop Plan button is enabled; Actula Result: Stop Plan button is disabled")
		Exit Function				
	End If
		
	'Check dialog should appear after clicking on the Stop button
	blnReturnValue = ClickButton("Stop",objStopButton,strOutErrorDescButton)
	If not blnReturnValue Then
		Call WriteToLog("Fail", "Error in clicking Stop button:" &strOutErrorDescButton)
		Exit Function
	End If
	
	objStopDate.highlight	
	'Check Stop Date field existence
	If objStopDate.Exist(10) Then
		Call WriteToLog("Pass", "Stop Date edit box is exist")
	Else
		Call WriteToLog("Fail","Stop Date edit box does not exist")
	End If 
	
	'Set value  to Stop Date field	
	objStopDate.set strStopDate
	If Err.Number = 0 Then
		Call WriteToLog("Pass","Date is selected from Stop Date field")
	Else
		Call WriteToLog("Fail","Unable to set date for Stop Date field. Error Returned :" & Err.Description)
	End If
		
	'Check Stop Reason field exist or not 	
	If objStopReason.Exist(2) Then
		Call WriteToLog("Pass", "Stop Reason field is exist")
	Else
		Call WriteToLog("Fail","Stop Reason field does not exist")
	End If

	'Select Reason from Stop Reason dropdown
	blnReturnValue =  selectComboBoxItem(objStopReason, strStopReason)
	
	If not(blnReturnValue) Then
		Call WriteToLog("Fail"," Stop Reason is not selected from Stop Reason dropdown. Error Returned:-" & strOutErrorDesc)
		Exit Function	
	End If
	
	'Check the existence of Stop button on Stop dialog and click on it
	If objStopPlanPopupStop.Exist(10) Then
		Call WriteToLog("Pass", "Stop button exist")
	Else
		Call WriteToLog("Fail", "Stop button does not exist")
	End If
	
'	'Wait till Stop button on Stop Plan is enabled 	
'	blnReturnValue = objStopPlanPopupStop.waitproperty("disabled",0,3000)
'	If not(blnReturnValue) Then
'			strOutErrorDesc = "Stop button is not enabled"
'	Exit Function
'	End If
	
	'Click on the Stop button on Stop dialog
	blnReturnValue = ClickButton("Stop",objStopPlanPopupStop,strOutErrorDescButton)
	If not blnReturnValue Then
		Call WriteToLog("Fail","Error in clicking Stop button in Stop popup dialog:" &strOutErrorDescButton)
		Exit Function
	End If
	
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'Check for Message Box popup
	blnReturnValue = checkForPopup("Changes Saved", "Ok", "Changes saved successfully.", strOutErrorDesc)
	
	If blnReturnValue Then
		Call WriteToLog("Pass","Changes Saved Successfully message box was dispalyed")
	Else
		Call WriteToLog("Fail","Expected Result: Successfully Saved message box should be displayed; Actual Result: Error return: "&strOutErrorDesc)
		Exit Function
	End If
	
			
	'==================
	'Kill the objects
	'==================
	
	Execute "Set objStopButton = Nothing" 
	Execute "Set objStopDate = Nothing" 
	Execute "Set objStopReason = Nothing"
	Execute "Set objOkButton = Nothing" 
	Execute "Set objStopPlanPopupStop = Nothing"		
			
	ToStopPlanOfVascularAcessManagement = True

End Function
