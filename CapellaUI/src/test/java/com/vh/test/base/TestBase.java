package com.vh.test.base;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Method;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.testng.ITestResult;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeSuite;
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
 */

public class TestBase
{
	protected static final Properties frameworkProperty = PropertyManager
			.loadFrameworkPropertyFile("framework.properties");
	protected static final Logger log = Logg.createLogger();
	protected final static Utilities util = new Utilities();
	protected static String[][] strorage = null;
	protected final static Properties applicationProperty = PropertyManager
			.loadApplicationPropertyFile("resources/application.properties");
	WebDriver driver;

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

//	@AfterMethod(alwaysRun = true)
//	protected void afterTest(Method m, ITestResult result) throws IOException, SQLException
//	{
//		if (result.isSuccess()) {
//			log.info(Utilities.getCurrentThreadId() + "Test Case PASSED.");
//		} else if(result.getStatus() == ITestResult.FAILURE) {
//			Utilities.captureScreenshot(driver, m.getName());
//			log.info(Utilities.getCurrentThreadId() + "Test Case Failed.");
//		}
//
//		log.info(Utilities.getCurrentThreadId() + "Proceeding to close the driver for method " + m.getName());
//	}

	@Step("Launching the browser")
	public WebDriver getWebDriver() {
		driver = LocalBrowserDriver.getInstance().getDriver();
		return driver;
	}
	
	@DataProvider(name = "CapellaDataProvider")
	public Iterator<Object[]> readTestData(Method m) throws IOException
	{
		System.out.println("inside test base : Class Name = " + this.getClass().getSimpleName() + " and test method = " + m.getName());

		List<Object[]> list = ReadExcel.readTestData(this.getClass().getSimpleName(), m.getName());

		return list.iterator();
	}
	
//	@BeforeSuite
//	public void createResultsFolder() {
//		log.info("Creating Results folder...");
//		String projectRootFolder = System.getProperty("user.dir");
//		System.out.println(projectRootFolder);
//		
//		String screenshotsFolderPath = projectRootFolder + "\\screenshots";
//		File screenshotsFolder = new File(screenshotsFolderPath);
//		if(!screenshotsFolder.exists()) {
//			screenshotsFolder.mkdir();
//		}
//		
//		 String format = "yyyy-MM-dd";
//		 Date date = new Date();
//         DateFormat dateFormatter = new SimpleDateFormat(format);
//         String todaysDate = dateFormatter.format(date);
//         
//         String todaysDateFolderPath = screenshotsFolderPath + "\\" + todaysDate;
//         File todaysDateFolder = new File(todaysDateFolderPath);
//         
//         if(!todaysDateFolder.exists()) {
//        	 todaysDateFolder.mkdir();
//         }
//         
//         String timeFormat = "hh:mm:ss";
//         Calendar cal = Calendar.getInstance();
//         SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
//         String currentTime = sdf.format(cal.getTime());
//         currentTime = currentTime.replace(":", "");
//         System.out.println(currentTime);
//         String timeFolderPath = todaysDateFolderPath + "\\" + currentTime;
//         System.out.println(timeFolderPath);
//         File timeFolder = new File(timeFolderPath);
//         if(!timeFolder.exists()) {
//        	 timeFolder.mkdir();
//         }
//         
//         Utilities.setResultsFolder(timeFolderPath);
//         
//         log.info("Created results folder - " + Utilities.getResultsFolder());
//	}
}
