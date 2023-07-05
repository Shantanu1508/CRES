using CRES.DAL.Repository;
using CRES.DataContract;
using CRES.Utilities;
using System;

namespace CRES.BusinessLogic
{
    public class LoggerLogic
    {
        LoggerRepository logrepo = new LoggerRepository();
        public void WriteLogException(string Module, string message, string objectID, string username, string MethodName, string requestobj, Exception ex)
        {
            LoggerDataContract ldc = new LoggerDataContract();
            string formatedstring = LoggerHelper.GetExceptionString(ex).Replace("'", "''");
            ldc.ExceptionSource = ex.GetType().Name.ToString();
            ldc.Message_StackTrace = message + " " + formatedstring;
            ldc.Message = LoggerHelper.GetMessage(ex);
            ldc.Severity = CRESEnums.Severity.Error.ToString();
            ldc.Module = Module;
            ldc.Priority = LoggerHelper.GetExceptionPriority(formatedstring);
            ldc.MethodName = MethodName;
            ldc.RequestText = requestobj;
            ldc.ObjectID = objectID;
            ldc.CreatedBy = username;
            logrepo.InsertLog(ldc);
        }

        public void WriteLogExceptionMessage(string Module, string stackTrace, string objectID, string username, string MethodName, string message)
        {
            LoggerDataContract ldc = new LoggerDataContract();
            string formatedstring = stackTrace.Replace("'", "''");

            if (MethodName == "UI Log")
            {
                ldc.ExceptionSource = "UI Log";
                ldc.MethodName = null;
            }
            else
            {
                ldc.ExceptionSource = null;
                ldc.MethodName = MethodName;
            }

            ldc.Message_StackTrace = formatedstring;
            ldc.Message = message;
            ldc.Severity = CRESEnums.Severity.Error.ToString();
            ldc.Module = Module;
            ldc.Priority = LoggerHelper.GetExceptionPriority(formatedstring);

            ldc.RequestText = null;

            ldc.ObjectID = objectID;
            ldc.CreatedBy = username;
            logrepo.InsertLog(ldc);
        }


        public void WriteLogException(string Module, string message, string username, string MethodName)
        {
            LoggerDataContract ldc = new LoggerDataContract();
            string formatedstring = message;
            ldc.Message_StackTrace = message + " " + formatedstring;
            ldc.Severity = CRESEnums.Severity.Error.ToString();
            ldc.Module = Module;
            ldc.Priority = ldc.Priority = CRESEnums.Priority.Medium.ToString();
            ldc.MethodName = MethodName;
            ldc.ObjectID = "";
            ldc.CreatedBy = username;
            logrepo.InsertLog(ldc);
        }

        public void WriteLogInfo(string Module, string message, string objectid, string username)
        {
            LoggerDataContract ldc = new LoggerDataContract();
            ldc.ExceptionSource = "";
            ldc.Message_StackTrace = "";
            ldc.Message = message;
            ldc.Severity = CRESEnums.Severity.Info.ToString();
            ldc.Module = Module;

            ldc.Priority = CRESEnums.Priority.Low.ToString();
            ldc.MethodName = "";
            ldc.RequestText = "";
            ldc.ObjectID = objectid;
            ldc.CreatedBy = username;
            logrepo.InsertLog(ldc);
        }

        public bool GetAllowLoggingValue()
        {
            return logrepo.GetAllowLoggingValue();
        }

    }
}
