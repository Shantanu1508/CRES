using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class DealAmortScheduleDataContract
    {
        public Guid? DealAmortizationScheduleID { get; set; }
        //  public Int32? DealAmortizationScheduleAutoID { get; set; }
        public int? DealAmortScheduleRowno { get; set; }
        public Guid? DealID { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public bool IsDelete { get; set; }
    }

    public class NoteAmortScheduleDataContract
    {
        public Guid? DealAmortizationScheduleID { get; set; }
        public int? DealAmortScheduleRowno { get; set; }
        public Guid? DealID { get; set; }
        public DateTime? Date { get; set; }
        public string NoteID { get; set; }
        public string CRENoteID { get; set; }
        public string NoteName { get; set; }
        public Decimal? Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }

    public class AmortTargetNoteFundingScheduleDataContract
    {
        public Guid? NoteID { get; set; }
        public DateTime? Date { get; set; }
        public Decimal? Value { get; set; }
        public String NoteName { get; set; }
        public string DrawFundingId { get; set; }
        public int? DealFundingRowno { get; set; }
    }

}
