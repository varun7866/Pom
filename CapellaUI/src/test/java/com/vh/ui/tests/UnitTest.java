package com.vh.ui.tests;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.testng.annotations.Test;

import com.vh.test.base.TestBase;

public class UnitTest extends TestBase{
		
	@Test(dataProvider="dp1", priority=1)
	public void function1(Map<String, String> map) throws IOException
	{		
//		map.get("FirstName");
		Set set = map.entrySet();
		Iterator iterator = set.iterator();
	    while(iterator.hasNext()) {
	    	Map.Entry mentry = (Map.Entry)iterator.next();
	        System.out.println("function1:: key is: "+ mentry.getKey() + " & Value is: "+mentry.getValue());
	    }
	}	
	
//	@Test(dataProvider="dp1", priority=2)
//	public void function2(Map<String, String> map) throws IOException
//	{
//		Set set = map.entrySet();
//		Iterator iterator = set.iterator();
//	    while(iterator.hasNext()) {
//	    	Map.Entry mentry = (Map.Entry)iterator.next();
//	        System.out.println("function2:: key is: "+ mentry.getKey() + " & Value is: "+mentry.getValue());
//	    }
//	}	
//	
//	@Test(dataProvider="dp1", priority=3)
//	public void function3(Map<String, String> map) throws IOException
//	{
//		Set set = map.entrySet();
//		Iterator iterator = set.iterator();
//	    while(iterator.hasNext()) {
//	    	Map.Entry mentry = (Map.Entry)iterator.next();
//	        System.out.println("function3:: key is: "+ mentry.getKey() + " & Value is: "+mentry.getValue());
//	    }
//	}
}
