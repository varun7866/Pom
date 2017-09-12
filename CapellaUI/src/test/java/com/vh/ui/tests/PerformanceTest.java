package com.vh.ui.tests;

import java.awt.AWTException;
import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.PerformancePage;
import com.vh.ui.utilities.Utilities;

/*
 * @author Sudheer Kumar Balivada
 * @date   July 27, 2017
 * @class  PerformanceTest.java
 */
public class PerformanceTest extends TestBase {
	// Class objects
	WebDriver driver;
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	
	PerformancePage performancePage;
		
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		
		appFunctions.capellaLogin();
		
		performancePage = new PerformancePage(driver);
		performancePage.startMemoryMonitor();
		
	}
	
	@Test(dataProvider = "CapellaDataProvider")
	public void performanceTest(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException, AWTException
	{
		
		//open patient
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));
		
		Thread.sleep(3000);	
		//medical equipment
		performancePage.performanceTestMedicalEquipmentPage(map);
		
		Thread.sleep(3000);
		//add current labs
		performancePage.performanceTestCurrentLabsPage(map);
		
		Thread.sleep(3000);
		//manage documents
		performancePage.performanceTestManageDocumentsPage(map);
		
		Thread.sleep(5000);
		//Material Fulfillment
//		performancePage.performanceTestMaterialFulfillmentPage(map);
		
		Thread.sleep(3000);	
		//Providers and Team
		performancePage.performanceTestProviderTeamPage(map);
		
		Utilities.captureScreenshot(driver, map.get("PatientName"));
			
	}
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		appFunctions.capellaLogout();
		pageBase.quit();
	}
}
