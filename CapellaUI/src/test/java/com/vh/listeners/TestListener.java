package com.vh.listeners;

import org.apache.log4j.Logger;
import org.testng.IInvokedMethod;
import org.testng.IInvokedMethodListener;
import org.testng.ISuite;
import org.testng.ISuiteListener;
import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

import com.vh.test.base.TestBase;
import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.Utilities;

public class TestListener implements ITestListener, ISuiteListener, IInvokedMethodListener {

	private static final Logger LOGGER = Logg.createLogger();
	
	// This belongs to ITestListener and will execute before the main test start (@Test)
	public void onTestStart(ITestResult result) {
		LOGGER.info("In onTestStart...");
	}

	// This belongs to ITestListener and will execute only when the test is pass
	public void onTestSuccess(ITestResult result) {
		LOGGER.info(Utilities.getCurrentThreadId() + "Test Case PASSED.");
	}

	// This belongs to ITestListener and will execute only on the event of fail test
	public void onTestFailure(ITestResult result) {
		String className = result.getTestClass().getRealClass().getSimpleName();
		Utilities.createCurrentTestResultsFolder(className);
		System.out.println("Method name :: " + className + " :: " + result.getMethod().getMethodName());
		Utilities.captureScreenshot(((TestBase)result.getInstance()).getWebDriver(), result.getMethod().getMethodName());
		LOGGER.info(Utilities.getCurrentThreadId() + "Test Case Failed.");
	}

	// This belongs to ITestListener and will execute only if any of the main test(@Test) get skipped
	public void onTestSkipped(ITestResult result) {
	}

	// not required. ignore this
	public void onTestFailedButWithinSuccessPercentage(ITestResult result) {
	}

	// This belongs to ITestListener and will execute before starting of Test set/batch 
	public void onStart(ITestContext context) {
		LOGGER.info("onStart of Test...");		
	}

	// This belongs to ITestListener and will execute, once the Test set/batch is finished
	public void onFinish(ITestContext context) {		
	}

	// This belongs to ISuiteListener and will execute before the Suite start
	public void onStart(ISuite suite) {
		LOGGER.info("In onStart of Suite");
		Utilities.createResultsFolder();
	}

	// This belongs to ISuiteListener and will execute, once the Suite is finished
	public void onFinish(ISuite suite) {
	}

	// This belongs to IInvokedMethodListener and will execute before every method including @Before @After @Test
	public void beforeInvocation(IInvokedMethod method, ITestResult testResult) {
	}

	// This belongs to IInvokedMethodListener and will execute after every method including @Before @After @Test
	public void afterInvocation(IInvokedMethod method, ITestResult testResult) {
	}
}
