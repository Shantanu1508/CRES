using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class EmailDataContract
    {
        public EmailDataContract()
        {
            EmailSettings = new EmailSettings();
        }
        public string Subject { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }
        public string Bcc { get; set; }
        public string Body { get; set; }
        public string ReceiverName { get; set; }
        public string ReplyTo { get; set; }
        public List<FileAttachmentDataContract> FileAttachment;
        public string TemplatePath {get;set;}
        //email setting
        public EmailSettings EmailSettings { get; set; }
        public int ModuleId { get; set; }
        public string EmailID { get; set; }

        public int? Type { get; set; }    


    }
    public class FileAttachmentDataContract
    {
        public string FilePath { get; set; }
    }

    public class EmailSettings
    {
        public string Host { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Port { get; set; }
    }
}
