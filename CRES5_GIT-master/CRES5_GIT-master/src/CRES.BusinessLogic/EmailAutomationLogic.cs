using CRES.DataContract;
using CRES.Utilities;
using System;
using System.IO;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class EmailAutomationLogic
    {
        /*
            //call method example
            EmailDataContract emailDC = new EmailDataContract();
            emailDC.To = "skhan@hvantage.com,rsahu@hvnatge.com";
            
            //optional
            emailDC.Cc = "skhan@hvantage.com,rsahu@hvnatge.com";
            emailDC.Bcc = "skhan@hvantage.com,rsahu@hvnatge.com";
            emailDC.ReceiverName = "Shahid";
            emailDC.FileAttachment = new List<FileAttachmentDataContract>();
            emailDC.FileAttachment.Add(new FileAttachmentDataContract { FilePath = "C:\\Delphi_Transactions.xlsx"});    
            emailDC.Subject = "This is subject";
            emailDC.Body = "This is bbody";
            //
            EmailAutomationLogic lg = new EmailAutomationLogic();
            lg.SendGenericEmail(emailDC);
        //
        */
        public string SendGenericEmail(EmailDataContract emailDC)
        {
            string HtmlTemplateName = "GenericEmailNotification.html";
            string htmlContent = string.Empty;
            string fromEmail = "no-reply@m61systems.com";
            string Message = "";
            try
            {
                //using streamreader for reading my htmltemplate   

                if (emailDC != null)
                {
                    if (string.IsNullOrEmpty(emailDC.To))
                    {
                        Message = "Please provide sender's email address";
                        return Message;
                    }

                    using (StreamReader reader = new StreamReader(emailDC.TemplatePath + HtmlTemplateName))
                    {
                        htmlContent = reader.ReadToEnd();
                    }
                    if (!string.IsNullOrEmpty(emailDC.ReceiverName))
                        htmlContent = htmlContent.Replace("{UserName}", emailDC.ReceiverName);
                    if (!string.IsNullOrEmpty(emailDC.Body))
                        htmlContent = htmlContent.Replace("{bodytext}", emailDC.Body);
                    string[] files = "".Split(',');
                    emailDC.Cc = emailDC.Cc ?? "";
                    emailDC.Bcc = emailDC.Bcc ?? "";
                    emailDC.ReplyTo = emailDC.ReplyTo ?? "";
                    emailDC.Subject = emailDC.Subject ?? "";
                    if (emailDC.FileAttachment != null)
                    {
                        files = emailDC.FileAttachment.Select(i => i.FilePath).ToArray();
                    }
                    EmailSender.SendGenericEmail(fromEmail, emailDC.To.Trim().Split(','), emailDC.Cc.Trim().Split(','), emailDC.Bcc.Trim().Split(','), emailDC.ReplyTo.Trim().Split(','), emailDC.Subject, htmlContent, files, emailDC.EmailSettings);
                    Message = "Email sent succeeded";
                }
            }
            catch (Exception ex)
            {
                Message = ex.Message;
            }
            return Message;
        }


    }
}
