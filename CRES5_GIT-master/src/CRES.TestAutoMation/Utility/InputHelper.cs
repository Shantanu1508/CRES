using CRES.DataContract;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;


namespace CRES.TestAutoMation.Utility
{
    public class InputHelper
    {
        public List<AutoMationLoginDataContract> ReadFromExcel(string excelFileName, string excelsheetTabName, string inputfilepath)
        {
            string executableLocation = inputfilepath;
            string xslLocation = Path.Combine(executableLocation, excelFileName);
            List<AutoMationLoginDataContract> parmeters = new List<AutoMationLoginDataContract>();
            string cmdText = "SELECT * FROM [" + excelsheetTabName + "$]";

            if (!File.Exists(xslLocation))
                throw new Exception(string.Format("File name: {0}", xslLocation), new FileNotFoundException());
            string connectionStr = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0 Xml;HDR=YES\";", xslLocation);

            var testCases = new List<AutoMationLoginDataContract>();
            DataSet data = new DataSet();
            DataTable dataTable = new DataTable();

            using (var connection = new OleDbConnection(connectionStr))
            {

                connection.Open();
                var command = new OleDbCommand(cmdText, connection);
                OleDbDataAdapter adapter = new OleDbDataAdapter(cmdText, connection);
                adapter.Fill(dataTable);
                data.Tables.Add(dataTable);

            }

            if (dataTable != null)
            {
                AutoMationLoginDataContract ldc = new AutoMationLoginDataContract();
                for (int i = 0; i < dataTable.Rows.Count; i++)
                {

                    if (dataTable.Rows[i].ItemArray[0].ToString() == "User_Name")
                    {
                        ldc.UserName = dataTable.Rows[i].ItemArray[1].ToString();
                    }
                    if (dataTable.Rows[i].ItemArray[0].ToString() == "Password")
                    {
                        ldc.Password = dataTable.Rows[i].ItemArray[1].ToString();
                    }
                    if (dataTable.Rows[i].ItemArray[0].ToString() == "WebURL")
                    {
                        ldc.URL = dataTable.Rows[i].ItemArray[1].ToString();
                    }

                }
                parmeters.Add(ldc);
            }
            return parmeters; ;
        }


        public static List<AutoMationLoginDataContract> ReadXlsxDataDriveFile(string path, string sheetName, [Optional] string[] diffParam, [Optional] string testName)
        {
            List<AutoMationLoginDataContract> parmeters = new List<AutoMationLoginDataContract>();
            XSSFWorkbook wb;
            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                wb = new XSSFWorkbook(fs);
            }
            // get sheet
            var sh = (XSSFSheet)wb.GetSheet(sheetName);

            int startRow = 1;
            int startCol = 0;
            int totalRows = sh.LastRowNum;
            int totalCols = sh.GetRow(0).LastCellNum;

            var row = 1;
            for (int i = startRow; i <= totalRows; i++, row++)
            {
                var column = 0;
                var testParams = new Dictionary<string, string>();
                for (int j = startCol; j < totalCols; j++, column++)
                {
                    if (sh.GetRow(0).GetCell(column).CellType != CellType.String)
                    {
                        throw new InvalidOperationException(string.Format("Cell with name of parameter must be string only, file {0} at sheet {1} row {2} column {3}", path, sheetName, 0, column));
                    }

                    var cellType = sh.GetRow(row).GetCell(column).CellType;
                    switch (cellType)
                    {
                        case CellType.String:
                            testParams.Add(sh.GetRow(0).GetCell(column).StringCellValue, sh.GetRow(row).GetCell(column).StringCellValue);
                            break;
                        case CellType.Numeric:
                            testParams.Add(sh.GetRow(0).GetCell(column).StringCellValue, sh.GetRow(row).GetCell(column).NumericCellValue.ToString(CultureInfo.CurrentCulture));
                            break;
                        default:
                            throw new InvalidOperationException(string.Format("Not supported cell type {0} in file {1} at sheet {2} row {3} column {4}", cellType, path, sheetName, row, column));
                    }
                }

                
            }
            return parmeters;
        }

        private static string TestCaseName(string[] diffParam, Dictionary<string, string> testParams, string testCaseName)
        {
            if (diffParam != null && diffParam.Any())
            {
                foreach (var p in diffParam)
                {
                    string keyValue;
                    bool keyFlag = testParams.TryGetValue(p, out keyValue);

                    if (keyFlag)
                    {
                        if (!string.IsNullOrEmpty(keyValue))
                        {
                            testCaseName += "_" + Regex.Replace(keyValue, "[^0-9a-zA-Z]+", "_");
                        }
                    }
                    else
                    {
                        //throw new Exception;
                    }
                }
            }

            return testCaseName;
        }

        public static DataTable GetDataTableFromExcel(String Path, string sheetname)
        {
            XSSFWorkbook wb;
            XSSFSheet sh;
            ExcelUtility.ThrowIfExcelFileIsOpen(Path);


            using var fs = new FileStream(Path, FileMode.Open, FileAccess.Read);
                wb = new XSSFWorkbook(fs);
            

            DataTable DT = new DataTable();
            DT.Rows.Clear();
            DT.Columns.Clear();

            // get sheet
            sh = (XSSFSheet)wb.GetSheet(sheetname);
            int i = 0;
            while (sh.GetRow(i) != null)
            {
                // add neccessary columns
                if (DT.Columns.Count < sh.GetRow(i).Cells.Count)
                {
                    for (int j = 0; j < sh.GetRow(i).Cells.Count; j++)
                    {
                        DT.Columns.Add("", typeof(string));
                    }
                }

                // add row
                DT.Rows.Add();
                // write row value
                for (int j = 0; j < sh.GetRow(i).Cells.Count; j++)
                {
                    var cell = sh.GetRow(i).GetCell(j);

                    if (cell != null)
                    {
                        // TODO: you can add more cell types capatibility, e. g. formula
                        switch (cell.CellType)
                        {
                            case NPOI.SS.UserModel.CellType.Numeric:
                                DT.Rows[i][j] = sh.GetRow(i).GetCell(j).NumericCellValue;
                                //dataGridView1[j, i].Value = sh.GetRow(i).GetCell(j).NumericCellValue;

                                break;
                            case NPOI.SS.UserModel.CellType.String:
                                DT.Rows[i][j] = sh.GetRow(i).GetCell(j).StringCellValue;
                                break;
                        }
                    }
                }

                i++;
            }

            return DT;
        }

    }
}
