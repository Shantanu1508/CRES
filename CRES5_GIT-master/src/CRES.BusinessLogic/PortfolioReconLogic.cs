using System;
using System.Collections.Generic;
using System.Text;
using CRES.DAL.Helper;
using CRES.DAL.Repository;

namespace CRES.BusinessLogic
{
    public class PortfolioReconLogic
    {
        private PortfolioReconRepository _portfolioRecon = new PortfolioReconRepository();

        public int ExecuteSQLScript(string sqlScript)
        {
            return _portfolioRecon.ExecuteSQLScript(sqlScript);
        }
    }
}
