package com.vh.ui.pages;

import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_DATECOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_INUSECOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_PAGEHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_SOURCECOLUMNHEADER;
import static com.vh.ui.web.locators.MedicalEquipmentLocators.LBL_STATUSCOLUMNHEADER;

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

	@Step("Verify the visibility of the Medical Equipment page header label")
	public boolean viewPageHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PAGEHEADER);
	}

	@Step("Verify the visibility of the Equipment Description column header label")
	public boolean viewEquipmentDescriptionColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_EQUIPMENTDESCRIPTIONCOLUMNHEADER);
	}

	@Step("Verify the visibility of the Source column header label")
	public boolean viewSourceColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_SOURCECOLUMNHEADER);
	}

	@Step("Verify the visibility of the Date column header label")
	public boolean viewDateColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DATECOLUMNHEADER);
	}

	@Step("Verify the visibility of the Status column header label")
	public boolean viewStatusColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_STATUSCOLUMNHEADER);
	}

	@Step("Verify the visibility of the In Use column header label")
	public boolean viewInUseColumnHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_INUSECOLUMNHEADER);
	}
}