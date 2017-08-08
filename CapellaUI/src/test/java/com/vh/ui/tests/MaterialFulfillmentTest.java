package com.vh.ui.tests;

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
import com.vh.ui.pages.MaterialFulfillmentPage;

import ru.yandex.qatools.allure.annotations.Step;

/*
 * @author Harvy Ackermans
 * @date   August 7, 2017
 * @class  MaterialFulfillmentTest.java
 * 
 * Before running this test suite:
 *
 */

public class MaterialFulfillmentTest extends TestBase
{	
	// Class objects
	WebPage pageBase;
	ApplicationFunctions appFunctions;
	MaterialFulfillmentPage materialFulfillmentPage;
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		WebDriver driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		materialFulfillmentPage = new MaterialFulfillmentPage(driver);

		appFunctions.capellaLogin();
		// appFunctions.selectPatientFromMyPatients("Glayds Whoriskey");
		// appFunctions.navigateToMenu("Patient Admin->Material Fulfillment");
	}

	@Test(priority = 2, dataProvider = "CapellaDataProvider")
	@Step("Verify Ordering a Material with different scenarios")
	public void verify_OrderingMaterial(Map<String, String> map) throws WaitException, URLNavigationException, InterruptedException
	{
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));

		appFunctions.navigateToMenu("Patient Admin->Material Fulfillment");

		materialFulfillmentPage.orderMaterial(map);
	}

	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		// appFunctions.capellaLogout();
		// pageBase.quit();
	}
}
