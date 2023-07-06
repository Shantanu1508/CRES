
using CRES.BusinessLogic;
//using CRES.DAL;
using CRES.DataContract;
using CRES.Utilities;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;

namespace CRES.Services.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class DevDashBoardController : ControllerBase
    {
        private DevDashBoardLogic _DevDashBoardLogic = new DevDashBoardLogic();

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/GetcalculationStatus")]
        public IActionResult GetcalculationStatus([FromBody] string scenrioID)
        {
            GenericResult _authenticationResult = null;
            List<DevDashBoardDataContract> lstCalculationStatus = new List<DevDashBoardDataContract>();
            List<DevDashBoardDataContract> listuserrequstcount = new List<DevDashBoardDataContract>();
            List<DevDashBoardDataContract> listFastestandSlowest = new List<DevDashBoardDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            lstCalculationStatus = devDlogic.GetCalculationStaus(new Guid(scenrioID));
            listuserrequstcount = devDlogic.UserRequestCount(new Guid(scenrioID));
            listFastestandSlowest = devDlogic.GetFastestandSlowest(new Guid(scenrioID));
            listFastestandSlowest = listFastestandSlowest.OrderByDescending(x => x.value).ToList();
            try
            {
                if (lstCalculationStatus != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        CalculationStatus = lstCalculationStatus,
                        UserRequestCount = listuserrequstcount,
                        FastestandSlowest = listFastestandSlowest
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
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/GetFailedNotes")]
        public IActionResult GetFailedNotes([FromBody] string logtype)
        {
            GenericResult _authenticationResult = null;
            List<DevDashBoardDataContract> lstCalculationStatus = new List<DevDashBoardDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            if (logtype == "ServiceFailure")
            {
                logtype = "";
            }
            lstCalculationStatus = devDlogic.GetFailedNotes(logtype, new Guid(headerUserID));

            try
            {
                if (lstCalculationStatus != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Succeeded",
                        CalculationStatus = lstCalculationStatus
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Failed"
                    };
                }
            }
            catch (Exception ex)
            {
                string message = ExceptionHelper.GetFullMessage(ex);
                Logger.Write("Dash Board", "Error in loading: " + "" + " Exception : " + message, MessageLevel.Error, headerUserID, "");
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/GetCalcJson")]
        public IActionResult GetCalcJson([FromBody] DevDashBoardDataContract devDashBoard)
        {
            NoteDataContract _noteCalculatorDC = new NoteDataContract();

            string noteid = "";
            string analysisID = "";
            GenericResult _authenticationResult = null;
            List<DevDashBoardDataContract> lstCalculationStatus = new List<DevDashBoardDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();

            DataTable dt = devDlogic.GetNoteIDAndAnalysisID(devDashBoard.NoteID);

            analysisID = devDashBoard.ScenarioID;
            if (dt.Rows.Count > 0)
            {
                noteid = dt.Rows[0]["NoteID"].ToString();
                NoteLogic nl = new NoteLogic();
                _noteCalculatorDC = nl.GetNoteAllDataForCalculatorByNoteId(noteid, new Guid(headerUserID), new Guid(analysisID), null, null);
            }

            try
            {
                if (_noteCalculatorDC != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        NoteData = _noteCalculatorDC
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
                string message = ExceptionHelper.GetFullMessage(ex);
                Logger.Write("Dash Board", "Error in loading: " + "" + " Exception : " + message, MessageLevel.Error, headerUserID, "");
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        //[Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/refreshdatawarehouse")]
        public IActionResult RefreshDataWarehouse([FromBody] string currenttime)
        {
            List<DevDashBoardDataContract> _lstAppTimeZone = new List<DevDashBoardDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            NoteLogic _noteLogic = new NoteLogic();
            GenericResult _authenticationResult = null;
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            string Message = "";
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DataTable dt = devDlogic.GetDatabaseStatus(currenttime, new Guid(headerUserID));
            if (dt.Rows[0]["Status2"].ToString() != "Process Running")
            {
                Message = "Request to refresh data warehouse submitted successfully.";
                Thread FirstThread = new Thread(() => _noteLogic.importsourcetodw());
                FirstThread.Start();
            }
            else { Message = "Data warehouse process is already running."; }

            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = Message
            };

            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/geterrorlogcount")]
        public IActionResult GetErrorLogCount()
        {

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            GenericResult _authenticationResult = null;
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            List<DevDashBoardDataContract> lst = new List<DevDashBoardDataContract>();
            List<DevDashBoardDataContract> UserSummary = new List<DevDashBoardDataContract>();
            string Message = "";
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DataTable dt = devDlogic.GetErrorLogs();
            foreach (DataRow row in dt.Rows)
            {
                DevDashBoardDataContract dbc = new DevDashBoardDataContract();
                dbc.Name = row["Category"].ToString();
                dbc.ProcessType = row["Category"].ToString();
                if (dbc.Name == "")
                {
                    dbc.Name = "ServiceFailure";

                }
                else if (dbc.Name.Contains("ReadAccountingReportTemplate"))
                {

                    dbc.Name = "Reporting";
                }
                dbc.value = Convert.ToInt32(row["CategoryCount"]);
                lst.Add(dbc);
            }
            DataTable dtuser = devDlogic.ShowUserSummary();
            foreach (DataRow row in dtuser.Rows)
            {
                DevDashBoardDataContract res = UserSummary.Find(x => x.Name == row["UserName"].ToString());
                if (res != null)
                {
                    foreach (var User in UserSummary)
                    {
                        if (User.Name == row["UserName"].ToString())
                        {
                            if (row["Type"].ToString() == "Deal")
                            {
                                User.DealCount = Convert.ToInt32(row["Count"]);
                            }
                            else if (row["Type"].ToString() == "Note")
                            {
                                User.NoteCount = Convert.ToInt32(row["Count"]);

                            }
                        }
                    }
                }
                else
                {
                    DevDashBoardDataContract dbc = new DevDashBoardDataContract();
                    dbc.Name = row["UserName"].ToString();
                    if (row["Type"].ToString() == "Deal")
                    {
                        dbc.DealCount = Convert.ToInt32(row["Count"]);
                        dbc.NoteCount = 0;
                    }
                    else if (row["Type"].ToString() == "Note")
                    {
                        dbc.NoteCount = Convert.ToInt32(row["Count"]);
                        dbc.DealCount = 0;
                    }
                    UserSummary.Add(dbc);
                }

            }

            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = Message,
                UserRequestCount = lst,
                ResultList = UserSummary
            };

            return Ok(_authenticationResult);
        }




        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/calculatemultiplenotes")]
        public IActionResult CalculateMultipleNotes([FromBody] DevDashBoardDataContract devDashBoard)
        {
            NoteLogic _noteLogic = new NoteLogic();
            GenericResult _authenticationResult = null;
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            string Message = "";

            string noteids = devDashBoard.NoteID.Replace("\n", "");
            noteids = noteids.Replace("\t", "");
            devDlogic.CalculateMultipleNotes(noteids, devDashBoard.ScenarioID);

            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = Message
            };

            return Ok(_authenticationResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/calcallnotes")]
        public IActionResult CalcAllNotes([FromBody] string scenrioID)
        {
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            GenericResult _authenticationResult = null;
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            devDlogic.CalcAllNotes(scenrioID, headerUserID.ToString());
            _authenticationResult = new GenericResult()
            {
                Succeeded = true
            };

            return Ok(_authenticationResult);
        }



        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/GetAIDashBoardData")]
        public IActionResult GetAIDashBoardData()
        {
            GenericResult _authenticationResult = null;
            List<DevDashBoardDataContract> lstAIDashboard = new List<DevDashBoardDataContract>();
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            lstAIDashboard = devDlogic.GetAIDashBoardData();
            try
            {
                if (lstAIDashboard != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstAIDashboard = lstAIDashboard

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
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.AI_Assistant.ToString(), "Error occurred in GetAIDashBoardData ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/GetAIUserData")]
        public IActionResult GetAIUserData([FromBody] string username)
        {

            GenericResult _authenticationResult = null;
            List<DevDashBoardDataContract> lstAIDashboard = new List<DevDashBoardDataContract>();
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            lstAIDashboard = devDlogic.GetAIUserData(username);
            try
            {
                if (lstAIDashboard != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstAIDashboard = lstAIDashboard

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
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.AI_Assistant.ToString(), "Error occurred in GetAIDashBoardData ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/importStagingdata")]
        public IActionResult ImportStagingData()
        {

            GenericResult _authenticationResult = null;
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();
            string Message = "";


            AppConfigLogic appLogic = new AppConfigLogic();
            List<AppConfigDataContract> lstAppConfig = new List<AppConfigDataContract>();
            lstAppConfig = appLogic.GetAppConfigByKey(Guid.NewGuid(), "ImportStagingDataIntoIntegration");
            int IsImportEnable = Convert.ToInt32(lstAppConfig.FirstOrDefault().Value);


            string Status = devDlogic.GetImportStagingDataStatus();
            if (Status == "Not Completed")
            {
                Message = "Import staging data already in process.";
            }
            else
            {
                if (IsImportEnable == 0)
                {
                    Message = "The import flag is OFF, You have to enable that flag to import the staging data.";
                }
                else
                {

                    Message = "Request to import staging data submitted successfully.";

                    Thread thrd_ImportStagingData = new Thread(() => devDlogic.ImportStagingData());
                    thrd_ImportStagingData.Start();
                }
            }


            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = Message
            };
            return Ok(_authenticationResult);
        }


        [HttpGet]
        [Services.Controllers.DeflateCompression]
        [Route("api/devdash/getstagingdataintointegrationstatus")]
        public IActionResult GetStagingDataIntoIntegrationStatus()
        {

            GenericResult _authenticationResult = null;
            DevDashBoardLogic devDlogic = new DevDashBoardLogic();

            DataTable ImportDataStatus = devDlogic.GetStagingDataIntoIntegrationStatus();

            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                ImportDataStatus = ImportDataStatus
            };
            return Ok(_authenticationResult);
        }
    }
}