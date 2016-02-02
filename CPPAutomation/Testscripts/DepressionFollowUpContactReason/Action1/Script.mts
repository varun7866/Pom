'**************************************************************************************************************************************************************************
' TestCase Name			: DepressionFollowUpContactReason
' Purpose of TC			: To validate Routine Contact Task due after Finalizing the Patient.
' Author                : Amar
' Date                  : 1 Dec. 2015
' Modified				: 1 Dec. 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04907 
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "DepressionFollowUpContactReason", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call Terminator
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath
	
'-----------------------------------------------------------------
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)

'------------------------
' Variable initialization
'------------------------
strPatientNameExternal = DataTable.Value("PatientNameExternal","CurrentTestCaseData")
lngMemberID = DataTable.Value("MemberId","CurrentTestCaseData")
strDomain = DataTable.Value("Domain","CurrentTestCaseData")
strTask = DataTable.Value("Task","CurrentTestCaseData")
strCreateContact = DataTable.Value("CreateContact","CurrentTestCaseData")
strNote = DataTable.Value("Note","CurrentTestCaseData") 
strEngagementStartScore = DataTable.Value("EngagementStartScore","CurrentTestCaseData")
strEngagementEndScore = DataTable.Value("EngagementEndScore","CurrentTestCaseData") 
strContactMethods = DataTable.Value("ContactMethods","CurrentTestCaseData")
strRespectiveResolutionsForContactMethods = DataTable.Value("RespectiveResolutionsForContactMethods","CurrentTestCaseData") 
strDatesForContacts = DataTable.Value("DatesForContacts","CurrentTestCaseData") 
strExternalTeamddvals = DataTable.Value("ExternalTeamddvals","CurrentTestCaseData") 
strInternalTeamddvals = DataTable.Value("InternalTeamddvals","CurrentTestCaseData") 
strReasonForContactMethods = DataTable.Value("ReasonForContactMethods","CurrentTestCaseData") 
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData") 

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objParent ="&Environment("WPG_AppParent")	'page object
Execute "Set objMyDashboard = "&Environment("WL_DashBoard") ' MyDashboard

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
On Error Resume Next
If not Lcase(strExecutionFlag) = "y" Then Exit Do

Call WriteToLog("Info","----------------Iteration for patient named '"&strPatientNameExternal&"'----------------") 
				
'Variables into usable format
arrContactMethod = Split(strContactMethods,",",-1,1)
arrRespectiveResolutionForContactMethod = Split(strRespectiveResolutionsForContactMethods,",",-1,1)
arrDateForContact = Split(strDatesForContacts,",",-1,1)
arrExternalTeamddval = Split(strExternalTeamddvals,",",-1,1)
arrInternalTeamddval = Split(strInternalTeamddvals,",",-1,1)
arrReasonForContactMethods = Split(strReasonForContactMethods,",",-1,1)
For Dtformat = 0 To Ubound(arrDateForContact) Step 1
	arrDateForContact(Dtformat) = DateFormat(arrDateForContact(Dtformat))
Next
Err.Clear

If Lcase(Trim(strCreateContact)) = "yes" Then

	'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("vhn", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")
	
	'Open required patient in assigned VHN user
	strGetAssingnedUserDashboard = GetAssingnedUserDashboard(lngMemberID, strOutErrorDesc)
	If strGetAssingnedUserDashboard = "" Then
		Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user. "&strOutErrorDesc)
		Call Terminator
	End If
	
	Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
	Wait 2
	
	'-----------------------------------------------------------------------------------------------------
	'Navigate to Menu of Actions > General Program Management domain > Routine Contact Due (date) task  
	'-----------------------------------------------------------------------------------------------------
	blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
	Wait 2
	'Testcase:Verify if ‘Routine Contact (date) due task is created upon patient enrollment.
	If Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
		Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should be available under '"&strDomain&"' domain; Actual Result: "&strOutErrorDesc)
		Call Terminator
	ElseIf not blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: Should be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass", "'"&strTask&"' task is available under '"&strDomain&"' domain as expected")
	Wait 5

	Call waitTillLoads("Loading...")
	Wait 2
	
	'Close Some Date May Be Out of Date' popup
	Call checkForPopup("Some Data My Be Out of Date","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
	Err.Clear
	Wait 2
	'Close 'Disclaimer' popup
	Call checkForPopup("Disclaimer","OK", "The information contained in the Wolters Kluwer Health", strOutErrorDesc)
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2		
	Err.Clear

	Call WriteToLog("Info","--------------------Adding contact for selected patient--------------------")
	CMdetails = 0
	Dim arrCM_Details(5)	
	For CMdetails = 0 To ubound(arrContactMethod) Step 1
		strContactMethod = arrContactMethod(CMdetails)
		dtContactDt = arrDateForContact(CMdetails)
		strEngScores = strEngagementStartScore&","&strEngagementEndScore
		strReqdTeams = arrExternalTeamddval(CMdetails)&","&arrInternalTeamddval(CMdetails)
		strReqdReason = arrReasonForContactMethods(CMdetails)
		strReqdResolution = arrRespectiveResolutionForContactMethod(CMdetails)	
				
 		blnAddNewContactMethod = AddContactMethod1(strContactMethod, dtContactDt, strEngScores, strReqdTeams, strReqdReason, strReqdResolution, strOutErrorDesc)
		If not blnAddNewContactMethod Then
			Call WriteToLog("Fail","Expected Result: Should add new contact with required values; Actual Result: Failed to add contact :"&strOutErrorDesc)
			Call Terminator
		Else
			Call WriteToLog("Pass","Added contact with required values")
		End If
	Next
	Wait 5
	
	Call WriteToLog("Info","--------------------Finalizing and closing record for required patient and navigating to Dashboard for mousehover--------------------")
	'Closing patient record
	blnClosePatientRecord = ClosePatientRecord(strNote,strOutErrorDesc) 
	If not blnClosePatientRecord Then
		Call WriteToLog("Fail","Expected Result: Should close patient record.  Actual Result: Failed to close patient record: "&strOutErrorDesc)
		Call Terminator
	Else
		Call WriteToLog("Pass","Closed patient record")
	End If
	wait 2

	Call waitTillLoads("Saving contact for "&strPatientName)
	Wait 5
	
	'Logout of application
	'---------------------
	Call WriteToLog("Info","--------------------Logout of application--------------------")
	Call Logout()
	Wait 2		
	
	'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("vhn", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")
	
	'Open required patient in assigned VHN user
	strGetAssingnedUserDashboard = GetAssingnedUserDashboard(lngMemberID, strOutErrorDesc)
	If strGetAssingnedUserDashboard = "" Then
		Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user. "&strOutErrorDesc)
		Call Terminator
	End If
	
	Call WriteToLog("Pass","Opened required patient in assigned VHN user "&strGetAssingnedUserDashboard&"'s dashboard")
	Wait 2
	
	'-----------------------------------------------------------------------------------------------------
	'Navigate to Menu of Actions > General Program Management domain > Routine Contact Due (date) task  
	'-----------------------------------------------------------------------------------------------------
	blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
	Wait 2
	'Testcase:Verify if ‘Initial Advanced Care Plan’ due task is created upon patient enrollment.
	If not Instr(1,strOutErrorDesc,"Unable to find '"&strTask&"' task",1) > 0 Then
		Call WriteToLog("Fail", "Expected Result: '"&strTask&"' task should not be available under '"&strDomain&"' domain; Actual Result: "&strOutErrorDesc)
	ElseIf  blnDomainTasks Then
		Call WriteToLog("Fail", "Expected Result: Should not be able to validate '"&strTask&"' task under '"&strDomain&"' domain of MOAN; Actual Result: Unable to perform MOAN task validations: "&strOutErrorDesc)
	End If
		Call WriteToLog("Pass", "'"&strTask&"' task is not available under '"&strDomain&"' domain as expected")
			
End If	

'---------------------
'Logout of application
'---------------------
Call WriteToLog("Info","--------------------Logout of application--------------------")
Call Logout()
Wait 2

'Set objects free
Set objParent = Nothing	
Set objMyDashboard = Nothing


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

'==========================================================================================================================================================================================
'Function Name       :	AddContactMethod1
'Purpose of Function :	To add contact method with reduired details
'Input Arguments     :	strContactMethod: string value representing contact method
'					 :	dtContactDate: date value representing contact date
'					 :	strScores: string value representing engagement start and end dates delimited by ","
'					 :	strTeams: string value representing external and internal teams delimited by ","
'					 :	strResolution: string value representing contact resolution
'Output Arguments    :	Boolean value: Indicating add contact method status
'					 :  strOutErrorDesc:String value which contains error message occurred (if any) during function execution
'Example of Call     :	blnAddContactMethod1 = AddContactMethod1("Phone", "11/12/2015", "3-Extremely Engaged,3-Extremely Engaged", "Patient,Registered Nurse", "Completed", strOutErrorDesc)
'Author	      		 :	Gregory
'Date				 :	12 November 2015
'==========================================================================================================================================================================================
Function AddContactMethod1(ByVal strContactMethod,ByVal dtContactDate,ByVal strScores,ByVal strTeams,ByVal strReason,ByVal strResolution, strOutErrorDesc)
	
	On Error Resume Next
	AddContactMethod1 = False
	strOutErrorDesc = ""
	Err.Clear	
		
	'Creating Objects for getting into add contact popup
	Execute "Set objBrowsing = " &Environment("WI_ACMBrowser") 'Browser icon
	Execute "Set objRecapTitle = " &Environment("WEL_CM_RecapTitle") 'Title icon
	Execute "Set objAddButton = " &Environment("WI_ACMAdd") 'Add new contact icon
	Execute "Set objNewContactIcon = " &Environment("WEL_CM_ChCMTitle") 'Add new contact icon
	Execute "Set objCM_Date = "&Environment("WE_CMDate") 'Date field
	Execute "Set objEmail = " &Environment("WI_ACMEmail") 'Object for Email icon
	Execute "Set objFax = " &Environment("WI_ACMFax") 'Object for Fax icon
	Execute "Set objInPerson = " &Environment("WI_ACMInPerson") 'Object for In Person icon
	Execute "Set objPostal = " &Environment("WI_ACMPostal") 'Object for Postal icon
	Execute "Set objPhone = " &Environment("WI_ACMPhone") 'Object for Phone icon	
	Execute "Set objEngStartScoreDD = " &Environment("WEL_ACMEngStScoreDD") 'Engagement Start Score dropdown
	Execute "Set objEngEndScoreDD = " &Environment("WEL_ACMEngEdScoreDD") 'Engagement End Score
	Execute "Set objCalendarIcon = " &Environment("WB_ACMCal") 'Calendar icon
	Execute "Set objCM_ClearDate = "&Environment("WB_CMClearDate") 'ClearDate button	
	Execute "Set objExternalTeamDD ="&Environment("WB_CMExternalTeamdd") 'Choose Contact Method External Team dropdown
	Execute "Set objInternalTeamDD ="&Environment("WB_CMInternalTeamdd") 'Choose Contact Method Internal Team dropdown
	Execute "Set objReasonDD ="&Environment("WB_CMReasondd") 'Choose Contact Method Reason dropdown
	Execute "Set objResolutionDD = " &Environment("WEL_ACMResolutionDD") 'Resolution
	Execute "Set objCM_OK= " &Environment("WI_ACM_OK") 'OKimage
	
	arrScores = Split(strScores,",",-1,1)
	strEngStartScore = arrScores(0)
	strEngEndScore = arrScores(1)
	arrTeams = Split(strTeams,",",-1,1)
	strExternalTeam = arrTeams(0)
	strInternalTeam = arrTeams(1) 
	
	If dtContactDate = "" OR lcase(dtContactDate) = "na" Then
		dtContactDate = Date-1
	End If
	
	strContactMethod = Replace(strContactMethod," ","",1,-1,1)
	If strContactMethod = "Mail" Then
		strContactMethod = "Postal"
	End If
		
	'Click on Browse for Contact method icon
	Err.Clear
	objBrowsing.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click Browsing Icon : "&" Error returned: " & Err.Description
		Exit Function
	End If
		
	'Sync till Recap screen is visible
    blnReturnValue = objRecapTitle.WaitProperty("visible", True, 30000)    'Wait upto 30 secs for Recap screen to be visible
    If not blnReturnValue Then
        strOutErrorDesc = "Recap screen is not visible"
		Exit Function
    End If
    
	'Click on AddNewContact method icon
	Err.Clear
	objAddButton.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click Add new contact Icon : "&" Error returned: " & Err.Description
		Exit Function
	End If
		
	'Sync till ChooseContactMethod popup is visible
    blnReturnValue = objNewContactIcon.WaitProperty("visible", True, 30000)    'Wait upto 30 secs for ChooseContactMethod popup to be visible
    If not blnReturnValue Then
        strOutErrorDesc = "ChooseContactMethod popup is not visible"
		Exit Function
    End If
    Wait 1
		
	Select Case strContactMethod 
		Case "Email"
			Err.Clear
			objEmail.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Email Icon : "&" Error returned: " & Err.Description
				Exit Function
    		End If

		Case "Fax"
			Err.Clear
			objFax.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Fax Icon : "&" Error returned: " & Err.Description
       			Exit Function
    		End If
 		  
		Case "InPerson"
			Err.Clear
			objInPerson.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click InPerson Icon : "&" Error returned: " & Err.Description
 				Exit Function
    		End If

		Case "Postal"
			Err.Clear
			objPostal.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Mail Icon : "&" Error returned: " & Err.Description
				Exit Function
    		End If

		Case "Phone"
			Err.Clear
			objPhone.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Phone Icon : "&" Error returned: " & Err.Description
       			Exit Function
    		End If

	End Select
		
	Err.Clear	
	objCalendarIcon.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click Calendar Icon : "&" Error returned: " & Err.Description
		Exit Function
	End If

	Err.Clear
	objCM_ClearDate.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click CalendarClear Icon : "&" Error returned: " & Err.Description
		Exit Function
	End If
	
	'set contact date
	Err.Clear	
	objCM_Date.Set dtContactDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set contact date: "&Err.Description
		Exit Function
    End If
	Wait 1		
	
	'select start score
	blnEngStartScore = selectComboBoxItem(objEngStartScoreDD, strEngStartScore)
	If Not blnEngStartScore Then
		strOutErrorDesc = "Unable to select Engagement Start Score "&strOutErrorDesc
		Exit Function
	End If
	Wait 1	
	
	'select end score
	blnEngEndScore = selectComboBoxItem(objEngEndScoreDD, strEngEndScore)
	If Not blnEngEndScore Then
		strOutErrorDesc = "Unable to select Engagement End Score "&strOutErrorDesc
		Exit Function
	End If
	Wait 1		
	
	'select external team
	blnExternalTeam = selectComboBoxItem(objExternalTeamDD,strExternalTeam)
	If Not blnExternalTeam Then
		strOutErrorDesc = "Unable to select ExternalTeam "&strOutErrorDesc
		Exit Function
	End If
	
	'select internal team
	blnInternalTeam = selectComboBoxItem(objInternalTeamDD,strInternalTeam)
	If Not blnInternalTeam Then
		strOutErrorDesc = "Unable to select InternalTeam "&strOutErrorDesc
		Exit Function
	End If
	
	'select Reason
	blnReason = selectComboBoxItem(objReasonDD,strReason)
	If Not blnReason Then
		strOutErrorDesc = "Unable to select Reason "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Depression Follow Up available in the Contact Reason List as expected")
	
	'select resolution
	blnResolution = selectComboBoxItem(objResolutionDD,strResolution)
	If Not blnResolution Then
		strOutErrorDesc = "Unable to select Resolution "&strOutErrorDesc
		Exit Function
	End If
	
	'Clk on OK of ContactMethod popup
	Err.Clear
	objCM_OK.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click OK button : "&" Error returned: " & Err.Description
		Exit Function
    End If
    Wait 2
    
    Call waitTillLoads("Loading...")
    Wait 2
    
	AddContactMethod1 = True
	
	Execute "Set objBrowsing = Nothing"
	Execute "Set objRecapTitle = Nothing"
	Execute "Set objAddButton = Nothing"
	Execute "Set objNewContactIcon = Nothing"
	Execute "Set objCM_Date = Nothing"
	Execute "Set objEmail = Nothing"
	Execute "Set objFax = Nothing"
	Execute "Set objInPerson = Nothing"
	Execute "Set objPostal = Nothing"
	Execute "Set objPhone = Nothing"
	Execute "Set objEngStartScoreDD = Nothing"
	Execute "Set objEngEndScoreDD = Nothing"
	Execute "Set objCalendarIcon = Nothing"
	Execute "Set objCM_ClearDate = Nothing"
	Execute "Set objExternalTeamDD = Nothing"
	Execute "Set objInternalTeamDD = Nothing"
	Execute "Set objResolutionDD = Nothing"
	Execute "Set objCM_OK = Nothing"

End Function
