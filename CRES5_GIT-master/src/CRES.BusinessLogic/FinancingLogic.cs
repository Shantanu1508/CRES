using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DAL;
using CRES.DAL.Repository;
using CRES.DataContract;

namespace CRES.BusinessLogic
{
    public class FinancingLogic
    {
        FinancingRepository _financingRepository = new FinancingRepository();

        public List<FinancingWarehouseDataContract> GetFinancingWarehouse(Guid? userid, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<FinancingWarehouseDataContract> _lstFinancingWarehouseDC = new List<FinancingWarehouseDataContract>();
            _lstFinancingWarehouseDC = _financingRepository.GetFinancingWarehouse(userid, pageSize, pageIndex, out TotalCount);
            return _lstFinancingWarehouseDC;
        }


        public string AddUpdateFinancingWarehouse(FinancingWarehouseDataContract _financingWarehouseDc)
        {
            return _financingRepository.AddUpdateFinancingWarehouse(_financingWarehouseDc);
        }


        public int AddUpdateFinancingWarehouseDetails(List<FinancingWarehouseDetailDataContract> lstfinancingWarehousedetailsDc,string headerUserID)
        {
            return _financingRepository.AddUpdateFinancingWarehouseDetails(lstfinancingWarehousedetailsDc, headerUserID);
        }

        public FinancingWarehouseDataContract GetFinancingWarehouseByid(string financingWarehouseID)
        {
            return _financingRepository.GetFinancingWarehouseByid(financingWarehouseID);
        }
    }
}
