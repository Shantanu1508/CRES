using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;
using System.Text;

namespace CRES.Utilities
{
    public class GenerateAutomationHelper
    {
        public DataTable GetFormatedDatafromDatatableForAutomation(DataTable dt)
        {
            DataTable emaildata = new DataTable();

            List<AutoMationOutputData> vallist = new List<AutoMationOutputData>();
            if (dt != null && dt.Rows.Count > 0)
            {
                DataView view = new DataView(dt);
                DataTable distinctValues = view.ToTable(true, "DealID");
                foreach (DataRow dv in distinctValues.Rows)
                {
                    DataTable tblFiltered = new DataTable();

                    string query = "DealID = '" + dv["DealID"].ToString() + "'";
                    tblFiltered = dt.Select(query).CopyToDataTable();
                    int j = 1;
                    AutoMationOutputData am = new AutoMationOutputData();

                    am.DealID = tblFiltered.Rows[0]["CREDealID"].ToString();
                    am.DealName = tblFiltered.Rows[0]["DealName"].ToString();

                    foreach (DataRow row in tblFiltered.Rows)
                    {
                        if (row["Message"].ToString() == "Funding schedule generated successfully.")
                        {
                            am.GenerateMessage = row["Message"].ToString();
                            am.SaveMessage = "Deal Saved Successfully";
                        }
                        else
                        {
                            if (j <= 10)
                            {
                                PropertyInfo _propertyInfo = am.GetType().GetProperty("Validation" + j);
                                _propertyInfo.SetValue(am, row["Message"].ToString(), null);
                                am.GenerateMessage = "";
                            }
                            j = j + 1;
                        }

                    }
                    vallist.Add(am);
                }
                emaildata = ObjToDataTable.ConvertToDataTable(vallist);

            }

            return emaildata;
        }
    }
}
