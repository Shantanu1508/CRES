using System;
using Azure.Storage.Queues.Models;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.DAL.Repository;
using CRES.DAL.Helper;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Net.Http;
using System.Text.Json;
using Azure.Core;
using Grpc.Core;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace CRES.AzureFunctionApp
{
    public class V1CalcAzureFunction
    {
        private readonly ILogger<V1CalcAzureFunction> _logger;

        public V1CalcAzureFunction(ILogger<V1CalcAzureFunction> logger)
        {
            _logger = logger;
        }

        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";

        [Function(nameof(V1CalcAzureFunction))]
        public void Run([QueueTrigger("azqueuestoragedemo", Connection = "ConnStrName")] QueueMessage message)
        {
            _logger.LogInformation($"C# Queue trigger function processed: {message.MessageText}");
            LoggerLogic log = new LoggerLogic();
            string Periodicstatus = "";
            string stripstatus = "";
            string trnstatus = "";

            try
            {
                var messageData = JsonSerializer.Deserialize<V1CalcQueueSaveOutput>(message.MessageText);

                if (messageData != null)
                {
                    V1CalcLogic v1logic = new V1CalcLogic();

                    Periodicstatus = v1logic.SavePeriodicOutput(messageData.requestid, messageData.headerkey, messageData.headerValue, messageData.strAPI, messageData.SourceNoteID, messageData.AnalysisID, messageData.username);
                    log.WriteLogInfo("CalcDataSaving", "SavePeriodicOutput executed", "", "", "UpdateM61EngineCalcStatus");

                    trnstatus = v1logic.SaveTransactionsOutput(messageData.requestid, messageData.headerkey, messageData.headerValue, messageData.strAPI, messageData.SourceNoteID, messageData.AnalysisID, messageData.username, messageData.noteid);
                    log.WriteLogInfo("CalcDataSaving", "SaveTransactionsOutput executed", "", "", "UpdateM61EngineCalcStatus");

                    stripstatus = v1logic.SaveStripingOutput(messageData.requestid, messageData.headerkey, messageData.headerValue, messageData.strAPI, messageData.SourceNoteID, messageData.AnalysisID, messageData.username);
                    log.WriteLogInfo("CalcDataSaving", "SaveStripingOutput executed", "", "", "UpdateM61EngineCalcStatus");

                    v1logic.SaveDailyData(messageData.requestid, messageData.headerkey, messageData.headerValue, messageData.strAPI, messageData.noteid, messageData.AnalysisID, messageData.username);
                    log.WriteLogInfo("CalcDataSaving", "SaveDailyData executed", "", "", "UpdateM61EngineCalcStatus");

                    if (Periodicstatus == "Saved" && stripstatus == "Saved" && trnstatus == "Saved")
                    {
                        v1logic.UpdateM61EngineCalcStatus(messageData.requestid, Convert.ToInt32(2), "");
                        v1logic.UpdateCalculationStatusForDependents(messageData.SourceNoteID, messageData.AnalysisID);
                        log.WriteLogInfo("CalcDataSaving", " Update Calculation Status For Dependents " + "CrenoteID : Requestid : " + messageData.SourceNoteID + " : " + messageData.requestid, messageData.requestid, "");

                    }
                    else
                    {
                        v1logic.UpdateM61EngineCalcStatus(messageData.requestid, Convert.ToInt32(-1), "");
                    }
                }
            }
            catch (Exception ex)
            {
                log.WriteLogException("CalcDataSaving", "Error in UpdateM61EngineCalcStatus_AzureFunction", "", useridforSys_Scheduler, "UpdateM61EngineCalcStatus", "", ex);
            }

        }

    }
}
