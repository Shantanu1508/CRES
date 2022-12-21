using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class FinancingWarehouseDataContract
    {
        public Guid? FinancingWarehouseID { get; set; }
        public Guid? AccountID { get; set; }
        public string Name { get; set; }
        public int? StatusID { get; set; }
        public string StatusIDText { get; set; }
        public int? IsRevolving { get; set; }
        public string IsRevolvingText { get; set; }
        public int? BaseCurrencyID { get; set; }
        public string BaseCurrencyIDText { get; set; }
        public decimal? OriginationFee { get; set; }
        public int? PayFrequency { get; set; }
        public decimal? TotalConstraint { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public List<FinancingWarehouseDetailDataContract> lstFinancingWarehouseDetail { get; set; }
    }
}
