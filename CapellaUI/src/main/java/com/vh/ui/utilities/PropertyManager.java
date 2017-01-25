/**
 * 
 */
package com.vh.ui.utilities;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  PropertyManager.java
 *
 */
public class PropertyManager {

	private static final Properties FRAMEWORKPROPERTY = new Properties();
	private static final Properties APPLICATIONPROPERTY = new Properties();
	private static final String APPLICATIONPROPERTIESPATH = "resources/application.properties";
	private static final String FRAMEWORKPROPERTIESPATH = "resources/framework.properties";
	private static final Logger LOGGER = Logg.createLogger();

	private PropertyManager() {
	}

	public static Properties loadFrameworkPropertyFile(String propertyToLoad) {
		try {
			InputStream ins = new FileInputStream("resources/framework.properties");
			FRAMEWORKPROPERTY.load(ins);
			
//			System.out.println(FRAMEWORKPROPERTY.getProperty("randomMaxInteger"));
////			FRAMEWORKPROPERTY.load(PropertyManager.class
////					.getResourceAsStream(FRAMEWORKPROPERTIESPATH));
//			Thread currentThread = Thread.currentThread();
//			ClassLoader cl = currentThread.getContextClassLoader();
//			InputStream is = cl.getResourceAsStream(FRAMEWORKPROPERTIESPATH);
//			if(is!=null)
//			{
//				LOGGER.info("Hello Sudheer");
//				FRAMEWORKPROPERTY.load(is);
//			}
//			else
//			{
//				System.out.println("Null sudheer");
//			}
		} catch (IOException io) {
			LOGGER.debug(
					"IOException in the loadFrameworkPropertyFile() method of the PropertyManager class",
					io);
			Runtime.getRuntime().halt(0);
		}
		return FRAMEWORKPROPERTY;
	}

	public static Properties loadApplicationPropertyFile(String propertyToLoad) {
		try {
			InputStream ins = new FileInputStream(APPLICATIONPROPERTIESPATH);
			APPLICATIONPROPERTY.load(ins);
//			APPLICATIONPROPERTY.load(PropertyManager.class
//					.getResourceAsStream(APPLICATIONPROPERTIESPATH));
		} catch (IOException io) {
			LOGGER.debug(
					"IOException in the loadApplicationPropertyFile() method of the PropertyManager class",
					io);
			Runtime.getRuntime().halt(0);
		}
		return APPLICATIONPROPERTY;
	}
}