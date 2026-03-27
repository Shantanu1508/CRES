using CRES.DAL.IRepository;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Text;

namespace CRES.BusinessLogic
{
    public class JournalEntryLogic
    {
        JournalLedgerRepository _JournalRepository = new JournalLedgerRepository();
        public string InsertUpdateJournalEntry(List<JournalLedgerDataContract> jldc, string userid, int? Id, DateTime? Date, string Comment)
        {
            return _JournalRepository.InsertUpdateJournalEntry(jldc, userid, Id, Date, Comment);
        }
        public List<JournalLedgerDataContract> GetJournalEntryByDebtEquityAccountID(Guid? DebtEquityAccountID)
        {
            return _JournalRepository.GetJournalEntryByDebtEquityAccountID(DebtEquityAccountID);
        }
        public List<JournalLedgerDataContract> GetJournalEntryByJournalEntryMasterGUID(Guid JournalEntryMasterGUID)
        {
            return _JournalRepository.GetJournalEntryByJournalEntryMasterGUID(JournalEntryMasterGUID);
        }
    }
}
