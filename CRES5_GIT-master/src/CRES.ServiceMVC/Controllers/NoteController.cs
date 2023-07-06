using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.NoteCalculator;
using CRES.Utilities;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading;
//using CRES.Utilities;

namespace CRES.ServicesNew.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class NoteController : ControllerBase
    {
#pragma warning disable CS0618 // 'IHostingEnvironment' is obsolete: 'This type is obsolete and will be removed in a future version. The recommended alternative is Microsoft.AspNetCore.Hosting.IWebHostEnvironment.'
        private IHostingEnvironment _env;
#pragma warning restore CS0618 // 'IHostingEnvironment' is obsolete: 'This type is obsolete and will be removed in a future version. The recommended alternative is Microsoft.AspNetCore.Hosting.IWebHostEnvironment.'


        //private readonly IEmailNotification _iEmailNotification;
        //public DealController(IEmailNotification iemailNotification, IHostingEnvironment env)
        //{
        //    _iEmailNotification = iemailNotification;
        //    _env = env;
        //}

        private readonly IEmailNotification _iEmailNotification;
#pragma warning disable CS0618 // 'IHostingEnvironment' is obsolete: 'This type is obsolete and will be removed in a future version. The recommended alternative is Microsoft.AspNetCore.Hosting.IWebHostEnvironment.'
        public NoteController(IEmailNotification iemailNotification, IHostingEnvironment env)
#pragma warning restore CS0618 // 'IHostingEnvironment' is obsolete: 'This type is obsolete and will be removed in a future version. The recommended alternative is Microsoft.AspNetCore.Hosting.IWebHostEnvironment.'
        {
            _iEmailNotification = iemailNotification;
            _env = env;
        }



        // GET: Note
        private NoteLogic _noteLogic = new NoteLogic();
        private TagMasterLogic _tagMasterLogic = new TagMasterLogic();

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getnotesbydealId")]
        public IActionResult GetNotesByDealId([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            List<NoteDataContract> lstNotes = new List<NoteDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            int? totalCount;
            lstNotes = _noteLogic.GetAllNotesFromDealIds(_noteDC.DealID, headerUserID, pageSize, pageIndex, out totalCount);

            try
            {
                if (lstNotes != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(totalCount),
                        lstNotes = lstNotes
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
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetNotesByDealId: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/getnotesfromdealdetailbydealID")]
        public IActionResult GetNotesFromDealDetailByDealID([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            List<NoteUsedInDealDataContract> lstNotes = new List<NoteUsedInDealDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            int? totalCount;
            lstNotes = _noteLogic.GetNotesFromDealDetailByDealID(_noteDC.DealID, headerUserID, pageSize, pageIndex, out totalCount);

            if (lstNotes.Count == 0)
            {
                NoteUsedInDealDataContract note = new NoteUsedInDealDataContract();
                note.TotalCommitment = 0;
                note.Isexclude = false;
                lstNotes.Add(note);
            }
            try
            {
                if (lstNotes != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(totalCount),
                        lstNotesDeal = lstNotes
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
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetNotesFromDealDetailByDealID: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/addnewnote")]
        [Services.Controllers.DeflateCompression]
        public IActionResult AddNewNote([FromBody] List<NoteDataContract> _noteDC)
        {
            GenericResult _actionResult = null;
            List<NoteDataContract> _lstNotes = new List<NoteDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            var createdBy = string.Empty;
            var UpdatedBy = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }


            NoteLogic _noteLogic = new NoteLogic();

            _noteDC = _noteDC.FindAll(x => x.CRENoteID != null && x.Name != null);

            string result = _noteLogic.AddNewNoteFromDealDetail(new Guid(headerUserID), _noteDC, headerUserID, headerUserID);
            if (_noteDC[0].NoteMaturityList != null)
            {
                _noteLogic.UpdateMaturityConfiguration(_noteDC, (new Guid(headerUserID)));
                if (_noteDC[0].NoteMaturityList.Rows.Count > 0)
                {
                    _noteLogic.SaveMaturitybydeal(_noteDC[0].NoteMaturityList, (new Guid(headerUserID)));
                }
            }
            // to call for AIEntityApi
            AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
            Thread FirstThread = new Thread(() => _dynamicentity.InsertUpdateAINoteEntitiesAsync(_noteDC, headerUserID));
            FirstThread.Start();

            try
            {
                if (result != "")
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Changes were saved successfully.",
                    };
                }
                else
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Updation failed",
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred while saving Notes with : Note ID " + _noteDC[0].CRENoteID, _noteDC[0].NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            return Ok(_actionResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/addupdatenoteadditionallist")]
        public IActionResult AddupdateNoteAdditinallist([FromBody] NoteAdditinalListDataContract _noteaddlistdc)
        {
            GenericResult _actionResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            string Validationmessage = string.Empty;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            try
            {

                #region  validate all list to have proper data

                if (_noteaddlistdc.RateSpreadScheduleList.Count > 0)
                    _noteaddlistdc.RateSpreadScheduleList = _noteaddlistdc.RateSpreadScheduleList.FindAll(y => y.Date != null).ToList();
                if (_noteaddlistdc.NotePrepayAndAdditionalFeeScheduleList != null)
                    _noteaddlistdc.NotePrepayAndAdditionalFeeScheduleList = _noteaddlistdc.NotePrepayAndAdditionalFeeScheduleList.FindAll(y => y.StartDate != null).ToList();
                if (_noteaddlistdc.NoteStrippingList != null)
                    _noteaddlistdc.NoteStrippingList = _noteaddlistdc.NoteStrippingList.FindAll(y => y.StartDate != null).ToList();
                if (_noteaddlistdc.lstFinancingFeeSchedule != null)
                    _noteaddlistdc.lstFinancingFeeSchedule = _noteaddlistdc.lstFinancingFeeSchedule.FindAll(y => y.Date != null).ToList();
                if (_noteaddlistdc.NoteFinancingScheduleList != null)
                    _noteaddlistdc.NoteFinancingScheduleList = _noteaddlistdc.NoteFinancingScheduleList.FindAll(y => y.Date != null).ToList();
                if (_noteaddlistdc.NoteDefaultScheduleList != null)
                    _noteaddlistdc.NoteDefaultScheduleList = _noteaddlistdc.NoteDefaultScheduleList.FindAll(y => y.StartDate != null).ToList();
                //  _noteaddlistdc.ListFutureFundingScheduleTab = _noteaddlistdc.ListFutureFundingScheduleTab.FindAll(y => y.Date != null).ToList();
                if (_noteaddlistdc.ListFixedAmortScheduleTab != null)
                    _noteaddlistdc.ListFixedAmortScheduleTab = _noteaddlistdc.ListFixedAmortScheduleTab.FindAll(y => y.Date != null).ToList();

                #endregion


                #region validationengine

                ExceptionsLogic _ExceptionsLogic = new ExceptionsLogic();
                ValidationEngine validate = new ValidationEngine();
                NoteDataContract _cnoteobject = ConvertToNoteobject(_noteaddlistdc);
                List<ExceptionDataContract> edc = validate.ValidateNoteObject(_cnoteobject);

                #endregion validationengine

                NoteLogic _noteLogic = new NoteLogic();
                int result = _noteLogic.AddUpdateNoteAdditinalList(new Guid(headerUserID), _noteaddlistdc, headerUserID, headerUserID);
                if (_noteaddlistdc.deleteMarketPriceList != null)
                {
                    _noteLogic.DeleteMarketPriceByNoteID(_noteaddlistdc.deleteMarketPriceList, new Guid(headerUserID));
                }
                if (_noteaddlistdc.noteValue == "Copy")
                {
                    //Script for copy FF while NOteCopy
                    _noteLogic.CopyFundingSchedule(_noteaddlistdc.NoteId, _noteaddlistdc.NoteId, headerUserID);
                }

                DynamicSizerLogic _dynamicsizer = new DynamicSizerLogic();
                DataTable data = _dynamicsizer.GetPikPaidTransactionByCREnoteID(_cnoteobject.CRENoteID);

                Decimal? sumCashFlow = 0, sumactual = 0;
                foreach (DataRow row in data.Rows)
                {
                    if (Convert.ToString(row["Tabletype"]) == "Actual")
                    {
                        sumactual = 0;
                        sumactual = CommonHelper.ToDecimal(row["Amount"]);
                    }
                    if (Convert.ToString(row["Tabletype"]) == "CashFlow")
                    {
                        sumCashFlow = 0;
                        sumCashFlow = CommonHelper.ToDecimal(row["Amount"]);
                    }

                }
                Validationmessage = validate.ValidatePikBalance(sumactual.GetValueOrDefault(0), sumCashFlow.GetValueOrDefault(0));
                if (Validationmessage != "")
                {
                    ExceptionDataContract ed = new ExceptionDataContract();
                    ed.ObjectID = new Guid(_cnoteobject.NoteId);
                    ed.ObjectTypeText = "Note";
                    ed.FieldName = "PIK Balance";
                    ed.Summary = Validationmessage;
                    ed.ActionLevelText = "Critical";
                    edc.Add(ed);
                }
                if (edc.Count > 0)
                {
                    //update validate exception in database
                    foreach (ExceptionDataContract exc in edc)
                    {
                        exc.CreatedBy = headerUserID;
                        exc.CreatedBy = headerUserID;
                    }
                    _ExceptionsLogic.InsertExceptions(edc, headerUserID);
                    Validationmessage = "Note saved successfully with exceptions.";
                }
                else
                {
                    //remove old exceptions
                    _ExceptionsLogic.DeleteExceptionByobject(_cnoteobject.NoteId, "note");
                    Validationmessage = "Note saved successfully.";
                }
                List<ExceptionDataContract> filteredlist = edc.FindAll(x => x.ActionLevelText == "Critical").ToList();
                if (filteredlist.Count == 0)
                {
                    if (_noteaddlistdc.noteobj.EnableM61Calculations != 4)
                    {
                        InsertSingleNoteForCalculation(headerUserID.ToString(), _noteaddlistdc.noteobj.AnalysisID, _cnoteobject.NoteId);
                    }

                }
                ////=============

                if (result != 0)
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = Validationmessage,
                        TotalCount = edc.Count
                    };
                }
                else
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Updation failed",
                    };
                }
            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in AddupdateNoteAdditinallist " + _noteaddlistdc.NoteId, _noteaddlistdc.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message.ToString()
                };
            }

            return Ok(_actionResult);
        }




        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/copynote")]
        public IActionResult CopyNote([FromBody] NoteDataContract _note)
        {
            GenericResult _actionResult = null;

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            string Validationmessage = string.Empty;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            try
            {
                NoteLogic _noteLogic = new NoteLogic();

                //if (_note.noteValue == "Copy")
                //{
                //Script for copy FF while NOteCopy
                string newnoteid = _noteLogic.CopyNote(_note, headerUserID);
                //  }               

                if (newnoteid != "")
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Note Copied Successfully. ",
                        newNoteID = newnoteid
                        //TotalCount = edc.Count
                    };
                }
                else
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Updation failed",
                    };
                }
            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in CopyNote " + _note.CRENoteID, _note.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message.ToString()
                };
            }

            return Ok(_actionResult);
        }
        public void ExportFutureFundingFromCRES(List<FutureFundingScheduleTab> lstFF, string headerUserID, NoteDataContract NoteDC)
        {
            NoteLogic nl = new NoteLogic();
            string BackShopStatus = "";
            string exceptionMessage = "success";

            exceptionMessage = nl.ExportFutureFundingFromNote(lstFF, headerUserID);

            if (exceptionMessage.ToLower() != "success")
            {
                if (exceptionMessage.ToLower().Contains("login failed"))
                {
                    BackShopStatus = "loginfailed";
                }
                else
                {
                    BackShopStatus = "backshopfailed";
                }

                if (BackShopStatus.ToLower().Contains("failed"))
                {
                    //   EmailNotification emailnotify = new EmailNotification();
                    _iEmailNotification.SendEmailExportFFBackShopFail(NoteDC, BackShopStatus, exceptionMessage);
                }
            }

        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/addupdatenotearchieveadditionallist")]
        public IActionResult AddupdateNoteArchieveAdditinallist([FromBody] NoteAdditinalListDataContract _noteaddlistdc)
        {
            GenericResult _actionResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            string Validationmessage = string.Empty;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            NoteLogic _noteLogic = new NoteLogic();
            int res = _noteLogic.DeleteNoteTransactionDetail(_noteaddlistdc.lstNoteServicingLog);

            int result = _noteLogic.AddUpdateNoteArchieveAdditinalList(new Guid(headerUserID), _noteaddlistdc, headerUserID, headerUserID);
            ////=============
            try
            {
                if (result != 0)
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = Validationmessage
                    };
                }
                else
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Updation failed",
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in AddupdateNoteArchieveAdditinallist " + _noteaddlistdc.NoteId, _noteaddlistdc.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            return Ok(_actionResult);
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getnoteadditinallist")]
        public IActionResult GetNoteAdditinalList([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _actionResult = null;
            NoteAdditinalListDataContract objNoteadd = new NoteAdditinalListDataContract();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            NoteLogic _noteLogic = new NoteLogic();
            if (_noteDC.NoteId != null)
            {

                objNoteadd = _noteLogic.GetNoteAdditinalList(new Guid(_noteDC.NoteId), new Guid(headerUserID));
                if (objNoteadd.ListFutureFundingScheduleTab == null)
                {
                    FutureFundingScheduleTab fss = new FutureFundingScheduleTab();
                    fss.Value = 0.00m;
                    fss.Applied = false;
                    List<FutureFundingScheduleTab> list = new List<FutureFundingScheduleTab>();
                    list.Add(fss);
                    objNoteadd.ListFutureFundingScheduleTab = list;
                }

                try
                {
                    if (objNoteadd != null)
                    {

                        _actionResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "Authentication succeeded",
                            NoteAdditinalList = objNoteadd
                        };
                    }
                    else
                    {
                        _actionResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "Record not found"
                        };
                    }
                }
                catch (Exception ex)
                {
                    LoggerLogic Log = new LoggerLogic();
                    Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetNoteAdditinalList: " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = ex.Message
                    };
                }
            }

            return Ok(_actionResult);
        }

        [HttpPost]
        [Services.Controllers.DeflateCompression]
        [Services.Controllers.IsAuthenticate]
        [Route("api/note/addnote")]
        public IActionResult Addteadditiote([FromBody] NoteDataContract _noteDC)
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

            NoteLogic _noteLogic = new NoteLogic();

            if (_noteDC.CopyCRENoteId != null)
            {
                _noteDC.CRENoteID = _noteDC.CopyCRENoteId;
                _noteDC.ClientNoteID = _noteDC.CopyCRENoteId;
                if (_noteDC.ListNoteMarketPrice.Count > 0 && _noteDC.ListNoteMarketPrice != null)
                {
                    for (var m = 0; m < _noteDC.ListNoteMarketPrice.Count; m++)
                    {
                        _noteDC.ListNoteMarketPrice[m].NoteID = _noteDC.CopyCRENoteId;
                    }
                }

            }

            if (_noteDC.CopyName != null)
            {
                _noteDC.Name = _noteDC.CopyName;
            }
            if (_noteDC.CopyDealName != null)
            {
                _noteDC.DealName = _noteDC.CopyDealName;
            }
            if (_noteDC.CopyDealID != null)
            {
                _noteDC.DealID = _noteDC.CopyDealID;
            }

            //  bool result = _noteLogic.AddNewNote(new Guid(headerUserID), _noteDC);
            List<NoteDataContract> lstNoteDC = new List<NoteDataContract> { _noteDC };
            string result = _noteLogic.AddNewNote(new Guid(headerUserID), lstNoteDC, headerUserID, headerUserID);

            if (_noteDC.ListNoteMarketPrice.Count > 0 && _noteDC.ListNoteMarketPrice != null)
            {
                _noteLogic.InsertUpdateMarketPriceByNoteID(_noteDC.ListNoteMarketPrice, new Guid(headerUserID));
            }
            // to call for AIEntityApi
            AIDynamicEntityUpdateLogic _dynamicentity = new AIDynamicEntityUpdateLogic();
            Thread FirstThread = new Thread(() => _dynamicentity.InsertUpdateAINoteEntitiesAsync(lstNoteDC, headerUserID));
            FirstThread.Start();
            try
            {
                if (result != "00000000-0000-0000-0000-000000000000")
                {

                    _actionResult = new GenericResult()
                    {
                        newNoteID = result,
                        Succeeded = true,
                        Message = "Changes were saved successfully.",
                    };
                }
                else
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Updation failed",
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in AddNote: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_actionResult);
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Route("api/note/getnotebynoteId")]
        [Services.Controllers.DeflateCompression]
        public IActionResult GetNoteByNoteId([FromBody] NoteDataContract _noteDC)
        { //manish
            GenericResult _acationResult = null;
            NoteDataContract objNote = new NoteDataContract();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            UserPermissionLogic upl = new UserPermissionLogic();
            DataTable dt = new DataTable();
            DataTable dtnotecommitment = new DataTable();
            //to get user
            List<UserPermissionDataContract> permissionlist = upl.GetuserPermissionByUserIDAndPageName(headerUserID.ToString(), "NoteDetail", _noteDC.NoteId, 182);
            if (permissionlist != null && permissionlist.Count > 0)
            {
                objNote = _noteLogic.GetNoteFromNoteId(_noteDC.NoteId, headerUserID, _noteDC.AnalysisID);

                ScenarioLogic _sl = new ScenarioLogic();
                objNote.DefaultScenarioParameters = _sl.GetActiveScenarioParameters(_noteDC.AnalysisID);
                objNote.DefaultscenarioID = objNote.DefaultScenarioParameters.AnalysisID;
                objNote.ListEffectiveDateCount = _noteLogic.GetScheduleEffectiveDateCount(new Guid(_noteDC.NoteId));
                dt = _noteLogic.GetMarketPriceByNoteID(_noteDC.NoteId, Convert.ToString(headerUserID));
                dtnotecommitment = _noteLogic.GetNoteCommitmentsByNoteID(_noteDC.NoteId, Convert.ToString(headerUserID));
            }

            try
            {
                if (objNote.StatusCode == 200)
                {

                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        NoteData = objNote,
                        UserPermissionList = permissionlist,
                        dt = dt,
                        dtNoteCommitment = dtnotecommitment
                    };
                }
                else
                {
                    _acationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Not Exists",
                        StatusCode = 404
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetNotesByDealId: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _acationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_acationResult);
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getallLookup")]
        public IActionResult GetAllLookup()
        {
            string getAllLookup = "2,5,6,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,28,29,32,33,39,43,44,47,1,50,62,65,66,71,72,73,74,78,79,95,99,110";
            GenericResult _authenticationResult = null;
            List<LookupDataContract> lstlookupDC = new List<LookupDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            LookupLogic lookupLogic = new LookupLogic();
            lstlookupDC = lookupLogic.GetAllLookups(getAllLookup);
            lstlookupDC = lstlookupDC.OrderBy(x => x.SortOrder).ToList();

            try
            {
                if (lstlookupDC != null)
                {
                    // Logger.Write("Note lookup loaded successfully", MessageLevel.Info);
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstLookups = lstlookupDC
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
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetAllLookup ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/getnotecalculatordatabynoteId")]
        public IActionResult GetNoteCalculatorDataByNoteId([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
#pragma warning disable CS0219 // The variable '_result' is assigned but its value is never used
            IActionResult _result = null;
#pragma warning restore CS0219 // The variable '_result' is assigned but its value is never used
            GenericResult _authenticationResult = null;
            NoteDataContract _noteCalculatorDC = new NoteDataContract();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            try
            {
#pragma warning disable CS0219 // The variable 'flag' is assigned but its value is never used
                bool flag = false;
#pragma warning restore CS0219 // The variable 'flag' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'totalCount' is assigned but its value is never used
                int? totalCount = 0;
#pragma warning restore CS0219 // The variable 'totalCount' is assigned but its value is never used

                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                // check for dependents
                PayruleSetupLogic _PayruleSetupLogic = new PayruleSetupLogic();
                List<PayruleSetupDataContract> notedependtslist = _PayruleSetupLogic.GetNoteDependentsByNoteID(_noteDC.NoteId);

                //  calculationlogic.UpdateCalculationStatusandTime(_cmDC.CalculationRequestID, _cmDC.NoteId, "Failed", "EndTime", ex.Message);

                if (notedependtslist.Count > 0)
                {
                    List<CalculationManagerDataContract> listnotes = new List<CalculationManagerDataContract>();
                    foreach (PayruleSetupDataContract pay in notedependtslist)
                    {
                        CalculationManagerDataContract cdc = new CalculationManagerDataContract();
                        cdc.StatusText = "Dependents";
                        cdc.UserName = headerUserID.ToString();
                        cdc.ApplicationText = "";
                        cdc.PriorityText = "Real Time";
                        cdc.NoteId = pay.StripTransferTo;
                        listnotes.Add(cdc);
                    }
                    calculationlogic.QueueNotesForCalculation(listnotes, headerUserID.ToString());
                }

                NoteLogic nl = new NoteLogic();
                _noteCalculatorDC = nl.GetNoteAllDataForCalculatorByNoteId(_noteDC.NoteId, null, _noteDC.AnalysisID, null, null);

                CalculationMaster cm = new CalculationMaster();
                NoteDataContract objNote = cm.StartCalculation(_noteCalculatorDC);

                List<PIKDistributionsDataContract> ListPIkDis = new List<PIKDistributionsDataContract>();
                if (objNote.NotePIKScheduleList != null)
                {
                    if (objNote.NotePIKScheduleList.Count > 0)
                    {
                        foreach (PIKSchedule pik in objNote.NotePIKScheduleList)
                        {
                            foreach (PIKInterestTab pikc in objNote.ListPIKInterestTab)
                            {
                                if (pikc.TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod != null && pikc.TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod != 0)
                                {
                                    PIKDistributionsDataContract pikdc = new PIKDistributionsDataContract();
                                    pikdc.SourceNoteID = pik.NoteID;
                                    pikdc.ReceiverNoteID = pik.TargateNoteID;
                                    pikdc.Amount = pikc.TotalPIKInteresttobeTransferredtoRelatedNoteforthePeriod;
                                    pikdc.TransactionDate = pikc.Date;
                                    ListPIkDis.Add(pikdc);
                                }
                            }

                        }

                    }
                }

                if (objNote != null && objNote.CalculatorExceptionMessage == "Succeed")
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Calculation succeeded",
                        lstNotePeriodicOutputsDataContract = objNote.ListNotePeriodicOutputs,
                        ListTransaction = objNote.ListTransaction,
                        ListCashflowTransactionEntry = objNote.ListCashflowTransactionEntry,
                        ListNotePeriodicOutput_Daily = objNote.ListNotePeriodicOutput_Daily,
                        ListNotePeriodicOutput_PVAndGaap = objNote.ListNotePeriodicOutput_PVAndGaap,
                        ListNotePeriodicOutput_SpreadAndLibor = objNote.ListNotePeriodicOutput_SpreadAndLibor,
                        ListInterestCalculator = objNote.ListInterestCalculator,
                        ListPIKDistribution = ListPIkDis,
                        ListDailyInterestAccruals = objNote.ListDailyInterestAccruals,
                        CalculatorExceptionMessage = objNote.CalculatorExceptionMessage
                    };
                }
                else
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = objNote.CalculatorExceptionMessage
                    };
                }
                if (_authenticationResult.ListCashflowTransactionEntry != null)
                {
                    _noteLogic.InsertCashflowTransaction(_authenticationResult.ListCashflowTransactionEntry, _noteDC.NoteId, headerUserID.ToString());
                }


                Thread FirstThread = new Thread(() => saveOutputCalculatorValues(_authenticationResult, _noteDC.NoteId, headerUserID.ToString(), _noteDC.AnalysisID));
                FirstThread.Start();
                if (notedependtslist.Count > 0)
                {
                    foreach (PayruleSetupDataContract psd in notedependtslist)
                    {
                        calculationlogic.UpdateCalculationStatus(psd.StripTransferTo, "Processing", _noteDC.AnalysisID);
                    }
                }


            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error while calculating single note id :" + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/getliborscheduledatabynoteId")]
        public IActionResult GetLiborScheduleDataByNoteId([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            List<LiborScheduleTab> lstLiborScheduledata = new List<LiborScheduleTab>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            int? totalCount;
            lstLiborScheduledata = _noteLogic.GetLiborScheduleTabListDataForCalcByNoteId(new Guid(_noteDC.NoteId), Convert.ToInt32(_noteDC.IndexNameID), headerUserID, _noteDC.AnalysisID, pageIndex, pageSize, out totalCount);
            try
            {
                if (lstLiborScheduledata != null)
                {
                    if (lstLiborScheduledata.Count > 0)
                    {

                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            TotalCount = Convert.ToInt32(totalCount),
                            lstLiborScheduledata = lstLiborScheduledata
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed"
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
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

        public GenericResult GetCalculatorAPI(NoteDataContract _noteCalculatorDC)
        {
            GetConfigSetting();
            //string _endPoint = System.Configuration.ConfigurationManager.AppSettings["_calcServiceEndPoint"].ToString();
            string _endPoint = Sectionroot.GetSection("_calcServiceEndPoint").Value;
            using (var client = new HttpClient())
            {
                using (var httpClient = new HttpClient())
                {
                    httpClient.Timeout = TimeSpan.FromMinutes(4);
                    var response = httpClient.PostAsJsonAsync(_endPoint, _noteCalculatorDC).ContinueWith((postTask) => postTask.Result.EnsureSuccessStatusCode()).Result;
                    //return response;

                    return Newtonsoft.Json.JsonConvert.DeserializeObject<GenericResult>(response.Content.ReadAsStringAsync().Result);
                }
            }
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/GetHistoricalDataOfModuleByNoteId")]
        public IActionResult GetHistoricalDataOfModuleByNoteId([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;

            //int? pageIndex = _noteDC.pageIndex;
            //int? pageSize = _noteDC.pageSize;
            string modulename = _noteDC.modulename;

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            try
            {
                bool flag = false;
                int? totalCount = 0;

                DataTable dtMaturityScenariosDataContract = new DataTable();
                DataTable dtRateSpreadSchedule = new DataTable();
                DataTable dtPrepayAndAdditionalFeeScheduleDataContract = new DataTable();
                DataTable dtStrippingScheduleDataContract = new DataTable();
                DataTable dtFinancingFeeScheduleDataContract = new DataTable();
                DataTable dtFinancingScheduleDataContract = new DataTable();
                DataTable dtDefaultScheduleDataContract = new DataTable();
                DataTable dtServicingFeeScheduleDataContract = new DataTable();
                DataTable dtPIKSchedule = new DataTable();

                DataTable dtFundingSchedule = new DataTable();
                DataTable dtPIKScheduleDetail = new DataTable();
                DataTable dtLIBORSchedule = new DataTable();
                DataTable dtAmortSchedule = new DataTable();
                DataTable dtFeeCouponStripReceivable = new DataTable();

                switch (modulename)
                {
                    case "Maturity":
                        if (_noteDC.MaturityMethodID == 0)
                        {
                            dtMaturityScenariosDataContract = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        }
                        else
                        {
                            dtMaturityScenariosDataContract = _noteLogic.GetMaturityHistoricalDataByDealID(new Guid(_noteDC.DealID), headerUserID, _noteDC.MultipleNoteids);
                        }
                        if (dtMaturityScenariosDataContract.Rows.Count > 0) flag = true;

                        break;

                    //case "BalanceTransactionSchedule":
                    //    break;

                    case "DefaultSchedule":

                        dtDefaultScheduleDataContract = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtDefaultScheduleDataContract.Rows.Count > 0) flag = true;

                        break;

                    //case "FeeCouponSchedule":
                    //    break;

                    case "FinancingFeeSchedule":

                        dtFinancingFeeScheduleDataContract = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtFinancingFeeScheduleDataContract.Rows.Count > 0) flag = true;

                        break;

                    case "FinancingSchedule":

                        dtFinancingScheduleDataContract = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtFinancingScheduleDataContract.Rows.Count > 0) flag = true;

                        break;

                    case "PIKSchedule":

                        dtPIKSchedule = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtPIKSchedule.Rows.Count > 0) flag = true;

                        break;

                    case "PrepayAndAdditionalFeeSchedule":

                        dtPrepayAndAdditionalFeeScheduleDataContract = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtPrepayAndAdditionalFeeScheduleDataContract.Rows.Count > 0) flag = true;

                        break;

                    case "RateSpreadSchedule":

                        dtRateSpreadSchedule = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtRateSpreadSchedule.Rows.Count > 0) flag = true;

                        break;

                    case "ServicingFeeSchedule":

                        dtServicingFeeScheduleDataContract = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtServicingFeeScheduleDataContract.Rows.Count > 0) flag = true;

                        break;

                    case "StrippingSchedule":

                        dtStrippingScheduleDataContract = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtStrippingScheduleDataContract.Rows.Count > 0) flag = true;

                        break;

                    case "FundingSchedule":

                        dtFundingSchedule = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtFundingSchedule.Rows.Count > 0) flag = true;

                        break;

                    case "PIKScheduleDetail":

                        dtPIKScheduleDetail = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtPIKScheduleDetail.Rows.Count > 0) flag = true;

                        break;

                    case "LIBORSchedule":
                        dtLIBORSchedule = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtLIBORSchedule.Rows.Count > 0) flag = true;

                        break;

                    case "AmortSchedule":
                        dtAmortSchedule = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtAmortSchedule.Rows.Count > 0) flag = true;

                        break;

                    case "FeeCouponStripReceivable":
                        dtFeeCouponStripReceivable = _noteLogic.GetHistoricalDataOfModuleByNoteId(new Guid(_noteDC.NoteId), headerUserID, modulename, _noteDC.AnalysisID.ToString());
                        if (dtFeeCouponStripReceivable.Rows.Count > 0) flag = true;

                        break;

                    default:
                        break;
                }

                if (flag)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(totalCount),
                        lstMaturityScenariosDataContract = dtMaturityScenariosDataContract,
                        lstRateSpreadSchedule = dtRateSpreadSchedule,
                        lstPrepayAndAdditionalFeeScheduleDataContract = dtPrepayAndAdditionalFeeScheduleDataContract,
                        lstStrippingScheduleDataContract = dtStrippingScheduleDataContract,
                        lstFinancingFeeScheduleDataContract = dtFinancingFeeScheduleDataContract,
                        lstFinancingScheduleDataContract = dtFinancingScheduleDataContract,
                        lstDefaultScheduleDataContract = dtDefaultScheduleDataContract,
                        lstNoteServicingFeeScheduleDataContract = dtServicingFeeScheduleDataContract,
                        lstPIKSchedule = dtPIKSchedule,

                        lstFundingSchedule = dtFundingSchedule,
                        lstPIKScheduleDetail = dtPIKScheduleDetail,
                        lstLIBORSchedule = dtLIBORSchedule,
                        lstAmortSchedule = dtAmortSchedule,
                        lstFeeCouponStripReceivable = dtFeeCouponStripReceivable,
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Not Exists",
                        StatusCode = 404
                    };
                }
            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetHistoricalDataOfModuleByNoteId: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/getAllScheduleLatestDataByNoteId")]
        public IActionResult GetAllScheduleLatestDataByNoteId([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            NoteAllScheduleLatestRecordDataContract _noteAllScheduleLatestRecordDataContract = new NoteAllScheduleLatestRecordDataContract();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            int? totalCount;
            _noteAllScheduleLatestRecordDataContract = _noteLogic.GetAllScheduleLatestDataByNoteId(new Guid(_noteDC.NoteId), headerUserID, _noteDC.AnalysisID, pageIndex, pageSize, out totalCount);

            try
            {
                if (_noteAllScheduleLatestRecordDataContract != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(totalCount),
                        NoteAllScheduleLatestRecord = _noteAllScheduleLatestRecordDataContract,
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
        [Route("api/note/getFeeCouponStripReceivableDataByNoteId")]
        public IActionResult GetFeeCouponStripReceivableListDataByNoteId([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            NoteAllScheduleLatestRecordDataContract _noteAllScheduleLatestRecordDataContract = new NoteAllScheduleLatestRecordDataContract();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            int? totalCount;
            _noteAllScheduleLatestRecordDataContract.ListFeeCouponStripReceivable = _noteLogic.GetFeeCouponStripReceivableListDataByNoteId(new Guid(_noteDC.NoteId), headerUserID, _noteDC.AnalysisID, pageIndex, pageSize, out totalCount);

            try
            {
                if (_noteAllScheduleLatestRecordDataContract != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        TotalCount = Convert.ToInt32(totalCount),
                        NoteAllScheduleLatestRecord = _noteAllScheduleLatestRecordDataContract,
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
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetFeeCouponStripReceivableListDataByNoteId: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        public GenericResult GetCalculatorAPIForsave(NoteDataContract _noteDC)
        {
            string _endPoint = "http://localhost:63477/api/note/CalculateNoteSaveInputAndOutput";
            using (var client = new HttpClient())
            {
                using (var httpClient = new HttpClient())
                {
                    var response = httpClient.PostAsJsonAsync(_endPoint, _noteDC).Result;
                    //return response;

                    return Newtonsoft.Json.JsonConvert.DeserializeObject<GenericResult>(response.Content.ReadAsStringAsync().Result);
                }
            }
        }

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getNotePeriodicCalcByNoteId")]
        public IActionResult GetNotePeriodicCalcByNoteId([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            List<NotePeriodicOutputsDataContract> lstnotePeriodicOutputs = new List<NotePeriodicOutputsDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            lstnotePeriodicOutputs = _noteLogic.GetNotePeriodicCalcByNoteId(new Guid(_noteDC.NoteId), _noteDC.AnalysisID);

            try
            {
                if (lstnotePeriodicOutputs != null)
                {
                    if (lstnotePeriodicOutputs.Count > 0)
                    {

                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstnotePeriodicOutputs = lstnotePeriodicOutputs
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed"
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetNotePeriodicCalcByNoteId: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/getNotePeriodicCalcDynamicByNoteId")]
        public IActionResult GetNotePeriodicCalcDynamicByNoteId([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            //List<NoteCashflowsExportDataContract> lstNoteCashflowsExportData = new List<NoteCashflowsExportDataContract>();
            DataTable lstnotePeriodicOutputs = new DataTable();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            lstnotePeriodicOutputs = _noteLogic.GetNotePeriodicCalcDynamicByNoteId(new Guid(_noteDC.NoteId));
            try
            {
                if (lstnotePeriodicOutputs != null)
                {
                    if (lstnotePeriodicOutputs.Rows.Count > 0)
                    {

                        lstnotePeriodicOutputs.Columns.Remove("NotePeriodicCalcID");
                        lstnotePeriodicOutputs.Columns.Remove("NoteID");
                        lstnotePeriodicOutputs.Columns.Remove("CreatedDate");
                        lstnotePeriodicOutputs.Columns.Remove("CreatedBy");
                        lstnotePeriodicOutputs.Columns.Remove("UpdatedBy");
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstNoteCashflowsExportData = lstnotePeriodicOutputs
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed"
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
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
        [Route("api/note/checkduplicatenote")]
        // public IActionResult CheckDuplicateNote([FromBody] List<NoteDataContract> _noteDC)
        public IActionResult CheckDuplicateNote([FromBody] NoteDataContract _noteDC)
        {
            bool isexist = false;
            List<string> lstnoteexistmsg = new List<string>();
            GenericResult _authenticationResult = null;

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            NoteLogic noteLogic = new NoteLogic();

            if (_noteDC.CopyCRENoteId != null)
            {
                _noteDC.CRENoteID = _noteDC.CopyCRENoteId;
            }

            if (_noteDC.CopyName != null)
            {
                _noteDC.Name = _noteDC.CopyName;
            }
            if (_noteDC.CopyDealName != null)
            {
                _noteDC.DealName = _noteDC.CopyDealName;
            }
            if (_noteDC.CopyDealID != null)
            {
                _noteDC.DealID = _noteDC.CopyDealID;
            }


            isexist = noteLogic.CheckDuplicateNote(_noteDC);
            if (isexist)
            {
                lstnoteexistmsg.Add("Note " + _noteDC.Name + " and " + _noteDC.CRENoteID + " combination already exist.");

            }

            try
            {
                if (isexist == true)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Note " + _noteDC.Name + " and " + _noteDC.CRENoteID + " combination already exist.",
                        lstnoteexistmsg = lstnoteexistmsg
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        //   Message = "Note does not exist.",
                        lstnoteexistmsg = null
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
        [Route("api/note/getnoteexceptions")]
        public IActionResult GetNoteExceptions([FromBody] string objectid)
        {
            GenericResult _authenticationResult = null;
            List<NoteDataContract> lstNotes = new List<NoteDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            ExceptionsLogic _ExceptionsLogic = new ExceptionsLogic();

            List<ExceptionDataContract> _NoteExceptions = _ExceptionsLogic.GetNoteExceptionsList(objectid, "Note");

            try
            {
                if (_NoteExceptions != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        Allexceptionslist = _NoteExceptions
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
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetNoteExceptions: Note ID " + objectid, objectid, headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/validatenoteobj")]
        public IActionResult Validatenoteobj([FromBody] NoteAdditinalListDataContract _noteaddlistdc)
        {
            GenericResult _authenticationResult = null;
            string Validationmessage = string.Empty;
            int count = int.MinValue;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            #region validationengine

            ExceptionsLogic _ExceptionsLogic = new ExceptionsLogic();
            ValidationEngine validate = new ValidationEngine();

            NoteDataContract _cnoteobject = ConvertToNoteobject(_noteaddlistdc);
            List<ExceptionDataContract> edc = validate.ValidateNoteObject(_cnoteobject);
            int Criticalerror = edc.FindAll(x => x.ActionLevelText == "Critical").ToList().Count();

            if (Criticalerror == 0)
            {
                count = edc.Count;
            }
            else
            {
                Validationmessage = "Cannot calculate with missing fields see Exception tab for more information";
                count = edc.Count;
            }

            #endregion validationengine

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    Validationstring = Validationmessage,
                    exceptioncount = count,
                    Allexceptionslist = edc,
                    Criticalerror = Criticalerror
                };
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

        //_validatenoteobj

        public NoteDataContract ConvertToNoteobject(NoteAdditinalListDataContract _noteaddlistdc)
        {
            try
            {
                NoteAdditinalListDataContract _NoteAdditinalListDataContract = _noteaddlistdc;
                NoteDataContract noteobj = new NoteDataContract();

                noteobj.NoteId = _NoteAdditinalListDataContract.noteobj.NoteId;
                noteobj.AccountID = _NoteAdditinalListDataContract.noteobj.AccountID;
                noteobj.DealID = _NoteAdditinalListDataContract.noteobj.DealID;
                noteobj.DealName = _NoteAdditinalListDataContract.noteobj.DealName;
                noteobj.CREDealID = _NoteAdditinalListDataContract.noteobj.CREDealID;
                noteobj.CalculatorExceptionMessage = _NoteAdditinalListDataContract.noteobj.CalculatorExceptionMessage;
                noteobj.CRENoteID = _NoteAdditinalListDataContract.noteobj.CRENoteID;
                noteobj.ClientNoteID = _NoteAdditinalListDataContract.noteobj.ClientNoteID;
                noteobj.Comments = _NoteAdditinalListDataContract.noteobj.Comments;
                noteobj.EnableTrace = _NoteAdditinalListDataContract.noteobj.EnableTrace;
                noteobj.InitialInterestAccrualEndDate = _NoteAdditinalListDataContract.noteobj.InitialInterestAccrualEndDate;
                noteobj.AccrualFrequency = _NoteAdditinalListDataContract.noteobj.AccrualFrequency;
                noteobj.DeterminationDateLeadDays = _NoteAdditinalListDataContract.noteobj.DeterminationDateLeadDays;
                noteobj.DeterminationDateReferenceDayoftheMonth = _NoteAdditinalListDataContract.noteobj.DeterminationDateReferenceDayoftheMonth;
                noteobj.DeterminationDateInterestAccrualPeriod = _NoteAdditinalListDataContract.noteobj.DeterminationDateInterestAccrualPeriod;
                noteobj.DeterminationDateHolidayList = _NoteAdditinalListDataContract.noteobj.DeterminationDateHolidayList;
                noteobj.DeterminationDateHolidayListText = _NoteAdditinalListDataContract.noteobj.DeterminationDateHolidayListText;
                noteobj.FirstPaymentDate = _NoteAdditinalListDataContract.noteobj.FirstPaymentDate;
                noteobj.InitialMonthEndPMTDateBiWeekly = _NoteAdditinalListDataContract.noteobj.InitialMonthEndPMTDateBiWeekly;
                noteobj.PaymentDateBusinessDayLag = _NoteAdditinalListDataContract.noteobj.PaymentDateBusinessDayLag;
                noteobj.IOTerm = _NoteAdditinalListDataContract.noteobj.IOTerm;
                noteobj.AmortTerm = _NoteAdditinalListDataContract.noteobj.AmortTerm;
                noteobj.PIKSeparateCompounding = _NoteAdditinalListDataContract.noteobj.PIKSeparateCompounding;
                noteobj.MonthlyDSOverridewhenAmortizing = _NoteAdditinalListDataContract.noteobj.MonthlyDSOverridewhenAmortizing;
                noteobj.AccrualPeriodPaymentDayWhenNotEOMonth = _NoteAdditinalListDataContract.noteobj.AccrualPeriodPaymentDayWhenNotEOMonth;
                noteobj.FirstPeriodInterestPaymentOverride = _NoteAdditinalListDataContract.noteobj.FirstPeriodInterestPaymentOverride;
                noteobj.FirstPeriodPrincipalPaymentOverride = _NoteAdditinalListDataContract.noteobj.FirstPeriodPrincipalPaymentOverride;
                noteobj.FinalInterestAccrualEndDateOverride = _NoteAdditinalListDataContract.noteobj.FinalInterestAccrualEndDateOverride;
                noteobj.AmortType = _NoteAdditinalListDataContract.noteobj.AmortType;
                noteobj.RateType = _NoteAdditinalListDataContract.noteobj.RateType;
                noteobj.RateTypeText = _NoteAdditinalListDataContract.noteobj.RateTypeText;
                noteobj.ReAmortizeMonthly = _NoteAdditinalListDataContract.noteobj.ReAmortizeMonthly;
                noteobj.ReAmortizeatPMTReset = _NoteAdditinalListDataContract.noteobj.ReAmortizeatPMTReset;
                noteobj.StubPaidInArrears = _NoteAdditinalListDataContract.noteobj.StubPaidInArrears;
                noteobj.RelativePaymenttMonth = _NoteAdditinalListDataContract.noteobj.RelativePaymenttMonth;
                noteobj.SettleWithAccrualFlag = _NoteAdditinalListDataContract.noteobj.SettleWithAccrualFlag;
                noteobj.InterestDueAtMaturity = _NoteAdditinalListDataContract.noteobj.InterestDueAtMaturity;
                noteobj.RateIndexResetFreq = _NoteAdditinalListDataContract.noteobj.RateIndexResetFreq;
                noteobj.FirstRateIndexResetDate = _NoteAdditinalListDataContract.noteobj.FirstRateIndexResetDate;
                noteobj.LoanPurchase = _NoteAdditinalListDataContract.noteobj.LoanPurchase;
                noteobj.AmortIntCalcDayCount = _NoteAdditinalListDataContract.noteobj.AmortIntCalcDayCount;
                noteobj.StubPaidinAdvanceYN = _NoteAdditinalListDataContract.noteobj.StubPaidinAdvanceYN;
                noteobj.FullPeriodInterestDueatMaturity = _NoteAdditinalListDataContract.noteobj.FullPeriodInterestDueatMaturity;
                noteobj.ProspectiveAccountingMode = _NoteAdditinalListDataContract.noteobj.ProspectiveAccountingMode;
                noteobj.IsCapitalized = _NoteAdditinalListDataContract.noteobj.IsCapitalized;
                noteobj.SelectedMaturityDateScenario = _NoteAdditinalListDataContract.noteobj.SelectedMaturityDateScenario;
                //noteobj.SelectedMaturityDate = _NoteAdditinalListDataContract.noteobj.SelectedMaturityDate;
                // noteobj.InitialMaturityDate = _NoteAdditinalListDataContract.noteobj.InitialMaturityDate;
                //noteobj.ExpectedMaturityDate = _NoteAdditinalListDataContract.noteobj.ExpectedMaturityDate;
                // noteobj.FullyExtendedMaturityDate = _NoteAdditinalListDataContract.noteobj.FullyExtendedMaturityDate;
                //noteobj.OpenPrepaymentDate = _NoteAdditinalListDataContract.noteobj.OpenPrepaymentDate;
                noteobj.CashflowEngineID = _NoteAdditinalListDataContract.noteobj.CashflowEngineID;
                noteobj.LoanType = _NoteAdditinalListDataContract.noteobj.LoanType;
                noteobj.Classification = _NoteAdditinalListDataContract.noteobj.Classification;
                noteobj.SubClassification = _NoteAdditinalListDataContract.noteobj.SubClassification;
                noteobj.GAAPDesignation = _NoteAdditinalListDataContract.noteobj.GAAPDesignation;
                noteobj.PortfolioID = _NoteAdditinalListDataContract.noteobj.PortfolioID;
                noteobj.GeographicLocation = _NoteAdditinalListDataContract.noteobj.GeographicLocation;
                noteobj.PropertyType = _NoteAdditinalListDataContract.noteobj.PropertyType;
                noteobj.RatingAgency = _NoteAdditinalListDataContract.noteobj.RatingAgency;
                noteobj.RiskRating = _NoteAdditinalListDataContract.noteobj.RiskRating;
                noteobj.PurchasePrice = _NoteAdditinalListDataContract.noteobj.PurchasePrice;
                noteobj.FutureFeesUsedforLevelYeild = _NoteAdditinalListDataContract.noteobj.FutureFeesUsedforLevelYeild;
                noteobj.TotalToBeAmortized = _NoteAdditinalListDataContract.noteobj.TotalToBeAmortized;
                noteobj.StubPeriodInterest = _NoteAdditinalListDataContract.noteobj.StubPeriodInterest;
                noteobj.WDPAssetMultiple = _NoteAdditinalListDataContract.noteobj.WDPAssetMultiple;
                noteobj.WDPEquityMultiple = _NoteAdditinalListDataContract.noteobj.WDPEquityMultiple;
                noteobj.PurchaseBalance = _NoteAdditinalListDataContract.noteobj.PurchaseBalance;
                noteobj.DaysofAccrued = _NoteAdditinalListDataContract.noteobj.DaysofAccrued;
                noteobj.InterestRate = _NoteAdditinalListDataContract.noteobj.InterestRate;
                noteobj.PurchasedInterestCalc = _NoteAdditinalListDataContract.noteobj.PurchasedInterestCalc;
                noteobj.ModelFinancingDrawsForFutureFundings = _NoteAdditinalListDataContract.noteobj.ModelFinancingDrawsForFutureFundings;
                noteobj.NumberOfBusinessDaysLagForFinancingDraw = _NoteAdditinalListDataContract.noteobj.NumberOfBusinessDaysLagForFinancingDraw;
                noteobj.FinancingFacilityID = _NoteAdditinalListDataContract.noteobj.FinancingFacilityID;
                noteobj.FinancingFacilityIDText = _NoteAdditinalListDataContract.noteobj.FinancingFacilityIDText;
                noteobj.FinancingInitialMaturityDate = _NoteAdditinalListDataContract.noteobj.FinancingInitialMaturityDate;
                noteobj.FinancingExtendedMaturityDate = _NoteAdditinalListDataContract.noteobj.FinancingExtendedMaturityDate;
                noteobj.FinancingPayFrequency = _NoteAdditinalListDataContract.noteobj.FinancingPayFrequency;
                noteobj.FinancingInterestPaymentDay = _NoteAdditinalListDataContract.noteobj.FinancingInterestPaymentDay;
                noteobj.ClosingDate = _NoteAdditinalListDataContract.noteobj.ClosingDate;
                noteobj.InitialFundingAmount = _NoteAdditinalListDataContract.noteobj.InitialFundingAmount;
                noteobj.Discount = _NoteAdditinalListDataContract.noteobj.Discount;
                noteobj.OriginationFee = _NoteAdditinalListDataContract.noteobj.OriginationFee;
                noteobj.CapitalizedClosingCosts = _NoteAdditinalListDataContract.noteobj.CapitalizedClosingCosts;
                noteobj.PurchaseDate = _NoteAdditinalListDataContract.noteobj.PurchaseDate;
                noteobj.PurchaseAccruedFromDate = _NoteAdditinalListDataContract.noteobj.PurchaseAccruedFromDate;
                noteobj.PurchasedInterestOverride = _NoteAdditinalListDataContract.noteobj.PurchasedInterestOverride;
                noteobj.OngoingAnnualizedServicingFee = _NoteAdditinalListDataContract.noteobj.OngoingAnnualizedServicingFee;
                noteobj.DiscountRate = _NoteAdditinalListDataContract.noteobj.DiscountRate;
                noteobj.ValuationDate = _NoteAdditinalListDataContract.noteobj.ValuationDate;
                noteobj.FairValue = _NoteAdditinalListDataContract.noteobj.FairValue;
                noteobj.DiscountRatePlus = _NoteAdditinalListDataContract.noteobj.DiscountRatePlus;
                noteobj.FairValuePlus = _NoteAdditinalListDataContract.noteobj.FairValuePlus;
                noteobj.DiscountRateMinus = _NoteAdditinalListDataContract.noteobj.DiscountRateMinus;
                noteobj.FairValueMinus = _NoteAdditinalListDataContract.noteobj.FairValueMinus;
                noteobj.IncludeServicingPaymentOverrideinLevelYield = _NoteAdditinalListDataContract.noteobj.IncludeServicingPaymentOverrideinLevelYield;
                noteobj.IncludeServicingPaymentOverrideinLevelYieldText = _NoteAdditinalListDataContract.noteobj.IncludeServicingPaymentOverrideinLevelYieldText;
                noteobj.CreatedBy = _NoteAdditinalListDataContract.noteobj.CreatedBy;
                noteobj.CreatedDate = _NoteAdditinalListDataContract.noteobj.CreatedDate;
                noteobj.UpdatedBy = _NoteAdditinalListDataContract.noteobj.UpdatedBy;
                noteobj.UpdatedDate = _NoteAdditinalListDataContract.noteobj.UpdatedDate;
                noteobj.PIKSeparateCompoundingText = _NoteAdditinalListDataContract.noteobj.PIKSeparateCompoundingText;
                noteobj.LoanPurchaseYNText = _NoteAdditinalListDataContract.noteobj.LoanPurchaseYNText;
                noteobj.StubPaidinAdvanceYNText = _NoteAdditinalListDataContract.noteobj.StubPaidinAdvanceYNText;
                noteobj.ModelFinancingDrawsForFutureFundingsText = _NoteAdditinalListDataContract.noteobj.ModelFinancingDrawsForFutureFundingsText;
                noteobj.RelativePaymentMonth = _NoteAdditinalListDataContract.noteobj.RelativePaymentMonth;
                noteobj.InitialIndexValueOverride = _NoteAdditinalListDataContract.noteobj.InitialIndexValueOverride;
                noteobj.StubInterestPaidonFutureAdvances = _NoteAdditinalListDataContract.noteobj.StubInterestPaidonFutureAdvances;
                noteobj.TaxAmortCheck = _NoteAdditinalListDataContract.noteobj.TaxAmortCheck;
                noteobj.PIKWoCompCheck = _NoteAdditinalListDataContract.noteobj.PIKWoCompCheck;
                noteobj.GAAPAmortCheck = _NoteAdditinalListDataContract.noteobj.GAAPAmortCheck;
                noteobj.RoundingMethod = _NoteAdditinalListDataContract.noteobj.RoundingMethod;
                noteobj.RoundingMethodText = _NoteAdditinalListDataContract.noteobj.RoundingMethodText;
                noteobj.IndexRoundingRule = _NoteAdditinalListDataContract.noteobj.IndexRoundingRule;
                noteobj.StubOnFFtext = _NoteAdditinalListDataContract.noteobj.StubOnFFtext;
                noteobj.StubOnFF = _NoteAdditinalListDataContract.noteobj.StubOnFF;
                noteobj.StubInterestPurchased = _NoteAdditinalListDataContract.noteobj.StubInterestPurchased;
                noteobj.StatusID = _NoteAdditinalListDataContract.noteobj.StatusID;
                noteobj.StatusName = _NoteAdditinalListDataContract.noteobj.StatusName;
                noteobj.Name = _NoteAdditinalListDataContract.noteobj.Name;
                noteobj.BaseCurrencyID = _NoteAdditinalListDataContract.noteobj.BaseCurrencyID;
                noteobj.StartDate = _NoteAdditinalListDataContract.noteobj.StartDate;
                noteobj.EndDate = _NoteAdditinalListDataContract.noteobj.EndDate;
                noteobj.PayFrequency = _NoteAdditinalListDataContract.noteobj.PayFrequency;
                noteobj.LoanCurrency = _NoteAdditinalListDataContract.noteobj.LoanCurrency;
                noteobj.StubIntOverride = _NoteAdditinalListDataContract.noteobj.StubIntOverride;
                noteobj.PurchasedIntOverride = _NoteAdditinalListDataContract.noteobj.PurchasedIntOverride;
                noteobj.ExitFeeFreePrepayAmt = _NoteAdditinalListDataContract.noteobj.ExitFeeFreePrepayAmt;
                noteobj.ExitFeeBaseAmountOverride = _NoteAdditinalListDataContract.noteobj.ExitFeeBaseAmountOverride;
                noteobj.ExitFeeAmortCheck = _NoteAdditinalListDataContract.noteobj.ExitFeeAmortCheck;
                noteobj.ExitFeeAmortCheckText = _NoteAdditinalListDataContract.noteobj.ExitFeeAmortCheckText;
                noteobj.FixedAmortSchedule = _NoteAdditinalListDataContract.noteobj.FixedAmortSchedule;
                noteobj.FixedAmortScheduleText = _NoteAdditinalListDataContract.noteobj.FixedAmortScheduleText;
                noteobj.UseRuletoDetermineNoteFunding = _NoteAdditinalListDataContract.noteobj.UseRuletoDetermineNoteFunding;
                noteobj.UseRuletoDetermineNoteFundingText = _NoteAdditinalListDataContract.noteobj.UseRuletoDetermineNoteFundingText;
                noteobj.NoteFundingRule = _NoteAdditinalListDataContract.noteobj.NoteFundingRule;
                noteobj.NoteFundingRuleText = _NoteAdditinalListDataContract.noteobj.NoteFundingRuleText;
                noteobj.NoteBalanceCap = _NoteAdditinalListDataContract.noteobj.NoteBalanceCap;
                noteobj.FundingPriority = _NoteAdditinalListDataContract.noteobj.FundingPriority;
                noteobj.RepaymentPriority = _NoteAdditinalListDataContract.noteobj.RepaymentPriority;
                // list items
                noteobj.NotePIKScheduleList = _NoteAdditinalListDataContract.NotePIKScheduleList;
                noteobj.RateSpreadScheduleList = _NoteAdditinalListDataContract.RateSpreadScheduleList;
                noteobj.MaturityScenariosList = _NoteAdditinalListDataContract.MaturityScenariosList;
                noteobj.lstMaturity = _NoteAdditinalListDataContract.lstMaturity;
                noteobj.NoteStrippingList = _NoteAdditinalListDataContract.NoteStrippingList;
                noteobj.NoteDefaultScheduleList = _NoteAdditinalListDataContract.NoteDefaultScheduleList;
                noteobj.NotePrepayAndAdditionalFeeScheduleList = _NoteAdditinalListDataContract.NotePrepayAndAdditionalFeeScheduleList;
                noteobj.ListFutureFundingScheduleTab = _NoteAdditinalListDataContract.ListFutureFundingScheduleTab;
                noteobj.ListPIKfromPIKSourceNoteTab = _NoteAdditinalListDataContract.ListPIKfromPIKSourceNoteTab;
                noteobj.ListFeeCouponStripReceivable = _NoteAdditinalListDataContract.ListFeeCouponStripReceivable;
                noteobj.ListLiborScheduleTab = _NoteAdditinalListDataContract.ListLiborScheduleTab;
                noteobj.ListFixedAmortScheduleTab = _NoteAdditinalListDataContract.ListFixedAmortScheduleTab;
                noteobj.NoteServicingFeeScheduleList = _NoteAdditinalListDataContract.NoteServicingFeeScheduleList;
                noteobj.NoteFinancingScheduleList = _NoteAdditinalListDataContract.NoteFinancingScheduleList;
                noteobj.ListFinancingFeeSchedule = _NoteAdditinalListDataContract.lstFinancingFeeSchedule;
                noteobj.pageIndex = _NoteAdditinalListDataContract.noteobj.pageIndex;
                noteobj.pageSize = _NoteAdditinalListDataContract.noteobj.pageSize;
                noteobj.modulename = _NoteAdditinalListDataContract.noteobj.modulename;
                noteobj.SaveWithoutCalc = _NoteAdditinalListDataContract.noteobj.SaveWithoutCalc;
                noteobj.NoofdaysrelPaymentDaterollnextpaymentcycle = _NoteAdditinalListDataContract.noteobj.NoofdaysrelPaymentDaterollnextpaymentcycle;
                noteobj.lastCalcDateTime = _NoteAdditinalListDataContract.noteobj.lastCalcDateTime;

                return noteobj;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        [HttpGet]
        [Route("api/note/ValidateAllNote")]
        public IActionResult ValidateAllNote()
        {
            GenericResult _authenticationResult = null;

            int? totalCount;
            List<NoteDataContract> lstNotes = new List<NoteDataContract>();
            lstNotes = _noteLogic.GetAllNotesFromDealIds("", new Guid("00000000-0000-0000-0000-000000000000"), 1000, 1, out totalCount);

            foreach (NoteDataContract note in lstNotes)
            {
                try
                {
                    NoteDataContract noteobject = _noteLogic.GetNoteAllDataForCalculatorByNoteId(note.NoteId, null, note.AnalysisID, null, null);

                    ExceptionsLogic _ExceptionsLogic = new ExceptionsLogic();
                    ValidationEngine validate = new ValidationEngine();
                    List<ExceptionDataContract> edc = validate.ValidateNoteObject(noteobject);

                    if (edc.Count > 0)
                    {
                        //update validate exception in database
                        foreach (ExceptionDataContract exc in edc)
                        {
                            exc.CreatedBy = "kbaderia";
                            exc.CreatedBy = "kbaderia";
                        }

                        _ExceptionsLogic.InsertExceptions(edc, "kbaderia");
                    }
                    else
                    {
                        //remove old exceptions
                        _ExceptionsLogic.DeleteExceptionByobject(noteobject.NoteId, "note");
                    }
                }
                catch (Exception ex)
                {
                    string msg = ex.Message.ToString() + note.CRENoteID;
                }
            }

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "All note validated"
                };
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
        [Route("api/note/getnotecalculatorjsonbynoteid")]
        public IActionResult GetNoteCalculatorJsonByNoteId([FromBody] string _noteDC)
        {
            IActionResult _result = null;
            GenericResult _authenticationResult = null;
            FNoteDataContract _noteCalculatorDC = new FNoteDataContract();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            try
            {

                NoteLogic nl = new NoteLogic();
                _noteCalculatorDC = nl.GetNoteDataForCalculationByNoteId(_noteDC, null, null, null);
                var _gresult = JsonConvert.SerializeObject(_noteCalculatorDC);
                var result1 = _gresult;
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = _gresult
                };
                return Ok(_authenticationResult);
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_result);
        }

        [Services.Controllers.DeflateCompression]
        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Route("api/note/getnotecalculatordatabyjson")]
        public IActionResult GetNoteCalculatorDataByJson([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            IActionResult _result = null;
            GenericResult _authenticationResult = null;
            //NoteDataContract _noteCalculatorDC = new NoteDataContract();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            try
            {
#pragma warning disable CS0219 // The variable 'flag' is assigned but its value is never used
                bool flag = false;
#pragma warning restore CS0219 // The variable 'flag' is assigned but its value is never used
#pragma warning disable CS0219 // The variable 'totalCount' is assigned but its value is never used
                int? totalCount = 0;
#pragma warning restore CS0219 // The variable 'totalCount' is assigned but its value is never used

                var _calcJSONRequest = _noteDC.CalcJSONRequest;

                var _noteCalculatorDC = JsonConvert.DeserializeObject<NoteDataContract>(_calcJSONRequest);

                CalculationMaster cm = new CalculationMaster();
                NoteDataContract objNote = cm.StartCalculation(_noteCalculatorDC);
                //Track Note object
                var result1 = JsonConvert.SerializeObject(objNote);
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = result1
                };

                return Ok(_authenticationResult);

            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_result);
        }

        private static string NullToString(object Value)
        {
            // Value.ToString() allows for Value being DBNull, but will also convert int, double, etc.
            return Value == null ? "" : Value.ToString();

            // If this is not what you want then this form may suit you better, handles 'Null' and DBNull otherwise tries a straight cast
            // which will throw if Value isn't actually a string object.
            //return Value == null || Value == DBNull.Value ? "" : (string)Value;
        }

        public void saveOutputCalculatorValues(GenericResult _gresult, string Noteid, string UserId, Guid? AnalysisID)
        {
            try
            {


                if (_gresult.lstNotePeriodicOutputsDataContract != null)
                {
                    foreach (var item in _gresult.lstNotePeriodicOutputsDataContract)
                    {
                        item.CreatedBy = UserId;
                        item.UpdatedBy = UserId;
                        item.NoteID = new Guid(Noteid);
                    }
                    _noteLogic.InsertNotePeriodicCalc(_gresult.lstNotePeriodicOutputsDataContract);
                    _noteLogic.InsertNotePeriodicCalcFromCalculationDaily(_gresult.ListNotePeriodicOutput_Daily, UserId, new Guid(Noteid));
                    _noteLogic.InsertNotePeriodicCalcFromCalculationPVandGaap(_gresult.ListNotePeriodicOutput_PVAndGaap, UserId, new Guid(Noteid));
                    _noteLogic.InsertNotePeriodicCalcFromCalculationSpreadLibor(_gresult.ListNotePeriodicOutput_SpreadAndLibor, UserId, new Guid(Noteid));


                    _noteLogic.InsertInterestCalculator(_gresult.ListInterestCalculator, Noteid, UserId);
                    if (_gresult.ListDailyInterestAccruals != null)
                    {
                        _noteLogic.InsertDailyInterestAccural(_gresult.ListDailyInterestAccruals, Noteid, UserId);
                    }


                    PayruleSetupLogic _PayruleSetupLogic = new PayruleSetupLogic();
                    _PayruleSetupLogic.InsertUpdatePayruleDistributions(Noteid, UserId, AnalysisID);
                }

                if (_gresult.ListPIKDistribution != null)
                {
                    _noteLogic.InsertPIKDistributions(_gresult.ListPIKDistribution, UserId);
                }

            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error in Saving outputs " + Noteid, Noteid, UserId, ex.TargetSite.Name.ToString(), "", ex);
            }

        }

        public Stream GenerateStreamFromString(string s)
        {
            System.IO.MemoryStream stream = new MemoryStream();
            StreamWriter writer = new StreamWriter(stream);
            writer.Write(s);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }

        [HttpGet]
        //[Services.Controllers.IsAuthenticate]
        [Route("api/note/getimportsourcetodw-new")]
        public IActionResult Getimportsourcetodw()
        {
            GenericResult _authenticationResult = null;

            _noteLogic.importsourcetodw();
            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Import succeeded"
            };

            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Route("api/note/getconsolidatedemailnightly")]
        public IActionResult getconsolidatedemailnightly()
        {

            GenericResult _authenticationResult = null;
            GetDealNoteFundingDiscrepancyNew();
            GetNonFullpayoffDealDiscrepancy();
            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Consolidated email succeeded"
            };
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Route("api/note/getexecuteprocedurenightly-new")]
        public IActionResult GetExecuteProcedureNightly()
        {

            GenericResult _authenticationResult = null;
            //  GetDealNoteFundingDiscrepancyNew();
            //  GetNonFullpayoffDealDiscrepancy();
            var isButtonClick = 0;
            _noteLogic.GetExecuteProcedureNightly(Convert.ToInt32(isButtonClick));
            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Import succeeded"
            };
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Route("api/note/getexecuteadditionalprocedurenightly")]
        public IActionResult GetExecuteAdditionalProcedureNightly()
        {
            GenericResult _authenticationResult = null;
            try
            {
                //create and upload tag file to azure
                bool isSuccess = false;
                DataTable tagdatatable = new DataTable();

                List<TagMasterDataContract> listTagFiles = _tagMasterLogic.GetTagFileNameForAzureUpload();
                List<TagFileDataContract> lstTagFile = new List<TagFileDataContract>();

                foreach (TagMasterDataContract tagfile in listTagFiles)
                {
                    tagdatatable = _tagMasterLogic.GetNoteCashflowsExportDataFromTransactionClose(tagfile.AnalysisID.ToString(), tagfile.TagMasterID.ToString());
                    isSuccess = UploadDataTableToAzureblob(tagdatatable, tagfile.TagFileName);
                    if (isSuccess)
                    {
                        lstTagFile.Add(new TagFileDataContract { TagMasterID = new Guid(tagfile.TagMasterID.ToString()), TagFileName = tagfile.TagFileName });
                        _tagMasterLogic.UpdateTagFileName(lstTagFile);
                        lstTagFile.Clear();
                        Thread SecondThread = new Thread(() => ImportIntoTransactionEntryCloseArchive(tagfile.TagMasterID, tagfile.AnalysisID));
                        SecondThread.Start();

                    }

                }
                //if (lstTagFile.Count > 0)
                //{
                //    _tagMasterLogic.UpdateTagFileName(lstTagFile);

                //}
            }
            catch { }
            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Import succeeded"
            };

            return Ok(_authenticationResult);
        }

        public void ImportIntoTransactionEntryCloseArchive(Guid? TagMasterID, Guid? AnalysisID)
        {
            _tagMasterLogic.ImportIntoTransactionEntryCloseArchive(TagMasterID, AnalysisID);

        }


        public bool UploadDataTableToAzureblob(System.Data.DataTable dt, string csvname)
        {
            GetConfigSetting();

            System.Text.UnicodeEncoding uniEncoding = new System.Text.UnicodeEncoding();

            MemoryStream ms1 = new MemoryStream();

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    StreamWriter sw = new StreamWriter(ms);
                    int columnCount = dt.Columns.Count;

                    for (int i = 0; i < columnCount; i++)
                    {
                        sw.Write(dt.Columns[i]);

                        if (i < columnCount - 1)
                        {
                            sw.Write(",");
                        }
                    }

                    sw.Write(sw.NewLine);

                    foreach (DataRow dr in dt.Rows)
                    {
                        for (int i = 0; i < columnCount; i++)
                        {
                            if (!Convert.IsDBNull(dr[i]))
                            {
                                sw.Write(dr[i].ToString());
                            }

                            if (i < columnCount - 1)
                            {
                                sw.Write(",");
                            }
                        }

                        sw.Write(sw.NewLine);
                    }
                    ms1 = ms;

                    //var Container = System.Configuration.ConfigurationManager.AppSettings["storage:container:name"];
                    var Container = Sectionroot.GetSection("storage:container:name").Value;

                    // Get Blob Container
                    Microsoft.WindowsAzure.Storage.Blob.CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);
                    // Get reference to blob (binary content)
                    Microsoft.WindowsAzure.Storage.Blob.CloudBlockBlob blockBlob = container.GetBlockBlobReference(csvname);
                    blockBlob.Properties.ContentType = "application/octet-stream";
                    ms1.Seek(0, SeekOrigin.Begin);
                    blockBlob.UploadFromStream(ms1);
                }


                return true;

            }
            catch (Exception ex)
            {
                return true;
            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

        }



        [HttpGet]
        //[Services.Controllers.IsAuthenticate]
        [Route("api/note/getexecuteprocedureonesinaday-new")]
        public IActionResult GetExecuteProcedureOnesInADay()
        {
            GenericResult _authenticationResult = null;

            _noteLogic.ExecuteProcedureOnesInADay();
            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Execute Procedure Ones In A Day succeeded."
            };

            return Ok(_authenticationResult);
        }



        [HttpPost]
        [Services.Controllers.DeflateCompression]
        [Services.Controllers.IsAuthenticate]
        [Route("api/note/getNoteCashflowsExportData")]
        public IActionResult GetNoteCashflowsExportData([FromBody] DownloadCashFlowDataContract downloadCashFlow)
        {
            GenericResult _authenticationResult = null;
            //List<NoteCashflowsExportDataContract> lstNoteCashflowsExportData = new List<NoteCashflowsExportDataContract>();
            DataTable lstNoteCashflowsExportData = new DataTable();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            DealLogic deallogic = new DealLogic();
            DataTable exceptiondt = new DataTable();
            //lstNoteCashflowsExportData = _noteLogic.GetNoteCashflowsExportData(new Guid(downloadCashFlow.NoteId), new Guid(downloadCashFlow.DealID), new Guid(downloadCashFlow.AnalysisID), downloadCashFlow.MutipleNoteId);
            lstNoteCashflowsExportData = _noteLogic.GetNoteCashflowsExportData(downloadCashFlow);
            if (downloadCashFlow.Pagename == "Deal")
            {
                exceptiondt = deallogic.GetAllExceptionsByDealID(new Guid(downloadCashFlow.DealID), downloadCashFlow.Pagename, "", new Guid(), new Guid());
            }
            else if (downloadCashFlow.Pagename == "Calc")
            {
                exceptiondt = deallogic.GetAllExceptionsByDealID(new Guid(), downloadCashFlow.Pagename, downloadCashFlow.MutipleNoteId, new Guid(), new Guid());
            }
            else if (downloadCashFlow.Pagename == "Note")
            {
                exceptiondt = deallogic.GetAllExceptionsByDealID(new Guid(), downloadCashFlow.Pagename, downloadCashFlow.MutipleNoteId, new Guid(), new Guid(downloadCashFlow.NoteId));
            }
            try
            {
                if (lstNoteCashflowsExportData != null)
                {
                    if (lstNoteCashflowsExportData.Rows.Count > 0)
                    {
                        // Logger.Write("Note Cashflows Export Data " + _noteDC.NoteId + " loaded successfully", MessageLevel.Info);
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstNoteCashflowsExportData = lstNoteCashflowsExportData,
                            dt = exceptiondt
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success with no records",
                            lstNoteCashflowsExportData = lstNoteCashflowsExportData
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
                    };
                }
            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.CashFlowDownload.ToString(), "Error occurred in cashflow download ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpPost]
        //[Services.Controllers.DeflateCompression]
        //[Services.Controllers.IsAuthenticate]
        [Route("api/note/getNoteCashflowsExportExcel")]
        public IActionResult GetNoteCashflowsExportExcel([FromBody] DownloadCashFlowDataContract downloadCashFlow)
        {
            DataTable lstNoteCashflowsExportData = new DataTable();
            DataTable lstGaapBasisExportData = new DataTable();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            DealLogic deallogic = new DealLogic();
            DataTable exceptiondt = new DataTable();
            if (downloadCashFlow.Pagename != "Scenario")
            {
                //lstNoteCashflowsExportData = _noteLogic.GetNoteCashflowsExportData(new Guid(downloadCashFlow.NoteId), new Guid(downloadCashFlow.DealID), new Guid(downloadCashFlow.AnalysisID), downloadCashFlow.MutipleNoteId);
                lstNoteCashflowsExportData = _noteLogic.GetNoteCashflowsExportData(downloadCashFlow);

                if (downloadCashFlow.Pagename == "Deal")
                {
                    lstGaapBasisExportData = _noteLogic.GetNoteCashflowsGAAPBasisExportData(downloadCashFlow);
                    exceptiondt = deallogic.GetAllExceptionsByDealID(new Guid(downloadCashFlow.DealID), downloadCashFlow.Pagename, "", new Guid(), new Guid());
                }
                else if (downloadCashFlow.Pagename == "Calc")
                {
                    exceptiondt = deallogic.GetAllExceptionsByDealID(new Guid(), downloadCashFlow.Pagename, downloadCashFlow.MutipleNoteId, new Guid(), new Guid());
                }
                else if (downloadCashFlow.Pagename == "Note")
                {
                    lstGaapBasisExportData = _noteLogic.GetNoteCashflowsGAAPBasisExportData(downloadCashFlow);
                    exceptiondt = deallogic.GetAllExceptionsByDealID(new Guid(), downloadCashFlow.Pagename, downloadCashFlow.MutipleNoteId, new Guid(), new Guid(downloadCashFlow.NoteId));
                }
            }
            else
            {
                lstNoteCashflowsExportData = _noteLogic.GetNoteCashflowsExportData(new Guid("00000000-0000-0000-0000-000000000000"), new Guid("00000000-0000-0000-0000-000000000000"), new Guid(downloadCashFlow.AnalysisID), "");
                exceptiondt = deallogic.GetAllExceptionsByDealID(new Guid(), "Scenario", "", new Guid(), new Guid());
                //lstGaapBasisExportData = _noteLogic.GetNoteCashflowsGAAPBasisExportData(new Guid("00000000-0000-0000-0000-000000000000"), new Guid("00000000-0000-0000-0000-000000000000"), new Guid(downloadCashFlow.AnalysisID), "");

            }
            // Export to excel
            DataSet ds = new DataSet();
            lstNoteCashflowsExportData.TableName = "Cashflow";
            ds.Tables.Add(lstNoteCashflowsExportData);

            if (lstGaapBasisExportData.Rows.Count > 0)
            {
                lstGaapBasisExportData.TableName = "GaapBasis";
                ds.Tables.Add(lstGaapBasisExportData);
            }
            exceptiondt.TableName = "Exceptions";
            ds.Tables.Add(exceptiondt);

            Stream stream = new StreamReader(_env.WebRootPath + "/ExcelTemplate/" + "Cashflow_download.xlsx").BaseStream;
            MemoryStream ms = WriteDataToExcel(ds, stream);
            return File(ms, "application/octet-stream");

        }

        [Services.Controllers.DeflateCompression]
        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Route("api/note/DownloadNoteDataTape")]
        public IActionResult DownloadNoteDataTape([FromBody] string withoutSpread)
        {
            GenericResult _authenticationResult = null;
            DataTable lstDownloadNoteDataTape = new DataTable();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            lstDownloadNoteDataTape = _noteLogic.DownloadNoteDataTape(Convert.ToInt32(withoutSpread));

            try
            {
                if (lstDownloadNoteDataTape != null)
                {
                    if (lstDownloadNoteDataTape.Rows.Count > 0)
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstDownloadNoteDataTape = lstDownloadNoteDataTape
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed"
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
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
        [Route("api/note/searchnote")]
        public IActionResult SearchNoteByCRENoteId([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _authenticationResult = null;
            List<NoteDataContract> lstNotes = new List<NoteDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            try
            {
                lstNotes = _noteLogic.SearchNoteByCRENoteId(_noteDC);
                if (lstNotes != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstNotes = lstNotes
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
        [Route("api/note/getactivitylogbymoduleid")]
        public IActionResult GetActivityLogModuleId([FromBody] ActivityLogDataContract logDC, int? pageIndex, int? pageSize)
        //public IActionResult GetActivityLogModuleId([FromBody] ActivityLogDataContract logDC)
        {
            GenericResult _authenticationResult = null;
            List<ActivityLogDataContract> lstactivitydc = new List<ActivityLogDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            //  string currentTime = "2017-08-09";
            var headerUserID = string.Empty;
            int? totalCount = 0;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            lstactivitydc = _noteLogic.GetActivityLogByModuleId(headerUserID.ToString(), logDC, pageIndex, pageSize, out totalCount);

            try
            {
                if (lstactivitydc != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstActivityLog = lstactivitydc,
                        TotalCount = Convert.ToInt32(totalCount)
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
        [Route("api/note/checkconcurrentupdate")]
        public IActionResult CheckConcurrentUpdate([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _authenticationResult = null;
            DealDataContract Deal = new DealDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();

            DateTime dt = DateTime.ParseExact(_noteDC.FFLastUpdatedDate_String, "MM/dd/yyyy hh:mm:ss tt", CultureInfo.InvariantCulture);

            Deal = dealLogic.CheckConcurrentUpdate(new Guid(_noteDC.NoteId), "Note", dt);

            try
            {
                if (Deal.LastUpdatedFF == null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = ""
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = Deal.LastUpdatedByFF + " has modified the schedule on " + Convert.ToDateTime(Deal.LastUpdatedFF).ToString("M/dd/yyyy h:mm:ss tt") + " please refresh and then save your changes."

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
        [Route("api/note/GetLastUpdatedDateAndUpdatedByForSchedule")]
        public IActionResult GetLastUpdatedDateAndUpdatedByForSchedule([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _authenticationResult = null;
            NoteAllScheduleLatestRecordDataContract noteallsche = new NoteAllScheduleLatestRecordDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            NoteLogic noteLogic = new NoteLogic();

            noteallsche = noteLogic.GetLastUpdatedDateAndUpdatedByForSchedule(new Guid(_noteDC.NoteId), "Note");

            try
            {
                if (noteallsche != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        NoteAllScheduleLatestRecord = noteallsche
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        NoteAllScheduleLatestRecord = noteallsche
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
        [Route("api/note/addupdatenoterulebynoteId")]
        public IActionResult AddUpdateNoteRuleByNoteId([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _actionResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            string Validationmessage = string.Empty;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            try
            {
                NoteLogic _noteLogic = new NoteLogic();
                _noteLogic.AddUpdateNoteRuleByNoteId(_noteDC, new Guid(headerUserID));
                _actionResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = ""
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

            return Ok(_actionResult);
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getAllClient")]
        public IActionResult GetAllClient()
        {
            GenericResult _authenticationResult = null;
            List<ClientDataContract> lstClient = new List<ClientDataContract>();

            lstClient = _noteLogic.GetAllClient();

            try
            {
                if (lstClient != null)
                {
                    if (lstClient.Count > 0)
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstClient = lstClient
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed"
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
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

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getAllFund")]
        public IActionResult GetAllFund()
        {
            GenericResult _authenticationResult = null;
            List<FundDataContract> lstFund = new List<FundDataContract>();

            lstFund = _noteLogic.GetAllFund();

            try
            {
                if (lstFund != null)
                {
                    if (lstFund.Count > 0)
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstFund = lstFund
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed"
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
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

        public DataSet ImportWellsDataByDealID(string DealID)
        {
            DataSet lstWellsImportData = new DataSet();
            DataSet dsWellsImportData = new DataSet();
            DataTable dt, dtCopy;

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
            try
            {
                dsWellsImportData = _noteLogic.GetWellsViewsAllDataByDealID(DealID);

                dtCopy = new DataTable();
                dt = new DataTable("Master");
                dt.TableName = "Master";

                dtCopy = dsWellsImportData.Tables[0];
                dt = dtCopy.Copy();
                lstWellsImportData.Tables.Add(dt);
                lstWellsImportData.Tables[lstWellsImportData.Tables.Count - 1].TableName = "Master";

                dt = new DataTable("Investor");
                dt.TableName = "Investor";
                dtCopy = dsWellsImportData.Tables[1];
                dt = dtCopy.Copy();
                lstWellsImportData.Tables.Add(dt);
                lstWellsImportData.Tables[lstWellsImportData.Tables.Count - 1].TableName = "Investor";

                dt = new DataTable("Property");
                dt.TableName = "Property";
                dtCopy = dsWellsImportData.Tables[2];
                dt = dtCopy.Copy();
                lstWellsImportData.Tables.Add(dt);
                lstWellsImportData.Tables[lstWellsImportData.Tables.Count - 1].TableName = "Property";

                dt = new DataTable("Tax");
                dt.TableName = "Tax";
                dtCopy = dsWellsImportData.Tables[3];
                dt = dtCopy.Copy();
                lstWellsImportData.Tables.Add(dt);
                lstWellsImportData.Tables[lstWellsImportData.Tables.Count - 1].TableName = "Tax";

                dt = new DataTable("Insurance");
                dt.TableName = "Insurance";
                dtCopy = dsWellsImportData.Tables[4];
                dt = dtCopy.Copy();
                lstWellsImportData.Tables.Add(dt);
                lstWellsImportData.Tables[lstWellsImportData.Tables.Count - 1].TableName = "Insurance";

                dt = new DataTable("Reserve");
                dt.TableName = "Reserve";
                dtCopy = dsWellsImportData.Tables[5];
                dt = dtCopy.Copy();
                lstWellsImportData.Tables.Add(dt);
                lstWellsImportData.Tables[lstWellsImportData.Tables.Count - 1].TableName = "Reserve";

                dt = new DataTable("ARM");
                dt.TableName = "ARM";
                dtCopy = dsWellsImportData.Tables[6];
                dt = dtCopy.Copy();
                lstWellsImportData.Tables.Add(dt);
                lstWellsImportData.Tables[lstWellsImportData.Tables.Count - 1].TableName = "ARM";

            }
            catch (Exception ex)
            {

            }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            return lstWellsImportData;

        }


        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getAllLiborSchedule")]
        public IActionResult GetLiborScheduleForFast()
        {
            GenericResult _authenticationResult = null;
            List<FLiborScheduleTab> _liborScheduleTabList = new List<FLiborScheduleTab>();

            _liborScheduleTabList = _noteLogic.GetLiborScheduleForFast();

            try
            {
                if (_liborScheduleTabList != null)
                {
                    if (_liborScheduleTabList.Count > 0)
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstFastLiborScheduledata = _liborScheduleTabList
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed"
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
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


        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/GetAllNotes")]
        public IActionResult GetAllNotes()
        {
            GenericResult _authenticationResult = null;
            List<NoteDataContract> lstNotes = new List<NoteDataContract>();

            lstNotes = _noteLogic.GetAllNotes();

            try
            {
                if (lstNotes != null)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstNotes = lstNotes
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



        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/GetAllFeeTypesFromFeeSchedulesConfig")]
        public IActionResult GetAllFeeTypesFromFeeSchedulesConfig()
        {
            GenericResult _authenticationResult = null;
            List<FeeSchedulesConfigDataContract> lstFeeSchedulesConfigDataContract = new List<FeeSchedulesConfigDataContract>();

            lstFeeSchedulesConfigDataContract = _noteLogic.GetAllFeeTypesFromFeeSchedulesConfig();

            try
            {
                if (lstFeeSchedulesConfigDataContract != null)
                {
                    if (lstFeeSchedulesConfigDataContract.Count > 0)
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstFeeTypeLookUp = lstFeeSchedulesConfigDataContract
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed",
                            lstFeeTypeLookUp = null
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed",
                        lstFeeTypeLookUp = null
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetAllFeeTypesFromFeeSchedulesConfig", "", "00000000-0000-0000-0000-000000000000", ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/getTransactionEntryByNoteId")]
        public IActionResult GetTransactionEntryByNoteId([FromBody] NoteDataContract _noteDC)
        {
            GenericResult _authenticationResult = null;
            List<TransactionEntryDataContract> lsttransactionEntry = new List<TransactionEntryDataContract>();

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            lsttransactionEntry = _noteLogic.GetTransactionEntryByNoteId(new Guid(_noteDC.NoteId), _noteDC.AnalysisID);

            try
            {
                if (lsttransactionEntry != null)
                {
                    if (lsttransactionEntry.Count > 0)
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = true,
                            Message = "success",
                            lstTransactionEntry = lsttransactionEntry
                        };
                    }
                    else
                    {
                        _authenticationResult = new GenericResult()
                        {
                            Succeeded = false,
                            Message = "failed"
                        };
                    }
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetTransactionEntryByNoteId: Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }



        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/GetLookupForMaster")]
        public IActionResult GetLookupForMaster()
        {

            GenericResult _authenticationResult = null;
            List<LookupMasterDataContract> lstlookupMasterDC = new List<LookupMasterDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            NoteLogic noteLogic = new NoteLogic();
            lstlookupMasterDC = noteLogic.GetLookupForMaster();


            try
            {
                if (lstlookupMasterDC != null)
                {
                    // Logger.Write("Note lookup loaded successfully", MessageLevel.Info);
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstlookupMaster = lstlookupMasterDC
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
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetLookupForMaster ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

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
        [Route("api/note/getnotecalcinfobynoteId")]
        public IActionResult GetNoteCalcInfoByNoteId([FromBody] DevDashBoardDataContract devDashBoard)
        {
            GenericResult _authenticationResult = null;
            DevDashBoardDataContract devd = new DevDashBoardDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            NoteLogic noteLogic = new NoteLogic();
            devd = noteLogic.GetNoteCalcInfoByNoteId(new Guid(devDashBoard.NoteID), new Guid(devDashBoard.ScenarioID), new Guid(headerUserID));

            try
            {
                if (devd != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dwstatus = devd
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
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetLookupForMaster ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/GetFinancingSource")]
        public IActionResult GetFinancingSource()
        {

            GenericResult _authenticationResult = null;
            List<FinancingSourceDataContract> lstfinancingsourceDC = new List<FinancingSourceDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            NoteLogic noteLogic = new NoteLogic();
            lstfinancingsourceDC = noteLogic.GetFinancingSource(new Guid(headerUserID));


            try
            {
                if (lstfinancingsourceDC != null)
                {
                    // Logger.Write("Note lookup loaded successfully", MessageLevel.Info);
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        lstfinancingsource = lstfinancingsourceDC
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
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error occurred in GetFinancingSource ", "", headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        IConfigurationSection Sectionroot = null;
        public void GetConfigSetting()
        {
            if (Sectionroot == null)
            {
                IConfigurationBuilder builder = new ConfigurationBuilder();
                builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                var root = builder.Build();
                Sectionroot = root.GetSection("Application");
            }
        }



        public void GetDealNoteFundingDiscrepancyNew()
        {
            DataTable dt = new DataTable();
            DataTable dt1 = new DataTable();
            DataTable dt2 = new DataTable();
            DataTable dt3 = new DataTable();
            DataTable dt4 = new DataTable();
            DataTable dt5 = new DataTable();
            DataTable dt6 = new DataTable();
            DealLogic _dealLogic = new DealLogic();
            dt = _dealLogic.GetDealNoteFundingDiscrepancy();
            dt1 = _dealLogic.GetDiscrepancyForExitAndExtentionStripReceiveable();
            dt2 = _dealLogic.GetDiscrepancyForFFBetweenM61andBackshop();
            dt3 = _dealLogic.GetDiscrepancyForCommitment();
            dt4 = _dealLogic.GetDiscrepancyForCommitmentData();
            dt5 = _dealLogic.GetDiscrepancyListOfDealForEnableAutoSpread();
            dt6 = _dealLogic.GetDiscrepancyForExportPaydown();
            try
            {
                _iEmailNotification.SendDealFundingandNoteFundingDiscrepancy(dt, dt.Rows.Count, dt1, dt1.Rows.Count, dt2, dt2.Rows.Count, dt3, dt3.Rows.Count, dt4, dt4.Rows.Count, dt5, dt5.Rows.Count, dt6, dt6.Rows.Count);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        [HttpGet]
        [Route("api/note/getRefreshBSUnderwriting")]
        public IActionResult GetRefreshBSUnderwriting()
        {
            GenericResult _authenticationResult = null;
            string Message = "";
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            var batchstatus = "Refresh From Backshop";
            var isButtonClick = 1;
            DataTable dt = _noteLogic.refreshBSUnderwritingStatus(batchstatus, new Guid(headerUserID));
            if (dt.Rows[0]["Status2"].ToString() != "Process Running")
            {
                Message = "Request to refresh backshop submitted successfully.";
                Thread FirstThread = new Thread(() => _noteLogic.GetExecuteProcedureNightly(isButtonClick));
                FirstThread.Start();
            }
            else { Message = "Refresh backshop process is already running."; }

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
        [Route("api/note/queuenoteforcalculation")]
        public IActionResult QueueNotesForCalculation([FromBody] NoteDataContract _noteDC, int? pageIndex, int? pageSize)
        {
            GenericResult _authenticationResult = null;
            bool status = true;
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
                GetConfigSetting();
                List<CalculationManagerDataContract> nlist = new List<CalculationManagerDataContract>();
                CalculationManagerDataContract cdc = new CalculationManagerDataContract();
                string envname = Sectionroot.GetSection("ApplicationName").Value;
                cdc.StatusText = "Processing";
                cdc.UserName = headerUserID.ToString();
                cdc.ApplicationText = envname;
                cdc.AnalysisID = _noteDC.AnalysisID;
                cdc.NoteId = _noteDC.NoteId;
                cdc.PriorityText = "Real Time";
                cdc.CalcType = 775;
                nlist.Add(cdc);

                CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
                status = calculationlogic.QueueNotesForCalculation(nlist, headerUserID.ToString());

                if (status)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Calculation request submitted successfully"
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Error"
                    };
                }

            }
            catch (Exception ex)
            {

                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Note.ToString(), "Error while calculating single : Note ID " + _noteDC.CRENoteID, _noteDC.NoteId.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

        public void InsertSingleNoteForCalculation(string username, Guid? AnalysisID, string NoteId)
        {

            List<CalculationManagerDataContract> nlist = new List<CalculationManagerDataContract>();
            CalculationManagerDataContract cdc = new CalculationManagerDataContract();

            cdc.StatusText = "Processing";
            cdc.UserName = username.ToString();
            cdc.ApplicationText = "";
            cdc.AnalysisID = AnalysisID;
            cdc.NoteId = NoteId;
            cdc.PriorityText = "Real Time";
            cdc.CalcType = 775;
            nlist.Add(cdc);

            CalculationManagerLogic calculationlogic = new CalculationManagerLogic();
            calculationlogic.QueueNotesForCalculation(nlist, username);
        }

        ////to call for AI notename or crenoteid add/update
        //public async Task InsertUpdateAINoteEntitiesAsync(List<NoteDataContract> _noteDC, string userid)
        //{
        //    try
        //    {
        //        GetConfigSetting();
        //        string AIApiAuthKey = Sectionroot.GetSection("AIApiAuthKey").Value;
        //        string BaseUrl = Sectionroot.GetSection("apiPath").Value;
        //        string AIAddEntityApi = Sectionroot.GetSection("AIAddEntityApi").Value;
        //        //insert new deal
        //        foreach (var note in _noteDC)
        //        {
        //            if (note.NoteId == "00000000-0000-0000-0000-000000000000")
        //            {
        //                ArrayList noteidarr = new ArrayList();
        //                ArrayList notenamearr = new ArrayList();
        //                using (var client = new HttpClient())
        //                {
        //                    client.BaseAddress = new Uri(BaseUrl);
        //                    client.DefaultRequestHeaders.Accept.Clear();
        //                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //                    AIRealTimeEntityDataContract EntityResult = new AIRealTimeEntityDataContract();

        //                    // HTTP POST for crenoteid
        //                    HttpResponseMessage _noteidresponse = new HttpResponseMessage();
        //                    EntityResult.type = "NoteID";
        //                    EntityResult.value = note.CRENoteID;
        //                    noteidarr.Add(note.CRENoteID);

        //                    EntityResult.synonym = noteidarr;

        //                    _noteidresponse = await client.PostAsJsonAsync(AIAddEntityApi + AIApiAuthKey, EntityResult);
        //                    if (_noteidresponse.IsSuccessStatusCode)
        //                    {
        //                        Uri aientityUrl = _noteidresponse.Headers.Location;
        //                    }
        //                    // HTTP POST for notename
        //                    HttpResponseMessage _notenameresponse = new HttpResponseMessage();
        //                    EntityResult.type = "NoteName";
        //                    EntityResult.value = note.Name;
        //                    notenamearr.Add(note.Name);
        //                    EntityResult.synonym = notenamearr;

        //                    _notenameresponse = await client.PostAsJsonAsync(AIAddEntityApi + AIApiAuthKey, EntityResult);
        //                    if (_notenameresponse.IsSuccessStatusCode)
        //                    {
        //                        Uri aientityUrl = _notenameresponse.Headers.Location;
        //                    }
        //                }
        //            }// end for insert entity
        //            else
        //            {
        //                //update noteid and notename
        //                string AIUpdateEntityApi = Sectionroot.GetSection("AIUpdateEntityApi").Value;
        //                using (var client = new HttpClient())
        //                {
        //                    AIRealTimeEntityDataContract EntityResult = new AIRealTimeEntityDataContract();
        //                    if (note.OriginalCRENoteID != note.CRENoteID)
        //                    {

        //                        client.BaseAddress = new Uri(BaseUrl);
        //                        client.DefaultRequestHeaders.Accept.Clear();
        //                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //                        ArrayList noteidarr = new ArrayList();

        //                        // HTTP POST for crenoteid
        //                        HttpResponseMessage _noteidresponse = new HttpResponseMessage();
        //                        EntityResult.type = "NoteID";
        //                        EntityResult.original_entity =note.OriginalCRENoteID;
        //                        EntityResult.altered_entity =note.CRENoteID;
        //                        noteidarr.Add(note.OriginalCRENoteID);
        //                        noteidarr.Add(note.CRENoteID);
        //                        EntityResult.synonym = noteidarr;
        //                        _noteidresponse = await client.PostAsJsonAsync(AIUpdateEntityApi + AIApiAuthKey, EntityResult);
        //                        if (_noteidresponse.IsSuccessStatusCode)
        //                        {
        //                            Uri aientityUrl = _noteidresponse.Headers.Location;
        //                        }
        //                    }

        //                        // HTTP POST for notename
        //                        if (note.OriginalNoteName != note.Name)
        //                        {
        //                            ArrayList notenamearr = new ArrayList();
        //                            HttpResponseMessage _notenameresponse = new HttpResponseMessage();
        //                            EntityResult.type = "NoteName";
        //                            EntityResult.value= note.Name;
        //                            notenamearr.Add(note.Name);
        //                            EntityResult.synonym = notenamearr;
        //                            _notenameresponse = await client.PostAsJsonAsync(AIAddEntityApi + AIApiAuthKey, EntityResult);
        //                            if (_notenameresponse.IsSuccessStatusCode)
        //                            {
        //                                Uri aientityUrl = _notenameresponse.Headers.Location;
        //                            }
        //                        }
        //                }
        //            }// end for update entity
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        LoggerLogic Log = new LoggerLogic();
        //        Log.WriteLogException(CRESEnums.Module.AI_Assistant.ToString(), "Error occurred  while saving note(AI Entity insert/update): Deal ID " + _noteDC[0].CRENoteID, _noteDC[0].NoteId.ToString(), userid, ex.TargetSite.Name.ToString(), "", ex);
        //    }
        //}

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getholidaymaster")]
        public IActionResult GetHolidayMaster()
        {
            GenericResult _authenticationResult = null;
            DataTable dtholidaymaster = new DataTable();
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }
            UserPermissionLogic upl = new UserPermissionLogic();

            dtholidaymaster = upl.GetHolidayMaster(new Guid(headerUserID));
            try
            {
                if (dtholidaymaster.Rows.Count > 0)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "succeeded",
                        dtholidaymaster = dtholidaymaster

                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "failed"
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

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/note/getmaturitybynoteid")]
        public IActionResult GetMaturityByNoteID(string ID)
        {
            GenericResult _authenticationResult = null;

#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = string.Empty;

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            DealLogic dealLogic = new DealLogic();
            DataTable dtMaturity = dealLogic.GetMaturityByDealID(headerUserID, null, ID);

            try
            {
                if (dtMaturity != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        dt = dtMaturity
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
                Log.WriteLogException(CRESEnums.Module.Deal.ToString(), "Error occurred in GetMaturityByNoteID: Deal ID " + ID, ID.ToString(), headerUserID.ToString(), ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }



        public MemoryStream WriteDataToExcel(DataSet dsData, Stream strm)
        {

            DataTable dt = new DataTable();
            Stream TemplateMemoryStream = new MemoryStream();
            List<string> lstTemplateLines = new List<string>();
            try
            {


                using (var package = new OfficeOpenXml.ExcelPackage(strm))
                {

                    int iSheetsCount = 0;
                    try
                    {
                        iSheetsCount = package.Workbook.Worksheets.Count;
                    }
                    catch (Exception)
                    {
                        iSheetsCount = package.Workbook.Worksheets.Count;
                    }
                    if (iSheetsCount > 0)
                    {
                        for (int i = 0; i < iSheetsCount; i++)
                        {

                            OfficeOpenXml.ExcelWorksheet worksheet;
                            try
                            {
                                worksheet = package.Workbook.Worksheets[i];
                            }
                            catch (Exception)
                            {
                                worksheet = package.Workbook.Worksheets[i];
                            }


                            if (dsData.Tables[worksheet.Name] != null)
                            {
                                //for (var k = 1; k <= worksheet.Dimension.End.Column; k++)
                                //{
                                //    worksheet.Column(k).AutoFit();

                                //}
                                //if (i == 0)
                                //{
                                //    worksheet.Column(3).Style.Numberformat.Format = "mm-dd-yyyy";

                                //    worksheet.Column(8).Style.Numberformat.Format = "mm-dd-yyyy";
                                //    worksheet.Column(9).Style.Numberformat.Format = "mm-dd-yyyy";
                                //    worksheet.Column(10).Style.Numberformat.Format = "mm-dd-yyyy";
                                //}
                                //if (i == 1)
                                //{
                                //    worksheet.Column(6).Style.Numberformat.Format = "mm-dd-yyyy";
                                //}
                                worksheet.Cells[1, 1].LoadFromDataTable(dsData.Tables[worksheet.Name], true);
                            }

                        }

                        Byte[] fileBytes = package.GetAsByteArray();
                        TemplateMemoryStream = new MemoryStream(fileBytes);
                    }


                }

                return (MemoryStream)TemplateMemoryStream;


            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.CashFlowDownload.ToString(), "Error detail(method: ReadAndUploadTemplateFile) :  ", "", "", ex.TargetSite.Name.ToString(), "", ex);

                throw ex;
            }

        }



        [HttpGet]
        [Route("api/note/getrefreshentitydatatodw")]
        public IActionResult getrefreshentitydatatodw()
        {
            GenericResult _authenticationResult = null;
            string Message = "";
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            var batchstatus = "Refresh Entity Data";

            DataTable dt = _noteLogic.refreshBSUnderwritingStatus(batchstatus, new Guid(headerUserID));
            if (dt.Rows[0]["Status2"].ToString() != "Process Running")
            {
                Message = "Request to refresh entity data submitted successfully.";
                Thread FirstThread = new Thread(() => _noteLogic.refreshentitydatatodw());
                FirstThread.Start();
            }
            else { Message = "Refresh entity data process is already running."; }

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
        [Route("api/note/AddUpdateNoteRuleTypeSetup")]
        public IActionResult AddUpdateNoteRuleTypeSetup([FromBody] List<ScenarioruletypeDataContract> scenarioDC)
        {
            GenericResult _authenticationResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
#pragma warning disable CS0219 // The variable 'scenariomsg' is assigned but its value is never used
            string scenariomsg = "";
#pragma warning restore CS0219 // The variable 'scenariomsg' is assigned but its value is never used
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            NoteLogic noteLogic = new NoteLogic();
            string res = noteLogic.AddUpdateNoteRuleTypeSetup(scenarioDC, headerUserID);

            try
            {
                if (res != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
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
        [Route("api/note/GetRuleTypeSetupByNoteId")]
        public IActionResult GetRuleTypeSetupByNoteId([FromBody] ScenarioruletypeDataContract scenarioruletypeDataContract)
        {
            GenericResult _authenticationResult = null;
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }
            List<ScenarioruletypeDataContract> listscenario = new List<ScenarioruletypeDataContract>();
            NoteLogic notelogic = new NoteLogic();
            listscenario = notelogic.GetRuleTypeSetupByNoteId(scenarioruletypeDataContract.NoteID, scenarioruletypeDataContract.AnalysisID);

            try
            {
                if (listscenario.Count > 0)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        AnalysisId = listscenario.First().AnalysisID,
                        lstScenariorule = listscenario
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded"

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

        public void GetNonFullpayoffDealDiscrepancy()
        {
            DataTable dt = new DataTable();
            DealLogic _dealLogic = new DealLogic();
            dt = _dealLogic.GetDiscrepancyListOfDealForEnableAutoSpread();

            try
            {
                _iEmailNotification.SendNonFullPayoffDealDiscrepancy(dt);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}
