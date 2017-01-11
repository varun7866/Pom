package com.vh.api.test;

import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import com.vh.api.base.TestBase;
import com.vh.api.user.steps.PatientSteps;

import ru.yandex.qatools.allure.annotations.Features;
import ru.yandex.qatools.allure.annotations.Stories;
import ru.yandex.qatools.allure.annotations.TestCaseId;

public class PatientAPITest extends TestBase{
	private PatientSteps ptSteps; 
	private String authValue;
	
	@BeforeTest
	public void createBasicAuth()
	{
		authValue = getAuthorization();
		ptSteps = new PatientSteps(authValue);
	}
	
	@Features("Patient API")
	@Stories("Story1")
	@Test(dataProvider="ptcontacts")
    @TestCaseId("1")
	public void GetPtContactsTest(String ptUid, String startDt, String EndDt)
	{
		try {
				ptSteps.GetPtContacts(ptUid, startDt, EndDt);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	@DataProvider(name = "ptcontacts")
    public String[][] ptContacts() {
             
        return new String[][] {
                {"202937", "2016-10-19T00:00:00","2016-11-19T00:00:00"}
        };
    }
}
