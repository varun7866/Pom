/**
 * 
 */
package com.vh.test.base;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.testng.ITestResult;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.DataProvider;

import com.vh.ui.drivers.LocalBrowserDriver;
import com.vh.ui.excel.ReadExcel;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.PropertyManager;
import com.vh.ui.utilities.Utilities;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  TestBase.java
 *
 */

public class TestBase {
	protected static final Properties frameworkProperty = PropertyManager
			.loadFrameworkPropertyFile("framework.properties");
	protected static final Logger log = Logg.createLogger();
	protected final static Utilities util = new Utilities();
	protected static String[][] strorage = null;
	protected final static Properties applicationProperty = PropertyManager
			.loadApplicationPropertyFile("resources/application.properties");
	WebDriver driver;

//	@DataProvider(name = "ReadExcel")
//	public String[][] readDataFromExcel(Method m) throws Exception {
//		log.info(Utilities.getCurrentThreadId() + "Data Provider: Read Excel");
//		log.info(Utilities.getCurrentThreadId() + "Data Provider: Running for Method: " + m.getName());
//		if ("smokeTest3".equals(m.getName())) {
//			strorage = ReadExcel.readTestData("Patients");
//			log.info(Utilities.getCurrentThreadId()
//					+ "Data Provider: Retrieved data from the Patients Sheet of Test Data Excel");
//		} else if ("".equals(m.getName())) {
//			strorage = ReadExcel.readTestData("Sheet2");
//		} else {
//			log.info(Utilities.getCurrentThreadId()
//					+ "NO MATCHING METHOD FOUND. PLEASE CHECK THE METHOD NAME IN THE DATA PROVIDER");
//		}
//		return strorage;
//	}

	protected void logErrorMessage(Throwable ex) {
		StringWriter stw = new StringWriter();
		PrintWriter pw = new PrintWriter(stw);
		ex.printStackTrace(pw);
		log.error(stw.toString());
	}

	protected void closeDrivers() {
		if ("local".equals(frameworkProperty.getProperty("executionType"))) {
			log.info(Utilities.getCurrentThreadId() + "Closing the Local Browser driver");
			LocalBrowserDriver.getInstance().removeDriver();
		}
	}

	@AfterMethod(alwaysRun = true)
	protected void afterTest(Method m, ITestResult result) throws IOException {

		if (result.isSuccess()) {
			log.info(Utilities.getCurrentThreadId() + "Test Case PASSED.");
		} else if(result.getStatus() == ITestResult.FAILURE) {
			Utilities.captureScreenshot(driver, m.getName());
			log.info(Utilities.getCurrentThreadId() + "Test Case Failed.");
		}
		log.info(Utilities.getCurrentThreadId() + "Proceeding to close the driver for method " + m.getName());
	}

//	@Step("Launching the mobile app")
//	protected AppiumDriver<MobileElement> getMobileDriver() {
//
//		if ("Android".equals(AppConfig.getPlatform())) {
//			log.info(Utilities.getCurrentThreadId() + "Getting the Android mobile driver");
//			return AppiumAndroidDriver.getInstance().getDriver();
//		} else if ("iOS".equals(AppConfig.getPlatform())) {
//			log.info(Utilities.getCurrentThreadId() + "Getting the iOS mobile driver");
//			return AppiumiOSDriver.getInstance().getDriver();
//		} else {
//			log.warn(Utilities.getCurrentThreadId() + "Platform name not set. Set it in the framework.properties file");
//			return null;
//		}
//	}
//
	@Step("Launching the browser")
	protected WebDriver getWebDriver() {
		driver = LocalBrowserDriver.getInstance().getDriver();
		return driver;
	}
	
	@DataProvider(name="dp1")
	public Iterator<Object[]> readTestData(Method m) throws IOException
	{
		System.out.println("inside test base : Class Name = " + this.getClass().getSimpleName() + " and test method = " + m.getName());
		List list = ReadExcel.readTestData(this.getClass().getSimpleName(), m.getName());		
		return list.iterator();
	}
}