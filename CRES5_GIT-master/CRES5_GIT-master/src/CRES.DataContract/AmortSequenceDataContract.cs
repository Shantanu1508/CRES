using System;

namespace CRES.DataContract
{
    public class AmortSequenceDataContract
    {
        public Guid? NoteID { get; set; }
        public int? SequenceNo { get; set; }
        public string SequenceType { get; set; }
        public string SequenceTypeText { get; set; }
        public Decimal? Value { get; set; }
        public Decimal? Ratio { get; set; }
    }
}
