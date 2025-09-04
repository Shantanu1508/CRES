using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class SizerGenericResult
    {
        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public List<DataDictionaryDataContract> DataDictionaryList { get; set; }
        public List<RefreshLookupDataContract> LookupList { get; set; }
        public DealDataContract DealDC { get; set; }
        public List<NoteDataContract> NoteDC { get; set; }
        public List<PayruleDealFundingDataContract> DealFundingDC { get; set; }
        public string NoteOutputJson { get; set; }
        public List<IndexDefaultLiborRateDataContract> LiborRateList { get; set; }
        public List<RefreshTagXIRRDataContract> TagXIRRList { get; set; }
    }
}
