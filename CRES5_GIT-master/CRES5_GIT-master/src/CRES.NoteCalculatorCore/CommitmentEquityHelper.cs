using CRES.DAL.Repository;
using CRES.DataContract;
using CRES.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

namespace CRES.NoteCalculator
{
    public class CommitmentEquityHelper
    {

        public NoteDataContract noteDC = new NoteDataContract();
        private DealRepository _dealRepository = new DealRepository();
        public List<NoteCommitmentEquityDataContract> calcNoteCommitment(string DealID, Guid headerUserID)
        {
            List<NoteCommitmentEquityDataContract> lstnoteCommitment = new List<NoteCommitmentEquityDataContract>();
            try
            {
                // noteDC = notedc;
                DataTable dtTotalCommitment = _dealRepository.GetAdjustmentTotalCommitmentByDealIDForAPI(new Guid(DealID), new Guid("b0e6697b-3534-4c09-be0a-04473401ab93"));

                GetDealCommitment(dtTotalCommitment, headerUserID);


            }
            catch (Exception ex)
            {
                throw ex;
            }
            return lstnoteCommitment;
        }

        #region UnUsed
        public List<DealCommitmentEquityDataContract> GetDealCommitmentNew(DataTable dt)
        {
            List<DealCommitmentEquityDataContract> lstdealCommitment = new List<DealCommitmentEquityDataContract>();
            var distinctDatearr = (from r in dt.AsEnumerable()
                                   select r["Date"]).Distinct().ToList();


            for (var i = 0; i < distinctDatearr.Count; i++)
            {
                DealCommitmentEquityDataContract dCommitment = new DealCommitmentEquityDataContract();

                dCommitment.Date = CommonHelper.ToDateTime(dt.Rows[i]["Date"]);
                dCommitment.Type = CommonHelper.ToInt32(dt.Rows[i]["Type"]);
                dCommitment.TypeText = dt.Rows[i]["TypeText"].ToString();
                dCommitment.DealID = dt.Rows[i]["DealID"].ToString();
                dCommitment.Comments = dt.Rows[i]["Comments"].ToString();
                dCommitment.TotalRequiredEquity = CommonHelper.ToDecimal(dt.Rows[i]["TotalRequiredEquity"]);
                dCommitment.TotalAdditionalEquity = CommonHelper.ToDecimal(dt.Rows[i]["TotalAdditionalEquity"]);
                dCommitment.ExcludeFromCommitmentCalculation = CommonHelper.ToBoolean(dt.Rows[i]["ExcludeFromCommitmentCalculation"]);

                if (i == 0)
                {
                    dCommitment.NoteID = dt.Rows[i]["NOteID"].ToString();
                    if (dt.Rows[i]["TypeText"].ToString() == "Closing")
                    {

                    }
                }
                else
                {

                }
            }
            return lstdealCommitment;
        }

        public void GroupByList()
        {

            var grplCashflowTransEntry = noteDC.ListCashflowTransactionEntry.Where(x => x.Date <= DateTime.Now.Date && x.Amount != Convert.ToDecimal(0.01)).GroupBy(y => new { y.Date, y.PurposeType, y.CRENoteID, y.FeeName }).Select(val => new TransactionEntry
            {
                Date = val.Key.Date,
                PurposeType = val.Key.PurposeType,
                CRENoteID = val.Key.CRENoteID,
                FeeName = val.Key.FeeName,
                Amount = val.Sum(v => v.Amount)
            }).ToList();

        }
        #endregion



        public List<DealCommitmentEquityDataContract> GetDealCommitment(DataTable dt, Guid headerUserID)
        {
            List<DealCommitmentEquityDataContract> lstdealCommitment = new List<DealCommitmentEquityDataContract>();


            string[] columnNames = dt.Columns.Cast<DataColumn>()
                                 .Select(x => x.ColumnName)
                                 .ToArray();
            ///=========================Deal Commitment==================
            for (var adj = 0; adj < dt.Rows.Count; adj++)
            {
                DealCommitmentEquityDataContract dCommitment = new DealCommitmentEquityDataContract();
                dCommitment.Date = CommonHelper.ToDateTime(dt.Rows[adj]["Date"]);
                //dCommitment.Rownumber = CommonHelper.ToInt32(dt.Rows[adj]["Rownumber"]);
                dCommitment.Type = CommonHelper.ToInt32(dt.Rows[adj]["Type"]);
                dCommitment.TypeText = dt.Rows[adj]["TypeText"].ToString();
                dCommitment.DealID = noteDC.DealID;
                dCommitment.Rownumber = adj;
                dCommitment.Comments = dt.Rows[adj]["Comments"].ToString();
                dCommitment.TotalRequiredEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalRequiredEquity"]);
                dCommitment.TotalAdditionalEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalAdditionalEquity"]);
                dCommitment.ExcludeFromCommitmentCalculation = CommonHelper.ToBoolean(dt.Rows[adj]["ExcludeFromCommitmentCalculation"]);
                decimal? adjusteddealcommitmenthistorycol = 0;
                for (var n = 0; n < columnNames.Length; n++)
                {

                    var _isbracket = columnNames[n].IndexOf("_");
                    if (_isbracket > -1)
                    {
                        if (columnNames[n].Contains("_Noteid"))
                        {
                            dCommitment.NoteID = columnNames[n].Split("_")[0];
                            dCommitment.Amount = CommonHelper.ToDecimal(dt.Rows[adj][columnNames[n]]);
                            adjusteddealcommitmenthistorycol = adjusteddealcommitmenthistorycol + CommonHelper.ToDecimal(dt.Rows[adj][columnNames[n]]);

                        }

                    }


                }
                if (adj == 0)
                {
                    dCommitment.AdjustedCommitment = adjusteddealcommitmenthistorycol;
                    dCommitment.TotalCommitment = adjusteddealcommitmenthistorycol;

                }
                else
                {
                    //dCommitment.AdjustedCommitment = lstdealCommitment[n-1].AdjustedCommitment + CommonHelper.ToDecimal(dt.Rows[adj][columnNames[n]]);

                    dCommitment.AdjustedCommitment = lstdealCommitment[adj - 1].AdjustedCommitment + adjusteddealcommitmenthistorycol;


                    if (dt.Rows[adj]["TypeText"].ToString() == "Prepayment" || dt.Rows[adj]["TypeText"].ToString() == "Scheduled Principal" || dt.Rows[adj]["TypeText"].ToString() == "Curtailment")
                    {
                        dCommitment.TotalCommitment = lstdealCommitment[adj - 1].TotalCommitment;
                        // this.adjusteddealaggregatedcommitmentcol = this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.AggregatedCommitment;
                    }
                    else
                    {
                        dCommitment.TotalCommitment = lstdealCommitment[adj - 1].TotalCommitment + adjusteddealcommitmenthistorycol;
                        //  this.adjusteddealaggregatedcommitmentcol = this.flexadjustedtotalcommitment.rows[adj].dataItem.DealAdjustmentHistory + this.flexadjustedtotalcommitment.rows[adj - 1].dataItem.AggregatedCommitment;
                    }

                }
                dCommitment.DealAdjustmentHistory = adjusteddealcommitmenthistorycol;
                lstdealCommitment.Add(dCommitment);
            }


            //==============================Note Commitment============================

            //List<DealCommitmentEquityDataContract> lstdealNOteCommitment = new List<DealCommitmentEquityDataContract>();
            List<AdjustedTotalCommitmentDataContract> lstdealNOteCommitment = new List<AdjustedTotalCommitmentDataContract>();
            for (var adj = 0; adj < dt.Rows.Count; adj++)
            {

                decimal? adjusteddealcommitmenthistorycol = 0;
                for (var n = 0; n < columnNames.Length; n++)
                {

                    var _isbracket = columnNames[n].IndexOf("_");
                    if (_isbracket > -1)
                    {
                        if (columnNames[n].Contains("_Noteid"))
                        {
                            if (CommonHelper.ToDecimal(dt.Rows[adj][columnNames[n]]) != 0)
                            {
                                //   DealCommitmentEquityDataContract dCommitment = new DealCommitmentEquityDataContract();
                                AdjustedTotalCommitmentDataContract dCommitment = new AdjustedTotalCommitmentDataContract();
                                dCommitment.Date = CommonHelper.ToDateTime(dt.Rows[adj]["Date"]);
                                //dCommitment.Rownumber = CommonHelper.ToInt32(dt.Rows[adj]["Rownumber"]);
                                dCommitment.Type = CommonHelper.ToInt32(dt.Rows[adj]["Type"]);
                                dCommitment.TypeText = dt.Rows[adj]["TypeText"].ToString();
                                dCommitment.CommitmentType = dt.Rows[adj]["CommitmentType"].ToString();
                                dCommitment.DealID = new Guid(dt.Rows[adj]["DealId"].ToString());
                                dCommitment.Rownumber = adj;
                                dCommitment.Comments = dt.Rows[adj]["Comments"].ToString();
                                dCommitment.TotalRequiredEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalRequiredEquity"]);
                                dCommitment.TotalAdditionalEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalAdditionalEquity"]);
                                dCommitment.ExcludeFromCommitmentCalculation = CommonHelper.ToBoolean(dt.Rows[adj]["ExcludeFromCommitmentCalculation"]);
                                dCommitment.NoteID = new Guid(columnNames[n].Split("_")[0]);
                                dCommitment.Amount = CommonHelper.ToDecimal(dt.Rows[adj][columnNames[n]]);
                                adjusteddealcommitmenthistorycol = adjusteddealcommitmenthistorycol + CommonHelper.ToDecimal(dt.Rows[adj][columnNames[n]]);
                                lstdealNOteCommitment.Add(dCommitment);
                            }
                        }

                    }
                }
            }

            for (var n = 0; n < lstdealNOteCommitment.Count; n++)
            {
                for (var d = 0; d < lstdealCommitment.Count; d++)
                {

                    if (lstdealNOteCommitment[n].Date == lstdealCommitment[d].Date && lstdealNOteCommitment[n].Type == lstdealCommitment[d].Type)
                    {
                        lstdealNOteCommitment[n].DealAdjustmentHistory = lstdealCommitment[d].DealAdjustmentHistory;
                        lstdealNOteCommitment[n].AdjustedCommitment = lstdealCommitment[d].AdjustedCommitment;
                        lstdealNOteCommitment[n].TotalCommitment = lstdealCommitment[d].TotalCommitment;
                    }
                }
            }

            var NoteCommitment = calculateNoteCommitment(lstdealNOteCommitment);




            // CreateCSVFile(ToDataSet(lstdealNOteCommitment).Tables[0], "FinalnoteCommitment33");

            //  CreateCSVFile(ToDataSet(NoteCommitment).Tables[0], "FinalnoteCommitment44");


            _dealRepository.InsertUpdateAdjustedTotalCommitment(NoteCommitment, headerUserID);




            return lstdealCommitment;
        }
        public List<NoteCommitmentEquityDataContract> GetCommitmentTransaction()
        {

            int j = 0;
            var Fundingdate = noteDC.ListCashflowTransactionEntry.Where(x => x.Date <= DateTime.Now.Date && x.Amount != Convert.ToDecimal(0.01)).Select(d => d.Date).Distinct();

            List<NoteCommitmentEquityDataContract> lstnoteCommitment = new List<NoteCommitmentEquityDataContract>();

            NoteCommitmentEquityDataContract nCommit = new NoteCommitmentEquityDataContract();
            nCommit.Date = noteDC.ClosingDate;
            nCommit.Type = "Closing";
            nCommit.NoteAmount = noteDC.OriginalTotalCommitment;
            nCommit.NoteAdjustedCommitment = noteDC.OriginalTotalCommitment;
            nCommit.NoteTotalCommitment = noteDC.OriginalTotalCommitment;
            nCommit.DealID = noteDC.DealID;
            nCommit.NoteId = noteDC.NoteId;

            lstnoteCommitment.Add(nCommit);
            //lstnoteCommitment1.Add(nCommit);
            var maxeffective = noteDC.ListFutureFundingScheduleTabFromDB.Max(x => x.EffectiveDate);
            var noteFunding = noteDC.ListFutureFundingScheduleTabFromDB.Where(x => x.EffectiveDate == maxeffective).ToList();

            noteFunding = noteFunding.OrderBy(x => x.Date).ToList();

            var Fundingdates = noteFunding.Where(x => x.PurposeText == "Amortization" || x.PurposeText == "Full Payoff" || x.PurposeText == "Capital Expenditure").GroupBy(x => x.Date).Select(y => y.Key).ToList();
            var CashflowTransDates = noteDC.ListCashflowTransactionEntry.Where(x => x.Type == "Balloon" || x.Type == "PIKPrincipalFunding" || x.Type == "PIKPrincipalPaid" || x.Type == "ScheduledPrincipal").GroupBy(y => y.Date).Select(y => y.Key).ToList();
            noteDC.ListNoteCommitment = noteDC.ListNoteCommitment.Where(x => x.Amount != Convert.ToDecimal("0.01") && x.Amount != 0).ToList();
            var NoteCommitmentDates = noteDC.ListNoteCommitment.GroupBy(y => y.Date).Select(y => y.Key).ToList();
            var MyCombinedList = NoteCommitmentDates.Concat(Fundingdates.Concat(CashflowTransDates)).Distinct().ToList();

            noteFunding = noteFunding.Where(x => x.Value != Convert.ToDecimal("0.01") && x.Value != 0).ToList();
            noteDC.ListCashflowTransactionEntry = noteDC.ListCashflowTransactionEntry.Where(x => x.Amount != Convert.ToDecimal("0.01") && x.Amount != 0).ToList();

            for (var k = 0; k < MyCombinedList.Count; k++)
            {

                for (var i = 0; i < noteFunding.Count; i++)
                {
                    if (MyCombinedList[k].Value == noteFunding[i].Date)
                    {
                        NoteCommitmentEquityDataContract nCommitment = new NoteCommitmentEquityDataContract();

                        if (noteFunding[i].PurposeText == "Amortization")
                        {
                            nCommitment.Date = noteFunding[i].Date;
                            nCommitment.Type = "Scheduled Principal";
                            nCommitment.NoteAmount = noteFunding[i].Value;
                            nCommitment.NoteAdjustedCommitment = lstnoteCommitment[j].NoteAdjustedCommitment + nCommitment.NoteAmount;
                            nCommitment.NoteTotalCommitment = lstnoteCommitment[j].NoteTotalCommitment;
                            nCommitment.DealID = noteDC.DealID;
                            nCommitment.NoteId = noteDC.NoteId;

                            j++;
                            lstnoteCommitment.Add(nCommitment);
                        }

                        if (noteFunding[i].PurposeText == "Upsize/Mod" || noteFunding[i].PurposeText == "Curtailment" || noteFunding[i].PurposeText == "Note Transfer" || noteFunding[i].PurposeText == "Equity Rebalancing")
                        {
                            nCommitment.Date = noteFunding[i].Date;
                            nCommitment.Type = "Others";
                            nCommitment.NoteAmount = noteFunding[i].Value;
                            nCommitment.NoteAdjustedCommitment = lstnoteCommitment[j].NoteAdjustedCommitment + noteFunding[i].Value;
                            nCommitment.NoteTotalCommitment = lstnoteCommitment[j].NoteTotalCommitment + noteFunding[i].Value;
                            nCommitment.DealID = noteDC.DealID;
                            nCommitment.NoteId = noteDC.NoteId;

                            j++;
                            lstnoteCommitment.Add(nCommitment);
                        }

                    }
                }


                for (var m = 0; m < noteDC.ListCashflowTransactionEntry.Count; m++)
                {
                    if (MyCombinedList[k].Value == noteDC.ListCashflowTransactionEntry[m].Date)
                    {
                        NoteCommitmentEquityDataContract nCommitment = new NoteCommitmentEquityDataContract();

                        if ((noteDC.ListCashflowTransactionEntry[m].Type == "PIKPrincipalPaid") || (noteDC.ListCashflowTransactionEntry[m].Type == "Balloon"))
                        {
                            nCommitment.Date = noteDC.ListCashflowTransactionEntry[m].Date;
                            nCommitment.Type = "Prepayment";
                            nCommitment.NoteAmount = -1 * (noteDC.ListCashflowTransactionEntry[m].Amount);
                            nCommitment.NoteAdjustedCommitment = lstnoteCommitment[j].NoteAdjustedCommitment;
                            nCommitment.NoteTotalCommitment = lstnoteCommitment[j].NoteTotalCommitment;
                            nCommitment.DealID = noteDC.DealID;
                            nCommitment.NoteId = noteDC.NoteId;

                            j++;
                            lstnoteCommitment.Add(nCommitment);
                        }


                        if ((noteDC.ListCashflowTransactionEntry[m].PurposeType == "Full Payoff"))
                        {
                            nCommitment.Date = noteDC.ListCashflowTransactionEntry[m].Date;
                            nCommitment.Type = "Prepayment";
                            nCommitment.NoteAmount = -1 * (noteDC.ListCashflowTransactionEntry[m].Amount);
                            nCommitment.NoteAdjustedCommitment = lstnoteCommitment[j].NoteAdjustedCommitment;
                            nCommitment.NoteTotalCommitment = lstnoteCommitment[j].NoteTotalCommitment;
                            nCommitment.DealID = noteDC.DealID;
                            nCommitment.NoteId = noteDC.NoteId;
                            j++;
                            lstnoteCommitment.Add(nCommitment);
                        }
                    }
                }

                for (var l = 0; l < noteDC.ListNoteCommitment.Count; l++)
                {
                    if (MyCombinedList[k].Value == noteDC.ListNoteCommitment[l].Date)
                    {
                        if (noteDC.ListNoteCommitment[l].Type == "Upsize/Mod" || noteDC.ListNoteCommitment[l].Type == "Note Transfer" || noteDC.ListNoteCommitment[l].Type == "Equity Rebalancing")
                        {
                            NoteCommitmentEquityDataContract nCommitment = new NoteCommitmentEquityDataContract();
                            nCommitment.Date = noteDC.ListNoteCommitment[l].Date;
                            nCommitment.Type = "Upsize/Mod";
                            nCommitment.NoteAmount = noteDC.ListNoteCommitment[l].Amount;
                            nCommitment.NoteAdjustedCommitment = lstnoteCommitment[j].NoteAdjustedCommitment + noteDC.ListNoteCommitment[l].Amount;
                            nCommitment.NoteTotalCommitment = lstnoteCommitment[j].NoteTotalCommitment + noteDC.ListNoteCommitment[l].Amount;
                            nCommitment.DealID = noteDC.DealID;
                            nCommitment.NoteId = noteDC.NoteId;
                            j++;
                            lstnoteCommitment.Add(nCommitment);
                        }
                        if (noteDC.ListNoteCommitment[l].Type == "Curtailment")
                        {
                            NoteCommitmentEquityDataContract nCommitment = new NoteCommitmentEquityDataContract();
                            nCommitment.Date = noteDC.ListNoteCommitment[l].Date;
                            nCommitment.Type = "Curtailment";
                            nCommitment.NoteAmount = noteDC.ListNoteCommitment[l].Amount;
                            nCommitment.NoteAdjustedCommitment = lstnoteCommitment[j].NoteAdjustedCommitment;
                            nCommitment.NoteTotalCommitment = lstnoteCommitment[j].NoteTotalCommitment;
                            nCommitment.DealID = noteDC.DealID;
                            nCommitment.NoteId = noteDC.NoteId;
                            j++;
                            lstnoteCommitment.Add(nCommitment);
                        }
                    }
                }
            }
            CreateCSVFile(ToDataSet(lstnoteCommitment).Tables[0], noteDC.CRENoteID + "FinalnoteCommitment");
            return lstnoteCommitment;

        }


        public List<AdjustedTotalCommitmentDataContract> calculateNoteCommitment(List<AdjustedTotalCommitmentDataContract> lstNOteCommitment)
        {
            //   List<DealCommitmentEquityDataContract> lstNoteCommit = new List<DealCommitmentEquityDataContract>();
            var lstNOte = lstNOteCommitment.Select(o => o.NoteID).Distinct().ToList();

            for (var j = 0; j < lstNOte.Count; j++)
            {
                var note = lstNOteCommitment.Where(x => x.NoteID == lstNOte[j]).ToList();
                for (var k = 0; k < note.Count; k++)
                {
                    if (note[k].TypeText == "Closing")
                    {
                        note[k].NoteAdjustedTotalCommitment = note[k].Amount;
                        note[k].NoteAggregatedTotalCommitment = note[k].Amount;
                        note[k].NoteTotalCommitment = note[k].Amount;

                    }
                    else
                    {
                        //  note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment + note[k].Amount;


                        if (note[k].TypeText == "Prepayment" || note[k].TypeText == "Curtailment")
                        {
                            if (note[k].CommitmentType == "BalloonPayment")
                            {
                                note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment + note[k].Amount;
                                note[k].NoteAggregatedTotalCommitment = note[k - 1].NoteAggregatedTotalCommitment;
                            }
                            else
                            {
                                note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment;
                                note[k].NoteAggregatedTotalCommitment = note[k - 1].NoteAggregatedTotalCommitment;
                            }
                        }
                        else
                        {
                            note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment + note[k].Amount;
                            note[k].NoteAggregatedTotalCommitment = note[k - 1].NoteAggregatedTotalCommitment + note[k].Amount;

                        }

                        note[k].NoteTotalCommitment = note[k - 1].NoteTotalCommitment;
                    }
                }
            }



            return lstNOteCommitment;
        }

        public static DataSet ToDataSet<T>(IEnumerable<T> list)
        {
            Type elementType = typeof(T);
            DataSet ds = new DataSet();
            System.Data.DataTable t = new System.Data.DataTable();
            ds.Tables.Add(t);

            //add a column to table for each public property on T
            foreach (var propInfo in elementType.GetProperties())
            {
                t.Columns.Add(propInfo.Name);
            }

            //go through each property on T and add each value to the table
            foreach (T item in list)
            {
                DataRow row = t.NewRow();
                foreach (var propInfo in elementType.GetProperties())
                {
                    row[propInfo.Name] = propInfo.GetValue(item, null);
                }

                //This line was missing:
                t.Rows.Add(row);
            }

            return ds;
        }
        public void CreateCSVFile(System.Data.DataTable dt, string csvname)
        {
            try
            {
                string path = @"C:\temp";
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                string strFilePath = "C:\\temp\\" + csvname + ".csv";

                StreamWriter sw = new StreamWriter(strFilePath, false);
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

                sw.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
