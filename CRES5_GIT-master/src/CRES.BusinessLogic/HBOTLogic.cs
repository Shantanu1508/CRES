using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;

namespace CRES.BusinessLogic
{
    public class HBOTLogic
    {
        private HBOTRepository _hbotRepository = new HBOTRepository();

        public string GetSingleEntityByIntent(string ObjectType, string ObjectNature, string ObjectValue, string Intent)
        {
            return _hbotRepository.GetSingleEntityByIntent(ObjectType, ObjectNature, ObjectValue, Intent);
        }

        public string GetSingleEntityByIntentGeneric(string ObjectType, string ObjectNature, string ObjectValue, string Intent)
        {
            return _hbotRepository.GetSingleEntityByIntentGeneric(ObjectType, ObjectNature, ObjectValue, Intent);
        }

        public DataTable GetListEntityByIntent(string ObjectType, string ObjectNature, string ObjectValue, string Intent)
        {
            return _hbotRepository.GetListEntityByIntent(ObjectType, ObjectNature, ObjectValue, Intent);
        }
        public string GetSingleEntityByIntentForNoteAndDeal(string NoteNature, string NoteValue, string DealNature, string DealValue, string Intent)
        {
            return _hbotRepository.GetSingleEntityByIntentForNoteAndDeal(NoteNature, NoteValue, DealNature, DealValue, Intent);
        }
        public DataTable GetSingleEntityByIntentForNoteAndDealByDateRange(string NoteNature, string NoteValue, string DealNature, string DealValue, DateTime? StartDate, DateTime? EndDate, string Intent)
        {
            return _hbotRepository.GetSingleEntityByIntentForNoteAndDealByDateRange(NoteNature, NoteValue, DealNature, DealValue, StartDate, EndDate, Intent);
        }

        public DataTable GetListEntityByIntentForNoteAndDeal(string NoteNature, string NoteValue, string DealNature, string DealValue, string Intent)
        {
            return _hbotRepository.GetListEntityByIntentForNoteAndDeal(NoteNature, NoteValue, DealNature, DealValue, Intent);
        }


        public DataTable GetCREdealIDByDealID(Guid? DealId, Guid? UserID)
        {
            return _hbotRepository.GetCREdealIDByDealID(DealId, UserID);
        }
        public List<HBOTEntityDataContract> GetListOfEntity(Guid? UserID)
        {
            return _hbotRepository.GetListOfEntity(UserID);
        }
        public void InsertHBOTChatLog(string Status, string Question, string intentname, string userid, string sentby, string sessionId)
        {
            _hbotRepository.InsertHBOTChatLog(Status, Question, intentname, userid, sentby, sessionId);
        }
        public DataTable GetchatlogHistory(Guid? UserID, int pageindex, int pagesize)
        {
            return _hbotRepository.GetchatlogHistory(UserID, pageindex, pagesize);
        }
        public void InsertAIApiStartandEndTime(Guid userid, DateTime Starttime, DateTime Endtime, string Intentname)
        {
            _hbotRepository.InsertAIApiStartandEndTime(userid, Starttime, Endtime, Intentname);
        }
        public DataTable GetListEntityByIntentForNoteAndDealByIntegerValue(string NoteNature, string NoteValue, string DealNature, string DealValue, decimal IntValue, string Intent)
        {
            return _hbotRepository.GetListEntityByIntentForNoteAndDealByIntegerValue(NoteNature, NoteValue, DealNature, DealValue, IntValue, Intent);
        }
    }
}