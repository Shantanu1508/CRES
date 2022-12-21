using CRES.DAL.IRepository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CRES.DAL.Repository
{
    public class HBOTRepository : IHBOTRepository
    {
        public string GetSingleEntityByIntent(string ObjectType, string ObjectNature, string ObjectValue, string Intent)
        {
            string ret_value = "";

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();

            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectType", Value = ObjectType };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectNature", Value = ObjectNature };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ObjectValue", Value = ObjectValue };
            SqlParameter p4 = new SqlParameter { ParameterName = "@Intent", Value = Intent };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };

            dt = hp.ExecDataTable("HBOT.usp_GetSingleEntityByIntent", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ret_value = Convert.ToString(dr["SingleResult"]);
            }

            return ret_value;
        }

        public string GetSingleEntityByIntentGeneric(string ObjectType, string ObjectNature, string ObjectValue, string Intent)
        {
            string ret_value = "";

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();

            SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectType", Value = ObjectType };
            SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectNature", Value = ObjectNature };
            SqlParameter p3 = new SqlParameter { ParameterName = "@ObjectValue", Value = ObjectValue };
            SqlParameter p4 = new SqlParameter { ParameterName = "@Intent", Value = Intent };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };

            dt = hp.ExecDataTable("HBOT.usp_GetSingleEntityByIntentGeneric", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ret_value = Convert.ToString(dr["SingleResult"]);
            }

            return ret_value;
        }


        public DataTable GetListEntityByIntent(string ObjectType, string ObjectNature, string ObjectValue, string Intent)
        {
            DataTable dt = new DataTable();

            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@ObjectType", Value = ObjectType };
                SqlParameter p2 = new SqlParameter { ParameterName = "@ObjectNature", Value = ObjectNature };
                SqlParameter p3 = new SqlParameter { ParameterName = "@ObjectValue", Value = ObjectValue };
                SqlParameter p4 = new SqlParameter { ParameterName = "@Intent", Value = Intent };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };

                dt = hp.ExecDataTable("HBOT.usp_GetListEntityByIntent", sqlparam);
            }
            catch (Exception)
            {

                throw;
            }

            return dt;
        }
        public string GetSingleEntityByIntentForNoteAndDeal(string NoteNature, string NoteValue, string DealNature, string DealValue, string Intent)
        {
            string ret_value = "";

            Helper.Helper hp = new Helper.Helper();
            DataTable dt = new DataTable();

            SqlParameter p1 = new SqlParameter { ParameterName = "@NoteNature", Value = NoteNature };
            SqlParameter p2 = new SqlParameter { ParameterName = "@NoteValue", Value = NoteValue };
            SqlParameter p3 = new SqlParameter { ParameterName = "@DealNature", Value = DealNature };
            SqlParameter p4 = new SqlParameter { ParameterName = "@DealValue", Value = DealValue };
            SqlParameter p5 = new SqlParameter { ParameterName = "@Intent", Value = Intent };
            SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };

            dt = hp.ExecDataTable("HBOT.usp_GetSingleEntityByIntentForNoteAndDeal", sqlparam);

            foreach (DataRow dr in dt.Rows)
            {
                ret_value = Convert.ToString(dr["SingleResult"]);
            }

            return ret_value;
        }

        public DataTable GetSingleEntityByIntentForNoteAndDealByDateRange(string NoteNature, string NoteValue, string DealNature, string DealValue, DateTime? StartDate, DateTime? EndDate, string Intent)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();


                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteNature", Value = NoteNature };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteValue", Value = NoteValue };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealNature", Value = DealNature };
                SqlParameter p4 = new SqlParameter { ParameterName = "@DealValue", Value = DealValue };
                SqlParameter p5 = new SqlParameter { ParameterName = "@StartDate", Value = StartDate };
                SqlParameter p6 = new SqlParameter { ParameterName = "@EndDate", Value = EndDate };
                SqlParameter p7 = new SqlParameter { ParameterName = "@Intent", Value = Intent };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6, p7 };

                dt = hp.ExecDataTable("HBOT.usp_GetSingleEntityByIntentForNoteAndDealByDateRange", sqlparam);

                //foreach (DataRow dr in dt.Rows)
                //{
                //    ret_value = Convert.ToString(dr["SingleResult"]);
                //}

                return dt;
            }
            catch (Exception)
            {

                throw;
            }
        }

        public DataTable GetListEntityByIntentForNoteAndDeal(string NoteNature, string NoteValue, string DealNature, string DealValue, string Intent)
        {
            DataTable dt = new DataTable();

            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteNature", Value = NoteNature };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteValue", Value = NoteValue };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealNature", Value = DealNature };
                SqlParameter p4 = new SqlParameter { ParameterName = "@DealValue", Value = DealValue };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Intent", Value = Intent };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5 };

                dt = hp.ExecDataTable("HBOT.usp_GetListEntityByIntentForNoteAndDeal", sqlparam);
            }
            catch (Exception)
            {

                throw;
            }

            return dt;
        }


        public DataTable GetCREdealIDByDealID(Guid? DealId, Guid? UserID)
        {
            DataTable dt = new DataTable();
            try
            {

                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@DealID", Value = DealId };
                SqlParameter p2 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2 };
                dt = hp.ExecDataTable("dbo.usp_GetCREDealIdByDealID", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return dt;
        }
        public List<HBOTEntityDataContract> GetListOfEntity(Guid? UserID)
        {
            List<HBOTEntityDataContract> _EntityDataContractList = new List<HBOTEntityDataContract>();

            DataTable dt = new DataTable();

            Helper.Helper hp = new Helper.Helper();
            SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };

            SqlParameter[] sqlparam = new SqlParameter[] { p1 };
            dt = hp.ExecDataTable("dbo.usp_GetEntityList", sqlparam);

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    _EntityDataContractList.Add(new HBOTEntityDataContract
                    {
                        entity_type = Convert.ToString(dr["entity_type"]),
                        entity_names = Convert.ToString(dr["entity_names"]),
                        synonyms = Convert.ToString(dr["synonyms"])

                    });
                }
            }
            return _EntityDataContractList;
        }

        public void InsertHBOTChatLog(string Status, string Question, string intentname, string userid, string sentby, string sessionId)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@Status", Value = Status };
                SqlParameter p2 = new SqlParameter { ParameterName = "@Question", Value = Question };
                SqlParameter p3 = new SqlParameter { ParameterName = "@IntentName", Value = intentname };
                SqlParameter p4 = new SqlParameter { ParameterName = "@CreatedBy", Value = userid };
                SqlParameter p5 = new SqlParameter { ParameterName = "@Sentby", Value = sentby };
                SqlParameter p6 = new SqlParameter { ParameterName = "@SessionId", Value = sessionId };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };
                hp.ExecNonquery("HBOT.usp_InsertHBOTChatLog", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetchatlogHistory(Guid? UserID, int pageindex, int pagesize)
        {
            DataTable dt = new DataTable();
            try
            {
                Helper.Helper hp = new Helper.Helper();
                SqlParameter p1 = new SqlParameter { ParameterName = "@UserID", Value = UserID };
                SqlParameter p2 = new SqlParameter { ParameterName = "@PageIndex", Value = pageindex };
                SqlParameter p3 = new SqlParameter { ParameterName = "@PageSize", Value = pagesize };

                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3 };
                dt = hp.ExecDataTable("dbo.usp_GetChatlogHistory", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return dt;
        }

        public void InsertAIApiStartandEndTime(Guid userid, DateTime Starttime, DateTime Endtime, string Intentname)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();

                SqlParameter p1 = new SqlParameter { ParameterName = "@UserId", Value = userid };
                SqlParameter p2 = new SqlParameter { ParameterName = "@StartTime", Value = Starttime };
                SqlParameter p3 = new SqlParameter { ParameterName = "@EndTime", Value = Endtime };
                SqlParameter p4 = new SqlParameter { ParameterName = "@IntentName", Value = Intentname };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4 };
                hp.ExecNonquery("HBOT.usp_InsertAIApiStartandEndTime", sqlparam);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetListEntityByIntentForNoteAndDealByIntegerValue(string NoteNature, string NoteValue, string DealNature, string DealValue, decimal IntValue, string Intent)
        {
            try
            {
                Helper.Helper hp = new Helper.Helper();
                DataTable dt = new DataTable();

                SqlParameter p1 = new SqlParameter { ParameterName = "@NoteNature", Value = NoteNature };
                SqlParameter p2 = new SqlParameter { ParameterName = "@NoteValue", Value = NoteValue };
                SqlParameter p3 = new SqlParameter { ParameterName = "@DealNature", Value = DealNature };
                SqlParameter p4 = new SqlParameter { ParameterName = "@DealValue", Value = DealValue };
                SqlParameter p5 = new SqlParameter { ParameterName = "@IntValue", Value = IntValue };
                SqlParameter p6 = new SqlParameter { ParameterName = "@Intent", Value = Intent };
                SqlParameter[] sqlparam = new SqlParameter[] { p1, p2, p3, p4, p5, p6 };

                dt = hp.ExecDataTable("HBOT.usp_GetListEntityByIntentForNoteAndDealByIntegerValue", sqlparam);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
