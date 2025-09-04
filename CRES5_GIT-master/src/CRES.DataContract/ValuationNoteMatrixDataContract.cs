using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationNoteMatrixDataContract
    {

        public DateTime? MarkedDate { get; set; }
        public String NoteMatrixSheetName { get; set; }
        public String DealID { get; set; }
        public String DealGroupID { get; set; }
        public String NoteID { get; set; }
        public String DealName { get; set; }
        public String NoteName { get; set; }
        public Decimal? Commitment { get; set; }
        public DateTime? InitialFunding { get; set; }
        public DateTime? CurrentMaturity_Date { get; set; }
        public Decimal? OriginationFee { get; set; }
        public Decimal? ExtensionFee1 { get; set; }
        public Decimal? ExtensionFee2 { get; set; }
        public Decimal? ExtensionFee3 { get; set; }
        public Decimal? ExitFee { get; set; }
        public String ProductType { get; set; }
        public Decimal? AcoreOrig { get; set; }
        public String UserID { get; set; }
    }
}
