using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    //  DrawFeeInvoiceDataContract
    public class DrawFeeInvoiceDataContract
    {
        public int DrawFeeInvoiceDetailID { get; set; }
        public string InvoiceNo { get; set; }
        public string InvoiceNoUI { get; set; }
        public Guid TaskID { get; set; }
        public int ObjectTypeID { get; set; }
        public string ObjectID { get; set; }
        public decimal? Amount { get; set; }
        public decimal AmountPaid { get; set; }
        public decimal AmountAdj { get; set; }
        public DateTime? PaymentDate { get; set; }
        public string AdjComments { get; set; }
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
        public int AutoSendInvoice { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
        public DateTime FundingDate { get; set; }
        public int DrawFeeStatus { get; set; }
        public string DrawFeeStatusText { get; set; }
        public string FileName { get; set; }
        public string CreDealID { get; set; }
        public string DrawNo { get; set; }
        public bool IsExistCustomer { get; set; }
        public bool IsExistCompany { get; set; }
        public int InvoiceTypeID { get; set; }
        public string ID { get; set; }
        public string EndPointID { get; set; }
        public string DealName { get; set; }
        public string StorageType { get; set; }
        public string StorageTypeId { get; set; }
        //IsManualInvoice
        public bool IsManualInvoice { get; set; }
        public string TemplateName { get; set; }
        public string InvoiceCode { get; set; }
        public bool IsLogActivity { get; set; }
        public int? StateID { get; set; }
        public bool IsSuccess { get; set; }
        public string InvoiceSource { get; set; }
        public MemoryStream filestream { get; set; }
        public string AMEmails {get;set;}
        public string SenderFirstName { get;set; }
        public string SenderLastName { get;set; }
        public string SenderEmail { get;set; }

        public decimal? FundingAmount { get; set; }
        public string DealID { get; set; }

        public DateTime InvoiceDate { get; set; }
        public DateTime InvoiceDateOriginal { get; set; }
        public DateTime InvoiceDueDate { get; set; }
        public string BatchUploadComment { get; set; }
        //CurrentDate
        public DateTime CurrentDate { get; set; }
        public string InvoiceTypeName { get; set; }
        public string UploadedFrom { get; set; }
        public List<InvoiceReferenceDataContract> InvoiceReferenceData { get; set; }

        public string EmailCC { get; set; }
        public string InvoiceComment { get; set; }
        public string PreAssignedInvoiceNo { get; set; }
        public string InvoiceGuid { get; set; }
        public string CreatedFrom { get; set; }
        public string InvoiceTypeFreeText { get; set; }
        public string WorkDescription { get; set; }
    }
}
