package com.vh.ui.pages;

import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

/*
 * @author Harvy Ackermans
 * @date   March 29, 2017
 * @class  MyContactsPage.java
 */

public class MyContactsPage extends WebPage
{
	public MyContactsPage(WebDriver driver) throws WaitException {
		super(driver);
	}
}