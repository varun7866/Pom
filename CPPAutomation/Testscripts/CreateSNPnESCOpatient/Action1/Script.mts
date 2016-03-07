 '**************************************************************************************************************************************************************************
' TestCase Name			: CreateSNPnESCOpatient
' Purpose of TC			: Create an SNP or ESCO patient with all required values and get the name of assigned VHN
' Author                : Gregory
' Date                  : 08 December 2015
' Environment			: QA/Train/Stage (url as described in Config file)
' Comments				: This script is meant for creating single/multiple SNP, ESCO patients as required by user
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "CreateSNPnESCOpatient", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'Get all required scenarios
intRowCout = DataTable.GetSheet("CurrentTestCaseData").GetRowCount
For RowNumber = 1 to intRowCout: Do
	DataTable.SetCurrentRow(RowNumber)
	
	'------------------------
	' Variable initialization
	'------------------------
	On Error Resume Next
	strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
	strPatientType = DataTable.Value("PatientType","CurrentTestCaseData")
	strPatientNames = DataTable.Value("PatientNames","CurrentTestCaseData")
	arrPatientNames = Split(strPatientNames,vblf,-1,1)
	strAddressDetails = DataTable.Value("AddressDetails","CurrentTestCaseData")
	strMedicalDetails = DataTable.Value("MedicalDetails","CurrentTestCaseData")
	Err.Clear
	
	strScriptPath = Environment.Value("TestDir") 
		'Execution as required
	If not Lcase(strExecutionFlag) = "y" Then Exit Do
		
		'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------
		
		Call WriteToLog("Info","--------------------------------------------Creating "&strPatientType&" patient--------------------------------------------") 

		For P = 1 To UBound(arrPatientNames)+1 Step 1
			
			If LCase(Trim(strPatientType)) = "snp" Then			
				Call WriteToLog("Info","----------------Creating SNP patient with name: '"&arrPatientNames(P-1)&"'----------------") 
			ElseIf LCase(Trim(strPatientType)) = "esco" Then			
				Call WriteToLog("Info","----------------Creating ESCO patient with name: '"&arrPatientNames(P-1)&"'----------------") 
			End If
			
			On Error Resume Next
			Err.Clear	
			
			'-------------------------------------------------
			'*Login as EPS and refer a new SNP or ESCO member.
			'-------------------------------------------------
			'Navigation: Login to EPS > CloseAllOpenPatients > SelectUserRoster 
			blnNavigator = Navigator("eps", strOutErrorDesc)
			If not blnNavigator Then
				Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
				Call Terminator											
			End If
			Call WriteToLog("Pass","Navigated to user dashboard")											
			Wait 0,500
	
			'Create new SNP or ESCO patient
			strNewPatientDetails = CreateNewPatientFromEPS(arrPatientNames(P-1),strAddressDetails,strMedicalDetails,strOutErrorDesc)
			If strNewPatientDetails = "" Then
				Call WriteToLog("Fail","Expected Result: User should be able to create new patient in EPS. Actual Result: Unable to  create new patient in EPS."&strOutErrorDesc)
				Call Terminator											
			End If
			
			If LCase(Trim(strPatientType)) = "snp" Then			
				Call WriteToLog("Pass","Created new SNP patient in EPS")
			ElseIf LCase(Trim(strPatientType)) = "esco" Then			
				Call WriteToLog("Pass","Created new ESCO patient in EPS")
			End If	
			
			Wait 1
			
			arrNewPatientDetails = Split(strNewPatientDetails,",",-1,1)
			lngMemberID = arrNewPatientDetails(0)
			
			'----------------
			'log out from eps
			Call Logout()
			Wait 2	
			'----------------
		
'			'-------------------------------------------
'			'*Login as VHN and get the assigned VHN name
'			'-------------------------------------------
'			'Login with required role
'			Call WriteToLog("Info","----------Login as VHN and get the assigned VHN name----------")
'			blnLogin = Login("vhn")
'			If not blnLogin Then
'				Call WriteToLog("Fail","Failed to Login to 'vhn' user.")
'				Call Terminator
'			End If
'			Call WriteToLog("PASS","Successfully logged into 'vhn' user")
'			Wait 2
'			Call waitTillLoads("Loading...")
'			Wait 2	
'			
'			'Get assigned VHN name
'			strAssignedVHN = GetAssingnedUserName(lngMemberID, strOutErrorDesc)
'			If strAssignedVHN = "" Then
'				Call WriteToLog("Fail","Expected Result: User should be able to open required patient in assigned VHN user.  Actual Result: Unable to open required patient in assigned VHN user."&strOutErrorDesc)
'				Call Terminator
'			End If
'			
'			If LCase(Trim(strPatientType)) = "snp" Then			
'				Call WriteToLog("Pass","Validated assigned VHN for newly created SNP patient")	
'			ElseIf LCase(Trim(strPatientType)) = "esco" Then			
'				Call WriteToLog("Pass","Validated assigned VHN for newly created ESCO patient")
'			End If	
'		
'			Wait 2	
'			
'			strPatient = arrPatientNames(P-1)
'			strScriptOutput = "'"&strAssignedVHN &"' is the assigned VHN for "&strPatientType&" patient: '"& strPatient & "' [Member ID: "& lngMemberID & "] ----- " & NOW & vbNewLine
'			RequiredTextFilePath = strScriptPath&"\AssignedVHNs.txt"	
'			
'			Call WriteOutputToText(strScriptOutput, RequiredTextFilePath)
'		
'			'----------------
'			Call WriteToLog("Info","--------------------------------------------Logout--------------------------------------------") 
'			'log out from vhn
'			Call Logout()
'			Wait 2	
'			'----------------
'			
		Next

'Iteration loop
Loop While False: Next
wait 2

'CloseAllBrowsers and write log footer
Call CloseAllBrowsers()
Call WriteLogFooter()


Function GetAssingnedUserName(ByVal lngPatientMemberID, strOutErrorDesc)	
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	GetAssingnedUserName = ""
		
	Execute "Set objGloSearch_GAUN = " &Environment("WE_GloSearch")'GlobalSearch TxtField	
	Execute "Set objGlobalSearchIcon__GAUN = " &Environment("WI_GlobalSearchIcon")'GlobalSearch icon	
	Execute "Set objGloSearchGrid__GAUN = " &Environment("WEL_GloSearchGrid")'PatientSearchResult popup OK btn	
			
	'Set patient MemID in global search search field
	Err.Clear	
	objGloSearch_GAUN.Set lngPatientMemberID
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set patient member ID in global search field: "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Patient member ID is set in global search field")
	Wait 1			
	
	'Clk on global search icon
	Err.Clear	
	objGlobalSearchIcon__GAUN.Click
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to click on global search icon: "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked global search icon")
	Wait 3
	Call waitTillLoads("Searching...")
	Wait 2
	
	'Verify 'no matching results found' message box exists when no patient found
    blnNoResultPopup = checkForPopup("Error", "Ok", "No matching results found", strOutErrorDesc)
    If blnNoResultPopup Then
		strOutErrorDesc = "Invalid Member ID"
		Exit Function
	End If
    
    'Check whether PatientSearchResult popup is available
    If not objGloSearchGrid__GAUN.Exist(10) Then
		strOutErrorDesc = "Unable to find PatientSearchResult popup"
		Exit Function
	End If
 	Call WriteToLog("Pass", "Patient Search Result popup is available")
  
  	'getting assigned user from Patient seacrh popup
  	Execute "Set objPage_GAUN = Nothing"
  	Execute "Set objPage_GAUN = " &Environment("WPG_AppParent")'Page object	
   	strPatientDetails = objPage_GAUN.WebTable("class:=k-selectable","column names:=.*"&lngPatientMemberID&".*","name:=WebTable","visible:=True").GetROProperty("column names")
    arrPatientDetails = Split(strPatientDetails,";",-1,1)
	strAssignedVHN_name = Trim(arrPatientDetails(4)) 'Assigned user's name is shown in 5th coulmn of Patient seacrh popup
	
	If strAssignedVHN_name = "" Then
		strOutErrorDesc = "Assigned user shows blank - Patient may be 'Termed' OR patient might not be assigned to VHN user"
		Exit Function
	End If
	Wait 1
	
	Execute "Set objPage_GAUN = " &Environment("WPG_AppParent")'Page object	
	Set objGridCancel_GAUN = objPage_GAUN.WebButton("html tag:=BUTTON","innertext:= Cancel","outerhtml:=.*data-capella-automation-id=""Global-Search-Button-Cancel.*","visible:=True")
	blnClickCancelButton = ClickButton("Cancel",objGridCancel_GAUN,strOutErrorDesc)
	If not blnClickCancelButton Then
		strOutErrorDesc = "Unable to click on Cancel button. "&strOutErrorDesc
		Exit Function
	End If	
	Wait 1
	
	GetAssingnedUserName = strAssignedVHN_name
	
	Execute "Set objPage_GAUN = Nothing"
	Execute "Set objGloSearch_GAUN = Nothing"
	Execute "Set objGlobalSearchIcon__GAUN = Nothing"	
	Execute "Set objGloSearchGrid__GAUN = Nothing"
	Set objGridCancel_GAUN = Nothing
	
End Function

Function Terminator()
	
	On Error Resume Next	
	Logout
	CloseAllBrowsers
	WriteLogFooter
	ExitAction

End Function
