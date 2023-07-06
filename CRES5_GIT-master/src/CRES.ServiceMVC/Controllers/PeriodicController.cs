using CRES.BusinessLogic;
#pragma warning disable CS0105 // The using directive for 'CRES.BusinessLogic' appeared previously in this namespace
#pragma warning restore CS0105 // The using directive for 'CRES.BusinessLogic' appeared previously in this namespace
using CRES.DataContract;
using CRES.Utilities;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading;

namespace CRES.Services.Controllers
{

    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class PeriodicController : ControllerBase
    {
        private PeriodicLogic _periodicLogic = new PeriodicLogic();

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/periodic/getperiodicclosebyuserid")]
        public IActionResult GetPeriodicCloseByUserID([FromBody] PeriodicDataContract _periodicDC)
        {
            GenericResult _authenticationResult = null;
            List<PeriodicDataContract> lstPeriodicClose = new List<PeriodicDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            lstPeriodicClose = _periodicLogic.GetPeriodicCloseByUserID(headerUserID, _periodicDC.AnalysisID);

            try
            {
                if (lstPeriodicClose != null)
                {
                    Logger.Write(lstPeriodicClose.Count + " periodic close for user Id " + headerUserID + " loaded successfully", MessageLevel.Info);
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(lstPeriodicClose.Count),
                        lstPeriodicClose = lstPeriodicClose
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Authentication failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.DeflateCompression]
        [Services.Controllers.IsAuthenticate]
        [Route("api/periodic/saveperiodicclose")]
        public IActionResult SavePeriodicClose([FromBody] PeriodicDataContract _periodicDC)
        {
            GenericResult _actionResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            PeriodicLogic _periodicLogic = new PeriodicLogic();

            Guid? PeriodId;
            PeriodId = _periodicLogic.SavePeriodicClose(_periodicDC.StartDate, _periodicDC.EndDate, _periodicDC.AzureBlobLink, new Guid(headerUserID), new Guid("00000000-0000-0000-0000-000000000000"));



            Thread FirstThread = new Thread(() => ImportIntoPeriodCloseArchive(_periodicDC.StartDate, _periodicDC.EndDate, PeriodId, new Guid(headerUserID), new Guid("00000000-0000-0000-0000-000000000000")));
            FirstThread.Start();

            Thread SecondThread = new Thread(() => ImportIntoTransactionEntryClose(_periodicDC.StartDate, _periodicDC.EndDate, PeriodId, new Guid(headerUserID), new Guid("00000000-0000-0000-0000-000000000000"), _periodicDC.AnalysisID));
            SecondThread.Start();



            try
            {
                Logger.Write("Periodic close with User Id " + headerUserID + " saved successfully", MessageLevel.Info);
                _actionResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Changes were saved successfully.",
                };

                //back db

                try
                {
                    _periodicDC.PeriodID = PeriodId;
                    _periodicDC.UserID = headerUserID;
                    AzureStorageImportExportDatabases export = new AzureStorageImportExportDatabases();
                    export.BackupDatabaseToBlob(_periodicDC);
                }
                catch { }
            }
            catch (Exception ex)
            {
                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            //var javaScriptSerializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            //string jsonString = javaScriptSerializer.Serialize(_actionResult);
            //var json = new JavaScriptSerializer().Serialize(_actionResult);
            //Request.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
            return Ok(_actionResult);
        }



        public void ImportIntoPeriodCloseArchive(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? AnalysisID)
        {
            PeriodicLogic _periodicLogic = new PeriodicLogic();
            _periodicLogic.ImportIntoPeriodCloseArchive(StartDate, EndDate, PeriodId, userID, AnalysisID);

        }

        public void ImportIntoTransactionEntryClose(DateTime? StartDate, DateTime? EndDate, Guid? PeriodId, Guid? userID, Guid? TagMasterID, Guid? AnalysisID)
        {
            PeriodicLogic _periodicLogic = new PeriodicLogic();
            _periodicLogic.ImportIntoTransactionEntryClose(StartDate, EndDate, PeriodId, userID, TagMasterID, AnalysisID);

        }

        [HttpPost]
        [Services.Controllers.DeflateCompression]
        [Services.Controllers.IsAuthenticate]
        [Route("api/periodic/openperiodicclose")]
        public IActionResult OpenPeriodicClose([FromBody] PeriodicDataContract _periodicDC)
        {
            GenericResult _actionResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            try
            {
                PeriodicLogic _periodicLogic = new PeriodicLogic();
                _periodicDC.AnalysisID = new Guid("00000000-0000-0000-0000-000000000000");
                _periodicLogic.OpenPeriodicClose(new Guid(headerUserID), _periodicDC);
                Logger.Write("Periodic close with User Id " + headerUserID + " open successfully", MessageLevel.Info);
                _actionResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Changes were saved successfully.",
                };
            }
            catch (Exception ex)
            {
                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            //var javaScriptSerializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            //string jsonString = javaScriptSerializer.Serialize(_actionResult);
            //var json = new JavaScriptSerializer().Serialize(_actionResult);
            //Request.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
            return Ok(_actionResult);
        }

        public void DeleteTagMasterTransactionEntryClose(Guid? userID, PeriodicDataContract _periodicDC)
        {
            PeriodicLogic _periodicLogic = new PeriodicLogic();
            _periodicLogic.DeleteTagMasterTransactionEntryClose(userID, _periodicDC);
        }

    }
}