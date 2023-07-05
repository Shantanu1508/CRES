using CRES.DataContract;

namespace CRES.DAL.IRepository
{
    public interface ILoggerRepository
    {
        void InsertLog(LoggerDataContract ldc);
        bool GetAllowLoggingValue();
    }
}
