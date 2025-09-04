
using Azure.Core;
using CRES.DAL.Repository;
using CRES.DataContract;
using CRES.Utilities;
using Microsoft.Extensions.Configuration;
using Microsoft.WindowsAzure.Storage;

using Microsoft.WindowsAzure.Storage.Blob;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;

using System.Threading;

namespace CRES.BusinessLogic
{
    public class PrepayPremiumLogic
    {
        private PayoffRepository PayoffRepository = new PayoffRepository();
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
        public dynamic GetDealCalcRequestDataForPrepayment(string objectID, int objectTypeId, string analysisID, int CalcType, bool? batchType = false, bool? isTestRequest = false)
        {

            string MaturityScenarioOverridetext = "";
            DataSet dsCalcInfo = new DataSet();
            DataTable dtDataRootinfo = new DataTable();
            DataTable dtNotes_Root = new DataTable();
            DataTable dtDataEffective_dates = new DataTable();
            //DataTable dtdataStructure = new DataTable();
            DataTable dtDataRulesetsPay = new DataTable();
            DataTable dtData_notes_setup = new DataTable();
            DataTable dtdata_notes_setup_dictionary = new DataTable();


            // DataTable dtdata_notes_setup_tables_fees = new DataTable();
            //DataTable dtdata_notes_setup_tables_fee_stripping = new DataTable();
            //DataTable dtdata_notes_fee_strip_received = new DataTable();
            DataTable dtdata_notes_actuals = new DataTable();

            //DataTable dtdata_deal_setup_tables_funding = new DataTable();


            DataTable dtdata_notes_setup_tables_noteperiodiccal = new DataTable();
            //DataTable dtdata_notes_setup_tables_pikrate = new DataTable();

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

            //DataTable dtdata_notes_watchlist = new DataTable();


            DataTable dtdata_notes_setup_noteallocationsetup_notes = new DataTable();
            DataTable dtdata_notes_setup_noteallocationsetup_notes_attr = new DataTable();
            DataTable dtdata_notes_setup_noteallocationsetup_groups = new DataTable();
            DataTable dtdata_notes_setup_noteallocationsetup_groups_attr = new DataTable();

            DataTable dtdata_notes_setup_noteallocationsetup_groups_priority = new DataTable();

            DataTable dtdata_notes_setup_noteallocationsetup_groups_priorityNotes = new DataTable();

            DataTable dtdata_config_fee_config = new DataTable();
            V1CalcLogic v1CalcLogic = new V1CalcLogic();

            dynamic objJsonResult;
            try
            {
                dsCalcInfo = v1CalcLogic.GetCalcRequestData(objectID, objectTypeId, "", analysisID, CalcType);
                dtDataRootinfo = dsCalcInfo.Tables["data.rootinfo"];

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


                //if (dtDataRootinfo.Rows[0]["MaturityScenarioOverride"] != null)
                //{
                //    MaturityScenarioOverridetext = dtDataRootinfo.Rows[0]["MaturityScenarioOverride"].ToString();
                //}

                dtNotes_Root = dsCalcInfo.Tables["data.notes"];
                dtDataEffective_dates = dsCalcInfo.Tables["data.effective_dates"];
                //dtdataStructure = dsCalcInfo.Tables["data.structure"];
                dtDataRulesetsPay = dsCalcInfo.Tables["data.rulesets.pay"];
                dtData_notes_setup = dsCalcInfo.Tables["data.notes.setup"];
                dtdata_notes_setup_dictionary = dsCalcInfo.Tables["data.notes.setup.dictionary"];



                //dtdata_notes_setup_tables_fees = dsCalcInfo.Tables["data.notes.setup.tables.fees"];
                //dtdata_notes_setup_tables_fee_stripping = dsCalcInfo.Tables["data.notes.setup.tables.fee_stripping"];
                //dtdata_notes_fee_strip_received = dsCalcInfo.Tables["data.notes.fee_strip_received"];
                dtdata_notes_actuals = dsCalcInfo.Tables["data.notes.actuals"];


                dtdata_notes_setup_tables_noteperiodiccal = dsCalcInfo.Tables["data.notes.noteperiodiccalc"]; //dsCalcInfo.Tables["data.notes.noteperiodiccal"];




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

                dtdata_notes_setup_noteallocationsetup_notes = dsCalcInfo.Tables["data.notes.setup.noteallocationsetup.notes"];
                dtdata_notes_setup_noteallocationsetup_notes_attr = dsCalcInfo.Tables["data.notes.setup.noteallocationsetup.notes.attr"];

                dtdata_notes_setup_noteallocationsetup_groups = dsCalcInfo.Tables["data.notes.setup.noteallocationsetup.groups"];
                dtdata_notes_setup_noteallocationsetup_groups_attr = dsCalcInfo.Tables["data.notes.setup.noteallocationsetup.groups.attr"];

                dtdata_notes_setup_noteallocationsetup_groups_priority = dsCalcInfo.Tables["data.notes.setup.noteallocationsetup.groups.priority"];
                dtdata_notes_setup_noteallocationsetup_groups_priorityNotes = dsCalcInfo.Tables["data.notes.setup.noteallocationsetup.groups.priorityNotes"];


                dtJsonTemplate = dsCalcInfo.Tables["JsonTemplate"];

                dtdata_calendars = dsCalcInfo.Tables["data.calendars"];
                dtdata_Json_Info = dsCalcInfo.Tables["Json_Info"];
                dtJsonFormat = dsCalcInfo.Tables["JsonFormat"];

                rootDataPrepay prepayJson = new rootDataPrepay();
                #region notes


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

                                        notes_Deal_setup_dictionary.Add("CalcThru", dr_dtdata_notes_PrepayScheduleDict["CalcThru"]);
                                        notes_Deal_setup_dictionary.Add("PrepaymentMethod", dr_dtdata_notes_PrepayScheduleDict["PrepaymentMethod"]);
                                        notes_Deal_setup_dictionary.Add("BaseAmountType", dr_dtdata_notes_PrepayScheduleDict["BaseAmountType"]);
                                        notes_Deal_setup_dictionary.Add("SpreadCalcMethod", dr_dtdata_notes_PrepayScheduleDict["SpreadCalcMethod"]);
                                        notes_Deal_setup_dictionary.Add("GreaterOfSMOrBaseAmtTimeSpread", dr_dtdata_notes_PrepayScheduleDict["GreaterOfSMOrBaseAmtTimeSpread"]);
                                        notes_Deal_setup_dictionary.Add("HasNoteLevelSMSchedule", dr_dtdata_notes_PrepayScheduleDict["HasNoteLevelSMSchedule"]);
                                        notes_Deal_setup_dictionary.Add("IncludeFeesInCredits", CommonHelper.ToBoolean(dr_dtdata_notes_PrepayScheduleDict["IncludeFeesInCredits"]));
                                        notes_Deal_setup_dictionary.Add("OpenPaymentDate", dr_dtdata_notes_PrepayScheduleDict["OpenPaymentDate"].ToString());
                                        notes_Deal_setup_dictionary.Add("MinimumMultipleDue", dr_dtdata_notes_PrepayScheduleDict["MinimumMultipleDue"]);

                                        #region prepay Groups and notes
                                        Dictionary<String, Object> innerData_NoteAllocaion = new Dictionary<String, Object>();
                                        Dictionary<String, Object> innerData_Notes = new Dictionary<String, Object>();
                                        Dictionary<string, Object> innerDictionaryGroups = new Dictionary<string, object>();
                                        Dictionary<string, Object> innerDictionaryNotes = new Dictionary<string, object>();

                                        // var lstGroups = new List<Dictionary<String, Object>>();

                                        Dictionary<string, Object> innerDictionaryGroups1attr = new Dictionary<string, object>();

                                        // add groups
                                        foreach (DataRow dr_noteallocationsetup_groups in dtdata_notes_setup_noteallocationsetup_groups.Rows)
                                        {
                                            var lstGroups = new List<Dictionary<String, Object>>();

                                            Dictionary<string, Object> innerDictionaryNotesattr = new Dictionary<string, object>();

                                            var tempdt1 = dtdata_notes_setup_noteallocationsetup_groups_attr.AsEnumerable().Where(x => x.Field<Int32>("GroupId") == Convert.ToInt32(dr_noteallocationsetup_groups["GroupId"]));
                                            DataTable tempdt = new DataTable();
                                            if (tempdt1.Count() > 0)
                                            {
                                                tempdt = tempdt1.CopyToDataTable();
                                            }

                                            foreach (DataRow dr_attr in tempdt.Rows)
                                            {
                                                Dictionary<String, Object> innerDictionaryGroupsTemp = new Dictionary<String, Object>()
                                                {
                                                    ["GroupId"] = dr_attr["GroupId"].ToString(),
                                                    ["nm"] = dr_attr["nm"].ToString(),
                                                    ["val"] = dr_attr["val"].ToString()

                                                };

                                                var TempNotes = new Dictionary<string, Object>(innerDictionaryGroupsTemp);
                                                lstGroups.Add(TempNotes);

                                            }

                                            var tempGroupsattr = new Dictionary<string, Object>(innerDictionaryNotesattr);
                                            tempGroupsattr.Add("attrs", lstGroups);

                                            var lstPriorities = new List<Dictionary<String, Object>>();
                                            foreach (DataRow dr_noteallocationsetup_groups_priority in dtdata_notes_setup_noteallocationsetup_groups_priority.Rows)
                                            {
                                                Dictionary<string, Object> DictionaryPriorityTemp = new Dictionary<string, object>();


                                                Dictionary<string, Object> innerDictionaryPriorityTemp = new Dictionary<string, object>();
                                                string[] arrPrepayNotes = dtdata_notes_setup_noteallocationsetup_groups_priorityNotes.AsEnumerable().Where(x => x.Field<Int32>("GroupPriority") == Convert.ToInt32(dr_noteallocationsetup_groups_priority["GroupPriority"])).Select(x => x.Field<string>("name")).ToArray();

                                                innerDictionaryPriorityTemp.Add("Notes", arrPrepayNotes);

                                                DictionaryPriorityTemp.Add(dr_noteallocationsetup_groups_priority["GroupPriority"].ToString(), innerDictionaryPriorityTemp);

                                                //Dictionary<String, Object> tmpDict = new Dictionary<String, Object>(innerDictionaryGroups1);
                                                var tempGroups = new Dictionary<string, Object>(DictionaryPriorityTemp);
                                                lstPriorities.Add(tempGroups);
                                            }
                                            tempGroupsattr.Add("priorities", lstPriorities);
                                            innerDictionaryGroups.Add(dr_noteallocationsetup_groups["GroupId"].ToString(), tempGroupsattr);

                                        }

                                        innerData_NoteAllocaion.Add("Notes", innerDictionaryGroups);

                                        Dictionary<String, Object> innerData_NoteAllocationSetup = new Dictionary<String, Object>();
                                        notes_Deal_setup_dictionary.Add("NoteAllocationSetup", innerData_NoteAllocaion);
                                        #endregion
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
                                        Dictionary<String, Object> innerDictionary = new Dictionary<String, Object>()
                                        {
                                            ["EffectiveDate_Prepay"] = dr_dtdata_notes_PrepayAdjustment["EffectiveDate_Prepay"].ToString(),
                                            ["Date"] = dr_dtdata_notes_PrepayAdjustment["Date"].ToString(),
                                            ["PrepayAdjAmt"] = dr_dtdata_notes_PrepayAdjustment["PrepayAdjAmt"].ToString(),
                                            ["Comment"] = dr_dtdata_notes_PrepayAdjustment["Comment"].ToString()

                                        };
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

                                        Dictionary<String, Object> innerDictionary = new Dictionary<String, Object>()
                                        {
                                            ["EffectiveDate_Prepay"] = dr_dtdata_notes_FeeCredits["EffectiveDate_Prepay"].ToString(),
                                            ["FeeType"] = dr_dtdata_notes_FeeCredits["FeeType"].ToString(),
                                            ["OverrideFeeAmount"] = dr_dtdata_notes_FeeCredits["OverrideFeeAmount"],
                                            ["UseActualFees"] = CommonHelper.ToBoolean(dr_dtdata_notes_FeeCredits["UseActualFees"].ToString())

                                        };

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

                                        Dictionary<String, Object> innerDictionary = new Dictionary<String, Object>()
                                        {
                                            ["EffectiveDate_Prepay"] = dr_dtdata_notes_MinMultSchedule["EffectiveDate_Prepay"].ToString(),
                                            ["Date"] = dr_dtdata_notes_MinMultSchedule["Date"].ToString(),
                                            ["MinMultAmount"] = dr_dtdata_notes_MinMultSchedule["MinMultAmount"]

                                        };


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
                                        Dictionary<String, Object> innerDictionary = new Dictionary<String, Object>()
                                        {
                                            ["EffectiveDate_Prepay"] = dr_dtdata_notes_SpreadMaintenanceSchedule["EffectiveDate_Prepay"].ToString(),
                                            ["Date"] = dr_dtdata_notes_SpreadMaintenanceSchedule["Date"].ToString(),
                                            ["Spread"] = dr_dtdata_notes_SpreadMaintenanceSchedule["Spread"],
                                            ["CalcAfterPayoff"] = CommonHelper.ToBoolean(dr_dtdata_notes_SpreadMaintenanceSchedule["CalcAfterPayoff"].ToString())

                                        };
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

                                Dictionary<String, Object> notes_Deal_setup_dictionary = new Dictionary<String, Object>()
                                {

                                    ["CRENoteID"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["CRENoteID"].ToString(),
                                    ["NoteID"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["NoteID"].ToString(),
                                    ["min_effective_dates"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["min_effective_dates"].ToString(),
                                    ["initaccenddt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initaccenddt"].ToString(),
                                    ["initmatdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initmatdt"].ToString(),
                                    ["initpmtdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initpmtdt"].ToString(),
                                    ["ioterm"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["ioterm"].ToString(),
                                    ["amterm"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["amterm"].ToString(),
                                    ["clsdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["clsdt"].ToString(),
                                    ["initbal"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initbal"].ToString(),
                                    ["leaddays"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["leaddays"].ToString(),
                                    ["initresetdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initresetdt"].ToString(),
                                    ["initindex"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["initindex"].ToString(),
                                    ["roundmethod"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["roundmethod"].ToString(),
                                    ["precision"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["precision"].ToString(),
                                    ["discount"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["discount"].ToString(),
                                    ["stubintovrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["stubintovrd"].ToString(),
                                    ["loanpurchase"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["loanpurchase"].ToString(),
                                    ["purintovrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["purintovrd"].ToString(),
                                    ["insvrpayoverinlvly"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["insvrpayoverinlvly"].ToString(),
                                    ["intcalcrulepydn"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["intcalcrulepydn"].ToString(),
                                    ["capclscost"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["capclscost"].ToString(),
                                    ["busidayrelapmtdt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["busidayrelapmtdt"].ToString(),
                                    ["dayofmnth"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["dayofmnth"].ToString(),
                                    ["accfreq"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["accfreq"].ToString(),
                                    ["determidtinterestaccper"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["determidtinterestaccper"].ToString(),
                                    ["determidayrefdayofmnth"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["determidayrefdayofmnth"].ToString(),
                                    ["rateindexresetfreq"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["rateindexresetfreq"].ToString(),
                                    ["accperpaydaywhennoteomnth"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["accperpaydaywhennoteomnth"].ToString(),
                                    ["payfreq"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["payfreq"].ToString(),
                                    ["paydatebusiessdaylag"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["paydatebusiessdaylag"].ToString(),
                                    ["stubpaidadv"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["stubpaidadv"].ToString(),
                                    ["finalintaccenddtvrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["finalintaccenddtvrd"].ToString(),
                                    ["stubonff"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["stubonff"].ToString(),
                                    ["monamovrd"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["monamovrd"].ToString(),
                                    ["fixedamortsche"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["fixedamortsche"].ToString(),
                                    ["amortintcalcdaycnt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["amortintcalcdaycnt"].ToString(),
                                    ["pikinteraddedtoblsbusiadvdate"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["pikinteraddedtoblsbusiadvdate"].ToString(),
                                    ["piksepcomponding"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["piksepcomponding"].ToString(),
                                    ["intcalcruleforamort"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["intcalcruleforamort"].ToString(),
                                    ["actualpayoffdate"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["actualpayoffdate"].ToString(),
                                    ["priority"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["priority"].ToString(),
                                    ["lienpos"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["lienpos"].ToString(),
                                    ["pikcalcrulepydn"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["pikcalcrulepydn"].ToString(),
                                    ["pikcalcruleforamort"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["pikcalcruleforamort"].ToString(),
                                    ["intcalcrulepikprinpmt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["intcalcrulepikprinpmt"].ToString(),
                                    ["pikcalcrulepikprinpmt"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["pikcalcrulepikprinpmt"].ToString(),
                                    ["expectedmaturitydate"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["expectedmaturitydate"].ToString(),
                                    ["FstIndexDeterDtOverride"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["FstIndexDeterDtOverride"].ToString(),
                                    ["accrualperiodtype"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["accrualperiodtype"].ToString(),
                                    ["accrualperiodbusinessdayadj"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["accrualperiodbusinessdayadj"].ToString(),
                                    ["detdt_hlday_ls"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["detdt_hlday_ls"].ToString(),
                                    ["accountingclosedate"] = dtdata_notes_setup_dictionary.Rows[row_dictionary]["accountingclosedate"].ToString(),


                                };

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
                                    var lstnoteperiodiccalc = new List<Dictionary<String, Object>>();
                                    var lstnotecommitment = new List<Dictionary<String, Object>>();
                                    var lstnotebalance = new List<Dictionary<String, Object>>();

                                    //data.notes.NoteAdjustedCommitment
                                    #region "NoteAdjustedCommitment"

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

                                    #endregion



                                    //code for generate all  type rates dtdata_Json_Info 

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
                                                //notes_Deal.Add("actuals", innerDictionary);
                                                lstdata_notes_actuals.Add(innerDictionary);

                                            }
                                        }

                                        //add in effective date parallel
                                        if (lstdata_notes_actuals.Count() > 0)
                                        {
                                            notes_Deal.Add("actuals", lstdata_notes_actuals);
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

                                        //if (lstdata_notes_actuals.Count > 0)
                                        //{
                                        //    notes_Deal_setup_dictionary.Add("actuals", lstdata_notes_actuals);
                                        //}


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
                                    var lstdtdata_notes_watchlist = new List<Dictionary<string, object>>();



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
                                    //if (dtdata_notes_maturity != null)
                                    //{
                                    //    foreach (DataRow dr_dtdata_notes_maturity in dtdata_notes_maturity.Rows)
                                    //    {
                                    //        if ((dr_dtData_notes_setup["effective_dates"].ToString() == dr_dtdata_notes_maturity["EffectiveDate"].ToString()) && (dr_dtdata_notes_maturity["CRENoteID"].ToString() == dtNotes_Root.Rows[i]["Id"].ToString()))
                                    //        {
                                    //            foreach (DataColumn dc in dtdata_notes_maturity.Columns)
                                    //            {
                                    //                string _key = dc.ColumnName;
                                    //                foreach (DataRow drJsonFormat in dtJsonFormat.Rows)
                                    //                {
                                    //                    if (drJsonFormat["Type"].ToString() == "tbl_notematurity" && drJsonFormat["key"].ToString() == _key)
                                    //                    {
                                    //                        dynamic _value = CommonHelper.convertValforjson(dr_dtdata_notes_maturity[dc], drJsonFormat["DataType"].ToString());
                                    //                        notes_Deal_setup_dictionary.Add(_key, _value);
                                    //                    }
                                    //                }
                                    //            }
                                    //        }
                                    //    }

                                    //}
                                    #endregion



                                    //fees 


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
                    innerData.Add(dtNotes_Root.Rows[i]["id"].ToString(), ObjToCsv.DictionaryToObject(notes_Deal));
                }

                prepayJson.notes = notes;
                #endregion                 


                string _jsonData = JsonConvert.SerializeObject(prepayJson);
                string fileName = "request_rules.json";
                string currentDirectoryPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot//JSONTemplate//" + fileName);
                string jsonRequest = System.IO.File.ReadAllText(currentDirectoryPath);

                //dynamic 
                objJsonResult = JsonConvert.DeserializeObject<ExpandoObject>(jsonRequest);
                objJsonResult.data.data = JsonConvert.DeserializeObject<ExpandoObject>(_jsonData);  // _jsonData;


                objJsonResult.data.data.period_end_date = dtDataRootinfo.Rows[0]["period_end_date"].ToString();
                objJsonResult.data.engine = dtDataRootinfo.Rows[0]["engine"].ToString(); ;
                objJsonResult.data.data.period_start_date = dtDataRootinfo.Rows[0]["period_start_date"].ToString();
                objJsonResult.data.data.root_note_id = dtDataRootinfo.Rows[0]["root_note_id"].ToString();
                objJsonResult.data.data.debug = dtDataRootinfo.Rows[0]["debug"].ToBoolean();

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
                        objJsonResult.data.rules = _fileContent;
                    }
                    #endregion

                }



                #region effective_dates
                string[] arrEffectiveDt = dtDataEffective_dates.AsEnumerable().Select(x => x.Field<string>("effective_dates")).ToArray();
                string effective_dates = JsonConvert.SerializeObject(arrEffectiveDt);
                dynamic _effective_dates = JsonConvert.DeserializeObject(effective_dates);
                objJsonResult.data.data.effective_dates = _effective_dates;
                #endregion

                dynamic index = new ExpandoObject();
                //dtdata_calendars
                #region calendars
                calendars calendars = new calendars();
                var lstcalenders = new List<Dictionary<string, object>>();
                var innerData_root_calenders = new Dictionary<string, List<Dictionary<string, string[]>>>();
                IDictionary<string, object> innerData_calendars = (IDictionary<string, object>)index;

                string[] arrCalendarUSDt = dtdata_calendars.AsEnumerable().Where(x => x.Field<string>("HolidaytypeText") == "US").Select(x => x.Field<string>("HoliDayDate")).ToArray();
                string[] arrCalendarUKDt = dtdata_calendars.AsEnumerable().Where(x => x.Field<string>("HolidaytypeText") == "UK").Select(x => x.Field<string>("HoliDayDate")).ToArray();
                string[] arrCalendarUSandUKDt = dtdata_calendars.AsEnumerable().Where(x => x.Field<string>("HolidaytypeText") == "US & UK").Select(x => x.Field<string>("HoliDayDate")).ToArray();
                string[] arrCalendarSIFMAUS = dtdata_calendars.AsEnumerable().Where(x => x.Field<string>("HolidaytypeText") == "SIFMA US").Select(x => x.Field<string>("HoliDayDate")).ToArray();
                calendars.US = arrCalendarUSDt;
                calendars.UK = arrCalendarUKDt;
                calendars.US_and_UK = arrCalendarUSandUKDt;
                calendars.SIFMA_US = arrCalendarSIFMAUS;


                objJsonResult.data.data.calendar = calendars;
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
        }
        public string SavePrepayPremium(string requestid, string headerkey, string headerValue, string strAPI, string username)
        {

            string status = "";
            LoggerLogic Log = new LoggerLogic();
            var cts = new CancellationTokenSource();
            string SavingFailedFor = "";
            V1CalcLogic _V1CalcLogic = new V1CalcLogic();

            try
            {
                V1CalcLogic v1logic = new V1CalcLogic();
                v1logic.InsertUpdateCalculationQueueRequest(requestid, null, null, null, 267, null, null, 1, username);
                // Prepay premium saving
                SavingFailedFor = "Prepaypremium_Output";
                var strPrepayPremiumAPI = strAPI + "/" + requestid + "/outputs/prepaypremium.csv";
                HttpClient prepaypremiumclient = new HttpClient();
                prepaypremiumclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                var apiprepaypremiumresult = prepaypremiumclient.GetAsync(strPrepayPremiumAPI).Result;
                if (apiprepaypremiumresult.IsSuccessStatusCode == true)
                {
                    var prepaypremiumresponse = apiprepaypremiumresult.Content.ReadAsStringAsync().Result;
                    var prepaypremiumoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(prepaypremiumresponse);
                    DataTable dtPrepaypremiumoutput = ObjToDataTable.ConvertStringToDataTableToSave(prepaypremiumoutput.data);

                    foreach (DataRow row in dtPrepaypremiumoutput.Rows)
                    {
                        row["prepaypremium"] = CommonHelper.StringToDecimal(row["prepaypremium"]);
                        row["bal"] = CommonHelper.StringToDecimal(row["bal"]);
                    }

                    _V1CalcLogic.InsertPrepayPremiumEntry(dtPrepaypremiumoutput, username);
                    v1logic.InsertUpdateCalculationQueueRequest(requestid, null, null, null, 266, null, null, 1, username);
                    status = "Saved";

                    string CREdealID = string.Empty;
                    DateTime PrepayDate = new DateTime();
                    string DealID = string.Empty;

                    if (dtPrepaypremiumoutput.Rows.Count > 0)
                    {
                        CREdealID = dtPrepaypremiumoutput.Rows[0]["DealID"].ToString();
                        PrepayDate = Convert.ToDateTime(dtPrepaypremiumoutput.Rows[0]["prepaydate"]);
                    }

                    string formattedDate = PrepayDate.ToString("MM-dd-yyyy");

                    LiabilityNoteLogic lc = new LiabilityNoteLogic();
                    DataTable dt = lc.GetDealDatabyCREDealID(CREdealID);

                    if (dt.Rows.Count > 0)
                    {
                        DealID = dt.Rows[0]["DealID"].ToString();
                    }

                    UploadPrepayPremium_CF(requestid, headerkey, headerValue, strAPI, DealID, formattedDate);
                }
                status = "Saved";

            }
            catch (Exception ex)
            {

                string result = "";
                V1CalcLogic v1logic = new V1CalcLogic();
                result = "Saving Failed for : Prepay premium : " + ex.Message;
                if (result.Contains("A task was canceled"))
                {
                    status = "Retry";
                    result = "Saving Failed for : Prepay premium as M61 output api did not responds in 60 secs ";
                }
                else if (result.Contains("timeout"))
                {
                    status = "Retry";
                }
                else if (result.Contains("deadlock"))
                {
                    status = "Retry";
                }
                else
                {
                    status = "Failed";
                }
                _V1CalcLogic.UpdateM61EngineCalcStatus(requestid, Convert.ToInt32(-1), "Prepay Premium calculated successfully but failed to save data in DB.");
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), "Error in saving for  " + SavingFailedFor + " for request id:: " + requestid + " " + ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "GetFileOutput", result);
            }

            return status;
        }
        public DataTable GetDefeaultDataForPayoffStatementFees(string DealID)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("PayoffStatementFeesID");
            dt.Columns.Add("FeeName");
            dt.Columns.Add("FeeType");
            dt.Columns.Add("FeeTypeText");
            dt.Columns.Add("Value");
            dt.Columns.Add("DealID");
            dt.Columns.Add("Comment");


            DataRow rmport = dt.NewRow();
            rmport["PayoffStatementFeesID"] = 0;
            rmport["FeeName"] = "Lender's Counsel's Legal Fee";
            rmport["FeeType"] = 927;
            rmport["FeeTypeText"] = "Legal";
            rmport["Value"] = 7500;
            rmport["DealID"] = DealID;
            rmport["Comment"] = "";
            dt.Rows.Add(rmport);

            DataRow rmport1 = dt.NewRow();
            rmport1["PayoffStatementFeesID"] = 0;
            rmport1["FeeName"] = "ACORE Processing Fee";
            rmport1["FeeType"] = 928;
            rmport1["FeeTypeText"] = "ACORE Processing";
            rmport1["Value"] = 2500;
            rmport1["DealID"] = DealID;
            rmport["Comment"] = "";
            dt.Rows.Add(rmport1);

            DataRow rmport2 = dt.NewRow();
            rmport2["PayoffStatementFeesID"] = 0;
            rmport2["FeeName"] = "Servicer Processing Fee";
            rmport2["FeeType"] = 929;
            rmport2["FeeTypeText"] = "Servicer Fee";
            rmport2["Value"] = 500;
            rmport2["DealID"] = DealID;
            rmport["Comment"] = "";
            dt.Rows.Add(rmport2);

            return dt;
        }

        public string UploadPrepayPremium_CF(string requestid, string headerkey, string headerValue, string strAPI, string DealID, string PrepayDate)
        {
            string status = "";
            LoggerLogic Log = new LoggerLogic();

            try
            {
                var strPrepayPremiumAPI = strAPI + "/" + requestid + "/outputs/prepaypremium_cf.csv";
                HttpClient prepaypremiumclient = new HttpClient();
                prepaypremiumclient.DefaultRequestHeaders.Add(headerkey, headerValue);
                var apiprepaypremiumresult = prepaypremiumclient.GetAsync(strPrepayPremiumAPI).Result;
                if (apiprepaypremiumresult.IsSuccessStatusCode == true)
                {
                    var prepaypremiumresponse = apiprepaypremiumresult.Content.ReadAsStringAsync().Result;
                    var prepaypremiumoutput = JsonConvert.DeserializeObject<Jsonperiodicresponse>(prepaypremiumresponse);
                    DataTable dtPrepaypremiumoutput_cf = ObjToDataTable.ConvertStringToDataTableToSave(prepaypremiumoutput.data);

                    List<string> columnsToRemove = new List<string> { "LIBORPercentage", "PIKInterestPercentage", "SpreadPercentage" };

                    foreach (string colName in columnsToRemove)
                    {
                        if (dtPrepaypremiumoutput_cf.Columns.Contains(colName))
                        {
                            dtPrepaypremiumoutput_cf.Columns.Remove(colName);
                        }
                    }

                    string csvData = ConvertDataTableToCsv(dtPrepaypremiumoutput_cf);
                    UploadCSVFileToAzureBlob(csvData, "PPOutputCF_" + DealID + "_" + PrepayDate + ".csv");
                }

                status = "Saved";

            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.V1Calculator.ToString(), ex.StackTrace, requestid, "B0E6697B-3534-4C09-BE0A-04473401AB93", "UploadPrepayPremium_CF", "Error in UploadPrepayPremium_CF");
            }

            return status;
        }
        public Boolean UploadCSVFileToAzureBlob(string csvData, string FileName)
        {
            try
            {
                GetConfigSetting();
                byte[] byteArray = Encoding.ASCII.GetBytes(csvData);
                MemoryStream stream = new MemoryStream(byteArray);
                var Container = Sectionroot.GetSection("storage:container:name").Value;
                // Get Blob Container
                CloudBlobContainer container = BlobUtilities.GetBlobClient.GetContainerReference(Container);
                CloudBlobDirectory blobDirectory = container.GetDirectoryReference("CalcDebug");
                CloudBlockBlob blockBlob = blobDirectory.GetBlockBlobReference(FileName);
                blockBlob.UploadFromStream(stream);
                return true;
            }
            catch (Exception ex)
            {
                return false;
                throw;
            }
        }

        internal class BlobUtilities
        {

            public static CloudBlobClient GetBlobClient
            {
                get
                {

                    IConfigurationSection Sectionroot = null;
                    IConfigurationBuilder builder = new ConfigurationBuilder();
                    builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
                    var root = builder.Build();
                    Sectionroot = root.GetSection("Application");


                    var accountName = Sectionroot.GetSection("storage:account:name").Value;
                    var accountKey = Sectionroot.GetSection("storage:account:key").Value;

                    CloudStorageAccount storageAccount = CloudStorageAccount.Parse("DefaultEndpointsProtocol=https;AccountName=" + accountName + ";"
                     + "AccountKey=" + accountKey + "");
                    CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
                    return blobClient;
                }
            }

        }
        private string ConvertDataTableToCsv(DataTable dataTable)
        {
            var csvBuilder = new StringBuilder();

            foreach (DataColumn column in dataTable.Columns)
            {
                csvBuilder.Append(column.ColumnName + ",");
            }
            csvBuilder.AppendLine();

            foreach (DataRow row in dataTable.Rows)
            {
                foreach (var item in row.ItemArray)
                {
                    csvBuilder.Append(item.ToString().Replace(",", ";") + ",");
                }
                csvBuilder.AppendLine();
            }

            return csvBuilder.ToString();
        }


        public int GetPayoffEmailToSendCount()
        {
            return PayoffRepository.GetPayoffEmailToSendCount();
        }

        public DataTable GetPayoffEmailData()
        {
            return PayoffRepository.GetPayoffEmailData();
        }

        public void UpdateCalculationRequestSetIsEmailSentToYes(string CalculationRequestID)
        {
            PayoffRepository.UpdateCalculationRequestSetIsEmailSentToYes(CalculationRequestID);
        }

    }
}
