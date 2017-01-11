/**
 * 
 */
package com.vh.ui.capabilities;

import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;

import com.vh.ui.executionagent.BrowserAgent;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  WebCapabilities.java
 *
 */
public class WebCapabilities {
	private static DesiredCapabilities capabilities;

	private WebCapabilities() {
	}

	public static DesiredCapabilities setFirefoxCapability(BrowserAgent browser) {
		capabilities = DesiredCapabilities.firefox();
		capabilities.setBrowserName(browser.getBrowserName());
		capabilities.setPlatform(browser.getPlatform());
		capabilities.setVersion(browser.getVersion());
		capabilities.setJavascriptEnabled(true);
		return capabilities;
	}

	public static DesiredCapabilities setInternetExplorerCapability(
			BrowserAgent browser) {
		capabilities = DesiredCapabilities.internetExplorer();
		capabilities.setBrowserName(browser.getBrowserName());
		capabilities.setPlatform(browser.getPlatform());
		capabilities.setVersion(browser.getVersion());
		capabilities.setJavascriptEnabled(true);
		return capabilities;
	}

	public static DesiredCapabilities setChromeCapability(BrowserAgent browser) {
		ChromeOptions options = new ChromeOptions();
		options.addArguments("start-maximized", "forced-maximize-mode",
				"no-default-browser-check", "always-authorize-plugins",
				"test-type");
		capabilities = DesiredCapabilities.chrome();
		capabilities.setBrowserName(browser.getBrowserName());
		capabilities.setPlatform(browser.getPlatform());
		capabilities.setVersion(browser.getVersion());
		capabilities.setJavascriptEnabled(true);
		capabilities.setCapability(ChromeOptions.CAPABILITY, options);
		return capabilities;
	}

	public static DesiredCapabilities setSafariCapability(BrowserAgent browser) {
		capabilities = DesiredCapabilities.safari();
		capabilities.setBrowserName(browser.getBrowserName());
		capabilities.setPlatform(browser.getPlatform());
		capabilities.setVersion(browser.getVersion());
		capabilities.setJavascriptEnabled(true);
		return capabilities;
	}
}
