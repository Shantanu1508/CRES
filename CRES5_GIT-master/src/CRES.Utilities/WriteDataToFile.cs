using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Data;

namespace CRES.Utilities
{
    public static class WriteDataToFile
    {
        public static void WriteDataToNewFile(string filename, string fileContent)
        {
            try
            {
                string path = @"C:\temp";
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                string strFilePath = "C:\\temp\\" + filename;
                StreamWriter sw = new StreamWriter(strFilePath, false);
                sw.Write(fileContent);
                sw.Close();
            }
            catch (Exception ex)
            {
                string error = "Error";
            }

        }
    }
}
