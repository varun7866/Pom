package com.vh.ui.pages;

import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_ADDAPROVIDER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_ADDATEAMMEMBER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWPROVIDERPOPUPADDPROVIDER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWPROVIDERPOPUPSEARCH;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWTEAMPOPUPCANCEL;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWTEAMPOPUPPATIENTSEEINGSINCE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWTEAMPOPUPSUBMIT;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWTEAMPOPUPSUBMITENABLE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWTEAMPOPUPX;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CAL_NEWTEAMPOPUPPATIENTSEEINGSINCE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CBO_ACTIVEINACTIVE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CBO_NEWPROVIDERPOPUPASSOCIATEAS;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CBO_NEWTEAMPOPUPSTATE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CBO_NEWTEAMPOPUPTEAMTYPE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CHK_NEWTEAMPOPUPALLOWCOMMUNICATION;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CHK_NEWTEAMPOPUPFAXNUMBERVERIFIED;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_ADDRESSCOLUMNHEADER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_ALLOWCONTACTCOLUMNHEADER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_DATESCOLUMNHEADER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NAMETYPECOLUMNHEADER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPADDRESS;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPALLOWCOMMUNICATION;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPAPTSUITE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPCITY;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPEMAIL;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPFAX;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPFAXNUMBERVERIFIED;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPHEADER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPNAME;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPOTHERPHONE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPPATIENTSEEINGSINCE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPPHONE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPSTATE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPTEAMTYPE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_NEWTEAMPOPUPZIP;
import static com.vh.ui.web.locators.ProvidersTeamLocators.LBL_PAGEHEADER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.PLH_ACTIVEINACTIVE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.PLH_NEWTEAMPOPUPSTATE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.PLH_NEWTEAMPOPUPTEAMTYPE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPADDRESS;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPAPTSUITE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPCITY;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPEMAIL;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPFAX;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPNAME;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPOTHERPHONE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPPATIENTSEEINGSINCE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPPHONE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.TXT_NEWTEAMPOPUPZIP;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.actions.ApplicationFunctions4;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   August 2, 2017
 * @class  ProviderTeamPage.java
 */

public class ProvidersTeamPage extends WebPage
{
	ApplicationFunctions appFunctions;
	ApplicationFunctions4 appFunctions4;

	public ProvidersTeamPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
		appFunctions4 = new ApplicationFunctions4(driver);
	}

	@Step("Delete all Providers and Team Members for the given Patient")
	public void deleteProvidersAndTeamDatabase(String memberID) throws TimeoutException, WaitException, SQLException
	{
		String memberUID = appFunctions.getMemberUIDFromMemberID(memberID);

		final String SQL_DELETE_AUD_MPA_MEM_PTA_ASSOCIATE = "DELETE AUD_MPA_MEM_PTA_ASSOCIATE WHERE MPA_MEM_UID = '" + memberUID + "'";
		appFunctions.queryDatabase(SQL_DELETE_AUD_MPA_MEM_PTA_ASSOCIATE);

		final String SQL_DELETE_MPA_MEM_PTA_ASSOCIATE = "DELETE MPA_MEM_PTA_ASSOCIATE WHERE MPA_MEM_UID = '" + memberUID + "' AND MPA_ASSOCIATION != 'VHN'";
		appFunctions.queryDatabase(SQL_DELETE_MPA_MEM_PTA_ASSOCIATE);

		appFunctions.closeDatabaseConnection();
	}

	@Step("Verify the visibility of the Providers and Team page header label")
	public boolean viewPageHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PAGEHEADER);
	}

	@Step("Verify the visibility of the ADD A TEAM MEMBER button")
	public boolean viewAddATeamMemberButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDATEAMMEMBER);
	}

	@Step("Verify the visibility of the ADD A PROVIDER button")
	public boolean viewAddAProviderButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDAPROVIDER);
	}

	@Step("Verify the visibility of the Active/Inactive combo box")
	public boolean viewActiveInactiveComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ACTIVEINACTIVE);
	}

	@Step("Verify the visibility of the Active/Inactive placeholder")
	public boolean viewActiveInactivePlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ACTIVEINACTIVE);
	}

	@Step("Verify the options of the Active/Inactive combo box")
	public boolean verifyActiveInactiveComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("Active");
		dropDownOptions.add("Inactive");
		dropDownOptions.add("All");

		return appFunctions.verifyDropDownOptions(CBO_ACTIVEINACTIVE, dropDownOptions);
	}

	@Step("Verify the visibility of the NAME/TYPE column header label")
	public boolean viewNameTypeColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NAMETYPECOLUMNHEADER);
	}

	@Step("Verify the visibility of the ADDRESS column header label")
	public boolean viewAddressColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDRESSCOLUMNHEADER);
	}

	@Step("Verify the visibility of the DATES column header label")
	public boolean viewDatesColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DATESCOLUMNHEADER);
	}

	@Step("Verify the visibility of the ALLOW CONTACT column header label")
	public boolean viewAllowContactColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ALLOWCONTACTCOLUMNHEADER);
	}

	@Step("Verify the visibility of the New Team popup header label")
	public boolean viewNewTeamPopupHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPHEADER);
	}

	@Step("Verify the visibility of the New Team popup X button")
	public boolean viewNewTeamPopupXButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWTEAMPOPUPX);
	}

	@Step("Verify the visibility of the New Team popup TEAM TYPE label")
	public boolean viewNewTeamPopupTeamTypeLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPTEAMTYPE);
	}

	@Step("Verify the visibility of the New Team popup TEAM TYPE combo box")
	public boolean viewNewTeamPopupTeamTypeComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWTEAMPOPUPTEAMTYPE);
	}

	@Step("Verify the visibility of the New Team popup TEAM TYPE placeholder")
	public boolean viewNewTeamPopupTeamTypePlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_NEWTEAMPOPUPTEAMTYPE);
	}

	@Step("Verify the options of the New Team popup TEAM TYPE combo box")
	public boolean verifyNewTeamPopupTeamTypeComboBoxOptions() throws TimeoutException, WaitException, SQLException
	{
		List<String> dropDownOptionsTextFromDB = appFunctions4.getDropDownOptionsByLookUpValueType("132");

		dropDownOptionsTextFromDB.remove("Assessment Nurse");
		dropDownOptionsTextFromDB.remove("Davita Pharmacist");
		dropDownOptionsTextFromDB.remove("Dialysis Center");
		dropDownOptionsTextFromDB.remove("Nephrologist");
		dropDownOptionsTextFromDB.remove("PCP");
		dropDownOptionsTextFromDB.remove("PRL");
		dropDownOptionsTextFromDB.remove("Pharmacist Tech");
		dropDownOptionsTextFromDB.remove("RCM");
		dropDownOptionsTextFromDB.remove("Reviewer");
		dropDownOptionsTextFromDB.remove("VHN");

		return appFunctions4.verifyDropDownOptionsByPassedInList(CBO_NEWTEAMPOPUPTEAMTYPE, dropDownOptionsTextFromDB);
	}

	@Step("Verify the visibility of the New Team popup NAME label")
	public boolean viewNewTeamPopupNameLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPNAME);
	}

	@Step("Verify the visibility of the New Team popup NAME text box")
	public boolean viewNewTeamPopupNameTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPNAME);
	}

	@Step("Verify the visibility of the New Team popup EMAIL label")
	public boolean viewNewTeamPopupEmailLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPEMAIL);
	}

	@Step("Verify the visibility of the New Team popup EMAIL text box")
	public boolean viewNewTeamPopupEmailTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPEMAIL);
	}

	@Step("Verify the visibility of the New Team popup ADDRESS label")
	public boolean viewNewTeamPopupAddressLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPADDRESS);
	}

	@Step("Verify the visibility of the New Team popup ADDRESS text box")
	public boolean viewNewTeamPopupAddressTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPADDRESS);
	}

	@Step("Verify the visibility of the New Team popup APT/SUITE label")
	public boolean viewNewTeamPopupAptSuiteLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPAPTSUITE);
	}

	@Step("Verify the visibility of the New Team popup APT/SUITE text box")
	public boolean viewNewTeamPopupAptSuiteTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPAPTSUITE);
	}

	@Step("Verify the visibility of the New Team popup CITY label")
	public boolean viewNewTeamPopupCityLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPCITY);
	}

	@Step("Verify the visibility of the New Team popup CITY text box")
	public boolean viewNewTeamPopupCityTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPCITY);
	}

	@Step("Verify the visibility of the New Team popup STATE label")
	public boolean viewNewTeamPopupStateLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPSTATE);
	}

	@Step("Verify the visibility of the New Team popup STATE combo box")
	public boolean viewNewTeamPopupStateComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_NEWTEAMPOPUPSTATE);
	}

	@Step("Verify the visibility of the New Team popup STATE placeholder")
	public boolean viewNewTeamPopupStatePlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_NEWTEAMPOPUPSTATE);
	}

	@Step("Verify the options of the New Team popup STATE combo box")
	public boolean verifyNewTeamPopupStateComboBoxOptions() throws TimeoutException, WaitException, SQLException
	{
		List<String> dropDownOptionsTextFromDB = new ArrayList<String>();
		
		ResultSet queryResultSet = appFunctions.queryDatabase("SELECT STA_DESC FROM STA_STATE_PROVINCE WHERE STA_RECORD_STATUS = 'A' ORDER BY STA_DESC");

		while (queryResultSet.next())
		{
			dropDownOptionsTextFromDB.add(queryResultSet.getString("STA_DESC"));
		}

		appFunctions.closeDatabaseConnection();
		
		return appFunctions4.verifyDropDownOptionsByPassedInList(CBO_NEWTEAMPOPUPSTATE, dropDownOptionsTextFromDB);
	}

	@Step("Verify the visibility of the New Team popup ZIP label")
	public boolean viewNewTeamPopupZipLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPZIP);
	}

	@Step("Verify the visibility of the New Team popup ZIP text box")
	public boolean viewNewTeamPopupZipTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPZIP);
	}

	@Step("Verify the visibility of the New Team popup PHONE label")
	public boolean viewNewTeamPopupPhoneLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPPHONE);
	}

	@Step("Verify the visibility of the New Team popup PHONE text box")
	public boolean viewNewTeamPopupPhoneTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPPHONE);
	}

	@Step("Verify the visibility of the New Team popup FAX label")
	public boolean viewNewTeamPopupFaxLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPFAX);
	}

	@Step("Verify the visibility of the New Team popup FAX text box")
	public boolean viewNewTeamPopupFaxTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPFAX);
	}

	@Step("Verify the visibility of the New Team popup OTHER PHONE label")
	public boolean viewNewTeamPopupOtherPhoneLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPOTHERPHONE);
	}

	@Step("Verify the visibility of the New Team popup OTHER PHONE text box")
	public boolean viewNewTeamPopupOtherPhoneTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_NEWTEAMPOPUPOTHERPHONE);
	}

	@Step("Verify the visibility of the New Team popup Allow Communication label")
	public boolean viewNewTeamPopupAllowCommunicationLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPALLOWCOMMUNICATION);
	}

	@Step("Verify the visibility of the New Team popup Allow Communication text box")
	public boolean viewNewTeamPopupAllowCommunicationCheckBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CHK_NEWTEAMPOPUPALLOWCOMMUNICATION);
	}

	@Step("Verify the visibility of the New Team popup Fax Number Verified label")
	public boolean viewNewTeamPopupFaxNumberVerifiedLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPFAXNUMBERVERIFIED);
	}

	@Step("Verify the visibility of the New Team popup Fax Number Verified text box")
	public boolean viewNewTeamPopupFaxNumberVerifiedCheckBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CHK_NEWTEAMPOPUPFAXNUMBERVERIFIED);
	}

	@Step("Verify the visibility of the New Team popup PATIENT SEEING SINCE label")
	public boolean viewNewTeamPopupPatientSeeingSinceLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPPATIENTSEEINGSINCE);
	}

	@Step("Verify the visibility of the New Team popup PATIENT SEEING SINCE date picker")
	public boolean viewNewTeamPopupPatientSeeingSinceDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_NEWTEAMPOPUPPATIENTSEEINGSINCE);
	}

	@Step("Verify the visibility of the New Team popup PATIENT SEEING SINCE date picker button")
	public boolean viewNewTeamPopupPatientSeeingSinceDatePickerButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWTEAMPOPUPPATIENTSEEINGSINCE);
	}

	@Step("Verify the visibility of the New Team popup CANCEL button")
	public boolean viewNewTeamPopupCancelButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWTEAMPOPUPCANCEL);
	}

	@Step("Verify the visibility of the New Team popup SUBMIT button")
	public boolean viewNewTeamPopupSubmitButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_NEWTEAMPOPUPSUBMIT);
	}

	@Step("Verify if the New Team popup SUBMIT button is enabled")
	public boolean isNewTeamPopupSubmitButtonEnabled() throws TimeoutException, WaitException
	{
		return webActions.isElementEnabledLocatedBy(BTN_NEWTEAMPOPUPSUBMITENABLE);
	}

	@Step("Verify the visibility of the passed in error message on the New Team popup")
	public boolean viewNewTeamPopupErrorMessage(String errorMessage) throws TimeoutException, WaitException
	{
		final By LBL_NEWTEAMPOPUPERRORMESSAGE = By.xpath("//div[@class='error-message' and text()=\"" + errorMessage + "\"]");
		
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_NEWTEAMPOPUPERRORMESSAGE);
	}

	@Step("Adds a Team Member to the table")
	public void addATeamMember(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		clickAddATeamMemberButton();

		if (map.get("TEAMTYPE") != null)
		{
			selectNewTeamPopupTeamTypeComboBox(map.get("TEAMTYPE"));
		}

		if (map.get("NAME") != null)
		{
			enterNewTeamPopupName(map.get("NAME"));
		}

		if (map.get("EMAIL") != null)
		{
			enterNewTeamPopupEmail(map.get("EMAIL"));
		}

		if (map.get("ADDRESS") != null)
		{
			enterNewTeamPopupAddress(map.get("ADDRESS"));
		}

		if (map.get("APTSUITE") != null)
		{
			enterNewTeamPopupAptSuite(map.get("APTSUITE"));
		}

		if (map.get("CITY") != null)
		{
			enterNewTeamPopupCity(map.get("CITY"));
		}

		if (map.get("STATE") != null)
		{
			selectNewTeamPopupStateComboBox(map.get("STATE"));
		}

		if (map.get("ZIP") != null)
		{
			enterNewTeamPopupZip(map.get("ZIP"));
		}

		if (map.get("PHONE") != null)
		{
			enterNewTeamPopupPhone(map.get("PHONE"));
		}

		if (map.get("FAX") != null)
		{
			enterNewTeamPopupFax(map.get("FAX"));
		}

		if (map.get("OTHERPHONE") != null)
		{
			enterNewTeamPopupOtherPhone(map.get("OTHERPHONE"));
		}

		if (map.get("ALLOWCOMMUNICATION") != null)
		{
			checkNewTeamPopupAllowCommunicationCheckBox(map.get("ALLOWCOMMUNICATION"));
		}

		if (map.get("FAXNUMBERVERIFIED") != null)
		{
			checkNewTeamPopupFaxNumberVerifiedCheckBox(map.get("FAXNUMBERVERIFIED"));
		}

		if (map.get("PATIENTSEEINGSINCE") != null)
		{
			enterNewTeamPopupPatientSeeingSince(map.get("PATIENTSEEINGSINCE"));
		}

		clickNewTeamPopupSubmitButton();
	}

	@Step("Click the ADD A TEAM MEMBER button")
	public void clickAddATeamMemberButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_ADDATEAMMEMBER);
	}

	@Step("Select an option form the New Team popup TEAM TYPE combo box")
	public void selectNewTeamPopupTeamTypeComboBox(String value) throws TimeoutException, WaitException
	{
		webActions4.selectFromDropDown(VISIBILITY, CBO_NEWTEAMPOPUPTEAMTYPE, value);
	}

	@Step("Enter {0} in the New Team popup NAME text field")
	public void enterNewTeamPopupName(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPNAME, value);
	}

	@Step("Enter {0} in the New Team popup EMAIL text field")
	public void enterNewTeamPopupEmail(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPEMAIL, value);
	}

	@Step("Enter {0} in the New Team popup ADDRESS text field")
	public void enterNewTeamPopupAddress(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPADDRESS, value);
	}

	@Step("Enter {0} in the New Team popup APT/SUITE text field")
	public void enterNewTeamPopupAptSuite(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPAPTSUITE, value);
	}

	@Step("Enter {0} in the New Team popup CITY text field")
	public void enterNewTeamPopupCity(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPCITY, value);
	}

	@Step("Select an option form the New Team popup STATE combo box")
	public void selectNewTeamPopupStateComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions4.selectFromDropDown(VISIBILITY, CBO_NEWTEAMPOPUPSTATE, optionToSelect);
	}

	@Step("Enter {0} in the New Team popup ZIP text field")
	public void enterNewTeamPopupZip(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPZIP, value);
	}

	@Step("Enter {0} in the New Team popup PHONE text field")
	public void enterNewTeamPopupPhone(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPPHONE, value);
	}

	@Step("Enter {0} in the New Team popup FAX text field")
	public void enterNewTeamPopupFax(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPFAX, value);
	}

	@Step("Enter {0} in the New Team popup OTHER PHONE text field")
	public void enterNewTeamPopupOtherPhone(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPOTHERPHONE, value);
	}

	@Step("Enter {0} in the New Team popup Allow Communication check box")
	public void checkNewTeamPopupAllowCommunicationCheckBox(String value) throws TimeoutException, WaitException
	{
		if (value.equals("Y"))
		{
			webActions.click(VISIBILITY, CHK_NEWTEAMPOPUPALLOWCOMMUNICATION);
		}
	}

	@Step("Enter {0} in the New Team popup Fax Number Verified check box")
	public void checkNewTeamPopupFaxNumberVerifiedCheckBox(String value) throws TimeoutException, WaitException
	{
		if (value.equals("Y"))
		{
			webActions.click(VISIBILITY, CHK_NEWTEAMPOPUPFAXNUMBERVERIFIED);
		}
	}

	@Step("Click the New Team popup PATIENT SEEING SINCE date picker button")
	public void clickNewTeamPopupPatientSeeingSinceDatePickerButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_NEWTEAMPOPUPPATIENTSEEINGSINCE);
	}

	@Step("Enter {0} in the New Team popup PATIENT SEEING SINCE text box")
	public void enterNewTeamPopupPatientSeeingSince(String value) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_NEWTEAMPOPUPPATIENTSEEINGSINCE, value);
	}

	@Step("Click the New Team popup SUBMIT button")
	public void clickNewTeamPopupSubmitButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_NEWTEAMPOPUPSUBMIT);
	}

	@Step("Adds a Provider to the table")
	public void addAProvider(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		clickAddAProviderButton();
		clickNewProviderPopupSearchButton();
		Thread.sleep(11000);
		clickNewProviderPopupAccordion(map.get("PROVIDERNAME"));
		selectNewProviderPopupAssociateAsComboBox(map.get("ASSOCIATEAS"));
		clickNewProviderPopupAddProviderButton();
	}

	@Step("Click the ADD A PROVIDER button")
	public void clickAddAProviderButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_ADDAPROVIDER);
	}

	@Step("Click the Add Provider popup SEARCH button")
	public void clickNewProviderPopupSearchButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_NEWPROVIDERPOPUPSEARCH);
	}

	@Step("Expand {0} Add Provider popup Provider accordion")
	public void clickNewProviderPopupAccordion(String value) throws TimeoutException, WaitException
	{
		final By BTN_NEWPROVIDERPOPUPCHEVRON = By.xpath("//providers-team-add-provider//span[contains(., '" + value + "')]");

		webActions.javascriptClick(BTN_NEWPROVIDERPOPUPCHEVRON);
	}

	@Step("Select an option form the New Provider popup ASSOCIATE AS combo box")
	public void selectNewProviderPopupAssociateAsComboBox(String value) throws TimeoutException, WaitException
	{
		webActions4.selectFromDropDown(VISIBILITY, CBO_NEWPROVIDERPOPUPASSOCIATEAS, value);
	}

	@Step("Click the Add Provider popup ADD PROVIDER button")
	public void clickNewProviderPopupAddProviderButton() throws TimeoutException, WaitException
	{
		webActions.javascriptClick(BTN_NEWPROVIDERPOPUPADDPROVIDER);
	}
}