package com.vh.ui.tests;

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.CurrentLabsPage;
import com.vh.ui.pages.ManageDocumentsPage;
import com.vh.ui.pages.MedicalEquipmentPage;

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
	
	MedicalEquipmentPage medicalEquipmentPage;
	CurrentLabsPage currentLabsPage;
	ManageDocumentsPage  manageDocumentsPage;
	
	
	@BeforeClass
	public void buildUp() throws TimeoutException, WaitException, URLNavigationException, InterruptedException {
		driver = getWebDriver();
		pageBase = new WebPage(driver);
		appFunctions = new ApplicationFunctions(driver);
		
		appFunctions.capellaLogin();
		Robot r;
		try {
			r = new Robot();
			r.keyPress(KeyEvent.VK_CONTROL);
			r.keyPress(KeyEvent.VK_SHIFT);
			r.keyPress(KeyEvent.VK_U);
			r.keyRelease(KeyEvent.VK_CONTROL);
			r.keyRelease(KeyEvent.VK_SHIFT);
			r.keyRelease(KeyEvent.VK_U);
		} catch (AWTException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	@Test(dataProvider = "CapellaDataProvider")
	public void performanceTest(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException {
		String equipmentAddDay;
		boolean equipmentInUse = false;
		//open patient
		appFunctions.selectPatientFromMyPatients(map.get("PatientName"));
		//navigate to medical equipment
		appFunctions.navigateToMenu("Patient Admin->Medical Equipment");
		equipmentAddDay = appFunctions.adjustCurrentDateBy(map.get("DATE"), "d");
		
		if (map.get("EQUIPMENTINUSE").equals("Y"))
		{
			equipmentInUse = true;
		}
		
		//get medical equipment page object
		medicalEquipmentPage = new MedicalEquipmentPage(driver);
		//add medical equipment
		Thread.sleep(5000);
		medicalEquipmentPage.addMedicalEquipment(equipmentAddDay, map.get("SOURCEDROPDOWN"), map.get("EQUIPMENTTYPE"), map.get("STATUS"), equipmentInUse);
		//verify if medical equipment is added successfully in the table
		Assert.assertTrue(medicalEquipmentPage.isMedicalEquipmentInTable(map), "The Medical Equipment is not in the table");
		
		//add current labs
		//navigate to current labs
		appFunctions.navigateToMenu("Patient Experience->Labs->Current Labs");
		currentLabsPage = new CurrentLabsPage(driver);
		Assert.assertTrue(currentLabsPage.viewPageHeaderLabel(), "Failed to identify the Current Labs page header label");
		Assert.assertTrue(currentLabsPage.viewAddLabButton(), "Failed to identify the ADD LAB button");
		currentLabsPage.clickAddLabButton(); //click on add labs button
		
		if (map.get("PatientType").equals("CKD"))
		{
			currentLabsPage.populateAddPopupAllCKD(map);
		} else
		{
			if (map.get("PatientType").equals("ESRD"))
			{
				currentLabsPage.populateAddPopupAllESRD(map);
			}
		}

		currentLabsPage.clickAddPopupSaveButton();
		
		Thread.sleep(3000);
		
		//manage documents
		appFunctions.navigateToMenu("Patient Admin->Manage Documents");
		manageDocumentsPage = new ManageDocumentsPage(driver);
		manageDocumentsPage.clickAddDocumentButton();
		manageDocumentsPage.clickSelectaFileButtonAddDocument();
		manageDocumentsPage.uploadFile("FileUpload.exe", "C:\\Users\\subalivada\\Desktop\\manageddocuments\\images.jpg");
		manageDocumentsPage.addDescriptionAddDocument("Verify add document automation");
		manageDocumentsPage.selectDocumentTypeOptionAddDocument("Diabetic Retinal Eye Exam Verification");
//		Assert.assertTrue(manageDocumentsPage.isAddDocumentopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be disabled at this point");
		manageDocumentsPage.clickDateofSignaturePickerButton();
//		Assert.assertTrue(manageDocumentsPage.isDateofSignatureDateRangeValid(), "The Add Medical Equipment popup enabled DATE range is invalid");
//		manageDocumentsPage.selectDateofSignatureCurrentDateFromCalendar();
		manageDocumentsPage.clickAddButtonAddDocument();
		
		Thread.sleep(5000);
	}
	
//	@AfterClass
//	public void tearDown() throws TimeoutException, WaitException
//	{
//		appFunctions.capellaLogout();
//		pageBase.quit();
//	}
}
