using System;
using System.IO;

namespace CRES.TestAutoMation.Utility
{
    public class TextLogger
    {
        public static void Write(string message, string fileName)
        {
            try
            {
                //if file name is empty use deafult logging file
                if (fileName.Trim() == "")
                {
                    fileName = ProjectBaseConfiguration.DeafultLoggingFile;
                }

                if (!File.Exists(fileName))
                {
                    File.CreateText(fileName).Dispose(); ;
                }

                using (StreamWriter w = File.AppendText(fileName))
                {
                    Log(message, w);
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.ToString());
            }
        }

        public static void Log(string logMessage, TextWriter w)
        {
            w.WriteLine(DateTime.Now + " | " + logMessage);
        }
        public static string CreateDirectory(string subdirectory)
        {
            string path = ProjectBaseConfiguration.ExecutionLogs;
            if (subdirectory.Trim() == "")
            {
                path = System.IO.Path.Combine(path, "Result_" + DateTime.Now.ToString("ddMMyyyy"));
            }
            else
            {
                path = System.IO.Path.Combine(path, subdirectory + "_" + DateTime.Now.ToString("ddMMyyyy"));
            }
            if (!Directory.Exists(path))
            {
                DirectoryInfo di = Directory.CreateDirectory(path);
            }
            return path;

        }
    }
}
