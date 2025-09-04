using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class MaturityScenariosDataContract
    {
        public Guid? NoteID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public Guid? EventId { get; set; }
        public DateTime? SelectedMaturityDate { get; set; }
        public string Type { get; set; }
        public string ScheduleID { get; set; }
        public DateTime? Date { get; set; }
        public int? ModuleId { get; set; }
        public List<MaturityDateList> MaturityDateList { get; set; }
        public DateTime? ExpectedMaturityDate { get; set; }
        public DateTime? ActualPayoffDate { get; set; }
        public DateTime? OpenPrepaymentDate { get; set; }
        public DateTime? MaturityDate { get; set; }
        public DateTime? FullyExtendedMaturityDate { get; set; }
        public string CRENoteID { get; set; }
        

        public int Approved { get; set; }
        public int MaturityID { get; set; }
        // public Guid? AccountID { get; set; }
        // public Guid? MaturityID { get; set; }
        //public string CreatedBy { get; set; }
        //public DateTime? CreatedDate { get; set; }
        //public string UpdatedBy { get; set; }
        //public DateTime? UpdatedDate { get; set; }
    }

    public class MaturityDateList
    {
        public DateTime? MaturityDate { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public string Type { get; set; }
        public string Approved { get; set; }
    }

}
