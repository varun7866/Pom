package com.vh.ui.pages;

import static com.vh.ui.web.locators.HospitalizationLocators.BTN_ADDHOSPITALIZATION;
import static com.vh.ui.web.locators.HospitalizationLocators.BTN_ADDPOPUPADMCANCEL;
import static com.vh.ui.web.locators.HospitalizationLocators.BTN_ADDPOPUPADMNEXT;
import static com.vh.ui.web.locators.HospitalizationLocators.BTN_NEWPOPUPDISCHARGEDATECAL;
import static com.vh.ui.web.locators.HospitalizationLocators.BTN_NEWPOPUPDISCHARGENOTIFICATIONDATECAL;
import static com.vh.ui.web.locators.HospitalizationLocators.BTN_NEWPOPUPDISCHARGETAB;
import static com.vh.ui.web.locators.HospitalizationLocators.BTN_NEWPOPUPPLANDATECAL;
import static com.vh.ui.web.locators.HospitalizationLocators.BTN_NEWPOPUPTRANSFERDATECAL;
import static com.vh.ui.web.locators.HospitalizationLocators.BTN_NEWPOPUPTRANSFERTAB;
import static com.vh.ui.web.locators.HospitalizationLocators.CAL_NEWPOPUPADDDISCHARGEDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.CAL_NEWPOPUPADDDISCHARGENOTIFICATIONDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.CAL_NEWPOPUPADDPLANDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.CAL_TRANSFERDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.CBO_NEWPOPUPDISCHARGEDIAGNOSIS;
import static com.vh.ui.web.locators.HospitalizationLocators.CBO_NEWPOPUPDISCHARGERELATEDSUBCATEGORY;
import static com.vh.ui.web.locators.HospitalizationLocators.CBO_NEWPOPUPDISPOSITION;
import static com.vh.ui.web.locators.HospitalizationLocators.CBO_NEWPOPUPHOMEHEALTHREASON;
import static com.vh.ui.web.locators.HospitalizationLocators.CHK_ADDPOPUPADMAVOIDABLEADM;
import static com.vh.ui.web.locators.HospitalizationLocators.CHK_ADDPOPUPADMPLANNEDADMISSION;
import static com.vh.ui.web.locators.HospitalizationLocators.CHK_ADDPOPUPADMVCWHOSPCMGR;
import static com.vh.ui.web.locators.HospitalizationLocators.CMB_ADDPOPUPADMNOTIFIEDBy;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMADMITDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMADMITTINGDIAGNOSIS;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMADMITTYPE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMAVOIDABLEADM;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMFACILITYNAME;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMFAX;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMNOTIFICATIONDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMNOTIFIEDBy;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMPHONE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMPLANNEDADMISSION;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMPRIORLOCATION;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMREASON;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMRELATEDSUBCATEGORY;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMVCWHOSPCMGR;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDPOPUPADMWORKINGDIAGNOSIS;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_ADDTRANSFER;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPDISCHARGEDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPDISCHARGEDIAGNOSIS;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPDISCHARGEHEADER;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPDISCHARGENOTIFICATIONDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPDISCHARGEPATIENTREFUSEDPLAN;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPDISCHARGEPLANDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPDISCHARGERELATEDSUBCATEGORY;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPDISPOSITION;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPHOMEHEALTHNAME;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPHOMEHEALTHREASON;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPTRANSFERDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPTRANSFERFACILITYNAME;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPTRANSFERFAX;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPTRANSFERHEADER;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_NEWPOPUPTRANSFERPHONE;
import static com.vh.ui.web.locators.HospitalizationLocators.LBL_PATIENTEXPERIENCEHOSPITALIZATIONS;
import static com.vh.ui.web.locators.HospitalizationLocators.RDO_NEWPOPUPADDPATIENTREFUSEDPLANNO;
import static com.vh.ui.web.locators.HospitalizationLocators.RDO_NEWPOPUPADDPATIENTREFUSEDPLANYES;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMADMITDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMADMITTYPE;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMCOMMENT;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMDMITTINGDIAGNOSIS;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMFACILITYNAME;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMFAX;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMNOTIFICATIONDATE;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMPHONE;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMPRIORLOCATION;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMREASON;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMRELATEDSUBCATEGORY;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPADMWORKINGDIAGNOSIS;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_ADDPOPUPSOURCEOFADMIT;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_NEWPOPUPHOMEHEALTHNAME;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_NEWPOPUPTRANSFERFACILITYNAME;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_NEWPOPUPTRANSFERFAX;
import static com.vh.ui.web.locators.HospitalizationLocators.TXT_NEWPOPUPTRANSFERPHONE;

import java.util.ArrayList;
import java.util.List;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
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
    
    @Step("Click the Add Hospitalization popup button")
    public void clickAddHospButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_ADDHOSPITALIZATION);
    }
    @Step("Click the Cancel ADDHospitalization popup button")
    public void clickCancelHospButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_ADDPOPUPADMCANCEL);
    }
    @Step("Click the Next ADDHospitalization popup button")
    public void clickNextHospButton() throws TimeoutException, WaitException
    {
        webActions.click(VISIBILITY, BTN_ADDPOPUPADMNEXT);
    }
    @Step("Verify the visibility of the FACILITY NAME For AddPopUpAdmHospitalization")
    public boolean ViewFaciltityNameAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMFACILITYNAME);
    }
    @Step("Verify the visibility of the ADMIT DATE for AddPopUpADMHospitalization")
    public boolean viewAdmitDateAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMADMITDATE);
    }
    @Step("Verify the visibility of the NOTIFICATION DATE FOR ADD Hospitalization button")
    public boolean viewNotificationDateAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMNOTIFICATIONDATE);
    }
    @Step("Verify the visibility of the NOTIFIED BY FOR ADD Hospitalization button")
    public boolean viewNotifiedByAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMNOTIFIEDBy);
    }
    @Step("Verify the visibility of the REASON FOR ADD Hospitalization button")
    public boolean viewReasonAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMREASON);
    }
    @Step("Verify the visibility of the READMIT FOR ADD Hospitalization button")
    public boolean viewReadmitAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDHOSPITALIZATION);
    }
    @Step("Verify the visibility of the PHONE FOR ADD Hospitalization button")
    public boolean viewPhoneAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMPHONE);
    }
    @Step("Verify the visibility of the FAX FOR ADD Hospitalization button")
    public boolean viewFaxAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMFAX);
    }
    @Step("Verify the visibility of the ADMIT TYPE FOR ADD Hospitalization button")
    public boolean viewAdmittypeAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMADMITTYPE);
    }
    @Step("Verify the visibility of the SOURCE OF ADMIT FOR ADD Hospitalization button")
    public boolean viewSourceofAdmitAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMADMITTYPE);
    }
    @Step("Verify the visibility of the LOCATION PRIOR TO VISIT FOR ADD Hospitalization button")
    public boolean viewPriorLocationAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMPRIORLOCATION);
    }
    @Step("Verify the visibility of the ADMITTING DIAGNOSIS FOR ADD Hospitalization button")
    public boolean viewAdmittingDiagnosisAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMADMITTINGDIAGNOSIS);
    }
    @Step("Verify the visibility of the REALTED SUBCATEGORY FOR ADD Hospitalization button")
    public boolean viewRelatedSubCategoryAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMRELATEDSUBCATEGORY);
    }
    @Step("Verify the visibility of the WORKING DIAGNOSIS FOR ADD Hospitalization button")
    public boolean viewWorkingDiagnosisAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMWORKINGDIAGNOSIS);
    }
    @Step("Verify the visibility of the PLANNED ADMISSION FOR ADD Hospitalization button")
    public boolean viewPlannedAdmissionAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMPLANNEDADMISSION);
    }
    @Step("Verify the visibility of the AVOIDABLE ADMISSION FOR ADD Hospitalization button")
    public boolean viewAvoidableAdmissionAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMAVOIDABLEADM);
    }
    @Step("Verify the visibility of the VERBAL CONTACT WITH HOSPITAL CASE MANAGER FOR ADD Hospitalization button")
    public boolean viewHOSPCMGRAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADMVCWHOSPCMGR);
    }
    @Step("Verify the visibility of the COMMENT FOR ADD Hospitalization button")
    public boolean viewCommentAddHospitalization() throws TimeoutException, WaitException
    {
        return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPADMCOMMENT);
    }
    
    
    @Step("Select an option to Enter FacilityName")
    public void enterFacitlityName(String facilityName) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMFACILITYNAME, facilityName);
    }
    @Step("Select an option to Enter Admit Date")
    public void enterAdmitDate(String AdmitDate) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMADMITDATE, AdmitDate);
    }
    @Step("Select an option to Enter NotificationDate")
    public void enterNotificationDate(String NotificationDate) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMNOTIFICATIONDATE, NotificationDate);
    }
    @Step("Select an option to Enter NotifiedBy")
    public void enterNotifiedBy(String NotifiedBy) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,CMB_ADDPOPUPADMNOTIFIEDBy, NotifiedBy);
    }
    @Step("Select an option to Enter Reason")
    public void enterReason(String Reason) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMREASON, Reason);
    }	
    @Step("Select an option to Enter Phone")
    public void enterPhone(String Phone) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMPHONE, Phone);
    }
    @Step("Select an option to Enter Fax")
    public void enterFax(String fax) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMFAX,fax);
    }
    @Step("Select an option to Enter AdmitType")
    public void enterAdmitType(String AdmitType) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMADMITTYPE, AdmitType);
    }
    @Step("Select an option to Enter SourceOfAdmit")
    public void enterSourceOfAdmit(String SourceOfAdmit) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPSOURCEOFADMIT, SourceOfAdmit);
    }
    @Step("Select an option to Enter PriorLocation")
    public void enterPriorLocation(String PriorLocation) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMPRIORLOCATION, PriorLocation);
    }
    @Step("Select an option to Enter Admittingdiagnosis")
    public void enterAdmittingdiagnosis(String Admittingdiagnosis) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMDMITTINGDIAGNOSIS, Admittingdiagnosis);
    }
    @Step("Select an option to Enter Related SubCategory")
    public void enterRelatedSubCategory(String RelatedSubCategory) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMRELATEDSUBCATEGORY, RelatedSubCategory);
    }
    @Step("Select an option to Enter Workingdiagnosis")
    public void enterWorkingdiagnosis(String Workingdiagnosis) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMWORKINGDIAGNOSIS, Workingdiagnosis);
    }
    @Step("Select an option to Enter PlannedAdmission")
    public void enterPlannedAdmission(String PlannedAdmission) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,CHK_ADDPOPUPADMPLANNEDADMISSION, PlannedAdmission);
    }
    @Step("Select an option to Enter AvoidableAdmission")
    public void enterAvoidableAdmission(String AvoidableAdmission) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,CHK_ADDPOPUPADMAVOIDABLEADM, AvoidableAdmission);
    }
    @Step("Select an option to Enter VERBAL CONTACT WITH HOSPITAL CASE MANAGER")
    public void enterHOSPCMGR(String enterHOSPCMGR) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,CHK_ADDPOPUPADMVCWHOSPCMGR , enterHOSPCMGR);
    }
    @Step("Select an option to Enter Comment")
    public void enterHospComment(String enterHospComment) throws TimeoutException, WaitException
    {
        webActions.enterText(NOTREQUIRED,TXT_ADDPOPUPADMCOMMENT, enterHospComment);
    }
    
    
    @Step("Verify the options of the Add HospNotified By box")
    public boolean verifyAddPopupHospNotifiedBydropdownOptions() throws TimeoutException, WaitException
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
                    
        return appFunctions.verifyDropDownOptions(CMB_ADDPOPUPADMNOTIFIEDBy, dropDownOptions);            
    }
    
    
    @Step("Verify the options of the Add HospReason box")
    public boolean verifyAddPopupHospReasondropdownOptions() throws TimeoutException, WaitException
    {
        List<String> dropDownOptions = new ArrayList<String>();
        dropDownOptions.add("Select a value");
        dropDownOptions.add("Dry Weight Not Changed Appropriately");
        dropDownOptions.add("End of Life Issues");
        dropDownOptions.add("Patient Did Not Follow Treatment Plan");
        dropDownOptions.add("Premature Discharge");
        dropDownOptions.add("Unrelated Readmission");
        
        return appFunctions.verifyDropDownOptions(TXT_ADDPOPUPADMREASON, dropDownOptions);
    }
    
    
	@Step("Verify the options of the Add HospAdmittype box")
	public boolean verifyAddPopupHospAdmittypedropdownOptions() throws TimeoutException, WaitException
	{
        List<String> dropDownOptions = new ArrayList<String>();
        dropDownOptions.add("Select a value");
        dropDownOptions.add("ED Visit");
        dropDownOptions.add("Hospital Admit");
        dropDownOptions.add("Observation");
        dropDownOptions.add("OutPatient");
        dropDownOptions.add("SNF/Rehab Admit");
        
        return appFunctions.verifyDropDownOptions(TXT_ADDPOPUPADMADMITTYPE, dropDownOptions);
	}
	                
	
	
	@Step("Verify the options of the Add HospSourceofAdmit box")
	public boolean verifyAddPopupHospSourceofadmitdropdownOptions() throws TimeoutException, WaitException
	{
	    List<String> dropDownOptions = new ArrayList<String>();
	    dropDownOptions.add("Select a value");
	    dropDownOptions.add("Elective Admit");
	    dropDownOptions.add("ER Admit");
	    dropDownOptions.add("Observation");
	    dropDownOptions.add("OutPatient");
	    dropDownOptions.add("Urgent Direct Admit");
	    
	    return appFunctions.verifyDropDownOptions(TXT_ADDPOPUPADMADMITTYPE, dropDownOptions);
	}
	
	
	@Step("Verify the options of the Add HospPriorLocation box")
	public boolean verifyAddPopupHospPriorLocationdropdownOptions() throws TimeoutException, WaitException
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
	    
	    return appFunctions.verifyDropDownOptions(TXT_ADDPOPUPADMADMITTYPE, dropDownOptions);
	}
                                    
	@Step("Verify the options of the Add HospAdmittingDiagnosis box")
	public boolean verifyAddPopupHospAdmittingDiagnosisdropdownOptions() throws TimeoutException, WaitException
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
	    
	    return appFunctions.verifyDropDownOptions(TXT_ADDPOPUPADMADMITTYPE, dropDownOptions);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWPOPUPHOMEHEALTHREASON);
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