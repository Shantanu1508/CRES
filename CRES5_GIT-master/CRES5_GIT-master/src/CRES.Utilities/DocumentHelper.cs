using System.Configuration;



namespace CRES.Utilities
{
    public static class DocumentHelper
    {

        public static string DocumentPath(string documentName)
        {
            string _documentPath = string.Empty;

            string BlobUrl = ConfigurationManager.AppSettings["storage:account:url"].Replace("https://", "");
            string BlobContainer = ConfigurationManager.AppSettings["storage:container:name"] + "/";
            _documentPath = BlobUrl + BlobContainer + documentName;

            return _documentPath;
        }

    }
}
