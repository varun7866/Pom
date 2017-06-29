/**
 * 
 */
package com.vh.ui.web.locators;

import org.openqa.selenium.By;

/*
 * @author Harvy Ackermans
 * @date   June 29, 2017
 * @class  PatientNavigationLocators.java
 */

public class PatientNavigationLocators
{
	public static final By LBL_PLANOFCARE = By.xpath("//a[text()='Plan of Care']");
	public static final By LBL_PLANOFCAREOVERVIEW = By.xpath("//a[contains(., 'Overview')]");
}