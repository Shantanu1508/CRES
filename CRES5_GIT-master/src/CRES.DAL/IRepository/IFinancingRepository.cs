using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IFinancingRepository
    {
        List<FinancingWarehouseDataContract> GetFinancingWarehouse(Guid? userid, int? PageSize, int? PageIndex, out int? TotalCount);
    }
}
