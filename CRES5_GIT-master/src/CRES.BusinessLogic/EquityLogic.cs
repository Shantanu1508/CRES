using CRES.DAL.IRepository;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class EquityLogic
    {
        private EquityRepository _equityRepository = new EquityRepository();

        public EquityDataContract InsertUpdateEquity(Guid? userid, EquityDataContract _equityDC)
        {
            return _equityRepository.InsertUpdateEquity(userid, _equityDC);
        }
        public EquityDataContract GetEquityByEquityID(Guid? EquityGUID)
        {
            return _equityRepository.GetEquityByEquityID(EquityGUID);
        }        
        public List<SearchDataContract> GetAutosuggestDebtNameSubline(string serchKey)
        {
            return _equityRepository.GetAutosuggestDebtNameSubline(serchKey);
        }
        public EquityDataContract GetEquityCalcInfoByEquityAccountID(Guid? EquityAccountID, Guid? UserID)
        {
            return _equityRepository.GetEquityCalcInfoByEquityAccountID(EquityAccountID, UserID);
        }
        public DataTable GeDebtOrEquityCashflowExportData(string EquityAccountID, string AnalysisId, string Type)
        {
            return _equityRepository.GeDebtOrEquityCashflowExportData(EquityAccountID, AnalysisId, Type);
        }
        public DataTable GetCashflowExportDataDetail(string EquityAccountID, string AnalysisId, string Type)
        {
            return _equityRepository.GetCashflowExportDataDetail(EquityAccountID, AnalysisId, Type);
        }

        public DataTable GetEquityCapitalContributionExportExcel(string AccountId)
        {
            return _equityRepository.GetEquityCapitalContributionExportExcel(AccountId);
        }

        public string GetFileNameforLiabilityCalcExcelBlob(string AccountId)
        {
            return _equityRepository.GetFileNameforLiabilityCalcExcelBlob(AccountId);
        }
        public List<CashAccountDataContract> GetCashAccount()
        {
            return _equityRepository.GetCashAccount();
        }
        public EquityDataContract GetEquityByEquityName(string EquityName)
        {
            return _equityRepository.GetEquityByEquityName(EquityName);
        }
        public EquityDataContract InsertUpdateEquity_OnetimefromFile(Guid? userid, EquityDataContract _equityDC)
        {
            return _equityRepository.InsertUpdateEquity_OnetimefromFile(userid, _equityDC);
        }
    }
}
