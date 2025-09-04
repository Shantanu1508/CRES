using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class DataDictionaryDataContract
    {
        public DataDictionaryDataContract()
        { }

        public int? DataDictionaryID { get; set; }
        public string NamedRange { get; set; }
        public string NamedCell { get; set; }
        public string DataType { get; set; }
        public string Required { get; set; }
        public string DBField { get; set; }
        public string IsDropDown { get; set; }
        public string UsedInSizer { get; set; }
        public string UsedInBatchUpload { get; set; }

    }

    public class RefreshLookupDataContract
    {
        public string LookupID { get; set; }
        public string Name { get; set; }
        public string DisplayValues { get; set; }
        public int ParentID { get; set; }
    }

    public class IndexDefaultLiborRateDataContract
    {
        public DateTime Date { get; set; }
        public decimal? Value { get; set; }
    }

    public class NoteOutputforVSTO
    {
        public string CRENoteID { get; set; }
        public string NoteName { get; set; }
        public DateTime? MaturityUsedInCalc { get; set; }
        public List<NotePeriodicOutputsDataContract> ListNotePeriodicOutputs { get; set; }
        public List<TransactionEntry> ListCashflowTransactionEntry { get; set; }
    }

    public class CalculatorOuputForVSTO
    {
        public string CRENoteID { get; set; }
        public string NoteName { get; set; }
        public List<PeriodicCashflowVSTO> ListNotePeriodicOutputs { get; set; }
        public List<TransactionEntryVSTO> ListTransactionEntry { get; set; }
        public DataTable XIRROutput { get; set; }
    }

    public class RefreshTagXIRRDataContract
    {
        public string TableName { get; set; }
        public string TagName { get; set; }
        public string ObjectID { get; set; }
        public string NoteName { get; set; }
        public string CREDealID { get; set; }
        public string DealName { get; set; }
        public string Location { get; set; }
        public string PropertyType { get; set; }
        public string FinancingSourceType { get; set; }
    }

}
