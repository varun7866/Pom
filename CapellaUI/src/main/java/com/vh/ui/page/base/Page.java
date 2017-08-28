package com.vh.ui.page.base;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.Utilities;

import ru.yandex.qatools.allure.annotations.Attachment;

/*  
 * @author Rishi Khanna
 * @version 2.0
 * @Team:DaVita MCOE
 * @Email:rishi.khanna@davita.com
 * @Company:CitiusTech
 */
public class Page {

	protected static final String VISIBILITY = "visibility";
	protected static final String PRESENCE = "presence";
	protected static final String CLICKABILITY = "clickability";
	protected static final String NOTREQUIRED = "notrequired";
	protected static final Utilities UTIL = new Utilities();
//	protected static final Comparator COMPARE = new Comparator();
	public static final Logger LOGGER = Logg.createLogger();
	private WebDriver driver;
	
	public Page(WebDriver driver) {
		this.driver = driver; 
 	}
	
	@Attachment(value = "{0}", type = "image/png")
	public byte[] saveImageAttach(String attachName) {
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
}