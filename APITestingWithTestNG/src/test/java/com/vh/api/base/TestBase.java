package com.vh.api.base;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Method;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.testng.ITestResult;
import org.testng.annotations.AfterMethod;

import com.vh.api.reader.PropertyManager;
import com.vh.api.utilities.Logg;
import com.vh.api.utilities.Utilities;

import ru.yandex.qatools.allure.annotations.Step;

public class TestBase {
	protected static final Properties frameworkProperty = PropertyManager
			.loadFrameworkPropertyFile("framework.properties");
	protected static final Logger log = Logg.createLogger();
	protected final static Utilities util = new Utilities();
	protected static String[][] strorage = null;
	protected final static Properties applicationProperty = PropertyManager
			.loadApplicationPropertyFile("application.properties");
	protected final static String BASE_URI = "https://capellawebqa.com/cppapi";
	
	@Step("Get authorization header")
	public String getAuthorization()
	{
		String authString = applicationProperty.getProperty("username") + ":" + applicationProperty.getProperty("password") + ":" + applicationProperty.getProperty("token") + ":" + applicationProperty.getProperty("appcode");
	    byte[] message = authString.getBytes(StandardCharsets.UTF_8);
	    String auth = Base64.getEncoder().encodeToString(message);
	    
	    return "Basic " + auth;
	}

	protected void logErrorMessage(Throwable ex) {
		StringWriter stw = new StringWriter();
		PrintWriter pw = new PrintWriter(stw);
		ex.printStackTrace(pw);
		log.error(stw.toString());
	}

	@AfterMethod(alwaysRun = true)
	protected void afterTest(Method m, ITestResult result) throws IOException 
	{
		if (result.isSuccess()) {
			log.info("Test Case PASSED." + m.getName());
		} else {
			log.info("Test Case Failed." + m.getName());
		}
	}
}
