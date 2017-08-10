package com.vh.ui.pages;


import static com.vh.ui.web.locators.HospitalizationLocators.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Swetha Ryali
 * @date   July 14, 2017
 * @class  java
 */

public class HospitalizationPage extends WebPage
{
	ApplicationFunctions appFunctions;
	
	public HospitalizationPage(WebDriver driver) throws WaitException {
		super(driver);
		
		appFunctions = new ApplicationFunctions(driver);
	}
	
	@Step("Verify the visibility of the ADD Hospitalization button")
    public boolean viewAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDHOSPITALIZATION);
    }

	@Step("Click the ADD HOSPITALIZATION button")
	public void clickAddHospitalizationButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDHOSPITALIZATION);
	}
	    
//    @Step("Click the Cancel ADDHospitalization popup button")
//    public void clickNewHospPopupCancelButton() throws TimeoutException, WaitException
//    {
//        webActions.click(VISIBILITY, BTN_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABCANCEL);
//    }
//    @Step("Click the Next ADDHospitalization popup button")
//    public void clickNextHospButton() throws TimeoutException, WaitException
//    {
//        webActions.click(VISIBILITY, BTN_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABNEXT);
//    }
    
    @Step("Verify the visibility of the Admittance header For AddPopUpAdmHospitalization")
    public boolean viewNewHospPopupAdmittanceTabHeader() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABADMITTANCEHEADER);
    }
    
    @Step("Verify the visibility of the FACILITY NAME For AddPopUpAdmHospitalization")
    public boolean viewNewHospPopupAdmittanceTabFaciltityNameLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABFACILITYNAME);
    }
    @Step("Verify the visibility of the FACILITY NAME TEXT BOX For AddPopUpAdmHospitalization")
    public boolean viewNewHospPopupAdmittanceTabFaciltityNameTextBox() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPADDPOPUPADMITTANCETABFACILITYNAME);
    }
    @Step("Verify the visibility of the ADMIT DATE for AddPopUpADMHospitalization")
    public boolean viewNewHospPopupAdmittanceTabAdmitDateLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABADMITDATE);
    } 
    @Step("Verify the visibility of the ADMIT DATE picker")
	public boolean viewNewHospPopupAdmittanceTabAdmitDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWHOSPPOPUPADMITTANCETABADMITDATECAL);
	}
	@Step("Verify the visibility of the ADMIT DATE picker button")
	public boolean viewNewHospPopupAdmittanceTabAdmitDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWHOSPPOPUPADMITTANCETABADMITDATECAL);
	}	
    @Step("Verify the visibility of the NOTIFICATION DATE FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabNotificationDate() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABNOTIFICATIONDATE);
    }
    @Step("Verify the visibility of the NOTIFICATION DATE picker")
	public boolean viewNewHospPopupAdmittanceTabNotificationDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWHOSPPOPUPADMITTANCETABNOTIFICATIONDATECAL);
	}
	@Step("Verify the visibility of the NOTIFICATION DATE picker button")
	public boolean viewNewHospPopupAdmittanceTabNotificationDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWHOSPPOPUPADMITTANCETABNOTIFICATIONDATECAL);
	}	
    @Step("Verify the visibility of the NOTIFIED BY FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabNotifiedByLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABNOTIFIEDBy);
    }
    @Step("Verify the visibility of the REASON FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabReasonLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABREASON);
    }
    @Step("Verify the visibility of the READMIT FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabReadmitLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABREADMIT);
    }
    @Step("Verify the visibility of the PHONE FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabPhoneLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABPHONE);
    }
    @Step("Verify the visibility of the Phone TEXT BOX For AddPopUpAdmHospitalization")
    public boolean viewNewHospPopupAdmittanceTabPhoneTextBox() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPADDPOPUPADMITTANCETABPHONE);
    }
    @Step("Verify the visibility of the FAX FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabFaxLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABFAX);
    }
    @Step("Verify the visibility of the Fax TEXT BOX For AddPopUpAdmHospitalization")
    public boolean viewNewHospPopupAdmittanceTabFaxTextBox() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPADDPOPUPADMITTANCETABFAX);
    }
    @Step("Verify the visibility of the ADMIT TYPE FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabAdmittypeLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABADMITTYPE);
    }
    @Step("Verify the visibility of the SOURCE OF ADMIT FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabSourceofAdmitLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABSOURCEOFADMIT);
    }
    @Step("Verify the visibility of the LOCATION PRIOR TO VISIT FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabPriorLocationLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABPRIORLOCATION);
    }
    @Step("Verify the visibility of the ADMITTING DIAGNOSIS FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabAdmittingDiagnosisLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABADMITTINGDIAGNOSIS);
    }
    @Step("Verify the visibility of the REALTED SUBCATEGORY FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabRelatedSubCategoryLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABRELATEDSUBCATEGORY);
    }
    @Step("Verify the visibility of the WORKING DIAGNOSIS label FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabWorkingDiagnosisLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABWORKINGDIAGNOSIS);
    }
    @Step("Verify the visibility of the  WORKING DIAGNOSIS text box For AddPopUpAdmHospitalization")
    public boolean viewNewHospPopupAdmittanceTabWorkingDiagnosisTextBox() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPADDPOPUPADMITTANCETABWORKINGDIAGNOSIS);
    }
    @Step("Verify the visibility of the PLANNED ADMISSION FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabPlannedAdmissionLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABPLANNEDADMISSION);
    }
    @Step("Verify the visibility of the AVOIDABLE ADMISSION FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabAvoidableAdmissionLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABAVOIDABLEADM);
    }
    @Step("Verify the visibility of the VERBAL CONTACT WITH HOSPITAL CASE MANAGER FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabHOSPCMGRLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABVCWHOSPCMGR);
    }
    @Step("Verify the visibility of the COMMENT FOR ADD Hospitalization button")
    public boolean viewNewHospPopupAdmittanceTabCommentLabel() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPADDPOPUPADMITTANCETABCOMMENT);
    }  
    @Step("Verify the visibility of the  COMMENT text box For AddPopUpAdmHospitalization")
    public boolean viewNewHospPopupAdmittanceTabCommentTextBox() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPADDPOPUPADMITTANCETABCOMMENT);
    }


    @Step("Select an option to Enter FacilityName in admittance tab")
    public void enterNewHospPopupAdmittanceTabFacitlityName(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPADDPOPUPADMITTANCETABFACILITYNAME, value);
    }
	@Step("Select a date from the Admit date calendar")
	public void selectNewHospPopupAdmittanceTabAdmitDate(String dateChange) throws TimeoutException, WaitException, InterruptedException
	{
		clickNewHospPopupAdmittanceTabAdmitDatePickerButton();
		String currentDayMinusX = appFunctions.adjustCurrentDateBy(dateChange, "d");
		System.out.println(currentDayMinusX);
		appFunctions.selectDateFromCalendar(CAL_NEWHOSPPOPUPADMITTANCETABADMITDATECAL, currentDayMinusX);
	}
    @Step("Click the Admit date calendar button")
    public void clickNewHospPopupAdmittanceTabAdmitDatePickerButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPPOPUPADMITTANCETABADMITDATECAL);
    }
	@Step("Select a date from the Notification date calendar")
	public void selectNewHospPopupAdmittanceTabNotificationDate(String dateChange) throws TimeoutException, WaitException, InterruptedException
	{
		clickNewHospPopupAdmittanceTabNotifcationDatePickerButton();
		String currentDayMinusX = appFunctions.adjustCurrentDateBy(dateChange, "d");
		appFunctions.selectDateFromCalendar(CAL_NEWHOSPPOPUPADMITTANCETABNOTIFICATIONDATECAL, currentDayMinusX);
	}
    @Step("Click the Notification date calendar button")
    public void clickNewHospPopupAdmittanceTabNotifcationDatePickerButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPPOPUPADMITTANCETABNOTIFICATIONDATECAL);
    }
    @Step("Select an option to Enter NotifiedBy")
    public void selectNewHospPopupAdmittanceTabNotifiedBy(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPADMITTANCETABNOTIFIEDBy, value);
    }
    @Step("Select an option to Enter Reason")
    public void selectNewHospPopupAdmittanceTabReason(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPADMITTANCETABREASON, value);
    }	
    @Step("Enter Phone Number in Admittance Tab")
    public void enterNewHospPopupAdmittanceTabPhone(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPADDPOPUPADMITTANCETABPHONE, value);
    }
    @Step("Enter Fax Number in Admittance Tab")
    public void enterNewHospPopupAdmittanceTabFax(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPADDPOPUPADMITTANCETABFAX, value);
    }
    @Step("Select an option to Enter Admit Type in Admittance Tab")
    public void selectNewHospPopupAdmittanceTabAdmitType(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPADMITTANCETABADMITTYPE, value);
    }
    @Step("Select an option to Enter SourceOfAdmit in Admittance Tab")
    public void selectNewHospPopupAdmittanceTabSourceOfAdmit(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPADMITTANCETABSOURCEOFADMIT, value);
    }
    @Step("Select an option to Enter PriorLocation in Admittance Tab")
    public void selectNewHospPopupAdmittanceTabPriorLocation(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPADMITTANCETABPRIORLOCATION, value);
    }
    @Step("Select an option to Enter Admittingdiagnosis in Admittance Tab")
    public void selectNewHospPopupAdmittanceTabAdmittingdiagnosis(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPADMITTANCETABADMITTINGDIAGNOSIS, value);
    }
    @Step("Select an option to Enter Related SubCategory in Admittance Tab")
    public void selectNewHospPopupAdmittanceTabRelatedSubCategory(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPADMITTANCETABRELATEDSUBCATEGORY, value);
    }
    @Step("Select an option to Enter Workingdiagnosis in Admittance Tab")
    public void enterNewHospPopupAdmittanceTabWorkingdiagnosis(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPADDPOPUPADMITTANCETABWORKINGDIAGNOSIS, value);
    }
    @Step("Check the PlannedAdmission check box in Admittance Tab")
    public void selectNewHospPopupAdmittanceTabPlannedAdmission() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, CHK_NEWHOSPPOPUPADMITTANCETABPLANNEDADMISSION);
    }
    @Step("Check the Avoidable Admission check box in Admittance Tab")
    public void selectNewHospPopupAdmittanceTabAvoidableAdmission() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, CHK_NEWHOSPPOPUPADMITTANCETABAVOIDABLEADM);
    }
    @Step("Check the VERBAL CONTACT WITH HOSPITAL CASE MANAGER check box in Admittance Tab")
    public void selectNewHospPopupAdmittanceTabVCMHospManager() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, CHK_NEWHOSPPOPUPADMITTANCETABVCWHOSPCMGR);
    }
    @Step("Select an option to Enter Comment in Admittance Tab")
    public void enterNewHospPopupAdmittanceTabHospComment(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPADDPOPUPADMITTANCETABCOMMENT, value);
    }
    @Step("Check the Next button in Admittance Tab")
    public void clickNextButtonNewHospPopupAdmittanceTab() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPNEWHOSPADDPOPUPADMITTANCETABNEXT);
    } 
       
    @Step("Verify the options of the Add HospNotified By box")
    public boolean verifyNewHospPopupAdmittanceTabNotifiedBydropdownOptions() throws TimeoutException, WaitException
    {
    	List<String> dropDownOptions = new ArrayList<String>();
        dropDownOptions.add("Select a value");
        dropDownOptions.add("Dialysis Center");
        dropDownOptions.add("Family Member");
        dropDownOptions.add("Hospital");
        dropDownOptions.add("Hospital Census");
        dropDownOptions.add("HP Case Manager");
        dropDownOptions.add("Missing TX Alert/Report");
        dropDownOptions.add("Nephrologist");
        dropDownOptions.add("Patient-Caregiver");
        dropDownOptions.add("PCP");
                    
        return appFunctions.verifyDropDownOptions(CBO_NEWHOSPPOPUPADMITTANCETABNOTIFIEDBy, dropDownOptions);            
    }
    
    
    @Step("Verify the options of the Add HospReason box")
    public boolean verifyNewHospPopupAdmittanceTabReasondropdownOptions() throws TimeoutException, WaitException
    {
        List<String> dropDownOptions = new ArrayList<String>();
        dropDownOptions.add("Select a value");
        dropDownOptions.add("Dry Weight Not Changed Appropriately");
        dropDownOptions.add("End of Life Issues");
        dropDownOptions.add("Patient Did Not Follow Treatment Plan");
        dropDownOptions.add("Premature Discharge");
        dropDownOptions.add("Unrelated Readmission");
        
        return appFunctions.verifyDropDownOptions(CBO_NEWHOSPPOPUPADMITTANCETABREASON, dropDownOptions);
    }
    
    
	@Step("Verify the options of the Add HospAdmittype box")
	public boolean verifyNewHospPopupAdmittanceTabAdmittypedropdownOptions() throws TimeoutException, WaitException
	{
        List<String> dropDownOptions = new ArrayList<String>();
        dropDownOptions.add("Select a value");
        dropDownOptions.add("ED Visit");
        dropDownOptions.add("Hospital Admit");
        dropDownOptions.add("Observation");
        dropDownOptions.add("OutPatient");
        dropDownOptions.add("SNF/Rehab Admit");
        
        return appFunctions.verifyDropDownOptions(CBO_NEWHOSPPOPUPADMITTANCETABREASON, dropDownOptions);
	}
	                
	
	
	@Step("Verify the options of the Add HospSourceofAdmit box")
	public boolean verifyNewHospPopupAdmittanceTabSourceofadmitdropdownOptions() throws TimeoutException, WaitException
	{
	    List<String> dropDownOptions = new ArrayList<String>();
	    dropDownOptions.add("Select a value");
	    dropDownOptions.add("Elective Admit");
	    dropDownOptions.add("ER Admit");
	    dropDownOptions.add("Observation");
	    dropDownOptions.add("OutPatient");
	    dropDownOptions.add("Urgent Direct Admit");
	    
	    return appFunctions.verifyDropDownOptions(CBO_NEWHOSPPOPUPADMITTANCETABSOURCEOFADMIT, dropDownOptions);
	}
	
	
	@Step("Verify the options of the Add HospPriorLocation box")
	public boolean verifyNewHospPopupAdmittanceTabPriorLocationdropdownOptions() throws TimeoutException, WaitException
	{
	    List<String> dropDownOptions = new ArrayList<String>();
	    dropDownOptions.add("Select a value");
	    dropDownOptions.add("Acute Hospital Transfer");
	    dropDownOptions.add("Acute Rehab Transfer");
	    dropDownOptions.add("Community");
	    dropDownOptions.add("Dialysis Center");
	    dropDownOptions.add("ECF");
	    dropDownOptions.add("Home/Residence");
	    dropDownOptions.add("Long Term Acute Center");
	    dropDownOptions.add("Other");
	    dropDownOptions.add("SNF");
	    dropDownOptions.add("Unknown");
	    
	    return appFunctions.verifyDropDownOptions(CBO_NEWHOSPPOPUPADMITTANCETABPRIORLOCATION, dropDownOptions);
	}
                                    
	@Step("Verify the options of the Add HospAdmittingDiagnosis box")
	public boolean verifyNewHospPopupAdmittanceTabAdmittingDiagnosisdropdownOptions() throws TimeoutException, WaitException
	{
	    List<String> dropDownOptions = new ArrayList<String>();
	    dropDownOptions.add("Select a value");
	    dropDownOptions.add("Abnormal Labs/Electrolyte Imbalance");
	    dropDownOptions.add("Access");
	    dropDownOptions.add("Cardiovascular");
	    dropDownOptions.add("CHF/Fluid Overload");
	    dropDownOptions.add("Diabetes");
	    dropDownOptions.add("Gastrointestinal");
	    dropDownOptions.add("Genitourinary");
	    dropDownOptions.add("Infection");
	    dropDownOptions.add("Medication");
	    dropDownOptions.add("Mental Health");
	    dropDownOptions.add("Ortho");
	    dropDownOptions.add("Other");
	    dropDownOptions.add("Planned Procedure or Surgery");
	    dropDownOptions.add("Renal");
	    dropDownOptions.add("Respiratory");
	    
	    return appFunctions.verifyDropDownOptions(CBO_NEWHOSPPOPUPADMITTANCETABADMITTINGDIAGNOSIS, dropDownOptions);
	}
	
	@Step("Verify the options of the Add HospAdmittingDiagnosis box")
	public boolean verifyNewHospPopupAdmittanceTabRelatedSubcategorydropdownOptions() throws TimeoutException, WaitException
	{
	    List<String> dropDownOptions = new ArrayList<String>();
	    dropDownOptions.add("Select a value");
	    dropDownOptions.add("Abdominal Pain");
	    dropDownOptions.add("Bowel Obstruction");
	    dropDownOptions.add("Cholecystitis");
	    dropDownOptions.add("Constipation");
	    dropDownOptions.add("Diarrhea");
	    dropDownOptions.add("Gastritis");
	    dropDownOptions.add("GI Bleed");
	    dropDownOptions.add("Hepatic");
	    dropDownOptions.add("Ileus");
	    dropDownOptions.add("Nausea and Vomiting");
	    dropDownOptions.add("Other");
	    
	    return appFunctions.verifyDropDownOptions(CBO_NEWHOSPPOPUPADMITTANCETABRELATEDSUBCATEGORY, dropDownOptions);
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

	@Step("Click on the transfer tab in the Add new hospitalization window")
	public void clickNewHospPopupAddTransferTabButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_NEWHOSPPOPUPTRANSFERTABTRANSFERBUTTON);
	}
	
	@Step("Verify the visibility of the transfer header")
	public boolean viewNewHospPopupTransferTabHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERHEADER);
	}
	
	@Step("Verify the visibility of the facility name label in the transfer tab")
	public boolean viewNewHospPopupTransferTabFacilityNameLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERFACILITYNAME);
	}
	
	@Step("Verify the visibility of the facility name text box in the transfer tab")
	public boolean viewNewHospPopupTransferTabFacilityNameTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERFACILITYNAME);
	}

	@Step("Verify the visibility of the Transfer DATE label")
	public boolean viewNewHospPopupTransferTabTransferDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERDATE);
	}

	@Step("Verify the visibility of the Transfer DATE picker")
	public boolean viewNewHospPopupTransferTabTransferDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWHOSPPOPUPADMITTANCETABTRANSFERDATE);
	}

	@Step("Verify the visibility of the Transfer DATE picker button")
	public boolean viewNewHospPopupTransferTabTransferDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWHOSPPOPUPTRANSFERTABTRANSFERDATECAL);
	}
	
	@Step("Verify the visibility of the Transfer Phone label")
	public boolean viewNewHospPopupTransferTabPhoneLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERPHONE);
	}
	
	@Step("Verify the visibility of the Transfer Phone text box")
	public boolean viewNewHospPopupTransferTabPhoneTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERPHONE);
	}
	
	@Step("Verify the visibility of the Transfer Fax label")
	public boolean viewNewHospPopupTransferTabFaxLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPTRANSFERTABTRANSFERFAX);
	}
	
	@Step("Verify the visibility of the Transfer Fax text box")
	public boolean viewNewHospPopupTransferTabFaxTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERFAX);
	}
	
	@Step("Verify the visibility of the ADD Transfer button")
	public boolean viewAddTransferButtonLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDTRANSFER);
	}
	
    @Step("Select an option to Enter FacilityName in Transfer tab")
    public void enterNewHospPopupTransferTabFacitlityName(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERFACILITYNAME, value);
    }
    
	@Step("Select a date from the Transfer date calendar")
	public void selectNewHospPopupTransferTabTransferDate(String dateChange) throws TimeoutException, WaitException, InterruptedException
	{
		clickNewHospPopupTransferTabTransferDatePickerButton();
		String currentDayMinusX = appFunctions.adjustCurrentDateBy(dateChange, "d");
		appFunctions.selectDateFromCalendar(CAL_NEWHOSPPOPUPADMITTANCETABTRANSFERDATE, currentDayMinusX);
	}
	
    @Step("Click the Transfer date calendar button")
    public void clickNewHospPopupTransferTabTransferDatePickerButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPPOPUPTRANSFERTABTRANSFERDATECAL);
    }
    
    @Step("Enter Phone Number in Transfer Tab")
    public void enterNewHospPopupTransferTabPhone(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERPHONE, value);
    }
    
    @Step("Enter Fax Number in Transfer Tab")
    public void enterNewHospPopupTransferTabFax(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPPOPUPTRANSFERTABTRANSFERFAX, value);
    }
    
    @Step("Click the Next button in Transfer Tab")
    public void clickNextButtonNewHospPopupTransferTab() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPTRANSFERTABNEXT);
    } 
    
	//-------------------------------------Discharge Tab-----------------------------------------
    
	@Step("Click on the Discharge tab in the Add new hospitalization window")
	public void clickNewHospPopupAddDischargeTabButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_NEWHOSPPOPUPDISCHARGETABDISCHARGETAB);
	}
	
	@Step("Verify the visibility of the Discharge header")
	public boolean viewNewHospPopupDischargeTabHeader() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEHEADER);
	}
	
	@Step("Verify the visibility of the Discharge date label in the transfer tab")
	public boolean viewNewHospPopupDischargeTabDischargeDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEDATE);
	}

	@Step("Verify the visibility of the Discharge DATE picker")
	public boolean viewNewHospPopupDischargeTabDischargeDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWHOSPPOPUPDISCHARGETABADDDISCHARGEDATE);
	}

	@Step("Verify the visibility of the Discharge DATE picker button")
	public boolean viewNewHospPopupDischargeTabDischargeDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWHOSPPOPUPDISCHARGETABDISCHARGEDATECAL);
	}
	
	@Step("Verify the visibility of the Discharge Notification date label in the transfer tab")
	public boolean viewNewHospPopupDischargeTabNotificationDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGENOTIFICATIONDATE);
	}

	@Step("Verify the visibility of the Discharge DATE picker")
	public boolean viewNewHospPopupDischargeTabNotificationDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWHOSPPOPUPDISCHARGETABNOTIFICATIONDATE);
	}

	@Step("Verify the visibility of the Discharge Notification DATE picker button")
	public boolean viewNewHospPopupDischargeTabNotificationDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWHOSPPOPUPDISCHARGETABNOTIFICATIONDATECAL);
	}

	@Step("Verify the visibility of the Plan DATE label")
	public boolean viewNewHospPopupDischargeTabPlanDateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEPLANDATE);
	}

	@Step("Verify the visibility of the Plan DATE picker")
	public boolean viewNewHospPopupDischargeTabPlanDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWHOSPPOPUPDISCHARGETABADDPLANDATE);
	}

	@Step("Verify the visibility of the Plan DATE picker button")
	public boolean viewNewHospPopupDischargeTabPlanDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWHOSPPOPUPDISCHARGETABPLANDATECAL);
	}
	
	@Step("Verify the visibility of the Patient refused plan label")
	public boolean viewNewHospPopupDischargeTabPatientRefusedPlanLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEPATIENTREFUSEDPLAN);
	}
	
	@Step("Verify the visibility of the Patient refused plan YES radio button")
	public boolean viewNewHospPopupDischargeTabPatientRefusedPlanYesradiobutton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, RDO_NEWHOSPPOPUPDISCHARGETABADDPATIENTREFUSEDPLANYES);
	}
	
	@Step("Verify the visibility of the Patient refused plan NO radio button")
	public boolean viewNewHospPopupDischargeTabPatientRefusedPlanNoradiobutton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, RDO_NEWHOSPPOPUPDISCHARGETABADDPATIENTREFUSEDPLANNO);
	}
	
	@Step("Verify the visibility of the Discharge Diagnosis label")
	public boolean viewNewHospPopupDischargeTabDischargeDiagnosisLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGEDIAGNOSIS);
	}

	@Step("Verify the visibility of the Discharge Diagnosis combo box")
	public boolean viewNewHospPopupDischargeTabDischargeDiagnosisComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWHOSPPOPUPDISCHARGETABDISCHARGEDIAGNOSIS);
	}

	@Step("Verify the visibility of the Discharge Related Subcategory label")
	public boolean viewNewHospPopupDischargeTabRelatedSubcategoryLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABDISCHARGERELATEDSUBCATEGORY);
	}

	@Step("Verify the visibility of the Discharge Related Subcategory combo box")
	public boolean viewNewHospPopupDischargeTabRelatedSubcategoryComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWHOSPPOPUPDISCHARGETABDISCHARGERELATEDSUBCATEGORY);
	}

	@Step("Verify the visibility of the Discharge Disposition Subcategory label")
	public boolean viewNewHospPopupDischargeTabDispositionLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABDISPOSITION);
	}

	@Step("Verify the visibility of the Discharge Related Subcategory combo box")
	public boolean viewNewHospPopupDischargeTabDispositionComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWHOSPPOPUPDISCHARGETABDISPOSITION);
	}
	
	@Step("Verify the visibility of the Home Health Name label")
	public boolean viewNewHospPopupDischargeTabHomeHealthNameLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHNAME);
	}
	
	@Step("Verify the visibility of the Home Health Name text box")
	public boolean viewNewHospPopupDischargeTabHomeHealthNameTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHNAME);
	}
	
	@Step("Verify the visibility of the Home Health Reason label")
	public boolean viewNewHospPopupDischargeTabHomeHealthReasonLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHREASON);
	}
	
	@Step("Verify the visibility of the Home Health Reason combo box")
	public boolean viewNewHospPopupDischargeTabHomeHealthReasonComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHREASON);
	}
	
	@Step("Verify the visibility of the SUBMIT button")
	public boolean viewNewHospitalizationSubmitButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWHOSPITALIZATIONSUBMIT);
	}
	
	@Step("Select a date from the Discharge date calendar")
	public void selectNewHospPopupDischargeTabDischargeDate(String dateChange) throws TimeoutException, WaitException, InterruptedException
	{
		clickNewHospPopupDischargeTabDischargeDatePickerButton();
		String currentDayMinusX = appFunctions.adjustCurrentDateBy(dateChange, "d");
		appFunctions.selectDateFromCalendar(CAL_NEWHOSPPOPUPDISCHARGETABADDDISCHARGEDATE, currentDayMinusX);
	}
    @Step("Click the Discharge date calendar button")
    public void clickNewHospPopupDischargeTabDischargeDatePickerButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPPOPUPDISCHARGETABDISCHARGEDATECAL);
    }
    
	@Step("Select a date from the Notification date calendar in Discharge Tab")
	public void selectNewHospPopupDischargeTabNotificationDate(String dateChange) throws TimeoutException, WaitException, InterruptedException
	{
		clickNewHospPopupDischargeTabNotifcationDatePickerButton();
		String currentDayMinusX = appFunctions.adjustCurrentDateBy(dateChange, "d");
		appFunctions.selectDateFromCalendar(CAL_NEWHOSPPOPUPDISCHARGETABNOTIFICATIONDATE, currentDayMinusX);
	}
	
    @Step("Click the Notification date calendar button")
    public void clickNewHospPopupDischargeTabNotifcationDatePickerButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPPOPUPDISCHARGETABNOTIFICATIONDATECAL);
    }
	
	@Step("Select a date from the Plan date calendar in Discharge Tab")
	public void selectNewHospPopupDischargeTabPlanDate(String dateChange) throws TimeoutException, WaitException, InterruptedException
	{
		clickNewHospPopupDischargeTabPlanDatePickerButton();
		String currentDayMinusX = appFunctions.adjustCurrentDateBy(dateChange, "d");
		appFunctions.selectDateFromCalendar(CAL_NEWHOSPPOPUPDISCHARGETABADDPLANDATE, currentDayMinusX);
	}
	
    @Step("Click the Plan date calendar button")
    public void clickNewHospPopupDischargeTabPlanDatePickerButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPPOPUPDISCHARGETABPLANDATECAL);
    }
 	
    @Step("Click the Patient Plan Refused Yes radio button")
    public void clickNewHospPopupDischargeTabPatientPlanRefusedYes() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, RDO_NEWHOSPPOPUPDISCHARGETABADDPATIENTREFUSEDPLANYES);
    }
    
    @Step("Select an option to Enter Discharge Diagnosis")
    public void selectNewHospPopupDischargeTabDischargeDiagnosis(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPDISCHARGETABDISCHARGEDIAGNOSIS, value);
    }
    
    @Step("Select an option to Enter Related SubCategory in Admittance Tab")
    public void selectNewHospPopupDischargeTabRelatedSubCategory(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPDISCHARGETABDISCHARGERELATEDSUBCATEGORY, value);
    }
    
    @Step("Select an option to Enter Disposition")
    public void selectNewHospPopupDischargeTabDisposition(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPDISCHARGETABDISPOSITION, value);
    }	
    
    @Step("Click the Patient Plan Refused Yes radio button")
    public void clickNewHospPopupDischargeTabPatientMedicalEquipmentYes() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, RDO_NEWHOSPPOPUPDISCHARGETABMEDICALEQUIPMENTYES);
    }
    
    @Step("Select an option to Enter Home Health Name in Discharge Tab")
    public void enterNewHospPopupDischargeTabHomeHealthName(String value) throws TimeoutException, WaitException
    {
        webActions.enterText(VISIBILITY,TXT_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHNAME, value);
    }
    
    @Step("Select an option to Enter Home Health Reason")
    public void selectNewHospPopupDischargeTabHomeHealthReason(String value) throws TimeoutException, WaitException
    {
        webActions.selectFromDropDownOld(VISIBILITY,CBO_NEWHOSPPOPUPDISCHARGETABHOMEHEALTHREASON, value);
    }
    
    @Step("Click the Submit button on the hospitalization popup")
    public void clickNewHospPopupSubmitButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPITALIZATIONSUBMIT);
    }
    
    @Step("Click the Submit button on the hospitalization popup")
    public void clickNewHospPopupCancelButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_NEWHOSPITALIZATIONCANCEL);
    }
    //-------------------------Add New Hospitalization Record---------------------------------------
    
    @Step("Add a new hospitalization record for the patient")
	public void addHospitalizationRecord(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
//		String currentDayMinusX = null;

		clickAddHospitalizationButton();

		Thread.sleep(7000); // Give time for the list of drop downs to load

		enterNewHospPopupAdmittanceTabFacitlityName(map.get("ADMITTANCEFACILITYNAME"));
		System.out.println(map.get("ADMITDATE"));
		selectNewHospPopupAdmittanceTabAdmitDate(map.get("ADMITDATE"));
		selectNewHospPopupAdmittanceTabNotificationDate(map.get("ADMITTANCENOTIFICATIONDATE"));
		selectNewHospPopupAdmittanceTabNotifiedBy(map.get("NOTIFIEDBY"));
		selectNewHospPopupAdmittanceTabReason(map.get("REASON"));
		enterNewHospPopupAdmittanceTabPhone(map.get("ADMITTANCETABPHONE"));
		enterNewHospPopupAdmittanceTabFax(map.get("ADMITTANCETABFAX"));
		selectNewHospPopupAdmittanceTabAdmitType(map.get("ADMITTYPE"));
		selectNewHospPopupAdmittanceTabSourceOfAdmit(map.get("SOURCEOFADMIT"));
		selectNewHospPopupAdmittanceTabPriorLocation(map.get("PRIORLOCATION"));
		selectNewHospPopupAdmittanceTabAdmittingdiagnosis(map.get("ADMITTINGDIAGNOSIS"));
		Thread.sleep(1000);
		selectNewHospPopupAdmittanceTabRelatedSubCategory(map.get("ADMITTANCERELATEDSUBCATEGORY"));
		enterNewHospPopupAdmittanceTabWorkingdiagnosis(map.get("WORKINGDIAGNOSIS"));
		selectNewHospPopupAdmittanceTabPlannedAdmission();
		selectNewHospPopupAdmittanceTabAvoidableAdmission();
		selectNewHospPopupAdmittanceTabVCMHospManager();
		enterNewHospPopupAdmittanceTabHospComment(map.get("COMMENT"));	
		clickNextButtonNewHospPopupAdmittanceTab();

		// Add Transfer
		
		viewNewHospPopupTransferTabHeader();
		enterNewHospPopupTransferTabFacitlityName(map.get("TRANSFERFACILITYNAME"));
		selectNewHospPopupTransferTabTransferDate(map.get("TRANSFERDATE"));
		enterNewHospPopupTransferTabPhone(map.get("TRANSFERTABPHONE"));
		enterNewHospPopupTransferTabFax(map.get("TRANSFERTABFAX"));
		clickNextButtonNewHospPopupTransferTab();
		
		//Add Discharge
		
		viewNewHospPopupDischargeTabHeader();
		selectNewHospPopupDischargeTabDischargeDate(map.get("DISCHARGEDATE"));
		selectNewHospPopupDischargeTabNotificationDate(map.get("DISCHARGENOTIFICATIONDATE"));
		selectNewHospPopupDischargeTabPlanDate(map.get("DISCHARGEPLANDATE"));
		clickNewHospPopupDischargeTabPatientPlanRefusedYes();
		selectNewHospPopupDischargeTabDischargeDiagnosis(map.get("DISCHARGEDIAGNOSIS"));
		selectNewHospPopupDischargeTabRelatedSubCategory(map.get("DISCHARGERELATEDSUBCATEGORY"));
		Thread.sleep(1000);
		selectNewHospPopupDischargeTabDisposition(map.get("DISCHARGEDISPOSITION"));
		clickNewHospPopupDischargeTabPatientMedicalEquipmentYes();
		enterNewHospPopupDischargeTabHomeHealthName(map.get("DISCHARGEHOMEHEALTHNAME"));
		selectNewHospPopupDischargeTabHomeHealthReason(map.get("DISCHARGEHOMEHEALTHREASON"));
		clickNewHospPopupSubmitButton();		
	}
    
	@Step("Verify the added Hospital record name exist in the Hospitalization page")
	public boolean viewAddedHospFacilityName(String facilityName) throws TimeoutException, WaitException
	{
		final By LBL_FACILITY = By.xpath("//hospitalization//div/strong[contains(., '" + facilityName + "')]");//span[text()='Height (" + labValue + ")']");
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_FACILITY);
	}
	@Step("Verify the added Admit Type exists in the Hospitalization page")
	public boolean viewHospitalizationFacilityName(String facilityName) throws TimeoutException, WaitException
	{
		final By LBL_FACILITY = By.xpath("//hospitalization//div/strong[contains(., '" + facilityName + "')]");//span[text()='Height (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_FACILITY);
	}
	//hospitalization//div/span[contains(., '6765456578')]
	//hospitalization//section/div/div/div/div/div/div/div[1]//table//div[contains(., 'Hospital Admit')]
 }