using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class AutomationLogic
    {
        private DealRepository _dealRepository = new DealRepository();
        private NoteRepository _NoteRepository = new NoteRepository();

        public List<DealDataContract> GetAllDeal()
        {
            int? totalCount = 1;
            List<DealDataContract> lstDeals = _dealRepository.GetAllDealUSP(new Guid("B0E6697B-3534-4C09-BE0A-04473401AB93"), 1000, 1, out totalCount).ToList();
            return lstDeals;
        }

        public List<NoteDataContract> GetAllNotes()
        {
            int? totalCount = 1;
            List<NoteDataContract> lstNotes = _NoteRepository.GetNoteFromDealIds("", new Guid("B0E6697B-3534-4C09-BE0A-04473401AB93"), 1, 3000, out totalCount).ToList();
            return lstNotes;
        }
    }
}
