using CRES.DataContract;
using CRES.TestAutoMation.Utility;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml.Wordprocessing;
using Newtonsoft.Json;
using NPOI.SS.UserModel;
using NPOI.SS.Util;
using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq.Expressions;

namespace CRES.TestAutoMation.ExecutionReports
{
    public static class GenerateExcelFile
    {
        public static String CreateExcel(List<AutoMationOutputData> ItemList, string FileName)
        {
            try
            {
                DataTable table = (DataTable)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ItemList), (typeof(DataTable)));
                var memoryStream = new MemoryStream();
                string path = ProjectBaseConfiguration.ExcelReportsFolder;

                if (!Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);
                }

                path = path + FileName + "_" + Util.GetTimestamp(DateTime.Now) + ".xlsx";
                using (var fs = new FileStream(path, FileMode.Create, FileAccess.Write))
                {
                    IWorkbook workbook = new XSSFWorkbook();
                    ISheet excelSheet = workbook.CreateSheet("Validation_Summary");
                    ISheet excelSheet1 = workbook.CreateSheet("Sheet2");

                    List<String> columns = new List<string>();
                    IRow row = excelSheet.CreateRow(0);

                    int columnIndex = 0;
                    int widthInUnits = 50 * 256; // Excel uses 1/256th units
                    excelSheet.SetColumnWidth(columnIndex, widthInUnits);

                    foreach (System.Data.DataColumn column in table.Columns)
                    {
                        columns.Add(column.ColumnName);
                        row.CreateCell(columnIndex).SetCellValue(column.ColumnName);
                        columnIndex++;
                    }

                    int rowIndex = 1;
                    foreach (DataRow dsrow in table.Rows)
                    {
                        row = excelSheet.CreateRow(rowIndex);
                        int cellIndex = 0;
                        foreach (String col in columns)
                        {
                            row.CreateCell(cellIndex).SetCellValue(dsrow[col].ToString());
                            cellIndex++;
                        }

                        rowIndex++;
                    }
                    workbook.Write(fs);
                    return path;
                }
            }
            catch (Exception ex)
            {
                TextLogger.Write("Error while creating Excel" + ex.Message.ToString(), "");
                throw;
            }
        }


        public static String CreateExcelDataTable(DataTable table, string FileName)
        {
            try
            {

                var memoryStream = new MemoryStream();
                string path = ProjectBaseConfiguration.ExcelReportsFolder;

                if (!Directory.Exists(path))
                {
                    DirectoryInfo di = Directory.CreateDirectory(path);
                }

                path = path + FileName + "_" + Util.GetTimestamp(DateTime.Now) + ".xlsx";
                using (var fs = new FileStream(path, FileMode.Create, FileAccess.Write))
                {
                    IWorkbook workbook = new XSSFWorkbook();
                    ISheet excelSheet = workbook.CreateSheet("Validation_Summary");

                    List<String> columns = new List<string>();
                    IRow row = excelSheet.CreateRow(0);
                    int columnIndex = 0;
                    

                    foreach (System.Data.DataColumn column in table.Columns)
                    {
                        columns.Add(column.ColumnName);
                        row.CreateCell(columnIndex).SetCellValue(column.ColumnName);
                        columnIndex++;
                    }

                    int rowIndex = 1;
                    foreach (DataRow dsrow in table.Rows)
                    {
                        row = excelSheet.CreateRow(rowIndex);
                        int cellIndex = 0;
                        foreach (String col in columns)
                        {
                            row.CreateCell(cellIndex).SetCellValue(dsrow[col].ToString());
                            cellIndex++;
                        }

                        rowIndex++;
                    }
                    FormatExcel(excelSheet, workbook);
                    workbook.Write(fs);
                    
                    return path;
                }
            }
            catch (Exception ex)
            {
                TextLogger.Write("Error while creating Excel" + ex.Message.ToString(), "");
                throw;
            }
        }

        private static void FormatExcel(ISheet excelSheet, IWorkbook workbook)
        {
            
            excelSheet.SetColumnWidth(0, 2560);   // Excel uses 1/256th units
            excelSheet.SetColumnWidth(1, 7680);
            excelSheet.SetColumnWidth(2, 7680);
            excelSheet.SetColumnWidth(3, 9216);
            excelSheet.SetColumnWidth(4, 12800);
            excelSheet.SetColumnWidth(5, 12800);
            excelSheet.SetColumnWidth(6, 12800);
            excelSheet.SetColumnWidth(7, 12800);

            excelSheet.CreateFreezePane(0, 1);    // Freeze first row
             
            try
            {

                IRow headerRow = excelSheet.GetRow(0);
               int lastcellNumber =  headerRow.LastCellNum;
                if (headerRow != null && headerRow.LastCellNum > 0)
                {

                    CellRangeAddress filterRange = new CellRangeAddress(0, 0, 0, lastcellNumber-1);
                    excelSheet.SetAutoFilter(filterRange);

                    // Convert HTML color to RGB
                    var bgColor = ColorTranslator.FromHtml("#215C98"); // Background (Blue)
                    var fontColor = ColorTranslator.FromHtml("#FFFFFF"); // Font (white)

                    // Create XSSF colors
                    XSSFColor xssfBgColor = new XSSFColor(bgColor);
                    XSSFColor xssfFontColor = new XSSFColor(fontColor);

                    // Create cell style with custom background
                    XSSFCellStyle style = (XSSFCellStyle)workbook.CreateCellStyle();
                    style.FillForegroundColorColor = xssfBgColor;
                    style.FillPattern = FillPattern.SolidForeground;

                    style.Alignment = HorizontalAlignment.Center;
                    style.VerticalAlignment = VerticalAlignment.Center;

                    excelSheet.SetZoom(90);

                    // Create font with custom color
                    XSSFFont font = (XSSFFont)workbook.CreateFont();
                    font.SetColor(xssfFontColor);
                    font.IsBold = true;
                    style.SetFont(font);

                    // Apply to each header cell
                    for (int i = 0; i <= lastcellNumber-1; i++)
                    {
                        ICell cell = headerRow.GetCell(i) ?? headerRow.CreateCell(i);
                        cell.CellStyle = style;
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);

            }
        }
    }
}