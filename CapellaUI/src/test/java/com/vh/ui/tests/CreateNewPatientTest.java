package com.vh.ui.tests;

import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.CreateNewPatientPage;
import com.vh.ui.pages.WebLoginPage;

import ru.yandex.qatools.allure.annotations.Step;

/**
 * @author SUBALIVADA
 * @date   Jan 09, 2017
 * @class  CreateNewPatientTest.java
 *
 */
public class CreateNewPatientTest extends TestBase {
	WebPage pageBase;
	WebLoginPage webLoginPage;
	CreateNewPatientPage createNewPatient;
	ApplicationFunctions app;
	
	@BeforeClass
	public void init() throws WaitException
	{
		pageBase = new WebPage(getWebDriver());
		webLoginPage = new WebLoginPage(getWebDriver());
		createNewPatient = new CreateNewPatientPage(getWebDriver());
		app = new ApplicationFunctions(pageBase.getDriver());
		
	}
	
	@Test(dataProvider="dp1")
	@Step("Login to Capella")
	public void createNewPatient(Map<String, String> map) throws URLNavigationException, WaitException, InterruptedException
	{
		boolean isPass;
		//login to application
		isPass = webLoginPage.loginToCapella(applicationProperty.getProperty("webURL"), applicationProperty.getProperty("epsusername"), applicationProperty.getProperty("cpppassword"), applicationProperty.getProperty("token"));	
		if(!isPass)
		{
			Assert.fail("Failed to login to Capella");
		}
		
		//close all patients
		isPass = app.closeAllPatients();
		if(!isPass){
			Assert.fail("Failed to close all open patients");
		}
		
		createNewPatient.enterFirstName(map.get("FirstName"));			//search with first name
		createNewPatient.clickOnSearch();								//click on search
		createNewPatient.clickOnNewReferral();							//click on New Referral button
		isPass = createNewPatient.waitForReferralManagementWindow();	//wait for referral management window
		if(!isPass) {
			Assert.fail("Failed to find Referral Management Window");
		}
		
		//fill the referral management details and click on save
		createNewPatient.selectReferringPayor(map.get("ReferringPayor"));
		createNewPatient.selectDiseaseState(map.get("DiseaseState"));
		createNewPatient.selectLineOfBusiness(map.get("LineOfBusiness"));
		createNewPatient.selectServiceType(map.get("ServiceType"));
		createNewPatient.selectSource(map.get("Source"));
		createNewPatient.clickRefMgmtSaveButton();
		
		createNewPatient.enterLastName(map.get("LastName"));
		createNewPatient.enterDOB(map.get("DOB"));
		createNewPatient.enterAddress(map.get("Address"));
		createNewPatient.enterAptSuite(map.get("AptSuite"));
		createNewPatient.enterCity(map.get("City"));
		createNewPatient.selectState(map.get("State"));
		createNewPatient.enterZipCode(map.get("ZipCode"));
		
		createNewPatient.enterHomePhone(map.get("HomePhone"));
		createNewPatient.selectPrimaryPhone(map.get("PrimaryPhone"));
		createNewPatient.selectGender(map.get("Gender"));
		createNewPatient.enterPolicy(map.get("Policy"));
		
		createNewPatient.clickDemographicsSaveButton();
		
		isPass = createNewPatient.waitForChangesSavedMessageBox();
		if(!isPass) {
			Assert.fail("Failed to find Changes saved successfully message box");
		}
		
		createNewPatient.closeTheMessageBox();
		Thread.sleep(3000);
		
		if(!createNewPatient.getEnrollmentStatus().toString().equals("Referred"))
		{
			Assert.fail("Enrollment status is not as expected.");
		}
		
		System.out.println(createNewPatient.getMemberId());
	}
	
	@AfterClass
	public void tearDown() throws TimeoutException, WaitException
	{
		app.capellaLogOut();
		closeDrivers();
	}
}
