package com.vh.api.test;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.apache.log4j.Logger;
import org.testng.Assert;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import com.jayway.restassured.RestAssured;
import com.jayway.restassured.path.json.JsonPath;
import com.jayway.restassured.response.Header;
import com.jayway.restassured.response.Response;
import com.vh.api.utilities.Logg;

import ru.yandex.qatools.allure.annotations.Step;

public class CKDTest {
	protected static final Logger log = Logg.createLogger();
	String auth;
	String url = "https://capellawebqa.com/SalesForce";
	@BeforeTest
	public void ckdAuthorize()
	{
		String userName = "testvhes1";
		String pwd = "testvhes1password";
		String appCode = " SF";
		String authString = userName + ":" + pwd + ":" + appCode;
	    byte[] message = authString.getBytes(StandardCharsets.UTF_8);
	    auth = Base64.getEncoder().encodeToString(message);
	}
	
	@Step("Validating getTermdetails api for member id {0} and reason code {1}")
	@Test(dataProvider="memDetails")
	public void getTermDetails(String memId, String termReason)
	{
		url = "";
		url = "https://capellawebqa.com/SalesForce";
		url = url + "/Termination/GetTermDetails?memberId=" + memId;
		log.info("Testing Get :: " +url);
	    Header header = new Header("Content-Type", "application/json");
	    System.out.println(auth);
	    Response response = RestAssured
	                .given()
	                .header("Authorization", "Basic " + auth)
	                .when()
	                .get(url);

	    int statusCode = response.statusCode();

	    Assert.assertTrue(statusCode == 200, "Status code value for " + url + " is ");
	    
	    String json = response.asString();
	    JsonPath jp = new JsonPath(json);
	    Assert.assertEquals(jp.get("TermReason"), termReason, "Term Reason value ");

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
