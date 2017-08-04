package com.vh.ui.pages;

import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_ADDAPROVIDER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_ADDATEAMMEMBER;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWTEAMPOPUPPATIENTSEEINGSINCE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.BTN_NEWTEAMPOPUPSUBMIT;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CBO_NEWTEAMPOPUPSTATE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CBO_NEWTEAMPOPUPTEAMTYPE;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CHK_NEWTEAMPOPUPALLOWCOMMUNICATION;
import static com.vh.ui.web.locators.ProvidersTeamLocators.CHK_NEWTEAMPOPUPFAXNUMBERVERIFIED;
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

import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.ApplicationFunctions;
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

	public ProvidersTeamPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
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
	public void selectNewTeamPopupTeamTypeComboBox(String optionToSelect) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(VISIBILITY, CBO_NEWTEAMPOPUPTEAMTYPE, optionToSelect);
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
		webActions.selectFromDropDown(VISIBILITY, CBO_NEWTEAMPOPUPSTATE, optionToSelect);
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
		Thread.sleep(2000); // Give time for the Providers and Team screen to display

		clickAddAProviderButton();
	}

	@Step("Click the ADD A PROVIDER button")
	public void clickAddAProviderButton() throws TimeoutException, WaitException
	{
		webActions.click(VISIBILITY, BTN_ADDAPROVIDER);
	}
}