using System;

namespace CRES.DataContract
{
    public class FileImportMasterDataContract
    {

        public int FileImportMasterID { get; set; }
        public string FileName { get; set; }
        public int ObjectTypeID { get; set; }
        public int SourceStorageTypeID { get; set; }
        public string SourceStorageLocation { get; set; }
        public int HeaderPosition { get; set; }
        public int Status { get; set; }
        public string Frequency { get; set; }
        public DateTime? LastExecutionTime { get; set; }
    }
}
