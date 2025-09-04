using System;

namespace CRES.DataContract
{
  public  class AutomationExtensionDataContract
    {
        public string DealID { get; set; }
        public int BatchID { get; set; }
        public string ErrorMessage { get; set; }
        public string Message { get; set; }
        public string UserName { get; set; }
        public string DealFundingID { get; set; }
        public string PurposeType { get; set; }
        public decimal? Amount { get; set; }
        public DateTime? Date { get; set; }      


    }
}
