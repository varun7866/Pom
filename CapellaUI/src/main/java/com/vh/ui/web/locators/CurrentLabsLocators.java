/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   June 14, 2017
 * @class  CurrentLabsLocators.java
 */

public class CurrentLabsLocators
{
	public static final By BTN_ADDLAB = By.xpath("//button//span[text()='Add Lab']");
	public static final By BTN_ADDPOPUPCANCEL = By.xpath("//button//span[text()='Cancel']");
	public static final By BTN_ADDPOPUPSAVE = By.xpath("//button//span[text()='Save']");
	public static final By BTN_ADDPOPUPAPPLYTHISDATETOALLVALUES = By
	        .xpath("//div[@class='modal-dialog modal-lg']//span[text()='APPLY THIS DATE TO ALL VALUES']/../../..//input/..//button[@class='btnpicker btnpickerenabled']");

	public static final By CAL_ADDPOPUPAPPLYTHISDATETOALLVALUES = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='APPLY THIS DATE TO ALL VALUES']/../../..//input");

	public static final By CBO_ADDPOPUPDIPSTICKFORPROTEIN = By.xpath("//select[@id='labToAddDipstickForProteinDropdown']");

	public static final By LBL_ADDPOPUPPHOSPHOROUSGOAL = By.xpath("//span[text()='Phosphorous']/../../../div[3]/div/div/span[text()='Goal: Between 3 and 5.5']");
	public static final By LBL_ADDPOPUPGFRGOAL = By.xpath("//span[text()='GFR']/../../../div[3]/div/div/span[text()='Goal: CKD between 30 and 125']");
	public static final By LBL_ADDPOPUPLDLGOAL = By.xpath("//span[text()='LDL']/../../../div[3]/div/div/span[text()='Goal: Between 0 and 100']");
	public static final By LBL_ADDPOPUPALBUMINGOAL = By.xpath("//span[text()='Albumin']/../../../div[3]/div/div/span[text()='Goal: Between 4 and 7']");
	public static final By LBL_ADDPOPUPCO2LEVELGOAL = By.xpath("//span[text()='Co2 Level']/../../../div[3]/div/div/span[text()='Goal: Between 22 and 31']");
	public static final By LBL_ADDPOPUPKTVGOAL = By.xpath("//span[text()='KT/V']/../../../div[3]/div/div/span[text()='Goal: ESRD between 1.2 and 3']");
	public static final By LBL_ADDPOPUPPOTASSIUMGOAL = By.xpath("//span[text()='Potassium']/../../../div[3]/div/div/span[text()='Goal: Between 3.5 and 5.2']");
	public static final By LBL_ADDPOPUPHEPATITISBTITERGOAL = By.xpath("//span[text()='Hepatitis B Titer']/../../../div[3]/div/div/span[text()='Goal: Between 10 and 100']");
	public static final By LBL_ADDPOPUPTSATGOAL = By.xpath("//span[text()='TSAT']/../../../div[3]/div/div/span[text()='Goal: Between 20 and 100']");
	public static final By LBL_ADDPOPUPBLOODPRESUREDIASTOLICGOAL = By.xpath("//span[text()='Blood Pressure']/../../../div[3]/div/div/span[text()=' BPDia between 0 and 80']");
	public static final By LBL_ADDPOPUPCALCIUMXPHOSPHOROUSGOAL = By.xpath("//span[text()='Calcium X Phosphorous']/../../../div[3]/div/div/span[text()='Goal: Between 30 and 60']");
	public static final By LBL_ADDPOPUPCREATININEGOAL = By.xpath("//span[text()='Creatinine']/../../../div[3]/div/div/span[text()='Goal: Between 0.5 and 1.5']");
	public static final By LBL_ADDPOPUPHGBA1CGOAL = By.xpath("//span[text()='Hgb A1C']/../../../div[3]/div/div/span[text()='Goal: Between 3 and 8']");
	public static final By LBL_ADDPOPUPHGBGOAL = By.xpath("//span[text()='Hgb']/../../../div[3]/div/div/span[text()='Goal: Between 0 and 11']");
	public static final By LBL_ADDPOPUPURINEALBUMINCREATININERATIOGOAL = By
	        .xpath("//span[text()='Urine Albumin/Creatinine Ratio']/../../../div[3]/div/div/span[text()='Goal: CKD between 0 and 30']");
	public static final By LBL_ADDPOPUPCALCIUM1GOAL = By.xpath("//span[text()='Calcium']/../../../div[3]/div/div/span[text()='Goals: CKD between 8.6 and 10.3']");
	public static final By LBL_ADDPOPUPCALCIUM2GOAL = By.xpath("//span[text()='Calcium']/../../../div[3]/div/div/span[text()=' ESRD between 8.4 and 9.5']");
	public static final By LBL_ADDPOPUPURRGOAL = By.xpath("//span[text()='URR']/../../../div[3]/div/div/span[text()='Goal: ESRD between 65 and 99']");
	public static final By LBL_ADDPOPUPPTH1GOAL = By.xpath("//span[text()='PTH']/../../../div[3]/div/div/span[text()='Goals: CKD 1 between 0 and 9999']");
	public static final By LBL_ADDPOPUPPTH2GOAL = By.xpath("//span[text()='PTH']/../../../div[3]/div/div/span[text()=' CKD 2 between 0 and 9999']");
	public static final By LBL_ADDPOPUPPTH3GOAL = By.xpath("//span[text()='PTH']/../../../div[3]/div/div/span[text()=' CKD 3 between 35 and 70']");
	public static final By LBL_ADDPOPUPPTH4GOAL = By.xpath("//span[text()='PTH']/../../../div[3]/div/div/span[text()=' CKD 4 between 71 and 110']");
	public static final By LBL_ADDPOPUPPTH5GOAL = By.xpath("//span[text()='PTH']/../../../div[3]/div/div/span[text()=' ESRD between 150 and 600']");
	public static final By LBL_ADDPOPUPFERRITINGOAL = By.xpath("//span[text()='Ferritin']/../../../div[3]/div/div/span[text()='Goal: Between 100 and 500']");
	public static final By LBL_ADDPOPUPBLOODPRESURESYSTOLICGOAL = By.xpath("//span[text()='Blood Pressure']/../../../div[3]/div/div/span[text()='Goals: BPSys between 60 and 130']");
	public static final By LBL_ADDPOPUPDIPSTICKFORPROTEINGOAL = By.xpath("//span[text()='Dipstick For Protein']/../../../div[3]/div/div/span[text()='Goal: Negative']");
	public static final By LBL_PAGEHEADER = By.xpath("//h2[contains(., 'Labs')]");
	public static final By LBL_ADDPOPUPADDLABRESULTS = By.xpath("//span[text()='Add Lab Results']");
	public static final By LBL_ADDPOPUPAPPLYTHISDATETOALLVALUES = By.xpath("//span[text()='APPLY THIS DATE TO ALL VALUES']");
	public static final By LBL_ADDPOPUPHEIGHT = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Height']");
	public static final By LBL_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Target Dry Weight']");
	public static final By LBL_ADDPOPUPPHOSPHOROUS = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Phosphorous']");
	public static final By LBL_ADDPOPUPGFR = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='GFR']");
	public static final By LBL_ADDPOPUPLDL = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='LDL']");
	public static final By LBL_ADDPOPUPALBUMIN = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Albumin']");
	public static final By LBL_ADDPOPUPCO2LEVEL = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Co2 Level']");
	public static final By LBL_ADDPOPUPKTV = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='KT/V']");
	public static final By LBL_ADDPOPUPPOTASSIUM = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Potassium']");
	public static final By LBL_ADDPOPUPHEPATITISBTITER = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Hepatitis B Titer']");
	public static final By LBL_ADDPOPUPTSAT = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='TSAT']");
	public static final By LBL_ADDPOPUPWEIGHT = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Weight']");
	public static final By LBL_ADDPOPUPCALCIUMXPHOSPHOROUS = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Calcium X Phosphorous']");
	public static final By LBL_ADDPOPUPCREATININE = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Creatinine']");
	public static final By LBL_ADDPOPUPHGBA1C = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Hgb A1C']");
	public static final By LBL_ADDPOPUPHGB = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Hgb']");
	public static final By LBL_ADDPOPUPURINEALBUMINCREATININERATIO = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Urine Albumin/Creatinine Ratio']");
	public static final By LBL_ADDPOPUPCALCIUM = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Calcium']");
	public static final By LBL_ADDPOPUPURR = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='URR']");
	public static final By LBL_ADDPOPUPTH = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='PTH']");
	public static final By LBL_ADDPOPUPFERRITIN = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Ferritin']");
	public static final By LBL_ADDPOPUPBLOODPRESURE = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Blood Pressure']");
	public static final By LBL_ADDPOPUPDIPSTICKFORPROTEIN = By.xpath("//div[@class='modal-dialog modal-lg']//span[text()='Dipstick For Protein']");
	public static final By LBL_ADDPOPUPKTVERRORMESSAGE = By
	        .xpath("//div[@class='modal-dialog modal-lg']//div[@role='alert']//div[contains(., \"Labtype 'KTV' not valid for this patient\")]");
	public static final By LBL_ADDPOPUPURRERRORMESSAGE = By
	        .xpath("//div[@class='modal-dialog modal-lg']//div[@role='alert']//div[contains(., \"Labtype 'URR' not valid for this patient\")]");
	public static final By LBL_ADDPOPUPURINEALBUMINCREATININERATIOERRORMESSAGE = By
	        .xpath("//div[@class='modal-dialog modal-lg']//div[@role='alert']//div[contains(., \"Labtype 'UrineAlbuminCreatinineRatio' not valid for this patient\")]");
	public static final By LBL_ADDPOPUPBLOODPRESSUREERRORMESSAGE = By
	        .xpath("//div[@class='modal-dialog modal-lg']//div[@role='alert']//div[contains(., 'LabType.BPSys value must be greater than LabType.BPDia value')]");

	public static final By LBL_HEIGHTSOURCE = By.xpath("//span[contains(., 'Height (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_HEIGHTCOLOR = By.xpath("//span[contains(., 'Height (')]");
	public static final By LBL_GRAPHPOPUPHEIGHTCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Height (')]");

	public static final By LBL_WEIGHTSOURCE = By.xpath("//span[contains(., 'Weight (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_WEIGHTCOLOR = By.xpath("//span[contains(., 'Weight (')]");
	public static final By LBL_GRAPHPOPUPWEIGHTCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Weight (')]");

	public static final By LBL_TARGETDRYWEIGHTSOURCE = By.xpath("//span[contains(., 'Target Dry Weight (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_TARGETDRYWEIGHTCOLOR = By.xpath("//span[contains(., 'Target Dry Weight (')]");
	public static final By LBL_GRAPHPOPUPTARGETDRYWEIGHTCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Target Dry Weight (')]");

	public static final By LBL_CALCIUMXPHOSPHOROUSGOAL = By.xpath("//span[contains(., 'Calcium X Phosphorous (')]/../..//span[text()='Goal: Between 30 and 60']");
	public static final By LBL_CALCIUMXPHOSPHOROUSSOURCE = By.xpath("//span[contains(., 'Calcium X Phosphorous (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_CALCIUMXPHOSPHOROUSCOLOR = By.xpath("//span[contains(., 'Calcium X Phosphorous (')]");
	public static final By LBL_GRAPHPOPUPCALCIUMXPHOSPHOROUSCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Calcium X Phosphorous (')]");
	public static final By LBL_GRAPHPOPUPCALCIUMXPHOSPHOROUSGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 30 and 60']");

	public static final By LBL_PHOSPHOROUSGOAL = By.xpath("//span[contains(., 'Phosphorous (')]/../..//span[text()='Goal: Between 0.5 and 5.5']");
	public static final By LBL_PHOSPHOROUSSOURCE = By.xpath("//span[text()='Goal: Between 0.5 and 5.5']/../../..//span[text()='Source: VH']");
	public static final By LBL_PHOSPHOROUSCOLOR = By.xpath("//span[contains(., 'Phosphorous (')]");
	public static final By LBL_GRAPHPOPUPPHOSPHOROUSCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Phosphorous (')]");
	public static final By LBL_GRAPHPOPUPPHOSPHOROUSGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 0.5 and 5.5']");

	public static final By LBL_CREATININEGOAL = By.xpath("//span[contains(., 'Creatinine (')]/../..//span[text()='Goal: Between 0.5 and 1.5']");
	public static final By LBL_CREATININESOURCE = By.xpath("//span[contains(., 'Creatinine (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_CREATININECOLOR = By.xpath("//span[contains(., 'Creatinine (')]");
	public static final By LBL_GRAPHPOPUPCREATININECOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Creatinine (')]");
	public static final By LBL_GRAPHPOPUPCREATININEGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 0.5 and 1.5']");

	public static final By LBL_GFRGOAL = By.xpath("//span[contains(., 'GFR (')]/../..//span[text()='Goal: Between 30 and 125']");
	public static final By LBL_GFRSOURCE = By.xpath("//span[contains(., 'GFR (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_GFRCOLOR = By.xpath("//span[contains(., 'GFR (')]");
	public static final By LBL_GRAPHPOPUPGFRCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'GFR (')]");
	public static final By LBL_GRAPHPOPUPGFRGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 30 and 125']");

	public static final By LBL_HGBA1CGOAL = By.xpath("//span[contains(., 'Hgb A1C (')]/../..//span[text()='Goal: Between 3 and 8']");
	public static final By LBL_HGBA1CSOURCE = By.xpath("//span[contains(., 'Hgb A1C (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_HGBA1CCOLOR = By.xpath("//span[contains(., 'Hgb A1C (')]");
	public static final By LBL_GRAPHPOPUPHGBA1CCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Hgb A1C (')]");
	public static final By LBL_GRAPHPOPUPHGBA1CGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 3 and 8']");

	public static final By LBL_LDLGOAL = By.xpath("//span[contains(., 'LDL (')]/../..//span[text()='Goal: Between 0 and 100']");
	public static final By LBL_LDLSOURCE = By.xpath("//span[contains(., 'LDL (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_LDLCOLOR = By.xpath("//span[contains(., 'LDL (')]");
	public static final By LBL_GRAPHPOPUPLDLCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'LDL (')]");
	public static final By LBL_GRAPHPOPUPLDLGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 0 and 100']");

	public static final By LBL_HGBGOAL = By.xpath("//span[contains(., 'Hgb (')]/../..//span[text()='Goal: Between 0 and 11']");
	public static final By LBL_HGBSOURCE = By.xpath("//span[contains(., 'Hgb (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_HGBCOLOR = By.xpath("//span[contains(., 'Hgb (')]");
	public static final By LBL_GRAPHPOPUPHGBCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Hgb (')]");
	public static final By LBL_GRAPHPOPUPHGBGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 0 and 11']");

	public static final By LBL_ALBUMINGOAL = By.xpath("//span[contains(., 'Albumin (')]/../..//span[text()='Goal: Between 4 and 7']");
	public static final By LBL_ALBUMINSOURCE = By.xpath("//span[contains(., 'Albumin (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_ALBUMINCOLOR = By.xpath("//span[contains(., 'Albumin (')]");
	public static final By LBL_GRAPHPOPUPALBUMINCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Albumin (')]");
	public static final By LBL_GRAPHPOPUPALBUMINGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 4 and 7']");

	public static final By LBL_URINEALBUMINCREATININERATIOGOAL = By.xpath("//span[contains(., 'Urine Albumin/Creatinine Ratio (')]/../..//span[text()='Goal: Between 0 and 30']");
	public static final By LBL_URINEALBUMINCREATININERATIOSOURCE = By.xpath("//span[contains(., 'Urine Albumin/Creatinine Ratio (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_URINEALBUMINCREATININERATIOCOLOR = By.xpath("//span[contains(., 'Urine Albumin/Creatinine Ratio (')]");
	public static final By LBL_GRAPHPOPUPURINEALBUMINCREATININERATIOCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Urine Albumin/Creatinine Ratio (')]");
	public static final By LBL_GRAPHPOPUPURINEALBUMINCREATININERATIOGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 0 and 30']");

	public static final By LBL_DIPSTICKFORPROTEINGOAL = By.xpath("//span[contains(., 'Dipstick For Protein (')]/../..//span[text()='Goal: Negative']");
	public static final By LBL_DIPSTICKFORPROTEINSOURCE = By.xpath("//span[contains(., 'Dipstick For Protein (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_DIPSTICKFORPROTEINCOLOR = By.xpath("//span[contains(., 'Dipstick For Protein (')]");

	public static final By LBL_CO2LEVELGOAL = By.xpath("//span[contains(., 'Co2 Level (')]/../..//span[text()='Goal: Between 22 and 31']");
	public static final By LBL_CO2LEVELSOURCE = By.xpath("//span[contains(., 'Co2 Level (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_CO2LEVELCOLOR = By.xpath("//span[contains(., 'Co2 Level (')]");
	public static final By LBL_GRAPHPOPUPCO2LEVELCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Co2 Level (')]");
	public static final By LBL_GRAPHPOPUPCO2LEVELGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 22 and 31']");

	public static final By LBL_CALCIUMGOAL1 = By.xpath("//span[contains(., 'Calcium (')]/../..//span[text()='Goal: ESRD: Between 8.4 and 9.5']");
	public static final By LBL_CALCIUMGOAL2 = By.xpath("//span[contains(., 'Calcium (')]/../..//span[text()=' CKD: Between 8.6 and 10.3']");
	public static final By LBL_CALCIUMSOURCE = By.xpath("//span[contains(., 'Calcium (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_CALCIUMCOLOR = By.xpath("//span[contains(., 'Calcium (')]");
	public static final By LBL_GRAPHPOPUPCALCIUMCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Calcium (')]");
	public static final By LBL_GRAPHPOPUPCALCIUMGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: ESRD: Between 8.4 and 9.5 CKD: Between 8.6 and 10.3']");

	public static final By LBL_KTVGOAL = By.xpath("//span[contains(., 'KT/V (')]/../..//span[text()='Goal: Between 1.2 and 3']");
	public static final By LBL_KTVSOURCE = By.xpath("//span[contains(., 'KT/V (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_KTVCOLOR = By.xpath("//span[contains(., 'KT/V (')]");
	public static final By LBL_GRAPHPOPUPKTVCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'KT/V (')]");
	public static final By LBL_GRAPHPOPUPKTVGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 1.2 and 3']");

	public static final By LBL_URRGOAL = By.xpath("//span[contains(., 'URR (')]/../..//span[text()='Goal: Between 65 and 99']");
	public static final By LBL_URRSOURCE = By.xpath("//span[contains(., 'URR (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_URRCOLOR = By.xpath("//span[contains(., 'URR (')]");
	public static final By LBL_GRAPHPOPUPURRCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'URR (')]");
	public static final By LBL_GRAPHPOPUPURRGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 65 and 99']");

	public static final By LBL_POTASSIUMGOAL = By.xpath("//span[contains(., 'Potassium (')]/../..//span[text()='Goal: Between 3.5 and 5.2']");
	public static final By LBL_POTASSIUMSOURCE = By.xpath("//span[contains(., 'Potassium (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_POTASSIUMCOLOR = By.xpath("//span[contains(., 'Potassium (')]");
	public static final By LBL_GRAPHPOPUPPOTASSIUMCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Potassium (')]");
	public static final By LBL_GRAPHPOPUPPOTASSIUMGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 3.5 and 5.2']");

	public static final By LBL_PTHGOAL1 = By.xpath("//span[contains(., 'PTH (')]/../..//span[text()='Goal: CKD1: Between 0 and 9999']");
	public static final By LBL_PTHGOAL2 = By.xpath("//span[contains(., 'PTH (')]/../..//span[text()=' CKD2: Between 0 and 9999']");
	public static final By LBL_PTHGOAL3 = By.xpath("//span[contains(., 'PTH (')]/../..//span[text()=' ESRD: Between 150 and 600']");
	public static final By LBL_PTHGOAL4 = By.xpath("//span[contains(., 'PTH (')]/../..//span[text()=' CKD3: Between 35 and 70']");
	public static final By LBL_PTHGOAL5 = By.xpath("//span[contains(., 'PTH (')]/../..//span[text()=' CKD4: Between 71 and 110']");
	public static final By LBL_PTHSOURCE = By.xpath("//span[contains(., 'PTH (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_PTHCOLOR = By.xpath("//span[contains(., 'PTH (')]");
	public static final By LBL_GRAPHPOPUPPTHCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'PTH (')]");
	public static final By LBL_GRAPHPOPUPPTHGOAL = By.xpath(
	        "//div[@class='lab-history-modal-header-div']//span[text()='Goal: CKD1: Between 0 and 9999 CKD2: Between 0 and 9999 ESRD: Between 150 and 600 CKD3: Between 35 and 70 CKD4: Between 71 and 110']");

	public static final By LBL_HEPATITISBTITERGOAL = By.xpath("//span[contains(., 'Hepatitis B Titer (')]/../..//span[text()='Goal: Between 10 and 100']");
	public static final By LBL_HEPATITISBTITERSOURCE = By.xpath("//span[contains(., 'Hepatitis B Titer (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_HEPATITISBTITERCOLOR = By.xpath("//span[contains(., 'Hepatitis B Titer (')]");
	public static final By LBL_GRAPHPOPUPHEPATITISBTITERCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Hepatitis B Titer (')]");
	public static final By LBL_GRAPHPOPUPHEPATITISBTITERGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 10 and 100']");

	public static final By LBL_FERRITINGOAL = By.xpath("//span[contains(., 'Ferritin (')]/../..//span[text()='Goal: Between 100 and 500']");
	public static final By LBL_FERRITINSOURCE = By.xpath("//span[contains(., 'Ferritin (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_FERRITINCOLOR = By.xpath("//span[contains(., 'Ferritin (')]");
	public static final By LBL_GRAPHPOPUPFERRITINCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Ferritin (')]");
	public static final By LBL_GRAPHPOPUPFERRITINGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 100 and 500']");

	public static final By LBL_TSATGOAL = By.xpath("//span[contains(., 'TSAT (')]/../..//span[text()='Goal: Between 20 and 100']");
	public static final By LBL_TSATSOURCE = By.xpath("//span[contains(., 'TSAT (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_TSATCOLOR = By.xpath("//span[contains(., 'TSAT (')]");
	public static final By LBL_GRAPHPOPUPTSATCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'TSAT (')]");
	public static final By LBL_GRAPHPOPUPTSATGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 20 and 100']");

	public static final By LBL_BLOODPRESSURESYSTOLICGOAL = By.xpath("//span[contains(., 'Blood Pressure Systolic (')]/../..//span[text()='Goal: Between 60 and 130']");
	public static final By LBL_BLOODPRESSURESYSTOLICSOURCE = By.xpath("//span[contains(., 'Blood Pressure Systolic (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_BLOODPRESSURESYSTOLICCOLOR = By.xpath("//span[contains(., 'Blood Pressure Systolic (')]");
	public static final By LBL_GRAPHPOPUPBLOODPRESSURESYSTOLICCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Blood Pressure Systolic (')]");
	public static final By LBL_GRAPHPOPUPBLOODPRESSURESYSTOLICGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 60 and 130']");

	public static final By LBL_BLOODPRESSUREDIASTOLICGOAL = By.xpath("//span[contains(., 'Blood Pressure Diastolic (')]/../..//span[text()='Goal: Between 0 and 80']");
	public static final By LBL_BLOODPRESSUREDIASTOLICSOURCE = By.xpath("//span[contains(., 'Blood Pressure Diastolic (')]/../../..//span[text()='Source: VH']");
	public static final By LBL_BLOODPRESSUREDIASTOLICCOLOR = By.xpath("//span[contains(., 'Blood Pressure Diastolic (')]");
	public static final By LBL_GRAPHPOPUPBLOODPRESSUREDIASTOLICCOLOR = By.xpath("//div[@class='lab-history-modal-header-div']//span[contains(., 'Blood Pressure Diastolic (')]");
	public static final By LBL_GRAPHPOPUPBLOODPRESSUREDIASTOLICGOAL = By.xpath("//div[@class='lab-history-modal-header-div']//span[text()='Goal: Between 0 and 80']");

	public static final By PLH_ADDPOPUPHEIGHT = By.xpath("//span[text()='Height']/../../../div[2]/div/input[@placeholder='cm']");
	public static final By PLH_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//span[text()='Target Dry Weight']/../../../div[2]/div/input[@placeholder='kg']");
	public static final By PLH_ADDPOPUPWEIGHT = By.xpath("//span[text()='Weight']/../../../div[2]/div/input[@placeholder='kg']");
	public static final By PLH_ADDPOPUPDIPSTICKFORPROTEIN = By.xpath("//span[text()='Dipstick For Protein']/../../../div[2]/div/select[@ng-reflect-model='No Test']");

	public static final By TXT_ADDPOPUPHEIGHT = By.xpath("//span[text()='Height']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPTARGETDRYWEIGHT = By.xpath("//span[text()='Target Dry Weight']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPPHOSPHOROUS = By.xpath("//span[text()='Phosphorous']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPGFR = By.xpath("//span[text()='GFR']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPLDL = By.xpath("//span[text()='LDL']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPALBUMIN = By.xpath("//span[text()='Albumin']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPCO2LEVEL = By.xpath("//span[text()='Co2 Level']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPKTV = By.xpath("//span[text()='KT/V']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPPOTASSIUM = By.xpath("//span[text()='Potassium']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPHEPATITISBTITER = By.xpath("//span[text()='Hepatitis B Titer']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPTSAT = By.xpath("//span[text()='TSAT']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPBLOODPRESUREDIASTOLIC = By.xpath("//span[text()='Blood Pressure']/../../../div[2]/div/input[@placeholder='Diastolic']");
	public static final By TXT_ADDPOPUPWEIGHT = By.xpath("//span[text()='Weight']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPCALCIUMXPHOSPHOROUS = By.xpath("//span[text()='Calcium X Phosphorous']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPCREATININE = By.xpath("//span[text()='Creatinine']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPHGBA1C = By.xpath("//span[text()='Hgb A1C']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPHGB = By.xpath("//span[text()='Hgb']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPURINEALBUMINCREATININERATIO = By.xpath("//span[text()='Urine Albumin/Creatinine Ratio']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPCALCIUM = By.xpath("//span[text()='Calcium']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPURR = By.xpath("//span[text()='URR']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPPTH = By.xpath("//span[text()='PTH']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPFERRITIN = By.xpath("//span[text()='Ferritin']/../../../div[2]/div/input");
	public static final By TXT_ADDPOPUPBLOODPRESURESYSTOLIC = By.xpath("//span[text()='Blood Pressure']/../../../div[2]/div/input[@placeholder='Systolic']");

	public static final By XXX_ADDPOPUPKTV = By.xpath("//span[text()='KT/V']/../../../div[2]/div/input");
	public static final By XXX_ADDPOPUPURR = By.xpath("//span[text()='URR']/../../../div[2]/div/input");
}