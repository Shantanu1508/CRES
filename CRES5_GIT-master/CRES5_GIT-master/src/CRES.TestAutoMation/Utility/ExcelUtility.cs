using CRES.TestAutoMation.ExecutionReports;
using NPOI.XSSF.UserModel;
using System;
using System.Data;
using System.IO;

namespace CRES.TestAutoMation.Utility
{
    public class ExcelUtility
    {

        public static String MergeAllFiles(string UniqueID)
        {
            Random _random = new Random();
            string strPost = _random.Next().ToString();

            DataTable dt = new DataTable();
            string path = ProjectBaseConfiguration.ExcelReportsFolder;

            DirectoryInfo hdDirectoryInWhichToSearch = new DirectoryInfo(path);
            FileSystemInfo[] filesAndDirs = hdDirectoryInWhichToSearch.GetFileSystemInfos("*" + UniqueID + "*");

            foreach (FileSystemInfo foundFile in filesAndDirs)
            {
                MergeData(foundFile.FullName, dt);
            }
            String FileName = "Deal_Funding_Validation_" + strPost;
            String Path = GenerateExcelFile.CreateExcelDataTable(dt, FileName);

            return Path;
        }
        public class ExcelUtilityForNote
        {

            public static String MergeAllFiles()
            {
                Random _random = new Random();
                string strPost = _random.Next().ToString();

                DataTable dt = new DataTable();
                string path = ProjectBaseConfiguration.ExcelReportsFolder;

                DirectoryInfo hdDirectoryInWhichToSearch = new DirectoryInfo(path);
                FileSystemInfo[] filesAndDirs = hdDirectoryInWhichToSearch.GetFileSystemInfos("*");

                foreach (FileSystemInfo foundFile in filesAndDirs)
                {
                    MergeData(foundFile.FullName, dt);
                }
                String FileName = "Deal_Funding_Validation_" + strPost;
                String Path = GenerateExcelFile.CreateExcelDataTable(dt, FileName);

                return Path;
            }
        }   

            private static void MergeData(string path, DataTable dt)
        {
            XSSFWorkbook workbook = new XSSFWorkbook(path);
            XSSFSheet sheet = (XSSFSheet)workbook.GetSheetAt(0);
            XSSFRow headerRow = (XSSFRow)sheet.GetRow(0);
            int cellCount = headerRow.LastCellNum;
            if (dt.Rows.Count == 0)
            {
                for (int i = headerRow.FirstCellNum; i < cellCount; i++)
                {
                    DataColumn column = new DataColumn(headerRow.GetCell(i).StringCellValue);
                    dt.Columns.Add(column);
                }
            }
            else
            {
            }

            int rowCount = sheet.LastRowNum + 1;
            for (int i = (sheet.FirstRowNum + 1); i < rowCount; i++)
            {
                XSSFRow row = (XSSFRow)sheet.GetRow(i);
                DataRow dataRow = dt.NewRow();
                for (int j = row.FirstCellNum; j < cellCount; j++)
                {
                    if (row.GetCell(j) != null)
                        dataRow[j] = row.GetCell(j).ToString();
                }
                dt.Rows.Add(dataRow);
            }
            workbook = null;
            sheet = null;
        }
    }
}
