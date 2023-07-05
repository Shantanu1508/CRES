using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.DAL.IRepository
{
    public interface IPayruleSetupRepository
    {

        List<PayruleSetupDataContract> GetNoteDependentsByNoteID(string noteid);
        void InsertUpdatePayruleDistributions(string sourcenoteid, string updatedby, Guid? AnalysisID);
        DataTable GetNotePayruleSetupDataByDealID(Guid? dealID);

        void InsertIntoPayruleSetup(List<PayruleSetupDataContract> list, string username, string DealID);

    }
}
