using System;

namespace CRES.DataContract
{
    public class NoteUnderwritingAttributesDataContract
    {
        public int NoteUnderwritingID { get; set; }
        public string NoteID { get; set; }
        public string NoteName { get; set; }
        public int? DealID { get; set; }
        public string NoteLienPosition { get; set; }
        public Decimal? NotePer { get; set; }
        public Decimal? NoteTotalAmount { get; set; }
        public Decimal? NotePerUnit { get; set; }
        public int? NoteRateType { get; set; }
        public Decimal? NoteInterestRate { get; set; }
        public Decimal? NoteSpread { get; set; }
        public Decimal? NoteFloor { get; set; }
        public int? NoteAmort { get; set; }
        public Decimal? NoteOriginationFee { get; set; }
        public Decimal? NoteExitFee { get; set; }
        public Decimal? NoteStabilizedDebtYield { get; set; }
        public Decimal? NoteDSCR { get; set; }
        public Decimal? NoteStabilizedLTC { get; set; }
        public Decimal? NoteStabilizedLTVACORE { get; set; }
        public Decimal? NoteStabilizedLTVAppraisal { get; set; }


        public int? NoteType { get; set; }
        public Decimal? NoteUWDSCR { get; set; }
        public int? NoteIndex { get; set; }
        public Decimal? NoteMargin { get; set; }


        public string NoteRateTypeText { get; set; }
        public string NoteTypeText { get; set; }
        public string NoteIndexText { get; set; }

        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
