package com.vh.ui.pages;

import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCARE;
import static com.vh.ui.web.locators.PatientNavigationLocators.LBL_PLANOFCAREOVERVIEW;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   June 29, 2017
 * @class  PatientNavigationPage.java
 */

public class PatientNavigationPage extends WebPage
{
	public PatientNavigationPage(WebDriver driver) throws WaitException {
		super(driver);
	}

	@Step("Verify the visibility of the Plan of Care menu")
	public boolean viewPlanOfCareMenu() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PLANOFCARE);
	}

	@Step("Verify the expansion of the Plan of Care menu")
	public boolean viewPlanOfCareMenuExpanded() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, LBL_PLANOFCARE);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PLANOFCAREOVERVIEW);
	}

	@Step("Verify the Overview screen is displayed")
	public boolean viewPlanOfCareOverviewScreen() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, LBL_PLANOFCAREOVERVIEW);

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PLANOFCAREOVERVIEW);
	}
}