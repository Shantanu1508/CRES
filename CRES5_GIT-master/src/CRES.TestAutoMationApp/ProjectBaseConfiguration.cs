using System;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using System.Text;
using CRES.TestAutoMationApp.Utility;

namespace CRES.TestAutoMationApp
{
    public static class ProjectBaseConfiguration
    {
        private static readonly string CurrentDirectory = Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName;

        public static string DataDrivenFileXlsx
        {
            get
            {
                string setting = null;

                setting = BaseConfiguration.Builder["appSettings:DataDrivenFileXlsx"];

                if (BaseConfiguration.UseCurrentDirectory)
                {
                    return Path.Combine(CurrentDirectory + FilesHelper.Separator + setting);
                }

                return setting;
            }
        }

        public static string ScreenShotFolder
        {
            get
            {
                string setting = null;

                setting = BaseConfiguration.Builder["appSettings:ScreenShotFolder"];

                return Path.Combine(CurrentDirectory + FilesHelper.Separator + setting);



            }
        }

        public static string ExcelReportsFolder
        {
            get
            {
                string setting = null;

                setting = BaseConfiguration.Builder["appSettings:ExcelReports"];
                return Path.Combine(CurrentDirectory + FilesHelper.Separator + setting);
            }
        }

        public static string ExecutionLogs
        {
            get
            {
                string setting = null;
                setting = BaseConfiguration.Builder["appSettings:ExecutionLogs"];
                return Path.Combine(CurrentDirectory + FilesHelper.Separator + setting);



            }
        }

        public static string ExecutionReportFolder
        {
            get
            {
                string setting = null;
                setting = BaseConfiguration.Builder["appSettings:ExecutionReports"];
                return Path.Combine(CurrentDirectory + FilesHelper.Separator + setting);

            }
        }
        public static string DeafultLoggingFile
        {
            get
            {
                string setting = null;
                setting = BaseConfiguration.Builder["appSettings:DeafultLoggingFile"];
                return Path.Combine(CurrentDirectory + FilesHelper.Separator + setting);

            }
        }

        public static string TemplatePath
        {
            get
            {
                string setting = null;
                setting = BaseConfiguration.Builder["appSettings:TemplatePath"];
                return Path.Combine(CurrentDirectory + FilesHelper.Separator + setting);

            }
        }


    }
}
