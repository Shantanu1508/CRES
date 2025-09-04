using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace CRES.TestAutoMation.Practice
{
    internal class WriteToExcel_02
    {

        static IWorkbook workbook;
        static ISheet sheet;
        static IRow row;
        static ICell cell;
        static string file = "C:/Users/MSTEMP/Documents/Files/Test.xlsx";
        static string sheetName = "Testcase";
        static string filePath;
        public static void createExcel(DataTable table, string FileName)
        {
            string path = ProjectBaseConfiguration.ExcelReportsFolder;
            
            string firstValue = "Hello";
            if (!File.Exists(file))
            {
                filePath = path + FileName + ".xlsx";

                using (FileStream str = new FileStream(file, FileMode.Create, FileAccess.Write))
                {
                    workbook = new XSSFWorkbook();
                    sheet = workbook.CreateSheet(sheetName);
                    row = sheet.CreateRow(0);
                    cell = row.CreateCell(0);
                    cell.SetCellValue(firstValue);
                    workbook.Write(str);
                    str.Close();
                }
            }
            else
            {
                using (FileStream rstr = new FileStream(file, FileMode.Open, FileAccess.Read))
                {
                    workbook = new XSSFWorkbook(rstr);
                    sheet = workbook.GetSheet(sheetName);

                    using (FileStream wstr = new FileStream(file, FileMode.Open, FileAccess.ReadWrite))
                    {
                        string secondValue = "changes";

                        row = sheet.GetRow(0);
                        cell = row.GetCell(0);
                        cell.SetCellValue(secondValue);
                        Debug.Print(cell.ToString());
                        workbook.Write(wstr);
                        wstr.Close();
                    }
                    rstr.Close();
                }
            }
        }

    }
}
