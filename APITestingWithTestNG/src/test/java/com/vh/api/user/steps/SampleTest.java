package com.vh.api.user.steps;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.openxml4j.exceptions.InvalidFormatException;
import org.testng.annotations.AfterTest;
import org.testng.annotations.Test;
import org.testng.asserts.SoftAssert;

import com.jayway.restassured.RestAssured;
import com.jayway.restassured.path.json.JsonPath;
import com.jayway.restassured.response.Header;
import com.jayway.restassured.response.Response;
import com.jayway.restassured.specification.RequestSpecification;
import com.vh.api.base.TestBase;
import com.vh.api.excel.ReadExcel;
import com.vh.api.utilities.Utilities;

import ru.yandex.qatools.allure.annotations.Description;
import ru.yandex.qatools.allure.annotations.Step;
import ru.yandex.qatools.allure.annotations.Title;

public class SampleTest  extends TestBase{
	private String authValue;
	String BASE_URI = "https://capellawebqa.com/cppapi";
	SoftAssert sAssert = new SoftAssert();
	
	@Title("CPP API Testing")
	@Description("In this we will test all api calls")
	@Test
	public void validateAllApiCalls()
	{
		validateTheCalls();
	}
	
	public void validateTheCalls()
	{
		authValue = getAuthorization();
		try {
			getTestData();
		} catch (InvalidFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@Step("Read each input row")
	private void getTestData() throws InvalidFormatException, IOException
	{
		String[][] testData = ReadExcel.readTestData("api");
		for(int i=1; i<testData.length; i++)
		{
			if(testData[i][0].equalsIgnoreCase("get"))
			{
				String params = "?";
				
				for(int j=2; j<testData[i].length; j++)
				{
					if(testData[i][j]!=null)
						params = params.concat(testData[i][j]).trim().concat("&");
				}
				
				params = params.substring(0, params.length()-1);
				String url = testData[i][1].trim().concat(params);
				verifyGetCall(url);
			}
			else if(testData[i][0].equalsIgnoreCase("post"))
			{
				Map map = new HashMap<String, List<String>>();
				String url = testData[i][1]; 

				for(int j=2; j<testData[i].length; j++)
				{
					if(testData[i][j]!=null)
					{
						String[] val = testData[i][j].trim().split("=");
						if(map.containsKey(val[0]))
						{
							List<String> list = (List<String>) map.get(val[0].trim());
							list.add(val[1].trim());
							map.put(val[0].trim(), list);
						}
						else
						{
							List<String> list = new ArrayList<String>();
							list.add(val[1].trim());
							map.put(val[0].trim(), list);
						}
					}
				}
				
				verifyPostCall(url, map);
			}
		}
	}
	
	
	@Step("Testing the get service call : {0}")
	private void verifyGetCall(String url)
	{
		log.info("Testing Get :: " +url);
	    Header header = new Header("Content-Type", "application/x-www-form-urlencoded");
	    Response response = RestAssured
	                .given()
	                .header("Authorization", this.authValue)
	                .when()
	                .get(BASE_URI + url);

	    int statusCode = response.statusCode();

	    sAssert.assertTrue(statusCode == 200, "Status code ");
	    String json = response.asString();
	    JsonPath jp = new JsonPath(json);
	    sAssert.assertEquals(jp.get("Status"), 2, "Response status value for " + url + " is ");
	    log.info(url + " :: " + response.statusCode());
	}
	
	@Step("Testing the post service call : {0}")
	private void verifyPostCall(String url, Map<String, ArrayList<String>> formParams)
	{
		log.info("Testing Post :: " +url);
	    Header header = new Header("Content-Type", "application/x-www-form-urlencoded");
	    RequestSpecification request = RestAssured.given()
	    		.header("Authorization", this.authValue)
	    		.header("Accept", "text/plain");
	    		
	    for(String key : formParams.keySet())
	    {
	    	request.formParam(key, formParams.get(key));
	    }
	    
	    Response response = request
	                .when()
	                .post("https://capellawebqa.com/cppapi" + url);

	    int statusCode = response.statusCode();
	    sAssert.assertTrue(statusCode == 200, "Status code ");
	    String json = response.asString();
	    JsonPath jp = new JsonPath(json);
	    sAssert.assertEquals(jp.get("Status"), 2, "Response status value for " + url + " is ");
	
	    log.info(url + ":: "+ response.statusCode());
	}
	
	@AfterTest
	private void tearDown()
	{
		sAssert.assertAll();
	}
}
