package com.vh.ui.page.base;

import org.apache.log4j.Logger;
import org.openqa.selenium.WebDriver;

import com.vh.ui.actions.WebActions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.pages.WebLoginPage;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.Utilities;

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
	protected String webStrTempVar;
	protected static final Logger log = Logg.createLogger();

	public WebPage(WebDriver driver) throws WaitException {
		super(driver);
		this.setDriver(driver);
		this.webActions = new WebActions(driver);
	}

	public WebPage navigateTo(String url) throws URLNavigationException,
			WaitException {
		webActions.maximizeBrowser();
		webActions.navigateToURL(url);
			log.info(Utilities.getCurrentThreadId()
					+ "Returning the instance of Village Health Login");
			return new WebLoginPage(getDriver());
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
