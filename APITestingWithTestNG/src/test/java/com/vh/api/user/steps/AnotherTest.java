package com.vh.api.user.steps;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.openxml4j.exceptions.InvalidFormatException;
import org.testng.Assert;
import org.testng.annotations.Test;

import com.jayway.restassured.RestAssured;
import com.jayway.restassured.path.json.JsonPath;
import com.jayway.restassured.response.Header;
import com.jayway.restassured.response.Response;
import com.jayway.restassured.specification.RequestSpecification;
import com.vh.api.base.TestBase;
import com.vh.api.excel.ReadExcel;
import com.vh.api.utilities.Utilities;

public class AnotherTest extends TestBase{
	
	private String[][] testData;
	private String authValue;
	
	private void verifyPostCall1(String url, Map<String, List<String>> map)
	{
		log.info("in post");
		log.info(Utilities.getCurrentThreadId() + " :: Testing " +url);
	    Header header = new Header("Content-Type", "application/x-www-form-urlencoded");
	    RequestSpecification request = RestAssured.given()
	    		.header("Authorization", this.authValue)
	    		.header("Accept", "text/plain");
	    		
	    for(String key : map.keySet())
	    {
	    	request.formParam(key, map.get(key));
	    }
	    Response response = request
	                .when()
	                .post("https://capellawebqa.com/cppapi" + url);
//	    response.then()
//	    .assertThat().statusCode(200);
	    System.out.println("hello " + response.statusCode());
	    int statusCode = response.statusCode();
//	    validateStatus(statusCode);
//	    Assert.assertTrue(statusCode == 200, "Status code ");
	    String json = response.asString();
	    JsonPath jp = new JsonPath(json);
	    System.out.println(jp.get("Status"));
	    System.out.println(jp.get("Messages.Message"));
//	    Assert.assertEquals(jp.get("Status"), 2, "Response status value ");
	
	    log.info(url + ":: "+ response.statusCode());
	}
	
	@Test(priority=1)
	private void getTestData() throws InvalidFormatException, IOException
	{
		testData = ReadExcel.readTestData("api");
	}
	
	@Test(priority=2)
	public void getAuthValue()
	{
		authValue = getAuthorization();
	}
	
	@Test(priority=3)
	private void verifyPost()
	{
		for(int i=1; i<testData.length; i++)
		{
			if(testData[i][0].equalsIgnoreCase("post"))
			{
				Map map = new HashMap<String, List<String>>();
				String url = testData[i][1]; 

				for(int j=2; j<testData[i].length; j++)
				{
					String[] val = testData[i][j].split("=");
					if(map.containsKey(val[0]))
					{
						List<String> list = (List<String>) map.get(val[0]);
						list.add(val[1]);
						map.put(val[0], list);
					}
					else
					{
						List<String> list = new ArrayList<String>();
						list.add(val[1]);
						map.put(val[0], list);
					}		
				}
				
				verifyPostCall1(url, map);
			}
		}
	}
}
