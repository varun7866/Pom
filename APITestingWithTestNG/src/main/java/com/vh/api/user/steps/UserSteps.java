/**
 * 
 */
package com.vh.api.user.steps;

import org.apache.log4j.Logger;
import org.testng.Assert;

import com.jayway.restassured.RestAssured;
import com.jayway.restassured.path.json.JsonPath;
import com.jayway.restassured.response.Header;
import com.jayway.restassured.response.Response;
import com.vh.api.base.StepsBase;
import com.vh.api.utilities.Logg;
import com.vh.api.utilities.Utilities;

import ru.yandex.qatools.allure.annotations.Step;

/**
 * @author SUBALIVADA
 * @date   Nov 6, 2016
 * @class  UserSteps.java
 *
 */
public class UserSteps extends StepsBase{
	private String userAuth;
	protected static final Logger log = Logg.createLogger();

    public UserSteps(String userAuth) {
        this.userAuth = userAuth;
    }
    
    @Step("Testing the service : {method}")
    public void GetTeamUsersAll() throws Exception {
		log.error(Utilities.getCurrentThreadId()
					+ "Testing GetTeamUsersAll");
        Header header = new Header("Content-Type", "application/x-www-form-urlencodedcd");
        Response response = RestAssured
                    .given()
                    .header("Authorization", this.userAuth)
                    .param("capellaUserUID", "2015")
                    .when()
                    .get(BASE_URI + "/api/User/GetTeamUsersAll");
        response.then()
        .assertThat().statusCode(200);
        int statusCode = response.statusCode();
        Assert.assertTrue(statusCode == 200, "Status code ");

        String json = response.asString();
        JsonPath jp = new JsonPath(json);
        Assert.assertEquals(jp.get("Status"), 2, "Response status value ");

        log.info("GetTeamUsersAll :: "+ response.statusCode());
	}
    
    @Step("Testing the service : {method}")
	public void GetVHNChartMetricData()  throws Exception {
		log.info("REQUEST");
        Header header = new Header("Content-Type", "application/x-www-form-urlencoded");
        Response response = RestAssured
                    .given()
                    .header("Authorization", this.userAuth)
                    .header("UserId", "2015")
                    .when()
                    .post(BASE_URI + "/api/User/GetVHNChartMetricData");
//        response.then().assertThat().statusCode(200);
        
        int statusCode = response.statusCode();
        Assert.assertEquals(statusCode, 200,"Status code ");
        String json = response.asString();
        JsonPath jp = new JsonPath(json);
        Assert.assertEquals(jp.get("Status"), 2, "Response status value ");
        
        log.info("GetVHNChartMetricData :: "+ response.statusCode());
	}
    
    public void savePatientAllergy() throws Exception {
		log.info(Utilities.getCurrentThreadId()
					+ "Testing SavePatienttAllergy");
        Header header = new Header("Content-Type", "application/x-www-form-urlencodedcd");
        Response response = RestAssured
                    .given()
                    .header("Authorization", this.userAuth)
                    .param("DataState", "Added")
                    .param("PatientUID", "147288")
                    .param("AllergyName", "Eggs+or+Egg-derived+Products")
                    .when()
                    .get(BASE_URI + "/api/Clinical/SavePatienttAllergy");
        response.then()
        .assertThat().statusCode(200);
        
        int statusCode = response.statusCode();
        Assert.assertTrue(statusCode == 200, "Status code ");
        String json = response.asString();
        JsonPath jp = new JsonPath(json);
        Assert.assertEquals(jp.get("Status"), 2, "Response status value ");

        log.info("SavePatienttAllergy :: "+ response.statusCode());
	}
}