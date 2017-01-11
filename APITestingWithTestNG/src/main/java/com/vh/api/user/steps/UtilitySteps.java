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
 * @date   Nov 18, 2016
 * @class  UtilitySteps.java
 *
 */
public class UtilitySteps extends StepsBase {
	private String userAuth;
	protected static final Logger log = Logg.createLogger();

    public UtilitySteps(String userAuth) {
        this.userAuth = userAuth;
    }
    
    @Step("Testing the service : {method}")
    public void GetMenuOfAction() throws Exception {
		log.error(Utilities.getCurrentThreadId()
					+ "Testing GetMenuOfAction");
        Header header = new Header("Content-Type", "application/x-www-form-urlencoded");
        Response response = RestAssured
                    .given()
                    .header("Authorization", this.userAuth)
                    .formParam("PatientUid", "202935")
                    .formParam("AppCode", "CPP")
                    .when()
                    .post(BASE_URI + "/api/Utility/GetMenuOfAction");
        response.then()
        .assertThat().statusCode(200);
        int statusCode = response.statusCode();
        Assert.assertTrue(statusCode == 200, "Status code ");

        String json = response.asString();
        JsonPath jp = new JsonPath(json);
        Assert.assertEquals(jp.get("Status"), 2, "Response status value ");

        log.info("GetMenuOfAction :: "+ response.statusCode());
	}
}
