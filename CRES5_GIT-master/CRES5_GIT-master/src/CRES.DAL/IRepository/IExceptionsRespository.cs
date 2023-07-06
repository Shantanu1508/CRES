using CRES.DataContract;
using System.Collections.Generic;

namespace CRES.DAL.IRepository
{
    public interface IExceptionsRespository
    {
        void InsertExceptions(List<ExceptionDataContract> edc, string username);

        List<ExceptionDataContract> GetNoteExceptionsList(string objectid, string name);

        void DeleteExceptionByobject(string objectid, string objecttype);

        // List<ExceptionDataContract> GetAllExceptionsList(string name);
        List<ExceptionDataContract> GetAllExceptionsList(string name, int? PageSize, int? PageIndex, out int? TotalCount);
    }
}