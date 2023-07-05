namespace CRES.DataContract
{
    public class FileImportColumnMappingDataContract
    {
        public int FileImportColumnMappingID { get; set; }
        public int FileImportMasterID { get; set; }
        public string FileColumnName { get; set; }
        public string LandingColumnName { get; set; }
    }
}
