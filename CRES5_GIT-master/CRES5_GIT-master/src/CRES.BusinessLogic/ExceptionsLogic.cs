using CRES.DAL.Repository;
using CRES.DataContract;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class ExceptionsLogic
    {
        private ExceptionsRespository er = new ExceptionsRespository();

        public void InsertExceptions(List<ExceptionDataContract> edc, string username)
        {
            er.InsertExceptions(edc, username);
        }

        public List<ExceptionDataContract> GetNoteExceptionsList(string objectid, string name)

        {
            List<ExceptionDataContract> edc = er.GetNoteExceptionsList(objectid, name);
            return edc;
        }


        public void DeleteExceptionByobject(string objectid, string objecttype)
        {
            er.DeleteExceptionByobject(objectid, objecttype);
        }

        public List<ExceptionDataContract> GetAllExceptionsList(string name, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<ExceptionDataContract> lstexce = er.GetAllExceptionsList(name, pageSize, pageIndex, out TotalCount);
            return lstexce;
        }

        public void InsertExceptionsByFieldName(List<ExceptionDataContract> exlist, string username, string FieldName)
        {
            er.InsertExceptionsByFieldName(exlist, username, FieldName);
        }

        public void DeleteExceptionByobjectByFieldName(string objectid, string objecttype, string fieldname)
        {
            er.DeleteExceptionByobjectByFieldName(objectid, objecttype, fieldname);
        }
    }
}