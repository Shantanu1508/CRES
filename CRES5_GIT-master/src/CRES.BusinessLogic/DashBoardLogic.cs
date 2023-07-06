using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;

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


    }
}
