namespace CRES.DataContract
{
    public class LookupDataContract
    {
        public int LookupID { get; set; }
        public int ParentID { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }
        public short SortOrder { get; set; }
        public int StatusID { get; set; }
    }
}
