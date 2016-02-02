''***********************************************************************************************************************************************************************
'' Function Name				: Enrollment Screening
'' Inputs 					    : Call Outcome Value(Enrolled, Declined, Ineligible, Undecided), Popup Title, Save Popup Text, ARN Workflow (YES/NO), Choose ARN(YES/NO), Schedule date (mm/dd/YYYY)
'' Author                   	: Sharmila
''***********************************************************************************************************************************************************************
Set objFso = CreateObject("Scripting.FileSystemObject")
driverScriptFolder = objFso.GetParentFolderName(Environment.Value("TestDir"))
Environment.Value("PROJECT_FOLDER") = objFso.GetParentFolderName(driverScriptFolder)

'load environment file
Environment.LoadFromFile Environment.Value("PROJECT_FOLDER") & "\Configuration\DaVita-Capella_Configuration.xml",True 	'Import environment file

'load all functional libraries
functionalLibFolder = Environment.Value("PROJECT_FOLDER") & "\Library\generic_functions"
For each objFile in objFso.GetFolder(functionalLibFolder).Files
	If UCase(objFso.GetExtensionName(objFile.Name)) = "VBS" or UCase(objFso.GetExtensionName(objFile.Name)) = "QFL" Then
		LoadFunctionLibrary objFile.Path
	End If
Next

Set objFso = Nothing

Call Initialization() 

''=========================
'' Variable initialization
''=========================
strOutcomeValue =  "Ineligible"         'Answer for Question 4
strPopUpTitle = "Enrollment Screening"
strSavePopupText = "Screening has been saved successfully"
strARNWorkFlow = "YES"
strChooseARN = "NO"
strScheduleDate = "04/30/2015"
''=====================================
'' Objects required for test execution
''=====================================

isPass = Login("vhes")

If not isPass Then
	Call WriteToLog("Fail","Failed to Login to VHES role.")
	Call WriteLogFooter()
	ExitAction
End If

Call WriteToLog("Pass","Successfully logged into VHES role")

Call clickOnSubMenu("Screenings->Enrollment Screening")

'Execute "Set objEnrollmentScreeningTitle = " &Environment.Value("DictObject").Item("WEL_EnrollmentScreeningTitle") 
'Execute "Set objEnrollmentScreeningDate= "   &Environment.Value("DictObject").Item("WE_EnrollmentScreeningDate") 
'Execute "Set objEnrollementScreeningSaveButton = "  &Environment.Value("DictObject").Item("WEL_EnrollementScreening_SaveButton") 
'Execute "Set objEnrollementScreeningCancelButton = " &Environment.Value("DictObject").Item("WEL_EnrollementScreening_CancelButton") 
Set objPage = Browser("name:=DaVita VillageHealth Capella","openTitle:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
'objPage.highlight
Set objEnrollmentScreeningTitle = objPage.WebElement("class:=row title-gradient title-header.*","html tag:=DIV","innertext:=.*Enrollment Screening.*")
Set objEnrollementScreeningCancelButton =objPage.WebElement("class:=.*cancel-btn.*","innertext:=Cancel")
Set objEnrollementScreeningSaveButton = objPage.WebElement("class:=.*save-btn.*","innertext:=Save")
Set objEnrollmentScreeningDate= objPage.WebEdit("class:=deviceHome.*","placeholder:=<MM/dd/yyyy>","visible:=True")
Set objEnrollementQuestion = objPage.WebElement("html tag:=DIV","html id:=enrollmentQuestionDiv")
Set objPopupTitle = objPage.WebElement("html tag:=DIV","innertext:=Enrollment Screening","class:=modal-header title-gradient custompopup-title-header title-header drag-handler")
Set objPopupText = objPage.WebElement("html tag:=B","innertext:=.*","outerhtml:=.*alertText.*|.*|.*alert-text.*","visible:=True")
Set objOKButton = objPage.WebButton("html tag:=INPUT|BUTTON","name:=Ok|OK","class:=btn-custom-model btn-custom-gradient")
Set objScheduleCall = objPage.WebElement("html tag:=DIV","html id:=AddAppointmentVHES")
Set ObjScheduleSave = objPage.WebButton("html tag:=BUTTON","outertext:=Save","class:=btn btn-custom title-gradient")

'==================================================
'Verify that Enrollment screening open successfully
'==================================================
If CheckObjectExistence(objEnrollmentScreeningTitle,intWaitTime) Then
	Call WriteToLog("Pass","Enrollment screening opened successfully")
Else
	Call WriteToLog("Fail","Enrollment screening not opened successfully")
	Call WriteLogFooter()
	ExitAction
End If

'=======================================
'Verify the existance of Screening Date
'=======================================
If CheckObjectExistence(objEnrollmentScreeningDate,intWaitTime) Then
	Call WriteToLog("Pass","Screening date exist on Enrollment screening")		
Else
	Call WriteToLog("Fail","Screening date not exist on Enrollment screening")
End If

'============================================================
'Verify the number of question of Enrollment screening screen
'============================================================

'objEnrollementQuestion.highlight
Set objTableRowDesc = Description.Create
objTableRowDesc("micclass").value = "WebElement"
objTableRowDesc("html tag").value = "DIV"
objTableRowDesc("class").value = "row row-padding"
Set objQuestions = objEnrollementQuestion.ChildObjects(objTableRowDesc) 

''=====================================
'Question 1
''=====================================

Set objQuestion1 = Description.Create
objQuestion1("micclass").value = "WebElement"
objQuestion1("html tag").value = "DIV"
objQuestion1("class").value = "screening-check-box screening-question-answer-text.*"
Set objCheckBoxClick = objQuestions(0).ChildObjects(objQuestion1)
For CBCount = 0 To objCheckBoxClick.Count -1 Step 1
	objCheckBoxClick(CBCount).Click
Next
Set objQuestion1 = nothing
Set objCheckBoxClick = nothing
			
''=====================================			
'End of Question 1	
''=====================================
'Question 2
''=====================================
Set objQuestion1 = Description.Create
objQuestion1("micclass").value = "WebElement"
objQuestion1("html tag").value = "DIV"
objQuestion1("class").value = "circular-radio.*"
Set objRadioButtonClick = objQuestions(1).ChildObjects(objQuestion1)
objRadioButtonClick(0).Click
Set objQuestion1 = nothing
Set objRadioButtonClick = nothing	

''=====================================
'End of Question 2	
''=====================================
'Question 3
''=====================================
Set objQuestion1 = Description.Create
objQuestion1("micclass").value = "WebElement"
objQuestion1("html tag").value = "DIV"
objQuestion1("class").value = "circular-radio.*"
Set objRadioButtonClick = objQuestions(2).ChildObjects(objQuestion1)
objRadioButtonClick(0).Click	
Set objQuestion1 = nothing
Set objRadioButtonClick = nothing

''=====================================
'End of Question 3	
''=====================================
'Start Question 4
''=====================================
Set objQuestion1 = Description.Create
objQuestion1("micclass").value = "WebElement"
objQuestion1("html tag").value = "DIV"
objQuestion1("class").value = "circular-radio.*"
Set objRadioButtonClick = objQuestions(3).ChildObjects(objQuestion1)
''=====================================================================================
'Choosing the call outcome for the screening (Enrolled/Declined/Ineligible/Undecided)
''=====================================================================================
Select Case strOutcomeValue
	Case "Enrolled"
		objRadioButtonClick(0).click	
		''=====================================
		'Start Question 4a
		''=====================================
		If strARNWorkFlow = "YES" Then
			Set objQuestionARN = Description.Create
			objQuestionARN("micclass").value = "WebElement"
			objQuestionARN("html tag").value = "DIV"
			objQuestionARN("class").value = "circular-radio.*"
			Set objARNRadioButtonClick = objQuestions(4).ChildObjects(objQuestionARN)
			If strChooseARN = "NO" Then
				objARNRadioButtonClick(0).click
			Else
				objARNRadioButtonClick(1).click
				''=====================================
				'Schedule ARN Apoointment
				''=====================================
			End If
			objARNRadioButtonClick(0).click
			Set objQuestionARN = nothing
			Set objARNRadioButtonClick = nothing		
		End If
		''=====================================
		'End of Question 4a	
		''=====================================
		'Start Question 7
		''=====================================
		Set objQuestion7 = Description.Create
		objQuestion7("micclass").value = "WebElement"
		objQuestion7("html tag").value = "DIV"
		objQuestion7("class").value = "circular-radio.*"
		Set objQ7RadioButtonClick = objQuestions(7).ChildObjects(objQuestion7)
		objQ7RadioButtonClick(0).click
		Set objQuestion7 = nothing
		Set objQ7RadioButtonClick = nothing	
		''=====================================
		'End of Question 4a	
		''=====================================
		'Start Question 8
		''=====================================		
		Set objQuestion8 = Description.Create
		objQuestion8("micclass").value = "WebButton"
		objQuestion8("html tag").value = "BUTTON"
		objQuestion8("html id").value = "option-dropdown"
		objQuestion8("class").value = ".*dropdown-toggle.*"
		objQuestion8("class").regularexpression = true
		Set objDropdown = objQuestions(8).ChildObjects(objQuestion8)
		Call selectComboBoxItem(objDropdown(0),"Brother")
		Set objQuestion8 = nothing
		Set objDropdown = nothing
		''=====================================
		'End of Question 8	
		''=====================================
		'Start Question 9
		''=====================================
		Set objQuestion9 = Description.Create
		objQuestion9("micclass").value = "WebElement"
		objQuestion9("html tag").value = "DIV"
		objQuestion9("class").value = "circular-radio.*"
		Set objQ9RadioButtonClick = objQuestions(9).ChildObjects(objQuestion9)
		objQ9RadioButtonClick(0).click
		Set objQuestion9 = nothing
		Set objQ9RadioButtonClick = nothing	
		''=====================================
		'End of Question 4a	
		''=====================================
	Case "Declined"
		objRadioButtonClick(1).click
	Case "Ineligible"
		objRadioButtonClick(2).click
	Case "Undecided"
		objRadioButtonClick(3).click
		'=====================================
		'Reschedule Call
		'=====================================
		Set objReschedule = Description.Create
		objReschedule("micclass").value = "WebElement"
		objReschedule("html tag").value = "DIV"
		objReschedule("html id").value = "rescheduleCallBtn"
		objReschedule("innertext").value = "Reschedule Call"
		Set objRescheduleBtnClick = objQuestions(3).ChildObjects(objReschedule)
		objRescheduleBtnClick(0).click
		'=====================================
		'Schedule Appointment Function
		'=====================================
		Call scheduleCalendar(strScheduleDate)
		ObjScheduleSave.highlight
		ObjScheduleSave.Click
		'=====================================
		'End Schedule Appointment Function
		'=====================================
		
		
		Set objReschedule = nothing
		Set objRescheduleBtnClick = nothing
		''=====================================
		'Start Question 5
		''=====================================
		Set objQuestion5 = Description.Create
		objQuestion5("micclass").value = "WebButton"
		objQuestion5("html tag").value = "BUTTON"
		objQuestion5("html id").value = "option-dropdown"
		objQuestion5("class").value = ".*dropdown-toggle.*"
		objQuestion5("class").regularexpression = true
		Set objDropdown = objQuestions(5).ChildObjects(objQuestion5)
		Call selectComboBoxItem(objDropdown(0),"other")
		Set objQuestion5 = nothing
		Set objDropdown = nothing
		''=====================================
		'End of Question 5	
		''=====================================
		'Start Question 6
		''=====================================
		Set objQuestion6 = Description.Create
		objQuestion6("micclass").value = "WebEdit"
		objQuestion6("html tag").value = "TEXTAREA"
		objQuestion6("html id").value = "memberUndecidedReasonTbox"
		objQuestion6("class").value = ".*form-control freeformtext.*"
		objQuestion6("class").regularexpression = true
		Set objTextArea = objQuestions(6).ChildObjects(objQuestion6)
		objTextArea(0).click
		objTextArea(0).Set "Test"
		Set objQuestion5 = nothing
		Set objDropdown = nothing
		''=====================================
		'End of Question 6	
		''=====================================
End Select
Set objQuestion1 = nothing
Set objRadioButtonClick = nothing
''=====================================
'End of Enrollment Screening
''=====================================

blnReturnValue = ClickButton("Save",objEnrollementScreeningSaveButton,strOutErrorDesc)
If not blnReturnValue Then
	Call WriteToLog("Fail","ClickButton return: "&strOutErrorDesc)
	Call WriteLogFooter()
	ExitAction
End If

Call checkForPopup(strPopUpTitle, "Ok", strSavePopupText)
If (strOutcomeValue <> "Undecided" ) and (strOutcomeValue <> "Enrolled" )  Then
	strSavePopupText = "Please navigate to Patient Info screen and terminate the patient."
    Call checkForPopup(strPopUpTitle, "Ok", strSavePopupText)
End If





'
'#################################################	End: Test Case Execution	#################################################
Function selectComboBoxItem(ByVal objComboBox, ByVal itemToClick)

    Set objPage = Browser("name:=DaVita VillageHealth Capella","openTitle:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
    
    objComboBox.Click
    wait 2
    Set objDropDown = objPage.WebElement("class:=dropdown-menu defaultdropdownul.*","html tag:=UL","visible:=true")
    
    Set itemDesc = Description.Create
    itemDesc("micclass").Value = "Link"
    itemDesc("class").Value = "ng-binding.*"
    itemDesc("html tag").Value = "A"
    itemDesc("text").Value = ".*" & trim(itemToClick) & ".*"
    itemDesc("text").regularexpression = true
    
    Set objItem = objDropDown.Link(itemDesc)
    objItem.Click
    wait 2
    Set objDropDown = Nothing
    Set objCombo = Nothing
    Set objPage = Nothing
    
End Function


Function checkForPopup(ByVal title, ByVal buttonName, ByVal alertText)

    Set objPage = Browser("name:=DaVita VillageHealth Capella","openTitle:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
    
    'check if the required pop up with title exists
    Set customPopupDesc = Description.Create
    customPopupDesc("micclass").Value = "WebElement"
    customPopupDesc("class").Value = "modal-header title-gradient custompopup-title-header.*"
    customPopupDesc("class").regularExpression = true
    customPopupDesc("innertext").Value = ".*" & trim(title) & ".*"
    customPopupDesc("innertext").regularExpression = true
                                      
    Set objCustomPopUp = objPage.ChildObjects(customPopupDesc)
    
    If Not isObject(objCustomPopUp) Then
        MsgBox "No pop up found with title '" & title & "'."
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
        Print "No pop up body found"
        Set popupBodyDesc = Nothing
        Set objPopupBody = Nothing
        Set objCustomPopUp = Nothing
        Set customPopupDesc = Nothing
        Set objPage = Nothing
        checkForPopup = False
        Exit Function
    End If
    
'    Call WriteResultLog("", objPopupBody.Count & " custom popup(s) found. Attempting to close all.", "info", true)
    'verify if required text exists
    Set alertTextDesc = Description.Create
    alertTextDesc("micClass").Value = "WebElement"
    alertTextDesc("class").Value = ".*alert-text.*"
    alertTextDesc("class").regularExpression = true
    
    Dim popUpFound : popUpFound = False
    For i = 0 To objPopupBody.Count - 1
        Set objAlertText = objPopupBody(i).ChildObjects(alertTextDesc)
        
        If Not isObject(objAlertText) Then
            Print "No pop up body found"
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
    
        popUpAlertText = objAlertText(0).getROProperty("innertext")
        
        If StrComp(popUpAlertText, alertText) >= 0 Then
            Set buttonDesc = Description.Create
            buttonDesc("micclass").Value = "WebButton"
            buttonDesc("innertext").Value = buttonName
            'buttonDesc("class").Value = "btn-custom-model btn-custom-gradient"
            
            Set objButton = objPopupBody(i).WebButton(buttonDesc)
            objButton.Click
                
        '    Call WriteResultLog("", "Clicked OK button on pop up " & i+1, "info", true)
            Set objButton = Nothing
                
            wait 3
            Err.Clear
            checkForPopup = True
            popUpFound = True
            Exit For
        End If
        
    Next
    
    
    If Not popUpFound Then
'        Call WriteResultLog("", "No Message Box exist with required text.", "info", true)
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
    
    'Set objPage = getPageObject()
     Set objPage = Browser("name:=DaVita VillageHealth Capella","openTitle:=DaVita VillageHealth Capella").Page("title:=DaVita VillageHealth Capella")
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

