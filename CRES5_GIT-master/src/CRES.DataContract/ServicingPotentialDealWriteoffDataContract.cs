using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class ServicingPotentialDealWriteoffDataContract
    {
        public int? WLDealPotentialImpairmentID { get; set; }
        public string DealID { get; set; }
        public DateTime? Date { get; set; }
        public decimal? Value { get; set; }
        public int? AdjustmentType { get; set; }
        public string AdjustmentTypeText { get; set; }
        public string Comment { get; set; }
        public int RowNo { get; set; }
        public bool Applied { get; set; }       
        public string UserID { get; set; }
        public int IsDeleted { get; set; }
    }
}
