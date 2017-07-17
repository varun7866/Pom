package com.vh.ui.pages;

import static com.vh.ui.web.locators.HospitalizationLocators.*;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Swetha Ryali
 * @date   July 14, 2017
 * @class  HospitalizationPage.java
 */

public class HospitalizationPage extends WebPage
{
	public HospitalizationPage(WebDriver driver) throws WaitException {
		super(driver);
	}

	@Step("Verify the visibility of the Hospitalization page header label")
	public boolean viewHospitalizationPageHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PATIENTEXPERIENCEHOSPITALIZATIONS);
	}

	@Step("Verify the visibility of the ADD HOSPITALIZATION button")
	public boolean viewAddHospitalizationButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDHOSPITALIZATION);
	}
	
	@Step("Click the ADD HOSPITALIZATION button")
	public void clickAddHospitalizationButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDHOSPITALIZATION);
	}
	
	@Step("Click on the transfer tab in the Add new hospitalization window")
	public void clickAddTransferTabButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_NEWPOPUPTRANSFERTAB);
	}
	
	@Step("Verify the visibility of the transfer header")
	public boolean viewTransferTabHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPTRANSFERHEADER);
	}
	
	@Step("Verify the visibility of the facility name label in the transfer tab")
	public boolean viewFacilityNameLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPTRANSFERFACILITYNAME);
	}
	
	@Step("Verify the visibility of the facility name text box in the transfer tab")
	public boolean viewFacilityNameTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWPOPUPTRANSFERFACILITYNAME);
	}

	@Step("Verify the visibility of the Transfer DATE label")
	public boolean viewTransferDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPTRANSFERDATE);
	}

	@Step("Verify the visibility of the Transfer DATE picker")
	public boolean viewTransferDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_TRANSFERDATE);
	}

	@Step("Verify the visibility of the Transfer DATE picker button")
	public boolean viewTransferDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWPOPUPTRANSFERDATECAL);
	}
	
	@Step("Verify the visibility of the Transfer Phone label")
	public boolean viewTransferPhoneLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPTRANSFERPHONE);
	}
	
	@Step("Verify the visibility of the Transfer Phone text box")
	public boolean viewTransferPhoneTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWPOPUPTRANSFERPHONE);
	}
	
	@Step("Verify the visibility of the Transfer Fax label")
	public boolean viewTransferFaxLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPTRANSFERFAX);
	}

	
	@Step("Verify the visibility of the Transfer Fax text box")
	public boolean viewTransferFaxTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWPOPUPTRANSFERFAX);
	}
	
	@Step("Verify the visibility of the ADD Transfer button")
	public boolean viewAddTransferButtonLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDTRANSFER);
	}
	
	@Step("Click on the Discharge tab in the Add new hospitalization window")
	public void clickAddDischargeTabButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_NEWPOPUPDISCHARGETAB);
	}
	
	@Step("Verify the visibility of the Discharge header")
	public boolean viewDischargeTabHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPDISCHARGEHEADER);
	}
	
	@Step("Verify the visibility of the Discharge date label in the transfer tab")
	public boolean viewDischargeDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPDISCHARGEDATE);
	}

	@Step("Verify the visibility of the Discharge DATE picker")
	public boolean viewDischargeDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWPOPUPADDDISCHARGEDATE);
	}

	@Step("Verify the visibility of the Discharge DATE picker button")
	public boolean viewDischargeDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWPOPUPDISCHARGEDATECAL);
	}
	
	@Step("Verify the visibility of the Discharge Notification date label in the transfer tab")
	public boolean viewDischargeNotificationDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPDISCHARGENOTIFICATIONDATE);
	}

	@Step("Verify the visibility of the Discharge DATE picker")
	public boolean viewDischargeNotificationDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWPOPUPADDDISCHARGENOTIFICATIONDATE);
	}

	@Step("Verify the visibility of the Discharge Notification DATE picker button")
	public boolean viewDischargeNotificationDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWPOPUPDISCHARGENOTIFICATIONDATECAL);
	}

	@Step("Verify the visibility of the Plan DATE label")
	public boolean viewPlanDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPDISCHARGEPLANDATE);
	}

	@Step("Verify the visibility of the Plan DATE picker")
	public boolean viewPlanDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWPOPUPADDPLANDATE);
	}

	@Step("Verify the visibility of the Plan DATE picker button")
	public boolean viewPlanDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWPOPUPPLANDATECAL);
	}
	
	@Step("Verify the visibility of the Patient refused plan label")
	public boolean viewPatientRefusedPlanLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPDISCHARGEPATIENTREFUSEDPLAN);
	}
	
	@Step("Verify the visibility of the Patient refused plan YES radio button")
	public boolean viewPatientRefusedPlanYesradiobutton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, RDO_NEWPOPUPADDPATIENTREFUSEDPLANYES);
	}
	
	@Step("Verify the visibility of the Patient refused plan NO radio button")
	public boolean viewPatientRefusedPlanNoradiobutton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, RDO_NEWPOPUPADDPATIENTREFUSEDPLANNO);
	}
	
	@Step("Verify the visibility of the Discharge Diagnosis label")
	public boolean viewDischargeDiagnosisLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPDISCHARGEDIAGNOSIS);
	}

	@Step("Verify the visibility of the Discharge Diagnosis combo box")
	public boolean viewDischargeDiagnosisComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWPOPUPDISCHARGEDIAGNOSIS);
	}

	@Step("Verify the visibility of the Discharge Related Subcategory label")
	public boolean viewDischargeRelatedSubcategoryLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPDISCHARGERELATEDSUBCATEGORY);
	}

	@Step("Verify the visibility of the Discharge Related Subcategory combo box")
	public boolean viewDischargeRelatedSubcategoryComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWPOPUPDISCHARGERELATEDSUBCATEGORY);
	}

	@Step("Verify the visibility of the Discharge Disposition Subcategory label")
	public boolean viewDischargeDispositionLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPDISPOSITION);
	}

	@Step("Verify the visibility of the Discharge Related Subcategory combo box")
	public boolean viewDischargeDispositionComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWPOPUPDISPOSITION);
	}
	
	@Step("Verify the visibility of the Medical Equipment label")
	public boolean viewMedicalEquipmentLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPMEDICALEQUIPMENT);
	}
	
	@Step("Verify the visibility of the Medical Equipment YES radio button")
	public boolean viewMedicalEquipmentYesradiobutton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, RDO_NEWPOPUPMEDICALEQUIPMENTYES);
	}
	
	@Step("Verify the visibility of the Medical Equipment NO radio button")
	public boolean viewMedicalEquipmentNoradiobutton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, RDO_NEWPOPUPMEDICALEQUIPMENTNO);
	}
	
	@Step("Verify the visibility of the Home Health Name label")
	public boolean viewHomeHealthNameLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPHOMEHEALTHNAME);
	}
	
	@Step("Verify the visibility of the Home Health Name text box")
	public boolean viewHomeHealthNameTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWPOPUPHOMEHEALTHNAME);
	}
	
	@Step("Verify the visibility of the Home Health Reason label")
	public boolean viewHomeHealthReasonLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPHOMEHEALTHNAME);
	}
	
	@Step("Verify the visibility of the Home Health Reason combo box")
	public boolean viewHomeHealthReasonComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWPOPUPHOMEHEALTHREASON);
	}
	
	@Step("Verify the visibility of the SUBMIT button")
	public boolean viewNewHospitalizationSubmitButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDTRANSFER);
	}
}