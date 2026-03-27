using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class PrincipalWriteoffDataContract
    {
        public List<AutoDistributeWriteoffDataContract> AutoDistributeWriteoffList { get; set; }
        public List<ServicingPotentialDealWriteoffDataContract> ServicingPotentialDealWriteoffList { get; set; }
        public List<ServicingPotentialNoteWriteoffDataContract> ServicingPotentialNoteWriteoffList { get; set; }
        public string GenerationExceptionMessage { get; set; }
        public string GenerationStackTrace { get; set; }
        public String DealID { get; set; }

    }
}
