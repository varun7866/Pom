'**************************************************************************************************************************************************************************
' TestCase Name			: ReferralsMenu
' Purpose of TC			: Validating newly implemented Referrals menu.
' Author                : Gregory
' Date                  : 08 July 2015
' Modified				: 08 October 2015
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "ReferralsMenu", strOutTestName, strOutErrorDesc) 
If Not (blnReturnValue) Then
	Call WriteLogFooter()
	ExitAction
End If
'load repository xml file
orfilePath = Environment.Value("PROJECT_FOLDER") & "\Repository\" & Environment.Value("RepositoryFileName")
Environment.LoadFromFile orfilePath

'------------------------
' Variable initialization
'------------------------
lngMemberID = DataTable.Value("PatientMemberID","CurrentTestCaseData")
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strUser = DataTable.Value("User","CurrentTestCaseData")

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
Execute "Set objPatCaPln = "&Environment("WL_PatCaPlnTab") 'PatientCarePlan tab
Execute "Set objPatientListScrollbar = "&Environment("WEL_PatientListScrollbar") ' PatientList Scrollbar
Execute "Set objMyPatientsMainTab = "&Environment("WL_MyPatientsMainTab") 'My Patients tab
Execute "Set objReferralsTab = "&Environment("WL_ReferralsTab") 'Referrals Tab
Execute "Set objReferralsPageComp = "&Environment("WEL_ReferralsPageComp") 'Referral screen
Execute "Set objScreeningsTab = "&Environment("WL_ScreeningsTab") 'Screening tab
Execute "Set objDepressionScreeningLink = "&Environment("WL_DepressionScreeningLink") 'Depression screen link
Execute "Set objMaterialsLink = "&Environment("WEL_MaterialsLink") 'Meterials link
Execute "Set objScreeningLink = "&Environment("WEL_ScreeningLink") 'Screening link
Execute "Set objReferralsLink = "&Environment("WEL_ReferralsLink") 'Referrals link
Execute "Set objRefHeaderInPage = "&Environment("WEL_RefHeaderInPage") 'Referrals page header name

On Error Resume Next
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

'Call WriteToLog("Info","----------------Select required patient from MyPatient List----------------")
''Select patient from MyPatient list
'blnSelectPatientFromPatientList = SelectPatientFromPatientList(strUser, strPatientName)
'If blnSelectPatientFromPatientList Then
'	Call WriteToLog("Pass","Selected required patient from MyPatient list")
'Else
'	strOutErrorDesc = "Unable to select required patient"
'	Call WriteToLog("Fail","Expected Result: Should be able to select required patient from MyPatient list.  Actual Result: "&strOutErrorDesc)
'	Call Terminator
'End If
'Wait 2

Call WriteToLog("Info","----------------Select required patient through Global Search----------------")
blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
If Not blnGlobalSearchUsingMemID Then
	strOutErrorDesc = "Select patient through global search returned error: "&strOutErrorDesc
	Call WriteToLog("Fail", "Expected Result: User should be able to select patient through global search; Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Call WriteToLog("Pass","Successfully selected required patient through global search")
Wait 3

Call waitTillLoads("Loading...")
Wait 2

'Handle navigation error if exists
blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
If not blnHandleWrongDashboardNavigation Then
    Call WriteToLog("Fail","Unable to provide proper navigation after patient selection "&strOutErrorDesc)
End If
Call WriteToLog("Pass","Provided proper navigation after patient selection")
Wait 2

Call WriteToLog("Info","----------------Validating availability of Referrals menu----------------")
If objReferralsTab.Exist(5) Then
	Call WriteToLog("Pass"," Referrals menu is available")
Else
	strOutErrorDesc = "Referrals menu is NOT available for the user"
	Call WriteToLog("Fail","Expected Result: Referrals menu should be available for the user.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If
Wait 2

Call WriteToLog("Info","----------------Validating newly implemented Referrels menu with existing view of referrals screen in Depression screening----------------")
'Clk on Referrals Tab
Err.Clear
Execute "Set objReferralsTab = Nothing"
Execute "Set objReferralsTab = "&Environment("WL_ReferralsTab") 'Referrals Tab
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
	
	'Navigate to ClinicalManagement > Medications
	blnScreenNavigation = clickOnSubMenu_WE("Screenings->Depression Screening")
	If not blnScreenNavigation Then
		Call WriteToLog("Fail","Unable to navigate to Screenings > Depression screen "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Navigated to Screenings > Depression screen")
	wait 3
	Call waitTillLoads("Loading...")
	Call waitTillLoads("Loading Materials...")
	Call waitTillLoads("Loading...")
	Wait 2

	'Clk Referrals Link
	Err.Clear
	objReferralsLink.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click Referrals Link: "& Err.Description
		Call WriteToLog("Fail", "Expected Result: Referrals Link should be clicked.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Clicked Referrals Link")
	Wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2

	Set objRefHeaderInPage = Nothing
	Execute "Set objRefHeaderInPage = "&Environment("WEL_RefHeaderInPage") 'Referrals link
	
	If  objRefHeaderInPage.Exist(5) Then
		strOutErrorDesc = "Referrals page tab is available under DepressionScreening tab"
		Call WriteToLog("Fail", "Expected Result: Referrals page tab should not be available under DepressionScreening tab.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
	Call WriteToLog("Pass","Referrals page header is NOT available under DepressionScreening tab")
	Wait 1
	
	Execute "Set objReferralsPageComp = Nothing"
	Execute "Set objReferralsPageComp = "&Environment("WEL_ReferralsPageComp") 'Referral screen
	If objReferralsPageComp.Exist(5) Then
		Call WriteToLog("Pass"," Referrals page obtained under newly implemented Referrals tab matches with Referrals page available Depression Screening")
	Else
		strOutErrorDesc = "Referrals page obtained under newly implemented Referrals tab doesn't match with Referrals page obtained under Depression Screening : "& Err.Description
		Call WriteToLog("Fail", "Expected Result: Referrals page obtained under newly implemented Referrals tab should match with Referrals page obtained under Depression Screening.  Actual Result: "&strOutErrorDesc)
		Call Terminator
	End If
		
Else

	strOutErrorDesc = "Referrals page is not available under newly implemented Referrals tab"
	Call WriteToLog("Fail", "Expected Result: Referrals page should be available under newly implemented Referrals tab.  Actual Result: "&strOutErrorDesc)
	Call Terminator
	
End If
Wait 2

Call WriteToLog("Info","----------------Validating newly implemented Referrels menu for not displaying tabs or other screen specific items----------------")
'Clk on Referrals tab
Err.Clear
Execute "Set objReferralsTab = Nothing"
Execute "Set objReferralsTab = "&Environment("WL_ReferralsTab") 'Referrals Tab
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

If not objScreeningLink.Exist(1) AND not objMaterialsLink.Exist(1) Then
	Call WriteToLog("Pass"," Referrals Page is available without tabs or other screen specific items")
Else
	strOutErrorDesc = "Referrals Page is displaying tabs or other screen specific items"
	Call WriteToLog("Fail", "Expected Result: Referrals Page should be available without tabs or other screen specific items.  Actual Result: "&strOutErrorDesc)
	Call Terminator
End If

'Logout
Call WriteToLog("Info","----------------Logout of application----------------")	
Call Logout()

'Set objects free
Set objPage = Nothing 
Set objPatCaPln = Nothing
Set objPatientListScrollbar = Nothing
Set objMyPatientsMainTab = Nothing 
Set objReferralsTab = Nothing 
Set objReferralsPageComp = Nothing 
Set objScreeningsTab = Nothing 
Set objDepressionScreeningLink = Nothing 
Set objMaterialsLink = Nothing
Set objScreeningLink = Nothing
Set objReferralsLink = Nothing 

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

'Function clickOnSubMenu_WE(ByVal menu)
'
'	On Error Resume Next
'	Err.Clear	
'	Set objPage = getPageObject()
'	
'	menuArr = Split(menu,"->")
'	
'	For i = 0 To UBound(menuArr)
'		Set menuDesc = Description.Create
'		menuDesc("micclass").Value = "WebElement"
'		menuDesc("html tag").Value = "A"
'		menuDesc("innertext").Value = ".*" & trim(menuArr(i)) & ".*"
'		menuDesc("innertext").regularexpression = true
'		
'		Set objMenu = objPage.ChildObjects(menuDesc)
'		If objMenu.Count = 2 Then
'			objMenu(1).Click
'		Else
'			objMenu(0).Click
'		End If
'		
'		Set menuDesc = Nothing
'		Set objMenu = Nothing
'	Next
'	
'	Call WriteToLog("info", "Clicked on the submenu '" & Trim(menu) & "'.")
'	
'	Set objPage = Nothing
'	Err.Clear
'	
'End Function
