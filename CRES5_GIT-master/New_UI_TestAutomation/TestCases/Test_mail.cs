using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.TestAutoMation.TestCases;
using Newtonsoft.Json;
using NPOI.HSSF.Record;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.TestAutoMation;

namespace New_UI_TestAutomation.TestCases
{
    internal class Test_mail:BaseClass
    {


        [Test]
        public static void test_mail(  )
        {
            try
            {
                new Test_mail().SendMail();
            }
            catch (Exception ex) { 
            
                Console.WriteLine("test email exception = "+ex.Message);
            }
            
        }

        



        public void SendMail()
        {
            Console.WriteLine("You are in SendMail method");
            
            //............................. Email attachment ........................                  

            string sendValidationReportEmail = BaseConfiguration.SendValidationReportEmail();
            if (sendValidationReportEmail.ToString().ToLower() == "yes")
            {
                try
                {
                           // Email check point


                    if (sendValidationReportEmail.ToString().ToLower() == "yes")
                    {
                        Console.WriteLine("\nsend Merge all files mail");
                        EmailDataContract emailDC = new EmailDataContract();
                        emailDC.To = "shantanu@hvantage.com";
                        // emailDC.Cc = "rsahu@hvantage.com,msingh@hvantage.com,ssingh@hvantage.com,vbalapure@hvantage.com,vandana@hvantage.com";
                        //optional
                        //emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
                        //emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
                        emailDC.ReceiverName = "All";
                        emailDC.FileAttachment = new List<FileAttachmentDataContract>();
                        //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = filePath });
                        Console.WriteLine("attached file = "  );
                        //emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = indexReport + "\\index.html" });
                        emailDC.Subject = "Liability Functional Flow Test Report";
                        emailDC.Body = "PFA the Liability Functional Flow Test Report.";
                        emailDC.TemplatePath = ProjectBaseConfiguration.TemplatePath;
                        emailDC.EmailSettings.Host = BaseConfiguration.Host;
                        emailDC.EmailSettings.UserName = BaseConfiguration.UserName;
                        emailDC.EmailSettings.Password = BaseConfiguration.Password;
                        emailDC.EmailSettings.Port = BaseConfiguration.Port;
                        //
                        EmailAutomationLogic lg = new EmailAutomationLogic();

                        String response = lg.SendGenericEmail(emailDC);
                        Thread.Sleep(5000);  // Check Point 
                    }


                }
                catch (Exception ex)
                {
                    Console.WriteLine("\nSend report mail Exception =" + ex);

                }       //Email check point             // Check Point
                
            }
        }
    }
}
