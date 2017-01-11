/**
 * 
 */
package com.vh.ui.executionagent;

import org.openqa.selenium.Platform;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  BrowserAgent.java
 *
 */
public class BrowserAgent {
	private String name;
	private String version;
	private Platform platform;

	public BrowserAgent(String name, String version, Platform platform) {
		this.name = name;
		this.platform = platform;
		this.version = version;
	}

	public String getBrowserName() {
		return name;
	}

	public Platform getPlatform() {
		return platform;
	}

	public String getVersion() {
		return version;
	}
}
