using System;
using System.Collections.Generic;
using System.Data;
using CRES.DAL.Repository;
using CRES.DataContract;


namespace CRES.BusinessLogic
{
    public class ChathamFinancialLogic
    {
        private ChathamFinancialRepository _Chathamrepo = new ChathamFinancialRepository();
        public DataTable GetChathamConfig(  string type)
        {
           return _Chathamrepo.GetChathamConfig(type);
        }
    }
}
