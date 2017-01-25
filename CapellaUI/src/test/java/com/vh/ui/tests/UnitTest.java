package com.vh.ui.tests;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.openqa.selenium.TimeoutException;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import com.vh.test.base.TestBase;
import com.vh.ui.actions.ApplicationFunctions;
import com.vh.ui.excel.ReadExcel;
import com.vh.ui.exceptions.URLNavigationException;
import com.vh.ui.exceptions.WaitException;
import com.vh.ui.page.base.WebPage;
import com.vh.ui.pages.WebLoginPage;
import com.vh.ui.pages.WebMyDashboardPage;

import ru.yandex.qatools.allure.annotations.Step;

public class UnitTest extends TestBase{
		
	@Test(dataProvider="dp1")
	public void excelReadTest(Map<String, String> map) throws IOException
	{
	
//		map.get("FirstName");
		Set set = map.entrySet();
		Iterator iterator = set.iterator();
	    while(iterator.hasNext()) {
	    	Map.Entry mentry = (Map.Entry)iterator.next();
	        System.out.println("key is: "+ mentry.getKey() + " & Value is: "+mentry.getValue());
	    }
	}	
}
