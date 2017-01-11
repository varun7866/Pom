package com.vh.api.test;

import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import com.vh.api.base.TestBase;
import com.vh.api.user.steps.UserSteps;

import ru.yandex.qatools.allure.annotations.Features;
import ru.yandex.qatools.allure.annotations.Stories;
import ru.yandex.qatools.allure.annotations.TestCaseId;

public class UserAPITest extends TestBase{
	
	private UserSteps userSteps; 
	private String authValue;
	
	@BeforeTest
	public void createBasicAuth()
	{
		authValue = getAuthorization();
		userSteps = new UserSteps(authValue);
	}
	

	@Features("User API")
	@Stories("GetTeamUsersAll")
    @TestCaseId("1")
	@Test(priority=1)
	public void GetTeamUsersAllTest()
	{
		try {
			userSteps.GetTeamUsersAll();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Features("User API")
	@Stories("GetVHNChartMetricData")
    @TestCaseId("2")
	@Test(priority=2)
	public void GetVHNChartMetricDataTest()
	{
		try {
			userSteps.GetVHNChartMetricData();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
