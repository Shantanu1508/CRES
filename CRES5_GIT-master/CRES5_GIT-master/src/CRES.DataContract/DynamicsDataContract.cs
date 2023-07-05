using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class DynamicsCustomerInput
    {
        public string id { get; set; }
        public string number { get; set; }
        public string displayName { get; set; }
        public string type { get; set; }
        public string addressLine1 { get; set; }
        public string addressLine2 { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string country { get; set; }
        public string postalCode { get; set; }
        public string phoneNumber { get; set; }
        public string email { get; set; }
        public string website { get; set; }
        public bool taxLiable { get; set; }
        public string taxRegistrationNumber { get; set; }
        public string currencyId { get; set; }
        public string currencyCode { get; set; }
        public string paymentTermsId { get; set; }

        public string shipmentMethodId { get; set; }
        public string blocked { get; set; }
    }

    public class DynamicsCustomerOutput
    {
        public string id { get; set; }
        public string number { get; set; }
        public string displayName { get; set; }
        public string type { get; set; }
        public string addressLine1 { get; set; }
        public string addressLine2 { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string country { get; set; }
        public string postalCode { get; set; }
        public string phoneNumber { get; set; }
        public string email { get; set; }
        public string website { get; set; }
        public string salespersonCode { get; set; }
        public decimal balanceDue { get; set; }
        public decimal creditLimit { get; set; }
        public bool taxLiable { get; set; }
        public string taxAreaId { get; set; }
        public string taxAreaDisplayName { get; set; }
        public string taxRegistrationNumber { get; set; }
        public string currencyId { get; set; }
        public string currencyCode { get; set; }
        public string paymentTermsId { get; set; }
        public string shipmentMethodId { get; set; }
        public string paymentMethodId { get; set; }
        public string blocked { get; set; }
        //public DateTime lastModifiedDateTime { get; set; }
    }


    public class DynamicsODataCustomerInput
    {
        public string Name { get; set; }
        public string Name_2 { get; set; }
        public string Search_Name { get; set; }
        public string Address { get; set; }
        public string Address_2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country_Region_Code { get; set; }
        public string Post_Code { get; set; }
        public string Phone_No { get; set; }
        public string E_Mail { get; set; }
        public string Fax_No { get; set; }
        public string Home_Page { get; set; }
        public string Primary_Contact_No { get; set; }
        public string Contact { get; set; }
        public string Location_Code { get; set; }
        public string IC_Partner_Code { get; set; }
        public string Salesperson_Code { get; set; }
        public string Bill_to_Customer_No { get; set; }
        public string GLN { get; set; }
        public string VAT_Registration_No { get; set; }
        public string Customer_Posting_Group { get; set; }
        public string Gen_Bus_Posting_Group { get; set; }
        public string VAT_Bus_Posting_Group { get; set; }
        public string Customer_Price_Group { get; set; }
        public string Customer_Disc_Group { get; set; }
        public string Payment_Method_Code { get; set; }
        public string Payment_Terms_Code { get; set; }
        public string Reminder_Terms_Code { get; set; }
        public string Fin_Charge_Terms_Code { get; set; }
        public string Currency_Code { get; set; }
        public string Language_Code { get; set; }
        public int Credit_Limit_LCY { get; set; }
        public string Blocked { get; set; }
        public string Shipping_Advice { get; set; }
        public string Shipment_Method_Code { get; set; }
        public string Shipping_Agent_Code { get; set; }
        public string Shipping_Agent_Service_Code { get; set; }
    }
    public class DynamicsODataCustomerOutput
    {
        public string No { get; set; }
        public string Name { get; set; }
        public string Name_2 { get; set; }
        public string Search_Name { get; set; }
        public string Address { get; set; }
        public string Address_2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country_Region_Code { get; set; }
        public string Post_Code { get; set; }
        public string Phone_No { get; set; }
        public string E_Mail { get; set; }
        public string Fax_No { get; set; }
        public string Home_Page { get; set; }
        public string Primary_Contact_No { get; set; }
        public string Contact { get; set; }
        public string Location_Code { get; set; }
        public string IC_Partner_Code { get; set; }
        public string Salesperson_Code { get; set; }
        public string Bill_to_Customer_No { get; set; }
        public string GLN { get; set; }
        public string VAT_Registration_No { get; set; }
        public string Customer_Posting_Group { get; set; }
        public string Gen_Bus_Posting_Group { get; set; }
        public string VAT_Bus_Posting_Group { get; set; }
        public string Customer_Price_Group { get; set; }
        public string Customer_Disc_Group { get; set; }
        public string Payment_Method_Code { get; set; }
        public string Payment_Terms_Code { get; set; }
        public string Reminder_Terms_Code { get; set; }
        public string Fin_Charge_Terms_Code { get; set; }
        public string Currency_Code { get; set; }
        public string Language_Code { get; set; }
        public int Credit_Limit_LCY { get; set; }
        public string Blocked { get; set; }
        public string Shipping_Advice { get; set; }
        public string Shipment_Method_Code { get; set; }
        public string Shipping_Agent_Code { get; set; }
        public string Shipping_Agent_Service_Code { get; set; }
        public string SystemId { get; set; }

    }

    public class DynamicsODataCustomerUpdate
    {
        public string Name_2 { get; set; }
        public string Search_Name { get; set; }
        public string Address { get; set; }
        public string Address_2 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Country_Region_Code { get; set; }
        public string Post_Code { get; set; }
        public string Phone_No { get; set; }
        public string E_Mail { get; set; }
        public string Fax_No { get; set; }
        public string Home_Page { get; set; }
        public string Primary_Contact_No { get; set; }
        public string Contact { get; set; }
        public string Location_Code { get; set; }
        public string IC_Partner_Code { get; set; }
        public string Salesperson_Code { get; set; }
        public string Bill_to_Customer_No { get; set; }
        public string GLN { get; set; }
        public string VAT_Registration_No { get; set; }
        public string Customer_Posting_Group { get; set; }
        public string Gen_Bus_Posting_Group { get; set; }
        public string VAT_Bus_Posting_Group { get; set; }
        public string Customer_Price_Group { get; set; }
        public string Customer_Disc_Group { get; set; }
        public string Payment_Method_Code { get; set; }
        public string Payment_Terms_Code { get; set; }
        public string Reminder_Terms_Code { get; set; }
        public string Fin_Charge_Terms_Code { get; set; }
        public string Currency_Code { get; set; }
        public string Language_Code { get; set; }
        public int Credit_Limit_LCY { get; set; }
        public string Blocked { get; set; }
        public string Shipping_Advice { get; set; }
        public string Shipment_Method_Code { get; set; }
        public string Shipping_Agent_Code { get; set; }
        public string Shipping_Agent_Service_Code { get; set; }
    }

    public class DynamicsSalesInvoiceLineInput
    {
        public string lineType { get; set; }
        public string lineObjectNumber { get; set; }
        public string description { get; set; }
        public decimal? unitPrice { get; set; }
        public int quantity { get; set; }
    }

    public class DynamicsSalesInvoiceLineOutput
    {
        public string id { get; set; }
        public string documentId { get; set; }
        public int sequence { get; set; }
        public string itemId { get; set; }
        public string accountId { get; set; }
        public string lineType { get; set; }
        public string lineObjectNumber { get; set; }
        public string description { get; set; }
        public string unitOfMeasureId { get; set; }
        public string unitOfMeasureCode { get; set; }
        public decimal unitPrice { get; set; }
        public int quantity { get; set; }
        public decimal netAmount { get; set; }
        public DateTime shipmentDate { get; set; }
        public string itemVariantId { get; set; }
        public string locationId { get; set; }
    }

    public class DynamicsSalesInvoiceInput
    {
        public string externalDocumentNumber { get; set; }
        public string invoiceDate { get; set; }
        public string postingDate { get; set; }
        public string dueDate { get; set; }
        public string customerPurchaseOrderReference { get; set; }
        public string customerNumber { get; set; }
        public string shipToName { get; set; }
        public string shipToContact { get; set; }
        public string sellToAddressLine1 { get; set; }
        public string sellToAddressLine2 { get; set; }
        public string sellToCity { get; set; }
        public string sellToCountry { get; set; }
        public string sellToState { get; set; }
        public string sellToPostCode { get; set; }
        public string shipToAddressLine1 { get; set; }
        public string shipToAddressLine2 { get; set; }
        public string shipToCity { get; set; }
        public string shipToCountry { get; set; }
        public string shipToState { get; set; }
        public string shipToPostCode { get; set; }
        public string currencyId { get; set; }
        public string currencyCode { get; set; }
        public string shipmentMethodId { get; set; }
        public decimal discountAmount { get; set; }
        public string phoneNumber { get; set; }
        public string email { get; set; }
        public List<DynamicsSalesInvoiceLineInput> salesInvoiceLines { get; set; }
        public string paymentTermsId { get; set; }
    }
    public class DynamicsSalesInvoiceOutput
    {
        public string id { get; set; }
        public string number { get; set; }
        public string externalDocumentNumber { get; set; }
        public DateTime invoiceDate { get; set; }
        public DateTime postingDate { get; set; }
        public DateTime dueDate { get; set; }
        public string customerPurchaseOrderReference { get; set; }
        public string customerId { get; set; }
        public string customerNumber { get; set; }
        public string billToCustomerId { get; set; }
        public string billToCustomerNumber { get; set; }
        public string shipToName { get; set; }
        public string shipToContact { get; set; }
        public string sellToAddressLine1 { get; set; }
        public string sellToAddressLine2 { get; set; }
        public string sellToCity { get; set; }
        public string sellToCountry { get; set; }
        public string sellToState { get; set; }
        public string sellToPostCode { get; set; }
        public string shipToAddressLine1 { get; set; }
        public string shipToAddressLine2 { get; set; }
        public string shipToCity { get; set; }
        public string shipToCountry { get; set; }
        public string shipToState { get; set; }
        public string shipToPostCode { get; set; }
        public string currencyId { get; set; }
        public string currencyCode { get; set; }
        public string shipmentMethodId { get; set; }
        public decimal discountAmount { get; set; }
        public string phoneNumber { get; set; }
        public string email { get; set; }
        public string status { get; set; }
        public bool IsError { get; set; }
        public DateTime lastModifiedDateTime { get; set; }
        public decimal totalAmountIncludingTax { get; set; }
        public decimal remainingAmount { get; set; }

    }

    public class SearchCustomerOutput
    {
        public List<DynamicsCustomerOutput> value { get; set; }
    }

    public class SearchCustomer
    {

        public string id { get; set; }
    }

    public class DynamicsCustomerUpdate
    {
        public string displayName { get; set; }
        public string addressLine1 { get; set; }
        public string addressLine2 { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string postalCode { get; set; }
        public string phoneNumber { get; set; }
    }

    public class DynamicsCustomer
    {
        public string ID { get; set; }
        public string Name { get; set; }
        public string FullName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string CompanyName { get; set; }
        public bool IsActive { get; set; }
        public string CustomerNo { get; set; }
        public string ContactID { get; set; }
    }
    public class error
    {
        public string code { get; set; }
        public string message { get; set; }
    }
}
