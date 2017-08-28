package com.vh.ui.pages;

import org.openqa.selenium.WebDriver;

import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;

/*
 * @author Harvy Ackermans
 * @date   March 29, 2017
 * @class  ConsolidatedPage.java
 */

public class MySchedulePage extends WebPage
{
	public MySchedulePage(WebDriver driver) throws WaitException {
		super(driver);
	}
}