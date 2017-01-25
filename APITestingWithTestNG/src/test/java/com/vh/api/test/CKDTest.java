package com.vh.api.test;

import org.apache.log4j.Logger;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import com.jayway.restassured.RestAssured;
import com.jayway.restassured.path.json.JsonPath;
import com.jayway.restassured.response.Header;
import com.jayway.restassured.response.Response;
import com.vh.api.base.TestBase;
import com.vh.api.utilities.Logg;

import ru.yandex.qatools.allure.annotations.Description;
import ru.yandex.qatools.allure.annotations.Step;
import ru.yandex.qatools.allure.annotations.Title;

/**
 * @author SUBALIVADA
 * @date   Jan 11, 2017
 * @class  CKDTest.java
 *
 */
public class CKDTest extends TestBase{
	protected static final Logger log = Logg.createLogger();
	String auth;
	String url;
	@BeforeClass
	public void ckdAuthorize()
	{
		this.auth = getCKDAuthorization();
	}
	
	@Step("Validating getTermdetails api for member id {0} and reason code {1}")
	@Test(dataProvider="memDetails")
	@Title("CKD API Testing")
	@Description("In this we will test will test GetTermDetails API call")
	public void getTermDetails(String memId, String termReason)
	{
		url = "";
		url = CKD_BASE_URI;
		url = url + "/Termination/GetTermDetails?memberId=" + memId;
		log.info("Testing Get :: " +url);
	    Header header = new Header("Content-Type", "application/json");
	    Response response = RestAssured
	                .given()
	                .header("Authorization", this.auth)
	                .when()
	                .get(url);

	    int statusCode = response.statusCode();

	    Assert.assertTrue(statusCode == 200, "Status code value for " + url + " is ");
	    
	    String json = response.asString();
	    JsonPath jp = new JsonPath(json);
	    Assert.assertEquals(jp.get("TermReason"), termReason, "Term Reason value is ");
	    
	    log.info(url + " :: " + jp.get("TermReason"));
	}
	
	@DataProvider(name = "memDetails")
    public String[][] memberDetails() {
             
        return new String[][] {
                {"213544", "NERMS"},
                {"99999", "UNRCH"}
        };
    }
}
