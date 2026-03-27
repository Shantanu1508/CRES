using System;
using System.Collections.Generic;
using System.Text;
using CRES.DataContract;
using System.Linq;
using System.Data;
using System.IO;
using CRES.DAL.Repository;
using CRES.Utilities;


namespace CRES.BusinessLogic
{
    public class CommitmentEquityHelperLogic
    {
        public NoteDataContract noteDC = new NoteDataContract();
        private DealRepository _dealRepository = new DealRepository();
        LoggerLogic Log = new LoggerLogic();
        public List<NoteCommitmentEquityDataContract> calcNoteCommitment(string DealID, Guid headerUserID)
        {
            List<NoteCommitmentEquityDataContract> lstnoteCommitment = new List<NoteCommitmentEquityDataContract>();
            try
            {
                Log.WriteLogInfo(CRESEnums.Module.GenerateAutomation.ToString(), "calcNoteCommitment called", "", "");
                DataTable dtTotalCommitment = _dealRepository.GetAdjustmentTotalCommitmentByDealIDForAPI(new Guid(DealID), new Guid("b0e6697b-3534-4c09-be0a-04473401ab93"));
                GetDealCommitment(dtTotalCommitment, headerUserID, DealID);
            }
            catch (Exception ex)
            {
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, DealID, "", "calcNoteCommitment", "Error occurred  calcNoteCommitment using API" + DealID + " " + ex.Message);
                throw ex;
            }
            return lstnoteCommitment;
        }
        public List<DealCommitmentEquityDataContract> GetDealCommitment(DataTable dt, Guid headerUserID, string DealID)
        {
            try
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
                    dCommitment.Type = CommonHelper.ToInt32(dt.Rows[adj]["Type"]);
                    dCommitment.TypeText = dt.Rows[adj]["TypeText"].ToString();
                    dCommitment.DealID = noteDC.DealID;
                    dCommitment.Rownumber = adj;
                    dCommitment.Comments = dt.Rows[adj]["Comments"].ToString();
                    dCommitment.TotalRequiredEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalRequiredEquity"]);
                    dCommitment.TotalAdditionalEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalAdditionalEquity"]);
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
                                if (dt.Rows[adj][columnNames[n]] != null)
                                {


                                    if (dt.Rows[adj]["TypeText"].ToString() == "Equity Rebalancing")
                                    {
                                        AdjustedTotalCommitmentDataContract dCommitment = new AdjustedTotalCommitmentDataContract();
                                        dCommitment.Date = CommonHelper.ToDateTime(dt.Rows[adj]["Date"]);
                                        dCommitment.Type = CommonHelper.ToInt32(dt.Rows[adj]["Type"]);
                                        dCommitment.TypeText = dt.Rows[adj]["TypeText"].ToString();
                                        dCommitment.CommitmentType = dt.Rows[adj]["CommitmentType"].ToString();
                                        dCommitment.DealID = new Guid(dt.Rows[adj]["DealId"].ToString());
                                        dCommitment.Rownumber = adj;
                                        dCommitment.Comments = dt.Rows[adj]["Comments"].ToString();
                                        dCommitment.TotalRequiredEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalRequiredEquity"]);
                                        dCommitment.TotalAdditionalEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalAdditionalEquity"]);
                                        dCommitment.NoteID = new Guid(columnNames[n].Split("_")[0]);
                                        // dCommitment.Amount = CommonHelper.ToDecimal(dt.Rows[adj]["TotalAdditionalEquity"]);
                                        lstdealNOteCommitment.Add(dCommitment);
                                    }
                                    else
                                    {
                                        AdjustedTotalCommitmentDataContract dCommitment = new AdjustedTotalCommitmentDataContract();
                                        dCommitment.Date = CommonHelper.ToDateTime(dt.Rows[adj]["Date"]);
                                        dCommitment.Type = CommonHelper.ToInt32(dt.Rows[adj]["Type"]);
                                        dCommitment.TypeText = dt.Rows[adj]["TypeText"].ToString();
                                        dCommitment.CommitmentType = dt.Rows[adj]["CommitmentType"].ToString();
                                        dCommitment.DealID = new Guid(dt.Rows[adj]["DealId"].ToString());
                                        dCommitment.Rownumber = adj;
                                        dCommitment.Comments = dt.Rows[adj]["Comments"].ToString();
                                        dCommitment.TotalRequiredEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalRequiredEquity"]);
                                        dCommitment.TotalAdditionalEquity = CommonHelper.ToDecimal(dt.Rows[adj]["TotalAdditionalEquity"]);
                                        dCommitment.NoteID = new Guid(columnNames[n].Split("_")[0]);
                                        dCommitment.Amount = CommonHelper.ToDecimal(dt.Rows[adj][columnNames[n]]);

                                        lstdealNOteCommitment.Add(dCommitment);
                                    }

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
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogExceptionMessage(CRESEnums.Module.GenerateAutomation.ToString(), ex.StackTrace, DealID, "", "GetDealCommitment", "Error occurred  in GetDealCommitment using API" + DealID + " " + ex.Message);
                throw ex;
            }
        }

        public List<AdjustedTotalCommitmentDataContract> calculateNoteCommitment(List<AdjustedTotalCommitmentDataContract> lstNOteCommitment)
        {

            try
            {

                var lstNOte = lstNOteCommitment.Select(o => o.NoteID).Distinct().ToList();

                for (var j = 0; j < lstNOte.Count; j++)
                {
                    var note = lstNOteCommitment.Where(x => x.NoteID == lstNOte[j]).ToList();
                    for (var k = 0; k < note.Count; k++)
                    {
                        //  if (note[k].TypeText == "Closing")
                        if (k == 0)
                        {
                            note[k].NoteAdjustedTotalCommitment = note[k].Amount;
                          //  note[k].NoteAggregatedTotalCommitment = note[k].Amount;
                            note[k].NoteTotalCommitment = note[k].Amount;

                        }
                        else
                        {

                            note[k].NoteAdjustedTotalCommitment =Convert.ToDecimal( note[k - 1].NoteAdjustedTotalCommitment) + Convert.ToDecimal(note[k].Amount!=null ? note[k].Amount:0);
                            //Total Commitment Adjustment NoteAdjustedTotalCommitment
                            //if (note[k].TypeText == "Prepayment" || note[k].TypeText == "Scheduled Principal")
                            //    note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment;
                            //else
                            //    note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment + note[k].AmountConvert.ToDecimal( 

                            //Total Commitment NoteTotalCommitment

                            if (note[k].TypeText == "Upsize/Mod" || note[k].TypeText == "Note Transfer" || note[k].TypeText == "Closing")
                            {
                                note[k].NoteTotalCommitment = Convert.ToDecimal(note[k - 1].NoteTotalCommitment) + Convert.ToDecimal(note[k].Amount != null ? note[k].Amount : 0);
                            }
                            else
                            {
                                note[k].NoteTotalCommitment = note[k - 1].NoteTotalCommitment;
                            }

                           



                            
                            /*
                                if (note[k].TypeText == "Prepayment" || note[k].TypeText == "Curtailment" || note[k].TypeText == "Equity Rebalancing"|| note[k].TypeText == "Closing")
                                {
                                    note[k].NoteAggregatedTotalCommitment = note[k - 1].NoteAggregatedTotalCommitment;
                                    if (note[k].CommitmentType == "BalloonPayment" || note[k].CommitmentType == "Prepayment")
                                    {
                                        note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment + note[k].Amount;
                                    }
                                    else
                                    {
                                        note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment;
                                    }
                                }
                                
                            else
                            {
                                if (note.Count == 1)
                                {
                                    note[k].NoteAdjustedTotalCommitment = note[k].Amount;
                                    note[k].NoteAggregatedTotalCommitment = note[k].Amount;
                                }
                                else
                                {
                                    note[k].NoteAdjustedTotalCommitment = note[k - 1].NoteAdjustedTotalCommitment + note[k].Amount;
                                    note[k].NoteAggregatedTotalCommitment = note[k - 1].NoteAggregatedTotalCommitment + note[k].Amount;
                                }
                            
                        }



                            if (note.Count == 1)
                            {
                                note[k].NoteTotalCommitment = note[k].Amount;
                            }
                            else
                            {
                                note[k].NoteTotalCommitment = note[k - 1].NoteTotalCommitment;
                            }
                            */
                        }

                    }
                }
               // CreateCSVFile(ToDataSet(lstNOteCommitment).Tables[0], "Test1");


                return lstNOteCommitment;
            }
            catch (Exception ex)
            {

                throw;
            }
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
