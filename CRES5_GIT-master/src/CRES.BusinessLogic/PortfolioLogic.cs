using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class PortfolioLogic
    {
        private PortfolioRepository _portfolioRepository = new PortfolioRepository();

        public int AddUpdateFortfolio(PortfolioDataContract portfolio)
        {
         return _portfolioRepository.AddUpdateFortfolio(portfolio);
        }


        public PortfolioDataContract GetPortfolioDetailByID(Guid? PortfolioID)
        {
            return _portfolioRepository.GetPortfolioDetailByID(PortfolioID);
        }

        public List<PortfolioDataContract> GetAllPortfolio(string userid, int pageIndex, int pageSize, out int? TotalCount)
        {
            return _portfolioRepository.GetAllPortfolio(userid, pageIndex, pageSize, out TotalCount);
        }
    }
}
