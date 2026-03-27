using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CRES.DataContract;
using CRES.DAL.IRepository;
using System.Data;
using System.Data.SqlClient;
using CRES.Utilities;

namespace CRES.DAL.Repository
{
  public  class PropertyRepository :  IPropertyRepository
    {
        public List<PropertyDataContract> GetAllProperty(String dealID, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            // ObjectParameter totalCount = new ObjectParameter("TotalCount", typeof(int));
            DataTable dt = new DataTable();
            List<PropertyDataContract> lstPropertyDC = new List<PropertyDataContract>();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@DealId", Value = dealID };
            SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = userID };
            SqlParameter p3 = new SqlParameter { ParameterName = "@PageIndex", Value = pageIndex };
            SqlParameter p4 = new SqlParameter { ParameterName = "@PageSize", Value = pageSize };
            SqlParameter p5 = new SqlParameter { ParameterName = "@TotalCount", Direction = ParameterDirection.Output, Size = int.MaxValue };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };
            dt = hp.ExecDataTable("dbo.usp_GetAllPropertyByUserId", sqlparam);
            
           // var lstpropertyResult = db.usp_GetAllPropertyByUserId(dealID, userID, pageIndex, pageSize, totalCount);

            // Forcing procedure execution
           // var lstproperty = lstpropertyResult.ToList();
            TotalCount = string.IsNullOrEmpty(Convert.ToString(p5.Value)) ? 0 : Convert.ToInt32(p5.Value);

            foreach (DataRow dr in dt.Rows)
            {
                PropertyDataContract propertyDC = new PropertyDataContract();
                if (Convert.ToString(dr["PropertyID"]) != "")
                {
                    propertyDC.PropertyID = new Guid(Convert.ToString(dr["PropertyID"]));
                }
                propertyDC.DealID = Convert.ToString(dr["Deal_DealID"]);
                propertyDC.PropertyName = Convert.ToString(dr["PropertyName"]);
                propertyDC.DealName = Convert.ToString(dr["DealName"]);
                propertyDC.Address = Convert.ToString(dr["Address"]);
                propertyDC.City = Convert.ToString(dr["City"]);
                propertyDC.State = CommonHelper.ToInt32(dr["State"]);
                propertyDC.Zip = CommonHelper.ToInt32(dr["Zip"]);
                propertyDC.UWNCF = CommonHelper.ToDecimal(dr["UWNCF"]);
                propertyDC.SQFT = CommonHelper.ToDecimal(dr["SQFT"]);
                propertyDC.PropertyType = CommonHelper.ToInt32(dr["PropertyType"]);
                propertyDC.PropertyTypeText = Convert.ToString(dr["PropertyTypeText"]);
                propertyDC.AllocDebtPer = CommonHelper.ToDecimal(dr["AllocDebtPer"]);
                propertyDC.PropertySubtype = CommonHelper.ToInt32(dr["PropertySubtype"]);
                propertyDC.PropertySubtypeText = Convert.ToString(dr["PropertySubtypeText"]);
                propertyDC.NumberofUnitsorSF = CommonHelper.ToInt32(dr["NumberofUnitsorSF"]);
                propertyDC.Occ = CommonHelper.ToDecimal(dr["Occ"]);
                propertyDC.Class = Convert.ToString(dr["Class"]);
                propertyDC.YearBuilt = Convert.ToString(dr["YearBuilt"]);
                propertyDC.Renovated = Convert.ToString(dr["Renovated"]);
                propertyDC.Bldgs = CommonHelper.ToInt32(dr["Bldgs"]);
                propertyDC.Acres = Convert.ToString(dr["Acres"]);
                propertyDC.CreatedBy = Convert.ToString(dr["CreatedBy"]);
                propertyDC.CreatedDate = CommonHelper.ToDateTime(dr["CreatedDate"]);
                propertyDC.UpdatedBy = Convert.ToString(dr["UpdatedBy"]);
                propertyDC.UpdatedDate = CommonHelper.ToDateTime(dr["UpdatedDate"]); 
                lstPropertyDC.Add(propertyDC);
            }
            return lstPropertyDC;
        }

        public bool UpdateProperty(Guid? userid, List<PropertyDataContract> propertyDataContract, string CreatedBy, string UpdatedBy)
        {

            string NewPropertyID;
            bool retValue = false;
            Helper.Helper hp = new Helper.Helper();
            // ObjectParameter _newPropertyID = new ObjectParameter("NewPropertyID", typeof(string));
            foreach (var ProItem in propertyDataContract)
            {
                ProItem.Deal_DealID = Convert.ToString(ProItem.DealID);
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = userid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Deal_DealId", Value = new Guid(ProItem.Deal_DealID) };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PropertyID", Value = ProItem.PropertyID };
                SqlParameter p4 = new SqlParameter { ParameterName = "@PropertyName", Value = ProItem.PropertyName };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Address", Value = ProItem.Address };
                SqlParameter p6 = new SqlParameter { ParameterName = "@City", Value = ProItem.City };
                SqlParameter p7 = new SqlParameter { ParameterName = "@State", Value = ProItem.State };
                SqlParameter p8 = new SqlParameter { ParameterName = "@Zip", Value = ProItem.Zip };
                SqlParameter p9 = new SqlParameter { ParameterName = "@UWNCF", Value = ProItem.UWNCF };
                SqlParameter p10 = new SqlParameter { ParameterName = "@SQFT", Value = ProItem.SQFT };
                SqlParameter p11 = new SqlParameter { ParameterName = "@PropertyType", Value = ProItem.PropertyType };
                SqlParameter p12 = new SqlParameter { ParameterName = "@AllocDebtPer", Value = ProItem.AllocDebtPer };
                SqlParameter p13 = new SqlParameter { ParameterName = "@PropertySubtype", Value = ProItem.PropertySubtype };
                SqlParameter p14 = new SqlParameter { ParameterName = "@NumberofUnitsorSF", Value = ProItem.NumberofUnitsorSF };
                SqlParameter p15 = new SqlParameter { ParameterName = "@Occ", Value = ProItem.Occ };
                SqlParameter p16 = new SqlParameter { ParameterName = "@Class", Value = ProItem.Class };
                SqlParameter p17 = new SqlParameter { ParameterName = "@YearBuilt", Value = ProItem.YearBuilt };
                SqlParameter p18 = new SqlParameter { ParameterName = "@Renovated", Value = ProItem.Renovated };
                SqlParameter p19 = new SqlParameter { ParameterName = "@Bldgs", Value = ProItem.Bldgs };
                SqlParameter p20 = new SqlParameter { ParameterName = "@Acres", Value = ProItem.Acres };
                SqlParameter p21 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                SqlParameter p22 = new SqlParameter { ParameterName = "@CreatedDate", Value = ProItem.CreatedDate };
                SqlParameter p23 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy };
                SqlParameter p24 = new SqlParameter { ParameterName = "@UpdatedDate", Value = ProItem.UpdatedDate };
                SqlParameter p25 = new SqlParameter { ParameterName = "@NewPropertyID", Direction = ParameterDirection.Output , Size = int.MaxValue };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11,
                                                           p12, p13, p14, p15, p16, p17, p18, p19, p20, p21,
                                                           p22, p23, p24, p25};
                var result = hp.ExecNonquery("CRE.usp_AddUpdateProperty", sqlparam);
                NewPropertyID = Convert.ToString(p25.Value);

                //Save in App.Object table
                DataTable dt = new DataTable();
                Helper.Helper hpl1 = new Helper.Helper();
                SqlParameter hp1 = new SqlParameter { ParameterName = "@Name", Value = "property" };
                SqlParameter hp2 = new SqlParameter { ParameterName = "@ParentID", Value = null };
                SqlParameter[] sqlparamhp1 = new SqlParameter[] { hp1, hp2 };
                dt = hpl1.ExecDataTable("dbo.usp_GetLookupByNameAndParentID", sqlparamhp1);

                int? lookupid = null;
                if (dt != null && dt.Rows.Count > 0)
                {
                    lookupid = Convert.ToInt32(dt.Rows[0]["LookupID"]);
                    //Save in App.Object table
                    Helper.Helper hpl = new Helper.Helper();
                    SqlParameter pr1 = new SqlParameter { ParameterName = "@ObjectID", Value = new Guid(NewPropertyID) };
                    SqlParameter pr2 = new SqlParameter { ParameterName = "@ObjectTypeID", Value = lookupid };
                    SqlParameter pr3 = new SqlParameter { ParameterName = "@CreatedBy", Value = CreatedBy };
                    SqlParameter pr4 = new SqlParameter { ParameterName = "@UpdatedBy", Value = UpdatedBy };
                    SqlParameter[] sqlparam1 = new SqlParameter[] { pr1, pr2, pr3, pr4 };
                    hpl.ExecNonquery("App.usp_AddUpdateObject", sqlparam1);
                }
                //=================


                if (result != 0)
            {
                retValue = true;
            }
        }
            return retValue;
        }


        public PropertyDataContract GetPropertyById(string PropertyId)
        {
            DataTable dt = new DataTable();
            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@PropertyId", Value = PropertyId };
            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetPropertyByPropertyId", sqlparam);
            // var _property = db.usp_GetPropertyByPropertyId(PropertyId).FirstOrDefault();
            PropertyDataContract propertyDC = new PropertyDataContract();
            if (Convert.ToString("PropertyID") != "")
            {
                propertyDC.PropertyID = new Guid(Convert.ToString("PropertyID"));
            }
            
            propertyDC.DealID = Convert.ToString("Deal_DealID");
            propertyDC.PropertyName = Convert.ToString("PropertyName");
            propertyDC.Address = Convert.ToString("Address");
            propertyDC.City = Convert.ToString("City");
            propertyDC.State =CommonHelper.ToInt32("State");
            propertyDC.Zip = CommonHelper.ToInt32("Zip");
            propertyDC.UWNCF = CommonHelper.ToDecimal("UWNCF");
            propertyDC.SQFT = CommonHelper.ToDecimal("SQFT");
            propertyDC.PropertyType = CommonHelper.ToInt32("PropertyType");
            propertyDC.PropertyTypeText = Convert.ToString("PropertyTypeText");
            propertyDC.AllocDebtPer = CommonHelper.ToDecimal("AllocDebtPer");
            propertyDC.PropertySubtype = CommonHelper.ToInt32("PropertySubtype");
            propertyDC.PropertySubtypeText = Convert.ToString("PropertySubtypeText");
            propertyDC.NumberofUnitsorSF = CommonHelper.ToInt32("NumberofUnitsorSF");
            propertyDC.Occ = CommonHelper.ToDecimal("Occ");
            propertyDC.Class = Convert.ToString("Class");
            propertyDC.YearBuilt = Convert.ToString("YearBuilt");
            propertyDC.Renovated = Convert.ToString("Renovated");
            propertyDC.Bldgs = CommonHelper.ToInt32("Bldgs");
            propertyDC.Acres = Convert.ToString("Acres");
            propertyDC.CreatedBy = Convert.ToString("CreatedBy");
            propertyDC.CreatedDate = CommonHelper.ToDateTime("CreatedDate");
            propertyDC.UpdatedBy = Convert.ToString("UpdatedBy");
            propertyDC.UpdatedDate = CommonHelper.ToDateTime("UpdatedDate"); 
            return propertyDC;
        }
    }
}
