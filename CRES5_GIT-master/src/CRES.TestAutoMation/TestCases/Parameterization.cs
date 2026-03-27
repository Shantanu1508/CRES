using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using x1 = Microsoft.Office.Interop.Excel;

namespace CRES.TestAutoMation.TestCases
{
    internal class Parameterization
    {
        //..........................New Excel................................
        x1.Application xlApp = null;
        x1.Workbooks workbooks = null;
        x1.Workbook workbook = null;
        Hashtable sheets;
        public string xlFilePath;

        public Parameterization(string xlFilePath)
        {
            this.xlFilePath = xlFilePath;
        }

        public void OpenExcel()
        {
            xlApp = new x1.Application();
            workbooks = xlApp.Workbooks;
            workbook = workbooks.Open(xlFilePath);
            sheets = new Hashtable();

            int count = 1;

            // To store worksheet name to HashTable
            foreach (x1.Worksheet sheet in workbook.Sheets)
            {
                sheets[count] = sheet.Name;
                count++;
            }
        }
        public void CloseExcel()
        {
            workbook.Close(false, xlFilePath, null);
            Marshal.FinalReleaseComObject(workbook);
            workbook = null;

            workbooks.Close();
            Marshal.FinalReleaseComObject(workbooks);
            workbooks = null;

            xlApp.Quit();
            Marshal.FinalReleaseComObject(xlApp);
            xlApp = null;
        }

        public int GetRowCount(string sheetName)
        {
            OpenExcel();
            int rowCount = 0;
            int sheetValue = 0;

            if (sheets.Contains(sheetName))
            {
                foreach (DictionaryEntry sheet in sheets)
                {
                    if (sheet.Value.Equals(sheetName))
                    {
                        sheetValue = (int)sheet.Key;
                    }
                }
                // Getting particular worksheet using index/key froom workbook
                x1.Worksheet worksheet = workbook.Worksheets[sheetValue] as x1.Worksheet;
                x1.Range range = worksheet.UsedRange; // Range of Cells wich are having content.
                rowCount = range.Rows.Count;
            }
            CloseExcel();
            return rowCount;
        }

        public int GetColumnCount(string sheetName)
        {
            OpenExcel();
            int columnCount = 0;
            int sheetValue = 0;

            if (sheets.Contains(sheetName))
            {
                foreach (DictionaryEntry sheet in sheets)
                {
                    if (sheet.Value.Equals(sheetName))
                    {
                        sheetValue = (int)sheet.Key;
                    }
                }
                // Getting particular worksheet using index/key froom workbook
                x1.Worksheet worksheet = workbook.Worksheets[sheetValue] as x1.Worksheet;
                x1.Range range = worksheet.UsedRange; // Range of Cells wich are having content.
                columnCount = range.Rows.Count;
            }
            CloseExcel();
            return columnCount;
        }

        public string GetCellData(string sheetName, int colNumm, int rowNum)
        {
            OpenExcel();
            string Value = string.Empty;
            int sheetValue = 0;

            if (sheets.Contains(sheetName))
            {
                foreach (DictionaryEntry sheet in sheets)
                {
                    if (sheet.Value.Equals(sheetName))
                    {
                        sheetValue = (int)sheet.Key;
                    }
                }
                // Getting particular worksheet using index/key froom workbook
                x1.Worksheet worksheet = null;
                worksheet = workbook.Worksheets[sheetValue] as x1.Worksheet;
                x1.Range range = worksheet.UsedRange; // Range of Cells wich are having content.

                Value = Convert.ToString((range.Cells[rowNum, colNumm] as x1.Range).Value2);
                Marshal.FinalReleaseComObject(worksheet);
                worksheet = null;
            }
            CloseExcel();
            return Value;
        }

        public string GetCellData(string sheetName, string colName, int rowNum)
        {
            OpenExcel();
            string Value = string.Empty;
            int sheetValue = 0;
            int colNum = 0;

            if (sheets.Contains(sheetName))
            {
                foreach (DictionaryEntry sheet in sheets)
                {
                    if (sheet.Value.Equals(sheetName))
                    {
                        sheetValue = (int)sheet.Key;
                    }
                }
                // Getting particular worksheet using index/key froom workbook
                x1.Worksheet worksheet = null;
                worksheet = workbook.Worksheets[sheetValue] as x1.Worksheet;
                x1.Range range = worksheet.UsedRange; // Range of Cells wich are having content.

                for (int i = 0; i < range.Cells.Count; i++)
                {
                    string colNameValue = Convert.ToString((range.Cells[1, i] as x1.Range).Value2);

                    if (colNameValue.ToLower() == colNameValue.ToLower())
                    {
                        colNum = i;
                        break;
                    }
                }
                Value = Convert.ToString((range.Cells[rowNum, colNum] as x1.Range).Value2);
                Marshal.FinalReleaseComObject(worksheet);
                worksheet = null;
            }
            CloseExcel();
            return Value;
        }

        public bool setCellData(string sheetName, int colNum, int rowNum, string value)
        {
            OpenExcel();
            int sheetValue = 0;

            try
            {
                if (sheets.ContainsValue(sheetName))
                {
                    foreach (DictionaryEntry sheet in sheets)
                    {
                        if (sheet.Value.Equals(sheetName))
                        {
                            sheetValue = (int)sheet.Key;
                        }
                    }
                    // Getting particular worksheet using index/key froom workbook
                    x1.Worksheet worksheet = null;
                    worksheet = workbook.Worksheets[sheetValue] as x1.Worksheet;
                    x1.Range range = worksheet.UsedRange; // Range of Cells wich are having content.

                    range.Cells[rowNum, colNum] = value;
                    workbook.Save();

                    Marshal.FinalReleaseComObject(worksheet);
                    worksheet = null;
                    CloseExcel();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("new Excelsheet Exception = " + ex.Message);
                return false;
            }
            return true;
        }

        public bool setCellData(string sheetName, string colName, int rowNum, string value)
        {
            OpenExcel();
            int sheetValue = 0;
            int colNum = 0;

            try
            {
                if (sheets.ContainsValue(sheetName))
                {
                    foreach (DictionaryEntry sheet in sheets)
                    {
                        if (sheet.Value.Equals(sheetName))
                        {
                            sheetValue = (int)sheet.Key;
                        }
                    }
                    // Getting particular worksheet using index/key froom workbook
                    x1.Worksheet worksheet = null;
                    worksheet = workbook.Worksheets[sheetValue] as x1.Worksheet;
                    x1.Range range = worksheet.UsedRange; // Range of Cells wich are having content.

                    for (int i = 2; i < range.Columns.Count; i++)
                    {
                        string colNameValue = Convert.ToString((range.Cells[2, i] as x1.Range).Value2);
                        if (colNameValue.ToLower().Equals(colName))
                        {
                            colNum = i;
                            break;

                        }
                    }

                    range.Cells[rowNum, colNum] = value;
                    workbook.Save();

                    Marshal.FinalReleaseComObject(worksheet);
                    worksheet = null;
                    CloseExcel();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("new Excelsheet Exception = " + ex.Message);
                return false;
            }
            return true;
        }
    }
}
