/**
 * 
 */
package com.vh.ui.actions;

import static com.vh.ui.web.locators.WebMyDashboardPageLocators.BTN_CLOSE_PATIENT_YES;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.BTN_EXPAND_OPENPATIENT;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.BTN_LOGOUT;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.BTN_LOGOUT_OK;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.LBL_DO_YOU_WANT_TO_FINALIZE;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.LBL_LOGOUT_MSG;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.LBL_NO_OF_PATIENTS;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.OPEN_PATIENT_CONTAINER;
import static com.vh.ui.web.locators.WebMyDashboardPageLocators.POPUP_CLOSE_PATIENT;

import java.util.List;

import org.apache.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.Utilities;
import com.vh.ui.waits.WebDriverWaits;

import ru.yandex.qatools.allure.annotations.Step;

/**
 * @author SUBALIVADA
 * @date   Jan 9, 2017
 * @class  ApplicationFunctions.java
 *
 */
public class ApplicationFunctions {
	protected WebDriver driver;
	protected static final Logger LOGGER = Logg.createLogger();
	protected final WebDriverWaits wait = new WebDriverWaits();
	private static Cookie cookie;
	private WebActions webActions = null;
	
	public ApplicationFunctions(WebDriver driver)
	{
		this.driver = driver;
		this.webActions = new WebActions(driver);
	}
	
	/**
	 * Navigate to Menu in CPP
	 * 
	 * @param menuToNavigate the path of menu to navigate to. i.e. Screenings->Cognitive Screening
	 */
	@Step("Navigate to {0} menu")
	public boolean navigateToMenu(String menuToNavigate)
	{
		String menu[] = menuToNavigate.split("->");		
		
		if(menu.length != 1)
		{
			By mainMenu = By.xpath("//span[text() = '" + menu[0] + "']");
			WebElement mainEle = driver.findElement(mainMenu);
			Utilities.highlightElement(driver, mainEle);
		
			webActions.javascriptClick(mainEle);
			
			By subMenu = By.xpath("//a[text() = '" + menu[1] + "']");
			Utilities.highlightElement(driver, subMenu);
			webActions.javascriptClick(subMenu);
		}
		else if(menu.length == 1)
		{
			By subMenu = By.xpath("//a[text() = '" + menu[0] + "']");
			Utilities.highlightElement(driver, subMenu);
			webActions.javascriptClick(subMenu);
		}
		else
		{
			return false;
		}
		return true;
	}
	
	/**
	 * Click Logout button in CPP and logout of application
	 * 
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	@Step("Logout of Capella")
	public void capellaLogOut() throws TimeoutException, WaitException
	{
		LOGGER.info("In ApplicationFunctions - capellaLogOut");
		Utilities.highlightElement(driver, BTN_LOGOUT);
		webActions.javascriptClick(BTN_LOGOUT);
		String Invalid_Errormessage = webActions.getText("visibility", LBL_LOGOUT_MSG);
		System.out.println(Invalid_Errormessage);
		
		WebElement btnOk = driver.findElement(BTN_LOGOUT_OK);
		Utilities.highlightElement(driver, BTN_LOGOUT_OK);
		webActions.javascriptClick(btnOk);	
	}
	
	/**
	 * Click on Main Menu's like My Patients, My Dashboard, Patient Engagement, etc.
	 * 
	 * @param menu
	 */
	@Step("Navigate to {0} menu")
	public void clickOnMainMenu(String menu)
	{
		LOGGER.info("In ApplicationFunctions - clickOnMainMenu");
		By mainMenu = By.xpath("//span[text() = '" + menu + "']");
		WebElement mainEle = driver.findElement(mainMenu);
		Utilities.highlightElement(driver, mainEle);
	
		webActions.javascriptClick(mainEle);
	}
	
	
	public void getRecordFromTable(String tableLocator, String searchValue, int searchColumn)
	{
		LOGGER.info("In ApplicationFunctions - selectPatientFromMyPatient");
		String value;
		String rowLocator = tableLocator + "/tbody/tr";
		String colValue = null;
		int rowCount = driver.findElements(By.xpath(rowLocator)).size();
		int colCount = driver.findElements(By.xpath(rowLocator + "[1]/td")).size();
		
		do
		{
			value = getTextFromTable(tableLocator, 1, 1, searchColumn);
		}while(value.equals(searchValue));
				
	}
	
	public String getTextFromTable(String tableLocator, int startRow, int startCol, int searchColumn)
	{
		String rowLocator = tableLocator + "/tbody/tr";
		String colValue = null;
		int rowCount = driver.findElements(By.xpath(rowLocator)).size();
		int colCount = driver.findElements(By.xpath(rowLocator + "[1]/td")).size();
		
		for(int i = startRow; i <= rowCount; i++)
		{
			for(int j = startCol; j <= colCount; j++)
			{
				colValue = driver.findElement(By.xpath(tableLocator + "/tbody/tr[" + i + "]/td[" + j + "]")).getText();
				break;
			}
		}
		return colValue;
	}
	
	/**
	 * Verifies if the required message box exists or not
	 * 
	 * @param popupLocator locator to identify the message box
	 * @param msgLocator locator to identify the message
	 * @param message the message text
	 * @return true if the required message box exists, else false
	 * @throws WaitException
	 * @throws InterruptedException
	 */
	public boolean checkMessageBoxExist(By popupLocator, By msgLocator, String message) throws WaitException, InterruptedException
	{
		boolean isVisible = new WebDriverWaits().checkForElementVisibility(this.driver, popupLocator);
		if(!isVisible)
		{
			return false;
		}
		String requiredMessage = webActions.getText("presence", msgLocator);
		if(requiredMessage.equalsIgnoreCase(message))
		{
			return true;
		}
		return false;
	}
	
	/**
	 * Clicks on a button in the message box identified by the message
	 * 
	 * @param popupLocator locator to identify Message box
	 * @param msgLocator locator to identify the message
	 * @param message the message text
	 * @param btnLocator locator to identify the button in the message box
	 * @return true if successfully click on the button, else false
	 * @throws WaitException
	 * @throws InterruptedException
	 */
	public boolean clickButtonOnMessageBox(By popupLocator, By msgLocator, String message, By btnLocator) throws WaitException, InterruptedException
	{
		boolean isVisible = checkMessageBoxExist(popupLocator, msgLocator, message);
		
		if(!isVisible)
		{
			return false;
		}
		
		WebElement btn = driver.findElement(btnLocator);
		Utilities.highlightElement(driver, btnLocator);
		webActions.javascriptClick(btn);
		return true;
	}
	
	@Step("Close All Patients")
	public boolean closeAllPatients() throws TimeoutException, WaitException, InterruptedException
	{
		LOGGER.debug("In WebMyDashboardPage - closeAllPatients");
		
		int count = Integer.parseInt(webActions.getText("visibility", LBL_NO_OF_PATIENTS));
		System.out.println(count);
		if(count == 0)
		{
			return true;
		}
		
		Utilities.highlightElement(driver, BTN_EXPAND_OPENPATIENT);
//		webActions.actionClick(CLICKABILITY, BTN_EXPAND_OPENPATIENT);
		WebElement btnExpandOpenPatient = driver.findElement(BTN_EXPAND_OPENPATIENT);
		webActions.javascriptClick(btnExpandOpenPatient);
		
		Thread.sleep(5000);
		
		Utilities.highlightElement(driver, OPEN_PATIENT_CONTAINER);
		WebElement container = driver.findElement(OPEN_PATIENT_CONTAINER);
		
		List<WebElement> finalize = null;
		finalize =  container.findElements(By.xpath("//div[@title='Finalize Patient']"));
		do
		{
			System.out.println(finalize.size());
			Utilities.highlightElement(driver, finalize.get(2));
			Thread.sleep(3000);

			webActions.javascriptClick(finalize.get(2));
			
			clickButtonOnMessageBox(POPUP_CLOSE_PATIENT, LBL_DO_YOU_WANT_TO_FINALIZE, "Do you want to finalize and close this patient record?", BTN_CLOSE_PATIENT_YES);
			
//			boolean isVisible = new WebDriverWaits().checkForElementVisibility(driver, POPUP_CLOSE_PATIENT);
//			if(!isVisible)
//			{
//				return false;
//			}
//			String doYouWantToFinalize = webActions.getText("presence", LBL_DO_YOU_WANT_TO_FINALIZE);
//			if(doYouWantToFinalize.equalsIgnoreCase("Do you want to finalize and close this patient record?"))
//			{
////				webActions.click(CLICKABILITY, BTN_CLOSE_PATIENT_YES);
//				WebElement btnYes = driver.findElement(BTN_CLOSE_PATIENT_YES);
//				Utilities.highlightElement(driver, BTN_CLOSE_PATIENT_YES);
//				webActions.javascriptClick(btnYes);
//				Thread.sleep(3000);
//			}
			finalize =  container.findElements(By.xpath("//div[@title='Finalize Patient']"));
			
		}while(finalize.size() != 0);
		return true;						
	}
}
