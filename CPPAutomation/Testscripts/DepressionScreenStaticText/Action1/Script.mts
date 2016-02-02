'**************************************************************************************************************************************************************************
' TestCase Name			: DepressionScreenStaticText
' Purpose of TC			: Validating newly implemented DepressionScreenStaticText.
' Author                : Amar
' Date                  : 26 October 2015
' Modified				: 26 October 2015
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "DepressionScreenStaticText", strOutTestName, strOutErrorDesc)
If Not (blnReturnValue) Then
	Call WriteToLog("Fail" , "Testdata could not be loaded into the datatable. Error returned: " & strOutErrorDesc)
	Call Terminator
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
strPatientName = DataTable.Value("PatientName","CurrentTestCaseData")
strExecutionFlag = DataTable.Value("ExecutionFlag","CurrentTestCaseData")
lngMemberID =  DataTable.Value("MemberId","CurrentTestCaseData")
strStaticTextMessage =  DataTable.Value("StaticTextMessage","CurrentTestCaseData")

'-----------------------------------
'Objects required for test execution
'-----------------------------------
Execute "Set objPage = "&Environment("WPG_AppParent") 'Page Object
	
If not Lcase(strExecutionFlag) = "y" Then Exit Do

On Error Resume Next
Err.Clear

'-----------------------EXECUTION-------------------------------------------------------------------------------------------------------------------------------------------------------

Call WriteToLog("Info","----------Login to application, Close all open patients, Select user roster----------")

'-----------------
'Login to VHN user
'-----------------
'Navigation: Login to app > CloseAllOpenPatients > SelectUserRoster 
blnNavigator = Navigator("vhn", strOutErrorDesc)
If not blnNavigator Then
	Call WriteToLog("Fail","Expected Result: User should be able to navigate required user dashboard.  Actual Result: Unable to navigate required user dashboard."&strOutErrorDesc)
	Call Terminator											
End If
Call WriteToLog("Pass","Navigated to user dashboard")

Wait 2
Call WriteToLog("Info","----------------Select required patient from MyPatient List----------------")
'select the patient through global search
blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
If not blnGlobalSearchUsingMemID Then
	Call WriteToLog("Fail","Expected Result: Should be able to select required patient through global search; Actual Result: Unable to select required patient through global search")
	Call Terminator
End If
Call WriteToLog("Pass","Selected required patient through global search")
Wait 5

'click on Depression screening
clickOnSubMenu_WE("Screenings->Depression Screening")
		
wait 2
waitTillLoads "Loading..."
wait 2

Set ObjStaticTextMsg=objPage.WebElement("html tag:=DIV","outerhtml:=.*Review the medications and Comorbid management before beginning the Depression Screen.*","visible:=True")
ObjStaticTextMsg.highlight
If InStr(1,ObjStaticTextMsg.getROProperty("outertext"),strStaticTextMessage,1) Then
	Call WriteToLog("Pass", "User is able to view the required Static text")
else
	Call WriteToLog("Fail", "Expected Result: User should be able to view the required Static text; Actual Result:Unable to to view the required Static text")
	Call Terminator	
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

