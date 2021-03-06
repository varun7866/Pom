'##################################################################################################################################
'Function Name       :	scheduleCalendar
'Purpose of Function :	navigate to particular day in calendar and double click on the day
'Input Arguments     :	Date in the format mm/dd/yyyy
'Output Arguments    :	None
'Example of Call     :	Call scheduleCalendar("05/29/2015")
'Author              :	Sudheer
'Date                :	24-April-2015
'##################################################################################################################################
Function scheduleCalendar(Byval requiredDate)

	reqDD = Split(requiredDate,"/")
	
	reqMonth = Cint(reqDD(0)) 'CInt("05")
	reqYear = CInt(reqDD(2))
	reqDate = CInt(reqDD(1))
	
	If Year(Now()) > reqYear Then
		MsgBox "Schedule date cannot be less than today's date"
		Exit Function		
	ElseIf Month(Now()) > reqMonth Then
		MsgBox "Schedule date cannot be less than today's date"
		Exit Function
	ElseIf Day(Now()) > reqDate Then
		MsgBox "Schedule date cannot be less than today's date"
		Exit Function
	End If
	
	Set objPage = getPageObject()
	
	'get the parent object	
	Set objParent = objpage.WebElement("html id:=scheduler","html tag:=DIV")
	
	'click on Month to get month view
	Set objMonth = objParent.Link("html tag:=A","innertext:=Month")
	objMonth.Click
	Set objMonth = Nothing
	
	
	'change the month to required month
	uiMonthYear = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL").getROProperty("innertext")
	uiYear = Cint(Trim(Split(uiMonthYear,",")(1)))
	
	
	
	If uiYear <> reqYear Then
	
		Do while (uiYear = reqYear) = False
			If reqYear > uiYear Then
				Set objRightArrow = objParent.Link("html tag:=A", "innerhtml:=.*k-icon k-i-arrow-e.*")
				objRightArrow.Click
				wait 1
				Set objM = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL")
				uiMonthYear = objM.getROProperty("innertext")
				uiYear = CInt(Trim(Split(uiMonthYear,",")(1)))
				Set objRightArrow = Nothing
			ElseIf reqYear < uiYear Then
				Set objLeftArrow = objParent.Link("html tag:=A", "innerhtml:=.*k-icon k-i-arrow-w.*")
				objLeftArrow.Click
				wait 1
				Set objM = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL")
				uiMonthYear = objM.getROProperty("innertext")
				uiYear = CInt(Trim(Split(uiMonthYear,",")(1)))
				Set objM = Nothing
				Set objLeftArrow = Nothing
			End If
		Loop
	
	End If	
	
	uiMonthYear = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL").getROProperty("innertext")
	uiMonth = Trim(Split(uiMonthYear,",")(0))
	uiMonth = Mid(uiMonth, len("Today")+1)
	
	uiMonthVal = getNumericValueOfMonth(uiMonth)
	
	Do while (reqMonth = uiMonthVal) = False
		
		If reqMonth > uiMonthVal Then
		
			Set objRightArrow = objParent.Link("html tag:=A", "innerhtml:=.*k-icon k-i-arrow-e.*")
			objRightArrow.Click
			wait 1
			Set objM = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL")
			uiMonthYear = objM.getROProperty("innertext")
			uiYear = Trim(Split(uiMonthYear,",")(1))
			uiMonth = Trim(Split(uiMonthYear,",")(0))
			uiMonth = Mid(uiMonth, len("Today")+1)
			
			uiMonthVal = getNumericValueOfMonth(uiMonth)
			Set objM = Nothing
			Set objRightArrow = Nothing
		ElseIf reqMonth < uiMonthVal Then
			Set objLeftArrow = objParent.Link("html tag:=A", "innerhtml:=.*k-icon k-i-arrow-w.*")
			objLeftArrow.Click
			wait 1
			Set objM = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL")
			uiMonthYear = objM.getROProperty("innertext")
			uiYear = Trim(Split(uiMonthYear,",")(1))
			uiMonth = Trim(Split(uiMonthYear,",")(0))
			uiMonth = Mid(uiMonth, len("Today")+1)
			
			uiMonthVal = getNumericValueOfMonth(uiMonth)
			Set objM = Nothing
			Set objLeftArrow = Nothing
			
		End If
		
	Loop	
	
	Set dateDesc = Description.Create
	dateDesc("micclass").Value = "WebElement"
	dateDesc("html tag").Value = "TD"
	dateDesc("outertext").Value = ".*" & reqDate & ".*"
	dateDesc("outertext").regularExpression = true
	dateDesc("outerhtml").Value = "<td role=""gridcell"".*"
	dateDesc("outerhtml").regularExpression = true
	Set objDate = objParent.WebElement(dateDesc)
	objDate.highlight
	Set dayDesc = Description.Create
	dayDesc("micclass").Value = "WebElement"
	dayDesc("class").Value = "monthHeader k-nav-day k-link"
	dayDesc("html tag").Value = "DIV"
	dayDesc("innertext").Value = ".*" & reqDate & ".*"
	dayDesc("innertext").regularexpression = true
	Set objDay = objDate.WebElement(dayDesc)
	
	getX = objDay.getROProperty("abs_x")
	getY = objDay.getROProperty("abs_y")
	
	Set deviceReplay = CreateObject("Mercury.DeviceReplay")
	deviceReplay.MouseDblClick getX, getY,LEFT_MOUSE_BUTTON
	
	Set dateDesc = Nothing
	Set objDate = Nothing
	Set deviceReplay = Nothing
	Set objDay = Nothing
	Set dayDesc = Nothing
	Set objParent = Nothing
	Set objPage = Nothing
	
End Function


Function getNumericValueOfMonth(ByVal mont)
	Dim intMon : intMon = -1
	
	Select Case lcase(mont)
		
		Case "january"
			intMon = 1
		Case "february"
			intMon = 2
		Case "march"
			intMon = 3
		Case "april"
			intMon = 4
		Case "may"
			intMon = 5
		Case "june"
			intMon = 6
		Case "july"
			intMon = 7
		Case "august"
			intMon = 8
		Case "september"
			intMon = 9
		Case "october"
			intMon = 10
		Case "november"
			intMon = 11
		Case "december"
			intMon = 12
		Case Else
			intMon = -1
	End Select
	
	getNumericValueOfMonth = intMon
	
End Function

'##################################################################################################################################
'Function Name       :	Login
'Purpose of Function :	login to capella premium as per the role. credentials are taken from the config file
'Input Arguments     :	Role
'Output Arguments    :	None
'Example of Call     :	Call Login("vhes")
'Author              :	Sudheer
'Date                :	08-April-2015
'##################################################################################################################################
Function Login(ByVal role)
	
	On Error Resume Next
	Err.Clear
	
	Login = false
	
	'get the details from config file
	strUrl 	    = getConfigFileValue("strUrl")			'Capella application launch URL
	strOTP      = getConfigFileValue("strOTP")
	
	Select Case UCase(role)
		Case "VHN"
			strUserName = getConfigFileValue("strVHNUserName")	'VHN role username
			strPassword = getConfigFileValue("strVHNPassword")	'VHN role password
		Case "OTHERVHN"
			strUserName = getConfigFileValue("strOtherVHNUserName")	'VHN role username
			strPassword = getConfigFileValue("strVHNPassword")	'VHN role password
		Case "ARN"
			strUserName = getConfigFileValue("strARNUserName")	'ARN role username
			strPassword = getConfigFileValue("strARNPassword")	'ARN role password
		Case "EPS"
			strUserName = getConfigFileValue("strEPSUserName")	'EPS role username
			strPassword = getConfigFileValue("strEPSPassword")	'EPS role password
		Case "VHES"
			strUserName = getConfigFileValue("strVHESUserName")	'VHES role username
			strPassword = getConfigFileValue("strVHESPassword")	'VHES role password
		Case "PTC"
			strUserName = getConfigFileValue("strPTCUserName")	'PTC role username
			strPassword = getConfigFileValue("strPTCPassword")	'PTC role password	
		Case "PHM"
			strUserName = getConfigFileValue("strPHMUserName")	'PHM role username
			strPassword = getConfigFileValue("strPHMPassword")	'PHM role password			
		Case "RCM"
			strUserName = getConfigFileValue("strRCMUserName")	'RCM role username
			strPassword = getConfigFileValue("strRCMPassword")	'RCM role password
		Case "RVR"
			strUserName = getConfigFileValue("strRVRUserName")	'RCM role username
			strPassword = getConfigFileValue("strRVRPassword")	'RCM role password
		Case Else
			Login = False
			StepActual = "No such role exists"
			Exit Function
	End Select
	
	
	'verify and close if any open browsers
	CloseAllBrowsers
		
	'Launch Capella URL
	SystemUtil.Run "iexplore.exe", strUrl, , ,3
	
	wait 5
	If not Browser("name:=DaVita VillageHealth Capella").Exist(10) Then
		Call WriteToLog("Fail","Failed to open the browser")
		Exit Function
	End If
	hwnd = Browser("name:=DaVita VillageHealth Capella").GetROProperty("HWND")
	Window("HWND:=" & hwnd).Activate
	
	Err.Clear
	do while getPageObject().WebElement("html tag:=SPAN","innerhtml:=Loading config parameters...").getRoProperty("visible") = true
		If err.Number <> 0 Then
			Exit Do
		End If
		wait 3
	Loop
	'set the page object
	Set objPage = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
	
	'Sync the page
	objPage.Sync
	
	Set objUserName = objPage.WebEdit("html id:=inputUsername")
	
	Dim isLogin : isLogin = True
	Dim cnt : cnt = 1
	do while objUserName.WaitProperty("visible", True, 2000) = False
		Call WriteToLog("info", "Login Page did not load in given time. Refreshing the page to reload again.")
'		Window("hwnd:=" & getPageObject().GetROPRoperty("hwnd")).Type micF5
		Browser("micclass:=Browser").Refresh
		wait 5
		cnt = cnt + 1
		If cnt = 5 Then
			isLogin = False
			Exit Do
		End If
	Loop
	
	If Not isLogin Then
		Call WriteToLog("Fail", "Failed to load login page after multiple attempts of reload.")
		Set objUserName = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	
	'retrieve build details and write to text file. Added by Sudheer on 4/5/2016
	Set objFso = CreateObject("Scripting.FileSystemObject")
	driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
	Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)
	Environment("HTMLRESULTS_PATH") = Environment.Value("PROJECT_FOLDER") & "\Reports"
	If Not objFso.FileExists(Environment("HTMLRESULTS_PATH")&"\build.txt") Then
		Set objFileToWrite = CreateObject("Scripting.FileSystemObject").CreateTextFile(Environment("HTMLRESULTS_PATH")&"\build.txt") 'environment variable
		objFileToWrite.Close
		Set objFileToWrite = Nothing
		Set objBuildDetails = getPageObject().WebElement("class:=panel-footer.*", "html tag:=DIV", "visible:=True")
	
		If Not objBuildDetails.Exist(1) Then
			getBuildNumber = getConfigFileValue("strBuildNumber")
			Exit Function
		End If
		
		buildNo = objBuildDetails.GetROProperty("innertext")
		
		Set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile(Environment("HTMLRESULTS_PATH")&"\build.txt",2,true)
		objFileToWrite.WriteLine(buildNo)
		objFileToWrite.Close
		Set objFileToWrite = Nothing
	End If
		
	Set objPassword = objPage.WebEdit("html id:=password")
	Set objToken = objPage.WebEdit("html id:=token")
	Set objLogin = objPage.WebButton("html id:=modalview-login-button")
	
	arrUserID = Split(strUserName,"|")
	
	objUserName.Set arrUserID(0)
	Call WriteToLog("Pass", "Username entered successfully.")
	
	objPassword.Set strPassword
	Call WriteToLog("Pass", "Password entered successfully.")
	objToken.Set strOTP
	Call WriteToLog("Pass", "Token entered successfully")
	
	uName = objUserName.GetROProperty("value")
	uPwd = objPassword.GetROProperty("value")
	uToken = objToken.GetROProperty("value")
	
	If trim(uName) = "" or trim(uPwd) = "" or trim(uToken) = "" Then
		'Kill all the objects
		Set objUserName = Nothing
		Set objPassword = Nothing
		Set objToken = Nothing
		Set objLogin = Nothing
		Set objPage = Nothing
		
		Call WriteToLog("Fail", "Failed to Login.")
		Login = False
		Exit Function
		
	End If
	
	objLogin.Click
	
	wait 2
	waitTillLoads "Authenticating..."
	wait 2
	isPass = isMessageBoxExist("Invalid Username or Password", "Invalid username / password combination", strOutErrorDesc)
	If isPass Then
		isPass = checkForPopup("Invalid Username or Password", "Ok", "Invalid username / password combination", strOutErrorDesc)
		If not isPass Then
			Call WriteToLog("Fail", "Failed to Login. Invalid username/password.")
			Exit Function
		End If
	End If
	
	Call WriteToLog("Pass", "Successfully entered login details and clicked on Login button.")
	
	'Kill all the objects
	Set objUserName = Nothing
	Set objPassword = Nothing
	Set objToken = Nothing
	Set objLogin = Nothing
	
	wait 5
	
	Err.Clear
	
	do while getPageObject().WebElement("html tag:=SPAN","innerhtml:=Authenticating...").getRoProperty("visible") = true
		If err.Number <> 0 Then
			Exit Do
		End If
		wait 3
	Loop
	
	Err.Clear
	Call waitTillLoads("Authenticating...")	
	wait 10	
	objPage.Sync	
	
'	Call checkForPopupUnsavedContacts()
	Call waitTillLoads("Loading...")
	'Kill all the objects
	Set objPage = Nothing
	
	Login = True

End Function

'##################################################################################################################################
'Function Name       :	checkForPopupUnsavedContacts
'Purpose of Function :	if Unsaved contacts message box exits, click OK irrespective of number of message boxes open
'Input Arguments     :	None
'Output Arguments    :	None
'Example of Call     :	Call checkForPopupUnsavedContacts()
'Author              :	Sudheer
'Date                :	09-April-2015
'##################################################################################################################################
Function checkForPopupUnsavedContacts()
	Set objPage = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
	wait 10
	
	
	Set customPopupDesc = Description.Create
	customPopupDesc("micclass").Value = "WebElement"
	customPopupDesc("class").Value = "modal-header title-gradient custompopup-title-header title-header drag-handler"
									  
	Set objCustomPopUp = objPage.ChildObjects(customPopupDesc)
	
'	MsgBox objCustomPopUp.Count
	If Not isObject(objCustomPopUp) Then
		Print "No pop ups found"
		Exit Function
	End If
	
	Set popupBodyDesc = Description.Create
	popupBodyDesc("micclass").Value = "WebElement"
	popupBodyDesc("class").Value = "modal-body "
	
	Set objPopupBody = objPage.ChildObjects(popupBodyDesc)
	
	If Not isObject(objPopupBody) Then
		Print "No pop ups found"
		Set popupBodyDesc = Nothing
		Set objPopupBody = Nothing
		Set objCustomPopUp = Nothing
		Set customPopupDesc = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	
	Call WriteToLog("info", objPopupBody.Count & " custom popup(s) found. Attempting to close all.")
	
	Set buttonDesc = Description.Create
	buttonDesc("micclass").Value = "WebButton"
	'buttonDesc("innertext").Value = "Ok"
	'buttonDesc("class").Value = "btn-custom-model btn-custom-gradient"
	
	For i = 0 To objPopupBody.Count - 1
	
		Set objButton = objPopupBody(i).ChildObjects(buttonDesc)
		objButton(0).Click
		
		Call WriteToLog("info", "Clicked OK button on pop up " & i+1)
		Set objButton = Nothing
	Next
	
	wait 3
	Err.Clear
	
	
	Set popupBodyDesc = Nothing
	Set objPopupBody = Nothing
	Set objCustomPopUp = Nothing
	Set buttonDesc = Nothing
	Set customPopupDesc = Nothing
	Set objPage = Nothing
End Function

Function isMessageBoxExist(ByVal title, ByVal alertText, strOutErrorDesc)
	Set objPage = getPageObject()
	isMessageBoxExist = false
	
	'check if the required pop up with title exists
	Set customPopupDesc = Description.Create
	customPopupDesc("micclass").Value = "WebElement"
	customPopupDesc("class").Value = "modal-header title-gradient custompopup-title-header.*"
	customPopupDesc("class").regularExpression = true
	customPopupDesc("innertext").Value = ".*" & trim(title) & ".*"
	customPopupDesc("innertext").regularExpression = true
	
	Set objCustomPopUp = objPage.ChildObjects(customPopupDesc)
	
	If Not isObject(objCustomPopUp) Then
		strOutErrorDesc = "No pop up found with title '" & title & "'."
		Set objPage = Nothing
		Set customPopupDesc = Nothing
		Set objCustomPopUp = Nothing
		Exit Function
	End If
	
	Set popupBodyDesc = Description.Create
	popupBodyDesc("micclass").Value = "WebElement"
	popupBodyDesc("class").Value = "modal-body.*"
	popupBodyDesc("class").regularExpression = true
	Set objPopupBody = objPage.ChildObjects(popupBodyDesc)
	
	If Not isObject(objPopupBody) Then
		strOutErrorDesc = "No pop up body found"
		Set popupBodyDesc = Nothing
		Set objPopupBody = Nothing
		Set objCustomPopUp = Nothing
		Set customPopupDesc = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	
	'verify if required text exists
	Set alertTextDesc = Description.Create
	alertTextDesc("micClass").Value = "WebElement"
	alertTextDesc("class").Value = ".*alert-text.*"
	alertTextDesc("class").regularExpression = true
	
	Dim popUpFound : popUpFound = False
	For i = 0 To objPopupBody.Count - 1
		Set objAlertText = objPopupBody(i).ChildObjects(alertTextDesc)
		
		If Not isObject(objAlertText) Then
			strOutErrorDesc = "No pop up body found"
			Set popupBodyDesc = Nothing
			Set objPopupBody = Nothing
			Set objCustomPopUp = Nothing
			Set customPopupDesc = Nothing
			Set objPage = Nothing
			Set alertTextDesc = Nothing
			Set objAlertText = Nothing
			Exit Function
		End If
	
		Dim popUpAlertText : popUpAlertText = ""
		For j = 0 To objAlertText.Count - 1
			popUpAlertText = popUpAlertText & objAlertText(j).getROProperty("innertext") & ";"
		Next
				
		If Instr(lcase(popUpAlertText), lcase(alertText)) > 0 Then
			strOutErrorDesc = "Required Message Box Exists"
			popUpFound = True
			Exit For
		End If
		
	Next
	
	
	If Not popUpFound Then
		strOutErrorDesc = "No Message Box exist with required text."
		isMessageBoxExist = False
	Else
		isMessageBoxExist = True
	End If	
	
	Set popupBodyDesc = Nothing
	Set objPopupBody = Nothing
	Set objCustomPopUp = Nothing
	Set buttonDesc = Nothing
	Set customPopupDesc = Nothing
	Set alertTextDesc = Nothing
	Set objAlertText = Nothing
	Set objPage = Nothing
End Function

'##################################################################################################################################
'Function Name       :	checkForPopup
'Purpose of Function :	To check for a particular message box and click on the button
	'Input Arguments     :	title -> title of the message box
'						buttonName -> name of the button to click
'						alertText -> message text on the message box
'Output Arguments    :	strOutErrorDesc -> error message if any
'Example of Call     :	Call checkForPopup()
'Author              :	Sudheer
'Date                :	09-April-2015
'##################################################################################################################################
Function checkForPopup(ByVal title, ByVal buttonName, ByVal alertText, strOutErrorDesc)

	Set objPage = getPageObject()
	
	'check if the required pop up with title exists
	Set customPopupDesc = Description.Create
	customPopupDesc("micclass").Value = "WebElement"
	customPopupDesc("class").Value = "modal-header title-gradient custompopup-title-header.*"
	customPopupDesc("class").regularExpression = true
	customPopupDesc("innertext").Value = ".*" & trim(title) & ".*"
	customPopupDesc("innertext").regularExpression = true
	
	Set objCustomPopUp = objPage.ChildObjects(customPopupDesc)
	
	If Not isObject(objCustomPopUp) Then
		strOutErrorDesc = "No pop up found with title '" & title & "'."
		checkForPopup = False
		Set objPage = Nothing
		Set customPopupDesc = Nothing
		Set objCustomPopUp = Nothing
		Exit Function
	End If
	
	Set popupBodyDesc = Description.Create
	popupBodyDesc("micclass").Value = "WebElement"
	popupBodyDesc("class").Value = "modal-body.*"
	popupBodyDesc("class").regularExpression = true
	Set objPopupBody = objPage.ChildObjects(popupBodyDesc)
	
	If Not isObject(objPopupBody) Then
		strOutErrorDesc = "No pop up body found"
		Set popupBodyDesc = Nothing
		Set objPopupBody = Nothing
		Set objCustomPopUp = Nothing
		Set customPopupDesc = Nothing
		Set objPage = Nothing
		checkForPopup = False
		Exit Function
	End If
	
	'verify if required text exists
	Set alertTextDesc = Description.Create
	alertTextDesc("micClass").Value = "WebElement"
	alertTextDesc("class").Value = ".*alert-text.*"
	alertTextDesc("class").regularExpression = true
	
	Dim popUpFound : popUpFound = False
	For i = 0 To objPopupBody.Count - 1
		Set objAlertText = objPopupBody(i).ChildObjects(alertTextDesc)
		
		If Not isObject(objAlertText) Then
			strOutErrorDesc = "No pop up body found"
			Set popupBodyDesc = Nothing
			Set objPopupBody = Nothing
			Set objCustomPopUp = Nothing
			Set customPopupDesc = Nothing
			Set objPage = Nothing
			Set alertTextDesc = Nothing
			Set objAlertText = Nothing
			checkForPopup = False
			Exit Function
		End If
	
		Dim popUpAlertText : popUpAlertText = ""
		For j = 0 To objAlertText.Count - 1
			popUpAlertText = popUpAlertText & objAlertText(j).getROProperty("innertext") & ";"
		Next
				
		If Instr(lcase(popUpAlertText), lcase(alertText)) > 0 Then
			Set buttonDesc = Description.Create
			buttonDesc("micclass").Value = "WebButton"
			buttonDesc("name").Value = buttonName
			'buttonDesc("class").Value = "btn-custom-model btn-custom-gradient"
			objPopupBody(i).highlight
			Set objButton = objPopupBody(i).WebButton(buttonDesc)
			objButton.Click
				
			Call WriteToLog("Pass", "Clicked '" & buttonName & "' button on the message box with title " & title)
			Set objButton = Nothing
				
			wait 3
			Err.Clear
			checkForPopup = True
			popUpFound = True
			Exit For
		End If
		
	Next
	
	
	If Not popUpFound Then
		strOutErrorDesc = "No Message Box exist with required text."
		checkForPopup = False
	End If	
	
	
	Set popupBodyDesc = Nothing
	Set objPopupBody = Nothing
	Set objCustomPopUp = Nothing
	Set buttonDesc = Nothing
	Set customPopupDesc = Nothing
	Set alertTextDesc = Nothing
	Set objAlertText = Nothing
	Set objPage = Nothing
	
End Function

'##################################################################################################################################
'Function Name       :	clickOnMessageBox
'Purpose of Function :	To check for a particular message box and click on the button. This function will work for old message boxes
'						which can be found for example when click on Patient unable to complete screening option in screenings.
'Input Arguments     :	title -> title of the message box
'						buttonName -> name of the button to click
'						alertText -> message text on the message box
'Output Arguments    :	strOutErrorDesc -> error message if any
'Example of Call     :	isPass = clickOnMessageBox("Cognitive Screening", "Yes", "Your current responses will be lost. Do you want to continue?", strOutErrorDesc)
'Author              :	Sudheer
'Date                :	19-Aug-2015
'##################################################################################################################################
Function clickOnMessageBox(ByVal title, ByVal buttonName, ByVal alertText, strOutErrorDesc)

    clickOnMessageBox = False
    Set objPage = getPageObject()
    
    'check if the required pop up with title exists
    Set customPopupDesc = Description.Create
    customPopupDesc("micclass").Value = "WebElement"
    customPopupDesc("class").Value = "row title-gradient title-header.*"
    customPopupDesc("class").regularExpression = true
    customPopupDesc("innertext").Value = ".*" & trim(title) & ".*"
    customPopupDesc("innertext").regularExpression = true
    
    Set objCustomPopUp = objPage.ChildObjects(customPopupDesc)
    
    If Not isObject(objCustomPopUp) Then
        strOutErrorDesc = "No pop up found with title '" & title & "'."
        Set objPage = Nothing
        Set customPopupDesc = Nothing
        Set objCustomPopUp = Nothing
        Exit Function
    End If
    
    Set popupBodyDesc = Description.Create
    popupBodyDesc("micclass").Value = "WebElement"
    popupBodyDesc("class").Value = "modal-content.*"
    popupBodyDesc("class").regularExpression = true
    Set objPopupBody = objPage.ChildObjects(popupBodyDesc)
    
    If Not isObject(objPopupBody) Then
        strOutErrorDesc = "No pop up body found"
        Set popupBodyDesc = Nothing
        Set objPopupBody = Nothing
        Set objCustomPopUp = Nothing
        Set customPopupDesc = Nothing
        Set objPage = Nothing
        Exit Function
    End If
    
    'verify if required text exists
    Set alertTextDesc = Description.Create
    alertTextDesc("micClass").Value = "WebElement"
    alertTextDesc("html tag").Value = ".*B.*"
        
    Dim popUpFound : popUpFound = False
    For i = 0 To objPopupBody.Count - 1
        Set objAlertText = objPopupBody(i).ChildObjects(alertTextDesc)
        objPopupBody(i).highlight
        If Not isObject(objAlertText) Then
            strOutErrorDesc = "No pop up body found"
            Set popupBodyDesc = Nothing
            Set objPopupBody = Nothing
            Set objCustomPopUp = Nothing
            Set customPopupDesc = Nothing
            Set objPage = Nothing
            Set alertTextDesc = Nothing
            Set objAlertText = Nothing
            Exit Function
        End If
    
        Dim popUpAlertText : popUpAlertText = ""
        For j = 0 To objAlertText.Count - 1
            popUpAlertText = popUpAlertText & objAlertText(j).getROProperty("innertext") & ";"
        Next
                
        If Instr(lcase(popUpAlertText), lcase(alertText)) > 0 Then
            Set buttonDesc = Description.Create
            buttonDesc("micclass").Value = "WebButton"
            buttonDesc("name").Value = buttonName
            objPopupBody(i).highlight
            Set objButton = objPopupBody(i).WebButton(buttonDesc)
            objButton.Click
                
            Call WriteToLog("Pass", "Clicked '" & buttonName & "' button on the message box.")
            Set objButton = Nothing
                
            wait 3
            Err.Clear
            clickOnMessageBox = True
            popUpFound = True
            Exit For
        End If
        
    Next
    
    
    If Not popUpFound Then
        strOutErrorDesc = "No Message Box exist with required text."
	End If	
	
	
	Set popupBodyDesc = Nothing
	Set objPopupBody = Nothing
	Set objCustomPopUp = Nothing
	Set buttonDesc = Nothing
	Set customPopupDesc = Nothing
	Set alertTextDesc = Nothing
	Set objAlertText = Nothing
	Set objPage = Nothing
	
End Function

Function clickButtonOnMessageBox(ByVal title, ByVal buttonName, ByVal alertText, strOutErrorDesc)
	Set objPage = getPageObject()
	
	'check if the required pop up with title exists									  
	Set objCustomPopUp = objPage.WebElement("class:=title-gradient title-header actionItemheader div-shadow pos-a width-100-percent")
	
	If Not isObject(objCustomPopUp) Then
		strOutErrorDesc = "No pop up found with title '" & title & "'."
		checkForPopup = False
		Set objPage = Nothing
		Set customPopupDesc = Nothing
		Set objCustomPopUp = Nothing
		Exit Function
	End If
	
	Set popupBodyDesc = Description.Create
	popupBodyDesc("micclass").Value = "WebElement"
	popupBodyDesc("class").Value = "modal-body.*"
	popupBodyDesc("class").regularExpression = true
	Set objPopupBody = objPage.ChildObjects(popupBodyDesc)
	
	If Not isObject(objPopupBody) Then
		strOutErrorDesc = "No pop up body found"
		Set popupBodyDesc = Nothing
		Set objPopupBody = Nothing
		Set objCustomPopUp = Nothing
		Set customPopupDesc = Nothing
		Set objPage = Nothing
		checkForPopup = False
		Exit Function
	End If
	
	'verify if required text exists
	Set alertTextDesc = Description.Create
	alertTextDesc("micClass").Value = "WebElement"
	alertTextDesc("class").Value = ".*alert-text.*"
	alertTextDesc("class").regularExpression = true
	
	Dim popUpFound : popUpFound = False
	For i = 0 To objPopupBody.Count - 1
		Set objAlertText = objPopupBody(i).ChildObjects(alertTextDesc)
		
		If Not isObject(objAlertText) Then
			strOutErrorDesc = "No pop up body found"
			Set popupBodyDesc = Nothing
			Set objPopupBody = Nothing
			Set objCustomPopUp = Nothing
			Set customPopupDesc = Nothing
			Set objPage = Nothing
			Set alertTextDesc = Nothing
			Set objAlertText = Nothing
			checkForPopup = False
			Exit Function
		End If
	
		Dim popUpAlertText : popUpAlertText = ""
		For j = 0 To objAlertText.Count - 1
			popUpAlertText = popUpAlertText & objAlertText(j).getROProperty("innertext") & ";"
		Next
				
		If Instr(lcase(popUpAlertText), lcase(alertText)) > 0 Then
			Set buttonDesc = Description.Create
			buttonDesc("micclass").Value = "WebButton"
			buttonDesc("name").Value = buttonName
			'buttonDesc("class").Value = "btn-custom-model btn-custom-gradient"
			objPopupBody(i).highlight
			Set objButton = objPopupBody(i).WebButton(buttonDesc)
			objButton.Click
				
			Call WriteToLog("Pass", "Clicked '" & buttonName & "' button on the message box.")
			Set objButton = Nothing
				
			wait 3
			Err.Clear
			checkForPopup = True
			popUpFound = True
			Exit For
		End If
		
	Next
	
	
	If Not popUpFound Then
		strOutErrorDesc = "No Message Box exist with required text."
		checkForPopup = False
	End If	
	
	
	Set popupBodyDesc = Nothing
	Set objPopupBody = Nothing
	Set objCustomPopUp = Nothing
	Set buttonDesc = Nothing
	Set customPopupDesc = Nothing
	Set alertTextDesc = Nothing
	Set objAlertText = Nothing
	Set objPage = Nothing
End Function

'##################################################################################################################################
'Function Name       :	waitTillLoads
'Purpose of Function :	To wait till the Authenticating... messagebox dissappears. it waits maximum of 100seconds
'Input Arguments     :	None
'Output Arguments    :	None
'Example of Call     :	Call waitTillLoads()
'Author              :	Sudheer
'Date                :	10-April-2015
'##################################################################################################################################
Function waitTillLoads(ByVal textLabel)
	
	On Error Resume Next
	Err.Clear
	waitTillLoads = True
'	Set objPage = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
'	Set objPopup = objPage.WebElement("innertext:=" & textLabel & ".*", "html tag:=SPAN", "visible:=True")
	Dim cnt : cnt = 1
	Set objLoadingScreen = getPageObject().WebElement("class:=loadingblackscreendiv", "html tag:=DIV")
	Do while objLoadingScreen.getROProperty("visible") = True
		wait 1
		cnt = cnt + 1
		If cnt = 100 Then
			waitTillLoads = False
			Set objLoadingScreen = Nothing		
			Exit Do
		End If
	Loop

	Set objLoadingScreen = Nothing
	
End Function

'##################################################################################################################################
'Function Name       :	Logout
'Purpose of Function :	To logs out of Capella
'Input Arguments     :	None
'Output Arguments    :	None
'Example of Call     :	Call Logout()
'Author              :	Sudheer
'Date                :	13-April-2015
'##################################################################################################################################
Function Logout()
	
	On Error Resume Next
	Err.Clear
	
	Set objPage = getPageObject()
	
	'logout
	Set objLogout = objPage.WebElement("attribute/data-capella-automation-id:=LogOut", "html tag:=SPAN")
	If objLogout.Exist(3) Then
		objLogout.Click
	Else
		Exit function
	End If
	
	If err.Number = 0 Then
		wait 2
		Call waitTillLoads("Saving...")
		wait 2
		objPage.WebButton("name:=Ok").Click
		wait 2
		Call waitTillLoads("Loading...")
		wait 2
	End If
	
	Err.Clear
	Set objPage = Nothing
	Set objLogout = Nothing
End Function

'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'#######################################################################################################################################################################################################
'Function Name         : CloseAllOpenPatient
'Purpose of Function : Purpose of this function is to close all the open patient
'Input Arguments     : None 
'Output Arguments     : boolean: True or False
'                     : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call     : blnReturnValue = CloseAllOpenPatient(strOutErrorDesc)
'Author                 : Piyush Chandana
'Date                 : 11-March-2015
'Modification Done     : Piyush Chandana
'Modification date     : 02-April-2015
'#######################################################################################################################################################################################################
Function CloseAllOpenPatient(strOutErrorDesc)

    strOutErrorDesc = ""
    Err.Clear
    On Error Resume Next
    CloseAllOpenPatient = False
    
    strInvalidDataPopupTitle = "Invalid Data\s*"
    strClosePatientRecordPopupTitle = "Close Patient Record\?"
    strClosePatientRecordPopupText = "Contacts marked for deletion \(if any\) shall not be saved\.By finalizing the contacts for this patient, the patient record will also be closed\. Are you sure you want to proceed\?"
    intWaitTime = 10
	'wait till the loads
	wait 2
	waitTillLoads "Loading..."
	wait 2
    'Create object required for function CloseAllOpenPatient
    Set objPage = getPageObject()
    Execute "Set objOpenPatientWidget = " & Environment.Value("WEL_OpenPatientList_OpenPatientWidget")
    Execute "Set objOpenPatientListExpandIcon = " & Environment.Value("WEL_OpenPatientList_ExpandIcon")
    Execute "Set objOpenPatientListCollapseIcon = " & Environment.Value("WEL_OpenPatientList_CollapseIcon")
    Execute "Set objNoOfPatientOpen = " & Environment.Value("WEL_OpenPatientList_NoOfPatientOpen")
    
    'Verify that open patient widget exist on screen
    If Not CheckObjectExistence(objOpenPatientWidget,intWaitTime) Then
        strOutErrorDesc = "Open Patient widget does not exist on My Patient screen"
        Exit Function
    End If
    
    'Verify that open patient widget expand icon exist on screen
    If Not CheckObjectExistence(objOpenPatientListExpandIcon,intWaitTime) Then
        strOutErrorDesc = "Expand icon does not exist on the Open Patient widget"
        Exit Function
    End If
    
    'Expand Open Patient Widget
    Err.Clear
    objOpenPatientListExpandIcon.Click
    If Err.Number <> 0 Then
        strOutErrorDesc= "Open Patient widget is not expanded successfully.Error returned: "&Err.Description
        Exit Function    
    End If
	wait 2
	Call waitTillLoads("Loading...")
    Wait intWaitTime/5 'Wait Time for application sync
    'Verify that Open number patient count object shoult be present in Open patient widget
    If Not CheckObjectExistence(objNoOfPatientOpen,intWaitTime) Then
        objOpenPatientListCollapseIcon.Click
        If Err.Number <> 0 Then
            strOutErrorDesc= "Open Patient widget is not collapse successfully.Error returned: "&Err.Description
            Exit Function    
        End If
        CloseAllOpenPatient = True
        Exit Function    
    End If
    
    'Get the count of Open Patient from Open patient widget
    strPatientCount = objNoOfPatientOpen.getRoProperty("innertext")
    arrCount = split(strPatientCount,"(",-1,1)
    arrTotalCount = split(arrCount(1),")",-1,1)
    intPatientCount = arrTotalCount(0)
    intInvalidDataPopupCounter = 0
    
    If intPatientCount > 3 Then
    	Call WriteToLog("Fail", "There are '" & intPatientCount & "' open patients in the widget.")
    End If
    
    If intPatientCount > 0  Then
        Set objPatientName = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*open-column Patientopenborder.*;DIV;.*open-column Patientopenborder.*")
        For i = 0 To objPatientName.Count - 1 Step 1
            Err.Clear
            objPatientName(i).Click
            If Err.Number <> 0 Then
                strOutErrorDesc= Trim(objPatientName(i).GetROProperty("innertext")) &": Patient name is not clicked in Open patient widget.Error returned: "& Err.Description
                Exit Function    
            End If
            
			wait 2
            Call waitTillLoads("Loading...")
            Wait intWaitTime/5
            
            'Click on Collapse icon to close the open patient widget
            Execute "Set objOpenPatientListCollapseIcon = " & Environment.Value("WEL_OpenPatientList_CollapseIcon")
            objOpenPatientListCollapseIcon.Click
            If Err.Number <> 0 Then
                strOutErrorDesc= "Open Patient widget is not colllapse successfully.Error returned: "&Err.Description
                Exit Function    
            End If
			wait 2
			Call waitTillLoads("Loading...")
            Wait intWaitTime/5
            Execute "Set objFinalizeButton = " & Environment.Value("WB_RecapScreen_Finalize")
            Execute "Set objSaveButton = " & Environment.Value("WB_RecapScreen_Save")
            
            Dim isFinalizeExist : isFinalizeExist  = false
            Dim isSaveExist : isSaveExist = false
            'Click on finalize button, if finalize button exist
            If CheckObjectExistence(objFinalizeButton,intWaitTime) Then
            	isFinalizeExist = true
                Err.Clear
                objFinalizeButton.Click
                If Err.Number <> 0 Then
                    strOutErrorDesc= "Finalize button does not clicked successfully.Error returned: "&Err.Description
                    Exit Function    
                End If
				wait 2
                Call waitTillLoads("Loading...")
                Wait intWaitTime/5
            ElseIf CheckObjectExistence(objSaveButton,intWaitTime) Then
            	isSaveExist = true
                Err.Clear
                 objSaveButton.Click
                 If Err.Number <> 0 Then
                    strOutErrorDesc= "Save button does not clicked successfully.Error returned: "&Err.Description
                    Exit Function    
                 End If
				 wait 2
                 Call waitTillLoads("Loading...")
                 Wait intWaitTime/5
            End If
        
            'If Save and finalize buttons does not exist close the patient directly from patient widget
            If Not isSaveExist and Not isFinalizeExist Then
                Execute "Set objOpenPatientListExpandIcon = " & Environment.Value("WEL_OpenPatientList_ExpandIcon")
                objOpenPatientListExpandIcon.Click
                If Err.Number <> 0 Then
                    strOutErrorDesc= "Open Patient widget is not expanded successfully.Error returned: "&Err.Description
                    Exit Function    
                End If
				wait 2
                Call waitTillLoads("Loading...")
                Wait intWaitTime/5 'Wait time for sync application /2
                
                Set objCurrentPatient = getPageObject().WebElement("attribute/data-capella-automation-id:=Patients-CurrentPatient-0")
				Set objCloseIcon = objCurrentPatient.WebElement("title:=Finalize Patient")
                objCloseIcon.highlight
                objCloseIcon.Click
                Set objCloseIcon = Nothing
                Set objCurrentPatient = Nothing
                wait 2
                Call waitTillLoads("Loading...")
                Wait 5 'Wait time for sync application
				
				isPass = checkForPopup("Close Patient?", "Yes", "Do you want to finalize and close this patient record?", strOutErrorDesc)
				'Click on finalize button, if finalize button exist
				Execute "Set objFinalizeButton = " & Environment.Value("WB_RecapScreen_Finalize")
            	If CheckObjectExistence(objFinalizeButton,intWaitTime) Then
	                Err.Clear
	                objFinalizeButton.Click
	                If Err.Number <> 0 Then
	                    strOutErrorDesc= "Finalize button does not clicked successfully.Error returned: "&Err.Description
	                    Exit Function    
	                End If
	                wait 2
	                Call waitTillLoads("Loading...")
	                Wait intWaitTime/5
               	End If                
                'Click on Collapse icon to close the open patient widget
                Execute "Set objOpenPatientListCollapseIcon = " & Environment.Value("WEL_OpenPatientList_CollapseIcon")
                objOpenPatientListCollapseIcon.Click
                If Err.Number <> 0 Then
                    strOutErrorDesc= "Open Patient widget is not colllapse successfully.Error returned: "&Err.Description
                    Exit Function    
                End If
                
            End If
			wait 2
            Call waitTillLoads("Loading...")
            Wait intWaitTime/5 'wait Time for sync application
            
            'Check existence of message box for Close Patient record and click OK button
            Execute "Set objPopupTitle = " & Environment.Value("WEL_ClosePatientRecord_PopupTitle")
            Execute "Set objPopupText = " & Environment.Value("WEL_ClosePatientRecord_PopupText")
            blnReturnValue = CheckMessageBoxExist(objPopupTitle,strClosePatientRecordPopupTitle,objPopupText,strClosePatientRecordPopupText,"WB_OK|WB_CANCEL","No",strOutErrorDesc)
            If Not blnReturnValue Then    
                'Click OK button to close the close patient recod popup
                Execute "Set objOKButton = " & Environment.Value("WB_OK")
                objOKButton.Click
                If Err.Number <> 0 Then
                    strOutErrorDesc= "OK button not clicked successfully.Error returned: "&Err.Description
                    Exit Function    
                End If
            End If   
			wait 2
            Call waitTillLoads("Loading...")
            Wait intWaitTime/5
            
            'Invalid Data Popup Handling
            Execute "Set objPopupTitle = " & Environment.Value("WEL_InvalidDataPopUp_Title")
            blnReturnValue = CheckMessageBoxExist(objPopupTitle,strInvalidDataPopupTitle,"NA","NA","NA","No",strOutErrorDesc)
            If Not blnReturnValue Then
                
                intInvalidDataPopupCounter = intInvalidDataPopupCounter + 1
                
                If intInvalidDataPopupCounter = objPatientName.Count Then
                    strOutErrorDesc = "Display of Invalid Data popup reached to its maximum count i.e. total number of patient open in application.Hence patient can not be closed."
                    Exit Function
                End If
                'Click OK button to close the error popup
                Execute "Set objOKButton = " & Environment.Value("WB_OK")
                objOKButton.Click
                If Err.Number <> 0 Then
                    strOutErrorDesc= "OK button not clicked successfully.Error returned: "&Err.Description
                    Exit Function    
                End If
            End If    
			wait 2
            Call waitTillLoads("Loading...")
            Wait intWaitTime/5
            
            	
		'-----closing notification dialog box for storing app credentials-----------------------------------------------------------------------------------------------------------------------------------------
		Set objStoragePopupNotBtn = Browser("name:=DaVita VillageHealth Capella").WinObject("nativeclass:=window","object class:=window","text:=Do you want to allow.*").WinButton("nativeclass:=push button","object class:=push button","acc_name:=Not for this site")
		If objStoragePopupNotBtn.Exist(1) Then
			objStoragePopupNotBtn.highlight
			objStoragePopupNotBtn.click
		End If
		'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
            
            'click on expand icon to open the patient widget
            Execute "Set objOpenPatientListExpandIcon = " & Environment.Value("WEL_OpenPatientList_ExpandIcon")
            objOpenPatientListExpandIcon.Click
            If Err.Number <> 0 Then
                strOutErrorDesc= "Open Patient widget is not expanded successfully.Error returned: "&Err.Description
                Exit Function    
            End If
        Next
    End If
    
    'Click on Collapse icon to close the open patient widget
    Execute "Set objOpenPatientListCollapseIcon = " & Environment.Value("WEL_OpenPatientList_CollapseIcon")
    objOpenPatientListCollapseIcon.Click
    If Err.Number <> 0 Then
        strOutErrorDesc= "Open Patient widget is not collapse successfully.Error returned: "&Err.Description
        Exit Function    
    End If
	wait 2
    Call waitTillLoads("Loading...")
    Wait intWaitTime/2

    CloseAllOpenPatient = True
    Set objPage = Nothing
    Set objPatientName = Nothing
End Function

'#######################################################################################################################################################################################################
'Function Name		 : SelectUserRoster
'Purpose of Function : Purpose of this function is Select user roster
'Input Arguments	 : None
'Output Arguments	 : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call	 : blnReturnValue = SelectUserRoster(strOutErrorDesc)
'Author				 : Kavita Thorat
'Date				 : 06-April-2015
'##################################################################################################################################################################################

Function SelectUserRoster(strOutErrorDesc)
    
    strOutErrorDesc = ""
    Err.Clear
    On Error Resume Next
    SelectUserRoster = False
    
    'Create Object required for SelectUserRoster function
    Execute "Set objSwitchUserIcon = " & Environment.Value("WI_SwitchUser_SwitchUserIcon")
    Execute "Set objMyRosterBtn = " & Environment.Value("WB_SwitchUser_MyRosterBtn")
    Execute "Set objCloseIcon = " & Environment.Value("WI_SwitchUser_CloseIcon")
    
    'Check the existence of the Switch User icon
    If not objSwitchUserIcon.Exist(10) Then
         strOutErrorDesc = "Switch User icon does not exist"    
         Exit Function
    End If
    
    'Click on Switch User icon     
    blnReturnValue = ClickButton("Switch User", objSwitchUserIcon,strOutErrorDesc)
    If not(blnReturnValue) Then
        strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
        Exit Function    
    End If
	Wait 2
    Call waitTillLoads("Loading...")
    Wait 1
        
    'Check the existence of My Roster button 
    If objMyRosterBtn.Exist(3) Then
        'Click on the My Roster button
        blnReturnValue = ClickButton("My Roster",objMyRosterBtn,strOutErrorDesc)
        If not(blnReturnValue) Then
            strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
            Exit Function    
        End If
    Else
        'Click on the My Roster button
        blnReturnValue = ClickButton("Close",objCloseIcon,strOutErrorDesc)
        If not(blnReturnValue) Then
            strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
            Exit Function    
        End If
    End If
	Wait 2
    Call waitTillLoads("Loading...")
    Wait 1
    
'    Wait intWaitTime 'Wait time for sync
    
    SelectUserRoster = True
    
End Function

'###################################################################################################################################################################################
'Function Name:				OpenPatientProfileFromActionItemsList
'Purpose of Function:		Select Patient name from Action item list of dashboard
'Input Arguments:			strPatientName -> Patient name need to select from the Action list
'Output Arguments:			boolean
'Example of Call:			blnPatientExist = OpenPatientProfileFromActionItemsList("Adam, bernard",strOutErrorDesc)
'Author:					Piyush Chandana
'Date: 						03-Oct-2014
'###################################################################################################################################################################################

Function OpenPatientProfileFromActionItemsList(ByVal strPatientName, strOutErrorDesc)

	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
	OpenPatientProfileFromActionItemsList = False
	
	'Check patient name is present
	Set objPatient = ReturnObject("BrowserActionItemPatient", strPatientName)
	If not objPatient.Exist(5) Then
		strOutErrorDesc = "Patient Name: " & strPatientName & " not found in Action Items"
		Exit Function
	End If
	
	'Click on Patient name	
	objPatient.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Patient name : " & strPatientName & ". Error returned: " & Err.Description
		Exit Function
	End If
	
	Set objLoading = getPageObject().WebElement("class:=.*please-wait.*", "visible:=True")
	Do while objLoading.Exist(1) = true
		wait 1
	Loop	
	'Create Object required for OpenPatientProfileFromActionItemsList function
	Execute "Set objPatientProfile = "  & Environment.Value("WEL_MyPatient_PatientProfile")	'My Patient > Patient Profile widget
	
	'Check user is navigated to My Patient tab and Patient Profile widget is visible
	blnReturnValue = objPatientProfile.WaitProperty("visible", True, 50000)
'	If not blnReturnValue Then
'		strOutErrorDesc = "Patient Profile for '" & strPatientName & "' not loaded"
'		Exit Function
'	End If
	
	OpenPatientProfileFromActionItemsList = True
	
End Function


'##################################################################################################################################
'Function Name       :	getTaskStatus
'Purpose of Function :	To return the color of a particular task of a particular domain in the score card
'Input Arguments     :	domain, task
'Output Arguments    :	None
'Example of Call     :	reqColor = getTaskStatus("General Program", "HGB")
'Author              :	Sudheer
'Date                :	05-May-2015
'##################################################################################################################################
Function getTaskStatus(ByVal domain, ByVal task)
	On Error Resume Next
	Err.Clear
	
	Dim shownColor : shownColor = "NA"
	
	Set objpage = getPageObject
	Set objDesc = Description.Create
	objDesc("micclass").Value = "WebElement"
	objDesc("html tag").Value = "DIV"
	objDesc("class").Value = ".*col-md-3.*"
	Set objCCC = objPage.ChildObjects(objDesc)
	
	Set labelDesc = Description.Create
	labelDesc("micclass").Value = "WebElement"
	labelDesc("html tag").Value = "DIV"
	labelDesc("class").Value = ".*line-height-scorecard-title"
	
	Dim reqBox
	For i = 0 To objCCC.Count - 1
		Set objLabel = objCCC(i).ChildObjects(labelDesc)
		If Instr(objLabel(0).GetROProperty("innertext"), domain) > 0 Then
			Set reqBox = objCCC(i)
			Exit For
		End If
	Next
	Set objLabel = Nothing
	Set labelDesc = Nothing
	Set objCCC = Nothing
	Set objDesc = Nothing
	
	Set rowDesc = Description.Create
	rowDesc("micclass").Value = "WebElement"
	rowDesc("html tag").Value = "DIV"
	'rowDesc("class").Value = "col-md-11.*"
	rowDesc("class").Value = "row ng-scope"
	
	Set objRow = reqBox.ChildObjects(rowDesc)
	
	Set elemDesc = Description.Create
	elemDesc("micclass").Value = "WebElement"
	elemDesc("class").Value = "col-md-11.*"
	
	Set colorDesc = Description.Create
	colorDesc("micclass").Value = "WebElement"
	colorDesc("class").Value = "col-md-1 .*"
	For i = 0 To objRow.Count - 1
		Set reqRow = objRow(i).ChildObjects(elemDesc)
		Dim text 
		text = reqRow(0).GetROProperty("innertext")
		If Instr(text, task) > 0	Then
			Set objColor = objRow(i).ChildObjects(colorDesc)
			Dim color : color = objColor(0).getROProperty("class")
			If Instr(color, "image-Good") > 0 Then
				shownColor = "GREEN"
			ElseIf Instr(color, "image-Neutral") > 0 Then
				shownColor = "AMBER"
			ElseIf Instr(color, "image-Focus") > 0 Then
				shownColor = "RED"
			End If
			
			Set colorDesc = Nothing
			Set objColor = Nothing
		End If 
	Next
	
	getTaskStatus = shownColor
		
	Set reqRow = Nothing
	Set rowDesc = Nothing
	Set objRow = Nothing
	Set reqBox = Nothing
	Set objpage = Nothing
End Function

'##################################################################################################################################
'Function Name       :	getFullTaskDetails
'Purpose of Function :	To return the complete task of a particular task of a particular domain in the score card
'Input Arguments     :	domain, task
'Output Arguments    :	None
'Example of Call     :	reqTask = getFullTaskDetails("General Program", "HGB")
'Author              :	Sudheer
'Date                :	05-May-2015
'##################################################################################################################################
Function getFullTaskDetails(ByVal domain, ByVal task)
	On Error Resume Next
	Err.Clear
	
	Dim fullTask : fullTask = "NA"
	
	Set objpage = getPageObject
	Set objDesc = Description.Create
	objDesc("micclass").Value = "WebElement"
	objDesc("html tag").Value = "DIV"
	objDesc("class").Value = ".*col-md-3.*"
	Set objCCC = objPage.ChildObjects(objDesc)
	
	Set labelDesc = Description.Create
	labelDesc("micclass").Value = "WebElement"
	labelDesc("html tag").Value = "DIV"
	labelDesc("class").Value = ".*line-height-scorecard-title"
	
	Dim reqBox
	For i = 0 To objCCC.Count - 1
		Set objLabel = objCCC(i).ChildObjects(labelDesc)
		If Instr(objLabel(0).GetROProperty("innertext"), domain) > 0 Then
			Set reqBox = objCCC(i)
			Exit For
		End If
	Next
	Set objLabel = Nothing
	Set labelDesc = Nothing
	Set objCCC = Nothing
	Set objDesc = Nothing
	
	Set rowDesc = Description.Create
	rowDesc("micclass").Value = "WebElement"
	rowDesc("html tag").Value = "DIV"
	'rowDesc("class").Value = "col-md-11.*"
	rowDesc("class").Value = "row ng-scope"
	
	Set objRow = reqBox.ChildObjects(rowDesc)
	
	Set elemDesc = Description.Create
	elemDesc("micclass").Value = "WebElement"
	elemDesc("class").Value = "col-md-11.*"
	
	For i = 0 To objRow.Count - 1
		Set reqRow = objRow(i).ChildObjects(elemDesc)
		Dim text 
		text = reqRow(0).GetROProperty("innertext")
		If Instr(text, task) > 0	Then
			fullTask = text
			Exit For
		End If 
	Next
	
	getFullTaskDetails = fullTask
	
	Set elemDesc = Nothing
	Set reqRow = Nothing
	Set rowDesc = Nothing
	Set objRow = Nothing
	Set reqBox = Nothing
	Set objpage = Nothing
	
End Function

'##################################################################################################################################
'Function Name       :	getAllTasks
'Purpose of Function :	To return array of all tasks of a particular domain in the score card
'Input Arguments     :	domain
'Output Arguments    :	None
'Example of Call     :	tasks = getAllTasks("Health Maintenance")
'Author              :	Sudheer
'Date                :	05-May-2015
'##################################################################################################################################
Function getAllTasks(ByVal domain)
	On Error Resume Next
	Err.Clear
	
	Dim fullTask()
	
	
	Set objpage = getPageObject
	Set objDesc = Description.Create
	objDesc("micclass").Value = "WebElement"
	objDesc("html tag").Value = "DIV"
	objDesc("class").Value = ".*col-md-3.*"
	Set objCCC = objPage.ChildObjects(objDesc)
	
	Set labelDesc = Description.Create
	labelDesc("micclass").Value = "WebElement"
	labelDesc("html tag").Value = "DIV"
	labelDesc("class").Value = ".*line-height-scorecard-title"
	
	Dim reqBox
	For i = 0 To objCCC.Count - 1
		Set objLabel = objCCC(i).ChildObjects(labelDesc)
		If Instr(objLabel(0).GetROProperty("innertext"), domain) > 0 Then
			Set reqBox = objCCC(i)
			Exit For
		End If
	Next
	Set objLabel = Nothing
	Set labelDesc = Nothing
	Set objCCC = Nothing
	Set objDesc = Nothing
	
	Set rowDesc = Description.Create
	rowDesc("micclass").Value = "WebElement"
	rowDesc("html tag").Value = "DIV"
	'rowDesc("class").Value = "col-md-11.*"
	rowDesc("class").Value = "row ng-scope"
	
	Set objRow = reqBox.ChildObjects(rowDesc)
	
	Set elemDesc = Description.Create
	elemDesc("micclass").Value = "WebElement"
	elemDesc("class").Value = "col-md-11.*"
	
	For i = 0 To objRow.Count - 1
		Set reqRow = objRow(i).ChildObjects(elemDesc)
		Dim text 
		text = reqRow(0).GetROProperty("innertext")
		ReDim Preserve fullTask(i)
		fullTask(i) = text
	Next
	
	getAllTasks = fullTask
		
	Set reqRow = Nothing
	Set rowDesc = Nothing
	Set objRow = Nothing
	Set reqBox = Nothing
	Set objpage = Nothing
End Function

'##################################################################################################################################
					   'Function Name       :	isDomainExist
'Purpose of Function :	To validate if domain exist
'Input Arguments     :	domain
'Output Arguments    :	None
'Example of Call     :	tasks = getAllTasks("Health Maintenance")
'Author              :	Sudheer
'Date                :	05-May-2015
'##################################################################################################################################
Function isDomainExist(ByVal domain)
	On Error Resume Next
	Err.Clear
	
	Dim isDomainExists : isDomainExists = False
	
	
	Set objpage = getPageObject()
	Set objDesc = Description.Create
	objDesc("micclass").Value = "WebElement"
	objDesc("html tag").Value = "DIV"
	objDesc("class").Value = ".*col-md-3.*"
	Set objCCC = objPage.ChildObjects(objDesc)
	
	Set labelDesc = Description.Create
	labelDesc("micclass").Value = "WebElement"
	labelDesc("html tag").Value = "DIV"
	labelDesc("class").Value = ".*line-height-scorecard-title"
	
	Dim reqBox
	For i = 0 To objCCC.Count - 1
		Set objLabel = objCCC(i).ChildObjects(labelDesc)
		If Instr(objLabel(0).GetROProperty("innertext"), domain) > 0 Then
			Set reqBox = objCCC(i)
			isDomainExists = True
			Exit For
		End If
	Next
	
	isDomainExist = isDomainExists
	
	Set objLabel = Nothing
	Set labelDesc = Nothing
	Set objCCC = Nothing
	Set objDesc = Nothing
End Function

'##################################################################################################################################
'Function Name       :	clickOnTask
'Purpose of Function :	To click on a particular task for a particular domain in the score card
'Input Arguments     :	domain, task
'Output Arguments    :	None
'Example of Call     :	isPass = clickOnTask("General Program", "HGB")
'Author              :	Sudheer
'Date                :	08-May-2015
'##################################################################################################################################
Function clickOnTask(ByVal domain, ByVal task)
	On Error Resume Next
	Err.Clear
	
	clickOnTask = False
	
	Set objpage = getPageObject
	Set objDesc = Description.Create
	objDesc("micclass").Value = "WebElement"
	objDesc("html tag").Value = "DIV"
	objDesc("class").Value = ".*col-md-3.*"
	Set objCCC = objPage.ChildObjects(objDesc)
	
	Set labelDesc = Description.Create
	labelDesc("micclass").Value = "WebElement"
	labelDesc("html tag").Value = "DIV"
	labelDesc("class").Value = ".*line-height-scorecard-title"
	
	Dim reqBox
	For i = 0 To objCCC.Count - 1
		Set objLabel = objCCC(i).ChildObjects(labelDesc)
		If Instr(objLabel(0).GetROProperty("innertext"), domain) > 0 Then
			Set reqBox = objCCC(i)
			Exit For
		End If
	Next
	Set objLabel = Nothing
	Set labelDesc = Nothing
	Set objCCC = Nothing
	Set objDesc = Nothing
	
	Set rowDesc = Description.Create
	rowDesc("micclass").Value = "WebElement"
	rowDesc("html tag").Value = "DIV"
	'rowDesc("class").Value = "col-md-11.*"
	rowDesc("class").Value = "row ng-scope"
	
	Set objRow = reqBox.ChildObjects(rowDesc)
	
	Set elemDesc = Description.Create
	elemDesc("micclass").Value = "WebElement"
	elemDesc("class").Value = "col-md-11.*"
	
	For i = 0 To objRow.Count - 1
		Set reqRow = objRow(i).ChildObjects(elemDesc)
		Dim text 
		text = reqRow(0).GetROProperty("innertext")
		If Instr(text, task) > 0	Then
			reqRow(0).Click		
			clickOnTask = True
			Exit For
		End If 
	Next
	
		
	Set reqRow = Nothing
	Set rowDesc = Nothing
	Set objRow = Nothing
	Set reqBox = Nothing
	Set objpage = Nothing
End Function


'##################################################################################################################################
'Function Name       :	selectPatientFromOpenCallList
'Purpose of Function :	To select a patient from open call list
'Input Arguments     :	strPatientName
'Output Arguments    :	None
'Example of Call     :	Call selectPatientFromOpenCallList("Berry")
'Prerequisite		 :  "My Dashboard" screen should be open
'Author              :	Sudheer
'Date                :	04-May-2015
'##################################################################################################################################
Function selectPatientFromOpenCallList(ByVal strPatientName)
	
	On Error Resume Next
	Err.Clear
	
	'Check patient name is present
	Set objPatient = ReturnObject("OpenCallList", strPatientName)
	If not objPatient.Exist(5) Then
		Call WriteToLog("Fail", "Patient Name: " & strPatientName & " not found in Action Items")
		Set objPatient = Nothing
		selectPatientFromOpenCallList = False
		Exit Function
	End If
	
	'Click on Patient name	
	objPatient.highlight
	
	intX = objPatient.GetROProperty("abs_x")
	intY = objPatient.GetROProperty("abs_y")
	Set ObjectName = CreateObject("Mercury.DeviceReplay")
	ObjectName.MouseMove intX,intY
	wait 3
	
	ObjectName.MouseDblClick intX, intY, 0
	If Err.Number <> 0 Then
		Call WriteToLog("Fail", "Unable to click on Patient name : " & strPatientName & ". Error returned: " & Err.Description)
		Set objPatient = Nothing
		Set objectName = Nothing
		selectPatientFromOpenCallList = False
		Exit Function
	End If
	
	Set objPatient = Nothing
	Set objectName = Nothing	
	
	selectPatientFromOpenCallList = True
	
End Function




'##################################################################################################################################
'Function Name       :	CloseDBConnection
'Purpose of Function :	Disconnects DB connection established in ConnectDB funciton call
'Input Arguments     :	None
'Output Arguments    :	None
'Example of Call     :	Call CloseDBConnection()
'Author              :	Sudheer
'Date                :	06-May-2015
'##################################################################################################################################
Public Function CloseDBConnection()
	On Error Resume Next
	Err.Clear
	objDBRecordSet.Close 'Variable initialised in RunQueryRetrieveRecordSet funciton
	objDBConnection.Close  'Variable initialised in ConnectDB funciton
	Set objDBConnection = nothing
	Set objDBRecordSet = Nothing
	Print "DB connection is closed"

End Function

'##################################################################################################################################
'Function Name       :	ConnectDB
'Purpose of Function :	Establishes connection to Database
'Input Arguments     :	None. Input values are taken from config file.
'Output Arguments    :	None
'Example of Call     :	isPass = ConnectDB()
'Author              :	Sudheer
'Date                :	06-May-2015
'##################################################################################################################################
Function ConnectDB()
	
	On Error Resume Next
	Err.Clear
	
	Dim isPass : isPass = True
	
	Dim strHostName,strPortName,strServiceName,strUID,strPassword
	
	strHostName = getConfigFileValue("HostName") '"sea-ax0183.davita.com"   '172.16.38.165
	strPortName = getConfigFileValue("DBPortNumber")	'"1526"
	strServiceName = getConfigFileValue("DBServiceName")	'"MISTSYS"
	strUID = getConfigFileValue("DBUserName")	'"CAPELLA"
	strPassword = getConfigFileValue("DBPassword") 
	
	strCon="Driver={Microsoft ODBC for Oracle};CONNECTSTRING=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=" & strHostName &")(PORT="& strPortName &"))(CONNECT_DATA=(SERVICE_NAME="& strServiceName & ")));Uid="& strUID & ";Pwd="& strPassword&";"
		
	Set objDBConnection = CreateObject("ADODB.Connection")
	objDBConnection.Open strCon
	
	If objDBConnection.State = "1" Then
		Print "Connection to the Database is established."	
	ElseIf objDBConnection.state = "0" Then
		Print "Connection to the Database could not be Established"
		isPass = False
	End If
	
	Err.Clear
	
	ConnectDB = isPass
	
End Function

'##################################################################################################################################
'Function Name       :	RunQueryRetrieveRecordSet
'Purpose of Function :	Run the query and store the data in global variable objDBRecordSet
'Input Arguments     :	strQuery
'Output Arguments    :	None
'Example of Call     :	isPass = RunQueryRetrieveRecordSet("select * from mem_member where mem_id = '100352'")
'Author              :	Sudheer
'Date                :	06-May-2015
'##################################################################################################################################
Function RunQueryRetrieveRecordSet(ByVal strQuery)
	On Error Resume Next
	Err.Clear
	Dim isPass : isPass = True
	If objDBConnection.State <> "1" Then  'Object Name is set in ConnectDB function
		isPass = False
	Else
		Set objDBRecordSet = CreateObject("ADODB.Recordset")
		objDBRecordSet.Open strQuery,objDBConnection,3,3,1  'objDBRecordSet is set as Public variable
		If Err.Description<>"" Then
			isPass = False	
		End If
	End If	
	
'	objConn.Open strConnection
'    objCmd.ActiveConnection = objConn
'    objCmd.CommandType = adCmdStoredProc
'
'    objCmd.Properties("PLSQLRSet") = TRUE
'
'    objCmd.CommandText = "pk_students.getstudents"
'
'    objCmd.Parameters.Append objCmd.CreateParameter("param1", adVarChar, adParamInput, 10, v_studentid)
'    Set objSearch = objCmd.Execute
	
	RunQueryRetrieveRecordSet = isPass
End Function

'##################################################################################################################################
'Function Name       :	verifyPatientTaskinActionItemsList
'Purpose of Function :	To verify the task is present in Action Items List of a patient
'Input Arguments     :	Patient Name, Task to verify
'Output Arguments    :	None
'Example of Call     :	isPass = verifyPatientTaskinActionItemsList("Burtan, Kay", "Annual LDL Due")
'Author              :	Sudheer
'Date                :	07-May-2015
'##################################################################################################################################
Function verifyPatientTaskinActionItemsList(ByVal strPatientName, ByVal reqTask)

	On Error Resume Next
	Err.Clear
	verifyPatientTaskinActionItemsList = False
	
	'Get page object
	Set objPage = getPageObject()
	
	'Check if patient exist in action item list
	Set objPatientDetailView = objPage.WebElement("html tag:=DIV","class:=row detailView-patient .*","innertext:=.*"&strPatientName&".*")
	objPatientDetailView.highlight
	If not objPatientDetailView.Exist(3) Then
		verifyPatientTaskinActionItemsList = False
		Set objPatientDetailView = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("class").Value = "col-md-1 rvrthirdBLock"
	
	Set oWebElement = objPatientDetailView.ChildObjects(oDesc)
	oWebElement(0).highlight
	oWebElement(0).Click
	
	Set objTaskView = objPage.WebElement("html tag:=DIV","class:=col-md-12 detailView-patient .*")
	objTaskView.highlight
	
	If not objTaskView.Exist(3) Then
		verifyPatientTaskinActionItemsList = False
		Set oDesc = Nothing
		Set oWebElement = Nothing
		Set objTaskView = Nothing
		Set objPatientDetailView = Nothing
		Set objPage = Nothing
		Exit Function
	End If	
	
	Set oTaskDesc = Description.Create
	oTaskDesc("micclass").Value = "WebElement"
	oTaskDesc("class").Value = "col-md-8 .*"
	
	Set objTasks = objTaskView.ChildObjects(oTaskDesc)
	For i = 0 To objTasks.Count - 1
		task = objTasks(i).GetROProperty("innertext")
		If Instr(task, reqTask) > 0 Then
			Print trim(task)
			verifyPatientTaskinActionItemsList = True
			Exit For
		End If
		
	Next
	
	Err.Clear
	
	Set oTaskDesc = Nothing
	Set objTasks = Nothing	
	Set objTaskView = Nothing
	Set oDesc = Nothing
	Set oWebElement = Nothing
	Set objPatientDetailView = Nothing
	Set objPage = Nothing
End Function

'##################################################################################################################################
'Function Name       :	getDueDateOfTaskinActionItemsList
'Purpose of Function :	To get due date of a particular task of a patient from the Action Items List
'Input Arguments     :	Patient Name, Task to retrieve due date
'Output Arguments    :	due date of the task, else NA
'Example of Call     :	dueDate = getDueDateOfTaskinActionItemsList("Burtan, Kay", "Annual LDL Due")
'Author              :	Sudheer
'Date                :	07-May-2015
'##################################################################################################################################
Function getDueDateOfTaskinActionItemsList(ByVal strPatientName, ByVal reqTask)

'	On Error Resume Next
'	Err.Clear
	getDueDateOfTaskinActionItemsList = "NA"
	
	'Get page object
	Set objPage = getPageObject()
	
	'Check if patient exist in action item list
	Set objPatientDetailView = objPage.WebElement("html tag:=DIV","class:=row detailView-patient .*","innertext:=.*"&strPatientName&".*")
	objPatientDetailView.highlight
	If not objPatientDetailView.Exist(3) Then
		getDueDateOfTaskinActionItemsList = False
		Set objPatientDetailView = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	
	Set oDesc = Description.Create
	oDesc("micclass").Value = "WebElement"
	oDesc("class").Value = "col-md-1 rvrthirdBLock"
	
	Set oWebElement = objPatientDetailView.ChildObjects(oDesc)
	oWebElement(0).highlight
	oWebElement(0).Click
	
	Set objTaskView = objPage.WebElement("html tag:=DIV","class:=col-md-12 detailView-patient .*")
	objTaskView.highlight
	
	If not objTaskView.Exist(3) Then
		getDueDateOfTaskinActionItemsList = "NA"
		Set oDesc = Nothing
		Set oWebElement = Nothing
		Set objTaskView = Nothing
		Set objPatientDetailView = Nothing
		Set objPage = Nothing
		Exit Function
	End If	
	
	Set dueDateDesc = Description.Create
	dueDateDesc("micclass").Value = "WebElement"
	dueDateDesc("class").Value = "due-date .*"
	dueDateDesc("html tag").Value = "SPAN"
	
	Set fullTaskDesc = Description.Create
	fullTaskDesc("micclass").Value = "WebElement"
	fullTaskDesc("class").Value = ".*row.*"
	Set objfullTask = objTaskView.ChildObjects(fullTaskDesc)
	Print "Count: " & objfullTask.Count
	
	For i = 0 To objfullTask.Count - 1
		Set oTaskDesc = Description.Create
		oTaskDesc("micclass").Value = "WebElement"
		oTaskDesc("html tag").Value = "PRE"
		
		Set objTasks = objfullTask(i).ChildObjects(oTaskDesc)
		Print objTasks.Count
		
		task = objTasks(0).GetROProperty("innertext")
		If Instr(task, reqTask) > 0 Then
			Print trim(task)
			objTasks(0).highlight
			
			Set dueDateDesc = Description.Create
			dueDateDesc("micclass").Value = "WebElement"
			dueDateDesc("attribute/data-capella-automation-id").Value = "Action_Items_DueDate.*"
			dueDateDesc("attribute/data-capella-automation-id").RegularExpression = True
'			dueDateDesc("html id").Value = "SPAN"
			
			Set objDueDate = objfullTask(i).ChildObjects(dueDateDesc)
			Print objDueDate.Count
			
			dueDate = objDueDate(0).getROProperty("innertext")
			
			Set dueDateDesc = Nothing
			Set objDueDate = Nothing
			
			getDueDateOfTaskinActionItemsList = dueDate
			Exit For
		End If
		
		Set objTasks = Nothing
		Set oTaskDesc = Nothing
	Next
	
	Set fullTaskDesc = Nothing
	Set objfullTask = Nothing
	Set dueDateDesc = Nothing
	Set oTaskDesc = Nothing
	Set objTasks = Nothing	
	Set objTaskView = Nothing
	Set oDesc = Nothing
	Set oWebElement = Nothing
	Set objPatientDetailView = Nothing
	Set objPage = Nothing
End Function

'##################################################################################################################################
'Function Name       :	validatePatientProfileScreen
'Purpose of Function :	To validate complete patient profile screen which is on the left side
'Input Arguments     :	Member first name, member last name, member id
'Output Arguments    :	None
'Example of Call     :	Call validatePatientProfileScreen(strMemberFirstName, strMemberLastName, strMemberID)
'Author              :	Sudheer
'Date                :	11-May-2015
'##################################################################################################################################
Function validatePatientProfileScreen(ByVal memberFirstName, ByVal memberLastName, ByVal memberID)
	On Error Resume Next
	Err.Clear
	
	strPatientName = memberFirstName & " " & memberLastName
	
	Dim labels
	labels = "CONTACT PREFERENCE;HOME PHONE ;WORK PHONE ;MOBILE PHONE ;ADDRESS ;BIRTHDATE;MARITAL STATUS;GENDER;LANGUAGE;RACE / ETHNICITY;ELIGIBILITY STATUS;DISEASE STATE;SHIFT/SCHEDULE;PAYOR;IMBH ELIGIBLE;CURRENT ACCESS;VASC. ACCESS STEP;MEDICATIONS;ALLERGIES;COMORBIDS;PROVIDERS & TEAM;MEDICAL AUTHORIZATION"
	
	Dim labelNames
	labelNames = Split(labels, ";")
	
	Set objPage = getPageObject()
	Set objPatientProfileTitle =  objPage.WebElement("class:=row title-gradient title-header.*","html tag:=DIV","innertext:=.*Patient Profile.*")
	
	Set prfoileContainerDesc = Description.Create
	prfoileContainerDesc("micclass").Value = "WebElement"
	prfoileContainerDesc("class").Value = "profile-container.*"
	
	Set objProfileContainer = objPage.WebElement(prfoileContainerDesc)
	objProfileContainer.highlight
	
	'verify Patient Name
	Set nameDesc = Description.Create
	nameDesc("micclass").Value = "WebElement"
 	nameDesc("class").Value = "patient-name.*"
	Set objName = objProfileContainer.ChildObjects(nameDesc)
	Set patientNameDesc = Description.Create
	patientNameDesc("micclass").Value = "WebElement"
	patientNameDesc("html tag").Value = "SPAN"
	Set names = objName(0).ChildObjects(patientNameDesc)
	patientName = names(0).getROProperty("innertext")
	
	If StrComp(strPatientName, patientName, 1) = 0 Then
		Call WriteToLog("Pass", "Patient name is correct")
	Else
		Call WriteToLog("Fail", "Patient name is wrong" & strPatientName)
	End If
	
	Set rowDesc = Description.Create
	rowDesc("micclass").Value = "WebElement"
	rowDesc("class").Value = "row remove-margin.*"
	
	Set objRows = objProfileContainer.ChildObjects(rowDesc)

	Dim j : j = 0
	Dim k : k = 13
	
	'open db connections
	isPass = ConnectDB()
	If Not isPass Then
		validatePatientProfileScreen = False
	End If
	
	'Validate all the labels in Patient Profile Screen
	For i = 0 To objRows.Count - 1
	
		Set labelDesc = Description.Create
		labelDesc("micclass").Value = "WebElement"
		labelDesc("class").Value = ".*patient-info-label.*"
		
		Set objLabel = objRows(i).ChildObjects(labelDesc)
		If objLabel.Count = 1 Then
			Set labelValueDesc = Description.Create
			labelValueDesc("micclass").Value = "WebElement"
			labelValueDesc("class").Value = "patient-info .*"
			Set objLabelValue = objRows(i).WebElement(labelValueDesc)
			labelText = objLabel(0).GetROProperty("innertext")
'			textValue = objLabelValue.getROProperty("innertext")
'			Print labelText & " --> " & textValue
			Print labelText
			innerhtmlText = objRows(i).getROProperty("innerhtml")
			If Not Instr(innerhtmlText, "col-xs-12") > 0 Then 
'				If StrComp(labelText, labelNames(j), 1) = 0 Then
				If Ubound(Filter(labelNames, labelText)) > -1 Then
					Call WriteToLog("Pass", labelText & " exists in patient profile screen")
				Else
					Call WriteToLog("Fail", labelText & " should not be present in patient profile screen")
				End If
				
				Call validateButtonIfExists(objRows(i), trim(labelText), memberID, isPass)
				
				j = j + 1
				
			End If

			Err.Clear

			Set labelValueDesc = Nothing
			Set objLabelValue = Nothing
		End If
		
		Set objLabel = Nothing
		Set labelDesc = Nothing
		
	Next
	
	Set names = Nothing
	Set patientNameDesc = Nothing
	Set objName = Nothing
	Set nameDesc = Nothing
	Set objRows = Nothing
	Set prfoileContainerDesc = Nothing
	Set objProfileContainer = Nothing
	Set objPatientProfileTitle = Nothing
	Set objPage = Nothing
	
	'close db connections
	Call CloseDBConnection()
	
End Function

Function getCount(ByVal labelName, ByVal memberID, byVal connectionStatus)
	
	Dim count
	count = "NA"
	Dim strSqlQuery
	
	Select Case UCase(labelName)
	
		Case "VASC. ACCESS STEP"
			strSqlQuery = "select LAST_STEP from M2prod.VASACC_VASCULAR_ACCESS_M where member_UID in (select mem_uid from mem_member where mem_id = '" & memberID & "') and STOP_DATE is NULL"
		Case "MEDICATIONS"
			strSqlQuery = "select count(*) from M2PROD.RXMED_MEDCLM_ORDER where key_member_uid in (select mem_uid from mem_member where mem_id = '" & memberID & "') and RXMED_DISCONTINUED_DATE is Null"
		
		Case "ALLERGIES"
			strSqlQuery = "select count(*) from M2PROD.ALGY_ALLERGY_LIST where member_uid in (select mem_uid from mem_member where mem_id = '" & memberID & "') and ALGY_IS_DELETED_YN = 'N'"
			
		Case "COMORBIDS"
			strSqlQuery = "select count(*) from PCMB_PATIENT_COMORBIDS where PCMB_MEM_UID in (select mem_uid from mem_member where mem_id = '" & memberID & "') and PCMB_STATUS = 'A'"
			
		Case "PROVIDERS & TEAM"
			strSqlQuery = "select count(*) from mpa_mem_pta_associate where mpa_mem_uid in (select mem_uid from mem_member where mem_id = '" & memberID & "') and mpa_date_end > sysdate"
		
		Case "MEDICAL AUTHORIZATION"
			strSqlQuery = ""
	
		Case Else
			strSqlQuery = ""
	End Select
	
	
	If strSqlQuery = "" Then
		getCount = "NA"
		Exit Function
	End If
	Dim isPass : isPass = false
	If connectionStatus Then
		isPass = RunQueryRetrieveRecordSet(strSqlQuery)
	End If
	
	
	If not isPass Then
		getCount = "NA"
		Exit Function
	End If
	
	Do until objDBRecordSet.EOF
		count = objDBRecordSet.Fields(0).Value
		objDBRecordSet.MoveNext
	Loop
		
	getCount = count
	
End Function

Function validateButtonIfExists(ByVal objRow, ByVal labelName, ByVal memberID, ByVal connectionStatus)
	On Error Resume Next
	Err.Clear
	
	Select Case labelName
		Case "VASC. ACCESS STEP"
		Case "MEDICATIONS"
		Case "ALLERGIES"
		Case "COMORBIDS"
		Case "PROVIDERS & TEAM"
		Case "MEDICAL AUTHORIZATION"
		Case Else
			Exit Function
	End Select
	
	Set btnDesc = Description.Create
	btnDesc("micclass").Value = "WebElement"
	btnDesc("class").Value = "btn-custom btn-custom-gradient.*"
	
	Set objBtn = objRow.WebElement(btnDesc)
	objBtn.Click
	
	Call checkScreenLabelPP(labelName)
	buttonVal = objBtn.GetROProperty("innertext")
	
	If labelName = "VASC. ACCESS STEP" Then
		dbValue = getCount(labelName, memberID)
		If trim(buttonVal) <> "" Then
			If trim(dbValue) = trim(buttonVal) Then
				Call WriteToLog("Pass", "Value of " & labelName & " in DB and UI matches. Value is - " & buttonVal)
			Else
				Call WriteToLog("Fail", "Value of " & labelName & " in DB is - " & dbValue & ", does not match to as in UI - " & buttonVal)
			End If
		Else
			Call WriteToLog("Pass", "Value on the button for the label " & labelName & " is blank.")
		End If
		
		
	Else
'		x = Mid(buttonVal, 2, len(buttonVal) - 2)
		x = Mid(buttonVal, Instr(buttonVal, "(") + 1, Instr(buttonVal, ")") - Instr(buttonVal, "(") - 1)
	
		count = getCount(labelName, memberID, connectionStatus)
		If count <> "NA" Then
			If CInt(count) = CInt(x) Then
				Call WriteToLog("Pass", "Count of " & labelName & " in DB and UI matches. Value is - " & count)
			Else
				Call WriteToLog("Fail", "Count of " & labelName & " in DB is - " & count & ", does not match to as in UI - " & x)
			End If
		End If
		
	End If
	
	Set btnDesc = Nothing
	Set objBtn = Nothing
	
	
End Function

Function checkScreenLabelPP(ByVal labelName)
	On Error Resume Next
	Err.Clear

	Set labelDesc = Description.Create
	labelDesc("micclass").Value = "WebElement"
	labelDesc("html tag").Value = "DIV"
	
	
	Select Case labelName
		
		Case "VASC. ACCESS STEP"
			labelDesc("class").Value = "col-xs-12 page-title-intervention containerHeader ng-binding"
			labelDesc("innertext").Value = "Access Management.*"
			Set objPage = getPageObject()
			Set objLabel = objPage.WebElement(labelDesc)
			isPass = waitUntilExist(objLabel, 5)
			
		Case "MEDICATIONS"
			isOk = checkForPopup("Some Data May Be Out of Date", "Ok", "The information ", strOutErrorDesc)
			isOk = checkForPopup("Disclaimer","Ok", "The information ", strOutErrorDesc)
			
			labelDesc("class").Value = "col-xs-12 page-title-intervention containerHeader ng-binding"
			labelDesc("innertext").Value = "Medications Management.*"
			Set objPage = getPageObject()
			Set objLabel = objPage.WebElement(labelDesc)
			isPass = waitUntilExist(objLabel, 5)
			
		Case "ALLERGIES"
			isOk = checkForPopup("Some Data May Be Out of Date", "Ok", "The information ", strOutErrorDesc)
			isOk = checkForPopup("Disclaimer","Ok", "The information ", strOutErrorDesc)
			
			labelDesc("class").Value = "col-xs-12 page-title-intervention containerHeader ng-binding"
			labelDesc("innertext").Value = "Medications Management.*"
			Set objPage = getPageObject()
			Set objLabel = objPage.WebElement(labelDesc)
			isPass = waitUntilExist(objLabel, 5)
			
		Case "COMORBIDS"
			labelDesc("class").Value = "comorbidHeaderName page-title .*"
			labelDesc("innertext").Value = "Comorbids.*"
			Set objPage = getPageObject()
			Set objLabel = objPage.WebElement(labelDesc)
			isPass = waitUntilExist(objLabel, 5)
			
		Case "PROVIDERS & TEAM"
			labelDesc("class").Value = "col-md-12 title-gradient all-title-header .*"
			labelDesc("innertext").Value = "Provider Management.*"
			Set objPage = getPageObject()
			Set objLabel = objPage.WebElement(labelDesc)
			isPass = waitUntilExist(objLabel, 5)
			
		Case "MEDICAL AUTHORIZATION"
			labelDesc("class").Value = "col-md-12 patient-info-main-header title-gradient.*"
			labelDesc("innertext").Value = "Manage Documents.*"
			Set objPage = getPageObject()
			Set objLabel = objPage.WebElement(labelDesc)
			isPass = waitUntilExist(objLabel, 5)
		
		Case Else
			Exit Function
		
	End Select
		
	If Not isPass Then
		Call WriteToLog("Fail", labelName & " - Navigation Failed")
	Else
		Call WriteToLog("Pass", labelName & " - Navigation successfull")
	End If
	
	Set objPage = Nothing
	Set objLabel = Nothing
	Set labelDesc = Nothing
End Function

'##################################################################################################################################
'Function Name       :	getValueFromPatientProfileScreen
'Purpose of Function :	To get value of a field from Patient Profile Screen(update getAutomationID function before using this function)
'Input Arguments     :	fieldName
'Output Arguments    :	None
'Example of Call     :	value = getValueFromPatientProfileScreen("Disease State")
'Author              :	Sudheer
'Date                :	1-June-2015
'##################################################################################################################################
Function getValueFromPatientProfileScreen(ByVal fieldName)
	On Error Resume Next
	Err.Clear
	
	getValueFromPatientProfileScreen = "NA"
	
	Set objPage = getPageObject()
	Set objPatientProfileTitle =  objPage.WebElement("class:=row title-gradient title-header.*","html tag:=DIV","innertext:=.*Patient Profile.*")

	If Not objPatientProfileTitle.Exist(4) Then
		Exit Function
	End If
	
	Set prfoileContainerDesc = Description.Create
	prfoileContainerDesc("micclass").Value = "WebElement"
	prfoileContainerDesc("class").Value = "profile-container.*"
	
	Set objProfileContainer = objPage.WebElement(prfoileContainerDesc)
	
	'get automation id for the label/value
	Dim aid
	aId = "Patient_Profile_Item_" & getAutomationID(fieldName) & ".*"
	
	Set valueDesc = Description.Create
	valueDesc("micclass").Value = "WebElement"
	valueDesc("class").Value  = "text-ellipsis.*"
	valueDesc("outerhtml").Value =".*data-capella-automation-id=""" & aId & """.*"
	
	Set objValue = objProfileContainer.ChildObjects(valueDesc)
	
	If Not isObject(objValue) Then
		Set valueDesc = Nothing
		Set objValue = Nothing
		Set prfoileContainerDesc = Nothing
		Set objProfileContainer = Nothing
		Set objPatientProfileTitle = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	
	If objValue.Count = 0 Then
		Set valueDesc = Nothing
		Set objValue = Nothing
		Set prfoileContainerDesc = Nothing
		Set objProfileContainer = Nothing
		Set objPatientProfileTitle = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	
	Dim reqVal
	reqVal = ""
	For i = 0 To objValue.Count - 1
		reqVal = reqVal & objValue(i).GetROProperty("innertext") & ";"
	Next
	reqVal = Mid(reqVal, 1, len(reqVal) - 1)
	getValueFromPatientProfileScreen = reqVal
	
	Set prfoileContainerDesc = Nothing
	Set objProfileContainer = Nothing
	Set objPatientProfileTitle = Nothing
	Set objPage = Nothing
	
End Function

Function getAutomationID(ByVal labelValue)
	
	Select Case UCase(labelValue)
	
		Case "CONTACT PREFERENCE"
			getAutomationID = "CONTACT_PREFERENCE"
		Case "HOME PHONE"
			getAutomationID = "HOME PHONE"
		Case "ADDRESS"
			getAutomationID = "ADDRESS"
		Case "BIRTHDATE"
			getAutomationID = "BIRTHDATE"
		Case "MARITAL STATUS"
			getAutomationID = "MARITAL_STATUS"
		Case "GENDER"
			getAutomationID = "GENDER"
		Case "LANGUAGE"
			getAutomationID = "LANGUAGE"
		Case "RACE / ETHNICITY"
			getAutomationID = "RACE_ETHNICITY"
		Case "ELIGIBILITY STATUS"
			getAutomationID = "ELIGIBILITY_STATUS"
		Case "DISEASE STATE"
			getAutomationID = "DISEASE_STATE"
		Case "PAYOR"
			getAutomationID = "PAYOR"
		Case "IMBH ELIGIBLE"
			getAutomationID = "IMBH_ELIGIBLE"
		Case "MEDICAL AUTHORIZATION"
			getAutomationID = "MedicalAuthorization"
		Case "NAME"
			getAutomationID = "label-Patient.Detail.PatientDetails.Demographics.PatientName"
		Case "DOB"
			getAutomationID = "label-Demographics.PatientDOB"
		Case Else
			getAutomationID = "NA"
		
	End Select
	
	
End Function
	  
'===========================================================================================================================================================
'Function Name       :	DateFormat
'Purpose of Function :	To get date format as mm/dd/yyy
'Input Arguments     :	dtDate: Date value which is to be converted to required format
'Output Arguments    :	Datevalue in required format as mm/dd/yyy
'Example of Call     :	Call DateFormat(ByVal dtDate)
'Author              :	Gregory
'Date                : 	16June2015
'===========================================================================================================================================================
Function DateFormat(ByVal dtDate)
If Len(DatePart("d",dtDate))<2 Then
	dtday = 0&DatePart("d",dtDate)
Else 
	dtday = DatePart("d",dtDate)
End If
If Len(DatePart("m",dtDate))<2 Then
	dtmonth = 0&DatePart("m",dtDate)
Else 
	dtmonth = DatePart("m",dtDate)
End If
DateFormat = dtmonth&"/"&dtday&"/"&DatePart("yyyy",dtDate)
End Function

'===========================================================================================================================================================
'Function Name       :	ClosePatientRecord
'Purpose of Function :	To Close patient record, giving note and Topics to contacts, then Finalizing
'Input Arguments     :	strNote: String value required to be filled for finalizing a patient
'Output Arguments    :	Boolean value: Indicating whether the patient record is closed or not
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Example of Call     :	ClosePatientRecord(strNote,strOutErrorDesc)
'Author              :	Gregory
'Date                : 	23April2015
'Modified			 :  17June2015
'===========================================================================================================================================================

Function ClosePatientRecord(ByVal strNote,strOutErrorDesc) 
	
ClosePatientRecord = False	
strOutErrorDesc = ""
Err.Clear
On Error Resume Next

'***********************
Execute "Set objParent = " &Environment("WPG_AppParent") 'Parent object
Execute "Set objTgTpPP = " &Environment("WEL_CM_TgTpTitle") 'Tag/Topics popup title
Execute "Set objFinalize = " &Environment("WB_ACMFinalize") 'Finalize Button
Execute "Set objFinPP = " &Environment("WEL_CM_CPRTitle") 'Finalize PP
Execute "Set objFinalizeOK = " &Environment("WB_ACMFiOK") 'Finalize PP OK button
Execute "Set objppOK = " &Environment("WB_ACMTT_OK") 'Tag/Topics OK button
Execute "Set objClosePatientRecordpp = "&Environment("WEL_ClosePatientRecordpp") ' ClosePatientRecord popup
Execute "Set objClosePatientRecordppOKbtn = "&Environment("WB_ClosePatientRecordppOKbtn") ' WB_ClosePatientRecord popup OK btn
Execute "Set objInvalidDatappCPat = " &Environment("WEL_InvalidDatappCPat") 'Invalid data popup
Execute "Set objInvalidDatappCpatOK = " &Environment("WB_InvalidDatappCpatOK") ''Invalid data popup ok btn

	For j=0 To 12 Step 1
		'Create object for ChangeContact button
		Set objCC = objParent.WebButton("html tag:=BUTTON","innertext:=Change Contact ","name:=Change Contact ","outerhtml:=.*openChangeContact.*","outertext:=Change Contact ","value:=Change Contact ","visible:=True","index:="&j)
		If objCC.Exist(2) Then
			ccb=ccb+1
			ccr=ccr+1
		Else
			strOutErrorDesc = "Unable to find change contact button: "&" Error returned: " & Err.Description
			Exit For
		End If
	Next
For i = 0 To ccb-1 Step 1
'Create object for ContactMethod NoteTxtArea
Set objNote = objParent.WebEdit("height:=300","html tag:=TEXTAREA","name:=WebEdit","outerhtml:=.*recap-textbox.*","type:=textarea","visible:=True","index:="&i)
'Set the note required for the contact it not already existing
	If objNote.GetROProperty("outertext") = "" Then
		objNote.Set strNote
	End If
'objNote.Set strNote
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to enter note: "&" Error returned: " & Err.Description
		Exit Function
	End If
'Create object for ContactMethod EditTopics
Set EditButton = objParent.WebButton("html tag:=BUTTON","innerhtml:=.*Edit Topics.*","innertext:=Edit Topics ","name:=Edit Topics ","index:="&i)
'Clk on edit button
EditButton.Click
	If err.number <> 0 Then
			strOutErrorDesc = "Unable to clk on Edit: "&" Error returned: " & Err.Description
			Exit Function
	End If
'Start to chk chkboxes in Tags/Topics popup
	For k = 0 To 7  Step 1
		'Create object for checkboxs in Tags/Topics popup 
		Set objTTChk = objParent.WebElement("html tag:=DIV","outerhtml:=.*AddClicked.*","visible:=True","index:="&k)
		If Trim(objTTChk.GetROProperty("class")) = "check-no" Then
			'Select ChkBoxes in Taga/Topics popup
			objTTChk.Click
				If err.number <> 0 Then
					strOutErrorDesc = "Unable to select chkbox in Tags/Topics: "&" Error returned: " & Err.Description
					Exit Function
				End If
		End If
	Next
		Set objppOK = Nothing
		Execute "Set objppOK = " &Environment("WB_ACMTT_OK") 'Tag/Topics OK button
		'Clk on OK in T/T popup
		Setting.Webpackage("ReplayType")=2
		objppOK.FireEvent "onClick"
		Setting.Webpackage("ReplayType")=1
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to clk OK in Tags/Topics: "&" Error returned: " & Err.Description
				Exit Function
			End If
Next

Call WriteToLog("PASS","Successfully set notes, Clicked Edit button, Selected required Tags Topics from popup, Clicked OK button of Tgs popup")

'Click on Finalize button
objFinalize.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to clk Finalize: "&" Error returned: " & Err.Description
   	Exit Function
End If

'check ClosePatientRecord popup exists
blnReturnValue = objClosePatientRecordpp.WaitProperty("visible", True, 30000)    'Wait upto 30 secs for ClosePatientRecord popup to be visible
If not blnReturnValue Then
	strOutErrorDesc = "Unable to find ClosePatientRecord popup: "&" Error returned: " & Err.Description
	Exit Function
End If

Err.clear
'Click on ClosePatientRecord popup OK btn
objClosePatientRecordppOKbtn.Click
If err.number <> 0 Then
	strOutErrorDesc = "Unable to clk ClosePatientRecord popup OK btn: "&" Error returned: " & Err.Description
  	Exit Function
End If
	
'FORCE CLOSEPATIENTRECORD	
	j=0
	i=0
	ccb = 0
Set objTgTpPP = Nothing
Set objFinalize = Nothing
Set objFinPP =Nothing
Set objFinalizeOK = Nothing
Set objppOK = Nothing
Set objClosePatientRecordpp = Nothing
Set objClosePatientRecordppOKbtn =Nothing
	
Execute "Set objTgTpPP = " &Environment("WEL_CM_TgTpTitle") 'Tag/Topics popup title
Execute "Set objFinalize = " &Environment("WB_ACMFinalize") 'Finalize Button
Execute "Set objFinPP = " &Environment("WEL_CM_CPRTitle") 'Finalize PP
Execute "Set objFinalizeOK = " &Environment("WB_ACMFiOK") 'Finalize PP OK button
Execute "Set objppOK = " &Environment("WB_ACMTT_OK") 'Tag/Topics OK button
Execute "Set objClosePatientRecordpp = "&Environment("WEL_ClosePatientRecordpp") ' ClosePatientRecord popup
Execute "Set objClosePatientRecordppOKbtn = "&Environment("WB_ClosePatientRecordppOKbtn") ' WB_ClosePatientRecord popup OK btn
	
If objInvalidDatappCPat.Exist(5) Then
	objInvalidDatappCpatOK.Click
	
	For j=0 To 12 Step 1
		'Create object for ChangeContact button
		Set objCC = objParent.WebButton("html tag:=BUTTON","innertext:=Change Contact ","name:=Change Contact ","outerhtml:=.*openChangeContact.*","outertext:=Change Contact ","value:=Change Contact ","visible:=True","index:="&j)
		If objCC.Exist(2) Then
			ccb=ccb+1
		Else
			strOutErrorDesc = "Unable to find change contact button: "&" Error returned: " & Err.Description
			Exit For
		End If
	Next
	
	For i = 0 To ccb-2 Step 1
		'Create object for DeleteContact checkbox
		Set objDelContChkBox = objParent.WebElement("class:=recapDeleteCheckBox.*","html tag:=DIV","innerhtml:=.*isDeleted.*","outerhtml:=.*recapDeleteCheckBox.*","visible:=True","index:="&i)
		'Select DeleteContact checkbox
		objDelContChkBox.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click DeleteContact chkbox: "&" Error returned: " & Err.Description
				Exit Function
			End If
	Next

'Create object for ContactMethod NoteTxtArea
Set objNote = objParent.WebEdit("height:=300","html tag:=TEXTAREA","name:=WebEdit","outerhtml:=.*recap-textbox.*","type:=textarea","visible:=True","index:="&i)
'Set the note required for the contact
objNote.Set strNote
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to enter note: "&" Error returned: " & Err.Description
		Exit Function
	End If
'Create object for ContactMethod EditTopics
Set EditButton = objParent.WebButton("html tag:=BUTTON","innerhtml:=.*Edit Topics.*","innertext:=Edit Topics ","name:=Edit Topics ","index:="&i)
'Clk on edit button
EditButton.Click
	If err.number <> 0 Then
			strOutErrorDesc = "Unable to clk on Edit: "&" Error returned: " & Err.Description
			Exit Function
	End If
	wait 1
	'Start to chk chkboxes in Tags/Topics popup
	For k = 0 To 10  Step 1
		'Create object for checkboxs in Tags/Topics popup 
		Set objTTChk = objParent.WebElement("html tag:=DIV","outerhtml:=.*AddClicked.*","visible:=True","index:="&k)
		If Trim(objTTChk.GetROProperty("class")) = "check-no" Then
			'Select ChkBoxes in Taga/Topics popup
			objTTChk.Click
				If err.number <> 0 Then
					strOutErrorDesc = "Unable to select chkbox in Tags/Topics: "&" Error returned: " & Err.Description
					Exit Function
				End If
		End If
	Next
		Set objppOK = Nothing
		Execute "Set objppOK = " &Environment("WB_ACMTT_OK") 'Tag/Topics OK button
		'Clk on OK in T/T popup
		Setting.Webpackage("ReplayType")=2
		objppOK.FireEvent "onClick"
		Setting.Webpackage("ReplayType")=1
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to clk OK in Tags/Topics: "&" Error returned: " & Err.Description
				Exit Function
			End If

'Click on Finalize button
objFinalize.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to clk Finalize: "&" Error returned: " & Err.Description
		Exit Function
	End If

Set objInvalidDatappCPat = Nothing
Set objInvalidDatappCpatOK = Nothing

Execute "Set objInvalidDatappCPat = " &Environment("WEL_InvalidDatappCPat") 
Execute "Set objInvalidDatappCpatOK = " &Environment("WB_InvalidDatappCpatOK") 

'check ClosePatientRecord popup exists
blnReturnValue = objClosePatientRecordpp.WaitProperty("visible", True, 30000)    'Wait upto 30 secs for ClosePatientRecord popup to be visible
If not blnReturnValue Then
	strOutErrorDesc = "Unable to find ClosePatientRecord popup: "&" Error returned: " & Err.Description
	Exit Function
End If

Err.clear
'Click on ClosePatientRecord popup OK btn
objClosePatientRecordppOKbtn.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to clk ClosePatientRecord popup OK btn: "&" Error returned: " & Err.Description
		Exit Function
	End If
	
	
End If
'**********************

''Create objects required ClosingPatientRecord
'Execute "Set objParent = " &Environment("WPG_AppParent") 'Parent object
'Execute "Set objTgTpPP = " &Environment("WEL_CM_TgTpTitle") 'Tag/Topics popup title
'Execute "Set objFinalize = " &Environment("WB_ACMFinalize") 'Finalize Button
'Execute "Set objFinPP = " &Environment("WEL_CM_CPRTitle") 'Finalize PP
'Execute "Set objFinalizeOK = " &Environment("WB_ACMFiOK") 'Finalize PP OK button
'Execute "Set objppOK = " &Environment("WB_ACMTT_OK") 'Tag/Topics OK button
'Execute "Set objClosePatientRecordpp = "&Environment("WEL_ClosePatientRecordpp") ' ClosePatientRecord popup
'Execute "Set objClosePatientRecordppOKbtn = "&Environment("WB_ClosePatientRecordppOKbtn") ' WB_ClosePatientRecord popup OK btn
'
'	For j=0 To 12 Step 1
'		'Create object for ChangeContact button
'		Set objCC = objParent.WebButton("html tag:=BUTTON","innertext:=Change Contact ","name:=Change Contact ","outerhtml:=.*openChangeContact.*","outertext:=Change Contact ","value:=Change Contact ","visible:=True","index:="&j)
'		If objCC.Exist(2) Then
'			ccb=ccb+1
'		Else
'			strOutErrorDesc = "Unable to find change contact button: "&" Error returned: " & Err.Description
'			Exit For
'		End If
'	Next
'For i = 0 To ccb-1 Step 1
''Create object for ContactMethod NoteTxtArea
'Set objNote = objParent.WebEdit("height:=300","html tag:=TEXTAREA","name:=WebEdit","outerhtml:=.*recap-textbox.*","type:=textarea","visible:=True","index:="&i)
''Set the note required for the contact it not already existing
'	If objNote.GetROProperty("outertext") = "" Then
'		objNote.Set strNote
'	End If
''objNote.Set strNote
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to enter note: "&" Error returned: " & Err.Description
'		Exit Function
'	End If
''Create object for ContactMethod EditTopics
'Set EditButton = objParent.WebButton("html tag:=BUTTON","innerhtml:=.*Edit Topics.*","innertext:=Edit Topics ","name:=Edit Topics ","index:="&i)
''Clk on edit button
'EditButton.Click
'	If err.number <> 0 Then
'			strOutErrorDesc = "Unable to clk on Edit: "&" Error returned: " & Err.Description
'			Exit Function
'	End If
''Start to chk chkboxes in Tags/Topics popup
'	For k = 0 To 7  Step 1
'		'Create object for checkboxs in Tags/Topics popup 
'		Set objTTChk = objParent.WebElement("html tag:=DIV","outerhtml:=.*AddClicked.*","visible:=True","index:="&k)
'		If Trim(objTTChk.GetROProperty("class")) = "check-no" Then
'			'Select ChkBoxes in Taga/Topics popup
'			objTTChk.Click
'				If err.number <> 0 Then
'					strOutErrorDesc = "Unable to select chkbox in Tags/Topics: "&" Error returned: " & Err.Description
'					Exit Function
'				End If
'		End If
'	Next
'		Set objppOK = Nothing
'		Execute "Set objppOK = " &Environment("WB_ACMTT_OK") 'Tag/Topics OK button
'		'Clk on OK in T/T popup
'		Setting.Webpackage("ReplayType")=2
'		objppOK.FireEvent "onClick"
'		Setting.Webpackage("ReplayType")=1
'			If err.number <> 0 Then
'				strOutErrorDesc = "Unable to clk OK in Tags/Topics: "&" Error returned: " & Err.Description
'				Exit Function
'			End If
'Next
''Click on Finalize button
'objFinalize.Click
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to clk Finalize: "&" Error returned: " & Err.Description
'		Exit Function
'	End If
'
''check ClosePatientRecord popup exists
'blnReturnValue = objClosePatientRecordpp.WaitProperty("visible", True, 30000)    'Wait upto 30 secs for ClosePatientRecord popup to be visible
'If not blnReturnValue Then
'	strOutErrorDesc = "Unable to find ClosePatientRecord popup: "&" Error returned: " & Err.Description
'	Exit Function
'End If
'
'Err.clear
''Click on ClosePatientRecord popup OK btn
'objClosePatientRecordppOKbtn.Click
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to clk ClosePatientRecord popup OK btn: "&" Error returned: " & Err.Description
'		Exit Function
'	End If

ClosePatientRecord = True

End Function
'===========================================================================================================================================================
'Function Name       :	CacheClear
'===========================================================================================================================================================
	Function CacheClear(ByVal strCacheClear)
		On Error Resume Next
		Err.Clear
		If Trim(UCase(strCacheClear)) = "YES" Then
			Dim objShell
			Set objShell = CreateObject("wscript.shell")
			objShell.run "RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 4351"
			Set objShell = Nothing
		End If
		CacheClear = True
	End Function
	

'===========================================================================================================================================================
'Function Name       :	SelectPatientFromPatientList
'Purpose of Function :	To select required patient from MyPatient List
'Input Arguments     :	strUser: String value representing required user (eg. VHN, PHM etc.)
'					 :	strPateintName: String value representing required patient name to be selected from MyPatient List
'Output Arguments    :	array: giving Sort count and patient Row number after sorting
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Example of Call     :	SelectPatientFromPatientList(ByVal strUser, ByVal strPateintName)
'Author              :	Gregory
'Date                : 	08 July 2015
'Date Modified		 :	05August2015
'===========================================================================================================================================================
Function SelectPatientFromPatientList(ByVal strUser, ByVal strPatientName)

	On Error Resume Next
	Err.Clear	
	SelectPatientFromPatientList = False
	
	User = Ucase(strUser)
	
	Execute "Set objPageMyPatientList ="&Environment("WPG_AppParent")	'page object
	Execute "Set objMyPatientsMajorTabPL ="&Environment("WL_MyPatientsMajorTab") 'MyPatients tab
	Execute "Set objAllMyPatients ="&Environment("WB_AllMyPatients") 'AllMyPatients button
	Execute "Set objPatientSearchDD ="&Environment("WB_PatientSearchDD") 'PatientSearch dropdown
	Execute "Set objPatientSearchTxtBx ="&Environment("WE_PatientSearchTxtBx") 'MyRoster patient search
	Execute "Set objPatientSearchImage ="&Environment("WEL_PatientSearchImage") 'Patient search image
	Execute "Set objPatientSearchGridCB ="&Environment("WEL_PatientSearchGridCB") 'Patient List grid
		
	'click on My Patients Tab
	Call clickOnMainMenu("My Patients")
	Wait 10'2 app performance
	
	Call waitTillLoads("Loading...")
	Wait 2
	
	blnAllMyPatientsClicked = ClickButton("All My Patients",objAllMyPatients,strOutErrorDesc)
	If not blnAllMyPatientsClicked Then
		strOutErrorDesc = "Unable to click 'AllMyPatients' button: "&strOutErrorDesc
		Exit Function
	End If
	Wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2
	
	blnselectComboBoxItem = selectComboBoxItem(objPatientSearchDD, "Name")
	If Not blnselectComboBoxItem Then
		strOutErrorDesc = "Unable to select required value from patient search dropdown: "&strOutErrorDesc
		Exit Function
	End If
	
	'Set required patient name for SearchMyRoster txtbox
	objPatientSearchTxtBx.Set strPatientName
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set required name for SearchMyRoster txtbox: "& Err.Description
		Exit Function
	End If
	Wait 1
	
	'Clk on Patient Search Image
	objPatientSearchImage.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click Patient Search Image: "& Err.Description
		Exit Function
	End If
	wait 2
	
	'Click check box for required patient	
	Execute "Set objCBforPatient_UnChecked = "&Environment("WE_CBforPatient_UnChecked")	
	Err.Clear
	objCBforPatient_UnChecked.Click
	Err.Clear
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Patient check box: "& Err.Description
		Exit Function
	End If
	
	'Sometimes after clicking also checkbox won't get checked (and no error is captured).
	'So first check 'checked' check box is existing or not. If not existing, then check the check box again.
	Execute "Set objCBforPatient_Checked = "&Environment("WE_CBforPatient_Checked")
	If not objCBforPatient_Checked.Exist(2) Then
		Execute "Set objCBforPatient_UnChecked = Nothing"
		Execute "Set objCBforPatient_UnChecked = "&Environment("WE_CBforPatient_UnChecked")
		Err.Clear
		objCBforPatient_UnChecked.Click		
	End If
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Patient check box: "& Err.Description
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Clicked check box for patient in patient list")

	Execute "Set objCBforPatient_UnChecked = Nothing"
	Execute "Set objCBforPatient_Checked = Nothing"
	Wait 1

'	'Select required patient from PatientList grid
'	Set objPatientSearchGridCB=Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("class:=check-no","html tag:=DIV","outerhtml:=.*check-no.*","visible:=True")
'	Setting.WebPackage("ReplayType") = 2
'	objPatientSearchGridCB.FireEvent "onClick"
'	If err.number <> 0 Then
'		strOutErrorDesc = "Unable to mark required patient from PatientList grid: "& Err.Description
'		Exit Function
'	End If
'	wait 1	
	
'	'Set column appropriate number for specific users
'	Select Case User
'		Case "VHN"
'			intPatientListColCount = 4
'			intPatientListNameCol = 3
'		Case "PHM"
'			intPatientListColCount = 5
'			intPatientListNameCol = 2		
'	End Select
	
'	'Create object for MyPatientList Table (left part), which includes patient names
'	Set objPatientListTable = objPageMyPatientList.WebTable("class:=k-selectable","html tag:=TABLE","cols:="&intPatientListColCount,"visible:=True","name:=icon_vh_priority_high")
'	'Get the row of required patient
'	intPatientRow = objPatientListTable.GetRowWithCellText(Trim(strPatientName))
'	Setting.WebPackage("ReplayType") = 2
'	objPatientListTable.ChildItem(intPatientRow,intPatientListNameCol,"WebElement",0).FireEvent "onClick"
'	If Err.number <> 0 Then
'		Setting.WebPackage("ReplayType") = 1
'		strOutErrorDesc =  "Unable to click on patient's name: "&Err.Description
'		Exit Function	
'	End If

	'Click on patient name
	Set objRequiredPatient = getPageObject().WebElement("html tag:=TD","outertext:=.*"&Trim(strPatientName)&".*","visible:=True")
	objRequiredPatient.highlight
	Err.Clear
	objRequiredPatient.click
	If Err.number <> 0 Then
		strOutErrorDesc =  "Unable to click on patient's name: "&Err.Description
		Exit Function	
	End If
	Call WriteToLog("Pass", "Clicked required patient name in patient list")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
		
	Set objPageMyPatientList = Nothing
	Set objMyPatientsMajorTabPL = Nothing
	Set objAllMyPatients = Nothing
	Set objPatientSearchDD = Nothing
	Set objPatientSearchTxtBx = Nothing
	Set objPatientSearchImage = Nothing
	Set objPatientListTable = Nothing
	Set objPatientSearchGridCB = Nothing
	
	SelectPatientFromPatientList = True
	
		
End Function

'===========================================================================================================================================================
'Function Name       :	AddMedication
'Purpose of Function :	To Required medications for a patient
'Input Arguments     :	strLabelName: String value representing Label(medicine) value which is required for the patient
'					 :	dtWrittenDate: Date value specifying written date for medication
'					 :	dtFilledDate: Date value specifying filled date for medication
'					 :	strFrequencyValue: String value specifying required frequency for new medication
'Output Arguments    :	String value representing Rx number for newly added Medication
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Example of Call     :	strAddMedication = AddMedication(strLabel, dtWrittenDt, dtFilledDt, strFrequency, strOutErrorDesc)
'Author				 :  Gregory
'===========================================================================================================================================================

Function AddMedication(ByVal strLabelName,ByVal dtWrittenDate,ByVal dtFilledDate,ByVal strFrequencyValue, strOutErrorDesc)
	   
	On Error Resume Next
	AddMedication = ""
	strOutErrorDesc = ""
	Err.Clear
	
	Execute "Set objPageMed = "&Environment("WPG_AppParent") 'PageObject	
	Execute "Set objMedAddBtn = "&Environment("WEL_MedAddBtn") ''Medications Add Button
	Execute "Set objRxNumberTxt = "&Environment("WE_RxNumberTxt") 'RxNumber
	Execute "Set objESAcb = "&Environment("WEL_ESAcb") 'ESA chk box
	Execute "Set objLbNaDD = "&Environment("WEL_LbNaDD") 'LabelNameDD
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	
	If dtWrittenDate = "" OR lcase(dtWrittenDate) = "na" Then
		dtWrittenDate = Date-1
	End If
	If dtFilledDate = "" OR lcase(dtFilledDate) = "na" Then
		dtFilledDate = Date-1
	End If
	
	'Close 'Some Date May Be Out of Date' msgbox
	Execute "Set objSDMBOFDpptleOK = "&Environment("WB_SDMBOFDpptleOK")	
	If objSDMBOFDpptleOK.Exist(3) Then
		Err.Clear
		objSDMBOFDpptleOK.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'Some Data May Be Out of Date' message box OK button." &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked 'Some Data May Be Out of Date' message box OK button")			
	End If
	Execute "Set objSDMBOFDpptleOK = Nothing"
	
	Wait 1
	Call waitTillLoads("Loading...")

	'Close 'Disclaimer' msgbox
	Execute "Set objDisclaimerOK = "&Environment("WB_DisclaimerOK")	
	If objDisclaimerOK.Exist(3) Then
		Err.Clear
		objDisclaimerOK.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'Disclaimer' message box OK button." &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked 'Disclaimer' message box OK button")			
	End If
	Execute "Set objDisclaimerOK = Nothing"
	
	Wait 1
	Call waitTillLoads("Loading...")
		
	'Clk Medications Add button
	Execute "Set objMedAddBtn = "&Environment("WEL_MedAddBtn") ''Medications Add Button
	objMedAddBtn.highlight
	Err.Clear
	blnClickAdd = ClickButton("Add",objMedAddBtn,strOutErrorDesc)
	If not blnClickAdd Then
		strOutErrorDesc = "Unable to click Add button for adding new medication"
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Get the RxNumber for new medication
	Execute "Set objRxNumberTxt = "&Environment("WE_RxNumberTxt") 'RxNumber
	objRxNumberTxt.highlight
	strRxNumber = Trim(objRxNumberTxt.GetROProperty("value"))
	If strRxNumber = "" Then
		strOutErrorDesc = "Unable to retrieve RxNumber for added medication"
		Exit Function
	End If
	Call WriteToLog("Pass","Retrieved RxNumber for new medication")
	wait 0,250
	
	'Chk on ESA chkbox
	Execute "Set objESAcb = "&Environment("WEL_ESAcb") 'ESA chk box
	objESAcb.highlight
	Err.clear	
	objESAcb.Click
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to click ESA checkbox "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Checked ESA checkbok")
	Wait 0,500
		
	'Select Label	
	Execute "Set objLbNaDD = "&Environment("WEL_LbNaDD") 'LabelNameDD
	objLbNaDD.highlight
	blnLabel = selectComboBoxItem(objLbNaDD, strLabelName)
	If Not blnLabel Then
		strOutErrorDesc = "Unable to select label for medication"
		Exit Function
	End If
	Call WriteToLog("Pass","Selected '"&strLabelName&"' label for medication")
	wait 0,500
	
	'Value for Medications WrittenDate
	Execute "Set objWrittenDate = "&Environment("WE_WrittenDate") 'Medications WrittenDate
	Err.clear
	objWrittenDate.Set dtWrittenDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set written date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Written date is set as '"&dtWrittenDate&"' for medication")
	Wait 0,500
	
	'Value for Medications FilledDate 
	Execute "Set objFilledDate = "&Environment("WE_FilledDate") 'Medications FilledDate
	Err.clear
	objFilledDate.Set dtFilledDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set filled date "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Filled date is set as '"&dtFilledDate&"' for medication")
	Wait 0,500
	
	'Select required frequency
	Execute "Set objMedFreq = "&Environment("WEL_MedFreq") 'Medications Frequency
	objMedFreq.highlight
	blnFreqSelect = selectComboBoxItem(objMedFreq, strFrequencyValue)
	If not blnFreqSelect Then	
	   	strOutErrorDesc = "Unable to select frequency value from dropdown"
		Exit Function
	End If 
	Call WriteToLog("Pass","'"&strFrequencyValue&"' frequency value is selected for new medication")	
	Wait 0,500
	
	'Save new Medication
	Execute "Set objMedSavbtn = "&Environment("WEL_MedSave") 'Medications Save Btn
	blnClickSave = ClickButton("Save",objMedSavbtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for medication "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass","Saved newly added medication")
	
	AddMedication = strRxNumber
	
	Wait 2
	Dim wt : wt = 0
	Do While objPageMed.WebElement("class:=please-wait-style loading.*","html tag:=SPAN","outertext:=Processing.*","visible:=True").Exist(1)
		Wait 0,500
		wt = wt + 1
		If wt = 200 Then
			Exit Do
		End If
	Loop
	Wait 0,250
	
	Execute "Set objPageMed = Nothing"
	Execute "Set objMedAddBtn = Nothing"
	Execute "Set objRxNumberTxt = Nothing"
	Execute "Set objESAcb = Nothing"
	Execute "Set objLbNaDD = Nothing"
	Execute "Set objWrittenDate = Nothing"
	Execute "Set objFilledDate = Nothing"
	Execute "Set objMedFreq = Nothing"
	Execute "Set objMedSavbtn = Nothing"
	 
End Function

'=============================================================================================================================================================
'Function Name       :	AddAllergyDeletingOld
'Purpose of Function :	To add the required Contact Method for any patient, from any screen, by any user
'Input Arguments     :	strAllergy: String value representing the new Allergy type which is to be added for a patient after the deletion of previous allergies
'Output Arguments    :	Boolean value: Indicating whether the new Allergy type is added,deleted old ones or not
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Pre-Requirement	 :  User should be in Medications Management > Review screen
'Example of Call     :	AddAllergyDeletingOld(strAllergy, strOutErrorDesc)
''Author			 :  Gregory
'=============================================================================================================================================================

Function AddAllergyDeletingOld(ByVal strAllergy, strOutErrorDesc)

	'Creating objects required for AddAllergy function
	'DiscLaimer popup OK button
	Execute "Set objDisOK = "&Environment("WB_DisclaimerOK")
	'Medications Management screen title
	Execute "Set objMedMagtitle = "&Environment("WEL_MedMagTitle")
	'SomeDataMayBeOutOfDate popup title
	Execute "Set SDMBOFDpptle = "&Environment("WEL_SDMBOFDpptle")
	'SomeDataMayBeOutOfDate popup title OK button
	Execute "Set SDMBOFDpptleOK = "&Environment("WB_SDMBOFDpptleOK")
	'Add Allergy button
	Execute "Set objAddAllerg = " &Environment("WB_AddAllerg")
	'AddAllergyTxtBox
	Execute "Set objAlrgyNamTxtBx = " &Environment("WEL_AlrgyNamTxtBx")
	'AddAllergyEditBox
	Execute "Set objAlrgyNamEdBx = " &Environment("WE_AlrgyNamEdBx") 
	'AddAllergy SaveBtn
	Execute "Set objAlgrySavebtn = " &Environment("WI_AlgrySavebtn") 
	'SaveAllergy popup
	Execute "Set objSavAlgryPP = " &Environment("WEL_SavAlgryPP") 
	'Allergy delete icon
	Execute "Set objDelAgy = " &Environment("WI_DelAgy") 
	'Delete Allergy Popup
	Execute "Set objDelAgyPP = " &Environment("WEL_DelAgyPP") 
	'Delete Allergy Popup OK
	Execute "Set objDelAgyppOK = " &Environment("WB_DelAgyppOK")
	'Save Allergy Popup OK
	Execute "Set objSavAgyppOK = " &Environment("WB_SavAgyppOK")
	'CahngesSaved popup
	Execute "Set objChgSvdPP = " &Environment("WEL_ChgSvdPP")
	'ChangesSavedOK
	Execute "Set objChSvPPOK = " &Environment("WB_ChSvPPOK")
	'AllergyTable 
	Execute "Set objAgyoldTbl = " &Environment("WT_AgyoldTbl")
	'AllergyTableExistingValue
	Execute "Set objPreAlgy = " &Environment("WEL_PreAlgy")
	
	AddAllergyDeletingOld = False
	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
		
	'Clk SomeDataMayBeOutOfDate popup OK button if it exists
	If SDMBOFDpptle.Exist(5) Then
		Err.Clear
		SDMBOFDpptleOK.Click
		If err.number <> 0 Then
			strOutErrorDesc = "SomeDataMayBeOutOfDate popup OK : "&" Error returned: " & Err.Description
			Exit Function
		End If
	End If
	
	'Clk Disclaimer popup OK button if it exists
	If objDisOK.Exist(3) Then
		Err.Clear
		objDisOK.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Disclaimer popup OK : "&" Error returned: " & Err.Description
			Exit Function
		End If
	End If
	
	'Check whether user landed on Medications Management screen
	If not objMedMagtitle.Exist(3) Then
		strOutErrorDesc = "Medications Management Screen is not visible"
		Exit Function
	End If

	'Delete existing Allergies
	Do While objPreAlgy.Exist(2)

		For i = 1 To objAgyoldTbl.RowCount Step 1
			'Click on Allergy delete icon after refreshing DelAlgy object
			objDelAgy.RefreshObject
			Err.Clear
			objDelAgy.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Delete Allergy Icon : "&" Error returned: " & Err.Description
				Exit Function
			End If
'			Check whether DeleteAllergy popup exists or not
			If not objDelAgyPP.Exist(3) Then
				strOutErrorDesc = "Delete Allerygy popup is not displayed"
		  		Exit Function
			End If
'			Clk on DeleteAllergy popup OK after refreshing DelAgyppOK object		
			objDelAgyppOK.RefreshObject
			Err.Clear
			objDelAgyppOK.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Delete Allergy popup OK button : "&" Error returned: " & Err.Description
				Exit Function
			End If
			wait(1)
			
		Next
	'Refresh PreAlgy object	
	objPreAlgy.RefreshObject
	loop

	'Clk on AddAllergy btn
	Err.Clear
	objAddAllerg.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click Add Allergy button : "&" Error returned: " & Err.Description
			Exit Function
		End If
	
	'Clk on AddAllergy TxtBox
	Err.Clear
	objAlrgyNamTxtBx.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click Add Allergy Textbox : "&" Error returned: " & Err.Description
			Exit Function
		End If
	
	'Set Allergy value for AddAllergyEditBox
	Err.Clear
	objAlrgyNamEdBx.Set strAllergy
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click set value for Add Allergy : "&" Error returned: " & Err.Description
			Exit Function
		End If
	
	'Clk on AllergySaveBtn
	Err.Clear
	objAlgrySavebtn.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click Add Allergy Save button : "&" Error returned: " & Err.Description
			Exit Function
		End If
	
	'Check whether SaveAllergy popup exists or not
		If not objSavAlgryPP.Exist(3) Then
			strOutErrorDesc = "Save Allerygy popup is not displayed"
			Exit Function
		End If
	
	'Clk on SaveAllergy popup OK
	Err.Clear
	objSavAgyppOK.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click Add Allergy Save popup OK button : "&" Error returned: " & Err.Description
			Exit Function
		End If
	
	'Check whether ChangesSaved popup exists or not
	If not objChgSvdPP.Exist(3) Then
		strOutErrorDesc = "ChangesSaved popup is not displayed"
		Exit Function
	End If
	
	'Clk on ChangesSavedOK
	Err.Clear
	objChSvPPOK.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click ChangesSaved OK button : "&" Error returned: " & Err.Description
			Exit Function
		End If
	
	AddAllergyDeletingOld = True

End Function

'===========================================================================================================================================================
'Function Name       :	ActionItemsPatientMouseoverMsg
'Purpose of Function :	To retrieve mouse over message for required patient present in Action Items list
'Input Arguments     :	strPatientName: String value representing patient's fullname (eg: Reed, Caroline) or patient's lastname (eg:Reed)
'Output Arguments    :	ActionItemsPatientMouseoverMsg: Array value, containing mouseover msg
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Example of Call     :	ActionItemsPatientMouseoverMsg("Medlin", strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	12-May-2015
'Modified (Gregory)  :	27-May-2015
'===========================================================================================================================================================

Function ActionItemsPatientMouseoverMsg(ByVal strName, strOutErrorDesc)

	'Create objects required
	'PageObject
	Execute "Set objPage = "&Environment("WPG_AppParent")
	'Object for Dashboard
	Execute "Set objDash = "&Environment("WL_DashBoard")
	'Object for ActionItems list
	Execute "Set objAcItem = "&Environment("WEL_ActionItems")
	'objAcItem.highlight
	
	ActionItemsPatientMouseoverMsg = False
	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
	
	'clk on My Dashboard
	objDash.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click MyDashboard: "&" Error returned: " & Err.Description
       	Call WriteToLog("Fail","Expected Result: Should be able to click MyDashboard.  Actual Result: "&strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("PASS","Clicked MyDashboard")
   	End If
	
	'Sync till Action Item list is visible
	blnReturnValue = objAcItem.WaitProperty("visible", True, 30000)    'Wait upto 30 secs for ActionItem to be visible
    If not blnReturnValue Then
        strOutErrorDesc = "Action Item is not visible"
       	Call WriteToLog("Fail","Expected Result: Should be able to find ActionItems.  Actual Result: "&strOutErrorDesc)
		Exit Function
	Else
		Call WriteToLog("PASS","ActionItem list is available")
   	End If
	    
	'Setting the replay type for mouseover
	Setting.WebPackage("ReplayType") = 2 
	RgEx = ".*"
	
	'getting name
'	strName = Left(strName,Instr(1,strName,",",1)-1)   

	'setting innerhtml value as required patient name
	strinnerhtml = RgEx&Trim(strName)&RgEx
	
	'Object for required patient name in action item
	Set objNameItem = objPage.WebElement("html tag:=SPAN","innerhtml:="&strinnerhtml,"outerhtml:=.*data-capella-automation-id=""Action_Items_PatientName.*","visible:=True")

	'getting mouseover value
	Err.Clear
	objNameItem.FireEvent "onmouseover"
	wait 2	
	strmoVal = objPage.WebElement("class:=popover-content ng-binding","html tag:=DIV").Object.outertext
	Setting.WebPackage("ReplayType") = 1
	
	strOutErrorDesc =""	
	If strmoVal = "" Then
		strOutErrorDesc = "No mousehover message"
		Exit Function
	End If
	
	'Storing tooltip value into an array
	arrSpec = split(strmoVal,vbnewline,-1,1) 
	
	'Function return array
	ActionItemsPatientMouseoverMsg = arrSpec

End Function

'===========================================================================================================================================================
'Function Name       :	AddPatientCarePlan
'Purpose of Function :	To add new Care Plan for patient with required data
'Input Arguments     :	strRequiredCarePlan: String value representing CarePlanTopic required for the patient
'					 :	strRequiredStatus: String value representing Status for required CarePlan
'					 :	strReqdCarePlanName: String value representing CarePlanName
'					 :	strReqdBehavioralPlan: String value representing BhehavioralPlan
'					 :	strSelfManagement: String value representing SelfManagement value
'					 :	strConfidenceLevel: String value representing ConfidenceLevel (yet to be implemented)
'					 :	strImportance: String value representing Importance  (yet to be implemented)
'Output Arguments    :	Boolean value: representing CarePlan is added for patient or not
'					 :  strOutErrorDesc:String value which contains detail error message
'Pre-requisite		 :  One Patient should be selected
'Example of Call     :	Call AddPatientCarePlan(strRequiredCarePlan,strRequiredStatus,strReqdCarePlanName,strReqdBehavioralPlan,strSelfManagement,strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	14-May-2015
'===========================================================================================================================================================

Function AddPatientCarePlan(ByVal strReqdCaPln, ByVal strReqdStatus,ByVal strCarePlanName,ByVal strBehavioralPlan,ByVal strSelfMang,strOutErrorDesc)
	
	'Create objects required
	Execute "Set objPage ="&Environment("WPG_AppParent")
	
	'PatientCarePlan tab
	Execute "Set objPatCaPln ="&Environment("WL_PatCaPlnTab")
	'Add CP
	Execute "Set objAddCPbtn ="&Environment("WEL_PatCaPlnAdd")
	'CarePlanTopicDD
	Execute "Set objCaPlnTpc ="&Environment("WB_PatCaPlnTopic")
	'Due Date
	Execute "Set objDueDate ="&Environment("WB_PatCaPlnDueDate")
	'Today
	Execute "Set objToday ="&Environment("WB_PatCaPlnTdy")
	'StatusDD
	Execute "Set objStatus ="&Environment("WB_PatCaPlnStatus")
	'ClinicalRelevanceDD
	Execute "Set objCliRelvn ="&Environment("WB_PatCaPlnClinicalRelvnDD")
	'Choose 'ClinicalRelevance
	Execute "Set objCliRelvnReqd ="&Environment("WEL_PatCaPlnClinicalRelvnReqd")
	'CarePlanName
	Execute "Set objCPname ="&Environment("WE_PatCaPlnName")	
	'BehavioralPlan 
	Execute "Set objBepln ="&Environment("WE_PatCaPlnBePln")	
	'SelfManagement 
	Execute "Set objSelManTB ="&Environment("WE_PatCaPlnSlfMng")		
	'Save CP
	Execute "Set objSaveCPbtn ="&Environment("WE_PatCaPlnSave")

	Err.Clear
	On Error Resume Next
	strOutErrorDesc = ""
	AddPatientCarePlan = False	
			
	'Clk on PatientCarePlan tab
	Err.Clear
	objPatCaPln.click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click PatientCarePlan tab : "&" Error returned: " & Err.Description
			Exit Function
		End If
	
	Wait 3
	
	If objAddCPbtn.Exist(3) Then
	'Clk on Add button for creating new Care Plan
	Err.Clear
	objAddCPbtn.click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to click Add care plan button : "&" Error returned: " & Err.Description
			Exit Function
		End If
	End If
	
		'Select required CarePlanTopic from dropdown
		Call selectComboBoxItem(objCaPlnTpc,strReqdCaPln)
		
		Wait 1
		
		'Clk on DueDate calendar icon
		Set objPage = getPageObject()
		Err.Clear
		objDueDate.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Duedate calendar icon : "&" Error returned: " & Err.Description
				Exit Function
			End If
	
		'Clk on Today button in calendar
		Err.Clear
		objToday.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Today button in due date calendar : "&" Error returned: " & Err.Description
				Exit Function
			End If	
		'Select required status from dropdown
		Call selectComboBoxItem(objStatus,strReqdStatus)
		
		Wait 1
		
		'Clk on Clinical Relevance dropdown
		Err.Clear
		Set objPage = getPageObject()
		objCliRelvn.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Clinical Relevance Dropdown: "&" Error returned: " & Err.Description
				Exit Function
			End If
				
		'Choose ClinicalRelevance
		Err.Clear
		objCliRelvnReqd.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click required value for Clinical Relevance from Dropdown: "&" Error returned: " & Err.Description
				Exit Function
			End If
		
		'Set required Care Paln Name
		Err.Clear
		objCPname.Set strCarePlanName
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to set required Care Plan "&" Error returned: " & Err.Description
				Exit Function
			End If
		
		'Set required Behavioral Plan
		Err.Clear		
		objBepln.Set strBehavioralPlan
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to set required Behavioral Plan "&" Error returned: " & Err.Description
				Exit Function
			End If
		
		'Select Barriers
		For i=0 to 3 Step 2
			Set objBarriers = objPage.WebElement("class:=check-no","html tag:=DIV","innerhtml:=","visible:=True","index:="&i)
			Err.Clear
			objBarriers.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to click Barriers check box: "&" Error returned: " & Err.Description
				Exit Function
			End If
		Next
		
		'Select values for ChangeOptionQuestions
		For i=1 to 9 Step 4
			Set objChOpQues = objPage.WebElement("html tag:=DIV","outerhtml:=.*ChangeOptionOnQuestion.*","visible:=True","index:="&i)
			Err.Clear
			objChOpQues.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to ChangeOptionQuestions radio btns: "&" Error returned: " & Err.Description
				Exit Function
			End If
		Next
		
		'Set required value for SelfManagement 
		Err.Clear
		objSelManTB.Set strSelfMang
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to set required self management value "&" Error returned: " & Err.Description
				Exit Function
			End If
		Wait 2
		'Clk on Save btn for care plan
		Err.Clear
		objSaveCPbtn.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to Click Save care plan button "&" Error returned: " & Err.Description
				Exit Function
			End If
		
	AddPatientCarePlan = True
	
End Function

Function validateCalenderLastSevenDays(ByVal objCalendar)
	
	Set objPage = getPageObject()
	objPage.highlight

	'Click on calender
	'Set objCalendar = Browser("DaVita VillageHealth Capella").Page("DaVita VillageHealth Capella").WebButton("Cal2")
	objCalendar.Click

	Set objCalendar = Nothing
	
	'get complete calender object
	Set calOuterDesc = Description.Create
	calOuterDesc("micclass").Value = "WebElement"
	calOuterDesc("class").Value = "dropdown-menu ng-pristine ng-valid ng-valid-date-disabled.*"
	calOuterDesc("html tag").Value = "UL"
	calOuterDesc("outerhtml").Value = ".*display: block;"" ng-model=""date"".*"		'<ul class=""dropdown-menu ng-pristine ng-valid ng-valid-date-disabled"" style=""left: 0px; top: 24px; display: block;"" display: block;" ng-model="date"
	Set objOuterCal = objPage.WebElement(calOuterDesc)
	'objOuterCal.highlight
	'get current date on calender
	Set objCurrentMonth = objOuterCal.WebButton("class:=btn btn-default btn-sm","visible:=True", "html id:=datepicker.*")
	calMonYear = objCurrentMonth.getROProperty("innertext")
	calMonYear = trim(calMonYear)
	calMonth = Split(calMonYear," ")(0)
	calYear = Split(calMonYear," ")(1)

	Dim calMonthValue : calMonthValue = getNumericValueOfMonth(calMonth)
	Dim calYearValue : calYearValue = CInt(calYear)
	
	Dim currentDay :  currentDay = Day(now)
	Dim currentMonth : currentMonth = Month(now)
	Dim currentYear : currentYear = year(now)
	
	If calYearValue = currentYear and calMonthValue = currentMonth Then
		Print "Calendar is in correct Month and Year"
	End If
	
	Set activeDayDesc = Description.Create
	activeDayDesc("micclass").Value = "WebButton"
	activeDayDesc("class").Value = "btn btn-default btn-sm active"
	activeDayDesc("html tag").Value = "BUTTON"
	
	Set objActiveDay = objOuterCal.WebButton(activeDayDesc)
	objActiveDay.highlight
	calDay = objActiveDay.getROProperty("innertext")
	calDay = CInt(calDay)
	If calDay = currentDay Then
		Print "Calendar is in current Day"
	End If
	
	Set activeDayDesc = Nothing
	Set objActiveDay = Nothing
	
	Dim reqDay : reqDay = calDay
	'validate last 7 days from active day are enabled
	For i = 7 To 1 Step -1
		reqDay = reqDay - 1
		
		Set dayDesc = Description.Create
		dayDesc("micclass").Value = "WebButton"
		dayDesc("class").Value = "btn btn-default btn-sm"
		dayDesc("html tag").Value = "BUTTON"
		dayDesc("innertext").Value = "" & reqDay & ""
		
		Set objDay = objOuterCal.WebButton(dayDesc)
		objDay.highlight
		
		Print reqDay & " - is active as expected."
		
		Set objDay = Nothing
		Set dayDesc = Nothing
		
	Next
	
	'check if 7-1 day is inactive
	reqDay = reqDay - 1
	Set dayDesc = Description.Create
	dayDesc("micclass").Value = "WebElement"
	dayDesc("html tag").Value = "TD"
	dayDesc("innertext").Value = reqDay & ".*"
	
	Set objDay = objOuterCal.WebButton(dayDesc)
	objDay.highlight
	Print reqDay & " - is not active as expected."
	Set objDay = Nothing
	Set dayDesc = Nothing
	
	'check if 7-1 day is inactive
	reqDay = calDay + 1
	Set dayDesc = Description.Create
	dayDesc("micclass").Value = "WebElement"
	dayDesc("html tag").Value = "TD"
	dayDesc("innertext").Value = reqDay & ".*"
	
	Set objDay = objOuterCal.WebButton(dayDesc)
	objDay.highlight
	Print reqDay & " - is not active as expected."
	Set objDay = Nothing
	Set dayDesc = Nothing
	
	Set objCurrentMonth = Nothing
	Set calOuterDesc = Nothing
	Set objOuterCal = Nothing
	Set objPage = Nothing
	
End Function

'===========================================================================================================================================================
'Function Name       :	AddPatientCarePlan
'Purpose of Function :	To add new Care Plan for patient with required data
'Input Arguments     :	objCalendar - Calendar object(webbutton)
'						dayToSelect - date which has to be selected
'						monthToSelect - month in words, as it appears on the calendar to be selected
'						yearToSelect - year which has to be selected
'Output Arguments    :	None
'Pre-requisite		 :  
'Example of Call     :	isPass = calendarFunction(objCal, "17", "August", "2018")
'Author				 :  Sudheer
'Date				 :	22-May-2015
'===========================================================================================================================================================
Function calendarFunction(ByVal objCalendar, ByVal dayToSelect, ByVal monthToSelect, ByVal yearToSelect)
    On Error Resume Next
    Err.Clear
    
    calendarFunction = false

    'Click on calender
    If not objCalendar.Exist(2) Then
        strOutErrorDesc = "Calendar does not exist on the screen."
        Exit Function
    End If
    objCalendar.Click
    Set objCalendar = Nothing
    Set objPage = getPageObject()
    
    wait 2
    
    'get complete calender object
    Set calOuterDesc = Description.Create
    calOuterDesc("micclass").Value = "WebElement"
    calOuterDesc("class").Value = "dropdown-menu ng-pristine ng-valid ng-valid-date-disabled.*"
    calOuterDesc("html tag").Value = "UL"
    calOuterDesc("outerhtml").Value = ".*display: block;"" ng-model=""date"".*"        '<ul class=""dropdown-menu ng-pristine ng-valid ng-valid-date-disabled"" style=""left: 0px; top: 24px; display: block;"" display: block;" ng-model="date"
    Set objOuterCal = objPage.WebElement(calOuterDesc)
    
    If not objOuterCal.Exist(2) Then
        Set objOuterCal = Nothing
            
        'get complete calender object
        Set calOuterDesc = Description.Create
        calOuterDesc("micclass").Value = "WebElement"
        calOuterDesc("class").Value = "dropdown-menu ng-valid ng-valid-date-disabled.*"
        calOuterDesc("html tag").Value = "UL"
        calOuterDesc("outerhtml").Value = ".*display: block;"" ng-model=""date"".*"        '<ul class=""dropdown-menu ng-pristine ng-valid ng-valid-date-disabled"" style=""left: 0px; top: 24px; display: block;"" display: block;" ng-model="date"
        Set objOuterCal = objPage.WebElement(calOuterDesc)    
    End If
    
    If Not objOuterCal.Exist(2) Then
        strOutErrorDesc = "Error in calendar function"
        Set objPage = Nothing
        Exit Function
    End If
    
    'get current date on calender
    Dim currentMonYear
    Set objCurrentMonth = objOuterCal.WebButton("class:=btn btn-default btn-sm","visible:=True", "html id:=datepicker.*")
    
    If Not objCurrentMonth.Exist(2) Then
        strOutErrorDesc = "Error in calendar function"
        Set objPage = Nothing
        Set objCurrentMonth = Nothing
        Exit Function
    End If
    
    currentMonYear = objCurrentMonth.getROProperty("innertext")
    currentMonYear = trim(currentMonYear)
    currentMonth = Split(currentMonYear," ")(0)
    currentYear = Split(currentMonYear," ")(1)
    
    Dim monthToSelectValue : monthToSelectValue = getNumericValueOfMonth(monthToSelect)
    Dim currentMonthValue : currentMonthValue = getNumericValueOfMonth(currentMonth)
    
    Dim yearToSelectValue : yearToSelectValue = CInt(yearToSelect)
    Dim currentYearValue : currentYearValue = CInt(currentYear)
    
    
    Set objRightButton = objOuterCal.WebButton("class:=btn btn-default btn-sm pull-right","type:=button","visible:=True")
    Set objLeftButton = objOuterCal.WebButton("class:=btn btn-default btn-sm pull-left","type:=button","visible:=True")
    
    'click on calendar where current month year displays
    objCurrentMonth.Click
    
    'if year to select is greater than current year on UI
    If  yearToSelectValue > currentYearValue Then

        Do until yearToSelectValue = currentYearValue
            objRightButton.Click
            wait 1
            Set objCurrentMonth1 = objOuterCal.WebButton("class:=btn btn-default btn-sm","visible:=True", "html id:=datepicker.*")
            objCurrentMonth1.highlight
            uiYear = objCurrentMonth1.getROProperty("innertext")
            uiYear = trim(uiYear)
            currentYearValue = Cint(uiYear)
            Set objCurrentMonth1 = Nothing
        Loop
    
    'if year to select is lesser than current year on UI    
    ElseIf  yearToSelectValue < currentYearValue Then
        
        Do until yearToSelectValue = currentYearValue
            objLeftButton.Click
            wait 1
            Set objCurrentMonth1 = objOuterCal.WebButton("class:=btn btn-default btn-sm","visible:=True", "html id:=datepicker.*")
            objCurrentMonth1.highlight
            uiYear = objCurrentMonth1.getROProperty("innertext")
            uiYear = trim(uiYear)
            currentYearValue = Cint(uiYear)
            Set objCurrentMonth1 = Nothing
        Loop
        
    End If
    
    Set objMonthButton = objOuterCal.WebButton("class:=btn btn-default.*", "html tag:=BUTTON", "outertext:=" & monthToSelect, "visible:=True")
    objMonthButton.Click
    wait 2
    Set objMonthButton = Nothing
    
    Set objDate = objOuterCal.WebButton("class:=btn btn-default btn-sm.*", "html tag:=BUTTON", "visible:=True", "innerhtml:=<span class=""ng-binding"".*", "innertext:=" & dayToSelect)
    objDate.highlight
    objDate.Click
    
    calendarFunction = True
    'kill all objects
    Set objDate = Nothing
    Set objRightButton = Nothing
    Set objLeftButton = Nothing
    Set objCurrentMonth = Nothing
    Set calOuterDesc = Nothing
    Set objOuterCal = Nothing
    Set objPage = Nothing
    
End Function


'#######################################################################################################################################################################################################
'Function Name		 : DeleteAllManageDocuments
'Purpose of Function : Purpose of this function is to delete all manage document attachement
'Input Arguments	 : None 
'Output Arguments	 : boolean: True or False
'					 : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call	 : blnReturnValue = DeleteAllManageDocuments(strOutErrorDesc)
'Author				 : Sharmila (Modified CT Script)
'Date				 : 14-May-2015
'#######################################################################################################################################################################################################

Function DeleteAllManageDocuments(strOutErrorDesc)

	strOutErrorDesc = ""
	Err.Clear
    On Error Resume Next
	DeleteAllManageDocuments = False
	
	strFileDeletedPopupTitle = DataTable.Value("FileDeletedPopupTitle","CurrentTestCaseData") 'File deleted popup title text
	strFileDeletedPopupText  = DataTable.Value("FileDeletedPopupText","CurrentTestCaseData")  'File deleted popup text message  
	strFileDeletedSuccessPopupText = DataTable.Value("FileDeletedSuccessText","CurrentTestCaseData")
	
	Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")' Data grid of manage document screen
	Execute "Set objDeleteButton = "  &Environment("WB_ManageDocument_DeleteButton")		 ' Delete button
	'Execute "Set objFileDeletedPopupTitle = "  &Environment("WEL_PopUp_Title")				 ' File deleted popup header
	'Execute "Set objFileDeletedPopupText  = "  &Environment("WEL_PopUp_Text")				 ' File deleted popup text message
	'Execute "Set objYesButton = "  &Environment.Value("DictObject").Item("WB_YES")								     ' Yes button
	'Execute "Set objOKButton = "  &Environment.Value("DictObject").Item("WB_OK")	
	
	If not waitUntilExist(objManageDocumentDataGrid,10) Then
		Call WriteToLog("Fail","Manage Document Data Grid does not exist")
		Call WriteLogFooter()
		ExitAction
	End If
	
	Call WriteToLog("Info","Manage Document Data Grid does exists")

	'Get the rows in Grid
	intRows = objManageDocumentDataGrid.GetROProperty("rows")
	If intRows = 0 Then
		Call WriteToLog("Pass","No document exist in manage documents grid")
		DeleteAllManageDocuments = True
		Exit Function
	End If
	
	For i = 1 To intRows Step 1
		Err.Clear
		objManageDocumentDataGrid.ChildItem(i,1,"WebElement",0).Click

		If Err.Number<>0 Then
			strOutErrorDesc = "Check box was not clicked in Manage document grid"
			Exit Function
		End If
		Set objManageDocumentDataGrid = Nothing
		Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")' Data grid of manage document screen
	Next
	
	'Click on Delete button
	blnReturnValue = ClickButton("Delete button",objDeleteButton,strOutErrorDesc)
	If Not blnReturnValue Then
		strOutErrorDesc = "ClickButton returned error: "&strOutErrorDesc
		Exit Function
	End If
	
	Call waitTillLoads("Saving...")
	
	'Verify that message box exist stating that "Are you sure you want to remove the selected file\(s\)\?"
	blnReturnValue =  checkForPopup(strFileDeletedPopupTitle,"Yes",strFileDeletedPopupText, strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedPopupText&" was displayed")
	Else
		strOutErrorDesc = "Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedPopupTitle&" was not displayed. Error returned: "&strOutErrorDesc
		Exit Function
	End If
	
	Call waitTillLoads("Saving...")
	
	blnReturnValue = checkForPopup(strFileDeletedPopupTitle,"Ok",strFileDeletedSuccessPopupText,strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedSuccessPopupText&" was displayedl")
	Else
		strOutErrorDesc = "Popup with title: "&strFileDeletedPopupTitle& " and stating message: "&strFileDeletedSuccessPopupText&" was not displayed. Error returned: "&strOutErrorDesc
		Exit Function
	End If
	
	
	Wait 2
	
	DeleteAllManageDocuments = True
	
End Function

'#######################################################################################################################################################################################################
'Function Name		 : UploadAllManageDocuments
'Purpose of Function : Purpose of this function is to upload different file types in Manage Document
'Input Arguments	 : FileType 
'Output Arguments	 : boolean: True or False
'					 : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call	 : blnReturnValue = UploadManageDocuments(strOutErrorDesc,"PDF")
'Author				 : Sharmila/Swetha
'Date				 : 14-May-2015
'#######################################################################################################################################################################################################

Function UploadManageDocuments(strOutErrorDesc, ByVal TestFileType)

	strOutErrorDesc = ""
    Err.Clear
    On Error Resume Next
    UploadManageDocuments = False
    
    strFileUploadedPopupTitle = DataTable.Value("FileUpLoadedPopupTitle","CurrentTestCaseData")
    strFileUploadedPopupText = DataTable.Value("FileUpLoadedPopupText","CurrentTestCaseData")
    strFileDescription = DataTable.Value("FileDescription","CurrentTestCaseData")
    strDocumentType = DataTable.Value("DocumentType","CurrentTestCaseData")
    strFilePath = Environment.Value("PROJECT_FOLDER")&"\Testdata\ManageDocuments"
    strFileName = "Test_"&TestFileType&"File."&TestFileType
    strBrowseFileNameWithLocation = strFilePath&"\"&strFileName
    
    
    Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid") ' Data grid of manage document screen
    Execute "Set objDeleteButton = "  &Environment("WB_ManageDocument_DeleteButton")         ' Delete button
    Execute "Set objUploadButton = "  &Environment("WB_ManageDocument_UploadButton")
    Execute "Set objFileSelectionPopup = "  &Environment("WEL_ManageDocument_FileSelection_PopupTitle")
    Execute "Set objFileSelectionFileNameField = "  &Environment("WE_ManageDocument_FileSelection_FileName")
    Execute "Set objFileSelectionSelectFile = "  &Environment("WEL_ManageDocument_FileSelection_SelectFile")
    Execute "Set objFileSelectionFileDescriptionField = "  &Environment("WE_ManageDocument_FileSelection_FileDescription")
    Execute "Set objFileSelectionDocumentTypeDropdown = "  &Environment("WB_ManageDocument_FileSelection_DocumentType")
    Execute "Set objFileNameField = "  &Environment("WiE_ChooseFileToUpload_Dialog_FileNameField")
    Execute "Set objOpenButton = "  &Environment("WiB_ChooseFileToUpload_Dialog_OpenButton")
    Execute "Set objOKButton= "  &Environment("WB_OK")
    '==========================================================
    'Verify that manage document screen contain button Upload 
    '==========================================================
    If not waitUntilExist(objUploadButton,10) Then
        strOutErrorDesc = "Upload button does not exist on manage document screen" &strOutErrorDesc
        Exit Function
    End If
    
    Call WriteToLog("Info","Upload button exist on manage document screen")
    
    '=======================================================================
    'Click on Upload button and verify that File Seletion popup should open
    '=======================================================================
    blnReturnValue = ClickButton("Upload button",objUploadButton,strOutErrorDesc)
    If Not blnReturnValue Then
        strOutErrorDesc =  "ClickButton returned error: "&strOutErrorDesc
        Exit Function
        
    End If
    
    wait 2
    
    'Verify the file popup dialog exists
    If not waitUntilExist(objFileSelectionPopup,10) Then
        strOutErrorDesc = "File Seletion popup does not open successfully after clicking on upload button"  &strOutErrorDesc
        Exit Function
    End If
    
    Call WriteToLog("Pass","File Seletion popup open successfully after clicking on upload button")
    
    'Verify the file selection field name exists
    If not waitUntilExist(objFileSelectionFileNameField,10) Then
        strOutErrorDesc = "File name edit field does not exist on File Selection popup" &strOutErrorDesc
        Exit Function
    End If
    
    Call WriteToLog("Info","File name edit field exist on File Selection popup")
    
    If not waitUntilExist(objFileSelectionSelectFile,10) Then
        Call WriteToLog("Fail","Select file button does not exist on File Selection popup")
        Exit Function
    End If
    
    Call WriteToLog("Info","Select file button exist on File Selection popup")
    
    
    '============================================
    'Set the location of file in File name field
    '============================================
    intX = objFileSelectionSelectFile.GetROProperty("abs_x")
    intY = objFileSelectionSelectFile.GetROProperty("abs_y")
    
    intX1 = objFileSelectionSelectFile.GetROProperty("width")
    intY1 = objFileSelectionSelectFile.GetROProperty("height")
    
    'Move click at middle of an object
    Set ObjectName = CreateObject("Mercury.DeviceReplay")
    ObjectName.MouseClick intX + intX1/2,intY + intY1/2,LEFT_MOUSE_BUTTON
    
    wait 2
    
    If not waitUntilExist(objFileNameField,10) Then
        Call WriteToLog("Fail","File name edit field does not exist on Choose file to upload Dialog")
        Exit Function
    End If
    
    Call WriteToLog("Info","File name edit field exist on Choose file to upload Dialog")
    
    Err.Clear
    objFileNameField.Set strBrowseFileNameWithLocation
    If Err.Number <> 0 Then
        strOutErrorDesc = "File name edit field does not exist on choose file to upload Dialog" &strOutErrorDesc
        Exit Function
    End If
    
    Wait 2
    'Verify open button exist on Choose file to upload dialog
    If not waitUntilExist(objOpenButton,10) Then
        Call WriteToLog("Fail","Open button does not exist on Choose file to upload Dialog")
        Exit Function
    End If
    
    Call WriteToLog("Info","Open button exist on Choose file to upload Dialog")
    
    'Click on open file button
    blnReturnValue = ClickButton("Open button",objOpenButton,strOutErrorDesc)
    If Not blnReturnValue Then
        strOutErrorDesc = "ClickButton returned error: "&strOutErrorDesc
        Exit Function
    End If
    
    Wait 2
    
        
    '==================================================================
    'Set the location of file in File Description field to some value
    '==================================================================
    
    If not waitUntilExist(objFileSelectionFileDescriptionField,10) Then
        Call WriteToLog("Fail","File description field does not exist on File Selection popup")
        Exit Function
    End If
    
    Call WriteToLog("Info","File description field exist on File Selection popup")
    
    Err.Clear
    objFileSelectionFileDescriptionField.Click
    objFileSelectionFileDescriptionField.Set "Test"&TestFileType
    
    'Call SendKeys("{TAB}")
    
    If Err.Number<>0 Then
        strOutErrorDesc = "File description does not set sucessfully in File name field. Error returned: "&strOutErrorDesc
        Exit Function
    End If
    
    Wait 2
    
    '===========================
    'Set document type field
    '===========================
    
    If not waitUntilExist(objFileSelectionDocumentTypeDropdown,10) Then
        Call WriteToLog("Fail","Document Type dropdown does not exist on File Selection popup")
        Call WriteLogFooter()
        ExitAction
    End If
    
    Call WriteToLog("Info","Document Type dropdown exist on File Selection popup")
    
    Call selectComboBoxItem(objFileSelectionDocumentTypeDropdown, strDocumentType)
    
    Wait 2 'Wait time for application sync
    
    '======================
    'Click on OK button
    '======================
    If not waitUntilExist(objOKButton,10) Then
        Call WriteToLog("Fail","OK button does not exist on File Selection popup")
        Exit Function
    End If
    
    Call WriteToLog("Pass","OK button exist on File Selection popup")
    
    blnReturnValue = ClickButton("OK button",objOKButton,strOutErrorDesc)
    If Not blnReturnValue Then
        strOutErrorDesc = "ClickButton returned error: "&strOutErrorDesc
        Exit function
    End If
    
    wait 5
'    '========================================================================================
'    'Wait for Saving....
'    '========================================================================================
'
'    Set objPage = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
'    Set objPopup = objPage.WebElement("innertext:=Saving...", "html tag:=SPAN")
'    Dim cnt : cnt = 1
'    
'    Do while objPopup.Exist(2) = True
'        cnt = cnt + 1
'        If cnt = 30 Then
'            waitTillLoads = False
'    
'        End If
'        wait 2
'    Loop
'    
''    waitTillLoads = True
''    Set objPopup = Nothing
''    Set objPage = Nothing
    
    '========================================================================================
    'Verify that file uploaded successfully message popup is visible after uploading the file
    '========================================================================================
    Call waitTillLoads("Saving...")
    wait 6
    blnReturnValue = checkForPopup(strFileUploadedPopupTitle, "Ok", strFileUploadedPopupText, strOutErrorDesc)
    If blnReturnValue Then
        Call WriteToLog("Pass","File Type:" &TestFileType &" Was Uploaded Successfully")
    Else
        Call WriteToLog("Fail","File Type:" &TestFileType & " Was  not Uploaded Successfully")
        Exit function
    End If
    
    wait 3

    UploadManageDocuments = True
    

End Function
Function selectPatientFromGlobalSearch(ByVal searchValue)
    
    Err.Clear
    On Error Resume Next

    selectPatientFromGlobalSearch = False
    Dim isMemberId : isMemberId = False
    
    lngMemID = searchValue
    
    If isNumeric(lngMemID) Then
        isMemberId = True
    End If
    
    'Search with patient MemID
    Execute "Set objGloSearch = " & Environment("WE_GloSearch")
    objGloSearch.Set lngMemID
    If Err.number <> 0 Then
        Set objGloSearch = Nothing    'kill the object
        strOutErrorDesc = "Unable to set Member ID IN Global Search: "&" Error returned: " & Err.Description
        Exit Function
    End If
    Set objGloSearch = Nothing    'kill the object
    
    'wait till the loads
	wait 2
	waitTillLoads "Loading..."
	wait 2
    
    'Clk on search icon of global search
    Execute "Set objSearchIcon = " & Environment("WI_GlobalSearchIcon")
    objSearchIcon.Click
    If err.number <> 0 Then
        Set objSearchIcon = Nothing    'kill the object
        strOutErrorDesc = "Unable to click Global Search icon: "&" Error returned: " & Err.Description
        Exit Function
    End If
    Set objSearchIcon = Nothing    'kill the object
    
    'wait till the loads
	wait 2
	waitTillLoads "Loading..."
	wait 2
    
    'verify if A patient exists matching the entered criteria message box exists
    isPass = checkForPopup("Error", "Ok", "A patient exists matching the entered criteria.", strOutErrorDesc)
    If isPass Then
        Call WriteToLog("Fail", "A patient exists matching the entered criteria. You do not currently have permissions to view this patient record, please contact your manager.")
        Exit Function
    End If
    
    'verify if no matching results found message box existed if no patient found
    isPass = checkForPopup("Error", "Ok", "No matching results found", strOutErrorDesc)
    If isPass Then
        strOutErrorDesc = "No matching results found"
        Call WriteToLog("Fail", strOutErrorDesc)
        Exit Function
    End If
    
    'Chk whether PatientSearchResult popup is available
    Execute "Set objPatSeResPP = " & Environment("WEL_GloSearchGrid")	'Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("html tag:=DIV","innerhtml:=.*Patient Search Results.*","innertext:=Patient Search Results.*","outerhtml:=.*Patient Search Results.*","visible:=True")
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
    Set objGlobalSearchGrid = objPage.WebElement("html id:=global-search-grid")
    objGlobalSearchGrid.highlight
    
    Set objtable = objGlobalSearchGrid.WebTable("class:=k-selectable")
    objtable.highlight
    For i = 1 To objtable.getRoProperty("rows")
        x = objtable.getCellData(i,reqColumn)
        If lcase(x) = lcase(lngMemID) Then
            objtable.ChildItem(i, reqColumn, "WebElement", 0).Click
            Exit For
        End If
    Next
	
	'wait till the loads
	wait 2
	waitTillLoads "Loading..."
	wait 2 

    'Clk OK for required patient
    Execute "Set PSResOK = " & Environment("WB_PSResOK")
    PSResOK.Click
    If err.number <> 0 Then
        Set PSResOK = Nothing    'kill the object
        strOutErrorDesc = "Unable to click OK in PatientSearchResult popup : "&" Error returned: " & Err.Description
        Exit Function
    End If
    Set PSResOK = Nothing    'kill the object
	
	'wait till the loads
	wait 2
	waitTillLoads "Loading..."
	wait 2

    selectPatientFromGlobalSearch = true
    Set objGlobalSearchGrid = Nothing
    Set tableDesc = Nothing
    Set objtable = Nothing
    Set objPage = Nothing
    
End Function

'===========================================================================================================================================================
'Function Name       :	AdmitPatient
'Purpose of Function :	To Admit a patient with required values
'Input Arguments     :	dtAdmitDate: Date value representing date of admission
'					 :  dtNotificationDate: Date value representing date of admit notification
'					 :  strAdmitType: string value representing the type of admission
'					 :  strNotifiedBy: string value representing the NotifiedBy value
'					 :  strSourceOfAdmit: string value representing the Source of Admit
'					 :  strAdmittingDiagnosisTxt: string value representing the type of admit diagnosis
'					 :  strWorkingDiagnosisTxt: string value representing the type of working diagnosis
'Output Arguments    :	Boolean value: Indicating whether the patient is admitted with required values
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Example of Call     :	blnAdmitPatient = AdmitPatient(dtAdmitDate, dtNotificationDate, strAdmitType, strNotifiedBy, strSourceOfAdmit, strAdmittingDiagnosisTxt, strWorkingDiagnosisTxt, strOutErrorDesc)
'Author              :	Gregory
'Date                : 	03August2015
'===========================================================================================================================================================
Function AdmitPatient(ByVal dtAdmitDate, ByVal dtNotificationDate, ByVal strAdmitType, ByVal strNotifiedBy, ByVal strSourceOfAdmit, ByVal strAdmittingDiagnosisTxt, ByVal strWorkingDiagnosisTxt, strOutErrorDesc)

	On Error Resume Next
	strOutErrorDesc = ""
	AdmitPatient = False
	Err.Clear
	
	'Click on Add button if it is enabled
	Execute "Set objAddBtn = " & Environment("WEL_HospitalizationAddBtn") 'Hospitalization Add button
	If not objAddBtn.Object.isDisabled Then
		Err.Clear
		blnAddClicked = ClickButton("Add",objAddBtn,strOutErrorDesc)
		If not blnAddClicked Then
			strOutErrorDesc = "Unable to click Add button for hospitalization "& strOutErrorDesc
			Exit Function	
		End If
	End If
	Call WriteToLog("Pass","'Add' button is available and validated button functionality")	
	Execute "Set objAddBtn = Nothing"
	wait 5	
		
'	'Set 'Admit Date'
'	Execute "Set objAdmitDateTxt = " & Environment("WE_AdmitDateTxt") 'Admit date text box
'	If not objAdmitDateTxt.Object.isDisabled Then
'		Err.Clear
'		Execute "Set objAdmitCalendarBtn = " & Environment("WB_AdmitCalendarBtn")
'		blnSelectDateFromCalendarWidget = SelectDateFromCalendarWidget(objAdmitCalendarBtn, "No", dtAdmitDate, strOutErrorDesc)
'		If not blnSelectDateFromCalendarWidget Then
'			strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
'			Exit Function	
'		Else 
'			Call WriteToLog("Pass","Admit Date is set")
'		End If
'	End If	
'	Execute "Set objAdmitDateTxt = Nothing"
'	wait 0,250

	'Set 'Admit Date'
	Execute "Set objAdmitDateTxt = " & Environment("WE_AdmitDateTxt") 'Admit date text box
	If not objAdmitDateTxt.Object.isDisabled Then
		Err.Clear
		objAdmitDateTxt.Set dtAdmitDate
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to set AdmitDate "&strOutErrorDesc
			Exit Function	
		Else 
			Call WriteToLog("Pass","Admit Date field is available and admit date is set")
		End If
	End If	
	Execute "Set objAdmitDateTxt = Nothing"
	wait 0,250
	
'	'Set 'Admit Notification Date'
'	Err.Clear
'	Execute "Set objAdmitNotificationCalendarBtn = " & Environment("WB_AdmitNotificationCalendarBtn")
'	blnSelectDateFromCalendarWidget = SelectDateFromCalendarWidget(objAdmitNotificationCalendarBtn, "No", dtNotificationDate, strOutErrorDesc)
'	If not blnSelectDateFromCalendarWidget Then
'		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
'		Exit Function	
'	Else 
'		Call WriteToLog("Pass","Admit Notification Date is set")
'	End If
'	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
'	wait 0,250

	'Set 'Admit Notification Date'
	Execute "Set objAdmitNotificationDate = "&Environment("WE_NotificationDateTxt")
	Err.Clear
	objAdmitNotificationDate.Set dtNotificationDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Admit Notification Date field is available and admit notification date is set")
	End If
	Execute "Set objAdmitNotificationCalendarBtn = Nothing"
	wait 0,250
	
	'Select required notification
	Execute "Set objNotifiedByDD = " & Environment("WB_NotifiedByDD") 'NotifiedBy drop down
	objNotifiedByDD.highlight
	blnNotification = selectComboBoxItem(objNotifiedByDD, strNotifiedBy)
	If Not blnNotification Then
		strOutErrorDesc = "Unable to select required 'NotifiedBy'. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Selected required 'Notified By' value")
	Execute "Set objNotifiedByDD = Nothing"
	wait 0,500
	
	'Select required AdmitType
	Execute "Set objAdmitTypeDD = " & Environment("WB_AdmitTypeDD") 'Adimit Type dropdown
	objAdmitTypeDD.highlight
	blnAdmitType = selectComboBoxItem(objAdmitTypeDD, strAdmitType)
	If Not blnAdmitType Then
		strOutErrorDesc = "Unable to select required admit type. " &strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Selected required 'Admit Type'")
	Execute "Set objAdmitTypeDD = Nothing"
	wait 0,500
	
	'For 'ED Visit' admit type,SourceOfAdmit dropdown will be disabled 
	If strAdmitType <> "ED Visit" Then
		
		'Select required SourceOfAdmit
		Execute "Set objSourceOfAdmitDD = " & Environment("WB_SourceOfAdmitDD") 'Source of Admit dropdown
		objSourceOfAdmitDD.highlight
		blnSourceOfAdmit = selectComboBoxItem(objSourceOfAdmitDD, strSourceOfAdmit)
		If Not blnSourceOfAdmit Then
			strOutErrorDesc = "SourceOfAdmit selection returned error: "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass","Selected required SourceOfAdmit")
		Execute "Set objSourceOfAdmitDD = Nothing"
		wait 0,250
			
		'Set the required value for AdmittingDiagnosis textarea
		Err.Clear
		Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
		objAdmittingDiagnosisTxt.Set strAdmittingDiagnosisTxt
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to set value for AdmittingDiagnosis "&Err.Description
			Exit Function	
		Else 
			Call WriteToLog("Pass","'Admitting Diagnosis' value is set")
		End If
		Execute "Set objAdmittingDiagnosisTxt = Nothing"
		wait 0,500
		
		'Set the required value for WorkingDiagnosis textarea
		Err.Clear
		Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
		objWorkingDiagnosisTxt.Set strWorkingDiagnosisTxt
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to set value for WorkingDiagnosis "&Err.Description
			Exit Function	
		Else 
			Call WriteToLog("Pass","'Working Diagnosis' field is available and required value is set")
		End If
		Execute "Set objWorkingDiagnosisTxt = Nothing"
		wait 0,500
		
		'Click on Save button for hospitalization
		Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
		objSaveBtn.highlight
		Err.Clear
		blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
		If not blnSaveClicked Then
			strOutErrorDesc = "Unable to click Save button for hospitalization "& strOutErrorDesc
			Exit Function	
		End If
		Wait 2	
		Call waitTillLoads("Updating Record...")
		Wait 1
		Call waitTillLoads("Loading...")
		Execute "Set objSaveBtn = Nothing"
		Wait 0,100
			
		'Check for 'Record has been added successfully' popup
		blnRecordUpdatedPopup = checkForPopup("Hospitalization", "Ok", "Record has been added successfully", strOutErrorDesc)
		If not blnRecordUpdatedPopup Then
			strOutErrorDesc = "Unable to validate record updated popup "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("PASS","Validated record added popup")	
		Wait 1	

	ElseIf strAdmitType = "ED Visit" Then
	
		dtDischargeNotificationDate = dtAdmitDate
		Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
		Err.Clear 
		objDischargeNotificationDate.Set dtDischargeNotificationDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set Discharge Notification Date "&strOutErrorDesc
			Exit Function	
		Else 
			Call WriteToLog("Pass","Discharge Notification Date field is available and Discharge Notification date is set")
		End If
		Execute "Set objDischargeNotificationCalendarBtn = Nothing"
		wait 1
'		Execute "Set objDischargeNotificationCalendarBtn = " & Environment("WB_DischargeNotificationCalendarBtn")
'		blnSelectDateFromCalendarWidget = SelectDateFromCalendarWidget(objDischargeNotificationCalendarBtn, "No", dtDischargeNotificationDate, strOutErrorDesc)
'		If not blnSelectDateFromCalendarWidget Then
'			strOutErrorDesc = "Unable to set Discharge Notification Date "&strOutErrorDesc
'			Exit Function	
'		Else 
'			Call WriteToLog("Pass","Discharge Notification Date field is available and Discharge Notification date is set")
'		End If
'		Execute "Set objDischargeNotificationCalendarBtn = Nothing"
'		wait 0,250
		
		'Check any Related diagnoses
		For iRD = 0 To 3 Step 1
			Execute "Set objPage_H_RD = "&Environment("WPG_AppParent")
			Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("class:=screening-check-box-no.*","html id:=dig-selected-"&iRD,"html tag:=DIV","visible:=True")
			Err.Clear
			objRelatedDiagnosesCB.Click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to select checkbox for RelatedDiagnosis: "&" Error returned: " & Err.Description
				Exit Function
			End If	
			Execute "Set objPage_H_RD = Nothing"
			Set objRelatedDiagnosesCB = Nothing		
		Next
		Call WriteToLog("Pass","Checked RelatedDiagnoses check boxes")
		Execute "Set objPage_H_RD = Nothing"
		Set objRelatedDiagnosesCB = Nothing
		
		'Set the required value for AdmittingDiagnosis textarea
		Err.Clear
		Execute "Set objAdmittingDiagnosisTxt = " & Environment("WE_AdmittingDiagnosisTxt") 'Admitting diagnosis text area
		objAdmittingDiagnosisTxt.Set strAdmittingDiagnosisTxt
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to set value for AdmittingDiagnosis "&Err.Description
			Exit Function	
		Else 
			Call WriteToLog("Pass","'Admitting Diagnosis' value is set")
		End If
		Execute "Set objAdmittingDiagnosisTxt = Nothing"
		wait 0,500
		
		'Set the required value for WorkingDiagnosis textarea
		Err.Clear
		Execute "Set objWorkingDiagnosisTxt = " & Environment("WE_WorkingDiagnosisTxt") 'Working Diagnosis text area
		objWorkingDiagnosisTxt.Set strWorkingDiagnosisTxt
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to set value for WorkingDiagnosis "&Err.Description
			Exit Function	
		Else 
			Call WriteToLog("Pass","'Working Diagnosis' field is available and required value is set")
		End If
		Execute "Set objWorkingDiagnosisTxt = Nothing"
		wait 0,500
		
		'Click on Save button for hospitalization
		Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
		objSaveBtn.highlight
		Err.Clear
		blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
		If not blnSaveClicked Then
			strOutErrorDesc = "Unable to click Save button for hospitalization "& strOutErrorDesc
			Exit Function	
		End If
		Wait 2	
		Call waitTillLoads("Updating Record...")
		Wait 1
		Call waitTillLoads("Loading...")
		Execute "Set objSaveBtn = Nothing"
		Wait 0,100
			
		'Check for 'Record has been added successfully' popup
		blnRecordUpdatedPopup = checkForPopup("Hospitalization", "Ok", "Record has been added successfully", strOutErrorDesc)
		If not blnRecordUpdatedPopup Then
			strOutErrorDesc = "Unable to validate record updated popup "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("PASS","Validated record added popup")	
		Wait 1
		
	End If

	AdmitPatient = True
	
End Function

'===========================================================================================================================================================
'Function Name       :	DischargePatient
'Purpose of Function :	To discharge a patient with required values
'Input Arguments     :	dtDischargeDate: Date value representing date of discharge
'					 :  dtNotificationDate: Date value representing date of discharge notification
'					 :  strDisposition: string value representing disposition
'Output Arguments    :	Boolean value: Indicating whether the patient is discharged with required values
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Example of Call     :	blnDischargePatient = DischargePatient(dtDischargeDate, dtDischargeNotificationDate, strDisposition, strOutErrorDesc)
'Author              :	Gregory
'Date                : 	03August2015
'===========================================================================================================================================================

Function DischargePatient(ByVal dtDischargeDate, ByVal dtDischargeNotificationDate, ByVal strDisposition, strOutErrorDesc)

	On Error Resume Next
	strOutErrorDesc = ""
	DischargePatient = False
	Err.Clear
	
	'Set the required date for discharge
	Execute "Set objDischargeDate = "&Environment("WE_DischargeDateTxt")
	Err.Clear
	objDischargeDate.Set dtDischargeDate
	If Err.Number <> 0 Then		
		strOutErrorDesc = "Unable to set Discharge Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Date field is available and Discharge date is set")
	End If
	Execute "Set objAdmitDateFieldVal = Nothing"
	Execute "Set objDischargeCalendarBtn = Nothing"
	wait 0,250
	
'	Err.Clear
'	Execute "Set objDischargeCalendarBtn = " & Environment("WB_DischargeCalendarBtn")
'	blnSelectDateFromCalendarWidget = SelectDateFromCalendarWidget(objDischargeCalendarBtn, "No", dtDischargeDate, strOutErrorDesc)
'	If not blnSelectDateFromCalendarWidget Then
'		strOutErrorDesc = "Unable to set required date for discharge "&strOutErrorDesc
'		Exit Function	
'	Else 
'		Call WriteToLog("PASS","Set required date for discharge")
'	End If
'	Execute "Set objDischargeCalendarBtn = Nothing"
'	wait 1
	
	'Set the required Notification date for discharge
	dtDischargeNotificationDate = dtDischargeDate
	Execute "Set objDischargeNotificationDate = "&Environment("WE_DischargeNotificationDateTxt")
	Err.Clear 
	objDischargeNotificationDate.Set dtDischargeNotificationDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Discharge Notification Date "&strOutErrorDesc
		Exit Function	
	Else 
		Call WriteToLog("Pass","Discharge Notification Date field is available and Discharge Notification date is set")
	End If
	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
	wait 1
	
'	Err.Clear
'	Execute "Set objDischargeNotificationCalendarBtn = " & Environment("WB_DischargeNotificationCalendarBtn")
'	blnSelectDateFromCalendarWidget = SelectDateFromCalendarWidget(objDischargeNotificationCalendarBtn, "No", dtDischargeNotificationDate, strOutErrorDesc)
'	If not blnSelectDateFromCalendarWidget Then
'		strOutErrorDesc "Unable to set required Notification date for discharge "&strOutErrorDesc
'		Exit Function	
'	Else 
'		Call WriteToLog("PASS","Set required Notification date for discharge")
'	End If
'	Execute "Set objDischargeNotificationCalendarBtn = Nothing"
'	wait 1
	
	'Select Disposition value
	Execute "Set objDispositionDD = " & Environment("WB_DispositionDD")
	objDispositionDD.highlight
	blnDisposition = selectComboBoxItem(objDispositionDD, strDisposition)
	If Not blnDisposition Then
		strOutErrorDesc = "Disposition selection returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("PASS","Selected required Disposition")
	Execute "Set objDispositionDD = Nothing"
	wait 2

	'Check any Related diagnoses
	For iRD = 0 To 3 Step 1
		Execute "Set objPage_H_RD = "&Environment("WPG_AppParent")
'		Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("class:=screening-check-box-no.*","html id:=dig-selected-"&iRD,"html tag:=DIV","visible:=True")
		Set objRelatedDiagnosesCB = objPage_H_RD.WebElement("html id:=Hospitalization_Review_DomainDeleted_"&iRD&"_Div","visible:=True")
		Err.Clear
		objRelatedDiagnosesCB.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Unable to select checkbox for RelatedDiagnosis: "&" Error returned: " & Err.Description
			Exit Function
		End If	
		Execute "Set objPage_H_RD = Nothing"
		Set objRelatedDiagnosesCB = Nothing		
	Next
	Call WriteToLog("Pass","Checked RelatedDiagnoses check boxes")
	Execute "Set objPage_H_RD = Nothing"
	Set objRelatedDiagnosesCB = Nothing
	
	'Click on Save button for hospitalization
	Execute "Set objSaveBtn = "&Environment("WI_SaveAdmission")
	objSaveBtn.highlight
	Err.Clear
	blnSaveClicked = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnSaveClicked Then
		strOutErrorDesc = "Unable to click Save button for hospitalization "& strOutErrorDesc
		Exit Function	
	End If
	Wait 2	
	Call waitTillLoads("Updating Record...")
	Wait 1
	Call waitTillLoads("Loading...")
	Execute "Set objSaveBtn = Nothing"
	Wait 0,100
	
	'Check for 'Record has been updated successfully' popup
	blnRecordUpdatedPopup = checkForPopup("Hospitalization", "Ok", "Record has been updated successfully", strOutErrorDesc)
	If not blnRecordUpdatedPopup Then
		strOutErrorDesc = "Unable to validate record updated popup "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("PASS","Validated record updated popup")	
	Wait 1
	
	DischargePatient = True
	
End Function

'#######################################################################################################################################################################################################
'Function Name		 : TerminatePatient
'Purpose of Function : Purpose of this function is to terminate a patient from EPS
'Input Arguments	 : Member ID
'Output Arguments	 : boolean: True or False
'					 : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call	 : isPass = TerminatePatient(strMemberID)
'Author				 : Sudheer (Modified by Sharmila)
'Date Modified		 : 12-Aug-2015
'#######################################################################################################################################################################################################
'Make sure app is logged out and all browsers are closed
Function TerminatePatient(ByVal memberID)

	On Error Resume Next
	Err.Clear
	TerminatePatient = False
	
	''=========================
	'' Variable initialization
	''=========================
	strReason = DataTable.Value("Reason","CurrentTestCaseData")
	strNotifiedBy = DataTable.Value("NotifiedBy","CurrentTestCaseData")
	strDetail = DataTable.Value("Detail","CurrentTestCaseData")	
	strSupportingDetails = DataTable.Value("SupportingDetails","CurrentTestCaseData")
	
	Call WriteToLog("Info","==========Testcase - Search for the member with ID:" &strMemberID& " in the EPS dashboard.==========")

	
	clickOnMainMenu("My Dashboard")
	wait 2
	Call waitTillLoads("Loading...")
	wait 2
	Set objpage = getPageObject()
	Execute "Set objMemberId = "  & Environment("WE_SearchMemberId")
	objMemberId.Set memberID
	
	Execute "Set objSearchBtn = " & Environment("WB_MemberSearch")
	objSearchBtn.Click
	Set objSearchBtn = Nothing
	Set objMemberId = Nothing
	Call WriteToLog("Pass", "Search button was clicked successfully")
	Wait 2
	Call waitTillLoads("Loading...")
	
	Execute "Set objCustomMsgBoxTitle = " & Environment("WEL_MemberSearchResults")
	If objCustomMsgBoxTitle.WaitProperty("visible",True,5000) Then
		objCustomMsgBoxTitle.highlight
		Set objMsg = objpage.WebElement("html tag:=SPAN", "innerhtml:=No Search results found.")
		If objMsg.WaitProperty("visible", True, 5000) Then
			Call WriteToLog("Fail", "No search results found for the member id - '" & memberID & "'")
			Execute "Set objCancelBtn = " & Environment("WB_MemberSearchResultsCancel")
			objCancelBtn.Click
			Set objCustomMsgBoxTitle = Nothing
        	Exit Function
		End If		
    End If
	
	Set objCustomMsgBoxTitle = Nothing
	Call WriteToLog("Pass", "Member Search Results displayed in the table")	
	Execute "Set objTable = " & Environment("WT_MemberSearchResultsTable")
	objTable.ChildItem(1,1, "WebElement", 1).Click
	Execute "Set objView = " & Environment("WB_MemberSearchView")
	objView.Click
	wait 2
	Call waitTillLoads("Loading...")
	
	Call WriteToLog("Info","==========Testcase - Once the patient is loaded, Terminate the patient.==========")

	
	clickOnSubMenu("Member Info->Patient Info")
	wait 2
	Call waitTillLoads("Loading...")
	Set objpage = Nothing
	Set objpage = getPageObject()
	objpage.highlight
	Call WriteToLog("Pass", "Searched Member was opened successfully and demographics screen was displayed")	
	
	Execute "Set objterminateBtn = " & Environment("WB_PatientTerminate")
	isPass = waitUntilExist(objterminateBtn, 10)
	objterminateBtn.Click
	Wait 2
	
	Call WriteToLog("Pass", "Terminate button was clicked")	
	
	waitTillLoads "Loading..."
	wait 2
	Execute "Set objterminatePatient = " & Environment("WEL_TerminatePatientWindow")
	If not objterminatePatient.WaitProperty("visible", true, 5000) Then
		Call WriteToLog("Fail", "Failed to open the Terminate Patient window")
		Exit Function
	End if
	
	Call WriteToLog("Pass", "Terminate Patient dialog is displayed")	
	
'	Set objReason = objPage.WebButton("html id:=resone")
'	Call selectComboBoxItem(objReason, "Patient Request")
'	wait 5
'	Set objnotified = objPage.WebButton("html id:=notified", "index:=0")
'	Call selectComboBoxItem(objnotified, "Call Center")
	Set objDropDown = getTerminatePatientDropDown("Reason")
	isPass = selectComboBoxItem(objDropDown, strReason)
	Set objDropDown = Nothing
	wait 5
	
	Call WriteToLog("Pass", "Reason dropdown is set with value: " &strReason)
	Set objDropDown = getTerminatePatientDropDown("Notified By")
	isPass = selectComboBoxItem(objDropDown, strNotifiedBy)
	Set objDropDown = Nothing
	Call WriteToLog("Pass", "Notified By dropdown is set with value: " &strNotifiedBy)
	wait 5
	Set objpage = Nothing
	Set objpage = getPageObject()
    objpage.Sync
'	objPage.WebEdit("html id:=eventDatepicker", "outerhtml:=.*data-capella-automation-id=""terminatePatient.myDate"".*").Set date - 1
	Set dateDesc = Description.Create
	dateDesc("micclass").Value = "WebEdit"
	
	Set objDate = objPage.ChildObjects(dateDesc)
	For i = 0 To objDate.Count - 1
		outerhtml = objDate(i).GetROPRoperty("outerhtml")
		htmlid = objDate(i).GetROProperty("html id")
		'Print outerhtml
		'Print htmlid
		If lcase(htmlid) = lcase("eventDatepicker") Then
			objDate(i).highlight
			objDate(i).Set date - 1
		End If
		If instr(outerhtml, "terminatePatient.myDate") > 0 Then
			objDate(i).highlight
			objDate(i).Set date - 1
		End If
	Next 
	
	Set dateDesc = Nothing
	Set objDate = Nothing
	

	wait 5
	
	Set objDropDown = getTerminatePatientDropDown("Detail")
	isPass = selectComboBoxItem(objDropDown, strDetail)
	Set objDropDown = Nothing
	Call WriteToLog("Pass", "Detail dropdown is set with value: " &strDetail)
	
	'Only if the Reason is Patient Request, Supporting Details dropdown will be displayed.
	If strReason = "Patient Request" Then
		Set objDropDown = getTerminatePatientDropDown("Supporting Details")
		isPass = selectComboBoxItem(objDropDown, strSupportingDetails)
		Set objDropDown = Nothing
		Call WriteToLog("Pass", "Supporting Details dropdown is set with value:" &strSupportingDetails )
	End If

	
	wait 10
	
'	Set objDetails = objPage.WebButton("html id:=notified", "index:=1")
'	Call selectComboBoxItem(objDetails, "Patient Request")
'	wait 5
'	Set objSupportingDetails = objPage.WebButton("html id:=notified", "index:=2")
'	Call selectComboBoxItem(objSupportingDetails, "Don't need")
	Execute "Set objSaveBtn = " & Environment("WB_PatientTerminateSave")
	objSaveBtn.Click
	
	Call WriteToLog("Pass", "Save button was clicked successfully." )
	wait 5
	Call waitTillLoads("Loading...")
	
	isPass = checkForPopup("Your changes have been saved successfully.", "Ok", "Member has been Termed.", strOutErrorDesc)
	If not isPass Then
		Call WriteToLog("Fail", "Failed to terminate the patient.")
		Exit Function
	End If
	
	wait 5
	
	Call WriteToLog("Pass", "Patient was terminated successfully." )
	
	Call WriteToLog("Info","==========Testcase - Verfiy the staus in Patient Profile.==========")
	
	Execute "Set objEnrollmentStatus = " & Environment("WEL_EnrollStatus")
	strPatientStatus = Trim(objEnrollmentStatus.getRoProperty("innertext"))
	
	If strPatientStatus = "Termed" Then
		Call WriteToLog("Pass", "Patient Profile was updated with Eligibility Status: "&strPatientProfileValue )
	Else
		Call WriteToLog("Fail", "Patient Profile was not updated with Eligibility Status as Termed. Current status is: "&strPatientProfileValue )
	End If
	
	
	TerminatePatient = True
	Set objTable = Nothing
	Set objPage = Nothing
End Function

'#######################################################################################################################################################################################################
'Function Name		 : getTerminatePatientDropDown
'Purpose of Function : Purpose of this function is to get the dropdown properties and create an object for the Dropdown in Terminate Patient dialog
'Input Arguments	 : FieldName
'Output Arguments	 : object
'Example of Call	 : Set objDropDown = getTerminatePatientDropDown("Reason")
'Author				 : Sudheer (Modified by Sharmila)
'Date Modified		 : 12-Aug-2015
'#######################################################################################################################################################################################################
Function getTerminatePatientDropDown(ByVal fieldName)
	Err.Clear
	Dim autoId
	Select Case fieldName
		Case "Reason"
			autoId = "terminatePatient.selectedRole"
		Case "Notified By"
			autoId = "terminatePatient.selectedNotifiedBy"
		Case "Detail"
			autoId = "terminatePatient.selectedDetail"
		Case "Supporting Details"
			autoId = "terminatePatient.selectedSupportingTermDetail"
	End Select
	Set objPage = getPageObject()
	Set desc = Description.Create
	desc("micclass").Value = "WebElement"
	desc("class").Value = "dropdown"
	
	Set objDesc = objPage.ChildObjects(desc)
	For i = 0 To objDesc.Count - 1
		outerhtml = objDesc(i).GetROPRoperty("outerhtml")
		If instr(outerhtml, autoId) > 0 Then
			objDesc(i).highlight
			Set getTerminatePatientDropDown = objDesc(i)
		End If
	Next 
		
	Set desc = Nothing
	Set objDesc = Nothing
	Set objPage = Nothing	
End Function


'***********************************************************************************************************************************************************************
' Function Name 			: AccessInformation
'Purpose of Function 		: Different scenarios covered in this function:
' 	                          Scenario 1 - Verify there is any Active Accees
'							  Scenario 2 - When there is a already an Active Access, User cannot add a new Access, it should thrown an error.
'							  Scenario 3 - Verify editing the Active Access to Termed
'							  Scenario 4 - Add New Access
'							  Scenario 5 - Verfiy the Access History for Newly added Access
'							  Scenario 6 - When user adds, more than 3 Inactive Access, it should display an error message. 
'Input Arguments            : strOutErrorDesc
'Output Arguments  			: strOutErrorDesc - String for returning the error messages.
'Pre-requisite				: This function occurs in the AccessManagement Screen (Clinical Management->Access)
' Pre-requisites(if any)    : None
' Author                    : Sharmila
' Date                      : 29-JUL-2015
'***********************************************************************************************************************************************************************

Function AccessInformation(strOutErrorDesc)
		
		strOutErrorDesc = ""
		Err.Clear
	    On Error Resume Next
		AccessInformation = False
		
		'=========================
		'Variable initialization
		'=========================
		
		strAccessType = DataTable.Value("AccessType","CurrentTestCaseData")   			'Access Type
		strAccessStatus = DataTable.Value("AccessStatus","CurrentTestCaseData") 		'Access Status
		strSideValue = DataTable.Value("SideValue","CurrentTestCaseData")			  	'Side value
		strRegionValue = DataTable.Value("RegionValue","CurrentTestCaseData")			'Reason value
		strExtremityValue = DataTable.Value("ExtremityValue","CurrentTestCaseData")	  	'Extremity Value
		strPopupTitle = DataTable.Value("PopupTitle","CurrentTestCaseData")	  			'Popup Title
		strSavePopupText = DataTable.Value("ChangesSaveText","CurrentTestCaseData") 	'Changes Saved Text
		
		'=====================================
		'Objects required for test execution
		'=====================================
		Execute "Set objAccessManagementScreen = "  &Environment("WEL_AccessManagement_ScreenTitle") 'Access Management screen title
		Execute "Set objAccessInformationTab = "  &Environment("WEL_AccessManagement_AccessInformationTab") 'Access Information tab
		Execute "Set objCancelButton = "  &Environment("WEL_AccessManagement_CancelButton") 'Cancel button
		intWaitTime =Environment.Value("WaitTime") 
	
	
		'=======================================================
		'Verify that Access management screen open successfully
		'=======================================================
		Call WriteToLog("Info","==========Testcase - Verify Access management screen open successfully. ==========")
		
		
		If not waitUntilExist(objAccessManagementScreen, intWaitTime/2) Then	
			Call WriteToLog("Fail","Expected Result:Access management screen opened successfully; Actual Result: Access management screen not opened successfully")
			Exit Function
		End If
		
		objAccessManagementScreen.highlight
		Call WriteToLog("Pass","Access management screen opened successfully")
		
		
		''=========================================================================
		''Verify that Access Information section exist in Access management screen 
		''=========================================================================
		'objAccessInformationTab.highlight
		'If not waitUntilExist(objAccessInformationTab, intWaitTime/2) Then
		'	Call WriteToLog("Fail","Expected Result:Access Information section exists; Actual result: Access Information section does not exist on Access management")
		'	Call WriteLogFooter()
		'	ExitAction
		'End If
		'
		'Call WriteToLog("info","Access Information section exist on Access Management Screen")
		'
		''================================
		''Click on Access information tab 
		''================================
		'blnReturnValue = ClickButton("Access information tab",objAccessInformationTab,strOutErrorDesc)
		'Wait intWaitTime/4
		'If not blnReturnValue Then
		'	Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
		'	Call WriteLogFooter()
		'	ExitAction
		'End If
		
		
		
		'====================================================================
		'Check number of Access hitory present on Access information screen
		'====================================================================
		Set objAccessInformationHistory = GetChildObject("micclass;class;html id;innerhtml","WebElement;.*access-tab-gradient.*;.*AH_.*;.*showAccessHistoryInfo.*")
		intAccessInformationHistoryCount = objAccessInformationHistory.Count
		
		'==================================================================================================
		'Verify if there is already Active Access exists, then term the existing and then Add a new Access
		'==================================================================================================
		print intAccessInformationHistoryCount
		
		If intAccessInformationHistoryCount >0 Then
			'For each Access item, verify any of the Access items are still active.
			For i = 0 To intAccessInformationHistoryCount-1 Step 1
				objAccessInformationHistory(i).click
				Wait intWaitTime/5
				Set objAccessBlock = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("class:=dialysis-info-block")
				Set ObjRowDesc = Description.Create
				ObjRowDesc("micclass").Value = "WebElement"
				ObjRowDesc("class").Value = "dialysis-info-row"
				Set objRow = objAccessBlock.ChildObjects(ObjRowDesc)
				strAccessStatusCurrentValue =  objRow(3).WebElement("index:=1").getROProperty("innertext")
				print strAccessStatusCurrentValue 
				
				Call WriteToLog("info", "=============Testcase - Verify if there is any Active Access exists, Add a new Access with status Active should thrown an error================")
				If trim(strAccessStatusCurrentValue) = "Active" Then
					'Try adding a new Access, when already there is an Active Access, It should thrown an error message
					
					'===========================================================
					'Click on Add button and Add the Access Status as Active
					'===========================================================
					Call WriteToLog("info", "=============Testcase - Adding a new Access to a patient. ================")
					'Once terming the existing Access, Add a new Access
					blnReturnValue = AccessAdd("Active",strOutErrorDesc)
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					If not blnReturnValue Then
						Call WriteToLog("Fail","Expected Result:User was able to Edit the Access; Actual Result: Error was returned:" &strOutErrorDesc)
						Exit Function
					End If
					
					strPopupMessage = "We already have an Active Access."
					'===================================================
					'Verify that validation error popup is displayed
					'===================================================
					blnReturnValue = checkForPopup("Invalid Data", "Ok", strPopupMessage, strOutErrorDesc)
					'blnReturnValue = CheckMessageBoxExist(objPopupTitle,strPopupTitle,objPopupText,strSavePopupText,"WB_OK","yes",strOutErrorDesc)
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					If blnReturnValue Then
						Call WriteToLog("Pass","Validation Error message: We already have an Active Access was dispalyed")
					Else
						Call WriteToLog("Fail","Expected Result: Validation Error message should be displayed; Actual Result: Error return: "&strOutErrorDesc)
						Exit Function
					End If
					
					'======================
					'Click on Cancel button
					'======================
					blnReturnValue = ClickButton("Cancel",objCancelButton,strOutErrorDesc)
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					If not blnReturnValue Then
						Call WriteToLog("Fail","Expected Result: Cancel Button Was clicked.;Actual Result: Cancel Button returned: "&strOutErrorDesc)
						Exit Function
					End If
					
					'==========================================
					'Click on Edit button and Edit the Access.
					'==========================================
					Call WriteToLog("info", "=============Testcase - Verify the Edit functionality by Editing a Access. ================")
					
					blnReturnValue = AccessEdit(strOutErrorDesc)
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					If not blnReturnValue Then
						Call WriteToLog("Fail","Expected Result:User was able to Edit the Access; Actual Result: Error was returned:" &strOutErrorDesc)
						Exit Function
					End If
					Exit For
				End If
				Execute "Set objAccessBlock = Nothing"  
				Execute "Set ObjRowDesc = Nothing"  
				
			Next
			
			Execute "Set objAccessInformationHistory = Nothing"
			intAccessInformationHistoryCount = 0	
		
			'==================================================================================================================
			'Verify user cannot save Access with ACCESS STATUS as INACTIVE when there is already 3 INACTIVE Access Entries.
			'==================================================================================================================
			Call WriteToLog("info", "=============Testcase - Verify user cannot save Access with ACCESS STATUS as INACTIVE when there is already 3 INACTIVE Access Entries.================")
			
			Set objAccessInformationHistory = GetChildObject("micclass;class;html id;innerhtml","WebElement;.*access-tab-gradient.*;.*AH_.*;.*showAccessHistoryInfo.*")
			intAccessInformationHistoryCount = objAccessInformationHistory.Count
			'Inactive value count
			intInactiveCount = 0
			For i = 0 To intAccessInformationHistoryCount-1 Step 1
				objAccessInformationHistory(i).click
				wait intWaitTime/4
				Set objAccessBlock = Browser("name:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella").WebElement("class:=dialysis-info-block")
				Set ObjRowDesc = Description.Create
				ObjRowDesc("micclass").Value = "WebElement"
				ObjRowDesc("class").Value = "dialysis-info-row"
				Set objRow = objAccessBlock.ChildObjects(ObjRowDesc)
				strAccessStatusCurrentValue =  objRow(3).WebElement("index:=1").getROProperty("innertext")
				print strAccessStatusCurrentValue 
				If trim(strAccessStatusCurrentValue) = "InActive" Then
					intInactiveCount = intInactiveCount + 1
				End If
				Execute "Set objAccessBlock = Nothing"  
				Execute "Set ObjRowDesc = Nothing"  
			Next
			
			'===========================================================================================================================================================
			'If the active count is greater than 0, then add more than 3 Access with status INACTIVE, It should thrown an error for 4th Access with status 'InActive'
			'===========================================================================================================================================================
			If intInactiveCount > 0 Then
				intInactiveCount = intInactiveCount + 1
				For i = intInactiveCount To 4 Step 1
					'==========================================
					'Click on Add button and Add a new Access.
					'==========================================
					Call WriteToLog("info", "=============Testcase - Adding a new Access to a patient. ================")
					'Once terming the existing Access, Add a new Access
					blnReturnValue = AccessAdd("InActive", strOutErrorDesc)
					Wait 2
					waitTillLoads "Loading..."
					wait 2
					If not blnReturnValue Then
						Call WriteToLog("Fail","Expected Result:User was able to Edit the Access; Actual Result: Error was returned:" &strOutErrorDesc)
						Exit Function
					End If
					'If count = 4, then validation error message should be displayed, else success message should be displayed.
					If i = 4 Then
						strPopupMessage = "Cannot add more than 3 Inactive Access for members."
						'===================================================
						'Verify that validation error popup is displayed
						'===================================================
						blnReturnValue = checkForPopup("Invalid Data", "Ok", strPopupMessage, strOutErrorDesc)
						Wait 2
					    waitTillLoads "Loading..."
					    wait 2
						If blnReturnValue Then
							Call WriteToLog("Pass","Validation Error message:  "& strPopupMessage & " was dispalyed")
						Else
							Call WriteToLog("Fail","Expected Result: Validation Error message should be displayed; Actual Result: Error return: "&strOutErrorDesc)
							Exit Function
						End If
						'======================
						'Click on Cancel button
						'======================
						blnReturnValue = ClickButton("Cancel",objCancelButton,strOutErrorDesc)
						Wait 2
					    waitTillLoads "Loading..."
					    wait 2
						If not blnReturnValue Then
							Call WriteToLog("Fail","Expected Result: Cancel Button Was clicked.;Actual Result: Cancel Button returned: "&strOutErrorDesc)
							Exit Function
						End If
					Else
						'====================================================================================================
						'Verify that Success message stating 'Changes saved successfully.' should get displayed
						'====================================================================================================
						blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)
						'blnReturnValue = CheckMessageBoxExist(objPopupTitle,strPopupTitle,objPopupText,strSavePopupText,"WB_OK","yes",strOutErrorDesc)
						Wait 2
					    waitTillLoads "Loading..."
					    wait 2
						If blnReturnValue Then
							Call WriteToLog("Pass","Success message stating: "&strSavePopupText&" found successfully")
						Else
							Call WriteToLog("Fail","CheckMessageBoxExist return: "&strOutErrorDesc)
							Exit Function
						End If
					End If
				Next
			End If
			
			'=======================================================
			'Click on Add button and Add a new Access status Active.
			'=======================================================
			Call WriteToLog("info", "=============Testcase - Adding a new Access to a patient. ================")
			'Once terming the existing Access, Add a new Access
			blnReturnValue = AccessAdd("Active",strOutErrorDesc)
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			If not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result:User was able to Edit the Access; Actual Result: Error was returned:" &strOutErrorDesc)
				Exit Function
			End If
		
			'====================================================================================================
			'Verify that Success message stating 'Changes saved successfully.' should get displayed
			'====================================================================================================
			blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)
			'blnReturnValue = CheckMessageBoxExist(objPopupTitle,strPopupTitle,objPopupText,strSavePopupText,"WB_OK","yes",strOutErrorDesc)
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			If blnReturnValue Then
				Call WriteToLog("Pass","Success message stating: "&strSavePopupText&" found successfully")
			Else
				Call WriteToLog("Fail","CheckMessageBoxExist return: "&strOutErrorDesc)
				Exit Function
			End If
			
		
			Execute "Set objAccessInformationHistory = Nothing"
			intAccessInformationHistoryCount = 0
			'===============================================
			'Verify the access history Panel for new Access
			'===============================================
			
			Call WriteToLog("info", "=============Testcase - Verify the new access added is displayed in the Access History Panel.================")
			
			Set objAccessInformationHistory = GetChildObject("micclass;class;html id;innerhtml","WebElement;.*access-tab-gradient.*;.*AH_.*;.*showAccessHistoryInfo.*")
			intAccessInformationHistoryCount = objAccessInformationHistory.Count
			strAccessHistoryValue = objAccessInformationHistory(0).getROProperty("innertext")
			strTodayDate = GetDateFormat("mm/dd/yyyy",Date)
			strNewAccess = StrAccessType & " placed " & strTodayDate
			print strNewAccess
			If instr(strAccessHistoryValue, strNewAccess)>0 Then
				Call WriteToLog("Pass", "Access History has the value as: " &strAccessHistoryValue)
			Else
				Call WriteToLog("Fail", "Expected Result: Access History has a new Access added;Actual Result: Value is: " &strAccessHistoryValue)
			End If
			
			
			Execute "Set objAccessInformationHistory = Nothing"
			intAccessInformationHistoryCount = 0
			
			
		Else
		
			'================================================================================================
			'Click on Add button and Add a new Access, When there is no item in the Access History Panel.
			'================================================================================================
			
			Call WriteToLog("info", "=============Testcase - Adding a new Access to a patient. ================")
			'If there is no Access Hitory, then add a new Access.
			blnReturnValue = AccessAdd("Active", strOutErrorDesc)
			Wait 2
			waitTillLoads "Loading..."
			wait 2
			If not blnReturnValue Then
				Call WriteToLog("Fail","Expected Result:User was able to Edit the Access; Actual Result: Error was returned:" &strOutErrorDesc)
				Exit Function
			End If
			
			'====================================================================================================
			'Verify that Success message stating 'Changes saved successfully.' should get displayed
			'====================================================================================================
			blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)
			'blnReturnValue = CheckMessageBoxExist(objPopupTitle,strPopupTitle,objPopupText,strSavePopupText,"WB_OK","yes",strOutErrorDesc)
			Wait 2
				waitTillLoads "Loading..."
			wait 2
			If blnReturnValue Then
				Call WriteToLog("Pass","Success message stating: "&strSavePopupText&" found successfully")
			Else
				Call WriteToLog("Fail","CheckMessageBoxExist return: "&strOutErrorDesc)
				Exit Function
			End If
			
			'===============================================
			'Verify the access history Panel for new Access
			'===============================================
			Call WriteToLog("info", "=============Testcase - Verify the new access added is displayed in the Access History Panel.================")
			Set objAccessInformationHistory = GetChildObject("micclass;class;html id;innerhtml","WebElement;.*access-tab-gradient.*;.*AH_.*;.*showAccessHistoryInfo.*")
			intAccessInformationHistoryCount = objAccessInformationHistory.Count
			strAccessHistoryValue = objAccessInformationHistory(0).getROProperty("innertext")
			strTodayDate = GetDateFormat("mm/dd/yyyy",Date)
			strNewAccess = StrAccessType & " placed " & strTodayDate
			print strNewAccess
			If instr(strAccessHistoryValue, strNewAccess)>0 Then
				Call WriteToLog("Pass", "Access History has the value as: " &strAccessHistoryValue)
			Else
				Call WriteToLog("Fail", "Expected Result: Access History has a new Access added;Actual Result: Value is: " &strAccessHistoryValue)
			End If
			Execute "Set objAccessInformationHistory = Nothing"
		
		End If
		
		AccessInformation = true
		
		Execute "Set objAccessManagementScreen = Nothing"  
		Execute "Set objAccessInformationTab = Nothing"  
		Execute "Set objCancelButton = Nothing" 

End Function


'===========================================================================================================================================================
'Function Name       :	AccessEdit
'Purpose of Function :	If there is any active Access, then term that Access and Add a new access for that patient.
'Input Arguments     :	strOutErrorDesc
'Output Arguments    :	Returns boolean value
'					 :  strOutErrorDesc - String for returning the error messages.
'Pre-requisite		 :  This function occurs in the AccessManagement Screen
'Example of Call     :	AccessEdit
'Author				 :  Sharmila
'Date				 :	31-July-2015
'===========================================================================================================================================================

Function AccessEdit(strOutErrorDesc)
	
	strOutErrorDesc = ""
	Err.Clear
    On Error Resume Next
	AccessEdit = False
	
	'Object Intialization
	Execute "Set objEditButton = "  &Environment("WEL_AccessManagement_EditButton") 'Edit button
	Execute "Set objTerminateDate = "  &Environment("WE_AccessManagement_TerminateDate") 'Access information > Terminate Date
	Execute "Set objSaveButton = "  &Environment("WEL_AccessManagement_SaveButton")	 'Add button
	Execute "Set objAccessStatus = "  &Environment("WEL_AccessManagement_AccessInformation_AccessStatus") 'Access Status
	Execute "Set objTerminatedReason = "  &Environment("WEL_AccessManagement_AccessInformation_TerminateReason") 'Access Terminated Reason
	intWaitTime =Environment.Value("WaitTime")
		
	'Variable Intilaization
	strTerminateReason = DataTable.Value("TerminateReason","CurrentTestCaseData") 	'Terminate Reason

	strPopupTitle = DataTable.Value("PopupTitle","CurrentTestCaseData")	  			'Popup Title
	strSavePopupText = DataTable.Value("ChangesSaveText","CurrentTestCaseData") 	'Changes Saved Text

	'Click on Edit button, To term the patient.
	blnReturnValue = ClickButton("Edit",objEditButton,strOutErrorDesc)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If not blnReturnValue Then
		Call WriteToLog("Fail","Expected Result: Add button was clicked; Actual Result: Add button returned error: "&strOutErrorDesc)
		Exit function
	End If
	
	
	'=======================================
	'Select Access Status Value as Termed
	'=======================================
	blnReturnValue = selectComboBoxItem(objAccessStatus,"Termed")
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If blnReturnValue Then
		Call WriteToLog("Pass",strAccessStatus&" is selected in Access status drop down")
	Else
		Call WriteToLog("Fail","Expected Result: Access Status value is selected; Actual Result: Error returned: "&strOutErrorDesc)
		Exit function
	End If
	
	'==============================
	'Select Terminate reason value
	'==============================
	blnReturnValue = selectComboBoxItem(objTerminatedReason,strTerminateReason)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If blnReturnValue Then
		Call WriteToLog("Pass",strTerminateReason& " is selected in Terminate Reason drop down")
	Else
		Call WriteToLog("Fail","Expected Result:Terminated Reason value is selected; Actual Result: Error returned: "&strOutErrorDesc)
		Exit Function
	End If

	'==================
	'Set Terminated Date
	'===================
	Err.Clear
	objTerminateDate.Set Date
	If Err.Number<>0 Then
		Call WriteToLog("Fail", "Expected Result: Date Terminated value is set; Actual Result: Error returned: "&Err.Description)
		Exit Function
	End If
	
	'====================
	'Click on Save button
	'====================
	blnReturnValue = ClickButton("Save",objSaveButton,strOutErrorDesc)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If not blnReturnValue Then
		Call WriteToLog("Fail","Expected Result: Save Button Was clicked.;Actual Result: Save Button returned: "&strOutErrorDesc)
		Exit Function
	End If
	
	'====================================================================================================
	'Verify that Success message stating 'Changes saved successfully.' should get displayed
	'====================================================================================================
	blnReturnValue = checkForPopup(strPopupTitle, "Ok", strSavePopupText, strOutErrorDesc)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	'blnReturnValue = CheckMessageBoxExist(objPopupTitle,strPopupTitle,objPopupText,strSavePopupText,"WB_OK","yes",strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Success message stating: "&strSavePopupText&" found successfully")
	Else
		Call WriteToLog("Fail","CheckMessageBoxExist return: "&strOutErrorDesc)
		Exit Function
	End If
	
	Wait intWaitTime/4
	
	AccessEdit = true
	
	
	Execute "Set objEditButton = Nothing"  
	Execute "Set objTerminateDate = Nothing"  
	Execute "Set objSaveButton = Nothing"  
	Execute "Set objTerminatedReason = Nothing"  
		
	
	
End Function


'===========================================================================================================================================================
'Function Name       :	AccessAdd
'Purpose of Function :	Add a new access for any member patient.
'Input Arguments     :	strStatus - to pass the Access Status: Active, Termed, Inactive
'						strOutErrorDesc 
'Output Arguments    :	Returns boolean value
'					 :  strOutErrorDesc - String for returning the error messages.
'Pre-requisite		 :  This function occurs in the AccessManagement Screen
'Example of Call     :	AccessEdit
'Author				 :  Sharmila
'Date				 :	31-July-2015
'===========================================================================================================================================================

Function AccessAdd(StrStatus, strOutErrorDesc)
	
		strOutErrorDesc = ""
		Err.Clear
	    On Error Resume Next
		AccessAdd = False
		
		'Object Intialization
		Execute "Set objAddButton = "  &Environment("WEL_AccessManagement_AddButton")	 'Add button
		Execute "Set objPlacedDate = "  &Environment("WE_AccessManagement_PlacedDate") 'Access information > Placed Date
		Execute "Set objSaveButton = "  &Environment("WEL_AccessManagement_SaveButton")	 'Add button
		Execute "Set objAccessType = "  &Environment("WEL_AccessManagement_AccessInformation_AccessType")	 'Access Type Dropdown
		Execute "Set objAccessStatus = "  &Environment("WEL_AccessManagement_AccessInformation_AccessStatus") 'Access Status
		Execute "Set objAccessSide = "  &Environment("WEL_AccessManagement_AccessInformation_Side") 'Access Side
		Execute "Set objAccessRegion= "  &Environment("WEL_AccessManagement_AccessInformation_Region") 'Access Extremity
		Execute "Set objAccessExtremity = "  &Environment("WEL_AccessManagement_AccessInformation_Extremity") 'Access Extremity
		Execute "Set objDateActivated = "  &Environment("WE_AccessManagement_ActivatedDate") 'Est. Date Activated
		Execute "Set objInActiveReason = "  &Environment("WEL_AccessManagement_AccessInformation_InActiveReason") 'InActive Reason dropdown
		Execute "Set objDateInActivated = "  &Environment("WE_AccessManagement_InActiveDate") 'Est. Date InActivated
		intWaitTime =Environment.Value("WaitTime")
		
		'Variable Initialization
		strAccessType = DataTable.Value("AccessType","CurrentTestCaseData")   			'Access Type
		strSideValue = DataTable.Value("SideValue","CurrentTestCaseData")			  	'Side value
		strRegionValue = DataTable.Value("RegionValue","CurrentTestCaseData")			'Reason value
		strExtremityValue = DataTable.Value("ExtremityValue","CurrentTestCaseData")	  	'Extremity Value
		strPopupTitle = DataTable.Value("PopupTitle","CurrentTestCaseData")	  			'Popup Title
		strSavePopupText = DataTable.Value("ChangesSaveText","CurrentTestCaseData") 	'Changes Saved Text
		
		
		'=====================
		'Click on Add button
		'=====================
		blnReturnValue = ClickButton("Add",objAddButton,strOutErrorDesc)
		Wait 2
		waitTillLoads "Loading..."
		wait 2
		If not blnReturnValue Then
			Call WriteToLog("Fail","Expected Result: Add button was clicked; Actual Result: Add button returned error: "&strOutErrorDesc)
			Exit Function
		End If
		
		'==========================
		'Select Access type value
		'==========================
		objAccessType.highlight
		blnReturnValue = selectComboBoxItem(objAccessType,strAccessType)
		Wait intWaitTime/4
		If blnReturnValue Then
			Call WriteToLog("Pass",strAccessType& " is selected in Access type drop down")
		Else
			Call WriteToLog("Fail","Expected Result: Access type is selected; Actual Result: Unable to select Access Type. Error return: "&strOutErrorDesc)
			Exit Function
		End If
		
					
		'================
		'Set Placed date
		'================
		Err.Clear
		objPlacedDate.Set Date
		If Err.Number<>0 Then
			strOutErrorDesc = Err.Description
			Call WriteToLog("Fail", "Expected Result: Place Date is set; Actual Result: Error returned: "&strOutErrorDesc)
			Exit Function
		End If
		
		'===========================
		'Select Access Status Value
		'===========================
		blnReturnValue = selectComboBoxItem(objAccessStatus,StrStatus)
		Wait intWaitTime/4
		If blnReturnValue Then
			Call WriteToLog("Pass",StrStatus&" is selected in Access status drop down")
		Else
			Call WriteToLog("Fail","Expected Result: Access Status value is selected; Actual Result: Error returned: "&strOutErrorDesc)
			Exit Function
		End If
		
		Select Case strStatus
			Case "Active"
				
				'Set only Est. Date Activated
				'===================
				'Set Activated Date
				'===================
				Err.Clear
				objDateActivated.Set Date
				If Err.Number<>0 Then
					strOutErrorDesc = Err.Description
					Call WriteToLog("Fail", "Expected Result: Date Activated value is set; Actual Result: Error returned: "&strOutErrorDesc)
					Exit Function
				End If
					
			Case "InActive"
			
				'Set Est. Date InActivated and Inactive Reason
				
				'=====================
				'Set Inactivated Date
				'=====================
				Err.Clear
				objDateInActivated.Set Date
				If Err.Number<>0 Then
					Call WriteToLog("Fail", "Expected Result: Date InActivated value is set; Actual Result: Error returned: "&Err.Description)
					Exit Function
				End If
				
				'==============================
				'Select Terminate reason value
				'==============================
				blnReturnValue = selectComboBoxItem(objInActiveReason,"Infection")
				Wait intWaitTime/4
				If blnReturnValue Then
					Call WriteToLog("Pass","Value is selected in Inactivated Reason drop down")
				Else
					Call WriteToLog("Fail","Expected Result:Inactivated Reason value is selected; Actual Result: Error returned: "&strOutErrorDesc)
					Exit Function
				End If
			
				
				
		End Select
		
		'===================
		'Select side value
		'===================
		blnReturnValue = selectComboBoxItem(objAccessSide,strSideValue)
		Wait intWaitTime/4
		If blnReturnValue Then
			Call WriteToLog("Pass",strSideValue&" is selected in Side drop down")
		Else
			Call WriteToLog("Fail","Expected Result: Access Side value is selected; Actual Result: Error returned: "&strOutErrorDesc)
			Exit Function
		End If
		
		'====================
		'Select Region value
		'====================
		blnReturnValue = selectComboBoxItem(objAccessRegion,strRegionValue)
		Wait intWaitTime/4
		If blnReturnValue Then
			Call WriteToLog("Pass",strRegionValue& " is selected in reason drop down")
		Else
			Call WriteToLog("Fail","Expected Result: Access Region value is selected; Actual Result: Error returned: "&strOutErrorDesc)
			Exit Function
		End If
		
		'======================
		'Select Extremity value
		'======================
		blnReturnValue = selectComboBoxItem(objAccessExtremity,strExtremityValue)
		Wait intWaitTime/4
		If blnReturnValue Then
			Call WriteToLog("Pass",strExtremityValue & "is selected in Extremity drop down")
		Else
			Call WriteToLog("Fail","Expected Result: Access Extremity value is selected; Actual Result: Error returned: "&strOutErrorDesc)
			Exit Function
		End If
		
			
		'====================
		'Click on Save button
		'====================
		blnReturnValue = ClickButton("Save",objSaveButton,strOutErrorDesc)
		Wait 2
		waitTillLoads "Loading..."
		wait 2
		If not blnReturnValue Then
			Call WriteToLog("Fail","Expected Result: Save Button Was clicked.;Actual Result: Save Button returned: "&strOutErrorDesc)
			Exit Function
		End If
		
			
		AccessAdd = true
		
		Execute "Set objAddButton = Nothing" 
		Execute "Set objPlacedDate = Nothing"  
		Execute "Set objSaveButton = Nothing"  
		Execute "Set objAccessType = Nothing"  
		Execute "Set objAccessStatus = Nothing"  
		Execute "Set objAccessSide = Nothing"  
		Execute "Set objAccessRegion= Nothing"  
		Execute "Set objAccessExtremity = Nothing"  
		Execute "Set objInActiveReason = Nothing"  
		Execute "Set objDateInActivated = Nothing"
		
End Function
'===========================================================================================================================================================
'Function Name       :	selectComboBoxItemMyDashBoard
'Purpose of Function :	Select the status for My Patient Census
'Input Arguments     :	combobox object, item to be clicked
'Output Arguments    :	Returns boolean value
'Pre-requisite		 :  MYDashboard page should be opened
'Example of Call     :	call selectComboBoxItemMyDashBoard(objCombo, "All")
'Author				 :  Sudheer
'Date				 :	10-Aug-2015
'===========================================================================================================================================================
Function selectComboBoxItemMyDashBoard(ByVal objComboBox, ByVal itemToClick)
	On Error Resume Next
	Err.Clear
	
	selectComboBoxItemMyDashBoard = true
		
	Dim isListItem : isListItem = True
	Set objPage = getPageObject()	
	
	Dim objClass
	objClass = objComboBox.getROProperty("micclass")
	
	Select Case objClass
		
		Case "WebElement"
			objComboBox.Click
			
		Case "WebButton"
			objComboBox.Click
			
	End Select
	
	wait 2
	Set objDropDown = objPage.WebElement("class:=k-list-container.*","html tag:=DIV","visible:=true", "html id:=censusFilterDDL-list")
	
	Set itemDesc = Description.Create
	itemDesc("micclass").Value = "WebElement"
	itemDesc("class").Value = ".*k-item.*"
	itemDesc("html tag").Value = "LI"
	itemDesc("outertext").Value = ".*" & itemToClick & ".*"
	
	Set objItems = ObjDropDown.ChildObjects(itemDesc)
		
	if objItems.Count = 0 Then
		Print "No such item exists"
		sendKeys("{ESC}")
		selectComboBoxItemMyDashBoard = false
		Set objItems = Nothing
		Set objDropDown = Nothing
		Set objCombo = Nothing
		Set objPage = Nothing
		Exit Function
	End If
	Dim clicked : clicked = false
	
	For i = 0 To objItems.Count - 1
		uitext = objItems(i).getROProperty("outertext")
		If Ucase(trim(uitext)) = Ucase(trim(itemToClick)) Then
			objItems(i).Click
			clicked = true
			Exit For
		End If
	Next	

	If not clicked Then
		Print "Item does not exist to click"
		sendKeys("{ESC}")
		selectComboBoxItemMyDashBoard = false
	End If
	wait 2
	Set objItems = Nothing
	Set objDropDown = Nothing
	Set objCombo = Nothing
	Set objPage = Nothing
	
End Function

'===========================================================================================================================================================
'Function Name       :	SelectRequiredRoster
'Purpose of Function :	To discharge a patient with required values
'Input Arguments     :	strReqRoster: string value representing required roster name
'Output Arguments    :	Boolean value: Indicating whether the patient is discharged with required values
'					 :  strOutErrorDesc:String value which contains detail error message occurred (if any) during function execution
'Example of Call     :	blnSelectRequiredRoster = SelectRequiredRoster(strReqRoster, strOutErrorDesc)
'Author              :	Gregory
'Date                : 	07August2015
'===========================================================================================================================================================
Function SelectRequiredRoster(ByVal strReqRoster, strOutErrorDesc)
    
    strOutErrorDesc = ""
    Err.Clear
    On Error Resume Next
    SelectRequiredRoster = False
    
    'Create Object required for SelectRequiredRoster function
    Execute "Set objPageForSR = "&Environment("WPG_AppParent")
    Execute "Set objSwitchUserIcon = " & Environment.Value("WI_SwitchUser_SwitchUserIcon")
    Execute "Set objMyRosterBtn = " & Environment.Value("WB_SwitchUser_MyRosterBtn")
    Execute "Set objCloseIcon = " & Environment.Value("WI_SwitchUser_CloseIcon")
    Execute "Set objSelectUserTable = " & Environment("WT_SelectUserTable")  
	Execute "Set objSwitchRosterBtn = " & Environment("WB_SwitchRosterBtn")  
	Execute "Set objSwitchRosterBlockPP = " & Environment("WEL_SwitchRosterBlockPP") 
	Execute "Set objSwitchRosterBlkPPokBtn = " & Environment("WB_SwitchRosterBlkPPokBtn")  
	Execute "Set objRosterName = " & Environment("WEL_RosterName") 	
	Execute "Set objUnsavedPPokBtn = " & Environment("WB_UnsavedPPokBtn")
    
    'first select MyRoster
	blnSelectRoster = SelectUserRoster(strOutErrorDesc)	
	If Not blnSelectRoster Then
		strOutErrorDesc = "Select Roster returned error: "&strOutErrorDesc
		Exit Function 
	End If
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
    
    strReqRoster = Ucase(strReqRoster)
	strCurrentRosterReqd = Replace(strReqRoster," ","",1,-1,1) 'required roster
	strCurrentRosterFromApp = Ucase(Replace((objRosterName.GetROProperty("outertext"))," ","",1,-1,1))	'current roster
	
	If Instr(1,strCurrentRosterFromApp,strCurrentRosterReqd,1) <= 0 then	'if required and current rosters not match
	
		'Check the existence of the Switch User icon
		If not objSwitchUserIcon.Exist(5) Then
	         strOutErrorDesc = "Switch User icon does not exist"    
	         Exit Function
	    End If
	    
	    'Click on Switch User icon 
	    Set objSwitchUserIcon = Nothing
		Execute "Set objSwitchUserIcon = " & Environment.Value("WI_SwitchUser_SwitchUserIcon")	    
	    blnReturnValue = ClickButton("Switch User", objSwitchUserIcon,strOutErrorDesc)
	    If not(blnReturnValue) Then
	        strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
	        Exit Function    
	    End If
	    Wait 3
		Call waitTillLoads("Loading...")
		Wait 2
		
	    Setting.WebPackage("ReplayType") = 2
		intSU_rc = objSelectUserTable.RowCount
		For intRC = 1 To intSU_rc Step 1
			Set objRosterField = objSelectUserTable.ChildItem(intRC,intCC,"WebElement",0)
			If Ucase(Trim(objRosterField.GetROProperty("outertext"))) = Ucase(Trim(strReqRoster)) Then	'select required roster
			print objRosterField.GetROProperty("outertext")
			    objRosterField.FireEvent "onClick"
				Exit For
			Else
				SelectRequiredRoster = False
			End If
		Next
		Setting.WebPackage("ReplayType") = 1 
	   
	    'Check the existence of Switch Roster button 
	    If objSwitchRosterBtn.Exist(5) Then
	        'Click on the Switch Roster button
	        blnReturnValue = ClickButton("Switch Roster",objSwitchRosterBtn,strOutErrorDesc)
	        If not(blnReturnValue) Then
	            strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
	            Exit Function    
	        End If
	    End If
	     
		'If app blocks switch roster because of open patients, close all patients and then switch the roster	     
	    If objSwitchRosterBlockPP.Exist(3) Then
	       blnReturnValue = ClickButton("OK",objSwitchRosterBlkPPokBtn,strOutErrorDesc)
	       If not(blnReturnValue) Then
	      		strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
	         	Exit Function    
	       End If
	       Wait 1
	       
		 	'Close all open patients 
			blnCloseAllPats = CloseAllOpenPatient(strOutErrorDesc)
			If Not blnCloseAllPats Then
				strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
				Exit Function 
			End If
			
			Set objSwitchRosterBlockPP = Nothing
	   		Set objSwitchRosterBlkPPokBtn = Nothing
	   		
		    Call SelectRequiredRoster(strReqRoster, strOutErrorDesc)
			
		End If
		
		'If Unsaved popup msg exists and patients are not closed in selected roster, then close all patients
		If objUnsavedPPokBtn.Exist(5) Then
		    blnReturnValue = ClickButton("OK", objUnsavedPPokBtn,strOutErrorDesc)
		    If not(blnReturnValue) Then
	        	strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
	       		Exit Function    
	   		End If
			'Close all open patients 
			blnCloseAllPats = CloseAllOpenPatient(strOutErrorDesc)
			If Not blnCloseAllPats Then
				strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
				Exit Function 
			End If	
		End If
		
	End If	
	
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
	
	SelectRequiredRoster = True
   
   	Set objPageForSR = Nothing
  	Set objSwitchUserIcon = Nothing
    Set objMyRosterBtn = Nothing
    Set objCloseIcon = Nothing
    Set objSelectUserTable = Nothing
	Set objSwitchRosterBtn = Nothing  
	Set objRosterField = Nothing
	Set objSwitchRosterBlockPP = Nothing
	Set objSwitchRosterBlockPP = Nothing
    
End Function

Function ScheduleCalendarSpecific(Byval requiredDate, strOutErrorDesc)

On Error Resume Next
ScheduleCalendarSpecific = False

	Execute "Set objSchCallInfoHeader = " & Environment("WEL_SchCallInfoHeader")

	reqDD = Split(requiredDate,"/")
	
	reqMonth = Cint(reqDD(0)) 'CInt("05")
	reqYear = CInt(reqDD(2))
	reqDate = CInt(reqDD(1))
	
	If Year(Now()) > reqYear Then
		strOutErrorDesc = "Schedule date cannot be less than today's date"
		Exit Function		
	ElseIf Month(Now()) > reqMonth Then
		strOutErrorDesc = "Schedule date cannot be less than today's date"
		Exit Function
	ElseIf Day(Now()) > reqDate Then
		strOutErrorDesc = "Schedule date cannot be less than today's date"
		Exit Function
	End If
	
	Set objPage = getPageObject()
	
	'get the parent object	
	Set objParent = objpage.WebElement("html id:=scheduler","html tag:=DIV")
	
	'click on Month to get month view
	Set objMonth = objParent.Link("html tag:=A","innertext:=Month")
	objMonth.Click
	Set objMonth = Nothing
	
	
	'change the month to required month
	uiMonthYear = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL").getROProperty("innertext")
	uiYear = Cint(Trim(Split(uiMonthYear,",")(1)))
		
	If uiYear <> reqYear Then
	
		Do while (uiYear = reqYear) = False
			If reqYear > uiYear Then
				Set objRightArrow = objParent.Link("html tag:=A", "innerhtml:=.*k-icon k-i-arrow-e.*")
				objRightArrow.Click
				wait 1
				Set objM = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL")
				uiMonthYear = objM.getROProperty("innertext")
				uiYear = CInt(Trim(Split(uiMonthYear,",")(1)))
				Set objRightArrow = Nothing
			ElseIf reqYear < uiYear Then
				Set objLeftArrow = objParent.Link("html tag:=A", "innerhtml:=.*k-icon k-i-arrow-w.*")
				objLeftArrow.Click
				wait 1
				Set objM = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL")
				uiMonthYear = objM.getROProperty("innertext")
				uiYear = CInt(Trim(Split(uiMonthYear,",")(1)))
				Set objM = Nothing
				Set objLeftArrow = Nothing
			End If
		Loop
	
	End If	
	
	uiMonthYear = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL").getROProperty("innertext")
	uiMonth = Trim(Split(uiMonthYear,",")(0))
	uiMonth = Mid(uiMonth, len("Today")+1)
	
	uiMonthVal = getNumericValueOfMonth(uiMonth)
	
	Do while (reqMonth = uiMonthVal) = False
		
		If reqMonth > uiMonthVal Then
		
			Set objRightArrow = objParent.Link("html tag:=A", "innerhtml:=.*k-icon k-i-arrow-e.*")
			objRightArrow.Click
			wait 1
			Set objM = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL")
			uiMonthYear = objM.getROProperty("innertext")
			uiYear = Trim(Split(uiMonthYear,",")(1))
			uiMonth = Trim(Split(uiMonthYear,",")(0))
			uiMonth = Mid(uiMonth, len("Today")+1)
			
			uiMonthVal = getNumericValueOfMonth(uiMonth)
			Set objM = Nothing
			Set objRightArrow = Nothing
		ElseIf reqMonth < uiMonthVal Then
			Set objLeftArrow = objParent.Link("html tag:=A", "innerhtml:=.*k-icon k-i-arrow-w.*")
			objLeftArrow.Click
			wait 1
			Set objM = objParent.WebElement("class:=k-reset k-scheduler-navigation","html tag:=UL")
			uiMonthYear = objM.getROProperty("innertext")
			uiYear = Trim(Split(uiMonthYear,",")(1))
			uiMonth = Trim(Split(uiMonthYear,",")(0))
			uiMonth = Mid(uiMonth, len("Today")+1)
			
			uiMonthVal = getNumericValueOfMonth(uiMonth)
			Set objM = Nothing
			Set objLeftArrow = Nothing
			
		End If
		
	Loop	
	
	Set dateDesc = Description.Create
	dateDesc("micclass").Value = "WebTable"
	dateDesc("html tag").Value = "TABLE"
	dateDesc("outertext").Value = ".*" & reqDate & ".*"
	dateDesc("class").Value = "k-scheduler-table"
	Set objDate = objParent.WebElement(dateDesc)
	
	Set dayDesc = Description.Create
	dayDesc("micclass").Value = "WebElement"
	dayDesc("class").Value = "monthHeader k-nav-day k-link"
	dayDesc("html tag").Value = "DIV"
	dayDesc("innertext").Value = ".*" & reqDate & ".*"
	dayDesc("innertext").regularexpression = true
	Set objDay = objDate.WebElement(dayDesc)
	
	getX = objDay.getROProperty("abs_x")
	getY = objDay.getROProperty("abs_y")
	
	Set deviceReplay = CreateObject("Mercury.DeviceReplay")
	deviceReplay.MouseDblClick getX, getY,LEFT_MOUSE_BUTTON
	print err.number
	
	Set objRedqDate = objParent.WebElement("html tag:=TD","innerhtml:=.*Switch to Day View"" class=""monthHeader k-nav-day k-link.*","outertext:="&reqDate,"visible:=True","index:=1")
	
	If err.number <> 0 Then
		objRedqDate.highlight
		Wait 1
	
		getX = objRedqDate.getROProperty("abs_x")
		getY = objRedqDate.getROProperty("abs_y")
		
		Set deviceReplay = CreateObject("Mercury.DeviceReplay")
		deviceReplay.MouseDblClick getX, getY,LEFT_MOUSE_BUTTON
	
	End If
	
	If objSchCallInfoHeader.Exist(10) Then
		objSchCallInfoHeader.highlight
		ScheduleCalendarSpecific = True
	Else 
		ScheduleCalendarSpecific = False
	End If
	
	
	Set dateDesc = Nothing
	Set objDate = Nothing
	Set deviceReplay = Nothing
	Set objDay = Nothing
	Set dayDesc = Nothing
	Set objParent = Nothing
	Set objPage = Nothing
	
End Function

'================================================================================================================================================================================================
'Function Name       :	PTCtechscreening
'Purpose of Function :	To perform tech screening in PTC user
'Input Arguments     :	strTechScreenAnsOpts: String value with details for Tech screening (eg: "Phone,Yes,Yes,English,Yes,3,Yes,CHF,Accepted,Yes,Yes,Yes") - values are delimited by ","
'					 :  strPostTechScrDetails: String value with details required for post Tech screening actions. (ButtonToBeClickedAfterScreening,PHMUserToWhomPatientToBeAssigned,ScheduleDate) (eg: "Warm Transfer,Maricela Lara-Nevarez,10/18/2015") - values are delimited by ","    (ScheduleDate is required only when ButtonToBeClickedAfterScreening is selected for schedule)
'Output Arguments    :	Boolean value: representing status of screening and post screening actions
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	blnPTCtechscreening =  PTCtechscreening(strTechScreeningAnswerOptions,strPostTechScreeningDetails, strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	20-Aug-2015
'================================================================================================================================================================================================

Function PTCtechscreening(ByVal strTechScreenAnsOpts, ByVal strPostTechScrDetails, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	PTCtechscreening = False
	strOutErrorDesc = ""
	
	Execute "Set objPageScrQues = " & Environment("WPG_AppParent")
	
	arrTechScrAnswers = Split(strTechScreenAnsOpts,",",-1,1)

	strMethodOfContact = arrTechScrAnswers(0)	
	strReviewLicense = arrTechScrAnswers(1)
	strcheckedPatientImpairments = arrTechScrAnswers(2)
	strPreferredLanguage = arrTechScrAnswers(3)
	strLanguageLineOffered = arrTechScrAnswers(4)
	strHIPAAinformation = arrTechScrAnswers(5) 'no of checkboxes to be checked min=2, max =3
	strAwareOfCallBeingRecorded = arrTechScrAnswers(6)
	strTMRreason = arrTechScrAnswers(7)
	strScreeningOutcome = arrTechScrAnswers(8)
	strAllergyChangeIdentified = arrTechScrAnswers(9)
	strComorbidChangeIdentified = arrTechScrAnswers(10)
	strProviderChangeIdentified = arrTechScrAnswers(11)	

	'Perform Screening---------
	
	'QUESTION 1: What was the method of contact for this review? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strMethodOfContact))
		Case "phone"
			MC = 1
		Case "telemedicine"
			MC = 2
		Case "indirect"
			MC = 3
	End Select
	Err.Clear
	Ques1_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs1Opt"&MC&".*"
		objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques1_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If

'			If method of contact for review is 'Indirect' (i.e. choice 3), then only 8th question is to be answered
			If MC = 3 Then
				'QUESTION 8: Verified reason for Targeted Medication Review: 
				'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				'For getting complete list of questions, highlight one question option near bottom. This is not part of screening
				objPageScrQues.WebElement("html tag:=DIV","outerhtml:=.*data-capella-automation-id=""pharTechScrQs10Opt1.*","visible:=True").highlight
				'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				Ques8_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs8dropdown.*"
				Set objTMRreason =  objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques8_ReqdOption)
				blnTMRreason = selectComboBoxItem(objTMRreason, Trim(strTMRreason))
				If Not blnTMRreason Then
					strOutErrorDesc = "Reason for Targeted Medication Review is not selected"
					Exit Function
				End If
				
				blnPostScreeningAction = PostScreeningAction(strPostScreening, strAssignedPHMusername, dtScheduleDate, strOutErrorDesc)
				If Not blnPostScreeningAction Then
					Exit Function
				End If
				
				PTCtechscreening = True
				Exit Function								
			End If
			
	'QUESTION 2: Did you review your license, your employer and the relationship with VillageHealth (i.e. Agent of VH)? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strReviewLicense))
		Case "yes"
			RL = 1
		Case "no"
			RL = 2
	End Select
	Err.Clear
	Ques2_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs2Opt"&RL&".*"
	objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques2_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If
	
	'QUESTION 3: Did you check Patient Impairments (Vision and Hear)? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strcheckedPatientImpairments))
		Case "yes"
			CPI = 1
		Case "no"
			CPI = 2
	End Select
	Err.Clear
	Ques3_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs3Opt"&CPI&".*"
	objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques3_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If
	
	'QUESTION 4: What is Patient Preferred Language? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Ques4_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs4dropdown.*"
	Set objPreferredLanguage =  objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques4_ReqdOption)
	blnPreferredLanguage = selectComboBoxItem(objPreferredLanguage, Trim(strPreferredLanguage))
	If Not blnPreferredLanguage Then
		strOutErrorDesc = "Preferred language is not selected"
		Exit Function
	End If
	
	'QUESTION 5: If needed did you offer to use the language line? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strLanguageLineOffered))
		Case "yes"
			LLO = 1
		Case "no"
			LLO = 2
	End Select
	Err.Clear
	Ques5_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs5Opt"&LLO&".*"
	objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques5_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If
	
	'QUESTION 6: What two pieces of HIPAA information were verified? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case strHIPAAinformation
		Case 2
			For ChkBoxNo = 1 To 2 Step 1	
				Ques6_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs6Opt"&ChkBoxNo&".*"
				objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques6_ReqdOption).Click
					If Err.Number <> 0 Then
							strOutErrorDesc = Err.Description
							Exit Function
					End If				
			Next
		Case 3
			For ChkBoxNo = 1 To 3 Step 1	
				Ques6_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs6Opt"&ChkBoxNo&".*"
				objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques6_ReqdOption).Click	
					If Err.Number <> 0 Then
							strOutErrorDesc = Err.Description
							Exit Function
					End If					
			Next
	End Select
	
	'QUESTION 7: Is member aware that call is being recorded? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strAwareOfCallBeingRecorded))
		Case "yes"
			ACR = 1
		Case "no"
			ACR = 2
	End Select
	Err.Clear
	Ques7_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs7Opt"&ACR&".*"
	objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques7_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If
	
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'For getting complete list of questions, highlight one question option near bottom. This is not part of screening
	objPageScrQues.WebElement("html tag:=DIV","outerhtml:=.*data-capella-automation-id=""pharTechScrQs10Opt1.*","visible:=True").highlight
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	'QUESTION 8: Verified reason for Targeted Medication Review: 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Ques8_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs8dropdown.*"
	Set objTMRreason =  objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques8_ReqdOption)
	blnTMRreason = selectComboBoxItem(objTMRreason, Trim(strTMRreason))
	If Not blnTMRreason Then
		strOutErrorDesc = "Reason for Targeted Medication Review is not selected"
		Exit Function
	End If
	
	'QUESTION 9: What was the outcome of screening? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strScreeningOutcome))
		Case "accepted"
			SO = 1
		Case "declined"
			SO = 2
		Case "undecided"
			SO = 3
	End Select
	Err.Clear
	Ques9_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs9Opt"&SO&".*"
	objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques9_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If
	
	'QUESTION 10: Verify patient's allergies. Was change identified? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strAllergyChangeIdentified))
		Case "yes"
			Allergy_CI = 1
		Case "no"
			Allergy_CI = 2
	End Select
	Err.Clear
	Ques10_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs10Opt"&Allergy_CI&".*"
	objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques10_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If
	
	'QUESTION 11: Verify patient's comorbid conditions. Was change identified? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strComorbidChangeIdentified))
		Case "yes"
			Comorbid_CI = 1
		Case "no"
			Comorbid_CI = 2
	End Select
	Err.Clear
	Ques11_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs11Opt"&Comorbid_CI&".*"
	objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques11_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If
	
	'QUESTION 12: Verify patient's providers and team. Was change identified? 
	'----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select Case Lcase(Trim(strProviderChangeIdentified))
		Case "yes"
			Provider_CI = 1
		Case "no"
			Provider_CI = 2
	End Select
	Err.Clear
	Ques12_ReqdOption = "outerhtml:=.*data-capella-automation-id=""pharTechScrQs12Opt"&Provider_CI&".*"
	objPageScrQues.WebElement("html tag:=DIV","visible:=True",Ques12_ReqdOption).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = Err.Description
		Exit Function
	End If
	
	'Action after screening questions ----------------------
	
	blnPostScreeningAction = PostScreeningAction(strPostTechScrDetails, strOutErrorDesc)
	If Not blnPostScreeningAction Then
		Exit Function
	End If
	
	Set objPageScrQues = Nothing
	Set objPageScrQues = Nothing
	
	PTCtechscreening = True
	
End Function

'================================================================================================================================================================================================
'Function Name       :	PostScreeningAction
'Purpose of Function :	To perform post screening actions including Tech Assessment
'Input Arguments     :	strReqdDetailsPostTechScr: String value with details required for post Tech screening actions. (ButtonToBeClickedAfterScreening,PHMUserToWhomPatientToBeAssigned,ScheduleDate) (eg: "Warm Transfer,Maricela Lara-Nevarez,10/18/2015") - values are delimited by ","    (ScheduleDate is required only when ButtonToBeClickedAfterScreening is selected for schedule)
'Output Arguments    :	Boolean value: representing status of post screening actions
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	blnPostScreeningAction = PostScreeningAction(strPostTechScrDetails, strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	21-Aug-2015
'================================================================================================================================================================================================

Function PostScreeningAction(ByVal strReqdDetailsPostTechScr, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PostScreeningAction = False
	
	arrPostTechScr = Split(strReqdDetailsPostTechScr,",",-1,1)
		
	strPostScreening = arrPostTechScr(0)
	strAssignedPHMusername = arrPostTechScr(1)
	dtScheduleDate = arrPostTechScr(2)
	
	Execute "Set objPageScr = " & Environment("WPG_AppParent")
	Execute "Set objWarmTransfer = " & Environment("WEL_WarmTransfer")
	Execute "Set objWarmTransferSave = " & Environment("WEL_WarmTransferSave")
	Execute "Set objPharTechScrSaveBtn = " & Environment("WEL_PharTechScrSaveBtn")
	Execute "Set objSchedulePHMAppnt = " & Environment("WEL_SchedulePHMAppnt")
	Execute "Set objSchCallSaveBtn = " & Environment("WB_SchCallSaveBtn")
	Execute "Set objTechAssessmentHeader = "& Environment("WEL_TechAssessmentHeader")
	Execute "Set objTechAssessmentReviewedCB = "& Environment("WEL_TechAssessmentReviewedCB")
	Execute "Set objProviderManagementHdr = "& Environment("WEL_ProviderManagementHdr_ptc")
	Execute "Set objMedicationsHeader = "& Environment("WEL_MedicationsHeader_ptc")
	Execute "Set objTechAssessmentSave = "& Environment("WB_TechAssessmentSave")
	
	Set objPHMAssignmentDD = objPageScr.WebButton("html id:=option-dropdown","html tag:=BUTTON","type:=button","visible:=True","index:=2")
	Set objAssignedPHMusername = objPageScr.WebElement("class:=patientName ng-binding","html tag:=DIV","outertext:="&Trim(strAssignedPHMusername),"visible:=True")
	
	If Lcase(Trim(strPostScreening)) = "warm transfer" Then
		
		'Click on Warm Transfer button
		blnButtonClicked = ClickButton("Warm Transfer",objWarmTransfer,strOutErrorDesc)
		If blnButtonClicked Then
			Call WriteToLog("Pass", "Warm Transfer button is clicked")
		Else
			Call WriteToLog("Fail", "Expected Result: Warm Transfer button should be clicked; Actual Result: Warm Transfer button is not clicked " &strOutErrorDesc)
			Exit Function
		End If
		Wait 2
		
		Call waitTillLoads("Loading...")
		Wait 1
		
		'select user to whom the patient should be assigned
		blnPHMAssignment = SelectComboBoxItemSpecific(objPHMAssignmentDD, strAssignedPHMusername)
		If blnPHMAssignment Then
			Call WriteToLog("Pass", "Warm Transfer Save button is clicked")
		Else
			strOutErrorDesc = "Unable to select required PHM user to assign the patient"
			Call WriteToLog("Fail", "Expected Result: Should be able to select required PHM user to assign the patient; Actual Result: " &strOutErrorDesc)
			Exit Function
		End If
		
		'Click on Warm Transfer Save button
		blnButtonClicked = ClickButton("Save",objWarmTransferSave,strOutErrorDesc)
		If blnButtonClicked Then
			Call WriteToLog("Pass", "Warm Transfer Save button is clicked")
		Else
			Call WriteToLog("Fail", "Expected Result: Warm Transfer Save button should be clicked; Actual Result: Warm Transfer Save button is not clicked " &strOutErrorDesc)
			Exit Function
		End If
		
		'Click on Phar TechScreening Save btn
		blnButtonClicked = ClickButton("Save",objPharTechScrSaveBtn,strOutErrorDesc)
		If blnButtonClicked Then
			Call WriteToLog("Pass", "Phar TechScreening Save button is clicked")
		Else
			Call WriteToLog("Fail", "Expected Result: Phar TechScreening Save button should be clicked; Actual Result: Phar TechScreening Save button is not clicked " &strOutErrorDesc)
			Exit Function
		End If
		Wait 2
		
		Call waitTillLoads("Loading...")
		Wait 2
		
	'Tech Assessment.........

		'Check whether Tesch Assessment window is available
		If CheckObjectExistence(objMedicationsHeader,5) Then
			Call WriteToLog("Pass", "'Tech Assessment' window is available")
		Else
			Call WriteToLog("Fail", "'Tech Assessment' window is not available")
			Exit Function
		End If	
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 1
		
		'Click Reviewed check box for Allergies
		Set objTechAssessmentReviewedCB = Nothing
		Execute "Set objTechAssessmentReviewedCB = "& Environment("WEL_TechAssessmentReviewedCB")
		Err.Clear
		objTechAssessmentReviewedCB.Click
		If Err.Number <> 0 Then
			Call WriteToLog("Fail", "'Tech Assessment Reviewed' check box does not click successfully. Error Returned: "&Err.Description)
			Exit Function
		End If
		Call WriteToLog("Pass", "'Tech Assessment Reviewed' check box for Allergies clicked successfully")
		Wait 1
	
		'Expand Provider Management pane
		Err.Clear
		objProviderManagementHdr.click
		If Err.Number <> 0 Then
			Call WriteToLog("Fail", "'Provider Management pane' is not expanded")
			Exit Function
		End If
		Call WriteToLog("Pass", "'Provider Management pane' is expanded")
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 1
		
		'Click Reviewed check box for Provider Management
		Set objTechAssessmentReviewedCB = Nothing
		Execute "Set objTechAssessmentReviewedCB = "& Environment("WEL_TechAssessmentReviewedCB")
		Err.Clear
		objTechAssessmentReviewedCB.Click
		If Err.Number <> 0 Then
			Call WriteToLog("Fail", "'Tech Assessment Reviewed' check box does not click successfully. Error Returned: "&Err.Description)
			Exit Function
		End If
		Call WriteToLog("Pass", "'Tech Assessment Reviewed' check box for Provider Management clicked successfully")
		Wait 1
		
		'Expand Medications pane
		Err.Clear
		objMedicationsHeader.Click
		If Err.Number <> 0 Then
			Call WriteToLog("Fail", "'Medications pane' is not expanded")
			Exit Function
		End If
		Call WriteToLog("Pass", "'Medications pane' is expanded")
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 1
		
		'Click Reviewed check box for Medication
		Set objTechAssessmentReviewedCB = Nothing
		Execute "Set objTechAssessmentReviewedCB = "& Environment("WEL_TechAssessmentReviewedCB")
		Err.Clear
		objTechAssessmentReviewedCB.Click
		If Err.Number <> 0 Then
			Call WriteToLog("Fail", "'Tech Assessment Reviewed' check box does not click successfully. Error Returned: "&Err.Description)
			Exit Function
		End If
		Call WriteToLog("Pass", "'Tech Assessment Reviewed' check box for Medication clicked successfully")
		Wait 1
		
		'Click Save btn
		blnReturnValue = ClickButton("Save",objTechAssessmentSave,strOutErrorDesc)
		If not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
			Exit Function
		End If
		Wait 2		
		Call waitTillLoads("Saving Tech Screening...")
		Call waitTillLoads("Loading...")
		Wait 1
		Call waitTillLoads("Loading...")
		Wait 1
		
	Else
		
		'Click on Schedule PHM Appointment btn
		blnSchedule = ClickButton("Schedule PHM Appointment",objSchedulePHMAppnt,strOutErrorDesc)
		If blnSchedule Then
			Call WriteToLog("Pass", "'Schedule PHM Appointment' button is clicked")
		Else
			Call WriteToLog("Fail", "Expected Result: 'Schedule PHM Appointment' button should be clicked; Actual Result: 'Schedule PHM Appointment' button is not clicked " &strOutErrorDesc)
			Exit Function
		End If
		
		Call DateFormat(dtScheduleDate)
		blnScheduleCall = ScheduleCalendarSpecific(dtScheduleDate, strOutErrorDesc)
		If blnScheduleCall Then
			Call WriteToLog("Pass", "Schedule PHM Appointment is completed")
		Else
			Call WriteToLog("Fail", "Expected Result: Schedule PHM Appointment should be completed; Actual Result: Schedule PHM Appointment is not completed " &strOutErrorDesc)
			Exit Function
		End If
		
		Call waitTillLoads("Loading...")
		wait 2
		
		blnSaveSchedule = ClickButton("Save",objSchCallSaveBtn,strOutErrorDesc)
		If blnSaveSchedule Then
			Call WriteToLog("Pass", "Schedule PHM Appointment is saved")
		Else
			Call WriteToLog("Fail", "Expected Result: Schedule PHM Appointment should be saved; Actual Result: Schedule PHM Appointment is not saved " &strOutErrorDesc)
			Exit Function
		End If
		
		'Click on Phar TechScreening Save btn
		objPharTechScrSaveBtn = Nothing
		Execute "Set objPharTechScrSaveBtn = " & Environment("WEL_PharTechScrSaveBtn")
		blnButtonClicked = ClickButton("Save",objPharTechScrSaveBtn,strOutErrorDesc)
		If blnButtonClicked Then
			Call WriteToLog("Pass", "Phar TechScreening Save button is clicked")
		Else
			Call WriteToLog("Fail", "Expected Result: Phar TechScreening Save button should be clicked; Actual Result: Phar TechScreening Save button is not clicked " &strOutErrorDesc)
			Exit Function
		End If
		
	End If
	
	'Click on Phar TechScreening Save btn
	blnButtonClicked = ClickButton("Save",objPharTechScrSaveBtn,strOutErrorDesc)
	If blnButtonClicked Then
		Call WriteToLog("Pass", "Phar TechScreening Save button is clicked")
	Else
		Call WriteToLog("Fail", "Expected Result: Phar TechScreening Save button should be clicked; Actual Result: Phar TechScreening Save button is not clicked " &strOutErrorDesc)
		Exit Function
	End If
	Wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2
	
	Set objPageScr = Nothing
	Set objWarmTransfer = Nothing
	Set objWarmTransferSave = Nothing
	Set objPharTechScrSaveBtn = Nothing
	Set objSchedulePHMAppnt = Nothing
	Set objSchCallSaveBtn = Nothing
	Set objTechAssessmentHeader = Nothing
	Set objTechAssessmentReviewedCB = Nothing
	Set objProviderManagementHdr = Nothing
	Set objMedicationsHeader = Nothing
	Set objTechAssessmentSave = Nothing
	
	PostScreeningAction = True
	
End Function

'================================================================================================================================================================================================
'Function Name       :	AddPharmacistMedReview
'Purpose of Function :	To add pharmacist med review
'Input Arguments     :	dtPHMReviewDate: date value representing review date
'					 :	strPHMReviewEvent: string value representing review event
'Output Arguments    :	Boolean value: representing status of pharmacist med review add
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	blnAddPharmacistMedReview = AddPharmacistMedReview(dtPHMReviewDate, strPHMReviewEvent, strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	20-Aug-2015
'================================================================================================================================================================================================

Function AddPharmacistMedReview(ByVal dtPHMReviewDate, ByVal strPHMReviewEvent, strOutErrorDesc)
	
	On Error Resume Next
	strOutErrorDesc =""
	Err.clear
	AddPharmacistMedReview = False	

	Execute "Set objAddReviewBtnPHM = "&Environment("WB_AddReviewBtnPHM") 'Review event Add btn
	If objAddReviewBtnPHM.Exist(5) Then
		'Clk on Review Add btn
		blnAddReviewBtnPHM = ClickButton("Add",objAddReviewBtnPHM,strOutErrorDesc)
		If not blnAddReviewBtnPHM Then
			strOutErrorDesc = "PharmacistMedReview Add button is not clicked. " & strOutErrorDesc
			Exit Function
		End If
	End If
	Wait 0,500
	
	'Set review date
	Execute "Set objReviewDatePHM = "&Environment("WE_ReviewDatePHM") 'PHM Review date text box
	Err.Clear
	objReviewDatePHM.Set dtPHMReviewDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set Pharmacist Med Review date. "&Err.Description
	End If 
	Call WriteToLog("Pass","PHM review date is set as '"&dtPHMReviewDate&"'")
	Wait 0,500
	
	'Select Review event 
	Execute "Set objReviewEventPHMdd = "&Environment("WB_ReviewEventPHMdd") 'Review event dropdown
	blnPHMReviewEvent = selectComboBoxItem(objReviewEventPHMdd,strPHMReviewEvent)
	If not blnPHMReviewEvent Then
		strOutErrorDesc = "PharmacistMedReview Review event is not selected. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","PHM review event is selected as '"&strPHMReviewEvent&"'")
	Wait 0,500
	
	'Save Review event
	Execute "Set objReviewEventSaveBtn= "&Environment("WB_ReviewEventSaveBtn") 'Review event save button
	blnReviewEventSave = ClickButton("Save",objReviewEventSaveBtn,strOutErrorDesc)
	If not blnReviewEventSave Then
		strOutErrorDesc = "Pharmacist Med Review save button not clicked. " & strOutErrorDesc
		Exit Function
	End If
	
	Wait 2
	Call waitTillLoads("Saving Review...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	
	Execute "Set objAddReviewBtnPHM = Nothing"
	Execute "Set objReviewDatePHM = Nothing"
	Execute "Set objReviewEventPHMdd = Nothing"
	Execute "Set objReviewEventSaveBtn= Nothing"
	
	AddPharmacistMedReview = True
	
End Function

'================================================================================================================================================================================================
'Function Name       :	AddPHMintervention
'Purpose of Function :	To add intervention for medication
'Input Arguments     :	strAddInterventionValues: string value representing all required values for PHM intervention add
'						Note: Provide the values in the order delimit by "|" as shown below: (if any value (non-mandatory) is not required, then write "NA" it its place, but put "|" to keed the place value
'						strValuesForAddingIntervention = "strScreeningMethod|strIndication|strReferredTo|strInterventionDiseaseState|strTitleType|strTitleText|strMRP|strChangeRecommended|strMedRecommended|strMRPoutcome|strPHMcoding|strMD_MAP_RcmdnNotes|strMD_RcmdnNotes|strPHM_Notes"
'						eg: strValuesForAddingIntervention = "NA|Abnormal A/G Ratio|Davita Pharmacist : BHAKTA, VIMAL|Diabetes|DIABETIC SUPPLIES NEEDED|DIABETIC SUPPLIES NEEDED|Drug Interaction|Change|MedRecommended|Dose decreased|Avoided ER|NA|NA|NA"
'					 :	dtDateRecommended: date value representing DateRecommended
'					 :	dtPHMcodingDate: date value representing PHMcodingDate
'Output Arguments    :	Boolean value: representing status of pharmacist intervention add
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	blnAddIntervention = AddPHMintervention(strValuesForAddingIntervention,dtDateRecommended,dtPHMcodingDate,strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	24-Aug-2015
'Date Modified:		 :	22-March-2016
'================================================================================================================================================================================================

Function AddPHMintervention(ByVal strAddInterventionValues, ByVal dtDateRecommended, ByVal dtPHMcodingDate, strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc =""
	AddPHMintervention = False
	
	strScreeningMethod = Split(strAddInterventionValues,"|",-1,1)(0)
	strIndication = Split(strAddInterventionValues,"|",-1,1)(1)
	strReferredTo = Split(strAddInterventionValues,"|",-1,1)(2)
	strInterventionDiseaseState = Split(strAddInterventionValues,"|",-1,1)(3)
	strTitleType = Split(strAddInterventionValues,"|",-1,1)(4)
	strTitleText = Split(strAddInterventionValues,"|",-1,1)(5)
	strMRP = Split(strAddInterventionValues,"|",-1,1)(6)
	strChangeRecommended = Split(strAddInterventionValues,"|",-1,1)(7)
	strMedRecommended = Split(strAddInterventionValues,"|",-1,1)(8)
	strMRPoutcome = Split(strAddInterventionValues,"|",-1,1)(9)
	strPHMcoding = Split(strAddInterventionValues,"|",-1,1)(10)
	strMD_MAP_RcmdnNotes = Split(strAddInterventionValues,"|",-1,1)(11)
	strMD_RcmdnNotes = Split(strAddInterventionValues,"|",-1,1)(12)
	strPHM_Notes = Split(strAddInterventionValues,"|",-1,1)(13)

	If Lcase(Trim(strScreeningMethod)) <> "na" Then
		'Select Screening Method
		Execute "Set objScreeningMethod = " & Environment("WB_ScreeningMethod_DD")
		blnScreeningMethod = selectComboBoxItem(objScreeningMethod,strScreeningMethod)
		If not blnScreeningMethod Then
			strOutErrorDesc = "Unable to select Screening Method . " & strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass", "Selected 'Screening Method' value as '"&strScreeningMethod&"'")	
		Execute "Set objScreeningMethod = Nothing"
		Wait 0,250
	End If
	
	'Select Indication
	Execute "Set objIndicationDD = " & Environment("WE_IndicationDD")
	Execute "Set objIndicationDDlist = " & Environment("WEL_IndicationDDlist")
	blnSelectDDitemBySendingKeys = SelectDDitemBySendingKeys(objIndicationDD,objIndicationDDlist,strIndication,strOutErrorDesc)
	If not blnSelectDDitemBySendingKeys Then
		strOutErrorDesc = "Unable to select 'Indication' value. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Selected 'Indication' value as '"&strIndication&"'")
	Execute "Set objIndicationDD = Nothing"	
	Execute "Set objIndicationDDlist = Nothing"	
	Wait 0,250
	
	'Select ReferredTo
	Execute "Set objPHMmedRevRefToDD = " & Environment("WB_PHMmedRevRefToDD")
	blnPHMmedRevRefTo = SelectComboBoxItemSpecific(objPHMmedRevRefToDD,strReferredTo)
	If not blnPHMmedRevRefTo Then
		strOutErrorDesc = "Unable to select PHM Med Review 'Referred To' value. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Selected 'ReferredTo' value as '"&strReferredTo&"'")	
	Execute "Set objPHMmedRevRefToDD = Nothing"	
	Wait 0,250
	
	'Select Intervention Disease state
	Execute "Set objPHMmedRevIntervDisSt = " & Environment("WB_PHMmedRevIntervDisSt")
	blnPHMmedRevIntervDisSt = selectComboBoxItem(objPHMmedRevIntervDisSt,strInterventionDiseaseState)
	If not blnPHMmedRevIntervDisSt Then
		strOutErrorDesc = "Unable to select PHM Med Review 'Intervention Disease State' value. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Selected 'Intervention Disease state' value as '"&strInterventionDiseaseState&"'")
	Execute "Set objPHMmedRevIntervDisSt = Nothing"	
	Wait 0,250
	
	'Selected Title
	Execute "Set objPHMmedRevTitle = " & Environment("WB_PHMmedRevTitle")
	blnPHMmedRevTitle = selectComboBoxItem(objPHMmedRevTitle,strTitleType)
	If not blnPHMmedRevTitle Then
		strOutErrorDesc = "Unable to select PHM Med Review 'Title' value. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Selected 'TitleType'set as '"&strTitleType&"'")
	Execute "Set objPHMmedRevTitle = Nothing"	
	Wait 0,250
	
	'Set Review Title 
	Execute "Set objRevTitle = " & Environment("WE_RevTitle")
	Err.Clear
	objRevTitle.Set strTitleText
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set Pharmacist Med Review Title. "&Err.Description
	End If 
	Call WriteToLog("Pass", "'Title' is set as '"&strTitleText&"'")
	Execute "Set objRevTitle = Nothing"	
	Wait 0,250
	
	'Select MRP value from 'MRP' dropdown
	Execute "Set objMRPdropdown = " & Environment("WB_MRP_DD")
	blnMRP_DDvalue = selectComboBoxItem(objMRPdropdown,strMRP)
	If not blnMRP_DDvalue Then
		strOutErrorDesc = "Unable to select MRP value. " & strOutErrorDesc
		Exit Function
	End If	
	Call WriteToLog("Pass", "Selected 'MRP' value as '"&strMRP&"'")	
	Execute "Set objMRPdropdown = Nothing"	
	Wait 0,250
	
	'Select ChangeRecommended value from 'Change Recommended' dropdown
	Execute "Set objChangeRecommendedDD = " & Environment("WB_ChangeRecommended_DD")
	blnCR_DDvalue = selectComboBoxItem(objChangeRecommendedDD,strChangeRecommended)
	If not blnCR_DDvalue Then
		strOutErrorDesc = "Unable to select ChangeRecommended value. " & strOutErrorDesc
		Exit Function
	End If	
	Call WriteToLog("Pass", "Selected 'ChangeRecommended' value as '"&strChangeRecommended&"'")	
	Execute "Set objChangeRecommendedDD = Nothing"	
	Wait 0,250
	
	'Click on MedRecommended check box
	Execute "Set objChangeRecommendedDD = " & Environment("WCB_MedRecommended_CB")	
	Err.Clear
	objChangeRecommendedDD.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click MedRecommended check box. " & strOutErrorDesc
		Exit Function
	End If	
	Call WriteToLog("Pass", "Clicked MedRecommended check box")	
	Execute "Set objChangeRecommendedDD = Nothing"	
	Wait 0,250
	
	'Set value for MedRecommended Txt Box
	Execute "Set objMedRecommendedTxtBx = " & Environment("WE_MedRecommended")
	Err.Clear
	objMedRecommendedTxtBx.Set strMedRecommended
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set MedRecommended. "&Err.Description
	End If 
	Call WriteToLog("Pass", "'MedRecommended' is set as '"&strMedRecommended&"'")
	Execute "Set objMedRecommendedTxtBx = Nothing"	
	Wait 0,250	
	
	'Set value for DateRecommended
	Execute "Set objDateRecommended = " & Environment("WE_DateRecommended")
	Err.Clear
	objDateRecommended.Set dtDateRecommended
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set DateRecommended. "&Err.Description
	End If 
	Call WriteToLog("Pass", "'DateRecommended' is set as '"&dtDateRecommended&"'")
	Execute "Set objDateRecommended = Nothing"	
	Wait 0,250	
	
	'Select MRP Outcome value from 'MRP Outcome' dropdown
	Execute "Set objMRPOutcome_DD = " & Environment("WB_MRPOutcome_DD")
	blnMRPoutcome = selectComboBoxItem(objMRPOutcome_DD,strMRPoutcome)
	If not blnMRPoutcome Then
		strOutErrorDesc = "Unable to select MRP Outcome value. " & strOutErrorDesc
		Exit Function
	End If	
	Call WriteToLog("Pass", "Selected 'MRP Outcome' value as '"&strMRPoutcome&"'")	
	Execute "Set objMRPOutcome_DD = Nothing"	
	Wait 0,250	
	
	'Select PHMCoding value from 'PHM Coding' dropdown
	Execute "Set objPHMCoding = "&Environment("WB_PHMCoding")	
	blnPHMCodingvalue = selectComboBoxItem(objPHMCoding,strPHMcoding)
	If not blnPHMCodingvalue Then
		strOutErrorDesc = "Unable to select PHMCoding value. " & strOutErrorDesc
		Exit Function
	End If	
	Call WriteToLog("Pass", "Selected 'PHMCoding' value as '"&strPHMcoding&"'")	
	Execute "Set objPHMCoding = Nothing"	
	Wait 0,250	
	
	'Set value for PHM Coding Date 
	Execute "Set objPHMCodingDate = "&Environment("WE_PHMCodingDate")	
	Err.Clear
	objPHMCodingDate.Set dtPHMcodingDate
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to set PHM Coding Date. "&Err.Description
		Exit Function
	End If 
	Call WriteToLog("Pass", "'PHM Coding Date' is set as '"&dtPHMcodingDate&"'")
	Execute "Set objPHMCodingDate = Nothing"	
	Wait 0,250
	
	'Set value for MAP/MD Recommendation Notes
'	If Lcase(Trim(strMD_MAP_RcmdnNotes)) <> "na" Then
'		Execute "Set objMAPMDRecommendationNotes = "&Environment("WE_MAPMDRecommendationNotes")	
'		objMAPMDRecommendationNotes.highlight
'		Err.Clear
'		objMAPMDRecommendationNotes.Set strMD_MAP_RcmdnNotes
'		If Err.Number <> 0 Then
'			strOutErrorDesc = "Unable to set value for 'MAP/MD Recommendation Notes'. "&Err.Description 
'			Exit Function
'		End If
'		Call WriteToLog("Pass", "'MAP/MD Recommendation Notes' is set as '"&strMD_MAP_RcmdnNotes&"'")
'		Execute "Set objMAPMDRecommendationNotes = Nothing"	
'		Wait 0,250	
'	End If

	'Set value for MAP/MD Recommendation Notes
	strMAPMEDRecomNotes_Existing = ""
	Execute "Set objMAPMDRecommendationNotes = "&Environment("WE_MAPMDRecommendationNotes")	
	strMAPMEDRecomNotes_Existing = objMAPMDRecommendationNotes.GetROProperty("value")
	If strMAPMEDRecomNotes_Existing = "" Then	
		If Lcase(Trim(strMD_MAP_RcmdnNotes)) <> "na" Then
			Execute "Set objMAPMDRecommendationNotes = "&Environment("WE_MAPMDRecommendationNotes")	
			objMAPMDRecommendationNotes.highlight	
			Err.Clear			
			objMAPMDRecommendationNotes.Set strMD_MAP_RcmdnNotes
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to set value for 'MAP/MD Recommendation Notes'. "&Err.Description 
				Exit Function
			End If
			Call WriteToLog("Pass", "'MAP/MD Recommendation Notes' is set as '"&strMD_MAP_RcmdnNotes&"'")
			Execute "Set objMAPMDRecommendationNotes = Nothing"	
			Wait 0,250	
		Else
			Execute "Set objMAPMDRecommendationNotes = "&Environment("WE_MAPMDRecommendationNotes")	
			objMAPMDRecommendationNotes.highlight
			Err.Clear
			objMAPMDRecommendationNotes.Set "Recommendation Notes"
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to set value for 'MAP/MD Recommendation Notes'. "&Err.Description 
				Exit Function
			End If
			Call WriteToLog("Pass", "'MAP/MD Recommendation Notes' is set as '"&strMD_MAP_RcmdnNotes&"'")
			Execute "Set objMAPMDRecommendationNotes = Nothing"	
			Wait 0,250				
		End If			
	ElseIf Lcase(Trim(strMD_MAP_RcmdnNotes)) <> "na" Then	
		Execute "Set objMAPMDRecommendationNotes = "&Environment("WE_MAPMDRecommendationNotes")	
		objMAPMDRecommendationNotes.highlight
		Err.Clear
		objMAPMDRecommendationNotes.Set strMD_MAP_RcmdnNotes
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set value for 'MAP/MD Recommendation Notes'. "&Err.Description 
			Exit Function
		End If
		Call WriteToLog("Pass", "'MAP/MD Recommendation Notes' is set as '"&strMD_MAP_RcmdnNotes&"'")
		Execute "Set objMAPMDRecommendationNotes = Nothing"	
		Wait 0,250	
	End If
	
	'Set value for MD Recommendation Reference(s)
	If Lcase(Trim(strMD_RcmdnNotes)) <> "na" Then
		Execute "Set objMDRecommendationReference = "&Environment("WE_MDRecommendationReference")	
		objMDRecommendationReference.highlight
		Err.Clear
		objMDRecommendationReference.Set strMD_RcmdnNotes
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set value for 'MD Recommendation Reference(s)'. "&Err.Description 
			Exit Function
		End If
		Call WriteToLog("Pass", "'MD Recommendation Reference(s)' is set as '"&strMD_RcmdnNotes&"'")
		Execute "Set objMDRecommendationReference = Nothing"	
		Wait 0,250			
	End If
	
	'Set value for PHM Notes 
	If Lcase(Trim(strPHM_Notes)) <> "na" Then
		Execute "Set objPHMNotes = "&Environment("WE_PHMNotes")	
		objPHMNotes.highlight
		Err.Clear
		objPHMNotes.Set strPHM_Notes
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set value for 'PHM Notes'. "&Err.Description 
			Exit Function
		End If
		Call WriteToLog("Pass", "'PHM Notes' is set as '"&strPHM_Notes&"'")
		Execute "Set objPHMNotes = Nothing"	
		Wait 0,250			
	End If
	
	'Click Save button
	Execute "Set objPHMInterAddSave = " & Environment("WB_PHMInterAddSave")
	blnPHMInterAddSave = ClickButton("Save",objPHMInterAddSave,strOutErrorDesc)
	If not blnPHMInterAddSave Then
		strOutErrorDesc = "PHM intervention save button (after adding intervention) is not clicked. " & strOutErrorDesc
		Exit Function
	End If
	Execute "Set objPHMInterAddSave = Nothing"
	Wait 2
	Call waitTillLoads("Saving Intervention...")
	Wait 1
	
	AddPHMintervention = True
	
End Function

'================================================================================================================================================================================================
'Function Name       :	EditInterventionStatus
'Purpose of Function :	To edit intervention for medication
'Input Arguments     :	strStatusRequired: string value representing status required after editing an intervention
'					 :	strCurrentVisibleStatus: string value representing current intervention status
'					 :	strPHMcoding: string value representing PHM coding value
'					 :	dtPHMcodingDate: date value representing PHM coding date
'Output Arguments    :	Boolean value: representing status of intervention edit
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	EditInterventionStatus(strPHMInterventionEditStatus, strCurrentVisibleStatusinPHM, strPHMcoding, dtPHMcodingDate, strOutErrorDesc)"
'Author				 :  Gregory
'Date				 :	24-Aug-2015
'================================================================================================================================================================================================
Function EditInterventionStatusOld(ByVal strStatusRequired, ByVal strCurrentVisibleStatus, ByVal strPHMcoding, ByVal dtPHMcodingDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc =""
	EditInterventionStatus = False
	
	Execute "Set objPageEditInter = " & Environment("WPG_AppParent")
	Execute "Set objInterventionEdit = " & Environment("WB_InterventionEdit")
'	Execute "Set objPHMinterventionStatus = " & Environment("WB_PHMinterventionStatus")
	Execute "Set objInterventionSaveEdit = " & Environment("WB_InterventionSaveEdit")
	Execute "Set objPHMCoding = "&Environment("WB_PHMCoding")
	Execute "Set objPHMCodingDate = "&Environment("WE_PHMCodingDate")
	
	blnInterventionEdit = ClickButton("Edit",objInterventionEdit,strOutErrorDesc)
	If not blnInterventionEdit Then
		strOutErrorDesc = "Pharmacist Intevention Edit button not clicked. " & strOutErrorDesc
		Exit Function
	End If
	Wait 2

	strVstatus = ".*"&strCurrentVisibleStatus&".*"	
	Set objInterventionStatus = objPageEditInter.WebButton("html id:=sideDropDown","html tag:=BUTTON","name:="&strVstatus,"outertext:="&strVstatus,"visible:=True")
	objInterventionStatus.highlight

	blnInterventionStatus = selectComboBoxItem(objInterventionStatus,strStatusRequired)
	If not blnInterventionStatus Then
		strOutErrorDesc = "Unable to select PHM intervention Status value. " & strOutErrorDesc
		Exit Function
	End If
	
'	If Ucase(Trim(strStatusRequired)) = "FINAL REVIEW NEEDED" Then
'
'		blnPhmCoding = SelectComboBoxItemSpecific(objPHMCoding,strPHMcoding)
'		If not blnPhmCoding Then
'			strOutErrorDesc = "Unable to select PHM intervention Status value. " & strOutErrorDesc
'			Exit Function
'		End If
'		
'		Err.Clear
'		objPHMCodingDate.Set dtPHMcodingDate
'		If Err.Number <> 0 Then
'			strOutErrorDesc = "PHM Coding Date is not set. " & Err.Description
'			Exit Function
'		End If
'		
'	End If
	
	blnInterventionSaveEdit = ClickButton("Save",objInterventionSaveEdit,strOutErrorDesc)
	If not blnInterventionSaveEdit Then
		strOutErrorDesc = "Pharmacist Intevention status save button (after editing intervention) is not clicked. " & strOutErrorDesc
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Saving Intervention...")
	Wait 1

	EditInterventionStatus = True
	
	Execute "Set objPageEditInter = Nothing"
	Execute "Set objInterventionEdit = Nothing"
	Execute "Set objInterventionSaveEdit = Nothing"
	Execute "Set objPHMCoding = Nothing"
	Execute "Set objPHMCodingDate = Nothing"
	
End Function

Function EditInterventionStatus(ByVal strStatusRequired, ByVal strCurrentVisibleStatus, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc =""
	EditInterventionStatus = False
	
	Execute "Set objPageEditInter = " & Environment("WPG_AppParent")
	Execute "Set objInterventionEdit = " & Environment("WB_InterventionEdit")
	Execute "Set objInterventionSaveEdit = " & Environment("WB_InterventionSaveEdit")
	Execute "Set objPHMCoding = "&Environment("WB_PHMCoding")
	Execute "Set objPHMCodingDate = "&Environment("WE_PHMCodingDate")
	
	blnInterventionEdit = ClickButton("Edit",objInterventionEdit,strOutErrorDesc)
	If not blnInterventionEdit Then
		strOutErrorDesc = "Pharmacist Intevention Edit button not clicked. " & strOutErrorDesc
		Exit Function
	End If
	Wait 2

	strVstatus = ".*"&strCurrentVisibleStatus&".*"	
	Set objInterventionStatus = objPageEditInter.WebButton("html id:=sideDropDown","html tag:=BUTTON","name:="&strVstatus,"outertext:="&strVstatus,"visible:=True")
	objInterventionStatus.highlight

	blnInterventionStatus = selectComboBoxItem(objInterventionStatus,strStatusRequired)
	If not blnInterventionStatus Then
		strOutErrorDesc = "Unable to select PHM intervention Status value. " & strOutErrorDesc
		Exit Function
	End If
		
	blnInterventionSaveEdit = ClickButton("Save",objInterventionSaveEdit,strOutErrorDesc)
	If not blnInterventionSaveEdit Then
		strOutErrorDesc = "Pharmacist Intevention status save button (after editing intervention) is not clicked. " & strOutErrorDesc
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Saving Intervention...")
	Wait 1

	EditInterventionStatus = True
	
	Execute "Set objPageEditInter = Nothing"
	Execute "Set objInterventionEdit = Nothing"
	Execute "Set objInterventionSaveEdit = Nothing"
	Execute "Set objPHMCoding = Nothing"
	Execute "Set objPHMCodingDate = Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	CloseIntervention
'Purpose of Function :	To close an intervention
'Input Arguments     :	NA
'Output Arguments    :	Boolean value: representing status of intervention closure
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	CloseIntervention()
'Author				 :  Gregory
'Date				 :	26-Aug-2015
'================================================================================================================================================================================================

Function CloseIntervention()

	On Error Resume Next
	Err.Clear
	CloseIntervention = False
	
	Execute "Set objInterventionEdit = " & Environment("WB_InterventionEdit")
	objInterventionEdit.Highlight
	blnInterventionEdit = ClickButton("Edit",objInterventionEdit,strOutErrorDesc)
	If not blnInterventionEdit Then
		Exit Function
	End If
	Wait 2
	
	'Check Close Intervention checkbox
	Execute "Set objClsInterCB = " & Environment("WEL_ClsInterCB")	
	objClsInterCB.highlight
	Err.Clear
	objClsInterCB.Click
	If Err.Number <> 0  Then
		strOutErrorDesc = "Unable to click intervention check box. "&Err.Description
		Exit Function
	End If
	
	'Save intervention closure	
	Execute "Set objInterventionSaveEdit = " & Environment("WB_InterventionSaveEdit")
	blnInterventionSaveEdit = ClickButton("Save",objInterventionSaveEdit,strOutErrorDesc)
	If not blnInterventionSaveEdit Then
		Exit Function
	End If
	
	Call waitTillLoads("Saving Intervention...")
	Wait 2
	
	CloseIntervention = True
	
	Set objInterventionEdit = Nothing
	Set objInterventionSaveEdit = Nothing
	Set objClsInterCB = Nothing
	
End Function

'================================================================================================================================================================================================
'Function Name       :	GlobalSearchUsingMemID
'Purpose of Function :	Global search for a patient giving member id specifically
'Input Arguments     :	lngMemberID: long value patient member id
'Output Arguments    :	Boolean value: representing global search result
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	27-Aug-2015
'================================================================================================================================================================================================

Function GlobalSearchUsingMemID(ByVal lngMemberID, strOutErrorDesc)

	On Error Resume Next 
	Err.Clear
	GlobalSearchUsingMemID = False
	strOutErrorDesc = ""

	Execute "Set objGloSearch = " &Environment("WE_GloSearch")'GlobalSearch TxtField	
	Execute "Set objGlobalSearchIcon = " &Environment("WI_GlobalSearchIcon")'GlobalSearch icon	
	Execute "Set PSResOK = " &Environment("WB_PSResOK")'PatientSearchResult popup OK btn

	'Search with patient MemID
	Err.Clear	
	objGloSearch.Set lngMemberID
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set patient member ID in global search field: "&Err.Description
		Exit Function
	End If
	Execute "Set objGloSearch = Nothing"
	Wait 1
		
	'Clk on global search icon
	If objGlobalSearchIcon.Exist(2) Then		
		Err.Clear	
		objGlobalSearchIcon.Click
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to click on global search icon: "&Err.Description
			Exit Function	
		End If
		Call WriteToLog("Pass", "Clicked global search icon")
	Else
		Execute "Set objGloSearch = " &Environment("WE_GloSearch")'GlobalSearch TxtField
		Err.Clear
		
		objGloSearch.Click
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to click on global search icon for sending enter key: "&Err.Description
			Exit Function	
		End If
		
		Set W_Shell = CreateObject("WScript.Shell")		
		W_Shell.SendKeys "{ENTER}"	
		
		Set W_Shell = Nothing	
		Execute "Set objGloSearch = Nothing"
	End If
		
	Wait 2	
	Call waitTillLoads("Searching...")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'verify if no matching results found message box existed if no patient found
    blnPopupClosed = checkForPopup("Error", "Ok", "No matching results found", strOutErrorDesc)
    If blnPopupClosed Then
        strOutErrorDesc = "Invalid Member ID"
        Exit Function
    End If			
    
	'Clk OK for required patient
	Err.Clear	
	PSResOK.Click
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to click OK btn in search result popup window: "&Err.Description
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1

	GlobalSearchUsingMemID = True

	Execute "Set objGloSearch = Nothing"
	Execute "Set objGlobalSearchIcon = Nothing"	
	Execute "Set PSResOK = Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	DomainTasks
'Purpose of Function :	1. Select required Domain under MOAN, validate Task list under seleted domain, select required task and navigate to task related screen
'Input Arguments     :	strDomain: string value representing required domain
'					 :	strTask: string val representing required task
'Output Arguments    :	Boolean value: representing Domain Task selection
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	blnDomainTasks = DomainTasks(strDomain, strTask, strOutErrorDesc)
'Author				 :  Gregory/Amar
'Date				 :	04-Sept-2015
'================================================================================================================================================================================================
Function DomainTasks(ByVal strDomain, ByVal strTask, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	DomainTasks = False

	'Objects required
	Execute "Set objPageMOAN ="&Environment("WPG_AppParent")	'page object
	Execute "Set objMOANexpand = "&Environment("WI_MOANexpand")	 'Menu of Actions Expand image
	Execute "Set objMOANcollapse = "&Environment("WI_MOANcollapse")	 'Menu of Actions Collapse image
	Execute "Set objDomain_exp_clap = "&Environment("WI_Domain_exp_clap")	'Menu of Actions>Domain Expand/collapse image
	Execute "Set objMOAN_TotalTaskCt = "&Environment("WEL_MOAN_TaskCount")	'Menu of Actions>Domain Expand/collapse image
	Execute "Set objTaskParentDomain = "&Environment("WEL_TaskParentDomain")  'Menu of Actions>Domain>Task pane
	
	'Required domain
	Set objDomain = objPageMOAN.WebElement("class:=moa-header.*","html tag:=DIV","innertext:="&".*"&strDomain&".*","visible:=True")

	'Expand MOAN if it is not expanded form
	Err.Clear
	If Not objDomain.Exist(1) then
		objMOANexpand.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'Menu of Action': "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Expanded 'Menu of Actions'")
	End If
	Wait 1
	
	'Domain header
	Set oDomains = Description.Create
	oDomains("micclass").value = "WebElement"
	oDomains("class").value = "moa-header"
	oDomains("html tag").value = "DIV"
	Set objDomains = objPageMOAN.ChildObjects(oDomains)
	intDomainCount = objDomains.Count
	
	'Exapnd/Close all domains in MOAN
	Err.Clear
	objDomain_exp_clap.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to expand/close all Domains: "&Err.Description
		Exit Function
	End If
			
	Set oDomainState = Description.Create
	oDomainState("micclass").value = "Image"
	oDomainState("class").value = "moa-expand-collapse-img moa-tile-img"
	Set objDomainCurrentState = objPageMOAN.ChildObjects(oDomainState)
	intDomainOpenCount = 0
	intDomainCloseCount = 0
	
	For intDomains = 0 To objDomainCurrentState.Count-1 Step 1
		If Instr(1,objDomainCurrentState(intDomains).GetROProperty("file name"),"arrow-down",1) Then
			intDomainCloseCount = intDomainCloseCount+1
		End If
		If Instr(1,objDomainCurrentState(intDomains).GetROProperty("file name"),"arrow-up",1) Then
			intDomainOpenCount = intDomainOpenCount+1
		End If	
	Next
	
	Err.Clear
	If intDomainOpenCount = intDomainCount AND intDomainCloseCount = 0  Then
		objDomain_exp_clap.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to expand/close all Domains: "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Expanded/Closed all domains")
	Else
		strOutErrorDesc = "Menu of Action Expand / Collapse icon malfunction"
		Exit Function
	End If
	
	'Wait till MOAN tasks load
	blnwaitUntilExist = waitUntilExist(objMOAN_TotalTaskCt, 100)
	If not blnwaitUntilExist Then
		strOutErrorDesc = "MOAN tasks are not loaded"
		Exit Function	
	End If
	Call WriteToLog("Pass", "Menu of actions tasks are loaded")
	Wait 2	

	'click required domain is available under MOAN
	Err.Clear
	objDomain.highlight
	objDomain.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on required Domain: "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on '"&strDomain&"' domain")
	Wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2
	
	'Child tasks in opened task pane	
	Set oTaskDesc = Description.Create
	oTaskDesc("micclass").value = "WebElement"
	oTaskDesc("html tag").value = "DIV"
	oTaskDesc("outertext").value = ".*"&strTask&".*"
	oTaskDesc("outertext").RegularExpression = True
	oTaskDesc("attribute/data-capella-automation-id").value = "Expand-All-Btn-Menu-Of-Actions.*"
	oTaskDesc("attribute/data-capella-automation-id").RegularExpression = True
	
	Set objTaskNames = objTaskParentDomain.ChildObjects(oTaskDesc)

	If objTaskNames.Count = 0 Then
		strOutErrorDesc = "Unable to find '"&strTask&"' task under '"&strDomain&"' domain"
		Exit Function
	Else
		Call WriteToLog("Pass", "'"&strTask&"' task is available under '"&strDomain&"' domain")
		Err.Clear
		objTaskNames(0).highlight
		objTaskNames(0).Click
		If Err.Number <> 0  Then
			strOutErrorDesc = "Unable to click '"&strTask&"' task under '"&strDomain&"' domain"
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked on '"&strTask&"' task")
		Wait 2
	
		Call waitTillLoads("Loading...")
		Wait 2
	End If

	
	Err.Clear
	If objMOANcollapse.Exist(10) Then
		objMOANcollapse.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = Err.Description
			Exit Function
		End If
	End If
	
	DomainTasks = True 
	
	Execute "Set objPageMOAN = Nothing"
	Execute "Set objMOANexpand = Nothing"
	Execute "Set objMOANcollapse = Nothing"
	Execute "Set objDomain_exp_clap = Nothing"
	Execute "Set objMOAN_TotalTaskCt = Nothing"
	Execute "Set objDomain = Nothing"
	Execute "Set oDomains = Nothing"
	Execute "Set objDomains = Nothing"
	Execute "Set oDomainState = Nothing"
	Execute "Set objDomainCurrentState = Nothing"
	Execute "Set objTaskParentDomain = Nothing"
	Execute "Set oTaskDesc = Nothing"
	Execute "Set objTaskNames = Nothing"
	Execute "Set objTask = Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	FallRiskAssessmentScreening
'Purpose of Function :	1.Perform Fall Risk Assessment screening, 2.validate other functionalities - Postpone,History 
'Input Arguments     :	dtScreeningDate: date value representing Fall Risk Assessment start date
'					 :	dtCompletedDate: date value representing Fall Risk Assessment completed date
'					 :	arrAnswerOption: array value representing answer options for Fall Risk Assessment screening 
'					 :	strTestAllFunctionalities: string value representing whether user wants only screening or test all other functionalities of FRA screen
'Output Arguments    :	Boolean value: representing FallRiskAssessment screening
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Pre-requisite		 :  SNP_Library folder should be loaded in the script which is calling this function (Ref: SNP_InitialTransplantEvaluation)
						'Use following code (for loading the SNP function library) in the script which calls this function:			
						'-------------------------------------------------------------------------------------
							'Set objFso = CreateObject("Scripting.FileSystemObject")
							'SNP_Library = Environment.Value("PROJECT_FOLDER") & "\Library\SNP_functions"
							'For each SNPlibfile in objFso.GetFolder(SNP_Library).Files
							'	If UCase(objFso.GetExtensionName(SNPlibfile.Name)) = "VBS" Then
							'		LoadFunctionLibrary SNPlibfile.Path
							'	End If
							'Next	
							'Set objFso = Nothing							
						'-------------------------------------------------------------------------------------	
'Example of Call     :	blnFallRiskAssessmentScreening = FallRiskAssessmentScreening(dtScreeningDt, dtCompletedDt, arrAnswerOption, strTestAllFunctionalities, strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	10-Sept-2015
'================================================================================================================================================================================================
Function FallRiskAssessmentScreening(ByVal dtScreeningDate, ByVal dtCompletedDate, ByVal arrAnswerOption, ByVal strTestAll, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	
	strOutErrorDesc = ""
	FallRiskAssessmentScreening = False
	
	'Objects required	
	Execute "Set objPage_FRA = "&Environment("WPG_AppParent")	'page object
	Execute "Set objFRA_Header = "&Environment("WEL_FRA_Header")	'Fall risk assessment screen header
	Execute "Set objFRA_Add = "&Environment("WEL_FRA_Add")	'Fall risk assessment Add button
	Execute "Set objFRA_ScrDt = "&Environment("WE_FRA_ScrDt")	'Fall risk assessment Screening date edit box
	Execute "Set objFRA_RiskScore = "&Environment("WEL_FRA_RiskScore")	'Fall risk assessment score
	Execute "Set objFRA_Save = "&Environment("WEL_FRA_Save")	'Fall risk assessment save btn

	'check whether navigated to 'Fall Risk Assessment' screen
	If not objFRA_Header.Exist(10) Then
		strOutErrorDesc = "Fall Risk Assessment screen is not available"
		Exit Function
	End If 
	Call WriteToLog("Pass", "Navigated to 'Fall Risk Assessment' screen")
	
	'Validating status of Add, Postpone and Save buttons in 'Fall Risk Assessment' screen
	If not objFRA_Add.Object.isDisabled Then 'Fresh screening
		If objFRA_Postpone.Object.isDisabled AND objFRA_Save.Object.isDisabled Then
			Call WriteToLog ("Pass", "Add btn is enabled and Postpone, Save buttons are disabled - Option for adding fresh screening")
		End If
	ElseIf objFRA_Add.Object.isDisabled Then 'Screening existing - continue or restart
		If not objFRA_Postpone.Object.isDisabled AND objFRA_Save.Object.isDisabled Then
			Call WriteToLog("Pass", "Add and Save buttons are disabled. Postpone button is enabled - Option for going forward with existing screening")
		End If
	Else 
		strOutErrorDesc = "Fall Risk screening page buttons are not available as expected"
		Exit Function
	End If
	
	'Click Add btn (for fresh screening)
	If not objFRA_Add.Object.isDisabled Then
		blnFRA_Add = ClickButton("Add",objFRA_Add,strOutErrorDesc)
		If not blnFRA_Add Then
			strOutErrorDesc = "Unable to click Fall Risk Assessment Add button: "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked on screening Add btn")
	 	Wait 2
	 	
		Call waitTillLoads("Loading Fall Risk Screening...")
		Wait 1
		'Set screening date
		Err.clear
		objFRA_ScrDt.Set dtScreeningDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set Fall Risk Assessment screening date"
			Exit Function
		End If
		Call WriteToLog("Pass", "Screening date is set")
		Wait 2
		
		'Validate score before screening
		If not isNumeric(Trim(objFRA_RiskScore.GetROProperty("outertext"))) Then
			Call WriteToLog("Pass", "Risk Score is empty as screening is yet to start")
		Else 
			strOutErrorDesc = "Risk Score is pre populated even before screening"
			Exit Function
		End If
	End If
	
	'objects for Screening question and screening answer options
	Set objFRA_ScreeningQues = GetChildObject("micclass;attribute/data-capella-automation-id","WebElement;label-question.*")
	Set objFRA_ScreeningRadioOpts = GetChildObject("micclass;html tag;outerhtml","WebElement;DIV;.*changeOptionOnQuestion.*")
	
	'Validate screening questions
	FRAScreeningQuesCount = objFRA_ScreeningQues.count
	If FRAScreeningQuesCount = "" OR FRAScreeningQuesCount = 0 Then
		strOutErrorDesc = "No screening questions existing in the screen"
		Exit Function
	End If
	Call WriteToLog("Pass", "FRA screening questions count is: "&FRAScreeningQuesCount)
	
	'screening with required answers
	For forFRAQuestion = 1 To FRAScreeningQuesCount Step 1
		FRAScreeningAnswer = arrAnswerOption(forFRAQuestion-1)
		Select Case forFRAQuestion
			Case 1:
				If Lcase(FRAScreeningAnswer) = "0 falls" Then
					ReqdOption = 0
				ElseIf Lcase(FRAScreeningAnswer) = "1 fall" Then
					ReqdOption = 1
				Else
					ReqdOption = 2
				End If
			Case 2:
				If Lcase(FRAScreeningAnswer) = "age <= 65" Then
					ReqdOption = 3
				ElseIf Lcase(FRAScreeningAnswer) = "age 66-75" Then
					ReqdOption = 4
				Else
					ReqdOption = 5
				End If
			Case 3:
				If Lcase(FRAScreeningAnswer) = "previous cva" Then
					ReqdOption = 6
				ElseIf Lcase(FRAScreeningAnswer) = "parkinson disease" Then
					ReqdOption = 7
				ElseIf Lcase(FRAScreeningAnswer) = "confusion" Then
					ReqdOption = 8
				ElseIf Lcase(FRAScreeningAnswer) = "depression" Then
					ReqdOption = 9
				Else
					ReqdOption = 10
				End If
			Case 4:
				If Lcase(FRAScreeningAnswer) = "yes" Then
					ReqdOption = 11
				Else
					ReqdOption = 12
				End If
			Case 5:
				If Lcase(FRAScreeningAnswer) = "sedatives" Then
					ReqdOption = 13
				ElseIf Lcase(FRAScreeningAnswer) = "hypnotics" Then
					ReqdOption = 14
				ElseIf Lcase(FRAScreeningAnswer) = "narcotics" Then
					ReqdOption = 15
				Else
					ReqdOption = 16
				End If
			Case 6:
				If Lcase(FRAScreeningAnswer) = "dizziness" Then
					ReqdOption = 17
				ElseIf Lcase(FRAScreeningAnswer) = "unsteadiness" Then
					ReqdOption = 18
				Else
					ReqdOption = 19
				End If
		End Select
		
		'Select required option
		Err.Clear
		objFRA_ScreeningRadioOpts(ReqdOption).Click
		Wait 1
		If Err.Number <> 0 Then
			strOutErrorDesc = objFRA_ScreeningRadioOpts(ReqdOption)& " option does not click successfully. Error Returned: "&Err.Description
			Exit  Function
		End If
		
	Next	
	
	Call WriteToLog("Pass", "Answered all screening questions with required values")
	Wait 1
	
	'------------------------------------------------
	'Test postpone functionality if required
	If Lcase(strTestAll) = "yes" Then
		blnFRA_ValidatePostponeBtn = FRA_ValidatePostponeBtn()
		If not blnFRA_ValidatePostponeBtn  Then
			Exit  Function
		End If
	End If
	'-------------------------------------------------
	
	'Save screening
	Execute "Set objFRA_Save = Nothing"
	Execute "Set objFRA_Save = "&Environment("WEL_FRA_Save")	'Fall risk assessment save btn
	blnFRA_Save = ClickButton("Save",objFRA_Save,strOutErrorDesc)
	If not blnFRA_Save Then
		strOutErrorDesc = "Fall risk assessment save btn is not clicked. Error returned: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Fall risk assessment save btn is clicked")
	Wait 2
	
	Call waitTillLoads("Saving Fall Risk Screening...")
	Wait 2
	
	If Not objErrorButton.Exist(3) Then
	Else
		Err.Clear		
		objErrorButton.click
		If Err.Number <> 0 Then
			strOutErrorDesc = "After clicking Save button, 'CompletedDate cannot be older than 7 days from today's date and cannot be greater than today's date' msg box is available. Unable to click OK button in this msg box: "&strOutErrorDesc
			Exit Function
		Else
			Call WriteToLog("Warning", "After clicking Save button, 'CompletedDate cannot be older than 7 days from today's date and cannot be greater than today's date' msg box is available. Clicked on OK button in this msg box. Screening is not saved due to time constraints. Note: Screening should be performed afternoon if script executed offshore")
			Exit Function
		End If	
	End If
	
	'Validate Screening success message
	blnFRA_SavedPP = checkForPopup("Fall Risk Assessment Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not blnFRA_SavedPP Then
		strOutErrorDesc = "FRA saved confirmation popup is not available"
		Exit Function
	End If
	Call WriteToLog("Pass", "Saved FRA screening, accepted confirmation popup")

	'Validate score after screening
	Execute "Set objFRA_RiskScore = Nothing"
	Execute "Set objFRA_RiskScore = "&Environment("WEL_FRA_RiskScore")	'Fall risk assessment score
	intFRA_Score = Trim(objFRA_RiskScore.GetROProperty("outertext"))
	If isNumeric(intFRA_Score) Then
		Call WriteToLog("Pass", "Current Fall Risk Assessment screening score is: "&intFRA_Score)
	Else
		strOutErrorDesc = "Current Fall Risk Assessment screening score is not a Numeric value. Actual value is: " & intFRA_Score
		Exit Function
	End If
	
	'-------------------------------------------------
	'Test history functionality if required
	If Lcase(strTestAll) = "yes" Then
		blnFRA_ValidateHistory = FRA_ValidateHistory(dtCompletedDate,intFRA_Score)
		If not blnFRA_ValidateHistory  Then
			Exit  Function
		End If
	End If	
	'-------------------------------------------------
	
	Call WriteToLog("Pass", "Completed Fall Risk assessment screening successfully")
	
	FallRiskAssessmentScreening = True
	
	Execute "Set objPage_FRA = Nothing"
	Execute "Set objFRA_Header = Nothing"
	Execute "Set objFRA_Add = Nothing"
	Execute "Set objFRA_ScrDt = Nothing"
	Execute "Set objFRA_RiskScore = Nothing"
	Execute "Set objFRA_Save = Nothing"
	Set objFRA_ScreeningQues = Nothing
	Set objFRA_ScreeningRadioOpts = Nothing
			
End Function


'================================================================================================================================================================================================
'Function Name       :	TransplantEvaluation
'Purpose of Function :	1.Perform TransplantEvaluation pathway, 2.validate other functionalities - Add,Postpone,Save,Cancel,History, Validate all Links connecting to other sceens, messages etc.. 
'Input Arguments     :	arrAnswerBook: array value representing answers for all pathway questions (inclueds answers for all possible workflows)
'					 :	arrPatwayDecidingAnswers: array value representing answers which actually decides which flow the pathway should follow
'					 :	strTestAll: string value (Yes/No) representing whether user wants only screening or test all other functionalities of Transplant Evaluation screen
'					 :	dtScreeningDate = date value representing pathway performing date
'Output Arguments    :	Boolean value: representing TransplantEvaluation pathway status
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Pre-requisite		 :  SNP_Library folder should be loaded in the script which is calling this function (Ref: SNP_InitialTransplantEvaluation)
						'Use following code (for loading the SNP function library) in the script which calls this function:			
						'-------------------------------------------------------------------------------------
							'Set objFso = CreateObject("Scripting.FileSystemObject")
							'SNP_Library = Environment.Value("PROJECT_FOLDER") & "\Library\SNP_functions"
							'For each SNPlibfile in objFso.GetFolder(SNP_Library).Files
							'	If UCase(objFso.GetExtensionName(SNPlibfile.Name)) = "VBS" Then
							'		LoadFunctionLibrary SNPlibfile.Path
							'	End If
							'Next	
							'Set objFso = Nothing							
						'-------------------------------------------------------------------------------------															
'Example of Call     :	blnTransplantEvaluation = TransplantEvaluation(arrTE_AnsBook, arrDecidingAns, strTestAllFunctionalities, dtScreeningDt, strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	30-Sept-2015
'================================================================================================================================================================================================
Function TransplantEvaluation(ByVal arrAnswerBook,ByVal arrPatwayDecidingAnswers,ByVal strTestAll,ByVal dtScreeningDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	TransplantEvaluation = False
	
	Execute "Set objTE_Page = " & Environment("WPG_AppParent")
	Execute "Set objTE_Header = " & Environment("WEL_TE_Header")
	Execute "Set objTE_AddBtn = " & Environment("WEL_TE_Add")
	Execute "Set objTE_SaveBtn = " & Environment("WEL_TE_Save")
	Execute "Set objTE_CancelBtn = " & Environment("WEL_TE_Cancel")
	Execute "Set objTE_Comments = " & Environment("WE_TE_Comments") 
	Execute "Set objTE_PatientCommentCB = " & Environment("WE_TE_PatientCommentCB")
	Execute "Set objTE_ProviderCommentCB = " & Environment("WE_TE_ProviderCommentCB") 
	Execute "Set objTE_Date = " &Environment("WEL_TE_Date")
	
	'Verify whether user navigated to 'Transplant Evaluation' screen
	If not objTE_Header.Exist(5) Then
		strOutErrorDesc = "Transplant Evaluation screen is not available"
		Exit Function
	End If	
	Call WriteToLog("Pass", "User is able to navigate to 'Transplant Evaluation' screen")
	
	'------------------------------------------------
	'Validate buttons and history if required
	If Lcase(strTestAll)  = "yes" Then
		blnTE_ButtonInitialStatus = TE_ButtonInitialStatus()
		If not blnTE_ButtonInitialStatus  Then
			Exit function
		End If
		Call WriteToLog("Pass", "Validated initial status on Transplan Evaluation screen buttons and pathway report")
	End If 
	'------------------------------------------------
	Wait 2
	
	'Perform Pathway
	If objTE_AddBtn.exist(1) Then
	blnTE_AddClicked = ClickButton("Add",objTE_AddBtn,strOutErrorDesc)
		If not blnTE_AddClicked Then
			strOutErrorDesc = "Unable to click Transplant Evaluation Add button"
			Exit function
		End If
	    Call WriteToLog("Pass", "Clicked on Transplant Evaluation Add button")
	End If
	Wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2
	
	strDecidingQuesAnswer1 = arrPatwayDecidingAnswers(0)	'PatientOnRenalTransplantList
	strDecidingQuesAnswer2 = arrPatwayDecidingAnswers(1)	'ReferredForRenalTransplantation
	strDecidingQuesAnswer3 = arrPatwayDecidingAnswers(2)	'WasAssistanceProvided
	
	'Is patient on a renal transplant list = yes
	If Lcase(strDecidingQuesAnswer1) = "yes" Then
		
					Dim arrAnswerBook1(3) 
					
					For TEQuestion = 1 To 4 Step 1
						
						arrAnswerBook1(0) = arrAnswerBook(0)	'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided	
						arrAnswerBook1(1) = arrAnswerBook(1)	'AnswerOption2 = WhichTransplantList:Living/Non-living		
						arrAnswerBook1(2) = arrAnswerBook(8)	'AnswerOption9 = VerbalEducationProvided:Yes/No/NA		
						arrAnswerBook1(3) = arrAnswerBook(9)	'AnswerOption10 = SendWrittenMaterials:Yes/No/NA
				
						Select Case TEQuestion
							Case 1:'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided	
								If Lcase(arrAnswerBook1(TEQuestion-1)) = "yes" Then
									ReqdOption = "683_1670"
								ElseIf lcase(arrAnswerBook1(TEQuestion-1)) = "no" Then
									ReqdOption = "683_1671"
								Else
									ReqdOption = "683_1672"
								End If
								objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
								'Testing link functionality for 'Yes' answer opted for "Is patient on a renal transplant list?" pathway question
								If lcase(strTestAll) = "yes" AND Lcase(arrAnswerBook1(TEQuestion-1)) = "yes" Then
									blnTeamLink = TestTE_TeamLink()
									If not blnTeamLink Then
										Exit Function
									End If
								End If
								
							Case 2:'AnswerOption2 = WhichTransplantList:Living/Non-living
								If Trim(lcase(arrAnswerBook1(TEQuestion-1))) = "living" Then
									ReqdOption = "684_1673"
								Else
									ReqdOption = "684_1674"
								End If
								objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
								
							Case 3:'AnswerOption9 = VerbalEducationProvided:Yes/No/NA	
								If lcase(arrAnswerBook1(TEQuestion-1)) = "yes" Then
									ReqdOption = "691_1703"
								ElseIf lcase(arrAnswerBook1(TEQuestion-1)) = "no" Then
									ReqdOption = "691_1704"
								Else
									ReqdOption = "691_1705"
								End If
								objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
								
							Case 4:'AnswerOption10 = SendWrittenMaterials:Yes/No/NA
								If lcase(arrAnswerBook1(TEQuestion-1)) = "yes" Then
									ReqdOption = "692_1706"
								ElseIf lcase(arrAnswerBook1(TEQuestion-1)) = "no" Then
									ReqdOption = "692_1707"
								Else
									ReqdOption = "692_1708"
								End If
								objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
								
								'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
								If lcase(strTestAll) = "yes" AND lcase(arrAnswerBook1(TEQuestion-1)) = "yes" Then
									blnMaterialLink = TestTE_MaterialLink()
									If not blnMaterialLink Then
										Exit Function
									End If
								End If
								
						End Select
					
					Next
	
	'Is patient on a renal transplant list = no, Has patient been referred for renal transplantation = yes, Was assistance provided in the work up process = yes
	ElseIf Lcase(strDecidingQuesAnswer1) = "no" AND Lcase(strDecidingQuesAnswer2) = "yes" AND Lcase(strDecidingQuesAnswer3) = "yes" Then
					
						Dim arrAnswerBook2(7)
		
						For TEQuestion = 1 To 8 Step 1
						
							arrAnswerBook2(0) = arrAnswerBook(0) 	'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided
							arrAnswerBook2(1) = arrAnswerBook(2)	'AnswerOption3 = NotOnRenalTransplantListBecause:Age,GFR,..
							arrAnswerBook2(2) = arrAnswerBook(3)	'AnswerOption4 = ReferredForRenalTransplantation:Yes/No/NA
							arrAnswerBook2(3) = arrAnswerBook(5)	'AnswerOption6 = TransplantWorkInitiated:Yes/No/NA
							arrAnswerBook2(4) = arrAnswerBook(6)	'AnswerOption7 = WasAssistanceProvided:Yes/No/NA
							arrAnswerBook2(5) = arrAnswerBook(7)	'AnswerOption8 = FollowingAssistanceWasProvided:Referral for dental,Other,...
							arrAnswerBook2(6) = arrAnswerBook(8)	'AnswerOption9 = VerbalEducationProvided:Yes/No/NA
							arrAnswerBook2(7) = arrAnswerBook(9)	'AnswerOption10 = SendWrittenMaterials:Yes/No/NA
						
							Select Case TEQuestion
								Case 1:'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided
									If lcase(arrAnswerBook2(TEQuestion-1)) = "yes" Then
										ReqdOption = "683_1670"
									ElseIf lcase(arrAnswerBook2(TEQuestion-1)) = "no" Then
										ReqdOption = "683_1671"
									Else
										ReqdOption = "683_1672"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
								
								Case 2:'AnswerOption3 = NotOnRenalTransplantListBecause:Age,GFR,..
									arrAnswerBook2Specific = Split(arrAnswerBook2(1),",",-1,1)
									For rsn = 0 To Ubound(arrAnswerBook2Specific) Step 1
										Reason = arrAnswerBook2Specific(rsn)
										Select Case Reason
											Case "Age"
												ReqdOption = "685_1675"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "GFR"
												ReqdOption = "685_1676"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Medical Contraindication"
												ReqdOption = "685_1677"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext22","type:=text","visible:=True").Set "mc"
											Case "Not Interested"
												ReqdOption = "685_1678"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Socio-economic Contraindication"
												ReqdOption = "685_1679"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Approval Pending"
												ReqdOption = "685_1680"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Denial"
												ReqdOption = "685_1681"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "On Hold"
												ReqdOption = "685_1682"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext77","type:=text","visible:=True").Set "on hold"
										End Select
									
									Next
									
								Case 3:'AnswerOption4 = ReferredForRenalTransplantation:Yes/No/NA							
									ReqdOption = "686_1683"
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
									
									'Testing link functionality for 'Yes' answer opted for "Has patient been referred for renal transplantation?" pathway question
									If lcase(strTestAll) = "yes" AND Lcase(arrAnswerBook2(2)) = "yes" Then
										blnReferralLink = TestTE_ReferralLink()
										If not blnReferralLink Then
											Exit Function
										End If
									End If
									
								Case 4:'AnswerOption6 = TransplantWorkInitiated:Yes/No/NA							
									If lcase(arrAnswerBook2(TEQuestion-1)) = "yes" Then
										ReqdOption = "688_1692"
									ElseIf lcase(arrAnswerBook2(TEQuestion-1)) = "no" Then
										ReqdOption = "688_1693"
									Else
										ReqdOption = "688_1694"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 5:'AnswerOption7 = WasAssistanceProvided:Yes/No/NA							
									ReqdOption = "689_1695"
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 6:'AnswerOption8 = FollowingAssistanceWasProvided:Referral for dental,Other,...								
									arrAnswerBook2SpecificAP = Split(arrAnswerBook2(5),",",-1,1)
									For aPRO = 0 To Ubound(arrAnswerBook2SpecificAP) Step 1
										AsPro= arrAnswerBook2SpecificAP(aPRO)
										Select Case AsPro
											Case "Referral for testing or screening"
												ReqdOption = "690_1698"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Referral for specialist"
												ReqdOption = "690_1699"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Referral for dental"
												ReqdOption = "690_1700"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
											Case "Coordinate authorization/work-up"
												ReqdOption = "690_1701"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Other"
												ReqdOption = "690_1702"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext44","type:=text","visible:=True").Set "test"
										End Select
									Next
								
								Case 7:'AnswerOption9 = VerbalEducationProvided:Yes/No/NA							
									If lcase(arrAnswerBook2(TEQuestion-1)) = "yes" Then
										ReqdOption = "691_1703"
									ElseIf lcase(arrAnswerBook2(TEQuestion-1)) = "no" Then
										ReqdOption = "691_1704"
									Else
										ReqdOption = "691_1705"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 8:'AnswerOption10 = SendWrittenMaterials:Yes/No/NA							
									If lcase(arrAnswerBook2(TEQuestion-1)) = "yes" Then
										ReqdOption = "692_1706"
									ElseIf lcase(arrAnswerBook2(TEQuestion-1)) = "no" Then
										ReqdOption = "692_1707"
									Else
										ReqdOption = "692_1708"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
								If lcase(strTestAll) = "yes" AND lcase(arrAnswerBook2(7)) = "yes" Then
									blnMaterialLink = TestTE_MaterialLink()
									If not blnMaterialLink Then
										Exit Function
									End If
								End If							
									
									
								End Select
					
						Next
						
	'Is patient on a renal transplant list = no, Has patient been referred for renal transplantation = yes, Was assistance provided in the work up process = no									
	ElseIf Lcase(strDecidingQuesAnswer1) = "no" AND Lcase(strDecidingQuesAnswer2) = "yes" AND Lcase(strDecidingQuesAnswer3) = "no" Then
	
						Dim arrAnswerBook3(6)
		
						For TEQuestion = 1 To 7 Step 1
						
							arrAnswerBook3(0) = arrAnswerBook(0) 	'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided
							arrAnswerBook3(1) = arrAnswerBook(2)	'AnswerOption3 = NotOnRenalTransplantListBecause:Age,GFR,....
							arrAnswerBook3(2) = arrAnswerBook(3)	'AnswerOption4 = ReferredForRenalTransplantation:Yes/No/NA
							arrAnswerBook3(3) = arrAnswerBook(5)	'AnswerOption6 = TransplantWorkInitiated:Yes/No/NA
							arrAnswerBook3(4) = arrAnswerBook(6)	'AnswerOption7 = WasAssistanceProvided:Yes/No/NA
							arrAnswerBook3(5) = arrAnswerBook(8)	'AnswerOption9 = VerbalEducationProvided:Yes/No/NA
							arrAnswerBook3(6) = arrAnswerBook(9)	'AnswerOption10 = SendWrittenMaterials:Yes/No/NA
						
							Select Case TEQuestion
								Case 1:'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided
									If lcase(arrAnswerBook3(TEQuestion-1)) = "yes" Then
										ReqdOption = "683_1670"
									ElseIf lcase(arrAnswerBook3(TEQuestion-1)) = "no" Then
										ReqdOption = "683_1671"
									Else
										ReqdOption = "683_1672"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
								
								Case 2:'AnswerOption3 = NotOnRenalTransplantListBecause:Age,GFR,....
									arrAnswerBook3Specific = Split(arrAnswerBook3(1),",",-1,1)
									For rsn1 = 0 To Ubound(arrAnswerBook3Specific) Step 1
										Reason1 = arrAnswerBook3Specific(rsn1)
										Select Case Reason1
											Case "Age"
												ReqdOption = "685_1675"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "GFR"
												ReqdOption = "685_1676"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Medical Contraindication"
												ReqdOption = "685_1677"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext22","type:=text","visible:=True").Set "mc"
											Case "Not Interested"
												ReqdOption = "685_1678"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Socio-economic Contraindication"
												ReqdOption = "685_1679"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Approval Pending"
												ReqdOption = "685_1680"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Denial"
												ReqdOption = "685_1681"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "On Hold"
												ReqdOption = "685_1682"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext77","type:=text","visible:=True").Set "on hold"
										End Select
									
									Next
									
								Case 3:'AnswerOption4 = ReferredForRenalTransplantation:Yes/No/NA							
									ReqdOption = "686_1683"
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
									
									'Testing link functionality for 'Yes' answer opted for "Has patient been referred for renal transplantation?" pathway question
									If lcase(strTestAll) = "yes" AND Lcase(arrAnswerBook3(2)) = "yes" Then
										blnReferralLink = TestTE_ReferralLink()
										If not blnReferralLink Then
											Exit Function
										End If
									End If								
									
								Case 4:'AnswerOption6 = TransplantWorkInitiated:Yes/No/NA							
									If lcase(arrAnswerBook3(TEQuestion-1)) = "yes" Then
										ReqdOption = "688_1692"
									ElseIf lcase(arrAnswerBook3(TEQuestion-1)) = "no" Then
										ReqdOption = "688_1693"
									Else
										ReqdOption = "688_1694"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 5:'AnswerOption7 = WasAssistanceProvided:Yes/No/NA							
									ReqdOption = "689_1696"
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 6:'AnswerOption9 = VerbalEducationProvided:Yes/No/NA							
									If lcase(arrAnswerBook3(TEQuestion-1)) = "yes" Then
										ReqdOption = "691_1703"
									ElseIf lcase(arrAnswerBook3(TEQuestion-1)) = "no" Then
										ReqdOption = "691_1704"
									Else
										ReqdOption = "691_1705"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 7:'AnswerOption10 = SendWrittenMaterials:Yes/No/NA							
									If lcase(arrAnswerBook3(TEQuestion-1)) = "yes" Then
										ReqdOption = "692_1706"
									ElseIf lcase(arrAnswerBook3(TEQuestion-1)) = "no" Then
										ReqdOption = "692_1707"
									Else
										ReqdOption = "692_1708"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
									'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
									If lcase(strTestAll) = "yes" AND lcase(arrAnswerBook3(6)) = "yes" Then
										blnMaterialLink = TestTE_MaterialLink()
										If not blnMaterialLink Then
											Exit Function
										End If
									End If								
									
								End Select
					
						Next
	
	'Is patient on a renal transplant list = no, Has patient been referred for renal transplantation = no, Was assistance provided in the work up process = yes	
	ElseIf Lcase(strDecidingQuesAnswer1) = "no" AND Lcase(strDecidingQuesAnswer2) = "no" AND Lcase(strDecidingQuesAnswer3) = "yes" Then
	
						Dim arrAnswerBook4(8)
		
						For TEQuestion = 1 To 9 Step 1
						
							arrAnswerBook4(0) = arrAnswerBook(0) 	'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided
							arrAnswerBook4(1) = arrAnswerBook(2)	'AnswerOption3 = NotOnRenalTransplantListBecause:Age,GFR,...
							arrAnswerBook4(2) = arrAnswerBook(3)	'AnswerOption4 = ReferredForRenalTransplantation:Yes/No/NA
							arrAnswerBook4(3) = arrAnswerBook(4)	'AnswerOption5 = NotBeenReferredForReason:GFR/...
							arrAnswerBook4(4) = arrAnswerBook(5)	'AnswerOption6 = TransplantWorkInitiated:Yes/No/NA
							arrAnswerBook4(5) = arrAnswerBook(6)	'AnswerOption7 = WasAssistanceProvided:Yes/No/NA
							arrAnswerBook4(6) = arrAnswerBook(7)	'AnswerOption8 = FollowingAssistanceWasProvided:Referral for dental,Other,..
							arrAnswerBook4(7) = arrAnswerBook(8)	'AnswerOption9 = VerbalEducationProvided:Yes/No/NA
							arrAnswerBook4(8) = arrAnswerBook(9)	'AnswerOption10 = SendWrittenMaterials:Yes/No/NA
	
							Select Case TEQuestion
								Case 1:'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided
									If lcase(arrAnswerBook4(TEQuestion-1)) = "yes" Then
										ReqdOption = "683_1670"
									ElseIf lcase(arrAnswerBook4(TEQuestion-1)) = "no" Then
										ReqdOption = "683_1671"
									Else
										ReqdOption = "683_1672"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
								
								Case 2:'AnswerOption3 = NotOnRenalTransplantListBecause:Age,GFR,...
									arrAnswerBook4Specific = Split(arrAnswerBook4(1),",",-1,1)
									For rsn2 = 0 To Ubound(arrAnswerBook4Specific) Step 1
										Reason2 = arrAnswerBook4Specific(rsn2)
										Select Case Reason2
											Case "Age"
												ReqdOption = "685_1675"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "GFR"
												ReqdOption = "685_1676"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Medical Contraindication"
												ReqdOption = "685_1677"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext22","type:=text","visible:=True").Set "mc"
											Case "Not Interested"
												ReqdOption = "685_1678"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Socio-economic Contraindication"
												ReqdOption = "685_1679"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Approval Pending"
												ReqdOption = "685_1680"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Denial"
												ReqdOption = "685_1681"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "On Hold"
												ReqdOption = "685_1682"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext77","type:=text","visible:=True").Set "on hold"
										End Select
									
									Next
									
								Case 3:'AnswerOption4 = ReferredForRenalTransplantation:Yes/No/NA							
									ReqdOption = "686_1684"
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
									
									'Testing link functionality for 'Yes' answer opted for "Has patient been referred for renal transplantation?" pathway question
									If lcase(strTestAll) = "yes" AND Lcase(arrAnswerBook4(2)) = "yes" Then
										blnReferralLink = TestTE_ReferralLink()
										If not blnReferralLink Then
											Exit Function
										End If
									End If								
									
								Case 4:'AnswerOption5 = NotBeenReferredForReason:GFR/...
										ResonForNotReferred = arrAnswerBook4(3)
										Select Case ResonForNotReferred
											Case "Age"
												ReqdOption = "687_1685"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "GFR"
												ReqdOption = "687_1686"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Medical Contraindication"
												ReqdOption = "687_1687"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
											Case "Not Interested"
												ReqdOption = "687_1688"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Socio-economic Contraindication"
												ReqdOption = "687_1689"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Approval Pending"
												ReqdOption = "687_1690"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Denial"
												ReqdOption = "687_1691"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Pending Referral"
												ReqdOption = "687_1786"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
										End Select
									
								Case 5:'AnswerOption6 = TransplantWorkInitiated:Yes/No/NA							
									If lcase(arrAnswerBook4(TEQuestion-1)) = "yes" Then
										ReqdOption = "688_1692"
									ElseIf lcase(arrAnswerBook4(TEQuestion-1)) = "no" Then
										ReqdOption = "688_1693"
									Else
										ReqdOption = "688_1694"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 6:'AnswerOption7 = WasAssistanceProvided:Yes/No/NA							
									ReqdOption = "689_1695"
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 7:'AnswerOption8 = FollowingAssistanceWasProvided:Referral for dental,Other,..								
									arrAnswerBook4SpecificAP = Split(arrAnswerBook4(6),",",-1,1)
									For aPRO2 = 0 To Ubound(arrAnswerBook4SpecificAP) Step 1
										AsPro2 = arrAnswerBook4SpecificAP(aPRO2)
										Select Case AsPro2
											Case "Referral for testing or screening"
												ReqdOption = "690_1698"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Referral for specialist"
												ReqdOption = "690_1699"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Referral for dental"
												ReqdOption = "690_1700"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
											Case "Coordinate authorization/work-up"
												ReqdOption = "690_1701"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Other"
												ReqdOption = "690_1702"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext44","type:=text","visible:=True").Set "test"
										End Select
									Next
								
								Case 8:'AnswerOption9 = VerbalEducationProvided:Yes/No/NA							
									If lcase(arrAnswerBook4(TEQuestion-1)) = "yes" Then
										ReqdOption = "691_1703"
									ElseIf lcase(arrAnswerBook4(7)) = "no" Then
										ReqdOption = "691_1704"
									Else
										ReqdOption = "691_1705"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 9:'AnswerOption10 = SendWrittenMaterials:Yes/No/NA							
									If lcase(arrAnswerBook4(TEQuestion-1)) = "yes" Then
										ReqdOption = "692_1706"
									ElseIf lcase(arrAnswerBook4(TEQuestion-1)) = "no" Then
										ReqdOption = "692_1707"
									Else
										ReqdOption = "692_1708"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
									
									'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
									If lcase(strTestAll) = "yes" AND lcase(arrAnswerBook4(8)) = "yes" Then
										blnMaterialLink = TestTE_MaterialLink()
										If not blnMaterialLink Then
											Exit Function
										End If
									End If								
									
								End Select
					
						Next
	
	'Is patient on a renal transplant list = no, Has patient been referred for renal transplantation = no, Was assistance provided in the work up process = no	
	ElseIf Lcase(strDecidingQuesAnswer1) = "no" AND Lcase(strDecidingQuesAnswer2) = "no" AND Lcase(strDecidingQuesAnswer3) = "no" Then
	
						Dim arrAnswerBook5(7)
		
						For TEQuestion = 1 To 8 Step 1
						
							arrAnswerBook5(0) = arrAnswerBook(0) 	'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided
							arrAnswerBook5(1) = arrAnswerBook(2)	'AnswerOption3 = NotOnRenalTransplantListBecause:Age,GFR,...
							arrAnswerBook5(2) = arrAnswerBook(3)	'AnswerOption4 = ReferredForRenalTransplantation:Yes/No/NA
							arrAnswerBook5(3) = arrAnswerBook(4)	'AnswerOption5 = NotBeenReferredForReason:GFR/...
							arrAnswerBook5(4) = arrAnswerBook(5)	'AnswerOption6 = TransplantWorkInitiated:Yes/No/NA
							arrAnswerBook5(5) = arrAnswerBook(6)	'AnswerOption7 = WasAssistanceProvided:Yes/No/NA
							arrAnswerBook5(6) = arrAnswerBook(8)	'AnswerOption9 = VerbalEducationProvided:Yes/No/NA
							arrAnswerBook5(7) = arrAnswerBook(9)	'AnswerOption10 = SendWrittenMaterials:Yes/No/NA
						
							Select Case TEQuestion
								Case 1:'AnswerOption1 = PatientOnRenalTransplantList:Yes/No/Undecided
									If lcase(arrAnswerBook5(TEQuestion-1)) = "yes" Then
										ReqdOption = "683_1670"
									ElseIf lcase(arrAnswerBook5(TEQuestion-1)) = "no" Then
										ReqdOption = "683_1671"
									Else
										ReqdOption = "683_1672"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
								
								Case 2:'AnswerOption3 = NotOnRenalTransplantListBecause:Age,GFR,...
									arrAnswerBook5Specific = Split(arrAnswerBook5(1),",",-1,1)
									For rsn3 = 0 To Ubound(arrAnswerBook5Specific) Step 1
										Reason3 = arrAnswerBook5Specific(rsn3)
										Select Case Reason3
											Case "Age"
												ReqdOption = "685_1675"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "GFR"
												ReqdOption = "685_1676"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Medical Contraindication"
												ReqdOption = "685_1677"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext22","type:=text","visible:=True").Set "mc"
											Case "Not Interested"
												ReqdOption = "685_1678"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Socio-economic Contraindication"
												ReqdOption = "685_1679"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Approval Pending"
												ReqdOption = "685_1680"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Denial"
												ReqdOption = "685_1681"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "On Hold"
												ReqdOption = "685_1682"
												objTE_Page.WebElement("class:=acp-chkbox.*","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
												objTE_Page.WebEdit("html tag:=INPUT","name:=freeformtext77","type:=text","visible:=True").Set "on hold"
										End Select
									
									Next
									
								Case 3:'AnswerOption4 = ReferredForRenalTransplantation:Yes/No/NA							
									ReqdOption = "686_1684"
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
									
									'Testing link functionality for 'Yes' answer opted for "Has patient been referred for renal transplantation?" pathway question
									If lcase(strTestAll) = "yes" AND Lcase(arrAnswerBook5(2)) = "yes" Then
										blnReferralLink = TestTE_ReferralLink()
										If not blnReferralLink Then
											Exit Function
										End If
									End If								
										
								Case 4:'AnswerOption5 = NotBeenReferredForReason:GFR/...
										ResonForNotReferred1 = arrAnswerBook5(3)
										Select Case ResonForNotReferred1
											Case "Age"
												ReqdOption = "687_1685"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "GFR"
												ReqdOption = "687_1686"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Medical Contraindication"
												ReqdOption = "687_1687"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
											Case "Not Interested"
												ReqdOption = "687_1688"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Socio-economic Contraindication"
												ReqdOption = "687_1689"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Approval Pending"
												ReqdOption = "687_1690"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Health Plan Denial"
												ReqdOption = "687_1691"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
											Case "Pending Referral"
												ReqdOption = "687_1786"
												objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click
										End Select
									
								Case 5:'AnswerOption6 = TransplantWorkInitiated:Yes/No/NA							
									If lcase(arrAnswerBook5(TEQuestion-1)) = "yes" Then
										ReqdOption = "688_1692"
									ElseIf lcase(arrAnswerBook5(TEQuestion-1)) = "yes" Then
										ReqdOption = "688_1693"
									Else
										ReqdOption = "688_1694"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 6:'AnswerOption7 = WasAssistanceProvided:Yes/No/NA
								
									ReqdOption = "689_1696"
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 7:'AnswerOption9 = VerbalEducationProvided:Yes/No/NA							
									If lcase(arrAnswerBook5(TEQuestion-1)) = "yes" Then
										ReqdOption = "691_1703"
									ElseIf lcase(arrAnswerBook5(TEQuestion-1)) = "no" Then
										ReqdOption = "691_1704"
									Else
										ReqdOption = "691_1705"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
								Case 8:'AnswerOption10 = SendWrittenMaterials:Yes/No/NA							
									If lcase(arrAnswerBook5(TEQuestion-1)) = "yes" Then
										ReqdOption = "692_1706"
									ElseIf lcase(arrAnswerBook5(TEQuestion-1)) = "no" Then
										ReqdOption = "692_1707"
									Else
										ReqdOption = "692_1708"
									End If
									objTE_Page.WebElement("class:=acp-radio","html tag:=DIV","visible:=True","html id:="&ReqdOption).Click	
									
									'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
									If lcase(strTestAll) = "yes" AND lcase(arrAnswerBook5(7)) = "yes" Then
										blnMaterialLink = TestTE_MaterialLink()
										If not blnMaterialLink Then
											Exit Function
										End If
									End If								
									
								End Select
					
						Next	
	
	End If
	Wait 1
	'------------------------------------------
	'TE Comments part
	strComment = arrAnswerBook(10)
	strIncludePatientComment = arrAnswerBook(11)
	strIncludeProviderComment = arrAnswerBook(12)
	
	'set comment
	Err.Clear
	objTE_Comments.Set strComment
	If err.number <> 0 Then
		strOutErrorDesc = "Transplant Evaluation comment is not set"
		Exit Function	
	End If
	Call WriteToLog("Pass", "Provided comment for pathway")
	
	'check required check boxes
	Err.Clear
	If lcase(strIncludePatientComment) = "yes" Then
		objTE_PatientCommentCB.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Transplant Evaluation patinet comment is not set"
			Exit Function	
		End If
		Call WriteToLog("Pass", "Transplant Evaluation patinet comment is set")
	End If
		
	If lcase(strIncludeProviderComment) = "yes" Then
		objTE_ProviderCommentCB.Click
		If err.number <> 0 Then
			strOutErrorDesc = "Transplant Evaluation provider comment is not set"
			Exit Function	
		End If
		Call WriteToLog("Pass", "Transplant Evaluation provider comment is set")
	End If	

	'------------------------------------------------
	'Validate Cancel and Postpone functionalities if required
	If Lcase(strTestAll)  = "yes" Then
		blnTE_Cancel_PostponeValidation = TE_Cancel_PostponeValidation()
		If not blnTE_Cancel_PostponeValidation Then
			Exit Function
		End If
	End If 
	'------------------------------------------------
	Wait 2
		
	'Now save the pathway - 'validating SAVE btn
	If objTE_SaveBtn.Object.isDisabled Then
		strOutErrorDesc = "Transplant Evaluation Save btn is disabled after pathway"
		Exit Function
	End If
	Call WriteToLog("Pass", "Save button is enabled after pathway")
	
	'Click on Save btn
	blnClickedSaveBtn = ClickButton("Save",objTE_SaveBtn,strOutErrorDesc)
	If not blnClickedSaveBtn Then
		strOutErrorDesc = "Save button click returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Save button clicked")
	Wait 2
	
	Call waitTillLoads("Saving pathway...")
	Wait 2
	
	'if tried to perform transplant evaluation pathway at offshore forenoon, then msgbox with OK button is available. Handling the same.
	Execute "Set objErrorButton = "&Environment("WB_ErrorButton")
	If objErrorButton.Exist(3) Then
		Err.Clear		
		objErrorButton.click
		If Err.Number <> 0 Then
			strOutErrorDesc = "After clicking Save button, 'CompletedDate cannot be older than 7 days from today's date and cannot be greater than today's date' msg box is available. Unable to click OK button in this msg box: "&strOutErrorDesc
			Exit Function
		Else
			Call WriteToLog("Warning", "After clicking Save button, 'CompletedDate cannot be older than 7 days from today's date and cannot be greater than today's date' msg box is available. Clicked on OK button in this msg box. Pathway is not saved due to time constraints. Note: Pathway should be performed afternoon if script executed offshore")
			Exit Function
		End If
	End If
	
	'Validate pathway date
	If Instr(1,Trim(objTE_Date.GetROProperty("outertext")),dtScreeningDate,1) > 0  Then
		Call WriteToLog("Pass", "Pathway date validated")
	Else
		strOutErrorDesc = "Unable to validate pathway date"
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Completed Transplant Evaluation pathway successfully")
	
	TransplantEvaluation = True
	
	Execute "Set objTE_Page = Nothing"
	Execute "Set objTE_Header = Nothing"
	Execute "Set objTE_AddBtn = Nothing"
	Execute "Set objTE_SaveBtn = Nothing"
	Execute "Set objTE_Comments = Nothing"
	Execute "Set objTE_PatientCommentCB = Nothing"
	Execute "Set objTE_ProviderCommentCB = Nothing"
	Execute "Set objTE_Date = Nothing"

End Function

'================================================================================================================================================================================================
'Function Name       :	ProvideLabValue
'Purpose of Function :	1.Perform TransplantEvaluation pathway, 2.validate other functionalities - Add,Postpone,Save,Cancel,History, Validate all Links connecting to other sceens, messages etc.. 
'Input Arguments     :	dtDrawDate: date value representing lab draw date - which will be applied for all lab values initially
'					 :	strFieldAndValue: string value representing lab (consisting of Field and corresponding Value delimited with "=") . If more than one lab is required, labs should be delimited by ","
'					 :	dtSpecificLabDate: value representing date for specific lab. If more labs are present, then dates should be delimited by ",". If date is not required by a lab, then put "NA" for that particular lab
'					 :	strDipstickForProtein = string value representing DipstickForProtein dropdown value. If no vaule is required write "NA"
'Output Arguments    :	Boolean value: representing status of lab field entry
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnProvideLabValues =  ProvideLabValue(dtRequiredDrawDate, strLabFieldAndValue, dtSpecificLabDate, strDipstick, strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	15 October 2015
'================================================================================================================================================================================================

Function ProvideLabValue(ByVal dtDrawDate, ByVal strFieldAndValue, ByVal dtSpecificLabDate, ByVal strDipstickForProtein, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ProvideLabValue = False

	Execute "Set objLabPage ="&Environment("WPG_AppParent")
	Execute "Set objLab_Header ="&Environment("WEL_Lab_Header")
	Execute "Set objLab_Add ="&Environment("WEL_Lab_Add")
	Execute "Set objLab_Date ="&Environment("WE_Lab_Date")
	Execute "Set objLab_Save ="&Environment("WEL_Lab_Save")
	Execute "Set objLab_DipstickForProtein ="&Environment("WB_Lab_Dipstick")
	
	'Verify whether user is navigated to 'Labs' screen
	If not objLab_Header.Exist(10) Then
		strOutErrorDesc = "Lab screen is not available"
		Exit Function
	End If
	Wait 1
	Call WriteToLog("Pass", "Navigated to Labs screen")
	
	'Click on Add button
	If not objLab_Add.Object.isDisabled Then		
		blnLabAddClicked = ClickButton("Add",objLab_Add,strOutErrorDesc)
		If Not blnLabAddClicked Then
			strOutErrorDesc = "Lab screen Add btn click returned error: "&strOutErrorDesc
			Exit Function
		End If
	End If 
	Wait 2

	'Set required drawdate
	Err.Clear
	objLab_Date.Set dtDrawDate
	If Err.Number <> 0 Then
		strOutErrorDesc  = "Unable to set DrawDate: "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Draw date is set to '"&dtDrawDate&"'")
	Wait 1

	'Providing required lab field values and lab dates
	arrFieldValues = Split(strFieldAndValue,",",-1,1)
	arrLabDates =  Split(dtSpecificLabDate,",",-1,1)
	
	For FV = 0 to UBound(arrFieldValues)
	
		arrFieldValues(FV) = Trim(Replace(arrFieldValues(FV),"=","",1,-1,1))
		
		'getting values	
		For i = 1 To Len(arrFieldValues(FV)) Step 1
			intVal = Mid(arrFieldValues(FV),i,1)
			If IsNumeric(intVal) OR intVal = "." then
				intValue = intValue&intVal
			End If
		Next
	
		'gettiing fields
		strField = Trim(Replace(arrFieldValues(FV),intValue,"",1,-1,1))
		Select Case lcase(Replace(strField," ","",1,-1,1))
			Case "height" 
				strRequiredField = "Height"		
			Case "weight" 
				strRequiredField = "Weight"
			Case "targetweight" 
				strRequiredField = "TargetDryWeight"
			Case "calciumxphosphorous" 
				strRequiredField = "CalciumXPhosphorous"
			Case "phosphorous" 
				strRequiredField = "Phosphorous"
			Case "creatinine" 
				strRequiredField = "Creatinine"
			Case "gfr" 
				strRequiredField = "GFR"
			Case "hgbac" 
				strRequiredField = "HgbA1C"
			Case "ldl" 
				strRequiredField = "LDL"
			Case "urr" 
				strRequiredField = "URR"
			Case "potassium" 
				strRequiredField = "Potassium"
			Case "hepatitisbtiter" 
				strRequiredField = "Hepatitisbtiter"
			Case "bloodpressuresystolic" 
				strRequiredField = "BPSys"
			Case "bloodpressurediastolic" 
				strRequiredField = "BPDia"
			Case "hgb" 
				strRequiredField = "Hgb"
			Case "ferritin" 
				strRequiredField = "Ferritin"
			Case "tsat" 
				strRequiredField = "TSAT"
			Case "albumin" 
				strRequiredField = "Albumin"
			Case "urinealbumin/creatinineratio" 
				strRequiredField = "UrineAlbuminCreatinineRatio"	
			Case "carbondioxidelevel" 
				strRequiredField = "Co2Level"
			Case "serumcalcium" 
				strRequiredField = "Calcium"
			Case "kt/v" 
				strRequiredField = "KTV"
			Case "pth" 
				strRequiredField = "PTH"				
				
		End Select
		
		'getting lab date
		If Trim(LCase(arrLabDates(FV))) = "na" Then
			dtLabDate = ""
		Else
			dtLabDate = arrLabDates(FV)
		End If
					
		intRequiredValue = Trim(intValue)
		strRequiredField = Trim(strRequiredField)
		dtLabDate = Trim(dtLabDate)
		
		Execute "Set objLabPage = Nothing"
		Execute "Set objLabPage ="&Environment("WPG_AppParent")
		Set objLabField = objLabPage.WebEdit("class:=.*TextBox ng-pristine.*","html tag:=INPUT","name:=WebEdit","outerhtml:=.*'"&strRequiredField&"'.*","visible:=True")
		
		Execute "Set objLabPage = Nothing"
		Execute "Set objLabPage ="&Environment("WPG_AppParent")
		Set objLabDate = objLabPage.WebEdit("class:=form-control.*","html tag:=INPUT","name:=WebEdit","outerhtml:=.*'"&strRequiredField&"'.*","visible:=True")
		
		Err.Clear		
		objLabField.Set intRequiredValue
		If dtLabDate <> "" Then
			Err.Clear
			objLabDate.Set dtLabDate
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to set lab date for '"&strRequiredField&"' field"
				Exit Function
			End If
			Call WriteToLog("Pass","'"&dtLabDate&"' is set for '"&strRequiredField&"' field")
		End If		
				
		strField = ""
		intValue = ""
		strRequiredField = ""
		intRequiredValue = ""
		objLabDate = ""
		Set objLabField = Nothing
		Set objLabDate = Nothing
		Wait 1
	
	Next
	
'----------------------------------------------------------------------	
'Selecting Dipstick value as required
	If strDipstickForProtein = "" Then
		strDipstickForProtein = "NA"
	End If
	If lcase(strDipstickForProtein) <> "na" Then
		Err.Clear
		objLab_DipstickForProtein.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'DipstickForProtein' dropdown"
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked 'Dipstick for Protein' dropdown")
		
		Execute "Set objLabPage = Nothing"
		Execute "Set objLabPage ="&Environment("WPG_AppParent")
		Set objDipstick = objLabPage.WebElement("html tag:=A","outertext:=.*"&strDipstickForProtein&".*","visible:=True")
		Err.Clear
		objDipstick.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to select '"&strDipstickForProtein&"' from 'DipstickForProtein' dropdown"
			Exit Function
		End If
		Call WriteToLog("Pass","Selected '"&strDipstickForProtein&"' from 'DipstickForProtein' dropdown")	
	End If
'----------------------------------------------------------------------	

	'Click on Save btn
	blnLabSaveClicked = ClickButton("Save",objLab_Save,strOutErrorDesc)
	If Not blnLabSaveClicked Then
		strOutErrorDesc  = "Lab screen Save btn click returned error: "&strOutErrorDesc
		Exit Function
	End If
	Wait 2
	
	Call waitTillLoads("Saving Lab...")
	Call waitTillLoads("Saving Current Lab...")
	Wait 2
	
	'Validate Save confirmation message
	blnSavedLabConfirmation = checkForPopup("Changes Saved", "Ok", "Changes saved successfully.", strOutErrorDesc)
	If Not blnSavedLabConfirmation Then
		strOutErrorDesc  = "Save action is not confirmed: "&strOutErrorDesc
		Exit Function
	End If
	Wait 2
	
	ProvideLabValue = True

	Execute "Set objLabPage = Nothing"
	Execute "Set objLab_Header = Nothing"
	Execute "Set objLab_Add = Nothing"
	Execute "Set objLab_Date = Nothing"
	Execute "Set objLab_Save = Nothing"
	Execute "Set objLab_DipstickForProtein = Nothing"
	Set objDipstick = Nothing
	
	
End Function

'#######################################################################################################################################################################################################
'Function Name			:	VerifyNewNoteComponentForComplaintsList
'Purpose of Function	:	Purpose of this function to verify that New Note Component in comorbids screen
'Input Arguments		:	None
'Output Arguments		:	boolean
'Example of Call		:	blnComponentVerified = VerifyNewNoteComponentForComplaintsList(strOutErrorDesc)
'Author					:	Piyush Chandana
'Date					:	11-Nov-2014
'####################################################################################################################################################################################

Function VerifyNewNoteComponentForComplaintsList(strOutErrorDesc)
	
	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
	VerifyNewNoteComponentForComplaintsList = False
	
	strMessageBoxTitle = DataTable.Value("PopupTitle","CurrentTestCaseData")
	strMessageBoxText = DataTable.Value("DeleteComplaintMessage","CurrentTestCaseData")
	
	Execute "Set objComplaintsTitle = " & Environment("WE_Comorbid_ComplaintTitle") 'Complaint title
	Execute "Set objComplaintsDescription = " & Environment("WE_Comorbid_ComplaintDetails") 'Complaint Details
	Execute "Set objSaveIcon = " & Environment("WEL_Comorbid_SaveIcon") 'Comaplaint Save Icon
	Execute "Set objDeleteComplaintIcon = " & Environment("WEL_Comorbid_DeleteIcon") 'Complaints Delete Icon
	Execute "Set objPopupTitle = " & Environment("WEL_Comorbid_PopupTitle")
	Execute "Set objPopupText = " & Environment("WEL_PopUp_Text")
	Execute "Set objYesButton = " & Environment("WB_YES")
	
	'Title to complaint exist
	If CheckObjectExistence(objComplaintsTitle,intWaitTime/2) Then
		blnComponentVerified = True
		Call WriteToLog("Pass","Complaints title edit field exist")
	Else
		strOutErrorDesc = "Complaints title edit field does not exist"
		Exit Function	
	End If
	
	'Description to complaints exist
	If CheckObjectExistence(objComplaintsDescription,intWaitTime/2) Then
		Call WriteToLog("Pass","Complaints description edit field exist")
	Else
		strOutErrorDesc = "Complaints description edit field does not exist"
		Exit Function	
	End If
	
	'Save button exist
	If CheckObjectExistence(objSaveIcon,intWaitTime/2) Then
		Call WriteToLog("Pass","Save complaints button exist in complain list section")
	Else
		strOutErrorDesc = "Save complaints button does not exist in complain list section"
		Exit Function	
	End If
	
	'Verify that date exist in complaints section 
	strToday= GetDateFormat("mm/dd/yyyy",Now())
	Set objDate = GetChildObject("micclass;html tag;innertext","WebElement;SPAN;"&Trim(strToday))
	
	i = objDate.Count - 1
	If objDate(i).Exist(2) Then
		Call WriteToLog("Pass","Date exist in complaints list when we click on add button")
	Else
		strOutErrorDesc = "Date does not exist in complaints list when we click on add button"
		Exit Function	
	End If
	
	'Verify that Cancel button exist
'	If CheckObjectExistence(objDeleteComplaintIcon,intWaitTime/2) Then
'		Call WriteToLog("Pass","Delete complaints icon exist")
'		objDeleteComplaintIcon.Click		
'	Else
'		strOutErrorDesc = "Delete complaints icon does not exist"
'		Exit Function
'	End If
'	
'	wait 2
'	waitTillLoads "Loading..."
'	wait 2
'	
'	blnReturnValue = checkForPopup(strMessageBoxTitle, "Yes", strMessageBoxText, strOutErrorDesc)
'	If blnReturnValue Then
'		Call WriteToLog("Pass","Comorbids delete complaints message box exist with text stating "&strMessageBoxText&" on screen")
'	Else
'		strOutErrorDesc = "CheckMessageBoxExist returned: "&strOutErrorDesc
'		Exit Function	
'	End If
'
	Wait intWaitTime/2
	VerifyNewNoteComponentForComplaintsList = True
	
End Function

'#######################################################################################################################################################################################################
'Function Name			:	AddComplaintsToComorbids
'Purpose of Function	:	Purpose of this function to Add New complaints to complaint list of comorbid screen		
'Input Arguments		:	strComplaintTitle -> string title of the new complaints which is need to created
'						:	strComplaintDescription -> string Description of the new complaints which is need to created
'Output Arguments		:	boolean Value - True or False
'						:   strOutErrorDesc : String value which contains detail error message occurred (if any) during function execution
'Prerequisite			:   Coomorbids screen should be open
'Example of Call		:	blnComplaintAdded = AddComplaintsToComorbids("Title","Description",strOutErrorDesc)
'Author					:	Piyush Chandana
'Date					:	11-Nov-2014
'####################################################################################################################################################################################

Function AddComplaintsToComorbids(ByVal strComplaintTitle,ByVal strComplaintDescription,strOutErrorDesc)
	
	strOutErrorDesc = "" 
	Err.Clear
	On Error Resume Next
	AddComplaintsToComorbids = False
	
	'=====================================
	'Objects required for Function
	'=====================================
	Execute "Set objComplaintsList = " & Environment("WEL_Comorbid_ActiveComplaintsList")
	Execute "Set objComplaintsAddButton = " & Environment("WB_Comorbid_Complaints_AddButton")
	Execute "Set objComplaintsTitle = " & Environment("WE_Comorbid_ComplaintTitle")
	Execute "Set objComplaintsDescription = " & Environment("WE_Comorbid_ComplaintDetails")
	Execute "Set objSaveButton = " & Environment("WEL_Comorbid_SaveIcon") 
	
	'Check Complaints list Active complaint count comorbid screen
	If CheckObjectExistence(objComplaintsList,intWaitTime) Then
		
		Call WriteToLog("Pass","Complaints List exist on comorbids screen")
		
		'Verify the active complanits count
		strComplaintsList = objComplaintsList.GetROProperty("innertext")
		arrComplaintsList = Split(strComplaintsList,"(")
		intActiveComplaints = Split(arrComplaintsList(1),")")
		
		If IsNumeric(intActiveComplaints(0)) Then
			Call WriteToLog("Pass","Complaints list has "&Trim(intActiveComplaints(0))&" active complaints")
		Else	
			strOutErrorDesc = "Complaints lsit has not inactive complaints in numeric value"
			Exit Function
		End If
	Else
		strOutErrorDesc = "Complaints List does not exist on comorbids screen"
		Exit Function
	End If
	
	'Verify that Add button in complaint list should exist and click on the same
	If Not CheckObjectExistence(objComplaintsTitle,intWaitTime/2) Then
		If CheckObjectExistence(objComplaintsAddButton,intWaitTime/2) Then
			Call WriteToLog("Pass","Add button exist in complaints list")
			objComplaintsAddButton.Click
		Else
			strOutErrorDesc = "Add button does not exist in complaints list"
			Exit Function
		End If	
	End If
	
	'Add title to complaint
	If CheckObjectExistence(objComplaintsTitle,intWaitTime/2) Then
		objComplaintsTitle.Set strComplaintTitle
	Else
		strOutErrorDesc = "Complaints title edit field does not exist"
		Exit Function	
	End If
	
	'Add description to complaints
	If CheckObjectExistence(objComplaintsDescription,intWaitTime/2) Then
		objComplaintsDescription.Set strComplaintDescription
	Else
		strOutErrorDesc = "Complaints description edit field does not exist"
		Exit Function	
	End If
		
	'Click on save button
	If CheckObjectExistence(objSaveButton,intWaitTime/2) Then
		objSaveButton.Click
	Else
		strOutErrorDesc = "Save complaints button does not exist in complain list section"
		Exit Function
	End If
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	'Verify that Active complaints is increased
	If CheckObjectExistence(objComplaintsList,intWaitTime) Then
		Call WriteToLog("Pass","Complaints List exist on comorbids screen")
		
		'Verify the active complaits count
		strComplaintsListNew = objComplaintsList.GetROProperty("innertext")
		arrComplaintsListNew = Split(strComplaintsListNew,"(")
		intIncreasedActiveComplaints = Split(arrComplaintsListNew(1),")")
		
		If IsNumeric(intIncreasedActiveComplaints(0)) and Trim(intIncreasedActiveComplaints(0)) > Trim(intActiveComplaints(0)) Then
			Call WriteToLog("Pass","Active complaints count is increased from "&Trim(intActiveComplaints(0))&" to "& Trim(intIncreasedActiveComplaints(0)))
			blnComplaintsAdded = True
		Else	
			strOutErrorDesc = "Active complaints count is not increased"
			Exit Function
		End If
	Else
		strOutErrorDesc = "Complaints List does not exist on comorbids screen"
		Exit Function
	End If
	
	AddComplaintsToComorbids = True
	
End Function

'#######################################################################################################################################################################################################
'Function Name			:	clickOnComorbidsMessageBox
'Purpose of Function	:	Purpose of this function to Add New complaints to complaint list of comorbid screen		
'Input Arguments		:	strComplaintTitle -> string title of the new complaints which is need to created
'Output Arguments		:	boolean Value - True or False
'						:   strOutErrorDesc : String value which contains detail error message occurred (if any) during function execution
'Prerequisite			:   Comorbids screen should be open
'Example of Call		:	blnComplaintDeleted = DeleteComplaintsFromComorbidScreen(strComplaintTitle,strOutErrorDesc)
'Author					:	Piyush Chandana
'Date					:	11-Nov-2014
'####################################################################################################################################################################################

Function clickOnComorbidsMessageBox(ByVal title, ByVal buttonName, ByVal alertText, strOutErrorDesc)

    clickOnComorbidsMessageBox = False
    Set objPage = getPageObject()
    
    'check if the required pop up with title exists
    Set customPopupDesc = Description.Create
    customPopupDesc("micclass").Value = "WebElement"
    customPopupDesc("class").Value = "row title-gradient title-header.*"
    customPopupDesc("class").regularExpression = true
    customPopupDesc("innertext").Value = ".*" & trim(title) & ".*"
    customPopupDesc("innertext").regularExpression = true
    
    Set objCustomPopUp = objPage.ChildObjects(customPopupDesc)
    
    If Not isObject(objCustomPopUp) Then
        strOutErrorDesc = "No pop up found with title '" & title & "'."
        Set objPage = Nothing
        Set customPopupDesc = Nothing
        Set objCustomPopUp = Nothing
        Exit Function
    End If
    
    Set popupBodyDesc = Description.Create
    popupBodyDesc("micclass").Value = "WebElement"
    popupBodyDesc("class").Value = "modal.*"
    popupBodyDesc("class").regularExpression = true
    Set objPopupBody = objPage.ChildObjects(popupBodyDesc)
    
    If Not isObject(objPopupBody) Then
        strOutErrorDesc = "No pop up body found"
        Set popupBodyDesc = Nothing
        Set objPopupBody = Nothing
        Set objCustomPopUp = Nothing
        Set customPopupDesc = Nothing
        Set objPage = Nothing
        Exit Function
    End If

    'verify if required text exists
    Set alertTextDesc = Description.Create
    alertTextDesc("micClass").Value = "WebElement"
    alertTextDesc("html tag").Value = ".*B.*"
        
    Dim popUpFound : popUpFound = False
    For i = 0 To objPopupBody.Count - 1
        Set objAlertText = objPopupBody(i).ChildObjects(alertTextDesc)
        objPopupBody(i).highlight
        If Not isObject(objAlertText) Then
            strOutErrorDesc = "No pop up body found"
            Set popupBodyDesc = Nothing
            Set objPopupBody = Nothing
            Set objCustomPopUp = Nothing
            Set customPopupDesc = Nothing
            Set objPage = Nothing
            Set alertTextDesc = Nothing
            Set objAlertText = Nothing
            Exit Function
        End If
    
        Dim popUpAlertText : popUpAlertText = ""
        For j = 0 To objAlertText.Count - 1
            popUpAlertText = popUpAlertText & objAlertText(j).getROProperty("innertext") & ";"
        Next
                
        If Instr(lcase(popUpAlertText), lcase(alertText)) > 0 Then
            Set buttonDesc = Description.Create
            buttonDesc("micclass").Value = "WebButton"
            buttonDesc("name").Value = buttonName
            'buttonDesc("class").Value = "btn-custom-model btn-custom-gradient"
            objPopupBody(i).highlight
            Set objButton = objPopupBody(i).WebButton(buttonDesc)
            objButton.Click
                
            Call WriteToLog("Pass", "Clicked '" & buttonName & "' button on the message box.")
            Set objButton = Nothing
                
            wait 3
            Err.Clear
            clickOnComorbidsMessageBox = True
            popUpFound = True
            Exit For
        End If
        
    Next
    
    
    If Not popUpFound Then
        strOutErrorDesc = "No Message Box exist with required text."
    End If    
    
    
    Set popupBodyDesc = Nothing
    Set objPopupBody = Nothing
    Set objCustomPopUp = Nothing
    Set buttonDesc = Nothing
    Set customPopupDesc = Nothing
    Set alertTextDesc = Nothing
    Set objAlertText = Nothing
    Set objPage = Nothing
    
End Function

'
'Function DeleteComplaintsFromComorbidScreen(strComplaintTitle,strOutErrorDesc)
'	
'	strOutErrorDesc = ""
'	Err.Clear
'	On Error Resume Next
'	DeleteComplaintsFromComorbidScreen = False
'	
'	strMessageBoxTitle = DataTable.Value("PopupTitle","CurrentTestCaseData")
'	strDeleteComplaintMessage = DataTable.Value("DeleteComplaintMessage","CurrentTestCaseData")
'	
'	'Check the Complaints counts in complaints history and Complains history should be collapse mode
'	Execute "Set objComplaintsHistory = " & Environment.Value("DictObject").Item("WEL_Comorbid_ComplaintsHistory")
'	Execute "Set objComplaintHistoryTable = " & Environment.Value("DictObject").Item("WEL_Comorbid_ComplaintsHistoryTable")
'	
''	If objComplaintsHistory.Exist(3) and Not objComplaintHistoryTable.Exist(3) Then
''		Call WriteToLog("Pass","Complaints history widget is in collapse mode.")
''		
''		'=========================
''		'Verify the inactive count
''		'=========================
''		strComplaintsHistory = objComplaintsHistory.GetROProperty("innertext")
''		arrComplaintsHitory = Split(strComplaintsHistory,"(")
''		intInactiveComplaints = Split(arrComplaintsHitory(1),")")
''		
''		If IsNumeric(intInactiveComplaints(0)) Then
''			Call WriteToLog("Pass","Complaints history has "&intInactiveComplaints(0)&" inactive complaints")
''		Else	
''			strOutErrorDesc = "Complaints history has not inactive complaints in numeric value"
''			Exit Function
''		End If
''	Else
''		strOutErrorDesc = "Complaints history widget is not in collapse mode."
''		Exit Function
''	End If
'	
'	'Delete the Complaint from active complaints list
'	Set objComplaintsItems = GetChildObject("micclass;html tag;class","WebElement;LI;.*listItemOfComplaint.*")
'	Set objExpandActiveComplaintsIcon = GetChildObject("micclass;html tag;innertext","WebElement;SPAN;►")
'	For i = 0 To objComplaintsItems.Count-1 Step 1
'		strComplaintsText = objComplaintsItems(i).GetROProperty("innertext")
'		If InStr(1,strComplaintsText,strComplaintTitle,1) > 0 Then
'			
'			If objExpandActiveComplaintsIcon(i).Exist(2) Then
'				Err.Clear
'				'Click on expand of first complaints icon
'				objExpandActiveComplaintsIcon(i).Click
'				If Err.Number = 0 Then
'					Call WriteToLog("Pass","Complaint expand icon click successfully")
'				Else
'					strOutErrorDesc = "Complaint expand icon does not click successfully"
'					Exit Function	
'				End If
'			Else
'				strOutErrorDesc = "Complaint expand icon does not exist"
'				Exit Function	
'			End If
'			
'			'Delete complaints icon exist and clicked successfully
'			Set objDeleteComplaintIcon = GetChildObject("micclass;class;file name;html tag","Image;.*complainListIcons.*;icon_vh_closeSmall\.png;IMG")
'			blnReturnValue = objDeleteComplaintIcon(i).WaitProperty("visible","True",10000)
'			If blnReturnValue Then
'				Call WriteToLog("Pass","Delete complaints icon exist")	
'				Err.Clear
'				
'				'Click on Delete complaints button
'				objDeleteComplaintIcon(i).Click
'				If Err.Number = 0 Then
'					Call WriteToLog("Pass","Delete complaints icon click successfully")
'				Else
'					strOutErrorDesc = "Delete complaints icon does not click successfully"
'					Exit Function	
'				End If 
'			Else
'				strOutErrorDesc = "Delete complaints icon does not exist"
'				Exit Function
'			End If
'			
'			Wait iintWaitTime
'			
'			'Verify the delete complaint message box and Click on Yes button of Comorbids message box 
'			Execute "Set objPopupTitle = " & Environment.Value("DictObject").Item("WEL_Comorbid_PopupTitle")
'			Execute "Set objPopupText = " & Environment.Value("DictObject").Item("WEL_PopUp_Text")
'			Execute "Set objYesButton = " & Environment.Value("DictObject").Item("WB_YES")
'			blnReturnValue = CheckMessageBoxExist(objPopupTitle,strMessageBoxTitle,objPopupText,strDeleteComplaintMessage,"WB_YES|WB_NO","Yes",strOutErrorDesc)
'			If blnReturnValue Then
'				Call WriteToLog("Pass","Comorbids delete complaints message box exist with text stating "&strDeleteComplaintMessage&" on screen")
'				blnReturnValue = ClickButton("Yes button",objYesButton,strOutErrorDesc)
'				If Not blnReturnValue Then
'					Call WriteToLog("Fail","ClickButton returns: "&strOutErrorDesc)
'					Call WriteLogFooter()
'					ExitAction
'				End If
'			Else
'				strOutErrorDesc = "CheckMessageBoxExist returned: "&strOutErrorDesc
'				Exit Function	
'			End If
'		Else
'			strOutErrorDesc = "Complaint item does not exist with Title: "&strComplaintTitle
'			Exit Function	
'		End If
'	Next
'	
'	Wait intWaitTime
'	'Verify that complaints for strComplaints title deleted successfully
'	Set objComplaintsItems = GetChildObject("micclass;html tag;class","WebElement;LI;.*listItemOfComplaint.*")
'	If objComplaintsItems.Count = 0 Then
'		Call WriteToLog("Pass","Complaint item deleted successfully")
'	Elseif	objComplaintsItems.Count > 0 Then
'		For j = 0 To objComplaintsItems.Count-1 Step 1
'			strComplaintsText = objComplaintsItems(j).GetROProperty("innertext")
'			If InStr(1,strComplaintsText,strComplaintTitle,1) = 0 Then
'				Call WriteToLog("Pass","Complaint item deleted successfully")
'			Else
'				strOutErrorDesc = "Complaint item not deleted successfully"
'				Exit Function	
'			End If
'		Next
'	End If
'
'	'Verify that Complaints from complaints list is successfully deleted and History inactive count is increased
'	Execute "Set objComplaintsHistory = " & Environment.Value("DictObject").Item("WEL_Comorbid_ComplaintsHistory")
'	strComplaintsHistory = objComplaintsHistory.GetROProperty("innertext")
'	arrComplaintsHitory = Split(strComplaintsHistory,"(")
'	intIncreasedInactiveComplaints = Split(arrComplaintsHitory(1),")")
'	
'	If IsNumeric(intInactiveComplaints(0)) and intIncreasedInactiveComplaints(0) > intInactiveComplaints(0) Then
'		Call WriteToLog("Pass","Complaints history inactive count is changed from "&Trim(intInactiveComplaints(0))&" to "&Trim(intIncreasedInactiveComplaints(0)))
'	Else	
'		strOutErrorDesc = "Complaints history inactive count is not changed"
'		Exit Function
'	End If
'	
'	DeleteComplaintsFromComorbidScreen = True
'	
'End Function

'#######################################################################################################################################################################################################
'Function Name			:	GetCountOfInactiveComplaints
'Purpose of Function	:	Purpose of this function to get the count inactive complaints of comorbid screen	
'Input Arguments		:	None
'Output Arguments		:	Integer
'						:   strOutErrorDesc : String value which contains detail error message occurred (if any) during function execution
'Prerequisite			:  	Comorbid screen should be open
'Example of Call		:	intInactiveComplaints= GetCountOfInactiveComplaints(strOutErrorDesc)
'Author					:	Piyush Chandana
'Date					:	11-Nov-2014
'####################################################################################################################################################################################

Function GetCountOfInactiveComplaints(strOutErrorDesc)
	
	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
	
	'Verify that Complaints History widget is in Collapse mode
	Execute "Set objComplaintsHistory = " & Environment("WEL_Comorbid_ComplaintsHistory")
	Execute "Set objComplaintHistoryTable = " & Environment("WEL_Comorbid_ComplaintsHistoryTable")
	If objComplaintsHistory.Exist(3) and not objComplaintHistoryTable.Exist(3) Then
	
		Call WriteToLog("Pass","Complaints history widget is in collapse mode.")
		
		'Verify the inactive count
		strComplaintsHistory = objComplaintsHistory.GetROProperty("innertext")
		arrComplaintsHitory = Split(strComplaintsHistory,"(")
		intInactiveComplaintsCount = Split(arrComplaintsHitory(1),")")
		
		'Verify that Inactive complaint count is numeric
		If IsNumeric(intInactiveComplaintsCount(0)) Then
			Call WriteToLog("Pass","Complaints history has "&Trim(intInactiveComplaintsCount(0))&" inactive complaints")
		Else	
			strOutErrorDesc = "Complaints history has not inactive complaints in numeric value."
			Exit Function
		End If
	Else
		strOutErrorDesc = "Complaints history widget is not in collapse mode."
		Exit Function
	End If
	
	GetCountOfInactiveComplaints = Trim(intInactiveComplaintsCount(0))
	
End Function

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'#######################################################################################################################################################################################################
'Function Name			:	GetCountOfActiveComplaints
'Purpose of Function	:	Purpose of this function to get the count active complaints of comorbid screen	
'Input Arguments		:	None
'Output Arguments		:	Integer
'						:   strOutErrorDesc : String value which contains detail error message occurred (if any) during function execution
'Prerequisite			:  	Comorbid screen should be open
'Example of Call		:	intActiveComplaints= GetCountOfActiveComplaints(strOutErrorDesc)
'Author					:	Piyush Chandana
'Date					:	11-Nov-2014
'####################################################################################################################################################################################

Function GetCountOfActiveComplaints(strOutErrorDesc)
	
	strOutErrorDesc = ""
	Err.Clear
	On Error Resume Next
	
	'Create object of OR
	Set objCapellaPage = Browser("DaVita VillageHealth Capella").Page("DaVita VillageHealth Capella")
	
	'create object for Active complaints list
	Set objComplaintsList = objCapellaPage.WebElement("ActiveComplaintsList")
	If objComplaintsList.Exist(15) Then
		Call WriteToLog("Pass","Complaints List exist on comorbids screen")
		
		'Get the active complaits count
		strComplaintsList = objComplaintsList.GetROProperty("innertext")
		arrComplaintsList = Split(strComplaintsList,"(")
		intActiveComplaints = Split(arrComplaintsList(1),")")
		
		'Verify that Active complaint count is numeric
		If IsNumeric(intActiveComplaints(0)) Then
			Call WriteToLog("Pass","Active complaints count is: "&Trim(intActiveComplaints(0)))
		Else	
			strOutErrorDesc = "Active complaints count is not numeric"
			Exit Function
		End If
	Else
		strOutErrorDesc = "Complaints List does not exist on comorbids screen"
		Exit Function
	End If
	
	GetCountOfActiveComplaints = Trim(intActiveComplaints(0))
	
End Function
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'================================================================================================================================================================================================
'Function Name       :	CreateNewPatientFromEPS
'Purpose of Function :	Create a new patient from EPS user with required details
'Input Arguments     :	strPatientPersonalDetails: representing patient's personal details: FirstName,LastName,Gender,DOB,Language.
						'1. Write Personal details  delimeted by "," (Eg: "John,Knight,Male,12/12/1950,English")  
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.
							'Eg1: If user needs only FirstName, then write as:   "John"
							'Eg2: If user needs only FirstName and Gender and Language, then write as:   "John,,Male,,English"
						'3. FirstName is mandatory
						
'					:	strPatientAddressDetails: representing patient's Address details (Address,City,State,Zip,HomePhone,PrimaryPhone)
						'1. Write Address details  delimeted by "," (Eg: "Villa25,Alpine,California,91901,1234567891,Home")
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.
							'Eg1: If user needs only Address, then write as:  "Villa25"
							'Eg2: If user needs only PrimaryPhone, then write as:  ",,,,,Home"
						'3. for City,State,Zip, if user is providing value to  any one filed, then he must give respective values for other two fileds also
							'Eg: If user needs only State and PrimaryPhone, then write as:  ",Alpine,California,91901,,Home"
						
'					 :	strPatientMedicalDetails: representing patient's Medical details (ReferralDate,ReferralReceivedDate,ApplicationDate,Payor,DiseaseState,LineOfBuisness,ServiceType,Source,GroupPolicyNumber)
						'1. Write  Medical details  delimeted by "," (Eg: "10/10/2015,10/10/2015,10/10/2015,Humana Kidney Care- Las Vegas,CKD,Medicaid/Medicare,Field,Claims,123545")
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.
							'Eg: If user needs only ServiceType, then write as:  ",,,,,,Medicaid/Medicare"
							'Eg: If user needs only GroupPolicyNumber, then write as:  ",,,,,,,,123545"
						'3. For ReferralDate,ReferralReceivedDate,ApplicationDate, if user is providing value to  any one filed, then he must give respective values for other two fileds also
							'Eg: If user needs only ReferralDate, then write as:  "10/10/2015,10/10/2015,10/10/2015"
						'4: For Payor,DiseaseState,LineOfBuisness, if user is providing value to  any one filed, then he must give respective values for other two fileds also
							'Eg: If user needs only Payor and GroupPolicyNumber, then write as:  ",,,Humana Kidney Care- Las Vegas,CKD,Medicaid/Medicare,Field,,123545"

'Output Arguments    :	String value: New patients Member ID and Eligibility status delimited by ","    Eg: 177814,Enrolled
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	strNewPatient = CreateNewPatientFromEPS(strPersonalDetails,strAddressDetails,strMedicalDetails,strOutErrorDesc)
'Modified By		 :  Gregory
'Date				 :	15 October 2015
'Comment             :  This function is modification of createNewPatient()		
'================================================================================================================================================================================================

Function CreateNewPatientFromEPS(ByVal strPatientPersonalDetails,ByVal strPatientAddressDetails,ByVal strPatientMedicalDetails, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""	
	CreateNewPatientFromEPS = ""	
	
	arrPersonalDetails = Split(strPatientPersonalDetails,",",-1,1)
	
	If lcase(strPatientAddressDetails) <> "na" Then
		arrAddressDetails = Split(strPatientAddressDetails,",",-1,1)
	End If
	
	If lcase(strPatientMedicalDetails) <> "na" Then
		arrMedicalDetails = Split(strPatientMedicalDetails,",",-1,1)
	End If
	
	'Personal Details
	strFirstName = Trim(arrPersonalDetails(0))
	strLastName = Trim(arrPersonalDetails(1))
	
	If Trim(LCase(strFirstName)) = "na" Then
		strPatientName = ProvidePatientName()
		strFirstName = Split(strPatientName,", ",-1,1)(1)
		strLastName = Split(strPatientName,", ",-1,1)(0)	
		
	ElseIf strFirstName = "" AND (strLastName <> "" OR Trim(LCase(strLastName)) = "na") Then
		strFirstName = "Test" & RandomNumber(1,999)	
		strLastName = Split(strPatientName,",",-1,1)(1)
		
	ElseIf strLastName = "" OR Trim(LCase(strLastName)) = "na" Then	
		strLastName = "Test" & RandomNumber(1,999)
		
	End If	
	
	strPatientName = strLastName&", "&strFirstName
	
	strGender = Trim(arrPersonalDetails(2))
	If strGender = "" OR Trim(LCase(strGender)) = "na" Then
		strGender = "Male" 
	End If
	dtDateOfBirth = Trim(arrPersonalDetails(3))
	If dtDateOfBirth = "" OR Trim(LCase(dtDateOfBirth)) = "na" Then
		dtDateOfBirth = "12/12/1970"
	End If	
	strLanguage = Trim(arrPersonalDetails(4))
	If strLanguage = "" OR Trim(LCase(strLanguage)) = "na" Then
		strLanguage = "English"
	End If		
	
	'Address details
	strAddress = Trim(arrAddressDetails(0))
	If strAddress = "" OR Trim(LCase(strAddress)) = "na" Then
		strAddress = "Test Address" & RandomNumber(1,999)
	End If		
	strCity = Trim(arrAddressDetails(1))
	If strCity = "" OR Trim(LCase(strCity)) = "na" Then
		strCity = "Alpine"
	End If	
	strStateValue = Trim(arrAddressDetails(2))
	If strStateValue = "" OR Trim(LCase(strStateValue)) = "na" Then
		strStateValue = "California"
	End If	
	lngZipValue = Trim(arrAddressDetails(3))
	If lngZipValue = "" OR Trim(LCase(lngZipValue)) = "na" Then
		lngZipValue = "91901"
	End If	
	lngHomePhone = Trim(arrAddressDetails(4))
	If lngHomePhone = "" OR Trim(LCase(lngHomePhone)) = "na" Then
		lngHomePhone = "1234567891"
	End If	
	strPrimaryPhone = Trim(arrAddressDetails(5))
	If strPrimaryPhone = "" OR Trim(LCase(strPrimaryPhone)) = "na" Then
		strPrimaryPhone = "Home"
	End If	
	
	'Medical Details
	dtReferralDate = Trim(arrMedicalDetails(0))
	If dtReferralDate = "" OR Trim(LCase(dtReferralDate)) = "na" Then
		dtReferralDate = date-5
	End If	
	dtReferralReceivedDate = Trim(arrMedicalDetails(1))
	If dtReferralReceivedDate = "" OR Trim(LCase(dtReferralReceivedDate)) = "na" Then
		dtReferralReceivedDate = date-5
	End If	
	dtApplicationDate = Trim(arrMedicalDetails(2))
	If dtApplicationDate = "" OR Trim(LCase(dtApplicationDate)) = "na" Then
		dtApplicationDate = date-5
	End If	
	strPayor = Trim(arrMedicalDetails(3))
	If strPayor = "" OR Trim(LCase(strPayor)) = "na" Then	
'		strPayor = "Humana Kidney Care- Las Vegas"
'		strPayor = "AETNA CKD CINCINNATI CASE RATE"
		strPayor = "SCAN VILLAGEHEALTH - SAN BERNADINO"
	End If	
	strDiseaseState = Trim(arrMedicalDetails(4))
	If strDiseaseState = "" OR Trim(LCase(strDiseaseState)) = "na" Then
		strDiseaseState = "ESRD"
	End If
	strLineOfBuisness = Trim(arrMedicalDetails(5))
	If strLineOfBuisness = "" OR Trim(LCase(strLineOfBuisness)) = "na" Then
		strLineOfBuisness = "Medicaid/Medicare"
	End If
	strServiceType = Trim(arrMedicalDetails(6))
	If strServiceType = "" OR Trim(LCase(strServiceType)) = "na" Then
'		strServiceType = "Field"
		strServiceType = "Telephonic"
	End If
	strSource = Trim(arrMedicalDetails(7))
	If strSource = "" OR Trim(LCase(strSource)) = "na" Then
		strSource = "Claims"
	End If
	lngGroupPolicyNumber = Trim(arrMedicalDetails(8))
	If lngGroupPolicyNumber = "" OR Trim(LCase(lngGroupPolicyNumber)) = "na" Then
		lngGroupPolicyNumber = "123545"
	End If
	
	Execute "Set objFirstNameField = " & Environment("WE_SearchMemberFirstName")
	Execute "Set objSearchBtn = " & Environment("WB_MemberSearch")
	Execute "Set objNewReferralBtn = " & Environment("WB_MemberSearchNewReferral")
	Execute "Set objReferralDate = " & Environment("WE_ReferralDate")
	Execute "Set objReferralTitle = " & Environment("WEL_ReferralManagementTitle")
	Execute "Set objReferralReceivedDate = " & Environment("WE_ReferralReceivedDate")
	Execute "Set objApplicationDate = " & Environment("WE_ApplicationDate")
	Execute "Set objPayorDropDown = " & Environment("WB_PayorDropDown")
	Execute "Set objSaveBtn = " & Environment("WB_NewReferralSave")
	Execute "Set objLastName = " & Environment("WE_LastName")
	Execute "Set objDOB = " & Environment("WE_DOB")
	Execute "Set objAddress = " & Environment("WE_Address")
	Execute "Set objCity = " & Environment("WE_City")
	Execute "Set objState = " & Environment("WB_StateDropDown")
	Execute "Set objZip = " & Environment("WE_Zip")
	Execute "Set objHomePhone = " & Environment("WE_HomePhone")
	Execute "Set objPrimaryPhone = " & Environment("WB_PrimaryPhoneDropDown")
	Execute "Set objLanguage = " & Environment("WB_LanguageDropDown")
	Execute "Set objGender = " & Environment("WB_GenderDropDown")
	Execute "Set objGroupPolicyNumber = " & Environment("WE_GroupPloicy")
	Execute "Set objSaveNewPatientData = " & Environment("WEL_NewPatientSaveBtn")
	Execute "Set objEnrollmentStatus = " & Environment("WEL_EnrollStatus")
	Execute "Set objMemberId = " & Environment("WEL_MemberID")
	Execute "Set objReferralManagementWindow = " & Environment("WE_ReferralManagementWindow")

	'Set value to First Name field
	Err.clear
	objFirstNameField.Set strFirstName
	If Err.Number <> 0 Then
		strOutErrorDesc = strFirstName & "is not set to First Name field"
		Exit Function
	End If
	Call WriteToLog("Pass", strFirstName & "is set to First Name field.")
	Wait 0,500
	
	'Set value to Last Name field
	Execute "Set objLastNameField = " & Environment("WE_SearchMemberLastName")
	Err.clear
	objLastNameField.Set strLastName
	If Err.Number <> 0 Then
		strOutErrorDesc = strLastName & "is not set to Last Name field"
		Exit Function
	End If
	Call WriteToLog("Pass", strLastName & "is set to Last Name field.")
	Execute "Set objLastNameField = Nothing"
	Wait 0,500
	
	'Click on the Search button field
	blnReturnValue = ClickButton("Search",objSearchBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		strOutErrorDesc = "Click Search button returned: " & strOutErrorDesc
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	
	'Click on the New Referral button
	blnReturnValue = ClickButton("New Referral",objNewReferralBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		strOutErrorDesc = "Click New Referral button returned: " & strOutErrorDesc
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")	
	Wait 1
	
	'Set Referral date	
	Err.Clear
	objReferralDate.Set dtReferralDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set  Referral date" & Err.Description
		Exit Function		
	End If
	Call WriteToLog("Pass", "Referral date is set to "&dtReferralDate)
	
	'Set Referral Received date
	Err.Clear
	objReferralReceivedDate.Set dtReferralReceivedDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set  referral received date" & Err.Description
		Exit Function		
	End If
	Call WriteToLog("Pass", "Referral Received date is set to "&dtReferralReceivedDate)
	
	'Set Application date
	Err.Clear
	objApplicationDate.Set dtApplicationDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Application date" & Err.Description
		Exit Function		
	End If
	Call WriteToLog("Pass", "Application date is set to "&dtApplicationDate)
	wait 2
	Call waitTillLoads("Loading...")
		
	'Select value from Referring Payor dropdown
	Execute "Set objPayorDropDown = Nothing"
	Execute "Set objPayorDropDown = " & Environment("WB_PayorDropDown")
'	blnReturnValue = selectComboBoxItem(objPayorDropDown, strPayor)
	blnReturnValue = SelectComboBoxItemSpecific(objPayorDropDown, strPayor)
	If not blnReturnValue Then
		strOutErrorDesc = strReferringPayorValue & "value is not selected from Referring Payor dropdown. Error returned: " & strOutErrorDesc
		Exit Function	
	End If
	Call WriteToLog("Pass", strReferringPayorValue & " value is selected from Referring Payor dropdown.")
	wait 1
	
	'Select value from Disease State dropdown	
	Set objDiseaseState = getComboBoxReferralManagement("Disease State")
	blnReturnValue = selectComboBoxItem(objDiseaseState, strDiseaseState)
	If not blnReturnValue Then
		strOutErrorDesc = strDiseaseStateValue & "value is not selected from Disease State dropdown. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strDiseaseStateValue & " value is selected from Disease State dropdown.")
	wait 1
	
	'select Line of business
	Set objLOB = getComboBoxReferralManagement("Line Of Buisness")
	blnReturnValue = selectComboBoxItem(objLOB, strLineOfBuisness)
	If not blnReturnValue Then
		strOutErrorDesc = strLineOfBuisnessValue & "value is not selected from Line Of Buisness dropdown. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strLineOfBuisnessValue & " value is selected from Line Of Buisness dropdown.")
	wait 1
	
	'Select value from Service Type dropdown
	Set objServiceType = getComboBoxReferralManagement("ServiceType")
	blnReturnValue = selectComboBoxItem(objServiceType, strServiceType)
	If not blnReturnValue Then
		strOutErrorDesc = strServiceTypeValue & "value is not selected from Service Type dropdown. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strServiceTypeValue & " value is selected from Service Type dropdown.")
	wait 1
	
	'Select value from Source dropdown
	Set objSource = getComboBoxReferralManagement("Source")
	blnReturnValue = selectComboBoxItem(objSource, strSource)
	If not blnReturnValue Then
		strOutErrorDesc = strSource & "value is not selected from Source dropdown. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strSource & " value is selected from Source dropdown.")
	wait 1	
	
	'Click on the Save button
	blnReturnValue = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not(blnReturnValue) Then
		strOutErrorDesc = "Click Save button returned:  " & strOutErrorDesc
		Exit Function
	End If
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Set Last Name
	Err.Clear
	objLastName.Set strLastName
	If Err.Number <> 0 Then
		strOutErrorDesc = strLastName & "is not set to Last Name field. Error Returned: " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",strLastName & "is set to Last Name field")
	wait 1
	
	'Set Date of Birth
	Err.Clear
	objDOB.Set dtDateOfBirth
	If Err.Number <> 0 Then
		strOutErrorDesc = strDOB & "is not set to Date Of Birth field. Error Returned: " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",strDOB & "is set to Date Of Birth field")
	wait 1
	
	'Set Address
	Err.Clear
	objAddress.Set strAddress
	If Err.Number <> 0 Then
		strOutErrorDesc = strAddress & "is not set to Address field. Error Returned: " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",strAddress & "is set to Address field")
	wait 1
	
	'Set City
	Execute "Set objCity = " & Environment("WE_City")
	Err.Clear
	objCity.Set strCity
	If Err.Number <> 0 Then
		strOutErrorDesc = strCity & "is not set to City field. Error Returned: " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",strCity & "is set to City field")
	wait 1
	
	'Select value from State dropdown
	Execute "Set objState = " & Environment("WB_StateDropDown")
	blnReturnValue = selectComboBoxItem(objState, strStateValue)
	If not blnReturnValue Then
		strOutErrorDesc = strStateValue & "value is not selected from State dropdown. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strStateValue & " value is selected from State dropdown")
	wait 1
	
	'Set Zip
	Execute "Set objZip = " & Environment("WE_Zip")
	Err.Clear
	objZip.Set lngZipValue
	If Err.Number <> 0 Then
		strOutErrorDesc = lngZipValue & "is not set to Zip field. Error Returned: " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",lngZipValue & "is set to Zip field")
	wait 2	
	Call waitTillLoads("Loading...")
	
	'Handling City-State-Zip selection error
	'strStateValue = "California" 
	Set objSateSelected = getPageObject().WebButton("html id:=data-range","html tag:=BUTTON","innertext:=.*"&strStateValue&".*","visible:=True")
	If not objSateSelected.Exist(2) Then
		Wait 1
		Execute "Set objZip = " & Environment("WE_Zip")
		Err.Clear
		objZip.Set 22222
		Wait 1
		sendKeys "{TAB}"
		Wait 1	
		Execute "Set objFoundAddress_CB = " & Environment("WE_FoundAddress_CB")
		If objFoundAddress_CB.Exist(2) Then
			Wait 1		
			Execute "Set objFoundAddress_CB = " & Environment("WE_FoundAddress_CB")
			Err.Clear
			objFoundAddress_CB.Click
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to select 'We Found' check box in Zip code validation window. Error Returned: " & Err.Description
				Exit Function
			End If
			Call WriteToLog("Pass","Selected 'We Found' check box in Zip code validation window")
			Wait 1
			
			Execute "Set objFoundAddress_OK = " & Environment("WB_FoundAddress_OK")
			Err.Clear
			objFoundAddress_OK.Click
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to click OK button of Zip code validation window. Error Returned: " & Err.Description
				Exit Function
			End If
			Call WriteToLog("Pass","Clicked OK button of Zip code validation window")
			Call WriteToLog("Pass","Handled City-State-Zip selection error")
			Wait 1		
		End If	
	End If	
	
	'Set Home Phone
	Err.Clear	
	objHomePhone.highlight
	objHomePhone.Set lngHomePhone
	If Err.Number <> 0 Then
		strOutErrorDesc = lngHomePhone & "is not set to Home Phone field. Error Returned: " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",lngHomePhone & "is set to Home Phone field")

	'Select value from Primary Phone field
	blnReturnValue = selectComboBoxItem(objPrimaryPhone, strPrimaryPhone)
	If not blnReturnValue Then
		strOutErrorDesc = strPrimaryPhone & "value is not selected from Primary Phone field. Error returned: " & strOutErrorDesc
		Exit Function
	End If	
	Call WriteToLog("Pass", strPrimaryPhone & " value is selected from Primary Phone field.")
	
	'Select value from Language field
	blnReturnValue = selectComboBoxItem(objLanguage, strLanguage)
	If not blnReturnValue Then
		strOutErrorDesc = strLanguage & "is not selected from Language field. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strLanguage & " value is selected from Language field.")

	'Select value from Gender field
	blnReturnValue = selectComboBoxItem(objGender, strGender)
	If not blnReturnValue Then
		strOutErrorDesc = strGender & "value is not selected from Gender field. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strGender & " value is selected from Gender field.")

	'Set Policy Number to Group/Policy Number field
	Err.Clear
	objGroupPolicyNumber.Set lngGroupPolicyNumber
	If Err.Number <> 0 Then
		strOutErrorDesc = lngGroupPolicyNumber & "is not set to Group/Policy Number field. Error Returned: " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",lngGroupPolicyNumber & "is set to Group/Policy Number field")

	'Click on the Save button
	blnReturnValue = ClickButton("Save",objSaveNewPatientData,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "ClickButton returned:  " & strOutErrorDesc
		Exit Function
	End If
	
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Handle error - Check whether FN is entered. If not then 1.close the error popup, 2.Re-set FirstName, 3.Save
	Execute "Set objPage_EPS_CP = " &Environment("WPG_AppParent")'Page object	
	Set objFN_ErrorPP =  objPage_EPS_CP.WebElement("class:=popup-grad.*","html id:=myModal","html tag:=DIV","outertext:=.*Patient's First Name.*","visible:=True")
	If objFN_ErrorPP.Exist(10) Then
		
		'1.close the error popup
		blnFN_ErrorPP = checkForPopup("Error","OK","Please Enter Patient's First Name",strOutErrorDesc)
		If not blnFN_ErrorPP Then
			strOutErrorDesc = "Unable to close FN error popup" & strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass", "Handled error popup for FirstName filed")
		
		Wait 2
		
		'2. Re-set FirstName
		Execute "Set objFirstNameField = Nothing"
		Execute "Set objFirstNameField = " & Environment("WE_SearchMemberFirstName")
		objFirstNameField.Highlight
		Wait 0,500
		
		Err.Clear	
		objFirstNameField.Set strFirstName
		If Err.Number <> 0 Then
			strOutErrorDesc = strFirstName & "is not re-set to First Name field. "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", strFirstName & "is re-set to First Name field.")
		Wait 1
		
		'3. Save
		Execute "Set objSaveNewPatientData   = Nothing"
		Execute "Set objSaveNewPatientData   = " & Environment("WEL_NewPatientSaveBtn")
		blnReturnValue = ClickButton("Save",objSaveNewPatientData,strOutErrorDesc)
		If not blnReturnValue Then
			strOutErrorDesc = "ClickButton returned:  " & strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass","Handled FirstName entering error")
		
	End If
	
	Wait 2
	Call waitTillLoads("Loading...")
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Check the message box having title as "The Changes have been saved successfully" 
	strMessageTitle = "The Changes have been saved successfully"
	strMessageBoxText = "Member added successfully."
	blnReturnValue = checkForPopup("", "Ok", "", strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "CheckMessageBoxExist returned:  " & strOutErrorDesc
		Exit Function
	End If	
	Wait 1
	
	'Check the patient status
	strPatientStatus = Trim(objEnrollmentStatus.getRoProperty("innertext"))
	If  Trim(strPatientStatus) = "" Then	
		strOutErrorDesc = "Patient is not enrolled successfully. Status is empty"
		Exit Function
	End If
	Call WriteToLog("Pass","Patient is enrolled successfully with status " & strPatientStatus )
	
	'Check Member Id of the patient
	lngMemberId = ""
	If objMemberId.Exist(10) Then
		Wait 1
		lngMemberId = Trim(objMemberId.getRoProperty("innertext"))
		Call WriteToLog("Pass","Patient is enrolled succesfully with Member Id: '" & lngMemberId & "'")
	Else	
		strOutErrorDesc = "MemberId does not exist"
		Exit Function
	End If
	
	CreateNewPatientFromEPS = strPatientName&"|"&lngMemberId&"|"&strPatientStatus
	
	Execute "Set objPage_EPS_CP = Nothing"
	Execute "Set objFirstNameField = Nothing"
	Execute "Set objSearchBtn = Nothing"
	Execute "Set objNewReferralBtn = Nothing"
	Execute "Set objReferralDate = Nothing"
	Execute "Set objReferralTitle = Nothing"
	Execute "Set objReferralReceivedDate = Nothing"
	Execute "Set objApplicationDate = Nothing"
	Execute "Set objPayorDropDown = Nothing"
	Execute "Set objSaveBtn = Nothing"
	Execute "Set objLastName = Nothing"
	Execute "Set objDOB = Nothing"
	Execute "Set objAddress = Nothing"
	Execute "Set objCity = Nothing"
	Execute "Set objState = Nothing"
	Execute "Set objZip = Nothing"
	Execute "Set objHomePhone = Nothing"
	Execute "Set objPrimaryPhone = Nothing"
	Execute "Set objLanguage = Nothing"
	Execute "Set objGender = Nothing"
	Execute "Set objGroupPolicyNumber = Nothing"
	Execute "Set objSaveNewPatientData = Nothing"
	Execute "Set objEnrollmentStatus = Nothing"
	Execute "Set objMemberId = Nothing"	
	
End Function

'================================================================================================================================================================================================
'Function Name       :	AdvanceCarePlanning
'Purpose of Function :	1.Perform AdvanceCarePlanning pathway, 2.validate other functionalities - Add,Postpone,Save,Cancel,History, Validate all Links connecting to other sceens, messages etc.. 
'Input Arguments     :	arrAnswerBook: array value representing answers for all pathway questions (inclueds answers for all possible workflows)
'					 :	arrPatwayDecidingAnswers: array value representing answers which actually decides which flow the pathway should follow
'					 :	strTestFunctionalities: string value (Yes/No) representing whether user wants only screening or test all other functionalities of Advance Care Planning screen
'					 :	dtScreeningDate = date value representing pathway performing date
'Output Arguments    :	Boolean value: representing AdvanceCarePlanning pathway status
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Pre-requisite		 :  SNP_Library folder should be loaded in the script which is calling this function (Ref: SNP_InitialAdvanceCarePlanning)
						
						'Use this code (for loading the SNP function library) in the script which calls this function:			
						'-------------------------------------------------------------------------------------
							'SNP_Library = Environment.Value("PROJECT_FOLDER") & "\Library\SNP_functions"
							'For each SNPlibfile in objFso.GetFolder(SNP_Library).Files
							'	If UCase(objFso.GetExtensionName(SNPlibfile.Name)) = "VBS" Then
							'		LoadFunctionLibrary SNPlibfile.Path
							'	End If
							'Next							
						'-------------------------------------------------------------------------------------															
'Example of Call     :	blnAdvanceCarePlanning = AdvanceCarePlanning(arrACS_AnsBook, arrDecidingAns, strTestAllFunctionalities, dtScreeningDt, strOutErrorDesc)
'Author				 :  Amar
'Date				 :	30-Sept-2015
'================================================================================================================================================================================================
Function AdvanceCarePlanning(ByVal arrAnswerBook,ByVal arrPatwayDecidingAnswers,ByVal strTestAll,ByVal dtScreeningDate, strOutErrorDesc)
		
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	AdvanceCarePlanning = False
	
	Execute "Set objPageACP ="&Environment("WPG_AppParent")									
	Execute "Set objACS_Header = "&Environment("WEL_ACSheader")				    			
	Execute "Set objACS_AddBtn="&Environment("WEL_ACSAddBtn")
	Execute "Set objACS_PostponeBtn="&Environment("WEL_ACSPostponeBtn")
	Execute "Set objACS_CancelBtn="&Environment("WEL_ACSCancelBtn")
	Execute "Set objACS_SaveBtn="&Environment("WEL_ACSSaveBtn")  
	Execute "Set objACS_HistoryBtn="&Environment("WEL_ACSHistoryBtn")  
	Execute "Set objACS_PatwayReportHistoryHdr = " & Environment("WI_ACS_PatwayReportHistoryHdr")
	Execute "Set objACS_PatwayReportHistoryClose = " & Environment("WI_ACS_PatwayReportHistoryClose")
	Execute "Set objACS_Comments = " & Environment("WE_ACS_Comments")
	Execute "Set objACS_PatientCommentCB = " & Environment("WE_ACS_PatientCommentCB")
	Execute "Set objACS_ProviderCommentCB = " & Environment("WE_ACS_ProviderCommentCB") 
	Execute "Set objACS_Date = " &Environment("WEL_ACS_Date")
	
	'Verify whether user navigated to 'Advance Care Planning' screen
	If not objACS_Header.Exist(5) Then
		strOutErrorDesc = "Unable to navigate to 'Advance Care Planning' screen"
		Exit Function
	End If	
	Print "User is able to navigate to 'Advance Care Planning' screen"
		
	'Validate buttons and history if required
	If Lcase(strTestAll)  = "yes" Then
		blnACS_ButtonInitialStatus = ACS_ButtonInitialStatus()
		If not blnACS_ButtonInitialStatus  Then
			Exit function
		End If
		Call WriteToLog("Pass", "Validated initial status on Transplan Evaluation screen buttons and pathway report")
	End If 
	'Perform Pathway
	Execute "Set objACS_AddBtn= Nothing"
	Execute "Set objACS_AddBtn="&Environment("WEL_ACSAddBtn")
	If not objACS_AddBtn.Object.isDisabled Then
		blnACS_AddClicked = ClickButton("Add",objACS_AddBtn,strOutErrorDesc)
		If not blnACS_AddClicked Then
			strOutErrorDesc = "Unable to click Advance Care Planning Add button"
			Exit function
		End If
	End If
	
	strDecidingQuesAnswer = arrAnswerBook(0)'patient written advance care

	'Does the patient have a written advance care in place :In Place
	If strDecidingQuesAnswer="In Place" Then
						
				For ACSQuestion = 1 To 12 Step 1
						
						Select Case ACSQuestion
							Case 1:'AnswerOption1 = Does the patient :In Place/Not In Place
								If arrAnswerBook(ACSQuestion-1) ="In Place" Then
									ReqdOption = "761_1919"
								End If
								objPageACP.highlight
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
																
								'Testing link functionality for 'Yes' answer opted for "Does the patient :In Place/Not In Place" pathway question
								If lcase(strTestFunctionalities) = "yes" AND arrAnswerBook(ACSQuestion-1) = "In Place" Then
									blnTeamLink = TestACS_TeamLink()
									If not blnTeamLink Then
										Exit Function
									End If
								End If
								
							Case 3:'AnswerOption2 = Patient has the following :Living Will/POLST/Medical Power of Attorney (Health Care Proxy)/State Form/Five Wishes  
								
								If Trim(lcase(arrAnswerBook(ACSQuestion-1))) = "living will" Then
									ReqdOption = "762_1921"
								ElseIf Trim(lcase(arrAnswerBook(ACSQuestion-1))) = "polst" Then
									ReqdOption ="762_1922"
								ElseIf Trim(lcase(arrAnswerBook(ACSQuestion-1))) = "medical power of attorney (health care proxy)" Then
									ReqdOption ="762_1923"
								ElseIf Trim(lcase(arrAnswerBook(ACSQuestion-1))) = "state form" Then
									ReqdOption ="762_1924"
								ElseIf Trim(lcase(arrAnswerBook(ACSQuestion-1))) = "five wishes" Then
									ReqdOption ="762_1995"
								End If 
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
								
							Case 4:'AnswerOption3 = Copies of written advance:Health Care Agent,Dialysis Center,PCP,Nephrologist,None
								arrAnswerBookSpecific = Split(arrAnswerBook(ACSQuestion-1),",",-1,1)
									For rsn = 0 To Ubound(arrAnswerBookSpecific) Step 1
										Reason = arrAnswerBookSpecific(rsn)
										 			 
										Select Case Reason
											Case "Health Care Agent"
												ReqdOption = "763_1925"
												objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_"&ReqdOption&".*").Click
											Case "Dialysis Center"
												ReqdOption = "763_1926"
										   			objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_"&ReqdOption&".*").Click
											Case "PCP"
												ReqdOption = "763_1927"
												objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_"&ReqdOption&".*").Click
											Case "Nephrologist"
												ReqdOption = "763_1928"
												objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_"&ReqdOption&".*").Click
											Case "None"
												ReqdOption = "763_1929"
												objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_"&ReqdOption&".*").Click
											
										End Select
									Next
								
							Case 5:'AnswerOption4 = Was patient/caregiver instructed:Yes/No/NA
												
								If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "764_1930"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "764_1931"
								Else
									ReqdOption = "764_1932"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
								
							Case 6:'Was social worker engaged:Yes/No/NA
												
								If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "766_1936"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "766_1937"
								Else
									ReqdOption = "766_1938"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click

							Case 7:'Was physician engaged:Yes/No/NA
								
							If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "767_1939"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "767_1940"
								Else
									ReqdOption = "767_1941"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
					
							Case 8:'Was verbal education:Yes/No/NA
						
							If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "768_1942"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "768_1943"
								Else
									ReqdOption = "768_1944"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click

							Case 9:'Send written materials:Yes/No/NA
								
							If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "769_1945"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "769_1946"
								Else
									ReqdOption = "769_1947"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
								
									'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
								If lcase(strTestFunctionalities) = "yes" AND lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									blnMaterialLink = TestACS_MaterialLink()
									If not blnMaterialLink Then
										Exit Function
									End If
								End If							
									
								
							Case 10:'Comments:Advance Care Planning comments
									strComment = arrAnswerBook(ACSQuestion-1)
									
								Err.Clear
								objACS_Comments.Set strComment		
								If err.number <> 0 Then
								strOutErrorDesc = "Advance Care Planning comment is not set"
								Exit Function	
								End If
							Case 11:'IncludePatientComment:Yes/No	
								
								strIncludePatientComment = arrAnswerBook(ACSQuestion-1)
								If lcase(strIncludePatientComment) = "yes" Then
									objACS_PatientCommentCB.Click
								End If
								
							Case 12:'IncludeProviderComment:Yes/No	
									strIncludeProviderComment = arrAnswerBook(ACSQuestion-1)
									If lcase(strIncludeProviderComment) = "yes" Then
										objACS_ProviderCommentCB.Click
									End If
						End Select
				
				Next
				
		End If
		
		'Does the patient have a written advance care in place :Not In Place
		If strDecidingQuesAnswer="Not In Place" Then
								
				For TEQuestion = 1 To 12 Step 1
						
						Select Case TEQuestion
							Case 1:'AnswerOption1 = Does the patient :In Place/Not In Place
								If arrAnswerBook(ACSQuestion-1) ="Not In Place" Then
									ReqdOption = "761_1920"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
																						
							Case 2:'AnswerOption2 = Patient has reported:Pending/Refused/Revoked  
									  								
								If lcase(arrAnswerBook(ACSQuestion-1)) = "pending" Then
									ReqdOption = "765_1933"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "refused" Then
									ReqdOption = "765_1934"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "revoked" Then
									ReqdOption = "765_1935"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
								
							Case 6:'Was social worker engaged:Yes/No/NA
												
								If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "766_1936"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "766_1937"
								Else
									ReqdOption = "766_1938"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click

							Case 7:'Was physician engaged:Yes/No/NA
								
							If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "767_1939"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "767_1940"
								Else
									ReqdOption = "767_1941"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
					
							Case 8:'Was verbal education:Yes/No/NA
						
							If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "768_1942"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "768_1943"
								Else
									ReqdOption = "768_1944"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click

							Case 9:'Send written materials:Yes/No/NA
								
							If lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									ReqdOption = "769_1945"
								ElseIf lcase(arrAnswerBook(ACSQuestion-1)) = "no" Then
									ReqdOption = "769_1946"
								Else
									ReqdOption = "769_1947"
								End If
								objPageACP.WebElement("html tag:=DIV","visible:=True","outerhtml:=.*Plan_PathWay_"&ReqdOption&".*").Click
								
									'Testing link functionality for 'Yes' answer opted for "Send written materials regarding transplantation?" pathway question
								If lcase(strTestFunctionalities) = "yes" AND lcase(arrAnswerBook(ACSQuestion-1)) = "yes" Then
									blnMaterialLink = TestACS_MaterialLink()
									If not blnMaterialLink Then
										Exit Function
									End If
								End If							
									
								
							Case 10:'Comments:Advance Care Planning comments
									strComment = arrAnswerBook(ACSQuestion-1)
									
								Err.Clear
								objACS_Comments.Set strComment		
								If err.number <> 0 Then
								strOutErrorDesc = "Advance Care Planning comment is not set"
								Exit Function	
								End If
							Case 11:'IncludePatientComment:Yes/No	
								
								strIncludePatientComment = arrAnswerBook(ACSQuestion-1)
								If lcase(strIncludePatientComment) = "yes" Then
									objACS_PatientCommentCB.Click
								End If
								
							Case 12:'IncludeProviderComment:Yes/No	
									strIncludeProviderComment = arrAnswerBook(ACSQuestion-1)
									If lcase(strIncludeProviderComment) = "yes" Then
										objACS_ProviderCommentCB.Click
									End If
						End Select
				Next
	
	End If
	
	'------------------------------------------------
	'Validate Cancel and Postpone functionalities if required
	If Lcase(strTestAll)  = "yes" Then
		blnACS_Cancel_PostponeValidation = ACS_Cancel_PostponeValidation()
		If not blnACS_Cancel_PostponeValidation Then
			Exit Function
		End If
	End If 
	'------------------------------------------------
	Wait 2
		
	'Now save the pathway - 'validating SAVE btn
	Execute "Set objACS_SaveBtn=Nothing"
	Execute "Set objACS_SaveBtn="&Environment("WEL_ACSSaveBtn")
	If objACS_SaveBtn.Object.isDisabled Then
		strOutErrorDesc = "Advance Care Plan Save btn is disabled after pathway"
		Exit Function
	End If
	Call WriteToLog("Pass", "Save button is enabled after pathway")
	
	'Click on Save btn
	blnClickedSaveBtn = ClickButton("Save",objACS_SaveBtn,strOutErrorDesc)
	If not blnClickedSaveBtn Then
		strOutErrorDesc = "Save button click returned error: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Save button clicked")
	Wait 2
	
	Call waitTillLoads("Saving pathway...")
	Wait 2
	
	'Validate pathway date
	If Instr(1,Trim(objACS_Date.GetROProperty("outertext")),dtScreeningDate,1) > 0  Then
		Call WriteToLog("Pass", "Pathway date validated")
	Else
		strOutErrorDesc = "Unable to validate pathway date"
		Exit Function
	End If
	
	Call WriteToLog("Pass", "Completed Advance Care Plan pathway successfully")
	
	AdvanceCarePlanning = True
		
	Execute "Set objPageACP = Nothing"
	Execute "Set objACS_Header = Nothing"
	Execute "Set objACS_AddBtn = Nothing"
	Execute "Set objACS_PostponeBtn = Nothing"
	Execute "Set objACS_SaveBtn = Nothing"
	Execute "Set objACS_Comments = Nothing"
	Execute "Set objACS_PatientCommentCB = Nothing"
	Execute "Set objACS_ProviderCommentCB = Nothing"
	Execute "Set objACS_Date = Nothing"

End Function

'=============================================================================================================================================================
'Function Name       :	HomeSafetyScreening
'Purpose of Function :	1.Perform Home Safety Screening, 2.validate other functionalities - Add,Postpone,Save 
'Input Arguments     :	ScreeningDate: date value representing Home Safety Screening start date
'					 :	dtCompletedDate: date value representing Home Safety Screening completed date
'					 :	arrAnswerOption: array value representing answer options for Home Safety screening 
'					 :	strTestAll: string value representing whether user wants only screening or test all other functionalities of HSS screen
'Output Arguments    :	Boolean value: representing HomeSafetyScreening
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Pre-requisite		 :  SNP_Library folder should be loaded in the script which is calling this function (Ref: SNP_InitialTransplantEvaluation)
						'Use following code (for loading the SNP function library) in the script which calls this function:			
						'-------------------------------------------------------------------------------------
							'Set objFso = CreateObject("Scripting.FileSystemObject")
							'SNP_Library = Environment.Value("PROJECT_FOLDER") & "\Library\SNP_functions"
							'For each SNPlibfile in objFso.GetFolder(SNP_Library).Files
							'	If UCase(objFso.GetExtensionName(SNPlibfile.Name)) = "VBS" Then
							'		LoadFunctionLibrary SNPlibfile.Path
							'	End If
							'Next	
							'Set objFso = Nothing							
						'-------------------------------------------------------------------------------------	
'Example of Call     :	blnHomeSafetyScreening = HomeSafetyScreening(dtScreeningDt,dtCompletedDt,arrAnswerOption,strTestAllFunctionalities,strOutErrorDesc)
'Author				 :  Amar
'Date				 :	14-Sept-2015
'=============================================================================================================================================================

Function HomeSafetyScreening(ByVal dtScreeningDate,ByVal dtCompletedDate,ByVal arrAnswerOption,ByVal strTestAll,strOutErrorDesc)
	
	
	On Error Resume Next
	Err.Clear
	
	strOutErrorDesc = ""
	HomeSafetyScreening = false
	intWaitTime = 5

	'===============================
	' Objects required for function
	'===============================
	Execute "Set objPageHSS ="&Environment("WPG_AppParent")									'page object
	Execute "Set objHomeSafetyScreening_Header = "&Environment("WEL_HSSheader")				'HomeSafetyScreening header
	Execute "Set objHomeSafetyScreeningDate="&Environment("WE_HSEdit")						'HomeSafetyScreening Edit button
	Execute "Set objhomesafetyScreeningAddButton="&Environment("WEL_HSAddBtn")				'HomeSafetyScreening Add button
	Execute "Set objhomesafetyScreeningPostponeButton="&Environment("WEL_HSPostponeBtn")	'HomeSafetyScreening Postpone button
	Execute "Set objhomesafetyScreeningSaveButton="&Environment("WEL_HSSaveBtn")            'HomeSafetyScreening Save button
	Execute "Set objHomeSafetyScreening_HistUpArw = "&Environment("WI_HSS_ScrHistUpArw")	'HomeSafetyScreening history expand arrow button
	Execute "Set objHomeSafetyScreening_HtryTable = "&Environment("WT_HSS_ScrHtryTable")	'HomeSafetyScreening history table
	
	print "Performing Home Safety screening and validating other functionalities as required"
	
	'verify if Home Safety screening screen loaded		
	If not CheckObjectExistence(objPageHSS, 10) Then
		Call WriteToLog("Fail","Home Safety screen not opened successfully")
		Exit Function
	End If
	Call WriteToLog("Pass","Home Safety Screening screen opened successfully")			
		
	'check whether navigated to 'Home Safety screening' screen
	If not objHomeSafetyScreening_Header.Exist(10) Then
		strOutErrorDesc = "Home Safety screening screen is not available"
		Exit Function
	End If 
	Call WriteToLog("Pass", "Navigated to 'Home Safety screening' screen")

	'Validating status of Add, Postpone and Save buttons in 'Home Safety screening' screen
	If not objhomesafetyScreeningAddButton.Object.isDisabled Then 'Fresh screening
		If objhomesafetyScreeningPostponeButton.Object.isDisabled AND objhomesafetyScreeningSaveButton.Object.isDisabled Then
			print "Pass, Add btn is enabled and Postpone, Save buttons are disabled - Option for adding fresh screening"
		End If
	ElseIf objhomesafetyScreeningAddButton.Object.isDisabled Then 'Screening existing - continue
		If not objhomesafetyScreeningPostponeButton.Object.isDisabled AND objhomesafetyScreeningSaveButton.Object.isDisabled Then
			print "Pass, Add and Save buttons are disabled. Postpone button is enabled - Option for going forward with existing screening"
		End If
	Else 
		strOutErrorDesc = "Home Safety screening page buttons are not available as expected"
		Exit Function
	End If	
																																								
	'Click Add btn (for fresh screening)
	If not objhomesafetyScreeningAddButton.Object.isDisabled Then
		blnHSS_Add = ClickButton("Add",objhomesafetyScreeningAddButton,strOutErrorDesc)
		If not blnHSS_Add Then
			strOutErrorDesc = "Unable to click Home Safety Screening Assessment Add button: "&Err.Description
			Exit Function
		End If
	End If
		
	Wait 1
	print "pass, Clicked on screening Add btn"
	 
	Call waitTillLoads("Loading Home Safety...")
	
'	'Set screening date
'	Err.clear
'	objHomeSafetyScreeningDate.Set dtScreeningDate
'	If Err.Number <> 0 Then
'		strOutErrorDesc = "Unable to set Home Safety screening date"
'		print strOutErrorDesc
'		Exit Function
'	End If
'		print "pass, Set screening date"
'			
'	Wait 2
	
	'objects for Screening question and screening answer options
	Set objHSS_Questions = GetChildObject("micclass;class;html tag","WebElement;QuestionText.*;TD")
	intHSS_QuesCount = objHSS_Questions.Count
	Set objHSS_RadioOptions = GetChildObject("micclass;html tag;outerhtml","WebElement;DIV;.*data-capella-automation-id=""readonly_qGr.*")
	intHSS_OptionCount = objRadioOptions.Count

	'Validate screening questions
	If intHSS_QuesCount = "" OR intHSS_QuesCount = 0 Then
		strOutErrorDesc = "No screening questions existing in the screen"
		Exit Function
	End If
	print "pass, Home Safety Screening question count is: "&intHSS_OptionCount
	
	'screening with required answers
	For HSS_Question = 1 To intHSS_QuesCount
		HSS_Answer = arrAnswerOption(HSS_Question-1)
			
		Select Case HSS_Question
			Case 1:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 214
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 215
				Else
					ReqdOption = 216
				End If
			Case 2:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 217
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 218
				Else
					ReqdOption = 219
				End If
			Case 3:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 220
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 221
				Else
					ReqdOption = 222
			
				End If
			Case 4:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 223
				ElseIf lcase(answer) = "Assessed" Then
					ReqdOption = 224
				Else
					ReqdOption = 225
				End If
			Case 5:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 226
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 227
				Else
					ReqdOption = 228
				End If
			Case 6:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 229
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 230
				Else
					ReqdOption = 231
				End If
			Case 7:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 232
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 233
				Else
					ReqdOption = 234
				End If
			Case 8:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 235
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 236
				Else
					ReqdOption = 237
				End If
			Case 9:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 238
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 239
				Else
					ReqdOption = 240
				End If
			Case 10:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 241
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 242
				Else
					ReqdOption = 243
				End If
			Case 11:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 244
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 245
				Else
					ReqdOption = 246
				End If
			Case 12:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 247
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 248
				Else
					ReqdOption = 249
				End If
			Case 13:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 250
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 251
				Else
					ReqdOption = 252
				End If
			Case 14:
				If HSS_Answer = "Not Assessed" Then
					ReqdOption = 253
				ElseIf HSS_Answer = "Assessed" Then
					ReqdOption = 254
				Else
					ReqdOption = 255
				End If
		End Select
			
		Err.Clear
		Set objRadioOptions = GetChildObject("micclass;html tag;outerhtml","WebElement;DIV;.*data-capella-automation-id=""readonly_qGr.*")
		Set objReqdOptions = objPageHSS.WebElement("class:=screening-radio","html tag:=DIV","outerhtml:=.*_opt"&ReqdOption&".*","visible:=True")
		objReqdOptions.click
		
		Wait 1
		If Err.Number <> 0 Then
			Call WriteToLog("Fail",objRadioOptions(i) & " option does not click successfully. Error Returned: "&Err.Description)
			Call WriteLogFooter()
			ExitAction
		End If
	Next
	print "pass, answered all screening questions with required Options"
	Wait 5
	
	'Test postpone functionality if required
	If Lcase(strTestAll) = "y" Then
		blnHSS_ValidatePostponeBtn = HSS_ValidatePostponeBtn()
		If not blnHSS_ValidatePostponeBtn  Then
			Exit  Function
		End If
	End If
		
	'Save screening
	Execute "Set objhomesafetyScreeningSaveButton = Nothing"
	Execute "Set objhomesafetyScreeningSaveButton = "&Environment("WEL_HSSaveBtn")	'Home Safety Screening save btn
	blnHSS_Save = ClickButton("Save",objhomesafetyScreeningSaveButton,strOutErrorDesc)
	If not blnHSS_Save Then
		strOutErrorDesc = "Home Safety Screening save btn is not clicked. Error returned: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Home Safety Screening save btn is clicked")
	Wait 2
	
	Call waitTillLoads("Saving Home Safety Screening...")
	Wait 2
	'Validate Screening success message
	blnHSS_SavedPP = checkForPopup("Home Safety Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not blnHSS_SavedPP Then
		strOutErrorDesc = "HSS saved confirmation popup is not available"
		Exit Function
	End If
	Call WriteToLog("Pass", "Saved Home Safety Screening, accepted confirmation popup")

	If Lcase(strTestAll) = "no" Then
		print vblf&"Home Safety Screening is completed successfully and validated other functionalities"
	Else
		print vblf&"Home Safety Screening is completed successfully"
	End If 
		
	'Test history functionality if required
	If Lcase(strTestAll) = "y" Then
		blnHSS_ValidateHistory = HSS_ValidateHistory(dtCompletedDate)
		If not blnHSS_ValidateHistory  Then
			Exit  Function
		End If
	End If	
		
	Call WriteToLog("Pass", "Completed Home Safety Screening successfully")			
	
	HomeSafetyScreening = true
	
	Execute "Set objPageHSS =nothing"
	Execute "Set objHomeSafetyScreening_Header = Nothing"
	Execute "Set objHomeSafetyScreeningDate=Nothing"
	Execute "Set objhomesafetyScreeningAddButton=nothing"
	Execute "Set objhomesafetyScreeningPostponeButton=nothing"
	Execute "Set objhomesafetyScreeningSaveButton=nothing"
	Execute "Set objHomeSafetyScreening_HistUpArw =nothing"
	Execute "Set objHomeSafetyScreening_HtryTable =nothing"
	Set objHSS_Questions = Nothing
	Set objHSS_RadioOptions = Nothing
		
	End Function
	
'================================================================================================================================================================================================
'Function Name       :	CreateNewPatientFromPTC
'Purpose of Function :	Create a new patient from PTC user with required details
'Input Arguments     :	strPTCPatientPersonalDetails: representing patient's personal details: FirstName,LastName,Gender,DOB,Language.
						'1. Write Personal details  delimeted by "," (Eg: "John,Knight,Male,12/12/1950,English")  
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.
							'Eg1: If user needs only FirstName, then write as:   "John"
							'Eg2: If user needs only FirstName and Gender and Language, then write as:   "John,,Male,,English"
						'3. FirstName is mandatory
						
'					:	strPatientAddressDetails: representing patient's Address details (Address,City,State,Zip,HomePhone,PrimaryPhone)
						'1. Write Address details  delimeted by "," (Eg: "Villa25,Alpine,California,91901,1234567891,Home")
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.
							'Eg1: If user needs only Address, then write as:  "Villa25"
							'Eg2: If user needs only PrimaryPhone, then write as:  ",,,,,Home"
						'3. for City,State,Zip, if user is providing value to  any one filed, then he must give respective values for other two fileds also
							'Eg: If user needs only State and PrimaryPhone, then write as:  ",Alpine,California,91901,,Home"
						
'					 :	strPatientMedicalDetails: representing patient's Medical details (ReferralDate,ReferralReceivedDate,ApplicationDate,DiseaseState,LineOfBuisness,ServiceType,Source,GroupPolicyNumber)
						'1. Write  Medical details  delimeted by "," (Eg: "10/10/2015,10/10/2015,10/10/2015,CKD,Medicaid/Medicare,Field,Claims,123545")
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.
							'Eg: If user needs only ServiceType, then write as:  ",,,,,,Medicaid/Medicare"
							'Eg: If user needs only GroupPolicyNumber, then write as:  ",,,,,,,,123545"
						'3. For ReferralDate,ReferralReceivedDate,ApplicationDate, if user is providing value to  any one filed, then he must give respective values for other two fileds also
							'Eg: If user needs only ReferralDate, then write as:  "10/10/2015,10/10/2015,10/10/2015"
							
'					:	strPTCProgramDetails: representing patient's Program details (Program,Reason,ProgramStartDate)
						'1. Write Address details  delimeted by "," (Eg: "HCP Arizona ESRD,CHF,10/12/2015")
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.
							'Eg1: If user needs only Program, then write as:  "HCP Arizona ESRD"
							'Eg2: If user needs only Reason, then write as:  ",CHF"
							'Eg3: If user needs only Program and ProgramStartDate, then write as:  "HCP Arizona ESRD,,10/12/2015"

'Output Arguments    :	Longinteger value: New patient's Member ID
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	lngCreateNewPatientFromPTC = CreateNewPatientFromPTC(strPersonalDetails, strAddressDetails, strMedicalDetails, strProgramDetails, strOutErrorDesc)
'About				 :  This function is merge of three existing functions and one test: AddNewPatient(),AddPTCProgram(),PTCReferralManagement(), PTC_AddNewPatient
'Merged by		     :	Gregory
'Date				 :	13 August 2015
'Date Modified:		 :	19 October 2015	
'================================================================================================================================================================================================
Function CreateNewPatientFromPTC(ByVal strPTCPatientPersonalDetails,ByVal strPTCPatientAddressDetails,ByVal strPTCPatientMedicalDetails, ByVal strPTCProgramDetails, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""	
	CreateNewPatientFromPTC = ""	
	
	arrPTCPersonalDetails = Split(strPTCPatientPersonalDetails,",",-1,1)
	
	If lcase(strPTCPatientAddressDetails) <> "na" Then
		arrPTCAddressDetails = Split(strPTCPatientAddressDetails,",",-1,1)
	End If
	
	If lcase(strPTCPatientMedicalDetails) <> "na" Then
		arrPTCMedicalDetails = Split(strPTCPatientMedicalDetails,",",-1,1)
	End If
	
	If lcase(strPTCProgramDetails) <> "na" Then
		arrPTCProgramDetails = Split(strPTCProgramDetails,",",-1,1)
	End If
	
	
	'Personal Details
	strFirstName = Trim(arrPTCPersonalDetails(0))
	strLastName = Trim(arrPTCPersonalDetails(1))
	
	If Trim(LCase(strFirstName)) = "na" Then
		strPatientName = ProvidePatientName()
		strFirstName = Split(strPatientName,",",-1,1)(0)
		strLastName = Split(strPatientName,",",-1,1)(1)	
		
	ElseIf strFirstName = "" AND (strLastName <> "" OR Trim(LCase(strLastName)) = "na") Then
		strFirstName = "Test" & RandomNumber(1,999)	
		strLastName = Split(strPatientName,",",-1,1)(1)
		
	ElseIf strLastName = "" OR Trim(LCase(strLastName)) = "na" Then	
		strLastName = "Test" & RandomNumber(1,999)
		
	End If	
	
	strPatientName = strLastName&", "&strFirstName
	
	strGender = Trim(arrPTCPersonalDetails(2))
	If strGender = "" Then
		strGender = "Male" 
	End If
	
	dtDateOfBirth = Trim(arrPTCPersonalDetails(3))
	If dtDateOfBirth = "" Then
		dtDateOfBirth = "12/12/1970"
	End If	
	
	strLanguage = Trim(arrPTCPersonalDetails(4))
	If strLanguage = "" Then
		strLanguage = "English"
	End If		
	
	'Address details
	strAddress = Trim(arrPTCAddressDetails(0))
	If strAddress = "" OR Trim(LCase(strAddress)) = "na" Then
		strAddress = "Test Address" & RandomNumber(1,999)
	End If		
	strCity = Trim(arrPTCAddressDetails(1))
	If strCity = "" OR Trim(LCase(strCity)) = "na"  Then
		strCity = "Adak"
	End If	
	strStateValue = Trim(arrPTCAddressDetails(2))
	If strStateValue = "" OR Trim(LCase(strStateValue)) = "na"  Then
		strStateValue = "Alaska"
	End If	
	lngZipValue = Trim(arrPTCAddressDetails(3))
	If lngZipValue = "" OR Trim(LCase(lngZipValue)) = "na" Then
		lngZipValue = "99571"
	End If
	lngHomePhone = Trim(arrPTCAddressDetails(4))
	If lngHomePhone = "" OR Trim(LCase(lngHomePhone)) = "na" Then
		lngHomePhone = "1234567891"
	End If	
	strPrimaryPhone = Trim(arrPTCAddressDetails(5))
	If strPrimaryPhone = "" OR Trim(LCase(strPrimaryPhone)) = "na"  Then
		strPrimaryPhone = "Home"
	End If	
	
	'Medical Details
	dtReferralDate = Trim(arrPTCMedicalDetails(0))
	If dtReferralDate = "" OR Trim(LCase(dtReferralDate)) = "na" Then
		dtReferralDate = date-5
	End If	
	dtReferralReceivedDate = Trim(arrPTCMedicalDetails(1))
	If dtReferralReceivedDate = "" OR Trim(LCase(dtReferralReceivedDate)) = "na" Then
		dtReferralReceivedDate = date-5
	End If	
	dtApplicationDate = Trim(arrPTCMedicalDetails(2))
	If dtApplicationDate = "" OR Trim(LCase(dtApplicationDate)) = "na" Then
		dtApplicationDate = date-5
	End If	
	strDiseaseState = Trim(arrPTCMedicalDetails(3))
	If strDiseaseState = "" OR Trim(LCase(strDiseaseState)) = "na" Then
		strDiseaseState = "CKD"
	End If
	strLineOfBuisness = Trim(arrPTCMedicalDetails(4))
	If strLineOfBuisness = "" OR Trim(LCase(strLineOfBuisness)) = "na" Then
		strLineOfBuisness = "Medicaid/Medicare"
	End If
	strServiceType = Trim(arrPTCMedicalDetails(5))
	If strServiceType = "" OR Trim(LCase(strServiceType)) = "na" Then
		strServiceType = "Field"
	End If
	strSource = Trim(arrPTCMedicalDetails(6))
	If strSource = "" OR Trim(LCase(strSource)) = "na" Then
		strSource = "Claims"
	End If
	lngGroupPolicyNumber = Trim(arrPTCMedicalDetails(7))
	If lngGroupPolicyNumber = "" OR Trim(LCase(lngGroupPolicyNumber)) = "na" Then
		lngGroupPolicyNumber = "123545"
	End If
	
	'PTC Program Details
	strProgram = arrPTCProgramDetails(0)
	If strProgram = "" OR Trim(LCase(strProgram)) = "na" Then
		strProgram = "HCP Arizona ESRD"
	End If
	strReason = arrPTCProgramDetails(1)
	If strReason = "" OR Trim(LCase(strReason)) = "na" Then
		strReason = "CHF"
	End If	
	dtProgStartDate = arrPTCProgramDetails(2)
	If dtProgStartDate = "" OR Trim(LCase(dtProgStartDate)) = "na" Then
		dtProgStartDate = Date
	End If
	
	Execute "Set objAddNewPatientButton = " & Environment("WB_AddNewPatient_Button")
	Execute "Set objPatientInfoScreenTitle = " & Environment("WEL_PatientInfo_Title")
	Execute "Set objPatientFirstName = " & Environment("WE_PatientInfo_FirstName")
	Execute "Set objPatientLastName = " & Environment("WE_PatientInfo_LastName")
	Execute "Set objPatientDOB = " & Environment("WE_PatientInfo_DOB")
	Execute "Set objAddress  = " & Environment("WE_Address")
	Execute "Set objCity  = " & Environment("WE_City")
	Execute "Set objState  = " & Environment("WB_StateDropDown")
	Execute "Set objZip  = " & Environment("WE_Zip")
	Execute "Set objHomePhone  = " & Environment("WE_HomePhone_Ptc")
	Execute "Set objPrimaryPhone  = " & Environment("WB_PrimaryPhoneDropDown")
	Execute "Set objLanguage  = " & Environment("WB_LanguageDropDown")
	Execute "Set objGender  = " & Environment("WB_GenderDropDown")
	Execute "Set objGroupPolicyNumber   = " & Environment("WE_GroupPloicy")
	Execute "Set objSaveNewPatientData   = " & Environment("WEL_NewPatientSaveBtn")
	'Execute "Set objAddProgramBtn = " & Environment("WB_AddProgramBtn_PTCnewmember")
	Execute "Set objReferralManagementTitle = " & Environment("WEL_ReferralManagementTitle")
	Execute "Set objReferralDate = " & Environment("WE_ReferralDate")
	Execute "Set objReferralReceivedDate = " & Environment("WE_ReferralReceivedDate")
	Execute "Set objApplicationDate = " & Environment("WE_ApplicationDate")
	Execute "Set objPayor = " & Environment("WB_PayorDropDown")
	Execute "Set objSaveBtn = " & Environment("WB_NewReferralSave")
	Execute "Set objPagePrgStDt = " & Environment("WPG_AppParent")
	Execute "Set objProgramDropdown = " & Environment("WEL_ProgramDropDown")
	Execute "Set objReasonDropdown = " & Environment("WEL_ReasonDropDown")
	Execute "Set objStartDate = " & Environment("WE_StartDate")
	Execute "Set objProgramSaveBtn = " & Environment("WB_SaveProgramButton_Ptc")
'	Execute "Set objProgramSaveBtn = " & Environment("WB_SaveProgramButton")
'	Execute "Set objPatientProfileExpandIcon = " & Environment("WE_PatientProfileExpandIcon") 'Patient profile expand icon
	Execute "Set objPatientMemID = " & Environment("WEL_PatientMemID") 'Patient member ID
	
	'Verify AddNewPatient Button exists
	If not waitUntilExist(objAddNewPatientButton, 20) Then
		strOutErrorDesc = "AddNewPatient button does not exist"
		Exit Function	
	End If
	
	'Click on 'Add New Patient' button
	blnReturnValue = ClickButton("Add New Patient",objAddNewPatientButton,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "AddNewPatient button is not clicked. " & strOutErrorDesc
		Exit Function	
	End If	
	wait 2
	Call waitTillLoads("Loading...")
	wait 1
	
	'Verify that Patient Info screen open successfully
	If not waitUntilExist(objPatientInfoScreenTitle, 50) Then	'app performace 
		strOutErrorDesc = "Unable to open Patient Info Screen"
		Exit Function	
	End If
	
	'Set value for FirstName
	If waitUntilExist(objPatientFirstName, 20) Then
		Err.Clear
		objPatientFirstName.Set strFirstName
		If Err.Number <> 0 Then
			strOutErrorDesc = "Patient FirstName field is not set. " & Err.Description
			Exit Function
		End If
	End If
	Call WriteToLog("Pass", strFirstName & "is set to First Name field.")

	'Set value for LastName
	If waitUntilExist(objPatientLastName, 10) Then
		Err.Clear
		objPatientLastName.Set strLastName
		If Err.Number <> 0 Then
			strOutErrorDesc = "Patient LastName field is not set. " & Err.Description
			Exit Function
		End If
	End If
	Call WriteToLog("Pass", strLastName & "is set to First Name field.")

	'Set value for DOB
	If waitUntilExist(objPatientDOB, 10) Then
		Err.Clear
		objPatientDOB.Set dtDateOfBirth
		If Err.Number <> 0 Then
			strOutErrorDesc = "DOB field is not set. " & Err.Description
			Exit Function
		End If
	End If
	wait 2	
	Call waitTillLoads("Loading...")
	wait 1
	
	'Verify the Referral Management Screen Loads
	If not waitUntilExist(objReferralManagementTitle, 20) Then
		strOutErrorDesc = "Unable to open Referral Management Screen"
		Exit Function
	End If
	
	'Set Referral Date
	If waitUntilExist(objReferralDate, 10) Then
		Err.Clear
		objReferralDate.Set dtReferralDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "ReferralDate field is not set. " & Err.Description
			Exit Function
		End If
	Else
		strOutErrorDesc = "ReferralDate field is not present"
		Exit Function		
	End If
	Call WriteToLog("Pass", "ReferralDate field is set to "&dtReferralDate)
	
	'Set Referral Received Date
	If waitUntilExist(objReferralReceivedDate, 10) Then
		Err.Clear
		objReferralReceivedDate.Set dtReferralReceivedDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "ReferralReceivedDate field is not set. " & Err.Description
			Exit Function
		End If
	Else
		strOutErrorDesc = "ReferralReceivedDate field is not present"
		Exit Function		
	End If
	Call WriteToLog("Pass", "ReferralReceivedDate field is set to "&dtReferralReceivedDate)
	
	'Set Referral Application Date
	If waitUntilExist(objApplicationDate, 10) Then
		Err.Clear
		objApplicationDate.Set dtApplicationDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "ApplicationDate field is not set. " & Err.Description
			Exit Function
		End If
	Else
		strOutErrorDesc = "ApplicationDate field is not present"
		Exit Function		
	End If
	Call WriteToLog("Pass", "ApplicationDate field is set to "&dtApplicationDate)
	
	'Select Disease State	
'	Set objDiseaseState = getComboBoxReferralManagement("Disease State")
	Execute "Set objDiseaseState = " & Environment("WB_DiseaseState_ptc")
	blnReturnValue = selectComboBoxItem(objDiseaseState, strDiseaseState)
	If not blnReturnValue Then
		strOutErrorDesc = "Value is not selected from Disease State field. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Disease State is selected as "&strDiseaseState)
	
	wait 1
	Call waitTillLoads("Loading...")
	wait 1

	'Select other Line Of Business
'	Set objLOB = getComboBoxReferralManagement("Line Of Buisness")
	Execute "Set objLOB = " & Environment("WB_LOB_ptc")
	blnReturnValue = selectComboBoxItem(objLOB, strLineOfBuisness)
	If not blnReturnValue Then
		strOutErrorDesc = "Value is not selected from Line Of Business field. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Line Of Business is selected as "&strLineOfBuisness)
	
	wait 1	
	Call waitTillLoads("Loading...")
	wait 1
	
	'Select other values for Service Type
'	Set objServiceType = getComboBoxReferralManagement("ServiceType")
	Execute "Set objServiceType = " & Environment("WB_ServiceType_ptc")
	blnReturnValue = selectComboBoxItem(objServiceType, strServiceType)
	If not blnReturnValue Then
		strOutErrorDesc = "Value is not selected from Service Type field. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Service Type is selected as "&strServiceType)
	
'	Set objSource = getComboBoxReferralManagement("Source")
	Execute "Set objSource = " & Environment("WB_Source_ptc")
	blnReturnValue = selectComboBoxItem(objSource, strSource)
	If not blnReturnValue Then
		strOutErrorDesc = "Value is not selected from Source field. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Source is selected as "&strSource)
	
	'Click on the Save button in the Referral Management Screen
	blnReturnValue = ClickButton("Save",objSaveBtn,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "Save button in the Referral Management Screen is not clicked. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Referral Management is saved")
	wait 2
	
	Call waitTillLoads("Loading...")
	wait 2
	
	'Set address to Address field
	Err.Clear
	objAddress.Set strAddress
	If Err.Number <> 0 Then
		strOutErrorDesc =  "Address field is not set ." & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",strAddress & "is set to Address field")
	wait 1
	
	'Set value to City field
	Err.Clear
	objCity.Set strCity
	If Err.Number <> 0 Then
		strOutErrorDesc = "City field is not set ." & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",strCity & "is set to City field")	
	wait 1
	
	'Select value from State dropdown
	blnReturnValue = selectComboBoxItem(objState, strStateValue)
	If not blnReturnValue Then
		strOutErrorDesc = "Equipment Type field is nort selected. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strStateValue & " value is selected from State dropdown")
	wait 1
	
	'Set value to Zip field
	Err.Clear
	objZip.Set lngZipValue
	If Err.Number <> 0 Then
		strOutErrorDesc = "Zip field is not set ."& Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",lngZipValue & "is set to Zip field")
	
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Handling City-State-Zip selection error
	'strStateValue = "California" 
	Set objSateSelected = getPageObject().WebButton("html id:=data-range","html tag:=BUTTON","innertext:=.*"&strStateValue&".*","visible:=True")
	If not objSateSelected.Exist(2) Then
		Wait 1
		Execute "Set objZip = " & Environment("WE_Zip")
		Err.Clear
		objZip.Set 22222
		Wait 1
		sendKeys "{TAB}"
		Wait 1	
		Execute "Set objFoundAddress_CB = " & Environment("WE_FoundAddress_CB")
		If objFoundAddress_CB.Exist(2) Then
			Wait 1		
			Execute "Set objFoundAddress_CB = " & Environment("WE_FoundAddress_CB")
			Err.Clear
			objFoundAddress_CB.Click
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to select 'We Found' check box in Zip code validation window. Error Returned: " & Err.Description
				Exit Function
			End If
			Call WriteToLog("Pass","Selected 'We Found' check box in Zip code validation window")
			Wait 1
			
			Execute "Set objFoundAddress_OK = " & Environment("WB_FoundAddress_OK")
			Err.Clear
			objFoundAddress_OK.Click
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to click OK button of Zip code validation window. Error Returned: " & Err.Description
				Exit Function
			End If
			Call WriteToLog("Pass","Clicked OK button of Zip code validation window")
			Call WriteToLog("Pass","Handled City-State-Zip selection error")
			Wait 1		
		End If	
	End If	
	
	'Set value to Home Phone field
	Err.Clear
	objHomePhone.Set lngHomePhone
	If Err.Number <> 0 Then
		strOutErrorDesc = "Phone field is not set. " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",lngHomePhone & "is set to Home Phone field")
	wait 1
	
	'Select value from Primary Phone field
	blnReturnValue = selectComboBoxItem(objPrimaryPhone, strPrimaryPhone)
	If not blnReturnValue Then
		strOutErrorDesc = "Not selected Primary Phone field. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strPrimaryPhone & " value is selected from Primary Phone field.")
	wait 1
	
	'Select value from Language field
	blnReturnValue = selectComboBoxItem(objLanguage, strLanguage)
	If not blnReturnValue Then
		strOutErrorDesc = "Not selected Language field. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strLanguage & " value is selected from Language field.")
	wait 1
	
	'Select value from Gender field
	blnReturnValue = selectComboBoxItem(objGender, strGender)
	If not blnReturnValue Then
		strOutErrorDesc = "Not selected Gender field. Error returned: " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strGender & " value is selected from Gender field.")
	wait 1
	
	'Set Policy Number to Group/Policy Number field
	Err.Clear
	objGroupPolicyNumber.Set lngGroupPolicyNumber
	If Err.Number <> 0 Then
		strOutErrorDesc = "Group/Policy Number field is not set. " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",lngGroupPolicyNumber & "is set to Group/Policy Number field")
	Wait 1
	
	'Add Program	
	'Click on the Add Program button
	Execute "Set objAddProgramBtn = " & Environment("WB_AddProgramBtn_PTCnewmember")
	blnReturnValue = ClickButton("Add Program",objAddProgramBtn,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "AddProgram button is not clicked. " & strOutErrorDesc
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	
	'Click on the Program drop down.
'	Set objDropDown = Description.Create
'	objDropDown("micclass").Value = "WebButton"
'	objDropDown("html id").Value = "resone"
'	objDropDown("html tag").Value = "BUTTON"
'	
'	Set objDDProgram = objProgramDropdown.ChildObjects(objDropDown)

'	blnReturnValue = selectComboBoxItem(objDDProgram(0), strProgram)
	blnReturnValue = selectComboBoxItem(objProgramDropdown, strProgram)
	If not blnReturnValue Then
		strOutErrorDesc = "Not selected Program field. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Program is selected as "&strProgram)
	wait 1
	
	'Click on the Reason drop down.
	Set objDropDownReason = Description.Create
	objDropDownReason("micclass").Value = "WebButton"
	objDropDownReason("html id").Value = "resone"
	objDropDownReason("html tag").Value = "BUTTON"
	Set objDDReason = objReasonDropdown.ChildObjects(objDropDownReason)
	
	'Select Reason Drop down
	blnReturnValue = selectComboBoxItem(objDDReason(0), strReason)
	If not blnReturnValue Then
		strOutErrorDesc = "Not selected Reason field. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Reason is selected as "&strReason)
	wait 1
	
	'Set Start Date for the program
	Set objPagePrgStDt = Nothing
    Set objPagePrgStDt = getPageObject()
    objPagePrgStDt.Sync
	Set dateDesc = Description.Create
    dateDesc("micclass").Value = "WebEdit"
    dateDesc("placeholder").Value = "<MM/dd/yyyy>"
    dateDesc("attribute/data-capella-automation-id").Value = "model.addProgram.myDate"
    Set objDate = objPagePrgStDt.ChildObjects(dateDesc)
    For i = 0 To objDate.Count - 1
        outerhtml = objDate(i).GetROPRoperty("outerhtml")
        If instr(outerhtml, "addProgram.myDate") > 0 Then
			 objDate(i).Set dtProgStartDate 
        End If
    Next 
    Call WriteToLog("Pass", "Start Date for program is set to "&dtProgStartDate)
    wait 1
    Set dateDesc = Nothing
    Set objDate = Nothing

	'click on the Save button in Add Program
	If not waitUntilExist(objProgramSaveBtn,10) Then
		strOutErrorDesc = "Program save btn is not existing. " & strOutErrorDesc
		Exit Function
	End If		
		
	blnReturnValue = ClickButton("Save",objProgramSaveBtn,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "Save Program button not clicked. " & strOutErrorDesc
		Exit Function
	End If	
	wait 2	
	Call waitTillLoads("Loading...")
	wait 1
	
	'Click on the Save button after adding the program
	blnReturnValue = ClickButton("Save",objSaveNewPatientData,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "Save new patient button not clicked. " & strOutErrorDesc
		Exit Function
	End If	
	Wait 3
	Call waitTillLoads("Loading...")
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	strMessageTitle = "The Changes have been saved successfully"
	strMessageBoxText = "Member added successfully."
	
	'Check the message box having text as "Member added successfully."
	blnReturnValue = checkForPopup(strMessageTitle, "Ok", strMessageBoxText, strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Member added successfully' message box is not existing / Not clicked OK on popup "& strOutErrorDesc
		Exit Function
	End If
	Wait 1
	
	'Click on objPatientProfileExpand icon
	Execute "Set objPatientProfileExpandIcon = " & Environment("WE_PatientProfileExpandIcon") 'Patient profile expand icon
	Err.Clear
	objPatientProfileExpandIcon.Click
	If Err.number <> 0 Then
	    Err.Clear
	    Execute "Set objPatientProfileExpandIcon = " & Environment("WI_PatientProfileExpand_New")  'PatientProfileExpand icon new    
	    Err.Clear
	    objPatientProfileExpandIcon.Click
	    If Err.number <> 0 Then
	        strOutErrorDesc = "Unable to click on Patient Profile icon: "&strOutErrorDesc
	        Exit Function
	    End If
	    Call WriteToLog("Pass","Clicked on Patient Profile icon")
	End If
	Call WriteToLog("Pass","Clicked on Patient Profile icon")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	'Saving MemberId for other user's golbal searh
	lngMemberID = ""
	lngMemberID = Trim(objPatientMemID.GetROProperty("outertext"))
	If lngMemberID = "" Then
		strOutErrorDesc = "Unable to retrieve patient MemberID: "&Err.Description
		Exit Function
	End If
'	Call WriteToLog("PASS","PatientMemberID is: "&lngMemberID)	
	
	CreateNewPatientFromPTC = strPatientName&"|"&lngMemberId	
		
	'Set objects free
	Set objAddNewPatientButton = Nothing
	Set objPatientInfoScreenTitle = Nothing
	Set objPatientFirstName = Nothing
	Set objPatientLastName = Nothing
	Set objPatientDOB = Nothing
	Set objAddress = Nothing
	Set objCity = Nothing
	Set objState = Nothing
	Set objZip = Nothing
	Set objHomePhone = Nothing
	Set objPrimaryPhone = Nothing
	Set objLanguage = Nothing
	Set objGender = Nothing
	Set objGroupPolicyNumber = Nothing
	Set objSaveNewPatientData = Nothing
	Set objAddProgramBtn = Nothing
	Set objReferralManagementTitle = Nothing
	Set objReferralDate = Nothing
	Set objReferralReceivedDate = Nothing
	Set objApplicationDate = Nothing
	Set objPayor = Nothing
	Set objSaveBtn = Nothing
	Set objPagePrgStDt = Nothing
	Set objProgramDropdown = Nothing
	Set objReasonDropdown = Nothing
	Set objStartDate = Nothing
	Set objProgramSaveBtn = Nothing
	Set objPatientProfileExpandIcon = Nothing
	Set objPatientMemID = Nothing
	
End Function

'================================================================================================================================================================================================
'Function Name       :	Navigator
'Purpose of Function :	Login to the App with requried user > Close all open patients > Select user roster(i.e change dashboard to 'MyDshboard')
'Input Arguments     :	strLoginUser: string value representing required user for login (eg. VHN, ARN, EPS etc..)
'Output Arguments    :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	Call Navigator("VHN")
'Author				 :  Gregory
'Date				 :	26 October 2015
'=================================================================================================================================================================================================
Function Navigator(ByVal strLoginUser, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	Navigator = False
	
	'Login with required role
	Call WriteToLog("Info","----------Login to application, Close all open patients , Select user roster----------")
	blnLogin = Login(strLoginUser)
	If not blnLogin Then
		strOutErrorDesc = "Failed to Login to "&strLoginUser&" user."
		Exit Function
	End If
	Call WriteToLog("PASS","Successfully logged into '"&strLoginUser&"' role")
	
'	'Close all open patient     
'	blnCloseAllPats = CloseAllOpenPatient(strOutErrorDesc)
'	If Not blnCloseAllPats Then
'		strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
'		Exit Function
'	End If	

''''''''''	'Close all open patient     
''''''''''	blnCloseAllPats = closeOpenPatients(strOutErrorDesc)
''''''''''	If Not blnCloseAllPats Then
''''''''''		strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
''''''''''		Exit Function
''''''''''	End If	
	
	'Select user roster
	blnSelectUserRoster = SelectUserRoster(strOutErrorDesc)
	If Not blnSelectUserRoster Then
		strOutErrorDesc = "SelectUserRoster returned error: "&strOutErrorDesc
'		Exit Function
	End If
'	Call WriteToLog("PASS","Successfully selected user roster")

	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
	
	Navigator = True
	
	Err.Clear
	
End Function

'================================================================================================================================================================================================
'Function Name       :	CognitiveScreening
'Purpose of Function :	Perform Cognitive screening
'Input Arguments     :	strScreeningType: string value representing type of screening required.
'						If type Unable To Complete Screening, then strScreeningType should have comment also delimited with "," Eg: Unable To Complete Screening,MyComment			
'					 :	strCognitiveScreeningAnswers: string value representing required answers for Cognitive screening questions. Answers should be delimited with ","
'Output Arguments    :	Boolean value: representing CognitiveScreening status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnCognitiveScreening = CognitiveScreening("Do Screening","Correct,Incorrect,Done,Correct,Correct,1 error,All worng", strOutErrorDesc)
'About 				 :  This function is a modification of CognitiveScreening script.
'Modified by 		 :	Gregory
'Date				 :	27 October 2015
'=================================================================================================================================================================================================
Function CognitiveScreening(ByVal strScreeningType, ByVal strCognitiveScreeningAnswers, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	CognitiveScreening = False

	Execute "Set objCognPage = "&Environment("WPG_AppParent") 
	Execute "Set objCognitiveScreeningTitle = "  & Environment("WEL_CognitiveScreeningTitle") 
	Execute "Set objCognitiveScreeningDate = " & Environment("WE_CognitiveScreening_ScreeningDate") 
	Execute "Set objCognitiveScore = " & Environment("WEL_CognitiveScreening_CognitiveScore") 
	Execute "Set objCognitiveScreeningAddButton= " &Environment("WB_CognitiveScreening_AddButton") 
	Execute "Set objCommentBox = " & Environment("WE_CognitiveScreening_CommentBox")
	Execute "Set objCognitiveScreeningSaveButton= "  &Environment("WB_CognitiveScreening_SaveButton") 
	Execute "Set objPatientUnableToCompleteCheckBox = "&Environment("WEL_CognitiveScreening_PatientUnableToCompleteCheckBox") 
	
	If strScreeningType = "" Then	
		strScreeningType = "Do Screening"
	End If
	
	If Instr(1,Trim(lcase(Replace(strScreeningType," ","",1,-1,1))),"unabletocompletescreening",1) > 0 Then
		arrUnableToCompleteScreening = Split(strScreeningType,",",-1,1)
	End If
	strScreeningType = arrUnableToCompleteScreening(0)
	strComment = arrUnableToCompleteScreening(1)
	
	'click on cognitive screening
	clickOnSubMenu("Screenings->Cognitive Screening")
	wait 2
	
	waitTillLoads "Loading..."
	wait 2
	
	'verify if Cognitive screening screen loaded
	If not CheckObjectExistence(objCognitiveScreeningTitle, 10) Then
		strOutErrorDesc = "Cognitive Screening screen is not available"
		Exit Function
	End If	
	Call WriteToLog("Pass","Cognitive Screening screen is not available")
	
	If objCognitiveScreeningAddButton.Exist(1) Then
		blnReturnValue = ClickButton("Add",objCognitiveScreeningAddButton,strOutErrorDesc)
		If not blnReturnValue Then
			strOutErrorDesc = "ClickButton return: "&strOutErrorDesc
			Exit Function
		End If
	End If 
	wait 2
	
	waitTillLoads "Loading..."
	wait 2

	'Verify the number of question of cognitive screening screen
	Set objQuestions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*screening-question-answer-text.*;DIV;.*question\.Text.*")
	For i  = 0 To objQuestions.Count-1 Step 1
		Call WriteToLog("Pass",i+ 1& " question of cognitive screen is "&Trim(objQuestions(i).GetROProperty("innertext")))
	Next
	
	If objQuestions.Count = 0 Then
		strOutErrorDesc = "No question present on the screening page"
		Exit Function
	End If

	Set  objPatientRefusedCheckBox = objCognPage.WebElement("class:=screening-check-box.*","html tag:=DIV","innerhtml:=.*IsPatientRefusedSurveyEnabled.*","visible:=True")
	strStatus_UnableToCompleteCheckBox =  objPatientUnableToCompleteCheckBox.GetROProperty("outerhtml")
	strStatus_PatientRefusedSurvey = objPatientRefusedCheckBox.GetROProperty("outerhtml")
	
	Select Case Trim(lcase(Replace(strScreeningType," ","",1,-1,1)))
	
		Case "refusesurvey"
		
			If Instr(1,strStatus_UnableToCompleteCheckBox,"ng-hide",1) <= 0 Then	
				Err.Clear
				objPatientUnableToCompleteCheckBox.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to clear 'PatientUnableToComplete' CheckBox: "&Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Cleared 'PatientUnableToComplete' CheckBox")				
				Wait 1
				
				Err.Clear
				objPatientRefusedCheckBox.Click 
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to check 'PatientRefused' CheckBox: "&Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Checked 'PatientRefused' CheckBox")				
				Wait 1				

				
			ElseIf Instr(1,strStatus_PatientRefusedSurvey,"ng-hide",1) > 0 Then
				Err.Clear
				objPatientRefusedCheckBox.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to check 'PatientRefused' CheckBox: "&Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Checked 'PatientRefused' CheckBox")				
				Wait 1	
				
			End If	
			
		Case "unabletocompletescreening"
		
			If Instr(1,strStatus_PatientRefusedSurvey,"ng-hide",1) <= 0 Then	
				Err.Clear
				objPatientRefusedCheckBox.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to clear 'PatientRefused' CheckBox: "&Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Cleared 'PatientRefused' CheckBox")	
				Wait 1
				
				Err.Clear
				objPatientUnableToCompleteCheckBox.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to check 'PatientUnableToComplete' CheckBox: "&Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Checked 'PatientUnableToComplete' CheckBox")	
				Wait 1				
				
				If objCommentBox.Exist(1) Then
					Call WriteToLog("Pass","CommentBox exists for'PatientUnableToComplete' option")
					Err.Clear
					objCommentBox.Click
					If Err.Number <> 0 Then
						strOutErrorDesc = "Unable to set 'PatientUnableToComplete' comment: "&Err.Description
						Exit Function
					End If
					Call SendKeys("Testing..")
					Call WriteToLog("Pass","'PatientUnableToComplete' comment is set")	
					Wait 1						
				Else
					strOutErrorDesc = "CommentBox is not existing for 'PatientUnableToComplete' option: "&Err.Description
					Exit Function
				End If
				
			ElseIf Instr(1,strStatus_UnableToCompleteCheckBox,"ng-hide",1) > 0 Then
				Err.Clear
				objPatientUnableToCompleteCheckBox.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to check 'PatientUnableToComplete' CheckBox: "&Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Checked 'PatientUnableToComplete' CheckBox")	
				Wait 1	
				
				If objCommentBox.Exist(1) Then
					Call WriteToLog("Pass","CommentBox exists for'PatientUnableToComplete' option")
					Err.Clear
					objCommentBox.Click
					If Err.Number <> 0 Then
						strOutErrorDesc = "Unable to set 'PatientUnableToComplete' comment: "&Err.Description
						Exit Function
					End If
					Call SendKeys("Testing..")
					Call WriteToLog("Pass","'PatientUnableToComplete' comment is set")	
					Wait 1						
				Else
					strOutErrorDesc = "CommentBox is not existing for 'PatientUnableToComplete' option: "&Err.Description
					Exit Function
				End If
				
			ElseIf Instr(1,strStatus_UnableToCompleteCheckBox,"ng-hide",1) = 0 Then
				If objCommentBox.Exist(1) Then
					Call WriteToLog("Pass","CommentBox exists for'PatientUnableToComplete' option")
					Err.Clear
					objCommentBox.Click
					If Err.Number <> 0 Then
						strOutErrorDesc = "Unable to set 'PatientUnableToComplete' comment: "&Err.Description
						Exit Function
					End If
					Call SendKeys("Testing..")
					Call WriteToLog("Pass","'PatientUnableToComplete' comment is set")	
					Wait 1						
				Else
					strOutErrorDesc = "CommentBox is not existing for 'PatientUnableToComplete' option: "&Err.Description
					Exit Function
				End If		
			End If	
			
		Case "doscreening"
			Set objCognitiveScreeningAddButton = Nothing
			Execute "Set objCognitiveScreeningAddButton= " &Environment("WB_CognitiveScreening_AddButton")
			If objCognitiveScreeningAddButton.Exist(1) Then
				blnReturnValue = ClickButton("Add",objCognitiveScreeningAddButton,strOutErrorDesc)
				If not blnReturnValue Then
					Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
					Exit Function
				End If
			End If 
			wait 2
			waitTillLoads "Loading..."
			wait 2
		
			If Instr(1,strStatus_PatientRefusedSurvey,"ng-hide",1) <= 0 Then
				Err.Clear			
				objPatientRefusedCheckBox.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to clear 'PatientRefused' CheckBox: "&Err.Description
					Exit Function
				End If	
				Wait 1
			End If
			If Instr(1,strStatus_UnableToCompleteCheckBox,"ng-hide",1) <= 0 Then
				objPatientUnableToCompleteCheckBox.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to clear 'PatientUnableToCompleteCheckBox' CheckBox: "&Err.Description
					Exit Function
				End If
				Wait 1
			End If	
			Wait 1
			
			arrCogScrAns = Split(strCognitiveScreeningAnswers,",",-1,1)
				
			'Verify the number of radio button on congnitive screening screen
			Set objRadioOptions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;circular-radio.*;DIV;.*changeOptionOnQuestion.*")
			If objRadioOptions.Count = 0 Then
				Call WriteToLog("Fail","No question present on the screening page")
				Exit Function
			End If
			Call WriteToLog("Pass","Congnitive screen has "&objRadioOptions.Count&" questions")
			Dim id
			For q = 1 To 7
				answer = arrCogScrAns(q-1)
				Select Case q
					Case 1:
						If lcase(answer) = "correct" Then
							id = "o80"
						Else
							id = "o81"
						End If
					Case 2:
						If lcase(answer) = "correct" Then
							id = "o82"
						Else
							id = "o83"
						End If
					Case 3:
						id = "o84"
					Case 4:
						If lcase(answer) = "correct" Then
							id = "o85"
						Else
							id = "o86"
						End If
					Case 5:
						If lcase(answer) = "correct" Then
							id = "o87"
						ElseIf lcase(answer) = "1 error" Then
							id = "o88"
						Else
							id = "o89"
						End If
					Case 6:
						If lcase(answer) = "correct" Then
							id = "o90"
						ElseIf lcase(answer) = "1 error" Then
							id = "o91"
						Else
							id = "o92"
						End If
					Case 7:
						If lcase(answer) = "correct" Then
							id = "o93"
						ElseIf lcase(answer) = "1 error" Then
							id = "o94"
						ElseIf lcase(answer) = "2 errors" Then
							id = "o95"
						ElseIf lcase(answer) = "3 errors" Then
							id = "o96"
						ElseIf lcase(answer) = "4 errors" Then
							id = "o97"
						Else
							id = "o98"
						End If
				End Select
				
				For i  = 0 To objRadioOptions.Count-1
					outerhtml = objRadioOptions(i).getRoproperty("outerhtml")
					If instr(outerhtml, id) > 0 Then
						Err.Clear
						objRadioOptions(i).Click
						If Err.Number <> 0 Then
							strOutErrorDesc = "Unable to click required option: "&Err.Description
							Exit Function
						End If	
						Wait 1						
						Exit For
					End If
				Next
				
			Next
			
		End Select	
			
	blnReturnValue = ClickButton("Save",objCognitiveScreeningSaveButton,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "ClickButton return: "&strOutErrorDesc
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	isPass = checkForPopup("Cognitive Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not isPass Then
		strOutErrorDesc = "Expected Message box does not appear."
		Exit Function
	End If
	Call WriteToLog("Pass","Cognitive Screening save")
	wait 2
	
	'Verify the Cognitive screening score is getting display on screen
	intScore = Trim(objCognitiveScore.GetROProperty("innertext"))
	If IsNumeric(intScore) Then
		Call WriteToLog("Pass","Current screening score is: "&intScore)
	Else
		strOutErrorDesc = "Current screening score is not a Numeric value. Actual value is: " & intScore
		Exit Function
	End If
	
	CognitiveScreening = True

	Execute "Set objCognPage = Nothing"
	Execute "Set objCognitiveScreeningTitle = Nothing"
	Execute "Set objCognitiveScreeningDate = Nothing"
	Execute "Set objCognitiveScore = Nothing"
	Execute "Set objCognitiveScreeningAddButton= Nothing"
	Execute "Set objCommentBox = Nothing"
	Execute "Set objCognitiveScreeningSaveButton= Nothing"
	Execute "Set objPatientUnableToCompleteCheckBox = Nothing"
	Set objPatientRefusedCheckBox = Nothing

End Function

'================================================================================================================================================================================================
'Function Name       :	PainAssessmentScreening
'Purpose of Function :	Perform Pain Assessment screening
'Input Arguments     :	strPainAssessmentOptions: string value representing required answers for PainAssessment screening questions. Answers should be delimited with "|"
'Output Arguments    :	Boolean value: representing PainAssessment screening status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnPainAssessmentScreening = PainAssessmentScreening("Yes|Moderate|Head;Stomach|Both|Physical Therapy;Chiropractor", strOutErrorDesc)	
'						Note: For 3rd and 5th answer options, use ";" as delimiter for internal choice. Eg: "Yes|Moderate|Head;Stomach|Both|Physical Therapy;Chiropractor"
'About 				 :  This function is a modification of PainAssessment script.
'Modified by 		 :	Gregory
'Date				 :	27 October 2015
'=================================================================================================================================================================================================

Function PainAssessmentScreening(ByVal strPainAssessmentOptions, strOutErrorDesc)

	On Error Resume Next
	strOutErrorDesc = ""
	PainAssessmentScreening = False
	Err.Clear

	Execute "Set objPainAssessmentScreeningTitle = "  & Environment("WEL_PainAssessmentScreeningTitle") 'Patient Snapshot> Screening> Pain Assessment screening screen title
	Execute "Set objPainAssessmentScreeningTitle = "  & Environment("WEL_PainAssessmentScreeningTitle") 'PainAssessment screening screen title
	Execute "Set objPainAssessmentScreeningDate = " & Environment("WE_PainAssessmentScreening_ScreeningDate") 'PainAssessment screening date object
	Execute "Set objPainAssessmentScore = " & Environment("WE_PainAssessmentScreening_Score")				  'PainAssessment screening Score object
	Execute "Set objPainAssessmentScreeningAddButton= " & Environment("WB_PainAssessmentScreen_AddButton") 	  'PainAssessment screening Add button
	Execute "Set objPainAssessmentScreeningPostponeButton= "  & Environment("WB_PainAssessmentScreen_PostponeButton") 'PainAssessment screening screen postpone button
	Execute "Set objPainAssessmentScreeningSaveButton= " & Environment("WB_PainAssessmentScreen_SaveButton") 'PainAssessment screening screen Save button
	Execute "Set objScreeningHistorySection= " & Environment("WEL_ScreeningHistorySection")		  'PainAssessment screening Screening history section
	Execute "Set objOKButton= " & Environment("WB_OK") 'Ok button
	
	arrPainAssessmentOptions = Split(strPainAssessmentOptions,"|",-1,1)	
	
	'click on Pain Assessment screening
	clickOnSubMenu("Screenings->Pain Assessment Screening")
	wait 2
	
	waitTillLoads "Loading..."
	wait 2
	
	'verify if Pain Assessment screening screen loaded	
	If not CheckObjectExistence(objPainAssessmentScreeningTitle, 10) Then
		strOutErrorDesc = "Pain Assessment Screening screen is not available"
		Exit Function
	End If	
	Call WriteToLog("Pass","Pain Assessment Screening screen is available")
	
	'Click on Add button to enable new screening activity
	blnAddBtnDisabled = objPainAssessmentScreeningAddButton.Object.isDisabled
	If not blnAddBtnDisabled Then 'screening not done yet		
		blnReturnValue = ClickButton("Add",objPainAssessmentScreeningAddButton,strOutErrorDesc)
		If not blnReturnValue Then
			strOutErrorDesc = "ClickButton return: "&strOutErrorDesc
			Exit Function
		End If
	End If
	
	Set objRadioOptions = Nothing	
	'Verify the number of question of Pain Assessment screening questions
	Set objQuestions = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*screening-question-answer-text.*;DIV;.*question.Text.*")
	For i  = 0 To objQuestions.Count-1 Step 1
		Call WriteToLog("Pass",i+ 1& " question of Depression screen is "&Trim(objQuestions(i).GetROProperty("innertext")))
	Next
	
	If objQuestions.Count = 0 Then
		strOutErrorDesc = "No question present on the screening page"
		Exit Function
	End If
	
	'Verify the number of radio button on Depresion screening screen
	Set objRadioOptions = GetChildObject("micclass;html tag;cols","WebTable;TABLE;2")
	If objRadioOptions.Count = 0 Then
		strOutErrorDesc = "No radio buttons/questions present on the screening page"
		Exit Function
	End If
	
	Call WriteToLog("info", "Test Case - Complete the questions and save")
	Dim id
	For q = 1 To 5
		answer = arrPainAssessmentOptions(q-1)
		Select Case q
			Case 1:
				If lcase(answer) = "yes" Then
					id = 0
				ElseIf lcase(answer) = "no" Then
					id = 1
				End If
			Case 2:
				If lcase(answer) = "mild" Then
					id = 2
				ElseIf lcase(answer) = "moderate" Then
					id = 3
				Else
					id = 4
				End If
			Case 3:
				answers = split(answer,";")
				For a = 0 To UBound(answers)
					If lcase(answers(a)) = "head" Then
						id = 5
					ElseIf lcase(answers(a)) = "stomach" Then
						id = 6
					ElseIf lcase(answers(a)) = "back, coccyx" Then
						id = 7
					Else
						id = 8
					End If
					err.clear
					objRadioOptions(id).ChildItem(1,1,"WebElement",0).Click
				Next
			Case 4:
				If lcase(answer) = "nociceptive" Then
					id = 9
				ElseIf lcase(answer) = "neuropathic" Then
					id = 10
				Else
					id = 11
				End If
			Case 5:
				answers = split(answer,";")
				For a = 0 To UBound(answers)
					If lcase(answers(a)) = "medications ( prescription or otc)" Then
						id = 12
					ElseIf lcase(answers(a)) = "physical therapy" Then
						id = 13
					ElseIf lcase(answers(a)) = "chiropractor" Then
						id = 14
					ElseIf lcase(answers(a)) = "relaxation" Then
						id = 15
					ElseIf lcase(answers(a)) = "meditation" Then
						id = 16
					ElseIf lcase(answers(a)) = "massage therapy" Then
						id = 17
					Else
						id = 18
					End If
					
					err.clear
					objRadioOptions(id).ChildItem(1,1,"WebElement",0).Click
				Next
		End Select
		
		'click on required radio button
		If q <> 3 and q <> 5 Then
			Err.Clear
			objRadioOptions(id).ChildItem(1,1,"WebElement",0).Click
		End If
		
		Wait 1
		If Err.Number <> 0 Then
			strOutErrorDesc = objRadioOptions(id) & " option does not click successfully. Error Returned: "&Err.Description
		Else
			Call WriteToLog("Pass","Selected the option for the Question"&q)
		End If
		
		If q = 1 and id = 1 Then
			Exit For
		End If
	Next
	
	'Now Click on Save button
	blnReturnValue = ClickButton("Save",objPainAssessmentScreeningSaveButton,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "ClickButton return: "&strOutErrorDesc
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'Verify that Success message stating 'Screening has been completed successfully' should get displayed
	isPass = checkForPopup("Pain Assessment Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	If not isPass Then
		strOutErrorDesc = "Expected Message box does not appear."
		Exit Function
	End If
	
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	'Verify the Pain Assessment screening score is getting display on screen
	intScore = Trim(objPainAssessmentScore.GetROProperty("innertext"))
	If IsNumeric(intScore) Then
		Call WriteToLog("Pass","Current screening score is: "&intScore)
	Else
		strOutErrorDesc = "Current screening score is not a Numeric value. Actual value is: " & intScore
		Exit Function
	End If
	wait 2

	PainAssessmentScreening = True
	
	Execute "Set objPainAssessmentScreeningTitle = Nothing"
	Execute "Set objPainAssessmentScreeningTitle = Nothing"
	Execute "Set objPainAssessmentScreeningDate = Nothing"
	Execute "Set objPainAssessmentScore = Nothing"
	Execute "Set objPainAssessmentScreeningAddButton= Nothing"
	Execute "Set objPainAssessmentScreeningPostponeButton= Nothing"
	Execute "Set objPainAssessmentScreeningSaveButton= Nothing"
	Execute "Set objScreeningHistorySection= Nothing"
	Execute "Set objOKButton= Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	ADLScreening
'Purpose of Function :	Perform ADL screening
'Input Arguments     :	strADLoptions: string value representing required answers for ADLScreening screening questions. Answers should be delimited with "|"
'Output Arguments    :	Boolean value: representing ADLScreening screening status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnADLScreening = ADLScreening("BathingWithoutHelp,DressingWithHelp,ToiletingWithoutHelp,TransferringWithHelp,ContinenceWithHelp,FeedingWithoutHelp", strOutErrorDesc)	
'About 				 :  This function is a modification of ADLScreening script.
'Modified by 		 :	Gregory
'Date				 :	28 October 2015
'=================================================================================================================================================================================================

Function ADLScreening(ByVal strADLoptions, strOutErrorDesc)

	On Error Resume Next
	strOutErrorDesc = ""
	Err.clear
	ADLScreening = false
	
	Execute "Set objPageADL = " &Environment.Value("WPG_AppParent")
	Execute "Set objADLScreeningTitle = "  &Environment.Value("WEL_ADLScreeningTitle") 'ADL screening screen
	Execute "Set objADLScreeningAddButton= "  &Environment.Value("WEL_ADLScreening_AddButton") 'Create Object required ADL screening screen Add button
	Execute "Set objADLScreeningSaveButton= "  &Environment.Value("WEL_ADLScreening_SaveButton") 'ADL screening screen Save button
	Execute "Set objADLScreeningADLScore = " & Environment.Value("WEL_ADLScreening_ADLScore") ' SCrening score
	
	arrADLAnswerOptions = Split(strADLoptions,",",-1,1)	
	
	'Navigate to ADL screen and validate navigation
	clickOnSubMenu("Screenings->ADL Screening")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2
	
	If not waitUntilExist(objADLScreeningTitle, 10) Then	
		strOutErrorDesc = "ADL Screening screen is not available"
		Exit Function
	End If	
	Call WriteToLog("Pass","ADL Screening opened successfully")

	If objADLScreeningAddButton.Exist(10) Then
		blnADLaddClicked = ClickButton("Add",objADLScreeningAddButton,strOutErrorDesc)
		If not blnADLaddClicked Then
			strOutErrorDesc = "Unable to click Add button: "&strOutErrorDesc
			Exit Function
		End If
	End If
	Wait 2
	
	Call waitTillLoads("Loading...")
	Wait 2

	Err.Clear
	'screening	
	Set objADL_Questions = GetChildObject("micclass;outerhtml;html tag","WebElement;.*label-question.*;DIV")
	intADL_QuesCount = objADL_Questions.Count
	For ADL_Question = 1 To intADL_QuesCount
		ADL_Answer = arrADLAnswerOptions(ADL_Question-1)
			
		Select Case ADL_Question
			Case 1:
				If ADL_Answer = "BathingWithoutHelp" Then
					ReqdOption = "0-0"
				Else
					ReqdOption = "0-1"
				End If
			Case 2:
				If ADL_Answer = "DressingWithoutHelp" Then
					ReqdOption = "1-0"
				Else
					ReqdOption = "1-1"
				End If
			Case 3:
				If ADL_Answer = "ToiletingWithoutHelp" Then
					ReqdOption = "2-0"
				Else
					ReqdOption = "2-1"
				End If
			Case 4:
				If ADL_Answer = "TransferringWithoutHelp" Then
					ReqdOption = "3-0"
				Else
					ReqdOption = "3-1"
				End If
			Case 5:
				If ADL_Answer = "ContinenceWithoutHelp" Then
					ReqdOption = "4-0"
				Else
					ReqdOption = "4-1"
				End If
			Case 6:
				If ADL_Answer = "FeedingWithoutHelp" Then
					ReqdOption = "5-0"
				Else
					ReqdOption = "5-1"
				End If
		End Select
					
		Set objRadioOptions = GetChildObject("micclass;outerhtml;html tag","WebElement;.*ADL-Screening-Selected.*;DIV")
		Set objReqdOption = objPageADL.WebElement("class:=.*acp-radio.*","html tag:=DIV","outerhtml:=.*ADL-Screening-Selected-"&ReqdOption&".*","visible:=True")
		
		Err.Clear
		objReqdOption.click
		If Err.Number <> 0 Then
			strOutErrorDesc = objRadioOptions(i) & " option does not click successfully. Error Returned: "&Err.Description
			Exit Function
		End If
		Wait 1
		
	Next
	
	Call WriteToLog("Pass","ADL Screening options are selection as required")

	If objADLScreeningSaveButton.Exist(10) Then
		blnADLsaveClicked = ClickButton("Save",objADLScreeningSaveButton,strOutErrorDesc)
		If not blnADLsaveClicked Then
			strOutErrorDesc = "Unable to click Save button: "&strOutErrorDesc
			Exit Function
		End If
		
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 2
	Else
		strOutErrorDesc = "Save button is not enabled"
		Exit Function
	End If
			
	blnReturnValue = checkForPopup("ADL Screening", "Ok", "Screening has been completed successfully", strOutErrorDesc)
	Wait 2
	waitTillLoads "Loading..."
	wait 2
	If blnReturnValue Then
		Call WriteToLog("Pass","ADL Scrrening was successfully saved message is displayed. ")
	Else
		strOutErrorDesc = "Expected Result: ADL Scrrening was successfully saved message should be displayed; Actual Result: Error return: "&strOutErrorDesc
		Exit Function
	End If

	'Verify - ADL screening score same as number of green color boxes selected
	If waitUntilExist(objADLScreeningADLScore,5) Then
		Call WriteToLog("Pass","ADL score exist on ADL screening")
		intADLScreeningScore = Trim(objADLScreeningADLScore.GetROProperty("innertext"))
		
		Set objAnswerSelectedGreen = GetChildObject("micclass;outerhtml;html tag","WebElement;.*radio-button-ADL-1 acp-radio.*;DIV")
		If Cint(intADLScreeningScore) = Cint(objAnswerSelectedGreen.Count/3) Then
			Call WriteToLog("Pass","ADL score is same as number of green color boxes in screening")
		Else
			strOutErrorDesc = "ADL score is not same as number of green color boxes in screening"
			Exit Function
		End If
		
	Else
		strOutErrorDesc = "ADL score does not exist on ADL screening"
		Exit Function
	End If		

		
	ADLScreening = True

	Execute "Set objPageADL = Nothing"
	Execute "Set objADLScreeningTitle = Nothing"
	Execute "Set objADLScreeningAddButton= Nothing"
	Execute "Set objADLScreeningSaveButton= Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	DepressionScreening
'Purpose of Function :	Perform Depression screening
'Input Arguments     :	strRefusedSurvey: string value representing patient refused screening: yes/no
'					 :	strDepressionOptions: string value representing required answers for Depression screening. Answers should be delimited with "|"
						'Note1: If First option is 'Yes' then provide required comment delimited by ";" Eg: "yes;Comment1|yes|yes|i do not feel sad|i am not discouraged about my future|i do not feel like a failure|i get as much pleasure as i ever did from the things i enjoy|i feel the same about myself as ever|i dont criticize or blame myself more than usual|i dont have any thoughts of killing myself|no|yes|yes"
						'Note2: If First option is 'No then write like  "no|yes|yes|i do not feel sad|i am not discouraged about my future|i do not feel like a failure|i get as much pleasure as i ever did from the things i enjoy|i feel the same about myself as ever|i dont criticize or blame myself more than usual|i dont have any thoughts of killing myself|no|yes|yes"
'Output Arguments    :	Boolean value: representing DepressionScreening screening status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnDepressionScreening = DepressionScreening("no",no|yes|yes|i do not feel sad|i am not discouraged about my future|i do not feel like a failure|i get as much pleasure as i ever did from the things i enjoy|i feel the same about myself as ever|i dont criticize or blame myself more than usual|i dont have any thoughts of killing myself|no|yes|yes",strOutErrorDesc)
'About 				 :  This function is a modification of DepressionScreening script.
'Modified by 		 :	Gregory
'Date				 :	29 October 2015
'=================================================================================================================================================================================================

Function DepressionScreening(ByVal strRefusedSurvey, ByVal strDepressionOptions, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	DepressionScreening = false	

	Execute "Set objPageDpr = " &Environment.Value("WPG_AppParent")
	Execute "Set objDepressionScreeningTitle = "  & Environment("WEL_DepressionScreeningTitle") 'Depression screening screen title
	Execute "Set objDepressionScore = " & Environment("WE_DepressionScreening_Score")				  'Depression screening Score object
	Execute "Set objDepressionScreeningAddButton= " & Environment("WB_DepressionScreen_AddButton") 	  'Depression screening Add button
	Execute "Set objDepressionScreeningSaveButton= " & Environment("WB_DepressionScreen_SaveButton") 'Depression screening screen Save button
	Execute "Set objPatientRefusedCheckBox = " & Environment("WEL_DepressionScreening_PatientRefusedSurveyCheckBox") 'Depression screening patient refused checkbox
	Execute "Set objPopupText = " & Environment("WEL_PopUp_Text")	'Depression screening popup text
	
	If strRefusedSurvey  = "" OR LCase(strRefusedSurvey) = "na" Then
		strRefusedSurvey = "no"
	End If
	
	arrDepressionOptions = Split(strDepressionOptions,"|",-1,1)
	
	If Instr(1,lcase(arrDepressionOptions(0)),"yes",1) Then
		strMemberPrevent = lcase(arrDepressionOptions(0))
		arrMemPre = Split(strMemberPrevent,";",-1,1)
		strFirstOpt = Trim(arrMemPre(0))
		strPreventComment = Trim(arrMemPre(1))
	ElseIf Instr(1,lcase(arrDepressionOptions(0)),"no",1) Then
		strFirstOpt = arrDepressionOptions(0)
	End If
		
	'click on Depression screening
	clickOnSubMenu("Screenings->Depression Screening")
		
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'verify if Depression screening screen loaded
	If not CheckObjectExistence(objDepressionScreeningTitle, 10) Then
		strOutErrorDesc = "Depression Screening screen is not available"
		Exit Function
	End If
	Call WriteToLog("Pass","Depression Screening screen opened successfully")	

	'Click on Add button to enable new screening activity
	If not objDepressionScreeningAddButton.Object.isDisabled Then
		blnReturnValue = ClickButton("Add",objDepressionScreeningAddButton,strOutErrorDesc)
		If not blnReturnValue Then
			Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
			Exit Function
		End If
	End If

	wait 2
	waitTillLoads "Loading..."
	wait 1
	
	If lcase(strRefusedSurvey) = "no" Then
	
		Set objDepression_ScreeningQues = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*screening-question-answer-text.*;DIV;.*data-capella-automation-id=""label-question.*")
			Set objDepression_ScreeningRadioOpts = GetChildObject("micclass;class;html tag","WebElement;.*circular-radio screening-question-answer.*;DIV")
			
			intDprScreeningQuesCount = objDepression_ScreeningQues.Count
			If intDprScreeningQuesCount = 0 Then
				strOutErrorDesc = "No question present on the screening page"
				Exit Function
			End If
			
			
				For DprQuestion = 1 To intDprScreeningQuesCount Step 1
				answer = arrDepressionOptions(DprQuestion-1)
				Select Case DprQuestion
					Case 1:
						answer = strFirstOpt
						If lcase(answer) = "yes" Then
							id = 0
						ElseIf lcase(answer) = "no" Then
							id = 1
						Else
							id = 2
						End If
					Case 2:
						If lcase(answer) = "yes" Then
							id = 3
						ElseIf lcase(answer) = "no" Then
							id = 4
						Else
							id = 5
						End If
					Case 3:
						If lcase(answer) = "yes" Then
							id = 6
						ElseIf lcase(answer) = "no" Then
							id = 7
						Else
							id = 8
						End If
					Case 4:
						If lcase(answer) = "i do not feel sad" Then
							id = 9
						ElseIf lcase(answer) = "i feel sad much of the time" Then
							id = 10
						ElseIf lcase(answer) = "i am sad all the time" Then
							id = 11
						Else
							id = 12
						End If
					Case 5:
						If lcase(answer) = "i am not discouraged about my future" Then
							id = 13
						ElseIf lcase(answer) = "i feel more discouraged about my future than i used to be" Then
							id = 14
						ElseIf lcase(answer) = "i do not expect things to work out for me" Then
							id = 15
						Else
							id = 16
						End If
					Case 6:
						If lcase(answer) = "i do not feel like a failure" Then
							id = 17
						ElseIf lcase(answer) = "i have failed more than i should have" Then
							id = 18
						ElseIf lcase(answer) = "as i look back, i see a lot of failures" Then
							id = 19
						Else
							id = 20
						End If
					Case 7:
						If lcase(answer) = "i get as much pleasure as i ever did from the things i enjoy" Then
							id = 21
						ElseIf lcase(answer) = "i dont enjoy things as much as i used to" Then
							id = 22
						ElseIf lcase(answer) = "i get very little pleasure from the things i used to enjoy" Then
							id = 23
						Else
							id = 24
						End If
					Case 8:
						If lcase(answer) = "i feel the same about myself as ever" Then
							id = 25
						ElseIf lcase(answer) = "i have lost confidence in myself" Then
							id = 26
						ElseIf lcase(answer) = "i am disappointed in myself" Then
							id = 27
						Else
							id = 28
						End If
					Case 9:
						If lcase(answer) = "i dont criticize or blame myself more than usual" Then
							id = 29
						ElseIf lcase(answer) = "i am more critical of myself than I used to be" Then
							id = 30
						ElseIf lcase(answer) = "i criticize myself for all of my faults" Then
							id = 31
						Else
							id = 32
						End If
					Case 10:
						If lcase(answer) = "i dont have any thoughts of killing myself" Then
							id = 33
						ElseIf lcase(answer) = "i have thoughts of killing myself, but i would not carry them out" Then
							id = 34
						ElseIf lcase(answer) = "i would like to kill myself" Then
							id = 35
						Else
							id = 36
						End If
					Case 11:
						If lcase(answer) = "yes" Then
							id = 37
						ElseIf lcase(answer) = "no" Then
							id = 38
						Else
							id = 39
						End If
					Case 12:
						If lcase(answer) = "yes" Then
							id = 40
						ElseIf lcase(answer) = "no" Then
							id = 41
						Else
							id = 42
						End If
					Case 13:
						If lcase(answer) = "yes" Then
							id = 43
						ElseIf lcase(answer) = "no" Then
							id = 44
						Else
							id = 45
						End If
				End Select
		
				blnPreventMember = False
				If DprQuestion = 1 and id = 0 Then
					blnPreventMember = True
					Err.Clear			
					objDepression_ScreeningRadioOpts(id).Click
					If Err.Number <> 0 Then
						strOutErrorDesc = "First option not clicked successfully. Error Returned: "&Err.Description
						Exit Function
					End If
					Wait 1
					
					Err.Clear
					objPageDpr.WebEdit("class:=form-control freeformtext.*","html tag:=INPUT","visible:=True").Set strPreventComment
					If Err.Number <> 0 Then
						strOutErrorDesc = "First option comment not set. Error Returned: "&Err.Description
						Exit Function
					End If
					
					Exit For
				End If
		
				Err.Clear
				objDepression_ScreeningRadioOpts(id).Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Required option does not click successfully. Error Returned: "&Err.Description
					Exit Function
				End If
				Wait 1
			Next
		
		If blnPreventMember Then
			
			For DprQuestion = 11 To 13
				answer = arrDepressionOptions(DprQuestion-1)
				Select Case DprQuestion
		
					Case 11:
						If lcase(answer) = "yes" Then
							id = 37
						ElseIf lcase(answer) = "no" Then
							id = 38
						Else
							id = 39
						End If
					Case 12:
						If lcase(answer) = "yes" Then
							id = 40
						ElseIf lcase(answer) = "no" Then
							id = 41
						Else
							id = 42
						End If
					Case 13:
						If lcase(answer) = "yes" Then
							id = 43
						ElseIf lcase(answer) = "no" Then
							id = 44
						Else
							id = 45
						End If
				End Select
				
				Err.Clear
				objDepression_ScreeningRadioOpts(id).Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Required option does not click successfully. Error Returned: "&Err.Description
					Exit Function
				End If
				Wait 1
			Next
		
		End If
	
	Else
		'Check the 'Patient refused survey' checkbox
		If CheckObjectExistence(objPatientRefusedCheckBox,5) Then
			Call WriteToLog("Pass","'Patient refused survey' check box exist on screening")
			Err.Clear
			objPatientRefusedCheckBox.Click
			If Err.Number <> 0 Then
				strOutErrorDesc = "User not able to click on 'Patient refused survey' check box"
				Exit Function
			End If
			Call WriteToLog("Pass","User able to click on 'Patient refused survey' check box")
		Else
			strOutErrorDesc = "'Patient refused survey' check box does not exist on screening"
			Exit Function
		End If
		
		wait 2
		waitTillLoads "Loading..."
		wait 1
	
	End If

	'Click on Save button
	blnReturnValue = ClickButton("Save",objDepressionScreeningSaveButton,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "ClickButton return: "&strOutErrorDesc
		Exit Function
	End If
	
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	isPass = checkForPopup("Depression Screening", "Ok", "", strOutErrorDesc)
	If not isPass Then
		strOutErrorDesc = "Expected Message box does not appear."
		Exit Function
	End If
	
	wait 2 
	waitTillLoads "Loading..."
	wait 2
	
	'Verify the Depression screening score is getting display on screen
	intScore = Trim(objDepressionScore.GetROProperty("innertext"))
	If IsNumeric(intScore) Then
		Call WriteToLog("Pass","Current screening score is: "&intScore)
	Else
		strOutErrorDesc = "Current screening score is not a Numeric value. Actual value is: " & intScore
		Exit Function
	End If

	DepressionScreening = True
	
	Execute "Set objPageDpr = Nothing"
	Execute "Set objDepressionScreeningTitle = Nothing"
	Execute "Set objDepressionScore = Nothing"
	Execute "Set objDepressionScreeningAddButton= Nothing"
	Execute "Set objDepressionScreeningSaveButton= Nothing"
	Execute "Set objPatientRefusedCheckBox = Nothing"
	Execute "Set objPopupText = Nothing"
		
End Function	

'================================================================================================================================================================================================
'Function Name       :	GetAssingnedUserDashboard
'Purpose of Function :	Open patient in assingned user's dashboard
'Input Arguments     :	lngPatientMemberID: Long integer value representing meber Id of patient
'Output Arguments    :	strAssignedUser: string value representing assigned user name
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnGetAssingnedUserDashboard = GetAssingnedUserDashboard("177887", strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	29 October 2015
'=================================================================================================================================================================================================

Function GetAssingnedUserDashboard(ByVal lngPatientMemberID, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	GetAssingnedUserDashboard = ""
	
	Execute "Set objPageDashboard = " &Environment("WPG_AppParent")'Page object	
	Execute "Set objGloSearch = " &Environment("WE_GloSearch")'GlobalSearch TxtField	
	Execute "Set objGlobalSearchIcon = " &Environment("WI_GlobalSearchIcon")'GlobalSearch icon	
	Execute "Set objGloSearchGrid = " &Environment("WEL_GloSearchGrid")'PatientSearchResult popup OK btn
	Execute "Set objPSResOK = " &Environment("WB_PSResOK")'PatientSearchResult popup OK btn	
	Execute "Set objRosterName = " & Environment("WEL_RosterName") 	
	
	Set objGridCancel = objPageDashboard.WebButton("class:=btn-custom-model btn-custom.*","html tag:=BUTTON","innertext:= Cancel","outerhtml:=.*data-capella-automation-id=""Global-Search-Button-Cancel.*","type:=submit","visible:=True")
	Set objMaxPatientsPP = objPageDashboard.WebElement("class:=modal-body.*","html tag:=DIV","innertext:=.*You have met the maximum number of patient records open.*","visible:=True")
	
	'Set patient MemID in global search search field
	Err.Clear	
	objGloSearch.Set lngPatientMemberID
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set patient member ID in global search field: "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass", "Patient member ID is set in global search field")
	Wait 1			
	
	'Clk on global search icon
	If objGlobalSearchIcon.Exist(2) Then		
		Err.Clear	
		objGlobalSearchIcon.Click
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to click on global search icon: "&Err.Description
			Exit Function	
		End If
		Call WriteToLog("Pass", "Clicked global search icon")
	Else
		Execute "Set objGloSearch = " &Environment("WE_GloSearch")'GlobalSearch TxtField
		Err.Clear
		
		objGloSearch.Click
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to click on global search icon for sending enter key: "&Err.Description
			Exit Function	
		End If
		
		Set W_Shell = CreateObject("WScript.Shell")		
		W_Shell.SendKeys "{ENTER}"	
		
		Set W_Shell = Nothing	
		Execute "Set objGloSearch = Nothing"
	End If
		
	Wait 2	
	Call waitTillLoads("Searching...")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1	
	
'	Err.Clear	
'	objGlobalSearchIcon.Click
'	If Err.number <> 0 Then
'		strOutErrorDesc = "Unable to click on global search icon: "&Err.Description
'		Exit Function
'	End If
'	Call WriteToLog("Pass", "Clicked global search icon")
'	Wait 3
'	Call waitTillLoads("Searching...")
'	Wait 2
	
	'Verify 'no matching results found' message box exists when no patient found
    blnNoResultPopup = checkForPopup("Error", "Ok", "No matching results found", strOutErrorDesc)
    If blnNoResultPopup Then
		strOutErrorDesc = "Invalid Member ID"
		Exit Function
	End If
    
    'Check whether PatientSearchResult popup is available
    If not objGloSearchGrid.Exist(10) Then
		strOutErrorDesc = "Unable to find PatientSearchResult popup"
		Exit Function
	End If
 	Call WriteToLog("Pass", "Patient Search Result popup is available")
  
  	'getting assigned user from Patient seacrh popup
  	strPatientDetails = objPageDashboard.WebTable("class:=k-selectable","column names:=.*"&lngPatientMemberID&".*","name:=WebTable","visible:=True").GetROProperty("column names")
    arrPatientDetails = Split(strPatientDetails,";",-1,1)
	strAssignedUser = Trim(arrPatientDetails(4)) 'Assigned user's name is shown in 5th coulmn of Patient seacrh popup
	
	If strAssignedUser = "" Then
		strOutErrorDesc = "Assigned user shows blank - Patient may be 'Termed' OR patient might not be assigned to VHN/ARN user"
		Exit Function
	End If
		
	'get roster name in required format	
	
'	strAssignedUser = Replace(strAssignedUser,",","",1,-1,1)
'	arrFNnLN = Split(strAssignedUser," ",-1,1)	'required roster
'	strAssignedUser = arrFNnLN(1)&" "&arrFNnLN(0)	'current roster	

	strAssignedUser = Split(strAssignedUser,", ",-1,1)(1)&" "&Split(strAssignedUser,", ",-1,1)(0)

	strCurrentRosterReqd = Replace(strAssignedUser," ","",1,-1,1)
	strCurrentRosterFromApp = Ucase(Replace((objRosterName.GetROProperty("outertext"))," ","",1,-1,1))
	
	If Instr(1,strCurrentRosterFromApp,strCurrentRosterReqd,1) <= 0 Then	'if required and current rosters not match
		
		'Clk on Cancel of search popup
		blnGridCancelClicked = ClickButton("Cancel",objGridCancel,strOutErrorDesc)
		If not blnGridCancelClicked Then
			strOutErrorDesc = "Click Cancel of search popup return: "&strOutErrorDesc
			Exit Function
		End If	
		Wait 1
		
		'Switch to required roster
		blnSelectRequiredRoster = SelectRequiredRoster(strAssignedUser, strOutErrorDesc)
		If not blnSelectRequiredRoster Then
			GetAssingnedUserDashboard = ""
			Exit Function		
		End If
		Wait 1
	
		'search patient through global search
		blnGlobalSearch = GlobalSearchUsingMemID(lngPatientMemberID,strOutErrorDesc)
		If not blnGlobalSearch Then
			GetAssingnedUserDashboard = ""
			Exit Function	
		End If
		
		If objMaxPatientsPP.Exist(5) Then 'if 'maximum number of patient records open' popup exists, then close all open patients and search again
			blnMaxPatientsPPclosed = checkForPopup("Error", "Ok", "maximum number of patient records open", strOutErrorDesc)
			If Not blnMaxPatientsPPclosed Then
				strOutErrorDesc = "Unable to close 'Maximum number patients' popup: "&strOutErrorDesc
				Exit Function 
			End If	
			Call WriteToLog("Pass", "Closed 'Maximum number patients' popup")
			Wait 1
			'Close all open patients 
			blnCloseAllPats = CloseAllOpenPatient(strOutErrorDesc)
			If Not blnCloseAllPats Then
				strOutErrorDesc = "CloseAllOpenPatient returned error: "&strOutErrorDesc
				Exit Function 
			End If
			Call WriteToLog("Pass", "Closed all open patients")	
			Wait 2
			Call waitTillLoads("Loading...")
			Wait 2			
			'search patient through global search
			blnGlobalSearch = GlobalSearchUsingMemID(lngPatientMemberID,strOutErrorDesc)
			If not blnGlobalSearch Then
				GetAssingnedUserDashboard = ""
				Exit Function	
			End If
		End If	
		
		'Call WriteToLog("Pass", "Opened required patient in the assigned user's dashboard")	
		
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 2
	
	Else 'if required and current rosters match
		'click OK of patient search grid
		blnGridOKClicked = ClickButton("OK",objPSResOK,strOutErrorDesc)
		If not blnGridOKClicked Then
			strOutErrorDesc = "Unable to Click Patient search grid OK button"
			Exit Function	
		End If
		Call WriteToLog("Pass", "Opened required patient in the assigned user's dashboard")	
		
		Wait 2
		Call waitTillLoads("Loading...")
		Wait 2
		
	End If	

	GetAssingnedUserDashboard = strAssignedUser
	
	Execute "Set objPageDashboard = Nothing"
	Execute "Set objGloSearch = Nothing"
	Execute "Set objGlobalSearchIcon = Nothing"
	Execute "Set objGloSearchGrid = Nothing"
	Execute "Set objPSResOK = Nothing"
	Execute "Set objRosterName = " & Environment("WEL_RosterName") 	
	Set objGridCancel = Nothing
	Set objMaxPatientsPP = Nothing
	
End Function

'================================================================================================================================================================================================
'Function Name       :	PatientAssessmentBaseLine
'Purpose of Function :	Complete PatientAssessmentBaseLine
'Input Arguments     :	dtFirstEverDialysisDate: Date representing FirstEverDialysis date
'					 :	dtFirstChronicDialysis: Date representing FirstChronicDialysis date
'					 :	strFirstDialysis: String value representing FirstDialysis
'					 :	strChronicDialysis: String value representing ChronicDialysis
'					 :	strHearingImpairement: String value representing HearingImpairement
'					 :	strVisionImpairement: String value representing VisionImpairement
'Output Arguments    :	Boolean value: representing PatientAssessmentBaseLine completion status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnPatientAssessmentBaseLine = PatientAssessmentBaseLine("10/10/2015","10/10/2015","Inpatient","0429A-AIDS NEPHROPATHY","Deaf","Blind",strOutErrorDesc)
'About 				 :  This function is a modification of patientAssessmentBaseLine function.
'Modified by 		 :	Gregory
'Date				 :	29 October 2015
'=================================================================================================================================================================================================

Function PatientAssessmentBaseLine(ByVal dtFirstEverDialysisDate, ByVal strFirstEverDialysisValue, ByVal dtFirstChronicDialysisDate,ByVal strPrimaryCausesOfRenalDisease, ByVal strHearingImpairement, ByVal strVisionImpairement, strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PatientAssessmentBaseLine = false
	
	Execute "Set objPatientAssessmentScreenTitle = "  &Environment("WEL_PatientAssessment_ScreenTitle")
	Execute "Set objBaselineSection = "& Environment("WEL_Baseline_Section")
	Execute "Set objAssesmentDate = "& Environment("WE_PatientAssessment_AssessmentDate")
	Execute "Set objFirstEverDialysisDate = "& Environment("WE_PatientAssessment_FirstEverDialysisDate")
	Execute "Set objPatientAssessment_SettingofFirsteverDialysis = " & Environment("WB_PatientAssessment_SettingofFirsteverDialysis")
	Execute "Set objFirstchronicDialysisDate = "& Environment("WE_PatientAssessment_FirstChronicDialysisDate")
	Execute "Set objPatientAssessment_PrimaryCausesOfRenalDisease = " & Environment("WB_PatientAssessment_PrimaryCausesOfRenalDisease")
	Execute "Set objHearingImpairement = "& Environment("WB_PatientAssessment_HearingImpairement")
	Execute "Set objVisionImpairement = "& Environment("WB_PatientAssessment_VisionImpairement")
	Execute "Set objSave = " & Environment("WEL_PatientAssessment_SaveButton")
	
	If dtFirstEverDialysisDate = "" OR lcase(Trim(dtFirstEverDialysisDate)) = "na" Then
		dtFirstEverDialysisDate = Date-1
	End If	
	If strFirstEverDialysisValue = "" OR lcase(Trim(strFirstEverDialysisValue)) = "na" Then
		strFirstEverDialysisValue = "Inpatient"
	End If	
	If dtFirstChronicDialysisDate = "" OR lcase(Trim(dtFirstChronicDialysisDate)) = "na" Then
		dtFirstChronicDialysisDate = Date-1
	End If	
	If strPrimaryCausesOfRenalDisease = "" OR lcase(Trim(strPrimaryCausesOfRenalDisease)) = "na" Then
		strPrimaryCausesOfRenalDisease = "0429A-AIDS NEPHROPATHY"
	End If
	If strHearingImpairement = "" OR lcase(Trim(dtFirstEverDialysisDate)) = "na" Then
		strHearingImpairement = "Deaf"
	End If	
	If strVisionImpairement = "" OR lcase(Trim(dtFirstEverDialysisDate)) = "na" Then
		strVisionImpairement = "Blind"
	End If	
	
	'Verify that Patient Assessment screen is available
	blnPatientAssessmentScreenTitle = CheckObjectExistence(objPatientAssessmentScreenTitle, 10)
	If not blnPatientAssessmentScreenTitle Then
		strOutErrorDesc = "Patient Assessment screen is not available"
		Exit Function
	End If	
	Call WriteToLog("Pass","Patient Assessment screen is available")
	
	'Click on baseline section
	blnBaselineSection = CheckObjectExistence(objBaselineSection, 10)
	If not blnBaselineSection Then
		strOutErrorDesc = "Baseline Section does not exist in Patient Assessment screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Baseline Section exist in Patient Assessment screen")
	
	'Click on baseline section
	Err.Clear
	objBaselineSection.Click
	If Err.Number <> 0 Then
		Call WriteToLog("Fail", "Failed to click on Baseline tab")
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked on Baseline Section")
	
	'validate assessment date is by default todays date
	dtDefaultAssessmentDate = objAssesmentDate.getROProperty("value")
	dtDefaultAssessmentDate = CDate(dtDefaultAssessmentDate)
	If dtDefaultAssessmentDate = Date Then
		Call WriteToLog("Pass", "Assessment date is by default today's date as required.")
	Else
		strOutErrorDesc = "Assessment date is not by default today's date as required. Date is " & dtDefaultAssessmentDate
	End If
	
	'Set Date of First ever Dialysis
	Err.Clear
	objFirstEverDialysisDate.Set dtFirstEverDialysisDate
'	If Err.Number <> 0 Then
'		Call WriteToLog("Fail","First Ever Dialysis date not set successfuly. Error Returned: " & Err.Description)
'		Exit Function
'	End If
'	Call WriteToLog("Pass", "FirstEverDialysisDate is set")
	
	'Select First ever Dialysis from the dropdown
	Err.Clear
	blnFirsteverDialysis = selectComboBoxItem(objPatientAssessment_SettingofFirsteverDialysis, strFirstEverDialysisValue)
	If not blnFirsteverDialysis Then
		strOutErrorDesc = "Unable to select FirsteverDialysis value from dropdown"
		Exit Function
	End If
	Call WriteToLog("Pass", "Select FirsteverDialysis value from dropdown")
		
	'Set Date of First chronic Dialysis
	Err.Clear
	objFirstchronicDialysisDate.Set dtFirstChronicDialysisDate
	If Err.Number <>0 Then
		Call WriteToLog("Fail", Err.Description)
		Exit Function
	End If
	Call WriteToLog("Pass", "FirstchronicDialysisDate is set")

	'Select value for PrimaryCausesOfRenalDisease from the dropdown	
	blnPrimaryCausesOfRenalDisease = selectComboBoxItem(objPatientAssessment_PrimaryCausesOfRenalDisease, strPrimaryCausesOfRenalDisease)
	If not blnPrimaryCausesOfRenalDisease Then
		strOutErrorDesc = "Unable to select PrimaryCausesOfRenalDisease value from dropdown"
		Exit Function
	End If
	Call WriteToLog("Pass", "Select PrimaryCausesOfRenalDisease value from dropdown")

	'Select the value for hearing impairement
	blnHearingImpairement = selectComboBoxItem(objHearingImpairement, strHearingImpairement)
	If not blnHearingImpairement Then
		strOutErrorDesc = "Hearing impairement value is not selected from the dropdown"
		Exit Function
	End If	
	
	'Select the value for vision impairement
	blnVisionImpairement = selectComboBoxItem(objVisionImpairement, strVisionImpairement)
	If not blnVisionImpairement Then
		strOutErrorDesc = "Vision impairement value is not selected from the dropdown"
		Exit Function
	End If			
	wait 1
	
	'click on save button
	blnSaveClicked = ClickButton("Save",objSave,strOutErrorDesc)
	If not blnSaveClicked Then
		strOutErrorDesc = "Save button is not clicked"
		Exit Function
	End If			
	
	wait 3
	waitTillLoads "Loading..."
	wait 2
	waitTillLoads "Loading..."
	wait 1
	waitTillLoads "Loading..."
	wait 1
	
	
	'click on Ok on message box
	blnPatientAssessmentPPok = checkForPopup("Patient Assessment", "Ok", "Patient Assessment has been saved successfully", strOutErrorDesc)
	If not blnPatientAssessmentPPok Then
		strOutErrorDesc = "Ok on message box is not clicked"
		Exit Function
	End If		
	
	PatientAssessmentBaseLine = True
	
	Execute "Set objPatientAssessmentScreenTitle = Nothing"
	Execute "Set objBaselineSection = Nothing"
	Execute "Set objAssesmentDate = Nothing"
	Execute "Set objFirstEverDialysisDate = Nothing"
	Execute "Set objPatientAssessment_SettingofFirsteverDialysis = Nothing"
	Execute "Set objFirstchronicDialysisDate = Nothing"
	Execute "Set objPatientAssessment_PrimaryCausesOfRenalDisease = Nothing"
	Execute "Set objHearingImpairement = Nothing"
	Execute "Set objHearingImpairement = Nothing"
	Execute "Set objVisionImpairement = Nothing"
	Execute "Set objSave = Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	AddComorbid
'Purpose of Function :	Add comorbids for a patient
'Input Arguments     :	dtReportedDate: Date value representing ReportedDate
'					 :	strComorbidType: string value representing ComorbidType
'					 :	strProvider: String value representing Provider
'Output Arguments    :	Boolean value: representing AddComorbid status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnAddComorbid = AddComorbid("10/30/2015/","Alzheimer","VHN : LENON, CATHERINE", strOutErrorDesc)
'About 				 :  This function is taken from Comorbids script.
'Modified by 		 :	Gregory
'Date				 :	29 October 2015
'=================================================================================================================================================================================================
Function AddComorbid(ByVal dtReportedDate, ByVal strComorbidType, ByVal strProvider, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	AddComorbid = False

	Execute "Set objComorbidHeader ="&Environment("WEL_ComorbidHeader")
	Execute "Set objComorbidReportedDate ="&Environment("WE_ComorbidReportedDate")
	Execute "Set objAddButton = " & Environment("WB_ComorbidDetailsAdd")
	Execute "Set objComorbidType = " & Environment("WB_ComorbidType")
	Execute "Set objProvider = " & Environment("WB_ComorbidProvider")
	Execute "Set objSaveButton = " & Environment("WB_ComorbidDetailsSave")
	Execute "Set objComorbidListTable = " & Environment("WB_ComorbidListTable")	
	
	If lcase(dtReportedDate) = "na" Then
		dtReportedDate = Date
	End If
	
	'Navigate to comorbids screen
	Call clickOnSubMenu("Clinical Management->Comorbids")
	wait 2
	waitTillLoads "Loading..."
	wait 2
	
	'Validate Comorbid screen navigation
	If not objComorbidHeader.Exist(5) Then
		strOutErrorDesc = "Comorbids screen is not available"
		Exit Function
	End If
	Call WriteToLog("Pass", "Navigated to Comorbids screen")
	
	'Click Add button for adding comorbid
	If objAddButton.Exist(1) Then
		blnAddClicked = ClickButton("Add",objAddButton,strOutErrorDesc)
		If not(blnAddClicked) Then
	        strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
	        Exit Function    
	    End If		
	End If
    wait 2    
	Call waitTillLoads("Loading...")
	wait 2
	
	'Set Reported date
	Err.Clear
	objComorbidReportedDate.Set dtReportedDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set ReportedDate: "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Comorbid ReportedDate is set")
			
	'Select ComorbidType
	blnComorbidType = selectComboBoxItem(objComorbidType, strComorbidType)
	If not blnComorbidType Then
		strOutErrorDesc = "Unable to select ComorbidType "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Selected ComorbidType")
	Wait 1	
	
	'Select Provider
	blnProvider = selectComboBoxItem(objProvider, strProvider)
	If not blnProvider Then
		strOutErrorDesc = "Unable to select Provider "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", "Selected Provider for new Comorbid")
	Wait 1	
	
	'Save newly added comorbid
	blnSaveClicked = ClickButton("Save",objSaveButton,strOutErrorDesc)
	If not(blnSaveClicked) Then
        strOutErrorDesc = "ClickButton return error: "&strOutErrorDesc
        Exit Function    
    End If
	wait 2	
	Call waitTillLoads("Loading...")
	wait 2
	
	AddComorbid = True
	
	Execute "Set objComorbidHeader = Nothing"
	Execute "Set objComorbidReportedDate = Nothing"
	Execute "Set objAddButton = Nothing"
	Execute "Set objComorbidType = Nothing"
	Execute "Set objProvider = Nothing"
	Execute "Set objSaveButton = Nothing"
	Execute "Set objComorbidListTable = Nothing"	

End Function

'================================================================================================================================================================================================
'Function Name       :	ActionItemTaskBorderColor
'Purpose of Function :	Get border color of ActionItem taskcard for required patient
'Input Arguments     :	strPatientName: String value representing patient name
'Output Arguments    :	String value representing ActionItem taskcard border color
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	strBorderColor = ActionItemTaskBorderColor(strPatientName, strOutErrorDesc)
'Author      		 :	Gregory
'Date				 :	02 November 2015
'=================================================================================================================================================================================================
Function ActionItemTaskBorderColor(ByVal strPatientName, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ActionItemTaskBorderColor = ""
	
	Execute "Set objActionItems ="&Environment("WEL_ActionItems") 'object for ActionItems

	'Object for required patient TaskCard
	Set oTaskCardDesc = Description.Create
	oTaskCardDesc("micclass").value = "WebElement"
	oTaskCardDesc("html tag").value = "DIV"
	oTaskCardDesc("outertext").value = ".*"&Trim(strPatientName)&".*"
	oTaskCardDesc("outertext").regularexpression = true
	oTaskCardDesc("class").value = ".*detailView-patient action-item-gradient.*"
	oTaskCardDesc("class").regularexpression = true
	oTaskCardDesc("visible").value = true
	Set objTaskCards = objActionItems.ChildObjects(oTaskCardDesc)
	
	objTaskCards(0).highlight
	Err.Clear
	If not objTaskCards(0).Exist(2) Then
		strOutErrorDesc = "Unable to selected patient's TaskCard"
		Exit Function
	End If
	Call WriteToLog("Pass", "Selected required patient TaskCard")
	Wait 0,250
	
	'get border details
	strBorderDetails = objTaskCards(0).GetROProperty("class")
	If strBorderDetails = "" Then
		strOutErrorDesc = "Unable to retrieve TaskCard details"
		Exit Function
	End If
	Call WriteToLog("Pass", "Retrieved patient TaskCard details")
	
	'Border color description
	strBorderBrownColorDescription = "overdue-border" 'brown border??
	strBorderRedColorDescription = "high-border" 'red border
	strBorderYellowColorDescription = "medium-border" 'yellow border
	strBorderGreenColorDescription = "low-border" 'green border
	
	'Return color availed
	If Instr(1,strBorderDetails,strBorderBrownColorDescription,1) Then
		ActionItemTaskBorderColor = "brown" '??
	ElseIf Instr(1,strBorderDetails,strBorderRedColorDescription,1) Then
		ActionItemTaskBorderColor = "red"
	ElseIf Instr(1,strBorderDetails,strBorderYellowColorDescription,1) Then
		ActionItemTaskBorderColor = "yellow"
	ElseIf Instr(1,strBorderDetails,strBorderGreenColorDescription,1) Then
		ActionItemTaskBorderColor = "green"
	End If
	
	If ActionItemTaskBorderColor = "" Then
		strOutErrorDesc = "Available border color for specified task is neither brown/red/yellow/green"
		Err.Clear
		Exit Function
	End If
	
	Set objActionItems = Nothing
	Set oTaskCardDesc = Nothing
	Set objTaskCards = Nothing
		
End Function

'================================================================================================================================================================================================
'Function Name       :	ActionItemTaskIconColor
'Purpose of Function :	Get specific task icon color of ActionItem taskcard for required patient
'Input Arguments     :	strPatientName: String value representing patient name
'					 :	strTask: String value representing task
'Output Arguments    :	String value representing ActionItem task icon color
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	strTaskIconColor = ActionItemTaskIconColor(strPatientName, strPatientTask, strOutErrorDesc)
'Author				 :	Gregory
'Date				 :	02 November 2015
'=================================================================================================================================================================================================
Function ActionItemTaskIconColor(ByVal strPatientName,ByVal strTask, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ActionItemTaskIconColor = ""

	Execute "Set objActionItems = "&Environment("WEL_ActionItems") 'object for ActionItems
	Execute "Set objOpenTaskCard = "&Environment("WE_TaskCard") 'object for opentask card	
	
	'Object for required patient TaskCard
	Set oTaskCardDesc = Description.Create
	oTaskCardDesc("micclass").value = "WebElement"
	oTaskCardDesc("html tag").value = "DIV"
	oTaskCardDesc("outertext").value = ".*"&Trim(strPatientName)&".*"
	oTaskCardDesc("outertext").regularexpression = true
	oTaskCardDesc("class").value = ".*detailView-patient action-item-gradient.*"
	oTaskCardDesc("class").regularexpression = true
	oTaskCardDesc("visible").value = true
	Set objTaskCards = objActionItems.ChildObjects(oTaskCardDesc)
	
	objTaskCards(0).highlight	
	Err.Clear
	If not objTaskCards(0).Exist(2) Then
		strOutErrorDesc = "Unable to selected patient's TaskCard"
		Exit Function
	End If
	Call WriteToLog("Pass", "Selected required patient TaskCard")
	Wait 0,500
	
	'object for slider
	Set oSliderDesc = Description.Create
	oSliderDesc("micclass").value = "WebElement"
	oSliderDesc("html tag").value = "DIV"
	oSliderDesc("outertext").value = ".*▼▲.*"
	oSliderDesc("outertext").regularexpression = true
	oSliderDesc("visible").value = true
	Set objSliders = objTaskCards(0).ChildObjects(oSliderDesc)

	'Click on slider
	Err.Clear
	objSliders(0).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on task slider"
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on TaskCard slider")
	Wait 0,500	
	
	'object for tasks		
	Set oTasksDesc = Description.Create
	oTasksDesc("micclass").Value = "WebElement"
	oTasksDesc("class").Value = ".*row.*"
	oTasksDesc("class").RegularExpression = True
	Set objTasks = objOpenTaskCard.ChildObjects(oTasksDesc)
	
	If objTasks.Count = 0 Then
		strOutErrorDesc = "Tasks are not available in patient TaskCard"
		Exit Function
	End If
	Call WriteToLog("Pass", "Tasks are available in patient TaskCard")
	
	For task = 0 To objTasks.Count-1	Step 1
	
		Set oSecificTaskNames = Description.Create
		oSecificTaskNames("micclass").Value = "WebElement"
'		oSecificTaskNames("class").Value = "ng-binding"
		oSecificTaskNames("html tag").Value = "PRE"
		Set objSecificTaskNames = objTasks(task).ChildObjects(oSecificTaskNames)
		
		Set oSpecificTaskColor = Description.Create
		oSpecificTaskColor("micclass").Value = "WebElement"
		oSpecificTaskColor("class").Value = "col-md-8.*"
		Set objSpecificTasksColor = objTasks(task).ChildObjects(oSpecificTaskColor)
		
		'Specific task details
		strTaskNameDetails = objSecificTaskNames(0).GetROProperty("outertext")
		If strTaskNameDetails = "" Then			
			strOutErrorDesc = "Required task is not available in patient TaskCard"
			Exit Function
		End If
		Call WriteToLog("Pass", "Required task is available in patient TaskCard")
				
		strTaskColorDetails = objSpecificTasksColor(0).GetROProperty("outerhtml")			
		If strTaskColorDetails = "" Then
			strOutErrorDesc = "Unable to retrieve required task icon details from patient TaskCard"
			Exit Function
		End If
		Call WriteToLog("Pass", "Retrieved required task's icon details from patient TaskCard")
						
		'Task icon color details
		strTaskIconRedColorDescription = "padding-bottom-4px"" src=""Resources/Icons/Priority_High_Icon" 'high --> red task icon
		strTaskIconYellowColorDescription = "padding-bottom-4px"" src=""Resources/Icons/Priority_Medium_Icon" 'medium --> yellow task icon
		strTaskIconGreenColorDescription = "padding-bottom-4px"" src=""Resources/Icons/Priority_Low_Icon" 'low --> green task icon
		strTaskIconOrangeColorDescription = "padding-bottom-4px"" src=""Resources/Icons/Overdue_Icon" 'overdue --> orange task icon
			
		'Return color availed			
		If Instr(strTaskNameDetails, strTask) > 0 AND Instr(strTaskColorDetails, strTaskIconRedColorDescription) Then
			ActionItemTaskIconColor = "red"	
			Exit For	
		ElseIf Instr(strTaskNameDetails, strTask) > 0 AND Instr(strTaskColorDetails, strTaskIconYellowColorDescription) Then
			ActionItemTaskIconColor = "yellow"
			Exit For
		ElseIf Instr(strTaskNameDetails, strTask) > 0 AND Instr(strTaskColorDetails, strTaskIconGreenColorDescription) Then
			ActionItemTaskIconColor = "green"
			Exit For
		ElseIf Instr(strTaskNameDetails, strTask) > 0 AND Instr(strTaskColorDetails, strTaskIconOrangeColorDescription) Then
			ActionItemTaskIconColor = "orange"
			Exit For
		End If	
				
		Set oSecificTaskNames = Nothing
		Set objSecificTaskNames = Nothing
		Set oSpecificTaskColor = Nothing
		Set objSpecificTasksColor = Nothing
		
	Next

	'click slider
	Err.Clear
	objSliders(0).Click
'	If Err.Number <> 0 Then
'		strOutErrorDesc = "Unable to click on task slider to close"
'		Exit Function
'	End If
	
	If 	ActionItemTaskIconColor = "" Then
		strOutErrorDesc = "Available icon color for specified task is neither red/yellow/green/orange"
		Err.Clear
		Exit Function
	End If 
	
	Set objActionItems = Nothing
	Set objOpenTaskCard = Nothing
	Set oTaskCardDesc = Nothing
	Set objTaskCards = Nothing
	Set oSliderDesc = Nothing
	Set objSliders = Nothing
	Set oTasksDesc = Nothing
	Set objTasks = Nothing
	Set oSecificTaskNames = Nothing
	Set objSecificTaskNames = Nothing
	Set oSpecificTaskColor = Nothing
	Set objSpecificTasksColor = Nothing

End Function

'================================================================================================================================================================================================
'Function Name       :	ReferralsScreen
'Purpose of Function :	Addition of Field for Outpatient Visit to Referral Screen
'Input Arguments     :	strReferralsProviderDetails: representing  providers details:ProviderName,RefferedTo,City,State,EscoPayor
						'1. Write providers details  delimeted by "," (Eg: "HEALTH Management,Cardiologist,Alpine,California,91901,Yes")  
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.
'						 3. All fields are mandatory 	
						
'					:	strReferralsDetailsInfo: representing Referrals Details Information (strReferralDate,strOutPatientVisit,strAppointmentDate,strSelection)
						'1. Write Referrals Details Information  delimeted by "," (Eg: "10/27/2015,Yes,10/30/2015,vhn")
						'2. If user doesn't want to provide some details, then can leave that place, BUT should provide "," to  keep the place holder.

'Output Arguments    :	Boolean value: representing ReferralsScreen  status
'					 :  strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	'strReferralsScreen = ReferralsScreen(strProviderDetails,strReferralsDetails,strOutErrorDesc)
'Author	      		 :  Amar
'Date				 :	30 October 2015
'================================================================================================================================================================================================

Function ReferralsScreen(ByVal strReferralsProviderDetails,ByVal strReferralsDetailsInfo, strOutErrorDesc)


	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""	
	ReferralsScreen = false
	
	arrProviderDetails = Split(strReferralsProviderDetails,",",-1,1)
	arrReferralsDetailsInfo = Split(strReferralsDetailsInfo,",",-1,1)
		
	'Providers Details
	strProviderName = Trim(arrProviderDetails(0))
	strRefferedTo = Trim(arrProviderDetails(1))
	strCity=Trim(arrProviderDetails(2))
	strState=Trim(arrProviderDetails(3))
	strZip=Trim(arrProviderDetails(4))
	strEscoPayor=Trim(arrProviderDetails(5))
	
	'Referrals details Info
	strReferralDate=Trim(arrReferralsDetailsInfo(0))
	strOutPatientVisit=Trim(arrReferralsDetailsInfo(1))
	strAppointmentDate=Trim(arrReferralsDetailsInfo(2))
	strSelection=Trim(arrReferralsDetailsInfo(3))
		
	Execute "Set objProviderName = "&Environment("WE_ProviderName") 'Provider Name
	Execute "Set objReferredTo = "&Environment("WB_ReferredTo") 'Referred TO
	Execute "Set objCity = "&Environment("WE_City") 'City
	Execute "Set objState = "&Environment("WB_State") 'State
	Execute "Set objZip = "&Environment("WE_Zip") 'Zip
	Execute "Set objSelectVHN = "&Environment("WEL_SelectVHN") 'Select VHN
	Execute "Set objSelectPatient = "&Environment("WEL_SelectPatient") 'Select Patient
	Execute "Set objReferralDate = "&Environment("WE_ReferralDate") 'Referral Date
	Execute "Set objOutPatientVisit = "&Environment("WB_OutPatientVisit") 'OutPatientVisit
	Execute "Set objAppointmentScheduled = "&Environment("WEL_AppointmentScheduled") 'Appointment Scheduled
	Execute "Set objAppointmentDate = "&Environment("WE_AppointmentDate") 'Appointment Date
	Execute "Set objReferralsAdd = "&Environment("WEL_Referrals_Add") 'Add Button
	Execute "Set objReferralsCancel = "&Environment("WEL_Referrals_Cancel") 'Cancel Button
	Execute "Set objIsOutPatientVisit = "&Environment("WEL_Referrals_IsOutPatientVisit") 'IsOutPatientVisit Value
	Execute "Set objPopUpOkBtn = "&Environment("WEB_Referrals_PopUpOkBtn") 'IsOutPatientVisit Value
    'Set value for Provider Name
	Err.Clear
		objProviderName.Set strProviderName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Provider Name field is not set. " & Err.Description
		Exit Function
	End If
	
	Call WriteToLog("Pass", strProviderName & "is set to Provider Name field.")
	
	'Select value from Referred TO dropdown
	blnReturnValue = selectComboBoxItem(objReferredTo, strRefferedTo)
	If not blnReturnValue Then
		strOutErrorDesc = "Equipment Type field is nort selected. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strRefferedTo & " value is selected from RefferedTo dropdown")

	'Set value to City field
	Err.Clear
	objCity.Set strCity
	If Err.Number <> 0 Then
		strOutErrorDesc = "City field is not set ." & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",strCity & "is set to City field")
	
	'Select value from State dropdown
	blnReturnValue = selectComboBoxItem(objState, strState)
	If not blnReturnValue Then
		strOutErrorDesc = "Equipment Type field is nort selected. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strStateValue & " value is selected from State dropdown")

	'Set value to Zip field
	Err.Clear
	objZip.Set strZip
	If Err.Number <> 0 Then
		strOutErrorDesc = "Zip field is not set ."& Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass",strZip & "is set to Zip field")
	
	
	'Select VHN OR Patient
	If lcase(strSelection) = "vhn" Then
		objSelectVHN.Click
		If Err.Number <> 0 Then
		strOutErrorDesc = "VHN Option is not set ."& Err.Description
		Exit Function
		End If
		Call WriteToLog("Pass",strSelection & "is set ")
		
	'Set Referral Date
	If waitUntilExist(objReferralDate, 10) Then
		Err.Clear
		objReferralDate.Set strReferralDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "ReferralDate field is not set. " & Err.Description
			Exit Function
		End If
	Else
		strOutErrorDesc = "ReferralDate field is not present"
		'Exit Function		
	End If
	Call WriteToLog("Pass", "ReferralDate field is set to "&strReferralDate)
	
	
	If lcase(strEscoPayor) = "yes" Then
	'Select value from Outpatient Visit dropdown
	blnReturnValue = selectComboBoxItem(objOutPatientVisit, strOutPatientVisit)
	If not blnReturnValue Then
		strOutErrorDesc = "OutPatient Visit field is not selected. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strOutPatientVisit & " value is selected from OutPatientVisit dropdown")
	End If
	'Select Appointment Scheduled checkbox
	Err.Clear
	objAppointmentScheduled.click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Appointment Scheduled field is not selected" & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Appointment Scheduled field is selected")
	
	'Set Appointment Date
	If waitUntilExist(objAppointmentDate, 10) Then
		Err.Clear
		objAppointmentDate.Set strAppointmentDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "AppointmentDate field is not set. " & Err.Description
			Exit Function
		End If
	Else
		strOutErrorDesc = "AppointmentDate field is not present"
		Exit Function		
	End If
	Call WriteToLog("Pass", "AppointmentDate field is set to "&strAppointmentDate)
	Wait 2
	
	Set Wshell = CreateObject("WScript.Shell")
	Wshell.SendKeys"{TAB}"
	Wait 1
	
	If objReferralsAdd.Object.isDisabled Then
		objAppointmentDate.Clear
		Execute "Set objAppointmentDate = Nothing"
		Execute "Set objAppointmentDate = "&Environment("WE_AppointmentDate") 'Appointment Date		
		objAppointmentDate.Set strAppointmentDate
		Wshell.SendKeys"{TAB}"
		Set Wshell  = Nothing
	End If	
	
	Wait 1
	
	'Verify Add Button exists
	If not waitUntilExist(objReferralsAdd, 20) Then
		strOutErrorDesc = "ReferralsAdd button does not exist"
		Exit Function	
	End If
	If not objReferralsAdd.Object.isDisabled Then
			blnReferrals_Add = ClickButton("Add",objReferralsAdd,strOutErrorDesc)
		If not blnReferrals_Add Then
			strOutErrorDesc = "Unable to click Referrals Add button: "&Err.Description
			Exit Function
		End If
	End If
'	If not objReferralsAdd.Object.isDisabled Then
'		blnReferrals_Add = ClickButton("Add",objReferralsAdd,strOutErrorDesc)
'		If not blnReferrals_Add Then
'			strOutErrorDesc = "Unable to click Referrals Add button: "&Err.Description
'			'Exit Function
'		End If
'		ElseIf waitUntilExist(objIsOutPatientVisit, 20) Then
'			   Call WriteToLog("Pass", "Please Select Outpatient Visit is displayed")
'			   'Select value from Outpatient Visit dropdown
'				blnReturnValue = selectComboBoxItem(objOutPatientVisit, strOutPatientVisit)
'				If not blnReturnValue Then
'					strOutErrorDesc = "OutPatient Visit field is not selected. " & strOutErrorDesc
'					'Exit Function
'				End If
'				Call WriteToLog("Pass", strOutPatientVisit & " value is selected from OutPatientVisit dropdown")
'				blnReferrals_Add = ClickButton("Add",objReferralsAdd,strOutErrorDesc)
'				If not blnReferrals_Add Then
'					strOutErrorDesc = "Unable to click Referrals Add button: "&Err.Description
'					'Exit Function
'				End If
'		End IF 
'	End If
		
	Wait 1
	Call WriteToLog("Pass", "Clicked on Referrals Add btn")
		 
	Call waitTillLoads("Saving Referral...")
	
	strMessageTitle = "Referral Added"
	strMessageBoxText = "Referral has been added:"&strProviderName
	
	'Check the message box having text as "Referral has been added:"
	blnReturnValue=ClickButton("Ok",objPopUpOkBtn,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Referral has been added:' message box is not existing / Not clicked OK on popup "& strOutErrorDesc
		Exit Function
	End If
	Wait 2

	ElseIf lcase(strSelection) = "patient" Then	
		objSelectPatient.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "VHN Option is not set ."& Err.Description
		Exit Function
		End If
		Call WriteToLog("Pass",strSelection & "is set ")
		
	If lcase(strEscoPayor) = "yes" Then			
	'Select value from Outpatient Visit dropdown
	blnReturnValue = selectComboBoxItem(objOutPatientVisit, strOutPatientVisit)
	If not blnReturnValue Then
		strOutErrorDesc = "OutPatient Visit field is not selected. " & strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass", strOutPatientVisit & " value is selected from OutPatientVisit dropdown")
	End If
	
	'Select Appointment Scheduled checkbox
	Err.Clear
	'objAppointmentScheduled.click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Appointment Scheduled field is not selected" & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Appointment Scheduled field is selected")
	
	'Set Appointment Date
	If waitUntilExist(objAppointmentDate, 10) Then
		Err.Clear
		objAppointmentDate.Set strAppointmentDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "AppointmentDate field is not set. " & Err.Description
			Exit Function
		End If
	Else
		strOutErrorDesc = "AppointmentDate field is not present"
		Exit Function		
	End If
	Call WriteToLog("Pass", "AppointmentDate field is set to "&strAppointmentDate)
	Wait 2
	
	Set Wshell = CreateObject("WScript.Shell")
	Wshell.SendKeys"{TAB}"
	Set Wshell  = Nothing
	Wait 1

	'Verify Add Button exists
	If not waitUntilExist(objReferralsAdd, 20) Then
		strOutErrorDesc = "ReferralsAdd button does not exist"
		Exit Function	
	End If
	
	If not objReferralsAdd.Object.isDisabled Then
		blnReferrals_Add = ClickButton("Add",objReferralsAdd,strOutErrorDesc)
	If not blnReferrals_Add Then
		strOutErrorDesc = "Unable to click Referrals Add button: "&Err.Description
		Exit Function
	End If
	End If
		
	Wait 1
	Call WriteToLog("Pass", "Clicked on Referrals Add btn")
	Call waitTillLoads("Saving Referral...")
	

	strMessageTitle = "Referral Added"
	strMessageBoxText = "Referral has been added:"&strProviderName
	
	'Check the message box having text as "Referral has been added:"
	blnReturnValue=ClickButton("Ok",objPopUpOkBtn,strOutErrorDesc)
	If not blnReturnValue Then
		strOutErrorDesc = "'Referral has been added:' message box is not existing / Not clicked OK on popup "& strOutErrorDesc
		'Exit Function
	End If
	Wait 2
	End If
	
	
	Call WriteToLog("Pass", "Completed Adding Referrals successfully")			
	
	ReferralsScreen = true
	
	'Set objects free
	
	Execute "Set objProviderName = "&Environment("WE_ProviderName") 'Provider Name
	Execute "Set objReferredTo = "&Environment("WB_ReferredTo") 'Referred TO
	Execute "Set objCity = "&Environment("WE_City") 'City
	Execute "Set objState = "&Environment("WB_State") 'State
	Execute "Set objZip = "&Environment("WE_Zip") 'Zip
	Execute "Set objSelectVHN = "&Environment("WEL_SelectVHN") 'Select VHN
	Execute "Set objSelectPatient = "&Environment("WEL_SelectPatient") 'Select Patient
	Execute "Set objReferralDate = "&Environment("WE_ReferralDate") 'Referral Date
	Execute "Set objOutPatientVisit = "&Environment("WB_OutPatientVisit") 'OutPatientVisit
	Execute "Set objAppointmentScheduled = "&Environment("WEL_AppointmentScheduled") 'Appointment Scheduled
	Execute "Set objAppointmentDate = "&Environment("WE_AppointmentDate") 'Appointment Date
	Execute "Set objReferralsAdd = "&Environment("WEL_Referrals_Add") 'Add Button
	Execute "Set objReferralsCancel = "&Environment("WEL_Referrals_Cancel") 'Cancel Button
	Execute "Set objIsOutPatientVisit = "&Environment("WEL_Referrals_IsOutPatientVisit") 'IsOutPatientVisit Value
	Execute "Set objPopUpOkBtn = "&Environment("WEB_Referrals_PopUpOkBtn") 'IsOutPatientVisit Value
	
	End Function
	

'================================================================================================================================================================================================
'Function Name       :	ActionItemDateRange
'Purpose of Function :	Get specific task icon color of ActionItem taskcard for required patient
'Input Arguments     :	strRange: String value representing range required
'					 :	dtCustom_From: date value representing 'From' date in MM/DD/YYYY format (required only when daterange selected is 'custom'. other vise write "NA")
'					 :	dtCustom_To: date value representing 'To' date in MM/DD/YYYY format (required only when daterange selected is 'custom'. other vise write "NA")
'Output Arguments    :	Boolean value representing ActionItemDateRange selection status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnActionItemDateRange = ActionItemDateRange("OverDue", "NA", "NA", strOutErrorDesc)
'					 :	blnActionItemDateRange = ActionItemDateRange("Custom", "12/24/2014", "2/21/2015", strOutErrorDesc)
'Author				 :	Gregory
'Date				 :	03 November 2015
'=================================================================================================================================================================================================
Function ActionItemDateRange(ByVal strRange, ByVal dtCustom_From, ByVal dtCustom_To, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ActionItemDateRange = False
	
	Execute "Set objAIpage = " &Environment("WPG_AppParent")
	Execute "Set objActionItemsDateRangeDD = "&Environment("WB_ActionItemsDateRangeDD") 
	Execute "Set objCustomDateRangePP = "&Environment("WEL_CustomDateRangePP") 
	Execute "Set objCustomDateRange_From = "&Environment("WE_CustomDateRange_From") 
	Execute "Set objCustomDateRange_To = "&Environment("WE_CustomDateRange_To") 
	Execute "Set CustomDateRange_OK = "&Environment("WB_CustomDateRange_OK")
	
	'Click on ActionItems date range dropdown
	Err.Clear
	objActionItemsDateRangeDD.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on ActiomItems Date Range dropdown"
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on ActiomItems Date Range dropdown")
	Wait 0,500
	
	'select required date range
	Set oRange = Description.Create
	oRange("micclass").value = "WebElement"
	oRange("innertext").value = ".*"&strRange&".*"
	oRange("innertext").RegularExpression = True
	oRange("outerhtml").value = ".*menuitem.*"
	oRange("outerhtml").RegularExpression = True
	oRange("visible").value = True
	Set objRange = objAIpage.ChildObjects(oRange)
	
	If objRange.Count = 0 Then
		strOutErrorDesc = "Required date range is unavailable"
		Exit Function		
	End If
	Call WriteToLog("Pass", "Required date range is available under ActiomItems Date Range dropdown")
	
	Err.Clear
	objRange(0).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on required date range"
		Exit Function
	End If
	Call WriteToLog("Pass", "Clicked on required date range")
	Wait 0,500
	
	If Trim(LCase(strRange)) = "custom" Then
	
		If LCase(dtCustom_From) = "na" Then
			dtCustom_From = Date
		End If
		If LCase(dtCustom_To) = "na" Then
			dtCustom_To = Date
		End If
		
		'Validate existence on 'CustomDateRange' window
		blnCustomDateRangeExist = waitUntilExist(objCustomDateRangePP, 10)
		If not blnCustomDateRangeExist Then
			strOutErrorDesc = "'CustomDateRange' window doesn't exist"
			Exit Function
		End If
		Call WriteToLog("Pass", "'CustomDateRange' window is available")
		Wait 2
		
		'Set value for 'From' section of 'CustomDateRange' window
		Err.Clear
		objCustomDateRange_From.Set dtCustom_From
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set date in 'From' section of 'CustomDateRange' window"
			Exit Function
		End If
		Call WriteToLog("Pass", "Date is set in 'From' section of 'CustomDateRange' window")		
		Wait 0,500
		
		'Set value for 'To' section of 'CustomDateRange' window
		objCustomDateRange_To.Set dtCustom_To
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to set date in 'To' section of 'CustomDateRange' window"
			Exit Function
		End If
		Call WriteToLog("Pass", "Date is set in 'To' section of 'CustomDateRange' window")		
		Wait 0,500
		
		'clk ok btn
		blnOKclicked = ClickButton("OK",CustomDateRange_OK,strOutErrorDesc)
		If not blnOKclicked Then
			strOutErrorDesc = "Unable OK button of 'CustomDateRange' window"
			Exit Function			
		End If
	
	End If
	
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	ActionItemDateRange = True
	
	Execute "Set objActionItemsDateRangeDD = Nothing"
	Execute "Set objCustomDateRangePP = Nothing"
	Execute "Set objCustomDateRange_From = Nothing"
	Execute "Set objCustomDateRange_To = Nothing"
	Execute "Set CustomDateRange_OK = Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	SelectPatientFromActionItems
'Purpose of Function :	Select required patient from ActionItems
'Input Arguments     :	strAI_PatientName: String value representing patient name (user can enter FullName or FirstName or LastName)
'Output Arguments    :	Boolean value representing status for patient selection from ActionItems
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnSelectPatientFromActionItems = SelectPatientFromActionItems("Mccawl, Helmut", strOutErrorDesc)
'					 :	blnSelectPatientFromActionItems = SelectPatientFromActionItems("Mccawl", strOutErrorDesc)
'					 :	blnSelectPatientFromActionItems = SelectPatientFromActionItems("Helmut", strOutErrorDesc)
'Author      		 :	Gregory
'Date				 :	03 November 2015
'=================================================================================================================================================================================================
Function SelectPatientFromActionItems(ByVal strAI_PatientName, strOutErrorDesc)
		
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	SelectPatientFromActionItems = False
	
	Execute "Set objActionItemsPane = "&Environment("WEL_ActionItems") 'object for ActionItems
	
	'Check ActionItems pane availability
	If not objActionItemsPane.Exist(10) Then
		strOutErrorDesc = "Unable to find ActionItems pane"
		Exit Function
	End If
	Call WriteToLog("Pass", "ActionItems pane is available")
		
	'Object for required patient TaskCard
	Set oAI_Patient = Description.Create
	oAI_Patient("micclass").value = "WebElement"
	oAI_Patient("attribute/data-capella-automation-id").value = "Action_Items_PatientName.*"
	oAI_Patient("attribute/data-capella-automation-id").RegularExpression = True
	oAI_Patient("outertext").value = ".*"&Trim(strAI_PatientName)&".*"
	oAI_Patient("outertext").regularexpression = True
	
'	oAI_Patient("html tag").value = "DIV"
'	oAI_Patient("outerhtml").value = ".*data-capella-automation-id=""Action_Items_PatientName.*"
'	oAI_Patient("outerhtml").RegularExpression = True
'	oAI_Patient("visible").value = True
	Set objAI_Patients = objActionItemsPane.ChildObjects(oAI_Patient)
	objAI_Patients(0).highlight	
	
	If not objAI_Patients(0).Exist(2) Then
		strOutErrorDesc = "Unable to find '"&strAI_PatientName&"' in ActionItems"
		Exit Function
	Else
		Err.Clear
		objAI_Patients(0).Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click '"&strAI_PatientName&"' in ActionItems"
		End If
		Call WriteToLog("Pass", "Selected required patient from ActionItems")
	End If
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 2
	
	SelectPatientFromActionItems = True
	
	Set objActionItemsPane = Nothing
	Set oAI_Patient = Nothing
	Set objAI_Patients = Nothing
	
End Function

'================================================================================================================================================================================================
'Function Name       :	AddAllergy
'Purpose of Function :	Add allergy for a patient
'Input Arguments     :	strAllergy: string value representing Allergy
'Output Arguments    :	Boolean value: representing AddAllergy status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnAddAllergy = AddAllergy(strReqdAllergy, strOutErrorDesc)
'About 				 :  This function is taken from CreateNewPatient script.
'Modified by 		 :	Gregory
'Date				 :	09 November 2015
'=================================================================================================================================================================================================

Function AddAllergy(ByVal strAllergy, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	AddAllergy = false
	
	Execute "Set objPageMed = "&Environment("WPG_AppParent") 'PageObject	
	Execute "Set objMedMagtitle = "&Environment("WEL_MedMagTitle") 'Medications Management screen title
	Execute "Set objAllergyAddBtn = " & Environment("WB_AddAllerg")
	Execute "Set objAlrgyNamTxtBx = " & Environment("WEL_AlrgyNamTxtBx")
	Execute "Set objAlrgyNamEdBx = " & Environment("WE_AlrgyNamEdBx")
	Execute "Set objAlgrySavebtn = " & Environment("WI_AlgrySavebtn")
	
	'Close all available popups 
	'Close 'Some Date May Be Out of Date' msgbox
	Execute "Set objSDMBOFDpptleOK = "&Environment("WB_SDMBOFDpptleOK")	
	If objSDMBOFDpptleOK.Exist(3) Then
		Err.Clear
		objSDMBOFDpptleOK.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'Some Data May Be Out of Date' message box OK button." &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked 'Some Data May Be Out of Date' message box OK button")			
	End If
	Execute "Set objSDMBOFDpptleOK = Nothing"
	
	Wait 1
	Call waitTillLoads("Loading...")

	'Close 'Disclaimer' msgbox
	Execute "Set objDisclaimerOK = "&Environment("WB_DisclaimerOK")	
	If objDisclaimerOK.Exist(3) Then
		Err.Clear
		objDisclaimerOK.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click 'Disclaimer' message box OK button." &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass", "Clicked 'Disclaimer' message box OK button")			
	End If
	Execute "Set objDisclaimerOK = Nothing"
	
	Wait 1
	Call waitTillLoads("Loading...")
	
	'Check whether user landed on Medications Management screen
	If not objMedMagtitle.Exist(5) Then
		strOutErrorDesc = "Medications Management Screen is not available"
		Exit Function
	End If
	Call WriteToLog("Pass","Medications screen is available")
	
	'Clk Medications Add button for Allergy
	Err.Clear
	blnClickAdd = ClickButton("Add",objAllergyAddBtn,strOutErrorDesc)
	If not blnClickAdd Then
		strOutErrorDesc = "Unable to click Add button for adding new allergy"
		Exit Function
	End If
	wait 2
	Call waitTillLoads("Loading...")
	Wait 1	
	
	'Click allergy text box and enter value
	objAlrgyNamTxtBx.highlight
	Err.Clear
	objAlrgyNamTxtBx.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Allergy Name TxtBx"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Allergy Name TxtBx")	
		
	For i = 1 To len(strAllergy)
		ch = Mid(strAllergy, i, 1)
		sendKeys ch
		Err.Clear
		Set objList = objPageMed.WebElement("class:=k-list-container k-popup k-group k-reset k-state-border-up", "html id:=allergyName-list")
		isFound = false
		If Not objList.Exist(3) Then
		Else
			objList.highlight
		
			Set itemDesc = Description.Create
			itemDesc("micclass").Value = "WebElement"
			itemDesc("class").Value = "k-item.*"
			
			Set objItem = objList.ChildObjects(itemDesc)
			For j = 0 To objItem.Count - 1
				Print objItem(j).getROProperty("outertext")
				item = objItem(j).getROProperty("outertext")
				
				If item = strAllergy Then
					objItem(j).click
					isFound = true
					Exit For
				End If
			Next
		End If
		If isFound Then
			Exit For
		End If
		Set objList = Nothing
	Next
	wait 1
	
	'Save allergy
	blnClickSave = ClickButton("Save",objAlgrySavebtn,strOutErrorDesc)
	If not blnClickSave Then
		strOutErrorDesc = "Unable to click Save button for allergy "&Err.Description
		Exit Function
	End If 
	wait 1
	WaitTillLoads "Loading..."
	wait 1
	
	blnSavePP = checkForPopup("Save Allergy ?", "Yes", "Do you want to save allergy choosen ?", strOutErrorDesc)
	If not blnSavePP Then
		strOutErrorDesc = "Failed to save the allergy"
		Exit Function
	End If	
	wait 2
	WaitTillLoads "Loading..."
	wait 1
	
	blnSavePPok = checkForPopup("Changes Saved", "Ok", "Changes saved successfully.", strOutErrorDesc)
	If not blnSavePPok Then
		strOutErrorDesc = "Failed to save the allergy"
		Exit Function
	End If	
	Call WriteToLog("Pass", "Allergy saved successfully.")
	
	AddAllergy = True
	
	Execute "Set objPageMed = Nothing"
	Execute "Set objMedMagtitle = Nothing"
	Execute "Set objAllergyAddBtn = Nothing"
	Execute "Set objAlrgyNamTxtBx = Nothing"
	Execute "Set objAlrgyNamEdBx = Nothing"
	Execute "Set objAlgrySavebtn = Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	AccessInformationAdd
'Purpose of Function :	Add AccInformation for a patient
'Input Arguments     :	strAccessType: string value representing AccessType
'	 				 :	dtPlacedDate: date value representing PlacedDate
'	 				 :	strAccessStatus: string value representing AccessStatus
'	 				 :	dtDateActivated: date value representing DateActivated
'	 				 :	strTerminateReason: string value representing TerminateReason
'	 				 :	strSide: string value representing Side
'	 				 :	strRegion: string value representing Region
'Output Arguments    :	Boolean value: representing AccessInformationAdd status
'					 :	strOutErrorDesc: String value which contains detail error message if error occured
'Example of Call     :	blnAccessInformationAdd = AccessInformationAdd(strAccessType,dtPlacedDate,strAccessStatus,dtDateActivated,strTerminateReason,strSide,strRegion,strExtremity,strOutErrorDesc)
'About 				 :  This function is a modification of AccessAdd()
'Modified by 		 :	Gregory
'Date				 :	09 November 2015
'=================================================================================================================================================================================================
Function AccessInformationAdd(ByVal strAccessType,ByVal dtPlacedDate,ByVal strAccessStatus,ByVal dtDateActivated,ByVal strTerminateReason,ByVal strSide,ByVal strRegion,ByVal strExtremity,strOutErrorDesc)
	
		strOutErrorDesc = ""
		Err.Clear
	    On Error Resume Next
		AccessInformationAdd = False
		
		'Object Intialization
		Execute "Set objAccessMgmtHeader = " &Environment("WEL_AccessMgmtHeader") 'Access Management Header
		Execute "Set objAddButton = "  &Environment("WEL_AccessManagement_AddButton")	 'Add button
		Execute "Set objPlacedDate = "  &Environment("WE_AccessManagement_PlacedDate") 'Access information > Placed Date
		Execute "Set objSaveButton = "  &Environment("WEL_AccessManagement_SaveButton")	 'Add button
		Execute "Set objAccessType = "  &Environment("WEL_AccessManagement_AccessInformation_AccessType")	 'Access Type Dropdown
		Execute "Set objAccessStatus = "  &Environment("WEL_AccessManagement_AccessInformation_AccessStatus") 'Access Status
		Execute "Set objAccessSide = "  &Environment("WEL_AccessManagement_AccessInformation_Side") 'Access Side
		Execute "Set objAccessRegion= "  &Environment("WEL_AccessManagement_AccessInformation_Region") 'Access Extremity
		Execute "Set objAccessExtremity = "  &Environment("WEL_AccessManagement_AccessInformation_Extremity") 'Access Extremity
		Execute "Set objDateActivated = "  &Environment("WE_AccessManagement_ActivatedDate") 'Est. Date Activated
		Execute "Set objInActiveReason = "  &Environment("WEL_AccessManagement_AccessInformation_InActiveReason") 'InActive Reason dropdown
		Execute "Set objDateInActivated = "  &Environment("WE_AccessManagement_InActiveDate") 'Est. Date InActivated
		
		If dtPlacedDate = "" OR lcase(dtPlacedDate) = "na" Then
			dtPlacedDate = Date-1
		End If
		If dtDateActivated = "" OR lcase(dtDateActivated) = "na" Then
			dtDateActivated = Date-1
		End If
		
		If not objAccessMgmtHeader.Exist(10) Then
			strOutErrorDesc = "Access Management screen is not available"
			Exit Function
		End If
		Call WriteToLog("Pass", "Access Management screen is available")
		
		'Click on Add button
		blnAddClk = ClickButton("Add",objAddButton,strOutErrorDesc)
		If not blnAddClk Then
			strOutErrorDesc = "Access Add button not clicked "&strOutErrorDesc
			Exit Function
		End If
		Wait 2
		waitTillLoads "Loading..."
		wait 1

		'Select Access type value
		blnAccessType = selectComboBoxItem(objAccessType,strAccessType)
		If not blnAccessType Then
			strOutErrorDesc = "Unable to select Access Type. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass",strAccessType& " is selected as Access type")

		'Set Placed date
		Err.Clear
		objPlacedDate.Set dtPlacedDate
		If Err.Number<>0 Then
			strOutErrorDesc = "Place Date is not set. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass", "Place Date is set")

		'Select Access Status Value
		blnAccessStatus = selectComboBoxItem(objAccessStatus,strAccessStatus)
		If not blnAccessStatus Then
			strOutErrorDesc = "Access Status is not selected. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass",StrStatus&" is selected from Access status dropdown")
		
		Select Case Trim(lcase(strAccessStatus))
			Case "active"
				'Set Activated Date
				Err.Clear
				objDateActivated.Set dtDateActivated
				If Err.Number<>0 Then
					strOutErrorDesc = "Date Activated is not set. "&strOutErrorDesc
					Exit Function
				End If
				Call WriteToLog("Pass", "Date Activated is set")	
				
			Case "inactive"
				'Set Inactivated Date
				Err.Clear
				objDateInActivated.Set Date
				If Err.Number<>0 Then
					strOutErrorDesc = "Date InActivated is not set. "&Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass", "Date InActivated value is set")

				'Select Terminate reason value
				blnInActiveReason = selectComboBoxItem(objInActiveReason,strTerminateReason)
				If not blnInActiveReason Then
					strOutErrorDesc = "Inactivated Reason value is not selected. "&strOutErrorDesc
					Exit Function
				End If
				Call WriteToLog("Pass","Inactivated reason is selected")
				
		End Select
		
		'Select side value
		blnAccessSide = selectComboBoxItem(objAccessSide,strSide)
		If not blnAccessSide Then
			strOutErrorDesc = "Access Side value is not selected. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass",strSideValue&" is selected from Side dropdown")
		
		'Select Region value
		blnAccessRegion = selectComboBoxItem(objAccessRegion,strRegion)
		If not blnAccessRegion Then
			strOutErrorDesc = "Access Region value is not selected. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass",strRegionValue& " is selected from Region dropdown")

		'Select Extremity value
		blnAccessExtremity = selectComboBoxItem(objAccessExtremity,strExtremity)
		If not blnAccessExtremity Then
			strOutErrorDesc = "Access Extremity value is not selected. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass",strExtremityValue & "is selected from Extremity dropdown")
				
		'Click on Save button
		blnSaveButton = ClickButton("Save",objSaveButton,strOutErrorDesc)
		If not blnSaveButton Then
			strOutErrorDesc = "Save Button is not clicked. "&strOutErrorDesc
			Exit Function
		End If
		Wait 2
		waitTillLoads "Loading..."
		wait 1
			
		blnSavedPPok = checkForPopup("Changes Saved", "Ok", "Changes saved successfully", strOutErrorDesc)	
		If not blnSavedPPok Then
			strOutErrorDesc = "Saved confirmation popup returned error. "&strOutErrorDesc
			Exit Function
		End If
		Wait 1		
		
		AccessInformationAdd = true
		
		Execute "Set objAddButton = Nothing" 
		Execute "Set objPlacedDate = Nothing"  
		Execute "Set objSaveButton = Nothing"  
		Execute "Set objAccessType = Nothing"  
		Execute "Set objAccessStatus = Nothing"  
		Execute "Set objAccessSide = Nothing"  
		Execute "Set objAccessRegion= Nothing"  
		Execute "Set objAccessExtremity = Nothing"  
		Execute "Set objInActiveReason = Nothing"  
		Execute "Set objDateInActivated = Nothing"
		
End Function

'=====================================================================================================================================================================
'Function Name       :	PatientEligibilityStatus
'Purpose of Function :	To find the Eligibility Status of a patient
'Input Arguments     :	LongInteger value: MemberID of the patient
'					 :	strSearchRequired: string value 'yes' or 'no' specifying whether the patient is to be opened by searching through Global search using MemberId
'Output Arguments    :	String value: Indicating Eligibility Status of patient
'					 :  strOutErrorDesc:String value which contains error message occurred (if any) during function execution
'Example of Call     :	strPatientEligibilityStatus = PatientEligibilityStatus("177889","yes", strOutErrorDesc)
'					 :  strPatientEligibilityStatus = PatientEligibilityStatus("","no", strOutErrorDesc)
'Author	      		 :	Gregory
'Date				 :	11 November 2015
'=====================================================================================================================================================================
Function PatientEligibilityStatus(ByVal strPatientMemID, ByVal strSearchRequired, strOutErrorDesc)

	On Error Resume Next
	strOutErrorDesc = ""
	PatientEligibilityStatus = ""
	Err.Clear
	
	Execute "Set objPatientProfilePaneExpand = " &Environment("WI_PatientProfilePaneExpand")
	Execute "Set objPatientProfilePageExpand = " &Environment("WI_PatientProfilePageExpand")
	Execute "Set objPatientStatus = " &Environment("WEL_PatientStatus")	

	If Trim(lcase(strSearchRequired)) = "yes" Then
		blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(strPatientMemID, strOutErrorDesc)
		If not blnGlobalSearchUsingMemID Then
			strOutErrorDesc = "Unable to search patient. "&strOutErrorDesc
			Exit Function
		End If
		Call WriteToLog("Pass","Opened required patient profile (MemberId:"&strPatientMemID&")")
	End If
	
	Call clickOnSubMenu("Member Info->Patient Info")
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	
	If objPatientStatus.Exist(10) Then
		Call WriteToLog("Pass","Patient eligibility status field is available")
		strPatientStatus = Trim(objPatientStatus.GetROProperty("outertext"))
		If strPatientStatus = "" Then
			strOutErrorDesc = "Unable to retrieve patient eligibility status"
			Exit Function
		End If
		Call WriteToLog("Pass","Patient eligibility is retrieved")
		PatientEligibilityStatus = strPatientStatus
	Else
		strOutErrorDesc = "Patient eligibility status field is not available"
		Exit Function
	End If
	
	Execute "Set objPatientProfilePaneExpand = Nothing"
	Execute "Set objPatientProfilePageExpand = Nothing"
	Execute "Set objPatientStatus = Nothing"
	
End Function

'==========================================================================================================================================================================================
'Function Name       :	AddContactMethod
'Purpose of Function :	To add contact method with reduired details
'Input Arguments     :	strContactMethod: string value representing contact method
'					 :	dtContactDate: date value representing contact date
'					 :	strScores: string value representing engagement start and end dates delimited by ","
'					 :	strTeams: string value representing external and internal teams delimited by ","
'					 :	strResolution: string value representing contact resolution
'Output Arguments    :	Boolean value: Indicating add contact method status
'					 :  strOutErrorDesc:String value which contains error message occurred (if any) during function execution
'Example of Call     :	blnAddContactMethod = AddContactMethod("Phone", "11/12/2015", "3-Extremely Engaged,3-Extremely Engaged", "Patient,Registered Nurse", "Completed", strOutErrorDesc)
'Author	      		 :	Gregory
'Date				 :	20 November 2015
'==========================================================================================================================================================================================
Function AddContactMethod(ByVal strContactMethod,ByVal dtContactDate,ByVal strScores,ByVal strTeams,ByVal strResolution, strOutErrorDesc)
	
	On Error Resume Next
	AddContactMethod = False
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
	Execute "Set objResolutionDD = " &Environment("WEL_ACMResolutionDD") 'Resolution
	Execute "Set objCM_OK= " &Environment("WI_ACM_OK") 'OKimage
	
	Set objPageCCM = getPageObject()
	Set objExtTeamlist = objPageCCM.WebElement("class:=dropdown-menu defaultdropdownul custom-dropdown-bootstrap add-width","html tag:=UL","outertext:= Select a value  Caregiver or Family.*","visible:=True")
	Set objIntTeamlist = objPageCCM.WebElement("class:=dropdown-menu defaultdropdownul custom-dropdown-bootstrap add-width","html tag:=UL","outertext:= Select a value  Assessment Nurse  Assistant.*","visible:=True")
	Set objResolutionlist = objPageCCM.WebElement("class:=dropdown-menu defaultdropdownul custom-dropdown-bootstrap add-width","html tag:=UL","outertext:= Select a value  Attempted or Incomplete.*","visible:=True")
	
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
	Call WriteToLog("Pass","Clicked on contact browsing icon")
	
	'Sync till Recap screen is visible
    blnReturnValue = objRecapTitle.WaitProperty("visible", True, 30000)    'Wait upto 30 secs for Recap screen to be visible
    If not blnReturnValue Then
        strOutErrorDesc = "Recap screen is not visible"
		Exit Function
    End If
    Call WriteToLog("Pass","Recap screen is available")
    
	'Click on AddNewContact method icon
	Err.Clear
	objAddButton.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click Add new contact Icon : "&" Error returned: " & Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked on Add button for new contact")
		
	'Sync till ChooseContactMethod popup is visible
    blnReturnValue = objNewContactIcon.WaitProperty("visible", True, 30000)    'Wait upto 30 secs for ChooseContactMethod popup to be visible
    If not blnReturnValue Then
        strOutErrorDesc = "ChooseContactMethod popup is not visible"
		Exit Function
    End If
    Call WriteToLog("Pass","ChooseContactMethod popup is available")
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
	Call WriteToLog("Pass","Selected contact method")
		
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
    Call WriteToLog("Pass","Contact date is set")
	Wait 1		
	
	'select start score
	objEngStartScoreDD.highlight
	blnEngStartScore = selectComboBoxItem(objEngStartScoreDD, strEngStartScore)
	If Not blnEngStartScore Then
		strOutErrorDesc = "Unable to select Engagement Start Score "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Selected Engagement Start Score")
	Wait 1	
	
	'select end score
	objEngEndScoreDD.highlight
	blnEngEndScore = selectComboBoxItem(objEngEndScoreDD, strEngEndScore)
	If Not blnEngEndScore Then
		strOutErrorDesc = "Unable to select Engagement End Score "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Selected Engagement End Score")
	Wait 1		
		
	'select external team
	blnSelectRequiredItemFromLongDD = SelectRequiredItemFromLongDD(objExternalTeamDD, objExtTeamlist, strExternalTeam)	
	If not blnSelectRequiredItemFromLongDD Then
		Exit Function
	End If
	Wait 1
	
	'select internal team
	blnSelectRequiredItemFromLongDD = SelectRequiredItemFromLongDD(objInternalTeamDD, objIntTeamlist, strInternalTeam)
	If not blnSelectRequiredItemFromLongDD Then
		Exit Function
	End If
	Wait 1

	'select resolution
	blnSelectRequiredItemFromLongDD = SelectRequiredItemFromLongDD(objResolutionDD, objResolutionlist, strResolution)
	If not blnSelectRequiredItemFromLongDD Then
		Exit Function
	End If
	Wait 1
	
	'Clk on OK of ContactMethod popup
	Err.Clear
	objCM_OK.Click
	If err.number <> 0 Then
		strOutErrorDesc = "Unable to click OK button : "&" Error returned: " & Err.Description
		Exit Function
    End If
	Call WriteToLog("Pass","Clicked OK button")
	Wait 2
    
    Call waitTillLoads("Loading...")
    Wait 2
    
	AddContactMethod = True
	
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
	Set objPageCCM = Nothing
	Set objExtTeamlist = Nothing
	Set objIntTeamlist = Nothing
	Set objResolutionlist = Nothing

End Function

'==========================================================================================================================================================================================
'Function Name       :	SelectRequiredItemFromLongDD
'Purpose of Function :	To select required item from a long dropdown
'Input Arguments     :	objDD: object representing dropdown from which value to be selected
'					 :	objDDlist: dropdown list object corresponding to objDD
'					 :	strItemToSelect: string value representing item to be selected form dropdown
'Output Arguments    :	Boolean value: Indicating item selection
'Example of Call     :	blnSelectRequiredItemFromLongDD = SelectRequiredItemFromLongDD(objExternalTeamDD, objExtTeamlist, strExternalTeam)
'Author	      		 :	Gregory
'Date				 :	20 November 2015
'==========================================================================================================================================================================================

Function SelectRequiredItemFromLongDD(ByVal objDD, ByVal objDDlist, ByVal strItemToSelect)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	SelectRequiredItemFromLongDD = False
	
	Err.Clear
	objDD.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click required dropdown"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked required dropdown")
	Wait 1
	
	Set oDescExt = Description.Create
	oDescExt("micclass").value = "Link"
	Set objDropDownListItems = objDDlist.ChildObjects(oDescExt)
	intDropDownListItemCount = objDropDownListItems.count
	For intDDitem = 0 To intDropDownListItemCount-1 Step 1 
		Set objRequiredDropDownItem = objDropDownListItems(intDDitem)
		sendKeys("{DOWN}")
		If Instr(1,objRequiredDropDownItem.GetROProperty("outertext"),strItemToSelect,1) > 0 Then
			Err.Clear
			objRequiredDropDownItem.click
			If err.number <> 0 Then
				strOutErrorDesc = "Unable to select '"&strItemToSelect&"' from dropdown. "&Err.Description
				Exit Function
		    End If
		    Call WriteToLog("Pass","Selected '"&strItemToSelect&"' from dropdown")
			Exit For
		End if
		Wait 0,50
	Next
	
	SelectRequiredItemFromLongDD = True
	
	Set objDD = Nothing
	Set objDDlist = Nothing
	Set oDescExt = Nothing
	Set objRequiredDropDownItem = Nothing	
	
End Function

'#######################################################################################################################################################################################################
'Function Name		 : DeleteNewlyUploadedDocuments
'Purpose of Function : Purpose of this function is to delete the newly uploaded document from manage document screen
'Input Arguments	 : None 
'Output Arguments	 : boolean: True or False
'					 : strOutErrorDesc -> String value which contains detail error message occurred (if any) during function execution
'Example of Call	 : blnReturnValue = DeleteNewlyUploadedDocuments(strOutErrorDesc)
'Author				 : Amar
'Date				 : 12-Nov-2015
'#######################################################################################################################################################################################################

Function DeleteNewlyUploadedDocuments(strOutErrorDesc)

	strOutErrorDesc = ""
	Err.Clear
    On Error Resume Next
	DeleteNewlyUploadedDocuments = False
	
	strFileDeletedPopupTitle = DataTable.Value("FileDeletedPopupTitle","CurrentTestCaseData") 'File deleted popup title text
	strFileDeletedPopupText  = DataTable.Value("FileDeletedPopupText","CurrentTestCaseData")  'File deleted popup text message  
	strFileDeletedSuccessPopupText = DataTable.Value("FileDeletedSuccessText","CurrentTestCaseData")
	
	Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")' Data grid of manage document screen
	Execute "Set objDeleteButton = "  &Environment("WB_ManageDocument_DeleteButton")		 ' Delete button
	'Execute "Set objFileDeletedPopupTitle = "  &Environment("WEL_PopUp_Title")				 ' File deleted popup header
	'Execute "Set objFileDeletedPopupText  = "  &Environment("WEL_PopUp_Text")				 ' File deleted popup text message
	'Execute "Set objYesButton = "  &Environment.Value("DictObject").Item("WB_YES")								     ' Yes button
	'Execute "Set objOKButton = "  &Environment.Value("DictObject").Item("WB_OK")	
	
	If not waitUntilExist(objManageDocumentDataGrid,10) Then
		Call WriteToLog("Fail","Manage Document Data Grid does not exist")
		Call WriteLogFooter()
		Exit Function
	End If
	
	Call WriteToLog("Info","Manage Document Data Grid does exists")

	'Get the rows in Grid
	intRows = objManageDocumentDataGrid.GetROProperty("rows")
	If intRows = 0 Then
		Call WriteToLog("Pass","No document exist in manage documents grid")
		DeleteNewlyUploadedDocuments = True
		Exit Function
	End If
	
		objManageDocumentDataGrid.ChildItem(1,1,"WebElement",0).Click

		If Err.Number<>0 Then
			strOutErrorDesc = "Check box was not clicked in Manage document grid"
			Exit Function
		End If
		Set objManageDocumentDataGrid = Nothing
		Execute "Set objManageDocumentDataGrid  = "  &Environment("WT_ManageDocument_DataGrid")' Data grid of manage document screen
		
	'Click on Delete button
	blnReturnValue = ClickButton("Delete button",objDeleteButton,strOutErrorDesc)
	If Not blnReturnValue Then
		strOutErrorDesc = "ClickButton returned error: "&strOutErrorDesc
		Exit Function
	End If
	
	Call waitTillLoads("Saving...")
	
	'Verify that message box exist stating that "Are you sure you want to remove the selected file\(s\)\?"
	blnReturnValue =  checkForPopup(strFileDeletedPopupTitle,"Yes",strFileDeletedPopupText, strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedPopupText&" was displayed")
	Else
		strOutErrorDesc = "Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedPopupTitle&" was not displayed. Error returned: "&strOutErrorDesc
		Exit Function
	End If
	
	Call waitTillLoads("Saving...")
	
	blnReturnValue = checkForPopup(strFileDeletedPopupTitle,"Ok",strFileDeletedSuccessPopupText,strOutErrorDesc)
	If blnReturnValue Then
		Call WriteToLog("Pass","Popup with title: "&strFileDeletedPopupTitle& " with message: "&strFileDeletedSuccessPopupText&" was displayedl")
	Else
		strOutErrorDesc = "Popup with title: "&strFileDeletedPopupTitle& " and stating message: "&strFileDeletedSuccessPopupText&" was not displayed. Error returned: "&strOutErrorDesc
		Exit Function
	End If
		
	Wait 2
	
	DeleteNewlyUploadedDocuments = True
	
End Function


'================================================================================================================================================================================================
'Function Name       :	EditInterventionStatusInRVR
'Purpose of Function :	To edit intervention for medication
'Input Arguments     :	strStatusRequired: string value representing status required after editing an intervention
'					 :	strCurrentVisibleStatus: string value representing current intervention status
'					 :	strReviewerCoding: string value representing reviewer coding value
'					 :	dtReviewerCodingDate: date value representing reviewer coding date
'Output Arguments    :	Boolean value: representing status of intervention edit
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	EditInterventionStatusInRVR(strPHMInterventionEditStatus, strCurrentVisibleStatusinPHM, strReviewerCoding, dtReviewerCodingDate, strOutErrorDesc)"
'Author				 :  Amar
'Date				 :	24-Nov-2015
'================================================================================================================================================================================================

Function EditInterventionStatusInRVR(ByVal strStatusRequired, ByVal strCurrentVisibleStatus, ByVal strReviewerCoding, ByVal dtReviewerCodingDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc =""
	EditInterventionStatusInRVR = False
	
	Execute "Set objPageEditInter = " & Environment("WPG_AppParent")
	Execute "Set objInterventionEdit = " & Environment("WB_InterventionEdit")
'	Execute "Set objPHMinterventionStatus = " & Environment("WB_PHMinterventionStatus")
	Execute "Set objInterventionSaveEdit = " & Environment("WB_InterventionSaveEdit")
	Execute "Set objReviewerCoding = "&Environment("WB_ReviewerCoding")
	Execute "Set objReviewerCodingDate = "&Environment("WE_ReviewerCodingDate")
	
	blnInterventionEdit = ClickButton("Edit",objInterventionEdit,strOutErrorDesc)
	If not blnInterventionEdit Then
		strOutErrorDesc = "Pharmacist Intevention Edit button not clicked. " & strOutErrorDesc
		Exit Function
	End If
	Wait 2

	strVstatus = ".*"&strCurrentVisibleStatus&".*"	
	Set objInterventionStatus = objPageEditInter.WebButton("html id:=sideDropDown","html tag:=BUTTON","name:="&strVstatus,"outertext:="&strVstatus,"visible:=True")
	objInterventionStatus.highlight

	blnInterventionStatus = selectComboBoxItem(objInterventionStatus,strStatusRequired)
	If not blnInterventionStatus Then
		strOutErrorDesc = "Unable to select PHM intervention Status value. " & strOutErrorDesc
		Exit Function
	End If
	
	If Ucase(Trim(strStatusRequired)) = "FINAL REVIEW COMPLETED" Then

		blnReviewerCoding = SelectComboBoxItemSpecific(objReviewerCoding,strReviewerCoding)
		If not blnReviewerCoding Then
			strOutErrorDesc = "Unable to select PHM intervention Status value. " & strOutErrorDesc
			Exit Function
		End If
		
		Err.Clear
		objReviewerCodingDate.Set dtReviewerCodingDate
		If Err.Number <> 0 Then
			strOutErrorDesc = "Reviewer Coding Date is not set. " & Err.Description
			Exit Function
		End If
	End If
	
	blnInterventionSaveEdit = ClickButton("Save",objInterventionSaveEdit,strOutErrorDesc)
	If not blnInterventionSaveEdit Then
		strOutErrorDesc = "Pharmacist Intevention status save button (after editing intervention) is not clicked. " & strOutErrorDesc
		Exit Function
	End If
	
	Call waitTillLoads("Saving Intervention...")
	Wait 2

	EditInterventionStatusInRVR = True
	
	Execute "Set objPageEditInter = Nothing"
	Execute "Set objInterventionEdit = Nothing"
	Execute "Set objInterventionSaveEdit = Nothing"
	Execute "Set objReviewerCoding = Nothing"
	Execute "Set objReviewerCodingDate = Nothing"
	
End Function

'================================================================================================================================================================================================
'Function Name       :	SelectDateFromCalendarWidget
'Purpose of Function :	Select required date from the calendar widget
'Input Arguments     :	objCalenderWidget: object for the required calendar widget
'					 :	dtRequiredDate: date value to be selected from calender widget
'Output Arguments    :	Boolean value: representing status of selection of date from calendar widget
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	SelectDateFromCalendarWidget(objAdmitCalendarBtn, "12/2/2015" strOutErrorDesc)"
'Author				 :  Gregory
'Date				 :	December9, 2015
'================================================================================================================================================================================================
Function SelectDateFromCalendarWidget(ByVal objCalenderWidget, ByVal strClearCalendar, ByVal dtRequiredDate, strOutErrorDesc)
 
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	SelectDateFromCalendarWidget = False

	objCalenderWidget.highlight
	 
	Err.Clear
	objCalenderWidget.Click
	If Err.Number <> 0 Then
	strOutErrorDesc = "Unable to click Calendar widget. "&Err.Description
	Exit Function
	End If
	Call WriteToLog("Pass","Clicked Calendar widget")
	Wait 0,500
	 
	If lcase(trim(strClearCalendar)) = "yes" Then
	 
	Execute "Set objCalendarClearBtn = " & Environment("WB_CalendarClearBtn")
	blnCalendarCleared = ClickButton("Clear",objCalendarClearBtn,strOutErrorDesc)
	If not blnCalendarCleared Then
	strOutErrorDesc = "Unable to click on Clear button on Calendar widget"
	Exit Function
	End If
	Execute "Set objCalendarClearBtn = Nothing"
	 
	ElseIf CDate(dtRequiredDate) = Date Then
	 
	Execute "Set objCalendarToday_H = " & Environment("WB_CalendarToday_H")
	Err.Clear
	objCalendarToday_H.Click
	If Err.Clear Then
	strOutErrorDesc = "Unable to click on Today button on Calendar widget"
	Exit Function
	End If
	Execute "Set objCalendarToday_H = Nothing"
	 
	Else
	 
	Execute "Set objCalendarHeader = " & Environment("WB_CalendarHeader") 'Calendar header
	 
	dtCalendarHeader = Trim(objCalendarHeader.GetROProperty("outertext"))
	arrCalendarHeader = Split(dtCalendarHeader," ",-1,1)
	intHeaderMonth =  getNumericValueOfMonth (arrCalendarHeader(0))
	intHeaderYear = arrCalendarHeader(1)
	dtHeaderDate = CDate(intHeaderMonth&"/1/"&intHeaderYear)
	 
	intRequiredMonth = Split(dtRequiredDate,"/",-1,1)(0)
	intRequiredYear = Split(dtRequiredDate,"/",-1,1)(2)
	dtRequiredDateDummy = CDate(intRequiredMonth&"/1/"&intRequiredYear)
	 
	If DateDiff("d",dtHeaderDate,dtRequiredDateDummy) < 0 Then
	 
	For c = 0 To 60 Step 1
	 
	Execute "Set objCalendarLeftArrow = " & Environment("WB_CalendarLeftArrow") 'Calendar left arrow
	 
	Err.Clear
	Setting.WebPackage("ReplayType") = 2
	objCalendarLeftArrow.FireEvent "onClick"
	Setting.WebPackage("ReplayType") = 1
	 
	If Err.Number <> 0 Then
	strOutErrorDesc = "Unable to click Calendar widget right arrow button. "&Err.Description
	Exit Function
	End If
	 
	Execute "Set objCalendarHeader = Nothing"
	Execute "Set objCalendarHeader = " & Environment("WB_CalendarHeader") 'Calendar header
	 
	dtCalendarHeader = Trim(objCalendarHeader.GetROProperty("outertext"))
	arrCalendarHeader = Split(dtCalendarHeader," ",-1,1)
	intHeaderMonth =  getNumericValueOfMonth(arrCalendarHeader(0))
	arrCalendarHeader = Split(dtCalendarHeader," ",-1,1)
	intHeaderMonth =  getNumericValueOfMonth (arrCalendarHeader(0))
	intHeaderYear = arrCalendarHeader(1)
	dtHeaderDate = CDate(intHeaderMonth&"/1/"&intHeaderYear)
	 
	If DateDiff("d",dtHeaderDate,dtRequiredDateDummy) = 0 Then
	Call WriteToLog("Pass","Clicked Calendar widget left arrow button")
	Exit For
	End If
	 
	Next
	 
	ElseIf DateDiff("d",dtHeaderDate,dtRequiredDateDummy) > 0 Then
	 
	For c = 0 To 60 Step 1
	 
	Execute "Set objCalendarRightArrow = " & Environment("WB_CalendarRightArrow") 'Calendar Right arrow
	 
	Err.Clear
	Setting.WebPackage("ReplayType") = 2
	objCalendarRightArrow.FireEvent "onClick"
	Setting.WebPackage("ReplayType") = 1
	 
	If Err.Number <> 0 Then
	strOutErrorDesc = "Unable to click Calendar widget right arrow button. "&Err.Description
	Exit Function
	End If
	 
	Execute "Set objCalendarHeader = Nothing"
	Execute "Set objCalendarHeader = " & Environment("WB_CalendarHeader") 'Calendar header
	 
	dtCalendarHeader = Trim(objCalendarHeader.GetROProperty("outertext"))
	arrCalendarHeader = Split(dtCalendarHeader," ",-1,1)
	intHeaderMonth =  getNumericValueOfMonth(arrCalendarHeader(0))
	arrCalendarHeader = Split(dtCalendarHeader," ",-1,1)
	intHeaderMonth =  getNumericValueOfMonth (arrCalendarHeader(0))
	intHeaderYear = arrCalendarHeader(1)
	dtHeaderDate = CDate(intHeaderMonth&"/1/"&intHeaderYear)
	 
	If DateDiff("d",dtHeaderDate,dtRequiredDateDummy) = 0 Then
	Call WriteToLog("Pass","Clicked Calendar widget right arrow button")
	Exit For
	End If
	 
	Next
	 
	End If
	 
	intRequiredDay = Split(dtRequiredDate,"/",-1,1)(1)
	 
	If Len(intRequiredDay) = 1 Then
	intRequiredDay = 0&intRequiredDay
	End If

	Execute "Set objPage_Calendar = Nothing"
	Execute "Set objPage_Calendar = " & Environment("WPG_AppParent") 'Page object
	Set objCalendarDay = objPage_Calendar.WebButton("class:=btn btn-default btn-sm btn-info active","innerhtml:=.*span ng-class.*","html tag:=BUTTON","outertext:=.*"&intRequiredDay&".*","type:=button","visible:=True")
	 
	If objCalendarDay.Exist(.25) Then
	Err.Clear
	objCalendarDay.Click
	Else
	Execute "Set objPage_Calendar = Nothing"
	Execute "Set objPage_Calendar = " & Environment("WPG_AppParent") 'Page object
	Set objCalendarDay = objPage_Calendar.WebButton("class:=btn btn-default btn-sm active","innerhtml:=.*span ng-class.*","html tag:=BUTTON","outertext:=.*"&intRequiredDay&".*","type:=button","visible:=True")
	 
	If objCalendarDay.Exist(.25) Then
	Err.Clear
	objCalendarDay.Click
	Else
	Execute "Set objPage_Calendar = Nothing"
	Execute "Set objPage_Calendar = " & Environment("WPG_AppParent") 'Page object
	Set objCalendarDay = objPage_Calendar.WebButton("class:=btn btn-default btn-sm","innerhtml:=.*span ng-class.*","html tag:=BUTTON","outertext:=.*"&intRequiredDay&".*","type:=button","visible:=True")
	 
	If objCalendarDay.Exist(.25) Then
	Err.Clear
	objCalendarDay.Click
	End If
	End If
	End If
	 
	If Err.Number <> 0 Then
	strOutErrorDesc = "Unable to select required date from widget. "&Err.Description
	Exit Function
	End If
	Call WriteToLog("Pass","Selected required date from widget")
	Wait 1
	 
	End If
	 
	SelectDateFromCalendarWidget = True
	 
	Execute "Set objCalendarHeader = Nothing"
	Execute "Set objCalendarLeftArrow = Nothing"
	Execute "Set objCalendarRightArrow = Nothing"
	Set objCalendarDay = Nothing	
		
End Function

'================================================================================================================================================================================================
'Function Name       :	HandleWrongDashboardNavigation
'Purpose of Function :	To handle wrong Dashboard navigation 
'						Sometimes after selecting patient from MyPatient list or through GlobalSearch, app navigates to MyDashboard page. 
'						'HandleWrongDashboardNavigation' function handles this issue and provides proper navigation.
'Input Arguments     :	strPatientName: String value representing patient name which was during selection from MyPatient list or through GlobalSearch
'Output Arguments    :	Boolean value: representing status error handling
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation("Doocey, Eleonor",strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	January12, 2016
'================================================================================================================================================================================================

Function HandleWrongDashboardNavigation(ByVal strPatientName, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	HandleWrongDashboardNavigation = False
	
	Execute "Set objActionItems = " & Environment("WEL_ActionItems")
	
	If objActionItems.Exist(5) Then
	
		'Expand Open Patient Widget
		Wait 5
		Execute "Set objOpenPatientListExpandIcon = " & Environment.Value("WEL_OpenPatientList_ExpandIcon")
		Err.Clear
		objOpenPatientListExpandIcon.Click
		If Err.Number <> 0 Then
			strOutErrorDesc= "Open Patient widget is not expanded successfully.Error returned: "&Err.Description
		   Exit Function    
		End If		
		wait 2
		Call waitTillLoads("Loading...")
		Wait 1
			
		Set objPatientName = GetChildObject("micclass;class;html tag;outerhtml","WebElement;.*open-column Patientopenborder.*;DIV;.*open-column Patientopenborder.*")
		
		For i = 0 To objPatientName.Count - 1 Step 1
			Err.Clear
			strNameUI = Replace(Replace(objPatientName(i).GetROProperty("outertext")," ","",1,-1,1),",","",1,-1,1)
			strPatientName = Replace(Replace(strPatientName," ","",1,-1,1),",","",1,-1,1)
		   
			If Instr(1,strNameUI,strPatientName,1) Then
		    	objPatientName(i).highlight
		    	Err.Clear
		    	objPatientName(i).click
		   		If Err.Number <> 0 Then
		      		strOutErrorDesc= Trim(objPatientName(i).GetROProperty("innertext")) &": Patient name is not clicked in Open patient widget.Error returned: "& Err.Description
		      	 	Exit Function    
		   		End If	   		
		   		Exit For
		   	End If
		Next    		
		wait 2
		Call waitTillLoads("Loading...")
		Wait 1
		
		'Close Open Patient Widget
		Execute "Set objOpenPatientListCollapseIcon = " & Environment.Value("WEL_OpenPatientList_CollapseIcon")	    
		objOpenPatientListCollapseIcon.click
		If Err.Number <> 0 Then
	        strOutErrorDesc= "Open Patient widget is not collapse successfully.Error returned: "&Err.Description
	        Exit Function    
	    End If
	    Wait 1
	    
	    HandleWrongDashboardNavigation = True
	    
	Else		
		HandleWrongDashboardNavigation = True
	End If
	
	Execute "Set objActionItems = Nothing" 
	Execute "Set objOpenPatientListExpandIcon = Nothing"
	Set objPatientName = Nothing
	Execute "Set objOpenPatientListCollapseIcon = Nothing" 

End Function
'================================================================================================================================================================================================
'Function Name       :	ClosePatientAndReopenThroughGlobalSearch
'Purpose of Function :  Closing the patient and reopening through GlobalSearch. (this will help to avoid logout and login again for getting changes reflected)		'						
'Input Arguments     :	strPatientName: String value representing patient name
'					 :	lngMemberID: Long integer value representing patient member id
'Output Arguments    :	Boolean value: representing status of reopening the patient
'					 :  strOutErrorDesc:String value which contains detail error message
'Example of Call     :	blnClosePatientAndReopenThroughGlobalSearch = ClosePatientAndReopenThroughGlobalSearch(strPatientName,lngMemberID,strOutErrorDesc)
'Author				 :  Gregory
'Date				 :	February25, 2016
'================================================================================================================================================================================================
Function ClosePatientAndReopenThroughGlobalSearch(ByVal strPatientName, ByVal lngMemberID, strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	ClosePatientAndReopenThroughGlobalSearch = False
	
	'Close all open patients
'	blnCloseAllOpenPatient = CloseAllOpenPatient(strOutErrorDesc)
	blnCloseAllOpenPatient = closeOpenPatients(strOutErrorDesc)
	If not blnCloseAllOpenPatient Then
		strOutErrorDesc = "Unable to close all open patients in Open Patient widget. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Closed all open patients in Open Patient widget")
	
	'Re-open through global search
	blnGlobalSearchUsingMemID = GlobalSearchUsingMemID(lngMemberID, strOutErrorDesc)
	If not blnGlobalSearchUsingMemID Then
		strOutErrorDesc = "Unable to open patient through global search. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Opened patient through global search")
	
	'Handle navigation err (if exists) after global selection
	blnHandleWrongDashboardNavigation = HandleWrongDashboardNavigation(strPatientName,strOutErrorDesc)
	If not blnHandleWrongDashboardNavigation Then
		strOutErrorDesc = "Unable to provide proper navigation after patient selection. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Provided proper navigation after patient selection")
	
	ClosePatientAndReopenThroughGlobalSearch = True
	
End Function

Function ProvidePatientName()
	
	On Error Resume Next
	Err.Clear
	
	ProvidePatientName = ""
	
	strFirstName = "ATN"&Replace((Split(Now," ",-1,1)(0)),"/","",1,-1,1)
	strSecondName = "ATN"&Replace((Split(Now," ",-1,1)(1)),":","",1,-1,1)
	
	ProvidePatientName = strSecondName&", "&strFirstName
	
End Function

Function closePatientsFromDB(ByVal strUser)
	
	strUser = UCase(Trim(strUser))
	blnConnected_DB = ConnectDB()
	
	If blnConnected_DB Then	
'		strQ_Close = "Delete cnps_contact_pre_save where cnps_user_role = '"&strUser&"' AND CNPS_APP_CODE = 'CPP2'"
		strQ_Close = "Delete cnps_contact_pre_save where cnps_user_role = '"&strUser&"'"
		blnQ_Executed = RunQueryRetrieveRecordSet(strQ_Close)		
'		If blnQ_Executed Then
'			Call WriteToLog("Pass","Closed all open patients from DB")
'		End If		
	End If
	
	CloseDBConnection

End Function


Function closeOpenPatients(strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	closeOpenPatients = False
	
	Execute "Set objOpenPatientList_Expand = " & Environment.Value("WEL_OpenPatientList_ExpandIcon")
	Err.Clear
	objOpenPatientList_Expand.highlight
	objOpenPatientList_Expand.Click	
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click expand widget arrow. " &Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked expand widget arrow")
	Wait 1
	
	Set oDescP = Description.Create
	oDescP("micclass").value = "WebElement"
	oDescP("attribute/data-capella-automation-id").value = "Patients-CurrentPatient-.*"
	oDescP("attribute/data-capella-automation-id").RegularExpression = True
	oDescP("html tag").value = "DIV"
	oDescP("visible").value = True
	
	Set objOpenPatients = getPageObject().ChildObjects(oDescP)
	ic = objOpenPatients.count
	
	For i = 1 To ic-1 Step 1 '(i=0 is not taken as it is directed to header object)
	
		objOpenPatients(i).highlight
		Err.Clear
		objOpenPatients(i).click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click open patinet. " &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked open patinet")
		Wait 1
		Call waitTillLoads ("Loading...")

		Execute "Set objOpenPatientList_Collapse = " & Environment.Value("WEL_OpenPatientList_CollapseIcon")
		Err.Clear
		objOpenPatientList_Collapse.Click
		If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click collapse widget arrow. " &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked collapse widget arrow")
		Wait 1
		Call waitTillLoads ("Loading...")

'		Execute "Set objBrowserIconInOPW = "&Environment("WI_ACMBrowser")
'		Set objBrowserIconInOPW = getPageObject().Image("file name:=Browse_Small.*","html tag:=IMG","name:=Image","visible:=True","index:=0")
		Set objBrowserIconInOPW = getPageObject().WebElement("class:=.*binoculars recap-contact-footer-small-icon.*","visible:=True","index:=0")
		If objBrowserIconInOPW.Exist(10) Then
			Err.Clear
			objBrowserIconInOPW.Click
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to click Browser icon in Open patient widget. " &Err.Description
				Exit Function
			End If
			Call WriteToLog("Pass","Clicked Browser icon in Open patient widget")
			wait 1
			Call waitTillLoads("Loading...")			
		Else
			strOutErrorDesc = "Unable to find Browser icon in Open patient widget. " &Err.Description
			Exit Function
		End If	
							
		Execute "Set objFinalizeBtn = " & Environment.Value("WB_Finalize")
		If not objFinalizeBtn.Exist(1) Then
			Call closeOpenPatients(strOutErrorDesc)
		End If
		
		Err.Clear
		objFinalizeBtn.Click
		If Err.Number <> 0 Then
			strOutErrorDesc= "Unable to click finalize button: "&Err.Description
			Exit Function    
		End If
		Call WriteToLog("Pass","Clicked on Finalize button")
		wait 1
		Call waitTillLoads ("Loading...")
		
		Execute "Set objClosePatientOKbutton = " & Environment.Value("WB_ClosePatientOKbutton")
		If objClosePatientOKbutton.Exist(2) Then
			Err.Clear
			objClosePatientOKbutton.Click
			If Err.Number <> 0 Then
				strOutErrorDesc= "Unable to click ClosePatient OK button: "&Err.Description
				Exit Function    
			End If
			Call WriteToLog("Pass","Clicked on Close Patient OK button")
			Wait 1
			Call waitTillLoads ("Loading...")
		End If
		
		Execute "Set objErrorOKbutton = " & Environment.Value("WB_InvalidDataPPokAfterClosePatients")
		If objErrorOKbutton.Exist(2) Then
			Err.Clear
			objErrorOKbutton.Click
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to click error msg box OK button for Close patients. " &Err.Description
				Exit Function
			End If
			Call WriteToLog("Pass","Clicked error msg box OK button for Close patients")
			wait 1
			Call waitTillLoads ("Loading...")
						
			Set oDescDCcb = Description.Create
			oDescDCcb("micclass").Value = "WebElement"
			oDescDCcb("attribute/data-capella-automation-id").value = "recapNote\.isDeleted.*"
			oDescDCcb("attribute/data-capella-automation-id").RegularExpression = True
			
			Set objDeleteContactCBs = getPageObject().ChildObjects(oDescDCcb)
			intDeleteContactCBs = objDeleteContactCBs.Count			
			For iCB = 0 To intDeleteContactCBs-1 Step 1
				Err.Clear
				objDeleteContactCBs(iCB).Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to click delete contact check box "&iCB+1&". " &Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked delete contact check box "&iCB+1)
				Wait 1
			Next
			
			Set oDescDCcb = Nothing
			Set objDeleteContactCBs = Nothing
			
			Execute "Set objFinalizeBtn = " & Environment.Value("WB_Finalize")
			Err.Clear
			objFinalizeBtn.Click
			If Err.Number <> 0 Then
				strOutErrorDesc= "Unable to click finalize button: "&Err.Description
				Exit Function    
			End If
			Call WriteToLog("Pass","Clicked on Finalize button")

			Execute "Set objClosePatientOKbutton = " & Environment.Value("WB_ClosePatientOKbutton")
			Err.Clear
			objClosePatientOKbutton.Click
			If Err.Number <> 0 Then
				strOutErrorDesc= "Unable to click ClosePatient OK button: "&Err.Description
				Exit Function    
			End If
			Call WriteToLog("Pass","Clicked on Close Patient OK button")
			Wait 1
			Call waitTillLoads ("Loading...")
			
		End If
		
		Execute "Set objOpenPatientList_Expand = " & Environment.Value("WEL_OpenPatientList_ExpandIcon")
		Err.Clear
		objOpenPatientList_Expand.highlight
		objOpenPatientList_Expand.Click	
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click expand widget arrow. " &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked expand widget arrow")
		Wait 1
		
	Next	

	Execute "Set objOpenPatientList_Collapse = " & Environment.Value("WEL_OpenPatientList_CollapseIcon")
	If objOpenPatientList_Collapse.Exist(2) Then
		Err.Clear
		objOpenPatientList_Collapse.Click
		If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click collapse widget arrow. " &Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked collapse widget arrow")
		Wait 1
		Call waitTillLoads ("Loading...")
	End If
	
	Execute "Set objFinalizeBtn = Nothing"
	Execute "Set objContactNoteDetail_1 = Nothing"
	Execute "Set objClosePatientOKbutton = Nothing"
	Execute "Set objClosePatientRecordHeader = Nothing"
	Execute "Set objFinalizePatientGlypnInOPW = Nothing"
	Execute "Set objErrorOKbutton = Nothing"
	Execute "Set objBrowserIconInOPW = Nothing"

    closeOpenPatients = True

	
End Function

Function getQuesNo(ByVal survey_ques_uid)
	On Error Resume Next
	Err.Clear

	getQuesNo = "NA"
	
	strSQLQuery = "select survey_ques_order from survey_questions where survey_ques_uid = '" & survey_ques_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		quesNo = objDBRecordSet("survey_ques_order")
		objDBRecordSet.MoveNext
	Wend
	
	getQuesNo = quesNo
End Function

Function isEndOfSurvey(ByVal survey_ques_opt_ques_uid, ByVal survey_ques_opt_order)
	On Error Resume Next
	Err.Clear

	isEndOfSurvey = "NA"
	
	strSQLQuery = "select survey_ques_opt_eos_yn from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "' and survey_ques_opt_order = '" & survey_ques_opt_order & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		yn = objDBRecordSet("survey_ques_opt_eos_yn")
		objDBRecordSet.MoveNext
	Wend
	
	isEndOfSurvey = yn
End Function

Function getSurveyQuestionText(ByVal survey_ques_survey_uid, ByVal survey_ques_order)
	
	On Error Resume Next
	Err.Clear

	getSurveyQuestionText = "NA"
	
	strSQLQuery = "select survey_ques_text from capella.survey_questions where survey_ques_survey_uid = '" & survey_ques_survey_uid & "' and survey_ques_order = '" & survey_ques_order & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		quesText = objDBRecordSet("survey_ques_text")
		objDBRecordSet.MoveNext
	Wend
	
	getSurveyQuestionText = quesText
	
End Function

Function getSkipToQuestion(ByVal survey_ques_opt_ques_uid, ByVal survey_ques_opt_uid)
	On Error Resume Next
	Err.Clear

	getSkipToQuestion = "NA"
	
	strSQLQuery = "select survey_ques_uid_skipto from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "' and survey_ques_opt_uid = '" & survey_ques_opt_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		quesUid = objDBRecordSet("survey_ques_uid_skipto")
		objDBRecordSet.MoveNext
	Wend
	
	getSkipToQuestion = quesUid

End Function

Function getOptionCount(ByVal survey_ques_opt_ques_uid)
	On Error Resume Next
	Err.Clear

	getOptionCount = "NA"
	
	strSQLQuery = "select count(*) as COUNT from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		count = objDBRecordSet("COUNT")
		objDBRecordSet.MoveNext
	Wend
	
	getOptionCount = count
End Function

Function getQuesOptionUid(ByVal survey_ques_opt_ques_uid, ByVal optionText)
	On Error Resume Next
	Err.Clear

	getQuesOptionUid = "NA"
	
	strSQLQuery = "select survey_ques_opt_uid from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "' and survey_ques_opt_text = '" & optionText & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		optuid = objDBRecordSet("survey_ques_opt_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getQuesOptionUid = optuid
End Function

Function getSurveySkipToQuestionText(ByVal survey_ques_uid)
	
	On Error Resume Next
	Err.Clear

	getSurveySkipToQuestionText = "NA"
	
	strSQLQuery = "select survey_ques_text from capella.survey_questions where survey_ques_uid = '" & survey_ques_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		quesText = objDBRecordSet("survey_ques_text")
		objDBRecordSet.MoveNext
	Wend
	
	getSurveySkipToQuestionText = quesText
	
End Function

Function getActiveSurveyUid(ByVal surveyType)
	On Error Resume Next
	Err.Clear
	
	getActiveSurveyUid = "NA"
	
	strSQLQuery = "select m.survey_uid from survey_master m inner join survey_type t on m.survey_type_uid = t.survey_type_uid where t.survey_type = '" & surveyType & "' and (m.survey_start_date <= to_date(current_date) and m.survey_end_date >= to_date(current_date))"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	
	while not objDBRecordSet.EOF
		surveyUid = objDBRecordSet("survey_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getActiveSurveyUid = surveyUid
End Function

Function getMinQuestionUid(ByVal surveyType)
	On Error Resume Next
	Err.Clear
	
	getMinQuestionUid = "NA"
	
	survey_ques_survey_uid = getActiveSurveyUid(surveyType)
	If survey_ques_survey_uid = "NA" Then
		Exit Function
	End If
	
	strSQLQuery = "select min(survey_ques_uid) as survey_ques_uid from capella.survey_questions where survey_ques_survey_uid = '" & survey_ques_survey_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		surveyQuesUid = objDBRecordSet("survey_ques_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getMinQuestionUid = surveyQuesUid
End Function

Function getMaxQuestionUid(ByVal surveyType)
	On Error Resume Next
	Err.Clear
	
	getMaxQuestionUid = "NA"
	
	survey_ques_survey_uid = getActiveSurveyUid(surveyType)
	If survey_ques_survey_uid = "NA" Then
		Exit Function
	End If
	
	strSQLQuery = "select max(survey_ques_uid) as survey_ques_uid from capella.survey_questions where survey_ques_survey_uid = '" & survey_ques_survey_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		surveyQuesUid = objDBRecordSet("survey_ques_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getMaxQuestionUid = surveyQuesUid
End Function

Function getSurveyQuesUid(ByVal survey_ques_survey_uid, ByVal survey_ques_order)
	On Error Resume Next
	Err.Clear

	getSurveyQuesUid = "NA"
	
	strSQLQuery = "select survey_ques_uid from capella.survey_questions where survey_ques_survey_uid = '" & survey_ques_survey_uid & "' and survey_ques_order = '" & survey_ques_order & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	If objDBRecordSet.EOF Then
		Exit Function
	End If
	while not objDBRecordSet.EOF
		surveyQuesUid = objDBRecordSet("survey_ques_uid")
		objDBRecordSet.MoveNext
	Wend
	
	getSurveyQuesUid = surveyQuesUid
End Function

Function isOptionHasFreeForm(ByVal survey_ques_opt_ques_uid, ByVal survey_ques_opt_uid)
	On Error Resume Next
	Err.Clear

	isOptionHasFreeForm = "NA"
	
	strSQLQuery = "select survey_ques_opt_has_freeform from capella.survey_ques_options where survey_ques_opt_ques_uid = '" & survey_ques_opt_ques_uid & "' and survey_ques_opt_uid = '" & survey_ques_opt_uid & "'"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	while not objDBRecordSet.EOF
		hasfreeFormText = objDBRecordSet("survey_ques_opt_has_freeform")
		objDBRecordSet.MoveNext
	Wend
	
	isOptionHasFreeForm = hasfreeFormText
End Function

Function Grade(ByVal arrNamesForGrades)

	Dim GradeName()
	
	For i = 0 To UBound(arrNamesForGrades) Step 1
	
		ReDim Preserve GradeName(i)
	
		Name = arrNamesForGrades(i)
		
		GradeName(i) = Name&" "&"A+"
		
	Next
	
	Grade = GradeName
	
End Function

Function getScreeningHistory(ByVal survey_type_uid, ByVal memId, ByVal screening_completed_date)
	
	On Error Resume Next
	Err.Clear

	strSQLQuery = "select * from mem_survey where mem_srv_survey_uid = '" & survey_type_uid &"' and mem_srv_mem_uid = (select mem_uid from mem_member where mem_id = '" & memId & "') and trunc(MEM_SRV_SURVEY_DATE) = to_date('" & screening_completed_date & "', 'MM/DD/YYYY')"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	
	If Not isObject(objDBRecordSet) Then
		Exit Function
	End If
	
	Set recordData = CreateObject("Scripting.Dictionary")
	
	If objDBRecordSet.EOF = false Then
		For i = 0 To objDBRecordSet.fields.count - 1
			recordData.Add objDBRecordSet.fields(i).Name, objDBRecordSet.fields(i).Value
		Next
	End If
	
	Set getScreeningHistory = recordData	
End Function


Function getScreeningHistoryCount(ByVal survey_type_uid, ByVal memId)
	On Error Resume Next
	Err.Clear

	getScreeningHistoryCount = 0
	strSQLQuery = "select count(*) as Count from mem_survey where mem_srv_survey_uid = '" & survey_type_uid &"' and mem_srv_mem_uid = (select mem_uid from mem_member where mem_id = '" & memId & "') and mem_srv_complete_date >= sysdate - interval '5' year"
	isPass = RunQueryRetrieveRecordSet(strSQLQuery)
	
	If not isPass Then
		Exit Function
	End If	
	Dim count
	while not objDBRecordSet.EOF
		count = objDBRecordSet("count")
		objDBRecordSet.MoveNext
	Wend
	
	getScreeningHistoryCount = count
End Function