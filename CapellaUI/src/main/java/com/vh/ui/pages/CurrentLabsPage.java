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

		enterHeight(map.get("HEIGHT")).enterWeight(map.get("WEIGHT")).enterTargetDryWeight(map.get("TARGETDRYWEIGHT")).enterCalciumXPhosphorous(map.get("CALCIUMXPHOSPHOROUS"))
		        .enterPhosphorous(map.get("PHOSPHOROUS")).enterCreatinineString(map.get("CREATININE")).enterGFR(map.get("GFR")).enterHGBA1C(map.get("HGBA1C")).enterLDL(map.get("LDL"))
		        .enterHGB(map.get("HGB")).enterAlbumin(map.get("ALBUMIN")).enterUrineAlbuminCreatinineRatio(map.get("URINEALBUMINCREATININERATIO"))
		        .enterDipstickForProtein(map.get("DIPSTICKFORPROTEIN")).enterCO2Level(map.get("CO2LEVEL")).enterCalcium(map.get("CALCIUM")).enterKTV(map.get("KTV")).enterURR(map.get("URR"))
		        .enterPotassium(map.get("POTASIUM")).enterPTH(map.get("PTH")).enterHepatitisBTiter(map.get("HEPATITISBTITER")).enterFerritin(map.get("FERRITIN")).enterTSAT(map.get("TSAT"))
		        .enterBloodPressureSystolic(map.get("BLOODPRESSURESYSTOLIC")).enterBloodPressureDiastolic(map.get("BLOODPRESSUREDIASTOLIC"));
	}

	@Step("Populate all fields on the Add Lab Results popup for an ESRD Patient")
	public void populateAddPopupAllESRD(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException
	{
		webActions.click(VISIBILITY, BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES);

		String drawDateDay = appFunctions.adjustCurrentDateBy(map.get("APPLYTHISDATETOALLVALUES"), "d");

		appFunctions.selectDateFromCalendar(CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES, drawDateDay);

		enterHeight(map.get("HEIGHT")).enterWeight(map.get("WEIGHT")).enterTargetDryWeight(map.get("TARGETDRYWEIGHT")).enterCalciumXPhosphorous(map.get("CALCIUMXPHOSPHOROUS"))
		        .enterPhosphorous(map.get("PHOSPHOROUS")).enterCreatinineString(map.get("CREATININE")).enterGFR(map.get("GFR")).enterHGBA1C(map.get("HGBA1C")).enterLDL(map.get("LDL"))
		        .enterHGB(map.get("HGB")).enterAlbumin(map.get("ALBUMIN")).enterUrineAlbuminCreatinineRatio(map.get("URINEALBUMINCREATININERATIO")).enterCO2Level(map.get("CO2LEVEL"))
		        .enterCalcium(map.get("CALCIUM")).enterKTV(map.get("KTV")).enterURR(map.get("URR")).enterPotassium(map.get("POTASIUM")).enterPTH(map.get("PTH"))
		        .enterHepatitisBTiter(map.get("HEPATITISBTITER")).enterFerritin(map.get("FERRITIN")).enterTSAT(map.get("TSAT")).enterBloodPressureSystolic(map.get("BLOODPRESSURESYSTOLIC"))
		        .enterBloodPressureDiastolic(map.get("BLOODPRESSUREDIASTOLIC"));
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
}