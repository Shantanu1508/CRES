using System;

namespace CRES.DataContract
{
    public class NoteCashflowsExportDataContract
    {
        public string NoteID { get; set; }
        public string NoteName { get; set; }
        public Nullable<System.DateTime> Date { get; set; }
        public string DisplayDate { get; set; }
        public Nullable<decimal> Value { get; set; }
        public string ValueType { get; set; }
    }
}
