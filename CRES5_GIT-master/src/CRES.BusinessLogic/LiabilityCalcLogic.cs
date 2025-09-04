using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;
using System.Dynamic;
using System.Data;
using CRES.DataContract;
using CRES.DAL.Repository;
using System.Linq;
using CRES.Utilities;
using CRES.DataContract.Liability;
using System.IO;
using System.Collections;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using static CRES.DataContract.V1CalcDataContract;
using Microsoft.Extensions.Azure;
using Microsoft.VisualBasic;
using System.Text.RegularExpressions;
using Newtonsoft.Json.Linq;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Math;

namespace CRES.BusinessLogic
{
    public class LiabilityCalcLogic
    {
        private LiabilityCalcRepository _lbCalcRepository = new LiabilityCalcRepository();
        public dynamic GetLiabilityCalcRequestData(string userID, string fundIDorName, string analysisID)
        {
            dynamic objJsonResult = null;

            try
            {

                if (string.IsNullOrEmpty(fundIDorName))
                {
                    return objJsonResult;
                }
                DataSet dsCalJsonData = new DataSet();
                //get json structure to be format
                List<JsonFormatCalcLiability> JFormatCalcLiability = new List<JsonFormatCalcLiability>();
                JFormatCalcLiability = GetLiabilityJsonFormat();
                if (JFormatCalcLiability.Count > 0)
                {
                    //get the json data from db
                    dsCalJsonData = _lbCalcRepository.GetLiabilityCalcRequestData("", fundIDorName, analysisID);
                    

                    var distElement = JFormatCalcLiability.Select(x => x.Position).Distinct();
                    var root = JFormatCalcLiability.Where(x => x.ParentID == null).ToList();
                    dynamic rootJson = new ExpandoObject();
                    //var dictionary = (IDictionary<string, object>)rootJson;
                    Dictionary<String, Object> dictionary = new Dictionary<String, Object>();

                    if (root.Count() > 0 && dsCalJsonData.Tables.Count > 0)
                    {
                        //check whether the equity is exist in the table

                        DataTable dtrootFund = new DataTable();
                        dtrootFund = dsCalJsonData.Tables["root.Fund"];
                        if (dtrootFund == null || dtrootFund.Rows.Count == 0)
                        {
                            return objJsonResult;
                        }


                        DataTable dtroot = new DataTable();
                        dtroot = dsCalJsonData.Tables[root[0].Position];
                        //format root level variables
                        for (int i = 0; i < root.Count(); i++)
                        {

                            if (root[i].KeyFormat.ToLower() == "variable")
                            {
                                //dictionary.Add(root[i].Key, CommonHelper.convertValforjson(dtroot.Rows[0][root[i].Key], root[i].DataType.ToString()));
                                dictionary.Add(root[i].Key, CommonHelper.convertValToProperFormat(dtroot.Rows[0][root[i].Key], root[i].DataType.ToString()));

                            }
                            else if (root[i].KeyFormat.ToLower() == "json")
                            {

                                var lstchild = JFormatCalcLiability.Where(x => x.ParentID == root[i].JsonFormatCalcLiabilityID).ToList();

                                Dictionary<String, Object> dict = new Dictionary<String, Object>();
                                //dictionary.Add(root[i].Key, ObjToCsv.DictionaryToObject(dict));
                                if (lstchild.Count() > 0)
                                {
                                    DataTable dtChild = new DataTable();
                                    dtChild = dsCalJsonData.Tables[lstchild[0].Position];
                                    DataRow dr = dtChild.Rows[0];
                                    dictionary.Add(root[i].Key, GetChildDictionary(dict, lstchild, JFormatCalcLiability, dr, dsCalJsonData));
                                }
                                else
                                {
                                    dictionary.Add(root[i].Key, dict);
                                }
                                

                                dict = null;
                            }
                            else if (root[i].KeyFormat.ToLower() == "array")
                            {

                                var lstchild = JFormatCalcLiability.Where(x => x.ParentID == root[i].JsonFormatCalcLiabilityID).ToList();

                                var lstDict = new List<Dictionary<String, Object>>();
                                if (lstchild.Count() > 0)
                                {

                                    Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                    DataTable dtChild = new DataTable();

                                    dtChild = dsCalJsonData.Tables[lstchild[0].Position];
                                    for (int cntAr = 0; cntAr < dtChild.Rows.Count; cntAr++)
                                    {
                                        lstDict.Add(GetChildDictionary(innerDictionary, lstchild, JFormatCalcLiability, dtChild.Rows[cntAr], dsCalJsonData));
                                        innerDictionary = new Dictionary<string, object>();
                                    }
                                }
                                dictionary.Add(root[i].Key, lstDict);
                            }
                            else if (root[i].KeyFormat.ToLower() == "singlearray")
                            {

                                var lstchild = JFormatCalcLiability.Where(x => x.ParentID == root[i].JsonFormatCalcLiabilityID).ToList();

                                int[] arrsingle = null;

                                //dictionary.Add(root[i].Key, ObjToCsv.DictionaryToObject(dict));
                                if (lstchild.Count() > 0)
                                {
                                    DataTable dtChild = new DataTable();
                                    dtChild = dsCalJsonData.Tables[lstchild[0].Position];
                                    //DataRow dr = dtChild.Rows[0];
                                    arrsingle =dtChild.AsEnumerable().Select(r => r.Field<int>("col")).ToArray();
                                    dictionary.Add(root[i].Key, arrsingle);
                                }
                                else
                                {
                                    dictionary.Add(root[i].Key, arrsingle);
                                }
                            }
                        }
                        var serialized = JsonConvert.SerializeObject(dictionary);
                        objJsonResult = serialized;
                    }
                }
                return objJsonResult;
            }
            catch (Exception ex)
            {
                objJsonResult = "exception";
                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.EquityCalculator.ToString(), "Error in generating json for for Equity ID= " + fundIDorName + " " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetLiabilityCalcRequestData", "", ex);
                //rtrmessage = "Exception";
                throw ex;
            }           
        }

        public List<JsonFormatCalcLiability> GetLiabilityJsonFormat()
        {
            return _lbCalcRepository.GetLiabilityJsonFormat(); ;
        }
        public string readstring()
        {
            string json = File.ReadAllText(@"C:\temp\ACPII.json");
            return json;
        }

        //recursive method to format Calc Liability json
        public dynamic GetChildDictionary(IDictionary<String, Object> dictionary, List<JsonFormatCalcLiability> lstchild, List<JsonFormatCalcLiability> lstMain, DataRow drChild, DataSet dsCalJsonData)
        {

            //for (int cnt = 0; cnt < dtChild.Rows.Count; cnt++)
            //{
            for (int i = 0; i < lstchild.Count(); i++)
            {
                if (lstchild[i].KeyFormat.ToLower() == "variable")
                {
                    //dictionary.Add(lstchild[i].Key, CommonHelper.convertValToProperFormat("9", lstchild[i].DataType.ToString()));
                    dictionary.Add(lstchild[i].Key, CommonHelper.convertValToProperFormat(drChild[lstchild[i].Key], lstchild[i].DataType.ToString()));
                }
                else if (lstchild[i].KeyFormat.ToLower() == "json")
                {
                    Dictionary<String, Object> dict = new Dictionary<String, Object>();
                    var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();
                    DataTable dtChildinner = new DataTable();
                    dtChildinner = dsCalJsonData.Tables[lstchildinner[0].Position];
                    DataRow drinner = dtChildinner.Rows[0];
                    dictionary.Add(lstchild[i].Key, dictionary.Add(lstchild[i].Key, GetChildDictionary(dict, lstchildinner, lstMain, drinner, dsCalJsonData)));
                    dict = null;
                }
                else if (lstchild[i].KeyFormat.ToLower() == "array")
                {
                    var lstDict = new List<Dictionary<String, Object>>();
                    Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                    var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();
                    DataTable dtChildinner = new DataTable();

                    if (lstchildinner.Count() > 0)
                    {
                        if (!string.IsNullOrEmpty(lstchild[i].FilterBy))
                        {
                            string filterBy = Convert.ToString(drChild[lstchild[i].FilterBy]);

                            if (dsCalJsonData.Tables[lstchildinner[0].Position] != null && dsCalJsonData.Tables[lstchildinner[0].Position].Rows.Count > 0)
                            {
                                if (dsCalJsonData.Tables[lstchildinner[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'") != null
                                    && dsCalJsonData.Tables[lstchildinner[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").Count() > 0
                                    )
                                {

                                    dtChildinner = dsCalJsonData.Tables[lstchildinner[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").CopyToDataTable();
                                }
                            }
                        }
                        else
                        {
                            dtChildinner = dsCalJsonData.Tables[lstchildinner[0].Position];
                        }
                    }
                    //dtChildinner = dsCalJsonData.Tables[lstchildinner[0].Position];

                    //DataTable tblFiltered = dsCalJsonData.Tables[lstchildinner[0].Position].AsEnumerable()
                    //     .Where(r => r.Field<string>("AssetAccountID") == "45554FA8-C58C-4D9A-BEBE-99975F4F87E8")
                    //     .CopyToDataTable();

                    for (int cntAr = 0; cntAr < dtChildinner.Rows.Count; cntAr++)
                    {
                        lstDict.Add(GetChildDictionary(innerDictionary, lstchildinner, lstMain, dtChildinner.Rows[cntAr], dsCalJsonData));
                        innerDictionary = new Dictionary<string, object>();
                    }
                    dictionary.Add(lstchild[i].Key, lstDict);
                    //


                }

                else if (lstchild[i].KeyFormat.ToLower() == "singlearray")
                {

                    var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();
                    for (int cntAr = 0; cntAr < lstchildinner.Count; cntAr++)
                    {
                        DataTable dtChild = new DataTable();
                        dtChild = dsCalJsonData.Tables[lstchildinner[cntAr].Position];
                        //DataRow dr = dtChild.Rows[0];

                        if (lstchildinner[cntAr].DataType.ToLower() == "int")
                        {
                            var arrsingle = dtChild.AsEnumerable().Select(r => r.Field<int>("col")).ToArray();
                            dictionary.Add(lstchild[i].Key, arrsingle);
                        }
                        else if (lstchildinner[i].DataType.ToLower().StartsWith("nvarchar"))
                        {

                            var arrsingle = dtChild.AsEnumerable().Select(r => r.Field<string>("col")).ToArray();
                            dictionary.Add(lstchild[i].Key, arrsingle);

                        }
                        else if (lstchildinner[i].DataType.ToLower().StartsWith("decimal"))
                        {

                            var arrsingle = dtChild.AsEnumerable().Select(r => r.Field<decimal>("col")).ToArray();
                            dictionary.Add(lstchild[i].Key, arrsingle);

                        }
                    }
                }



                //}
            }
            return dictionary;
        }

        //recursive method to format Calc Liability end
        public List<EquityCalcDataContract> GetEquityForCalculation()
        {
            return _lbCalcRepository.GetEquityForCalculation();
        }
        public void UpdateLiabilityCalculationStatusandTime(Guid calcid, string statustext, string columnname, string errmsg, string updatedby)
        {
            _lbCalcRepository.UpdateLiabilityCalculationStatusandTime(calcid, statustext, columnname, errmsg, updatedby);
        }
        public List<GenerateAutomationDataContract> GetLiabilitListForCalculation(string type)
        {
            return _lbCalcRepository.GetLiabilitListForCalculation(type);
        }

        public void InsertTransactionEntryLiabilityLine(List<LiabilityLineTransaction> LiabilityLineTransaction, string username)
        {
            _lbCalcRepository.InsertTransactionEntryLiabilityLine(LiabilityLineTransaction, username);
        }
       
        public void InsertLiabilityNoteTransaction(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username)
        {
            _lbCalcRepository.InsertLiabilityNoteTransaction(LiabilityNoteTransaction, username);
        }

        public void InsertLiabilityNoteTransactionForFeeAndInterest(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username)
        {
            _lbCalcRepository.InsertLiabilityNoteTransactionForFeeAndInterest(LiabilityNoteTransaction, username);
        }

        public void InsertLiabilityNoteTransactionForFee(List<LiabilityNoteTransaction> LiabilityNoteTransaction, string username)
        {
            _lbCalcRepository.InsertLiabilityNoteTransactionForFee(LiabilityNoteTransaction, username);
        }

        public void UpdateLiabilityTransactionFileName(int AutomationRequestsID, string FileName)
        {
            _lbCalcRepository.UpdateLiabilityTransactionFileName(AutomationRequestsID, FileName);
        }


        public dynamic GetLiabilityCalcRequestForFeesAndInterest(string userID, string fundIDorName, string analysisID, bool? isTestRequest = false)
        {
            
            
            dynamic objJsonResult = null;
            Dictionary<String, Object> Rootdict = new Dictionary<String, Object>();
            Dictionary<String, Object> JsonRoot_data = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_calendar = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_index = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_effective_dates = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_notes = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_liabilitynote_notebalance = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_liabilitynote_effectivedate = new Dictionary<String, Object>();


            try
            {

                if (string.IsNullOrEmpty(fundIDorName))
                {
                    return objJsonResult;
                }
                DataSet dsCalJsonData = new DataSet();

                //get the json data from db
                dsCalJsonData = _lbCalcRepository.GetLiabilityFeesAndInterestCalcRequestData("", fundIDorName, analysisID);


                if (dsCalJsonData.Tables.Count > 0)
                {
                    DataTable dtRoot = dsCalJsonData.Tables["root"];
                    DataTable dtRoot_data= dsCalJsonData.Tables["root.data"];
                    DataTable dtRoot_data_calendar = dsCalJsonData.Tables["root.data.calendar"];
                    DataTable dtRoot_data_index = dsCalJsonData.Tables["root.data.index"];
                    DataTable dtRoot_data_effective_dates = dsCalJsonData.Tables["root.data.effective_dates"];
                    DataTable dtRoot_data_notes = dsCalJsonData.Tables["root.data.notes"];
                    DataTable dtRoot_data_liabilityNote_notebalance = dsCalJsonData.Tables["root.data.notes.LiabilityNote.notebalance"];
                    DataTable dtRoot_data_liabilityNote_effectivedate = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate"];
                    DataTable dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetail = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.LiabilityNoteDetail"];
                    DataTable dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetailByEffectiveDate = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.LiabilityNoteDetailByEffectiveDate"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_rate = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.rate"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_spread = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.spread"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_coupon_floor = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.coupon_floor"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_coupon_cap = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.coupon_cap"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_index_floor = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.index_floor"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_index_cap = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.index_cap"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_amort_rate = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.amort_rate"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_amort_spread = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.amort_spread"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_amort_rate_floor = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.amort_rate_floor"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_amort_rate_cap = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.amort_rate_cap"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_reference_rate = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.reference_rate"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_index_name = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.index_name"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_fee = dsCalJsonData.Tables["root.data.notes.LiabilityNote.effectivedate.fees"];
                    DataTable dtRoot_data_notes_unallocatedbls = dsCalJsonData.Tables["root.data.notes.unallocatedbls"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate"];

                    DataTable dtRoot_data_liabilityNote_effectivedate_unallocatedblsDetaill = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.unallocatedblsDetail"];
                    DataTable dtRoot_data_liabilityNote_effectivedate_unallocatedblsDetaillByEffectiveDate = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.unallocatedblsDetailByEffectiveDate"];


                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_rate = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.rate"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_spread = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.spread"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_coupon_floor = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.coupon_floor"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_coupon_cap = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.coupon_cap"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_index_floor = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.index_floor"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_index_cap = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.index_cap"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.amort_rate"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_amort_spread = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.amort_spread"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate_floor = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.amort_rate_floor"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate_cap = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.amort_rate_cap"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_reference_rate = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.reference_rate"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_index_name = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.index_name"];
                    DataTable dtRoot_data_notes_unallocatedbls_effectivedate_fee = dsCalJsonData.Tables["root.data.notes.unallocatedbls.effectivedate.fees"];


                    DataTable dtJsonTemplate = dsCalJsonData.Tables["JsonTemplate"];




                    // stop calc process when fetch cancel calc status
                    //if (dtDataRootinfo.Rows[0]["CalcStatus"].ToString() == "736")
                    //{
                    //    dynamic objJsonRes;
                    //    objJsonRes = dtDataRootinfo.Rows[0]["CalcStatus"].ToInt32();
                    //    return objJsonRes;
                    //}

                    if (isTestRequest == false)
                    {
                        ////code call for manage isCalcCancel
                        if (dtRoot_data.Rows[0]["isCalcCancel"].ToBoolean() == true)
                        {
                            dynamic objJsonRes;
                            objJsonRes = dtRoot_data.Rows[0]["isCalcCancel"].ToInt32();
                            return objJsonRes;
                        }
                        //code call for manage duplicate entry (isCalcStarted) 
                        if (dtRoot_data.Rows[0]["isCalcStarted"].ToBoolean() == true)
                        {
                            dynamic objJsonRes;
                            objJsonRes = dtRoot_data.Rows[0]["isCalcStarted"].ToInt32();
                            return objJsonRes;
                        }
                    }


                    string[] arrEffectiveDates = null;

                    //root.data.effective_dates

                    //root.data.calendar
                    if (dtRoot_data_effective_dates.Rows.Count > 0)
                    {
                        arrEffectiveDates = dtRoot_data_effective_dates.AsEnumerable().Select(r => r.Field<string>("effective_dates")).ToArray();
                       
                    }

                    //root.data.index

                    if (dtRoot_data_index.Rows.Count > 0)
                    {
                        var uniqueObjects = dtRoot_data_index.AsEnumerable().Select(x => x.Field<string>("indexname")).Distinct().ToList();
                        for (int i = 0; i < uniqueObjects.Count; i++)
                        {
                           // dtChildinner = dsCalJsonData.Tables[lstchild[i].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").CopyToDataTable();

                            var tblindexname = dtRoot_data_index.Select("indexname='" + uniqueObjects[i] + "'").CopyToDataTable();
                            Dictionary<String, Object> Dict_root_data_index_inner = new Dictionary<String, Object>();
                            for (int j = 0; j < tblindexname.Rows.Count; j++)
                            {
                                Dict_root_data_index_inner.Add(tblindexname.Rows[j]["date"].ToString(), tblindexname.Rows[j]["value"]);
                            }

                            Dict_root_data_index.Add(uniqueObjects[i], Dict_root_data_index_inner);
                        }
                    }

                    //root.data.calendar
                    if (dtRoot_data_calendar.Rows.Count > 0)
                    {
                        var uniqueObjects = dtRoot_data_calendar.AsEnumerable().Select(x => x.Field<string>("HolidayTypeText")).Distinct().ToList();
                        for (int i = 0; i < uniqueObjects.Count; i++)
                        {
                            //dtChildinner = dsCalJsonData.Tables[lstchild[i].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").CopyToDataTable();

                            var arrsingle = dtRoot_data_calendar.Select("HolidayTypeText='" + uniqueObjects[i] + "'").AsEnumerable().Select(r => r.Field<string>("HoliDayDate")).ToArray();

                            Dict_root_data_calendar.Add(uniqueObjects[i], arrsingle);
                        }
                    }

                    //root.data.notes
                    if (dtRoot_data_notes.Rows.Count > 0)
                    {

                        for (int i = 0; i < dtRoot_data_notes.Rows.Count; i++)
                        {
                            Dictionary<String, Object> Dict_root_data_notes_inner = new Dictionary<String, Object>();
                            Dict_root_data_notes_inner.Add("id", dtRoot_data_notes.Rows[i]["id"]);
                            Dict_root_data_notes_inner.Add("name", dtRoot_data_notes.Rows[i]["name"]);
                            Dict_root_data_notes_inner.Add("liabilityaccountid", dtRoot_data_notes.Rows[i]["LiabilityAccountID"]);
                            Dict_root_data_notes_inner.Add("liabilitytypeid", dtRoot_data_notes.Rows[i]["LiabilityTypeID"]);
                            Dict_root_data_notes_inner.Add("liabilitynoteaccountid", dtRoot_data_notes.Rows[i]["LiabilityNoteAccountID"]);
                            Dict_root_data_notes_inner.Add("pledgedate", dtRoot_data_notes.Rows[i]["PledgeDate"]);
                            Dict_root_data_notes_inner.Add("libnotetype", dtRoot_data_notes.Rows[i]["libnotetype"]);

                            if (dtRoot_data_liabilityNote_notebalance != null && dtRoot_data_liabilityNote_notebalance.Rows.Count > 0)
                            {
                                var dt_notebalance = dtRoot_data_liabilityNote_notebalance.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "'");
                                if (dt_notebalance.Count() > 0)
                                {
                                    var details = (from r in dt_notebalance.AsEnumerable()
                                                   select new
                                                   {
                                                       Date = r.Field<string>("Date"),
                                                       TransactionAmount = r.Field<Decimal?>("TransactionAmount"),
                                                       TransactionType = r.Field<string>("TransactionType"),
                                                       EndingBalance = r.Field<Decimal?>("EndingBalance"),
                                                   });
                                    Dict_root_data_notes_inner.Add("notebalance", details);
                                }
                                else
                                {
                                    Dict_root_data_notes_inner.Add("notebalance", "");
                                }
                            }
                            else
                            {
                                Dict_root_data_notes_inner.Add("notebalance", "");
                            }


                            // //root.data.notes.LiabilityNote.effectivedate
                            if (dtRoot_data_liabilityNote_effectivedate.Rows.Count > 0)
                            {
                                var dtEffeDates = dtRoot_data_liabilityNote_effectivedate.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "'");
                                if (dtEffeDates.Count()>0)
                                {
                                    var dtEffectiveDates = dtEffeDates.CopyToDataTable();



                                    for (int j = 0; j < dtEffectiveDates.Rows.Count; j++)
                                    {
                                        Dictionary<String, Object> Dict_root_data_notes_inner_inner = new Dictionary<String, Object>();
                                        if (j == 0)
                                        {

                                            var dt_liabilityNoteDetail = dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetail.Select("liabilityNoteID='" + dtRoot_data_notes.Rows[i]["liabilityNoteID"]+"'");
                                            
                                            if (dt_liabilityNoteDetail.Count() > 0)
                                            {
                                                var dtliabilityNoteDetail = dt_liabilityNoteDetail.CopyToDataTable();
                                                Dict_root_data_notes_inner_inner.Add("CRENoteID", dtliabilityNoteDetail.Rows[0]["CRENoteID"]);
                                                Dict_root_data_notes_inner_inner.Add("NoteID", dtliabilityNoteDetail.Rows[0]["NoteID"]);
                                                Dict_root_data_notes_inner_inner.Add("min_effective_dates", dtliabilityNoteDetail.Rows[0]["min_effective_dates"]);
                                                //Dict_root_data_notes_inner_inner.Add("initaccenddt", dtliabilityNoteDetail.Rows[0]["initaccenddt"]);
                                                Dict_root_data_notes_inner_inner.Add("initpmtdt", dtliabilityNoteDetail.Rows[0]["initpmtdt"]);
                                                //Dict_root_data_notes_inner_inner.Add("amterm", dtliabilityNoteDetail.Rows[0]["amterm"]);
                                                Dict_root_data_notes_inner_inner.Add("clsdt", dtliabilityNoteDetail.Rows[0]["clsdt"]);
                                                //Dict_root_data_notes_inner_inner.Add("leaddays", dtliabilityNoteDetail.Rows[0]["leaddays"]);
                                                //Dict_root_data_notes_inner_inner.Add("initresetdt", dtliabilityNoteDetail.Rows[0]["initresetdt"]);
                                                //Dict_root_data_notes_inner_inner.Add("initindex", dtliabilityNoteDetail.Rows[0]["initindex"]);
                                                Dict_root_data_notes_inner_inner.Add("roundmethod", dtliabilityNoteDetail.Rows[0]["roundmethod"]);
                                                Dict_root_data_notes_inner_inner.Add("resetindexdaily", dtliabilityNoteDetail.Rows[0]["ResetIndexDaily"]);

                                                Dict_root_data_notes_inner_inner.Add("precision", dtliabilityNoteDetail.Rows[0]["precision"]);
                                                Dict_root_data_notes_inner_inner.Add("accfreq", dtliabilityNoteDetail.Rows[0]["accfreq"]);
                                                Dict_root_data_notes_inner_inner.Add("payfreq", dtliabilityNoteDetail.Rows[0]["payfreq"]);

                                                Dict_root_data_notes_inner_inner.Add("perenddtbuslag", dtliabilityNoteDetail.Rows[0]["perenddtbuslag"]);
                                                //Dict_root_data_notes_inner_inner.Add("paydatebusiessdaylag", dtliabilityNoteDetail.Rows[0]["paydatebusiessdaylag"]);
                                                Dict_root_data_notes_inner_inner.Add("expectedmaturitydate", dtliabilityNoteDetail.Rows[0]["expectedmaturitydate"]);
                                                Dict_root_data_notes_inner_inner.Add("pmtdtaccper", dtliabilityNoteDetail.Rows[0]["pmtdtaccper"]);
                                                Dict_root_data_notes_inner_inner.Add("initmatdt", dtliabilityNoteDetail.Rows[0]["initmatdt"]);
                                                Dict_root_data_notes_inner_inner.Add("contractmat", dtliabilityNoteDetail.Rows[0]["contractmat"]);
                                                Dict_root_data_notes_inner_inner.Add("accenddatebusidaylag", dtliabilityNoteDetail.Rows[0]["accenddatebusidaylag"]);
                                                //Dict_root_data_notes_inner_inner.Add("determidayrefdayofmnth", dtliabilityNoteDetail.Rows[0]["determidayrefdayofmnth"]);
                                                Dict_root_data_notes_inner_inner.Add("intactmethod", dtliabilityNoteDetail.Rows[0]["intactmethod"]);
                                                Dict_root_data_notes_inner_inner.Add("defaultindexnm", dtliabilityNoteDetail.Rows[0]["defaultindexnm"]);
                                                Dict_root_data_notes_inner_inner.Add("pydt_detdt_hlday_ls", dtliabilityNoteDetail.Rows[0]["pydt_detdt_hlday_ls"]);

                                                Dict_root_data_notes_inner_inner.Add("targetadvrate", dtliabilityNoteDetail.Rows[0]["targetadvrate"]);
                                                //Dict_root_data_notes_inner_inner.Add("accperpaydaywhennoteomnth", dtliabilityNoteDetail.Rows[0]["accperpaydaywhennoteomnth"]);


                                            }
                                        }

                                        if (dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetailByEffectiveDate != null && dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetailByEffectiveDate.Rows.Count > 0)
                                        {
                                            var dt_liabilityNoteDetailByEffectiveDate = dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetailByEffectiveDate.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_liabilityNoteDetailByEffectiveDate.Count() > 0)
                                            {
                                                var dtliabilityNoteDetailByEffectiveDate = dt_liabilityNoteDetailByEffectiveDate.CopyToDataTable();
                                                Dict_root_data_notes_inner_inner.Add("initaccenddt", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initaccenddt"]);
                                                Dict_root_data_notes_inner_inner.Add("paydatebusiessdaylag", dtliabilityNoteDetailByEffectiveDate.Rows[0]["paydatebusiessdaylag"]);
                                                Dict_root_data_notes_inner_inner.Add("leaddays", dtliabilityNoteDetailByEffectiveDate.Rows[0]["leaddays"]);
                                                Dict_root_data_notes_inner_inner.Add("determidayrefdayofmnth", dtliabilityNoteDetailByEffectiveDate.Rows[0]["determidayrefdayofmnth"]);
                                                Dict_root_data_notes_inner_inner.Add("accperpaydaywhennoteomnth", dtliabilityNoteDetailByEffectiveDate.Rows[0]["accperpaydaywhennoteomnth"]);
                                                Dict_root_data_notes_inner_inner.Add("initindex", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initindex"]);
                                                Dict_root_data_notes_inner_inner.Add("initresetdt", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initresetdt"]);

                                            }
                                            else
                                            {
                                                Dict_root_data_notes_inner_inner.Add("initaccenddt", "");
                                                Dict_root_data_notes_inner_inner.Add("paydatebusiessdaylag", "");
                                                Dict_root_data_notes_inner_inner.Add("leaddays", "");
                                                Dict_root_data_notes_inner_inner.Add("determidayrefdayofmnth", "");
                                                Dict_root_data_notes_inner_inner.Add("accperpaydaywhennoteomnth", "");
                                                Dict_root_data_notes_inner_inner.Add("initindex", "");
                                                Dict_root_data_notes_inner_inner.Add("initresetdt", "");
                                            }

                                        }

                                        if (dtRoot_data_notes_liabilityNote_effectivedate_rate != null && dtRoot_data_notes_liabilityNote_effectivedate_rate.Rows.Count > 0)
                                        {
                                            var dt_rate = dtRoot_data_notes_liabilityNote_effectivedate_rate.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_rate.Count() > 0)
                                            {
                                                var details = (from r in dt_rate.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Decimal?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("rate", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_spread != null && dtRoot_data_notes_liabilityNote_effectivedate_spread.Rows.Count > 0)
                                        {

                                            var dt_spread = dtRoot_data_notes_liabilityNote_effectivedate_spread.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_spread.Count() > 0)
                                            {
                                                var details = (from r in dt_spread.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<decimal?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("spread", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_coupon_floor != null && dtRoot_data_notes_liabilityNote_effectivedate_coupon_floor.Rows.Count > 0)
                                        {
                                            var dt_coupon_floor = dtRoot_data_notes_liabilityNote_effectivedate_coupon_floor.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_floor.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_floor.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("coupon_floor", details);
                                            }

                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_coupon_cap != null && dtRoot_data_notes_liabilityNote_effectivedate_coupon_cap.Rows.Count > 0)
                                        {

                                            var dt_coupon_cap = dtRoot_data_notes_liabilityNote_effectivedate_coupon_cap.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_cap.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_cap.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("coupon_cap", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_index_floor != null && dtRoot_data_notes_liabilityNote_effectivedate_index_floor.Rows.Count > 0)
                                        {

                                            var dt_coupon_index_floor = dtRoot_data_notes_liabilityNote_effectivedate_index_floor.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_index_floor.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_index_floor.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<decimal?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("index_floor", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_index_cap != null && dtRoot_data_notes_liabilityNote_effectivedate_index_cap.Rows.Count > 0)
                                        {
                                            var dt_coupon_index_cap = dtRoot_data_notes_liabilityNote_effectivedate_index_cap.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_index_cap.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_index_cap.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("index_cap", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_amort_rate != null && dtRoot_data_notes_liabilityNote_effectivedate_amort_rate.Rows.Count > 0)
                                        {

                                            var dt_coupon_amort_rate = dtRoot_data_notes_liabilityNote_effectivedate_amort_rate.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_amort_rate.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_amort_rate.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("amort_rate", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_amort_spread != null && dtRoot_data_notes_liabilityNote_effectivedate_amort_spread.Rows.Count > 0)
                                        {

                                            var dt_amort_spread = dtRoot_data_notes_liabilityNote_effectivedate_amort_spread.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_amort_spread.Count() > 0)
                                            {
                                                var details = (from r in dt_amort_spread.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("amort_spread", details);
                                            }
                                        }

                                        if (dtRoot_data_notes_liabilityNote_effectivedate_amort_rate_floor != null && dtRoot_data_notes_liabilityNote_effectivedate_amort_rate_floor.Rows.Count > 0)
                                        {

                                            var dt_amort_rate_floor = dtRoot_data_notes_liabilityNote_effectivedate_amort_rate_floor.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_amort_rate_floor.Count() > 0)
                                            {
                                                var details = (from r in dt_amort_rate_floor.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("amort_rate_floor", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_amort_rate_cap != null && dtRoot_data_notes_liabilityNote_effectivedate_amort_rate_cap.Rows.Count > 0)
                                        {
                                            var dt_amort_rate_cap = dtRoot_data_notes_liabilityNote_effectivedate_amort_rate_cap.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_amort_rate_cap.Count() > 0)
                                            {
                                                var details = (from r in dt_amort_rate_cap.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("amort_rate_cap", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_reference_rate != null && dtRoot_data_notes_liabilityNote_effectivedate_reference_rate.Rows.Count > 0)
                                        {
                                            var dt_reference_rate = dtRoot_data_notes_liabilityNote_effectivedate_reference_rate.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_reference_rate.Count() > 0)
                                            {
                                                var details = (from r in dt_reference_rate.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("reference_rate", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_index_name != null && dtRoot_data_notes_liabilityNote_effectivedate_index_name.Rows.Count > 0)
                                        {
                                            var dt_index_name = dtRoot_data_notes_liabilityNote_effectivedate_index_name.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_index_name.Count() > 0)
                                            {
                                                var details = (from r in dt_index_name.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<decimal?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("index_name", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_liabilityNote_effectivedate_fee != null && dtRoot_data_notes_liabilityNote_effectivedate_fee.Rows.Count > 0)
                                        {
                                            var dt_fee = dtRoot_data_notes_liabilityNote_effectivedate_fee.Select("LiabilityNoteID='" + dtRoot_data_notes.Rows[i]["LiabilityNoteID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_fee.Count() > 0)
                                            {
                                                var details = (from r in dt_fee.AsEnumerable()
                                                               select new
                                                               {
                                                                   feename = r.Field<string>("feename"),
                                                                   startdt = r.Field<string>("startdt"),
                                                                   enddt = r.Field<string>("enddt"),
                                                                   type = r.Field<string>("type"),
                                                                   valtype = r.Field<int?>("valtype"),
                                                                   val = r.Field<Decimal?>("val"),
                                                                   ovrfeeamt = r.Field<Decimal?>("ovrfeeamt"),
                                                                   ovrbaseamt = r.Field<Decimal?>("ovrbaseamt"),
                                                                   trueupflag = r.Field<int?>("trueupflag"),
                                                                   levyldincl = r.Field<int?>("levyldincl"),
                                                                   basisincl = r.Field<Decimal?>("basisincl"),
                                                                   stripval = r.Field<Decimal?>("stripval"),
                                                                   actual_startdt = r.Field<string>("actual_startdt"),
                                                                   feescheduleid = r.Field<string>("feescheduleid") == null ? "" : r.Field<string>("feescheduleid"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("fee", details);
                                            }
                                        }


                                        Dict_root_data_notes_inner.Add(Convert.ToString(dtEffectiveDates.Rows[j]["EffectiveDate"]), Dict_root_data_notes_inner_inner);
                                    }
                                }
                                
                               

                             }

                           

                            Dict_root_data_notes.Add(Convert.ToString(dtRoot_data_notes.Rows[i]["LiabilityNoteID"]), Dict_root_data_notes_inner);

                        }

                    }

                    //root.data.notes for unallocated balance
                    if (dtRoot_data_notes_unallocatedbls.Rows.Count>0)
                    {
                        var uniqueObjects = dtRoot_data_notes_unallocatedbls.AsEnumerable().Select(x => x.Field<string>("LiabilityTypeName")).Distinct().ToList();

                        for (int j = 0; j < uniqueObjects.Count; j++)
                        {
                            var tblunallocated = dtRoot_data_notes_unallocatedbls.Select("LiabilityTypeName='" + uniqueObjects[j] + "'").CopyToDataTable();

                            Dictionary<String, Object> Dict_root_data_notes_inner = new Dictionary<String, Object>();
                            Dict_root_data_notes_inner.Add("id", tblunallocated.Rows[0]["ID"]);
                            Dict_root_data_notes_inner.Add("liabilityaccountid", tblunallocated.Rows[0]["LiabilityAccountID"]);
                            Dict_root_data_notes_inner.Add("liabilitynoteaccountid", tblunallocated.Rows[0]["LiabilityNoteID"]);
                            Dict_root_data_notes_inner.Add("liabilitytypeid", tblunallocated.Rows[0]["LiabilityTypeID"]);
                            Dict_root_data_notes_inner.Add("grptype", tblunallocated.Rows[0]["grptype"]);

                            var detailsNoteBalance = (from r in tblunallocated.AsEnumerable()
                                               select new
                                               {
                                                   Date = r.Field<string>("Date"),
                                                   Amount = r.Field<Decimal?>("Amount"),
                                               });
                            Dict_root_data_notes_inner.Add("notebalance", detailsNoteBalance);
                           
                            Dict_root_data_notes.Add(Convert.ToString(uniqueObjects[j]), Dict_root_data_notes_inner);

                            // dtRoot_data_notes_unallocatedbls_effectivedate
                            if (dtRoot_data_notes_unallocatedbls_effectivedate.Rows.Count > 0)
                            {
                                var dtEffeDates = dtRoot_data_notes_unallocatedbls_effectivedate.Select("LiabilityTypeName='" + uniqueObjects[j] + "'");
                                if (dtEffeDates.Count() > 0)
                                {
                                    var dtEffectiveDates = dtEffeDates.CopyToDataTable();

                                    for (int k = 0; k < dtEffectiveDates.Rows.Count; k++)
                                    {
                                        Dictionary<String, Object> Dict_root_data_notes_inner_inner = new Dictionary<String, Object>();
                                        if (k == 0)
                                        {

                                            var dt_liabilityNoteDetail = dtRoot_data_liabilityNote_effectivedate_unallocatedblsDetaill.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "'");
                                            var dtliabilityNoteDetail = dt_liabilityNoteDetail.CopyToDataTable();
                                            if (dtliabilityNoteDetail.Rows.Count > 0)
                                            {
                                                //Dict_root_data_notes_inner_inner.Add("CRENoteID", dtliabilityNoteDetail.Rows[0]["CRENoteID"]);
                                                //Dict_root_data_notes_inner_inner.Add("NoteID", dtliabilityNoteDetail.Rows[0]["NoteID"]);
                                                Dict_root_data_notes_inner_inner.Add("min_effective_dates", dtliabilityNoteDetail.Rows[0]["min_effective_dates"]);
                                                ////Dict_root_data_notes_inner_inner.Add("initaccenddt", dtliabilityNoteDetail.Rows[0]["initaccenddt"]);
                                                Dict_root_data_notes_inner_inner.Add("initpmtdt", dtliabilityNoteDetail.Rows[0]["initpmtdt"]);
                                                //Dict_root_data_notes_inner_inner.Add("amterm", dtliabilityNoteDetail.Rows[0]["amterm"]);
                                                Dict_root_data_notes_inner_inner.Add("clsdt", dtliabilityNoteDetail.Rows[0]["clsdt"]);
                                                ////Dict_root_data_notes_inner_inner.Add("leaddays", dtliabilityNoteDetail.Rows[0]["leaddays"]);
                                                ////Dict_root_data_notes_inner_inner.Add("initresetdt", dtliabilityNoteDetail.Rows[0]["initresetdt"]);
                                                ////Dict_root_data_notes_inner_inner.Add("initindex", dtliabilityNoteDetail.Rows[0]["initindex"]);
                                                Dict_root_data_notes_inner_inner.Add("roundmethod", dtliabilityNoteDetail.Rows[0]["roundmethod"]);
                                                Dict_root_data_notes_inner_inner.Add("resetindexdaily", dtliabilityNoteDetail.Rows[0]["ResetIndexDaily"]);
                                                Dict_root_data_notes_inner_inner.Add("precision", dtliabilityNoteDetail.Rows[0]["precision"]);
                                                Dict_root_data_notes_inner_inner.Add("accfreq", dtliabilityNoteDetail.Rows[0]["accfreq"]);
                                                Dict_root_data_notes_inner_inner.Add("payfreq", dtliabilityNoteDetail.Rows[0]["payfreq"]);
                                                Dict_root_data_notes_inner_inner.Add("perenddtbuslag", dtliabilityNoteDetail.Rows[0]["perenddtbuslag"]);
                                                ////Dict_root_data_notes_inner_inner.Add("paydatebusiessdaylag", dtliabilityNoteDetail.Rows[0]["paydatebusiessdaylag"]);
                                                Dict_root_data_notes_inner_inner.Add("expectedmaturitydate", dtliabilityNoteDetail.Rows[0]["expectedmaturitydate"]);
                                                Dict_root_data_notes_inner_inner.Add("pmtdtaccper", dtliabilityNoteDetail.Rows[0]["pmtdtaccper"]);
                                                Dict_root_data_notes_inner_inner.Add("initmatdt", dtliabilityNoteDetail.Rows[0]["initmatdt"]);
                                                Dict_root_data_notes_inner_inner.Add("contractmat", dtliabilityNoteDetail.Rows[0]["contractmat"]);
                                                Dict_root_data_notes_inner_inner.Add("accenddatebusidaylag", dtliabilityNoteDetail.Rows[0]["accenddatebusidaylag"]);
                                                ////Dict_root_data_notes_inner_inner.Add("determidayrefdayofmnth", dtliabilityNoteDetail.Rows[0]["determidayrefdayofmnth"]);
                                                Dict_root_data_notes_inner_inner.Add("intactmethod", dtliabilityNoteDetail.Rows[0]["intactmethod"]);
                                                Dict_root_data_notes_inner_inner.Add("defaultindexnm", dtliabilityNoteDetail.Rows[0]["defaultindexnm"]);
                                                Dict_root_data_notes_inner_inner.Add("targetadvrate", dtliabilityNoteDetail.Rows[0]["targetadvrate"]);
                                                Dict_root_data_notes_inner_inner.Add("pydt_detdt_hlday_ls", dtliabilityNoteDetail.Rows[0]["pydt_detdt_hlday_ls"]);
                                                ////Dict_root_data_notes_inner_inner.Add("accperpaydaywhennoteomnth", dtliabilityNoteDetail.Rows[0]["accperpaydaywhennoteomnth"]);


                                            }
                                        }

                                        if (dtRoot_data_liabilityNote_effectivedate_unallocatedblsDetaillByEffectiveDate != null && dtRoot_data_liabilityNote_effectivedate_unallocatedblsDetaillByEffectiveDate.Rows.Count > 0)
                                        {
                                            var dt_liabilityNoteDetailByEffectiveDate = dtRoot_data_liabilityNote_effectivedate_unallocatedblsDetaillByEffectiveDate.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_liabilityNoteDetailByEffectiveDate.Count() > 0)
                                            {
                                                var dtliabilityNoteDetailByEffectiveDate = dt_liabilityNoteDetailByEffectiveDate.CopyToDataTable();
                                                Dict_root_data_notes_inner_inner.Add("initaccenddt", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initaccenddt"]);
                                                Dict_root_data_notes_inner_inner.Add("paydatebusiessdaylag", dtliabilityNoteDetailByEffectiveDate.Rows[0]["paydatebusiessdaylag"]);
                                                Dict_root_data_notes_inner_inner.Add("leaddays", dtliabilityNoteDetailByEffectiveDate.Rows[0]["leaddays"]);
                                                Dict_root_data_notes_inner_inner.Add("determidayrefdayofmnth", dtliabilityNoteDetailByEffectiveDate.Rows[0]["determidayrefdayofmnth"]);
                                                Dict_root_data_notes_inner_inner.Add("accperpaydaywhennoteomnth", dtliabilityNoteDetailByEffectiveDate.Rows[0]["accperpaydaywhennoteomnth"]);
                                                Dict_root_data_notes_inner_inner.Add("initindex", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initindex"]);
                                                Dict_root_data_notes_inner_inner.Add("initresetdt", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initresetdt"]);

                                            }
                                            else
                                            {
                                                Dict_root_data_notes_inner_inner.Add("initaccenddt", "");
                                                Dict_root_data_notes_inner_inner.Add("paydatebusiessdaylag", "");
                                                Dict_root_data_notes_inner_inner.Add("leaddays", "");
                                                Dict_root_data_notes_inner_inner.Add("determidayrefdayofmnth", "");
                                                Dict_root_data_notes_inner_inner.Add("accperpaydaywhennoteomnth", "");
                                                Dict_root_data_notes_inner_inner.Add("initindex", "");
                                                Dict_root_data_notes_inner_inner.Add("initresetdt", "");
                                            }

                                        }

                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_rate != null && dtRoot_data_notes_unallocatedbls_effectivedate_rate.Rows.Count > 0)
                                        {
                                            var dt_rate = dtRoot_data_notes_unallocatedbls_effectivedate_rate.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[k]["EffectiveDate"] + "'");
                                            if (dt_rate.Count() > 0)
                                            {
                                                var details = (from r in dt_rate.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Decimal?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("rate", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_spread != null && dtRoot_data_notes_unallocatedbls_effectivedate_spread.Rows.Count > 0)
                                        {

                                            var dt_spread = dtRoot_data_notes_unallocatedbls_effectivedate_spread.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_spread.Count() > 0)
                                            {
                                                var details = (from r in dt_spread.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<decimal?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("spread", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_coupon_floor != null && dtRoot_data_notes_unallocatedbls_effectivedate_coupon_floor.Rows.Count > 0)
                                        {
                                            var dt_coupon_floor = dtRoot_data_notes_unallocatedbls_effectivedate_coupon_floor.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_floor.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_floor.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("coupon_floor", details);
                                            }

                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_coupon_cap != null && dtRoot_data_notes_unallocatedbls_effectivedate_coupon_cap.Rows.Count > 0)
                                        {

                                            var dt_coupon_cap = dtRoot_data_notes_unallocatedbls_effectivedate_coupon_cap.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_cap.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_cap.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("coupon_cap", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_index_floor != null && dtRoot_data_notes_unallocatedbls_effectivedate_index_floor.Rows.Count > 0)
                                        {

                                            var dt_coupon_index_floor = dtRoot_data_notes_unallocatedbls_effectivedate_index_floor.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_index_floor.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_index_floor.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<decimal?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("index_floor", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_index_cap != null && dtRoot_data_notes_unallocatedbls_effectivedate_index_cap.Rows.Count > 0)
                                        {
                                            var dt_coupon_index_cap = dtRoot_data_notes_unallocatedbls_effectivedate_index_cap.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_index_cap.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_index_cap.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("index_cap", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate != null && dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate.Rows.Count > 0)
                                        {

                                            var dt_coupon_amort_rate = dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_coupon_amort_rate.Count() > 0)
                                            {
                                                var details = (from r in dt_coupon_amort_rate.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("amort_rate", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_amort_spread != null && dtRoot_data_notes_unallocatedbls_effectivedate_amort_spread.Rows.Count > 0)
                                        {

                                            var dt_amort_spread = dtRoot_data_notes_unallocatedbls_effectivedate_amort_spread.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_amort_spread.Count() > 0)
                                            {
                                                var details = (from r in dt_amort_spread.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("amort_spread", details);
                                            }
                                        }

                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate_floor != null && dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate_floor.Rows.Count > 0)
                                        {

                                            var dt_amort_rate_floor = dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate_floor.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_amort_rate_floor.Count() > 0)
                                            {
                                                var details = (from r in dt_amort_rate_floor.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("amort_rate_floor", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate_cap != null && dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate_cap.Rows.Count > 0)
                                        {
                                            var dt_amort_rate_cap = dtRoot_data_notes_unallocatedbls_effectivedate_amort_rate_cap.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_amort_rate_cap.Count() > 0)
                                            {
                                                var details = (from r in dt_amort_rate_cap.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("amort_rate_cap", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_reference_rate != null && dtRoot_data_notes_unallocatedbls_effectivedate_reference_rate.Rows.Count > 0)
                                        {
                                            var dt_reference_rate = dtRoot_data_notes_unallocatedbls_effectivedate_reference_rate.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_reference_rate.Count() > 0)
                                            {
                                                var details = (from r in dt_reference_rate.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<Double?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("reference_rate", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_index_name != null && dtRoot_data_notes_unallocatedbls_effectivedate_index_name.Rows.Count > 0)
                                        {
                                            var dt_index_name = dtRoot_data_notes_unallocatedbls_effectivedate_index_name.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_index_name.Count() > 0)
                                            {
                                                var details = (from r in dt_index_name.AsEnumerable()
                                                               select new
                                                               {
                                                                   startdt = r.Field<string>("startdt"),
                                                                   valtype = r.Field<string>("valtype"),
                                                                   val = r.Field<decimal?>("val"),
                                                                   intcalcdays = r.Field<int>("intcalcdays"),
                                                                   detdt_hlday_ls = r.Field<string>("detdt_hlday_ls"),
                                                                   indexnametext = r.Field<string>("indexnametext"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("index_name", details);
                                            }
                                        }
                                        if (dtRoot_data_notes_unallocatedbls_effectivedate_fee != null && dtRoot_data_notes_unallocatedbls_effectivedate_fee.Rows.Count > 0)
                                        {
                                            var dt_fee = dtRoot_data_notes_unallocatedbls_effectivedate_fee.Select("LiabilityTypeName='" + dtEffectiveDates.Rows[k]["LiabilityTypeName"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_fee.Count() > 0)
                                            {
                                                var details = (from r in dt_fee.AsEnumerable()
                                                               select new
                                                               {
                                                                   feename = r.Field<string>("feename"),
                                                                   startdt = r.Field<string>("startdt"),
                                                                   enddt = r.Field<string>("enddt"),
                                                                   type = r.Field<string>("type"),
                                                                   valtype = r.Field<int>("valtype"),
                                                                   val = r.Field<Decimal?>("val"),
                                                                   ovrfeeamt = r.Field<Decimal?>("ovrfeeamt"),
                                                                   ovrbaseamt = r.Field<Decimal?>("ovrbaseamt"),
                                                                   trueupflag = r.Field<int>("trueupflag"),
                                                                   levyldincl = r.Field<int>("levyldincl"),
                                                                   basisincl = r.Field<Decimal?>("basisincl"),
                                                                   stripval = r.Field<Decimal?>("stripval"),
                                                                   actual_startdt = r.Field<string>("actual_startdt"),
                                                                   feescheduleid = r.Field<string>("feescheduleid") == null ? "" : r.Field<string>("feescheduleid"),
                                                               });
                                                Dict_root_data_notes_inner_inner.Add("fee", details);
                                            }
                                        }


                                        Dict_root_data_notes_inner.Add(Convert.ToString(dtEffectiveDates.Rows[k]["EffectiveDate"]), Dict_root_data_notes_inner_inner);

                                        //Dict_root_data_notes_inner.Add(Convert.ToString(dtEffectiveDates.Rows[k]["EffectiveDate"]), "");
                                    }
                                }
                            }


                        }

                     }


                        //root.data.notes.LiabilityNote.notebalance




                        ////root.data 
                        Dict_root_data.Add("period_start_date", Convert.ToString(dtRoot_data.Rows[0]["period_start_date"]));
                    Dict_root_data.Add("effective_dates", arrEffectiveDates);
                    Dict_root_data.Add("period_end_date", Convert.ToString(dtRoot_data.Rows[0]["period_end_date"]));
                    Dict_root_data.Add("root_note_id", Convert.ToString(dtRoot_data.Rows[0]["root_note_id"]));
                    Dict_root_data.Add("analysisid", Convert.ToString(dtRoot_data.Rows[0]["AnalysisID"]));
                    //Dict_root_data.Add("accounts", "");
                    Dict_root_data.Add("calc_basis", Convert.ToBoolean(dtRoot_data.Rows[0]["calc_basis"]));
                    Dict_root_data.Add("notes", Dict_root_data_notes);
                    Dict_root_data.Add("index", Dict_root_data_index);
                    Dict_root_data.Add("debug", Convert.ToBoolean(dtRoot_data.Rows[0]["debug"]));
                    //Dict_root_data.Add("config", "");
                    Dict_root_data.Add("calendar", Dict_root_data_calendar);


                  

                    //add json fro the rule setup
                    
                    AzureStorageRead azstorage = new AzureStorageRead();

                    foreach (DataRow drJsonTemplate in dtJsonTemplate.Rows)
                    {
                        string FileName = drJsonTemplate["DBFileName"].ToString();
                        #region rules
                        if (drJsonTemplate["key"].ToString() == "rules")
                        {
                            //objJsonResult.data.rules = azstorage.GetRuleJSONFileToAzureBlob(FileName).Replace( @"< br />", Environment.NewLine);
                            //==objJsonResult.data.rules = JsonConvert.DeserializeObject(azstorage.GetRuleJSONFileToAzureBlob(FileName));
                            string _fileContent = azstorage.GetRuleJSONFileToAzureBlob(FileName);
                           
                                _fileContent = Regex.Replace(_fileContent, @"\\r\\n", "");
                                _fileContent = Regex.Replace(_fileContent, @"\r\n", "");
                                _fileContent = Regex.Replace(_fileContent, @"\\""", "");
                                if (CommonHelper.ValidateJSON(_fileContent))
                                {
                                    var result = JsonConvert.DeserializeObject(_fileContent);
                                    Rootdict.Add("rules", result);
                                }
                                else
                                {
                                Rootdict.Add("rules", _fileContent);
                            }
                        }
                        #endregion

                        #region accounts
                        if (drJsonTemplate["key"].ToString() == "accounts")
                        {

                            //dynamic _accounts = JsonConvert.DeserializeObject(azstorage.GetRuleJSONFileToAzureBlob(FileName)); 
                            //objJsonResult.data.data.accounts = _accounts;
                            string _fileContent = azstorage.GetRuleJSONFileToAzureBlob(FileName);
                            _fileContent = Regex.Replace(_fileContent, @"\\r\\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\r\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\\""", "");
                            if (CommonHelper.ValidateJSON(_fileContent))
                            {
                                var result = JsonConvert.DeserializeObject(_fileContent);
                                Dict_root_data.Add("accounts", result);
                            }
                            else
                            {
                                Dict_root_data.Add("accounts", _fileContent);
                            }
                        }
                        #endregion

                        #region config
                        if (drJsonTemplate["key"].ToString() == "config")
                        {

                            //dynamic _config = JsonConvert.DeserializeObject(azstorage.GetRuleJSONFileToAzureBlob(FileName));
                            //objJsonResult.data.data.config = _config;
                            //objJsonResult.data.data.config = JsonConvert.DeserializeObject(azstorage.GetRuleJSONFileToAzureBlob(FileName));
                            string _fileContent = azstorage.GetRuleJSONFileToAzureBlob(FileName);
                            _fileContent = Regex.Replace(_fileContent, @"\\r\\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\r\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\\""", "");
                            if (CommonHelper.ValidateJSON(_fileContent))
                            {
                                var result = JsonConvert.DeserializeObject(_fileContent);
                                Dict_root_data.Add("config", result);
                            }
                            else
                            {
                                Dict_root_data.Add("config", _fileContent);
                            }
                        }
                        #endregion
                    }

                    //root
                    Rootdict.Add("engine", dtRoot.Rows[0]["engine"]);
                    Rootdict.Add("data", Dict_root_data);
                    //Rootdict.Add("rules", "");

                    #region root meta
                    dynamic meta = new ExpandoObject();
                    Dictionary<string, object> JsonRoot_meta = new Dictionary<string, object>();
                    JsonRoot_meta.Add("client_reference_id", Convert.ToString(dtRoot_data.Rows[0]["client_reference_id"]));
                    JsonRoot_meta.Add("batch", Convert.ToBoolean(dtRoot_data.Rows[0]["batch"]));
                    #endregion
                    #region json root 
                    JsonRoot_data.Add("meta", JsonRoot_meta);
                    JsonRoot_data.Add("data", Rootdict);
                    #endregion


                }

                var serialized = JsonConvert.SerializeObject(JsonRoot_data);
                objJsonResult = serialized;
                return objJsonResult;

               
            }
            catch (Exception ex)
            {
                objJsonResult = "exception";
                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.EquityCalculator.ToString(), "Error in generating json for for Equity ID= " + fundIDorName + " " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetLiabilityCalcRequestData", "", ex);
                return "EGcUUGNZDl1trzKiViRLs09icNapDW5x" + ex.Message.ToString();
            }
        }


        public List<JsonFormatCalcLiability> GetLiabilityCalcRequestForFeesAndInterest()
        {
            return _lbCalcRepository.GetLiabilityCalcRequestForFeesAndInterest(); ;
        }


        //recursive method to format Calc Liability json
        public dynamic GetChildDictionaryForInterestAndFee(IDictionary<String, Object> dictionary, List<JsonFormatCalcLiability> lstchild, List<JsonFormatCalcLiability> lstMain, DataRow drChild, DataSet dsCalJsonData,string dynamicKey,int rowIndex)
        {

            //for (int cnt = 0; cnt < dtChild.Rows.Count; cnt++)
            //{
            for (int i = 0; i < lstchild.Count(); i++)
            {
                if (lstchild[i].Key.ToLower() == "dynamic")
                {

                   // var dynamicField = drChild[lstchild[i].DynamicField];
                    DataTable dtChildinner = new DataTable();

                    dtChildinner = dsCalJsonData.Tables[lstchild[i].Position];

                    List<string> uniqueObjects = null;


                    if (!string.IsNullOrEmpty(lstchild[i].FilterBy))
                    {
                        string filterBy = Convert.ToString(drChild[lstchild[i].FilterBy]);

                        if (dsCalJsonData.Tables[lstchild[i].Position] != null && dsCalJsonData.Tables[lstchild[i].Position].Rows.Count > 0)
                        {
                            if (dsCalJsonData.Tables[lstchild[i].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'") != null
                                && dsCalJsonData.Tables[lstchild[i].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").Count() > 0
                                )
                            {
                                var filterStr = "" + lstchild[i].FilterBy + "= '" + filterBy + "'";
                                dtChildinner = dsCalJsonData.Tables[lstchild[i].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").CopyToDataTable();

                                
                            }
                        }

                        uniqueObjects = dtChildinner.AsEnumerable().Select(x => x.Field<string>("" + lstchild[i].DynamicField + "")).Distinct().ToList();

                    }


                   else if (string.IsNullOrEmpty(dynamicKey))
                    {
                        uniqueObjects = dtChildinner.AsEnumerable().Select(x => x.Field<string>("" + lstchild[i].DynamicField + "")).Distinct().ToList();
                    }
                    else
                    {
                        uniqueObjects = dtChildinner.AsEnumerable().Where(r => r.Field<string>("" + lstchild[i].DynamicField + "") == dynamicKey).Select(r => r.Field<string>("" + lstchild[i].DynamicFieldValue + "")).ToList();

                    }

                    //for (int j = 0; j < uniqueObjects.Count; j++)
                    //{
                    //    Dictionary<String, Object> dict = new Dictionary<String, Object>();
                    //    dictionary.Add(uniqueObjects[j], "");
                    //}
                    //
                    if (lstchild[i].KeyFormat.ToLower() == "variable")
                    {

                        //uniqueObjects = dtChildinner.AsEnumerable().Where(r => r.Field<string>("" + lstchild[i].ParentDynamicField + "") == dynamicKey).Select(r => r.Field<decimal>(""+ lstchild[i].DynamicFieldValue + "")).ToList();

                        var uniqueObjectsInnver = dtChildinner.AsEnumerable().Where(r => r.Field<string>("" + lstchild[i].ParentDynamicField + "") == dynamicKey).ToList();
                        //dictionary.Add(lstchild[i].Key, CommonHelper.convertValToProperFormat("9", lstchild[i].DataType.ToString()));
                        for (int ct = 0; ct < uniqueObjectsInnver.Count; ct++)
                        {
                            dictionary.Add(uniqueObjectsInnver[ct][lstchild[i].DynamicField].ToString(), CommonHelper.convertValToProperFormat(uniqueObjectsInnver[ct][lstchild[i].DynamicFieldValue], lstchild[i].DataType.ToString()));
                        }
                        
                       
                    }
                    else if (lstchild[i].KeyFormat.ToLower() == "json")
                    {

                        //if (!string.IsNullOrEmpty(lstchild[i].FilterBy))
                        //{
                        //    string filterBy = Convert.ToString(drChild[lstchild[i].FilterBy]);

                        //    if (dsCalJsonData.Tables[lstchild[i].Position] != null && dsCalJsonData.Tables[lstchild[i].Position].Rows.Count > 0)
                        //    {
                        //        if (dsCalJsonData.Tables[lstchild[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'") != null
                        //            && dsCalJsonData.Tables[lstchild[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").Count() > 0
                        //            )
                        //        {

                        //            dtChildinner = dsCalJsonData.Tables[lstchild[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").CopyToDataTable();
                        //        }
                        //    }

                        //    uniqueObjects = dtChildinner.AsEnumerable().Select(x => x.Field<string>("" + lstchild[i].DynamicField + "")).Distinct().ToList();

                        //}
                        
                        for (int j = 0; j < uniqueObjects.Count; j++)
                        {
                            Dictionary<String, Object> dict = new Dictionary<String, Object>();
                            List<IDictionary<String, Object>> lstDict = new List<IDictionary<string, object>>();
                            var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();

                            var lstpositions = lstchildinner.Select(i => i.Position);
                            if (uniqueObjects[j] == "05/04/2025")
                            {
                                string str11 = "";
                            }
                            
                            foreach (var item in lstpositions)
                            {
                                if  (dsCalJsonData.Tables[item]==null)
                                {
                                    lstchildinner = lstchildinner.Where(i => i.Position != item).ToList();
                                }
                            }


                            if (lstchildinner != null && lstchildinner.Count() > 0)
                            {
                                var lstchildinnerDistPosition = lstchildinner.Select(i => i.Position).Distinct();
                              
                                    foreach(string strTable in lstchildinnerDistPosition)
                                    {
                                        DataTable dtChildinnerinner = new DataTable();
                                        dtChildinnerinner = dsCalJsonData.Tables[strTable];

                                        var lstchildinnerDist = lstchildinner.Where(x => x.Position == strTable).ToList();
                                        DataRow drinner = dtChildinnerinner.Rows[j];
                                        //DataRow drinner = new DataTable().NewRow();

                                        if (lstchildinner[0].Key == "dynamic")
                                        {
                                            lstchildinner[0].ParentDynamicField = lstchild[i].DynamicField;
                                        lstDict.Add(GetChildDictionaryForInterestAndFee(dict, lstchildinnerDist, lstMain, drinner, dsCalJsonData, uniqueObjects[j], j));
                                        }
                                        else
                                        {
                                        lstDict.Add(GetChildDictionaryForInterestAndFee(dict, lstchildinnerDist, lstMain, drinner, dsCalJsonData, "", j));
                                        }

                                    }

                                dictionary.Add(uniqueObjects[j], lstDict);


                                    //DataRow drinner = new DataTable().NewRow();
                                    //Dictionary<String, Object> dictEmpty = new Dictionary<String, Object>();
                                    //dictionary.Add(uniqueObjects[j], dictEmpty);

                            }
                            else
                            {
                                DataRow drinner = new DataTable().NewRow();
                                Dictionary<String, Object> dictEmpty = new Dictionary<String, Object>();
                                dictionary.Add(uniqueObjects[j], dictEmpty);
                            }
                            dict = null;
                        }

                        
                    }
                    else if (lstchild[i].KeyFormat.ToLower() == "array")
                    {
                        var lstDict = new List<Dictionary<String, Object>>();
                        Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                        var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();
                        DataTable dtChildinnerinner = new DataTable();
                        if (lstchild[i].Position == "root.data.notes.LiabilityNote.effectivedate.amort_spread")
                        {
                            string str = "";
                        }

                        if (lstchildinner.Count() > 0)
                        {
                            if (!string.IsNullOrEmpty(lstchild[i].FilterBy))
                            {
                                string filterBy = Convert.ToString(drChild[lstchild[i].FilterBy]);

                                if (dsCalJsonData.Tables[lstchildinner[0].Position] != null && dsCalJsonData.Tables[lstchildinner[0].Position].Rows.Count > 0)
                                {
                                    if (dsCalJsonData.Tables[lstchildinner[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'") != null
                                        && dsCalJsonData.Tables[lstchildinner[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").Count() > 0
                                        )
                                    {

                                        dtChildinnerinner = dsCalJsonData.Tables[lstchildinner[0].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").CopyToDataTable();
                                    }
                                }
                            }
                            else
                            {
                                dtChildinnerinner = dsCalJsonData.Tables[lstchildinner[0].Position];
                            }
                        }
                        //dtChildinnerinner = dsCalJsonData.Tables[lstchildinner[0].Position];

                        //DataTable tblFiltered = dsCalJsonData.Tables[lstchildinner[0].Position].AsEnumerable()
                        //     .Where(r => r.Field<string>("AssetAccountID") == "45554FA8-C58C-4D9A-BEBE-99975F4F87E8")
                        //     .CopyToDataTable();

                        for (int cntAr = 0; cntAr < dtChildinnerinner.Rows.Count; cntAr++)
                        {
                            lstDict.Add(GetChildDictionaryForInterestAndFee(innerDictionary, lstchildinner, lstMain, dtChildinnerinner.Rows[cntAr], dsCalJsonData,"",0));
                            innerDictionary = new Dictionary<string, object>();
                        }
                        dictionary.Add(lstchild[i].Key, lstDict);
                        //


                    }

                    else if (lstchild[i].KeyFormat.ToLower() == "singlearray")
                    {

                        //var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();
                        //if (lstchildinner.Count() == 0)
                        //{
                        //    var EmptylstDict = new List<Dictionary<String, Object>>();
                        //    dictionary.Add(lstchild[i].Key, EmptylstDict);
                        //}

                        for (int cntAr = 0; cntAr < uniqueObjects.Count; cntAr++)
                        {
                            DataTable dtChild = new DataTable();
                            dtChild = dsCalJsonData.Tables[lstchild[i].Position];
                            //DataRow dr = dtChild.Rows[0];

                            if (lstchild[i].DataType.ToLower() == "int")
                            {
                                var arrsingle = dtChild.AsEnumerable().Where(r => r.Field<string>("" + lstchild[i].DynamicField + "") == uniqueObjects[cntAr]).Select(r => r.Field<int>("" + lstchild[i].DynamicFieldValue + "")).ToArray();
                                dictionary.Add(uniqueObjects[cntAr], arrsingle);
                            }
                            else if (lstchild[i].DataType.ToLower().StartsWith("nvarchar"))
                            {

                                var arrsingle = dtChild.AsEnumerable().Where(r => r.Field<string>("" + lstchild[i].DynamicField + "") == uniqueObjects[cntAr]).Select(r => r.Field<string>("" + lstchild[i].DynamicFieldValue + "")).ToArray();
                                dictionary.Add(uniqueObjects[cntAr], arrsingle);

                            }
                            else if (lstchild[i].DataType.ToLower().StartsWith("decimal"))
                            {

                                var arrsingle = dtChild.AsEnumerable().Where(r => r.Field<string>("" + lstchild[i].DynamicField + "") == uniqueObjects[cntAr]).Select(r => r.Field<decimal>("" + lstchild[i].DynamicFieldValue + "")).ToArray();
                                dictionary.Add(uniqueObjects[cntAr], arrsingle);

                            }
                            else
                            {
                                var arrsingle = dtChild.AsEnumerable().Where(r => r.Field<string>("" + lstchild[i].DynamicField + "") == uniqueObjects[cntAr]).Select(r => r.Field<string>("" + lstchild[i].DynamicFieldValue + "")).ToArray();
                                dictionary.Add(uniqueObjects[cntAr], arrsingle);
                            }
                        }
                    }
                    //


                }

                else

                {

                    if (lstchild[i].KeyFormat.ToLower() == "variable")
                    {
                        //DataTable dtvar = dsCalJsonData.Tables[lstchild[i].Position];
                        //DataRow dr = dtvar.Rows[0];

                        //dictionary.Add(lstchild[i].Key, CommonHelper.convertValToProperFormat("9", lstchild[i].DataType.ToString()));
                        dictionary.Add(lstchild[i].Key, CommonHelper.convertValToProperFormat(drChild[lstchild[i].Key], lstchild[i].DataType.ToString()));
                    }
                    else if (lstchild[i].KeyFormat.ToLower() == "json")
                    {
                        Dictionary<String, Object> dict = new Dictionary<String, Object>();
                        List<IDictionary<String, Object>> lstDict = new List<IDictionary<string, object>>();
                        var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();
                        if (lstchildinner != null && lstchildinner.Count() > 0)
                        {

                            var lstchildinnerDistPosition = lstchildinner.Select(i => i.Position).Distinct();

                            foreach (string strTable in lstchildinnerDistPosition)
                            {
                                DataTable dtChildinnerinner = new DataTable();
                                dtChildinnerinner = dsCalJsonData.Tables[strTable];

                                var lstchildinnerDist = lstchildinner.Where(x => x.Position == strTable).ToList();
                                DataRow drinner = dtChildinnerinner.Rows[0];
                                //DataRow drinner = new DataTable().NewRow();

                                if (lstchildinner[0].Key == "dynamic")
                                {
                                    lstDict.Add(GetChildDictionaryForInterestAndFee(dict, lstchildinnerDist, lstMain, drinner, dsCalJsonData, "", 0));
                                }
                                else
                                {
                                    lstDict.Add(dictionary.Add(lstchild[i].Key, GetChildDictionaryForInterestAndFee(dict, lstchildinnerDist, lstMain, drinner, dsCalJsonData, "", 0)));
                                }

                            }

                            dictionary.Add(lstchild[i].Key, lstDict);


                        }
                        else
                        {
                            DataRow drinner = new DataTable().NewRow();
                            Dictionary<String, Object> dictEmpty = new Dictionary<String, Object>();
                            dictionary.Add(lstchild[i].Key, dictEmpty);
                        }
                        dict = null;
                    }
                    else if (lstchild[i].KeyFormat.ToLower() == "array")
                    {
                        var lstDict = new List<Dictionary<String, Object>>();
                        Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                        var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();
                        DataTable dtChildinner = new DataTable();

                        if (lstchild[i].Position == "root.data.notes.LiabilityNote.effectivedate.amort_spread")
                        {
                            string str = "";
                        }
                        if (lstchildinner.Count() > 0)
                        {
                            if (!string.IsNullOrEmpty(lstchild[i].FilterBy))
                            {

                                var filterbysplit = lstchild[i].FilterBy.Split("|");
                               

                               if (dsCalJsonData.Tables[lstchildinner[0].Position] != null && dsCalJsonData.Tables[lstchildinner[0].Position].Rows.Count > 0)
                                   {
                                    dtChildinner = dsCalJsonData.Tables[lstchildinner[0].Position];

                                    for (int flt = 0; flt < filterbysplit.Length; flt++)
                                    {
                                        if (dtChildinner.Rows.Count > 0)
                                        {
                                            string filterBy = Convert.ToString(drChild[filterbysplit[flt]]);

                                            if (filterBy =="LN_DT_ACPII_23-0814_")
                                                {
                                                
                                                string tst = "sss";
                                            
                                            }
                                            
                                            if (dtChildinner.Select("" + filterbysplit[flt] + "= '" + filterBy + "'") != null
                                                && dtChildinner.Select("" + filterbysplit[flt] + "= '" + filterBy + "'").Count() > 0
                                                )
                                            {

                                                dtChildinner = dtChildinner.Select("" + filterbysplit[flt] + "= '" + filterBy + "'").CopyToDataTable();
                                            }
                                            else
                                            {
                                                dtChildinner = new DataTable();
                                            }
                                            
                                        }
                                    }
                                }
                               
                            }
                            else
                            {
                                dtChildinner = dsCalJsonData.Tables[lstchildinner[0].Position];
                            }
                        }
                        //dtChildinner = dsCalJsonData.Tables[lstchildinner[0].Position];

                        //DataTable tblFiltered = dsCalJsonData.Tables[lstchildinner[0].Position].AsEnumerable()
                        //     .Where(r => r.Field<string>("AssetAccountID") == "45554FA8-C58C-4D9A-BEBE-99975F4F87E8")
                        //     .CopyToDataTable();

                        for (int cntAr = 0; cntAr < dtChildinner.Rows.Count; cntAr++)
                        {
                            lstDict.Add(GetChildDictionaryForInterestAndFee(innerDictionary, lstchildinner, lstMain, dtChildinner.Rows[cntAr], dsCalJsonData, "", 0));
                            innerDictionary = new Dictionary<string, object>();
                        }
                        if (lstchild[i].IsOptional == false || lstDict.Count > 0)
                        {
                            dictionary.Add(lstchild[i].Key, lstDict);
                        }
                        
                        //


                    }

                    else if (lstchild[i].KeyFormat.ToLower() == "singlearray")
                    {

                        var lstchildinner = lstMain.Where(x => x.ParentID == lstchild[i].JsonFormatCalcLiabilityID).ToList();
                        if (lstchildinner.Count() == 0)
                        {
                            var EmptylstDict = new List<Dictionary<String, Object>>();
                            dictionary.Add(lstchild[i].Key, EmptylstDict);
                        }

                        for (int cntAr = 0; cntAr < lstchildinner.Count; cntAr++)
                        {
                            DataTable dtChild = new DataTable();
                            dtChild = dsCalJsonData.Tables[lstchildinner[cntAr].Position];
                            //DataRow dr = dtChild.Rows[0];

                            if (!string.IsNullOrEmpty(lstchildinner[cntAr].DynamicFieldValue))
                            {

                                if (lstchildinner[cntAr].DataType.ToLower() == "int")
                                {
                                    var arrsingle = dtChild.AsEnumerable().Select(r => r.Field<int>("" + lstchildinner[cntAr].DynamicFieldValue + "")).ToArray();

                                    dictionary.Add(lstchild[i].Key, arrsingle);
                                }
                                else if (lstchildinner[cntAr].DataType.ToLower().StartsWith("nvarchar"))
                                {

                                    var arrsingle = dtChild.AsEnumerable().Select(r => r.Field<string>("" + lstchildinner[cntAr].DynamicFieldValue + "")).ToArray();
                                    dictionary.Add(lstchild[i].Key, arrsingle);

                                }
                                else if (lstchildinner[cntAr].DataType.ToLower().StartsWith("decimal"))
                                {

                                    var arrsingle = dtChild.AsEnumerable().Select(r => r.Field<decimal>("" + lstchildinner[cntAr].DynamicFieldValue + "")).ToArray();
                                    dictionary.Add(lstchild[i].Key, arrsingle);

                                }
                            }
                        }
                    }


                }
                
            }
            return dictionary;
        }

        public bool QueueLiabilityForCalculation(List<CalculationRequestsLiabilityDataContract> list, string username)
        {
            return _lbCalcRepository.QueueLiabilityForCalculation(list, username);
        }


        public void UpdateCalculationStatusandTime(string calcid, string statustext, string columnname, string errmsg, string requestId,int calculationModeID)
        {
            _lbCalcRepository.UpdateCalculationStatusandTime(calcid, statustext, columnname, errmsg, requestId,calculationModeID);
        }

        public List<LiabilityCalcDataContract> GetCalculationStaus(Guid analysisID)
        {
            return _lbCalcRepository.GetCalculationStaus(analysisID);
        }
        public List<LiabilityCalcDataContract> GetLiabilityCalculationStatusForDashBoard(Guid analysisID)
        {
            return _lbCalcRepository.GetLiabilityCalculationStatusForDashBoard(analysisID);
        }
        public DataTable GetLiabilitySummaryDashBoard()
        {
            return _lbCalcRepository.GetLiabilitySummaryDashBoard();
        }

        public dynamic GetLiabilityCalcRequestForFees(string userID, string fundIDorName, string analysisID, bool? isTestRequest = false)
        {


            dynamic objJsonResult = null;

            Dictionary<String, Object> Rootdict = new Dictionary<String, Object>();
            Dictionary<String, Object> JsonRoot_data = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_calendar = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_effective_dates = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_notes = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_liabilitynote_notebalance = new Dictionary<String, Object>();
            Dictionary<String, Object> Dict_root_data_liabilitynote_effectivedate = new Dictionary<String, Object>();
            Dictionary<String, Object> config_fee_config = new Dictionary<string, object>();


            try
            {

                if (string.IsNullOrEmpty(fundIDorName))
                {
                    return objJsonResult;
                }
                DataSet dsCalJsonData = new DataSet();

                //get the json data from db
                dsCalJsonData = _lbCalcRepository.GetLiabilityFeesCalcRequestData("", fundIDorName, analysisID);


                if (dsCalJsonData.Tables.Count > 0)
                {
                    DataTable dtRoot = dsCalJsonData.Tables["root"];
                    DataTable dtRoot_data = dsCalJsonData.Tables["root.data"];
                    DataTable dtRoot_data_calendar = dsCalJsonData.Tables["root.data.calendar"];
                    DataTable dtRoot_data_effective_dates = dsCalJsonData.Tables["root.data.effective_dates"];
                    DataTable dtRoot_data_notes = dsCalJsonData.Tables["root.data.notes"];
                    DataTable dtRoot_data_listfeefunctions = dsCalJsonData.Tables["root.data.listfeefunctions"];
                    DataTable dtRoot_data_liabilityNote_notebalance = dsCalJsonData.Tables["root.data.notes.Facility.notebalance"];
                    DataTable dtRoot_data_liabilityNote_effectivedate = dsCalJsonData.Tables["root.data.notes.Facility.effectivedate"];
                    DataTable dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetail = dsCalJsonData.Tables["root.data.notes.Facility.effectivedate.FacilityDetails"];
                    DataTable dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetailByEffectiveDate = dsCalJsonData.Tables["root.data.notes.Facility.effectivedate.FacilityDetailsByEffectiveDate"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_fee = dsCalJsonData.Tables["root.data.notes.Facility.effectivedate.fees"];
                    DataTable dtRoot_data_notes_liabilityNote_effectivedate_fee_feeperconfig = dsCalJsonData.Tables["root.data.notes.Facility.effectivedate.fees.feeperconfig"];
                    DataTable dtRoot_data_notes_liabilityNote_CommitmentAmtbyEffectivedate = dsCalJsonData.Tables["root.data.notes.Facility.CommitmentAmtbyEffectivedate"];
                    

                    DataTable dtdata_config_fee_config = dsCalJsonData.Tables["root.data.config.fee.config"];

                    DataTable dtJsonTemplate = dsCalJsonData.Tables["JsonTemplate"];




                    // stop calc process when fetch cancel calc status
                    //if (dtDataRootinfo.Rows[0]["CalcStatus"].ToString() == "736")
                    //{
                    //    dynamic objJsonRes;
                    //    objJsonRes = dtDataRootinfo.Rows[0]["CalcStatus"].ToInt32();
                    //    return objJsonRes;
                    //}

                    if (isTestRequest == false)
                    {
                        ////code call for manage isCalcCancel
                        if (dtRoot_data.Rows[0]["isCalcCancel"].ToBoolean() == true)
                        {
                            dynamic objJsonRes;
                            objJsonRes = dtRoot_data.Rows[0]["isCalcCancel"].ToInt32();
                            return objJsonRes;
                        }
                        //code call for manage duplicate entry (isCalcStarted) 
                        if (dtRoot_data.Rows[0]["isCalcStarted"].ToBoolean() == true)
                        {
                            dynamic objJsonRes;
                            objJsonRes = dtRoot_data.Rows[0]["isCalcStarted"].ToInt32();
                            return objJsonRes;
                        }
                    }


                    string[] arrEffectiveDates = null;

                    //root.data.effective_dates

                    //root.data.calendar
                    if (dtRoot_data_effective_dates.Rows.Count > 0)
                    {
                        arrEffectiveDates = dtRoot_data_effective_dates.AsEnumerable().Select(r => r.Field<string>("effective_dates")).ToArray();

                    }

                    //root.data.calendar
                    if (dtRoot_data_calendar.Rows.Count > 0)
                    {
                        var uniqueObjects = dtRoot_data_calendar.AsEnumerable().Select(x => x.Field<string>("HolidayTypeText")).Distinct().ToList();
                        for (int i = 0; i < uniqueObjects.Count; i++)
                        {
                            //dtChildinner = dsCalJsonData.Tables[lstchild[i].Position].Select("" + lstchild[i].FilterBy + "= '" + filterBy + "'").CopyToDataTable();

                            var arrsingle = dtRoot_data_calendar.Select("HolidayTypeText='" + uniqueObjects[i] + "'").AsEnumerable().Select(r => r.Field<string>("HoliDayDate")).ToArray();

                            Dict_root_data_calendar.Add(uniqueObjects[i], arrsingle);
                        }
                    }

                    //root.data.notes
                    if (dtRoot_data_notes.Rows.Count > 0)
                    {

                        for (int i = 0; i < dtRoot_data_notes.Rows.Count; i++)
                        {
                            Dictionary<String, Object> Dict_root_data_notes_inner = new Dictionary<String, Object>();
                            Dict_root_data_notes_inner.Add("id", dtRoot_data_notes.Rows[i]["id"]);
                            Dict_root_data_notes_inner.Add("name", dtRoot_data_notes.Rows[i]["name"]);
                            Dict_root_data_notes_inner.Add("fundaccountid", dtRoot_data_notes.Rows[i]["FundAccountID"]);
                            Dict_root_data_notes_inner.Add("liabilitytypeid", dtRoot_data_notes.Rows[i]["liabilityTypeID"]);
                            //Dict_root_data_notes_inner.Add("liabilitynoteaccountid", dtRoot_data_notes.Rows[i]["LiabilityNoteAccountID"]);


                            if (dtRoot_data_liabilityNote_notebalance != null && dtRoot_data_liabilityNote_notebalance.Rows.Count > 0)
                            {
                                var dt_notebalance = dtRoot_data_liabilityNote_notebalance.Select("AccountID='" + dtRoot_data_notes.Rows[i]["liabilityTypeID"] + "'");
                                if (dt_notebalance.Count() > 0)
                                {
                                    var details = (from r in dt_notebalance.AsEnumerable()
                                                   select new
                                                   {
                                                       Date = r.Field<string>("Date"),
                                                       TransactionAmount = r.Field<Decimal?>("TransactionAmount"),
                                                       TransactionType = r.Field<string>("TransactionType"),
                                                       EndingBalance = r.Field<Decimal?>("EndingBalance"),
                                                   });
                                    Dict_root_data_notes_inner.Add("notebalance", details);
                                }
                                else
                                {
                                    Dict_root_data_notes_inner.Add("notebalance", "");
                                }
                            }
                            else
                            {
                                Dict_root_data_notes_inner.Add("notebalance", "");
                            }


                            // //root.data.notes.LiabilityNote.effectivedate
                            if (dtRoot_data_liabilityNote_effectivedate.Rows.Count > 0)
                            {
                                var dtEffeDates = dtRoot_data_liabilityNote_effectivedate.Select("liabilityTypeID='" + dtRoot_data_notes.Rows[i]["liabilityTypeID"] + "'");
                                if (dtEffeDates.Count() > 0)
                                {
                                    var dtEffectiveDates = dtEffeDates.CopyToDataTable();



                                    for (int j = 0; j < dtEffectiveDates.Rows.Count; j++)
                                    {
                                        Dictionary<String, Object> Dict_root_data_notes_inner_inner = new Dictionary<String, Object>();
                                        if (j == 0)
                                        {
                                            var dt_liabilityNoteDetail = dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetail.Select("liabilityTypeID='" + dtRoot_data_notes.Rows[i]["liabilityTypeID"] + "'");

                                            if (dt_liabilityNoteDetail.Count() > 0)
                                            {
                                                var dtliabilityNoteDetail = dt_liabilityNoteDetail.CopyToDataTable();
                                                
                                                Dict_root_data_notes_inner_inner.Add("payfreq", dtliabilityNoteDetail.Rows[0]["payfreq"]);
                                                Dict_root_data_notes_inner_inner.Add("accenddatebusidaylag", dtliabilityNoteDetail.Rows[0]["accenddatebusidaylag"]);
                                                Dict_root_data_notes_inner_inner.Add("accfreq", dtliabilityNoteDetail.Rows[0]["accfreq"]);
                                                Dict_root_data_notes_inner_inner.Add("roundmethod", dtliabilityNoteDetail.Rows[0]["roundmethod"]);
                                                Dict_root_data_notes_inner_inner.Add("precision", dtliabilityNoteDetail.Rows[0]["precision"]);
                                                Dict_root_data_notes_inner_inner.Add("financingspreadrate", dtliabilityNoteDetail.Rows[0]["FinancingSpreadRate"]);
                                                Dict_root_data_notes_inner_inner.Add("intactmethod", dtliabilityNoteDetail.Rows[0]["intactmethod"]);
                                                Dict_root_data_notes_inner_inner.Add("defaultindexnm", dtliabilityNoteDetail.Rows[0]["defaultindexnm"]);
                                                Dict_root_data_notes_inner_inner.Add("targetadvrate", dtliabilityNoteDetail.Rows[0]["targetadvrate"]);
                                                Dict_root_data_notes_inner_inner.Add("pmtdtaccper", dtliabilityNoteDetail.Rows[0]["pmtdtaccper"]);
                                                Dict_root_data_notes_inner_inner.Add("resetindexdaily", dtliabilityNoteDetail.Rows[0]["ResetIndexDaily"]);
                                                Dict_root_data_notes_inner_inner.Add("pydt_detdt_hlday_ls", dtliabilityNoteDetail.Rows[0]["pydt_detdt_hlday_ls"]);
                                                Dict_root_data_notes_inner_inner.Add("clsdt", dtliabilityNoteDetail.Rows[0]["clsdt"]);
                                                Dict_root_data_notes_inner_inner.Add("initmatdt", dtliabilityNoteDetail.Rows[0]["initmatdt"]);
                                           
                                            }
                                        }

                                        if (dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetailByEffectiveDate != null && dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetailByEffectiveDate.Rows.Count > 0)
                                        {
                                            var dt_liabilityNoteDetailByEffectiveDate = dtRoot_data_liabilityNote_effectivedate_liabilityNoteDetailByEffectiveDate.Select("liabilityTypeID='" + dtRoot_data_notes.Rows[i]["liabilityTypeID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_liabilityNoteDetailByEffectiveDate.Count() > 0)
                                            {
                                                var dtliabilityNoteDetailByEffectiveDate = dt_liabilityNoteDetailByEffectiveDate.CopyToDataTable();
                                                Dict_root_data_notes_inner_inner.Add("initaccenddt", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initaccenddt"]);
                                                Dict_root_data_notes_inner_inner.Add("paydatebusiessdaylag", dtliabilityNoteDetailByEffectiveDate.Rows[0]["paydatebusiessdaylag"]);
                                                Dict_root_data_notes_inner_inner.Add("leaddays", dtliabilityNoteDetailByEffectiveDate.Rows[0]["leaddays"]);
                                                Dict_root_data_notes_inner_inner.Add("determidayrefdayofmnth", dtliabilityNoteDetailByEffectiveDate.Rows[0]["determidayrefdayofmnth"]);
                                                Dict_root_data_notes_inner_inner.Add("accperpaydaywhennoteomnth", dtliabilityNoteDetailByEffectiveDate.Rows[0]["accperpaydaywhennoteomnth"]);
                                                Dict_root_data_notes_inner_inner.Add("initindex", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initindex"]);
                                                Dict_root_data_notes_inner_inner.Add("initresetdt", dtliabilityNoteDetailByEffectiveDate.Rows[0]["initresetdt"]);

                                            }

                                            var dt_liabilityNoteCommitmentAmtbyEffectivedate = dtRoot_data_notes_liabilityNote_CommitmentAmtbyEffectivedate.Select("liabilityTypeID='" + dtRoot_data_notes.Rows[i]["liabilityTypeID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            if (dt_liabilityNoteCommitmentAmtbyEffectivedate.Count() > 0)
                                            {
                                                var dtliabilityNoteCommitmentAmtbyEffectivedate = dt_liabilityNoteCommitmentAmtbyEffectivedate.CopyToDataTable();
                                             if (string.IsNullOrEmpty(dtliabilityNoteCommitmentAmtbyEffectivedate.Rows[0]["commitmentamt"].ToString()))
                                                {
                                                    Dict_root_data_notes_inner_inner.Add("commitmentamt", 0);
                                                }
                                                else
                                                {
                                                    Dict_root_data_notes_inner_inner.Add("commitmentamt", dtliabilityNoteCommitmentAmtbyEffectivedate.Rows[0]["commitmentamt"]);
                                                }
                                            }
                                            else
                                            {
                                                Dict_root_data_notes_inner_inner.Add("commitmentamt", 0);
                                            }

                                        }


                                        if (dtRoot_data_notes_liabilityNote_effectivedate_fee != null && dtRoot_data_notes_liabilityNote_effectivedate_fee.Rows.Count > 0)
                                        {
                                            var dt_fee = dtRoot_data_notes_liabilityNote_effectivedate_fee.Select("liabilityTypeID='" + dtRoot_data_notes.Rows[i]["liabilityTypeID"] + "' AND EffectiveDate='" + dtEffectiveDates.Rows[j]["EffectiveDate"] + "'");
                                            List<Dictionary<String, Object>> Dict_root_data_notes_inner_inner_inner = new List<Dictionary<string, object>>();
                                            Dictionary<String, Object> Dict_root_data_notes_inner_inner_inner_inner = null;

                                            if (dt_fee.Count() > 0)
                                            {
                                                var dtfee = dt_fee.CopyToDataTable();


                                                for (int k = 0; k < dtfee.Rows.Count; k++)
                                                {
                                                    Dict_root_data_notes_inner_inner_inner_inner = new Dictionary<string, object>();
                                                    var dtfee_feeperconfig = dtRoot_data_notes_liabilityNote_effectivedate_fee_feeperconfig.Select("feescheduleid='" + dtfee.Rows[k]["feescheduleid"] + "'");
                                                    if (dtfee_feeperconfig.Count() > 0)
                                                    {
                                                        
                                                        var feedetails = (from r in dtfee_feeperconfig.AsEnumerable()
                                                                          select new
                                                                          {
                                                                              From = r.Field<Decimal?>("From"),
                                                                              To = r.Field<Decimal?>("To"),
                                                                              Value = r.Field<Decimal?>("Value"),

                                                                          });
                                                        Dict_root_data_notes_inner_inner_inner_inner.Add("feeperconfig", feedetails);
                                                    }
                                                    else
                                                    {
                                                        Dict_root_data_notes_inner_inner_inner_inner.Add("feeperconfig", "");


                                                    }
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("feename", dtfee.Rows[k]["feename"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("startdt", dtfee.Rows[k]["startdt"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("enddt", dtfee.Rows[k]["enddt"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("type", dtfee.Rows[k]["type"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("valtype", dtfee.Rows[k]["valtype"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("val", dtfee.Rows[k]["val"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("ovrfeeamt", dtfee.Rows[k]["ovrfeeamt"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("ovrbaseamt", dtfee.Rows[k]["ovrbaseamt"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("trueupflag", dtfee.Rows[k]["trueupflag"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("levyldincl", dtfee.Rows[k]["levyldincl"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("basisincl", dtfee.Rows[k]["basisincl"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("stripval", dtfee.Rows[k]["stripval"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("actual_startdt", dtfee.Rows[k]["actual_startdt"]);
                                                    Dict_root_data_notes_inner_inner_inner_inner.Add("feescheduleid", dtfee.Rows[k]["feescheduleid"]);
                                                    Dict_root_data_notes_inner_inner_inner.Add(Dict_root_data_notes_inner_inner_inner_inner);
                                                }

                                                Dict_root_data_notes_inner_inner.Add("fee", Dict_root_data_notes_inner_inner_inner);


                                            }
                                            //else
                                            //{
                                            //    Dict_root_data_notes_inner_inner.Add("fee", "");
                                            //}
                                        }
                                        else
                                        {

                                            Dict_root_data_notes_inner_inner.Add("fee", "");
                                        }


                                        Dict_root_data_notes_inner.Add(Convert.ToString(dtEffectiveDates.Rows[j]["EffectiveDate"]), Dict_root_data_notes_inner_inner);
                                    }
                                }



                            }



                            Dict_root_data_notes.Add(Convert.ToString(dtRoot_data_notes.Rows[i]["name"]), Dict_root_data_notes_inner);

                        }

                    }

                    if (dtRoot_data_listfeefunctions != null && dtRoot_data_listfeefunctions.Rows.Count > 0)
                    {
                            var details = (from r in dtRoot_data_listfeefunctions.AsEnumerable()
                                           select new
                                           {
                                               FunctionNameID = r.Field<int>("FunctionNameID"),
                                               FunctionGuID = r.Field<Guid?>("FunctionGuID"),
                                               FunctionNameText = r.Field<string>("FunctionNameText"),
                                               FunctionTypeText = r.Field<string>("FunctionTypeText"),
                                               FunctionTypeID = r.Field<int>("FunctionTypeID"),
                                               PaymentFrequencyText = r.Field<string>("PaymentFrequencyText"),
                                               PaymentFrequencyID = r.Field<int?>("PaymentFrequencyID"),
                                               AccrualBasisText = r.Field<string>("AccrualBasisText"),
                                               AccrualBasisID = r.Field<int?>("AccrualBasisID"),
                                               AccrualStartDateText = r.Field<string>("AccrualStartDateText"),
                                               AccrualStartDateID = r.Field<int?>("AccrualStartDateID"),
                                               AccrualPeriodText = r.Field<string>("AccrualPeriodText"),
                                               AccrualPeriodID = r.Field<int?>("AccrualPeriodID"),
                                               LookupID = r.Field<int?>("LookupID"),
                                               Name = r.Field<string>("Name"),
                                               IsUsedInFeeSchedule = (r.Field<int?>("IsUsedInFeeSchedule")==1)?true:false,
                                           });
                        Dict_root_data.Add("lstfeefunctions", details);
                    }


                    ////root.data 
                    Dict_root_data.Add("period_start_date", Convert.ToString(dtRoot_data.Rows[0]["period_start_date"]));
                    Dict_root_data.Add("effective_dates", arrEffectiveDates);
                    Dict_root_data.Add("period_end_date", Convert.ToString(dtRoot_data.Rows[0]["period_end_date"]));
                    Dict_root_data.Add("root_note_id", Convert.ToString(dtRoot_data.Rows[0]["root_note_id"]));
                    Dict_root_data.Add("analysisid", Convert.ToString(dtRoot_data.Rows[0]["AnalysisID"]));
                    //Dict_root_data.Add("accounts", "");
                    Dict_root_data.Add("calc_basis", Convert.ToBoolean(dtRoot_data.Rows[0]["calc_basis"]));
                    Dict_root_data.Add("notes", Dict_root_data_notes);
                    Dict_root_data.Add("debug", Convert.ToBoolean(dtRoot_data.Rows[0]["debug"]));
                    //Dict_root_data.Add("config", "");
                    Dict_root_data.Add("calendar", Dict_root_data_calendar);




                    //add json fro the rule setup

                    AzureStorageRead azstorage = new AzureStorageRead();

                    foreach (DataRow drJsonTemplate in dtJsonTemplate.Rows)
                    {
                        string FileName = drJsonTemplate["DBFileName"].ToString();
                        #region rules
                        if (drJsonTemplate["key"].ToString() == "fee_rules")
                        {
                            //objJsonResult.data.rules = azstorage.GetRuleJSONFileToAzureBlob(FileName).Replace( @"< br />", Environment.NewLine);
                            //==objJsonResult.data.rules = JsonConvert.DeserializeObject(azstorage.GetRuleJSONFileToAzureBlob(FileName));
                            string _fileContent = azstorage.GetRuleJSONFileToAzureBlob(FileName);

                            _fileContent = Regex.Replace(_fileContent, @"\\r\\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\r\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\\""", "");
                            if (CommonHelper.ValidateJSON(_fileContent))
                            {
                                var result = JsonConvert.DeserializeObject(_fileContent);
                                Rootdict.Add("rules", result);
                            }
                            else
                            {
                                Rootdict.Add("rules", _fileContent);
                            }
                        }
                        #endregion

                        #region accounts
                        if (drJsonTemplate["key"].ToString() == "fee_accounts")
                        {

                            //dynamic _accounts = JsonConvert.DeserializeObject(azstorage.GetRuleJSONFileToAzureBlob(FileName)); 
                            //objJsonResult.data.data.accounts = _accounts;
                            string _fileContent = azstorage.GetRuleJSONFileToAzureBlob(FileName);
                            _fileContent = Regex.Replace(_fileContent, @"\\r\\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\r\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\\""", "");
                            if (CommonHelper.ValidateJSON(_fileContent))
                            {
                                var result = JsonConvert.DeserializeObject(_fileContent);
                                Dict_root_data.Add("accounts", result);
                            }
                            else
                            {
                                Dict_root_data.Add("accounts", _fileContent);
                            }
                        }
                        #endregion

                        #region config
                        if (drJsonTemplate["key"].ToString() == "fee_config")
                        {

                            //dynamic _config = JsonConvert.DeserializeObject(azstorage.GetRuleJSONFileToAzureBlob(FileName));
                            //objJsonResult.data.data.config = _config;
                            //objJsonResult.data.data.config = JsonConvert.DeserializeObject(azstorage.GetRuleJSONFileToAzureBlob(FileName));
                            string _fileContent = azstorage.GetRuleJSONFileToAzureBlob(FileName);
                            _fileContent = Regex.Replace(_fileContent, @"\\r\\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\r\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\\""", "");
                            if (CommonHelper.ValidateJSON(_fileContent))
                            {
                                var result = JsonConvert.DeserializeObject(_fileContent);
                                
                                Dict_root_data.Add("config", result);
                            }
                            else
                            {
                                Dict_root_data.Add("config", _fileContent);
                            }
                        }
                        #endregion
                    }

                    #region  config from db
                    
                    DataTable dt_config_distinct_name;

                    dt_config_distinct_name = dtdata_config_fee_config.DefaultView.ToTable(true, "feename", "type", "frequency", "Coverage", "function");


                    
                    for (int i = 0; i < dt_config_distinct_name.Rows.Count; i++)
                    {
                        Dictionary<String, Object> config_fee_config_inner = new Dictionary<String, Object>();

                        if (dt_config_distinct_name.Rows[i]["type"] != null)
                        {
                            config_fee_config_inner.Add("type", dt_config_distinct_name.Rows[i]["type"]);
                        }
                        if (dt_config_distinct_name.Rows[i]["frequency"] != null)
                        {
                            config_fee_config_inner.Add("frequency", dt_config_distinct_name.Rows[i]["frequency"]);
                        }

                        if (dt_config_distinct_name.Rows[i]["Coverage"] != null)
                        {
                            config_fee_config_inner.Add("coverage", dt_config_distinct_name.Rows[i]["Coverage"]);

                        }
                        if (dt_config_distinct_name.Rows[i]["function"] != null)
                        {
                            config_fee_config_inner.Add("function", dt_config_distinct_name.Rows[i]["function"]);
                        }

                        DataTable dtAccount = dtdata_config_fee_config.Select("feename ='" + dt_config_distinct_name.Rows[i]["feename"] + "'").CopyToDataTable();

                        if (dtAccount != null && dtAccount.Rows.Count > 0)
                        {
                            string[] arrAccount = new string[dtAccount.Rows.Count];
                            int j = 0;
                            foreach (DataRow dr in dtAccount.Rows)
                            {
                                arrAccount[j++] = dr["Account"].ToString();
                            }

                            config_fee_config_inner.Add("accounts", arrAccount);
                        }

                        config_fee_config.Add(dt_config_distinct_name.Rows[i]["feename"].ToString(), config_fee_config_inner);
                        //config_fee_config_main.Add(config_fee_config);
                    }
                   // Dict_root_data.Add("config_fee_config", config_fee_config);

                    //dynamic confignew = new ExpandoObject();

                    //objJsonResult.data.data.config.fee.confignew= config_fee;

                    #endregion

                    //root
                    Rootdict.Add("engine", dtRoot.Rows[0]["engine"]);
                    Rootdict.Add("data", Dict_root_data);
                    //Rootdict.Add("rules", "");

                    #region root meta
                    dynamic meta = new ExpandoObject();
                    Dictionary<string, object> JsonRoot_meta = new Dictionary<string, object>();
                    JsonRoot_meta.Add("client_reference_id", Convert.ToString(dtRoot_data.Rows[0]["client_reference_id"]));
                    JsonRoot_meta.Add("batch", Convert.ToBoolean(dtRoot_data.Rows[0]["batch"]));
                    #endregion
                    #region json root 
                    JsonRoot_data.Add("meta", JsonRoot_meta);
                    JsonRoot_data.Add("data", Rootdict);
                    #endregion


                }

                var serialized = JsonConvert.SerializeObject(JsonRoot_data);
                JObject obj = JObject.Parse(serialized);

                

                if (obj["data"]["data"]["config"] != null)
                {
                    if (obj["data"]["data"]["config"]["fee"] != null)
                    {
                        string feejson = JsonConvert.SerializeObject(config_fee_config);
                        JObject feejsonobj = JObject.Parse(feejson);
                        obj["data"]["data"]["config"]["fee"]["config"] = feejsonobj;

                    }
                    else
                    {
                        Dictionary<String, Object> Dict_root_data_data_config_fee = new Dictionary<String, Object>();
                        Dictionary<String, Object> Dict_root_data_data_config_fee_config = new Dictionary<String, Object>();
                        Dict_root_data_data_config_fee.Add("fee", config_fee_config);
                        Dict_root_data_data_config_fee_config.Add("config", Dict_root_data_data_config_fee);
                        string feejson = JsonConvert.SerializeObject(Dict_root_data_data_config_fee_config);
                        JObject feejsonobj = JObject.Parse(feejson);
                        obj["data"]["data"]["config"] = feejsonobj;
                    }
                
                }
                objJsonResult = JsonConvert.SerializeObject(obj);

                //string feejson = JsonConvert.SerializeObject(config_fee_config);
                //objJsonResult.data.data.config.fee.config = JsonConvert.DeserializeObject(feejson);
                return objJsonResult;


            }
            catch (Exception ex)
            {
                objJsonResult = "exception";
                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.EquityCalculator.ToString(), "Error in generating json for for Equity ID= " + fundIDorName + " " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetLiabilityCalcRequestData", "", ex);
                return "EGcUUGNZDl1trzKiViRLs09icNapDW5x" + ex.Message.ToString();
            }
        }


    }
}
