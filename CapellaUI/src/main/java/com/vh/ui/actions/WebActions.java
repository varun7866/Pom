package com.vh.ui.actions;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoAlertPresentException;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.Select;
import org.testng.ITestContext;

import com.thoughtworks.selenium.webdriven.JavascriptLibrary;
import com.vh.ui.comparator.Comparator;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.Utilities;
import com.vh.ui.waits.WebDriverWaits;

/*  
 * @author Rishi Khanna
 * @version 2.0
 * @Team:DaVita MCOE
 * @Email:rishi.khanna@davita.com
 * @Company:CitiusTech
 */
public class WebActions {
	
	protected WebDriver driver;
	protected final Comparator compare = new Comparator();
	protected static final Logger LOGGER = Logg.createLogger();
	protected final WebDriverWaits wait = new WebDriverWaits();
	private static Cookie cookie;

	public WebActions(WebDriver driver) {
		this.driver = driver;
	}

	/**
	 * Stores the cookie for the default path with the given name and value with no expiry set.
	 *
	 * @param  key  the name of the cookie
	 * @param  value the value of the cookie
	 * 
	 */
	public void storeDataInCookie(String key, String value) {
		cookie = new Cookie(key, value);
		LOGGER.info(Utilities.getCurrentThreadId() + "Cookie description");
		LOGGER.info(Utilities.getCurrentThreadId() + "Key=" + key + " " + "Value=" + value);
		driver.manage().addCookie(cookie);
		LOGGER.info(Utilities.getCurrentThreadId() + "Successfully added cookie named " + key + " to the HTML page");
	}
	
	/**
	 * Get a cookie with a given name
	 *
	 * @param  key  the name of the cookie
	 * @return  the value of the cookie
	 * 
	 */
	public String retrieveDataFromCookie(String key) {
		LOGGER.info(Utilities.getCurrentThreadId() + "Retrieving the value "
				+ driver.manage().getCookieNamed(key).getValue() + " stored in the cookie");
		return driver.manage().getCookieNamed(key).getValue();
	}
	
	/**
	 * Load a new web page in the current browser window. 
	 *
	 * @param webUrl The URL to load. It is best to use a fully qualified URL
	 */
	public void navigateToURL(String webUrl) throws URLNavigationException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Navigating to Application URL on Browser:" + webUrl);
		driver.get(webUrl);
		LOGGER.info(Utilities.getCurrentThreadId() + "Successfully navigated to Application URL on the Browser");
	}

	/**
     * Maximizes the current window if it is not already maximized
     */
	public void maximizeBrowser() {
		LOGGER.info(Utilities.getCurrentThreadId() + "Maximizing the browser");
		driver.manage().window().maximize();
		LOGGER.info(Utilities.getCurrentThreadId() + "Browser Successfully Maximized");
	}
	
	/**
     * Closes the current browser window
     * 
     * @param context object of ITestContext
     */
	public void closeBrowser(ITestContext context) {
		LOGGER.info(Utilities.getCurrentThreadId() + "Closing the browser");
		context.getAttribute(context.getCurrentXmlTest().getName());
		LOGGER.info(Utilities.getCurrentThreadId() + "Sucessfully closed the browser" + "\n");
	}
	
	/**
	 * Enter text in input field identified by the locator after waiting till the expected condition is true
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to find the element 
	 * @param text to enter in the required input field
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void enterText(String expectedCondition, By locator, String text) throws TimeoutException, WaitException {
		WebElement webElement = null;
		webElement = wait.syncLocatorUsing(expectedCondition, driver, locator);
		LOGGER.info(Utilities.getCurrentThreadId() + "Clearing the content of the text box");
		webElement.clear();
		LOGGER.info(Utilities.getCurrentThreadId() + "Contents cleared");
		webElement.sendKeys(text);
		LOGGER.info(Utilities.getCurrentThreadId() + "Entered text:" + webElement.getText()
				+ " in text box with locator:" + locator);
	}
	
	public void selectValueFromAutoCompleteText(By locator, String value) throws TimeoutException, WaitException {
		enterText("visibility", locator, value);
		String xpathExpression = ".//md-option/span[text()=contains(., '" + value + "')]";
		click("visibility", By.xpath(xpathExpression));
	}
	
	/**
	 * Enter text in input field identified by the locator after waiting till the expected condition is true.
	 * Verifies the entered text is required text, else clears the text and re-enters the text till the 
	 * required text is same as entered text. 
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to find the element
	 * @param text to enter in the required input field
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void enterTextWithCheck(String expectedCondition, By locator, String text) throws TimeoutException, WaitException {
		WebElement webElement = null;
		webElement = wait.syncLocatorUsing(expectedCondition, driver, locator);
		LOGGER.info(Utilities.getCurrentThreadId() + "Clearing the content of the text box");
		webElement.clear();
		LOGGER.info(Utilities.getCurrentThreadId() + "Contents cleared");
		webElement.sendKeys(text);
		while (true) {
			if (webElement.getText().equals(text)) {
				break;
			} else {
				enterTextWithCheck(expectedCondition, locator, text);
			}

		}
		LOGGER.info(Utilities.getCurrentThreadId() + "Entered text:" + webElement.getText()
				+ " in text box with locator:" + locator);
	}

	/**
	 * Press the key mentioned by keyType on the required element
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to find the element
	 * @param keyType represents pressable keys that aren't text.
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void pressKey(String expectedCondition, By locator, Keys keyType) throws TimeoutException, WaitException {
		WebElement webElement = null;
		LOGGER.info(
				Utilities.getCurrentThreadId() + "Pressing the Keyboard Key:" + keyType + " for locator " + locator);
		webElement = wait.syncLocatorUsing(expectedCondition, driver, locator);
		webElement.sendKeys(keyType);
		LOGGER.info(Utilities.getCurrentThreadId() + "Key " + keyType + " pressed for locator:" + locator);
	}

	/**
	 * Click on the button identified by the locator. Wait for the expected condition to be true and then click
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to find the element
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void click(String expectedCondition, By locator) throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Clicking on element with locator:" + locator);
		wait.syncLocatorUsing(expectedCondition, driver, locator).click();
		LOGGER.info(Utilities.getCurrentThreadId() + "Clicked on element with locator:" + locator);
	}

	/**
	 * Click on the button identified by the locator.Wait for the given timeout and then wait for
	 * the expected condition to be true and then click on the button.
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to find the element
	 * @param timeout the length of time to sleep in milliseconds
	 * @throws TimeoutException
	 * @throws WaitException
	 * @throws InterruptedException
	 */
	public void timedClick(String expectedCondition, By locator, long timeout)
			throws TimeoutException, WaitException, InterruptedException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Clicking after " + timeout + " secs on element with locator:"
				+ locator);
		wait.waitForTimePeriod(timeout);
		wait.syncLocatorUsing(expectedCondition, driver, locator).click();
		LOGGER.info(Utilities.getCurrentThreadId() + "Clicked on element with locator:" + locator);
	}

	/**
	 * Performs a context-click at middle of the given element identified by the locator. First performs a mouseMove
	 * to the location of the element and then performs the click after waiting for the expected condition to be true.
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to find the element
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void contextClick(String expectedCondition, By locator) throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Right clicking on element with locator:" + locator);
		Actions action = new Actions(driver);
		action.contextClick(wait.syncLocatorUsing(expectedCondition, driver, locator)).perform();
		LOGGER.info(Utilities.getCurrentThreadId() + "Right click performed on element with locator:" + locator);
	}

	/**
	 * 
	 * @param element
	 */
	public void clickByJQuery(String element) {
		LOGGER.info(Utilities.getCurrentThreadId() + "Clicking on element with locator:" + element + " using JQuery");
		JavascriptExecutor executor = (JavascriptExecutor) driver;
		executor.executeScript("$('" + element + "').click()");
		LOGGER.info("Clicked on element with locator:" + element + " using JQuery");
	}

	/**
	 * If this current element is a form, or an element within a form, then this will be submitted to
     * the remote server. If this causes the current page to change, then this method will block until
     * the new page is loaded. This method will wait for the expected condition to be true before 
     * submitting the form.
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to find the element
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void submitForm(String expectedCondition, By locator) throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Submitting the form using locator:" + locator);
		wait.syncLocatorUsing(expectedCondition, driver, locator).submit();
		LOGGER.info(Utilities.getCurrentThreadId() + "Form Submitted for element:" + locator);
	}

	/**
	 * Send future commands to a different window.
	 * 
	 * @param windowTitle is the title of the page you want to switch to
	 * @throws WaitException
	 * @throws InterruptedException
	 */
	public void switchToSecondaryWindow(String windowTitle) throws WaitException, InterruptedException {
		wait.waitForTimePeriod(10000);
		LOGGER.info(Utilities.getCurrentThreadId() + "Secondary window title for switching: " + windowTitle);
		Set<String> windows = driver.getWindowHandles();
		LOGGER.info(Utilities.getCurrentThreadId() + "Windows=" + windows.toString());
		for (String strWindows : windows) {
			if (driver.switchTo().window(strWindows).getTitle().equals(windowTitle)) {
				LOGGER.info(Utilities.getCurrentThreadId() + "Switched to the window with title: "
						+ driver.switchTo().window(strWindows).getTitle());
				driver.switchTo().window(strWindows).manage().window().maximize();
				LOGGER.info(Utilities.getCurrentThreadId() + "Maximized the window with title "
						+ driver.switchTo().window(strWindows).getTitle());
				break;
			}
		}
	}

	/**
	 * Select an option
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param parentLocator used to identify the parent element
	 * @param value to be selected
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void selectOption(String expectedCondition, By parentLocator, String value) throws TimeoutException, WaitException {
		List<WebElement> element = wait.syncLocatorsUsing(expectedCondition, driver, parentLocator);
		LOGGER.info(Utilities.getCurrentThreadId() + "Size of the elements in the list=" + element.size());
		LOGGER.info(Utilities.getCurrentThreadId() + "Elements=" + element.toString());
		for (int i = 0; i < element.size(); i++) {
			String temp = element.get(i).getText().replace((char) 0x00a0, (char) 0x0020);
			if (compare.compareExactText(value, temp.trim())) {
				LOGGER.info(Utilities.getCurrentThreadId() + " " + "Clicking on option " + value);
				wait.waitForTimePeriod(2000);
				wait.syncElementUsing("clickability", driver, element.get(i)).click();
				LOGGER.info(Utilities.getCurrentThreadId() + "Successfully Clicked on option " + temp);
				break;
			}
		}
	}

	/**
	 * scrolls the current element into the visible area of the browser window.
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to identify the element
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void scrollIntoView(String expectedCondition, By locator) throws TimeoutException, WaitException {
		WebElement element = wait.syncLocatorUsing(expectedCondition, driver, locator);
		((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", element);
	}

	/**
	 * Select an item from the passed in drop down
	 * 
	 * @param expectedCondition
	 *            The condition to wait for (notrequired, visibility, clickability, presence)
	 * @param locator
	 *            The <select> tag of the drop down
	 * @param itemToSelect
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void selectFromDropDown(String expectedCondition, By locator, String itemToSelect) throws TimeoutException, WaitException
	{
		LOGGER.info(Utilities.getCurrentThreadId() + "Selecting " + itemToSelect + " from drop-down with locator:" + locator);

		WebElement element;

		if ("notrequired".equals(expectedCondition)) {
			element = driver.findElement(locator);
		} else {
			element = wait.syncLocatorUsing(expectedCondition, driver, locator);
		}

		Select select = new Select(element);
		select.selectByVisibleText(itemToSelect);

		LOGGER.info(Utilities.getCurrentThreadId() + "Selected:" + itemToSelect + " from drop-down with locator:" + element);
	}

	/**
	 * Get the visible (i.e. not hidden by CSS) innerText of this element, including sub-elements,
     * without any leading or trailing whitespace
	 * 
	 * @param expectedCondition to wait for. The conditions can be notrequired, visibility, clickability, and presence
	 * @param locator used to identify the element
	 * @return the visible text
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public String getText(String expectedCondition, By locator) throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Retrieving the TEXT of element with locator:" + locator);
		String actual;
		if ("notrequired".equals(expectedCondition)) {
			actual = driver.findElement(locator).getText();
		} else {
			actual = wait.syncLocatorUsing(expectedCondition, driver, locator).getText();
		}
		LOGGER.info(Utilities.getCurrentThreadId() + "Actual Value:" + actual);
		return actual;
	}

	/**
	 * The title of the current page.
	 *  
	 * @return The title of the current page, with leading and trailing whitespace stripped, or null
     *         if one is not already set
	 */
	public String getTitle() {
		LOGGER.info(Utilities.getCurrentThreadId() + "Title of the page:" + driver.getTitle());
		return driver.getTitle();
	}

	/**
	 * Get the value of a the given attribute of the element. Will return the current value, even if this has been modified after the page has been loaded. More exactly, this method will return the
	 * value of the given attribute, unless that attribute is not present. In which case, the value of the property with the same name is returned (for example, for the "value" property of a text area
	 * element). If neither value is set, null is returned. The "style" attribute is converted as best can be to a text representation with a trailing semi-colon. The following are deemed to be
	 * "boolean" attributes, and will return either "true" or null: async, autofocus, autoplay, checked, compact, complete, controls, declare, defaultchecked, defaultselected, defer, disabled,
	 * draggable, ended, formnovalidate, hidden, indeterminate, iscontenteditable, ismap, itemscope, loop, multiple, muted, nohref, noresize, noshade, novalidate, nowrap, open, paused, pubdate,
	 * readonly, required, reversed, scoped, seamless, seeking, selected, spellcheck, truespeed, willvalidate Finally, the following commonly mis-capitalized attribute/property names are evaluated as
	 * expected:
	 * <ul>
	 * <li>"class"
	 * <li>"readonly"
	 * </ul>
	 * 
	 * @param expectedCondition
	 *            to wait for. The conditions can be notrequired, visibility, clickability, and presence
	 * @param locator
	 *            used to identify the element
	 * @param attribute
	 *            The name of the attribute
	 * @return The attribute/property's current value or null if the value is not set.
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public String getAttributeValue(String expectedCondition, By locator, String attribute) throws TimeoutException, WaitException
	{
		String attributeValue;

		LOGGER.info(Utilities.getCurrentThreadId() + "Retrieving the attribute " + attribute + " of element " + locator);

		if ("notrequired".equals(expectedCondition)) {
			attributeValue = driver.findElement(locator).getAttribute(attribute);
		} else
		{
			attributeValue = wait.syncLocatorUsing(expectedCondition, driver, locator).getAttribute(attribute);
		}

		return attributeValue;
	}

	
	/**
	 * Get the list of the texts of all elements identified by the locator
	 * 
	 * @param expectedCondition to wait for. The conditions can be notrequired, visibility, clickability, and presence
	 * @param locator used to identify the element
	 * @return list of texts of all elements identified by the locator
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public List<String> getWebElementsTextInList(String expectedCondition, By locator) throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Coverting the locator into a List of String");

		List<WebElement> weblElementList;

		if ("notrequired".equals(expectedCondition)) {
			weblElementList = driver.findElements(locator);
		} else {
			weblElementList = wait.syncLocatorsUsing(expectedCondition, driver, locator);
		}

		LOGGER.info(Utilities.getCurrentThreadId() + "List of size=" + weblElementList.size() + " elements created");
		List<String> list = new ArrayList<String>();
		for (int i = 0; i < weblElementList.size(); i++) {
			list.add(weblElementList.get(i).getText());
		}
		LOGGER.info(Utilities.getCurrentThreadId() + "List Elements=" + list);

		return list;
	}

	/**
	 * Get visibility of the element identified by the locator
	 * 
	 * @param expectedCondition to wait for. The conditions can be notrequired, visibility, clickability, and presence
	 * @param locator used to identify the element
	 * @return true if is visible, else false
	 * @throws WaitException
	 */
	public Boolean getVisibiltyOfElementLocatedBy(String expectedCondition, By locator) throws WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Checking for Visibility of element " + locator);

		Boolean isVisible;

		if ("notrequired".equals(expectedCondition)) {
			isVisible = driver.findElement(locator).isDisplayed();
		} else {
			isVisible = wait.checkForElementVisibility(driver, locator);
		}

		Utilities.highlightElement(driver, locator);

		return isVisible;
	}

	/**
	   * Performs a modifier key press. Does not release the modifier key - subsequent interactions
	   * may assume it's kept pressed.
	   * Note that the modifier key is <b>never</b> released implicitly - either
	   * <i>keyUp(theKey)</i> or <i>sendKeys(Keys.NULL)</i>
	   * must be called to release the modifier.
	   * @param theKey Either {@link Keys#SHIFT}, {@link Keys#ALT} or {@link Keys#CONTROL}. If the
	   * provided key is none of those, {@link IllegalArgumentException} is thrown.
	   * 
	   */
	public void pressModifierKey(Keys theKey) {
		LOGGER.info(Utilities.getCurrentThreadId() + "Pressing the Keyboard Key " + theKey + " usign the Action Class");
		Actions action = new Actions(driver);
		action.keyDown(theKey);
		LOGGER.info(Utilities.getCurrentThreadId() + "Pressing the Keyboard Key " + theKey + " usign the Action Class");
	}

	/**
	   * Sends keys to the active element. This differs from calling
	   * {@link WebElement#sendKeys(CharSequence...)} on the active element in two ways:
	   * <ul>
	   * <li>The modifier keys included in this call are not released.</li>
	   * <li>There is no attempt to re-focus the element - so sendKeys(Keys.TAB) for switching
	   * elements should work. </li>
	   * </ul>
	   *
	   * @see WebElement#sendKeys(CharSequence...)
	   *
	   * @param keysToSend The keys.
	   * 
	   */
	public void pressKeys(Keys key) {
		Actions action = new Actions(driver);
		action.sendKeys(key);
	}

	/**
	 * Moves the mouse to the middle of the element. The element is scrolled into view and its clicked.
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to identify the element
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void actionClick(String expectedCondition, By locator) throws TimeoutException, WaitException {
		Actions action = new Actions(driver);
		action.moveToElement(wait.syncLocatorUsing(expectedCondition, driver, locator)).click().perform();
	}
	
	public void javascriptClick(WebElement element)
	{
		new JavascriptLibrary().callEmbeddedSelenium(driver, "triggerMouseEventAt", element, "click", "0,0");
	}
	
	public void javascriptClick(By locator)
	{
		WebElement element = driver.findElement(locator);
		if(element!=null) {
//			element.sendKeys(Keys.ENTER);
//			new Actions(driver).moveToElement(element).click().perform();
//			new JavascriptLibrary().callEmbeddedSelenium(driver, "triggerMouseEventAt", element, "click", "0,0");
			JavascriptExecutor executor = (JavascriptExecutor) driver;
			executor.executeScript("arguments[0].click();", element);
		}
	}
	
	public void sampleClick(By locator) {
		try {
			WebElement element = driver.findElement(locator);
			
			String mouseOverScript = "if(document.createEvent){var evObj = document.createEvent('MouseEvents');evObj.initEvent('mouseover',	true, false); arguments[0].dispatchEvent(evObj);} else if(document.createEventObject){ arguments[0].fireEvent('onmouseover');}";

			String onClickScript = "if(document.createEvent){var evObj = document.createEvent('MouseEvents');evObj.initEvent('click', true, false); arguments[0].dispatchEvent(evObj);} else if(document.createEventObject)	{ arguments[0].fireEvent('onclick');}";
			JavascriptExecutor js = (JavascriptExecutor) driver;
			js.executeScript(mouseOverScript, element);

			js.executeScript(onClickScript, element);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Send future commands to a different frame.
	 * 
	 * @param expectedCondition to wait for. The conditions can be visibility, clickability, and presence
	 * @param locator used to identify the element
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void switchToFrame(String expectedCondition, By locator) throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Switching to HTML frame with locator " + locator);
		driver.switchTo().frame(wait.syncLocatorUsing(expectedCondition, driver, locator));
		LOGGER.info(Utilities.getCurrentThreadId() + "Switched to frame with locator:" + locator);
	}

	/**
	 * Send future commands to either the first frame on the page, or the main document when a page contains iframes
	 * 
	 * @throws TimeoutException
	 * @throws WaitException
	 */
	public void switchToParentFrame() throws TimeoutException, WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Switching to Parent HTML Frame");
		driver.switchTo().defaultContent();
		LOGGER.info(Utilities.getCurrentThreadId() + "Switched to the Parent HTML Frame");
	}

	/**
	 * Switches to the currently active modal dialog for this particular driver instance and click on OK button
	 * 
	 * @param expectedCondition to wait for. The conditions can be notrequired, visibility, clickability, and presence
	 * @throws WaitException
	 */
	public void switchToAcceptAlert(String expectedCondition) throws WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Switching to Accept the Alert");
		try {
			if ("notrequired".equals(expectedCondition)) {
				driver.switchTo().alert().accept();
			} else {
				wait.waitForAlert(driver).accept();
			}
			LOGGER.info(Utilities.getCurrentThreadId() + "Alert Accepted");
		} catch (NoAlertPresentException ex) {
			LOGGER.info(Utilities.getCurrentThreadId() + "Alert Not Found");
		}
	}
	
	/**
	 * Switches to the currently active modal dialog for this particular driver instance and click on Cancel button
	 * 
	 * @throws WaitException
	 */
	public void switchToDismissAlert() throws WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Switching to Dismiss the Alert");
		wait.waitForAlert(driver).dismiss();
		LOGGER.info(Utilities.getCurrentThreadId() + "Alert Dismissed");
	}

	/**
	 * Get the source of the last loaded page. If the page has been modified after loading (for
     * example, by Javascript) there is no guarantee that the returned text is that of the modified
     * page. Please consult the documentation of the particular driver being used to determine whether
     * the returned text reflects the current state of the page or the text last sent by the web
     * server. The page source returned is a representation of the underlying DOM: do not expect it to
     * be formatted or escaped in the same way as the response sent from the web server. Think of it as
     * an artist's impression.
	 * 
	 * @throws WaitException
	 */
	public void getPageSource() throws WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Switching to Dismiss the Alert");
		String pageSource = driver.getPageSource();
		LOGGER.info(Utilities.getCurrentThreadId() + pageSource);
	}

	/**
	 * Get count of number of elements identified by the locator in the current page
	 * 
	 * @param expectedCondition to wait for. The conditions can be notrequired, visibility, clickability, and presence
	 * @param locator used to identify the element
	 * @return number of elements identified by the locator in the current page
	 * @throws WaitException
	 */
	public int getNumberOfElements(String expectedCondition, By locator) throws WaitException {
		LOGGER.info(Utilities.getCurrentThreadId() + "Getting Size of the List");

		List<WebElement> weblElementList;

		if ("notrequired".equals(expectedCondition)) {
			weblElementList = driver.findElements(locator);
		} else {
			weblElementList = wait.syncLocatorsUsing(expectedCondition, driver, locator);
		}

		LOGGER.info(Utilities.getCurrentThreadId() + "List of size=" + weblElementList.size() + " elements created");

		return weblElementList.size();
	}

	/**
	 * Determines if the passed element is enabled
	 * 
	 * @param locator - Used to identify the element
	 *            
	 * @return true or false depending on if the element is enabled or not
	 * 
	 * @throws WaitException
	 */
	public boolean isElementEnabledLocatedBy(By locator) throws WaitException
	{
		LOGGER.info(Utilities.getCurrentThreadId() + "Determining if element is enabled");

		return driver.findElement(locator).isEnabled();
	}

	/**
	 * Clear the passed in text box
	 * 
	 * @param expectedCondition
	 *            to wait for. The conditions can be notrequired, visibility, clickability, and presence
	 * @param locator
	 *            used to identify the element
	 * @throws WaitException
	 */
	public void clearTextBox(String expectedCondition, By locator) throws WaitException
	{
		LOGGER.info(Utilities.getCurrentThreadId() + "Clearing text box");

		wait.syncLocatorUsing(expectedCondition, driver, locator).clear();
	}

	/**
	 * Moves the mouse pointer to the passed in locator
	 * 
	 * @param expectedCondition
	 *            to wait for. The conditions can be notrequired, visibility, clickability, and presence
	 * @param locator
	 *            used to identify the element
	 * @throws WaitException
	 */
	public void moveMouseToElement(String expectedCondition, By locator) throws WaitException
	{
		LOGGER.info(Utilities.getCurrentThreadId() + "Moving the mouse pointer");

		Actions builder = new Actions(driver);
		WebElement targetElement = wait.syncLocatorUsing(expectedCondition, driver, locator);
		builder.moveToElement(targetElement);
		builder.perform();
	}

	/**
	 * Waits until the progress bar is invisible 
	 * @return
	 */
	public boolean waitUntilLoaded()
	{
		wait.waitForElementInvisible(driver, By.xpath("//md-progress-bar"));
		return false;

	}
	
	/**
	 * 
	 * @param autoItExeFileName
	 * @param fileToUploadPath
	 */
	public void fileUploadByAutoIt(String autoItExeFileName, String fileToUploadPath)
	{
		String autoItExeFilePath = System.getProperty("user.dir") + "\\AutoIt\\" + autoItExeFileName;

		System.out.println("AutoIt :: " + autoItExeFileName);

		try {
			Runtime.getRuntime().exec(autoItExeFilePath + " " + fileToUploadPath);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}