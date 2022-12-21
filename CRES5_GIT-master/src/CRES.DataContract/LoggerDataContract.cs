namespace CRES.DataContract
{
    public class LoggerDataContract
    {
        public string Severity { get; set; }
        public string Module { get; set; }
        public string Message { get; set; }
        public string Message_StackTrace { get; set; }
        public string Priority { get; set; }
        public string ExceptionSource { get; set; }
        public string MethodName { get; set; }
        public string RequestText { get; set; }
        public string ObjectID { get; set; }
        public string CreatedBy { get; set; }

    }
}
