using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IPortfolioRepository
    {
        int AddUpdateFortfolio(PortfolioDataContract portfolio);
        PortfolioDataContract GetPortfolioDetailByID(Guid? PortfolioID);
        List<PortfolioDataContract> GetAllPortfolio(string userid, int pageIndex, int pageSize, out int? TotalCount);
    }
}
