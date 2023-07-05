using System;

namespace CRES.DataContract
{
    public class DrawFeeInvoiceBatchUploadDataContract
    {
        public string CreDealID { get; set; }
        public DateTime InvoiceDate { get; set; }
        public DateTime InvoiceDateOriginal { get; set; }
        public string InvoiceNo { get; set; }
        public DateTime InvoiceDueDate { get; set; }
        public decimal? Amount { get; set; }
        public int InvoiceTypeID { get; set; }
        public int DrawFeeStatus { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Designation { get; set; }
        public string CompanyName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string Email1 { get; set; }
        public string Email2 { get; set; }
        public string PhoneNo { get; set; }
        public string AlternatePhone { get; set; }
        public string Comment { get; set; }
        public int ObjectTypeID { get; set; }

    }
}
