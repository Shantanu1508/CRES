using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class GenericEntityDataContract
    {
        public string NoteID { get; set; }
        public string NoteName { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? TransactionDate { get; set; }
        public DateTime? RemitDate { get; set; }
        public decimal? Value { get; set; }
        public int? TransactionTypeID { get; set; }
        public int? ServicerMasterID { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public string Status { get; set; }
        public string Comment { get; set; }
        public string TableName { get; set; }
        public string Cash_NonCash { get; set; }
    }
    public class TagXIRREntityDataContract
    {
        public string TableName { get; set; }
        public string ObjectID { get; set; }
        public int TagID { get; set;}
        public string TagName { get; set; }
        public string Status { get; set; }
    }
}
