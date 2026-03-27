using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DAL.IRepository;
using CRES.DAL.Repository;
using CRES.DataContract;

namespace CRES.BusinessLogic
{
    public class DashBoardLogic
    {
        DashBoardRepository _dashboardRepository = new DashBoardRepository();

        public List<DashBoardDataContract> GetDashBoardByUserID(Guid? UserID)
        {
            List<DashBoardDataContract> _dashBoardDataContract = new List<DashBoardDataContract>();
            _dashBoardDataContract = _dashboardRepository.GetDashBoardByUserID(UserID);
            return _dashBoardDataContract;
        }
        public DataTable GetDashBoardData()
        {
            return _dashboardRepository.GetDashBoardData();
        }
        public DataTable GetBookMarkedDeals(string UserID)
        {
            return _dashboardRepository.GetBookMarkedDeals(UserID);
        }
        public void InsertUpdateBookMark(string UserID, Guid? AccountID, string IsBookMark)
        {
            _dashboardRepository.InsertUpdateBookMark(UserID, AccountID, IsBookMark);
        }

    }
}
