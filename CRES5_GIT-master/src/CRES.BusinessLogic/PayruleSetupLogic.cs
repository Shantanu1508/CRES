using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.BusinessLogic
{
    public class PayruleSetupLogic
    {
        private PayruleSetupRepository _PayruleSetupRepository = new PayruleSetupRepository();

        public List<PayruleSetupDataContract> GetNoteDependentsByNoteID(string noteid)

        {
            try
            {
                List<PayruleSetupDataContract> PSDCLIST = _PayruleSetupRepository.GetNoteDependentsByNoteID(noteid);
                return PSDCLIST;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertUpdatePayruleDistributions(string sourcenoteid, string username, Guid? AnalysisID)

        {
            try
            {
                _PayruleSetupRepository.InsertUpdatePayruleDistributions(sourcenoteid, username, AnalysisID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetNotePayruleSetupDataByDealID(Guid? dealID)
        {
            try
            {
                return _PayruleSetupRepository.GetNotePayruleSetupDataByDealID(dealID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertIntoPayruleSetup(List<PayruleSetupDataContract> list, string username, string DealID)
        {
            try
            {
                _PayruleSetupRepository.InsertIntoPayruleSetup(list, username, DealID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}