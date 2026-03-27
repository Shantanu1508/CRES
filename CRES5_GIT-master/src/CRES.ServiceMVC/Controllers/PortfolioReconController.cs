using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using CRES.DataContract;
using CRES.BusinessLogic;
using System.Net.Http.Headers;
using Microsoft.AspNetCore.Mvc;
using CRES.BusinessLogic;
using System.Text;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using System.Diagnostics;
using System.IO;
using iTextSharp.tool.xml;
using iTextSharp.text.html.simpleparser;
using Microsoft.Extensions.Configuration;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Auth;
using iTextSharp.tool.xml.pipeline.html;
using iTextSharp.tool.xml.html;
using Microsoft.AspNetCore.Html;
using CRES.Utilities;
using System.Net.Mail;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using CRES.Services.Infrastructure;
using System.Threading.Tasks;

namespace CRES.ServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class PortfolioReconController : ControllerBase
    {
        IConfigurationSection Sectionroot = null;
        public void GetConfigSetting()
        {
            if (Sectionroot == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }
        
        [HttpGet]
        [Services.Controllers.DeflateCompression]
        [Route("api/ImportExportController/TestDBRestore")]
        public void TestDBRestore()
        {

            GenericResult _authenticationResult = null;
            string sr = string.Empty;
            PortfolioReconLogic _logic = new PortfolioReconLogic();

            GetConfigSetting();
            var Container = Sectionroot.GetSection("storage:container:name").Value;
            CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);
            CloudBlobDirectory blobDirectory = container.GetDirectoryReference("dbrefreshscripts-portrecon");
            CloudBlockBlob blockBlob;
            StreamReader reader;

            blockBlob = blobDirectory.GetBlockBlobReference("PreReleaseScripts.sql");
            reader = new StreamReader(blockBlob.OpenRead());
            sr = reader.ReadToEnd();
            if (sr.Length > 0)
                _logic.ExecuteSQLScript(sr);

            blockBlob = blobDirectory.GetBlockBlobReference("ReleaseScripts.sql");
            reader = new StreamReader(blockBlob.OpenRead());
            sr = reader.ReadToEnd();
            if (sr.Length > 0)
                _logic.ExecuteSQLScript(sr);

            blockBlob = blobDirectory.GetBlockBlobReference("PostReleaseScripts.sql");
            reader = new StreamReader(blockBlob.OpenRead());
            sr = reader.ReadToEnd();
            if (sr.Length > 0)
                _logic.ExecuteSQLScript(sr);

            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Release scripts executed successfully."
            };
        }
    }
}
