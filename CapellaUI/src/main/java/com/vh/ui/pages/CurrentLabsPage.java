package com.vh.ui.pages;

import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDLAB;
import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES;
import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDPOPUPCANCEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDPOPUPSAVE;
import static com.vh.ui.web.locators.CurrentLabsLocators.CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPALBUMIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPBLOODPRESUREDIASTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPCALCIUMXPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPCO2LEVEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPGFR;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPHEPATITISBTITER;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPKTV;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPLDL;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPOTASSIUM;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPTSAT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPADDLABRESULTS;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPALBUMIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPAPPLYTHISDATETOALLVALUES;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPBLOODPRESUREDIASTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPCALCIUMXPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPCO2LEVEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPGFR;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPHEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPHEPATITISBTITER;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPKTV;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPLDL;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPPOTASSIUM;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPTARGETDRYWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPTSAT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_PAGEHEADER;
import static com.vh.ui.web.locators.CurrentLabsLocators.PLH_ADDPOPUPHEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.PLH_ADDPOPUPTARGETDRYWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.PLH_ADDPOPUPWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPALBUMIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPBLOODPRESUREDIASTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPCALCIUMXPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPCO2LEVEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPGFR;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPHEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPHEPATITISBTITER;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPKTV;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPLDL;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPPOTASSIUM;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPTARGETDRYWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPTSAT;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPWEIGHT;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   June 14, 2017
 * @class  CurrentLabsPage.java
 */

public class CurrentLabsPage extends WebPage
{
	ApplicationFunctions appFunctions;

	public CurrentLabsPage(WebDriver driver) throws WaitException {
		super(driver);

		appFunctions = new ApplicationFunctions(driver);
	}

	@Step("Verify the visibility of the Current Labs page header label")
	public boolean viewPageHeaderLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PAGEHEADER);
	}

	@Step("Verify the visibility of the ADD LAB button")
	public boolean viewAddLabButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDLAB);
	}

	@Step("Click the ADD LAB button")
	public void clickAddLabButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDLAB);
	}

	@Step("Verify the visibility of the Add Lab Results popup")
	public boolean viewAddLabResultsPopup() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPADDLABRESULTS);
	}

	@Step("Verify the visibility of the Add Labs Results popup CANCEL button")
	public boolean viewAddPopupCancelButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPCANCEL);
	}

	@Step("Verify the visibility of the Add Lab Results popup ADD button")
	public boolean viewAddPopupSaveButton() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, BTN_ADDPOPUPSAVE);
	}

	@Step("Verify the visibility of the Add Lab Results popup APPLY THIS DATE TO ALL VALUES label")
	public boolean viewAddPopupApplyThisDateToAllValuesLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPAPPLYTHISDATETOALLVALUES);
	}

	@Step("Verify the visibility of the Add Lab Results popup APPLY THIS DATE TO ALL VALUES picker")
	public boolean viewAddPopupDatePicker() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES);
	}

	@Step("Verify the visibility of all the Add Lab Results popup date picker buttons")
	public boolean viewAddPopupDatePickerButtons() throws TimeoutException, WaitException
	{
		List<WebElement> labsDates = driver.findElements(By.xpath("//div[@class='modal-dialog modal-lg']//button[@class='btnpicker btnpickerenabled']"));

		if (labsDates.size() == 24)
		{
			return true;
		} else
		{
			return false;
		}
	}

	@Step("Verify the Add Lab Results popup default date in the APPLY THIS DATE TO ALL VALUES picker is equal to the current date")
	public boolean isAddPopupDefaultDateCurrentDate() throws TimeoutException, WaitException, InterruptedException
	{
		return appFunctions.isCalendarDateEqualToCurrentDate(CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES);
	}

	@Step("Verify the Add Lab Results popup APPLY THIS DATE TO ALL VALUES applies the date to all date pickers")
	public boolean isAddPopupDateAplliedToAllDates(int dayChangeBy) throws TimeoutException, WaitException, InterruptedException
	{
		String currentDayMinusXDay;
		String currentDayMinusXDayGregorian;
		String attributeValue;
		
		if (dayChangeBy != 0) // If not checking the current date
		{
			webActions.click(VISIBILITY, BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES);
		}

		Calendar cal = Calendar.getInstance();
		DateFormat dateFormatDay = new SimpleDateFormat("d");
		DateFormat dateFormatGregorian = new SimpleDateFormat("MM/dd/yyyy");
		cal.add(Calendar.DATE, dayChangeBy);
		currentDayMinusXDay = dateFormatDay.format(new Date(cal.getTimeInMillis()));
		currentDayMinusXDayGregorian = dateFormatGregorian.format(new Date(cal.getTimeInMillis()));

		if (dayChangeBy != 0) // If not checking the current date
		{
			appFunctions.selectDateFromCalendar(CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES, currentDayMinusXDay);
		}

		List<WebElement> labsDates = driver.findElements(By.xpath("//div[@class='modal-dialog modal-lg']//input[@class='selection inputnoteditable ng-untouched ng-pristine ng-valid']"));
		
		if (labsDates.size() != 24)
		{
			return false;
		}

		for (WebElement labDate : labsDates)
		{
			attributeValue = labDate.getAttribute("ng-reflect-value");

			if (!attributeValue.equals(currentDayMinusXDayGregorian))
			{
				return false;
			}
		}

		return true;
	}

	@Step("Verify the visibility of the Add Lab Results popup HEIGHT label")
	public boolean viewAddpopupHeightLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPHEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup HEIGHT text box")
	public boolean viewAddpopupHeightTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPHEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup HEIGHT placeholder")
	public boolean viewAddpopupHeightPlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPHEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup TARGET DRY WEIGHT label")
	public boolean viewAddpopupTargetDryWeightLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPTARGETDRYWEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup TARGET DRY WEIGHT text box")
	public boolean viewAddpopupTargetDryWeightTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPTARGETDRYWEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup TARGET DRY WEIGHT placeholder")
	public boolean viewAddpopupTargetDryWeightPlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPTARGETDRYWEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup PHOSPHOROUS label")
	public boolean viewAddpopupPhosphorousLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPHOSPHOROUS);
	}

	@Step("Verify the visibility of the Add Lab Results popup PHOSPHOROUS text box")
	public boolean viewAddpopupPhosphorousTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPPHOSPHOROUS);
	}

	@Step("Verify the visibility of the Add Lab Results popup PHOSPHOROUS goal")
	public boolean viewAddpopupPhosphorousGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPPHOSPHOROUS);
	}

	@Step("Verify the visibility of the Add Lab Results popup GFR label")
	public boolean viewAddpopupGFRLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPGFR);
	}

	@Step("Verify the visibility of the Add Lab Results popup GFR text box")
	public boolean viewAddpopupGFRTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPGFR);
	}

	@Step("Verify the visibility of the Add Lab Results popup GFR goal")
	public boolean viewAddpopupGFRGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPGFR);
	}

	@Step("Verify the visibility of the Add Lab Results popup LDL label")
	public boolean viewAddpopupLDLLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPLDL);
	}

	@Step("Verify the visibility of the Add Lab Results popup LDL text box")
	public boolean viewAddpopupLDLTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPLDL);
	}

	@Step("Verify the visibility of the Add Lab Results popup LDL goal")
	public boolean viewAddpopupLDLGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPLDL);
	}

	@Step("Verify the visibility of the Add Lab Results popup ALBUMIN label")
	public boolean viewAddpopupAlbuminLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPALBUMIN);
	}

	@Step("Verify the visibility of the Add Lab Results popup ALBUMIN text box")
	public boolean viewAddpopupAlbuminTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPALBUMIN);
	}

	@Step("Verify the visibility of the Add Lab Results popup ALBUMIN goal")
	public boolean viewAddpopupAlbuminGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPALBUMIN);
	}

	@Step("Verify the visibility of the Add Lab Results popup CO2 LEVEL label")
	public boolean viewAddpopupCo2LevelLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCO2LEVEL);
	}

	@Step("Verify the visibility of the Add Lab Results popup CO2 LEVEL text box")
	public boolean viewAddpopupCo2LevelTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPCO2LEVEL);
	}

	@Step("Verify the visibility of the Add Lab Results popup CO2 LEVEL goal")
	public boolean viewAddpopupCo2LevelGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPCO2LEVEL);
	}

	@Step("Verify the visibility of the Add Lab Results popup KT/V label")
	public boolean viewAddpopupKTVLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPKTV);
	}

	@Step("Verify the visibility of the Add Lab Results popup KT/V text box")
	public boolean viewAddpopupKTVTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPKTV);
	}

	@Step("Verify the visibility of the Add Lab Results popup KT/V goal")
	public boolean viewAddpopupKTVGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPKTV);
	}

	@Step("Verify the visibility of the Add Lab Results popup POTASSIUM label")
	public boolean viewAddpopupPotassiumLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPOTASSIUM);
	}

	@Step("Verify the visibility of the Add Lab Results popup POTASSIUM text box")
	public boolean viewAddpopupPotassiumTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPPOTASSIUM);
	}

	@Step("Verify the visibility of the Add Lab Results popup POTASSIUM goal")
	public boolean viewAddpopupPotassiumGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPPOTASSIUM);
	}

	@Step("Verify the visibility of the Add Lab Results popup HEPATITIS B TITER label")
	public boolean viewAddpopupHepatitisBTiterLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPHEPATITISBTITER);
	}

	@Step("Verify the visibility of the Add Lab Results popup HEPATITIS B TITER text box")
	public boolean viewAddpopupHepatitisBTiterTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPHEPATITISBTITER);
	}

	@Step("Verify the visibility of the Add Lab Results popup HEPATITIS B TITER goal")
	public boolean viewAddpopupHepatitisBTiterGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPHEPATITISBTITER);
	}

	@Step("Verify the visibility of the Add Lab Results popup TSAT label")
	public boolean viewAddpopupTSATLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPTSAT);
	}

	@Step("Verify the visibility of the Add Lab Results popup TSAT text box")
	public boolean viewAddpopupTSATTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPTSAT);
	}

	@Step("Verify the visibility of the Add Lab Results popup TSAT goal")
	public boolean viewAddpopupTSATGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPTSAT);
	}

	@Step("Verify the visibility of the Add Lab Results popup BLOOD PRESURE DIASTOLIC label")
	public boolean viewAddpopupBloodPressureDiastolicLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPBLOODPRESUREDIASTOLIC);
	}

	@Step("Verify the visibility of the Add Lab Results popup BLOOD PRESURE DIASTOLIC text box")
	public boolean viewAddpopupBloodPressureDiastolicTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPBLOODPRESUREDIASTOLIC);
	}

	@Step("Verify the visibility of the Add Lab Results popup BLOOD PRESURE DIASTOLIC goal")
	public boolean viewAddpopupBloodPressureDiastolicGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPBLOODPRESUREDIASTOLIC);
	}

	@Step("Verify the visibility of the Add Lab Results popup WEIGHT label")
	public boolean viewAddpopupWeightLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPWEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup WEIGHT text box")
	public boolean viewAddpopupWeightTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPWEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup WEIGHT placeholder")
	public boolean viewAddpopupWeightPlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPWEIGHT);
	}

	@Step("Verify the visibility of the Add Lab Results popup CALCIUM X PHOSPHOROUS label")
	public boolean viewAddpopupCalciumXPhosphorousLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCALCIUMXPHOSPHOROUS);
	}

	@Step("Verify the visibility of the Add Lab Results popup CALCIUM X PHOSPHOROUS text box")
	public boolean viewAddpopupCalciumXPhosphorousTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPCALCIUMXPHOSPHOROUS);
	}

	@Step("Verify the visibility of the Add Lab Results popup CALCIUM X PHOSPHOROUS goal")
	public boolean viewAddpopupCalciumXPhosphorousGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPCALCIUMXPHOSPHOROUS);
	}
}