package com.vh.api.test;

import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import com.vh.api.base.TestBase;
import com.vh.api.user.steps.UtilitySteps;

import ru.yandex.qatools.allure.annotations.Features;
import ru.yandex.qatools.allure.annotations.Stories;
import ru.yandex.qatools.allure.annotations.TestCaseId;

public class UtilityAPITest extends TestBase {
	private UtilitySteps utilitySteps; 
	private String authValue;
	
	@BeforeTest
	public void createBasicAuth()
	{
		authValue = getAuthorization();
		utilitySteps = new UtilitySteps(authValue);
	}
	

	@Features("Utility API")
	@Stories("GetMenuOfAction")
    @TestCaseId("1")
	@Test(priority=1)
	public void GetMenuOfActionTest()
	{
		try {
			utilitySteps.GetMenuOfAction();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
