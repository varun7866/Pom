package com.vh.ui.pages;

import static com.vh.ui.web.locators.CurrentLabsLocators.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
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
		webActions.click(VISIBILITY, BTN_ADDLAB);
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

		currentDayMinusXDay = appFunctions.adjustCurrentDateBy(Integer.toString(dayChangeBy), "d");
		currentDayMinusXDayGregorian = appFunctions.adjustCurrentDateBy(Integer.toString(dayChangeBy), "MM/dd/YYYY");

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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPHOSPHOROUSGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPGFRGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPLDLGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPALBUMINGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCO2LEVELGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPKTVGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPOTASSIUMGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPHEPATITISBTITERGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPTSATGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPBLOODPRESUREDIASTOLICGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCALCIUMXPHOSPHOROUSGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCREATININEGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPHGBA1CGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPHGBGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPURINEALBUMINCREATININERATIOGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCALCIUM1GOAL);
	}

	@Step("Verify the visibility of the Add Lab Results popup CALCIUM goal 2")
	public boolean viewAddpopupCalciumGoal2() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPCALCIUM2GOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPURRGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPTH1GOAL);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 2")
	public boolean viewAddpopupPTHGoal2() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPTH2GOAL);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 3")
	public boolean viewAddpopupPTHGoal3() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPTH3GOAL);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 4")
	public boolean viewAddpopupPTHGoal4() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPTH4GOAL);
	}

	@Step("Verify the visibility of the Add Lab Results popup PTH goal 5")
	public boolean viewAddpopupPTHGoal5() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPPTH5GOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPFERRITINGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPBLOODPRESURESYSTOLICGOAL);
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
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPDIPSTICKFORPROTEINGOAL);
	}

	@Step("Populate all fields on the Add Lab Results popup for a CKD Patient")
	public void populateAddPopupAllCKD(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		webActions.click(VISIBILITY, BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES);

		String drawDateDay = appFunctions.adjustCurrentDateBy(map.get("APPLYTHISDATETOALLVALUES"), "d");

		appFunctions.selectDateFromCalendar(CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES, drawDateDay);

		if (map.get("HEIGHT") != null)
		{
			enterHeight(map.get("HEIGHT"));
		}

		if (map.get("WEIGHT") != null)
		{
			enterWeight(map.get("WEIGHT"));
		}

		if (map.get("TARGETDRYWEIGHT") != null)
		{
			enterTargetDryWeight(map.get("TARGETDRYWEIGHT"));
		}

		if (map.get("CALCIUMXPHOSPHOROUS") != null)
		{
			enterCalciumXPhosphorous(map.get("CALCIUMXPHOSPHOROUS"));
		}

		if (map.get("PHOSPHOROUS") != null)
		{
			enterPhosphorous(map.get("PHOSPHOROUS"));
		}

		if (map.get("CREATININE") != null)
		{
			enterCreatinine(map.get("CREATININE"));
		}

		if (map.get("GFR") != null)
		{
			enterGFR(map.get("GFR"));
		}

		if (map.get("HGBA1C") != null)
		{
			enterHGBA1C(map.get("HGBA1C"));
		}

		if (map.get("LDL") != null)
		{
			enterLDL(map.get("LDL"));
		}

		if (map.get("HGB") != null)
		{
			enterHGB(map.get("HGB"));
		}

		if (map.get("ALBUMIN") != null)
		{
			enterAlbumin(map.get("ALBUMIN"));
		}

		if (map.get("URINEALBUMINCREATININERATIO") != null)
		{
			enterUrineAlbuminCreatinineRatio(map.get("URINEALBUMINCREATININERATIO"));
		}

		if (map.get("DIPSTICKFORPROTEIN") != null)
		{
			enterDipstickForProtein(map.get("DIPSTICKFORPROTEIN"));
		}

		if (map.get("CO2LEVEL") != null)
		{
			enterCO2Level(map.get("CO2LEVEL"));
		}

		if (map.get("CALCIUM") != null)
		{
			enterCalcium(map.get("CALCIUM"));
		}

		if (map.get("KTV") != null)
		{
			enterKTV(map.get("KTV"));
		}

		if (map.get("URR") != null)
		{
			enterURR(map.get("URR"));
		}

		if (map.get("POTASIUM") != null)
		{
			enterPotassium(map.get("POTASIUM"));
		}

		if (map.get("PTH") != null)
		{
			enterPTH(map.get("PTH"));
		}

		if (map.get("HEPATITISBTITER") != null)
		{
			enterHepatitisBTiter(map.get("HEPATITISBTITER"));
		}

		if (map.get("FERRITIN") != null)
		{
			enterFerritin(map.get("FERRITIN"));
		}

		if (map.get("TSAT") != null)
		{
			enterTSAT(map.get("TSAT"));
		}

		if (map.get("BLOODPRESSURESYSTOLIC") != null)
		{
			enterBloodPressureSystolic(map.get("BLOODPRESSURESYSTOLIC"));
		}

		if (map.get("BLOODPRESSUREDIASTOLIC") != null)
		{
			enterBloodPressureDiastolic(map.get("BLOODPRESSUREDIASTOLIC"));
		}
	}

	@Step("Populate all fields on the Add Lab Results popup for an ESRD Patient")
	public void populateAddPopupAllESRD(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		webActions.click(VISIBILITY, BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES);

		String drawDateDay = appFunctions.adjustCurrentDateBy(map.get("APPLYTHISDATETOALLVALUES"), "d");

		appFunctions.selectDateFromCalendar(CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES, drawDateDay);

		if (map.get("HEIGHT") != null)
		{
			enterHeight(map.get("HEIGHT"));
		}

		if (map.get("WEIGHT") != null)
		{
			enterWeight(map.get("WEIGHT"));
		}

		if (map.get("TARGETDRYWEIGHT") != null)
		{
			enterTargetDryWeight(map.get("TARGETDRYWEIGHT"));
		}

		if (map.get("CALCIUMXPHOSPHOROUS") != null)
		{
			enterCalciumXPhosphorous(map.get("CALCIUMXPHOSPHOROUS"));
		}

		if (map.get("PHOSPHOROUS") != null)
		{
			enterPhosphorous(map.get("PHOSPHOROUS"));
		}

		if (map.get("CREATININE") != null)
		{
			enterCreatinine(map.get("CREATININE"));
		}

		if (map.get("GFR") != null)
		{
			enterGFR(map.get("GFR"));
		}

		if (map.get("HGBA1C") != null)
		{
			enterHGBA1C(map.get("HGBA1C"));
		}

		if (map.get("LDL") != null)
		{
			enterLDL(map.get("LDL"));
		}

		if (map.get("HGB") != null)
		{
			enterHGB(map.get("HGB"));
		}

		if (map.get("ALBUMIN") != null)
		{
			enterAlbumin(map.get("ALBUMIN"));
		}

		if (map.get("URINEALBUMINCREATININERATIO") != null)
		{
			enterUrineAlbuminCreatinineRatio(map.get("URINEALBUMINCREATININERATIO"));
		}

		if (map.get("CO2LEVEL") != null)
		{
			enterCO2Level(map.get("CO2LEVEL"));
		}

		if (map.get("CALCIUM") != null)
		{
			enterCalcium(map.get("CALCIUM"));
		}

		if (map.get("KTV") != null)
		{
			enterKTV(map.get("KTV"));
		}

		if (map.get("URR") != null)
		{
			enterURR(map.get("URR"));
		}

		if (map.get("POTASIUM") != null)
		{
			enterPotassium(map.get("POTASIUM"));
		}

		if (map.get("PTH") != null)
		{
			enterPTH(map.get("PTH"));
		}

		if (map.get("HEPATITISBTITER") != null)
		{
			enterHepatitisBTiter(map.get("HEPATITISBTITER"));
		}

		if (map.get("FERRITIN") != null)
		{
			enterFerritin(map.get("FERRITIN"));
		}

		if (map.get("TSAT") != null)
		{
			enterTSAT(map.get("TSAT"));
		}

		if (map.get("BLOODPRESSURESYSTOLIC") != null)
		{
			enterBloodPressureSystolic(map.get("BLOODPRESSURESYSTOLIC"));
		}

		if (map.get("BLOODPRESSUREDIASTOLIC") != null)
		{
			enterBloodPressureDiastolic(map.get("BLOODPRESSUREDIASTOLIC"));
		}
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
	public CurrentLabsPage enterCreatinine(String creatinineVal) throws TimeoutException, WaitException
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

	@Step("Verify the visibility of the Add Lab Results popup KT/VD error message")
	public boolean viewAddpopupKTVErrorMessage() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPKTVERRORMESSAGE);
	}

	@Step("Verify the visibility of the Add Lab Results popup URR error message")
	public boolean viewAddpopupURRErrorMessage() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPURRERRORMESSAGE);
	}

	@Step("Verify the visibility of the Add Lab Results popup Urine Albumin Creatinine Ratio error message")
	public boolean viewAddpopupUrineAlbuminCreatinineRatioErrorMessage() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ADDPOPUPURINEALBUMINCREATININERATIOERRORMESSAGE);
	}

	@Step("clear the KTV text box")
	public void clearKTVTextBox() throws TimeoutException, WaitException
	{
		webActions.pressKey(VISIBILITY, TXT_ADDPOPUPKTV, Keys.BACK_SPACE);
		webActions.pressKey(VISIBILITY, TXT_ADDPOPUPKTV, Keys.BACK_SPACE);
		webActions.pressKey(VISIBILITY, TXT_ADDPOPUPKTV, Keys.BACK_SPACE);
	}

	@Step("clear the URR text box")
	public void clearURRTextBox() throws TimeoutException, WaitException
	{
		webActions.pressKey(VISIBILITY, TXT_ADDPOPUPURR, Keys.BACK_SPACE);
		webActions.pressKey(VISIBILITY, TXT_ADDPOPUPURR, Keys.BACK_SPACE);
	}

	@Step("clear the Urine Albumin Creatinine Ratio text box")
	public void clearUrineAlbuminCreatinineRatioTextBox() throws TimeoutException, WaitException
	{
		webActions.pressKey(VISIBILITY, TXT_ADDPOPUPURINEALBUMINCREATININERATIO, Keys.BACK_SPACE);
		webActions.pressKey(VISIBILITY, TXT_ADDPOPUPURINEALBUMINCREATININERATIO, Keys.BACK_SPACE);
	}

	@Step("Verify the visibility of the HEIGHT label/value")
	public boolean viewHeightLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_HEIGHT = By.xpath("//span[text()='Height (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HEIGHT);
	}

	@Step("Verify the visibility of the HEIGHT draw date")
	public boolean viewHeightDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_HEIGHTDRAWDATE = By.xpath("//span[contains(., 'Height (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HEIGHTDRAWDATE);
	}

	@Step("Verify the visibility of the HEIGHT Source")
	public boolean viewHeightSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HEIGHTSOURCE);
	}

	@Step("Verify the color of the HEIGHT label/value")
	public boolean viewHeightColor() throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_HEIGHTCOLOR, "class");

		if (classAttributeValue.contains("greentext"))
		{
			return true;
		} else
		{
			return false;
		}
	}

	@Step("Verify the visibility of the WEIGHT label/value")
	public boolean viewWeightLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_WEIGHT = By.xpath("//span[text()='Weight (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_WEIGHT);
	}

	@Step("Verify the visibility of the WEIGHT draw date")
	public boolean viewWeightDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_WEIGHTDRAWDATE = By.xpath("//span[contains(., 'Weight (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_WEIGHTDRAWDATE);
	}

	@Step("Verify the visibility of the WEIGHT Source")
	public boolean viewWeightSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_WEIGHTSOURCE);
	}

	@Step("Verify the color of the WEIGHT label/value")
	public boolean viewWeightColor() throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_WEIGHTCOLOR, "class");

		if (classAttributeValue.contains("greentext"))
		{
			return true;
		} else
		{
			return false;
		}
	}

	@Step("Verify the visibility of the TARGET DRY WEIGHT label/value")
	public boolean viewTargetDryWeightLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_TARGETDRYWEIGHT = By.xpath("//span[text()='Target Dry Weight (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_TARGETDRYWEIGHT);
	}

	@Step("Verify the visibility of the TARGET DRY WEIGHT draw date")
	public boolean viewTargetDryWeightDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_TARGETDRYWEIGHTDRAWDATE = By.xpath("//span[contains(., 'Target Dry Weight (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_TARGETDRYWEIGHTDRAWDATE);
	}

	@Step("Verify the visibility of the TARGET DRY WEIGHT Source")
	public boolean viewTargetDryWeightSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_TARGETDRYWEIGHTSOURCE);
	}

	@Step("Verify the color of the TARGET DRY WEIGHT label/value")
	public boolean viewTargetDryWeightColor() throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_TARGETDRYWEIGHTCOLOR, "class");

		if (classAttributeValue.contains("greentext"))
		{
			return true;
		} else
		{
			return false;
		}
	}

	@Step("Verify the visibility of the CALCIUM X PHOSPHOROUS label/value")
	public boolean viewCalciumXPhosphorousLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_CALCIUMXPHOSPHOROUS = By.xpath("//span[text()='Calcium X Phosphorous (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUMXPHOSPHOROUS);
	}

	@Step("Verify the visibility of the CALCIUM X PHOSPHOROUS Goal")
	public boolean viewCalciumXPhosphorousGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUMXPHOSPHOROUSGOAL);
	}

	@Step("Verify the visibility of the CALCIUM X PHOSPHOROUS draw date")
	public boolean viewCalciumXPhosphorousDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_CALCIUMXPHOSPHOROUSDRAWDATE = By.xpath("//span[contains(., 'Calcium X Phosphorous (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUMXPHOSPHOROUSDRAWDATE);
	}

	@Step("Verify the visibility of the CALCIUM X PHOSPHOROUS Source")
	public boolean viewCalciumXPhosphorousSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUMXPHOSPHOROUSSOURCE);
	}

	@Step("Verify the color of the CALCIUM X PHOSPHOROUS label/value")
	public boolean viewCalciumXPhosphorousColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_CALCIUMXPHOSPHOROUSCOLOR, "class");

		if (labValue < 30 || labValue > 60) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
		else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the PHOSPHOROUS label/value")
	public boolean viewPhosphorousLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_PHOSPHOROUS = By.xpath("//span[text()='Phosphorous (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PHOSPHOROUS);
	}

	@Step("Verify the visibility of the PHOSPHOROUS Goal")
	public boolean viewPhosphorousGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PHOSPHOROUSGOAL);
	}

	@Step("Verify the visibility of the PHOSPHOROUS draw date")
	public boolean viewPhosphorousDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_PHOSPHOROUSDRAWDATE = By.xpath("//span[contains(., 'Phosphorous (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PHOSPHOROUSDRAWDATE);
	}

	@Step("Verify the visibility of the PHOSPHOROUS Source")
	public boolean viewPhosphorousSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PHOSPHOROUSSOURCE);
	}

	@Step("Verify the color of the PHOSPHOROUS label/value")
	public boolean viewPhosphorousColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_PHOSPHOROUSCOLOR, "class");

		if (labValue < .5 || labValue > 5.5) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the CREATININE label/value")
	public boolean viewCreatinineLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_CREATININE = By.xpath("//span[text()='Creatinine (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CREATININE);
	}

	@Step("Verify the visibility of the CREATININE Goal")
	public boolean viewCreatinineGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CREATININEGOAL);
	}

	@Step("Verify the visibility of the CREATININE draw date")
	public boolean viewCreatinineDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_CREATININEDRAWDATE = By.xpath("//span[contains(., 'Creatinine (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CREATININEDRAWDATE);
	}

	@Step("Verify the visibility of the CREATININE Source")
	public boolean viewCreatinineSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CREATININESOURCE);
	}

	@Step("Verify the color of the CREATININE label/value")
	public boolean viewCreatinineColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_CREATININECOLOR, "class");

		if (labValue < .5 || labValue > 1.5) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the GFR label/value")
	public boolean viewGFRLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_GFR = By.xpath("//span[text()='GFR (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_GFR);
	}

	@Step("Verify the visibility of the GFR Goal")
	public boolean viewGFRGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_GFRGOAL);
	}

	@Step("Verify the visibility of the GFR draw date")
	public boolean viewGFRDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_GFRDRAWDATE = By.xpath("//span[contains(., 'GFR (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_GFRDRAWDATE);
	}

	@Step("Verify the visibility of the GFR Source")
	public boolean viewGFRSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_GFRSOURCE);
	}

	@Step("Verify the color of the GFR label/value")
	public boolean viewGFRColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_GFRCOLOR, "class");

		if (labValue < 30 || labValue > 125) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the HGBA1C label/value")
	public boolean viewHGBA1CLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_HGBA1C = By.xpath("//span[text()='Hgb A1C (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HGBA1C);
	}

	@Step("Verify the visibility of the HGBA1C Goal")
	public boolean viewHGBA1CGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HGBA1CGOAL);
	}

	@Step("Verify the visibility of the HGBA1C draw date")
	public boolean viewHGBA1CDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_HGBA1CDRAWDATE = By.xpath("//span[contains(., 'Hgb A1C (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HGBA1CDRAWDATE);
	}

	@Step("Verify the visibility of the HGBA1C Source")
	public boolean viewHGBA1CSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HGBA1CSOURCE);
	}

	@Step("Verify the color of the HGBA1C label/value")
	public boolean viewHGBA1CColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_HGBA1CCOLOR, "class");

		if (labValue < 3 || labValue > 8) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the LDL label/value")
	public boolean viewLDLLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_LDL = By.xpath("//span[text()='LDL (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_LDL);
	}

	@Step("Verify the visibility of the LDL Goal")
	public boolean viewLDLGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_LDLGOAL);
	}

	@Step("Verify the visibility of the LDL draw date")
	public boolean viewLDLDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_LDLDRAWDATE = By.xpath("//span[contains(., 'LDL (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_LDLDRAWDATE);
	}

	@Step("Verify the visibility of the LDL Source")
	public boolean viewLDLSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_LDLSOURCE);
	}

	@Step("Verify the color of the LDL label/value")
	public boolean viewLDLColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_LDLCOLOR, "class");

		if (labValue < 0 || labValue > 100) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the HGB label/value")
	public boolean viewHGBLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_HGB = By.xpath("//span[text()='Hgb (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HGB);
	}

	@Step("Verify the visibility of the HGB Goal")
	public boolean viewHGBGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HGBGOAL);
	}

	@Step("Verify the visibility of the HGB draw date")
	public boolean viewHGBDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_HGBDRAWDATE = By.xpath("//span[contains(., 'Hgb (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HGBDRAWDATE);
	}

	@Step("Verify the visibility of the HGB Source")
	public boolean viewHGBSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HGBSOURCE);
	}

	@Step("Verify the color of the HGB label/value")
	public boolean viewHGBColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_HGBCOLOR, "class");

		if (labValue < 0 || labValue > 11) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the ALBUMIN label/value")
	public boolean viewAlbuminLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_ALBUMIN = By.xpath("//span[text()='Albumin (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ALBUMIN);
	}

	@Step("Verify the visibility of the ALBUMIN Goal")
	public boolean viewAlbuminGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ALBUMINGOAL);
	}

	@Step("Verify the visibility of the ALBUMIN draw date")
	public boolean viewAlbuminDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_ALBUMINDRAWDATE = By.xpath("//span[contains(., 'Albumin (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ALBUMINDRAWDATE);
	}

	@Step("Verify the visibility of the ALBUMIN Source")
	public boolean viewAlbuminSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_ALBUMINSOURCE);
	}

	@Step("Verify the color of the ALBUMIN label/value")
	public boolean viewAlbuminColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_ALBUMINCOLOR, "class");

		if (labValue < 4 || labValue > 7) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the URINE ALBUMIN/CREATININE RATIO label/value")
	public boolean viewUrineAlbuminCreatinineRatioLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_URINEALBUMINCREATININERATIO = By.xpath("//span[text()='Urine Albumin/Creatinine Ratio (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_URINEALBUMINCREATININERATIO);
	}

	@Step("Verify the visibility of the URINE ALBUMIN/CREATININE RATIO Goal")
	public boolean viewUrineAlbuminCreatinineRatioGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_URINEALBUMINCREATININERATIOGOAL);
	}

	@Step("Verify the visibility of the URINE ALBUMIN/CREATININE RATIO draw date")
	public boolean viewUrineAlbuminCreatinineRatioDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_URINEALBUMINCREATININERATIODRAWDATE = By.xpath("//span[contains(., 'Urine Albumin/Creatinine Ratio (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_URINEALBUMINCREATININERATIODRAWDATE);
	}

	@Step("Verify the visibility of the URINE ALBUMIN/CREATININE RATIO Source")
	public boolean viewUrineAlbuminCreatinineRatioSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_URINEALBUMINCREATININERATIOSOURCE);
	}

	@Step("Verify the color of the ALBUMIN label/value")
	public boolean viewUrineAlbuminCreatinineRatioColor(int labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_URINEALBUMINCREATININERATIOCOLOR, "class");

		if (labValue < 0 || labValue > 30) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the DIPSTICK FOR PROTEIN label/value")
	public boolean viewDipstickForProteinLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_DIPSTICKFORPROTEIN = By.xpath("//span[text()='Dipstick For Protein (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DIPSTICKFORPROTEIN);
	}

	@Step("Verify the visibility of the DIPSTICK FOR PROTEIN Goal")
	public boolean viewDipstickForProteinGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DIPSTICKFORPROTEINGOAL);
	}

	@Step("Verify the visibility of the DIPSTICK FOR PROTEIN draw date")
	public boolean viewDipstickForProteinDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_DIPSTICKFORPROTEINDRAWDATE = By.xpath("//span[contains(., 'Dipstick For Protein (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DIPSTICKFORPROTEINDRAWDATE);
	}

	@Step("Verify the visibility of the DIPSTICK FOR PROTEIN Source")
	public boolean viewDipstickForProteinSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_DIPSTICKFORPROTEINSOURCE);
	}

	@Step("Verify the color of the DIPSTICK FOR PROTEIN label/value")
	public boolean viewDipstickForProteinColor(String labValue) throws TimeoutException, WaitException
	{
		String classAttributeValue = webActions.getAttributeValue(VISIBILITY, LBL_DIPSTICKFORPROTEINCOLOR, "class");

		if (labValue.equals("Positive")) // If out of range
		{
			if (classAttributeValue.contains("redtext"))
			{
				return true;
			} else
			{
				return false;
			}
		} else // In range
		{
			if (classAttributeValue.contains("greentext"))
			{
				return true;
			} else
			{
				return false;
			}
		}
	}

	@Step("Verify the visibility of the CO2 LEVEL label/value")
	public boolean viewCO2LevelLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_CO2LEVEL = By.xpath("//span[text()='Co2 Level (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CO2LEVEL);
	}

	@Step("Verify the visibility of the CO2 LEVEL Goal")
	public boolean viewCO2LevelGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CO2LEVELGOAL);
	}

	@Step("Verify the visibility of the CO2 LEVEL draw date")
	public boolean viewCO2LevelDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_CO2LEVELDRAWDATE = By.xpath("//span[contains(., 'Co2 Level (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CO2LEVELDRAWDATE);
	}

	@Step("Verify the visibility of the CO2 LEVEL Source")
	public boolean viewCO2LevelSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CO2LEVELSOURCE);
	}

	@Step("Verify the visibility of the CALCIUM label/value")
	public boolean viewCalciumLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_CALCIUM = By.xpath("//span[text()='Calcium (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUM);
	}

	@Step("Verify the visibility of the CALCIUM Goal1")
	public boolean viewCalciumGoal1() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUMGOAL1);
	}

	@Step("Verify the visibility of the CALCIUM Goal2")
	public boolean viewCalciumGoal2() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUMGOAL2);
	}

	@Step("Verify the visibility of the CALCIUM draw date")
	public boolean viewCalciumDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_CALCIUMDRAWDATE = By.xpath("//span[contains(., 'Calcium (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUMDRAWDATE);
	}

	@Step("Verify the visibility of the CALCIUM Source")
	public boolean viewCalciumSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_CALCIUMSOURCE);
	}

	@Step("Verify the visibility of the KT/V label/value")
	public boolean viewKTVLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_KTV = By.xpath("//span[text()='KT/V (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_KTV);
	}

	@Step("Verify the visibility of the KT/V Goal")
	public boolean viewKTVGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_KTVGOAL);
	}

	@Step("Verify the visibility of the KT/V draw date")
	public boolean viewKTVDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_KTVDRAWDATE = By.xpath("//span[contains(., 'KT/V (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_KTVDRAWDATE);
	}

	@Step("Verify the visibility of the KT/V Source")
	public boolean viewKTVSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_KTVSOURCE);
	}

	@Step("Verify the visibility of the URR label/value")
	public boolean viewURRLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_URR = By.xpath("//span[text()='URR (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_URR);
	}

	@Step("Verify the visibility of the URR Goal")
	public boolean viewURRGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_URRGOAL);
	}

	@Step("Verify the visibility of the URR draw date")
	public boolean viewURRDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_URRDRAWDATE = By.xpath("//span[contains(., 'URR (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_URRDRAWDATE);
	}

	@Step("Verify the visibility of the URR Source")
	public boolean viewURRSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_URRSOURCE);
	}

	@Step("Verify the visibility of the POTASIUM label/value")
	public boolean viewPotassiumLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_POTASIUM = By.xpath("//span[text()='Potassium (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_POTASIUM);
	}

	@Step("Verify the visibility of the POTASIUM Goal")
	public boolean viewPotassiumGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_POTASIUMGOAL);
	}

	@Step("Verify the visibility of the POTASIUM draw date")
	public boolean viewPotassiumDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_POTASIUMDRAWDATE = By.xpath("//span[contains(., 'Potassium (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_POTASIUMDRAWDATE);
	}

	@Step("Verify the visibility of the POTASIUM Source")
	public boolean viewPotassiumSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_POTASIUMSOURCE);
	}

	@Step("Verify the visibility of the PTH label/value")
	public boolean viewPTHLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_PTH = By.xpath("//span[text()='PTH (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PTH);
	}

	@Step("Verify the visibility of the PTH Goal1")
	public boolean viewPTHGoal1() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PTHGOAL1);
	}

	@Step("Verify the visibility of the PTH Goal2")
	public boolean viewPTHGoal2() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PTHGOAL2);
	}

	@Step("Verify the visibility of the PTH Goal3")
	public boolean viewPTHGoal3() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PTHGOAL3);
	}

	@Step("Verify the visibility of the PTH Goal4")
	public boolean viewPTHGoal4() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PTHGOAL4);
	}

	@Step("Verify the visibility of the PTH Goal5")
	public boolean viewPTHGoal5() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PTHGOAL5);
	}

	@Step("Verify the visibility of the PTH draw date")
	public boolean viewPTHDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_PTHDRAWDATE = By.xpath("//span[contains(., 'PTH (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PTHDRAWDATE);
	}

	@Step("Verify the visibility of the PTH Source")
	public boolean viewPTHSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_PTHSOURCE);
	}

	@Step("Verify the visibility of the HEPATITIS B TITER label/value")
	public boolean viewHepatitisBTiterLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_HEPATITISBTITER = By.xpath("//span[text()='Hepatitis B Titer (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HEPATITISBTITER);
	}

	@Step("Verify the visibility of the HEPATITIS B TITER Goal")
	public boolean viewHepatitisBTiterGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HEPATITISBTITERGOAL);
	}

	@Step("Verify the visibility of the HEPATITIS B TITER draw date")
	public boolean viewHepatitisBTiterDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_HEPATITISBTITERDRAWDATE = By.xpath("//span[contains(., 'Hepatitis B Titer (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HEPATITISBTITERDRAWDATE);
	}

	@Step("Verify the visibility of the HEPATITIS B TITER Source")
	public boolean viewHepatitisBTiterSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_HEPATITISBTITERSOURCE);
	}

	@Step("Verify the visibility of the FERRITIN label/value")
	public boolean viewFerritinLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_FERRITIN = By.xpath("//span[text()='Ferritin (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_FERRITIN);
	}

	@Step("Verify the visibility of the FERRITIN Goal")
	public boolean viewFerritinGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_FERRITINGOAL);
	}

	@Step("Verify the visibility of the FERRITIN draw date")
	public boolean viewFerritinDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_FERRITINDRAWDATE = By.xpath("//span[contains(., 'Ferritin (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_FERRITINDRAWDATE);
	}

	@Step("Verify the visibility of the FERRITIN Source")
	public boolean viewFerritinSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_FERRITINSOURCE);
	}

	@Step("Verify the visibility of the TSAT label/value")
	public boolean viewTSATLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_TSAT = By.xpath("//span[text()='TSAT (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_TSAT);
	}

	@Step("Verify the visibility of the TSAT Goal")
	public boolean viewTSATGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_TSATGOAL);
	}

	@Step("Verify the visibility of the TSAT draw date")
	public boolean viewTSATDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_TSATDRAWDATE = By.xpath("//span[contains(., 'TSAT (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_TSATDRAWDATE);
	}

	@Step("Verify the visibility of the TSAT Source")
	public boolean viewTSATSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_TSATSOURCE);
	}

	@Step("Verify the visibility of the BLOOD PRESSURE SYSTOLIC label/value")
	public boolean viewBloodPressureSystolicLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_BLOODPRESSURESYSTOLIC = By.xpath("//span[text()='Blood Pressure Systolic (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_BLOODPRESSURESYSTOLIC);
	}

	@Step("Verify the visibility of the BLOOD PRESSURE SYSTOLIC Goal")
	public boolean viewBloodPressureSystolicGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_BLOODPRESSURESYSTOLICGOAL);
	}

	@Step("Verify the visibility of the BLOOD PRESSURE SYSTOLIC draw date")
	public boolean viewBloodPressureSystolicDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_BLOODPRESSURESYSTOLICDRAWDATE = By.xpath("//span[contains(., 'Blood Pressure Systolic (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_BLOODPRESSURESYSTOLICDRAWDATE);
	}

	@Step("Verify the visibility of the BLOOD PRESSURE SYSTOLIC Source")
	public boolean viewBloodPressureSystolicSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_BLOODPRESSURESYSTOLICSOURCE);
	}

	@Step("Verify the visibility of the BLOOD PRESSURE SYSTOLIC label/value")
	public boolean viewBloodPressureDiastolicLabelValue(String labValue) throws TimeoutException, WaitException
	{
		final By LBL_BLOODPRESSUREDIASTOLIC = By.xpath("//span[text()='Blood Pressure Diastolic (" + labValue + ")']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_BLOODPRESSUREDIASTOLIC);
	}

	@Step("Verify the visibility of the BLOOD PRESSURE SYSTOLIC Goal")
	public boolean viewBloodPressureDiastolicGoal() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_BLOODPRESSUREDIASTOLICGOAL);
	}

	@Step("Verify the visibility of the BLOOD PRESSURE SYSTOLIC draw date")
	public boolean viewBloodPressureDiastolicDrawDate(String drawDate) throws TimeoutException, WaitException
	{
		final By LBL_BLOODPRESSUREDIASTOLICDRAWDATE = By.xpath("//span[contains(., 'Blood Pressure Diastolic (')]/../../..//span[text()='" + drawDate + "']");

		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_BLOODPRESSUREDIASTOLICDRAWDATE);
	}

	@Step("Verify the visibility of the BLOOD PRESSURE SYSTOLIC Source")
	public boolean viewBloodPressureDiastolicSource() throws TimeoutException, WaitException
	{
		return webActions.getVisibiltyOfElementLocatedBy(VISIBILITY, LBL_BLOODPRESSUREDIASTOLICSOURCE);
	}
}