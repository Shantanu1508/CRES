using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

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

        public List<DealDataContract> GetAllAutospreadDeal(string getDealType) // Autospread update
        {
            
            int? totalCount = 1;
            List<DealDataContract> lstDeals = _dealRepository.GetAllAutospreadDealUSP(new Guid("80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B"), 1000, 1, out totalCount).ToList();  // Autospread update
            return lstDeals;
        }

        public List<DealDataContract> GetAllAutomationDeals(string getDealType, string env) // Autospread update
        {

            int? totalCount = 1;
            List<DealDataContract> lstDeals = _dealRepository.GetAllAutomationDealsUSP(new Guid("80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B"), getDealType, env, 1000, 1, out totalCount).ToList();  // Autospread update
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
