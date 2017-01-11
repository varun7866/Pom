package com.vh.api.test;

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

import ru.yandex.qatools.allure.annotations.Description;
import ru.yandex.qatools.allure.annotations.Step;
import ru.yandex.qatools.allure.annotations.Title;

public class APITest   extends TestBase{
	private String authValue;
	
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
			e.printStackTrace();
		}
	}
	
	@Step("Read each input row")
	private void getTestData() throws InvalidFormatException, IOException
	{
		String[][] testData = ReadExcel.readTestData("api");
		String status = "2";
		try
		{
		
			for(int i=1; i<testData.length; i++)
			{
				if(testData[i][0].equalsIgnoreCase("get"))
				{
					String params = "?";
					
					for(int j=2; j<testData[i].length; j++)
					{
						if(testData[i][j]!=null && !testData[i][j].isEmpty())
						{
							if(testData[i][j].trim().contains("status"))
							{
								status = testData[i][j].split("=")[1];
							}
							else
							{
								params = params.concat(testData[i][j]).trim().concat("&");
							}
						}
					}
					
					params = params.substring(0, params.length()-1);
					String url = testData[i][1].trim().concat(params);
					verifyGetCall(url, status);
				}
				else if(testData[i][0].equalsIgnoreCase("post"))
				{
					Map map = new HashMap<String, List<String>>();
					String url = testData[i][1]; 
	
					for(int j=2; j<testData[i].length; j++)
					{
						if(testData[i][j]!=null && !testData[i][j].isEmpty())
						{
							String[] val = testData[i][j].trim().split("=");
							if(val.length == 1)
							{
								List<String> list = new ArrayList<String>();
								list.add(val[0]);
								map.put("", list);
							}
							else
							{
								if(map.containsKey(val[0]) && !val[0].equalsIgnoreCase("status"))
								{
									List<String> list = (List<String>) map.get(val[0].trim());
									list.add(val[1].trim());
									map.put(val[0].trim(), list);
								}
								else if(!val[0].equalsIgnoreCase("status"))
								{
									List<String> list = new ArrayList<String>();
									list.add(val[1].trim());
									map.put(val[0].trim(), list);
								}
								else if(val[0].equalsIgnoreCase("status"))
								{
									status = val[1];
								}
							}
						}
					}
					
					verifyPostCall(url, map, status);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	
	@Step("Testing the get service call : {0}")
	private void verifyGetCall(String url, String status)
	{
		log.info("Testing Get :: " +url);
	    Header header = new Header("Content-Type", "application/x-www-form-urlencoded");
	    Response response = RestAssured
	                .given()
	                .header("Authorization", this.authValue)
	                .when()
	                .get(BASE_URI + url);

	    int statusCode = response.statusCode();

	    sAssert.assertTrue(statusCode == 200, "Status code value for " + url + " is ");
	    
	    String json = response.asString();
	    JsonPath jp = new JsonPath(json);
	    if(jp.get("Status")!=null)
	    	sAssert.assertEquals(jp.get("Status").toString(), status, "Response status value for " + url + " is ");
	    else
	    	sAssert.assertEquals(jp.get("Status"), null, "Response status value for " + url + " is ");
	    log.info(url + " :: " + response.statusCode());
	}
	
	@Step("Testing the post service call : {0}")
	private void verifyPostCall(String url, Map<String, ArrayList<String>> formParams, String status)
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
	    sAssert.assertTrue(statusCode == 200, "Status code value for " + url + " is ");
	    String json = response.asString();
//	    System.out.println(json);
	    JsonPath jp = new JsonPath(json);
	    if(jp.get("Status")!=null)
	    	sAssert.assertEquals(jp.get("Status").toString(), status, "Response status value for " + url + " is ");
	    else
	    	sAssert.assertEquals(jp.get("Status"), null, "Response status value for " + url + " is ");
	
	    log.info(url + ":: "+ response.statusCode());
	}
	
	@AfterTest
	private void tearDown()
	{
		sAssert.assertAll();
	}
}
