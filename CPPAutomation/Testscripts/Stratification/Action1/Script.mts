' TestCase Name				: Stratification
' Purpose of TC			    : The purpose of this script is to verify the Stratification Screen
' Pre-requisites(if any)    : None
' Author                    : Sharmila
' Date                      : 04-SEP-2015
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
blnReturnValue = LoadCurrentTestCaseData(strTestDataFileName, "Stratification", strOutTestName, strOutErrorDesc) 
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
strMemberID = DataTable.Value("MemberID","CurrentTestCaseData") 


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

'==============================
'Open patient from global search
'==============================
Call WriteToLog("Info","==========Testcase - Open a patient from Global Search.==========")

strMemberID = DataTable.Value("MemberID","CurrentTestCaseData")
isPass = selectPatientFromGlobalSearch(strMemberID)
If Not isPass Then
	strOutErrorDesc = "Failed to select member from Global Search"
	Call WriteToLog("Fail", strOutErrorDesc)
	Logout
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Wait 2
waitTillLoads "Loading..."
wait 2

'=========================================================
'Select Access screen from the Clinical management menu
'=========================================================
Call clickOnSubMenu("Tools->Stratification")

Wait 2
waitTillLoads "Loading..."
wait 2

'===================================================================================
' Call the function ADLScreening, which does all the validation for ADL Screening. 
' All the function are located at the Library --> Generic Functions
'====================================================================================
blnReturnValue = Stratification(strOutErrorDesc)
If not blnReturnValue Then
	Call WriteToLog("Fail","Expected Result:Stratification Screen functionalities were Verified; Actual Result: Error was returned:" &strOutErrorDesc)
	Call Logout()
	CloseAllBrowsers
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Stratification Screen functionalities were verified successfully")


'=================================
'Logout from Capella Application
'=================================
Call Logout()
CloseAllBrowsers


'============================
'Summarize execution status
'============================
Call WriteLogFooter()

Function Stratification(strOutErrorDesc)
	
	strOutErrorDesc = ""
	Err.clear
	Stratification = false
	
	'=========================
	'Objects Initialization
	'=========================
	Execute "Set objStratificationScreenTitle = "  &Environment.Value("WEL_StratificationScreenTitle") 'Stratification screen title
	Execute "Set objRiskStratificationHeader = "  &Environment.Value("WEL_RiskStratificationHeader")   'Risk Stratification screen title
	Execute "Set objPredictiveRiskScoreTable = "  &Environment.Value("WT_PredictiveRiskScoreTable")    'Risk Stratification Predictive Risk Score table
	Execute "Set objSIGStratificationHeader = "  &Environment.Value("WEL_SIGStratificationHeader") 'SIG Stratification Header
	Execute "Set objSIGRulesTable = "  &Environment.Value("WT_SIGRulesTable") 'SIG Rules Table
	Execute "Set objHRATable = "  &Environment.Value("WT_HRATable") 'HRA Table
	Execute "Set objSIGTrackingTable = "  &Environment.Value("WT_SIGTrackingTable") 'SIG Tracking Table
	Execute "Set objHRATableSegment = "  &Environment.Value("WEL_HRATableSegment") 'HRA Table
	
	'=========================
	'Variable Initialization
	'=========================
	strPatientName = DataTable.Value("PatientName","CurrentTestCaseData") 'Fetch patient name from test data
	strSIGTrackingTableColumns = DataTable.Value("SIGTrackingTableColumns","CurrentTestCaseData") 'fetch the SIG Tracking table column header string from test data
	strSIGRulesTableColumns = DataTable.Value("SIGRulesTableColumns","CurrentTestCaseData") 'fetch the SIG Rules table column header string from test data
	strHRATableColumns = DataTable.Value("HRATableColumns","CurrentTestCaseData") 'fetch the HRA table column header string from test data
	strMemberID = DataTable.Value("MemberID","CurrentTestCaseData") 'fetch MemberID from test data
	strPredictiveRiskScoreTableColumns = DataTable.Value("PredictiveRiskScoreTableColumns","CurrentTestCaseData") 'fetch the column header for Predictive Risk Score table
	
	'==============================================
	'Verify that ADL screening open successfully
	'==============================================
	Call WriteToLog("Info","==========Testcase - Verify Stratification screen was opened successfully. ==========")
	
	
	If not waitUntilExist(objStratificationScreenTitle, intWaitTime/2) Then	
		Call WriteToLog("Fail","Expected Result:Stratification screen opened successfully; Actual Result: ADL Screening not opened successfully")
		Exit Function
	End If
	
	objStratificationScreenTitle.highlight
	Call WriteToLog("Pass","Stratification screen opened successfully")
	
	'===================================================================================
	'Verify that SIG Stratification section should be present on Stratification screen
	'===================================================================================
	Call WriteToLog("Info","==========Testcase - Verify that SIG Stratification section should be present on Stratification screen. ==========")
	
	If not waitUntilExist(objSIGStratificationHeader, intWaitTime/2) Then
		Call WriteToLog("Fail","SIG Stratification section does not exist on Stratification screen")
		Exit Function
	End If
	
	Call WriteToLog("Pass","SIG Stratification section exist on Stratification screen")
	
	'==========================================================================
	'Click on risk stratification header to open the Risk Stratification screen
	'==========================================================================
	blnReturnValue = ClickButton("SIG Stratification",objSIGStratificationHeader,strOutErrorDesc)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If not blnReturnValue Then
		Call WriteToLog("Fail","User unable to click on the Risk Stratification tab: "&strOutErrorDesc)
		Exit Function
	End If
	
	'============================================================================================================================
	'Verify that SIG Tracking table should contain the column is below sequence
	'Assessed Date;Intenstiy
	'============================================================================================================================
	Call WriteToLog("Info","==========Testcase - Verify the columns on the SIG Tracking table ==========")
	
	If waitUntilExist(objSIGTrackingTable,intWaitTime/2) Then
		Call WriteToLog("Pass","SIG Tracking table exist on Stratification screen")
	Else
		Call WriteToLog("Fail","SIG Tracking table does not exist on Stratification screen")
		Exit Function
	End If
	
	arrSIGTrackingTableColumns = Split(strSIGTrackingTableColumns,";") 'Split the expected column header string with delimiter ";" 
	strActualSIGTrackingColumnHeaders = Trim(objSIGTrackingTable.GetROProperty("column names")) 'Get actual columns in SIG Tracking table
	arrActualSIGTrackingColumnHeaders = Split(strActualSIGTrackingColumnHeaders,";") 						   'Split the actual column header string with delimiter ";" 
	
	If Ubound(arrSIGTrackingTableColumns)<> Ubound(arrActualSIGTrackingColumnHeaders)Then  'check expected and actual column count is same in SIG Tracking table
		Call WriteToLog("Fail","Actual number of columns in SIG Tracking Table are not same as expected number of columns")
		Exit Function
	End If
	
	For i = 0 To Ubound(arrSIGTrackingTableColumns) Step 1					'Check the column sequence in SIG Tracking table is default
		If StrComp(arrSIGTrackingTableColumns(i),arrActualSIGTrackingColumnHeaders(i),1) <> 0 Then
			Call WriteToLog("Fail","'" &arrSIGTrackingTableColumns(i)& "'" & ": Column does not on it's default position")
		Else
			Call WriteToLog("Pass","'" &arrSIGTrackingTableColumns(i)& "'" & ": Column on default position")	
		End If
	Next
	
	'============================================================================================================================
	'Verify that SIG Rules table should contain the column is below sequence
	'Rule Description;Intensity;Assessed Date;Created Date;Override Allowed;SIG Override Status;Update date;Updated By
	'============================================================================================================================
	Call WriteToLog("Info","==========Testcase - Verify the columns on the SIG Rules table ==========")
	
	If waitUntilExist(objSIGRulesTable,intWaitTime/2) Then
		Call WriteToLog("Pass","SIG Rules table exist on Stratification screen")
	Else
		Call WriteToLog("Fail","SIG Rules table does not exist on Stratification screen")
		Exit Function
	End If
	
	arrSIGRulesTableColumns = Split(strSIGRulesTableColumns,";") 'Split the expected column header string with delimiter ";" 
	strActualSIGRulesColumnHeaders = Trim(objSIGRulesTable.GetROProperty("column names")) 'Get actual columns in SIG Rules table
	arrActualSIGRulesColumnHeaders = Split(strActualSIGRulesColumnHeaders,";") 						   'Split the actual column header string with delimiter ";" 
	
	If Ubound(arrSIGRulesTableColumns)<> Ubound(arrActualSIGRulesColumnHeaders)Then  'check expected and actual column count is same in SIG Rules
		Call WriteToLog("Fail","Actual number of columns in SIG Rules Table are not same as expected number of columns")
		Exit Function
	End If
	
	For i = 0 To Ubound(arrSIGRulesTableColumns) Step 1					'Check the column sequence in SIG Rules table is default
		If StrComp(arrSIGRulesTableColumns(i),arrActualSIGRulesColumnHeaders(i),1) <> 0 Then
			Call WriteToLog("Fail","'" &arrSIGRulesTableColumns(i)& "'" & ": Column does not on it's default position")
		Else
			Call WriteToLog("Pass","'" &arrSIGRulesTableColumns(i)& "'" & ": Column on default position")	
		End If
	Next
	
	
	'============================================================================================================================
	'Verify that HRA table should contain the column is below sequence
	'Health Risk Assessment;Assessed Date
	'============================================================================================================================
	Call WriteToLog("Info","==========Testcase - Verify the columns on the HRA table. 2 Columns: Health Risk Assessment and Assessed Date should be displayed. ==========")
	
	
	'open database connection
	isPass = ConnectDB()
	
	If Not isPass Then
		Call WriteToLog("Fail", "Connect to Database failed.")
		Exit Function
	End If
	
	'===================================================
	'Verify if the patient is a SNP Patient or not
	'===================================================
	'strMemberID = "178108"
	'Query to retrieve the records from the HRA table in the database.
	strSQLQuery = "SELECT ORG_Category From org_organization WHERE ORG_UID in (Select MRP_INIT_ORG_UID from mrp_mem_referral_period where mrp_mem_uid IN (select mem_uid from mem_member where mem_id = '" & strMemberID &"'))"
	
	blnReturnValue = RunQueryRetrieveRecordSet(strSQLQuery)
	
	If blnReturnValue Then
		strCheckSNPMember = objDBRecordSet("ORG_Category")
	End If
	
	Call CloseDBConnection()
	
	If strCheckSNPMember = "SNP" Then
	
			If waitUntilExist(objHRATable,intWaitTime/2) Then
				'only if the HRA table exists, following conditions should be verified.
				Call WriteToLog("Pass","HRA table exist on Stratification screen")
				
				arrHRATableColumns = Split(strHRATableColumns,";") 'Split the expected column header string with delimiter ";" 
				strActualHRAColumnHeaders = Trim(objHRATable.GetROProperty("column names")) 'Get actual columns in HRA table
				arrActualHRAColumnHeaders = Split(strActualHRAColumnHeaders,";") 						   'Split the actual column header string with delimiter ";" 
				
				If Ubound(arrHRATableColumns)<> Ubound(arrActualHRAColumnHeaders)Then  'check expected and actual column count is same in HRA table
					Call WriteToLog("Fail","Actual number of columns in HRA Table are not same as expected number of columns")
					Exit Function
				End If
				
				For i = 0 To Ubound(arrHRATableColumns) Step 1					'Check the column sequence in HRA table is default
					If StrComp(arrHRATableColumns(i),arrActualHRAColumnHeaders(i),1) <> 0 Then
						Call WriteToLog("Fail","'" &arrHRATableColumns(i)& "'" & ": Column does not on it's default position")
					Else
						Call WriteToLog("Pass","'" &arrHRATableColumns(i)& "'" & ": Column on default position")	
					End If
				Next
				'================================================================================
				'Read the database for the number of rows for that member in the HRA table.
				'================================================================================
				Call WriteToLog("Info","==========Testcase - Read the database for the number of rows for that member in the HRA table. ==========")
				
				'open database connection
				isPass = ConnectDB()
				If Not isPass Then
					Call WriteToLog("Fail", "Connect to Database failed.")
					Exit Function
				End If
				
				'Query to retrieve the records from the HRA table in the database.
				'strSQLQuery = "select * from HRA_HEALTH_RISK_ASSESSMENT Where HRA_MEM_UID IN (Select mem_uid from mem_member where mem_id = '" & strMemberID & "')"
				strSQLQuery = "select LOOKUP_VALUE_TEXT, HRA_DATE_END from HRA_HEALTH_RISK_ASSESSMENT, LOOKUP_VALUES Where HRA_MEM_UID IN (Select mem_uid from mem_member where mem_id = '" & strMemberID & "') AND HRA_STATUS IN ('C','I') AND HRA_TYPE = LOOKUP_VALUE_CODE AND LOOKUP_VALUE_TYPE_UID = '217' AND TRUNC(HRA_DATE_BEGIN) >= (SELECT TRUNC(MAX(MRP_REFERRAL_DATE)) FROM MRP_MEM_REFERRAL_PERIOD WHERE MRP_MEM_UID=HRA_MEM_UID) order by HRA_DATE_END Desc"
				isPass = RunQueryRetrieveRecordSet(strSQLQuery)
				If isPass and objDBRecordSet.EOF = false Then
					err.clear
					arrDBRecords = objDBRecordSet.getRows()
					If err.number <> 0 Then
						call WriteToLog("Fail", "Error in retrieving the Dataset")
						Call CloseDBConnection()
						Exit Function
					End If
				Else
					call WriteToLog("Fail", "No records found in the HRA table for the member " & strMemberID)
					Exit Function
				End If
				
				Call CloseDBConnection()
				
				Call WriteToLog("Pass","==========Database values for that member in the HRA table were retrieved successfully. ==========")
				
				
				'================================================================================
				'Verify the number of rows for that member in the HRA table in the UI
				'================================================================================
				Call WriteToLog("Info","==========Testcase - Verify the number of rows for that member in the HRA table in the UI. ==========")
				
				Set ObjHRATableRows = Description.Create
				ObjHRATableRows("micclass").Value = "WebTable"
				Set objHRARows = objHRATableSegment.ChildObjects(ObjHRATableRows)
				objHRARows(1).highlight
				intRows = objHRARows(1).RowCount
				If intRows >0 Then
					Dim arrHRATableRecords()
					ReDim arrHRATableRecords(intRows-1,1)
					For i= 1 To intRows Step 1
						For j = 1 To 2 Step 1
							'arrHRATableRecords(i-1,j-1)= objHRARows(1).ChildItem(i-1, j, "WebElement", 0).GetROProperty("innertext")
							arrHRATableRecords(i-1,j-1)= objHRARows(1).GetCellData(i,j)
						Next
					Next
				End If
				
				Call WriteToLog("Pass","==========HRA Table values for that member were retrieved successfully from the UI. ==========")
				
				'============================================================
				'Compare the HRA Database Rows and HRA Table Rows are same
				'============================================================
				Call WriteToLog("Info","==========Testcase - Compare the HRA Database Rows and HRA Table Rows are same. ==========")
				
				If Ubound(arrDBRecords,2)<> Ubound(arrHRATableRecords,1)Then  'check expected and actual column count is same in predictive risk score
					Call WriteToLog("Fail","Actual number of rows in HRA Table are not same as expected number of rows in the HRA Database")
					Exit Function
				End If
				
				
				'Compare the data in each row for both table and database
				For i = 0 To Ubound(arrHRATableRecords,1) Step 1					'Check the column sequence in HRA table is default
					'Compare the HRA Assessment column values
					Call WriteToLog("Info","========== Compare the HRA Assessment column values ==========")
					If StrComp(arrHRATableRecords(i,0),arrDBRecords(0,i),1) <> 0 Then
						Call WriteToLog("Fail","Table Value: '" &arrHRATableRecords(i,0)& "' and Database Value: '" &arrDBRecords(0,i)&"': are not matching for the HRA Assessment")
					Else
						Call WriteToLog("Pass","Table Value: '" &arrHRATableRecords(i,0)& "' and Database Value: '" &arrDBRecords(0,i)&"': are matching for the HRA Assessment")	
					End If
					
					'Compare the Assessed date column values
					Call WriteToLog("Info","========== Compare the Assessed date column values ==========")
					If DateValue(arrHRATableRecords(i,1)) = DateValue(arrDBRecords(1,i)) Then
						Call WriteToLog("Pass","Table Value: '" &arrHRATableRecords(i,1)& "' and Database Value: '" &arrDBRecords(1,i)&"': are matching for the Assessed Date")	
					Else
						Call WriteToLog("Fail","Table Value: '" &arrHRATableRecords(i,1)& "' and Database Value: '" &arrDBRecords(1,i)&"': are not matching for the Assessed Date")
					End If
				Next
			
			End IF
				
	Else
		'If the patient is not SNP, they should not have HRA table in the UI.
		
		If not waitUntilExist(objHRATable,intWaitTime/2)  Then			
			Call WriteToLog("Pass","This patient is not the SNP Patient. So he does not have HRA Table.")
		End If 	
		
	End If
	
	
	'============================================================================================================================
	'Verify that Risk Stratification tab and the Predictive Risk Score Table columns
	'Health Risk Assessment;Assessed Date
	'============================================================================================================================
	Call WriteToLog("Info","==========Testcase - Verify the Risk Stratification tab and the Predictive Risk Score Table columns. ==========")
	'===================================================================================
	'Verify that Risk Stratification section should be present on Stratification screen
	'===================================================================================
	If waitUntilExist(objRiskStratificationHeader,intWaitTime/2) Then
		Call WriteToLog("Pass","Risk Stratification section exist on Stratification screen")
	Else
		Call WriteToLog("Fail","Risk Stratification section does not exist on Stratification screen")
		Exit Function
	End If
	
	'==========================================================================
	'Click on risk stratification header to open the Risk Stratification screen
	'==========================================================================
	blnReturnValue = ClickButton("Risk Stratification",objRiskStratificationHeader,strOutErrorDesc)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If not blnReturnValue Then
		Call WriteToLog("Fail","User unable to click on the Risk Stratification tab: "&strOutErrorDesc)
		Exit Function
	End If
	
	'============================================================================================================================
	'Verify that Risk Stratification Table should contain the column is below sequence
	'Beginning Score,Demographic Score,Access Score,Comorbid Score,Albumin Score,Hospitalization Score,Final Score,Date Assessed
	'============================================================================================================================
	If waitUntilExist(objPredictiveRiskScoreTable,intWaitTime/2) Then
		Call WriteToLog("Pass","Predictive Risk Score table exist on Stratification screen")
		
		'If the table exists, Verify the Column Headers
		arrPredictiveRiskScoreTableColumns = Split(strPredictiveRiskScoreTableColumns,";") 'Split the expected column header string with delimiter ";" 
		strActualColumnHeaders = Trim(objPredictiveRiskScoreTable.GetROProperty("column names")) 'Get actual columns in Predictive Risk Score table
		arrActualColumnHeaders = Split(strActualColumnHeaders,";") 						   'Split the actual column header string with delimiter ";" 
		
		If Ubound(arrPredictiveRiskScoreTableColumns)<> Ubound(arrActualColumnHeaders)Then  'check expected and actual column count is same in predictive risk score
			Call WriteToLog("Fail","Actual number of columns in Predictive Risk Score Table are not same as expected number of columns")
			Exit Function
		End If
		
		For i = 0 To Ubound(arrPredictiveRiskScoreTableColumns) Step 1					'Check the column sequence in predictive risk score table is default
			If StrComp(arrPredictiveRiskScoreTableColumns(i),arrActualColumnHeaders(i),1) <> 0 Then
				Call WriteToLog("Fail","'" &arrPredictiveRiskScoreTableColumns(i)& "'" & ": Column does not on it's default position")
			Else
				Call WriteToLog("Pass","'" &arrPredictiveRiskScoreTableColumns(i)& "'" & ": Column on default position")	
			End If
		Next
	Else
		Call WriteToLog("Fail","Predictive Risk Score table does not exist on Stratification screen for the member")
		
	End If
	
	Stratification = true	
	
End Function
