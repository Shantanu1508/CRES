using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
using System.Threading.Tasks;
using static CRES.DataContract.V1CalcDataContract;

namespace CRES.DataContract
{
    public class ServicingWatchlistDataContract
    {
        public String CreDealID { get; set; }
        public String DealID { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? TypeID { get; set; }
        public string TypeText { get; set; }
        public string Comment { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public Decimal? Amount { get; set; }        
        public string UserID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? WLDealAccountingID { get; set; }
        public int? WLDealLegalStatusID { get; set; }
        public int? WLDealPotentialImpairmentID { get; set; }
        public Boolean? IsDeleted { get; set; }
        public string Type { get; set; }
        public string ReasonCode { get; set; }

    }
}
