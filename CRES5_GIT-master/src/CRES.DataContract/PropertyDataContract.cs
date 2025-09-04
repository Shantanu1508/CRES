using System;


namespace CRES.DataContract
{
public  class PropertyDataContract
    {
        public System.Guid PropertyID { get; set; }
        public string Deal_DealID { get; set; }
        public string DealID { get; set; }
        public string PropertyName { get; set; }

        public string DealName { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public Nullable<int> State { get; set; }
        public Nullable<int> Zip { get; set; }
        public Nullable<decimal> UWNCF { get; set; }
        public Nullable<decimal> SQFT { get; set; }
        public Nullable<int> PropertyType { get; set; }
        public string PropertyTypeText { get; set; }
        public Nullable<decimal> AllocDebtPer { get; set; }
        public Nullable<int> PropertySubtype { get; set; }
        public string PropertySubtypeText { get; set; }
        public Nullable<int> NumberofUnitsorSF { get; set; }
        public Nullable<decimal> Occ { get; set; }
        public string Class { get; set; }
        public string YearBuilt { get; set; }
        public string Renovated { get; set; }
        public Nullable<int> Bldgs { get; set; }
        public string Acres { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public Nullable<System.DateTime> UpdatedDate { get; set; }
    }
}
