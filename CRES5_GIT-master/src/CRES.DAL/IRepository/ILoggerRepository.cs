using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Text;

namespace CRES.DAL.IRepository
{
    public interface ILoggerRepository
    {
        void InsertLog(LoggerDataContract ldc);
        bool GetAllowLoggingValue();
    }
}
