using Microsoft.Extensions.Configuration;
using System;
using System.Globalization;
using System.IO;

namespace CRES.TestAutoMationApp
{
    public static class BaseConfiguration
    {
        public static readonly string Env = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");


        /// <summary>
        /// Getting appsettings.json file.
        /// </summary>
        public static readonly IConfigurationRoot Builder = new ConfigurationBuilder()
            .AddJsonFile(Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).Parent.Parent.FullName, "appsettings.json"))
            .Build();


        public static bool UseCurrentDirectory
        {
            get
            {
                string setting = null;


                setting = Builder["appSettings:UseCurrentDirectory"];

                if (string.IsNullOrEmpty(setting))
                {
                    return false;
                }

                if (setting.ToLower(CultureInfo.CurrentCulture).Equals("true"))
                {
                    return true;
                }

                return false;
            }
        }
        public static string GetEnvironment()
        {

            string setting = "";
            setting = Builder["appSettings:ExuecutionEnvironment"];
            return setting;

        }
        public static string GetQAUrl()
        {

            string setting = "";
            setting = Builder["appSettings:QAUrl"];
            return setting;

        }
        public static string GetQaUsername()
        {

            string setting = "";
            setting = Builder["appSettings:QaUsername"];
            return setting;

        }

        public static string GetQaPassword()
        {

            string setting = "";
            setting = Builder["appSettings:QaPassword"];
            return setting;

        }

        public static string GetIntUrl()
        {
            string setting = "";
            setting = Builder["appSettings:IntUrl"];
            return setting;
        }

        public static string GetIntUsername()
        {
            string setting = "";
            setting = Builder["appSettings:IntUsername"];
            return setting;

        }

        public static string GetIntPassword()
        {
            string setting = "";
            setting = Builder["appSettings:IntPassword"];
            return setting;

        }

        public static string GetDevUrl()
        {
            string setting = "";
            setting = Builder["appSettings:DevUrl"];
            return setting;
        }

        public static string GetDevUsername()
        {
            string setting = "";
            setting = Builder["appSettings:DevUsername"];
            return setting;

        }

        public static string GetDevPassword()
        {
            string setting = "";
            setting = Builder["appSettings:DevPassword"];
            return setting;

        }

        public static string GetStagingUrl()
        {
            string setting = "";
            setting = Builder["appSettings:StagingUrl"];
            return setting;
        }
        public static string GetDemoUrl()
        {  //code
            string setting = "";
            setting = Builder["appSettings:DemoUrl"];
            return setting;
        }
        public static string GetStagingUsername()
        {
            string setting = "";
            setting = Builder["appSettings:StagingUsername"];
            return setting;

        }

        public static string GetStagingPassword()
        {
            string setting = "";
            setting = Builder["appSettings:StagingPassword"];
            return setting;

        }
        public static string GetURL()
        {
            string setting = "";
            setting = Builder["appSettings:url"];
            return setting;

        }
        public static string GetAcoreUsername()
        {
            string setting = "";
            setting = Builder["appSettings:AcoreUsername"];
            return setting;

        }
        public static string GetAcorePassword()
        {
            string setting = "";
            setting = Builder["appSettings:AcorePassword"];
            return setting;

        }
        public static string GetLoginUrl()
        {
            string setting = "";
            setting = Builder["appSettings:LoginUrl"];
            return setting;

        }
        public static string GetDemoPassword()
        {
            string setting = "";
            setting = Builder["appSettings:DemoPassword"];
            return setting;

        }
        public static string GetDemoUsername()
        {
            string setting = "";
            setting = Builder["appSettings:DemoUsername"];
            return setting;

        }
        public static string GetDashboardUrl()
        {
            string setting = "";
            setting = Builder["appSettings:DashboardUrl"];
            return setting;

        }
        public static string GetLoginUrlNew()
        {
            string setting = "";
            setting = Builder["appSettings:LoginUrlNew"];
            return setting;

        }

        public static string DealFunding()
        {
            string setting = "";
            setting = Builder["appSettings:DealFundingUrl"];
            return setting;

        }

        public static string NoteFunding()
        {

            string setting = "";
            setting = Builder["appSettings:NoteFundingUrl"];
            return setting;

        }

        public static string getusername()
        {

            string setting = "";
            setting = Builder["appSettings:username"];

            return setting;

        }
        public static string TestAllDealForAmort()
        {
            string setting = "";
            setting = Builder["DealPageSettings:TestAllDealForAmort"];
            return setting;
        }
        public static string TestAllDealForGenerateFunding()
        {
            string setting = "";
            setting = Builder["DealPageSettings:TestAllDealForGenerateFunding"];
            return setting;
        }

        public static string TestAllNoteForSaving()
        {
            string setting = "";
            setting = Builder["NotePageSettings:TestAllNoteForSaving"];
            return setting;
        }


        public static string HeadlessDriver()
        {
            string headless = "";
            headless = Builder["appSettings:HeadlessDriver"];
            return headless;
        }

        public static int BrowserCount()
        {
            int browserCount = 1;
            browserCount = Convert.ToInt16(Builder["browserSettings:BrowserCount"]);
            return browserCount;
        }


        public static string getpassword()
        {
            string setting = "";
            setting = Builder["appSettings:password"];
            return setting;
        }
        public static string LoginUrl()
        {
            string setting = "";
            setting = Builder["appSettings:LoginUrl"];
            return setting;
        }

        public static bool AllowSave()
        {
            string setting = "";
            setting = Builder["DealPageSettings:SaveDeal"];
            if (setting.ToLower() == "yes")
            {
                return true;
            }
            else
            {
                return false;
            }

        }

        public static bool SendProgressEmail()
        {
            string setting = "";
            setting = Builder["appSettings:SendProgressEmail"];
            if (setting.ToLower() == "yes")
            {
                return true;
            }
            else
            {
                return false;
            }

        }

        public static int SendProgressEmailDealCounter()
        {
            string setting = "";
            setting = Builder["appSettings:SendProgressEmailDealCounter"];
            return int.Parse(setting);
        }


        public static string DeafultLoggingFile()
        {
            string setting = "";
            setting = Builder["appSettings:DeafultLoggingFile"];
            return setting;
        }

        public static string QAUrl()
        {
            string setting = "";
            setting = Builder["appSettings:QAUrl"];
            return setting;
        }

        public static string IntUrl()
        {
            string setting = "";
            setting = Builder["appSettings:IntUrl"];
            return setting;
        }

        public static string MyAccountUrl()
        {
            string setting = "";
            setting = Builder["appSettings:MyAccountUrl"];
            return setting;
        }
        public static string UserManagementUrl()
        {
            string setting = "";
            setting = Builder["appSettings:UserManagementUrl"];
            return setting;
        }

        public static string ScenarioUrl()
        {
            string setting = "";
            setting = Builder["appSettings:ScenarioUrl"];
            return setting;
        }
        public static string IndexPageUrl()
        {
            string setting = "";
            setting = Builder["appSettings:IndexPageUrl"];
            return setting;
        }

        public static string FeeConfigUrl()
        {
            string setting = "";
            setting = Builder["appSettings:FeeConfigUrl"];
            return setting;
        }


        public static string DynamicPortfolioUrl()
        {
            string setting = "";
            setting = Builder["appSettings:DynamicPortfolioUrl"];
            return setting;
        }

        public static string TranscatioReconUrl()
        {
            string setting = "";
            setting = Builder["appSettings:TranscatioReconUrl"];
            return setting;
        }

        public static string TransactionauditURL()
        {
            string setting = "";
            setting = Builder["appSettings:TransactionauditURL"];
            return setting;
        }

        public static string periodicCloseUrl()
        {
            string setting = "";
            setting = Builder["appSettings:periodicCloseUrl"];
            return setting;
        }

        public static string CalculationManagerUrl()
        {
            string setting = "";
            setting = Builder["appSettings:CalculationManagerUrl"];
            return setting;
        }

        public static string ReportUrl()
        {
            string setting = "";
            setting = Builder["appSettings:ReportUrl"];
            return setting;
        }

        public static string ReportHistoryUrl()
        {
            string setting = "";
            setting = Builder["appSettings:ReportHistoryUrl"];
            return setting;
        }

        public static string TagsUrl()
        {
            string setting = "";
            setting = Builder["appSettings:TagsUrl"];
            return setting;
        }
        public static string WorkFlowUrl()
        {
            string setting = "";
            setting = Builder["appSettings:WorkFlowUrl"];
            return setting;
        }
        public static string TaskUrl()
        {
            string setting = "";
            setting = Builder["appSettings:TaskUrl"];
            return setting;
        }

        public static string HelpPageUrl()
        {
            string setting = "";
            setting = Builder["appSettings:HelpPageUrl"];
            return setting;
        }

        public static string DataManagementUrl()
        {
            string setting = "";
            setting = Builder["appSettings:DataManagementUrl"];
            return setting;
        }

        public static string NotificationSubsUrl()
        {
            string setting = "";
            setting = Builder["appSettings:NotificationSubsUrl"];
            return setting;
        }

        public static string AcoreUrl()
        {
            string setting = "";
            setting = Builder["appSettings:AcoreUrl"];
            return setting;
        }

        public static string TakeScreenshot()
        {
            string setting = "";
            setting = Builder["appSettings:TakeScreenshot"];
            return setting;
        }
        public static string EmailTO()
        {
            string setting = "";
            setting = Builder["appSettings:EmailTO"];
            return setting;
        }

        public static string Host
        {

            get
            {
                string setting = "";
                setting = Builder["Application:Host"];
                return setting;

            }

        }
        public static string UserName
        {
            get
            {
                string setting = "";
                setting = Builder["Application:UserName"];
                return setting;

            }

        }
        public static string Password
        {
            get
            {
                string setting = "";
                setting = Builder["Application:Password"];
                return setting;

            }

        }

        public static string Port
        {
            get
            {
                string setting = "";
                setting = Builder["Application:Port"];
                return setting;

            }

        }


    }
}


