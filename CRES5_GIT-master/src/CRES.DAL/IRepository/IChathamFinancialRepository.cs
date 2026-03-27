using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface IChathamFinancialRepository
    {
        DataTable GetChathamConfig(string type);
    }
}
