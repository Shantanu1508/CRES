using System;

namespace CRES.DataContract
{
    public class ReserveAccountDataContract
    {
        public int ReserveAccountID { get; set; }
        public Guid? ReserveAccountGUID { get; set; }
        public int CREReserveAccountID { get; set; }
        public Guid? DealID { get; set; }
        public string ReserveAccountName { get; set; }
        public decimal InitialBalanceDate { get; set; }
        public decimal InitialFundingAmount { get; set; }
        public decimal EstimatedReserveBalance { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
        public decimal FloatInterestRate { get; set; }

        public decimal CurrentBalance { get; set; }
        public decimal RequestAmount { get; set; }
        public decimal NewBalance { get; set; }

    }
}
