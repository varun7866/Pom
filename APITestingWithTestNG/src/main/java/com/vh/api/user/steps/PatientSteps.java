/**
 * 
 */
package com.vh.api.user.steps;

import org.apache.log4j.Logger;
import org.testng.Assert;
import org.testng.annotations.DataProvider;

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
 * @class  PatientSteps.java
 *
 */
public class PatientSteps extends StepsBase{
	private String userAuth;
	protected static final Logger log = Logg.createLogger();

    public PatientSteps(String userAuth) {
        this.userAuth = userAuth;
    }
    
    @Step("Testing the service : {method} with PatientUid = {0} and StartDate = {1} and EndDate = {2}")
    public void GetPtContacts(String ptUid, String startDt, String endDt) throws Exception {
		log.info(Utilities.getCurrentThreadId()
					+ "Testing GetPtContacts");
        Header header = new Header("Content-Type", "application/x-www-form-urlencodedcd");
        Response response = RestAssured
                    .given()
                    .header("Authorization", this.userAuth)
                    .header("UserId","1997")
                    .formParam("PatientUID", ptUid)
                    .formParam("StartDate", startDt)
                    .formParam("EndDate", endDt)
                    .when()
                    .post(BASE_URI + "/api/Patient/GetPtContacts");
        response.then()
        .assertThat().statusCode(200);

        int statusCode = response.statusCode();
        Assert.assertEquals(statusCode,200, "Status code ");
        
        String json = response.asString();
        JsonPath jp = new JsonPath(json);
        Assert.assertEquals(jp.get("Status"), 2, "Response status value ");
        

        log.info("GetPtContacts :: "+ response.statusCode());
	}
    
    @Step("Testing the service : {method}")
    public void GetPatientDetails() throws Exception {
		log.info(Utilities.getCurrentThreadId()
					+ "Testing GetPatientDetails");
        Header header = new Header("Content-Type", "application/x-www-form-urlencoded");
        Response response = RestAssured
                    .given()
                    .header("Authorization", this.userAuth)
//                    .header("UserId","1997")
                    .formParam("PatientUID", "203212")
                    .formParam("PtDetailFilter[]", "Demographics")
//                    .formParam("PtDetailFilter[]", "Programs")
//                    .formParam("PtDetailFilter[]", "EnrollmentDetails")
//                    .formParam("PtDetailFilter[]", "MemberIdentifiers")
//                    .formParam("PtDetailFilter[]", "PtSchedule")
//                    .formParam("PtDetailFilter[]", "PECheck")
                    .when()
                    .post(BASE_URI + "/api/Demographics/GetPatientDetails");
        response.then()
        .assertThat().statusCode(200);

        int statusCode = response.statusCode();
        Assert.assertEquals(statusCode,200, "Status code ");
        
        String json = response.asString();
        JsonPath jp = new JsonPath(json);
        Assert.assertEquals(jp.get("Status"), 2, "Response status value ");
        

        log.info("GetPatientDetails :: "+ response.statusCode());
        log.info("Status :: " +jp.get("Status"));
	}
}

