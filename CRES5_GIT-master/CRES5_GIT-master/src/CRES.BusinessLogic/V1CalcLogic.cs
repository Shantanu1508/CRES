using CRES.DAL.Repository;
using CRES.DataContract;
using CRES.Utilities;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;

namespace CRES.BusinessLogic
{
    public class V1CalcLogic
    {
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

        public int InsertTransactionEntry(DataTable dtTransactionsoutput, string AnalysisID, string CreatedBy, string crenoteid, string StrCreatedBy)
        {
            return _v1CalcRepository.InsertTransactionEntry(dtTransactionsoutput, AnalysisID, CreatedBy, crenoteid, StrCreatedBy);
        }
        public int UpdateTransactionEntryCash_NonCash(string NoteId, string AnalysisID)
        {
            return _v1CalcRepository.UpdateTransactionEntryCash_NonCash(NoteId, AnalysisID);
        }

        public List<V1CalculationStatusDataContract> GetAllDealsProcessingstatus()
        {
            return _v1CalcRepository.GetAllDealsProcessingstatus();
        }

        public void UpdateCalculationRequestsStatus(string dealid, string RequestID, int Status, string AnalysisID, string UserID, string errmsg)
        {
            _v1CalcRepository.UpdateCalculationRequestsStatus(dealid, RequestID, Status, AnalysisID, UserID, errmsg);
        }


        public int InsertPayRuleDistribution(DataTable dtoutput, string AnalysisID, string CreatedBy)
        {
            return _v1CalcRepository.InsertPayRuleDistribution(dtoutput, AnalysisID, CreatedBy);
        }

        public dynamic GetDealCalcRequestData(string objectID, int objectTypeId, string analysisID, int CalcType, bool? batchType = false, bool? isTestRequest = false)
        {
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

            DataTable dtJsonTemplate = new DataTable();
            DataTable dtdata_index = new DataTable();
            DataTable dtdata_calendars = new DataTable();
            DataTable dtdata_Json_Info = new DataTable();
            DataTable dtJsonFormat = new DataTable();
            DataTable dtMaturityScenarios = new DataTable();

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

                dtdata_deal_setup_tables_funding = dsCalcInfo.Tables["data.deal.setup.tables.funding"];

                dtdata_notes_setup_tables_funding = dsCalcInfo.Tables["data.notes.setup.tables.funding"];
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

                dtJsonTemplate = dsCalcInfo.Tables["JsonTemplate"];
                dtdata_index = dsCalcInfo.Tables["data.index"];
                dtdata_calendars = dsCalcInfo.Tables["data.calendars"];
                dtdata_Json_Info = dsCalcInfo.Tables["Json_Info"];
                dtJsonFormat = dsCalcInfo.Tables["JsonFormat"];

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
                            NoteDataContract _noteCalculatorDC = new NoteDataContract();
                            NoteLogic nlogic = new NoteLogic();

                            _noteCalculatorDC.MaturityScenariosListFromDatabase = nlogic.GetMaturityPeriodicDataByNoteId(new Guid(dtNotes_Root.Rows[i]["objectguid"].ToString()), new Guid("B0E6697B-3534-4C09-BE0A-04473401AB93"), 0, 0, out totalCount);
                            _noteCalculatorDC = ScenarioRules.AssignValuesToSelectedMaturityUsingDealSetup(_noteCalculatorDC, MaturityScenarioOverridetext);
                            // samart has to add code here
                            dtMaturityScenarios = ObjToDataTable.ConvertToDataTable(_noteCalculatorDC.MaturityScenariosList);
                            dtMaturityScenarios.Columns.Add("CRENoteID", typeof(string));
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
                                    var lstnotes_funding = new List<Dictionary<string, object>>();
                                    var lstnotes_amsch = new List<Dictionary<string, object>>();
                                    var lstnotes_pikrate = new List<Dictionary<string, object>>();
                                    var lstnotes_piksch = new List<Dictionary<string, object>>();
                                    var lstmaturity_scenarios = new List<Dictionary<string, object>>();
                                    var lstSpreadMaintenanc = new List<Dictionary<String, object>>();
                                    var lstPrepayAdjustment = new List<Dictionary<String, Object>>();
                                    var lstMinMultSchedule = new List<Dictionary<String, Object>>();
                                    var lstFeeCredits = new List<Dictionary<String, Object>>();
                                    var lstcashflow = new List<Dictionary<String, Object>>();
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
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_maturity[dc], drJsonFormat["DataType"].ToString());
                                                            notes_Deal_setup_dictionary.Add(_key, _value);
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
                                                                ["intcalcdays"] = dr["intcalcdays"]
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
                                                    ["purpose"] = dr_dtdata_notes_setup_tables_funding["purpose"]
                                                };

                                                lstnotes_funding.Add(notes_tables_spread);
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
                                                    ["stripval"] = dr_dtdata_notes_setup_tables_fees["stripval"]
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

                                        if (lstmaturity_scenarios.Count > 0)
                                        {
                                            notes_Deal_setup_dictionary.Add("maturity_scenario", lstmaturity_scenarios);
                                        }

                                        if (lstnotes_funding.Count > 0)
                                        {
                                            //innerData_Notes_tables_spread.Add("funding", lstnotes_funding);
                                            notes_Deal_setup_dictionary.Add("funding", lstnotes_funding);
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
                                    var lstnotes_amsch = new List<Dictionary<string, object>>();
                                    var lstnotes_pikrate = new List<Dictionary<string, object>>();
                                    var lstnotes_piksch = new List<Dictionary<string, object>>();
                                    var lstSpreadMaintenanc = new List<Dictionary<string, object>>();
                                    var lstPrepayAdjustment = new List<Dictionary<String, Object>>();
                                    var lstMinMultSchedule = new List<Dictionary<String, Object>>();
                                    var lstFeeCredits = new List<Dictionary<String, Object>>();

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
                                                            dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_maturity[dc], drJsonFormat["DataType"].ToString());
                                                            notes_Deal_setup_dictionary.Add(_key, _value);
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
                                                                ["intcalcdays"] = dr["intcalcdays"]
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
                                                    ["purpose"] = dr_dtdata_notes_setup_tables_funding["purpose"]
                                                };

                                                lstnotes_funding.Add(notes_tables_spread);
                                            }
                                        }
                                    }

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
                                                    ["stripval"] = dr_dtdata_notes_setup_tables_fees["stripval"]
                                                };

                                                lstFees.Add(notes_tables_spread);
                                            }
                                        }
                                    }

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
                IDictionary<string, object> innerData_Index = (IDictionary<string, object>)index;
                if (dtdata_index != null)
                {
                    foreach (DataRow dr_dtdata_index in dtdata_index.Rows)
                    {
                        innerData_Index.Add(dr_dtdata_index["date"].ToString(), dr_dtdata_index["value"]);
                    }
                    index = innerData_Index;
                }
                data1.index = index;
                #endregion


                string _jsonData = JsonConvert.SerializeObject(data1);

                string fileName = "request_rules.json";
                string currentDirectoryPath = Directory.GetCurrentDirectory() + @"\wwwroot\JSONTemplate";

                string finalFileNameWithPath = string.Empty;
                finalFileNameWithPath = string.Format("{0}\\{1}", currentDirectoryPath, fileName);

                var newFile = new FileInfo(finalFileNameWithPath);

                string jsonRequest = System.IO.File.ReadAllText(finalFileNameWithPath);

                //dynamic 
                objJsonResult = JsonConvert.DeserializeObject<ExpandoObject>(jsonRequest);
                objJsonResult.data.data = JsonConvert.DeserializeObject<ExpandoObject>(_jsonData);  // _jsonData;


                objJsonResult.data.data.period_end_date = dtDataRootinfo.Rows[0]["period_end_date"].ToString();
                objJsonResult.data.engine = dtDataRootinfo.Rows[0]["engine"].ToString(); ;
                objJsonResult.data.data.period_start_date = dtDataRootinfo.Rows[0]["period_start_date"].ToString();
                objJsonResult.data.data.root_note_id = dtDataRootinfo.Rows[0]["root_note_id"].ToString();
                objJsonResult.data.data.calc_basis = dtDataRootinfo.Rows[0]["calc_basis"].ToBoolean();
                objJsonResult.data.data.calc_deffee_basis = dtDataRootinfo.Rows[0]["calc_deffee_basis"].ToBoolean();
                objJsonResult.data.data.calc_disc_basis = dtDataRootinfo.Rows[0]["calc_disc_basis"].ToBoolean();
                objJsonResult.data.data.calc_capcosts_basis = dtDataRootinfo.Rows[0]["calc_capcosts_basis"].ToBoolean();
                //objJsonResult.data.data.init_logging = dtDataRootinfo.Rows[0]["init_logging"].ToBoolean();
                objJsonResult.data.data.disable_businessday = dtDataRootinfo.Rows[0]["DisableBusinessDay"].ToString();
                objJsonResult.data.data.maturity_scenario_override = dtDataRootinfo.Rows[0]["MaturityScenarioOverride"].ToString();
                objJsonResult.data.data.debug = dtDataRootinfo.Rows[0]["debug"].ToBoolean();
                objJsonResult.data.data.use_servicingactual = dtDataRootinfo.Rows[0]["UseServicingActual"].ToString();

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

                return ex.Message.ToString();
            }

            //return objJsonResult;
            //return "";
        }


        public string SubmitCalcRequest(string objectid, int objecttypeid, string analysisID, int calctype, bool isbatchrequest)
        {
            string rtrmessage = "";
            try
            {
                GetConfigSetting();

                string headerkey = Sectionroot.GetSection("Authkeyname").Value;
                string headerValue = Sectionroot.GetSection("Authkeyvalue").Value;
                string strAPI = Sectionroot.GetSection("SubmitRequestConstantUrl").Value;

                bool isTestRequest = false;
                dynamic objJsonResult = GetDealCalcRequestData(objectid, objecttypeid, analysisID, calctype, isbatchrequest, isTestRequest);

                var returnType = objJsonResult.GetType();
                if (returnType.Name == "Int32")
                {
                    rtrmessage = "Batch Canceled";
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


                                //Log Status Update sucessfully
                                //response1.StatusCode
                                LoggerLogic log = new LoggerLogic();
                                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Sucessfully Submit in SubmitCalcRequest in api  " + objectid + " || StatusCode " + response1.StatusCode, objectid, "");
                            }
                            else
                            {
                                //Create log when status code != IsSuccessStatusCode
                                //response1.StatusCode
                                LoggerLogic log = new LoggerLogic();
                                log.WriteLogInfo(CRESEnums.Module.Calculator.ToString(), "Error in SubmitCalcRequest in api  " + objectid + " || StatusCode " + response1.StatusCode, objectid, "");
                            }
                        }
                        catch (Exception e)
                        {
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

        public List<V1CalculationStatusDataContract> GetRequestIDFromCalculationRequestsDataNotSaveInDB()
        {
            return _v1CalcRepository.GetRequestIDFromCalculationRequestsDataNotSaveInDB();
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
        public DataTable GetDataFromCalculationRequestsByRequestID(string RequestID)
        {
            return _v1CalcRepository.GetDataFromCalculationRequestsByRequestID(RequestID);
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




    }
}

public class Jsonresponse
{
    public string message { get; set; }
    public string request_id { get; set; }
}
