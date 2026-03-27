using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;

namespace CRES.DAL.IRepository
{
    public interface IPortfolioRepository
    {
        int AddUpdateFortfolio(PortfolioDataContract portfolio);
        PortfolioDataContract GetPortfolioDetailByID(Guid? PortfolioID);
        List<PortfolioDataContract> GetAllPortfolio(string userid, int pageIndex, int pageSize, out int? TotalCount);
    }
}
