using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
