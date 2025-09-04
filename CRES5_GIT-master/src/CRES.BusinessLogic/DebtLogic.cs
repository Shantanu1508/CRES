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

    public class DebtLogic
    {
        DebtRepository _DebtRepository = new DebtRepository();
        public DebtDataContract InsertUpdateDebt(DebtDataContract ddc, string userid)
        {
            return _DebtRepository.InsertUpdateDebt(ddc, userid);
        }
        public DebtDataContract GetDebtByDebtID(Guid? DebtGUID)
        {
            return _DebtRepository.GetDebtByDebtID(DebtGUID);
        }        
        public List<FeeScheduleDataContract> GetDebtFeeScheduleByDebtAccountID(Guid? DebtAccountID, Guid? AdditionalAccountID)
        {
            return _DebtRepository.GetDebtFeeScheduleByDebtAccountID(DebtAccountID, AdditionalAccountID);
        }
        public DataTable GetLiabilityFundingScheduleAggregateByLiabilityTypeID(string LiabilityTypeID)
        {
            return _DebtRepository.GetLiabilityFundingScheduleAggregateByLiabilityTypeID(LiabilityTypeID);
        }
        public List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleDetailByLiabilityTypeID(string LiabilityTypeID)
        {
            return _DebtRepository.GetLiabilityFundingScheduleDetailByLiabilityTypeID(LiabilityTypeID);
        }


        public List<LiabilityFundingScheduleDataContract> GetLiabilityFundingScheduleDetailByFilter(string LiabilityTypeID, string TransDate, string TransactionType) {
            return _DebtRepository.GetLiabilityFundingScheduleDetailByFilter(LiabilityTypeID, TransDate, TransactionType);
        }

        public DebtDataContract GetDebtByDebtID(string DebtName)
        {
            return _DebtRepository.GetDebtByDebtID(DebtName);
        }

        public void InsertUpdateGeneralSetupDetailsDebt(DebtDataContract ddc, string userid) 
        {
              _DebtRepository.InsertUpdateGeneralSetupDetailsDebt(ddc,userid);
        }
        public List<LookupDataContract> GetListofFundNameShortName()
        {
            return _DebtRepository.GetListofFundNameShortName();
        }
        public DebtDataContract InsertUpdateDebt_OnetimeFromFile(DebtDataContract ddc, string userid)
        {
            return _DebtRepository.InsertUpdateDebt_OnetimeFromFile(ddc,userid);
        }
        public List<PrepayAndAdditionalFeeScheduleLiabilityDetailDataContract> GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID(Guid? DebtAccountID, Guid? AdditionalAccountID)
        {
            return _DebtRepository.GetPrepayAndAdditionalFeeScheduleLiabilityDetailByAccountID(DebtAccountID, AdditionalAccountID);
        }
    }
}
