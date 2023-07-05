using System;
using System.Diagnostics;
using System.Reflection;
using System.Text;

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

            sb.AppendLine("-------------------  Exception Occured in " + caller + " Begin ------------------- ");
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
