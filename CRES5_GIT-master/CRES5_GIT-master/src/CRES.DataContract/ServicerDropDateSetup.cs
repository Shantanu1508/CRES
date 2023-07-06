using System;

namespace CRES.DataContract
{
    public class ServicerDropDateSetup
    {
        public Guid? ServicerDropDateSetupID { get; set; }
        public Guid? NoteID { get; set; }
        public DateTime? ModeledPMTDropDate { get; set; }
        public DateTime? PMTDropDateOverride { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
