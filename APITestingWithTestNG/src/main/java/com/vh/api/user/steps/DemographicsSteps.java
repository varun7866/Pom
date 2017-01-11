/**
 * 
 */
package com.vh.api.user.steps;

import org.testng.Assert;

import com.jayway.restassured.RestAssured;
import com.jayway.restassured.path.json.JsonPath;
import com.jayway.restassured.response.Header;
import com.jayway.restassured.response.Response;
import com.vh.api.base.StepsBase;
import com.vh.api.utilities.Utilities;

import ru.yandex.qatools.allure.annotations.Step;

/**
 * @author SUBALIVADA
 * @date   Nov 19, 2016
 * @class  DemographicsSteps.java
 *
 */
public class DemographicsSteps extends StepsBase{
	private String userAuth;

    public DemographicsSteps(String userAuth) {
        this.userAuth = userAuth;
    }
    
    @Step("Testing the service : {method} with PatientUid = {0} and PtDetailFilter[] = {1}")
    public void GetPatientDetails(String ptUid, String ptDetailFilter) throws Exception {
		log.info(Utilities.getCurrentThreadId()
					+ "Testing GetPatientDetails");
        Header header = new Header("Content-Type", "application/x-www-form-urlencoded");
        Response response = RestAssured
                    .given()
                    .header("Authorization", this.userAuth)
                    .formParam("PatientUid", ptUid)
                    .formParam("PtDetailFilter[]", ptDetailFilter)
                    .when()
                    .post(BASE_URI + "/api/Demographics/GetPatientDetails");
        response.then()
        .assertThat().statusCode(200);
        int statusCode = response.statusCode();
        Assert.assertTrue(statusCode == 200, "Status code ");

        String json = response.asString();
        JsonPath jp = new JsonPath(json);
        Assert.assertEquals(jp.get("Status"), 2, "Response status value ");

        log.info("GetPatientDetails :: "+ response.statusCode());
	}
}
