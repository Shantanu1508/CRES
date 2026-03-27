using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;

namespace CRES.DAL.IRepository
{
    public interface IFinancingRepository 
    {
        List<FinancingWarehouseDataContract> GetFinancingWarehouse(Guid? userid, int? PageSize, int? PageIndex, out int? TotalCount);
    }
}
