using Azure;
using CRES.DAL.Repository;
using CRES.DataContract;
using CRES.DataContract.Liability;
using CRES.Utilities;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Dynamic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;

namespace CRES.BusinessLogic
{
    public class V1CalcLogic
    {
        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
        Microsoft.Extensions.Configuration.IConfigurationSection Sectionroot = null;
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

        private V1CalcRepository _v1CalcRepository = new V1CalcRepository();

        public DataSet GetCalcRequestData(string objectID, int objectTypeId, string userID, string analysisID, int CalcType)
        {
            return _v1CalcRepository.GetCalcRequestData(objectID, objectTypeId, userID, analysisID, CalcType); ;
        }

        public int InsertUpdateNotePeriodicCalc(DataTable dtperiodicoutput, string AnalysisID, string CreatedBy, string crenoteid)
        {
            return _v1CalcRepository.InsertUpdateNotePeriodicCalc(dtperiodicoutput, AnalysisID, CreatedBy, crenoteid);
        }

        public int InsertTransactionEntry(DataTable dtTransactionsoutput, string AnalysisID, string CreatedBy, string crenoteid, string StrCreatedBy, string noteid, DateTime? LastAccountingCloseDate)
        {
            return _v1CalcRepository.InsertTransactionEntry(dtTransactionsoutput, AnalysisID, CreatedBy, crenoteid, StrCreatedBy, noteid, LastAccountingCloseDate);
        }
        public int UpdateTransactionEntryCash_NonCash(string NoteId, string AnalysisID, DateTime LastAccountingclosedate, DateTime? MaturityUsedInCalc)
        {
            return _v1CalcRepository.UpdateTransactionEntryCash_NonCash(NoteId, AnalysisID, LastAccountingclosedate, MaturityUsedInCalc);
        }

        public List<V1CalculationStatusDataContract> GetAllDealsProcessingstatus()
        {
            return _v1CalcRepository.GetAllDealsProcessingstatus();
        }

        public void UpdateCalculationRequestsStatus(string dealid, string RequestID, int Status, string AnalysisID, string UserID, string errmsg)
        {
            _v1CalcRepository.UpdateCalculationRequestsStatus(dealid, RequestID, Status, AnalysisID, UserID, errmsg);
        }
        public void InsertIntoCalculatorExtensionDbSave(string NoteID, string AnalysisID, string RequestID, string FileName, int ServerFileCount)
        {
            _v1CalcRepository.InsertIntoCalculatorExtensionDbSave(NoteID, AnalysisID, RequestID, FileName, ServerFileCount);
        }
        public int InsertPayRuleDistribution(DataTable dtoutput, string AnalysisID, string CreatedBy)
        {
            return _v1CalcRepository.InsertPayRuleDistribution(dtoutput, AnalysisID, CreatedBy);
        }

        public dynamic GetDealCalcRequestData(string objectID, int objectTypeId, string analysisID, int CalcType, bool? batchType = false, bool? isTestRequest = false)
        {
            DateTime? prepaydate = DateTime.MinValue;
            string MaturityScenarioOverridetext = "";
            DataSet dsCalcInfo = new DataSet();
            DataTable dtDataRootinfo = new DataTable();
            DataTable dtNotes_Root = new DataTable();
            DataTable dtDataEffective_dates = new DataTable();
            DataTable dtdataStructure = new DataTable();
            DataTable dtDataRulesetsPay = new DataTable();
            DataTable dtData_notes_setup = new DataTable();
            DataTable dtdata_notes_setup_dictionary = new DataTable();
            DataTable dtdata_notes_spread = new DataTable();
            DataTable dtdata_notes_index_floor = new DataTable();
            DataTable dtdata_notes_rate = new DataTable();
            DataTable dtdata_notes_coupon_floor = new DataTable();
            DataTable dtdata_notes_coupon_cap = new DataTable();
            DataTable dtdata_notes_index_cap = new DataTable();
            DataTable dtdata_notes_amort_rate = new DataTable();
            DataTable dtdata_notes_amort_spread = new DataTable();
            DataTable dtdata_notes_amort_rate_floor = new DataTable();
            DataTable dtdata_notes_amort_rate_cap = new DataTable();
            DataTable dtdata_notes_reference_rate = new DataTable();

            DataTable dtdata_notes_setup_tables_fees = new DataTable();
            DataTable dtdata_notes_setup_tables_fee_stripping = new DataTable();
            DataTable dtdata_notes_fee_strip_received = new DataTable();
            DataTable dtdata_notes_actuals = new DataTable();

            DataTable dtdata_deal_setup_tables_funding = new DataTable();

            DataTable dtdata_notes_setup_tables_funding = new DataTable();
            DataTable dtdata_notes_setup_tables_noteperiodiccal = new DataTable();
            DataTable dtdata_notes_setup_tables_amsch = new DataTable();
            DataTable dtdata_notes_setup_tables_pikrate = new DataTable();
            DataTable dtdata_notes_setup_tables_piksch = new DataTable();
            DataTable dtdata_notes_notebalance = new DataTable();
            DataTable dtdata_notes_PrepayScheduleDict = new DataTable();
            DataTable dtdata_notes_NoteAdjustedCommitment = new DataTable();
            DataTable dtdata_notes_maturity = new DataTable();

            DataTable dtdata_notes_SpreadMaintenanceSchedule = new DataTable();
            DataTable dtdata_notes_PrepayAdjustment = new DataTable();
            DataTable dtdata_notes_MinMultSchedule = new DataTable();
            DataTable dtdata_notes_FeeCredits = new DataTable();
            DataTable dtdata_notes_notecommitment = new DataTable();
            DataTable dtdata_notes_cashflow = new DataTable();
            //DataTable dtdata_notes_noteperiodiccalc = new DataTable();

            DataTable dtJsonTemplate = new DataTable();
            DataTable dtdata_index = new DataTable();
            DataTable dtdata_calendars = new DataTable();
            DataTable dtdata_Json_Info = new DataTable();
            DataTable dtJsonFormat = new DataTable();
            DataTable dtMaturityScenarios = new DataTable();

            DataTable dtdata_notes_watchlist = new DataTable();
            DataTable dtdata_feefunctions = new DataTable();

            DataTable dtdata_config_fee_config = new DataTable();

            V1CalcLogic v1CalcLogic = new V1CalcLogic();

            dynamic objJsonResult;
            try
            {
                dsCalcInfo = v1CalcLogic.GetCalcRequestData(objectID, objectTypeId, "", analysisID, CalcType);

                dtDataRootinfo = dsCalcInfo.Tables["data.rootinfo"];

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
                    if (dtDataRootinfo.Rows[0]["isCalcCancel"].ToBoolean() == true)
                    {
                        dynamic objJsonRes;
                        objJsonRes = dtDataRootinfo.Rows[0]["isCalcCancel"].ToInt32();
                        return objJsonRes;
                    }
                    //code call for manage duplicate entry (isCalcStarted) 
                    if (dtDataRootinfo.Rows[0]["isCalcStarted"].ToBoolean() == true)
                    {
                        dynamic objJsonRes;
                        objJsonRes = dtDataRootinfo.Rows[0]["isCalcStarted"].ToInt32();
                        return objJsonRes;
                    }
                }


                if (dtDataRootinfo.Rows[0]["MaturityScenarioOverride"] != null)
                {
                    MaturityScenarioOverridetext = dtDataRootinfo.Rows[0]["MaturityScenarioOverride"].ToString();
                }

                dtNotes_Root = dsCalcInfo.Tables["data.notes"];
                dtDataEffective_dates = dsCalcInfo.Tables["data.effective_dates"];
                dtdataStructure = dsCalcInfo.Tables["data.structure"];
                dtDataRulesetsPay = dsCalcInfo.Tables["data.rulesets.pay"];
                dtData_notes_setup = dsCalcInfo.Tables["data.notes.setup"];
                dtdata_notes_setup_dictionary = dsCalcInfo.Tables["data.notes.setup.dictionary"];
                dtdata_notes_spread = dsCalcInfo.Tables["data.notes.spread"];
                dtdata_notes_index_floor = dsCalcInfo.Tables["data.notes.index_floor"];
                dtdata_notes_rate = dsCalcInfo.Tables["data.notes.rate"];
                dtdata_notes_coupon_floor = dsCalcInfo.Tables["data.notes.coupon_floor"];
                dtdata_notes_coupon_cap = dsCalcInfo.Tables["data.notes.coupon_cap"];
                dtdata_notes_index_cap = dsCalcInfo.Tables["data.notes.index_cap"];
                dtdata_notes_amort_rate = dsCalcInfo.Tables["data.notes.amort_rate"];
                dtdata_notes_amort_spread = dsCalcInfo.Tables["data.notes.amort_spread"];
                dtdata_notes_amort_rate_floor = dsCalcInfo.Tables["data.notes.amort_rate_floor"];
                dtdata_notes_amort_rate_cap = dsCalcInfo.Tables["data.notes.amort_rate_cap"];
                dtdata_notes_reference_rate = dsCalcInfo.Tables["data.notes.reference_rate"];

                dtdata_notes_setup_tables_fees = dsCalcInfo.Tables["data.notes.setup.tables.fees"];
                dtdata_notes_setup_tables_fee_stripping = dsCalcInfo.Tables["data.notes.setup.tables.fee_stripping"];
                dtdata_notes_fee_strip_received = dsCalcInfo.Tables["data.notes.fee_strip_received"];
                dtdata_notes_actuals = dsCalcInfo.Tables["data.notes.actuals"];
                dtdata_notes_watchlist = dsCalcInfo.Tables["data.notes.svrwatchlist"];

                dtdata_deal_setup_tables_funding = dsCalcInfo.Tables["data.deal.setup.tables.funding"];

                dtdata_notes_setup_tables_funding = dsCalcInfo.Tables["data.notes.setup.tables.funding"];
                dtdata_notes_setup_tables_noteperiodiccal = dsCalcInfo.Tables["data.notes.noteperiodiccalc"]; //dsCalcInfo.Tables["data.notes.noteperiodiccal"];
                dtdata_notes_setup_tables_amsch = dsCalcInfo.Tables["data.notes.setup.tables.amsch"];
                dtdata_notes_setup_tables_pikrate = dsCalcInfo.Tables["data.notes.setup.tables.pikrate"];
                dtdata_notes_setup_tables_piksch = dsCalcInfo.Tables["data.notes.setup.tables.piksch"];

                dtdata_notes_notebalance = dsCalcInfo.Tables["data.notes.notebalance"];
                dtdata_notes_PrepayScheduleDict = dsCalcInfo.Tables["data.notes.PrepayScheduleDict"];
                dtdata_notes_NoteAdjustedCommitment = dsCalcInfo.Tables["data.notes.NoteAdjustedCommitment"];
                dtdata_notes_maturity = dsCalcInfo.Tables["data.notes.maturity"];

                dtdata_notes_SpreadMaintenanceSchedule = dsCalcInfo.Tables["data.notes.SpreadMaintenanceSchedule"];
                dtdata_notes_PrepayAdjustment = dsCalcInfo.Tables["data.notes.PrepayAdjustment"];
                dtdata_notes_MinMultSchedule = dsCalcInfo.Tables["data.notes.MinMultSchedule"];
                dtdata_notes_FeeCredits = dsCalcInfo.Tables["data.notes.FeeCredits"];
                dtdata_notes_notecommitment = dsCalcInfo.Tables["data.notes.notecommitment"];
                dtdata_notes_cashflow = dsCalcInfo.Tables["data.notes.cashflow"];
                //dtdata_notes_noteperiodiccalc = dsCalcInfo.Tables["data.notes.noteperiodiccalc"];

                dtJsonTemplate = dsCalcInfo.Tables["JsonTemplate"];
                dtdata_index = dsCalcInfo.Tables["data.index"];
                dtdata_calendars = dsCalcInfo.Tables["data.calendars"];
                dtdata_feefunctions = dsCalcInfo.Tables["data.listfeefunctions"];
                dtdata_Json_Info = dsCalcInfo.Tables["Json_Info"];
                dtJsonFormat = dsCalcInfo.Tables["JsonFormat"];

                dtdata_config_fee_config = dsCalcInfo.Tables["data.config.fee.config"];

                if (dtdata_notes_setup_dictionary.Rows[0]["prepaydate"] != null)
                {
                    prepaydate = CommonHelper.ToDateTime(dtdata_notes_setup_dictionary.Rows[0]["prepaydate"]);
                }
                rootData data1 = new rootData();

                /*
                data1.period_end_date = dtDataRootinfo.Rows[0]["period_end_date"].ToString();
                data1.period_start_date = dtDataRootinfo.Rows[0]["period_start_date"].ToString();
                data1.root_note_id = dtDataRootinfo.Rows[0]["root_note_id"].ToString();         

                data1.calc_basis = dtDataRootinfo.Rows[0]["calc_basis"].ToBoolean();
                data1.calc_deffee_basis = dtDataRootinfo.Rows[0]["calc_deffee_basis"].ToBoolean();
                data1.calc_disc_basis = dtDataRootinfo.Rows[0]["calc_disc_basis"].ToBoolean();
                data1.calc_capcosts_basis = dtDataRootinfo.Rows[0]["calc_capcosts_basis"].ToBoolean();
                data1.init_logging = dtDataRootinfo.Rows[0]["init_logging"].ToBoolean();
                */

                //data1.rulesets.pay
                Rulesets rulesets = new Rulesets();
                List<Pay> pay = new List<Pay>();
                foreach (DataRow dr in dtDataRulesetsPay.Rows)
                {
                    Pay _pay = new Pay();
                    _pay.description = "Pay " + Convert.ToDecimal(dr["weight"].ToString()) * 100 + "% to " + dr["note"].ToString() + " if total funding <= " + dr["cumulative_threshold"].ToString();  //"Pay 50% to 14310 if total funding <= $22125000",
                    _pay.condition = "@cumulative < " + dr["cumulative_threshold"].ToString();

                    Config config = new Config();
                    config.cumulative_threshold = dr["cumulative_threshold"].ToString();
                    config.note = dr["note"].ToString();
                    config.weight = dr["weight"].ToString();
                    _pay.config = config;

                    pay.Add(_pay);
                }

                //data1.rulesets.pay.Add(pay);
                rulesets.pay = pay;
                data1.rulesets = rulesets;

                #region notes
                if (dtDataRootinfo.Rows[0]["ExcludedForcastedPrePaymentText"].ToString() == "Y")
                {
                    NoteDataContract notedc = new NoteDataContract();
                    List<FutureFundingScheduleTab> ListFutureFundingScheduleTab = new List<FutureFundingScheduleTab>();

                    foreach (DataRow dr_dtdata_notes_setup_tables_funding in dtdata_notes_setup_tables_funding.Rows)
                    {
                        //dr_dtdata_notes_setup_tables_funding[]
                        FutureFundingScheduleTab futureFundingScheduleTab = new FutureFundingScheduleTab();
                        futureFundingScheduleTab.Date = dr_dtdata_notes_setup_tables_funding["dt"].ToDateTime();
                        futureFundingScheduleTab.EffectiveDate = dr_dtdata_notes_setup_tables_funding["EffectiveDate"].ToDateTime();
                        futureFundingScheduleTab.PurposeID = dr_dtdata_notes_setup_tables_funding["Purpose"].ToInt32();
                        futureFundingScheduleTab.PurposeText = dr_dtdata_notes_setup_tables_funding["PurposeText"].ToString();
                        futureFundingScheduleTab.Value = dr_dtdata_notes_setup_tables_funding["fundpydn"].ToDecimal();
                        futureFundingScheduleTab.CRENotedID = dr_dtdata_notes_setup_tables_funding["CRENoteID"].ToString();
                        futureFundingScheduleTab.NoteID = new Guid(dr_dtdata_notes_setup_tables_funding["noteid"].ToString());
                        futureFundingScheduleTab.noncommitmentadj = dr_dtdata_notes_setup_tables_funding["noncommitmentadj"].ToString();
                        futureFundingScheduleTab.adjustmenttype = dr_dtdata_notes_setup_tables_funding["adjustmenttype"].ToString();

                        ListFutureFundingScheduleTab.Add(futureFundingScheduleTab);
                    }

                    DataTable dtdata_notes_setup_tables_funding_new = dtdata_notes_setup_tables_funding.Clone();


                    //call Scenariorules for every notes
                    for (int i = 0; i < dtNotes_Root.Rows.Count; i++)

                    {
                        if (dtNotes_Root.Rows[i]["type"].ToString() == "legal")
                        {
                            ScenarioParameterDataContract defaultScenarioParameters = new ScenarioParameterDataContract();
                            defaultScenarioParameters.ExcludedForcastedPrePaymentText = "Y";
                            notedc.DefaultScenarioParameters = defaultScenarioParameters; //dtDataRootinfo.Rows[0]["ExcludedForcastedPrePaymentText"].ToString();
                            notedc.ListFutureFundingScheduleTab = ListFutureFundingScheduleTab.Where(x => x.CRENotedID == dtNotes_Root.Rows[i]["id"].ToString()).ToList();
                            NoteDataContract _notedc = ScenarioRules.ApplyExcludedForcastedPrePaymentRule(notedc);


                            foreach (var _futureFundingScheduleTab in _notedc.ListFutureFundingScheduleTab)
                            {

                                DataRow dr = dtdata_notes_setup_tables_funding_new.NewRow();
                                dr["dt"] = Convert.ToDateTime(_futureFundingScheduleTab.Date).ToString("MM/dd/yyyy");
                                dr["EffectiveDate"] = Convert.ToDateTime(_futureFundingScheduleTab.EffectiveDate).ToString("MM/dd/yyyy");
                                dr["Purpose"] = _futureFundingScheduleTab.PurposeID;
                                dr["PurposeText"] = _futureFundingScheduleTab.PurposeText;
                                dr["fundpydn"] = _futureFundingScheduleTab.Value;
                                dr["CRENoteID"] = dtNotes_Root.Rows[i]["id"].ToString(); //_futureFundingScheduleTab.CRENotedID;
                                dr["noteid"] = dtNotes_Root.Rows[i]["objectguid"].ToString(); //_futureFundingScheduleTab.NoteID; 
                                dr["noncommitmentadj"] = _futureFundingScheduleTab.noncommitmentadj;
                                dr["adjustmenttype"] = _futureFundingScheduleTab.adjustmenttype;

                                dtdata_notes_setup_tables_funding_new.Rows.Add(dr);
                            }

                            // add new effective dates to effective date list
                            List<EffectiveDateList> effectdatelist = new List<EffectiveDateList>();
                            var itemsNew = _notedc.ListFutureFundingScheduleTab.Select(x => Convert.ToDateTime(x.EffectiveDate).ToString("MM-dd-yyyy")).Distinct().ToArray();
                            if (itemsNew.Length > 0)
                            {
                                var itemsOriginal = dtDataEffective_dates.Rows.OfType<DataRow>().Select(k => Convert.ToDateTime(k[0]).ToString("MM-dd-yyyy")).ToArray();
                                var itemsNeedToAdd = itemsNew.Except(itemsOriginal).ToArray();
                                itemsNeedToAdd = itemsNeedToAdd.Select(s => Convert.ToDateTime(s).Month.ToString("00")
                                + "/" + Convert.ToDateTime(s).Day.ToString("00") + "/" + Convert.ToDateTime(s).Year).ToArray();

                                Array.ForEach(itemsNeedToAdd, c => dtDataEffective_dates.Rows.Add()[0] = c);

                                dtDataEffective_dates.Columns.Add("ef_dt_dateformat", typeof(DateTime));
                                foreach (DataRow dr_row in dtDataEffective_dates.Rows)
                                {
                                    dr_row[1] = Convert.ToDateTime(dr_row[0]);
                                }
                                dtDataEffective_dates = dtDataEffective_dates.AsEnumerable().OrderBy(r => r.Field<DateTime>("ef_dt_dateformat")).CopyToDataTable();
                                dtDataEffective_dates.Columns.Remove("ef_dt_dateformat");

                                //dtData_notes_setup
                                foreach (var item in itemsNeedToAdd)
                                {
                                    DataRow drNotes_setup = dtData_notes_setup.NewRow();
                                    drNotes_setup["CRENoteID"] = dtNotes_Root.Rows[i]["id"].ToString();
                                    drNotes_setup["noteid"] = dtNotes_Root.Rows[i]["objectguid"].ToString();
                                    drNotes_setup["effective_dates"] = Convert.ToDateTime(item).ToString("MM/dd/yyyy");

                                    dtData_notes_setup.Rows.Add(drNotes_setup);
                                }
                            }

                            //MaturityScenariosList
                            //              MaturityScenarioOverridetext = dtDataRootinfo.Rows[0]["MaturityScenarioOverride"].ToString();
                            int? totalCount = 0;
                            int matadjmonth = 0;
                            if (dtdata_notes_setup_dictionary != null)
                            {
                                if (dtdata_notes_setup_dictionary.Rows.Count > 0)
                                {
                                    matadjmonth = Convert.ToInt16(dtdata_notes_setup_dictionary.Rows[0]["matadjmonth"]);
                                }
                            }

                            NoteDataContract _noteCalculatorDC = new NoteDataContract();

                            NoteLogic nlogic = new NoteLogic();
                            ScenarioLogic _sl = new ScenarioLogic();
                            _noteCalculatorDC.DefaultScenarioParameters = _sl.GetActiveScenarioParameters(new Guid(analysisID));
                            _noteCalculatorDC.MaturityScenariosListFromDatabase = nlogic.GetMaturityPeriodicDataByNoteId(new Guid(dtNotes_Root.Rows[i]["objectguid"].ToString()), new Guid("B0E6697B-3534-4C09-BE0A-04473401AB93"), 0, 0, out totalCount);
                            _noteCalculatorDC.MaturityAdjMonthsOverride = matadjmonth;
                            _noteCalculatorDC.PrepayDate = prepaydate;
                            _noteCalculatorDC = ScenarioRules.AssignValuesToSelectedMaturityUsingDealSetup(_noteCalculatorDC, MaturityScenarioOverridetext);
                            // samart has to add code here
                            dtMaturityScenarios = ObjToDataTable.ConvertToDataTable(_noteCalculatorDC.MaturityScenariosList);

                            //CRENoteID already exists in dtMaturityScenarios
                            //==dtMaturityScenarios.Columns.Add("CRENoteID", typeof(string));
                            //assign noteid
                            foreach (DataRow dr_row in dtMaturityScenarios.Rows)
                            {
                                dr_row["CRENoteID"] = dtNotes_Root.Rows[i]["id"].ToString();
                                dr_row["noteid"] = dtNotes_Root.Rows[i]["objectguid"].ToString();
                            }
                        }
                    }

                    //remove existing  and assign latest fundings
                    dtdata_notes_setup_tables_funding = dtdata_notes_setup_tables_funding_new;


                }

                dynamic notes = new ExpandoObject();

                for (int i = 0; i < dtNotes_Root.Rows.Count; i++)
                {
                    dynamic setup = new ExpandoObject();
                    dynamic effevtiveDt = new ExpandoObject();
                    dynamic tables = new ExpandoObject();
                    dynamic spread = new ExpandoObject();

                    IDictionary<string, object> innerData = (IDictionary<string, object>)notes;
                    IDictionary<string, object> innerData_Deal_date = (IDictionary<string, object>)setup;

                    Dictionary<String, Object> notes_Deal = new Dictionary<String, Object>()
                    {
                        ["id"] = dtNotes_Root.Rows[i]["id"].ToString(),
                        ["name"] = dtNotes_Root.Rows[i]["name"].ToString(),
                        ["type"] = dtNotes_Root.Rows[i]["type"].ToString()
                        //["setup"] = setup
                    };


                    //Code for Deal & Effective dates
                    if (dtNotes_Root.Rows[i]["type"].ToString() == "wholenote")
                    {
                        notes_Deal.Add("prepaydate", dtNotes_Root.Rows[i]["prepaydate"].ToString());

                        foreach (DataRow dr_dtDataEffective_dates in dtDataEffective_dates.Rows)
                        {
                            Dictionary<String, Object> notes_Deal_setup_dictionary = new Dictionary<String, Object>();
                            var lstPrepayAdjustment = new List<Dictionary<String, Object>>();
                            var lstFeeCredits = new List<Dictionary<String, Object>>();
                            var lstMinMultSchedule = new List<Dictionary<String, Object>>();
                            var lstSpreadMaintenanceSchedule = new List<Dictionary<String, Object>>();


                            #region PrepayScheduleDict

                            if (dtdata_notes_PrepayScheduleDict != null)
                            {
                                foreach (DataRow dr_dtdata_notes_PrepayScheduleDict in dtdata_notes_PrepayScheduleDict.Rows)
                                {
                                    if ((dr_dtDataEffective_dates["effective_dates"].ToString() == dr_dtdata_notes_PrepayScheduleDict["EffectiveDate_Prepay"].ToString()))
                                    {
                                        foreach (DataColumn dc in dtdata_notes_PrepayScheduleDict.Columns)
                                        {
                                            string _key = dc.ColumnName;
                                            foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                            {
                                                if (drJsonFormat["Type"].ToString() == "PrepayPremium" && drJsonFormat["key"].ToString() == _key)
                                                {
                                                    //var _value = dr_dtdata_notes_PrepayScheduleDict[dc];
                                                    dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_PrepayScheduleDict[dc], drJsonFormat["DataType"].ToString());
                                                    notes_Deal_setup_dictionary.Add(_key, _value);
                                                }
                                            }
                                        }
                                    }
                                }

                            }

                            #endregion

                            //dtdata_notes_PrepayAdjustment
                            #region "PrepayAdjustment"
                            if (dtdata_notes_PrepayAdjustment != null)
                            {
                                foreach (DataRow dr_dtdata_notes_PrepayAdjustment in dtdata_notes_PrepayAdjustment.Rows)
                                {
                                    if ((dr_dtDataEffective_dates["effective_dates"].ToString() == dr_dtdata_notes_PrepayAdjustment["EffectiveDate_Prepay"].ToString()))
                                    {
                                        Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                        foreach (DataColumn dc in dtdata_notes_PrepayAdjustment.Columns)
                                        {
                                            string _key = dc.ColumnName;
                                            foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                            {

                                                if (drJsonFormat["Type"].ToString() == "tbl_PrepayAdjustment" && drJsonFormat["key"].ToString() == _key)
                                                {
                                                    dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_PrepayAdjustment[dc], drJsonFormat["DataType"].ToString());
                                                    innerDictionary.Add(_key, _value);

                                                }
                                            }
                                        }
                                        lstPrepayAdjustment.Add(innerDictionary);
                                    }
                                }
                            }

                            if (lstPrepayAdjustment.Count > 0)
                            {
                                notes_Deal_setup_dictionary.Add("PrepayAdjustment", lstPrepayAdjustment);
                            }
                            #endregion

                            #region "FeeCredits"
                            if (dtdata_notes_FeeCredits != null)
                            {
                                foreach (DataRow dr_dtdata_notes_FeeCredits in dtdata_notes_FeeCredits.Rows)
                                {
                                    if ((dr_dtDataEffective_dates["effective_dates"].ToString() == dr_dtdata_notes_FeeCredits["EffectiveDate_Prepay"].ToString()))
                                    {
                                        Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                        foreach (DataColumn dc in dtdata_notes_FeeCredits.Columns)
                                        {
                                            string _key = dc.ColumnName;
                                            foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                            {

                                                if (drJsonFormat["Type"].ToString() == "tbl_FeeCredits" && drJsonFormat["key"].ToString() == _key)
                                                {
                                                    dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_FeeCredits[dc], drJsonFormat["DataType"].ToString());
                                                    innerDictionary.Add(_key, _value);

                                                }
                                            }
                                        }
                                        lstFeeCredits.Add(innerDictionary);
                                    }
                                }
                            }

                            if (lstFeeCredits.Count > 0)
                            {
                                notes_Deal_setup_dictionary.Add("FeeCredits", lstFeeCredits);
                            }
                            #endregion

                            //dtdata_notes_MinMultSchedule
                            #region "MinMultSchedule"
                            if (dtdata_notes_MinMultSchedule != null)
                            {
                                foreach (DataRow dr_dtdata_notes_MinMultSchedule in dtdata_notes_MinMultSchedule.Rows)
                                {
                                    if ((dr_dtDataEffective_dates["effective_dates"].ToString() == dr_dtdata_notes_MinMultSchedule["EffectiveDate_Prepay"].ToString()))
                                    {
                                        Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                        foreach (DataColumn dc in dtdata_notes_MinMultSchedule.Columns)
                                        {
                                            string _key = dc.ColumnName;
                                            foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                            {

                                                if (drJsonFormat["Type"].ToString() == "tbl_MinMultSchedule" && drJsonFormat["key"].ToString() == _key)
                                                {
                                                    dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_MinMultSchedule[dc], drJsonFormat["DataType"].ToString());
                                                    innerDictionary.Add(_key, _value);

                                                }
                                            }
                                        }
                                        lstMinMultSchedule.Add(innerDictionary);
                                    }
                                }
                            }

                            if (lstMinMultSchedule.Count > 0)
                            {
                                notes_Deal_setup_dictionary.Add("MinMultSchedule", lstMinMultSchedule);
                            }
                            #endregion

                            //dtdata_notes_SpreadMaintenance
                            #region "Prepayment SpreadMaintenanceSchedule"
                            if (dtdata_notes_SpreadMaintenanceSchedule != null)
                            {
                                foreach (DataRow dr_dtdata_notes_SpreadMaintenanceSchedule in dtdata_notes_SpreadMaintenanceSchedule.Rows)
                                {
                                    if ((dr_dtDataEffective_dates["effective_dates"].ToString() == dr_dtdata_notes_SpreadMaintenanceSchedule["EffectiveDate_Prepay"].ToString()))
                                    {
                                        Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                        foreach (DataColumn dc in dtdata_notes_SpreadMaintenanceSchedule.Columns)
                                        {
                                            string _key = dc.ColumnName;
                                            foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                            {

                                                if (drJsonFormat["Type"].ToString() == "tbl_SpreadMaintenanceSchedule" && drJsonFormat["key"].ToString() == _key && drJsonFormat["IsActive"].ToInt32() == 1)
                                                {
                                                    dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_SpreadMaintenanceSchedule[dc], drJsonFormat["DataType"].ToString());
                                                    innerDictionary.Add(_key, _value);

                                                }
                                            }

                                        }
                                        lstSpreadMaintenanceSchedule.Add(innerDictionary);
                                    }
                                }
                            }

                            if (lstSpreadMaintenanceSchedule.Count > 0)
                            {
                                notes_Deal_setup_dictionary.Add("SpreadMaintenanceSchedule", lstSpreadMaintenanceSchedule);
                            }
                            #endregion

                            if (notes_Deal_setup_dictionary.Count > 0)
                            {
                                notes_Deal.Add(dr_dtDataEffective_dates["effective_dates"].ToString(), ObjToCsv.DictionaryToObject(notes_Deal_setup_dictionary));
                            }
                        }

                    }

                    //code for Note & Effective datas
                    //dtData_notes_setup
                    int chkNote_effectiveDt_First_dictionary = 1;
                    foreach (DataRow dr_dtData_notes_setup in dtData_notes_setup.Rows)
                    {
                        //if ((dr_dtData_notes_setup["CRENoteId"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString() && i > 0) || (i == 0 && chkNote_effectiveDt_First_dictionary == 1)) // i==0 -> for Deal
                        if ((dr_dtData_notes_setup["CRENoteId"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString())) // i==0 -> for Deal
                        {
                            IDictionary<string, object> innerData_Deal_dictionary = new Dictionary<string, object>(); //(IDictionary<string, object>)effevtiveDt;
                            IDictionary<string, object> innerData_Notes_tables = new Dictionary<string, object>();
                            var innerData_Notes_tables_spread = new Dictionary<string, List<Dictionary<string, object>>>();
                            //var lstTableRates = new List<Dictionary<string, object>>();

                            //since notes_Deal_setup_dictionary table contain only Notes dates and we also use assign first row for Deal 
                            int row_dictionary = i;
                            if (row_dictionary > 0)
                            {
                                row_dictionary--;
                            }
                            if (chkNote_effectiveDt_First_dictionary == 1)
                            {
                                chkNote_effectiveDt_First_dictionary = 0;

                                //JsonFormat
                                Dictionary<String, Object> notes_Deal_setup_dictionary = new Dictionary<String, Object>();
                                foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                {
                                    if (drJsonFormat["Type"].ToString() == "dictionary")
                                    {
                                        string _key = drJsonFormat["key"].ToString();
                                        dynamic _value = CommonHelper.convertValforjson(dtdata_notes_setup_dictionary.Rows[row_dictionary][_key], drJsonFormat["DataType"].ToString());
                                        notes_Deal_setup_dictionary.Add(_key, _value);

                                    }
                                }
                                if (MaturityScenarioOverridetext == "Prepay Date")
                                {

                                    if (prepaydate != null && prepaydate != DateTime.MinValue)
                                    {
                                        if (notes_Deal_setup_dictionary.ContainsKey("initmatdt") && Convert.ToBoolean(notes_Deal_setup_dictionary["initmatdt"]))
                                        {
                                            notes_Deal_setup_dictionary["initmatdt"] = prepaydate.Value.ToString("MM/dd/yyyy");
                                        }
                                        else
                                        {
                                            notes_Deal_setup_dictionary.Add("initmatdt", prepaydate.Value.ToString("MM/dd/yyyy"));

                                        }

                                        if (notes_Deal_setup_dictionary.ContainsKey("contractmat") && Convert.ToBoolean(notes_Deal_setup_dictionary["contractmat"]))
                                        {
                                            notes_Deal_setup_dictionary["contractmat"] = prepaydate.Value.ToString("MM/dd/yyyy");
                                        }
                                        else
                                        {
                                            notes_Deal_setup_dictionary.Add("contractmat", prepaydate.Value.ToString("MM/dd/yyyy"));

                                        }
                                    }
                                }
                                /*
                                Dictionary<String, Object> notes_Deal_setup_dictionary1 = new Dictionary<String, Object>()
                                {

                                    ["clsdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["clsdt"].ToString(),
                                    ["initbal"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initbal"],
                                    ["matdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["matdt"].ToString(),
                                    ["initaccenddt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initaccenddt"].ToString(),
                                    ["initpmtdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initpmtdt"].ToString(),
                                    ["ioterm"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["ioterm"],
                                    ["amterm"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["amterm"],
                                    ["totalcmt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["totalcmt"],
                                    ["leaddays"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["leaddays"],
                                    ["initresetdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initresetdt"].ToString(),
                                    ["initindexovrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initindexovrd"],
                                    ["roundmethod"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["roundmethod"].ToString().ToUpper(),
                                    ["precision"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["precision"],
                                    ["discount"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["discount"],
                                    ["stubintovrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["stubintovrd"],

                                    ["loanpurchase"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["loanpurchase"].ToString(),
                                    ["purintovrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["purintovrd"],
                                    //["insvrpayoverinlvly"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["insvrpayoverinlvly"].ToString(),
                                    ["intcalcrulepydn"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["intcalcrulepydn"].ToString(),
                                    ["capclscost"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["capclscost"],
                                    //["busidayrelapmtdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["busidayrelapmtdt"],
                                    ["dd_dom"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["dd_dom"],
                                    ["accfreq"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["accfreq"],
                                    //["determidtinterestaccper"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["determidtinterestaccper"],
                                    ["determidayrefdayofmnth"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["determidayrefdayofmnth"],
                                    ["rateindexresetfreq"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["rateindexresetfreq"],
                                    ["accperpaydaywhennoteomnth"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["accperpaydaywhennoteomnth"],
                                    ["payfreq"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["payfreq"],
                                    ["pmtdtbusdaylag"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["pmtdtbusdaylag"],
                                    ["stubpaidadv"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["stubpaidadv"].ToString(),
                                    ["finalintaccenddtvrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["finalintaccenddtvrd"].ToString(),
                                    ["stubonff"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["stubonff"].ToString(),
                                    ["monamovrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["monamovrd"],
                                    ["fixamsch"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["fixamsch"].ToString(),
                                    ["amintcalcdaycnt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["amintcalcdaycnt"],
                                    ["pikinteraddedtoblsbusiadvdate"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["pikinteraddedtoblsbusiadvdate"].ToString(),
                                    ["piksepcompoundingflg"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["piksepcompoundingflg"].ToString(),
                                    ["intcalcruleforam"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["intcalcruleforam"].ToString(),
                                };
                                */

                                //==innerData_Deal_dictionary.Add("dictionary", ObjToCsv.DictionaryToObject(notes_Deal_setup_dictionary));
                                //lstTableRates.Add(notes_Deal_setup_dictionary);
                                //innerData_Notes_tables_spread.Add(ObjToCsv.DictionaryToObject(notes_Deal_setup_dictionary))
                                //fee related code
                                if ((dr_dtData_notes_setup["CRENoteId"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                {
                                    //var innerData_Notes_tables_spread = new Dictionary<string, List<Dictionary<string, object>>>()//;
                                    var lstFees = new List<Dictionary<string, object>>();
                                    var lstfee_stripping = new List<Dictionary<string, object>>();
                                    var lstfee_strip_received = new List<Dictionary<string, object>>();
                                    var lstdata_notes_actuals = new List<Dictionary<string, object>>();
                                    var lstdtdata_notes_watchlist = new List<Dictionary<string, object>>();

                                    var lstnotes_funding = new List<Dictionary<string, object>>();
                                    var lstnotes_noteperiodiccal = new List<Dictionary<string, object>>();
                                    var lstnotes_amsch = new List<Dictionary<string, object>>();
                                    var lstnotes_pikrate = new List<Dictionary<string, object>>();
                                    var lstnotes_piksch = new List<Dictionary<string, object>>();
                                    var lstmaturity_scenarios = new List<Dictionary<string, object>>();
                                    var lstSpreadMaintenanc = new List<Dictionary<String, object>>();
                                    var lstPrepayAdjustment = new List<Dictionary<String, Object>>();
                                    var lstMinMultSchedule = new List<Dictionary<String, Object>>();
                                    var lstFeeCredits = new List<Dictionary<String, Object>>();
                                    var lstcashflow = new List<Dictionary<String, Object>>();
                                    var lstnoteperiodiccalc = new List<Dictionary<String, Object>>();
                                    var lstnotecommitment = new List<Dictionary<String, Object>>();
                                    var lstnotebalance = new List<Dictionary<String, Object>>();

                                    #region PrepayScheduleDict
                                    /*
                                    if (dtdata_notes_PrepayScheduleDict != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_PrepayScheduleDict in dtdata_notes_PrepayScheduleDict.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_PrepayScheduleDict["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_PrepayScheduleDict["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                foreach (DataColumn dc in dtdata_notes_PrepayScheduleDict.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "PrepayPremium" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            //var _value = dr_dtdata_notes_PrepayScheduleDict[dc];
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_PrepayScheduleDict[dc], drJsonFormat["DataType"].ToString());
                                                            notes_Deal_setup_dictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    */
                                    #endregion

                                    //data.notes.NoteAdjustedCommitment
                                    #region "NoteAdjustedCommitment"
                                    /*
                                     if (dtdata_notes_NoteAdjustedCommitment != null)
                                     {
                                         foreach (DataRow dr_dtdata_notes_NoteAdjustedCommitment in dtdata_notes_NoteAdjustedCommitment.Rows)
                                         {
                                             if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_NoteAdjustedCommitment["EffectiveDate"].ToString()) && (dr_dtdata_notes_NoteAdjustedCommitment["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                             {
                                                 foreach (DataColumn dc in dtdata_notes_NoteAdjustedCommitment.Columns)
                                                 {
                                                     string _key = dc.ColumnName;
                                                     foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                     {
                                                         if (drJsonFormat["Type"].ToString() == "NoteAdjustedTotalCommitment" && drJsonFormat["key"].ToString() == _key)
                                                         {
                                                             dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_NoteAdjustedCommitment[dc], drJsonFormat["DataType"].ToString());
                                                             notes_Deal_setup_dictionary.Add(_key, _value);
                                                         }
                                                     }
                                                 }
                                             }
                                         }

                                     }
                                    */
                                    #endregion

                                    //data.notes.maturity
                                    #region "notes.maturity"
                                    if (dtdata_notes_maturity != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_maturity in dtdata_notes_maturity.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_maturity["EffectiveDate"].ToString()) && (dr_dtdata_notes_maturity["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                foreach (DataColumn dc in dtdata_notes_maturity.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "tbl_notematurity" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            if (_key == "contractmat")
                                                            {
                                                                if (Convert.ToString(dr_dtdata_notes_maturity[dc]) != "")
                                                                {
                                                                    dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_maturity[dc], drJsonFormat["DataType"].ToString());
                                                                    notes_Deal_setup_dictionary.Add(_key, _value);
                                                                }
                                                            }
                                                            else
                                                            {
                                                                dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_maturity[dc], drJsonFormat["DataType"].ToString());
                                                                notes_Deal_setup_dictionary.Add(_key, _value);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    #endregion

                                    //code for generate all  type rates dtdata_Json_Info
                                    foreach (DataRow dr_dtdata_Json_Info in dtdata_Json_Info.Rows)
                                    {
                                        if (dr_dtdata_Json_Info["GroupName"].ToString() == "rate")
                                        {
                                            string _tableName = dr_dtdata_Json_Info["table_name"].ToString();
                                            string _jsonKey = dr_dtdata_Json_Info["table_name"].ToString().Replace("data.notes.", "");

                                            DataTable dt = dsCalcInfo.Tables[_tableName];

                                            if (dt.Rows.Count > 0)
                                            {
                                                var lstTableRates = new List<Dictionary<string, object>>();

                                                foreach (DataRow dr in dt.Rows)
                                                {
                                                    if (dr["valtype"].ToString().ToLower() == _jsonKey.ToLower())
                                                    {
                                                        if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr["EffectiveDate"].ToString()) && (dr["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                                        {
                                                            Dictionary<string, Object> notes_tables_rates = new Dictionary<string, object>()
                                                            {
                                                                ["startdt"] = dr["startdt"].ToString(),
                                                                ["valtype"] = dr["valtype"].ToString(),
                                                                ["val"] = dr["val"],
                                                                ["intcalcdays"] = dr["intcalcdays"],
                                                                ["detdt_hlday_ls"] = dr["detdt_hlday_ls"].ToString(),
                                                                ["indexnametext"] = dr["indexnametext"].ToString()

                                                            };

                                                            lstTableRates.Add(notes_tables_rates);
                                                        }
                                                    }
                                                }

                                                //innerData_Notes_tables_spread.Add(_jsonKey, lstTableRates);
                                                if (lstTableRates.Count > 0)
                                                {
                                                    notes_Deal_setup_dictionary.Add(_jsonKey, lstTableRates);
                                                }
                                            }
                                        }
                                    }



                                    #region funding
                                    if (dtdata_notes_setup_tables_funding != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_funding in dtdata_notes_setup_tables_funding.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_funding["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_funding["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_spread = new Dictionary<String, Object>()
                                                {
                                                    ["dt"] = dr_dtdata_notes_setup_tables_funding["dt"].ToString(),
                                                    ["fundpydn"] = dr_dtdata_notes_setup_tables_funding["fundpydn"],
                                                    ["purpose"] = dr_dtdata_notes_setup_tables_funding["purpose"],
                                                    ["noncommitmentadj"] = dr_dtdata_notes_setup_tables_funding["noncommitmentadj"].ToString(),
                                                    ["adjustmenttype"] = dr_dtdata_notes_setup_tables_funding["adjustmenttype"].ToString(),
                                                };

                                                lstnotes_funding.Add(notes_tables_spread);
                                            }
                                        }
                                    }
                                    #endregion

                                    //dtdata_notes_setup_tables_noteperiodiccal
                                    #region noteperiodiccal
                                    if (dtdata_notes_setup_tables_noteperiodiccal != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_noteperiodiccal in dtdata_notes_setup_tables_noteperiodiccal.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_noteperiodiccal["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_noteperiodiccal["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_spread = new Dictionary<String, Object>()
                                                {
                                                    ["date"] = dr_dtdata_notes_setup_tables_noteperiodiccal["date"].ToString(),
                                                    ["levyld"] = dr_dtdata_notes_setup_tables_noteperiodiccal["levyld"],
                                                    ["gaapbasis"] = dr_dtdata_notes_setup_tables_noteperiodiccal["gaapbasis"],
                                                    ["cum_am_disc"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_am_disc"],
                                                    // ["feeamort"] = dr_dtdata_notes_setup_tables_noteperiodiccal["feeamort"],
                                                    ["cum_am_fee"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_am_fee"],
                                                    ["cum_dailypikint"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailypikint"],
                                                    ["cum_baladdon_am"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_baladdon_am"],
                                                    ["cum_baladdon_nonam"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_baladdon_nonam"],
                                                    ["cum_dailyint"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailyint"].ToString(),
                                                    ["cum_ddbaladdon"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_ddbaladdon"],
                                                    ["cum_dailyint"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailyint"],
                                                    ["cum_ddbaladdon"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_ddbaladdon"],
                                                    ["cum_ddintdelta"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_ddintdelta"],
                                                    ["cum_am_capcosts"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_am_capcosts"],
                                                    ["endbal"] = dr_dtdata_notes_setup_tables_noteperiodiccal["endbal"],
                                                    ["initbal"] = dr_dtdata_notes_setup_tables_noteperiodiccal["initbal"],
                                                    ["cum_fee_levyld"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_fee_levyld"],
                                                    ["period_ddintdelta_shifted"] = dr_dtdata_notes_setup_tables_noteperiodiccal["period_ddintdelta_shifted"],
                                                    ["intdeltabal"] = dr_dtdata_notes_setup_tables_noteperiodiccal["intdeltabal"],
                                                    ["cum_exit_fee_excl_lv_yield"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_exit_fee_excl_lv_yield"],

                                                    ["periodend"] = dr_dtdata_notes_setup_tables_noteperiodiccal["periodend"].ToString(),
                                                    ["periodstart"] = dr_dtdata_notes_setup_tables_noteperiodiccal["periodstart"].ToString(),
                                                    ["pmtdtnotadj"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pmtdtnotadj"].ToString(),
                                                    ["pmtdt"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pmtdt"].ToString(),
                                                    ["periodpikint"] = dr_dtdata_notes_setup_tables_noteperiodiccal["periodpikint"],

                                                    ["yld_capcosts"] = dr_dtdata_notes_setup_tables_noteperiodiccal["yld_capcosts"],
                                                    ["bas_capcosts"] = dr_dtdata_notes_setup_tables_noteperiodiccal["bas_capcosts"],
                                                    //["am_capcosts"] = dr_dtdata_notes_setup_tables_noteperiodiccal["am_capcosts"],
                                                    ["yld_disc"] = dr_dtdata_notes_setup_tables_noteperiodiccal["yld_disc"],
                                                    ["bas_disc"] = dr_dtdata_notes_setup_tables_noteperiodiccal["bas_disc"],
                                                    //["am_disc"] = dr_dtdata_notes_setup_tables_noteperiodiccal["am_disc"],

                                                    ["curperintaccr"] = dr_dtdata_notes_setup_tables_noteperiodiccal["curperintaccr"],
                                                    ["curperpikintaccr"] = dr_dtdata_notes_setup_tables_noteperiodiccal["curperpikintaccr"],
                                                    ["intsuspensebal"] = dr_dtdata_notes_setup_tables_noteperiodiccal["intsuspensebal"],

                                                    ["curperintaccrmon"] = dr_dtdata_notes_setup_tables_noteperiodiccal["curperintaccrmon"],
                                                    ["curperpikintaccrmon"] = dr_dtdata_notes_setup_tables_noteperiodiccal["curperpikintaccrmon"],
                                                    ["cum_unusedfee"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_unusedfee"],
                                                    ////["initfunding"] = dr_dtdata_notes_setup_tables_noteperiodiccal["initfunding"],

                                                    //["netpikamountfortheperiod"] = dr_dtdata_notes_setup_tables_noteperiodiccal["netpikamountfortheperiod"],
                                                    //["cashinterest"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cashinterest"],
                                                    //["capitalizedinterest"] = dr_dtdata_notes_setup_tables_noteperiodiccal["capitalizedinterest"],

                                                    //["pikballoonsepcomp"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pikballoonsepcomp"],
                                                    ["pikendbalsepcomp"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pikendbalsepcomp"],
                                                    ["cum_daily_pik_from_interest"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_daily_pik_from_interest"],
                                                    ["cum_dailypikcomp"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailypikcomp"],
                                                    ["cum_dailyintonpik"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailyintonpik"],
                                                    ["pikinitbalsepcomp"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pikinitbalsepcomp"],
                                                };

                                                lstnotes_noteperiodiccal.Add(notes_tables_spread);
                                            }
                                        }
                                    }
                                    #endregion

                                    #region amsch
                                    if (dtdata_notes_setup_tables_amsch != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_amsch in dtdata_notes_setup_tables_amsch.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_amsch["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_amsch["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_amsch = new Dictionary<String, Object>()
                                                {
                                                    ["dt"] = dr_dtdata_notes_setup_tables_amsch["dt"].ToString(),
                                                    ["val"] = dr_dtdata_notes_setup_tables_amsch["val"]
                                                };

                                                lstnotes_amsch.Add(notes_tables_amsch);
                                            }
                                        }
                                    }
                                    #endregion

                                    //dtdata_notes_setup_tables_pikrate
                                    #region pikrate
                                    if (dtdata_notes_setup_tables_pikrate != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_pikrate in dtdata_notes_setup_tables_pikrate.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_pikrate["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_pikrate["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                //startdt	enddt	rate	spread	index_floor	intcalcdays	cap_bal	acc_cap_bal	pik_sep_comp	pik_reason_code	pik_comments
                                                Dictionary<String, Object> notes_tables_pikrate = new Dictionary<String, Object>()
                                                {
                                                    ["startdt"] = dr_dtdata_notes_setup_tables_pikrate["startdt"].ToString(),
                                                    ["enddt"] = dr_dtdata_notes_setup_tables_pikrate["enddt"].ToString(),
                                                    ["rate"] = dr_dtdata_notes_setup_tables_pikrate["rate"],
                                                    ["spread"] = dr_dtdata_notes_setup_tables_pikrate["spread"],
                                                    ["index_floor"] = dr_dtdata_notes_setup_tables_pikrate["index_floor"],
                                                    ["intcalcdays"] = dr_dtdata_notes_setup_tables_pikrate["intcalcdays"],
                                                    ["cap_bal"] = dr_dtdata_notes_setup_tables_pikrate["cap_bal"],
                                                    ["acc_cap_bal"] = dr_dtdata_notes_setup_tables_pikrate["acc_cap_bal"],
                                                    ["pik_sep_comp"] = dr_dtdata_notes_setup_tables_pikrate["pik_sep_comp"].ToBoolean(),
                                                    ["pik_reason_code"] = dr_dtdata_notes_setup_tables_pikrate["pik_reason_code"].ToString(),
                                                    ["pik_comments"] = dr_dtdata_notes_setup_tables_pikrate["pik_comments"].ToString(),
                                                    ["pur_balance"] = dr_dtdata_notes_setup_tables_pikrate["pur_balance"],
                                                    ["periodic_rate_cap_amount"] = dr_dtdata_notes_setup_tables_pikrate["periodic_rate_cap_amount"],
                                                    ["periodic_rate_cap_per"] = dr_dtdata_notes_setup_tables_pikrate["periodic_rate_cap_per"],


                                                    ["piksetup"] = dr_dtdata_notes_setup_tables_pikrate["piksetup"],
                                                    ["pikpercentage"] = dr_dtdata_notes_setup_tables_pikrate["pikpercentage"],

                                                    ["comp_rate"] = dr_dtdata_notes_setup_tables_pikrate["comp_rate"],
                                                    ["comp_spread"] = dr_dtdata_notes_setup_tables_pikrate["comp_spread"],
                                                    ["currentpayrate"] = dr_dtdata_notes_setup_tables_pikrate["currentpayrate"],

                                                };

                                                lstnotes_pikrate.Add(notes_tables_pikrate);
                                            }
                                        }
                                    }
                                    #endregion

                                    //dtdata_notes_setup_tables_piksch
                                    #region piksch
                                    if (dtdata_notes_setup_tables_piksch != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_piksch in dtdata_notes_setup_tables_piksch.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_piksch["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_piksch["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_piksch = new Dictionary<String, Object>()
                                                {
                                                    ["dt"] = dr_dtdata_notes_setup_tables_piksch["dt"].ToString(),
                                                    ["val"] = dr_dtdata_notes_setup_tables_piksch["val"]
                                                };

                                                lstnotes_piksch.Add(notes_tables_piksch);
                                            }
                                        }
                                    }
                                    #endregion


                                    #region Fee
                                    //fees 
                                    if (dtdata_notes_setup_tables_fees != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_fees in dtdata_notes_setup_tables_fees.Rows)
                                        {

                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_fees["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_fees["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<String, Object> notes_tables_spread = new Dictionary<String, Object>()
                                                {
                                                    ["feename"] = dr_dtdata_notes_setup_tables_fees["feename"].ToString(),
                                                    ["startdt"] = dr_dtdata_notes_setup_tables_fees["startdt"].ToString(),
                                                    ["enddt"] = dr_dtdata_notes_setup_tables_fees["enddt"].ToString(),
                                                    ["type"] = dr_dtdata_notes_setup_tables_fees["type"].ToString(),
                                                    ["valtype"] = dr_dtdata_notes_setup_tables_fees["valtype"],
                                                    ["val"] = dr_dtdata_notes_setup_tables_fees["val"],
                                                    ["ovrfeeamt"] = dr_dtdata_notes_setup_tables_fees["ovrfeeamt"],
                                                    ["ovrbaseamt"] = dr_dtdata_notes_setup_tables_fees["ovrbaseamt"],
                                                    ["trueupflag"] = dr_dtdata_notes_setup_tables_fees["trueupflag"].ToString(),
                                                    ["levyldincl"] = dr_dtdata_notes_setup_tables_fees["levyldincl"],
                                                    ["basisincl"] = dr_dtdata_notes_setup_tables_fees["basisincl"],
                                                    ["stripval"] = dr_dtdata_notes_setup_tables_fees["stripval"],
                                                    ["actual_startdt"] = dr_dtdata_notes_setup_tables_fees["actual_startdt"].ToString(),
                                                    ["feescheduleid"] = dr_dtdata_notes_setup_tables_fees["feescheduleid"].ToString()
                                                };

                                                lstFees.Add(notes_tables_spread);
                                            }
                                        }
                                    }
                                    #endregion

                                    #region"fee_stripping"
                                    if (dtdata_notes_setup_tables_fee_stripping != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_fee_stripping in dtdata_notes_setup_tables_fee_stripping.Rows)
                                        {

                                            //if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_fee_stripping["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_fee_stripping["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))

                                            // fee striping not depend on Effective dates
                                            if ((dr_dtdata_notes_setup_tables_fee_stripping["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                //Dictionary<String, Object> notes_tables_spread = new Dictionary<String, Object>()
                                                //{
                                                //    ["to"] = dr_dtdata_notes_setup_tables_fee_stripping["to"].ToString(),
                                                //    ["pct"] = dr_dtdata_notes_setup_tables_fee_stripping["pct"]
                                                //};

                                                //lstfee_stripping.Add(notes_tables_spread);

                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_setup_tables_fee_stripping.Columns)
                                                {
                                                    string _key = dc.ColumnName.ToLower();
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "fee_stripping" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_setup_tables_fee_stripping[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                                lstfee_stripping.Add(innerDictionary);
                                            }
                                        }
                                    }
                                    #endregion

                                    //dtdata_notes_fee_strip_received
                                    #region fee_strip_received
                                    if (dtdata_notes_fee_strip_received != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_fee_strip_received in dtdata_notes_fee_strip_received.Rows)
                                        {

                                            // fee_strip_received not depend on Effective dates
                                            if ((dr_dtdata_notes_fee_strip_received["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_dtdata_notes_fee_strip_received = new Dictionary<String, Object>()
                                                {
                                                    ["dt"] = dr_dtdata_notes_fee_strip_received["dt"].ToString(),
                                                    ["val"] = dr_dtdata_notes_fee_strip_received["val"],
                                                    ["type"] = dr_dtdata_notes_fee_strip_received["type"].ToString(),
                                                    ["feename"] = dr_dtdata_notes_fee_strip_received["feename"].ToString(),
                                                };

                                                lstfee_strip_received.Add(notes_tables_dtdata_notes_fee_strip_received);
                                            }
                                        }
                                    }
                                    #endregion

                                    //dtdata_notes_actuals
                                    #region actuals
                                    if (dtdata_notes_actuals != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_actuals in dtdata_notes_actuals.Rows)
                                        {

                                            // fee_strip_received not depend on Effective dates
                                            if ((dr_dtdata_notes_actuals["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                //Dictionary<String, Object> notes_tables_dtdata_notes_actuals = new Dictionary<String, Object>()
                                                //{
                                                //    ["account"] = dr_dtdata_notes_actuals["account"].ToString(),
                                                //    ["dt"] = dr_dtdata_notes_actuals["dt"].ToString(),
                                                //    ["val"] = dr_dtdata_notes_actuals["val"],
                                                //    ["cash"] = dr_dtdata_notes_actuals["cash"].ToBoolean(),
                                                //};
                                                //lstdata_notes_actuals.Add(notes_tables_dtdata_notes_actuals);

                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_actuals.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "noteactuals" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_actuals[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                                lstdata_notes_actuals.Add(innerDictionary);

                                            }
                                        }

                                        //add in effective date parallel
                                        //if (lstdata_notes_actuals.Count() > 0)
                                        //{
                                        //    notes_Deal.Add("actuals", lstdata_notes_actuals);
                                        //}

                                    }
                                    #endregion


                                    //dtdata_notes_watchlist
                                    #region dtdata_notes_watchlist
                                    if (dtdata_notes_watchlist != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_watchlist in dtdata_notes_watchlist.Rows)
                                        {
                                            if ((dr_dtdata_notes_watchlist["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString())

                                                    && (dr_dtData_notes_setup["effective_dates"].ToString() == (dr_dtdata_notes_watchlist["EffectiveDate"].ToString()))
                                                    )

                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_watchlist.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "svrwatchlist" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_watchlist[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                                lstdtdata_notes_watchlist.Add(innerDictionary);
                                            }
                                        }

                                    }
                                    #endregion
                                    //dtMaturityScenarios
                                    #region "MaturityScenario"
                                    if (dtMaturityScenarios != null)
                                    {
                                        foreach (DataRow dr_dtMaturityScenarios in dtMaturityScenarios.Rows)
                                        {

                                            // MaturityScenario not depend on Effective dates
                                            if ((dr_dtMaturityScenarios["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_dtMaturityScenario = new Dictionary<String, Object>()
                                                {
                                                    ["effective_date"] = dr_dtMaturityScenarios["EffectiveDate"].ToString().Split(' ')[0],
                                                    ["matdt"] = dr_dtMaturityScenarios["SelectedMaturityDate"].ToString().Split(' ')[0]
                                                };

                                                lstmaturity_scenarios.Add(notes_tables_dtMaturityScenario);
                                            }
                                        }
                                    }
                                    #endregion

                                    //dtdata_notes_SpreadMaintenance
                                    #region "Prepayment SpreadMaintenanc"
                                    /*
                                    if (dtdata_notes_SpreadMaintenance != null)
                                    {


                                        foreach (DataRow dr_dtdata_notes_SpreadMaintenance in dtdata_notes_SpreadMaintenance.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_SpreadMaintenance["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_SpreadMaintenance["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_SpreadMaintenance.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {

                                                        if (drJsonFormat["Type"].ToString() == "tbl_SpreadMaintenance" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_SpreadMaintenance[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);

                                                        }
                                                    }

                                                }
                                                lstSpreadMaintenanc.Add(innerDictionary);
                                            }
                                        }
                                    }
                                    */
                                    #endregion

                                    //dtdata_notes_PrepayAdjustment
                                    #region "PrepayAdjustment"
                                    /*
                                    if (dtdata_notes_PrepayAdjustment != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_PrepayAdjustment in dtdata_notes_PrepayAdjustment.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_PrepayAdjustment["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_PrepayAdjustment["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_PrepayAdjustment.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {

                                                        if (drJsonFormat["Type"].ToString() == "tbl_PrepayAdjustment" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_PrepayAdjustment[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);

                                                        }
                                                    }
                                                }
                                                lstPrepayAdjustment.Add(innerDictionary);
                                            }
                                        }
                                    }
                                    */
                                    #endregion

                                    //dtdata_notes_MinSpreadInterest
                                    #region "MinSpreadInterest"
                                    /*
                                    if (dtdata_notes_MinSpreadInterest != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_MinSpreadInterest in dtdata_notes_MinSpreadInterest.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_MinSpreadInterest["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_MinSpreadInterest["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_MinSpreadInterest.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {

                                                        if (drJsonFormat["Type"].ToString() == "tbl_MinSpreadInterest" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_MinSpreadInterest[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);

                                                        }
                                                    }
                                                }
                                                lstMinSpreadInterest.Add(innerDictionary);
                                            }
                                        }
                                    }
                                    */
                                    #endregion

                                    //dtdata_notes_MinFee
                                    #region "MinFee"
                                    /*
                                    if (dtdata_notes_MinFee != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_MinFee in dtdata_notes_MinFee.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_MinFee["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_MinFee["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_MinFee.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {

                                                        if (drJsonFormat["Type"].ToString() == "tbl_MinFee" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_MinFee[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);

                                                        }
                                                    }
                                                }
                                                lstMinFee.Add(innerDictionary);
                                            }
                                        }
                                    }
                                    */
                                    #endregion

                                    //dtdata_notes_cashflow
                                    #region "cashflow"
                                    if (dtdata_notes_cashflow != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_cashflow in dtdata_notes_cashflow.Rows)
                                        {
                                            if (dr_dtdata_notes_cashflow["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString())
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_cashflow.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "cashflow" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_cashflow[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                                lstcashflow.Add(innerDictionary);
                                            }
                                        }

                                        //add in effective date parallel
                                        if (lstcashflow.Count() > 0)
                                        {
                                            notes_Deal.Add("cashflow", lstcashflow);
                                        }
                                    }
                                    #endregion

                                    //dtdata_notes_noteperiodiccalc
                                    /*
                                    #region "noteperiodiccalc"
                                    
                                    if (dtdata_notes_noteperiodiccalc != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_noteperiodiccalc in dtdata_notes_noteperiodiccalc.Rows)
                                        {
                                            if (dr_dtdata_notes_noteperiodiccalc["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString())
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_noteperiodiccalc.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "noteperiodiccalc" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_noteperiodiccalc[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                                lstnoteperiodiccalc.Add(innerDictionary);
                                            }
                                        }

                                        //add in effective date parallel
                                        if (lstnoteperiodiccalc.Count() > 0)
                                        {
                                            notes_Deal.Add("noteperiodiccalc", lstnoteperiodiccalc);
                                        }
                                    }
                                    #endregion
                                    */

                                    //dtdata_notes_notecommitment
                                    #region "notecommitment"
                                    if (dtdata_notes_notecommitment != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_notecommitment in dtdata_notes_notecommitment.Rows)
                                        {
                                            if (dr_dtdata_notes_notecommitment["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString())
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_notecommitment.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "notecommitment" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_notecommitment[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                                lstnotecommitment.Add(innerDictionary);
                                            }
                                        }

                                        //add in effective date parallel
                                        if (lstnotecommitment.Count > 0)
                                        {
                                            notes_Deal.Add("notecommitment", lstnotecommitment);
                                        }

                                    }


                                    #endregion

                                    //dtdata_notes_notebalance
                                    #region
                                    if (dtdata_notes_notebalance != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_notebalance in dtdata_notes_notebalance.Rows)
                                        {
                                            if (dr_dtdata_notes_notebalance["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString())
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_notebalance.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "notebalance" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_notebalance[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                                lstnotebalance.Add(innerDictionary);
                                            }
                                        }

                                        //add in effective date parallel
                                        if (lstnotebalance.Count() > 0)
                                        {
                                            notes_Deal.Add("notebalance", lstnotebalance);
                                        }

                                    }


                                    #endregion


                                    //if (lstSpread.Count > 0 || lstindex_floor.Count >0 || lstFees.Count > 0 || lstfee_stripping.Count > 0|| lstRate.Count > 0 )
                                    {
                                        if (lstFees.Count > 0)
                                        {
                                            // innerData_Notes_tables_spread.Add("fee", lstFees);

                                            notes_Deal_setup_dictionary.Add("fee", lstFees);
                                        }
                                        if (lstfee_stripping.Count > 0)
                                        {
                                            // innerData_Notes_tables_spread.Add("fee_stripping", lstfee_stripping);
                                            notes_Deal_setup_dictionary.Add("fee_stripping", lstfee_stripping);
                                        }

                                        if (lstfee_strip_received.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("fee_strip_received", lstfee_strip_received);
                                        }

                                        if (lstdata_notes_actuals.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("actuals", lstdata_notes_actuals);
                                        }

                                        if (lstdtdata_notes_watchlist.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("svrwatchlist", lstdtdata_notes_watchlist);
                                        }

                                        if (lstmaturity_scenarios.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("maturity_scenario", lstmaturity_scenarios);
                                        }

                                        if (lstnotes_funding.Count > 0)
                                        {
                                            //innerData_Notes_tables_spread.Add("funding", lstnotes_funding);
                                            notes_Deal_setup_dictionary.Add("funding", lstnotes_funding);
                                        }

                                        if (lstnotes_noteperiodiccal.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("noteperiodiccalc", lstnotes_noteperiodiccal);
                                        }

                                        //
                                        if (lstnotes_amsch.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("amsch", lstnotes_amsch);
                                        }

                                        if (lstnotes_pikrate.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("pikrate", lstnotes_pikrate);
                                        }
                                        //
                                        if (lstnotes_piksch.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("piksch", lstnotes_piksch);
                                        }

                                        if (lstSpreadMaintenanc.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("YMSpread", lstSpreadMaintenanc);
                                        }

                                        if (lstPrepayAdjustment.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("PrepayAdjustment", lstPrepayAdjustment);
                                        }

                                        if (lstMinMultSchedule.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("MinMultSchedule", lstMinMultSchedule);
                                        }
                                        //
                                        if (lstFeeCredits.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("FeeCredits", lstFeeCredits);
                                        }

                                        //if (lstcashflow.Count > 0)
                                        //{
                                        //    notes_Deal_setup_dictionary.Add("cashflow", lstcashflow);
                                        //}

                                        //if (lstnotecommitment.Count > 0)
                                        //{
                                        //    notes_Deal_setup_dictionary.Add("notecommitment", lstnotecommitment);
                                        //}

                                        //if (lstnotebalance.Count > 0)
                                        //{
                                        //    notes_Deal_setup_dictionary.Add("notebalance", lstnotebalance);
                                        //}

                                        //innerData_Deal_dictionary.Add("tables", innerData_Notes_tables_spread);

                                        // innerData_Deal_date.Add(dr_dtData_notes_setup["effective_dates"].ToString(), innerData_Notes_tables_spread);


                                    }
                                }

                                //innerData_Deal_date.Add(dr_dtData_notes_setup["effective_dates"].ToString(), ObjToCsv.DictionaryToObject(innerData_Deal_dictionary));
                                //innerData_Deal_date.Add(dr_dtData_notes_setup["effective_dates"].ToString(), ObjToCsv.DictionaryToObject(notes_Deal_setup_dictionary));

                                notes_Deal.Add(dr_dtData_notes_setup["effective_dates"].ToString(), ObjToCsv.DictionaryToObject(notes_Deal_setup_dictionary));
                            }
                            else
                            {
                                Dictionary<String, Object> notes_Deal_setup_dictionary = new Dictionary<String, Object>();
                                //fee related code
                                if ((dr_dtData_notes_setup["CRENoteId"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                {
                                    // var innerData_Notes_tables_spread = new Dictionary<string, List<Dictionary<string, object>>>();
                                    var lstFees = new List<Dictionary<string, object>>();
                                    var lstnotes_funding = new List<Dictionary<string, object>>();
                                    var lstnotes_noteperiodiccal = new List<Dictionary<string, object>>();
                                    var lstnotes_amsch = new List<Dictionary<string, object>>();
                                    var lstnotes_pikrate = new List<Dictionary<string, object>>();
                                    var lstnotes_piksch = new List<Dictionary<string, object>>();
                                    var lstSpreadMaintenanc = new List<Dictionary<string, object>>();
                                    var lstPrepayAdjustment = new List<Dictionary<String, Object>>();
                                    var lstMinMultSchedule = new List<Dictionary<String, Object>>();
                                    var lstFeeCredits = new List<Dictionary<String, Object>>();
                                    var lstdtdata_notes_watchlist = new List<Dictionary<string, object>>();

                                    #region PrepayScheduleDict
                                    /*
                                    if (dtdata_notes_PrepayScheduleDict != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_PrepayScheduleDict in dtdata_notes_PrepayScheduleDict.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_PrepayScheduleDict["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_PrepayScheduleDict["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                foreach (DataColumn dc in dtdata_notes_PrepayScheduleDict.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "PrepayPremium" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            //var _value = dr_dtdata_notes_PrepayScheduleDict[dc];
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_PrepayScheduleDict[dc], drJsonFormat["DataType"].ToString());
                                                            notes_Deal_setup_dictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    */
                                    #endregion

                                    #region "NoteAdjustedCommitment"
                                    /*
                                    if (dtdata_notes_NoteAdjustedCommitment != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_NoteAdjustedCommitment in dtdata_notes_NoteAdjustedCommitment.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_NoteAdjustedCommitment["EffectiveDate"].ToString()) && (dr_dtdata_notes_NoteAdjustedCommitment["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                foreach (DataColumn dc in dtdata_notes_NoteAdjustedCommitment.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "NoteAdjustedTotalCommitment" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_NoteAdjustedCommitment[dc], drJsonFormat["DataType"].ToString());
                                                            notes_Deal_setup_dictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    */
                                    #endregion

                                    //data.notes.maturity
                                    #region "notes.maturity"
                                    if (dtdata_notes_maturity != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_maturity in dtdata_notes_maturity.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_maturity["EffectiveDate"].ToString()) && (dr_dtdata_notes_maturity["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                foreach (DataColumn dc in dtdata_notes_maturity.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "tbl_notematurity" && drJsonFormat["key"].ToString() == _key)
                                                        {

                                                            if (_key == "contractmat")
                                                            {
                                                                if (Convert.ToString(dr_dtdata_notes_maturity[dc]) != "")
                                                                {
                                                                    dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_maturity[dc], drJsonFormat["DataType"].ToString());
                                                                    notes_Deal_setup_dictionary.Add(_key, _value);
                                                                }
                                                            }
                                                            else
                                                            {
                                                                dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_maturity[dc], drJsonFormat["DataType"].ToString());
                                                                notes_Deal_setup_dictionary.Add(_key, _value);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    #endregion

                                    //code for generate all  type rates dtdata_Json_Info
                                    foreach (DataRow dr_dtdata_Json_Info in dtdata_Json_Info.Rows)
                                    {
                                        if (dr_dtdata_Json_Info["GroupName"].ToString() == "rate")
                                        {
                                            string _tableName = dr_dtdata_Json_Info["table_name"].ToString();
                                            string _jsonKey = dr_dtdata_Json_Info["table_name"].ToString().Replace("data.notes.", "");

                                            DataTable dt = dsCalcInfo.Tables[_tableName];

                                            if (dt.Rows.Count > 0)
                                            {
                                                var lstTableRates = new List<Dictionary<string, object>>();

                                                foreach (DataRow dr in dt.Rows)
                                                {
                                                    if (dr["valtype"].ToString().ToLower() == _jsonKey.ToLower())
                                                    {
                                                        if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr["EffectiveDate"].ToString()) && (dr["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                                        {
                                                            Dictionary<string, Object> notes_tables_rates = new Dictionary<string, object>()
                                                            {
                                                                ["startdt"] = dr["startdt"].ToString(),
                                                                ["valtype"] = dr["valtype"].ToString(),
                                                                ["val"] = dr["val"],
                                                                ["intcalcdays"] = dr["intcalcdays"],
                                                                ["detdt_hlday_ls"] = dr["detdt_hlday_ls"].ToString(),
                                                                ["indexnametext"] = dr["indexnametext"].ToString()
                                                            };

                                                            lstTableRates.Add(notes_tables_rates);
                                                        }
                                                    }
                                                }

                                                if (lstTableRates.Count > 0)
                                                {
                                                    notes_Deal_setup_dictionary.Add(_jsonKey, lstTableRates);
                                                }
                                            }
                                        }
                                    }

                                    // sam

                                    //dtdata_notes_setup_tables_funding
                                    //lstnotes_funding
                                    #region funding
                                    if (dtdata_notes_setup_tables_funding != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_funding in dtdata_notes_setup_tables_funding.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_funding["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_funding["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_spread = new Dictionary<String, Object>()
                                                {
                                                    ["dt"] = dr_dtdata_notes_setup_tables_funding["dt"].ToString(),
                                                    ["fundpydn"] = dr_dtdata_notes_setup_tables_funding["fundpydn"],
                                                    ["purpose"] = dr_dtdata_notes_setup_tables_funding["purpose"],
                                                    ["noncommitmentadj"] = dr_dtdata_notes_setup_tables_funding["noncommitmentadj"].ToString(),
                                                    ["adjustmenttype"] = dr_dtdata_notes_setup_tables_funding["adjustmenttype"].ToString(),
                                                };

                                                lstnotes_funding.Add(notes_tables_spread);
                                            }
                                        }
                                    }
                                    #endregion

                                    #region noteperiodiccal
                                    if (dtdata_notes_setup_tables_noteperiodiccal != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_noteperiodiccal in dtdata_notes_setup_tables_noteperiodiccal.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_noteperiodiccal["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_noteperiodiccal["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_spread = new Dictionary<String, Object>()
                                                {
                                                    ["date"] = dr_dtdata_notes_setup_tables_noteperiodiccal["date"].ToString(),
                                                    ["levyld"] = dr_dtdata_notes_setup_tables_noteperiodiccal["levyld"],
                                                    ["gaapbasis"] = dr_dtdata_notes_setup_tables_noteperiodiccal["gaapbasis"],
                                                    ["cum_am_disc"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_am_disc"],
                                                    // ["feeamort"] = dr_dtdata_notes_setup_tables_noteperiodiccal["feeamort"],
                                                    ["cum_am_fee"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_am_fee"],
                                                    ["cum_dailypikint"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailypikint"],
                                                    ["cum_baladdon_am"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_baladdon_am"],
                                                    ["cum_baladdon_nonam"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_baladdon_nonam"],
                                                    ["cum_dailyint"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailyint"],
                                                    ["cum_ddbaladdon"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_ddbaladdon"],
                                                    ["cum_dailyint"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailyint"],
                                                    ["cum_ddbaladdon"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_ddbaladdon"],
                                                    ["cum_ddintdelta"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_ddintdelta"],
                                                    ["cum_am_capcosts"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_am_capcosts"],
                                                    ["endbal"] = dr_dtdata_notes_setup_tables_noteperiodiccal["endbal"],
                                                    ["initbal"] = dr_dtdata_notes_setup_tables_noteperiodiccal["initbal"],
                                                    ["cum_fee_levyld"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_fee_levyld"],
                                                    ["period_ddintdelta_shifted"] = dr_dtdata_notes_setup_tables_noteperiodiccal["period_ddintdelta_shifted"],
                                                    ["intdeltabal"] = dr_dtdata_notes_setup_tables_noteperiodiccal["intdeltabal"],
                                                    ["cum_exit_fee_excl_lv_yield"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_exit_fee_excl_lv_yield"],

                                                    ["periodend"] = dr_dtdata_notes_setup_tables_noteperiodiccal["periodend"].ToString(),
                                                    ["periodstart"] = dr_dtdata_notes_setup_tables_noteperiodiccal["periodstart"].ToString(),
                                                    ["pmtdtnotadj"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pmtdtnotadj"].ToString(),
                                                    ["pmtdt"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pmtdt"].ToString(),
                                                    ["periodpikint"] = dr_dtdata_notes_setup_tables_noteperiodiccal["periodpikint"],

                                                    ["yld_capcosts"] = dr_dtdata_notes_setup_tables_noteperiodiccal["yld_capcosts"],
                                                    ["bas_capcosts"] = dr_dtdata_notes_setup_tables_noteperiodiccal["bas_capcosts"],
                                                    // ["am_capcosts"] = dr_dtdata_notes_setup_tables_noteperiodiccal["am_capcosts"],
                                                    ["yld_disc"] = dr_dtdata_notes_setup_tables_noteperiodiccal["yld_disc"],
                                                    ["bas_disc"] = dr_dtdata_notes_setup_tables_noteperiodiccal["bas_disc"],
                                                    //["am_disc"] = dr_dtdata_notes_setup_tables_noteperiodiccal["am_disc"],

                                                    ["curperintaccr"] = dr_dtdata_notes_setup_tables_noteperiodiccal["curperintaccr"],
                                                    ["curperpikintaccr"] = dr_dtdata_notes_setup_tables_noteperiodiccal["curperpikintaccr"],
                                                    ["intsuspensebal"] = dr_dtdata_notes_setup_tables_noteperiodiccal["intsuspensebal"],

                                                    ["curperintaccrmon"] = dr_dtdata_notes_setup_tables_noteperiodiccal["curperintaccrmon"],
                                                    ["curperpikintaccrmon"] = dr_dtdata_notes_setup_tables_noteperiodiccal["curperpikintaccrmon"],
                                                    ["cum_unusedfee"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_unusedfee"],
                                                    ////["initfunding"] = dr_dtdata_notes_setup_tables_noteperiodiccal["initfunding"],

                                                    //["netpikamountfortheperiod"] = dr_dtdata_notes_setup_tables_noteperiodiccal["netpikamountfortheperiod"],
                                                    //["cashinterest"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cashinterest"],
                                                    //["capitalizedinterest"] = dr_dtdata_notes_setup_tables_noteperiodiccal["capitalizedinterest"],

                                                    //["pikballoonsepcomp"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pikballoonsepcomp"],
                                                    ["pikendbalsepcomp"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pikendbalsepcomp"],
                                                    ["cum_daily_pik_from_interest"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_daily_pik_from_interest"],
                                                    ["cum_dailypikcomp"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailypikcomp"],
                                                    ["cum_dailyintonpik"] = dr_dtdata_notes_setup_tables_noteperiodiccal["cum_dailyintonpik"],
                                                    ["pikinitbalsepcomp"] = dr_dtdata_notes_setup_tables_noteperiodiccal["pikinitbalsepcomp"],
                                                };

                                                lstnotes_noteperiodiccal.Add(notes_tables_spread);
                                            }
                                        }
                                    }
                                    #endregion

                                    #region amsch
                                    if (dtdata_notes_setup_tables_amsch != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_amsch in dtdata_notes_setup_tables_amsch.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_amsch["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_amsch["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_amsch = new Dictionary<String, Object>()
                                                {
                                                    ["dt"] = dr_dtdata_notes_setup_tables_amsch["dt"].ToString(),
                                                    ["val"] = dr_dtdata_notes_setup_tables_amsch["val"]
                                                };

                                                lstnotes_amsch.Add(notes_tables_amsch);
                                            }
                                        }
                                    }
                                    #endregion

                                    #region pikrate
                                    if (dtdata_notes_setup_tables_pikrate != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_pikrate in dtdata_notes_setup_tables_pikrate.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_pikrate["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_pikrate["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                //startdt	enddt	rate	spread	index_floor	intcalcdays	cap_bal	acc_cap_bal	pik_sep_comp	pik_reason_code	pik_comments
                                                Dictionary<String, Object> notes_tables_pikrate = new Dictionary<String, Object>()
                                                {
                                                    ["startdt"] = dr_dtdata_notes_setup_tables_pikrate["startdt"].ToString(),
                                                    ["enddt"] = dr_dtdata_notes_setup_tables_pikrate["enddt"].ToString(),
                                                    ["rate"] = dr_dtdata_notes_setup_tables_pikrate["rate"],
                                                    ["spread"] = dr_dtdata_notes_setup_tables_pikrate["spread"],
                                                    ["index_floor"] = dr_dtdata_notes_setup_tables_pikrate["index_floor"],
                                                    ["intcalcdays"] = dr_dtdata_notes_setup_tables_pikrate["intcalcdays"],
                                                    ["cap_bal"] = dr_dtdata_notes_setup_tables_pikrate["cap_bal"],
                                                    ["acc_cap_bal"] = dr_dtdata_notes_setup_tables_pikrate["acc_cap_bal"],
                                                    ["pik_sep_comp"] = dr_dtdata_notes_setup_tables_pikrate["pik_sep_comp"].ToBoolean(),
                                                    ["pik_reason_code"] = dr_dtdata_notes_setup_tables_pikrate["pik_reason_code"].ToString(),
                                                    ["pik_comments"] = dr_dtdata_notes_setup_tables_pikrate["pik_comments"].ToString(),
                                                    ["pur_balance"] = dr_dtdata_notes_setup_tables_pikrate["pur_balance"],
                                                    ["periodic_rate_cap_amount"] = dr_dtdata_notes_setup_tables_pikrate["periodic_rate_cap_amount"],
                                                    ["periodic_rate_cap_per"] = dr_dtdata_notes_setup_tables_pikrate["periodic_rate_cap_per"],

                                                    ["piksetup"] = dr_dtdata_notes_setup_tables_pikrate["piksetup"],
                                                    ["pikpercentage"] = dr_dtdata_notes_setup_tables_pikrate["pikpercentage"],

                                                    ["comp_rate"] = dr_dtdata_notes_setup_tables_pikrate["comp_rate"],
                                                    ["comp_spread"] = dr_dtdata_notes_setup_tables_pikrate["comp_spread"],
                                                    ["currentpayrate"] = dr_dtdata_notes_setup_tables_pikrate["currentpayrate"],
                                                };

                                                lstnotes_pikrate.Add(notes_tables_pikrate);
                                            }
                                        }
                                    }
                                    #endregion

                                    #region piksch
                                    if (dtdata_notes_setup_tables_piksch != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_piksch in dtdata_notes_setup_tables_piksch.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_piksch["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_piksch["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {

                                                Dictionary<String, Object> notes_tables_piksch = new Dictionary<String, Object>()
                                                {
                                                    ["dt"] = dr_dtdata_notes_setup_tables_piksch["dt"].ToString(),
                                                    ["val"] = dr_dtdata_notes_setup_tables_piksch["val"]
                                                };

                                                lstnotes_piksch.Add(notes_tables_piksch);
                                            }
                                        }
                                    }
                                    #endregion

                                    //fees 
                                    if (dtdata_notes_setup_tables_fees != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_setup_tables_fees in dtdata_notes_setup_tables_fees.Rows)
                                        {

                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_fees["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_fees["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<String, Object> notes_tables_spread = new Dictionary<String, Object>()
                                                {
                                                    ["feename"] = dr_dtdata_notes_setup_tables_fees["feename"].ToString(),
                                                    ["startdt"] = dr_dtdata_notes_setup_tables_fees["startdt"],
                                                    ["enddt"] = dr_dtdata_notes_setup_tables_fees["enddt"],
                                                    ["type"] = dr_dtdata_notes_setup_tables_fees["type"].ToString(),
                                                    ["valtype"] = dr_dtdata_notes_setup_tables_fees["valtype"],
                                                    ["val"] = dr_dtdata_notes_setup_tables_fees["val"],
                                                    ["ovrfeeamt"] = dr_dtdata_notes_setup_tables_fees["ovrfeeamt"],
                                                    ["ovrbaseamt"] = dr_dtdata_notes_setup_tables_fees["ovrbaseamt"],
                                                    ["trueupflag"] = dr_dtdata_notes_setup_tables_fees["trueupflag"].ToString(),
                                                    ["levyldincl"] = dr_dtdata_notes_setup_tables_fees["levyldincl"],
                                                    ["basisincl"] = dr_dtdata_notes_setup_tables_fees["basisincl"],
                                                    ["stripval"] = dr_dtdata_notes_setup_tables_fees["stripval"],
                                                    ["actual_startdt"] = dr_dtdata_notes_setup_tables_fees["actual_startdt"].ToString(),
                                                    ["feescheduleid"] = dr_dtdata_notes_setup_tables_fees["feescheduleid"].ToString()
                                                };

                                                lstFees.Add(notes_tables_spread);
                                            }
                                        }
                                    }
                                    #region dtdata_notes_watchlist
                                    if (dtdata_notes_watchlist != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_watchlist in dtdata_notes_watchlist.Rows)
                                        {
                                            if ((dr_dtdata_notes_watchlist["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString())

                                                && (dr_dtData_notes_setup["effective_dates"].ToString() == (dr_dtdata_notes_watchlist["EffectiveDate"].ToString()))
                                                )
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_watchlist.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "svrwatchlist" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_watchlist[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);
                                                        }
                                                    }
                                                }
                                                lstdtdata_notes_watchlist.Add(innerDictionary);
                                            }
                                        }

                                    }
                                    #endregion
                                    //dtdata_notes_SpreadMaintenance
                                    #region "Prepayment SpreadMaintenanc"
                                    /*
                                    if (dtdata_notes_SpreadMaintenance != null)
                                    {


                                        foreach (DataRow dr_dtdata_notes_SpreadMaintenance in dtdata_notes_SpreadMaintenance.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_SpreadMaintenance["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_SpreadMaintenance["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_SpreadMaintenance.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {
                                                        if (drJsonFormat["Type"].ToString() == "tbl_SpreadMaintenance" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_SpreadMaintenance[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);

                                                        }
                                                    }

                                                }
                                                lstSpreadMaintenanc.Add(innerDictionary);
                                            }
                                        }

                                    }
                                    */
                                    #endregion

                                    #region "PrepayAdjustment"
                                    /*
                                    if (dtdata_notes_PrepayAdjustment != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_PrepayAdjustment in dtdata_notes_PrepayAdjustment.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_PrepayAdjustment["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_PrepayAdjustment["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_PrepayAdjustment.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {

                                                        if (drJsonFormat["Type"].ToString() == "tbl_PrepayAdjustment" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_PrepayAdjustment[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);

                                                        }
                                                    }
                                                }
                                                lstPrepayAdjustment.Add(innerDictionary);
                                            }
                                        }
                                    }
                                    */
                                    #endregion

                                    #region "MinSpreadInterest"
                                    /*
                                    if (dtdata_notes_MinSpreadInterest != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_MinSpreadInterest in dtdata_notes_MinSpreadInterest.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_MinSpreadInterest["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_MinSpreadInterest["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_MinSpreadInterest.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {

                                                        if (drJsonFormat["Type"].ToString() == "tbl_MinSpreadInterest" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_MinSpreadInterest[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);

                                                        }
                                                    }
                                                }
                                                lstMinSpreadInterest.Add(innerDictionary);
                                            }
                                        }
                                    }
                                    */
                                    #endregion

                                    #region "MinFee"
                                    /*
                                    if (dtdata_notes_MinFee != null)
                                    {
                                        foreach (DataRow dr_dtdata_notes_MinFee in dtdata_notes_MinFee.Rows)
                                        {
                                            if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_MinFee["EffectiveDate_Prepay"].ToString()) && (dr_dtdata_notes_MinFee["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                            {
                                                Dictionary<string, Object> innerDictionary = new Dictionary<string, object>();
                                                foreach (DataColumn dc in dtdata_notes_MinFee.Columns)
                                                {
                                                    string _key = dc.ColumnName;
                                                    foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                                    {

                                                        if (drJsonFormat["Type"].ToString() == "tbl_MinFee" && drJsonFormat["key"].ToString() == _key)
                                                        {
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_MinFee[dc], drJsonFormat["DataType"].ToString());
                                                            innerDictionary.Add(_key, _value);

                                                        }
                                                    }
                                                }
                                                lstMinFee.Add(innerDictionary);
                                            }
                                        }
                                    }
                                    */
                                    #endregion

                                    //if (lstSpread.Count > 0 || lstindex_floor.Count > 0 || lstFees.Count > 0 || lstRate.Count > 0)
                                    {
                                        if (lstFees.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("fee", lstFees);
                                        }
                                        if (lstnotes_funding.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("funding", lstnotes_funding);
                                        }

                                        if (lstnotes_noteperiodiccal.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("noteperiodiccalc", lstnotes_noteperiodiccal);
                                        }

                                        if (lstnotes_amsch.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("amsch", lstnotes_amsch);
                                        }

                                        if (lstnotes_pikrate.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("pikrate", lstnotes_pikrate);
                                        }

                                        if (lstnotes_piksch.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("piksch", lstnotes_piksch);
                                        }

                                        if (lstSpreadMaintenanc.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("YMSpread", lstSpreadMaintenanc);
                                        }

                                        if (lstPrepayAdjustment.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("PrepayAdjustment", lstPrepayAdjustment);
                                        }

                                        if (lstMinMultSchedule.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("MinMultSchedule", lstMinMultSchedule);
                                        }
                                        //
                                        if (lstFeeCredits.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("FeeCredits", lstFeeCredits);
                                        }
                                        if (lstdtdata_notes_watchlist.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("svrwatchlist", lstdtdata_notes_watchlist);
                                        }

                                        /*
                                        if (lstSpread.Count > 0)
                                        {
                                            innerData_Notes_tables_spread.Add("spread", lstSpread);
                                        }
                                        if (lstindex_floor.Count > 0)
                                        {
                                            innerData_Notes_tables_spread.Add("index_floor", lstindex_floor);
                                        }                                    
                                        if (lstRate.Count > 0)
                                        {
                                            innerData_Notes_tables_spread.Add("rate", lstRate);
                                        }
                                        if (lstcoupon_floor.Count > 0)
                                        {
                                            innerData_Notes_tables_spread.Add("coupon_floor", lstcoupon_floor);
                                        }
                                        if (lstCoupon_cap.Count > 0)
                                        {
                                            innerData_Notes_tables_spread.Add("coupon_cap", lstCoupon_cap);
                                        }
                                        if (lstIndex_cap.Count >0)
                                        {
                                            innerData_Notes_tables_spread.Add("index_cap", lstIndex_cap);
                                        }
                                        if (lstamort_rate.Count>0)
                                        {
                                            innerData_Notes_tables_spread.Add("amort_rate", lstamort_rate);
                                        }
                                        if (lstamort_spread.Count>0)
                                        {
                                            innerData_Notes_tables_spread.Add("amort_spread", lstamort_spread);
                                        }
                                        if (lstamort_rate_floor.Count > 0)
                                        {
                                            innerData_Notes_tables_spread.Add("amort_rate_floor", lstamort_rate_floor);
                                        }
                                        if (lstamort_rate_cap.Count > 0)
                                        {
                                            innerData_Notes_tables_spread.Add("amort_rate_cap", lstamort_rate_cap);
                                        }                                    
                                        */


                                        // innerData_Deal_dictionary.Add("tables", innerData_Notes_tables_spread);
                                    }

                                }
                                //innerData_Deal_date.Add(dr_dtData_notes_setup["effective_dates"].ToString(), ObjToCsv.DictionaryToObject(innerData_Deal_dictionary));
                                // innerData_Deal_date.Add(dr_dtData_notes_setup["effective_dates"].ToString(), innerData_Notes_tables_spread);

                                //notes_Deal.Add(dr_dtData_notes_setup["effective_dates"].ToString(), innerData_Notes_tables_spread);
                                notes_Deal.Add(dr_dtData_notes_setup["effective_dates"].ToString(), ObjToCsv.DictionaryToObject(notes_Deal_setup_dictionary));

                            }
                        }
                    }

                    //Dictionary<String, Object> notes_Deal = new Dictionary<String, Object>()
                    //{
                    //    ["id"] = dtNotes_Root.Rows[i]["id"].ToString(),
                    //    ["name"] = dtNotes_Root.Rows[i]["name"].ToString(),
                    //    ["type"] = dtNotes_Root.Rows[i]["type"].ToString()
                    //    //["setup"] = setup
                    //};

                    //notes_Deal.Add(innerData_Deal_date);
                    innerData.Add(dtNotes_Root.Rows[i]["id"].ToString(), ObjToCsv.DictionaryToObject(notes_Deal));
                }

                data1.notes = notes;
                #endregion

                #region structure
                dynamic structure = new ExpandoObject();
                IDictionary<string, object> innerData_structure = (IDictionary<string, object>)structure;
                var lstStructure = new List<Dictionary<string, object>>();
                if (dtdataStructure != null)
                {
                    foreach (DataRow dr_dtdataStructure in dtdataStructure.Rows)
                    {

                        Dictionary<String, Object> data_structure = new Dictionary<String, Object>()
                        {
                            ["from"] = dr_dtdataStructure["from"],
                            ["to"] = dr_dtdataStructure["to"],
                        };

                        lstStructure.Add(data_structure);
                    }
                }
                data1.structure = lstStructure;//structure;
                #endregion


                #region index

                dynamic index = new ExpandoObject();

                /*
                IDictionary<string, object> innerData_Index = (IDictionary<string, object>)index;
                if (dtdata_index != null)
                {
                    foreach (DataRow dr_dtdata_index in dtdata_index.Rows)
                    {
                        innerData_Index.Add(dr_dtdata_index["date"].ToString(), dr_dtdata_index["value"]);
                    }
                    index = innerData_Index;

                    
                }
                */

                //Dictionary<String, Object> notes_Deal_setup_dictionary = new Dictionary<String, Object>();
                Dictionary<String, Object> innerData_Index = new Dictionary<String, Object>();
                Dictionary<String, Object> innerData_Libor = new Dictionary<String, Object>();
                Dictionary<String, Object> innerData_SOFR = new Dictionary<String, Object>();

                Dictionary<String, Object> innerData_IndexType = new Dictionary<String, Object>();

                if (dtdata_index != null)
                {
                    var dtIndexname = dtdata_index.DefaultView.ToTable(true, "indexname");

                    foreach (DataRow dr in dtIndexname.Rows)
                    {
                        var cntIndexbyType = (from r in dtdata_index.AsEnumerable()
                                  .Where(x => x["indexname"].ToString().ToLower() == dr["indexname"].ToString().ToLower())
                                              select r["indexname"]).Count();

                        int cnt = 0;
                        foreach (DataRow dr_dtdata_index in dtdata_index.Rows)
                        {
                            if (dr["indexname"].ToString().ToLower() == dr_dtdata_index["indexname"].ToString().ToLower())
                            {
                                cnt++;
                                innerData_IndexType.Add(dr_dtdata_index["date"].ToString(), dr_dtdata_index["value"]);

                                if (cntIndexbyType == cnt)
                                {
                                    Dictionary<String, Object> tmpDict = new Dictionary<String, Object>(innerData_IndexType);


                                    innerData_Index.Add(dr["indexname"].ToString().ToLower(), tmpDict);

                                    innerData_IndexType.Clear();


                                }

                            }
                        }
                    }


                    /*
                    foreach (DataRow dr_dtdata_index in dtdata_index.Rows)
                    {
                        if (dr_dtdata_index["indexname"].ToString().ToLower() == "sofr")
                        {
                            innerData_SOFR.Add(dr_dtdata_index["date"].ToString(), dr_dtdata_index["value"]);
                        }
                        else
                        {
                            innerData_Libor.Add(dr_dtdata_index["date"].ToString(), dr_dtdata_index["value"]);
                        }
                    }

                   // index = innerData_Index;
                    */

                }

                /*
                // enable if condition if empty key not required
                //if (innerData_Libor.Count > 0)
                {
                    innerData_Index.Add("libor", innerData_Libor);
                }

                //if (innerData_SOFR.Count() >0 ) 
                {
                    innerData_Index.Add("sofr", innerData_SOFR);
                }
                */
                data1.index = innerData_Index;
                #endregion


                #region listfeefunctions
                dynamic listfeefunctions = new ExpandoObject();
                IDictionary<string, object> innerData_listfeefunctions = (IDictionary<string, object>)listfeefunctions;
                var lstfeefunctions = new List<Dictionary<string, object>>();
                if (dtdata_feefunctions != null)
                {
                    foreach (DataRow dr_dtfeefunctions in dtdata_feefunctions.Rows)
                    {

                        Dictionary<String, Object> data_feefunctions = new Dictionary<String, Object>()
                        {
                            ["FunctionNameID"] = dr_dtfeefunctions["FunctionNameID"],
                            ["FunctionGuID"] = dr_dtfeefunctions["FunctionGuID"],
                            ["FunctionNameText"] = dr_dtfeefunctions["FunctionNameText"],
                            ["FunctionTypeText"] = dr_dtfeefunctions["FunctionTypeText"],
                            ["FunctionTypeID"] = dr_dtfeefunctions["FunctionTypeID"],
                            ["PaymentFrequencyText"] = dr_dtfeefunctions["PaymentFrequencyText"],
                            ["PaymentFrequencyID"] = dr_dtfeefunctions["PaymentFrequencyID"],
                            ["AccrualBasisText"] = dr_dtfeefunctions["AccrualBasisText"],
                            ["AccrualBasisID"] = dr_dtfeefunctions["AccrualBasisID"],
                            ["AccrualStartDateText"] = dr_dtfeefunctions["AccrualStartDateText"],
                            ["AccrualStartDateID"] = dr_dtfeefunctions["AccrualStartDateID"],
                            ["AccrualPeriodText"] = dr_dtfeefunctions["AccrualPeriodText"],
                            ["AccrualPeriodID"] = dr_dtfeefunctions["AccrualPeriodID"],
                            ["LookupID"] = dr_dtfeefunctions["LookupID"],
                            ["Name"] = dr_dtfeefunctions["Name"],
                            ["IsUsedInFeeSchedule"] = dr_dtfeefunctions["IsUsedInFeeSchedule"].ToBoolean(),
                        };

                        lstfeefunctions.Add(data_feefunctions);
                    }
                }
                data1.lstfeefunctions = lstfeefunctions;//structure;
                #endregion


                string _jsonData = JsonConvert.SerializeObject(data1);

                string fileName = "request_rules.json";
                //string currentDirectoryPath = Directory.GetCurrentDirectory() + @"\wwwroot\JSONTemplate";

                //string finalFileNameWithPath = string.Empty;
                //finalFileNameWithPath = string.Format("{0}\\{1}", currentDirectoryPath, fileName);

                //var newFile = new FileInfo(finalFileNameWithPath);

                //string jsonRequest = System.IO.File.ReadAllText(finalFileNameWithPath);

                string currentDirectoryPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot//JSONTemplate//" + fileName);
                string jsonRequest = System.IO.File.ReadAllText(currentDirectoryPath);

                //dynamic 
                objJsonResult = JsonConvert.DeserializeObject<ExpandoObject>(jsonRequest);
                objJsonResult.data.data = JsonConvert.DeserializeObject<ExpandoObject>(_jsonData);  // _jsonData;


                objJsonResult.data.data.period_end_date = dtDataRootinfo.Rows[0]["period_end_date"].ToString();
                objJsonResult.data.engine = dtDataRootinfo.Rows[0]["engine"].ToString(); ;
                objJsonResult.data.data.period_start_date = dtDataRootinfo.Rows[0]["period_start_date"].ToString();
                objJsonResult.data.data.root_note_id = dtDataRootinfo.Rows[0]["root_note_id"].ToString();
                objJsonResult.data.data.calc_basis = dtDataRootinfo.Rows[0]["calc_basis"].ToBoolean();
                objJsonResult.data.data.calc_basis_freq = dtDataRootinfo.Rows[0]["calc_basis_freq"].ToString();
                objJsonResult.data.data.calc_deffee_basis = dtDataRootinfo.Rows[0]["calc_deffee_basis"].ToBoolean();
                objJsonResult.data.data.calc_disc_basis = dtDataRootinfo.Rows[0]["calc_disc_basis"].ToBoolean();
                objJsonResult.data.data.calc_capcosts_basis = dtDataRootinfo.Rows[0]["calc_capcosts_basis"].ToBoolean();
                //objJsonResult.data.data.init_logging = dtDataRootinfo.Rows[0]["init_logging"].ToBoolean();
                objJsonResult.data.data.disable_businessday = dtDataRootinfo.Rows[0]["DisableBusinessDay"].ToString();
                objJsonResult.data.data.maturity_scenario_override = dtDataRootinfo.Rows[0]["MaturityScenarioOverride"].ToString();
                objJsonResult.data.data.debug = dtDataRootinfo.Rows[0]["debug"].ToBoolean();
                objJsonResult.data.data.use_servicingactual = dtDataRootinfo.Rows[0]["UseServicingActual"].ToString();

                objJsonResult.data.data.accountingclose = dtDataRootinfo.Rows[0]["accountingclose"].ToBoolean();

                /*
                data1.period_end_date = dtDataRootinfo.Rows[0]["period_end_date"].ToString();
                data1.period_start_date = dtDataRootinfo.Rows[0]["period_start_date"].ToString();
                data1.root_note_id = dtDataRootinfo.Rows[0]["root_note_id"].ToString();
                data1.calc_basis = dtDataRootinfo.Rows[0]["calc_basis"].ToBoolean();
                data1.calc_deffee_basis = dtDataRootinfo.Rows[0]["calc_deffee_basis"].ToBoolean();
                data1.calc_disc_basis = dtDataRootinfo.Rows[0]["calc_disc_basis"].ToBoolean();
                data1.calc_capcosts_basis = dtDataRootinfo.Rows[0]["calc_capcosts_basis"].ToBoolean();
                data1.init_logging = dtDataRootinfo.Rows[0]["init_logging"].ToBoolean();
                */
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
                        if (CalcType == 776)
                        {
                            objJsonResult.data.rules = _fileContent;
                        }
                        else
                        {
                            _fileContent = Regex.Replace(_fileContent, @"\\r\\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\r\n", "");
                            _fileContent = Regex.Replace(_fileContent, @"\\""", "");
                            if (CommonHelper.ValidateJSON(_fileContent))
                            {
                                objJsonResult.data.rules = JsonConvert.DeserializeObject(_fileContent);
                            }
                            else
                            {
                                objJsonResult.data.rules = _fileContent;
                            }
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
                            objJsonResult.data.data.accounts = JsonConvert.DeserializeObject(_fileContent);
                        }
                        else
                        {
                            objJsonResult.data.data.accounts = _fileContent;
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
                            objJsonResult.data.data.config = JsonConvert.DeserializeObject(_fileContent);
                        }
                        else
                        {
                            objJsonResult.data.data.config = _fileContent;
                        }
                    }
                    #endregion
                }
                //foreach (DataRow drJsonTemplate in dtJsonTemplate.Rows)
                //{
                //    if (drJsonTemplate["key"].ToString() == "rules")
                //    {
                //        objJsonResult.data.data.rules = JsonConvert.DeserializeObject(drJsonTemplate["value"].ToString());
                //    }

                //    if (drJsonTemplate["key"].ToString() == "accounts")
                //    {
                //        objJsonResult.data.data.accounts = JsonConvert.DeserializeObject(drJsonTemplate["value"].ToString());
                //    }

                //    if (drJsonTemplate["key"].ToString() == "config")
                //    {
                //        objJsonResult.data.data.config = JsonConvert.DeserializeObject(drJsonTemplate["value"].ToString());
                //    }
                //}

                #region  config from db

                DataTable dt_config_distinct_name;

                dt_config_distinct_name = dtdata_config_fee_config.DefaultView.ToTable(true, "feename", "type", "frequency", "Coverage", "function");


                Dictionary<String, Object> config_fee_config = new Dictionary<string, object>();
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



                //dynamic confignew = new ExpandoObject();

                //objJsonResult.data.data.config.fee.confignew= config_fee;
                string feejson = JsonConvert.SerializeObject(config_fee_config);
                objJsonResult.data.data.config.fee.config = JsonConvert.DeserializeObject(feejson);

                #endregion

                #region effective_dates
                string[] arrEffectiveDt = dtDataEffective_dates.AsEnumerable().Select(x => x.Field<string>("effective_dates")).ToArray();
                string effective_dates = JsonConvert.SerializeObject(arrEffectiveDt);
                dynamic _effective_dates = JsonConvert.DeserializeObject(effective_dates);
                objJsonResult.data.data.effective_dates = _effective_dates;



                #endregion


                //dtdata_calendars
                #region calendars
                calendars calendars = new calendars();
                var lstcalenders = new List<Dictionary<string, object>>();
                var innerData_root_calenders = new Dictionary<string, List<Dictionary<string, string[]>>>();
                IDictionary<string, object> innerData_calendars = (IDictionary<string, object>)index;

                string[] arrCalendarUSDt = dtdata_calendars.AsEnumerable().Where(x => x.Field<string>("HolidaytypeText") == "US").Select(x => x.Field<string>("HoliDayDate")).ToArray();
                string[] arrCalendarUKDt = dtdata_calendars.AsEnumerable().Where(x => x.Field<string>("HolidaytypeText") == "UK").Select(x => x.Field<string>("HoliDayDate")).ToArray();
                string[] arrCalendarUSandUKDt = dtdata_calendars.AsEnumerable().Where(x => x.Field<string>("HolidaytypeText") == "US & UK").Select(x => x.Field<string>("HoliDayDate")).ToArray();

                calendars.US = arrCalendarUSDt;
                calendars.UK = arrCalendarUKDt;
                calendars.US_and_UK = arrCalendarUSandUKDt;

                //string calendar_dates = JsonConvert.SerializeObject(arrCalendarDt);
                //dynamic _calendar_dates = JsonConvert.DeserializeObject(calendar_dates);               

                objJsonResult.data.data.calendar = calendars;


                //innerData_root_calenders.Add("US", arrCalendarDt);
                //data1.calendars = innerData_root_calenders;


                //string[] arrEffectiveDt = dtDataEffective_dates.AsEnumerable().Select(x => x.Field<string>("HoliDayDate")).ToArray();
                //string effective_dates = JsonConvert.SerializeObject(arrEffectiveDt);
                //dynamic _effective_dates = JsonConvert.DeserializeObject(effective_dates);
                //objJsonResult.data.data.effective_dates = _effective_dates;


                //objJsonResult.data.data.effective_dates = _effective_dates;

                //if (dtdata_calendars != null)
                //{
                //    foreach (DataRow dr_dtdata_calendars in dtdata_calendars.Rows)
                //    {
                //        if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_setup_tables_piksch["EffectiveDate"].ToString()) && (dr_dtdata_notes_setup_tables_piksch["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                //        {

                //            Dictionary<String, Object> notes_tables_piksch = new Dictionary<String, Object>()
                //            {
                //                ["dt"] = dr_dtdata_notes_setup_tables_piksch["dt"].ToString(),
                //                ["val"] = dr_dtdata_notes_setup_tables_piksch["val"]
                //            };

                //            lstnotes_piksch.Add(notes_tables_piksch);
                //        }
                //    }
                //}

                //dynamic calendars = new ExpandoObject();
                //IDictionary<string, object> innerData_calendars = (IDictionary<string, object>)index;
                //if (dtdata_calendars != null)
                //{
                //    foreach (DataRow dr_dtdata_calendars in dtdata_calendars.Rows)
                //    {
                //        innerData_Index.Add(dr_dtdata_calendars["HolidayTypeText"].ToString(), dr_dtdata_calendars["HoliDayDate"]);
                //    }
                //    calendars = innerData_calendars;
                //}
                //data1.calendars = calendars;
                #endregion


                #region meta
                dynamic meta = new ExpandoObject();
                IDictionary<string, object> innerData_meta = (IDictionary<string, object>)meta;
                if (dtDataRootinfo != null)
                {
                    innerData_meta.Add("client_reference_id", dtDataRootinfo.Rows[0]["client_reference_id"].ToString());
                    //innerData_meta.Add("batch", batchType);
                    innerData_meta.Add("batch", dtDataRootinfo.Rows[0]["batchType"].ToBoolean());
                    meta = innerData_meta;
                }
                objJsonResult.meta = meta;
                #endregion

                return objJsonResult;
                //}
            }
            catch (Exception ex)
            {

                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in GenerateCalcRequest for ID " + objectID + " " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetDealCalcRequestData", "", ex);
                //rtrmessage = "Exception";

                return "pH01OUhWWG4BNT684PGXPSiOU8bHRI19" + ex.Message.ToString();
            }

            //return objJsonResult;
            //return "";
        }

        public string SubmitCalcRequest(string objectid, int objecttypeid, string analysisID, int calctype, bool isbatchrequest, string calc)
        {
            string rtrmessage = "";
            dynamic objJsonResult;
            try
            {
                GetConfigSetting();

                string headerkey = Sectionroot.GetSection("Authkeyname").Value;
                string headerValue = Sectionroot.GetSection("Authkeyvalue").Value;
                string strAPI = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;

                bool isTestRequest = false;

                if (calctype == 776)// 776-PrepayCalculator
                {
                    PrepayPremiumLogic prepay = new PrepayPremiumLogic();
                    objJsonResult = prepay.GetDealCalcRequestDataForPrepayment(objectid, objecttypeid, analysisID, calctype, false, true);
                }
                else
                {
                    objJsonResult = GetDealCalcRequestData(objectid, objecttypeid, analysisID, calctype, isbatchrequest, isTestRequest);
                }
                var returnType = objJsonResult.GetType();
                if (returnType.Name == "Int32")
                {
                    rtrmessage = "Batch Canceled";
                }
                else if (returnType.Name == "String")
                {
                    if (objJsonResult.Contains("pH01OUhWWG4BNT684PGXPSiOU8bHRI19") == true)
                    {
                        rtrmessage = "Error in Json creation";
                        UpdateCalculationRequestsStatus(objectid, "", -1, analysisID, useridforSys_Scheduler, rtrmessage + " " + objJsonResult);
                    }

                }
                else
                {
                    var content = new StringContent(JsonConvert.SerializeObject(objJsonResult), Encoding.UTF8, "application/json");
                    System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Add(headerkey, headerValue);
                        var res = client.PostAsync(strAPI, content);
                        try
                        {
                            HttpResponseMessage response1 = res.Result.EnsureSuccessStatusCode();
                            if (response1.IsSuccessStatusCode)
                            {
                                var Outputresponse = response1.Content.ReadAsStringAsync().Result;
                                var CalcResponse = JsonConvert.DeserializeObject<Jsonresponse>(Outputresponse);
                                UpdateCalculationRequestsStatus(objectid, CalcResponse.request_id, 0, analysisID, "00000000-0000-0000-0000-000000000000", "");
                                rtrmessage = "CalcSubmit";

                                //Log Status Update sucessfully
                                //response1.StatusCode
                                LoggerLogic log = new LoggerLogic();
                                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Sucessfully Submit in SubmitCalcRequest in api  " + objectid + " || StatusCode " + response1.StatusCode, objectid, "");
                            }
                            else
                            {
                                UpdateCalculationRequestsStatus(objectid, "", -1, analysisID, useridforSys_Scheduler, "");
                                //Create log when status code != IsSuccessStatusCode
                                //response1.StatusCode
                                LoggerLogic log = new LoggerLogic();
                                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest in api  " + objectid + " || StatusCode " + response1.StatusCode, objectid, "");
                            }
                        }
                        catch (Exception e)
                        {
                            UpdateCalculationRequestsStatus(objectid, "", -1, analysisID, useridforSys_Scheduler, e.Message.ToString());
                            LoggerLogic log = new LoggerLogic();
                            log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest in api " + objectid + " " + e.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "SubmitCalcRequest", "", e);
                            rtrmessage = "Exception";
                        }
                    }
                }
            }
            catch (Exception ex)
            {

                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest for ID " + objectid + " " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "SubmitCalcRequest", "", ex);
                rtrmessage = "Exception";
            }
            return rtrmessage;
        }

        public List<V1CalculationStatusDataContract> GetRecordsFromCalculationRequest()
        {
            return _v1CalcRepository.GetRecordsFromCalculationRequest();
        }
        public List<V1CalculationStatusDataContract> GetDealidForPrepaymentCalculation()
        {
            return _v1CalcRepository.GetDealidForPrepaymentCalculation();
        }
        public List<V1CalculationStatusDataContract> GetRequestIDFromCalculationQueueRequest()
        {
            return _v1CalcRepository.GetRequestIDFromCalculationQueueRequest();
        }

        public void InsertUpdateCalculationQueueRequest(string RequestID, int? TransactionOutput, int? NotePeriodicOutput, int? StrippingOutput, int? Prepaypremium_Output, int? Prepayallocations_Output, int? DailyInterestAcc_Output, int IsRetry, string CreatedBy)
        {
            _v1CalcRepository.InsertUpdateCalculationQueueRequest(RequestID, TransactionOutput, NotePeriodicOutput, StrippingOutput, Prepaypremium_Output, Prepayallocations_Output, DailyInterestAcc_Output, IsRetry, CreatedBy);
        }
        public void DeleteTransactionEntry(string AnalysisID, string crenoteid)
        {
            _v1CalcRepository.DeleteTransactionEntry(AnalysisID, crenoteid);
        }
        public string CallBatchCancelAPI(DataTable requestidarray)
        {
            string result = "";
            GetConfigSetting();
            //convert data table to array
            string[] REQUESTID = requestidarray.Rows.OfType<DataRow>().Select(k => k[0].ToString()).ToArray();
            dynamic data = new ExpandoObject();
            data.property = "cancelled_flag";
            data.value = true;
            data.request_ids = REQUESTID;

            string headerkey = Sectionroot.GetSection("Authkeyname").Value;
            string headerValue = Sectionroot.GetSection("Authkeyvalue").Value;
            string apiPath = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;

            var content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");
            System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add(headerkey, headerValue);
                var res = client.PatchAsync(apiPath, content);
                try
                {

                    HttpResponseMessage response1 = res.Result.EnsureSuccessStatusCode();
                    if (response1.IsSuccessStatusCode)
                    {
                        var Outputresponse = response1.Content.ReadAsStringAsync().Result;
                        var CalcResponse = JsonConvert.DeserializeObject<Jsonresponse>(Outputresponse);
                        result = CalcResponse.message;
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
            return result;
        }


        public string UpdateM61EngineCalcStatus(string RequestID, int Status, string errmsg)
        {
            return _v1CalcRepository.UpdateM61EngineCalcStatus(RequestID, Status, errmsg);
        }

        public string UpdateM61EngineCalcStatusForLiability(string RequestID, int Status, string errmsg)
        {
            return _v1CalcRepository.UpdateM61EngineCalcStatusForLiability(RequestID, Status, errmsg);
        }

        public void UpdateCalculationStatusForDependents(string CRENoteID, string AnalysisID)
        {
            _v1CalcRepository.UpdateCalculationStatusForDependents(CRENoteID, AnalysisID);
        }
        public DataTable GetDataFromCalculationRequestsByRequestID(string RequestID)
        {
            return _v1CalcRepository.GetDataFromCalculationRequestsByRequestID(RequestID);
        }

        public V1CalcQueueSaveOutput GetDataFromCalculationRequestsLiabilityByRequestID(string RequestID)
        {
            return _v1CalcRepository.GetDataFromCalculationRequestsLiabilityByRequestID(RequestID);
        }

        public int InsertCalculatorOutputJsonInfo_V1(string RequestID, Guid? UserID, String FileName, string FileType)
        {
            return _v1CalcRepository.InsertCalculatorOutputJsonInfo_V1(RequestID, UserID, FileName, FileType);
        }

        public int InsertPrepayPremiumEntry(DataTable dtPrepaypremiumoutput, string CreatedBy)
        {
            return _v1CalcRepository.InsertPrepayPremiumEntry(dtPrepaypremiumoutput, CreatedBy);
        }
        public int InsertPrepayAllocationsEntry(DataTable dtPrepayallocationsoutput, string CreatedBy)
        {
            return _v1CalcRepository.InsertPrepayAllocationsEntry(dtPrepayallocationsoutput, CreatedBy);
        }

        public DataTable GetTransactionEntryFromAccountingClose(string Noteid, string AnalysisID)
        {
            return _v1CalcRepository.GetTransactionEntryFromAccountingClose(Noteid, AnalysisID);
        }
        public DataTable GetNoteInfoForPIKExport_V1(string Noteid)
        {
            return _v1CalcRepository.GetNoteInfoForPIKExport_V1(Noteid);
        }
        public DataTable GetTransactionTypeIsClub_V1()
        {
            return _v1CalcRepository.GetTransactionTypeIsClub_V1();
        }
        public void InsertNoteExtentionCalcField(string CRENoteID, Guid? AnalysisID, DateTime? MaturityUsedInCalc, string CreatedBy)
        {
            _v1CalcRepository.InsertNoteExtentionCalcField(CRENoteID, AnalysisID, MaturityUsedInCalc, CreatedBy);
        }

        public string SavePeriodicOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username)
        {
            string status = "";
            int? responsecode = null;
            int rowscount = 0, month = 0;
            DateTime? dtInitMatDate = Convert.ToDateTime("01/01/1990");
            LoggerLogic Log = new LoggerLogic();
            try
            {

                var cts = new CancellationTokenSource();

                var strPeriodicAPI = strAPI + "/" + requestid + "/outputs/periodic.csv";
                Log.WriteLogInfo("CalcDataSaving", "inside get Periodic_Output 3 " + " Requestid " + requestid, requestid, "");
                V1CalcLogic _V1CalcLogic = new V1CalcLogic();
                System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
                dynamic response;
                using (var client = new HttpClient())
                using (var request = new HttpRequestMessage())
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    client.DefaultRequestHeaders.Add(headerkey, headerValue);
                    client.Timeout = TimeSpan.FromSeconds(60);

                    request.Method = HttpMethod.Get;
                    request.RequestUri = new Uri(strPeriodicAPI);
                    response = client.GetAsync(strPeriodicAPI, cts.Token).Result;
                    responsecode = (int)response.StatusCode;
                    response.EnsureSuccessStatusCode();
                }
                Log.WriteLogInfo("CalcDataSaving", "inside  get Periodic_Output 4 " + " Requestid " + requestid, requestid, "");

                if (response.IsSuccessStatusCode == true)
                {
                    Log.WriteLogInfo("CalcDataSaving", "inside  get Periodic_Output 5 " + " Requestid " + requestid, requestid, "");
                    var periodresponse = response.Content.ReadAsStringAsync().Result;
                    var periodoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(periodresponse);
                    DataTable dtperiodoutput = convertStringToDataTable(periodoutput.data);
                    List<string> Peridiccollist = new List<string>();
                    if (dtperiodoutput.Rows.Count > 0)
                    {
                        SourceNoteID = dtperiodoutput.Rows[0]["Note"].ToString();
                    }
                    foreach (DataRow row in dtperiodoutput.Rows)
                    {
                        row["Date"] = CommonHelper.ToDateTime(row["Date"]);
                        row["initbal_periodic"] = CommonHelper.StringToDecimal(row["initbal_periodic"]);
                        row["endbal"] = CommonHelper.StringToDecimal(row["endbal"]);
                        row["initbal_periodic"] = CommonHelper.StringToDecimal(row["initbal_periodic"]);
                        row["schprin"] = CommonHelper.StringToDecimal(row["schprin"]);
                        row["funding"] = CommonHelper.StringToDecimal(row["funding"]);
                        //row["act_periodpikint"] = CommonHelper.StringToDecimal(row["act_periodpikint"]);
                        row["paydown"] = CommonHelper.StringToDecimal(row["paydown"]);

                        //row["act_periodint"] = CommonHelper.StringToDecimal(row["act_periodint"]);
                        //row["act_periodpikintpaid"] = CommonHelper.StringToDecimal(row["act_periodpikintpaid"]);
                        row["act_pikprinpaid"] = CommonHelper.StringToDecimal(row["act_pikprinpaid"]);
                        row["clean_cost"] = CommonHelper.StringToDecimal(row["clean_cost"]);
                        row["feeamort"] = CommonHelper.StringToDecimal(row["feeamort"]);
                        row["cum_am_fee"] = CommonHelper.StringToDecimal(row["cum_am_fee"]);
                        row["am_capcosts"] = CommonHelper.StringToDecimal(row["am_capcosts"]);
                        row["am_disc"] = CommonHelper.StringToDecimal(row["am_disc"]);
                        row["gaapbasis"] = CommonHelper.StringToDecimal(row["gaapbasis"]);
                        row["curperintaccrmon"] = CommonHelper.StringToDecimal(row["curperintaccrmon"]);
                        row["curperpikintaccrmon"] = CommonHelper.StringToDecimal(row["curperpikintaccrmon"]);
                        row["intsuspensebal"] = CommonHelper.StringToDecimal(row["intsuspensebal"]);
                        row["allincouponrate"] = CommonHelper.StringToDecimal(row["allincouponrate"]);
                        row["gross_def_fees"] = CommonHelper.StringToDecimal(row["gross_def_fees"]);
                        row["rvrslof_intaccr"] = CommonHelper.StringToDecimal(row["rvrslof_intaccr"]);
                        row["curperintaccr"] = CommonHelper.StringToDecimal(row["curperintaccr"]);
                        row["intrcvdcurper"] = CommonHelper.StringToDecimal(row["intrcvdcurper"]);
                        row["totgaapintper"] = CommonHelper.StringToDecimal(row["totgaapintper"]);
                        row["am_cost"] = CommonHelper.StringToDecimal(row["am_cost"]);
                        row["balloon"] = CommonHelper.StringToDecimal(row["balloon"]);
                        row["rem_unfunded_commitment"] = CommonHelper.StringToDecimal(row["rem_unfunded_commitment"]);
                        row["month"] = CommonHelper.ToInt32(row["month"]);

                        row["levyld"] = CommonHelper.StringToDecimal(row["levyld"]);
                        row["cum_am_disc"] = CommonHelper.StringToDecimal(row["cum_am_disc"]);
                        row["cum_dailypikint"] = CommonHelper.StringToDecimal(row["cum_dailypikint"]);
                        row["cum_baladdon_am"] = CommonHelper.StringToDecimal(row["cum_baladdon_am"]);
                        row["cum_baladdon_nonam"] = CommonHelper.StringToDecimal(row["cum_baladdon_nonam"]);
                        row["cum_dailyint"] = CommonHelper.StringToDecimal(row["cum_dailyint"]);
                        row["cum_ddbaladdon"] = CommonHelper.StringToDecimal(row["cum_ddbaladdon"]);
                        row["cum_ddintdelta"] = CommonHelper.StringToDecimal(row["cum_ddintdelta"]);
                        row["cum_am_capcosts"] = CommonHelper.StringToDecimal(row["cum_am_capcosts"]);
                        row["initbal"] = CommonHelper.StringToDecimal(row["initbal"]);
                        row["cum_fee_levyld"] = CommonHelper.StringToDecimal(row["cum_fee_levyld"]);
                        row["period_ddintdelta_shifted"] = CommonHelper.StringToDecimal(row["period_ddintdelta_shifted"]);
                        row["intdeltabal"] = CommonHelper.StringToDecimal(row["intdeltabal"]);
                        row["cum_exit_fee_excl_lv_yield"] = CommonHelper.StringToDecimal(row["cum_exit_fee_excl_lv_yield"]);

                        row["periodend"] = CommonHelper.ToDateTime(row["periodend"]);
                        row["periodstart"] = CommonHelper.ToDateTime(row["periodstart"]);
                        row["pmtdtnotadj"] = CommonHelper.ToDateTime(row["pmtdtnotadj"]);
                        row["pmtdt"] = CommonHelper.ToDateTime(row["pmtdt"]);


                        row["yld_capcosts"] = CommonHelper.StringToDecimal(row["yld_capcosts"]);
                        row["bas_capcosts"] = CommonHelper.StringToDecimal(row["bas_capcosts"]);
                        row["am_capcosts"] = CommonHelper.StringToDecimal(row["am_capcosts"]);
                        row["yld_disc"] = CommonHelper.StringToDecimal(row["yld_disc"]);
                        row["bas_disc"] = CommonHelper.StringToDecimal(row["bas_disc"]);
                        row["am_disc"] = CommonHelper.StringToDecimal(row["am_disc"]);
                        row["gaapbv"] = CommonHelper.StringToDecimal(row["gaapbv"]);
                        row["act_actualdelta"] = CommonHelper.StringToDecimal(row["act_actualdelta"]);
                        row["dailyavgbal"] = CommonHelper.StringToDecimal(row["dailyavgbal"]);
                        row["pastdueint"] = CommonHelper.StringToDecimal(row["pastdueint"]);

                        //row["curperpikintaccr"] = CommonHelper.StringToDecimal(row["curperpikintaccr"]);
                        row["pmtdtpikint"] = CommonHelper.StringToDecimal(row["pmtdtpikint"]);
                        row["curperpikintaccr"] = CommonHelper.StringToDecimal(row["curperpikintaccr"]);

                        row["pikinitbalsepcomp"] = CommonHelper.StringToDecimal(row["pikinitbalsepcomp"]);
                        row["pikendbalsepcomp"] = CommonHelper.StringToDecimal(row["pikendbalsepcomp"]);
                        row["pikintsepcomp"] = CommonHelper.StringToDecimal(row["pikintsepcomp"]);
                        row["pikballoonsepcomp"] = CommonHelper.StringToDecimal(row["pikballoonsepcomp"]);

                        row["periodpikint"] = CommonHelper.StringToDecimal(row["periodpikint"]);
                        row["cum_unusedfee"] = CommonHelper.StringToDecimal(row["cum_unusedfee"]);
                        //row["initfunding"] = CommonHelper.StringToDecimal(row["initfunding"]);

                        row["netperiodpikamount"] = CommonHelper.StringToDecimal(row["netperiodpikamount"]);
                        row["cashint"] = CommonHelper.StringToDecimal(row["cashint"]);
                        row["capitalizedint"] = CommonHelper.StringToDecimal(row["capitalizedint"]);

                        row["act_periodpikintpaid"] = CommonHelper.StringToDecimal(row["act_periodpikintpaid"]);
                        row["periodpikinterestforperiod"] = CommonHelper.StringToDecimal(row["periodpikinterestforperiod"]);

                        row["cum_daily_pik_from_interest"] = CommonHelper.StringToDecimal(row["cum_daily_pik_from_interest"]);
                        row["cum_dailypikcomp"] = CommonHelper.StringToDecimal(row["cum_dailypikcomp"]);
                        row["cum_dailyintonpik"] = CommonHelper.StringToDecimal(row["cum_dailyintonpik"]);

                        if (row["month"].ToString() != "" && row["month"] != null)
                        {
                            if (month < CommonHelper.ToInt32(row["month"]))
                            {
                                month = Convert.ToInt32(row["month"]);
                                dtInitMatDate = Convert.ToDateTime(row["initmatdt"]);
                            }
                        }
                    }

                    if (dtperiodoutput.Rows.Count > 0)
                    {
                        Log.WriteLogInfo("CalcDataSaving", "going for Periodic_Output saving " + " Requestid " + requestid, requestid, "");
                        _V1CalcLogic.InsertUpdateNotePeriodicCalc(dtperiodoutput, AnalysisID, username, SourceNoteID);
                        _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, null, 266, null, null, null, null, 1, username);
                        _V1CalcLogic.InsertIntoCalculatorExtensionDbSave(SourceNoteID, AnalysisID, requestid, "Periodic", rowscount);




                        //var orderedRows = from row in dtperiodoutput.AsEnumerable()
                        //                  let date = DateTime.Parse(row.Field<string>("periodEnd"), CultureInfo.InvariantCulture)
                        //                  orderby date descending
                        //                  select row;
                        //dtInitMatDate = Convert.ToDateTime(orderedRows.CopyToDataTable().Rows[0]["initmatdt"].ToString());
                        if (dtInitMatDate.ToString() == "01/01/1990 00:00:00") dtInitMatDate = null;

                        _V1CalcLogic.InsertNoteExtentionCalcField(SourceNoteID, new Guid(AnalysisID), dtInitMatDate, username);

                        status = "Saved";
                        Log.WriteLogInfo("CalcDataSaving", "Periodic_Output saving ended " + " Requestid " + requestid, requestid, "");

                    }
                    else
                    {
                        _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, null, 266, null, null, null, null, 1, username);
                        status = "Saved";
                        Log.WriteLogInfo("CalcDataSaving", "Periodic_Output Row count 0." + " Requestid " + requestid, requestid, "");
                    }

                }
                else
                {
                    Log.WriteLogInfo("CalcDataSaving", "Periodic_Output File not found.Error Code : " + responsecode + " Requestid " + requestid, requestid, "");
                }

            }
            catch (Exception ex)
            {
                string result = "";
                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for : PeriodicOutput : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : PeriodicOutput as M61 output api did not responds in 10 secs ";
                }

                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }
                v1logic.UpdateCalculationRequestsStatus(SourceNoteID, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB." + status);
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in saving for PeriodicOutput " + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", ex.Message);

            }
            return status;
        }

        public string SaveTransactionsOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username, string noteid)
        {
            string status = "";
            int? responsecode = 0;
            LoggerLogic Log = new LoggerLogic();
            var cts = new CancellationTokenSource();
            string SavingFailedFor = "";
            int rowscount = 0;
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();
            DateTime? MaturityUsedInCalc = DateTime.MinValue;

            try
            {

                Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 1 " + " Requestid " + requestid, requestid, "");
                // transactions saving
                SavingFailedFor = "Transactions_Output";
                var strtransactionAPI = strAPI + "/" + requestid + "/outputs/transactions.csv";
                HttpClient transactionsclient = new HttpClient();
                transactionsclient.Timeout = TimeSpan.FromSeconds(60);
                transactionsclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 2 " + " Requestid " + requestid, requestid, "");
                var apitransactionsresult = transactionsclient.GetAsync(strtransactionAPI, cts.Token).Result;
                responsecode = (int)apitransactionsresult.StatusCode;
                Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 3 " + " Requestid " + requestid, requestid, "");
                if (apitransactionsresult.IsSuccessStatusCode == true)
                {
                    var transactionsresponse = apitransactionsresult.Content.ReadAsStringAsync().Result;
                    Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 4 " + " Requestid " + requestid, requestid, "");
                    var transactionsoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(transactionsresponse);

                    Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 5 " + " Requestid " + requestid, requestid, "");
                    DataTable dtTransactionsoutput = convertStringToDataTable(transactionsoutput.data);

                    List<string> collist = new List<string>();
                    foreach (DataColumn column in dtTransactionsoutput.Columns)
                    {
                        collist.Add(column.ColumnName);
                    }
                    string[] requiredcol = { "Date", "Note", "type", "value", "Fee Name", "IO Term End Date", "purpose", "remit_dt", "transdtbyrule_dt", "trans_dt", "due_dt", "LIBORPercentage", "PIKInterestPercentage", "PIKLiborPercentage", "SpreadPercentage", "AllInCouponRate", "adjustmenttype", "BalloonRepayAmount", "Comments", "IsClubTransactionOnSameDate", "IndexValue", "SpreadValue", "OriginalIndex" };

                    //remove column which are not required 
                    foreach (var item in collist)
                    {
                        var res = requiredcol.Contains(item);
                        if (res == false)
                        {
                            if (dtTransactionsoutput.Columns.IndexOf(item) != -1)
                            {
                                dtTransactionsoutput.Columns.Remove(item);
                            }
                        }
                    }
                    // add column which are required 
                    foreach (string item in requiredcol)
                    {
                        if (dtTransactionsoutput.Columns.IndexOf(item) == -1)
                        {
                            dtTransactionsoutput.Columns.Add(item);
                        }
                    }


                    DataTable dtTransactionOutputIsClubYes = new DataTable();
                    foreach (DataColumn dc in dtTransactionsoutput.Columns)
                    {
                        dtTransactionOutputIsClubYes.Columns.Add(dc.ColumnName, dc.DataType);
                    }

                    DataTable dtTransactionTypeIsClub = _V1CalcLogic.GetTransactionTypeIsClub_V1();
                    foreach (DataRow dr in dtTransactionTypeIsClub.Rows)
                    {
                        dtTransactionsoutput.Select(string.Format("[type] = '{0}'", dr["TransactionName"].ToString()))
                        .ToList<DataRow>()
                        .ForEach(r =>
                        {
                            r["IsClubTransactionOnSameDate"] = dr["IsClubTransactionOnSameDate"].ToString();
                        });
                    }

                    foreach (DataRow row in dtTransactionsoutput.Rows)
                    {
                        //541168c02f96461ab889a9444c9bfce5
                        //if ()

                        DateTime? due_dt = CommonHelper.ToDateTime(row["due_dt"]);
                        int? currentpurpose = CommonHelper.ToInt32(CommonHelper.StringToDecimal(row["purpose"]));
                        row["value"] = Math.Round(CommonHelper.StringToDecimal(row["value"]).GetValueOrDefault(0), 10);
                        row["IO Term End Date"] = CommonHelper.ToDateTime(row["IO Term End Date"]);
                        row["purpose"] = currentpurpose;
                        row["remit_dt"] = CommonHelper.ToDateTime(row["remit_dt"]);
                        row["transdtbyrule_dt"] = CommonHelper.ToDateTime(row["transdtbyrule_dt"]);
                        row["trans_dt"] = CommonHelper.ToDateTime(row["trans_dt"]);
                        row["due_dt"] = due_dt;
                        row["LIBORPercentage"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["LIBORPercentage"]).GetValueOrDefault(0), 10));
                        row["PIKInterestPercentage"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["PIKInterestPercentage"]).GetValueOrDefault(0), 10));
                        row["PIKLiborPercentage"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["PIKLiborPercentage"]).GetValueOrDefault(0), 10));
                        row["SpreadPercentage"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["SpreadPercentage"]).GetValueOrDefault(0), 10));

                        row["IndexValue"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["IndexValue"]).GetValueOrDefault(0), 10));
                        row["SpreadValue"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["SpreadValue"]).GetValueOrDefault(0), 10));
                        row["OriginalIndex"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["OriginalIndex"]).GetValueOrDefault(0), 10));
                        row["AllInCouponRate"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["AllInCouponRate"]).GetValueOrDefault(), 10));

                        if (currentpurpose != 0)
                        {
                            row["purpose"] = GetPurposeTypetext(currentpurpose);
                        }
                        else if (currentpurpose == 0)
                        {
                            row["purpose"] = null;
                        }
                        if (due_dt != null)
                        {
                            row["Date"] = due_dt;
                        }
                        if (row["IsClubTransactionOnSameDate"].ToString() == "Y")
                        {
                            dtTransactionOutputIsClubYes.Rows.Add(row.ItemArray);
                        }

                        if (row["type"].ToString() == "Balloon")
                        {
                            MaturityUsedInCalc = CommonHelper.ToDateTime(row["Date"]);
                        }
                    }

                    if (dtTransactionOutputIsClubYes.Rows.Count > 0)
                    {
                        DataTable dtResultofSum = dtTransactionOutputIsClubYes.AsEnumerable()
                        .GroupBy(r => new
                        {
                            Date = r["Date"],
                            Note = r["Note"],
                            type = r["type"],
                            FeeName = r["Fee Name"],
                            IOTermEndDate = r["IO Term End Date"],
                            purpose = r["purpose"],
                            remit_dt = r["remit_dt"],
                            transdtbyrule_dt = r["transdtbyrule_dt"],
                            trans_dt = r["trans_dt"],
                            due_dt = r["due_dt"],
                            LIBORPercentage = r["LIBORPercentage"],
                            PIKInterestPercentage = r["PIKInterestPercentage"],
                            PIKLiborPercentage = r["PIKLiborPercentage"],
                            SpreadPercentage = r["SpreadPercentage"],
                            AllInCouponRate = r["AllInCouponRate"],
                            adjustmenttype = r["adjustmenttype"],
                            BalloonRepayAmount = r["BalloonRepayAmount"],
                            Comments = r["Comments"],
                            IndexValue = r["IndexValue"],
                            SpreadValue = r["SpreadValue"],
                            OriginalIndex = r["OriginalIndex"]
                        })
                        .Select(g =>
                        {
                            var row = dtTransactionsoutput.NewRow();

                            row["Date"] = g.Key.Date;
                            row["Note"] = g.Key.Note;
                            row["type"] = g.Key.type;
                            row["Fee Name"] = g.Key.FeeName;
                            row["IO Term End Date"] = g.Key.IOTermEndDate;
                            row["purpose"] = g.Key.purpose;
                            row["remit_dt"] = g.Key.remit_dt;
                            row["transdtbyrule_dt"] = g.Key.transdtbyrule_dt;
                            row["trans_dt"] = g.Key.trans_dt;
                            row["due_dt"] = g.Key.due_dt;
                            row["LIBORPercentage"] = g.Key.LIBORPercentage;
                            row["PIKInterestPercentage"] = g.Key.PIKInterestPercentage;
                            row["PIKLiborPercentage"] = g.Key.PIKLiborPercentage;
                            row["SpreadPercentage"] = g.Key.SpreadPercentage;
                            row["AllInCouponRate"] = g.Key.AllInCouponRate;
                            row["adjustmenttype"] = g.Key.adjustmenttype;
                            row["BalloonRepayAmount"] = g.Key.BalloonRepayAmount;
                            row["Comments"] = g.Key.Comments;
                            row["value"] = g.Sum(r => Math.Round(CommonHelper.StringToDecimal(r.Field<string>("value")).GetValueOrDefault(0), 10));
                            row["IndexValue"] = g.Key.IndexValue;
                            row["SpreadValue"] = g.Key.SpreadValue;
                            row["OriginalIndex"] = g.Key.OriginalIndex;
                            return row;
                        }).CopyToDataTable();

                        var query = dtTransactionsoutput.AsEnumerable().Where(r => r.Field<string>("IsClubTransactionOnSameDate") == "Y");

                        foreach (var row in query.ToList())
                            row.Delete();

                        foreach (DataRow row in dtResultofSum.Rows)
                        {
                            dtTransactionsoutput.Rows.Add(row.ItemArray);
                        }
                    }

                    Log.WriteLogInfo("CalcDataSaving", " inside Transactions_Output 6 " + " Requestid " + requestid, requestid, "");

                    dtTransactionsoutput.Columns.Remove("IsClubTransactionOnSameDate");

                    if (dtTransactionsoutput.Rows.Count > 0)
                    {
                        PeriodicLogic pr = new PeriodicLogic();
                        DateTime? LastAccountingclosedate = pr.GetLastAccountingCloseDateByDealIDORNoteID(null, new Guid(noteid));
                        rowscount = dtTransactionsoutput.Rows.Count;

                        Log.WriteLogInfo("CalcDataSaving", "Transactions_Output saving started ." + dtTransactionsoutput.Rows.Count + " Requestid " + requestid, requestid, "");
                        //Transactions_Output
                        _V1CalcLogic.InsertTransactionEntry(dtTransactionsoutput, AnalysisID, username, SourceNoteID, username, noteid, LastAccountingclosedate);
                        Log.WriteLogInfo("CalcDataSaving", "Transactions_Output saving ended ." + dtTransactionsoutput.Rows.Count + " Requestid " + requestid, requestid, "");
                        if (MaturityUsedInCalc == DateTime.MinValue)
                        {
                            MaturityUsedInCalc = null;
                        }
                        _V1CalcLogic.UpdateTransactionEntryCash_NonCash(noteid, AnalysisID, Convert.ToDateTime(LastAccountingclosedate), MaturityUsedInCalc);

                        Log.WriteLogInfo("CalcDataSaving", "UpdateTransactionEntryCash_NonCash saving ended ." + dtTransactionsoutput.Rows.Count + " Requestid " + requestid, requestid, "");

                        if (AnalysisID.ToLower() == "c10f3372-0fc2-4861-a9f5-148f1f80804f")
                        {
                            Log.WriteLogInfo("BackShopExport", "ExportDataTobackShop called for AnalysisID :" + AnalysisID, requestid, "");

                            Thread thbackshop = new Thread(() => ExportDataTobackShop(noteid, requestid, SourceNoteID, username));
                            thbackshop.Start();
                        }
                        else
                        {
                            Log.WriteLogInfo("BackShopExport", "ExportDataTobackShop not called for AnalysisID :" + AnalysisID, requestid, "");
                        }


                        _V1CalcLogic.InsertIntoCalculatorExtensionDbSave(SourceNoteID, AnalysisID, requestid, "Transaction", rowscount);
                        status = "Saved";
                        _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, 266, null, null, null, null, null, 1, username);

                    }
                    else
                    {
                        Log.WriteLogInfo("CalcDataSaving", "Transactions_Output deleting old record." + " Requestid " + requestid, requestid, "");
                        //SourceNoteID is crenoteid
                        _V1CalcLogic.DeleteTransactionEntry(AnalysisID, SourceNoteID);
                        _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, 266, null, null, null, null, null, 1, username);
                        status = "Saved";
                        Log.WriteLogInfo("CalcDataSaving", "Transactions_Output Row count 0." + " Requestid " + requestid, requestid, "");
                    }
                }
                else
                {
                    Log.WriteLogInfo("CalcDataSaving", "Transactions_Output File not found.Error Code " + responsecode + " Requestid " + requestid, requestid, "");
                }
            }
            catch (Exception ex)
            {

                string result = "";
                V1CalcLogic v1logic = new V1CalcLogic();

                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : Transactions_Output as M61 output api did not responds in 60 secs ";
                }
                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }
                v1logic.UpdateCalculationRequestsStatus(SourceNoteID, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB." + status);
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in saving for Transactions_Output : " + responsecode + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", ex.Message);

            }

            return status;
        }
        public string SaveStripingOutput(string requestid, string headerkey, string headerValue, string strAPI, string SourceNoteID, string AnalysisID, string username)
        {
            string status = "";
            int? responsecode = null;
            LoggerLogic Log = new LoggerLogic();
            var cts = new CancellationTokenSource();
            string SavingFailedFor = "";
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();

            try
            {
                // strips saving
                SavingFailedFor = "Striping_Output";

                var strstripAPI = strAPI + "/" + requestid + "/outputs/strips.csv";
                HttpClient stripClient = new HttpClient();
                stripClient.DefaultRequestHeaders.Add(headerkey, headerValue);
                var stripres = stripClient.GetAsync(strstripAPI).Result;
                if (stripres.IsSuccessStatusCode == true)
                {
                    var response = stripres.Content.ReadAsStringAsync().Result;
                    var output = JsonConvert.DeserializeObject<Jsonperiodicresponse>(response);
                    DataTable dtoutput = convertStringToDataTable(output.data);

                    string[] requiredcol = { "Date", "Note", "type", "value", "Fee Name", "Rate", "Effective Date", "Parent Note" };

                    foreach (string item in requiredcol)
                    {
                        if (dtoutput.Columns.IndexOf(item) == -1)
                        {
                            dtoutput.Columns.Add(item);
                        }

                    }
                    List<string> collist = new List<string>();
                    foreach (DataColumn column in dtoutput.Columns)
                    {
                        collist.Add(column.ColumnName);
                    }
                    foreach (var item in collist)
                    {
                        var res = requiredcol.Contains(item);
                        if (res == false)
                        {
                            if (dtoutput.Columns.IndexOf(item) != -1)
                            {
                                dtoutput.Columns.Remove(item);
                            }
                        }
                    }
                    foreach (DataRow row in dtoutput.Rows)
                    {
                        row["value"] = CommonHelper.StringToDecimal(row["value"]);
                        row["Rate"] = CommonHelper.StringToDecimal(row["Rate"]);
                        row["Date"] = Convert.ToDateTime(row["Date"]);
                        row["Effective Date"] = Convert.ToDateTime(dtoutput.Rows[0]["Effective Date"]);
                    }
                    if (dtoutput.Rows.Count > 0)
                    {
                        if (dtoutput.Columns.IndexOf("Parent Note") == -1)
                        {
                            dtoutput.Columns.Add("Parent Note");
                        }
                        dtoutput.Columns["Parent Note"].ColumnName = "SourceNoteID";
                        dtoutput.Columns["Date"].SetOrdinal(0);
                        dtoutput.Columns["Note"].SetOrdinal(1);
                        dtoutput.Columns["type"].SetOrdinal(2);
                        dtoutput.Columns["value"].SetOrdinal(3);
                        dtoutput.Columns["Rate"].SetOrdinal(4);
                        dtoutput.Columns["Effective Date"].SetOrdinal(5);
                        dtoutput.Columns["Fee Name"].SetOrdinal(6);
                        dtoutput.Columns["SourceNoteID"].SetOrdinal(7);

                        _V1CalcLogic.InsertPayRuleDistribution(dtoutput, AnalysisID, username);

                    }
                }

                //  _V1CalcLogic.UpdateCalculationStatusForDependents(SourceNoteID, AnalysisID);

                status = "Saved";
                //_V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(2), "");
                _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, null, null, 266, null, null, null, 1, username);
            }
            catch (Exception ex)
            {

                string result = "";
                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for : Striping_Output : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : Striping_Output as M61 output api did not responds in 60 secs ";
                }

                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }
                v1logic.UpdateCalculationRequestsStatus(SourceNoteID, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB." + status);
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in saving for Striping_Output " + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", ex.Message);
            }

            return status;
        }
        public string SaveDailyData(string requestid, string headerkey, string headerValue, string strAPI, string noteid, string AnalysisID, string username)
        {
            Guid AnalysisIDGuid = new Guid(AnalysisID);
            string status = "";
            LoggerLogic Log = new LoggerLogic();
            int? responsecode = null;
            int NumberofDaysinPast = 0;
            int NumberofDaysinFuture = 0;
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();
            try
            {
                if (AnalysisID.ToLower() == "c10f3372-0fc2-4861-a9f5-148f1f80804f" || AnalysisID.ToLower() == "726671fa-16a9-44f6-af71-5d54492e7e82")
                {
                    Log.WriteLogInfo("CalcDataSaving", " inside SaveDailyData for default scenrio" + " Requestid " + requestid + " status " + status + " Analysis" + AnalysisID, requestid, "");
                    AppConfigLogic app = new AppConfigLogic();
                    List<AppConfigDataContract> appconfiglist = app.GetAppConfigByKey(new Guid(username), "NumberofDaysin");

                    foreach (AppConfigDataContract app1 in appconfiglist)
                    {
                        if (app1.Key.ToLower() == "NumberofDaysinPast".ToLower())
                        {
                            NumberofDaysinPast = Convert.ToInt32(app1.Value);
                        }
                        if (app1.Key.ToLower() == "NumberofDaysinFuture".ToLower())
                        {
                            NumberofDaysinFuture = Convert.ToInt32(app1.Value);
                        }
                    }

                    var cts = new CancellationTokenSource();
                    dynamic dailyDataresult;
                    var dailyDataAPI = strAPI + "/" + requestid + "/outputs/daily_data.csv";
                    using (var client = new HttpClient())
                    using (var request = new HttpRequestMessage())
                    {
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        client.DefaultRequestHeaders.Add(headerkey, headerValue);
                        client.Timeout = TimeSpan.FromSeconds(60);

                        request.Method = HttpMethod.Get;
                        request.RequestUri = new Uri(dailyDataAPI);
                        dailyDataresult = client.GetAsync(dailyDataAPI, cts.Token).Result;
                        responsecode = (int)dailyDataresult.StatusCode;
                        dailyDataresult.EnsureSuccessStatusCode();
                    }

                    if (dailyDataresult.IsSuccessStatusCode == true)
                    {
                        NoteLogic nl = new NoteLogic();
                        List<DailyInterestAccrualsDataContract> ListDailyInterest = new List<DailyInterestAccrualsDataContract>();
                        List<PeriodicInterestRateUsed> ListPeriodicInterestRateUsed = new List<PeriodicInterestRateUsed>();

                        var response = dailyDataresult.Content.ReadAsStringAsync().Result;
                        var output = JsonConvert.DeserializeObject<Jsonperiodicresponse>(response);
                        DataTable dtoutput = convertStringToDataTable(output.data);

                        List<string> collist = new List<string>();
                        foreach (DataColumn column in dtoutput.Columns)
                        {
                            collist.Add(column.ColumnName);
                        }

                        DateTime startdate = DateTime.Now.Date.AddDays(-NumberofDaysinPast);
                        DateTime enddate = DateTime.Now.Date.AddDays(NumberofDaysinFuture);

                        List<NotePeriodicOutputsDataContract> ListTrailingBalance = new List<NotePeriodicOutputsDataContract>();
                        foreach (DataRow row in dtoutput.Rows)
                        {
                            DailyInterestAccrualsDataContract dia = new DailyInterestAccrualsDataContract();

                            DateTime? cdate = CommonHelper.ToDateTime(row["Date"]);
                            decimal endbal = CommonHelper.StringToDecimal(row["endbal"]).GetValueOrDefault(0);
                            decimal dailyint = CommonHelper.StringToDecimal(row["dailyint"]).GetValueOrDefault(0);

                            decimal eff_spread_or_rate_val = CommonHelper.StringToDecimalWithNull(row["eff_spread_or_rate_val"]).GetValueOrDefault(0);
                            decimal eff_index_rate = CommonHelper.StringToDecimalWithNull(row["eff_index_rate"]).GetValueOrDefault(0);
                            decimal allincouponrate = CommonHelper.StringToDecimalWithNull(row["allincouponrate"]).GetValueOrDefault(0);

                            decimal allinpikrate = CommonHelper.StringToDecimalWithNull(row["allinpikrate"]).GetValueOrDefault(0);
                            decimal eff_pik_spread_or_rate_val = CommonHelper.StringToDecimalWithNull(row["eff_pik_spread_or_rate_val"]).GetValueOrDefault(0);
                            decimal pik_index_rate = CommonHelper.StringToDecimalWithNull(row["pik_index_rate"]).GetValueOrDefault(0);


                            decimal RemainingUnfundedCommitment = CommonHelper.StringToDecimal(row["rem_unfunded_commitment"]).GetValueOrDefault(0);

                            row["Date"] = cdate;
                            dia.Date = cdate;
                            dia.NoteID = noteid;
                            dia.AnalysisID = AnalysisIDGuid;
                            dia.EndingBalance = endbal;
                            dia.DailyInterestAccrual = dailyint;

                            dia.SpreadOrRate = eff_spread_or_rate_val;
                            dia.IndexRate = eff_index_rate;
                            dia.AllInCouponRate = allincouponrate;
                            dia.AllInPikRate = allinpikrate;
                            dia.PikSpreadOrRate = eff_pik_spread_or_rate_val;
                            dia.PIKIndexRate = pik_index_rate;

                            ListDailyInterest.Add(dia);

                            if (cdate >= startdate.Date && cdate < enddate.Date)
                            {
                                NotePeriodicOutputsDataContract npdc = new NotePeriodicOutputsDataContract();
                                npdc.PeriodEndDate = cdate;
                                npdc.EndingBalance = endbal;
                                npdc.AnalysisID = AnalysisIDGuid;
                                npdc.RemainingUnfundedCommitment = RemainingUnfundedCommitment;
                                ListTrailingBalance.Add(npdc);
                            }
                        }
                        if (ListDailyInterest.Count > 0)
                        {
                            nl.InsertDailyInterestAccural(ListDailyInterest, noteid, username);
                        }

                        if (ListTrailingBalance.Count > 0)
                        {
                            Log.WriteLogInfo("CalcDataSaving", "InsertNotePeriodicCalcFromCalculationDaily 1" + " Requestid " + requestid + " status " + status, requestid, "");
                            nl.InsertNotePeriodicCalcFromCalculationDaily(ListTrailingBalance, username, new Guid(noteid));
                            Log.WriteLogInfo("CalcDataSaving", "InsertNotePeriodicCalcFromCalculationDaily end" + " Requestid " + requestid + " status " + status, requestid, "");
                        }
                    }
                }
                else
                {
                    Log.WriteLogInfo("CalcDataSaving", "Daily data will not saved for scenrio other than deafult" + " Requestid " + requestid + " status " + status + " Analysis" + AnalysisID, requestid, "");
                }

                status = "Saved";
                _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(2), "");
                _V1CalcLogic.InsertUpdateCalculationQueueRequest(requestid, null, null, null, null, null, 266, 1, username);

            }
            catch (Exception ex)
            {

                string result = "";
                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for : PeriodicOutput : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : PeriodicOutput as M61 output api did not responds in 10 secs ";
                }

                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }
                v1logic.UpdateCalculationRequestsStatus(noteid, requestid, Convert.ToInt32(-1), AnalysisID, "00000000-0000-0000-0000-000000000000", "Note calculated successfully but failed to save data in DB." + status);
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in saving for SaveDailyData " + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", ex.Message);
            }

            return status;
        }

        public void ExportDataTobackShop(string noteid, string requestid, string SourceNoteID, string username)
        {
            LoggerLogic Log = new LoggerLogic();
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();
            try
            {
                string AllowBackshopPIKPrincipal = "";
                string dealID = "";

                DataTable dt = _V1CalcLogic.GetNoteInfoForPIKExport_V1(noteid);
                foreach (DataRow dr in dt.Rows)
                {
                    AllowBackshopPIKPrincipal = Convert.ToString(dr["AllowBackshopPIKPrincipal"]);
                    dealID = Convert.ToString(dr["dealid"]);
                }
                if (AllowBackshopPIKPrincipal == "1")
                {

                    Log.WriteLogInfo("CalcDataSaving", "BackshopPIKPrincipal Started ." + " Requestid " + requestid, requestid, "");
                    BackShopExportLogic backShopExportLogic = new BackShopExportLogic();
                    backShopExportLogic.ExportPIKPrincipalFromCRES_API(SourceNoteID, username);
                    backShopExportLogic.ExportDataToBackShop(dealID, username, noteid, "PIK");
                    Log.WriteLogInfo("CalcDataSaving", "BackshopPIKPrincipal Ended ." + " Requestid " + requestid, requestid, "");

                }
                WeightedSpreadCalcHelperLogic wsc = new WeightedSpreadCalcHelperLogic();
                wsc.CaculateWeightedAvg(dealID, username, noteid);

            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in ExportDataTobackShop : " + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "ExportDataTobackShop", ex.Message);
            }
        }
        public string GetPurposeTypetext(int? purposeID)
        {
            string purposetype = "";
            switch (purposeID)
            {
                case 315:
                    purposetype = "Property Release";
                    break;
                case 316:
                    purposetype = "Payoff/Paydown";
                    break;
                case 317:
                    purposetype = "Additional Collateral Purchase";
                    break;
                case 318:
                    purposetype = "Capital Expenditure";
                    break;
                case 319:
                    purposetype = "Debt Service / Opex";
                    break;
                case 320:
                    purposetype = "TI/LC";
                    break;
                case 321:
                    purposetype = "Other";
                    break;
                case 351:
                    purposetype = "Amortization";
                    break;
                case 517:
                    purposetype = "Capitalized Interest (Complex)";
                    break;
                case 518:
                    purposetype = "Capitalized Interest (Non-Complex)";
                    break;
                case 519:
                    purposetype = "OpEx";
                    break;
                case 520:
                    purposetype = "Force Funding";
                    break;
                case 581:
                    purposetype = "Capitalized Interest";
                    break;
                case 629:
                    purposetype = "Note Transfer";
                    break;
                case 630:
                    purposetype = "Full Payoff";
                    break;
                case 631:
                    purposetype = "Paydown";
                    break;
                case 840:
                    purposetype = "Principal Writeoff";
                    break;
                case 875:
                    purposetype = "Net Property Income/Loss";
                    break;
                case 879:
                    purposetype = "Equity Distribution";
                    break;
            }
            return purposetype;
        }
        public DataTable convertStringToDataTable(string data)
        {
            int loopindex = 0;
            DataTable dtCsv = new DataTable();
            // convert string to stream
            byte[] byteArray = Encoding.UTF8.GetBytes(data);
            MemoryStream Stream = new MemoryStream(byteArray);
            Regex regx = new Regex("," + "(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
            try
            {
                using (StreamReader sr = new StreamReader(Stream))
                {
                    while (!sr.EndOfStream)
                    {
                        var Fulltext = sr.ReadToEnd().ToString(); //read full file text  
                        string[] rows = Fulltext.Split('\n'); //split full file text into rows  
                        for (int i = 0; i < rows.Count() - 1; i++)
                        {
                            string[] rowValues = regx.Split(rows[i]); //split each row with comma to get individual values  
                            {
                                if (i == 0)
                                {
                                    for (int j = 0; j < rowValues.Count(); j++)
                                    {
                                        dtCsv.Columns.Add(rowValues[j]); //add headers  
                                    }
                                }
                                else
                                {
                                    DataRow dr = dtCsv.NewRow();
                                    for (int k = 0; k < rowValues.Count(); k++)
                                    {
                                        // remove the double quotes from the strings
                                        //dr[k] = rowValues[k].ToString();
                                        dr[k] = rowValues[k].Replace("\"", "").ToString();
                                    }
                                    dtCsv.Rows.Add(dr); //add other rows  
                                }
                            }
                            loopindex = loopindex + 1;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return dtCsv;
        }

        public string SubmitCalcRequestForFeeInterest(EquityCalcDataContract eqDc)
        {
            string rtrmessage = "";
            LiabilityCalcLogic lblogic = new LiabilityCalcLogic();
            try
            {
                GetConfigSetting();

                string headerkey = Sectionroot.GetSection("Authkeyname").Value;
                string headerValue = Sectionroot.GetSection("Authkeyvalue").Value;
                string strAPI = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;

                dynamic objJsonResult = lblogic.GetLiabilityCalcRequestForFeesAndInterest("", eqDc.AccountID, eqDc.AnalysisID, false);

                var returnType = objJsonResult.GetType();
                if (returnType.Name == "Int32")
                {
                    rtrmessage = "Batch Canceled";
                }
                //else if (returnType.Name == "String")
                //{
                //    if (objJsonResult.Contains("EGcUUGNZDl1trzKiViRLs09icNapDW5x") == true)
                //    {
                //        rtrmessage = "Error in Json creation";
                //        lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Failed", "EndTime", rtrmessage + " " + objJsonResult, "", eqDc.CalculationModeID);
                //    }

                //}
                else
                {
                    var content = new StringContent(objJsonResult, Encoding.UTF8, "application/json");
                    System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Add(headerkey, headerValue);
                        var res = client.PostAsync(strAPI, content);
                        try
                        {
                            HttpResponseMessage response1 = res.Result.EnsureSuccessStatusCode();
                            if (response1.IsSuccessStatusCode)
                            {
                                var Outputresponse = response1.Content.ReadAsStringAsync().Result;
                                var CalcResponse = JsonConvert.DeserializeObject<Jsonresponse>(Outputresponse);
                                lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "CalcSubmit", "", "", CalcResponse.request_id, eqDc.CalculationModeID);

                                rtrmessage = "CalcSubmit";

                                //Log Status Update sucessfully
                                //response1.StatusCode
                                LoggerLogic log = new LoggerLogic();
                                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Sucessfully Submit in SubmitCalcRequest in api  " + eqDc.CalculationRequestID + " || StatusCode " + response1.StatusCode, eqDc.UserName, "");
                            }
                            else
                            {
                                lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Failed", "EndTime", "Error in SubmitCalcRequest in api  " + eqDc.CalculationRequestID + " || StatusCode " + response1.StatusCode, "", eqDc.CalculationModeID);
                                //Create log when status code != IsSuccessStatusCode
                                //response1.StatusCode
                                LoggerLogic log = new LoggerLogic();
                                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest in api  " + eqDc.CalculationRequestID + " || StatusCode " + response1.StatusCode, eqDc.UserName, "");

                            }
                        }
                        catch (Exception e)
                        {

                            lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Failed", "EndTime", e.Message.ToString(), "", eqDc.CalculationModeID);
                            LoggerLogic log = new LoggerLogic();
                            log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest in api " + eqDc.CalculationRequestID + " " + e.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "SubmitCalcRequest", "", e);
                            rtrmessage = "Exception";
                        }
                    }
                }
            }
            catch (Exception ex)
            {

                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest for ID " + eqDc.AutomationRequestsID + " " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "SubmitCalcRequestForFeeInterest", "", ex);
                rtrmessage = "Exception";
            }
            return rtrmessage;
        }


        public string SubmitCalcRequestForFee(EquityCalcDataContract eqDc)
        {
            string rtrmessage = "";
            LiabilityCalcLogic lblogic = new LiabilityCalcLogic();
            try
            {
                GetConfigSetting();

                string headerkey = Sectionroot.GetSection("Authkeyname").Value;
                string headerValue = Sectionroot.GetSection("Authkeyvalue").Value;
                string strAPI = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;

                dynamic objJsonResult = lblogic.GetLiabilityCalcRequestForFees("", eqDc.AccountID, eqDc.AnalysisID, false);

                var returnType = objJsonResult.GetType();
                if (returnType.Name == "Int32")
                {
                    rtrmessage = "Batch Canceled";
                }
                else
                {
                    var content = new StringContent(objJsonResult, Encoding.UTF8, "application/json");
                    System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

                    using (var client = new HttpClient())
                    {
                        client.DefaultRequestHeaders.Add(headerkey, headerValue);
                        var res = client.PostAsync(strAPI, content);
                        try
                        {
                            HttpResponseMessage response1 = res.Result.EnsureSuccessStatusCode();
                            if (response1.IsSuccessStatusCode)
                            {
                                var Outputresponse = response1.Content.ReadAsStringAsync().Result;
                                var CalcResponse = JsonConvert.DeserializeObject<Jsonresponse>(Outputresponse);
                                lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "CalcSubmit", "", "", CalcResponse.request_id, eqDc.CalculationModeID);

                                rtrmessage = "CalcSubmit";

                                //Log Status Update sucessfully
                                //response1.StatusCode
                                LoggerLogic log = new LoggerLogic();
                                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Sucessfully Submit in SubmitCalcRequest in api  " + eqDc.CalculationRequestID + " || StatusCode " + response1.StatusCode, eqDc.UserName, "");
                            }
                            else
                            {
                                lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Failed", "EndTime", "Error in SubmitCalcRequest in api  " + eqDc.CalculationRequestID + " || StatusCode " + response1.StatusCode, "", eqDc.CalculationModeID);
                                //Create log when status code != IsSuccessStatusCode
                                //response1.StatusCode
                                LoggerLogic log = new LoggerLogic();
                                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest in api  " + eqDc.CalculationRequestID + " || StatusCode " + response1.StatusCode, eqDc.UserName, "");

                            }
                        }
                        catch (Exception e)
                        {

                            lblogic.UpdateCalculationStatusandTime(eqDc.CalculationRequestID, "Failed", "EndTime", e.Message.ToString(), "", eqDc.CalculationModeID);
                            LoggerLogic log = new LoggerLogic();
                            log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest in api " + eqDc.CalculationRequestID + " " + e.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "SubmitCalcRequest", "", e);
                            rtrmessage = "Exception";
                        }
                    }
                }
            }
            catch (Exception ex)
            {

                LoggerLogic log = new LoggerLogic();
                log.WriteLogException(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest for ID " + eqDc.AutomationRequestsID + " " + ex.Message, "", "B0E6697B-3534-4C09-BE0A-04473401AB93", "SubmitCalcRequestForFeeInterest", "", ex);
                rtrmessage = "Exception";
            }
            return rtrmessage;
        }

        public string CheckRequestIdInCalcTable(string RequestID)
        {
            return _v1CalcRepository.CheckRequestIdInCalcTable(RequestID);
        }

        public string SaveTransactionsOutputForLiabilityFeeAndInterest(string requestid, string headerkey, string headerValue, string strAPI, string AnalysisID, string username, int calcType)
        {
            string status = "";
            int? responsecode = 0;
            LoggerLogic Log = new LoggerLogic();
            var cts = new CancellationTokenSource();
            string SavingFailedFor = "";
            string result = "";
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();
            LiabilityCalcLogic lblLogic = new LiabilityCalcLogic();

            DateTime? MaturityUsedInCalc = DateTime.MinValue;
            List<LiabilityNoteTransaction> LiabilityNoteTransactions = new List<LiabilityNoteTransaction>();

            try
            {

                Log.WriteLogInfo("LiabiltyFeeInterestCalculator", " inside Transactions_Output 1 " + " Requestid " + requestid, requestid, "");
                // transactions saving
                SavingFailedFor = "Transactions_Output";
                var strtransactionAPI = strAPI + "/" + requestid + "/outputs/liability_transactions.csv";
                HttpClient transactionsclient = new HttpClient();
                transactionsclient.Timeout = TimeSpan.FromSeconds(60);
                transactionsclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                Log.WriteLogInfo("LiabiltyFeeInterestCalculator", " inside Transactions_Output 2 " + " Requestid " + requestid, requestid, "");
                var apitransactionsresult = transactionsclient.GetAsync(strtransactionAPI, cts.Token).Result;
                responsecode = (int)apitransactionsresult.StatusCode;
                Log.WriteLogInfo("LiabiltyFeeInterestCalculator", " inside Transactions_Output 3 " + " Requestid " + requestid, requestid, "");
                if (apitransactionsresult.IsSuccessStatusCode == true)
                {
                    var transactionsresponse = apitransactionsresult.Content.ReadAsStringAsync().Result;
                    Log.WriteLogInfo("LiabiltyFeeInterestCalculator", " inside Transactions_Output 4 " + " Requestid " + requestid, requestid, "");
                    var transactionsoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(transactionsresponse);

                    Log.WriteLogInfo("LiabiltyFeeInterestCalculator", " inside Transactions_Output 5 " + " Requestid " + requestid, requestid, "");
                    DataTable dtTransactionsoutput = convertStringToDataTable(transactionsoutput.data);

                    List<string> collist = new List<string>();
                    foreach (DataColumn column in dtTransactionsoutput.Columns)
                    {
                        collist.Add(column.ColumnName);
                    }
                    string[] requiredcol = { "Date", "Note", "type", "value", "AnalysisID", "LiabilityAccountID", "LiabilityTypeID", "LiabilityNoteAccountID", "remit_dt", "transdtbyrule_dt", "trans_dt", "due_dt", "AllInCouponRate", "IsClubTransactionOnSameDate", "IndexValue", "SpreadValue", "OriginalIndex", "CalcType" };

                    //remove column which are not required 
                    foreach (var item in collist)
                    {
                        var res = requiredcol.Contains(item);
                        if (res == false)
                        {
                            if (dtTransactionsoutput.Columns.IndexOf(item) != -1)
                            {
                                dtTransactionsoutput.Columns.Remove(item);
                            }
                        }
                    }
                    // add column which are required 
                    foreach (string item in requiredcol)
                    {
                        if (dtTransactionsoutput.Columns.IndexOf(item) == -1)
                        {
                            dtTransactionsoutput.Columns.Add(item);
                        }
                    }


                    DataTable dtTransactionOutputIsClubYes = new DataTable();
                    foreach (DataColumn dc in dtTransactionsoutput.Columns)
                    {
                        dtTransactionOutputIsClubYes.Columns.Add(dc.ColumnName, dc.DataType);
                    }

                    DataTable dtTransactionTypeIsClub = _V1CalcLogic.GetTransactionTypeIsClub_V1();
                    foreach (DataRow dr in dtTransactionTypeIsClub.Rows)
                    {
                        dtTransactionsoutput.Select(string.Format("[type] = '{0}'", dr["TransactionName"].ToString()))
                        .ToList<DataRow>()
                        .ForEach(r =>
                        {
                            r["IsClubTransactionOnSameDate"] = dr["IsClubTransactionOnSameDate"].ToString();
                        });
                    }

                    foreach (DataRow row in dtTransactionsoutput.Rows)
                    {

                        LiabilityNoteTransactions.Add(new LiabilityNoteTransaction
                        {
                            LiabilityAccountID = CommonHelper.ToGuid(row["LiabilityAccountID"]),
                            LiabilityNoteAccountID = CommonHelper.ToGuid(row["LiabilityNoteAccountID"]),
                            LiabilityNoteID = Convert.ToString(row["Note"]),
                            Date = CommonHelper.ToDateTime(row["Date"]),
                            Amount = Math.Round(CommonHelper.StringToDecimal(row["value"]).GetValueOrDefault(0), 10),
                            TransactionType = Convert.ToString(row["type"]),
                            AnalysisID = CommonHelper.ToGuid(AnalysisID),
                            CalcType = calcType,
                            LiabilityTypeID = CommonHelper.ToGuid(row["LiabilityTypeID"]),
                            AllInCouponRate = CommonHelper.ToDecimal(row["AllInCouponRate"]),
                            SpreadValue = CommonHelper.ToDecimal(row["SpreadValue"]),
                            OriginalIndex = CommonHelper.ToDecimal(row["OriginalIndex"])

                        });
                        DateTime? due_dt = CommonHelper.ToDateTime(row["due_dt"]);
                        row["value"] = Math.Round(CommonHelper.StringToDecimal(row["value"]).GetValueOrDefault(0), 10);
                        row["remit_dt"] = CommonHelper.ToDateTime(row["remit_dt"]);
                        row["transdtbyrule_dt"] = CommonHelper.ToDateTime(row["transdtbyrule_dt"]);
                        row["trans_dt"] = CommonHelper.ToDateTime(row["trans_dt"]);
                        row["due_dt"] = due_dt;
                        row["IndexValue"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["IndexValue"]).GetValueOrDefault(0), 10));
                        row["SpreadValue"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["SpreadValue"]).GetValueOrDefault(0), 10));
                        row["OriginalIndex"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["OriginalIndex"]).GetValueOrDefault(0), 10));
                        row["AllInCouponRate"] = CommonHelper.ValueOrNull(Math.Round(CommonHelper.StringToDecimal(row["AllInCouponRate"]).GetValueOrDefault(), 10));
                        row["CalcType"] = calcType;

                        if (due_dt != null)
                        {
                            row["Date"] = due_dt;
                        }
                        if (row["IsClubTransactionOnSameDate"].ToString() == "Y")
                        {
                            dtTransactionOutputIsClubYes.Rows.Add(row.ItemArray);
                        }

                        if (row["type"].ToString() == "Balloon")
                        {
                            MaturityUsedInCalc = CommonHelper.ToDateTime(row["Date"]);
                        }
                    }
                    ////transactions entry
                    lblLogic.InsertLiabilityNoteTransactionForFeeAndInterest(LiabilityNoteTransactions, username);

                    result = "Saved";
                }
                else
                {
                    Log.WriteLogInfo("LiabiltyFeeInterestCalculator", "Transactions_Output File not found.Error Code " + responsecode + " Requestid " + requestid, requestid, "");
                }
            }
            catch (Exception ex)
            {


                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for : Liability_Transactions_Output : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : Transactions_Output as M61 output api did not responds in 60 secs ";
                }
                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }

                v1logic.UpdateM61EngineCalcStatusForLiability(requestid, Convert.ToInt32(-1), "Note calculated successfully but failed to save data in DB.");
                Log.WriteLogExceptionMessage(CRESEnums.Module.LiabiltyFeeInterestCalculator.ToString(), "Error in saving for  " + SavingFailedFor + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", result);
            }

            return result;
        }

        public string SaveTransactionsOutputForLiabilityFee(string requestid, string headerkey, string headerValue, string strAPI, string AnalysisID, string username, int calcType)
        {
            string status = "";
            int? responsecode = 0;
            LoggerLogic Log = new LoggerLogic();
            var cts = new CancellationTokenSource();
            string SavingFailedFor = "";
            string result = "";
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();
            LiabilityCalcLogic lblLogic = new LiabilityCalcLogic();

            DateTime? MaturityUsedInCalc = DateTime.MinValue;
            List<LiabilityNoteTransaction> LiabilityNoteTransactions = new List<LiabilityNoteTransaction>();

            try
            {

                Log.WriteLogInfo("LiabiltyFeeCalculator", " inside Transactions_Output 1 " + " Requestid " + requestid, requestid, "");
                // transactions saving
                SavingFailedFor = "Transactions_Output";
                var strtransactionAPI = strAPI + "/" + requestid + "/outputs/liability_transactions.csv";
                HttpClient transactionsclient = new HttpClient();
                transactionsclient.Timeout = TimeSpan.FromSeconds(60);
                transactionsclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                Log.WriteLogInfo("LiabiltyFeeCalculator", " inside Transactions_Output 2 " + " Requestid " + requestid, requestid, "");
                var apitransactionsresult = transactionsclient.GetAsync(strtransactionAPI, cts.Token).Result;
                responsecode = (int)apitransactionsresult.StatusCode;
                Log.WriteLogInfo("LiabiltyFeeCalculator", " inside Transactions_Output 3 " + " Requestid " + requestid, requestid, "");
                if (apitransactionsresult.IsSuccessStatusCode == true)
                {
                    var transactionsresponse = apitransactionsresult.Content.ReadAsStringAsync().Result;
                    Log.WriteLogInfo("LiabiltyFeeCalculator", " inside Transactions_Output 4 " + " Requestid " + requestid, requestid, "");
                    var transactionsoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(transactionsresponse);

                    Log.WriteLogInfo("LiabiltyFeeCalculator", " inside Transactions_Output 5 " + " Requestid " + requestid, requestid, "");
                    DataTable dtTransactionsoutput = convertStringToDataTable(transactionsoutput.data);

                    List<string> collist = new List<string>();
                    foreach (DataColumn column in dtTransactionsoutput.Columns)
                    {
                        collist.Add(column.ColumnName);
                    }
                    string[] requiredcol = { "Date", "Note", "type", "value", "Fee Name", "AnalysisID", "FundAccountID", "LiabilityTypeID", "CalcType" };

                    //remove column which are not required 
                    foreach (var item in collist)
                    {
                        var res = requiredcol.Contains(item);
                        if (res == false)
                        {
                            if (dtTransactionsoutput.Columns.IndexOf(item) != -1)
                            {
                                dtTransactionsoutput.Columns.Remove(item);
                            }
                        }
                    }
                    // add column which are required 
                    foreach (string item in requiredcol)
                    {
                        if (dtTransactionsoutput.Columns.IndexOf(item) == -1)
                        {
                            dtTransactionsoutput.Columns.Add(item);
                        }
                    }


                    DataTable dtTransactionOutputIsClubYes = new DataTable();
                    foreach (DataColumn dc in dtTransactionsoutput.Columns)
                    {
                        dtTransactionOutputIsClubYes.Columns.Add(dc.ColumnName, dc.DataType);
                    }

                    DataTable dtTransactionTypeIsClub = _V1CalcLogic.GetTransactionTypeIsClub_V1();
                    foreach (DataRow dr in dtTransactionTypeIsClub.Rows)
                    {
                        dtTransactionsoutput.Select(string.Format("[type] = '{0}'", dr["TransactionName"].ToString()))
                        .ToList<DataRow>()
                        .ForEach(r =>
                        {
                            r["IsClubTransactionOnSameDate"] = dr["IsClubTransactionOnSameDate"].ToString();
                        });
                    }

                    foreach (DataRow row in dtTransactionsoutput.Rows)
                    {

                        LiabilityNoteTransactions.Add(new LiabilityNoteTransaction
                        {
                            Date = CommonHelper.ToDateTime(row["Date"]),
                            Amount = Math.Round(CommonHelper.StringToDecimal(row["value"]).GetValueOrDefault(0), 10),
                            TransactionType = Convert.ToString(row["type"]),
                            AnalysisID = CommonHelper.ToGuid(AnalysisID),
                            CalcType = calcType,
                            LiabilityTypeID = CommonHelper.ToGuid(row["LiabilityTypeID"]),
                            FeeName = Convert.ToString(row["Fee Name"]),
                            LiabilityAccountID = CommonHelper.ToGuid(row["FundAccountID"]),
                        });
                        //DateTime? due_dt = CommonHelper.ToDateTime(row["due_dt"]);
                        row["value"] = Math.Round(CommonHelper.StringToDecimal(row["value"]).GetValueOrDefault(0), 10);
                        row["CalcType"] = calcType;
                    }
                    ////transactions entry
                    lblLogic.InsertLiabilityNoteTransactionForFee(LiabilityNoteTransactions, username);

                    result = "Saved";
                }
                else
                {
                    Log.WriteLogInfo("LiabiltyFeeCalculator", "Transactions_Output File not found.Error Code " + responsecode + " Requestid " + requestid, requestid, "");
                }
            }
            catch (Exception ex)
            {


                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for : Liability_Transactions_Output : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : Transactions_Output as M61 output api did not responds in 60 secs ";
                }
                if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }

                v1logic.UpdateM61EngineCalcStatusForLiability(requestid, Convert.ToInt32(-1), "Note calculated successfully but failed to save data in DB.");
                Log.WriteLogExceptionMessage(CRESEnums.Module.LiabiltyFeeInterestCalculator.ToString(), "Error in saving for  " + SavingFailedFor + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", result);
            }

            return result;
        }
    }
}

public class Jsonresponse
{
    public string message { get; set; }
    public string request_id { get; set; }
}
