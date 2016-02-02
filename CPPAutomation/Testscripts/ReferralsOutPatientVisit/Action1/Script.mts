'**************************************************************************************************************************************************************************
' TestCase Name			: ReferralsOutPatientVisit
' Purpose of TC			: Validating newly implemented Referrals Screen and Referrals History.
' Author                : Amar
' Date                  : 26 November 2015
' Modified				: 18 December 2015
' Comments 				: This scripts covers testcases coresponding to user story B-05857
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ReferralsOutPatientVisit", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	ExitAction
End If
'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath			
			
'Get all required scenarios
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)
	
On Error Resume Next
'------------------------
' Variable initialization
'------------------------
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")
strProviderDetails =  DataTable.Value("ProviderDetails","CurrentTestCaseData")
strReferralsDetails =  DataTable.Value("ReferralsDetails","CurrentTestCaseData")
strMemberID =  DataTable.Value("MemberId","CurrentTestCaseData")

arrProviderDetails=Split(strProviderDetails,",",-1,1)
arrReferralsDetails=Split(strReferralsDetails,",",-1,1)

'Providers Details
strProviderName = Trim(arrProviderDetails(0))
strRefferedTo = Trim(arrProviderDetails(1))
strCity=Trim(arrProviderDetails(2))
strState=Trim(arrProviderDetails(3))
strZip=Trim(arrProviderDetails(4))
strEscoPayor=Trim(arrProviderDetails(5))
	
'Referrals details Info
strReferralDate=Trim(arrReferralsDetails(0))
strOutPatientVisit=Trim(arrReferralsDetails(1))
strAppointmentDate=Trim(arrReferralsDetails(2))
strSelection=Trim(arrReferralsDetails(3))

'-----------------------------------
'Objects required for test execution
'-----------------------------------
'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
Execute "Set objReferralsTab = "&Environment("WL_ReferralsTab") 'Referrals Tab
Execute "Set objReferralsPageComp = "&Environment("WEL_ReferralsPageComp") 'Referral screen
Execute "Set objRefHeaderInPage = "&Environment("WEL_RefHeaderInPage") 'Referrals Header
Execute "Set objIsOutPatientVisit = "&Environment("WEL_Referrals_IsOutPatientVisit") 'IsOutPatientVisit Value
Execute "Set objOutPatientVisit = "&Environment("WB_OutPatientVisit") 'OutPatientVisit
Execute "Set objReferralsAdd = "&Environment("WEL_Referrals_Add") 'Add Button
Execute "Set objReferralsCancel = "&Environment("WEL_Referrals_Cancel") 'Cancel Button
Execute "Set objProviderName = "&Environment("WE_ProviderName1") 'Provider Name
Execute "Set objReferredTo = "&Environment("WB_ReferredTo") 'Referred TO
Execute "Set objCity = "&Environment("WE_City") 'City
Execute "Set objState = "&Environment("WB_State") 'State
Execute "Set objZip = "&Environment("WE_Zip") 'Zip
Execute "Set objSelectVHN = "&Environment("WEL_SelectVHN") 'Select VHN
Execute "Set objSelectPatient = "&Environment("WEL_SelectPatient") 'Select Patient
Execute "Set objReferralDate = "&Environment("WE_ReferralScreen_ReferralDate") 'Referral Date
Execute "Set objOutPatientVisit = "&Environment("WB_OutPatientVisit") 'OutPatientVisit
Execute "Set objAppointmentScheduled = "&Environment("WEL_AppointmentScheduled") 'Appointment Scheduled
Execute "Set objAppointmentDate = "&Environment("WE_AppointmentDate") 'Appointment Date
Execute "Set objReferralsAdd = "&Environment("WEL_Referrals_Add") 'Add Button
Execute "Set objReferralsCancel = "&Environment("WEL_Referrals_Cancel") 'Cancel Button
Execute "Set objIsOutPatientVisit = "&Environment("WEL_Referrals_IsOutPatientVisit") 'IsOutPatientVisit Value
Execute "Set objPopUpOkBtn = "&Environment("WEB_Referrals_PopUpOkBtn") 'IsOutPatientVisit Value
	
'-----Execution as required---
If not Lcase(strExecutionFlag) = "y" Then Exit Do
Err.Clear

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("Info","----------Login to application, Close all open patients, Select user roster----------")
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

Wait 2

'Open required patient in assigned VHN user
strGetAssingnedUserDashboard = GetAssingnedUserDashboard(strMemberID, strOutErrorDesc)
If strGetAssingnedUserDashboard = "" Then
	Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user. "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
Wait 2

'Call WriteToLog("Info","----------------Select required patient from MyPatient List----------------")
''select the patient through global search
'blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
'If not blnGlobalSearchUsingMemID Then
'	Call WriteToLog("Fail","Expected Result: Should be able to select required patient through global search; Actual Result: Unable to select required patient through global search")
'	Call Terminator
'End If
'Call WriteToLog("Pass","Selected required patient through global search")
'Wait 5

Call WriteToLog("Info","----------------Validating availability of Referrals menu----------------")
If objReferralsTab.Exist(5) Then
	Call WriteToLog("Pass"," Referrals menu is available")
Else
	strOutErrorDesc = "Referrals menu is NOT available for the user"
	Call WriteToLog("Fail","Expected Result: Referrals menu should be available for the user.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Wait 1

Call WriteToLog("Info","----------------Validating newly implemented Referrels menu with existing view of referrals screen in Depression screening----------------")

'Clk on Referrals Tab
Err.Clear
objReferralsTab.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to click Referrals Tab: "& Err.Description
	Call WriteToLog("Fail", "Expected Result: Referrals Tab should be clicked.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Clicked Referrals Tab")
Wait 2

Call waitTillLoads("Loading...")
Wait 2

If objRefHeaderInPage.Exist(5) Then
	Call WriteToLog("Pass","Referrals page tab is available under newly implimented Referrals tab")
Else 
	strOutErrorDesc = "Referrals page tab is NOT available under newly implimented Referrals tab"
	Call WriteToLog("Fail", "Expected Result: Referrals page tab should be available under newly implimented Referrals menu.  Actual Result: "&strOutErrorDesc)
	Call Terminator	
End If
Wait 1

If objReferralsPageComp.Exist(5) Then

	'Testcase:Verify if the newly added field ‘Outpatient Visit’ is displayed under ‘Referrals’ screen.
	If not objOutPatientVisit.Exist(5) Then
			Call WriteToLog("Fail", "Expected Result: 'Outpatient Visit' should be available under 'Referrals Screen'; Actual Result:'Outpatient Visit' is not displayed under 'Referrals Screen'")
			Call Terminator
	End If
	Call WriteToLog("Pass", "'Outpatient Visit' is displayed under ‘Referrals’ screen as expected")
	
  '	Testcase:Verify for the default value under ‘Outpatient Visit’ of referrals screen.
	DefaultOutPatientVisit=objOutPatientVisit.getROProperty("outertext")
		
	If  not Instr(1,objOutPatientVisit.getROProperty("outertext"),"Select a value",1) > 0 Then
			Call WriteToLog("Fail", "Expected Result: Default Value 'Select a value' should be displayed under ‘Outpatient Visit’ of 'Referrals Screen'; Actual Result:Default Value 'Select a value' is not displayed under ‘Outpatient Visit’ of 'Referrals Screen'")
			Call Terminator		
	End If
	Call WriteToLog("Pass", "Default Value 'Select a value' is displayed under ‘Outpatient Visit’ of 'Referrals Screen' as expected")

'	Testcase:Verify for the ‘Outpatient Visit’ dropdown values under ‘Referrals’ screen
'	Execute "Set objOutPatientVisit = "&Environment("WB_OutPatientVisit") 'OutPatientVisit
'	blnReturnValue = selectComboBoxItem(objOutPatientVisit, "Yes")
'	If not blnReturnValue Then
'		Call WriteToLog("Fail", "Expected Result: 'Yes' should be displayed under ‘Outpatient Visit’ drop down of 'Referrals Screen'; Actual Result:'Yes' is not displayed under ‘Outpatient Visit’ drop down of 'Referrals Screen'")
'		Call WriteLogFooter()
'		ExitAction
'	End If
'	Call WriteToLog("Pass", "'Yes' is displayed under ‘Outpatient Visit’ drop down of 'Referrals Screen' as expected")
'	Set objOutPatientVisit=nothing
'	Execute "Set objOutPatientVisit = "&Environment("WB_OutPatientVisit") 'OutPatientVisit
'	blnReturnValue = selectComboBoxItem(objOutPatientVisit, "No")
'	If not blnReturnValue Then
'		Call WriteToLog("Fail", "Expected Result: 'No' should be displayed under ‘Outpatient Visit’ drop down of 'Referrals Screen'; Actual Result:'No' is not displayed under ‘Outpatient Visit’ drop down of 'Referrals Screen'")
'		Call WriteLogFooter()
'		ExitAction
'	End If
'	Call WriteToLog("Pass", "'No' is displayed under ‘Outpatient Visit’ drop down of 'Referrals Screen' as expected")
'	blnReturnValue = selectComboBoxItem(objOutPatientVisit, "Select a value")
'	Set objOutPatientVisit=nothing
'	
   'Testcase:Verify ‘Outpatient Visit’ field is not displayed for other payors.(Non ESCO Payer)
	If lcase(strEscoPayor) = "no" Then
		If objOutPatientVisit.Exist(5) Then
			Call WriteToLog("Fail", "Expected Result: 'Outpatient Visit' should not be displayed under 'Referrals Screen'; Actual Result:'Outpatient Visit' is displayed under 'Referrals Screen'")
			Call Terminator
		End If
	Call WriteToLog("Pass", "'Outpatient Visit' is not displayed under ‘Referrals’ screen as expected")
	End If
	
	
	'Testcase:Verify if user is able to save a referral record without selecting value under ‘Outpatient Visit’ field of ‘Referrals’ screen.
'	Call ReferralsScreen(strProviderDetails,strReferralsDetails,strOutErrorDesc)
'	-------------------------------------------Add Referral----------------------------------------
	'Set value for Provider Name
	Err.Clear
		objProviderName.Set strProviderName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Provider Name field is not set. " & Err.Description
		Call Terminator
	End If
	
	Call WriteToLog("Pass", strProviderName & "is set to Provider Name field.")
	
	'Select value from Referred TO dropdown
	blnReturnValue = selectComboBoxItem(objReferredTo, strRefferedTo)
	If not blnReturnValue Then
		strOutErrorDesc = "Equipment Type field is not selected. " & strOutErrorDesc
		Call Terminator
	End If
	Call WriteToLog("Pass", strRefferedTo & " value is selected from RefferedTo dropdown")
	
	'Select VHN OR Patient
	If lcase(strSelection) = "vhn" Then
		objSelectVHN.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "VHN Option is not set ."& Err.Description
			Call Terminator
		End If
		Call WriteToLog("Pass",strSelection & "is set ")
		
	'Set Referral Date
	If waitUntilExist(objReferralDate, 10) Then
		Err.Clear
		objReferralDate.Set strReferralDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "ReferralDate field is not set. " & Err.Description
			Call Terminator
		End If
	Else
		strOutErrorDesc = "ReferralDate field is not present"
		Call Terminator		
	End If
	Call WriteToLog("Pass", "ReferralDate field is set to "&strReferralDate)
	
	If lcase(strEscoPayor) = "yes" Then
		'Select value from Outpatient Visit dropdown
		Execute "Set objIsOutPatientVisit = Nothing"
		Execute "Set objIsOutPatientVisit = "&Environment("WB_OutPatientVisit") 'IsOutPatientVisit Value
		objIsOutPatientVisit.highlight
		blnReturnValue = selectComboBoxItem(objOutPatientVisit, strOutPatientVisit)
		If not blnReturnValue Then
			strOutErrorDesc = "OutPatient Visit field is not selected. " & strOutErrorDesc
			Call Terminator
		End If
		Call WriteToLog("Pass", strOutPatientVisit & " value is selected from OutPatientVisit dropdown")
		End If
		Execute "Set objIsOutPatientVisit = Nothing"
			
		objAppointmentScheduled.click
		objAppointmentScheduled.click
		
		'Verify Add Button exists
		If not waitUntilExist(objReferralsAdd, 20) Then
			strOutErrorDesc = "ReferralsAdd button does not exist"
			Call Terminator	
		End If
		If not objReferralsAdd.Object.isDisabled Then
			blnReferrals_Add = ClickButton("Add",objReferralsAdd,strOutErrorDesc)
			If not blnReferrals_Add Then
				strOutErrorDesc = "Unable to click Referrals Add button: "&Err.Description
				Call Terminator
			End If
		End If
			Wait 1
		Call WriteToLog("Pass", "Clicked on Referrals Add btn")
		 
		Call waitTillLoads("Saving Referral...")
	
		strMessageTitle = "Referral Added"
		strMessageBoxText = "Referral has been added:"&strProviderName
	
		'Check the message box having text as "Referral has been added:"
		
		blnReferrals_Ok = ClickButton("Ok",objPopUpOkBtn,strOutErrorDesc)
		If not blnReferrals_Ok Then
			strOutErrorDesc = "Unable to click Referrals Add button: "&Err.Description
			Call Terminator
		End If
		Wait 2
	End If
'	-------------------------------------------	
	'Set value for Provider Name
	Err.Clear
		objProviderName.Set strProviderName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Provider Name field is not set. " & Err.Description
		Call Terminator
	End If
	
	Call WriteToLog("Pass", strProviderName & "is set to Provider Name field.")
	
	'Select value from Referred TO dropdown
	blnReturnValue = selectComboBoxItem(objReferredTo, strRefferedTo)
	If not blnReturnValue Then
		strOutErrorDesc = "Equipment Type field is nort selected. " & strOutErrorDesc
		Call Terminator
	End If
	Call WriteToLog("Pass", strRefferedTo & " value is selected from RefferedTo dropdown")
	'Select VHN OR Patient
	If lcase(strSelection) = "vhn" Then
		objSelectVHN.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "VHN Option is not set ."& Err.Description
			Call Terminator
		End If
			Call WriteToLog("Pass",strSelection & "is set ")
		
		'Set Referral Date
		If waitUntilExist(objReferralDate, 10) Then
			Err.Clear
			objReferralDate.Set strReferralDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "ReferralDate field is not set. " & Err.Description
			Call Terminator
		End If
	Else
		strOutErrorDesc = "ReferralDate field is not present"
		Call Terminator		
	End If
	Call WriteToLog("Pass", "ReferralDate field is set to "&strReferralDate)
		objAppointmentScheduled.click
		objAppointmentScheduled.click
	
	If lcase(strEscoPayor) = "yes" Then
		'Verify Add Button exists
		If not waitUntilExist(objReferralsAdd, 20) Then
			strOutErrorDesc = "ReferralsAdd button does not exist"
			Call Terminator	
		End If
		If not objReferralsAdd.Object.isDisabled Then
			blnReferrals_Add = ClickButton("Add",objReferralsAdd,strOutErrorDesc)
			If not blnReferrals_Add Then
				strOutErrorDesc = "Unable to click Referrals Add button: "&Err.Description
				Call Terminator
			End If
		End If
		wait 1
		strMessageTitle = "Invalid Data"
		strMessageBoxText = "Outpatient visit field is required."
		blnCheckForPop=checkForPopup(strMessageTitle,"OK",strMessageBoxText,strOutErrorDesc)
		If not blnCheckForPop Then
			Call WriteToLog("Fail", "Expected Result: Validation message saying 'Outpatient visit field is required.' should be displayed under 'Referrals Screen'; Actual Result:'Outpatient visit field is required.' is not displayed under 'Referrals Screen'")
			Call WriteLogFooter()
			Call Terminator
		End If
			Call WriteToLog("Pass", " Validation message saying 'Outpatient visit field is required.' is displayed under ‘Referrals’ screen as expected")
	End If
			Execute "Set objIsOutPatientVisit = Nothing"
			Execute "Set objIsOutPatientVisit = "&Environment("WB_OutPatientVisit") 'IsOutPatientVisit Value
			blnReturnValue = selectComboBoxItem(objOutPatientVisit, strOutPatientVisit)
			If not blnReturnValue Then
				strOutErrorDesc = "OutPatient Visit field is not selected. " & strOutErrorDesc
				Call Terminator
			End If
			Call WriteToLog("Pass", strOutPatientVisit & " value is selected from OutPatientVisit dropdown")
			Execute "Set objIsOutPatientVisit = Nothing"
			
			objAppointmentScheduled.click
			objAppointmentScheduled.click
			If not objReferralsAdd.Object.isDisabled Then
				blnReferrals_Add = ClickButton("Add",objReferralsAdd,strOutErrorDesc)
				If not blnReferrals_Add Then
					strOutErrorDesc = "Unable to click Referrals Add button: "&Err.Description
					Call Terminator
				End If
			End If
			Call waitTillLoads("Saving Referral...")
			
			strMessageTitle = "Referral Added"
			strMessageBoxText = "Referral has been added"
			blnCheckForPop=checkForPopup(strMessageTitle,"OK",strMessageBoxText,strOutErrorDesc)
			If not blnCheckForPop Then
				strOutErrorDesc = "Unable to click Referrals Ok button: "&Err.Description
				Call Terminator
			End If
			Wait 2
	
End If	
	
			
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Testcase:Verify if the ‘Outpatient Visit’ field under ‘Referral History’ screen is populated with the same value given under ‘Referrals’ screen.		
	'Testcase:Verify if user is able to edit the ‘Outpatient Visit’ field of ‘Referral History’ screen for ESCO patients.
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	If lcase(strEscoPayor) = "yes" Then
		clickOnSubMenu1("Patient Story->Referrals History")
		Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
		Set objReferralHistoryTable = objPage.WebTable("class:=k-selectable","cols:=12","html tag:=TABLE","visible:=True")
		intRefHisTblRC = objReferralHistoryTable.RowCount
		For RH_RC = 1 To intRefHisTblRC Step 1
			Set objProviderName_RHT = objReferralHistoryTable.ChildItem(RH_RC,1,"WebElement",0)
			If Lcase(trim(objProviderName_RHT.GetROProperty("outertext"))) = Lcase(trim(strProviderName)) Then
				objReferralHistoryTable.ChildItem(RH_RC,1,"WebElement",0).Highlight
				Wait 1
				Set objOutpatientVist_RHT = objReferralHistoryTable.ChildItem(RH_RC,10,"WebElement",0)
			If Lcase(trim(objOutpatientVist_RHT.GetROProperty("outertext"))) = Lcase(trim(strOutPatientVisit)) Then
				Call WriteToLog("Pass","The ‘Outpatient Visit’ field of ‘Referral History’ is populated with the same value given under ‘Referrals’ screen.")
				Setting.WebPackage("ReplayType") = 2
				objOutpatientVist_RHT.FireEvent "ondblclick"
				wait 10
				chars="No"
				sendKeys chars
				wait 1
				If Lcase(trim(objOutpatientVist_RHT.GetROProperty("outertext"))) = Lcase(trim(strOutPatientVisit)) Then
					Call WriteToLog("Pass","user is not able to edit the ‘Outpatient Visit’ field of ‘Referral History’ screen for ESCO patients.")
				else
					Call WriteToLog("Fail","user is able to edit the ‘Outpatient Visit’ field of ‘Referral History’ screen for ESCO patients.")	
				End If
				Exit For
			else
			 	Call WriteToLog("Fail","The ‘Outpatient Visit’ field of ‘Referral History’ is not populated with the same value given under ‘Referrals’ screen.")
				Exit For			 	
			End If
			End If
		Next
		End If
		
	'Testcase:Verify if ‘Outpatient Visit’ field under ‘Referral History’ is null for non ESCO patients.
	If lcase(strEscoPayor) = "no" Then
		clickOnSubMenu("Patient Story->Referrals History")
		Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
		Set objReferralHistoryTable = objPage.WebTable("class:=k-selectable","cols:=12","html tag:=TABLE","visible:=True")
		intRefHisTblRC = objReferralHistoryTable.RowCount
		For RH_RC = 1 To intRefHisTblRC Step 1
			Set objProviderName_RHT = objReferralHistoryTable.ChildItem(RH_RC,1,"WebElement",0)
			If Lcase(trim(objProviderName_RHT.GetROProperty("outertext"))) = Lcase(trim(strProviderName)) Then
				objReferralHistoryTable.ChildItem(RH_RC,1,"WebElement",0).Highlight
				Wait 1
				Set objOutpatientVist_RHT = objReferralHistoryTable.ChildItem(RH_RC,10,"WebElement",0)
				If Lcase(trim(objOutpatientVist_RHT.GetROProperty("outertext"))) = "null" Then
					Call WriteToLog("Pass","‘Outpatient Visit’ field under ‘Referral History’ is null for non ESCO patients")
				else
					Call WriteToLog("Fail","‘Outpatient Visit’ field under ‘Referral History’ is not null for non ESCO patients")				
				End If
				Exit For
			End If
				
		Next
	End If
	
End If
	
'logout of the application
Call WriteToLog("Info","-------------------Logout of application-------------------")
Call Logout()
Wait 2

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
	

	
	
	
	
	
	

