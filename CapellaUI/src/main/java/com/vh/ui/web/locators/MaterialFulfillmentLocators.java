package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   August 2, 2017
 * @class  ProvidersTeamLocators.java
 */

public class MaterialFulfillmentLocators
{
	public static final By BTN_ORDERMATERIAL = By.id("orderMaterialButton");
	public static final By BTN_MATERIALSPOPUP1NEXTSTEP = By.id("nextStepButton");
	public static final By BTN_MATERIALSPOPUP2DATEREQUESTED = By.xpath("//div[@class='modal-content']//label[text()='DATE REQUESTED']/..//button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_MATERIALSPOPUP2FULFILLEDON = By.xpath("//div[@class='modal-content']//label[text()='FULFILLED ON']/..//button[@class='btnpicker btnpickerenabled']");
	public static final By BTN_MATERIALSPOPUP2NEXTSTEP = By.id("nextStepButton");

	public static final By CAL_MATERIALSPOPUP2DATEREQUESTED = By.xpath("//div[@class='modal-content']//label[text()='DATE REQUESTED']/..//input");
	public static final By CAL_MATERIALSPOPUP2FULFILLEDON = By.xpath("//div[@class='modal-content']//label[text()='FULFILLED ON']/..//input");

	public static final By CBO_MATERIALSPOPUP2REQUESTEDBY = By.xpath("//div[@class='modal-content']//select[@id='equipment-type']");
	public static final By CBO_MATERIALSPOPUP2ORDERTYPE = By.xpath("//div[@class='modal-content']//select[@id='source']");
	public static final By CBO_MATERIALSPOPUP2FULFILLEDBY = By.xpath("//div[@class='modal-content']//select[@id='status']");

	public static final By CHK_MATERIALSPOPUP2FOLLOWUP = By.id("followUpCheckbox");
}