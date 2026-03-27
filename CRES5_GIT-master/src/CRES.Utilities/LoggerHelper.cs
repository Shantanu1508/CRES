using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Runtime.Serialization;
using System.Security.Principal;
using System.Text;
using System.Xml;
 

namespace CRES.Utilities
{

    public static class LoggerHelper
    {
        public static string GetExceptionString(Exception exception)
        {
            StackFrame stackFrame = new StackFrame(1);
            MethodBase callingMethod = stackFrame.GetMethod();
            // Build a string containing the namespace and method name
            string caller = string.Format("{0}.{1}", callingMethod.DeclaringType.FullName, callingMethod.Name);

            // get stack trace
            string stackTrace = exception.StackTrace;

            // get all messages
            var sb = new StringBuilder();

            if (exception.GetType().FullName == "System.Data.SqlClient.SqlException")
            {
             
                SqlException selException = exception as SqlException;

                sb.Append(
                     "Message: " + selException.Message + "\n" +
                     "Error Number: " + selException.Number + "\n" +
                     "LineNumber: " + selException.LineNumber + "\n" +
                     "Source: " + selException.Source + "\n" +
                     "Procedure: " + selException.Procedure + "\n" +
                      "caller: " + selException.TargetSite.Name + "\n" +
                       "StackTrace: " + selException.ToString() + "\n"
                     );
            }
            else
            {
                sb.AppendLine("-------------------  Exception Occured in " + caller + " Begin ------------------- ");
                sb.AppendLine("Procedure");
                sb.AppendLine("<---- StackTrace Begin ---- >");
                sb.AppendLine(stackTrace);
                sb.AppendLine("<---- StackTrace End ---- >");
                sb.AppendLine(exception.Message);

                while (exception.InnerException != null)
                {
                    exception = exception.InnerException;
                    sb.AppendLine(" --> ").Append(exception.Message);
                }
                sb.AppendLine("-------------------  Exception Occured in " + caller + " Ends ------------------- ");
            }




            return sb.ToString();
        }

        public static string GetMessage(this Exception ex)
        {
            return ex.InnerException == null
                 ? ex.Message
                 : ex.Message + " --> " + ex.InnerException.GetFullMessage();
        }

        public static string GetExceptionPriority(string exstring)
        {
            string Priority = "";
            if (exstring.Contains("timeout period elapsed"))
            {
                Priority = "High";
            }
            else if (exstring.Contains("out of memory"))
            {
                Priority = "Fatal";
            }
            else if (exstring.Contains("was deadlocked on lock resources with another"))
            {
                Priority = "Fatal";
            }
            else
            {
                Priority = "Medium";
            }
            return Priority;
        }


    }
}
