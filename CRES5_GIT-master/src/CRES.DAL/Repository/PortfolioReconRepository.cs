using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;

namespace CRES.DAL.Repository
{
    public class PortfolioReconRepository
    {
        public int ExecuteSQLScript(string sqlScript)
        {
            Helper.Helper hp = new Helper.Helper();
            return hp.ExecuteInlineScript(sqlScript);
        }
    }
}
