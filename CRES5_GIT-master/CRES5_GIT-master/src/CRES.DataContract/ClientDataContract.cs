namespace CRES.DataContract
{
    public class ClientDataContract
    {
        public int ClientID { get; set; }
        public string ClientName { get; set; }
        public string EmailID { get; set; }
        public string ClientsName { get; set; }
        public string EmailIDs { get; set; }
        public int? LookupID { get; set; }
        public string ClientFunding { get; set; }
        public string DealClients { get; set; }
    }

    public class FundDataContract
    {
        public int FundID { get; set; }
        public string FundName { get; set; }
    }
}
