package com.vh.ui.waits;

import java.util.Collections;
import java.util.List;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.google.common.base.Function;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.PropertyManager;
import com.vh.ui.utilities.Utilities;

/*  
 * @author Rishi Khanna
 * @version 2.0
 * @Team:DaVita MCOE
 * @Email:rishi.khanna@davita.com
 * @Company:CitiusTech
 */
public class WebDriverWaits {

	private static final Logger LOGGER = Logg.createLogger();
	private Utilities utilities = new Utilities();
	private static final Properties FRAMEWORKPROPERTIES = PropertyManager
			.loadFrameworkPropertyFile("framework.properties");
	private static final String ELEMENTSEARCHTIMEOUT = "elementSearchTimeOut";

	private WebElement waitForElementVisibility(WebDriver driver, By locator) throws TimeoutException, WaitException {
		try {
			WebElement element = null;
			LOGGER.info(Utilities.getCurrentThreadId() + "Waiting for the visibility of the element using By class:"
					+ locator);
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty(ELEMENTSEARCHTIMEOUT)));
			element = wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
			LOGGER.info(Utilities.getCurrentThreadId() + "WebElement Present and Visible. Proceeding further...");
			return element;
		} catch (TimeoutException tm) {
			throw new TimeoutException(Utilities.getCurrentThreadId()
					+ "TIME OUT EXCEPTION while waiting for the VISIBILITY of the element using By class:" + locator
					+ "\n", tm);
		}
	}

	private WebElement waitForElementPresence(WebDriver driver, By locator) throws TimeoutException, WaitException {
		try {
			WebElement element = null;
			LOGGER.info(Utilities.getCurrentThreadId() + "Waiting for the presence of the element using By class:"
					+ locator);
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty("elementSearchTimeOut")));
			element = wait.until(ExpectedConditions.presenceOfElementLocated(locator));
			LOGGER.info(Utilities.getCurrentThreadId() + "WebElement Present. Proceeding further...");
			return element;
		} catch (TimeoutException tm) {
			throw new TimeoutException(Utilities.getCurrentThreadId()
					+ "TIME OUT EXCEPTION while waiting for the PRESENCE of the element using By class:" + locator
					+ "\n", tm);
		}
	}

	private WebElement waitForElementVisibility(WebDriver driver, WebElement beforeVisibilityElement)
			throws TimeoutException, WaitException {
		try {
			WebElement afterVisibilityElement = null;
			LOGGER.info(Utilities.getCurrentThreadId() + "Waiting for the visibility of the web element:"
					+ beforeVisibilityElement);
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty(ELEMENTSEARCHTIMEOUT)));
			afterVisibilityElement = wait.until(ExpectedConditions.visibilityOf(beforeVisibilityElement));
			LOGGER.info(Utilities.getCurrentThreadId() + "WebElement Visible. Proceeding further...");
			return afterVisibilityElement;
		} catch (TimeoutException tm) {
			throw new TimeoutException(Utilities.getCurrentThreadId()
					+ "TIME OUT EXCEPTION while waiting for the VISIBILITY of the web element:"
					+ beforeVisibilityElement + "\n", tm);
		}
	}

	private WebElement waitForElementClickability(WebDriver driver, By locator) throws TimeoutException, WaitException {
		try {
			WebElement element = null;
			LOGGER.info(Utilities.getCurrentThreadId() + "Waiting for the clickability of the element:" + locator);
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty(ELEMENTSEARCHTIMEOUT)));
			element = wait.until(ExpectedConditions.elementToBeClickable(locator));
			LOGGER.info(Utilities.getCurrentThreadId() + "WebElement Clickable. Proceeding further...");
			return element;
		} catch (TimeoutException tm) {
			throw new TimeoutException(
					Utilities.getCurrentThreadId()
							+ "TIME OUT EXCEPTION while waiting for the clickability of the element:" + locator + "\n",
					tm);
		}
	}

	private WebElement waitForElementClickability(WebDriver driver, WebElement element)
			throws TimeoutException, WaitException {
		try {
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty(ELEMENTSEARCHTIMEOUT)));
			element = wait.until(ExpectedConditions.elementToBeClickable(element));
			LOGGER.info(Utilities.getCurrentThreadId() + "WebElement Clickable. Proceeding further...");
			return element;
		} catch (TimeoutException tm) {
			throw new TimeoutException(Utilities.getCurrentThreadId()
					+ "TIME OUT EXCEPTION while waiting for the clickability of the element:" + "\n", tm);
		}
	}

	public Alert waitForAlert(WebDriver driver) throws TimeoutException, WaitException {
		try {
			Alert alert = null;
			LOGGER.info(Utilities.getCurrentThreadId() + "Waiting for visibility of the Alert");
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty(ELEMENTSEARCHTIMEOUT)));
			alert = wait.until(ExpectedConditions.alertIsPresent());
			LOGGER.info(Utilities.getCurrentThreadId() + "Alert Present and Visible. Proceeding further...");
			return alert;
		} catch (TimeoutException tm) {
			throw new TimeoutException(
					Utilities.getCurrentThreadId() + "TIME OUT EXCEPTION while waiting for Alert" + "\n", tm);
		}
	}

	private List<WebElement> waitForElementsVisibility(WebDriver driver, By locator)
			throws TimeoutException, WaitException {
		try {
			List<WebElement> element = null;
			LOGGER.info(Utilities.getCurrentThreadId() + "Waiting for the visibility of the elements:" + locator);
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty(ELEMENTSEARCHTIMEOUT)));
			element = wait.until(ExpectedConditions.visibilityOfAllElementsLocatedBy(locator));
			LOGGER.info(Utilities.getCurrentThreadId() + "WebElements Visible. Proceeding further...");
			return element;
		} catch (TimeoutException tm) {
			throw new TimeoutException(
					Utilities.getCurrentThreadId()
							+ "TIME OUT EXCEPTION while waiting for the VISIBILITY of the elementS:" + locator + "\n",
					tm);
		}
	}

	private List<WebElement> waitForElementsPresence(WebDriver driver, By locator)
			throws TimeoutException, WaitException {
		try {
			List<WebElement> element = null;
			LOGGER.info(Utilities.getCurrentThreadId() + "Waiting for the presence of the elements:" + locator);
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty(ELEMENTSEARCHTIMEOUT)));
			element = wait.until(ExpectedConditions.presenceOfAllElementsLocatedBy(locator));
			LOGGER.info(Utilities.getCurrentThreadId() + "WebElements Present. Proceeding further...");
			return element;
		} catch (TimeoutException tm) {
			throw new TimeoutException(
					Utilities.getCurrentThreadId()
							+ "TIME OUT EXCEPTION while waiting for the PRESENCE of the elementS:" + locator + "\n",
					tm);
		}
	}

	public void waitForTimePeriod(long timeOut) {
		try {
			LOGGER.info(Utilities.getCurrentThreadId() + "Thread.sleep activated for " + timeOut / 1000 + " seconds");
			Thread.sleep(timeOut);
			LOGGER.info(Utilities.getCurrentThreadId() + "Ended after waiting for " + timeOut / 1000 + " seconds");
		} catch (InterruptedException ie) {
			throw new RuntimeException(
					"Thread Interrupted Exception in the waitForTimePeriod() method of WebDriverWaits class");
		}
	}

	public boolean checkForElementVisibility(WebDriver driver, final By locator) throws WaitException {
		try {
			LOGGER.info(Utilities.getCurrentThreadId() + "Checking for the visibility of the element using By class:"
					+ locator);
			WebDriverWait wait = new WebDriverWait(driver,
					utilities.convertToInteger(FRAMEWORKPROPERTIES.getProperty(ELEMENTSEARCHTIMEOUT)));
			wait.until(new Function<WebDriver, Boolean>() {
				public Boolean apply(WebDriver driver) {
					return driver.findElement(locator).isDisplayed();
				}
			});
			LOGGER.info(Utilities.getCurrentThreadId() + "WebElement Visible. Proceeding further...");
			return true;
		} catch (TimeoutException tm) {
			LOGGER.error(Utilities.getCurrentThreadId()
					+ "TIME OUT EXCEPTION while waiting for the VISIBILITY of the element using By class:" + locator
					+ "\n", tm);
			return false;
		}
	}

	// Access Methods

	public WebElement syncLocatorUsing(String syncKey, WebDriver driver, By locator)
			throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Inside SYNC BLOCK for Locator");
		if ("visibility".equalsIgnoreCase(syncKey)) {
			LOGGER.info(Utilities.getCurrentThreadId() + "Inside VISIBILITY of Locator");
			return waitForElementVisibility(driver, locator);
		} else if ("clickability".equalsIgnoreCase(syncKey)) {
			LOGGER.info(Utilities.getCurrentThreadId() + "Inside CLICKABILITY of Locator");
			return waitForElementClickability(driver, locator);
		} else if ("presence".equalsIgnoreCase(syncKey)) {
			LOGGER.info(Utilities.getCurrentThreadId() + "Inside PRESENCE of Locator");
			return waitForElementPresence(driver, locator);
		} else {
			LOGGER.warn(Utilities.getCurrentThreadId() + "RETURNING NULL -- CHECK THE PARAMETER PASSED");
			return null;
		}
	}

	public List<WebElement> syncLocatorsUsing(String syncKey, WebDriver driver, By locator)
			throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Inside SYNC BLOCK for LocatorS");
		if ("visibility".equals(syncKey)) {
			LOGGER.info(Utilities.getCurrentThreadId() + "Inside VISIBILITY of List LocatorS");
			return waitForElementsVisibility(driver, locator);
		} else if ("presence".equals(syncKey)) {
			LOGGER.info(Utilities.getCurrentThreadId() + "Inside PRESENCE of List LocatorS");
			return waitForElementsPresence(driver, locator);
		} else {
			LOGGER.info(Utilities.getCurrentThreadId() + "No Elements Found. Returning EMPTY LIST");
			return Collections.emptyList();
		}
	}

	public WebElement syncElementUsing(String syncKey, WebDriver driver, WebElement element)
			throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Inside SYNC BLOCK for Element");
		if ("clickability".equals(syncKey)) {
			LOGGER.info(Utilities.getCurrentThreadId() + "Inside CLICKABILITY of Element");
			return waitForElementClickability(driver, element);
		} else if ("visibility".equals(syncKey)) {
			LOGGER.info(Utilities.getCurrentThreadId() + "Inside VISIBILITY of List ElementS");
			return waitForElementVisibility(driver, element);
		} else {
			LOGGER.warn(Utilities.getCurrentThreadId() + "RETURNING NULL -- CHECK THE PARAMETER PASSED");
			return null;
		}
	}
}