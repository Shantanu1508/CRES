using System;

namespace CRES.DataContract
{
    public class FinancingWarehouseDetailDataContract
    {
        public Guid? FinancingWarehouseDetailID { get; set; }
        public Guid? FinancingWarehouseID { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal? Value { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
    }
}
