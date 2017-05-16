package com.vh.ui.pages;

import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_PAGEHEADER;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   May 12, 2017
 * @class  MedicalEquipmentPage.java
 */

public class MedicalEquipmentPage extends WebPage
{
	public MedicalEquipmentPage(WebDriver driver) throws WaitException {
		super(driver);
	}

	@Step("Verifying the visibility of the Medical Equipment page header label")
	public boolean viewPageHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PAGEHEADER);
	}
}