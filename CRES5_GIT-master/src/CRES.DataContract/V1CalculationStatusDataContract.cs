using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class V1CalculationStatusDataContract
    {
        public string DealID { get; set; }
        public string RequestID { get; set; }
        public string AnalysisID { get; set; }
        public string objectID { get; set; }
        public int? objectTypeId { get; set; }
        public int? CalcType { get; set; }

        public int? TransactionOutput { get; set; }
        public int? NotePeriodicOutput { get; set; }
        public int? StrippingOutput { get; set; }
        public int? Prepaypremium_Output { get; set; }
        public int? Prepayallocations_Output { get; set; }
        public int? DailyInterestAccOutput { get; set; }
    }

    public class V1CalcQueueSaveOutput
    {
        public string requestid { get; set; }
        public string headerkey {  get; set; }
        public string headerValue { get; set; }
        public string strAPI {  get; set; }
        public string SourceNoteID {  get; set; }
        public string AnalysisID { get; set;}
        public string username {  get; set; }
        public string noteid { get; set; }

        public int CalcType { get; set; }

    }

}
