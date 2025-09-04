using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class QBDCustomerInputDataContract
    {
         
    public string ID { get; set; }
    public string Name { get; set; }
    public string CompanyName { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string FullName { get; set; }
    public QBDCustomerBillingAddress BillingAddress { get; set; }
    public string CCEmail { get; set; }
    public string CustomerNo { get; set; }
    public string ContactID { get; set; }
        //
    }


    public class QBDCustomerOutputDataContract
    {

        public string Self { get; set; }
        public string Kind { get; set; }
        public string RequestId { get; set; }
        public string Page { get; set; }
        public string MoreData { get; set; }
        public string HasErrors { get; set; }
        public List<QBDCustomerContents> Contents { get; set; }

        public List<QBDCustomerErrors> Errors { get; set; }

    }

    public class QBDCustomerContents
    {
        public QBDCustomerObject Object { get; set; }
        public string Self { get; set; }
        public string Kind { get; set; }
        public List<QBDCustomerErrors> Errors { get; set; }
    }
    public class QBDCustomerErrors
    {
        public string Message { get; set; }
        public string Code { get; set; }
    }
    public class QBDCustomerObject
    {
        public string ID { get; set; }
        public string Name { get; set; }
        public string CompanyName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName { get; set; }
        public QBDCustomerBillingAddress BillingAddress { get; set; }
    }

    public class QBDCustomerBillingAddress
    {
        public string Line1 { get; set; }
        public string Line2 { get; set; }
        public string Line3 { get; set; }
        public string Line4 { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string PostalCode { get; set; }
    }

    
}
