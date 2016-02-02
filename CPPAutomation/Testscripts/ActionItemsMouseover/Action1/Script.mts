'**************************************************************************************************************************************************************************
' TestCase Name			: ActionItemsMouseover
' Purpose of TC			: To validate ActionItems mouserover msg on Last attempted and Last completed contat dates, based of required filters
' Author                : Gregory
' Date                  : 03 May 2015
' Modified				: 5 October 2015
' Comments 				: This scripts covers testcases coresponding to user story B-04752 
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ActionItemsMouseover", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
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
strCreateContact = DataTable.Value("CreateContact","CurrentTestCaseData")
strPreviousContact = DataTable.Value("PreviousContact","CurrentTestCaseData")
strNote = DataTable.Value("Note","CurrentTestCaseData") 
strEngagementStartScore = DataTable.Value("EngagementStartScore","CurrentTestCaseData")
strEngagementEndScore = DataTable.Value("EngagementEndScore","CurrentTestCaseData") 
strContactMethods = DataTable.Value("ContactMethods","CurrentTestCaseData")
strRespectiveResolutionsForContactMethods = DataTable.Value("RespectiveResolutionsForContactMethods","CurrentTestCaseData") 
strDatesForContacts = DataTable.Value("DatesForContacts","CurrentTestCaseData") 
strExternalTeamddvals = DataTable.Value("ExternalTeamddvals","CurrentTestCaseData") 
strInternalTeamddvals = DataTable.Value("InternalTeamddvals","CurrentTestCaseData") 
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData") 
dtExistingContactAttemptedDate = DataTable.Value("ExistingContactAttemptedDate","CurrentTestCaseData") 
dtExistingContactCompletedDate = DataTable.Value("ExistingContactCompletedDate","CurrentTestCaseData") 

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
For Dtformat = 0 To Ubound(arrDateForContact) Step 1
	arrDateForContact(Dtformat) = DateFormat(arrDateForContact(Dtformat))
Next

'Iteration for patients who doesn't require contact creation
If Lcase(Trim(strCreateContact)) = "no" Then
	
	'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("vhn", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")
	
	If Lcase(Trim(strPreviousContact)) = "no" Then
		dtPreviousLAD = ""
		dtPreviousLCD = ""
	ElseIf Lcase(Trim(strPreviousContact)) = "yes" Then
		dtPreviousLAD = dtExistingContactAttemptedDate
		dtPreviousLCD = dtExistingContactCompletedDate
	End If	
	
	'-----------------------------------------------------------
	'Hoverover on required patient name and retrieve the message
	'-----------------------------------------------------------
	
	'Getting ActionItem patient mouseover msg values
	arrMouseMsgVals = ActionItemsPatientMouseoverMsg(strPatientNameExternal, strOutErrorDesc)
	If IsArrayEmpty(arrMouseMsgVals) Then
		Call WriteToLog("Fail","Expected Result: Should be able to retrieve Mousehover message values.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Retrieved Mousehover message values")
	
	'Parting array values
	For Mouseval = 0 To Ubound(arrMouseMsgVals) Step 1
		If Instr(1,arrMouseMsgVals(Mouseval),"SIG",1) Then
			strSIG = Trim(Mid(arrMouseMsgVals(Mouseval),Instr(1,arrMouseMsgVals(Mouseval),": ",1)+1))
		ElseIf Instr(1,arrMouseMsgVals(Mouseval),"TimeZone",1) Then
			strTimeZone = Trim(Mid(arrMouseMsgVals(Mouseval),Instr(1,arrMouseMsgVals(Mouseval),": ",1)+1))
		ElseIf Instr(1,arrMouseMsgVals(Mouseval),"Program",1) Then
			strProgram = Trim(Mid(arrMouseMsgVals(Mouseval),Instr(1,arrMouseMsgVals(Mouseval),": ",1)+1))
		ElseIf Instr(1,arrMouseMsgVals(Mouseval),"Last Attempted",1) Then
			dtMseovrLAD = Trim(arrMouseMsgVals(Mouseval)) 
			dtMseovrLAD = Trim(Replace(dtMseovrLAD,"Last Attempted:","",1,-1,1))
			If dtMseovrLAD = Trim(dtPreviousLAD) Then
				Call WriteToLog("Pass","Last Attempted Contact is displayed and is as per format")
			Else
				Call WriteToLog("Fail","Expected Result: Should be able to display valid Last Attempted Contact.  Actual Result: Last Attempted Contact displayed is Invalid")
				Call Terminator
			End If
		ElseIf Instr(1,arrMouseMsgVals(Mouseval),"Last Completed",1) Then
			dtMseovrLCD = Trim(arrMouseMsgVals(Mouseval)) 
			dtMseovrLCD = Trim(Replace(dtMseovrLCD,"Last Completed:","",1,-1,1))
			If dtMseovrLCD = Trim(dtPreviousLCD) Then
				Call WriteToLog("Pass","Last Completed Contact is displayed and is as per format")
			Else
				Call WriteToLog("Fail","Expected Result: Should be able to display valid Last Completed Contact.  Actual Result: Last Completed Contact displayed is Invalid")
				Call Terminator
				ExitAction
			End If
		End If 
		
	Next
		
'Iteration for patients who require contact creation		
ElseIf Lcase(Trim(strCreateContact)) = "yes" Then

	'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
	blnNavigator = Navigator("vhn", strOutErrorDesc)
	If not blnNavigator Then
		Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
		Call Terminator											
	End If
	Call WriteToLog("Pass","Navigated to user dashboard")
	
	Call WriteToLog("Info","--------------------Selecting required patient from ActionItems--------------------")
	blnPatientFromActionItems = OpenPatientProfileFromActionItemsList(strPatientNameExternal, strOutErrorDesc)
	If blnPatientFromActionItems Then
		Call WriteToLog("Pass","Required patient is selected from ActionItems list")
	Else
		strOutErrorDesc = "Required patient is NOT selected from ActionItems list: "&strOutErrorDesc
		Call WriteToLog("Fail", "Expected Result: Required patient should be selected from ActionItems list.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
	Wait 2
	
	Call WriteToLog("Info","--------------------Adding contact for selected patient--------------------")
	CMdetails = 0
	For CMdetails = 0 To ubound(arrContactMethod) Step 1
		strContactMethod = arrContactMethod(CMdetails)
		dtContactDt = arrDateForContact(CMdetails)
		strEngScores = strEngagementStartScore&","&strEngagementEndScore
		strReqdTeams = arrExternalTeamddval(CMdetails)&","&arrInternalTeamddval(CMdetails)
		strReqdResolution = arrRespectiveResolutionForContactMethod(CMdetails)	
		
 		blnAddNewContactMethod = AddContactMethod(strContactMethod, dtContactDt, strEngScores, strReqdTeams, strReqdResolution, strOutErrorDesc)
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
	Wait 2
	
	'FILTERING --------------------------------------------------------------------
	strContactMethods = DataTable.Value("ContactMethods","CurrentTestCaseData")
	strRespectiveResolutionsForContactMethods = DataTable.Value("RespectiveResolutionsForContactMethods","CurrentTestCaseData") 
	strDatesForContacts = DataTable.Value("DatesForContacts","CurrentTestCaseData") 
	strExternalTeamddvals = DataTable.Value("ExternalTeamddvals","CurrentTestCaseData") 
	strInternalTeamddvals = DataTable.Value("InternalTeamddvals","CurrentTestCaseData") 
	dtExistingContactAttemptedDate = DataTable.Value("ExistingContactAttemptedDate","CurrentTestCaseData") 
	dtExistingContactCompletedDate = DataTable.Value("ExistingContactCompletedDate","CurrentTestCaseData") 
	arrContactMethod = Split(strContactMethods,",",-1,1)
	arrRespectiveResolutionForContactMethod = Split(strRespectiveResolutionsForContactMethods,",",-1,1)
	arrExternalTeamddval = Split(strExternalTeamddvals,",",-1,1)
	arrInternalTeamddval = Split(strInternalTeamddvals,",",-1,1)
	For Dtformat = 0 To Ubound(arrDateForContact) Step 1
		arrDateForContact(Dtformat) = DateFormat(arrDateForContact(Dtformat))
	Next
	
	'Array of required filters 
	'FOT COMPLETED 
	ReDim ReqdContactFormatForCompletedContact(11)
			ReqdContactFormatForCompletedContact(0) = "PhoneRegistered NursePatient"
			ReqdContactFormatForCompletedContact(1) = "PhoneNurse PractitionerPatient"
			ReqdContactFormatForCompletedContact(2) = "PhoneLicensed Practical NursePatient"
			ReqdContactFormatForCompletedContact(3) = "PhoneRegistered NurseCaregiver or Family"
			ReqdContactFormatForCompletedContact(4) = "PhoneNurse PractitionerCaregiver or Family"
			ReqdContactFormatForCompletedContact(5) = "PhoneLicensed Practical NurseCaregiver or Family"
			ReqdContactFormatForCompletedContact(6) = "In PersonRegistered NursePatient"
			ReqdContactFormatForCompletedContact(7) = "In PersonNurse PractitionerPatient"
			ReqdContactFormatForCompletedContact(8) = "In PersonLicensed Practical NursePatient"
			ReqdContactFormatForCompletedContact(9) = "In PersonRegistered NurseCaregiver or Family"
			ReqdContactFormatForCompletedContact(10) = "In PersonNurse PractitionerCaregiver or Family"
			ReqdContactFormatForCompletedContact(11) = "In PersonLicensed Practical NurseCaregiver or Family"
			
	'FOR ATTEMPTED OR INCOMPLETE / MESSAGE		
	ReDim ReqdContactFormatForAttemptedContact(17)		
			ReqdContactFormatForAttemptedContact(0) = "PhoneRegistered NursePatient"
			ReqdContactFormatForAttemptedContact(1) = "PhoneNurse PractitionerPatient"
			ReqdContactFormatForAttemptedContact(2) = "PhoneLicensed Practical NursePatient"
			ReqdContactFormatForAttemptedContact(3) = "PhoneRegistered NurseCaregiver or Family"
			ReqdContactFormatForAttemptedContact(4) = "PhoneNurse PractitionerCaregiver or Family"
			ReqdContactFormatForAttemptedContact(5) = "PhoneLicensed Practical NurseCaregiver or Family"
			ReqdContactFormatForAttemptedContact(6) = "PhoneRegistered NurseCaregiver or Family"
			ReqdContactFormatForAttemptedContact(7) = "PhoneNurse PractitionerCaregiver or Family"
			ReqdContactFormatForAttemptedContact(8) = "PhoneLicensed Practical NurseCaregiver or Family"
			ReqdContactFormatForAttemptedContact(9) = "In PersonRegistered NursePatient"
			ReqdContactFormatForAttemptedContact(10) = "In PersonNurse PractitionerPatient"
			ReqdContactFormatForAttemptedContact(11) = "In PersonLicensed Practical NursePatient"
			ReqdContactFormatForAttemptedContact(12) = "In PersonRegistered NurseCaregiver or Family"
			ReqdContactFormatForAttemptedContact(13) = "In PersonNurse PractitionerCaregiver or Family"
			ReqdContactFormatForAttemptedContact(14) = "In PersonLicensed Practical NurseCaregiver or Family"
			ReqdContactFormatForAttemptedContact(15) = "In PersonRegistered NurseCaregiver or Family"
			ReqdContactFormatForAttemptedContact(16) = "In PersonNurse PractitionerCaregiver or Family"
			ReqdContactFormatForAttemptedContact(17) = "In PersonLicensed Practical NurseCaregiver or Family"	
	
	
	dtLastAttemptedDate = ""
	dtLastCompletedDate = ""
	
	For Resln = 0 To Ubound(arrContactMethod) Step 1
		If arrRespectiveResolutionForContactMethod(Resln) =  "Completed" Then
			strReqdContactFormatForCompletedContact = arrContactMethod(Resln)&arrInternalTeamddval(Resln)&arrExternalTeamddval(Resln) 'Filter
			For ReqFilt = 0 To Ubound(ReqdContactFormatForCompletedContact) Step 1
				If strReqdContactFormatForCompletedContact = ReqdContactFormatForCompletedContact(ReqFilt) Then
					dtLastCompletedDate = arrDateForContact(Resln)
				End If
			Next
		End If
	Next
		
		Resln = 0 
		
	For Resln = 0 To Ubound(arrContactMethod) Step 1	
		If arrRespectiveResolutionForContactMethod(Resln) =  "Attempted or Incomplete" OR arrRespectiveResolutionForContactMethod(Resln) =  "Message" Then
			strReqdContactFormatForAttemptedContact = arrContactMethod(Resln)&arrInternalTeamddval(Resln)&arrExternalTeamddval(Resln)
			For ReqFilt = 0 To Ubound(ReqdContactFormatForAttemptedContact) Step 1
				If strReqdContactFormatForAttemptedContact = ReqdContactFormatForAttemptedContact(ReqFilt) Then
					dtLastAttemptedDate = arrDateForContact(Resln)
				End If
			Next
		End If
	Next
	
	'check for previous entries and get latest contact dates for completed and attempted
	If dtExistingContactCompletedDate <>"" Then
		dtExistingContactCompletedDate = DateFormat(dtExistingContactCompletedDate)
	End If
	If dtExistingContactAttemptedDate <>"" Then
		dtExistingContactAttemptedDate = DateFormat(dtExistingContactAttemptedDate)
	End If
	
	
	intLADval = DateDiff("d",dtLastAttemptedDate,dtExistingContactAttemptedDate)
	If intLADval >= 0 Then
		dtLastAttemptedDate = dtExistingContactAttemptedDate
	End If
	
	intLCDval = DateDiff("d",dtLastCompletedDate,dtExistingContactCompletedDate)
	If intLCDval >= 0 Then
		dtLastCompletedDate = dtExistingContactCompletedDate
	End If
	
	'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Call WriteToLog("Info","----------------Logout and login for changes to happen in mousehover message contact dates----------------") 

	'Logout
	Call Logout()
	Wait 2

	'Login 
	Call WriteToLog("Info","------------------Login to VHN--------------------")
	blnLogin = Login("vhn")
	If not blnLogin Then
	Call WriteToLog("Fail","Failed to Login to VHN role.")
	Call Terminator
	End If
	
	Call WriteToLog("Pass","Successfully logged into VHN role")
	
	'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	Call WriteToLog("Info","--------------------Mousehover over patient named '"&strPatientNameExternal&"' and retrieving LastAttempted and LastCompleted contact dates, then validating both on required filters--------------------")
		
	'cLick Dashboard
	Err.Clear
	objMyDashboard.Click
	If Err.number = 0 Then
		Call WriteToLog("Pass","Clicked MyDashboard")
	Else
        strOutErrorDesc = "Unable to click MyDashboard"&Err.Description
       	Call WriteToLog("Fail","Expected Result: Should be able click MyDashboard  Actual Result: "&strOutErrorDesc)
		ExitAction		
	End If
	Wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2
	Err.Clear
	
	'-----------------------------------------------------------
	'Hoverover on required patient name and retrieve the message
	'-----------------------------------------------------------
	
	'Getting ActionItem patient mouseover msg values
	arrMouseMsgVals = ActionItemsPatientMouseoverMsg(strPatientNameExternal, strOutErrorDesc)
	If IsArrayEmpty(arrMouseMsgVals) Then
		strOutErrorDesc = "Unable to retrieve Mousehover message values"
		Call WriteToLog("Fail","Expected Result: Should be able to retrieve Mousehover message values.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Retrieved Mousehover message values")
	
	'Parting array values
	For Mouseval = 0 To Ubound(arrMouseMsgVals) Step 1
		If Instr(1,arrMouseMsgVals(Mouseval),"SIG",1) Then
			strSIG = Trim(Mid(arrMouseMsgVals(Mouseval),Instr(1,arrMouseMsgVals(Mouseval),": ",1)+1))
		ElseIf Instr(1,arrMouseMsgVals(Mouseval),"TimeZone",1) Then
			strTimeZone = Trim(Mid(arrMouseMsgVals(Mouseval),Instr(1,arrMouseMsgVals(Mouseval),": ",1)+1))
		ElseIf Instr(1,arrMouseMsgVals(Mouseval),"Program",1) Then
			strProgram = Trim(Mid(arrMouseMsgVals(Mouseval),Instr(1,arrMouseMsgVals(Mouseval),": ",1)+1))
					
		ElseIf Instr(1,arrMouseMsgVals(Mouseval),"Last Attempted",1) Then
			dtMseovrLAD = Trim(arrMouseMsgVals(Mouseval)) 
			dtMseovrLAD = Trim(Replace(dtMseovrLAD,"Last Attempted:","",1,-1,1))
			If dtMseovrLAD = dtLastAttemptedDate Then
				Call WriteToLog("Pass","Last Attempted Contact is displayed and is as per format")
			Else
				Call WriteToLog("Fail","Expected Result: Should be able to display valid Last Attempted Contact.  Actual Result: Last Attempted Contact displayed is Invalid")
				Call Terminator
			End If
				
		ElseIf Instr(1,arrMouseMsgVals(Mouseval),"Last Completed",1) Then
			dtMseovrLCD = Trim(arrMouseMsgVals(Mouseval)) 
			dtMseovrLCD = Trim(Replace(dtMseovrLCD,"Last Completed:","",1,-1,1))
			If dtMseovrLCD = dtLastCompletedDate Then
				Call WriteToLog("Pass","Last Completed Contact is displayed and is as per format")
			Else
				print "Fail"
				Call WriteToLog("Fail","Expected Result: Should be able to display valid Last Completed Contact.  Actual Result: Last Completed Contact displayed is Invalid")
				Call Terminator
			End If
			
		End If 
		
	Next
	
	dtLastAttemptedDate = ""
	dtLastCompletedDate = ""

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
