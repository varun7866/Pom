package com.vh.ui.page.base;

import org.apache.log4j.Logger;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.WebActions;
import com.vh.ui.actions.WebActions4;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.pages.LoginPage;
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

public class WebPage extends Page {

	protected WebDriver driver;
	protected WebActions webActions;
	protected WebActions4 webActions4;
	protected String webStrTempVar;
	protected WebDriverWaits wait;
	protected static final Logger log = Logg.createLogger();

	public WebPage(WebDriver driver) throws WaitException {
		super(driver);
		this.setDriver(driver);
		this.webActions = new WebActions(driver);
		this.webActions4 = new WebActions4(driver);
		this.wait = new WebDriverWaits();
	}

	public WebPage navigateTo(String url) throws URLNavigationException,
			WaitException {
		webActions.maximizeBrowser();
		webActions.navigateToURL(url);
			log.info(Utilities.getCurrentThreadId()
					+ "Returning the instance of Village Health Login");
			return new LoginPage(getDriver());
	}
	
	public void quit()
	{
		getDriver().quit();
	}

	/**
	 * @return the driver
	 */
	public WebDriver getDriver() {
		return driver;
	}

	/**
	 * @param driver the driver to set
	 */
	public void setDriver(WebDriver driver) {
		this.driver = driver;
	}
}
