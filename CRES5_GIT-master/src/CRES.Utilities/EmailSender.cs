
using CRES.DataContract;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;

using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;



namespace CRES.Utilities
{
    public class EmailSender
    {
        static IConfigurationSection Sectionroot = null;

#pragma warning disable CS0649 // Field 'EmailSender._hostingEnvironment' is never assigned to, and will always have its default value null
        static IHostingEnvironment _hostingEnvironment;
#pragma warning restore CS0649 // Field 'EmailSender._hostingEnvironment' is never assigned to, and will always have its default value null





        static EmailSender()
        {
            IConfigurationBuilder builder = new ConfigurationBuilder();
            //   _hostingEnvironment = environment;
            builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
            var root = builder.Build();
            Sectionroot = root.GetSection("Application");
        }

        public static void SendEmail(string fromEmail, string[] toEmail, string subject, string bodyText, string receiverUserName, string htmlTemplateName)
        {
            string htmlContent = string.Empty;

            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.WebRootPath + ("~/EmailTemplate/" + htmlTemplateName)))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(receiverUserName))
                htmlContent = htmlContent.Replace("{UserName}", receiverUserName);
            if (!string.IsNullOrEmpty(bodyText))
                htmlContent = htmlContent.Replace("{message}", bodyText);


            var msg = new MailMessage();
            foreach (var email in toEmail)
            {
                msg.To.Add(email);
            }
            msg.From = new MailAddress(fromEmail, "M61 Support");
            msg.Body = htmlContent;
            msg.Subject = subject;
            msg.IsBodyHtml = true;

            //get email setting from config file
            //  var newsection = new EmailSender();
            string Host = Sectionroot.GetSection("Host").Value;
            string UserName = Sectionroot.GetSection("UserName").Value;
            string Password = Sectionroot.GetSection("Password").Value;
            string Port = Sectionroot.GetSection("Port").Value;

            //string Host = ConfigurationManager.AppSettings["Host"];
            //string UserName = ConfigurationManager.AppSettings["UserName"];
            //string Password = ConfigurationManager.AppSettings["Password"];
            //string Port = ConfigurationManager.AppSettings["Port"];



            var smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential(UserName, Password);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = Convert.ToInt32(Port);
            ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
            { return true; };
            smtp.Send(msg);
        }




        public static void SendTOEmail(string fromEmail, string[] toEmail, List<string> toEmailBCC, string subject, string bodyText, string receiverUserName, string htmlContent)
        {

            var msg = new MailMessage();
            foreach (var email in toEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.To.Add(email);
            }

            if (toEmailBCC != null)
            {
                foreach (var emailbcc in toEmailBCC)
                {
                    if (!string.IsNullOrEmpty(emailbcc))
                        msg.Bcc.Add(emailbcc);
                }
            }

            // msg.From = new MailAddress(fromEmail, "M61 Support");
            msg.Body = htmlContent;
            msg.Subject = subject;
            msg.IsBodyHtml = true;

            //get email setting from config file
            // var newsection = new EmailSender();
            string Host = Sectionroot.GetSection("Host").Value;
            string UserName = Sectionroot.GetSection("UserName").Value;
            string Password = Sectionroot.GetSection("Password").Value;
            string Port = Sectionroot.GetSection("Port").Value;

            //string Host = ConfigurationManager.AppSettings["Host"];
            //string UserName = ConfigurationManager.AppSettings["UserName"];
            //string Password = ConfigurationManager.AppSettings["Password"];
            //string Port = ConfigurationManager.AppSettings["Port"];

            msg.From = new MailAddress(UserName, "M61 Support");
            var smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential(UserName, Password);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = Convert.ToInt32(Port);
            ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
            { return true; };
            smtp.Send(msg);

        }



        public static void SendTOCCEmail(string fromEmail, string[] toEmail, List<string> toEmailCC, string subject, string bodyText, string receiverUserName, string htmlContent)
        {

            var msg = new MailMessage();
            foreach (var email in toEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.To.Add(email);
            }

            if (toEmailCC != null)
            {
                foreach (var emailbcc in toEmailCC)
                {
                    if (!string.IsNullOrEmpty(emailbcc))
                        msg.CC.Add(emailbcc);
                }
            }

            // msg.From = new MailAddress(fromEmail, "M61 Support");
            msg.Body = htmlContent;
            msg.Subject = subject;
            msg.IsBodyHtml = true;

            //get email setting from config file
            // var newsection = new EmailSender();
            string Host = Sectionroot.GetSection("Host").Value;
            string UserName = Sectionroot.GetSection("UserName").Value;
            string Password = Sectionroot.GetSection("Password").Value;
            string Port = Sectionroot.GetSection("Port").Value;

            //string Host = ConfigurationManager.AppSettings["Host"];
            //string UserName = ConfigurationManager.AppSettings["UserName"];
            //string Password = ConfigurationManager.AppSettings["Password"];
            //string Port = ConfigurationManager.AppSettings["Port"];

            msg.From = new MailAddress(UserName, "M61 Support");
            var smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential(UserName, Password);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = Convert.ToInt32(Port);
            ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
            { return true; };
            smtp.Send(msg);

        }


        public static void SendEmailWithAttachment(string fromEmail, string[] toEmail, string subject, string bodyText, string receiverUserName, string htmlTemplateName, byte[] filebytes, string filename)
        {
            string htmlContent = string.Empty;

            //using streamreader for reading my htmltemplate   
            using (StreamReader reader = new StreamReader(_hostingEnvironment.WebRootPath + ("~/EmailTemplate/" + htmlTemplateName)))
            {
                htmlContent = reader.ReadToEnd();
            }
            if (!string.IsNullOrEmpty(receiverUserName))
                htmlContent = htmlContent.Replace("{UserName}", receiverUserName);
            if (!string.IsNullOrEmpty(bodyText))
                htmlContent = htmlContent.Replace("{message}", bodyText);


            var msg = new MailMessage();
            foreach (var email in toEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.To.Add(email);
            }
            msg.From = new MailAddress(fromEmail, "M61 Support");
            msg.Body = htmlContent;
            msg.Subject = subject;
            msg.IsBodyHtml = true;
            if (filebytes.Length > 0)
            {
                msg.Attachments.Add(new Attachment(new MemoryStream(filebytes), filename));
            }

            //get email setting from config file
            //    var newsection = new EmailSender();
            string Host = Sectionroot.GetSection("Host").Value;
            string UserName = Sectionroot.GetSection("UserName").Value;
            string Password = Sectionroot.GetSection("Password").Value;
            string Port = Sectionroot.GetSection("Port").Value;

            //string Host = ConfigurationManager.AppSettings["Host"];
            //string UserName = ConfigurationManager.AppSettings["UserName"];
            //string Password = ConfigurationManager.AppSettings["Password"];
            //string Port = ConfigurationManager.AppSettings["Port"];



            var smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential(UserName, Password);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = Convert.ToInt32(Port);
            ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
            { return true; };
            smtp.Send(msg);
        }
        public static void SendEmailTOCCWithAttachment(string fromEmail, string[] toEmail, string[] CCEmail, string subject, string receiverUserName, string htmlContent, byte[] filebytes, string filename)
        {
            var msg = new MailMessage();
            foreach (var email in toEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.To.Add(email);
            }
            foreach (var email in CCEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.CC.Add(email);
            }
            msg.From = new MailAddress(fromEmail, "M61 Support");
            msg.ReplyToList.Add(fromEmail);
            msg.Body = htmlContent;
            msg.Subject = subject;
            msg.IsBodyHtml = true;
            if (filebytes.Length > 0)
            {
                msg.Attachments.Add(new Attachment(new MemoryStream(filebytes), filename));
            }

            //get email setting from config file
            // var newsection = new EmailSender();
            string Host = Sectionroot.GetSection("Host").Value;
            string UserName = Sectionroot.GetSection("UserName").Value;
            string Password = Sectionroot.GetSection("Password").Value;
            string Port = Sectionroot.GetSection("Port").Value;

            //string Host = ConfigurationManager.AppSettings["Host"];
            //string UserName = ConfigurationManager.AppSettings["UserName"];
            //string Password = ConfigurationManager.AppSettings["Password"];
            //string Port = ConfigurationManager.AppSettings["Port"];



            var smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential(UserName, Password);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = Convert.ToInt32(Port);
            ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
            { return true; };
            smtp.Send(msg);
        }
        public static void SendEmailTOCCReplyToWithAttachment(string fromEmail, string[] toEmail, string[] CCEmail, string[] ReplyTo, string subject, string receiverUserName, string htmlContent, byte[] filebytes, string filename)
        {
            var msg = new MailMessage();
            foreach (var email in toEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.To.Add(email);
            }
            foreach (var email in CCEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.CC.Add(email);
            }
            msg.From = new MailAddress(fromEmail, "M61 Support");

            foreach (var email in ReplyTo)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.ReplyToList.Add(email);
            }



            msg.Body = htmlContent;
            msg.Subject = subject;
            msg.IsBodyHtml = true;
            if (filebytes.Length > 0)
            {
                msg.Attachments.Add(new Attachment(new MemoryStream(filebytes), filename));
            }

            //get email setting from config file
            // var newsection = new EmailSender();
            string Host = Sectionroot.GetSection("Host").Value;
            string UserName = Sectionroot.GetSection("UserName").Value;
            string Password = Sectionroot.GetSection("Password").Value;
            string Port = Sectionroot.GetSection("Port").Value;

            //string Host = ConfigurationManager.AppSettings["Host"];
            //string UserName = ConfigurationManager.AppSettings["UserName"];
            //string Password = ConfigurationManager.AppSettings["Password"];
            //string Port = ConfigurationManager.AppSettings["Port"];



            var smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential(UserName, Password);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = Convert.ToInt32(Port);
            ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
            { return true; };
            smtp.Send(msg);
        }
        public static void SendTOWPApproverEmail(string fromEmail, string toEmail, string subject, string bodyText, string htmlContent)
        {

            var msg = new MailMessage();
            msg.To.Add(toEmail);
            // msg.From = new MailAddress(fromEmail, "M61 Support");
            msg.Body = htmlContent;
            msg.Subject = subject;
            msg.IsBodyHtml = true;

            //get email setting from config file

            string Host = Sectionroot.GetSection("Host").Value;
            string UserName = Sectionroot.GetSection("UserName").Value;
            string Password = Sectionroot.GetSection("Password").Value;
            string Port = Sectionroot.GetSection("Port").Value;

            //string Host = ConfigurationManager.AppSettings["Host"];
            //string UserName = ConfigurationManager.AppSettings["UserName"];
            //string Password = ConfigurationManager.AppSettings["Password"];
            //string Port = ConfigurationManager.AppSettings["Port"];

            msg.From = new MailAddress(UserName, "M61 Support");
            var smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential(UserName, Password);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = Convert.ToInt32(Port);
            ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
            { return true; };
            smtp.Send(msg);

        }

        //generic email used for automation
        public static void SendGenericEmail(string fromEmail, string[] toEmail, string[] CCEmail, string[] BccEmail, string[] ReplyTo, string subject, string htmlContent, string[] FilePath, EmailSettings emailSettings)
        {
            var msg = new MailMessage();



            foreach (var email in toEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.To.Add(email);
            }
            foreach (var email in CCEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.CC.Add(email);
            }

            foreach (var email in BccEmail)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.Bcc.Add(email);
            }
            foreach (var email in ReplyTo)
            {
                if (!string.IsNullOrEmpty(email))
                    msg.ReplyToList.Add(email);
            }

            msg.From = new MailAddress(fromEmail, "M61 Support");
            msg.Body = htmlContent;
            msg.Subject = subject;
            msg.IsBodyHtml = true;

            foreach (var path in FilePath)
            {
                if (!string.IsNullOrEmpty(path))
                    msg.Attachments.Add(new Attachment(path));
            }


            //get email setting from config file
            // var newsection = new EmailSender();
            //string Host = Sectionroot.GetSection("Host").Value;
            //string UserName = Sectionroot.GetSection("UserName").Value;
            //string Password = Sectionroot.GetSection("Password").Value;
            //string Port = Sectionroot.GetSection("Port").Value;

            string Host = emailSettings.Host;
            string UserName = emailSettings.UserName;
            string Password = emailSettings.Password;
            string Port = emailSettings.Port;

            var smtp = new SmtpClient();
            smtp.Host = Host;
            smtp.EnableSsl = true;
            NetworkCredential NetworkCred = new NetworkCredential(UserName, Password);
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = NetworkCred;
            smtp.Port = Convert.ToInt32(Port);
            ServicePointManager.ServerCertificateValidationCallback = delegate (object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
            { return true; };
            smtp.Send(msg);
            // added code to remove lock from file  
            foreach (Attachment attachment in msg.Attachments)
            {
                attachment.Dispose();
            }
        }


    }
}
