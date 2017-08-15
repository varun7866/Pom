/**
 * 
 */
package com.vh.ui.excel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.openxml4j.exceptions.InvalidFormatException;

import com.vh.ui.utilities.Logg;
import com.vh.ui.utilities.PropertyManager;

/**
 * @author subalivada
 * @date   Jan 23, 2017
 * @class  ReadExcel.java
 *
 */
public class ReadExcel {
	private static final Properties EXCELRELATIVEPATH = PropertyManager
			.loadApplicationPropertyFile("application.properties");
	private static final Logger LOGGER = Logg.createLogger();
	private static String[][] storage;
	private static Sheet sheet = null;

	private ReadExcel() {
	}

	private static int getColumnCount(Sheet sheet) throws IOException {
		int colCount = 0;
		Row row = sheet.getRow(0);
		colCount = row.getPhysicalNumberOfCells();

		LOGGER.info("column count for a Row " + colCount);
		return colCount;
	}

	/**
	 * @param testClass
	 *            is the name of the test class
	 * @param testFunction
	 *            is the name of the method using the data provider
	 * @return a list of maps
	 * @throws IOException
	 */	
	public static List<Object[]> readTestData(String testClass, String testFunction) throws IOException
	{
		int rowCount;
		int colCount;
		FileInputStream file = null;
		List list = null;

		try
		{
			file = new FileInputStream(new File(EXCELRELATIVEPATH.getProperty("excelPath")));
			list = new ArrayList<Map<String, String>>();

			Workbook workbook = WorkbookFactory.create(file); // Create a Workbook instance, could be HSSF OR XSSF depending on the argument file

			sheet = workbook.getSheet(testClass); // Get given sheet from the workbook

			rowCount = sheet.getPhysicalNumberOfRows();
			colCount = getColumnCount(sheet);

			Row headerRow = sheet.getRow(0);
			Cell headerCell;

			for (int i = 1; i < rowCount; i++)
			{
				Row row = sheet.getRow(i);
				Cell cell = row.getCell(0);

				if (cell != null)
				{
					String value = getCellValue(cell);

					if(value!=null && value.equalsIgnoreCase("Y"))
					{
						if(getCellValue(row.getCell(1)).equalsIgnoreCase(testFunction)) {

							Map<String, String> map = new HashMap<String, String>();

							for (int j = 2; j < colCount; j++)
							{
								headerCell = headerRow.getCell(j);
								cell = row.getCell(j);

								if (cell != null)
								{
									map.put(getCellValue(headerCell), getCellValue(cell));//
								}
							}

							// list.add(map);
							list.add(new Object[]
							{ map });
						}
					}
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			file.close();
		}

		return list;
	}
	
	public static String[][] readTestData(String sheetName) throws IOException,
			InvalidFormatException {
		try {
			FileInputStream file = new FileInputStream(new File(EXCELRELATIVEPATH.getProperty("excelPath")));

			// Create Workbook instance , could be HSSF OR XSSF depending on the
			// argument file
			Workbook workbook = WorkbookFactory.create(file);
			// Get first sheet from the workbook
			sheet = workbook.getSheet(sheetName);
			int rowCount = sheet.getPhysicalNumberOfRows();
			int colCount = getColumnCount(sheet);
			storage = new String[rowCount][colCount];

			for (int i = 0; i < rowCount; i++) {
				Row row = sheet.getRow(i);
				for (int j = 0; j < colCount; j++) {
					Cell cell = row.getCell(j);
					if(cell!=null)
						storeValuesIn2DArray(cell, i, j);
				}
			}
			file.close();

		} catch (FileNotFoundException fException) {
			LOGGER.error("FileNotFoundException in the readTestData() method of ReadExcel Class");
			throw fException;
		} catch (NoSuchElementException noElementException) {
			LOGGER.error("NoSuchElementException in the readTestData() method of ReadExcel Class");
			throw noElementException;
		} catch (IOException ioException) {
			LOGGER.error("IOException in the readTestData() method of ReadExcel Class");
			throw ioException;
		}catch (EncryptedDocumentException edException) {
			LOGGER.error("EncryptedDocumentException in the readTestData() method of ReadExcel Class");
			throw edException;
		} catch (org.apache.poi.openxml4j.exceptions.InvalidFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return storage;
	}

	@SuppressWarnings({ "deprecation" })
	private static void storeValuesIn2DArray(Cell cell, int i, int j) {
		try
		{
			if (Cell.CELL_TYPE_NUMERIC == cell.getCellType()) {
//				LOGGER.info(Utilities.getCurrentThreadId() + "Cell Contains value "
//				+ cell.getDateCellValue());
				storage[i][j] = String.valueOf((int)Math.round(cell.getNumericCellValue()));
			} else if (Cell.CELL_TYPE_STRING == cell.getCellType()) {
//				LOGGER.info(Utilities.getCurrentThreadId() + "Cell Contains value "
//						+ cell.getStringCellValue());
				storage[i][j] = cell.getStringCellValue();
			} else if (DateUtil.isCellDateFormatted(cell)) {
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
//				LOGGER.info(Utilities.getCurrentThreadId() + "Cell Contains value "
//						+ sdf.format(cell.getDateCellValue()));
				storage[i][j] = String.valueOf(sdf.format(cell.getDateCellValue()));
			}
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	private static String getCellValue(Cell cell)
	{
		int decimalIndex;
		String value = null;
		try
		{
			if (Cell.CELL_TYPE_NUMERIC == cell.getCellType()) {
//				LOGGER.info(Utilities.getCurrentThreadId() + "Cell Contains value "
				// + cell.getDateCellValue());
				value = String.valueOf(cell.getNumericCellValue());
				decimalIndex = value.indexOf(".0");
				if (decimalIndex != -1)
				{
					value = String.valueOf((int) Math.round(cell.getNumericCellValue()));
				}
			} else if (Cell.CELL_TYPE_STRING == cell.getCellType()) {
//				LOGGER.info(Utilities.getCurrentThreadId() + "Cell Contains value "
//						+ cell.getStringCellValue());
				value = cell.getStringCellValue();
			} else if (DateUtil.isCellDateFormatted(cell)) {
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
//				LOGGER.info(Utilities.getCurrentThreadId() + "Cell Contains value "
//						+ sdf.format(cell.getDateCellValue()));
				value = String.valueOf(sdf.format(cell.getDateCellValue()));
			}
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		return value;
	}
}