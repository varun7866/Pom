/**
 * 
 */
package com.vh.api.utilities;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import org.apache.log4j.Logger;

/**
 * @author SUBALIVADA
 * @date   Nov 6, 2016
 * @class  DateAndTime.java
 *
 */
public class DateAndTime {
	private static final Logger LOGGER = Logg.createLogger();

	private DateAndTime() {
	}

	/**
	 * This method generates the Current Time in the milli seconds using the
	 * System Class
	 * 
	 * @return long - current time in milli seconds
	 */
	public static long getCurrentTimeInMillis() {
		long timeInMillis = 0;
		try {
			timeInMillis = System.currentTimeMillis();
			LOGGER.info("Current Time in millis is " + timeInMillis);
		} catch (Exception ex) {
			LOGGER.error("Exception in getCurrentTimeInMillis() method of DateAndTime Class " + ex.getMessage(), ex);
		}
		return timeInMillis;
	}

	/**
	 * This method generates the Current Date And Time in the default format
	 * using the Date Object
	 * 
	 * @return String- string of Current Date And Time
	 */
	public static String getCurrentDateAndTime() {
		String dateTime = null;
		try {
			dateTime = new Date().toString();
			LOGGER.info("Current Date and Time is " + dateTime);
		} catch (Exception ex) {
			LOGGER.error("Exception in getCurrentDateAndTime() method of DateAndTime Class " + ex.getMessage(), ex);
			return null;
		}
		return dateTime;
	}

	/**
	 * This method generates formatted Current Date And Time using the Date
	 * Object and SimpleDateFormat class
	 * 
	 * @param format
	 *            - string set by the User
	 * @return String- string of Current Date And Time formatted as per the user
	 */
	public static String getFormattedCurrentDateAndTime(String format) {
		String formattedDateTime = null;
		try {
			formattedDateTime = new SimpleDateFormat(format).format(new Date());
			LOGGER.info("Formatted(" + format + ")Current Date and Time is " + formattedDateTime);

		} catch (Exception ex) {
			LOGGER.error("Exception in getFormattedCurrentDateAndTime() method of DateAndTime Class " + ex.getMessage(),
					ex);
			return null;
		}
		return formattedDateTime;
	}

	/**
	 * This method generates formatted Modified Date And Time using the Date
	 * Object and SimpleDateFormat class
	 * 
	 * @param format
	 *            - string set by the User
	 * @return String- string of Current Date And Time formatted as per the user
	 */
	public static String getFormattedModifiedDateAndTime(String format, int numberOfDaysToAdd) {
		SimpleDateFormat formattedDateTime = null;
		String modifiedDate = null;
		try {
			formattedDateTime = new SimpleDateFormat(format);
			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DATE, numberOfDaysToAdd); // number of days to add
			modifiedDate = formattedDateTime.format(c.getTime());

			LOGGER.info("Formatted(" + format + ") Modified Date and Time is " + modifiedDate);

		} catch (Exception ex) {
			LOGGER.error(
					"Exception in getFormattedModifiedDateAndTime() method of DateAndTime Class " + ex.getMessage(),
					ex);
			return null;
		}
		return modifiedDate;
	}
	
	public static Date getTimeInUTCFromString(String stringDate){
		Date date = null;
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'");
		dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
		try {
			date = dateFormat.parse(stringDate);
		}catch (Exception e){
			e.printStackTrace();
		}
		return date;
	}

	public static String getLocalizedTimeFormat(String date,String destinationTimeZone){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'");
		Date tempDate = getTimeInUTCFromString(date);
		String dateOutput = null;
		sdf.setTimeZone(TimeZone.getDefault());
		try {
			dateOutput = sdf.format(tempDate);
			System.out.println("------------->"+dateOutput);
		}catch (Exception e){
			e.printStackTrace();
		}
		return dateOutput;
	}
}