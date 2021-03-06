/**
 * 
 */
package com.vh.ui.utilities;

import java.awt.Robot;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import ru.yandex.qatools.allure.annotations.Attachment;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  Utilities.java
 *
 */
public class Utilities {

	private static final Logger LOGGER = Logg.createLogger();
	private static final Properties FRAMEWORKPROPERTIES = PropertyManager
			.loadFrameworkPropertyFile("framework.properties");

	public static String getCurrentThreadId() {
		return "Thread:" + Thread.currentThread().getId() + "	-";
	}

	public int randomNumberGenerator() {
		LOGGER.info(Utilities.getCurrentThreadId()
				+ "Random number generator function");
		Random rand = new Random();
		LOGGER.info(Utilities.getCurrentThreadId()
				+ "Generating a random number between 0 and "
				+ FRAMEWORKPROPERTIES.getProperty("randomMaxInteger"));
		return rand.nextInt(1000);
	}

	public String convertToString(int value) {
		LOGGER.info(Utilities.getCurrentThreadId()
				+ "Integer to String Conversion function");
		LOGGER.info(Utilities.getCurrentThreadId()
				+ "Converting the Integer value " + value + " to String");
		return String.valueOf(value);
	}

	public int convertToInteger(String value) {
		LOGGER.info(Utilities.getCurrentThreadId()
				+ "String to Integer Conversion function");
		LOGGER.info(Utilities.getCurrentThreadId()
				+ "Converting the String value " + value + " to Integer");
		return Integer.parseInt(value);
	}

	public String[] convertListToStringArray(List<?> list) {
		LOGGER.info(Utilities.getCurrentThreadId()
				+ "List to String Array Conversion function");
		LOGGER.info(Utilities.getCurrentThreadId()
				+ "Size of the list obtained=" + list.size());
		Object[] obj = list.toArray();
		String[] str = new String[obj.length];
		for (int i = 0; i < obj.length; i++) {
			str[i] = (String) obj[i];
		}
		return str;
	}

	public List<String> covert2DArrayToList(String[][] array2D) {
		List<String> list = new ArrayList<String>();
		for (int i = 0; i < array2D.length; i++) {
			for (int j = 0; j < array2D[i].length; j++) {
				list.add(array2D[i][j]);
			}
		}
		return list;
	}

	public String decodeBase64String(String encodedPassword) {
		// Decode data on other side, by processing encoded data
		String originalString = new String(Base64.getDecoder().decode(
				encodedPassword.getBytes()));
		return originalString;
	}
	
	public static void highlightElement(WebDriver driver, WebElement element) 
    {
		for (int i = 0; i < 5; i++)
        {
            JavascriptExecutor js = (JavascriptExecutor) driver;
            js.executeScript("arguments[0].setAttribute('style', arguments[1]);", element, "color: red; border: 2px solid red;");
            js.executeScript("arguments[0].setAttribute('style', arguments[1]);", element, "");
        }
    }
	
	public static void highlightElement(WebDriver driver, By locator)
	{
		WebElement element = driver.findElement(locator);

		for (int i = 0; i < 1; i++)
        {
            JavascriptExecutor js = (JavascriptExecutor) driver;
            js.executeScript("arguments[0].setAttribute('style', arguments[1]);", element, "color: red; border: 2px solid red;");
            js.executeScript("arguments[0].setAttribute('style', arguments[1]);", element, "");
        }
	}
	
	@Attachment(value = "{1}", type = "image/png")
	public static byte[] captureScreenshot(WebDriver driver, String attachName) {
		LOGGER.debug("In captureScreenshot");
	    try {
	    	File screenshot;
	    	screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
	    	attachName = attachName + ".png";
	    	FileUtils.copyFile(screenshot, new File("./screenshots/" + attachName));
	    	return Files.readAllBytes(Paths.get(screenshot.getPath()));
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return new byte[0];
	}
	
	
	// public void uploadFile() throws Exception {
	// String filename = "some-file.txt";
	// File file = new File(filename);
	// String path = file.getAbsolutePath();
	// WebDriver driver = getWebDriver();
	// driver.get("http://the-internet.herokuapp.com/upload");
	// driver.findElement(By.id("file-upload")).sendKeys(path);
	// driver.findElement(By.id("file-submit")).click();
	// String text = driver.findElement(By.id("uploaded-files")).getText();
	// }
}
