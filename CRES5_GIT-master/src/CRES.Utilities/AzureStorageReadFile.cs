using Microsoft.Extensions.Configuration;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Configuration.FileExtensions;
using Newtonsoft.Json;
using Microsoft.Extensions.Configuration.Json;
using CRES.DataContract;
using System.Data;
using System.Threading.Tasks;
using ExcelDataReader;


namespace CRES.Utilities
{
    public   class AzureStorageRead
    {

        static IConfigurationSection Sectionroot = null;
        static IConfigurationSection SectionrootStatic = null;
        public string connectionString = "";
        public string sourceContainerName = "";

        public static void GetConfigSettingforStatic()
        {
            if (SectionrootStatic == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "App.config"));
                var root = builder.Build();
                SectionrootStatic = root.GetSection("appSettings");
            }
        }

        public  string GetRuleJSONFileToAzureBlob(string FileName)
        {
            string res = "";

            try
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));

                var root = builder.Build();
                var Container = root.GetSection("Application").GetSection("storage:calccontainer:name").Value;
               
                // Get Blob Container
                CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);

                var Foldername = root.GetSection("Application").GetSection("storage:calccontainer:folder").Value;
                CloudBlobDirectory blobDirectory = container.GetDirectoryReference(Foldername);
                CloudBlockBlob blockBlob = blobDirectory.GetBlockBlobReference(FileName);
                res= blockBlob.DownloadText(); //.Replace(Environment.NewLine, @"< br />");

            }
            catch (Exception ex)
            {
               // throw;
            }
            return res;
        }

        public static void GetConfigSetting()
        {
            if (Sectionroot == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }
        public static Boolean UploadJSONFileToAzureBlob(string jsontext, string FileName)
        {
            try
            {
                GetConfigSetting();
                byte[] byteArray = Encoding.ASCII.GetBytes(jsontext);
                MemoryStream stream = new MemoryStream(byteArray);
                var Container = Sectionroot.GetSection("storage:container:name").Value;
                // Get Blob Container
                CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);
                CloudBlobDirectory blobDirectory = container.GetDirectoryReference("CalcDebug");
                CloudBlockBlob blockBlob = blobDirectory.GetBlockBlobReference(FileName);
                blockBlob.UploadFromStream(stream);
                return true;
            }
            catch (Exception ex)
            {
                return false;
                throw;
            }
        }

        public static async Task<Stream> ReadAccountingReportStream(ReportFileDataContract ReportFileDC)
        {
            GetConfigSettingforStatic();
            DataTable dt = new DataTable();
            DataSet ds;
            string fileName = "";
            Stream TemplateMemoryStream = new MemoryStream();
            IExcelDataReader iExcelDataReader = null;
            List<string> lstTemplateLines = new List<string>();
            //392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer

            try
            {

                if (ReportFileDC.SourceStorageTypeID == 641)
                {
                    fileName = Path.Combine(Directory.GetCurrentDirectory() + "/wwwroot", ReportFileDC.SourceStorageLocation + "/" + ReportFileDC.ReportFileTemplate);

                    TemplateMemoryStream = File.OpenRead(fileName);
                }
                else if (ReportFileDC.SourceStorageTypeID == 392)
                {
                    var Container = SectionrootStatic.GetSection("storage:container:name").Value;
                    CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);

                    // Create the blob client.
                    CloudBlobDirectory dr = container.GetDirectoryReference(ReportFileDC.SourceStorageLocation);
                    CloudBlockBlob cloudBlockBlob = dr.GetBlockBlobReference(ReportFileDC.ReportFileTemplate);
                    cloudBlockBlob.DownloadToStream(TemplateMemoryStream);
                }
                else if (ReportFileDC.SourceStorageTypeID == 459)
                {
                    DocumentDataContract _docDC = new DocumentDataContract();
                    _docDC.DocumentStorageID = ReportFileDC.DocumentStorageID;
                    // TemplateMemoryStream = await new CRES.Services.Infrastructure.BoxHelper().DownloadFile(_docDC);
                }
                else if (ReportFileDC.SourceStorageTypeID == 642)
                {

                }

            }
            catch (Exception ex)
            {
                var error = ex.Message;
                // throw;

                Logger.Write("Error detail", ex);
                throw ex;
            }
            return TemplateMemoryStream;
        }

        public static Stream ReadAccountingReportInStream(ReportFileDataContract ReportFileDC)
        {
            GetConfigSettingforStatic();
            DataTable dt = new DataTable();
            DataSet ds;
            string fileName = "";
            Stream TemplateMemoryStream = new MemoryStream();
            IExcelDataReader iExcelDataReader = null;
            List<string> lstTemplateLines = new List<string>();
            //392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer

            try
            {

                if (ReportFileDC.SourceStorageTypeID == 641)
                {
                    fileName = Path.Combine(Directory.GetCurrentDirectory() + "/wwwroot", ReportFileDC.SourceStorageLocation + "/" + ReportFileDC.ReportFileTemplate);

                    TemplateMemoryStream = File.OpenRead(fileName);
                }
                else if (ReportFileDC.SourceStorageTypeID == 392)
                {
                    var Container = SectionrootStatic.GetSection("storage:container:name").Value;
                    CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);

                    // Create the blob client.
                    CloudBlobDirectory dr = container.GetDirectoryReference(ReportFileDC.SourceStorageLocation);
                    CloudBlockBlob cloudBlockBlob = dr.GetBlockBlobReference(ReportFileDC.ReportFileTemplate);
                    cloudBlockBlob.DownloadToStream(TemplateMemoryStream);
                }
                else if (ReportFileDC.SourceStorageTypeID == 459)
                {
                    //DocumentDataContract _docDC = new DocumentDataContract();
                    //_docDC.DocumentStorageID = ReportFileDC.DocumentStorageID;
                    //TemplateMemoryStream = await new CRES.NoteCalculatorServiceMVC.Infrastructure.BoxHelper().DownloadFile(_docDC);
                }
                else if (ReportFileDC.SourceStorageTypeID == 642)
                {

                }

            }
            catch (Exception ex)
            {
                var error = ex.Message;
                // throw;

                Logger.Write("Error detail", ex);
                throw ex;
            }
            return TemplateMemoryStream;
        }
    }


    internal class BlobUtilities
    {
        public static CloudBlobClient GetBlobClient
        {
            get
            {

                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));

                var root = builder.Build();
                var accountName = root.GetSection("Application").GetSection("storage:account:name").Value;
               var accountKey = root.GetSection("Application").GetSection("storage:account:key").Value;
                CloudStorageAccount storageAccount = CloudStorageAccount.Parse("DefaultEndpointsProtocol=https;AccountName=" + accountName + ";"
                 + "AccountKey=" + accountKey + "");
                CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
                return blobClient;
            }
        }
    }
}
