using System;

namespace CRES.DataContract
{
    public partial class OutputAllTabData
    {
        public OutputAllTabData()
        { }
        public DateTime? PaymentDate { get; set; }
        public Decimal? InterestPaidonPaymentDate { get; set; }
        public Decimal? InterestPaidperServicing { get; set; }
        public Decimal? PrincipalPaid { get; set; }
        public Decimal? PrincipalReceivedperServicing { get; set; }

    }
}
