using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class AutofyInvoiceInputDataContract
    {
        public string ID { get; set; }
        public DateTime Date { get; set; }
        public string Number { get; set; }
        public DateTime DueDate { get; set; }
        public decimal SubTotal { get; set; }
        public decimal Balance { get; set; }
        public bool ToBePrinted { get; set; }
        public bool ToBeEmailed { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public decimal SalesTaxAmount { get; set; }
        public DateTime DateShipped { get; set; }
        public decimal AppliedAmount { get; set; }
        public bool IsPaid { get; set; }
        public bool IsPending { get; set; }

        public Template Template { get; set; }
        public BillingAddress BillingAddress { get; set; }
        public Customer Customer { get; set; }
        public Account Account { get; set; }
        public List<ItemLines> ItemLines { get; set; }
        public string Memo { get; set; }
    }

    public class AutofyInvoiceOutputDataContract
    {
        public string Self { get; set; }
        public string Kind { get; set; }
        public string RequestId { get; set; }
        public string Page { get; set; }
        public string MoreData { get; set; }
        public string HasErrors { get; set; }
        public List<Contents> Contents { get; set; }
        public List<Errors> Errors { get; set; }
    }
    public class Contents
    {
        public ObjectCls Object { get; set; }
        public List<Errors> Errors { get; set; }
        public string Self { get; set; }
        public string Kind { get; set; }
    }
    public class ObjectCls
    {
        public string ID { get; set; }
        public DateTime Date { get; set; }
        public string Number { get; set; }
        public DateTime DueDate { get; set; }
        public decimal SubTotal { get; set; }
        public decimal Balance { get; set; }
        public bool ToBePrinted { get; set; }
        public bool ToBeEmailed { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public decimal SalesTaxAmount { get; set; }
        public DateTime DateShipped { get; set; }
        public decimal AppliedAmount { get; set; }
        public bool IsPaid { get; set; }
        public bool IsPending { get; set; }

        public Template Template { get; set; }
        public BillingAddress BillingAddress { get; set; }
        public Customer Customer { get; set; }
        public Account Account { get; set; }
        public List<ItemLines> ItemLines { get; set; }
        public string Memo { get; set; }
        public List<LinkedTransactions> LinkedTransactions { get; set; }
    }

    public class Errors
    {
        public string Message { get; set; }
        public string Code { get; set; }
    }

    public class Customer
    {
        public string ID { get; set; }
        public string FullName { get; set; }
    }
    public class BillingAddress
    {
        public string City { get; set; }
        public string State { get; set; }
    }
    public class Account
    {
        public string FullName { get; set; }
        public string ID { get; set; }
    }
    public class Template
    {
        public string ID { get; set; }
        public string FullName { get; set; }

    }
    public class ItemLines
    {
        public string Description { get; set; }
        public decimal Rate { get; set; }
        public decimal Amount { get; set; }
        public SalesTaxCode SalesTaxCode { get; set; }
        public Item Item { get; set; }

    }

    public class SalesTaxCode
    {
        public string ID { get; set; }
        public string FullName { get; set; }

    }
    public class Item
    {
        public string ID { get; set; }
        public string FullName { get; set; }

    }

    public class LinkedTransactions
    {
        public string ID { get; set; }
        public string Type { get; set; }
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
    }


}
