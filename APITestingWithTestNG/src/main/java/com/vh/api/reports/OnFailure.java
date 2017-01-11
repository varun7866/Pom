/**
 * 
 */
package com.vh.api.reports;

import org.testng.ITestResult;
import org.testng.TestListenerAdapter;

/**
 * @author SUBALIVADA
 * @date   Nov 6, 2016
 * @class  OnFailure.java
 *
 */
public class OnFailure extends TestListenerAdapter{
	
	@Override
	public void onTestFailure(ITestResult tr)
	{
		System.out.println("hello");
	}
}
