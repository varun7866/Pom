package com.vh.api.test;

import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import com.vh.api.base.TestBase;
import com.vh.api.user.steps.DemographicsSteps;
import com.vh.api.user.steps.PatientSteps;

import ru.yandex.qatools.allure.annotations.Features;
import ru.yandex.qatools.allure.annotations.Stories;
import ru.yandex.qatools.allure.annotations.TestCaseId;

public class DemographicsAPITest extends TestBase{
	private DemographicsSteps demoSteps; 
	private String authValue;
	
	@BeforeTest
	public void createBasicAuth()
	{
		authValue = getAuthorization();
		demoSteps = new DemographicsSteps(authValue);
	}
	
	@Features("Demographics API")
	@Stories("GetPatientDetails")
	@Test(dataProvider="ptDetails")
    @TestCaseId("1")
	public void GetPatientDetailsTest(String ptUid, String ptDetailFilter)
	{
		try {
				demoSteps.GetPatientDetails(ptUid, ptDetailFilter);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	@DataProvider(name = "ptDetails")
    public String[][] ptDetails() {
             
        return new String[][] {
                {"147882", "Demographics"},
                {"147882", "Programs"},
                {"147882", "EnrollmentDetails"},
                {"147882", "MemberIdentifiers"},
                {"147882", "PtSchedule"},
                {"147882", "PECheck"}
        };
    }
}
