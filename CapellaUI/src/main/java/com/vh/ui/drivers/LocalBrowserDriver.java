/**
 * 
 */
package com.vh.ui.drivers;

import java.util.Properties;

import org.apache.log4j.Logger;
import org.openqa.selenium.Platform;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.safari.SafariDriver;

import com.vh.ui.capabilities.WebCapabilities;
import com.vh.ui.executionagent.BrowserAgent;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.PropertyManager;
import com.vh.ui.utilities.Utilities;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  LocalBrowserDriver.java
 *
 */
public class LocalBrowserDriver {
	private static final Properties frameworkProperty = PropertyManager
			.loadFrameworkPropertyFile("framework.properties");
	private static final Logger LOGGER = Logg.createLogger();
	BrowserAgent agent = new BrowserAgent(frameworkProperty.getProperty("browserName"),
			frameworkProperty.getProperty("browserVersion"), Platform.WINDOWS);

	private LocalBrowserDriver() {

	}

	private static LocalBrowserDriver instance = new LocalBrowserDriver();

	public static LocalBrowserDriver getInstance() {
		return instance;
	}

	ThreadLocal<WebDriver> driver = new ThreadLocal<WebDriver>() {
		@Override
		protected WebDriver initialValue() {

			BrowserAgent browserAgent = (BrowserAgent) agent;

			System.out.println("Printing");
			System.out.println(browserAgent.getBrowserName());
			
			WebDriver driver = null;

			if ("internet explorer".equals(browserAgent.getBrowserName())) {
				LOGGER.info(Utilities.getCurrentThreadId() + "**Internet Explorer Browser**");
				System.setProperty("webdriver.ie.driver", "src/main/resources/drivers/IEDriverServer.exe");
				DesiredCapabilities capabilities = WebCapabilities.setInternetExplorerCapability(browserAgent);
				LOGGER.info(Utilities.getCurrentThreadId() + "Instantiating/Launching the Internet Explorer Browser");
				driver = new InternetExplorerDriver(capabilities);
			} else if ("firefox".equals(browserAgent.getBrowserName())) {
				LOGGER.info(Utilities.getCurrentThreadId() + "**FireFox Browser**");
				DesiredCapabilities capabilities = WebCapabilities.setFirefoxCapability(browserAgent);
				LOGGER.info(Utilities.getCurrentThreadId() + "Instantiating/Launching the Firefox Browser");
				driver = new FirefoxDriver(capabilities);
				driver.manage().window().maximize();
			} else if ("chrome".equals(browserAgent.getBrowserName())) {
				// `brew install chromedriver`
				LOGGER.info(Utilities.getCurrentThreadId() + "**Chrome Browser**");
				// System.setProperty("webdriver.chrome.driver",
				// "src/main/resources/com/drivers/chromedriver.exe");
				DesiredCapabilities capabilities = WebCapabilities.setChromeCapability(browserAgent);
				LOGGER.info(Utilities.getCurrentThreadId() + "Instantiating/Launching the Chrome Browser");
				driver = new ChromeDriver(capabilities);
			} else if ("safari".equals(browserAgent.getBrowserName())) {
				LOGGER.info(Utilities.getCurrentThreadId() + "**Safari Browser**");
				System.out.println();
				DesiredCapabilities capabilities = WebCapabilities.setSafariCapability(browserAgent);
				LOGGER.info(Utilities.getCurrentThreadId() + "Instantiating/Launching the Safari Browser");
				driver = new SafariDriver(capabilities);
			}
			LOGGER.info(Utilities.getCurrentThreadId() + "Returning the local instance of:" + driver.toString());
			return driver;
		}
	};

	public WebDriver getDriver() {
		return driver.get();
	}

	public void removeDriver() {
		driver.get().quit();
		driver.remove();
	}
}
