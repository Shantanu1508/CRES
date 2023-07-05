namespace CRES.DataContract
{
    public class v1GenericResult
    {
        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public int Status { get; set; }
        public string ErrorDetails { get; set; }
    }
}
