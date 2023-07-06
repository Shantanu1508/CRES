using Microsoft.Extensions.Configuration;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.IO;
using System.Text;


namespace CRES.Utilities
{
    public class AzureStorageRead
    {

#pragma warning disable CS0414 // The field 'AzureStorageRead.Sectionroot' is assigned but its value is never used
        IConfigurationSection Sectionroot = null;
#pragma warning restore CS0414 // The field 'AzureStorageRead.Sectionroot' is assigned but its value is never used
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

        public string GetRuleJSONFileToAzureBlob(string FileName)
        {
            string res = "";

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
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
                res = blockBlob.DownloadText(); //.Replace(Environment.NewLine, @"< br />");

            }
            catch (Exception ex)
            {
                // throw;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            return res;
        }

        public static Boolean UploadJSONFileToAzureBlob(string jsontext, string FileName)
        {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                GetConfigSettingforStatic();
                byte[] byteArray = Encoding.ASCII.GetBytes(jsontext);
                MemoryStream stream = new MemoryStream(byteArray);
                var Container = SectionrootStatic.GetSection("storage:container:name").Value;
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
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
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
