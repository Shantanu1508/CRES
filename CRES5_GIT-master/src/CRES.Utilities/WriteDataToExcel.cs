using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;

namespace CRES.Utilities
{
    public static class WriteDataToExcel
    {
        public static MemoryStream DataSetToExcel(DataSet dsData, Stream strm)
        {

            DataTable dt = new DataTable();
            Stream TemplateMemoryStream = new MemoryStream();
            List<string> lstTemplateLines = new List<string>();
            try
            {

                using (var package = new OfficeOpenXml.ExcelPackage(strm))
                {
                    int iSheetsCount = 0;
                    try
                    {
                        iSheetsCount = package.Workbook.Worksheets.Count;
                    }
                    catch (Exception)
                    {
                        iSheetsCount = package.Workbook.Worksheets.Count;
                    }
                    if (iSheetsCount > 0)
                    {
                        for (int i = 0; i < iSheetsCount; i++)
                        {

                            OfficeOpenXml.ExcelWorksheet worksheet;
                            try
                            {
                                worksheet = package.Workbook.Worksheets[i];
                            }
                            catch (Exception)
                            {
                                worksheet = package.Workbook.Worksheets[i];
                            }


                            if (dsData.Tables[worksheet.Name] != null)
                            {
                                worksheet.Cells[1, 1].LoadFromDataTable(dsData.Tables[worksheet.Name], true);
                            }

                        }
                        Byte[] fileBytes = package.GetAsByteArray();
                        TemplateMemoryStream = new MemoryStream(fileBytes);
                    }


                }
                return (MemoryStream)TemplateMemoryStream;

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}
