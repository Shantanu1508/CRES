using CRES.DataContract;
using CRES.Utilities;
using ExcelDataReader;
using Microsoft.Extensions.Configuration;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CRES.NoteCalculatorServiceMVC.Infrastructure
{
    public class AzureStorageReadFile
    {
        IConfigurationSection Sectionroot = null;
        static IConfigurationSection SectionrootStatic = null;
        public string connectionString = "";
        public string sourceContainerName = "";

        public AzureStorageReadFile()
        {
            GetConfigSetting();
            connectionString = Sectionroot.GetSection("storage:container:connectionstring").Value;
            sourceContainerName = Sectionroot.GetSection("storage:container:name").Value;
        }
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

        public static void GetConfigSettingforStatic()
        {
            if (SectionrootStatic == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                SectionrootStatic = root.GetSection("Application");
            }
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
    }
}