using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;



namespace CRES.Utilities
{
    public static class DocumentHelper
    {

        public static string DocumentPath(string documentName)
        {
            string _documentPath = string.Empty;

            string BlobUrl = ConfigurationManager.AppSettings["storage:account:url"].Replace("https://","");
            string BlobContainer = ConfigurationManager.AppSettings["storage:container:name"] + "/";
            _documentPath =  BlobUrl + BlobContainer + documentName;

            return _documentPath;
        }

    }
}
