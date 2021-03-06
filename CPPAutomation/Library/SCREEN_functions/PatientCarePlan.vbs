
'=====================================================================================================================================================================================
																'FUNCTION LIBRARY FOR PATIENT CARE PLAN SCREEN
'Created By: Gregory
'Date completed: April 12, 2016
'=====================================================================================================================================================================================

Function PCP_ScreenNavigation(strOutErrorDesc)
	
	'Validate Patient Care Plan screen navigation
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_ScreenNavigation = False
	
	Call WriteToLog("Info","--------Validate Patient Care Plan screen navigation-------")
	
	'Validate Patient Care Plan screen navigation
	Execute "Set objPCP_PatCaPlnMainMenu = "&Environment("WL_PatCaPlnTab") 'PatientCarePlan tab
	Err.Clear
	objPCP_PatCaPlnMainMenu.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Patient Care Plan main menu. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked on Patient Care Plan main menu")
	Execute "Set objPCP_PatCaPlnMainMenu = Nothing"
	
	Wait 2
	Call waitTillLoads("Loading...")
	Wait 1
	Call waitTillLoads("Loading...")
	
	Execute "Set objPCP_ScreenHeader = "&Environment("WT_PCP_ScrHeader") 'PatientCarePlan screen header
	If not objPCP_ScreenHeader.Exist(5) Then
		strOutErrorDesc = "Unable to navigate to Patient Care Plan screen"
		Exit Function
	End If
	objPCP_ScreenHeader.highlight
	Call WriteToLog("Pass","Navigated to Patient Care Plan screen")
	Execute "Set objPCP_ScreenHeader = Nothing"
	
	Wait 1
	Err.Clear
	
	PCP_ScreenNavigation = True
	
End Function
'----------------------------------------------------------------

Function PCP_FieldValidations(strOutErrorDesc)

	'Validate Patient Care Plan screen sections and fileds
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_FieldValidations = False
	
	Call WriteToLog("Info","--------Validate Patient Care Plan screen sections and fields-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validate 'Active Care Plans' section availability
	Execute "Set objPCP_ActiveCarePlansSection = "&Environment("WEL_PCP_ACPsection") 'ACP section tab
	If not objPCP_ActiveCarePlansSection.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Active Care Plans' section in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Active Care Plans' section is available in Patient Care Plan screen")
	Execute "Set objPCP_ActiveCarePlansSection = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validate 'Care Plan History' section availability
	Execute "Set objPCPHistoryHeader = "&Environment("WT_PCPHistoryHeader") 'PCP History Table Header
	If not objPCPHistoryHeader.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Care Plan History' section in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Care Plan History' section is available in Patient Care Plan screen")
	Execute "Set objPCPHistoryHeader = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validate availability of 'Patient Care Plan' section fileds
	
	'PCP CarePlanTopic dropdown	
	Execute "Set objPCP_CarePlanTopicDD ="&Environment("WB_PatCaPlnTopic") 'PCP CarePlanTopic dropdown	
	If not objPCP_CarePlanTopicDD.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Care Paln Topic' dropdown in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Care Paln Topic' dropdown is available in Patient Care Plan screen")
	Execute "Set objPCP_CarePlanTopicDD = Nothing"	
	
	'PCP Importance level drodown
	Execute "Set objPCP_ImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 'PCP Importance drodown
	If not objPCP_ImportanceLevelDD.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Importance' dropdown in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Importance' dropdown is available in Patient Care Plan screen")
	Execute "Set objPCP_ImportanceLevelDD = Nothing"	
	
	'PCP Confidence level dropdown
	Execute "Set objPCP_ConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 'PCP Confidence level dropdown
	If not objPCP_ConfidenceLevelDD.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Confidence Level' dropdown in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Confidence Level' dropdown is available in Patient Care Plan screen")
	Execute "Set objPCP_ConfidenceLevelDD = Nothing"
	
	'PCP Status dropdown
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	If not objPCP_StatusDD.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Status' dropdown in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Status' dropdown is available in Patient Care Plan screen")
	Execute "Set objPCP_StatusDD = Nothing"
	
	'PCP StartDate field
	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
	If not objPCP_StartDateTB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Start Date' field in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Start Date' field is available in Patient Care Plan screen")
	Execute "Set objPCP_StartDateTB = Nothing"	
	
	'PCP DueDate field
	Execute "Set objPCP_DueDateTB = "&Environment("WE_PCP_DueDateFiled") 'PCP DueDate field
	If not objPCP_DueDateTB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Due Date' field in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Due Date' field is available in Patient Care Plan screen")
	Execute "Set objPCP_DueDateTB = Nothing"	
	
	'PCP CompletedDate field
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If not objPCP_CompletedDateTB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Completed Date' field in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Completed Date' field is available in Patient Care Plan screen")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	
	'PCP ClinicalRelevance dropdown
	Execute "Set objPCP_ClinicalRelevanceDD = "&Environment("WB_PatCaPlnClinicalRelvnDD") 'PCP ClinicalRelevance dropdown
	If not objPCP_ClinicalRelevanceDD.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Clinical Relevance' dropdown in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Clinical Relevance' dropdown is available in Patient Care Plan screen")
	Execute "Set objPCP_ClinicalRelevanceDD = Nothing"
	
	'PCP CarePlanName field	
	Execute "Set objPCP_CarePlanNameTB = "&Environment("WE_PatCaPlnName") 'PCP CarePlanName field	
	If not objPCP_CarePlanNameTB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Care Plan Name' field in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Care Plan Name' field is available in Patient Care Plan screen")
	Execute "Set objPCP_CarePlanNameTB = Nothing"
	
	'PCP Send Material link
	Execute "Set objPCP_SendMaterialLink = "&Environment("WI_PCP_SendMaterialLink") 'PCP Send Material link
	If not objPCP_SendMaterialLink.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Send Material' link in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Send Material' link is available in Patient Care Plan screen")
	Execute "Set objPCP_SendMaterialLink = Nothing"
	
	'PCP Referral link
	Execute "Set objPCP_ReferralLink = "&Environment("WI_PCP_ReferralLink") 'PCP Referral link	
	If not objPCP_ReferralLink.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Referral' link in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Referral' link is available in Patient Care Plan screen")
	Execute "Set objPCP_ReferralLink = Nothing"	
	
	'PCP BehavioralPlan field	
	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
	If not objPCP_BehavioralPlanTB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Behavioral Plan' field in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Behavioral Plan' field is available in Patient Care Plan screen")
	Execute "Set objPCP_BehavioralPlanTB = Nothing"
	
	'PCP Engagement plan field
	Execute "Set objPCP_EngagementPlanTB = "&Environment("WE_EngagementPlan") 'PCP Engagement plan field	
	If not objPCP_EngagementPlanTB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Engagement Plan' field in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Engagement Plan' field is available in Patient Care Plan screen")
	Execute "Set objPCP_EngagementPlanTB = Nothing"	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validate availability of Barriers and free form text in Patient Care plan screen
	
	'Poor Habits/Practices check box
	Execute "Set objPCP_PoorHabits_BarrierCB = "&Environment("WEL_PCP_PoorHabits_BarrierCB") 'Poor Habits/Practices check box
	If not objPCP_PoorHabits_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Poor Habits/Practices' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Poor Habits/Practices' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_PoorHabits_BarrierCB = Nothing"
	
	'Knowledge Deficit check box
	Execute "Set objPCP_KnowledgeDeficit_BarrierCB = "&Environment("WEL_PCP_KnowledgeDeficit_BarrierCB") 'Knowledge Deficit check box
	If not objPCP_KnowledgeDeficit_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Knowledge Deficit' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Knowledge Deficit' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_KnowledgeDeficit_BarrierCB = Nothing"
	
	'Equipment Issue check box
	Execute "Set objPCP_EquipmentIssue_BarrierCB = "&Environment("WEL_PCP_EquipmentIssue_BarrierCB") 'Equipment Issue check box
	If not objPCP_EquipmentIssue_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Equipment Issue' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Equipment Issue' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_EquipmentIssue_BarrierCB = Nothing"	
	
	'Psychological check box
	Execute "Set objPCP_Psychological_BarrierCB = "&Environment("WEL_PCP_Psychological_BarrierCB") 'Psychological check box
	If not objPCP_Psychological_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Psychological' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Psychological' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_Psychological_BarrierCB = Nothing"	
	
	'Socioeconomic check box
	Execute "Set objPCP_Socioeconomic_BarrierCB = "&Environment("WEL_PCP_Socioeconomic_BarrierCB") 'Socioeconomic check box
	If not objPCP_Socioeconomic_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Socioeconomic' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Socioeconomic' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_Socioeconomic_BarrierCB = Nothing"		
	
	'Physical Limitation check box	
	Execute "Set objPCP_PhysicalLimitation_BarrierCB = "&Environment("WEL_PCP_PhysicalLimitation_BarrierCB") 'Physical Limitation check box	
	If not objPCP_PhysicalLimitation_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Physical Limitation' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Physical Limitation' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_PhysicalLimitation_BarrierCB = Nothing"	
	
	'No Support System check box
	Execute "Set objPCP_NoSupportSystem_BarrierCB = "&Environment("WEL_PCP_NoSupportSystem_BarrierCB") 'No Support System check box
	If not objPCP_NoSupportSystem_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'No Support System' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'No Support System' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_NoSupportSystem_BarrierCB = Nothing"	
	
	'Other check box
	Execute "Set objPCP_Other_BarrierCB = "&Environment("WEL_PCP_Other_BarrierCB") 'Other check box
	If not objPCP_Other_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'Other' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'Other' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_Other_BarrierCB = Nothing"	
	
	'Field availability on checking Other barrier check box
	Execute "Set objPCP_Other_BarrierCB = "&Environment("WEL_PCP_Other_BarrierCB") 'Other check box
	objPCP_Other_BarrierCB.highlight
	Err.Clear
	objPCP_Other_BarrierCB.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to find check Other barrier check box in Patient Care Plan screen. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Checked Other barrier check box in Patient Care Plan screen")
	Execute "Set objPCP_Other_BarrierCB = Nothing"		

	'Other field
	Execute "Set objPCP_OtherTB_BarrierTB = "&Environment("WE_PCP_OtherTB_BarrierTB") 'Other field
	If not objPCP_OtherTB_BarrierTB.Exist(2) Then
		strOutErrorDesc = "Unable to find field for Other barrier in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Field is available in Patient Care Plan screen after checking Other barrier")
	Execute "Set objPCP_OtherTB_BarrierTB = Nothing"
	Wait 0,500
	
	'Uncheck Other barrier field
	Execute "Set objPCP_Other_BarrierCB = "&Environment("WEL_PCP_Other_BarrierCB") 'Other check box
	objPCP_Other_BarrierCB.highlight
	Err.Clear
	objPCP_Other_BarrierCB.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to find check Other barrier check box in Patient Care Plan screen. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Checked Other barrier check box in Patient Care Plan screen")
	Execute "Set objPCP_Other_BarrierCB = Nothing"
	
	'No Barriers check box
	Execute "Set objPCP_NoBarriers_BarrierCB = "&Environment("WEL_PCP_NoBarriers_BarrierCB") 'No Barriers check box
	If not objPCP_NoBarriers_BarrierCB.Exist(2) Then
		strOutErrorDesc = "Unable to find 'No Barriers' check box in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","'No Barriers' check box is available in Patient Care Plan screen")
	Execute "Set objPCP_NoBarriers_BarrierCB = Nothing"		
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	Wait 1
	Err.Clear
	PCP_FieldValidations = True
	
End Function
'----------------------------------------------------------------

Function PCP_FiledToolTipValidations(strOutErrorDesc)

	'Validate tool tip messages for Patient Care Plan fields

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_FiledToolTipValidations = False	
	
	Call WriteToLog("Info","--------Validate tool tip messages for Patient Care Plan fields-------")

	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'PCP Care Plan Topic dropdown tool tip validation
	Execute "Set objPCP_CarePlanTopicDD ="&Environment("WB_PatCaPlnTopic") 'PCP CarePlanTopic dropdown	
	blnPCP_ToolTipMsgValidation = PCP_ToolTipMsgValidation(objPCP_CarePlanTopicDD, "Please select Care Plan Topic", "No", strOutErrorDesc)
	If not blnPCP_ToolTipMsgValidation Then
		strOutErrorDesc = "Unable to validate tool tip message for CarePlanTopic. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated mouseover message for Care Plan Topic dropdown")
	Execute "Set objPCP_ActiveCarePlansSection = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'PCP Confidence level dropdown tool tip validation	
	Execute "Set objPCP_ConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 'PCP Confidence level dropdown
	blnPCP_ToolTipMsgValidation = PCP_ToolTipMsgValidation(objPCP_ConfidenceLevelDD, "Please select Confidence", "No", strOutErrorDesc)
	If not blnPCP_ToolTipMsgValidation Then
		strOutErrorDesc = "Unable to validate tool tip message for Confidence level dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated mouseover message for Confidence level dropdown")
	Execute "Set objPCP_ConfidenceLevelDD = Nothing"		
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'PCP Importance dropdown tool tip validation
	Execute "Set objPCP_ImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 'PCP Importance drodown
	blnPCP_ToolTipMsgValidation = PCP_ToolTipMsgValidation(objPCP_ImportanceLevelDD, "Please select Importance", "No", strOutErrorDesc)
	If not blnPCP_ToolTipMsgValidation Then
		strOutErrorDesc = "Unable to validate tool tip message for Importance dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated mouseover message for Importance dropdown")
	Execute "Set objPCP_ImportanceLevelDD = Nothing"	
	'---------------------------------------------------------------------------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'PCP Status dropdown tool tip validation		
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnPCP_ToolTipMsgValidation = PCP_ToolTipMsgValidation(objPCP_StatusDD, "Goal Status is required", "No", strOutErrorDesc)
	If not blnPCP_ToolTipMsgValidation Then
		strOutErrorDesc = "Unable to validate tool tip message for Status dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated mouseover message for Status dropdown")
	Execute "Set objPCP_StatusDD = Nothing"		
	'---------------------------------------------------------------------------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'PCP Clinical Relevance dropdown tool tip validation
	Execute "Set objPCP_ClinicalRelevanceDD = "&Environment("WB_PatCaPlnClinicalRelvnDD") 'PCP ClinicalRelevance dropdown
	blnPCP_ToolTipMsgValidation = PCP_ToolTipMsgValidation(objPCP_ClinicalRelevanceDD, "Please select Clinical Relevance", "No", strOutErrorDesc)
	If not blnPCP_ToolTipMsgValidation Then
		strOutErrorDesc = "Unable to validate tool tip message for Clinical Relevance dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated mouseover message for Clinical Relevance dropdown")
	Execute "Set objPCP_ClinicalRelevanceDD = Nothing"		
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'PCP Behavioral Plan  field	
	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
	blnPCP_ToolTipMsgValidation = PCP_ToolTipMsgValidation(objPCP_BehavioralPlanTB, "Behavioral Plan is required", "No", strOutErrorDesc)
	If not blnPCP_ToolTipMsgValidation Then
		strOutErrorDesc = "Unable to validate tool tip message for Behavioral Plan field. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated mouseover message for Behavioral Plan field")
	Execute "Set objPCP_BehavioralPlanTB = Nothing"	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'PCP Care Plan Name field tool tip validation
	Execute "Set objPCP_CarePlanNameTB = "&Environment("WE_PatCaPlnName") 'PCP CarePlanName field	
	blnPCP_ToolTipMsgValidation = PCP_ToolTipMsgValidation(objPCP_CarePlanNameTB, "Care Plan Name is required", "No", strOutErrorDesc)
	If not blnPCP_ToolTipMsgValidation Then
		strOutErrorDesc = "Unable to validate tool tip message for Care Plan Name field. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated mouseover message for Care Plan Name field")
	Execute "Set objPCP_CarePlanNameTB = Nothing"		
	'---------------------------------------------------------------------------------------------------------------------------------------------------		

	Call WriteToLog("Pass","Validated tool tip messages for Patient Care Plan fields")
	
	Wait 1
	Err.Clear
	PCP_FiledToolTipValidations = True
	
End Function
'----------------------------------------------------------------

Function PCP_CompletedDateFieldStatus(strOutErrorDesc)

	'Validate Completed Date field status for Stats variations
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_CompletedDateFieldStatus = False
	
	Call WriteToLog("Info","--------Validate Completed Date field status for Status variations (Add,Edit modes)-------")
	
	'Make Status and Completed Date fieds visible
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	Err.Clear	
	objPCP_StatusDD.highlight
	If Err.Number <> 0 Then
		strOutErrorDesc = "In Add/Edit mode 'Completed Date' field showing enabled. "&Err.Description
		Exit Function
	End If
	Execute "Set objPCP_StatusDD = Nothing"	
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - In Add/Edit mode 'Completed Date' field should be disabled 
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If not objPCP_CompletedDateTB.Object.isDisabled Then
		strOutErrorDesc = "In Add/Edit mode 'Completed Date' field showing enabled"
		Exit Function
	End If
	Call WriteToLog("Pass","In Add/Edit mode 'Completed Date' field showing disabled")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Add/Edit mode -  Status = 'In Progress' then 'Completed Date' field should be disabled.
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown	
	blnStatus = selectComboBoxItem(objPCP_StatusDD, "In Progress")
	If not blnStatus Then
		strOutErrorDesc = "Unable to select status from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as 'In Progress'")
	Wait 0,250
	
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If not objPCP_CompletedDateTB.Object.isDisabled Then
		strOutErrorDesc = "In Add/Edit mode, when Status = 'In Progress', 'Completed Date' field is shown enabled"
		Exit Function
	End If
	Call WriteToLog("Pass","In Add/Edit mode, when Status = 'In Progress', 'Completed Date' field is shown disabled")
	Execute "Set objPCP_CompletedDateTB = Nothing"	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Add/Edit mode -  Status = 'Not Started' then 'Completed Date' field should be disabled.
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown	
	blnStatus = selectComboBoxItem(objPCP_StatusDD, "Not Started")
	If not blnStatus Then
		strOutErrorDesc = "Unable to select status from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as 'Not Started'")
	Wait 0,250
	
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If not objPCP_CompletedDateTB.Object.isDisabled Then
		strOutErrorDesc = "In Add/Edit mode, when Status = 'Not Started', 'Completed Date' field is shown enabled"
		Exit Function
	End If
	Call WriteToLog("Pass","In Add/Edit mode, when Status = 'Not Started', 'Completed Date' field is shown disabled")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Add/Edit mode -  Status = 'Cancelled' then 'Completed Date' field should be enabled.
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown	
	blnStatus = selectComboBoxItem(objPCP_StatusDD, "Cancelled")
	If not blnStatus Then
		strOutErrorDesc = "Unable to select status from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as 'Cancelled'")
	Wait 0,250
	
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If objPCP_CompletedDateTB.Object.isDisabled Then
		strOutErrorDesc = "In Add/Edit mode, when Status = 'Cancelled', 'Completed Date' field is shown disabled"
		Exit Function
	End If
	Call WriteToLog("Pass","In Add/Edit mode, when Status = 'Cancelled', 'Completed Date' field is shown enabled")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Add/Edit mode -  Status = 'Met' then 'Completed Date' field should be enabled.
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown	
	blnStatus = selectComboBoxItem(objPCP_StatusDD, "Met")
	If not blnStatus Then
		strOutErrorDesc = "Unable to select status from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as 'Met'")
	Wait 0,250
	
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If objPCP_CompletedDateTB.Object.isDisabled Then
		strOutErrorDesc = "In Add/Edit mode, when Status = 'Met', 'Completed Date' field is shown disabled"
		Exit Function
	End If
	Call WriteToLog("Pass","In Add/Edit mode, when Status = 'Met', 'Completed Date' field is shown enabled")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Add/Edit mode -  Status = 'Partially Met' then 'Completed Date' field should be enabled.
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown	
	blnStatus = selectComboBoxItem(objPCP_StatusDD, "Partially Met")
	If not blnStatus Then
		strOutErrorDesc = "Unable to select status from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as 'Partially Met'")
	Wait 0,250
	
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If objPCP_CompletedDateTB.Object.isDisabled Then
		strOutErrorDesc = "In Add/Edit mode, when Status = 'Partially Met', 'Completed Date' field is shown disabled"
		Exit Function
	End If
	Call WriteToLog("Pass","In Add/Edit mode, when Status = 'Partially Met', 'Completed Date' field is shown enabled")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation - Add/Edit mode -  Status = 'Unmet' then 'Completed Date' field should be enabled.
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown	
	blnStatus = selectComboBoxItem(objPCP_StatusDD, "Unmet")
	If not blnStatus Then
		strOutErrorDesc = "Unable to select status from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as 'Unmet'")
	Wait 0,250
	
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If objPCP_CompletedDateTB.Object.isDisabled Then
		strOutErrorDesc = "In Add/Edit mode, when Status = 'Unmet', 'Completed Date' field is shown disabled"
		Exit Function
	End If
	Call WriteToLog("Pass","In Add/Edit mode, when Status = 'Unmet', 'Completed Date' field is shown enabled")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	Call WriteToLog("Pass","Validated Completed Date field status for Status variations")
	
	Wait 1
	Err.Clear
	PCP_CompletedDateFieldStatus = True
	
End Function
'----------------------------------------------------------------

Function PCP_LinkValidations(strOutErrorDesc)

	'Validation - Links in Patient Care Plan screen and their functionalities
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_LinkValidations = False
	
	Call WriteToLog("Info","--------Validation for 'Send Material' and 'Referral link's functionality in Patient Care Plan screen-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Send Materiallink functionality
	
	'Click on Send Material link
	Execute "Set objPCP_SendMaterialLink = "&Environment("WI_PCP_SendMaterialLink") 'PCP Send Material link
	objPCP_SendMaterialLink.highlight
	Err.Clear
	objPCP_SendMaterialLink.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on 'Send Material' link. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked 'Send Material' link")
	Execute "Set objPCP_SendMaterialLink = Nothing"
	Wait 1
	Call waitTillLoads("Loading...")
	
	'Validate navigation to Material Fulfillment screen
	Execute "Set objMaterialFulFillment_Title = "&Environment("WEL_MaterialFulFillment_Title") 'Material Fulfillment screen header
	If not objMaterialFulFillment_Title.Exist(10) Then
		strOutErrorDesc = "Unable to navigate to Material Fulfillment screen by clicking 'Send Material' link"
		Exit Function
	End If
	Call WriteToLog("Pass","Navigated to Material Fulfillment screen by clicking 'Send Material' link")
	Execute "Set objMaterialFulFillment_Title = Nothing"	
	Wait 1
	
	'Click Back to Patient Care Plan screen button
	Execute "Set objBackToPCP = "&Environment("WEL_BackToPCP") 'Back to Patient Care Plan screen button
	Err.Clear
	objBackToPCP.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on 'Back to Patient Care Plan' button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked 'Back to Patient Care Plan' button")
	Execute "Set objPCP_SendMaterialLink = Nothing"	
	Wait 1
	Call waitTillLoads("Loading...")
	
	'Validate PCP navigation
	Execute "Set objPCP_ScreenHeader = "&Environment("WT_PCP_ScrHeader") 'PatientCarePlan screen header
	If not objPCP_ScreenHeader.Exist(5) Then
		strOutErrorDesc = "Unable to navigate to Patient Care Plan screen"
		Exit Function
	End If
	objPCP_ScreenHeader.highlight
	Call WriteToLog("Pass","Navigated to Patient Care Plan screen")
	Execute "Set objPCP_ScreenHeader = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Referral link	functionality
	
	'Click Referral link
	Execute "Set objPCP_ReferralLink = "&Environment("WI_PCP_ReferralLink") 'PCP Referral link	
	objPCP_ReferralLink.highlight
	Err.Clear
	objPCP_ReferralLink.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on 'Referral' link. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked 'Referral' link")
	Execute "Set objPCP_ReferralLink = Nothing"
	Wait 1
	Call waitTillLoads("Loading...")	
	
	'Validate navigation to Referrals screen
	Execute "Set objReferralsHeader = "&Environment("WEL_ReferralsHeader") 'Referrals header
	If not objReferralsHeader.Exist(10) Then
		strOutErrorDesc = "Unable to navigate to Referrals screen by clicking 'Referrals' link"
		Exit Function
	End If
	Call WriteToLog("Pass","Navigated to Referrals screen by clicking 'Referrals' link")
	Execute "Set objReferralsHeader = Nothing"	
	Wait 1
	
	'Click Back to Patient Care Plan screen button
	Execute "Set objBackToPCP = "&Environment("WEL_BackToPCP") 'Back to Patient Care Plan screen button
	Err.Clear
	objBackToPCP.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on 'Back to Patient Care Plan' button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked 'Back to Patient Care Plan' button")
	Execute "Set objPCP_SendMaterialLink = Nothing"	
	Wait 1
	Call waitTillLoads("Loading...")
	
	'Validate PCP navigation
	Execute "Set objPCP_ScreenHeader = "&Environment("WT_PCP_ScrHeader") 'PatientCarePlan screen header
	If not objPCP_ScreenHeader.Exist(5) Then
		strOutErrorDesc = "Unable to navigate to Patient Care Plan screen"
		Exit Function
	End If
	objPCP_ScreenHeader.highlight
	Call WriteToLog("Pass","Navigated to Patient Care Plan screen")
	Execute "Set objPCP_ScreenHeader = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	Call WriteToLog("Pass","Validated for 'Send Material' and 'Referral link's functionality in Patient Care Plan screen")
	
	Wait 1
	Err.Clear
	PCP_LinkValidations = True
	
End Function
'----------------------------------------------------------------

Function PCP_PrepopulatedDateVaildations(strOutErrorDesc)
	
	'Validation - Prepopulation of Start date field (with sys date) and Due date filed (with date greater than sys date)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_PrepopulatedDateVaildations = False
	
	Call WriteToLog("Info","--------Validation - Prepopulation of Start date field (with sys date) and Due date filed (with date greater than sys date)-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation for Prepopulation of Start date field (with sys date) 
	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
	objPCP_StartDateTB.highlight
	dtStartDateExisting = ""
	dtStartDateExisting = CDate(Trim(objPCP_StartDateTB.GetROProperty("value")))
	If dtStartDateExisting <> Date Then
		strOutErrorDesc = "Start date field is not pre-populated with sys date"
		Exit Function
	End If
	Call WriteToLog("Pass","Start date field is pre-populated with sys date")
	Execute "Set objPCP_StartDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation for Prepopulation of Due date field (with date greater than sys date) 
	Execute "Set objPCP_DueDateTB = "&Environment("WE_PCP_DueDateFiled") 'PCP DueDate field
	objPCP_DueDateTB.highlight
	dtDueDateExisting = ""
	dtDueDateExisting = CDate(Trim(objPCP_DueDateTB.GetROProperty("value")))
	If DateDiff("d",dtDueDateExisting,Date) >= 0 Then
		strOutErrorDesc = "Due date field is not pre-populated with date greater than sys date"
		Exit Function
	End If
	Call WriteToLog("Pass","Due date field is pre-populated with date greater than sys date")
	Execute "Set objPCP_DueDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	Call WriteToLog("Pass","Validated prepopulation of Start date field (with sys date) and Due date filed (with date greater than sys date)")
	
	Wait 1
	Err.Clear
	PCP_PrepopulatedDateVaildations = True
	
End Function
'----------------------------------------------------------------

Function PCP_NewMember_AddMode(ByVal strPCPAddModeRequisites, strOutErrorDesc)

	'Validating Add mode for new member and scenarios related to buttons, dates and fileds
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_NewMember_AddMode = False
	
	Call WriteToLog("Info","--------Validating Add mode for new member and scenarios related to buttons, dates and fields-------")	
	
	'Sorting required values for respective fields
	strCarePlanTopic = Split(strPCPAddModeRequisites,",",-1,1)(0)
	strImportance = Split(strPCPAddModeRequisites,",",-1,1)(1)
	strConfidenceLevel = Split(strPCPAddModeRequisites,",",-1,1)(2)
	strStatus = Split(strPCPAddModeRequisites,",",-1,1)(3)
	strClinicalRelevance = Split(strPCPAddModeRequisites,",",-1,1)(4)
	strCarePlanName = Split(strPCPAddModeRequisites,",",-1,1)(5)
	strBehavioralPlan = Split(strPCPAddModeRequisites,",",-1,1)(6)
	strEngagementPlan = Split(strPCPAddModeRequisites,",",-1,1)(7)
	
	
	'------Status of Buttons
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For new member care plan Add button should not be available
	Execute "Set objPCP_AddBTN ="&Environment("WEL_PatCaPlnAdd") 'PCP Add button
	If objPCP_AddBTN.Exist(2) Then
		strOutErrorDesc = "Add button is available for new member"
		Exit Function
	End If
	Call WriteToLog("Pass","Add button is not available for new member")
	Execute "Set objPCP_AddBTN = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For new member care plan Save button should be disabled before providing field values
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	If not objPCP_SaveBTN.Object.isDisabled Then
		strOutErrorDesc = "Save button is enabled for new member before providing field values"
		Exit Function
	End If
	Call WriteToLog("Pass","Save button is disabled for new member before providing field values")
	Execute "Set objPCP_SaveBTN = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For new member care plan Cancel button should not be enabled before providing field values
	Execute "Set objPCP_CancelBTN ="&Environment("WEL_PCP_CancelBtn") 'PCP Cancel button
	If objPCP_CancelBTN.Object.isDisabled Then
		strOutErrorDesc = "Cancel button is disabled for new member before providing field values"
		Exit Function
	End If
	Call WriteToLog("Pass","Cancel button is enabled for new member before providing field values")
	Execute "Set objPCP_CancelBTN = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'------Status of Active Care Plan section
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For new member Active Care Plan section should be empty
	Execute "Set objPCP_CarePlanTable = "&Environment("WT_PCP_CarePlanTable") 'Care plan table
	If objPCP_CarePlanTable.Exist(2) Then
		strOutErrorDesc = "For new member Active Care Plan section is showing populated"
		Exit Function
	End If
	Call WriteToLog("Pass","For new member Active Care Plan section is empty")
	Execute "Set objPCP_CarePlanTable = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Start adding Patient Care plan
	
	'----------Status of Main fields
	
	'Select Care Plan Topic	
	Execute "Set objPCP_CarePlanTopicDD ="&Environment("WB_PatCaPlnTopic") 'PCP CarePlanTopic dropdown
	objPCP_CarePlanTopicDD.highlight
	blnCarePlanTopic = selectComboBoxItem(objPCP_CarePlanTopicDD, strCarePlanTopic)
	If not blnCarePlanTopic Then
		strOutErrorDesc = "Care Plan Topic is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Topic is selected as '"&strCarePlanTopic&"'")
	Execute "Set objPCP_CarePlanTopicDD = Nothing"
	Wait 1
	Call waitTillLoads("Loading...")
	
	'Select Importance
	Execute "Set objPCP_ImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 'PCP Importance drodown
	blnImportance = selectComboBoxItem(objPCP_ImportanceLevelDD, strImportance)
	If not blnImportance Then
		strOutErrorDesc = "Importance is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Importance is selected as '"&strImportance&"'")
	Execute "Set objPCP_ImportanceLevelDD = Nothing"
	Wait 0,250
	
	'Select Confidence Level 
	Execute "Set objPCP_ConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 'PCP Confidence level dropdown
	blnConfidenceLevel = selectComboBoxItem(objPCP_ConfidenceLevelDD, strConfidenceLevel)
	If not blnConfidenceLevel Then
		strOutErrorDesc = "Confidence Level is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Confidence Level is selected as '"&strConfidenceLevel&"'")
	Execute "Set objPCP_ConfidenceLevelDD = Nothing"	
	Wait 0,250
	
	'Select Status
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"		
	Wait 0,250
	
	'Select Clinical Relevance 
	Execute "Set objPCP_ClinicalRelevanceDD = "&Environment("WB_PatCaPlnClinicalRelvnDD") 'PCP ClinicalRelevance dropdown
	blnClinicalRelevance = selectComboBoxItem(objPCP_ClinicalRelevanceDD, strClinicalRelevance)
	If not blnClinicalRelevance Then
		strOutErrorDesc = "Clinical Relevance is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Clinical Relevance is selected as '"&strClinicalRelevance&"'")
	Execute "Set objPCP_ClinicalRelevanceDD = Nothing"	
	Wait 0,250
	
	'Set Care Plan Name 
	Execute "Set objPCP_CarePlanNameTB = "&Environment("WE_PatCaPlnName") 'PCP CarePlanName field	
	Err.Clear
	objPCP_CarePlanNameTB.Set strCarePlanName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Care Plan Name is not set "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Name is set as '"&strCarePlanName&"'")
	Execute "Set objPCP_CarePlanNameTB = Nothing"		
	Wait 0,250
	
	'Set Behavioral Plan 
	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
	Err.Clear
	objPCP_BehavioralPlanTB.Set strBehavioralPlan
	If Err.Number <> 0 Then
		strOutErrorDesc = "Behavioral Plan is not set. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Behavioral Plan is set as '"&strBehavioralPlan&"'")
	Execute "Set objPCP_BehavioralPlanTB = Nothing"		
	Wait 0,250
	
	'Set Engagement Plan 
	Execute "Set objPCP_EngagementPlanTB = "&Environment("WE_EngagementPlan") 'PCP Engagement plan field		
	Err.Clear
	objPCP_EngagementPlanTB.Set strEngagementPlan
	If Err.Number <> 0 Then
		strOutErrorDesc = "Engagement Plan is not set. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Engagement Plan is set as '"&strEngagementPlan&"'")
	Execute "Set objPCP_EngagementPlanTB = Nothing"		
	Wait 0,250	
	
	'Click Save button
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Save button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button for adding new Care Plan")
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate message box 'Please select a Barrier'
	blnMsg_Box = checkForPopup("Error", "Ok", "Please select a Barrier", strOutErrorDesc)
	If not blnMsg_Box Then
		strOutErrorDesc = "Unable to validate 'Please select a Barrier' message box. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Please select a Barrier' message box")
	
	'----------Status of Barriers
	
	Execute "Set objPCP_PoorHabits_BarrierCB = "&Environment("WEL_PCP_PoorHabits_BarrierCB") 'Poor Habits/Practices check box
	Err.Clear
	objPCP_PoorHabits_BarrierCB.Click
	Wait 0,100
	
	Execute "Set objPCP_KnowledgeDeficit_BarrierCB = "&Environment("WEL_PCP_KnowledgeDeficit_BarrierCB") 'Knowledge Deficit check box
	objPCP_KnowledgeDeficit_BarrierCB.Click
	Wait 0,100
	
	Execute "Set objPCP_EquipmentIssue_BarrierCB = "&Environment("WEL_PCP_EquipmentIssue_BarrierCB") 'Equipment Issue check box
	objPCP_EquipmentIssue_BarrierCB.Click	
	Wait 0,100
	
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to select barriers. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Required barriers are selected")
	
	Execute "Set objPCP_PoorHabits_BarrierCB = Nothing"
	Execute "Set objPCP_KnowledgeDeficit_BarrierCB = Nothing"
	Execute "Set objPCP_EquipmentIssue_BarrierCB = Nothing"	
	Wait 0,100
	
	'----------Status of Survey questions
	
	'Click Save button
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Save button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button for adding new Care Plan")
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate message box 'Please select responses and freeform for all questions'
	blnMsg_Box = checkForPopup("Error", "Ok", "Please select responses and freeform for all questions", strOutErrorDesc)
	If not blnMsg_Box Then
		strOutErrorDesc = "Unable to validate 'Please select responses and freeform for all questions' message box. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Please select a Barrier' message box")
	
	'provide survey
	blnPCP_GetSurvey = PCP_GetSurvey("Yes","freeform",strOutErrorDesc)
'	blnPCP_GetSurvey = PCP_GetSurvey("CAREPLANGOAL","freeform",strOutErrorDesc)
	If not blnPCP_GetSurvey Then
		strOutErrorDesc = "Unable to select survey option and set free form values. "&strOutErrorDesc
		Exit Function
	End If	
	Call WriteToLog("Pass","Validated survey qestions and freeform text boxes")
	
	'----------Status of Save button status after providing values
	
	'For new member care plan Save button should be enabled after providing field values
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	If objPCP_SaveBTN.Object.isDisabled Then
		strOutErrorDesc = "Save button is disabled for new member after providing field values"
		Exit Function
	End If
	Call WriteToLog("Pass","Save button is enabled for new member after providing field values")
	Execute "Set objPCP_SaveBTN = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	Call WriteToLog("Pass","Validated Add mode for new member and scenarios related to buttons, dates and fields")
	
	Wait 1
	Err.Clear	
	PCP_NewMember_AddMode = True
	
End Function
'----------------------------------------------------------------

Function PCP_StatusFieldValidations(strOutErrorDesc)

	'Validating Status field scenarios
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_StatusFieldValidations = False
	
	Call WriteToLog("Info","--------Validating Status field scenarios-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'In Add mode, select Status as 'Cancelled' - Error msgbox with message 'Goal Status should be In Progress OR Not Started' should be displayed
	
	strStatus = "Cancelled"
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	objPCP_StatusDD.highlight
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"		
	Wait 1
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"

	'Validate error message box with text 'Goal Status should be In Progress OR Not Started'
	blnAddModeStatus_Cancelled = checkForPopup("Error", "Ok", "Goal Status should be In Progress OR Not Started", strOutErrorDesc)
	If not blnAddModeStatus_Cancelled Then
		strOutErrorDesc = "Unable to validate error message box with text 'Goal Status should be In Progress OR Not Started' while selecting Cancelled option for Status. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message box with text 'Goal Status should be In Progress OR Not Started' while selecting Cancelled option for Status")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'In Add mode, select Status as 'Met' - Error msgbox with message 'Goal Status should be In Progress OR Not Started' should be displayed
	
	strStatus = "Met"
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"		
	Wait 1
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"

	'Validate error message box with text 'Goal Status should be In Progress OR Not Started'
	blnAddModeStatus_Met = checkForPopup("Error", "Ok", "Goal Status should be In Progress OR Not Started", strOutErrorDesc)
	If not blnAddModeStatus_Met Then
		strOutErrorDesc = "Unable to validate error message box with text 'Goal Status should be In Progress OR Not Started' while selecting Met option for Status. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message box with text 'Goal Status should be In Progress OR Not Started' while selecting Met option for Status")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'In Add mode, select Status as 'Partially Met' - Error msgbox with message 'Goal Status should be In Progress OR Not Started' should be displayed
	
	strStatus = "Partially Met"
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"		
	Wait 1
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"

	'Validate error message box with text 'Goal Status should be In Progress OR Not Started'
	blnAddModeStatus_PartiallyMet = checkForPopup("Error", "Ok", "Goal Status should be In Progress OR Not Started", strOutErrorDesc)
	If not blnAddModeStatus_PartiallyMet Then
		strOutErrorDesc = "Unable to validate error message box with text 'Goal Status should be In Progress OR Not Started' while selecting Partially Met option for Status. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message box with text 'Goal Status should be In Progress OR Not Started' while selecting Partially Met option for Status")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'In Add mode, select Status as 'Unmet' - Error msgbox with message 'Goal Status should be In Progress OR Not Started' should be displayed
	
	strStatus = "Unmet"
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"		
	Wait 1
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"

	'Validate error message box with text 'Goal Status should be In Progress OR Not Started'
	blnAddModeStatus_Unmet = checkForPopup("Error", "Ok", "Goal Status should be In Progress OR Not Started", strOutErrorDesc)
	If not blnAddModeStatus_Unmet Then
		strOutErrorDesc = "Unable to validate error message box with text 'Goal Status should be In Progress OR Not Started' while selecting Unmet option for Status. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated error message box with text 'Goal Status should be In Progress OR Not Started' while selecting Unmet option for Status")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------	

	'Select valid status (In Progress)
	strStatus = "In Progress"
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"	

	Call WriteToLog("Pass","Validated Status field scenarios")

	Wait 1
	Err.Clear
	PCP_StatusFieldValidations = True
	
	
End Function
'----------------------------------------------------------------

Function PCP_StartDateValidations(strOutErrorDesc)

	'Validating Start Date scenarios
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_StartDateValidations = False
	
	Call WriteToLog("Info","--------Validating Start Date scenarios-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate 'Invalid Data msg box with msg 'StartDate cannot be older than 7 days from today's date and cannot be greater than today's date' 
	'when start date is selected as date older than 7 days from sys date

	'Set Start date to a date which is older than 7 days from sys date
	dtSatrtDate = DateAdd("d",-10,Date)
	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
	Err.Clear	
	objPCP_StartDateTB.Set dtSatrtDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Start Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Start date is set to '"&dtSatrtDate&"' which is older than 7 days from sys date")
	Execute "Set objPCP_StartDateTB = Nothing"
	Wait 0,500
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"
	Wait 3
	Call waitTillLoads("Loading...")
	
	'Validate Invalid Data msg box with msg 'StartDate cannot be older than 7 days from today's date and cannot be greater than today's date'
	blnStartDateOlderThan7days = checkForPopup("Invalid Data", "Ok", "'StartDate' cannot be older than 7 days from today's date and cannot be greater than today's date.", strOutErrorDesc)
	If not blnStartDateOlderThan7days Then
		strOutErrorDesc = "Unable to validate Invalid Data msg box with msg 'StartDate cannot be older than 7 days from today's date and cannot be greater than today's date' while selecting start date older than 7 days from sys date. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated Invalid Data msg box with msg 'StartDate cannot be older than 7 days from today's date and cannot be greater than today's date' while selecting start date older than 7 days from sys date")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate 'Invalid Data msg box with msg 'Start Date can not be in future' when start date is selected as date greater than sys date

	'Set Start date to a date which is greater than sys date
	dtSatrtDate = DateAdd("d",2,Date)
	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
	Err.Clear	
	objPCP_StartDateTB.Set dtSatrtDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Start Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Start date is set to '"&dtSatrtDate&"' which is greater than sys date")
	Execute "Set objPCP_StartDateTB = Nothing"
	Wait 0,500
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"
	Wait 3
	Call waitTillLoads("Loading...")
	
	'Validate 'Invalid Data msg box with msg 'Start Date can not be in future'
	blnStartDateGreaterThanSysDate = checkForPopup("Invalid Data", "Ok", "Start Date can not be in future", strOutErrorDesc)
	If not blnStartDateGreaterThanSysDate Then
		strOutErrorDesc = "Unable to validate Invalid Data msg box with msg 'Start Date can not be in future' while selecting start date greater than sys date. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated Invalid Data msg box with msg 'Start Date can not be in future' while selecting start date greater than sys date")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'Select valid date for start date
	dtSatrtDate = Date
	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
	Err.Clear	
	objPCP_StartDateTB.Set dtSatrtDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Start Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Start date is set to '"&dtSatrtDate&"'")
	Execute "Set objPCP_StartDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	Call WriteToLog("Pass","Validated Start Date scenarios")
	
	Wait 1
	Err.Clear
	PCP_StartDateValidations = True	

End Function

Function PCP_DueDateValidations(strOutErrorDesc)

	'Validating Due Date scenarios
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_DueDateValidations = False
	
	Call WriteToLog("Info","--------Validating Due Date scenarios-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate 'Invalid Data msg box with msg 'Field 'DueDate' of 'ptGoal' entity should be set to ' today or future date' for this operation' 
	'when due date is selected as date older than sys date

	'Set Due date to a date which is older than sys date
	dtDueDate = DateAdd("d",-10,Date)
	Execute "Set objPCP_DueDateTB = "&Environment("WE_PCP_DueDateFiled") 'PCP DueDate field
	Err.Clear	
	objPCP_DueDateTB.Set dtDueDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Due Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Due date is set to '"&dtDueDate&"' which is older than sys date")
	Execute "Set objPCP_DueDateTB = Nothing"
	Wait 0,500
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"
	Wait 3
	Call waitTillLoads("Loading...")
	
	'Validate Invalid Data msg box with msg 'Field 'DueDate' of 'ptGoal' entity should be set to ' today or future date' for this operation'
	blnDueDateOlderThanSysDate = checkForPopup("Invalid Data", "Ok", "Field 'DueDate' of 'ptGoal' entity should be set to ' today or future date' for this operation", strOutErrorDesc)
	If not blnDueDateOlderThanSysDate Then
		strOutErrorDesc = "Unable to validate Invalid Data msg box with msg 'Field 'DueDate' of 'ptGoal' entity should be set to ' today or future date' for this operation' while selecting due date older than sys date. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated Invalid Data msg box with msg 'Field 'DueDate' of 'ptGoal' entity should be set to ' today or future date' for this operation' while selecting due date older than sys date")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'Select valid date for due date
	dtDueDate = Date
	Execute "Set objPCP_DueDateTB = "&Environment("WE_PCP_DueDateFiled") 'PCP DueDate field
	Err.Clear	
	objPCP_DueDateTB.Set dtDueDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Due Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Due date is set to '"&dtDueDate&"'")
	Execute "Set objPCP_DueDateTB = Nothing"	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	Call WriteToLog("Pass","Validated Due Date scenarios")
	
	Wait 1
	Err.Clear
	PCP_DueDateValidations = True		
	
End Function
'----------------------------------------------------------------

Function PCP_BarriersAndFreeFormTextValidations(strOutErrorDesc)

	'Validating Barriers and Free-Form text scenarios
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_BarriersAndFreeFormTextValidations = False
	
	Call WriteToLog("Info","--------Validating Barriers and Free-Form text scenarios-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate 'Error msg box with msg 'Free-Form is required when "Other" option from barrier is selected' 
	'when 'Other' is selected as barrier and not provided the free-form text
	
	'Click Other barrier check box
	Execute "Set objPCP_Other_BarrierCB = "&Environment("WEL_PCP_Other_BarrierCB") 'Other check box
	objPCP_Other_BarrierCB.highlight
	Err.Clear
	objPCP_Other_BarrierCB.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to find check Other barrier check box in Patient Care Plan screen. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Checked Other barrier check box in Patient Care Plan screen")
	Execute "Set objPCP_Other_BarrierCB = Nothing"	

	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"
	Wait 3
	Call waitTillLoads("Loading...")
	
	'Validate message box with text 'Free-Form is required when "Other" option from barrier is selected'
	blnBarrier_Other = checkForPopup("Error", "Ok", "Free-Form is required", strOutErrorDesc)
	If not blnBarrier_Other Then
		strOutErrorDesc = "Unable to validate 'Free-Form is required when 'Other' option from barrier is selected' message box. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Free-Form is required when 'Other' option from barrier is selected' message box")
	Wait 1	

	'Set free-form text for Other barrier field
	Execute "Set objPCP_OtherTB_BarrierTB = "&Environment("WE_PCP_OtherTB_BarrierTB") 'Other field
	Err.Clear
	objPCP_OtherTB_BarrierTB.Set "Barrier"
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set value for Other barrier field in Patient Care Plan screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Free-form text for Other barrier field is set")
	Execute "Set objPCP_OtherTB_BarrierTB = Nothing"
	Wait 0,500
	
	Wait 1
	Err.Clear
	PCP_BarriersAndFreeFormTextValidations = True		
		
End Function
'----------------------------------------------------------------

Function PCP_OtherScreenNavigationValidation(strOutErrorDesc)

	'Validating message when navigating to other screen without saving care plan
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_OtherScreenNavigationValidation = False
	
	Call WriteToLog("Info","--------Validating message when navigating to other screen without saving care plan-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate 'Msg box with text 'Your current changes will be lost. Do you want to continue ?' when tried to navigate to other screen without saving care plan
	
	'Click on Referrals menu
	Execute "Set objReferralsTab = "&Environment("WL_ReferralsTab") 'Referrals menu
	Err.Clear
	objReferralsTab.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Referrals menu. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Referals menu is clicked")
	Execute "Set objReferralsTab = Nothing"
	Wait 2
	
	'Validate 'Msg box with text 'Your current changes will be lost. Do you want to continue ?'
	blnMessageNavigation = clickOnMessageBox("Patient Care Plan", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnMessageNavigation Then
		strOutErrorDesc = "Unable to validate 'Your current changes will be lost. Do you want to continue ?' message box. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Your current changes will be lost. Do you want to continue ?' message box when tried to navigate to other screen without saving care plan")
	'---------------------------------------------------------------------------------------------------------------------------------------------------
		
	Wait 1	
	Err.Clear
	PCP_OtherScreenNavigationValidation = True
	
End Function
'----------------------------------------------------------------

Function PCP_CancelButtonFunctionality(strOutErrorDesc)

	'Validating Cancel button functionality
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_CancelButtonFunctionality = False
	
	Call WriteToLog("Info","--------Validating Cancel button functionality-------")
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate Cancel - choose No option in cancel msg box - Field values should be preserved
	
	'Click Cancel button
	Execute "Set objPCP_CancelBTN ="&Environment("WEL_PCP_CancelBtn") 'PCP Cancel button
	objPCP_CancelBTN.highlight
	Err.clear
	objPCP_CancelBTN.Click	
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Cancel button ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Cancel button is clicked")
	Execute "Set objPCP_CancelBTN = Nothing"
	Wait 2
	
	'Validate message box with text 'Your current changes will be lost. Do you want to continue?' and select No option
	blnCancel_No = clickOnMessageBox("Patient Care Plan", "No", "Your current changes will be lost. Do you want to continue?", strOutErrorDesc)
	If not blnCancel_No Then
		strOutErrorDesc = "Unable to validate 'Your current changes will be lost. Do you want to continue?' message box while clicking Cancel button. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Your current changes will be lost. Do you want to continue?' message box while clicking Cancel button and seleted No option")
	Wait 1
	
	'Validate - whether values are preserved on selecting No option for Cancel (validating with Care Plan Name , Behavioral Plan, Engagement Plan  values)
	Execute "Set objPCP_CarePlanNameTB = "&Environment("WE_PatCaPlnName") 'PCP CarePlanName field	
	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
	Execute "Set objPCP_EngagementPlanTB = "&Environment("WE_EngagementPlan") 'PCP Engagement plan field
	
	strCarePlanName = objPCP_CarePlanNameTB.GetROProperty("value")
	strBehavioralPlan = objPCP_BehavioralPlanTB.GetROProperty("value")
	strEngagementPlan = objPCP_EngagementPlanTB.GetROProperty("value")
	If strCarePlanName = "" OR strBehavioralPlan = "" OR strEngagementPlan = "" Then
		strOutErrorDesc = "Values are not preserved when selected No option for Cancel"
		Exit Function
	End If
	Call WriteToLog("Pass","Values are preserved when selected No option for Cancel")
	
	Execute "Set objPCP_CarePlanNameTB = Nothing"
	Execute "Set objPCP_BehavioralPlanTB = Nothing"
	Execute "Set objPCP_EngagementPlanTB = Nothing"
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate Cancel - choose Yes option in cancel msg box - Field values should be cleared
	
	'Click Cancel button
	Execute "Set objPCP_CancelBTN ="&Environment("WEL_PCP_CancelBtn") 'PCP Cancel button
	Err.clear
	objPCP_CancelBTN.Click	
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Cancel button ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Cancel button is clicked")
	Execute "Set objPCP_CancelBTN = Nothing"
	Wait 2
	
	'Validate message box with text 'Your current changes will be lost. Do you want to continue?' and select Yes option
	blnCancel_Yes = clickOnMessageBox("Patient Care Plan", "Yes", "Your current changes will be lost. Do you want to continue?", strOutErrorDesc)
	If not blnCancel_Yes Then
		strOutErrorDesc = "Unable to validate 'Your current changes will be lost. Do you want to continue?' message box while clicking Cancel button. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Your current changes will be lost. Do you want to continue?' message box while clicking Cancel button and seleted Yes option")
	Wait 1
	
	'Validate - whether values are cleared on selecting Yes option for Cancel (validating with Care Plan Name , Behavioral Plan, Engagement Plan  values)
	Execute "Set objPCP_CarePlanNameTB = "&Environment("WE_PatCaPlnName") 'PCP CarePlanName field	
	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
	Execute "Set objPCP_EngagementPlanTB = "&Environment("WE_EngagementPlan") 'PCP Engagement plan field
	
	strCarePlanName = objPCP_CarePlanNameTB.GetROProperty("value")
	strBehavioralPlan = objPCP_BehavioralPlanTB.GetROProperty("value")
	strEngagementPlan = objPCP_EngagementPlanTB.GetROProperty("value")
	If strCarePlanName <> "" AND strBehavioralPlan <> "" AND strEngagementPlan <> "" Then
		strOutErrorDesc = "Values are not cleared when selected Yes option for Cancel"
		Exit Function
	End If
	Call WriteToLog("Pass","Values are cleared when selected Yes option for Cancel")
	
	Execute "Set objPCP_CarePlanNameTB = Nothing"
	Execute "Set objPCP_BehavioralPlanTB = Nothing"
	Execute "Set objPCP_EngagementPlanTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	Call WriteToLog("Pass","Validated Cancel button functionality")

	Wait 1	
	Err.Clear
	PCP_CancelButtonFunctionality = True
	
End Function
'----------------------------------------------------------------

Function PCP_GoalsSectionBeforeAddingPCP(strOutErrorDesc)

	'Validating Goals section before adding Patient care plan
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_GoalsSectionBeforeAddingPCP = False
	
	Call WriteToLog("Info","--------Validating Goals section before adding Patient care plan-------")
	
	'Click on Patient Snapshot tab
	Execute "Set objPatientSnapshotTab = "&Environment("WL_PatientSnapshotTab")
	Err.Clear
	objPatientSnapshotTab.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Patient Snapshot tab. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Patient Snapshot tab")
	Execute "Set objPatientSnapshotTab = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate 'This patient has no goals defined' text is not available under Goals section of Patient Snapshot screen before adding Care plan
	Execute "Set objPatientSnapshot_NoGoalsDefined = "&Environment("WEL_PatientSnapshot_NoGoalsDefined")
	If not objPatientSnapshot_NoGoalsDefined.Exist(2) Then
		strOutErrorDesc = "'This patient has no goals defined' is not available under Goals section of Patient Snapshot screen before adding Care plan. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","'This patient has no goals defined' is available under Goals section of Patient Snapshot screen before adding Care plan")
	Execute "Set objPatientSnapshot_NoGoalsDefined = Nothing"

	Call WriteToLog("Pass","Validated Goals section of Patient Care Plan screen before adding Patient care plan")

	Wait 1	
	Err.Clear
	PCP_GoalsSectionBeforeAddingPCP = True		
		
	'-----------------------------------------
	'Navigate back to Patient Care Plan screen
	blnPCP_ScreenNavigation = PCP_ScreenNavigation(strOutErrorDesc)
	If not blnPCP_ScreenNavigation Then 
		Exit Function
	End If	
	'-----------------------------------------
	
End Function
'----------------------------------------------------------------

Function PCP_CompletedDateScenario(ByVal strStatus, ByVal dtCompletedDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_CompletedDateScenario = False
	
	'Click on edit button
	Execute "Set objPCP_EditBTN = "&Environment("WEL_EditCarePlanBtn") 'PCP Edit button
	Err.CLear
	objPCP_EditBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Edit button. "&Err.Description
		Exit Function
	End If 	
	Call WriteToLog("Pass","Clicked on Patient Care Plan Edit button")
	Execute "Set objPCP_EditBTN = Nothing"
	Wait 1
	Call waitTillLoads("Loading...")	
	
	'Select Status
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"		
	Wait 0,250
	
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	Err.Clear	
	objPCP_CompletedDateTB.Set dtCompletedDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Completed Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Completed date is set to '"&dtCompletedDate&"'")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	
	'Click Save button
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Save button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button for adding new Care Plan")
	Wait 1
	Call waitTillLoads("Loading...")
	
	'Validate message box 'Please select a Barrier'
	blnMsg_Box = checkForPopup("Error", "Ok", "Completed Date should not be less than Create Date", strOutErrorDesc)
	If not blnMsg_Box Then
		strOutErrorDesc = "Unable to validate 'Completed Date should not be less than Create Date' message box. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Completed Date should not be less than Create Date' message box")
	Wait 1
	
	'Click Cancel button
	Execute "Set objPCP_CancelBTN ="&Environment("WEL_PCP_CancelBtn") 'PCP Cancel button
	objPCP_CancelBTN.highlight
	Err.clear
	objPCP_CancelBTN.Click	
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Cancel button ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Cancel button is clicked")
	Execute "Set objPCP_CancelBTN = Nothing"
	Wait 2
	
	'Validate message box with text 'Your current changes will be lost. Do you want to continue?' and select No option
	blnCancel_No = clickOnMessageBox("Patient Care Plan", "Yes", "Your current changes will be lost. Do you want to continue?", strOutErrorDesc)
	If not blnCancel_No Then
		strOutErrorDesc = "Unable to validate 'Your current changes will be lost. Do you want to continue?' message box while clicking Cancel button. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Your current changes will be lost. Do you want to continue?' message box while clicking Cancel button and seleted No option")
	Wait 1
	
	PCP_CompletedDateScenario = True
	
End Function

Function PCP_ActiveCarePlanSectionAfterAddingPCP(ByVal strACPvalues, ByVal dtDueDate, strOutErrorDesc)

	'Validate impact on Active Care Plan section after saving Care Plan

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_ActiveCarePlanSectionAfterAddingPCP = False
	
	Call WriteToLog("Info","--------Validate - After adding care plan, Active Care Plan section is available and is having required sections, and also validate all the populated fileds-------")
	
	Execute "Set objPCP_CarePlanTable = "&Environment("WT_PCP_CarePlanTable") 'Care plan table
	intCarePlanTopicRC = ""
	intCarePlanTopicRC = objPCP_CarePlanTable.RowCount
	
	'Validate Active Care Plan section is available after adding care plan to the patient
	If not objPCP_CarePlanTable.Exist(2) Then
		strOutErrorDesc = "After adding CarePlan, Active Care Plan section is not available"
		Exit Function
	End If 
	objPCP_CarePlanTable.highlight
	Call WriteToLog("Pass","After adding CarePlan, After adding CarePlan, Active Care Plan section is available")
	
	'Validate over due icon if care plan is added with due date >, =, <  sys date
	blnPCP_DueIcon = PCP_DueIcon()
	If DateDiff("d",dtDueDate,Date) >= 0 Then
		If not blnPCP_DueIcon Then
			strOutErrorDesc = "After adding CarePlan with due date eual to sys date, over due icon is not present in Active Care Plan table"
			Exit Function
		End If 
		Call WriteToLog("Pass","After adding CarePlan with due date eual/less than to sys date, over due icon is present in Active Care Plan table")
	ElseIf DateDiff("d",dtDueDate,Date) < 0 Then
		If blnPCP_DueIcon Then
			strOutErrorDesc = "After adding CarePlan with due date less than sys date, over due icon is present in Active Care Plan table"
			Exit Function
		End If 
		Call WriteToLog("Pass","After adding CarePlan with due date less than sys date, over due icon is not present in Active Care Plan table")
	End If
	
	'Validate care plan details are added to the Active Care Plan section
	If intCarePlanTopicRC = 0 Then
		strOutErrorDesc = "After adding CarePlan, Active Care Plan section is not populated with provided values"
		Exit Function
	End If 
	Call WriteToLog("Pass","After adding CarePlan, Active Care Plan section is having CarePlanTopic, ClinicalRelevance, Due date, Status sections")
	
	'Validate each data in the Active Care Plan section	
	strProvidedCarePlanTopic = Split(strACPvalues,",",-1,1)(0)
	strProvidedClinicalRelevance = Split(strACPvalues,",",-1,1)(1)
	dtProvidedDueDate = DateFormat(dtDueDate)
	strProvidedStatus = Split(strACPvalues,",",-1,1)(2)

	'--GetCellData(1,2)  '1 is the 1st row in ActiveCarePlan section. After adding care plan for a new patient, only 1 row will be available in ActiveCarePlan section
	strAddedCarePlanTopic = objPCP_CarePlanTable.GetCellData(1,2) '2 is the column number for CarePlanTopic in CarePlan table
	strAddedClinicalRelevance = objPCP_CarePlanTable.GetCellData(1,3) '3 is the column number for ClinicalRelevance in CarePlan table
	dtAddedDueDate = objPCP_CarePlanTable.GetCellData(1,4) '4 is the column number for DueDate in CarePlan table
	strAddedStatus = objPCP_CarePlanTable.GetCellData(1,5) '5 is the column number for Status in CarePlan table
	
	'Validate 'Care Plan Topic' value in Active Care Plan section
	If Instr(1,LCase(Trim(Replace(strAddedCarePlanTopic," ","",1,-1,1))),LCase(Trim(Replace(strProvidedCarePlanTopic," ","",1,-1,1))),1) <= 0 Then
		strOutErrorDesc = "After adding CarePlan, Active Care Plan section is not populated with Care Plan Topic"
		Exit Function
	End If 
	Call WriteToLog("Pass","After adding CarePlan, Active Care Plan section is populated with Care Plan Topic")
	
	'Validate 'Clinical Relevance' value in Active Care Plan section
	If Instr(1,LCase(Trim(Replace(strAddedClinicalRelevance," ","",1,-1,1))),LCase(Trim(Replace(strProvidedClinicalRelevance," ","",1,-1,1))),1) <= 0 Then
		strOutErrorDesc = "After adding CarePlan, Active Care Plan section is not populated with Clinical Relevance"
		Exit Function
	End If 
	Call WriteToLog("Pass","After adding CarePlan, Active Care Plan section is populated with Clinical Relevance")
	
	'Validate 'Due date' value in Active Care Plan section
	If Instr(1,Trim(Replace(dtAddedDueDate," ","",1,-1,1)),Trim(Replace(dtProvidedDueDate," ","",1,-1,1)),1) <= 0 Then
		strOutErrorDesc = "After adding CarePlan, Active Care Plan section is not populated with Due date"
		Exit Function
	End If 
	Call WriteToLog("Pass","After adding CarePlan, Active Care Plan section is populated with Due date")
	
	'Validate 'Status' value in Active Care Plan section
	If Instr(1,LCase(Trim(Replace(strAddedStatus," ","",1,-1,1))),LCase(Trim(Replace(strProvidedStatus," ","",1,-1,1))),1) <= 0 Then
		strOutErrorDesc = "After adding CarePlan, Active Care Plan section is not populated with Status"
		Exit Function
	End If 
	Call WriteToLog("Pass","After adding CarePlan, Active Care Plan section is populated with Status - "&strStatus)

	Execute "Set objPCP_CarePlanTable = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	Wait 1	
	Err.Clear
	PCP_ActiveCarePlanSectionAfterAddingPCP = True
	
End Function

Function PCP_OpenTray_Impact(strOutErrorDesc)

	'Validate impact on Open Patient tray after saving Care Plan

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_OpenTray_Impact = False
	
	Call WriteToLog("Info","--------Validate impact on Open Patient Tray after saving Care Plan-------")
	
	'Validate - After adding Care plan to a new patient one more browsing icon should be visible in Open Patient Tray	
	Set oDescBI = Description.Create
	oDescBI("micclass").Value = "WebElement"
	oDescBI("class").Value = ".*binoculars recap-contact-footer-small-icon.*"	
	oDescBI("class").RegularExpression = True
	oDescBI("html tag").Value = "SPAN"
	oDescBI("visible").Value = True
	
	Set objBrowsingIcons = getPageObject().ChildObjects(oDescBI)
	intBIcount = objBrowsingIcons.Count
	
	'After adding Care plan to a new patient one more browsing icon should be visible in Open Patient Tray
	If intBIcount <> 2 Then
		strOutErrorDesc = "After saving Care plan for the new patient, browsing icons are not visible in Open Patient Tray"
		Exit Function
	End If
	Call WriteToLog("Pass","After saving Care plan for the new patient, browsing icons are visible in Open Patient Tray")
	
	Set oDescBI = Nothing
	Set objBrowsingIcons = Nothing
	
	Call WriteToLog("Pass","Validated impact on Open Patient Tray after saving Care Plan")
	
	Wait 1	
	Err.Clear
	PCP_OpenTray_Impact = True
	
End Function

Function PCP_Add_RecapScreen_Impact(ByVal strRecapValues, ByVal dtStartDate, ByVal strBarrierValues, strOutErrorDesc)

	'Validate impact on Recap screen after saving Care Plan
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_Add_RecapScreen_Impact = False

	Call WriteToLog("Info","--------Validate impact on Recap screen after saving Care Plan-------")
	
	'Validate - After saving Care plan to patient, Recap screen should get populated with Care Plan details
	
	'Click on browsing icon in Open Patient Tray
	Set oDescBI = Description.Create
	oDescBI("micclass").Value = "WebElement"
	oDescBI("class").Value = ".*binoculars recap-contact-footer-small-icon.*"	
	oDescBI("class").RegularExpression = True
	oDescBI("html tag").Value = "SPAN"
	oDescBI("visible").Value = True
	
	Set objBrowsingIcons = getPageObject().ChildObjects(oDescBI)
	Err.Clear
	objBrowsingIcons(0).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on browsing icon in Open Patient tray. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked on browsing icon in Open Patient tray")
	Set oDescBI = Nothing
	Set objBrowsingIcons = Nothing
	Wait 1
	
	'Check that Recap screen is available after clicking on browsing icon in Open Patient tray
	Execute "Set objRecapTitle = "&Environment("WEL_CM_RecapTitle") 'Recap screen header
	If not objRecapTitle.Exist(5) Then
		strOutErrorDesc = "Recap screen is not available after clicking on browsing icon in Open Patient tray"
		Exit Function
	End If
	Call WriteToLog("Pass","Recap screen is available after clicking on browsing icon in Open Patient tray")
	Execute "Set objRecapTitle = Nothing"
	
	'Validate existence of 'Member Care Plan' header in Note section of Recap screen after saving care plan
	Execute "Set objRecap_PCPheader = " & Environment("WEL_Recap_PCPheader")
	If not objRecap_PCPheader.Exist(2) Then
		strOutErrorDesc = "'Member Care Plan' header is not existing in Note section of Recap screen after saving care plan"
		Exit Function
	End If
	objRecap_PCPheader.highlight
	Call WriteToLog("Pass","'Member Care Plan' header is not existing in Note section of Recap screen after saving care plan")
	Execute "Set objRecap_PCPheader = Nothing"
	
	'Sorting required values for respective fields 
	strCarePlanTopic = Split(strRecapValues,",",-1,1)(0)
	strClinicalRelevance = Split(strRecapValues,",",-1,1)(1)
	strImportance = Split(strRecapValues,",",-1,1)(3)
	strConfidenceLevel = Split(strRecapValues,",",-1,1)(4)
	strCarePlanName = Split(strRecapValues,",",-1,1)(5)
	strBehavioralPlan = Split(strRecapValues,",",-1,1)(6)
	dtStartDate = DateFormat(dtStartDate)
	
	'Get the Note details in Recap screen for the newly added Patient Care plan
	'index: = 1  points to the 2nd Note section in Recap screen which is having the Patient Care Plan details
	Set objNote = getPageObject().WebEdit("html tag:=TEXTAREA","name:=WebEdit","outerhtml:=.*recap-textbox.*","type:=textarea","visible:=True","index:=1")
	Err.Clear
	objNote.highlight
	strRecapScr_Note_PCPdetails = ""
	strRecapScr_Note_PCPdetails = objNote.GetROProperty("value")
	
	'Validate 'Start date' value in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,dtStartDate,1) <= 0 Then
		strOutErrorDesc = "Start date'"&dtStartDate&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If 
	Call WriteToLog("Pass","Start date'"&dtStartDate&"' is displayed in Note section of Recap screen")
	
	'Validate CarePlanTopic	in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strCarePlanTopic,1) <= 0 Then
		strOutErrorDesc = "Care Plan Topic '"&strCarePlanTopic&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Topic '"&strCarePlanTopic&"' is displayed in Note section of Recap screen")
	
	'Validate ClinicalRelevance	in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strClinicalRelevance,1) <= 0 Then
		strOutErrorDesc = "Clinical Relevance '"&strClinicalRelevance&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Clinical Relevance '"&strClinicalRelevance&"' is displayed in Note section of Recap screen")
	
	'Validate CarePlanName in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strCarePlanName,1) <= 0 Then
		strOutErrorDesc = "Care Plan Name '"&strCarePlanName&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Name '"&strCarePlanName&"' is displayed in Note section of Recap screen")
	
	'Validate Importance in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strImportance,1) <= 0 Then
		strOutErrorDesc = "Importance '"&strImportance&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Importance '"&strImportance&"' is displayed in Note section of Recap screen")
	
	'Validate ConfidenceLevel in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strConfidenceLevel,1) <= 0 Then
		strOutErrorDesc = "Confidence Level '"&strConfidenceLevel&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Confidence Level '"&strConfidenceLevel&"' is displayed in Note section of Recap screen")
	
	'Validate BehavioralPlan in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strBehavioralPlan,1) <= 0 Then
		strOutErrorDesc = "Behavioral Plan '"&strBehavioralPlan&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Behavioral 	Plan '"&strBehavioralPlan&"' is displayed in Note section of Recap screen")
	
	'Validate Barriers in note section of Recap screen
	strBarriers = GetReplacedString(strBarrierValues,"","","")
	strRecapScr_Note_PCPdetails_Barrier = GetReplacedString(strRecapScr_Note_PCPdetails,"","","")
	If Instr(1,strRecapScr_Note_PCPdetails_Barrier,strBarriers,1) <= 0 Then
		strOutErrorDesc = "Barriers are not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Barriers are displayed in Note section of Recap screen")
		
	Call WriteToLog("Pass","Validated impact on Recap screen after saving Care Plan")

	Wait 1	
	Err.Clear
	PCP_Add_RecapScreen_Impact = True
	
End Function

Function PCP_Goals_Impact(ByVal strGoalValues, ByVal dtStartDate, ByVal dtDueDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_Goals_Impact = False
	
	Call WriteToLog("Info","--------Validate impact on Goals section of Patient Snapshot screen after saving Care Plan-------")
	
	'Validate Goals section of Patient Snapshot screen after saving Patient Care Plan
	
	'Click on Patient Snapshot tab
	Execute "Set objPatientSnapshotTab = "&Environment("WL_PatientSnapshotTab")
	Err.Clear
	objPatientSnapshotTab.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Patient Snapshot tab. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Patient Snapshot tab")
	Execute "Set objPatientSnapshotTab = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Check availability of Goals section in Patient Snapshot screen
	Execute "Set objPatientSnapshot_Goals = "&Environment("WEL_PatientSnapshot_Goals")
	Err.Clear
	objPatientSnapshot_Goals.highlight
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to find Goals in Patient Snapshot screen. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Goals section is available in Patient Snapshot screen")
	Execute "Set objPatientSnapshot_Goals = Nothing"
	Wait 1
	
	'Validate whether Goal section is populated or not (should be populated)
	Execute "Set objPatientSnapshot_Goals = "&Environment("WEL_PatientSnapshot_Goals")
	strGoalsDetail = ""
	strGoalsDetail = objPatientSnapshot_Goals.GetROProperty("outertext")
	If strGoalsDetail = "" Then
		strOutErrorDesc = "Goals section is empty in Patient Snapshot screen. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Goals section is populated")
	Execute "Set objPatientSnapshot_Goals = Nothing"
	Wait 1
	
	'Validate values in Goal section with values provided while saving Patient care plan 
	
	strCarePlanTopic = Split(strGoalValues,",",-1,1)(0)
	strCarePlanName = Split(strGoalValues,",",-1,1)(5)
	strImportance = Split(strGoalValues,",",-1,1)(3)
	strConfidenceLevel = Split(strGoalValues,",",-1,1)(4)
	strBehavioralPlan = Split(strGoalValues,",",-1,1)(6)
	
	'Validate CarePlanTopic	in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,strCarePlanTopic,1) <= 0 Then
		strOutErrorDesc = "Care Plan Topic '"&strCarePlanTopic&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Topic '"&strCarePlanTopic&"' is displayed in Goals section of Patient Snapshot screen")
	
						''Validate CarePlanName in Goals section of Patient Snapshot screen
						'If Instr(1,strGoalsDetail,strCarePlanName,1) <= 0 Then
						'	strOutErrorDesc = "Care Plan Name '"&strCarePlanName&"' is not displayed in Goals section of Patient Snapshot screen"
						'	Exit Function
						'End If
						'Call WriteToLog("Pass","Care Plan Name '"&strCarePlanName&"' is displayed in in Goals section of Patient Snapshot screen")
	'
	'Validate Start date in Goals section of Patient Snapshot screen
	
	'Get Required Date format for Goals
	dtStartDate = DateFormatForGoals(dtStartDate)
	dtDueDate = DateFormatForGoals(dtDueDate)
	
	'Validate Start date in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,dtStartDate,1) <= 0 Then
		strOutErrorDesc = "Start date '"&dtStartDate&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Start date '"&dtStartDate&"' is displayed in Goals section of Patient Snapshot screen")	
	
	'Validate Due date in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,dtDueDate,1) <= 0 Then
		strOutErrorDesc = "Due date '"&dtDueDate&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Due date '"&dtDueDate&"' is displayed in Goals section of Patient Snapshot screen")
	
	'Validate Importance in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,strImportance,1) <= 0 Then
		strOutErrorDesc = "Importance '"&strImportance&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Importance '"&strImportance&"' is displayed in Goals section of Patient Snapshot screen")
	
	'Validate ConfidenceLevel in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,strConfidenceLevel,1) <= 0 Then
		strOutErrorDesc = "Confidence Level '"&strConfidenceLevel&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Confidence Level '"&strConfidenceLevel&"' is displayed in Goals section of Patient Snapshot screen")
	
	'Validate BehavioralPlan in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,strBehavioralPlan,1) <= 0 Then
		strOutErrorDesc = "Behavioral Plan '"&strBehavioralPlan&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Behavioral 	Plan '"&strBehavioralPlan&"' is displayed in Goals section of Patient Snapshot screen")	
	
	Call WriteToLog("Pass","Validated impact on Goals section of Patient Snapshot screen after saving Care Plan")
	
	Wait 1	
	Err.Clear
	PCP_Goals_Impact = True
	
End Function
'----------------------------------------------------------------

Function PCP_EditMode(ByVal strEditModeValues, ByVal dtDueDateForEdit, strOutErrorDesc)

	'Validating Edit mode scenarios
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_EditMode = False
	
	Call WriteToLog("Info","--------Validating Edit mode scenarios-------")	
	
	'Sorting required values for respective fields
	strCarePlanTopicForEdit = Split(strEditModeValues,",",-1,1)(0)
	strClinicalRelevanceForEdit = Split(strEditModeValues,",",-1,1)(1)
	strStatus = Split(strEditModeValues,",",-1,1)(2)
	
	'Select the required care plan for editing
	blnPCP_SelectPCPforEdit = PCP_SelectPCPforEdit(strCarePlanTopicForEdit,strClinicalRelevanceForEdit,dtDueDateForEdit,strStatus,strOutErrorDesc)
	If not blnPCP_SelectPCPforEdit Then
		strOutErrorDesc = "Unable to select required care plan for editing. "&Err.Description
		Exit Function
	End If 	
	
	'Click on edit button
	Execute "Set objPCP_EditBTN = "&Environment("WEL_EditCarePlanBtn") 'PCP Edit button
	Err.CLear
	objPCP_EditBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Edit button. "&Err.Description
		Exit Function
	End If 	
	Call WriteToLog("Pass","Clicked on Patient Care Plan Edit button")
	Execute "Set objPCP_EditBTN = Nothing"
	Wait 1
	Call waitTillLoads("Loading...")	

	'--------------------Status of Buttons	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For Edit mode, Save button should be enabled even before performing any value edit
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	If objPCP_SaveBTN.Object.isDisabled Then
		strOutErrorDesc = "Save button is disabled in edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Save button is enabled even before performing any value edit")
	Execute "Set objPCP_SaveBTN = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For Edit mode, Cancel button should be enabled even before performing any value edit
	Execute "Set objPCP_CancelBTN ="&Environment("WEL_PCP_CancelBtn") 'PCP Cancel button
	If objPCP_CancelBTN.Object.isDisabled Then
		strOutErrorDesc = "Cancel button is disabled in edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Cancel button is enabled even before performing any value edit")
	Execute "Set objPCP_CancelBTN = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For Edit mode, if tried to Save care plan without making any changes, then 'No Changes Found' error message box should be displayed.
	
	'Click Save button
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Save button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button without making any changes to existing care plan")
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate 'No Changes Found' error message box
	blnCompleteDt_LessThanStartDt_EditMode = checkForPopup("Error", "Ok", "No Changes Found", strOutErrorDesc)
	If not blnCompleteDt_LessThanStartDt_EditMode Then
		strOutErrorDesc = "Unable to validate 'No Changes Found' error msg box. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'No Changes Found' error msg box when tried to Save care plan without making any changes")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------Status of Main fields	
	'Validating - Disabled main fields
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Care Plan Topic dropdown should be disabled
	Execute "Set objPCP_CarePlanTopicDD ="&Environment("WB_PatCaPlnTopic") 'PCP CarePlanTopic dropdown	
	If not objPCP_CarePlanTopicDD.Object.isDisabled Then
		strOutErrorDesc = "Care Plan Topic dropdown is enabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Topic dropdown is disabled in Edit mode")
	Execute "Set objPCP_CarePlanTopicDD = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Start Date field should be disabled
	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
	If not objPCP_StartDateTB.Object.isDisabled Then
		strOutErrorDesc = "Start Date field is enabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Start Date field is disabled in Edit mode")
	Execute "Set objPCP_StartDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Completed Date field should be disabled before slecting any Status
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	If not objPCP_CompletedDateTB.Object.isDisabled Then
		strOutErrorDesc = "In  edit mode, Completed Date field is enabled before slecting any Status"
		Exit Function
	End If
	Call WriteToLog("Pass","In  edit mode, Completed Date field is disbaled before slecting any Status")
	Execute "Set objPCP_CompletedDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Clinical Relevance dropdown should be disabled
	Execute "Set objPCP_ClinicalRelevanceDD = "&Environment("WB_PatCaPlnClinicalRelvnDD") 'PCP ClinicalRelevance dropdown
	If not objPCP_ClinicalRelevanceDD.Object.isDisabled Then
		strOutErrorDesc = "Clinical Relevance dropdown is enabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Clinical Relevance dropdown is disabled in Edit mode")
	Execute "Set objPCP_ClinicalRelevanceDD = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'Validating - Enabled main fields
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Importance dropdown should be enabled
	Execute "Set objPCP_ImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 'PCP Importance drodown
	If objPCP_ImportanceLevelDD.Object.isDisabled Then
		strOutErrorDesc = "Importance dropdown is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Importance dropdown is enabled in Edit mode")
	Execute "Set objPCP_ImportanceLevelDD = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Confidence Level dropdown should be enabled
	Execute "Set objPCP_ConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 'PCP Confidence level dropdown
	If objPCP_ConfidenceLevelDD.Object.isDisabled Then
		strOutErrorDesc = "Confidence Level dropdown is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Confidence Level dropdown is enabled in Edit mode")
	Execute "Set objPCP_ConfidenceLevelDD = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Status dropdown should be enabled
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	If objPCP_StatusDD.Object.isDisabled Then
		strOutErrorDesc = "Status dropdown is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Status dropdown is enabled in Edit mode")
	Execute "Set objPCP_StatusDD = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Due date field should be enabled
	Execute "Set objPCP_DueDateTB = "&Environment("WE_PCP_DueDateFiled") 'PCP DueDate field
	If objPCP_DueDateTB.Object.isDisabled Then
		strOutErrorDesc = "Due date field is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Due date field is enabled in Edit mode")
	Execute "Set objPCP_DueDateTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Behavioral Plan field should be enabled
	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
	If objPCP_BehavioralPlanTB.Object.isDisabled Then
		strOutErrorDesc = "Behavioral Plan field is disabled in Edit mode"
		Exit Function
	End If
	Err.Clear
	objPCP_BehavioralPlanTB.Set "BP"  'just to change a value
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Behavioral Plan in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Behavioral Plan field is enabled in Edit mode")
	Execute "Set objPCP_BehavioralPlanTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Engagement Plan field should be enabled
	Execute "Set objPCP_EngagementPlanTB = "&Environment("WE_EngagementPlan") 'PCP Engagement plan field
	If objPCP_EngagementPlanTB.Object.isDisabled Then
		strOutErrorDesc = "Engagement Plan field is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Engagement Plan field is enabled in Edit mode")
	Execute "Set objPCP_EngagementPlanTB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'--------------------Status of Barriers	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Poor Habits/Practices barrier check box should be enabled
	Execute "Set objPCP_PoorHabits_BarrierCB = "&Environment("WEL_PCP_PoorHabits_BarrierCB") 'Poor Habits/Practices check box
	If objPCP_PoorHabits_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "Poor Habits/Practices barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Poor Habits/Practices barrier check box is enabled in Edit mode")
	Execute "Set objPCP_PoorHabits_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Knowledge Deficit barrier check box should be enabled
	Execute "Set objPCP_KnowledgeDeficit_BarrierCB = "&Environment("WEL_PCP_KnowledgeDeficit_BarrierCB") 'Knowledge Deficit check box
	If objPCP_KnowledgeDeficit_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "Knowledge Deficit barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Knowledge Deficit barrier check box is enabled in Edit mode")
	Execute "Set objPCP_KnowledgeDeficit_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Equipment Issue barrier check box should be enabled
	Execute "Set objPCP_EquipmentIssue_BarrierCB = "&Environment("WEL_PCP_EquipmentIssue_BarrierCB") 'Equipment Issue check box
	If objPCP_EquipmentIssue_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "Equipment Issue barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Equipment Issue check box is enabled in Edit mode")
	Execute "Set objPCP_EquipmentIssue_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Equipment Issue barrier check box should be enabled
	Execute "Set objPCP_EquipmentIssue_BarrierCB = "&Environment("WEL_PCP_EquipmentIssue_BarrierCB") 'Equipment Issue check box
	If objPCP_EquipmentIssue_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "Equipment Issue barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Equipment Issue check box is enabled in Edit mode")
	Execute "Set objPCP_EquipmentIssue_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Psychological barrier check box should be enabled
	Execute "Set objPCP_Psychological_BarrierCB = "&Environment("WEL_PCP_Psychological_BarrierCB") 'Psychological check box
	If objPCP_Psychological_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "Psychological barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Psychological check box is enabled in Edit mode")
	Execute "Set objPCP_Psychological_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Socioeconomic barrier check box should be enabled
	Execute "Set objPCP_Socioeconomic_BarrierCB = "&Environment("WEL_PCP_Socioeconomic_BarrierCB") 'Socioeconomic check box
	If objPCP_Socioeconomic_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "Socioeconomic barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Socioeconomic check box is enabled in Edit mode")
	Execute "Set objPCP_Socioeconomic_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Physical Limitation barrier check box should be enabled
	Execute "Set objPCP_PhysicalLimitation_BarrierCB = "&Environment("WEL_PCP_PhysicalLimitation_BarrierCB") 'Physical Limitation check box	
	If objPCP_PhysicalLimitation_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "Physical Limitation barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Physical Limitation check box is enabled in Edit mode")
	Execute "Set objPCP_PhysicalLimitation_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, No Support System barrier check box should be enabled
	Execute "Set objPCP_NoSupportSystem_BarrierCB = "&Environment("WEL_PCP_NoSupportSystem_BarrierCB") 'No Support System check box
	If objPCP_NoSupportSystem_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "No Support System barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","No Support System check box is enabled in Edit mode")
	Execute "Set objPCP_NoSupportSystem_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, Other barrier check box should be enabled
	Execute "Set objPCP_Other_BarrierCB = "&Environment("WEL_PCP_Other_BarrierCB") 'Other check box
	If objPCP_Other_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "Other barrier check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","Other check box is enabled in Edit mode")
	Execute "Set objPCP_Other_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'For edit mode, No Barriers check box should be enabled
	Execute "Set objPCP_NoBarriers_BarrierCB = "&Environment("WEL_PCP_NoBarriers_BarrierCB") 'No Barriers check box
	If objPCP_NoBarriers_BarrierCB.Object.isDisabled Then
		strOutErrorDesc = "No Barriers check box is disabled in Edit mode"
		Exit Function
	End If
	Call WriteToLog("Pass","No Barriers check box is enabled in Edit mode")
	Execute "Set objPCP_NoBarriers_BarrierCB = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate - in Edit mode, msg box with text 'Your current changes will be lost. Do you want to continue ?' when tried to navigate to other screen without saving care plan	
	'Click on Referrals menu
	Execute "Set objReferralsTab = "&Environment("WL_ReferralsTab") 'Referrals menu
	Err.Clear
	objReferralsTab.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Referrals menu. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Referals menu is clicked")
	Execute "Set objReferralsTab = Nothing"
	Wait 2
	
	'Validate 'Msg box with text 'Your current changes will be lost. Do you want to continue ?'
	blnMessageNavigation = clickOnMessageBox("Patient Care Plan", "No", "Your current changes will be lost. Do you want to continue ?", strOutErrorDesc)
	If not blnMessageNavigation Then
		strOutErrorDesc = "Unable to validate 'Your current changes will be lost. Do you want to continue ?' message box in edit mode. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Your current changes will be lost. Do you want to continue ?' message box when tried to navigate to other screen without saving care plan in edit mode")
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	'Validate Completed date field status for different Status variations in edit mode
	blnPCP_CompletedDateFieldStatus = PCP_CompletedDateFieldStatus(strOutErrorDesc)
	If not blnPCP_CompletedDateFieldStatus Then
		strOutErrorDesc = "Unable to validate Completed date field status in edit mode. "&strOutErrorDesc
		Exit Function		
	End If
	Call WriteToLog("Pass","Validated Completed date field status in edit mode")
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation -  (in edit mode) 'Complete Date' greater than sys date – Error msg box with msg 'Complete date of patient care plan can not be prior to start date'
	
	'Select status as Cancelled or Met or Partially Met or  Unmet
	strStatus = "Partially Met"
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown	
	objPCP_StatusDD.highlight
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Unable to select status from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"
	Wait 0,250	
	
	'Get Start date from UI
	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
	dtStartDate = ""
	dtStartDate = Trim(objPCP_StartDateTB.GetROProperty("value"))
	If dtStartDate = "" Then
		strOutErrorDesc = "Unable to retrieve start date"
		Exit Function
	End If
	Call WriteToLog("Pass","Retrieved start date as'"&dtStartDate&"'")
	Execute "Set objPCP_StartDateTB = Nothing"
	Wait 0,250
	
	'Set Completed date less than strat date
	dtCompletedDate = DateAdd("d",-5,CDate(dtStartDate))
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	Err.Clear
	objPCP_CompletedDateTB.Set dtCompletedDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Completed Date. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Completed Date is set as '"&dtCompletedDate&"'")
	Execute "Set objPCP_CompletedDateTB = Nothing"	
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate 'Complete date of patient care plan can not be prior to start date' error msg box
	blnCompleteDt_LessThanStartDt_EditMode = checkForPopup("Error", "Ok", "Complete date of patient care plan can not be prior to start date", strOutErrorDesc)
	If not blnCompleteDt_LessThanStartDt_EditMode Then
		strOutErrorDesc = "Unable to validate 'Complete date of patient care plan can not be prior to start date' error msg box. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Complete date of patient care plan can not be prior to start date' error msg box when tried to provide Completed date less than Start date")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	'Validation -  (in edit mode) 'Complete Date' greater than sys date – Invalid Data msg box with msg 'Complete Date should not be greater than System date'
	
	'Set Completed date greater than sys date
	dtCompletedDate = DateAdd("d",2,Date)
	Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
	Err.Clear
	objPCP_CompletedDateTB.Set dtCompletedDate
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to set Completed Date. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Completed Date is set as '"&dtCompletedDate&"'")
	Execute "Set objPCP_CompletedDateTB = Nothing"	
	
	'Click Save btn		
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Save button is not clicked. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button")
	Execute "Set objPCP_SaveBTN = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Validate 'Complete Date should not be greater than System date' Invalid Data msg box
	blnCompleteDt_LessThanStartDt_EditMode = checkForPopup("Invalid Data", "Ok", "Complete Date should not be greater than System date", strOutErrorDesc)
	If not blnCompleteDt_LessThanStartDt_EditMode Then
		strOutErrorDesc = "Unable to validate 'Complete Date should not be greater than System date. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Complete Date should not be greater than System date' Invalid Data msg box when tried to provide Completed date greater than sys date")
	Wait 1
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	'----Cancel the Edit
	
	'Click Cancel button
	Execute "Set objPCP_CancelBTN ="&Environment("WEL_PCP_CancelBtn") 'PCP Cancel button
	Err.clear
	objPCP_CancelBTN.Click	
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on Cancel button ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Cancel button is clicked")
	Execute "Set objPCP_CancelBTN = Nothing"
	Wait 2
	
	'Validate message box with text 'Your current changes will be lost. Do you want to continue?' and select Yes option
	blnCancel_Yes = clickOnMessageBox("Patient Care Plan", "Yes", "Your current changes will be lost. Do you want to continue?", strOutErrorDesc)
	If not blnCancel_Yes Then
		strOutErrorDesc = "Unable to validate 'Your current changes will be lost. Do you want to continue?' message box while clicking Cancel button. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Validated 'Your current changes will be lost. Do you want to continue?' message box while clicking Cancel button and seleted Yes option")
	'---------------------------------------------------------------------------------------------------------------------------------------------------
	
	Call WriteToLog("Pass","Validated Edit mode scenarios")
	
	Wait 1
	Err.Clear
	PCP_EditMode = True
	
End Function

Function PCP_ActiveCarePlanSectionAfterEdtingPCP(ByVal strStatus, ByVal dtDueDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_ActiveCarePlanSectionAfterEdtingPCP = False
	
	Call WriteToLog("Info","--------Validate - After editing care plan, Active Care Plan section is available and is having required edited values-------")
	
	Execute "Set objPCP_CarePlanTable = "&Environment("WT_PCP_CarePlanTable") 'Care plan table
	intCarePlanTopicRC = ""
	intCarePlanTopicRC = objPCP_CarePlanTable.RowCount
	
	'Validate Active Care Plan section is available after editing care plan to the patient
	If not objPCP_CarePlanTable.Exist(2) Then
		strOutErrorDesc = "After adding CarePlan, Active Care Plan section is not available"
		Exit Function
	End If 
	objPCP_CarePlanTable.highlight
	Call WriteToLog("Pass","After editing CarePlan, Active Care Plan section is available")
	
'	'Validate over due icon if care plan is edited with due date >= sys date
'	blnPCP_DueIcon = PCP_DueIcon()
'	If DateDiff("d",dtDueDate,Date) = 0 Then
'		If not blnPCP_DueIcon Then
'			strOutErrorDesc = "After editing CarePlan with due date eual to sys date, over due icon is not present in Active Care Plan table"
'			Exit Function
'		End If 
'		Call WriteToLog("Pass","After editing CarePlan with due date eual to sys date, over due icon is present in Active Care Plan table")
'	End If

	'Validate over due icon if care plan is edited with due date >, =, <  sys date
	blnPCP_DueIcon = PCP_DueIcon()
	If DateDiff("d",dtDueDate,Date) >= 0 Then
		If not blnPCP_DueIcon Then
			strOutErrorDesc = "After editing CarePlan with due date eual to sys date, over due icon is not present in Active Care Plan table"
			Exit Function
		End If 
		Call WriteToLog("Pass","After editing CarePlan with due date eual/less than to sys date, over due icon is present in Active Care Plan table")
	ElseIf DateDiff("d",dtDueDate,Date) < 0 Then
		If blnPCP_DueIcon Then
			strOutErrorDesc = "After editing CarePlan with due date less than sys date, over due icon is present in Active Care Plan table"
			Exit Function
		End If 
		Call WriteToLog("Pass","After editing CarePlan with due date less than sys date, over due icon is not present in Active Care Plan table")
	End If
	
	'Validate care plan details are edited to the Active Care Plan section
	If intCarePlanTopicRC = 0 Then
		strOutErrorDesc = "After editing CarePlan, Active Care Plan section is not populated with provided values"
		Exit Function
	End If 
	Call WriteToLog("Pass","After editing CarePlan, Active Care Plan section is having CarePlanTopic, ClinicalRelevance, Due date, Status sections")
	
	'Validate eaah data in the Active Care Plan section	
	dtProvidedDueDate = DateFormat(dtDueDate)
	strProvidedStatus = strStatus

	'--GetCellData(1,2)  '1 is the 1st row in ActiveCarePlan section. We've only one care plan, so row =1
	dtAddedDueDate = objPCP_CarePlanTable.GetCellData(1,4) '4 is the column number for DueDate in CarePlan table
	strAddedStatus = objPCP_CarePlanTable.GetCellData(1,5) '5 is the column number for Status in CarePlan table
			
	'Validate 'Due date' value in Active Care Plan section
	If Instr(1,Trim(Replace(dtAddedDueDate," ","",1,-1,1)),Trim(Replace(dtProvidedDueDate," ","",1,-1,1)),1) <= 0 Then
		strOutErrorDesc = "After editing CarePlan, Active Care Plan section is not populated with Due date"
		Exit Function
	End If 
	Call WriteToLog("Pass","After editing CarePlan, Active Care Plan section is populated with Due date")
	
	'Validate 'Status' value in Active Care Plan section
	If Instr(1,LCase(Trim(Replace(strAddedStatus," ","",1,-1,1))),LCase(Trim(Replace(strProvidedStatus," ","",1,-1,1))),1) <= 0 Then
		strOutErrorDesc = "After editing CarePlan, Active Care Plan section is not populated with Status"
		Exit Function
	End If 
	Call WriteToLog("Pass","After editing CarePlan, Active Care Plan section is populated with Status")

	Execute "Set objPCP_CarePlanTable = Nothing"
	'---------------------------------------------------------------------------------------------------------------------------------------------------	
	
	Wait 1	
	Err.Clear
	PCP_ActiveCarePlanSectionAfterEdtingPCP = True
	
End Function

Function PCP_Edit_RecapScreen_Impact(ByVal strRecapEditedValues, ByVal strBarrierValues, strOutErrorDesc)

	'Validate impact on Recap screen after saving Care Plan
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_Edit_RecapScreen_Impact = False

	Call WriteToLog("Info","--------Validate impact on Recap screen after saving Care Plan-------")
	
	'Validate - After saving Care plan to patient, Recap screen should get populated with Care Plan details
	
	'Click on browsing icon in Open Patient Tray
	Set oDescBI = Description.Create
	oDescBI("micclass").Value = "WebElement"
	oDescBI("class").Value = ".*binoculars recap-contact-footer-small-icon.*"	
	oDescBI("class").RegularExpression = True
	oDescBI("html tag").Value = "SPAN"
	oDescBI("visible").Value = True
	
	Set objBrowsingIcons = getPageObject().ChildObjects(oDescBI)
	Err.Clear
	objBrowsingIcons(0).Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click on browsing icon in Open Patient tray. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked on browsing icon in Open Patient tray")
	Set oDescBI = Nothing
	Set objBrowsingIcons = Nothing
	Wait 1
	
	'Check that Recap screen is available after clicking on browsing icon in Open Patient tray
	Execute "Set objRecapTitle = "&Environment("WEL_CM_RecapTitle") 'Recap screen header
	If not objRecapTitle.Exist(5) Then
		strOutErrorDesc = "Recap screen is not available after clicking on browsing icon in Open Patient tray"
		Exit Function
	End If
	Call WriteToLog("Pass","Recap screen is available after clicking on browsing icon in Open Patient tray")
	Execute "Set objRecapTitle = Nothing"
	
	'Validate existence of 'Member Care Plan' header in Note section of Recap screen after saving care plan
	Execute "Set objRecap_PCPheader = " & Environment("WEL_Recap_PCPheader")
	If not objRecap_PCPheader.Exist(2) Then
		strOutErrorDesc = "'Member Care Plan' header is not existing in Note section of Recap screen after saving care plan"
		Exit Function
	End If
	objRecap_PCPheader.highlight
	Call WriteToLog("Pass","'Member Care Plan' header is not existing in Note section of Recap screen after saving care plan")
	Execute "Set objRecap_PCPheader = Nothing"
	
	'Sorting required values for respective fields 
	strImportance = Split(strRecapEditedValues,",",-1,1)(0)
	strConfidenceLevel = Split(strRecapEditedValues,",",-1,1)(1)
	strBehavioralPlan = Split(strRecapEditedValues,",",-1,1)(3)
	
	'Get the Note details in Recap screen for the newly added Patient Care plan
	'index: = 1  points to the 2nd Note section in Recap screen which is having the Patient Care Plan details
	Set objNote = getPageObject().WebEdit("html tag:=TEXTAREA","name:=WebEdit","outerhtml:=.*recap-textbox.*","type:=textarea","visible:=True","index:=1")
	Err.Clear
	objNote.highlight
	strRecapScr_Note_PCPdetails = ""
	strRecapScr_Note_PCPdetails = objNote.GetROProperty("value")
	
	'Validate 'Start date' value in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,dtStartDate,1) <= 0 Then
		strOutErrorDesc = "Start date'"&dtStartDate&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If 
	Call WriteToLog("Pass","Start date'"&dtStartDate&"' is displayed in Note section of Recap screen")
	
	'Validate CarePlanTopic	in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strCarePlanTopic,1) <= 0 Then
		strOutErrorDesc = "Care Plan Topic '"&strCarePlanTopic&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Topic '"&strCarePlanTopic&"' is displayed in Note section of Recap screen")
	
	'Validate ClinicalRelevance	in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strClinicalRelevance,1) <= 0 Then
		strOutErrorDesc = "Clinical Relevance '"&strClinicalRelevance&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Clinical Relevance '"&strClinicalRelevance&"' is displayed in Note section of Recap screen")
	
	'Validate CarePlanName in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strCarePlanName,1) <= 0 Then
		strOutErrorDesc = "Care Plan Name '"&strCarePlanName&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Name '"&strCarePlanName&"' is displayed in Note section of Recap screen")
	
	'Validate Importance in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strImportance,1) <= 0 Then
		strOutErrorDesc = "Importance '"&strImportance&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Importance '"&strImportance&"' is displayed in Note section of Recap screen")
	
	'Validate ConfidenceLevel in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strConfidenceLevel,1) <= 0 Then
		strOutErrorDesc = "Confidence Level '"&strConfidenceLevel&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Confidence Level '"&strConfidenceLevel&"' is displayed in Note section of Recap screen")
	
	'Validate BehavioralPlan in note section of Recap screen
	If Instr(1,strRecapScr_Note_PCPdetails,strBehavioralPlan,1) <= 0 Then
		strOutErrorDesc = "Behavioral Plan '"&strBehavioralPlan&"' is not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Behavioral 	Plan '"&strBehavioralPlan&"' is displayed in Note section of Recap screen")
	
	'Validate Barriers in note section of Recap screen
	strBarriers = GetReplacedString(strBarrierValues,"","","")
	strRecapScr_Note_PCPdetails_Barrier = GetReplacedString(strRecapScr_Note_PCPdetails,"","","")
	If Instr(1,strRecapScr_Note_PCPdetails_Barrier,strBarriers,1) <= 0 Then
		strOutErrorDesc = "Barriers are not displayed in Note section of Recap screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Barriers are displayed in Note section of Recap screen")
	
	Call WriteToLog("Pass","Validated impact on Recap screen after saving Care Plan")

	Wait 1	
	Err.Clear
	PCP_Edit_RecapScreen_Impact = True
	
End Function

Function PCP_Edit_Goals_Impact(ByVal strGoalEditedValues, ByVal dtStartDate, ByVal dtDueDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_Edit_Goals_Impact = False
	
	Call WriteToLog("Info","--------Validate impact on Goals section of Patient Snapshot screen after saving Care Plan-------")
	
	'Validate Goals section of Patient Snapshot screen after saving Patient Care Plan
	
	'Click on Patient Snapshot tab
	Execute "Set objPatientSnapshotTab = "&Environment("WL_PatientSnapshotTab")
	Err.Clear
	objPatientSnapshotTab.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Patient Snapshot tab. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Patient Snapshot tab")
	Execute "Set objPatientSnapshotTab = Nothing"
	Wait 2
	Call waitTillLoads("Loading...")
	
	'Check availability of Goals section in Patient Snapshot screen
	Execute "Set objPatientSnapshot_Goals = "&Environment("WEL_PatientSnapshot_Goals")
	Err.Clear
	objPatientSnapshot_Goals.highlight
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to find Goals in Patient Snapshot screen. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Goals section is available in Patient Snapshot screen")
	Execute "Set objPatientSnapshot_Goals = Nothing"
	Wait 1
	
	'Validate whether Goal section is populated or not (should be populated)
	Execute "Set objPatientSnapshot_Goals = "&Environment("WEL_PatientSnapshot_Goals")
	strGoalsDetail = ""
	strGoalsDetail = objPatientSnapshot_Goals.GetROProperty("outertext")
	If strGoalsDetail = "" Then
		strOutErrorDesc = "Goals section is empty in Patient Snapshot screen. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Goals section is populated")
	Execute "Set objPatientSnapshot_Goals = Nothing"
	Wait 1
	
	'Validate values in Goal section with values provided while saving Patient care plan 
	
	strImportance = Split(strGoalEditedValues,",",-1,1)(0)
	strConfidenceLevel = Split(strGoalEditedValues,",",-1,1)(1)
	strBehavioralPlan = Split(strGoalEditedValues,",",-1,1)(3)
	
	'Validate Start date in Goals section of Patient Snapshot screen
	
	'Get Required Date format for Goals
	dtStartDate = DateFormatForGoals(dtStartDate)
	dtDueDate = DateFormatForGoals(dtDueDate)
	
	'Validate Start date in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,dtStartDate,1) <= 0 Then
		strOutErrorDesc = "Start date '"&dtStartDate&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Start date '"&dtStartDate&"' is displayed in Goals section of Patient Snapshot screen")	
	
	'Validate Due date in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,dtDueDate,1) <= 0 Then
		strOutErrorDesc = "Due date '"&dtDueDate&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Due date '"&dtDueDate&"' is displayed in Goals section of Patient Snapshot screen")
	
	'Validate Importance in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,strImportance,1) <= 0 Then
		strOutErrorDesc = "Importance '"&strImportance&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Importance '"&strImportance&"' is displayed in Goals section of Patient Snapshot screen")
	
	'Validate ConfidenceLevel in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,strConfidenceLevel,1) <= 0 Then
		strOutErrorDesc = "Confidence Level '"&strConfidenceLevel&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Confidence Level '"&strConfidenceLevel&"' is displayed in Goals section of Patient Snapshot screen")
	
	'Validate BehavioralPlan in Goals section of Patient Snapshot screen
	If Instr(1,strGoalsDetail,strBehavioralPlan,1) <= 0 Then
		strOutErrorDesc = "Behavioral Plan '"&strBehavioralPlan&"' is not displayed in Goals section of Patient Snapshot screen"
		Exit Function
	End If
	Call WriteToLog("Pass","Behavioral 	Plan '"&strBehavioralPlan&"' is displayed in Goals section of Patient Snapshot screen")	
	
	Call WriteToLog("Pass","Validated impact on Goals section of Patient Snapshot screen after saving Care Plan")
	
	Wait 1	
	Err.Clear
	PCP_Edit_Goals_Impact = True
	
	'-----------------------------------------
	'Navigate back to Patient Care Plan screen
	blnPCP_ScreenNavigation = PCP_ScreenNavigation(strOutErrorDesc)
	If not blnPCP_ScreenNavigation Then 
		Exit Function
	End If	
	'-----------------------------------------
	
End Function
'----------------------------------------------------------------


'******************************************************************************************************************************************************************
Function PCP_AddPCP(ByVal strPCPfieldRequisites, ByVal dtStartDate, ByVal dtDueDate, ByVal strRequiredBarriers, ByVal strFFtext, strOutErrorDesc)
	
	'Adding Patient Care Plan with required values
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_AddPCP = False	
	
	Call WriteToLog("Info","--------Adding Patient Care Plan-------")
	
	'Sorting required values for respective fields
	strCarePlanTopic = Split(strPCPfieldRequisites,",",-1,1)(0)
	strClinicalRelevance = Split(strPCPfieldRequisites,",",-1,1)(1)
	strStatus = Split(strPCPfieldRequisites,",",-1,1)(2)
	strImportance = Split(strPCPfieldRequisites,",",-1,1)(3)
	strConfidenceLevel = Split(strPCPfieldRequisites,",",-1,1)(4)
	strCarePlanName = Split(strPCPfieldRequisites,",",-1,1)(5)
	strBehavioralPlan = Split(strPCPfieldRequisites,",",-1,1)(6)
	strEngagementPlan = Split(strPCPfieldRequisites,",",-1,1)(7)
	
	'Click on Add button if available and enabled
	Execute "Set objPCP_AddBTN ="&Environment("WEL_PatCaPlnAdd") 'PCP Add button
	If objPCP_AddBTN.Exist(2) Then
		If not objPCP_AddBTN.Object.isDisabled Then
			objPCP_AddBTN.highlight
			Err.Clear
			objPCP_AddBTN.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = "Unable to click Add button. "&Err.Description
					Exit Function
				End If
			Call WriteToLog("Pass","Clicked Add button for adding new Care Plan")
		End If
	End If
	Execute "Set objPCP_AddBTN = Nothing"
	Wait 1
	Call waitTillLoads("Loading...")
	Wait 1
	
	'----------Main fields
	
	'Select Care Plan Topic	
	Execute "Set objPCP_CarePlanTopicDD ="&Environment("WB_PatCaPlnTopic") 'PCP CarePlanTopic dropdown
	objPCP_CarePlanTopicDD.highlight
	blnCarePlanTopic = selectComboBoxItem(objPCP_CarePlanTopicDD, strCarePlanTopic)
	If not blnCarePlanTopic Then
		strOutErrorDesc = "Care Plan Topic is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Topic is selected as '"&strCarePlanTopic&"'")
	Execute "Set objPCP_CarePlanTopicDD = Nothing"
	Wait 1
	Call waitTillLoads("Loading...")
	
	'Select Importance
	Execute "Set objPCP_ImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 'PCP Importance drodown
	blnImportance = selectComboBoxItem(objPCP_ImportanceLevelDD, strImportance)
	If not blnImportance Then
		strOutErrorDesc = "Importance is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Importance is selected as '"&strImportance&"'")
	Execute "Set objPCP_ImportanceLevelDD = Nothing"
	Wait 0,250
	
	'Select Confidence Level 
	Execute "Set objPCP_ConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 'PCP Confidence level dropdown
	blnConfidenceLevel = selectComboBoxItem(objPCP_ConfidenceLevelDD, strConfidenceLevel)
	If not blnConfidenceLevel Then
		strOutErrorDesc = "Confidence Level is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Confidence Level is selected as '"&strConfidenceLevel&"'")
	Execute "Set objPCP_ConfidenceLevelDD = Nothing"	
	Wait 0,250
	
	'Select Status
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"		
	Wait 0,250
	
	'Set Start date
	Execute "Set objPCP_StartDateTB = "&Environment("WE_PCP_StartDateFiled") 'PCP StartDate field
	Err.Clear	
	objPCP_StartDateTB.Set dtStartDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Start Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Start date is set to '"&dtSatrtDate&"'")
	Execute "Set objPCP_StartDateTB = Nothing"
	Wait 0,250
	
	'Set Due date
	Execute "Set objPCP_DueDateTB = "&Environment("WE_PCP_DueDateFiled") 'PCP DueDate field
	Err.Clear	
	objPCP_DueDateTB.Set dtDueDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Due Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Due date is set to '"&dtDueDate&"'")
	Execute "Set objPCP_DueDateTB = Nothing"
	Wait 0,250
	
	'Select Clinical Relevance 
	Execute "Set objPCP_ClinicalRelevanceDD = "&Environment("WB_PatCaPlnClinicalRelvnDD") 'PCP ClinicalRelevance dropdown
	blnClinicalRelevance = selectComboBoxItem(objPCP_ClinicalRelevanceDD, strClinicalRelevance)
	If not blnClinicalRelevance Then
		strOutErrorDesc = "Clinical Relevance is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Clinical Relevance is selected as '"&strClinicalRelevance&"'")
	Execute "Set objPCP_ClinicalRelevanceDD = Nothing"	
	Wait 0,250
	
	'Set Care Plan Name 
	Execute "Set objPCP_CarePlanNameTB = "&Environment("WE_PatCaPlnName") 'PCP CarePlanName field	
	Err.Clear
	objPCP_CarePlanNameTB.Set strCarePlanName
	If Err.Number <> 0 Then
		strOutErrorDesc = "Care Plan Name is not set "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Care Plan Name is set as '"&strCarePlanName&"'")
	Execute "Set objPCP_CarePlanNameTB = Nothing"		
	Wait 0,250
	
	'Set Behavioral Plan 
	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
	Err.Clear
	objPCP_BehavioralPlanTB.Set strBehavioralPlan
	If Err.Number <> 0 Then
		strOutErrorDesc = "Behavioral Plan is not set. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Behavioral Plan is set as '"&strBehavioralPlan&"'")
	Execute "Set objPCP_BehavioralPlanTB = Nothing"		
	Wait 0,250
	
	'Set Engagement Plan 
	Execute "Set objPCP_EngagementPlanTB = "&Environment("WE_EngagementPlan") 'PCP Engagement plan field		
	Err.Clear
	objPCP_EngagementPlanTB.Set strEngagementPlan
	If Err.Number <> 0 Then
		strOutErrorDesc = "Engagement Plan is not set. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Engagement Plan is set as '"&strEngagementPlan&"'")
	Execute "Set objPCP_EngagementPlanTB = Nothing"		
	Wait 0,250	
	
	'----------Barriers
	'Select required barriers
	blnPCP_GetBarrier = PCP_GetBarrier(strRequiredBarriers,,strOutErrorDesc)
	If not blnPCP_GetBarrier Then
		strOutErrorDesc = "Unable to check required barriers. "&strOutErrorDesc
		Exit Function
	End If	
	
	'----------Select Survey option and set free form values
	'Select required survey
	blnPCP_GetSurvey = PCP_GetSurvey("Yes","freeform",strOutErrorDesc)
'	blnPCP_GetSurvey = PCP_GetSurvey("CAREPLANGOAL",strFFtext,strOutErrorDesc)
	If not blnPCP_GetSurvey Then
		strOutErrorDesc = "Unable to select survey option and set free form values. "&strOutErrorDesc
		Exit Function
	End If	
	
	'----------Save button status after providing values
	
	'Click Save button
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Save button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button for adding new Care Plan")
	Wait 2
	Call waitTillLoads("Loading...")
	
	Call WriteToLog("Pass","Added new Patient Care Paln with all details")
	
	Wait 1	
	Err.Clear
	PCP_AddPCP = True
	
End Function

Function PCP_EditPCP(ByVal strPCPEditfieldRequisites, ByVal dtDueDate, ByVal dtCompletedDate, ByVal strBarrierEdit, ByVal strEditSurvey, ByVal strFFEdit, strOutErrorDesc)
	
	'Editing with required values
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_EditPCP = False	
	
	Call WriteToLog("Info","--------Editing Patient Care Plan-------")
	
	'Sorting required values for respective fields
	strImportance = Split(strPCPEditfieldRequisites,",",-1,1)(0)
	strConfidenceLevel = Split(strPCPEditfieldRequisites,",",-1,1)(1)
	strStatus = Split(strPCPEditfieldRequisites,",",-1,1)(2)
	strBehavioralPlan = Split(strPCPEditfieldRequisites,",",-1,1)(3)
	strEngagementPlan = Split(strPCPEditfieldRequisites,",",-1,1)(4)
	
	'Click on Edit button is available and enabled
	Execute "Set objPCP_EditBTN ="&Environment("WEL_EditCarePlanBtn") 'PCP Edit button
	objPCP_EditBTN.highlight
	Err.Clear
	objPCP_EditBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Edit button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Edit button for edting Care Plan")
	Execute "Set objPCP_EditBTN = Nothing"
	Wait 1
	Call waitTillLoads("Loading...")
	
	'----------Main fields
	
	'Edit Importance
	Execute "Set objPCP_ImportanceLevelDD = "&Environment("WB_ImportanceLevelDD") 'PCP Importance drodown
	blnImportance = selectComboBoxItem(objPCP_ImportanceLevelDD, strImportance)
	If not blnImportance Then
		strOutErrorDesc = "Importance is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Importance is selected as '"&strImportance&"'")
	Execute "Set objPCP_ImportanceLevelDD = Nothing"
	Wait 0,250
	
	'Edit Confidence Level 
	Execute "Set objPCP_ConfidenceLevelDD = "&Environment("WB_ConfidenceLevelDD") 'PCP Confidence level dropdown
	blnConfidenceLevel = selectComboBoxItem(objPCP_ConfidenceLevelDD, strConfidenceLevel)
	If not blnConfidenceLevel Then
		strOutErrorDesc = "Confidence Level is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Confidence Level is selected as '"&strConfidenceLevel&"'")
	Execute "Set objPCP_ConfidenceLevelDD = Nothing"	
	Wait 0,250
	
	'Edit Status
	Execute "Set objPCP_StatusDD = "&Environment("WB_PatCaPlnStatus") 'PCP Status dropdown
	blnStatus = selectComboBoxItem(objPCP_StatusDD, strStatus)
	If not blnStatus Then
		strOutErrorDesc = "Status is not selected "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Status is selected as '"&strStatus&"'")
	Execute "Set objPCP_StatusDD = Nothing"		
	Wait 0,250
	
	'Edit Due date
	Execute "Set objPCP_DueDateTB = "&Environment("WE_PCP_DueDateFiled") 'PCP DueDate field
	Err.Clear	
	objPCP_DueDateTB.Set dtDueDate
	If Err.number <> 0 Then
		strOutErrorDesc = "Unable to set Due Date ."&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Due date is set to '"&dtDueDate&"'")
	Execute "Set objPCP_DueDateTB = Nothing"
	Wait 0,250
	
	'Edit Completed date as required
	If LCase(Trim(dtCompletedDate)) <> "na" Then
		Execute "Set objPCP_CompletedDateTB = "&Environment("WE_PCP_CompletedDateFiled") 'PCP CompletedDate field
		Err.Clear	
		objPCP_CompletedDateTB.Set dtCompletedDate
		If Err.number <> 0 Then
			strOutErrorDesc = "Unable to set Completed Date ."&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Completed date is set to '"&dtCompletedDate&"'")
		Execute "Set objPCP_CompletedDateTB = Nothing"
	End If
	Wait 0,250		
	
	'Edit Behavioral Plan 
	Execute "Set objPCP_BehavioralPlanTB = "&Environment("WE_PatCaPlnBePln") 'PCP BehavioralPlan field	
	Err.Clear
	objPCP_BehavioralPlanTB.Set strBehavioralPlan
	If Err.Number <> 0 Then
		strOutErrorDesc = "Behavioral Plan is not set. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Behavioral Plan is set as '"&strBehavioralPlan&"'")
	Execute "Set objPCP_BehavioralPlanTB = Nothing"		
	Wait 0,250
	
	'Edit Engagement Plan 
	Execute "Set objPCP_EngagementPlanTB = "&Environment("WE_EngagementPlan") 'PCP Engagement plan field		
	Err.Clear
	objPCP_EngagementPlanTB.Set strEngagementPlan
	If Err.Number <> 0 Then
		strOutErrorDesc = "Engagement Plan is not set. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Engagement Plan is set as '"&strEngagementPlan&"'")
	Execute "Set objPCP_EngagementPlanTB = Nothing"		
	Wait 0,250	
	
	'----------Edit Barriers
	blnPCP_GetBarrier = PCP_GetBarrier(strBarrierEdit,,strOutErrorDesc)
	If not blnPCP_GetBarrier Then
		strOutErrorDesc = "Unable to check required barriers. "&strOutErrorDesc
		Exit Function
	End If		
	
	'----------if required Edit Survey option and set free form value
	If LCase(Trim(strEditSurvey)) = "yes" Then
		'Edit required survey
		blnPCP_GetSurvey = PCP_GetSurvey("Yes","freeform",strOutErrorDesc)
'		blnPCP_GetSurvey = PCP_GetSurvey("CAREPLANGOAL",strFFEdit,strOutErrorDesc)
		If not blnPCP_GetSurvey Then
			strOutErrorDesc = "Unable to select survey option and set free form values. "&strOutErrorDesc
			Exit Function
		End If
	End If
		
	'----------Save button status after editing values
	
	'Click Save button
	Execute "Set objPCP_SaveBTN ="&Environment("WEL_PatCaPlnSave") 'PCP Save button
	Err.Clear
	objPCP_SaveBTN.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Save button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Save button for adding new Care Plan")
	Wait 2
	Call waitTillLoads("Loading...")
	
	Call WriteToLog("Pass","Patient Care Paln is edited with required values")
	
	Wait 1	
	Err.Clear
	PCP_EditPCP = True
	
End Function
'******************************************************************************************************************************************************************


'******************************************************************************************************************************************************************
Function PCP_PatientCareReportValidations(ByVal strReportValues, ByVal dtDueDate, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_PatientCareReportValidations = False
	
	Call WriteToLog("Info","--------Validate BehavioralPlan, ClinicalRelevance and Duedate in Patient Care Report after saving Care Plan-------")
		
	'Click Print Report icon
	Execute "Set objPrintReportMain = " & Environment("WEL_PrintReportMain")
	Err.Clear
	objPrintReportMain.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Print Report icon. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Print Report icon")
	Execute "Set objPrintReportMain = Nothing"
	Wait 3
	Call waitTillLoads("Loading...")
	
	'Check availablity of Choose Reports popup
	Execute "Set objChooseReportsPP = " & Environment("WEL_ChooseReportsPP")
	If not objChooseReportsPP.Exist(3) Then
		strOutErrorDesc = "Choose Reports popup is unavailable after clicking Print Report icon. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Choose Reports popup is available after clicking Print Report icon")
	Execute "Set objChooseReportsPP = Nothing"
	
	'Click Patient Care report
	Execute "Set objChooseReportsPP_PCP_RB = " & Environment("WEL_ChooseReportsPP_PCP_RB")
	Err.Clear
	objChooseReportsPP_PCP_RB.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Patient Care Report radio button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Patient Care Report radio button")
	Execute "Set objChooseReportsPP_PCP_RB = Nothing"
	Wait 1
	
	'Select report language as English
	Execute "Set objChooseReportsPP_LanguageDD = " & Environment("WEL_ChooseReportsPP_LanguageDD")
	objChooseReportsPP_LanguageDD.highlight
	Set oDD_Desc = Description.Create	
	oDD_Desc("micclass").Value = "WebButton"
	Set objDD_Btn = objChooseReportsPP_LanguageDD.ChildObjects(oDD_Desc)
	blnLanguage = selectComboBoxItem(objDD_Btn(0), "English")
	If not blnLanguage Then
		strOutErrorDesc = "Unable to select Language from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Report language is selected as 'English'")
	Execute "Set objChooseReportsPP_LanguageDD = Nothing"
	Set oDD_Desc = Nothing
	Wait 0,250
	
	'Click OK button
	Execute "Set objChooseReportsPP_OK = " & Environment("WEL_ChooseReportsPP_OK")
	Err.Clear
	objChooseReportsPP_OK.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Choose Report OK button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Choose Report OK button")
	Execute "Set objChooseReportsPP_OK = Nothing"
	Wait 1
	
	'Close Report dialogbox if exists	
	Set objReportDialog = Browser("name:=DaVita VillageHealth Capella").Dialog("regexpwndtitle:=Internet Explorer","text:=Internet Explorer","visible:=True")
	If objReportDialog.Exist(10) Then
		objReportDialog.highlight
		Set objWShell = CreateObject("WScript.Shell")
		objWShell.SendKeys "{ENTER}"
	'	objWShell.SendKeys"%{F4}"
	End If
	Set objReportScroll = Browser("name:=DaVita VillageHealth Capella").WinScrollBar("nativeclass:=ScrollBar","visible:=True")

	'Wait till (or 50 secs) report exist
	If objReportScroll.Exist(50) Then
		Wait 1	
		'Validate Patient Care Report availability
		Set objPatientCareReport = getPageObject().WinObject("object class:=AVL_AVView","text:=AVPageView")
		If not waitUntilExist(objPatientCareReport, 10) Then	
			Call WriteToLog("Fail","Patient Care Report is not available")
			Exit Function
		End If
		Call WriteToLog("Pass","Patient Care Report is available")
		Set objPatientCareReport = Nothing
		Wait 1
		
		'Get content of Patient care report
		strPatientCareReportContent = ""
		Set objPatientCareReport = getPageObject().WinObject("object class:=AVL_AVView","text:=AVPageView")
		strPatientCareReportContent = GetDocumentContent(objPatientCareReport)
		If strPatientCareReportContent = "" Then
			Call WriteToLog("Fail","Unable to fetch content from Patient Care Report")
			Exit Function
		End If
		Call WriteToLog("Pass","Fetched content from Patient Care Report")
		Set objPatientCareReport = Nothing
		
		'Validate BehavioralPlan, ClinicalRelevance and Duedate in Patient Care Report
		
		strBehavioralPlan = Split(strReportValues,",",-1,1)(6)
		strClinicalRelevance = Split(strReportValues,",",-1,1)(1)
		strGoalDateDoc = "GoalDate:"&dtDueDate
		
		strPatientCareReportContent = LCase(Replace(strPatientCareReportContent," ","",1,-1,1))
		strBehavioralPlan = LCase(Replace(strBehavioralPlan," ","",1,-1,1))
		strClinicalRelevance = LCase(Replace(strClinicalRelevance," ","",1,-1,1))
		strGoalDateDoc = LCase(Replace(strGoalDateDoc," ","",1,-1,1))
		
		'Validate BehavioralPlan in Patient Care Report
		If Instr(1,strPatientCareReportContent,strBehavioralPlan,1) <= 0 Then
			strOutErrorDesc = "Behavioral Plan '"&strBehavioralPlan&"' is not displayed in Patient Care Report"
			Exit Function
		End If
		Call WriteToLog("Pass","Behavioral 	Plan '"&strBehavioralPlan&"' is displayed in Patient Care Report")
		
		'Validate ClinicalRelevance in Patient Care Report
		If Instr(1,strPatientCareReportContent,strClinicalRelevance,1) <= 0 Then
			strOutErrorDesc = "Clinical Relevance '"&strClinicalRelevance&"' is not displayed in Patient Care Report"
			Exit Function
		End If
		Call WriteToLog("Pass","Clinical Relevance '"&strClinicalRelevance&"' is displayed in Patient Care Report")
		
		'Validate Due date in Patient Care Report
		If Instr(1,strPatientCareReportContent,strClinicalRelevance,1) <= 0 Then
			strOutErrorDesc = "Due date '"&strGoalDateDoc&"' is not displayed in Patient Care Report"
			Exit Function
		End If
		Call WriteToLog("Pass","Due date '"&strGoalDateDoc&"' is displayed in Patient Care Report")
		
		'Click close report button
		Execute "Set objPateintCareReportClose = " & Environment("WI_PateintCareReportClose")
		Err.Clear
		objPateintCareReportClose.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click Patient Care Report Close button. "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked Patient Care Report Close button")
		Execute "Set objPateintCareReportClose = Nothing"
		
	End If 
	Set objReportDialog = Nothing
	Set objReportReport = Nothing


	Wait 1	
	Err.Clear
	PCP_PatientCareReportValidations = True
	
	Call WriteToLog("Pass","Validated BehavioralPlan, ClinicalRelevance and Duedate in Patient Care Report after saving Care Plan")
	
	'-----------------------------------------
	'Navigate back to Patient Care Plan screen
	blnPCP_ScreenNavigation = PCP_ScreenNavigation(strOutErrorDesc)
	If not blnPCP_ScreenNavigation Then 
		Exit Function
	End If	
	'-----------------------------------------
	
End Function
'******************************************************************************************************************************************************************


'******************************************************************************************************************************************************************
Function PCP_ToolTipMsgValidation(ByVal objMouseoverObject, ByVal strReqdMouseoverMsg, ByVal blnClkReqd, strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_ToolTipMsgValidation = False
	
	objMouseoverObject.highlight
	Wait 0,250
	
	'Setting the replay type for mouseover
	Setting.WebPackage("ReplayType") = 2 
	
	'Ff required click the objectto get mouse hover value 
	If Lcase(Trim(blnClkReqd)) = "yes" Then
		Err.Clear
		objMouseoverObject.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click object to get mouser over value. "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked object to get mouser over value")
		Wait 0,250
	End If
	
	'Get mouseover value
	objMouseoverObject.FireEvent "onmouseover"
	wait 1
	
	strMouseoverValue = ""
	strMouseoverValue = getPageObject().WebElement("class:=.*message-tooltip*","html tag:=DIV").Object.outertext
	Setting.WebPackage("ReplayType") = 1
	
	If strMouseoverValue = "" Then	
		strOutErrorDesc = "No mousehover message / Unable to retrieve mouseover message"	
		Exit Function
	End If
	
	If Instr(1,LCase(Trim(Replace(strMouseoverValue," ","",1,-1,1))),LCase(Trim(Replace(strReqdMouseoverMsg," ","",1,-1,1))),1) > 0 Then
		PCP_ToolTipMsgValidation = True
	Else
		strOutErrorDesc = "Retrieved mouser hover message is '"&strMouseoverValue&"' and required message is '"&strReqdMouseoverMsg&"'"
		Exit Function
	End If
	
	Wait 0,100
	Err.Clear
	
End Function

Function DateFormatForGoals(ByVal dtDateInGoals)

	If Instr(1,dtDateInGoals,"/0",1) Then
		dtDateInGoals = Replace(dtDateInGoals,"/0","/",1,-1,1)
	End If
	If Left(dtDateInGoals,1) = "0" Then
		dtDateInGoals = Replace(dtDateInGoals,Left(dtDateInGoals,1),"",1,1,1)
	End If
	DateFormatForGoals= dtDateInGoals
	
End Function

Function PCP_DueIcon()
	
	On Error Resume Next
	Err.Clear
	
	Execute "Set objDueIcon = " & Environment("WI_PCP_OverDueIcon")
	
	If objDueIcon.Exist(2) Then
		PCP_DueIcon = True
	Else
		PCP_DueIcon = False
	End If	
	
	Execute "Set objDueIcon = Nothing"

End Function

Function PCP_SelectPCPforEdit(ByVal strCarePlanTopicForEdit, ByVal strClinicalRelevanceForEdit, ByVal dtDueDateForEdit, ByVal strStatusForEdit, strOutErrorDesc)
	
	'Editing Patient Care Plan with required values
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_SelectPCPforEdit = False	
	
	'Select the required care plan for editing
	Execute "Set objPCP_CarePlanTable = "&Environment("WT_PCP_CarePlanTable") 'Care plan table
	intCarePlanTopicRC = objPCP_CarePlanTable.RowCount
	
	FoundFlag = False
	
	For CPT_RC = 1 To intCarePlanTopicRC Step 1
	
		strExistingCarePlanTopic = objPCP_CarePlanTable.GetCellData(CPT_RC,2) '2 is the column number for CarePlanTopic in CarePlan table
		strExistingClinicalRelevance = objPCP_CarePlanTable.GetCellData(CPT_RC,3) '3 is the column number for ClinicalRelevance in CarePlan table
		dtExistingDueDate = objPCP_CarePlanTable.GetCellData(CPT_RC,4) '4 is the column number for DueDate in CarePlan table
		strExistingStatus = objPCP_CarePlanTable.GetCellData(CPT_RC,5) '5 is the column number for Status in CarePlan table
		
		If Instr(1,LCase(Trim(Replace(strExistingCarePlanTopic," ","",1,-1,1))),LCase(Trim(Replace(strCarePlanTopicForEdit," ","",1,-1,1))),1) > 0 _
			AND Instr(1,LCase(Trim(Replace(strExistingClinicalRelevance," ","",1,-1,1))),LCase(Trim(Replace(strClinicalRelevanceForEdit," ","",1,-1,1))),1) > 0 _
			AND Instr(1,LCase(Trim(Replace(dtExistingDueDate," ","",1,-1,1))),LCase(Trim(Replace(dtDueDateForEdit," ","",1,-1,1))),1) > 0 _
			AND Instr(1,LCase(Trim(Replace(strExistingStatus," ","",1,-1,1))),LCase(Trim(Replace(strStatusForEdit," ","",1,-1,1))),1) > 0	Then
			
			Setting.WebPackage("ReplayType") = 2
			Err.Clear
			objPCP_CarePlanTable.ChildItem(CPT_RC,2,"WebElement",0).highlight
			objPCP_CarePlanTable.ChildItem(CPT_RC,2,"WebElement",0).FireEvent "onClick"
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to select required CarePlan from CarePlan table. "&Err.Description
				Exit Function
			End If 
			Setting.WebPackage("ReplayType") = 1
			
			FoundFlag = True
			Call WriteToLog("Pass","Selected required CarePlan from CarePlan table")
			
			Exit For
			
		End If
		
	Next
	
	Execute "Set objPCP_CarePlanTable = Nothing"
	
	Wait 1
	Call waitTillLoads("Loading...")
	
	Err.Clear	
	If FoundFlag Then
		PCP_SelectPCPforEdit = True
	End If	
	
End Function

'eg. of call: blnPCP_GetBarrier = PCP_GetBarrier("Poor Habits/Practices,Knowledge Deficit,Equipment Issue,Psychological,Other","other barrier value",strOutErrorDesc)
'if 'No Barriers' is to be selected then no need to put any other barriers
'blnPCP_GetBarrier = PCP_GetBarrier("No Barriers",,strOutErrorDesc)
'if 'Other' is to be selected then text value should also be provided 
'(eg: blnPCP_GetBarrier = PCP_GetBarrier("Poor Habits/Practices,Knowledge Deficit,Equipment Issue,Other","other barrier value",strOutErrorDesc)
'if 'Other' is not to be selected then put only "," to keep the place holder
'(eg: blnPCP_GetBarrier = PCP_GetBarrier("Poor Habits/Practices,Knowledge Deficit,Equipment Issue",,strOutErrorDesc)
Function PCP_GetBarrier(ByVal strBarriers, ByVal strOtherBarrierValue, strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_GetBarrier = False	

	intRequiredBarrierCount = UBound(Split(strBarriers,",",-1,1))+1
	

	For ib = 1 To intRequiredBarrierCount Step 1
	
		strBarrier = Split(strBarriers,",",-1,1)(ib-1)
		strBarrier = LCase(Trim(Replace(Replace(strBarrier," ","",1,-1,1),"/","",1,-1,1)))
		
		Select Case strBarrier
		
			Case "poorhabitspractices"
				Execute "Set objPCP_PoorHabits_BarrierCB = "&Environment("WEL_PCP_PoorHabits_BarrierCB") 'Poor Habits/Practices check box
				Err.Clear
				objPCP_PoorHabits_BarrierCB.Click	
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked Poor Habits/Practices barrier check box")
				Execute "Set objPCP_PoorHabits_BarrierCB = Nothing"
				Wait 0,250
				
			Case "knowledgedeficit"
				Execute "Set objPCP_KnowledgeDeficit_BarrierCB = "&Environment("WEL_PCP_KnowledgeDeficit_BarrierCB") 'Knowledge Deficit check box
				Err.Clear
				objPCP_KnowledgeDeficit_BarrierCB.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If	
				Call WriteToLog("Pass","Clicked Knowledge Deficit barrier check box")				
				Execute "Set objPCP_KnowledgeDeficit_BarrierCB = Nothing"
				Wait 0,250
				
			Case "equipmentissue"
				Execute "Set objPCP_EquipmentIssue_BarrierCB = "&Environment("WEL_PCP_EquipmentIssue_BarrierCB") 'Equipment Issue check box
				Err.Clear
				objPCP_EquipmentIssue_BarrierCB.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If		
				Call WriteToLog("Pass","Clicked Equipment Issue barrier check box")				
				Execute "Set objPCP_EquipmentIssue_BarrierCB = Nothing"
				Wait 0,250
				
			Case "psychological"
				Execute "Set objPCP_Psychological_BarrierCB = "&Environment("WEL_PCP_Psychological_BarrierCB") 'Psychological check box
				Err.Clear
				objPCP_Psychological_BarrierCB.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked Psychological barrier check box")
				Execute "Set objPCP_Psychological_BarrierCB = Nothing"
				Wait 0,250
				
			Case "socioeconomic"
				Execute "Set objPCP_Socioeconomic_BarrierCB = "&Environment("WEL_PCP_Socioeconomic_BarrierCB") 'Socioeconomic check box
				Err.Clear
				objPCP_Socioeconomic_BarrierCB.Click
				Call WriteToLog("Pass","Clicked Socioeconomic barrier check box")
				Execute "Set objPCP_Socioeconomic_BarrierCB = Nothing"
				Wait 0,250
				
			Case "physicallimitation"
				Execute "Set objPCP_PhysicalLimitation_BarrierCB = "&Environment("WEL_PCP_PhysicalLimitation_BarrierCB") 'Physical Limitation check box	
				Err.Clear
				objPCP_PhysicalLimitation_BarrierCB.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked Physical Limitation barrier check box")
				Execute "Set objPCP_PhysicalLimitation_BarrierCB = Nothing"
				Wait 0,250
				
			Case "nosupportsystem"
				Execute "Set objPCP_NoSupportSystem_BarrierCB = "&Environment("WEL_PCP_NoSupportSystem_BarrierCB") 'No Support System check box
				Err.Clear
				objPCP_NoSupportSystem_BarrierCB.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked No Support System barrier check box")
				Execute "Set objPCP_NoSupportSystem_BarrierCB = Nothing"
				Wait 0,250
				
			Case "other"
				Execute "Set objPCP_Other_BarrierCB = "&Environment("WEL_PCP_Other_BarrierCB") 'Other check box
				Err.Clear
				objPCP_Other_BarrierCB.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If
				Execute "Set objPCP_Other_BarrierCB = Nothing"
				Call WriteToLog("Pass","Clicked Other barrier check box")
				Wait 0,250
				
				Err.Clear
				Execute "Set objPCP_OtherTB_BarrierTB = "&Environment("WE_PCP_OtherTB_BarrierTB") 'Other field
				objPCP_OtherTB_BarrierTB.Set strOtherBarrierValue
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Other barrier value is set to '"&strOtherBarrierValue&"'")
				Execute "Set objPCP_OtherTB_BarrierTB = Nothing"
				Wait 0,250
				
			Case "nobarriers"
				Execute "Set objPCP_NoBarriers_BarrierCB = "&Environment("WEL_PCP_NoBarriers_BarrierCB") 'No Barriers check box
				Err.Clear
				objPCP_NoBarriers_BarrierCB.Click
				If Err.Number <> 0 Then
					strOutErrorDesc = Err.Description
					Exit Function
				End If
				Call WriteToLog("Pass","Clicked No Barriers check box")
				Execute "Set objPCP_NoBarriers_BarrierCB = Nothing"
				Wait 0,250
				
		End Select
		
	Next	
	
	Wait 1
	Err.Clear
	PCP_GetBarrier = True	

End Function


'PCP_GetSurvey() is divided into two:
'If user wants to complete survey without DB check, then use the 1st part, and comment the 2nd part
'	In this case 'survey_type' should be either 'Yes' or 'No'  and 'strFFvalue' should be any text value
'If user doesn't wants to complete survey without DB check, then use the 2nd part, and comment the 1st part
'	In this case 'survey_type' should be valid screening name.Eg. 'CAREPLANGOAL' and 'strFFvalue' should be any text value
Function PCP_GetSurvey(ByVal survey_type, ByVal strFFvalue, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_GetSurvey = false	
	
	'========================================================================================================
	Set objSurveyFirstQuestionRB = getPageObject().WebElement("attribute/data-capella-automation-id:=1_"&survey_type,"visible:=True")
	iSy = 1
	Do While objSurveyFirstQuestionRB.Exist(1/5)
		Set objSurveyRadioButton = getPageObject().WebElement("attribute/data-capella-automation-id:="&iSy&"_"&survey_type,"visible:=True")
		objSurveyRadioButton.highlight
		Err.Clear
		objSurveyRadioButton.click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click on survey radio button "&iSy
			Exit Function	
		End If
		Set objFreeResponseTxBx = getPageObject().WebEdit("attribute/data-capella-automation-id:="&iSy&"_option\.FreeFormResponse","visible:=True")
		If objFreeResponseTxBx.Exist(1/5) Then
			Err.Clear
			objFreeResponseTxBx.Set strFFvalue
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to set value in free form text box "&iSy
			Exit Function	
		End If
		End If	
		
		iSy = iSy+1
		
		Set objSurveyFirstQuestionRB = Nothing
		Set objSurveyFirstQuestionRB = getPageObject().WebElement("attribute/data-capella-automation-id:="&iSy&"_Yes","visible:=True")
		
		Set objFreeResponseTxBx = Nothing
		
	Loop 
	'========================================================================================================
	
	
'	'========================================================================================================
'	
'	Dim dbConnected : dbConnected = true
'	isPass = ConnectDB()
'	If Not isPass Then
'		strOutErrorDesc = "Connect to Database failed."
'		Call CloseDBConnection()
'		dbConnected = false
'	End If
'
'	Dim endOfLoop : endOfLoop = false
'	Dim k : k = 0
'	Dim qnNo : qnNo = 1
'	Dim survey_ques_uid
'	Dim survey_option_uid
'	Dim labelText
'	Dim survey_uid
'	
'	survey_uid = getActiveSurveyUid(survey_type)
'	If survey_uid = "" Then
'		CloseDBConnection
'		strOutErrorDesc = "Unable to get Survey UID"
'		Exit Function
'	End If
'	
'	Dim arr(2)
'	arr(0) = "Yes"
'	arr(1) = "No"
'	
'	Do while endOfLoop = false
'		
'		survey_ques_uid = getSurveyQuesUid(survey_uid, qnNo)
'		If survey_ques_uid = "" Then
'			CloseDBConnection
'			strOutErrorDesc = "Unable to get Survey Question UID"
'			Exit Function
'		End If
'		
'		count = getOptionCount(survey_ques_uid)
'		If count = "NA" Then
'			CloseDBConnection
'			strOutErrorDesc = "Unable to get count for survey questions"
'			Exit Function
'		End If
'		
'		For i = 1 To Cint(count)
'			Print qnNo
'			labelText = arr(i-1)
'			Print labelText
'			survey_option_uid = getQuesOptionUid(survey_ques_uid, labelText)
'			If survey_option_uid = "NA" Then
'				CloseDBConnection
'				strOutErrorDesc = "Unable to get option UID"
'				Exit Function
'			End If
'			Set ocrDesc = Description.Create
'			ocrDesc("micclass").Value = "WebElement"
'			ocrDesc("attribute/data-capella-automation-id").Value = qnNo & "_" & arr(i-1)
'			Set oRadio = getPageobject().ChildObjects(ocrDesc)
'			If oRadio.Count = 1 Then
'				Err.Clear
'				oRadio(0).highlight
'				oRadio(0).Click
'				If Err.Number <> 0 Then
'					strOutErrorDesc = "Unable to click required option. "&Err.Description
'					Exit Function
'				End If
'				wait 1
'			End If
'			
'			uid = getSkipToQuestion(survey_ques_uid, survey_option_uid)
'			If uid = "NA" Then
'				CloseDBConnection
'				strOutErrorDesc = "Unable to get skip to question UID"
'				Exit Function
'			End If
'			
'			If Not isNull(uid) Then
'				quesText = getSurveySkipToQuestionText(uid)
'				If quesText = "NA" Then
'					CloseDBConnection
'					strOutErrorDesc = "Unable to get skip to question text"
'					Exit Function
'				End If
'			
'				Set quesDesc = Description.Create
'				quesDesc("micclass").Value = "WebElement"
'				quesDesc("attribute/data-capella-automation-id").Value = "label-q.Text"
'				
'				Set objQuestions = getPageObject().ChildObjects(quesDesc)
'				uiQuestion = Trim(objQuestions(qnNo).GetROProperty("innertext"))
'				
'				If trim(uiQuestion) = quesText Then
'					Call WriteToLog("Pass", "SkipToLogic for question " & qnNo & " option " & labelText & " is correct")
'					Print "Pass" & "SkipToLogic for question " & qnNo & " option " & labelText & " is correct"
'				Else
'					strOutErrorDesc = "SkipToLogic for question " & qnNo & " option " & labelText & " is wrong"
'					Print "Fail" & "SkipToLogic for question " & qnNo & " option " & labelText & " is wrong"
'				End If
'			End If
'			
'			hasFreeformText = isOptionHasFreeForm(survey_ques_uid, survey_option_uid)
'
'			If hasFreeformText = "Y" Then
'				Set oRDesc = Description.Create
'				oRDesc("micclass").Value = "WebEdit"
'				oRDesc("attribute/data-capella-automation-id").Value = qnNo&"_option\.FreeFormResponse"
'				oRDesc("visible").value = True
'				Set oObj = getPageObject().ChildObjects(oRDesc)
'				
'				Print oObj.count
'				oObj(0).highlight
'				Err.Clear
'				oObj(0).Set strFFvalue
'				If Err.Number <> 0 Then
'					strOutErrorDesc = "Unable to set free form text. "&Err.Description
'					Exit Function
'				End If
'			End If
'			
'			k = k + 1
'			Err.Clear			
'		Next
'		
'		qnNo = qnNo + 1
'		If uid <> "Null" Then
'			qnNo = CInt(getQuesNo(uid))
'		End If
'		
'		Set olabelDesc  = Nothing
'		Set objLabel = Nothing
'		Set oRDesc = Nothing
'		Set oRadio = Nothing
'		Set ocrDesc = Nothing
'		yn = isEndOfSurvey(survey_ques_uid, count)
'		If uCase(yn) = "Y" Then
'			endOfLoop = true
'		End If
'	Loop 
'	
'	Call CloseDBConnection()
'	'========================================================================================================


	PCP_GetSurvey = true
	
End Function

'1. if all special characters (except ,'and ") are to replaced, then write strAfterReplacement as ""
'eg: strNote = GetReplacedString(strNote,"","","")
'2. write strReplacementWith delimited with ","
'eg: strNote = GetReplacedString(strNote,":,/ ",")","y")
'3. if LCase is requred, then write strLCaseRequired as "" or "y"
'eg: strNote = GetReplacedString(strNote,":,/ ",")","")
Function GetReplacedString(ByVal strAfterReplacement, ByVal strToBeReplaced, ByVal strReplacementWith, ByVal strLCaseRequired)

	If strToBeReplaced = "" Then
		strToBeReplaced = "~,`,!,@,#,$,%,^,&,*,(,),_,-,+,=,{,[,},],|,\,:,;,<,>,.,?,/, "
		arrToBeReplaced = Split(strToBeReplaced,",",-1,1)
		
		For iTBR = 0 To UBound(arrToBeReplaced) Step 1
			strAfterReplacement = Replace(strAfterReplacement,arrToBeReplaced(iTBR),strReplacementWith,1,-1,1)	
		Next
			
		strAfterReplacement = LCase(strAfterReplacement)
		
	Else
	
		arrToBeReplaced = Split(strToBeReplaced,",",-1,1)
		
		For iTBR = 0 To UBound(arrToBeReplaced) Step 1
			strAfterReplacement = Replace(strAfterReplacement,arrToBeReplaced(iTBR),strReplacementWith,1,-1,1)	
		Next
	
		If LCase(Trim(LCaseRequired)) = "y" OR LCaseRequired = "" Then
			strAfterReplacement = LCase(strAfterReplacement)
		End If
	
	End If
	
	GetReplacedString = strAfterReplacement
	
End Function
'******************************************************************************************************************************************************************


Function PCP_HistoryValidation(ByVal strCP, ByVal strCR, ByVal dtDue, ByVal strSTS, ByVal strIMP, ByVal strCL, ByVal strBP, strOutErrorDesc)
	
	'Validating Patient Care Plan History table entries
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_HistoryValidation = False	
	
	Execute "Set objPCP_HistoryTableUpArrow = "&Environment("WI_PCP_HistoryTableArrow") 'PCP history table up arrow
	Execute "Set objPCP_HistoryTableDownArrow = "&Environment("WI_PCP_HistoryTableArrow") 'PCP history table down arrow
	Execute "Set objPCP_HistoryTable = "&Environment("WT_PCP_HistoryTable") 'PCP history table	
	
	'Click history table up arror
	Err.Clear
	objPCP_HistoryTableUpArrow.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click history table up arrow"
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked history table up arrow")
	Wait 1
	
	Err.Clear
	strCP = LCase(Replace(strCP," ","",1,-1,1))
	strCR = LCase(Replace(strCR," ","",1,-1,1))
	dtDue = DateFormat(CDate(Trim(dtDue)))
	strSTS = LCase(Replace(strSTS," ","",1,-1,1))
	strIMP = LCase(Replace(strIMP," ","",1,-1,1))
	strCL = LCase(Replace(strCL," ","",1,-1,1))
	strBP = LCase(Replace(strBP," ","",1,-1,1))
	
	strHistoryTableData_Expected = strCP&strCR&dtDue&strSTS&strIMP&strCL&strBP
	
	intRC_HT = objPCP_HistoryTable.RowCount	
	
	strOutErrorDesc = ""		
	For rc = 1 To intRC_HT Step 1
	
		strCPT_HT = LCase(Replace(objPCP_HistoryTable.GetCellData(rc,1)," ","",1,-1,1))	'Care Plan Topic is available in 1st column of history table
		strCR_HT = LCase(Replace(objPCP_HistoryTable.GetCellData(rc,2)," ","",1,-1,1))	'Clinical Relevance is available in 2nd column of history table
		dtDue_HT = DateFormat(CDate(Trim(objPCP_HistoryTable.GetCellData(rc,3))))	'Due date is available in 3rd column of history table
		strSTS_HT = LCase(Replace(objPCP_HistoryTable.GetCellData(rc,4)," ","",1,-1,1))	'Status is available in 4th column of history table 
		strIMP_HT = LCase(Replace(objPCP_HistoryTable.GetCellData(rc,5)," ","",1,-1,1))	'Importance is available in 5th column of history table 
		strCL_HT = LCase(Replace(objPCP_HistoryTable.GetCellData(rc,6)," ","",1,-1,1))	'Confidence Level is available in 6th column of history table 
		strBP_HT = LCase(Replace(objPCP_HistoryTable.GetCellData(rc,7)," ","",1,-1,1))	'Behavioral Plan text is available in 7th column of history table 
		
		strHistoryTableData_Actual = strCPT_HT&strCR_HT&dtDue_HT&strSTS_HT&strIMP_HT&strCL_HT&strBP_HT
		
		If strComp(strHistoryTableData_Expected,strHistoryTableData_Actual,1) <> 0 Then
			strOutErrorDesc = "History table is not populated with required data as expected"
		Else
			strOutErrorDesc = ""
			PCP_HistoryValidation = True
			Call WriteToLog("Pass","History table is populated with Care Plan Topic: "&strCR_HT)
			Call WriteToLog("Pass","History table is populated with Clinical Relevance: "&strCR_HT)
			Call WriteToLog("Pass","History table is populated with Due date: "&strCR_HT)
			Call WriteToLog("Pass","History table is populated with Status: "&strCR_HT)
			Call WriteToLog("Pass","History table is populated with Importance: "&strCR_HT)
			Call WriteToLog("Pass","History table is populated with Confidence: "&strCR_HT)
			Call WriteToLog("Pass","History table is populated with Behavioral Plan text: "&strCR_HT)
			Exit For
		End If	
	
	Next	

	Execute "Set objPCP_HistoryTableUpArrow = Nothing"
	Execute "Set objPCP_HistoryTableDownArrow = Nothing"
	Execute "Set objPCP_HistoryTable = Nothing"
	
End Function

Function PCP_PCR_NoData_Validation(ByVal strPersonalCareSummary, strOutErrorDesc)

	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_PCR_NoData_Validation = False
	
	Call WriteToLog("Info","--------Validate no data in Patient Care Report after editing Care Plan with status Cancelled/Met/Partially Met/Unmet-------")
		
	'Click Print Report icon
	Execute "Set objPrintReportMain = " & Environment("WEL_PrintReportMain")
	Err.Clear
	objPrintReportMain.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Print Report icon. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Print Report icon")
	Execute "Set objPrintReportMain = Nothing"
	Wait 3
	Call waitTillLoads("Loading...")
	
	'Check availablity of Choose Reports popup
	Execute "Set objChooseReportsPP = " & Environment("WEL_ChooseReportsPP")
	If not objChooseReportsPP.Exist(3) Then
		strOutErrorDesc = "Choose Reports popup is unavailable after clicking Print Report icon. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Choose Reports popup is available after clicking Print Report icon")
	Execute "Set objChooseReportsPP = Nothing"
	
	'Click Patient Care report
	Execute "Set objChooseReportsPP_PCP_RB = " & Environment("WEL_ChooseReportsPP_PCP_RB")
	Err.Clear
	objChooseReportsPP_PCP_RB.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Patient Care Report radio button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Patient Care Report radio button")
	Execute "Set objChooseReportsPP_PCP_RB = Nothing"
	Wait 1
	
	'Select report language as English
	Execute "Set objChooseReportsPP_LanguageDD = " & Environment("WEL_ChooseReportsPP_LanguageDD")
	objChooseReportsPP_LanguageDD.highlight
	Set oDD_Desc = Description.Create	
	oDD_Desc("micclass").Value = "WebButton"
	Set objDD_Btn = objChooseReportsPP_LanguageDD.ChildObjects(oDD_Desc)
	blnLanguage = selectComboBoxItem(objDD_Btn(0), "English")
	If not blnLanguage Then
		strOutErrorDesc = "Unable to select Language from dropdown. "&strOutErrorDesc
		Exit Function
	End If
	Call WriteToLog("Pass","Report language is selected as 'English'")
	Execute "Set objChooseReportsPP_LanguageDD = Nothing"
	Set oDD_Desc = Nothing
	Wait 0,250
	
	'Click OK button
	Execute "Set objChooseReportsPP_OK = " & Environment("WEL_ChooseReportsPP_OK")
	Err.Clear
	objChooseReportsPP_OK.Click
	If Err.Number <> 0 Then
		strOutErrorDesc = "Unable to click Choose Report OK button. "&Err.Description
		Exit Function
	End If
	Call WriteToLog("Pass","Clicked Choose Report OK button")
	Execute "Set objChooseReportsPP_OK = Nothing"
	Wait 1
	
	'Close Report dialogue if exists	
	Set objReportDialog = Browser("name:=DaVita VillageHealth Capella").Dialog("regexpwndtitle:=Internet Explorer","text:=Internet Explorer","visible:=True")
	If objReportDialog.Exist(10) Then
		objReportDialog.highlight
		Set objWShell = CreateObject("WScript.Shell")
		objWShell.SendKeys "{ENTER}"
	'	objWShell.SendKeys"%{F4}"
	End If
	Set objReportScroll = Browser("name:=DaVita VillageHealth Capella").WinScrollBar("nativeclass:=ScrollBar","visible:=True")

	'Wait till (or 50 secs) report exist
	If objReportScroll.Exist(50) Then
		Wait 1	
		'Validate Patient Care Report availability
	
		'Validate Patient Care Report availability
		Set objPatientCareReport = getPageObject().WinObject("object class:=AVL_AVView","text:=AVPageView")
		If not waitUntilExist(objPatientCareReport, 10) Then	
			Call WriteToLog("Fail","Patient Care Report is not available")
			Exit Function
		End If
		Call WriteToLog("Pass","Patient Care Report is available")
		Set objPatientCareReport = Nothing
		Wait 1
		
		'Get content of Patient care report
		strPatientCareReportContent = ""
		Set objPatientCareReport = getPageObject().WinObject("object class:=AVL_AVView","text:=AVPageView")
		strPatientCareReportContent = GetDocumentContent(objPatientCareReport)
		If strPatientCareReportContent = "" Then
			Call WriteToLog("Fail","Unable to fetch content from Patient Care Report")
			Exit Function
		End If
		Call WriteToLog("Pass","Fetched content from Patient Care Report")
		Set objPatientCareReport = Nothing
		
		'Validate Personal Care Summary in Patient Care Report
		If Instr(1,Lcase(Replace(strPatientCareReportContent," ","",1,-1,1)),Lcase(Replace(strPersonalCareSummary," ","",1,-1,1)),1) > 0 Then
			strOutErrorDesc = strPersonalCareSummary&"' is not displayed in Patient Care Report"
			Exit Function
		End If
		Call WriteToLog("Pass",strPersonalCareSummary&"' is not displayed in Patient Care Report as expected")
		
		'Click close report button
		Execute "Set objPateintCareReportClose = " & Environment("WI_PateintCareReportClose")
		Err.Clear
		objPateintCareReportClose.Click
		If Err.Number <> 0 Then
			strOutErrorDesc = "Unable to click Patient Care Report Close button. "&Err.Description
			Exit Function
		End If
		Call WriteToLog("Pass","Clicked Patient Care Report Close button")
		Execute "Set objPateintCareReportClose = Nothing"
		wait 1
	
		Execute "Set objPateintCareReportClose = Nothing"
		
	End If 
	
	Set objReportDialog = Nothing
	Set objReportReport = Nothing


	Wait 1	
	PCP_PCR_NoData_Validation = True
	
	'-----------------------------------------
	'Navigate back to Patient Care Plan screen
	blnPCP_ScreenNavigation = PCP_ScreenNavigation(strOutErrorDesc)
	If not blnPCP_ScreenNavigation Then 
		Exit Function
	End If	
	'-----------------------------------------
	
End Function


Function PCP_Dulicates(ByVal intDuplicateVals, ByVal strCarePlanTopicForEdit, ByVal strClinicalRelevanceForEdit, ByVal dtDueDateForEdit, ByVal strStatusForEdit, strOutErrorDesc)
	
	On Error Resume Next
	Err.Clear
	strOutErrorDesc = ""
	PCP_Dulicates = False	
	
	Call WriteToLog("Info","--------Validate active care plan table for duplicate care plan entries and validate Open Patient tray impact on adding multiple care plans-------")
	
	'check active care plan table for duplicate care plan entries
	Execute "Set objPCP_CarePlanTable = "&Environment("WT_PCP_CarePlanTable") 'Care plan table
	intCarePlanTopicRC = objPCP_CarePlanTable.RowCount
	
	FoundFlag = False
	intCP_count = 0
	
	For CPT_RC = 1 To intCarePlanTopicRC Step 1
	
		strExistingCarePlanTopic = objPCP_CarePlanTable.GetCellData(CPT_RC,2) '2 is the column number for CarePlanTopic in CarePlan table
		strExistingClinicalRelevance = objPCP_CarePlanTable.GetCellData(CPT_RC,3) '3 is the column number for ClinicalRelevance in CarePlan table
		dtExistingDueDate = objPCP_CarePlanTable.GetCellData(CPT_RC,4) '4 is the column number for DueDate in CarePlan table
		strExistingStatus = objPCP_CarePlanTable.GetCellData(CPT_RC,5) '5 is the column number for Status in CarePlan table
		
		If Instr(1,LCase(Trim(Replace(strExistingCarePlanTopic," ","",1,-1,1))),LCase(Trim(Replace(strCarePlanTopicForEdit," ","",1,-1,1))),1) > 0 _
			AND Instr(1,LCase(Trim(Replace(strExistingClinicalRelevance," ","",1,-1,1))),LCase(Trim(Replace(strClinicalRelevanceForEdit," ","",1,-1,1))),1) > 0 _
			AND Instr(1,LCase(Trim(Replace(dtExistingDueDate," ","",1,-1,1))),LCase(Trim(Replace(dtDueDateForEdit," ","",1,-1,1))),1) > 0 _
			AND Instr(1,LCase(Trim(Replace(strExistingStatus," ","",1,-1,1))),LCase(Trim(Replace(strStatusForEdit," ","",1,-1,1))),1) > 0	Then
			
			Setting.WebPackage("ReplayType") = 2
			Err.Clear
			objPCP_CarePlanTable.ChildItem(CPT_RC,2,"WebElement",0).highlight
			objPCP_CarePlanTable.ChildItem(CPT_RC,2,"WebElement",0).FireEvent "onClick"
			If Err.Number <> 0 Then
				strOutErrorDesc = "Unable to select required CarePlan from CarePlan table. "&Err.Description
				Exit Function
			End If 
			Setting.WebPackage("ReplayType") = 1
			
			FoundFlag = True
			Call WriteToLog("Pass","Selected required CarePlan from CarePlan table")
			
			intCP_count = intCP_count+1
			
		End If
		
	Next
	
	Flag1 = False
	If intDuplicateVals = intCP_count Then
		Flag1 = True
	End If		
	
	'Check Open Patient tray browsing icon impact on adding multiple care plans
	intBIcount = 0
	'Validate - After adding Care plan to a new patient one more browsing icon should be visible in Open Patient Tray	
	Set oDescBI = Description.Create
	oDescBI("micclass").Value = "WebElement"
	oDescBI("class").Value = ".*binoculars recap-contact-footer-small-icon.*"	
	oDescBI("class").RegularExpression = True
	oDescBI("html tag").Value = "SPAN"
	oDescBI("visible").Value = True
	
	Set objBrowsingIcons = getPageObject().ChildObjects(oDescBI)
	intBIcount = objBrowsingIcons.Count
	Flag2 = False
	
	'After adding Care plan to a new patient one more browsing icon should be visible in Open Patient Tray
	If intBIcount > 2 Then
		strOutErrorDesc = "After adding multiple care plans, more than two browsing icons are visible in Open Patient Tray"
		Exit Function
	Else
		Call WriteToLog("Pass","After adding multiple care plans, required number of browsing icons are visible in Open Patient Tray")
		Flag2 = True
	End If
	
	Set oDescBI = Nothing
	Set objBrowsingIcons = Nothing
	
	Execute "Set objPCP_CarePlanTable = Nothing"
	
	If Flag1 AND Flag2 Then
		PCP_Dulicates = True
	End If
	
	
End Function


'
'Function PCP_GetSurvey(ByVal strSurvey_AllValues, strOutErrorDesc)
'	
'	On Error Resume Next
'	Err.Clear
'	strOutErrorDesc = ""
'	PCP_GetSurvey = False
'
'	arrSurvey_AllValues = Split(strSurvey_AllValues,"|",-1,1)
'	
'	For iSvy = 0 To UBound(arrSurvey_AllValues) Step 1
'	
'		strSurvey = arrSurvey_AllValues(iSvy)
'		strOption = Split(strSurvey,",",-1,1)(0)
'		strFreeFormValue = Split(strSurvey,",",-1,1)(1)
'		
'		Select Case iSvy
'		
'			Case 0
'				If LCase(Trim(strOption)) = "yes" Then
'					Execute "Set objPCP_Ques1UnderstandCP_YesRdBtn = "&Environment("WEL_PCP_Ques1UnderstandCP_YesRdBtn") 'Understand care plan Yes radio button
'					Err.Clear
'					objPCP_Ques1UnderstandCP_YesRdBtn.Click
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","Selected 'Yes' option for 'Does patient/caregiver understand care plan?' survey question")
'				
'				Else
'					Execute "Set objPCP_Ques1UnderstandCP_NoRdBtn = "&Environment("WEL_PCP_Ques1UnderstandCP_NoRdBtn") 'Understand care plan No radio button	
'					Err.Clear
'					objPCP_Ques1UnderstandCP_NoRdBtn.Click	
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","Selected 'No' option for 'Does patient/caregiver understand care plan?' survey question")
'					
'					Execute "Set objPCP_1FreeFormResponse = "&Environment("WE_PCP_1FreeFormResponse") 'PCP Freeform text field 1
'					Err.Clear
'					objPCP_1FreeFormResponse.Set strFreeFormValue
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","'"&strFreeFormValue&"' free form text is provided for 'Does patient/caregiver understand care plan?' survey question")
'				End If
'				
'				Execute "Set objPCP_Ques1UnderstandCP_YesRdBtn = Nothing"
'				Execute "Set objPCP_Ques1UnderstandCP_NoRdBtn = Nothing"
'				Execute "Set objPCP_1FreeFormResponse = Nothing"
'				Wait 0,250
'				
'			Case 1
'				If LCase(Trim(strOption)) = "yes" Then
'					Execute "Set objPCP_Ques2AgreeCP_YesRdBtn = "&Environment("WEL_PCP_Ques2AgreeCP_YesRdBtn") 'Agree care plan Yes radio button
'					Err.Clear
'					objPCP_Ques2AgreeCP_YesRdBtn.Click
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","Selected 'Yes' option for 'Patient / caregiver verbally agree to follow care plan?' survey question")
'				Else
'					Execute "Set objPCP_Ques2AgreeCP_NoRdBtn = "&Environment("WEL_PCP_Ques2AgreeCP_NoRdBtn") 'Agree care plan No radio button	
'					Err.Clear
'					objPCP_Ques2AgreeCP_NoRdBtn.Click	
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","Selected 'No' option for 'Patient / caregiver verbally agree to follow care plan?' survey question")
'					
'					Execute "Set objPCP_2FreeFormResponse = "&Environment("WE_PCP_2FreeFormResponse") 'PCP Freeform text field 2
'					Err.Clear
'					objPCP_2FreeFormResponse.Set strFreeFormValue	
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","'"&strFreeFormValue&"' free form text is provided for 'Patient / caregiver verbally agree to follow care plan?' survey question")
'				End If
'				
'				Execute "Set objPCP_Ques2AgreeCP_YesRdBtn = Nothing"
'				Execute "Set objPCP_Ques2AgreeCP_NoRdBtn = Nothing"
'				Execute "Set objPCP_2FreeFormResponse = Nothing"
'				Wait 0,250
'				
'			Case 2
'				If LCase(Trim(strOption)) = "yes" Then
'					Execute "Set objPCP_Ques3SelfManagement_YesRdBtn = "&Environment("WEL_PCP_Ques3SelfManagement_YesRdBtn") 'Self Management Yes radio button
'					Err.Clear
'					objPCP_Ques3SelfManagement_YesRdBtn.Click
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","Selected 'Yes' option for 'Is patient doing any self management?' survey question")
'					
'					Execute "Set objPCP_3FreeFormResponse = "&Environment("WE_PCP_3FreeFormResponse") 'PCP Freeform text field 3
'					Err.Clear
'					objPCP_3FreeFormResponse.Set strFreeFormValue
'					Call WriteToLog("Pass","'"&strFreeFormValue&"' free form text is provided for 'Is patient doing any self management?' survey question")
'				Else
'					Execute "Set objPCP_Ques3SelfManagement_NoRdBtn = "&Environment("WEL_PCP_Ques3SelfManagement_NoRdBtn") 'Self Management No radio button	
'					Err.Clear
'					objPCP_Ques3SelfManagement_NoRdBtn.Click	
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","Selected 'No' option for 'Is patient doing any self management?' survey question")
'					
'					Execute "Set objPCP_3FreeFormResponse = "&Environment("WE_PCP_3FreeFormResponse") 'PCP Freeform text field 3
'					Err.Clear
'					objPCP_3FreeFormResponse.Set strFreeFormValue
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","'"&strFreeFormValue&"' free form text is provided for 'Is patient doing any self management?' survey question")
'				End If	
'
'				Execute "Set objPCP_Ques3SelfManagement_YesRdBtn = Nothing"
'				Execute "Set objPCP_Ques3SelfManagement_NoRdBtn = Nothing"
'				Execute "Set objPCP_3FreeFormResponse = Nothing"
'				Wait 0,250		
'				
'				
'			Case 3
'				If LCase(Trim(strOption)) = "yes" Then
'					Execute "Set objPCP_Ques4NeedSelfManagement_YesRdBtn = "&Environment("WEL_PCP_Ques4NeedSelfManagement_YesRdBtn") 'need self management Yes radio button
'					Err.Clear
'					objPCP_Ques4NeedSelfManagement_YesRdBtn.Click
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","Selected 'Yes' option for 'Does patient need self management?' survey question")
'					
'					Execute "Set objPCP_4FreeFormResponse = "&Environment("WE_PCP_4FreeFormResponse") 'PCP Freeform text field 4
'					Err.Clear
'					objPCP_4FreeFormResponse.Set strFreeFormValue
'					Call WriteToLog("Pass","'"&strFreeFormValue&"' free form text is provided for 'Does patient need self management?' survey question")
'				Else
'					Execute "Set objPCP_Ques4NeedSelfManagement_NoRdBtn = "&Environment("WEL_PCP_Ques4NeedSelfManagement_NoRdBtn") 'need self management No radio button
'					Err.Clear
'					objPCP_Ques4NeedSelfManagement_NoRdBtn.Click	
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","Selected 'No' option for 'Does patient need self management?' survey question")
'					
'					Execute "Set objPCP_4FreeFormResponse = "&Environment("WE_PCP_4FreeFormResponse") 'PCP Freeform text field 4
'					Err.Clear
'					objPCP_4FreeFormResponse.Set strFreeFormValue
'					If Err.Number <> 0 Then
'						strOutErrorDesc = Err.Description
'						Exit Function
'					End If
'					Call WriteToLog("Pass","'"&strFreeFormValue&"' free form text is provided for 'Does patient need self management?' survey question")
'				End If	
'
'				Execute "Set objPCP_Ques4NeedSelfManagement_YesRdBtn = Nothing"
'				Execute "Set objPCP_Ques4NeedSelfManagement_NoRdBtn = Nothing"
'				Execute "Set objPCP_4FreeFormResponse = Nothing"
'				Wait 0,250			
'				
'		End Select
'		
'	Next
'	
'	Wait 1
'	Err.Clear
'	PCP_GetSurvey = True	
'
'End Function


'
''strSurveyValues: 'Survey questions' are delimited with "|". In that 'survey option' and 'freeform' are delimed by ","
''eg: strRequiredSurvey_Add = "Yes,|Yes,|Yes,FF1FF1"
''Out put: Survey results as they appear in Recap screen. Delimited by "|"
'Function PCP_GetSurveyValues_RecapImpact(ByVal strSurveyValues)
'
'	On Error Resume Next
'	Err.Clear
'
'	PCP_GetSurveyValues_RecapImpact = ""
'	
'	arrSurvey_AllValues = Split(strSurveyValues,"|",-1,1)
'	
'	'Survey 1 option and freeform text
'	strSurvey1 = arrSurvey_AllValues(0)
'	strOption1 = Split(strSurvey1,",",-1,1)(0)
'	strFreeFormValue1 = Split(strSurvey1,",",-1,1)(1)
'	
'	strRecapImpact_SurveyOption1 = ""
'	If LCase(Trim(strOption1)) = "yes" Then
'		strRecapImpact_SurveyOption1 = "Patient/caregiver understands care plan"
'	Else
'		strRecapImpact_SurveyOption1 = "Patient/caregiver does not understand care plan  - "&strFreeFormValue1
'	End If
'	
'	'Survey 2 option and freeform text
'	strSurvey2 = arrSurvey_AllValues(1)
'	strOption2 = Split(strSurvey1,",",-1,1)(0)
'	strFreeFormValue2 = Split(strSurvey1,",",-1,1)(1)
'	
'	strRecapImpact_SurveyOption2 = ""
'	If LCase(Trim(strOption2)) = "yes" Then
'		strRecapImpact_SurveyOption2 = "Patient/caregiver verbally agreed to follow care plan"
'	Else
'		strRecapImpact_SurveyOption2 = "Patient/caregiver refused to follow care plan  - "&strFreeFormValue2
'	End If
'	
'	'Survey 3 option and freeform text
'	strSurvey3 = arrSurvey_AllValues(2)
'	strOption3 = Split(strSurvey3,",",-1,1)(0)
'	strFreeFormValue3 = Split(strSurvey3,",",-1,1)(1)
'	
'	strRecapImpact_SurveyOption3 = ""
'	If LCase(Trim(strOption3)) = "yes" Then
'		strRecapImpact_SurveyOption3 = "Patient is engaged in self management  - "&strFreeFormValue3
'	Else
'		strRecapImpact_SurveyOption3 = "Patient is not engaged in self management  - "&strFreeFormValue3
'	End If
'	
'	PCP_GetSurveyValues_RecapImpact = strRecapImpact_SurveyOption1&"|"&strRecapImpact_SurveyOption2&"|"&strRecapImpact_SurveyOption3
'	
'End Function
