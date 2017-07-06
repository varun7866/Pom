package com.vh.ui.pages;

import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDLAB;
import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES;
import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDPOPUPCANCEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.BTN_ADDPOPUPSAVE;
import static com.vh.ui.web.locators.CurrentLabsLocators.CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES;
import static com.vh.ui.web.locators.CurrentLabsLocators.CBO_ADDPOPUPDIPSTICKFORPROTEIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPALBUMIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPBLOODPRESUREDIASTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPBLOODPRESURESYSTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPCALCIUM1;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPCALCIUM2;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPCALCIUMXPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPCO2LEVEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPCREATININE;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPDIPSTICKFORPROTEIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPFERRITIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPGFR;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPHEPATITISBTITER;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPHGB;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPHGBA1C;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPKTV;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPLDL;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPOTASSIUM;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPTH1;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPTH2;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPTH3;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPTH4;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPPTH5;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPTSAT;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPURINEALBUMINCREATININERATIO;
import static com.vh.ui.web.locators.CurrentLabsLocators.GOL_ADDPOPUPURR;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPADDLABRESULTS;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPALBUMIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPAPPLYTHISDATETOALLVALUES;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPBLOODPRESUREDIASTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPBLOODPRESURESYSTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPCALCIUM;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPCALCIUMXPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPCO2LEVEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPCREATININE;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPDIPSTICKFORPROTEIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPFERRITIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPGFR;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPHEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPHEPATITISBTITER;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPHGB;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPHGBA1C;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPKTV;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPLDL;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPPOTASSIUM;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPTARGETDRYWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPTH;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPTSAT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPURINEALBUMINCREATININERATIO;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPURR;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_ADDPOPUPWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.LBL_PAGEHEADER;
import static com.vh.ui.web.locators.CurrentLabsLocators.PLH_ADDPOPUPDIPSTICKFORPROTEIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.PLH_ADDPOPUPHEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.PLH_ADDPOPUPTARGETDRYWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.PLH_ADDPOPUPWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPALBUMIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPBLOODPRESUREDIASTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPBLOODPRESURESYSTOLIC;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPCALCIUM;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPCALCIUMXPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPCO2LEVEL;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPCREATININE;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPFERRITIN;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPGFR;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPHEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPHEPATITISBTITER;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPHGB;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPHGBA1C;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPKTV;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPLDL;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPPHOSPHOROUS;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPPOTASSIUM;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPPTH;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPTARGETDRYWEIGHT;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPTSAT;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPURINEALBUMINCREATININERATIO;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPURR;
import static com.vh.ui.web.locators.CurrentLabsLocators.TXT_ADDPOPUPWEIGHT;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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

	@Step("Click the Cancel button")
	public void clickAddPopupCancelButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDPOPUPCANCEL);
	}

	@Step("Click the Save button")
	public void clickAddPopupSaveButton() throws TimeoutException, WaitException
	{
		webActions.click(CLICKABILITY, BTN_ADDPOPUPSAVE);
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
	public boolean viewAddPopupDatePickerButtons(String diseaseState) throws TimeoutException, WaitException
	{
		List<WebElement> labsDates = driver.findElements(By.xpath("//div[@class='modal-dialog modal-lg']//button[@class='btnpicker btnpickerenabled']"));

		if ((diseaseState.equals("CKD") && labsDates.size() == 25) || (diseaseState.equals("ESRD") && labsDates.size() == 24))
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
	public boolean isAddPopupDateAplliedToAllDates(String diseaseState, int dayChangeBy) throws TimeoutException, WaitException, InterruptedException
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
		
		if ((diseaseState.equals("CKD") && labsDates.size() != 25) || (diseaseState.equals("ESRD") && labsDates.size() != 24))
		{
			return false;
		}

		for (WebElement labDate : labsDates)
		{
			attributeValue = labDate.getAttribute("ng-reflect-model");

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

	@Step("Verify the visibility of the Add Lab Results popup CREATININE label")
	public boolean viewAddpopupCreatinineLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCREATININE);
	}

	@Step("Verify the visibility of the Add Lab Results popup CREATININE text box")
	public boolean viewAddpopupCreatinineTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPCREATININE);
	}

	@Step("Verify the visibility of the Add Lab Results popup CREATININE goal")
	public boolean viewAddpopupCreatinineGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPCREATININE);
	}

	@Step("Verify the visibility of the Add Lab Results popup HGB A1C label")
	public boolean viewAddpopupHGBA1CLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPHGBA1C);
	}

	@Step("Verify the visibility of the Add Lab Results popup HGB A1C text box")
	public boolean viewAddpopupHGBA1CTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPHGBA1C);
	}

	@Step("Verify the visibility of the Add Lab Results popup HGB A1C goal")
	public boolean viewAddpopupHGBA1CGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPHGBA1C);
	}

	@Step("Verify the visibility of the Add Lab Results popup HGB label")
	public boolean viewAddpopupHGBLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPHGB);
	}

	@Step("Verify the visibility of the Add Lab Results popup HGB text box")
	public boolean viewAddpopupHGBTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPHGB);
	}

	@Step("Verify the visibility of the Add Lab Results popup HGB goal")
	public boolean viewAddpopupHGBGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPHGB);
	}

	@Step("Verify the visibility of the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO label")
	public boolean viewAddpopupUrineAlbuminCreatinineRatioLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPURINEALBUMINCREATININERATIO);
	}

	@Step("Verify the visibility of the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO text box")
	public boolean viewAddpopupUrineAlbuminCreatinineRatioTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPURINEALBUMINCREATININERATIO);
	}

	@Step("Verify the visibility of the Add Lab Results popup URINE ALBUMIN/CREATININE RATIO goal")
	public boolean viewAddpopupUrineAlbuminCreatinineRatioGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPURINEALBUMINCREATININERATIO);
	}

	@Step("Verify the visibility of the Add Lab Results popup CALCIUM label")
	public boolean viewAddpopupCalciumLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCALCIUM);
	}

	@Step("Verify the visibility of the Add Lab Results popup CALCIUM text box")
	public boolean viewAddpopupCalciumTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPCALCIUM);
	}

	@Step("Verify the visibility of the Add Lab Results popup CALCIUM goal 1")
	public boolean viewAddpopupCalciumGoal1() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPCALCIUM1);
	}

	@Step("Verify the visibility of the Add Lab Results popup CALCIUM goal 2")
	public boolean viewAddpopupCalciumGoal2() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPCALCIUM2);
	}

	@Step("Verify the visibility of the Add Lab Results popup URR label")
	public boolean viewAddpopupURRLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPURR);
	}

	@Step("Verify the visibility of the Add Lab Results popup URR text box")
	public boolean viewAddpopupURRTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPURR);
	}

	@Step("Verify the visibility of the Add Lab Results popup URR goal")
	public boolean viewAddpopupURRGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPURR);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH label")
	public boolean viewAddpopupPTHLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPTH);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH text box")
	public boolean viewAddpopupPTHTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPPTH);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 1")
	public boolean viewAddpopupPTHGoal1() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPPTH1);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 2")
	public boolean viewAddpopupPTHGoal2() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPPTH2);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 3")
	public boolean viewAddpopupPTHGoal3() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPPTH3);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 4")
	public boolean viewAddpopupPTHGoal4() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPPTH4);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 5")
	public boolean viewAddpopupPTHGoal5() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPPTH5);
	}

	@Step("Verify the visibility of the Add Lab Results popup FERRITIN label")
	public boolean viewAddpopupFerritinLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPFERRITIN);
	}

	@Step("Verify the visibility of the Add Lab Results popup FERRITIN text box")
	public boolean viewAddpopupFerritinTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPFERRITIN);
	}

	@Step("Verify the visibility of the Add Lab Results popup FERRITIN goal 1")
	public boolean viewAddpopupFerritinGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPFERRITIN);
	}

	@Step("Verify the visibility of the Add Lab Results popup BLOOD PRESURE SYSTOLIC label")
	public boolean viewAddpopupBloodPressureSystolicLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPBLOODPRESURESYSTOLIC);
	}

	@Step("Verify the visibility of the Add Lab Results popup BLOOD PRESURE SYSTOLIC text box")
	public boolean viewAddpopupBloodPressureSystolicTextBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, TXT_ADDPOPUPBLOODPRESURESYSTOLIC);
	}

	@Step("Verify the visibility of the Add Lab Results popup BLOOD PRESURE SYSTOLIC goal")
	public boolean viewAddpopupBloodPressureSystolicGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPBLOODPRESURESYSTOLIC);
	}

	@Step("Verify the visibility of the Add Lab Results popup DIPSTICK FOR PROTEIN label")
	public boolean viewAddpopupDipstickForProteinLabel() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPDIPSTICKFORPROTEIN);
	}

	@Step("Verify the visibility of the Add Lab Results popup DIPSTICK FOR PROTEIN combo box")
	public boolean viewAddPopupDipstickForProteinComboBox() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, CBO_ADDPOPUPDIPSTICKFORPROTEIN);
	}

	@Step("Verify the visibility of the Add Medical Equipment popup DIPSTICK FOR PROTEIN placeholder")
	public boolean viewAddpopupDipstickForProteinPlaceholder() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, PLH_ADDPOPUPDIPSTICKFORPROTEIN);
	}

	@Step("Verify the options of the Add Medical Equipment popup DIPSTICK FOR PROTEIN combo box")
	public boolean verifyAddPopupDipstickForProteinComboBoxOptions() throws TimeoutException, WaitException
	{
		List<String> dropDownOptions = new ArrayList<String>();
		dropDownOptions.add("No Test");
		dropDownOptions.add("Negative");
		dropDownOptions.add("Positive");

		return appFunctions.verifyDropDownOptions(CBO_ADDPOPUPDIPSTICKFORPROTEIN, dropDownOptions);
	}

	@Step("Verify the visibility of the Add Lab Results popup DIPSTICK FOR PROTEIN goal")
	public boolean viewAddpopupDipstickForProteinGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, GOL_ADDPOPUPDIPSTICKFORPROTEIN);
	}

	@Step("Populate all fields on the Add Lab Results popup for a CKD Patient")
	public void populateAddPopupAllCKD() throws TimeoutException, WaitException
	{
		enterHeight("182.88").enterTargetDryWeight("77.1107").enterPhosphorous("3.5").enterGFR("70").enterLDL("50").enterAlbumin("5").enterDipstickForProtein("Positive").enterCalcium("9.1")
		        .enterURR("70").enterPTH("300").enterFerritin("250").enterBloodPressureSystolic("100").enterWeight("77.1107").enterCalciumXPhosphorous("45").enterCreatinineString("1.2")
		        .enterHGBA1C("6").enterHGB("5").enterUrineAlbuminCreatinineRatio("15").enterCO2Level("25").enterKTV("1.5").enterPotassium("4.1").enterHepatitisBTiter("50").enterTSAT("50")
		        .enterBloodPressureDiastolic("30");
	}

	@Step("Populate all fields on the Add Lab Results popup for an ESRD Patient")
	public void populateAddPopupAllESRD() throws TimeoutException, WaitException
	{
		enterHeight("182.88").enterTargetDryWeight("77.1107").enterPhosphorous("3.5").enterGFR("70").enterLDL("50").enterAlbumin("5").enterCO2Level("25").enterKTV("1.5")
		        .enterPotassium("4.1").enterHepatitisBTiter("50").enterTSAT("50").enterBloodPressureDiastolic("30").enterWeight("77.1107").enterCalciumXPhosphorous("45")
		        .enterCreatinineString("1.2").enterHGBA1C("6").enterHGB("5").enterUrineAlbuminCreatinineRatio("15").enterCalcium("9.1").enterURR("70").enterPTH("200").enterFerritin("250")
		        .enterBloodPressureSystolic("100");
	}

	@Step("Entered {0} in the HEIGHT text field")
	public CurrentLabsPage enterHeight(String heightVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPHEIGHT, heightVal);
		return this;
	}

	@Step("Entered {0} in the TARGET DRY WEIGHT text field")
	public CurrentLabsPage enterTargetDryWeight(String targetDryWeightVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPTARGETDRYWEIGHT, targetDryWeightVal);
		return this;
	}

	@Step("Entered {0} in the PHOSPHOROUS text field")
	public CurrentLabsPage enterPhosphorous(String phosphorousVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPPHOSPHOROUS, phosphorousVal);
		return this;
	}

	@Step("Entered {0} in the GFR text field")
	public CurrentLabsPage enterGFR(String gfrVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPGFR, gfrVal);
		return this;
	}

	@Step("Entered {0} in the LDL text field")
	public CurrentLabsPage enterLDL(String ldlVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPLDL, ldlVal);
		return this;
	}

	@Step("Entered {0} in the ALBUMIN text field")
	public CurrentLabsPage enterAlbumin(String albuminVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPALBUMIN, albuminVal);
		return this;
	}

	@Step("Entered {0} in the CO2 LEVEL text field")
	public CurrentLabsPage enterCO2Level(String co2LevelVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPCO2LEVEL, co2LevelVal);
		return this;
	}

	@Step("Entered {0} in the KTV text field")
	public CurrentLabsPage enterKTV(String ktvVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPKTV, ktvVal);
		return this;
	}

	@Step("Entered {0} in the POTASSIUM text field")
	public CurrentLabsPage enterPotassium(String potassiumVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPPOTASSIUM, potassiumVal);
		return this;
	}

	@Step("Entered {0} in the HEPATITIS B TITER text field")
	public CurrentLabsPage enterHepatitisBTiter(String hepatitisBTiterVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPHEPATITISBTITER, hepatitisBTiterVal);
		return this;
	}

	@Step("Entered {0} in the TSAT text field")
	public CurrentLabsPage enterTSAT(String tsatVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPTSAT, tsatVal);
		return this;
	}

	@Step("Entered {0} in the BLOOD PRESSURE DIASTOLIC text field")
	public CurrentLabsPage enterBloodPressureDiastolic(String bloodPressureDiastolicVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPBLOODPRESUREDIASTOLIC, bloodPressureDiastolicVal);
		return this;
	}

	@Step("Entered {0} in the WEIGHT text field")
	public CurrentLabsPage enterWeight(String weightVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPWEIGHT, weightVal);
		return this;
	}

	@Step("Entered {0} in the CALCIUM X PHOSPHOROUS text field")
	public CurrentLabsPage enterCalciumXPhosphorous(String calciumXPhosphorousVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPCALCIUMXPHOSPHOROUS, calciumXPhosphorousVal);
		return this;
	}
	
	@Step("Entered {0} in the CREATININE text field")
	public CurrentLabsPage enterCreatinineString(String creatinineVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPCREATININE, creatinineVal);
		return this;
	}

	@Step("Entered {0} in the HGB A1C text field")
	public CurrentLabsPage enterHGBA1C(String hgba1cVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPHGBA1C, hgba1cVal);
		return this;
	}

	@Step("Entered {0} in the HGB text field")
	public CurrentLabsPage enterHGB(String hgbVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPHGB, hgbVal);
		return this;
	}

	@Step("Entered {0} in the URINE ALBUMIN/CREATININE RATIO text field")
	public CurrentLabsPage enterUrineAlbuminCreatinineRatio(String urineAlbuminCreatinineRatioVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPURINEALBUMINCREATININERATIO, urineAlbuminCreatinineRatioVal);
		return this;
	}

	@Step("Entered {0} in the CALCIUM text field")
	public CurrentLabsPage enterCalcium(String calciumVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPCALCIUM, calciumVal);
		return this;
	}

	@Step("Entered {0} in the URR text field")
	public CurrentLabsPage enterURR(String urrVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPURR, urrVal);
		return this;
	}

	@Step("Entered {0} in the PTH text field")
	public CurrentLabsPage enterPTH(String pthVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPPTH, pthVal);
		return this;
	}

	@Step("Entered {0} in the FERRITIN text field")
	public CurrentLabsPage enterFerritin(String ferritinVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPFERRITIN, ferritinVal);
		return this;
	}

	@Step("Entered {0} in the BLOOD PRESSURE SYSTOLIC text field")
	public CurrentLabsPage enterBloodPressureSystolic(String bloodPressureSystolicVal) throws TimeoutException, WaitException
	{
		webActions.enterText(VISIBILITY, TXT_ADDPOPUPBLOODPRESURESYSTOLIC, bloodPressureSystolicVal);
		return this;
	}

	@Step("Entered {0} in the DIPSTICK FOR PROTEIN combo box")
	public CurrentLabsPage enterDipstickForProtein(String dipstickForProteinVal) throws TimeoutException, WaitException
	{
		webActions.selectFromDropDown(CLICKABILITY, CBO_ADDPOPUPDIPSTICKFORPROTEIN, dipstickForProteinVal);
		return this;
	}
}