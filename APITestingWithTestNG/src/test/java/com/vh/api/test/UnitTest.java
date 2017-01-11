package com.vh.api.test;

import org.testng.Assert;
import org.testng.annotations.Test;

import com.vh.api.base.TestBase;

public class UnitTest extends TestBase {
	private String authValue;
	
	@Test
	public void apiUnitTest()
	{
		String status = "null";
		Assert.assertEquals("null", status, "Response status value ");		
	}
}
