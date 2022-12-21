using CRES.TestAutoMation.Pages;
using CRES.TestAutoMation.Utility;
using NUnit.Framework;
using System;
namespace CRES.TestAutoMation.TestCases
{
    public class CRES_DealAmort : BaseClass
    {

        //Login

        [Test]
        public void TestDealAmort()
        {

            CRES_Login loginapp = new CRES_Login();
            Login login = new Login(driver);
            Deal deal = new Deal(driver);
            Util util = new Util(driver);
            string dealfunding = BaseConfiguration.GetURL() + BaseConfiguration.DealFunding();
            // AutomationLogic autologic = new AutomationLogic();

            string username = BaseConfiguration.getusername();
            string password = BaseConfiguration.getpassword();
            string LoginUrl = BaseConfiguration.LoginUrl();

            //TestAllDealForAmort

            string testallamort = BaseConfiguration.TestAllDealForAmort();

            if (testallamort.ToLower() == "yes")
            {

            }
            else
            {

            }
            ////login in web site
            util.OpenUrl(LoginUrl);
            if (login.LoginWebPage())
            {
                util.OpenUrl(dealfunding + "950DEB9E-5CC6-4C42-AF4A-536F05C75388");
                deal.CheckDealPageLoaded();
                deal.ClickAmortTab();
                util.ImplicitWait(Convert.ToDouble(5));
                //  string[] amorttype = {"Straight Line Amortization","Fixed Payment Amortization","Full Amortization by Rate & Term","Custom Deal Amortization","Custom Note Amortization"}
                // util.captureScreenshot("NorthCreekCopy_De-001");
                string result = deal.GenerateAmort("Fixed Payment Amortization");


                if (BaseConfiguration.AllowSave())
                {
                }
                //change Amortization Method
                // click ok
                string a = "";
            }

        }
    }
}
