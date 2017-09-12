package com.vh.ui.pages;

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.util.Map;

import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.testng.Assert;

import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

public class PerformancePage extends WebPage {

	ApplicationFunctions appFunctions;
	
	MedicalEquipmentPage medicalEquipmentPage;
	CurrentLabsPage currentLabsPage;
	ManageDocumentsPage  manageDocumentsPage;
	MaterialFulfillmentPage materialFulfillmentPage;
	ProvidersTeamPage providersTeamPage;
	
	public PerformancePage(WebDriver driver) throws WaitException {
		super(driver);
		
		appFunctions = new ApplicationFunctions(driver);
	}
	
	public void startMemoryMonitor() {
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e1) {
			e1.printStackTrace();
		}
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
			e.printStackTrace();
		}
	}
	
	public void performanceTestMedicalEquipmentPage(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException {
		//navigate to medical equipment
		appFunctions.navigateToMenu("Patient Admin->Medical Equipment");
		
		String equipmentAddDay;
		boolean equipmentInUse = false;
		
		equipmentAddDay = appFunctions.adjustCurrentDateBy(map.get("EQUIPMENTDATE"), "d");
		
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
		
	}
	
	public void performanceTestCurrentLabsPage(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException, AWTException
	{
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
	}

	public void performanceTestManageDocumentsPage(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException {
		appFunctions.navigateToMenu("Patient Admin->Manage Documents");
		manageDocumentsPage = new ManageDocumentsPage(driver);
		manageDocumentsPage.clickAddDocumentButton();
		manageDocumentsPage.clickSelectaFileButtonAddDocument();
		Thread.sleep(3000);
		manageDocumentsPage.uploadFile("FileUpload.exe", "C:\\Users\\subalivada\\Desktop\\manageddocuments\\images.jpg");
		manageDocumentsPage.addDescriptionAddDocument("Verify add document automation");
		manageDocumentsPage.selectDocumentTypeOptionAddDocument("Diabetic Retinal Eye Exam Verification");
//		Assert.assertTrue(manageDocumentsPage.isAddDocumentopupAddButtonEnabled(), "The Add Medical Equipment popup ADD button should not be disabled at this point");
		manageDocumentsPage.clickDateofSignaturePickerButton();
//		Assert.assertTrue(manageDocumentsPage.isDateofSignatureDateRangeValid(), "The Add Medical Equipment popup enabled DATE range is invalid");
//		manageDocumentsPage.selectDateofSignatureCurrentDateFromCalendar();
		manageDocumentsPage.clickAddButtonAddDocument();
	}
	
	public void performanceTestMaterialFulfillmentPage(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException {
		appFunctions.navigateToMenu("Patient Admin->Material Fulfillment");

		materialFulfillmentPage = new MaterialFulfillmentPage(driver);
		materialFulfillmentPage.orderMaterial(map);
	}
	
	public void performanceTestProviderTeamPage(Map<String, String> map) throws TimeoutException, WaitException, InterruptedException {
		appFunctions.navigateToMenu("Patient Care->Care Team");
		Thread.sleep(10000);
		providersTeamPage = new ProvidersTeamPage(driver);
		providersTeamPage.addAProvider(map);
		
		Thread.sleep(5000);

		providersTeamPage.addATeamMember(map);
	}
}
