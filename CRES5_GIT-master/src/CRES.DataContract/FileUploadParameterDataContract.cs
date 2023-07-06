namespace CRES.DataContract
{
    public class FileUploadParameterDataContract
    {
        public int StorageTypeID { get; set; }
        public string StorageLocation { get; set; }
        public string FileName { get; set; }
        public string Document { get; set; }
        public int HeaderPosition { get; set; }

    }
}
