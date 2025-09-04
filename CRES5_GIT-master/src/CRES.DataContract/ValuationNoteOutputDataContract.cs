using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ValuationNoteOutputDataContract
    {
        public string NoteID { get; set; }
        public string DealID { get; set; }
        public string CalculationStatus { get; set; }
        public DateTime?  LastCalculatedOn { get; set; }
        public Decimal? NoteMarkPriceClean { get; set; }
        public Decimal? NoteGAAPPriceClean { get; set; }
        public Decimal? NoteUPB { get; set; }
        public Decimal? NoteMarkClean { get; set; }
        public Decimal? NoteCommitment { get; set; }
        public Decimal? NoteBasisDirty { get; set; }
        public Decimal? NoteYieldatGAAPBasis { get; set; }
        public Decimal? CalculatedNoteAccruedRate { get; set; }
        public Decimal? NoteGAAPDMIndex { get; set; }
        public Decimal? NoteMarkYield { get; set; }
        public Decimal? NoteMarkDMgtrFLRIndex { get; set; }
        public Decimal? NoteDurationonCommitment { get; set; }
        public string UserID { get; set; }
        public DateTime? MarkedDate { get; set; }
    }
}
