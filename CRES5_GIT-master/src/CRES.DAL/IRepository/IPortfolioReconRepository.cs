using System;
using System.Collections.Generic;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface IPortfolioReconRepository
    {
        public int ExecuteSQLScript(string sqlScript);
    }
}
