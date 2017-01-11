package com.vh.ui.comparator;

import java.util.List;

import org.apache.log4j.Logger;

import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.Utilities;

/*  
 * @author Rishi Khanna
 * @version 2.0
 * @Team:DaVita MCOE
 * @Email:rishi.khanna@davita.com
 * @Company:CitiusTech
 */
public class Comparator {

	private static final Logger LOGGER = Logg.createLogger();

	public boolean compareExactText(String actual, String expected) {
		LOGGER.info(Utilities.getCurrentThreadId() + "Actual Value=" + actual + " Expected Value="
				+ expected);
		LOGGER.info(Utilities.getCurrentThreadId() + "Result of exact comparison is "
				+ actual.equals(expected));
		return actual.equals(expected);
	}

	public boolean comparePartialText(String actual, String expected) {
		LOGGER.info(Utilities.getCurrentThreadId() + "Actual Value=" + actual + " Expected Value="
				+ expected);
		LOGGER.info(Utilities.getCurrentThreadId() + "Result of partial comparison is "
				+ actual.contains(expected));
		return actual.contains(expected);
	}

	public boolean compareListItems(List<String> actual, List<String> expected) {
		LOGGER.info(Utilities.getCurrentThreadId() + "Actual List Value=" + actual);
		LOGGER.info(Utilities.getCurrentThreadId() + "Expected List Value=" + expected);
		LOGGER.info(Utilities.getCurrentThreadId() + "Result of exact comparison is "
				+ actual.containsAll(expected));
		return ((actual.size() == expected.size()) && (actual.containsAll(expected)));
	}
}
