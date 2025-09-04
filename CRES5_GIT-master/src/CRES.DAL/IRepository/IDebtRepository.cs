using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface IDebtRepository
    {
        DebtDataContract InsertUpdateDebt(DebtDataContract ddc, string userid);
        DebtDataContract GetDebtByDebtID(Guid? DebtGUID);       
        public List<FeeScheduleDataContract> GetDebtFeeScheduleByDebtAccountID(Guid? DebtAccountID, Guid? AdditionalAccountID);
        DebtDataContract GetDebtByDebtID(string DebtName);
        List<LookupDataContract> GetListofFundNameShortName();
        void InsertUpdateGeneralSetupDetailsDebt(DebtDataContract ddc, string userid);
        DebtDataContract InsertUpdateDebt_OnetimeFromFile(DebtDataContract ddc, string userid);
    }
}
