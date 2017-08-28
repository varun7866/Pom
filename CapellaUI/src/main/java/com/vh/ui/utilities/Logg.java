/**
 * 
 */
package com.vh.ui.utilities;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

/**
 * @author SUBALIVADA
 * @date   Nov 21, 2016
 * @class  Logg.java
 *
 */
public class Logg {

	private static Logger LOGGER;

	private Logg() {
	}

	/**
	 * This method creates instance of the Logger class coming from log4j jar by
	 * implementing a singelton
	 * 
	 * @return _logger - new instance if no instance exist else an existing
	 *         instance if the method is invoked previously
	 */
	public static Logger createLogger() {
		if (LOGGER == null) {
			LOGGER = LogManager.getLogger(Logg.class);
			return LOGGER;
		} else {
			return LOGGER;
		}
	}
}