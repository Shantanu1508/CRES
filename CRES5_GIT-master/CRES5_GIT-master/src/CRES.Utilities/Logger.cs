using Microsoft.Practices.EnterpriseLibrary.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Runtime.Serialization;
using System.Security.Principal;
using System.Text;
using System.Xml;
using Ent = Microsoft.Practices.EnterpriseLibrary.Logging;


namespace CRES.Utilities
{
    public enum MessageLevel
    {
        Info,
        Warning,
        Error,
        Critical,
        Debug,
        Calculator_Info,
        Calculator_Warning
    }

    public enum ModuleName
    {
        Deal,
        Note,
        Calculator,
        WellsExtract,
        VSTO,
        AccountingReport,
        AccountingReportHistory,
        TransactionReconciliation,
        FileUpload,
        ServicerFileImport
    }


    public static class Logger
    {
        private const string BaseName = "NewConPlatform";

        public static void Write(string message)
        {
            Write(Guid.Empty, message, MessageLevel.Info);
        }

        //public static void Write(string message, TraceEventType severity)
        //{
        //    OutputToConsole(message, severity);

        //    Ent.Logger.Write(message,BaseName, -1, 1, severity, BaseName);
        //}

        // public static void Write(string message, MessageLevel messageLevel,string machineName)
        public static void Write(string message, MessageLevel messageLevel)
        {
            {
                Write(Guid.Empty, message, messageLevel);
            }
        }

        public static void Write(string message, MessageLevel messageLevel, string Userid, string ThreadName = "")
        {
            {
                Write(Guid.Empty, message, messageLevel, Userid, ThreadName);
            }
        }

        public static void Write(Guid workflowInstanceId, string message)
        {
            try
            {
                Write(workflowInstanceId, message, MessageLevel.Debug);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public static void Write(Guid workflowInstanceId, string message, MessageLevel messageLevel, string UserId, string ThreadName)
        {
            //string loggerinfo = WebConfigurationManager.AppSettings["LoggerInfoEnable"];
            //string loggerException = WebConfigurationManager.AppSettings["LoggerExceptionEnable"];
            //string loggercalculator = WebConfigurationManager.AppSettings["LoggerCalculatorEnable"];

            string loggerinfo = "true";
            string loggerException = "true";
            string loggercalculator = "true";


            try
            {
                Ent.LogEntry logEntry = new Ent.LogEntry();

                logEntry.Message = message;
                if (workflowInstanceId != Guid.Empty)
                    logEntry.ActivityId = workflowInstanceId;
                logEntry.MachineName = UserId;
                logEntry.ManagedThreadName = ThreadName;

                logEntry.Title = workflowInstanceId.ToString();
                switch (messageLevel)
                {
                    case MessageLevel.Info:
                        logEntry.Severity = TraceEventType.Information;
                        if (Convert.ToBoolean(loggerinfo) == true)
                        {
                            Logger.Write(logEntry);
                        }
                        break;



                    case MessageLevel.Warning:
                        logEntry.Severity = TraceEventType.Warning;
                        break;

                    case MessageLevel.Critical:
                        logEntry.Severity = TraceEventType.Critical;
                        break;

                    case MessageLevel.Error:
                        logEntry.Severity = TraceEventType.Error;
                        if (Convert.ToBoolean(loggerException) == true)
                        {
                            Logger.Write(logEntry);
                        }
                        break;

                    case MessageLevel.Calculator_Info:
                        logEntry.Severity = TraceEventType.Information;
                        if (Convert.ToBoolean(loggercalculator) == true)
                        {
                            Logger.Write(logEntry);
                        }
                        break;
                    case MessageLevel.Calculator_Warning:
                        logEntry.Severity = TraceEventType.Warning;
                        if (Convert.ToBoolean(loggercalculator) == true)
                        {
                            Logger.Write(logEntry);
                        }
                        break;
                }



                //if (Convert.ToBoolean(loggerinfo) == true)
                //{
                //    Logger.Write(logEntry);
                //}
                OutputToConsole(message, logEntry.Severity);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public static void Write(string title, string message, MessageLevel messageLevel)
        {
            try
            {
                Ent.LogEntry logEntry = new Ent.LogEntry();
                logEntry.Message = message;
                switch (messageLevel)
                {
                    case MessageLevel.Info:
                    case MessageLevel.Debug:
                        logEntry.Severity = TraceEventType.Information;
                        break;

                    case MessageLevel.Warning:
                        logEntry.Severity = TraceEventType.Warning;
                        break;

                    case MessageLevel.Critical:
                        logEntry.Severity = TraceEventType.Critical;
                        break;

                    case MessageLevel.Error:
                        logEntry.Severity = TraceEventType.Error;
                        break;
                }
                logEntry.Title = title;
                Logger.Write(logEntry);
                OutputToConsole(message, logEntry.Severity);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public static void Write(Guid workflowInstanceId, string title, Exception ex)
        {
            Ent.LogEntry logEntry = new Ent.LogEntry();
            logEntry.Message = "(" + title + ")" + ex.Message + "  (" + ex.StackTrace + ")";
            logEntry.Severity = TraceEventType.Error;
            logEntry.Title = workflowInstanceId.ToString();
            Logger.Write(logEntry);
            Console.ForegroundColor = GetMessageColor(TraceEventType.Error);
            Console.WriteLine(ex.Message);
            Console.WriteLine(ex.StackTrace);
            Console.ForegroundColor = ConsoleColor.White;
            if (ex.InnerException != null)
                Write(workflowInstanceId, title, ex.InnerException);
        }

        public static void Write(string title, Exception ex)
        {
            Ent.LogEntry logEntry = new Ent.LogEntry();
            logEntry.Message = ex.Message + "  (" + ex.StackTrace + ")";
            logEntry.Severity = TraceEventType.Error;
            logEntry.Title = title;
            Logger.Write(logEntry);
            Console.ForegroundColor = GetMessageColor(TraceEventType.Error);
            Console.WriteLine(ex.Message);
            Console.WriteLine(ex.StackTrace);
            Console.ForegroundColor = ConsoleColor.White;
            if (ex.InnerException != null)
                Write(title, ex.InnerException);
        }

        public static void Write(Exception ex)
        {
            Ent.LogEntry logEntry = new Ent.LogEntry();
            logEntry.Message = ex.Message + "  (" + ex.StackTrace + ")";
            logEntry.Severity = TraceEventType.Error;
            Logger.Write(logEntry);
            Console.ForegroundColor = GetMessageColor(TraceEventType.Error);
            Console.WriteLine(ex.Message);
            Console.WriteLine(ex.StackTrace);
            Console.ForegroundColor = ConsoleColor.White;
            if (ex.InnerException != null)
                Write(ex.InnerException);
        }

        public static void Write(string modulenName, string message, MessageLevel messageLevel, string UserId, string noteid)
        {
            //string loggerinfo = WebConfigurationManager.AppSettings["LoggerInfoEnable"];
            //string loggerException = WebConfigurationManager.AppSettings["LoggerExceptionEnable"];
            //string loggercalculator = WebConfigurationManager.AppSettings["LoggerCalculatorEnable"];

            string loggerinfo = "true";
            string loggerException = "true";
            string loggercalculator = "true";

            try
            {
                Ent.LogEntry logEntry = new Ent.LogEntry();
                logEntry.Message = message;
                logEntry.MachineName = UserId;
                logEntry.ManagedThreadName = noteid;
                logEntry.Title = modulenName;

                switch (messageLevel)
                {
                    case MessageLevel.Info:
                        logEntry.Severity = TraceEventType.Information;
                        if (Convert.ToBoolean(loggerinfo) == true)
                        {
                            Logger.Write(logEntry);
                        }
                        break;


                    case MessageLevel.Warning:
                        logEntry.Severity = TraceEventType.Warning;
                        break;

                    case MessageLevel.Critical:
                        logEntry.Severity = TraceEventType.Critical;
                        break;

                    case MessageLevel.Error:
                        logEntry.Severity = TraceEventType.Error;
                        if (Convert.ToBoolean(loggerException) == true)
                        {
                            Logger.Write(logEntry);
                        }
                        break;

                    case MessageLevel.Calculator_Info:
                        logEntry.Severity = TraceEventType.Information;
                        if (Convert.ToBoolean(loggercalculator) == true)
                        {
                            Logger.Write(logEntry);
                        }
                        break;
                    case MessageLevel.Calculator_Warning:
                        logEntry.Severity = TraceEventType.Warning;
                        if (Convert.ToBoolean(loggercalculator) == true)
                        {
                            Logger.Write(logEntry);
                        }
                        break;
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public static void LogMessage(string title, string message, TraceEventType severity)
        {
            Ent.LogEntry logEntry = new Ent.LogEntry();
            logEntry.Message = message;
            logEntry.Title = title;
            logEntry.Priority = 1;
            logEntry.Severity = severity;
            Logger.Write(logEntry);
        }

        public static void Write(Guid guid, string message, MessageLevel messageLevel, [Optional, DefaultParameterValue(true)] bool enableLogging, [Optional, DefaultParameterValue("*")] string allowedLogging)
        {
            try
            {
                Ent.LogEntry logEntry = new Ent.LogEntry();
                logEntry.Message = message;
                if (messageLevel == MessageLevel.Critical || messageLevel == MessageLevel.Error)
                {
                    if (messageLevel == MessageLevel.Critical)
                        logEntry.Severity = TraceEventType.Critical;
                    else
                        logEntry.Severity = TraceEventType.Error;

                    if (messageLevel == MessageLevel.Info)
                    {
                        logEntry.Severity = TraceEventType.Information;
                    }

                    logEntry.Title = guid.ToString();
                    Logger.Write(logEntry);
                    OutputToConsole(message, logEntry.Severity);
                    return;
                }

                if (!enableLogging)
                    return;

                bool writeLog = false;
                switch (allowedLogging)
                {
                    case "*":
                        switch (messageLevel)
                        {
                            case MessageLevel.Info:
                            case MessageLevel.Debug:
                                logEntry.Severity = TraceEventType.Information;
                                break;

                            case MessageLevel.Warning:
                                logEntry.Severity = TraceEventType.Warning;
                                break;
                        }
                        writeLog = true;
                        break;

                    case "Info":
                    case "Information":
                        if (messageLevel == MessageLevel.Info || messageLevel == MessageLevel.Debug)
                        {
                            logEntry.Severity = TraceEventType.Information;
                            writeLog = true;
                        }
                        break;

                    case "Warning":
                        if (messageLevel == MessageLevel.Warning)
                        {
                            logEntry.Severity = TraceEventType.Warning;
                            writeLog = true;
                        }
                        break;
                }
                if (writeLog)
                {
                    logEntry.Severity = TraceEventType.Information;
                    logEntry.Title = guid.ToString();
                    Logger.Write(logEntry);
                    OutputToConsole(message, logEntry.Severity);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public static void Write(string title, string message, MessageLevel messageLevel, [Optional, DefaultParameterValue(true)] bool enableLogging, [Optional, DefaultParameterValue("*")] string allowedLogging)
        {
            try
            {
                Ent.LogEntry logEntry = new Ent.LogEntry();
                logEntry.Message = message;
                if (messageLevel == MessageLevel.Critical || messageLevel == MessageLevel.Error)
                {
                    if (messageLevel == MessageLevel.Critical)
                        logEntry.Severity = TraceEventType.Critical;
                    else
                        logEntry.Severity = TraceEventType.Error;

                    logEntry.Severity = TraceEventType.Information;
                    logEntry.Title = title;
                    Logger.Write(logEntry);
                    OutputToConsole(message, logEntry.Severity);
                    return;
                }

                if (!enableLogging)
                    return;

                bool writeLog = false;
                switch (allowedLogging)
                {
                    case "*":
                        switch (messageLevel)
                        {
                            case MessageLevel.Info:
                            case MessageLevel.Debug:
                                logEntry.Severity = TraceEventType.Information;
                                break;

                            case MessageLevel.Warning:
                                logEntry.Severity = TraceEventType.Warning;
                                break;
                        }
                        writeLog = true;
                        break;

                    case "Info":
                    case "Information":
                        if (messageLevel == MessageLevel.Info || messageLevel == MessageLevel.Debug)
                        {
                            logEntry.Severity = TraceEventType.Information;
                            writeLog = true;
                        }
                        break;

                    case "Warning":
                        if (messageLevel == MessageLevel.Warning)
                        {
                            logEntry.Severity = TraceEventType.Warning;
                            writeLog = true;
                        }
                        break;
                }
                if (writeLog)
                {
                    logEntry.Severity = TraceEventType.Information;
                    logEntry.Title = title;
                    Logger.Write(logEntry);
                    OutputToConsole(message, logEntry.Severity);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public static void Write(LogEntry logEntry)
        {
            logEntry.ExtendedProperties.Add("User Id", WindowsIdentity.GetCurrent().Name);
            Ent.Logger.Write(logEntry);
        }

        public static void LogObjectState<T>(string methodName, T instance)
        {
            string xml = null;
            if (ToXml<T>(instance, out xml))
            {
                LogMessage(methodName, xml, TraceEventType.Information);
            }
            else
            {
                LogMessage(methodName, xml, TraceEventType.Error);
            }
        }

        public static string GetDictionaryString(Dictionary<string, string> KeyValues)
        {
            if (KeyValues == null)
                return string.Empty;

            StringBuilder sbMetaData = new StringBuilder();

            foreach (string key in KeyValues.Keys)
            {
                if (!string.IsNullOrEmpty(key))
                {
                    sbMetaData.Append(key);
                    sbMetaData.Append(": ");
                    if (KeyValues.ContainsKey(key) && KeyValues[key] != null)
                    {
                        string valAsString = KeyValues[key].ToString();
                        sbMetaData.Append(valAsString == null ? "[NULL]" : valAsString.ToString());
                    }
                }
            }
            return sbMetaData.ToString();
        }

        /// <summary>
        /// Write Exception to Log File
        /// </summary>
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

        public static string ToXmlTag<T>(T instance, params Type[] additionalTypesToInclude)
        {
            string xml = String.Empty;
            try
            {
                MemoryStream ms = new MemoryStream();
                var serializer = new DataContractSerializer(instance.GetType());
                using (var backing = new StringWriter())
                using (var writer = new XmlTextWriter(backing))
                {
                    serializer.WriteObject(writer, instance);
                    xml = backing.ToString();
                }
            }
            catch (Exception ex)
            {
                var strb = new StringBuilder("<?xml version=\"1.0\"?><errors>");
                Exception exCurrent = ex;
                while (exCurrent != null)
                {
                    strb.AppendFormat("<error message=\"{0}\" stackTrace=\"{1}\"/>", ex.Message, ex.StackTrace);
                    exCurrent = exCurrent.InnerException;
                }
                strb.Append("</errors>");
                xml = strb.ToString();
                return xml;
            }
            return xml;
        }

        private static bool ToXml<T>(T instance, out string xml)
        {
            xml = String.Empty;
            try
            {
                MemoryStream ms = new MemoryStream();
                var serializer = new DataContractSerializer(instance.GetType());
                using (var backing = new System.IO.StringWriter())
                using (var writer = new System.Xml.XmlTextWriter(backing))
                {
                    serializer.WriteObject(writer, instance);
                    xml = backing.ToString();
                }
                return true;
            }
            catch (Exception ex)
            {
                StringBuilder strb = new StringBuilder("<?xml version=\"1.0\"?><errors>");
                Exception exCurrent = ex;
                while (exCurrent != null)
                {
                    strb.AppendFormat("<error message=\"{0}\" stackTrace=\"{1}\"/>", ex.Message, ex.StackTrace);
                    exCurrent = exCurrent.InnerException;
                }
                strb.Append("</errors>");

                xml = strb.ToString();
                return false;
            }
        }

        private static ConsoleColor GetMessageColor(TraceEventType level)
        {
            switch (level)
            {
                case TraceEventType.Warning:
                    return ConsoleColor.Yellow;

                case TraceEventType.Error:
                case TraceEventType.Critical:
                    return ConsoleColor.Red;

                case TraceEventType.Information:
                    return ConsoleColor.Green;

                case TraceEventType.Verbose:
                    return ConsoleColor.Blue;

                case TraceEventType.Start:
                    return ConsoleColor.DarkGreen;

                default:
                    return ConsoleColor.White;
            }
        }

        public static void OutputToConsole(string message, TraceEventType severity)
        {
            Console.ForegroundColor = GetMessageColor(severity);
            Console.WriteLine(message);
            Console.ForegroundColor = ConsoleColor.Gray;
        }
    }
}
