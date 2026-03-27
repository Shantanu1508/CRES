using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface IJournalLedgerRepository
    {
        string InsertUpdateJournalEntry(List<JournalLedgerDataContract> JournalEntry, string userid, int? Id, DateTime? Date, string Comment);
        List<JournalLedgerDataContract> GetJournalEntryByDebtEquityAccountID(Guid? DebtEquityAccountID);
        List<JournalLedgerDataContract> GetJournalEntryByJournalEntryMasterGUID(Guid JournalEntryMasterGUID);

    }
}
