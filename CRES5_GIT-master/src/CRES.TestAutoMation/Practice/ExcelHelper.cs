using CRES.TestAutoMation.TestCases;
using NUnit.Framework;
using sun.security.krb5;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace CRES.TestAutoMation.Practice
{
    class ExcelHelper
    {
        [Test]
       public static void ExleMethod()
        {
            try
            {

                string pathNew = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;
                string xlFilePath = "D:/ExcelTest/Test.xlsx";

                Parameterization Pera = new Parameterization(xlFilePath);

                int rowCount = Pera.GetRowCount("Sheet1");
                Console.WriteLine("Total Number of Rows =" + rowCount);

                int colCount = Pera.GetColumnCount("Sheet1");
                Console.WriteLine("Total Number of Column =" + colCount);

                string cellValue = Pera.GetCellData("Sheet1", 1, 6);
                Console.WriteLine("Cell value using column Number =" + cellValue);

                cellValue = Pera.GetCellData("Sheet1", "First_Name", 4);
                Console.WriteLine("Cell value using column Number =" + cellValue);

                Pera.setCellData("Credentials", 5, 5, "Failed");

                Pera.setCellData("Credentials", "NoOneAttempted", 5, "20");

                Console.Read();
            }
            catch(Exception ex)
            {
                Console.WriteLine("Excel Exception = "+ex.Message);
            }

        }
    }
}
