using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CRES.Utilities;
using static CRES.DataContract.V1CalcDataContract;
using Syncfusion.Compression;
using static OfficeOpenXml.FormulaParsing.EpplusExcelDataProvider;

namespace CRES.NoteCalculator
{
    public class PrincipalWriteoffHelper
    {
        public PrincipalWriteoffDataContract dataobj = new PrincipalWriteoffDataContract();
        List<AutoDistributeWriteoffDataContract> AutoDistributeWriteoffList = new List<AutoDistributeWriteoffDataContract>();
        List<ServicingPotentialDealWriteoffDataContract> ServicingPotentialDealWriteoffList = new List<ServicingPotentialDealWriteoffDataContract>();
        List<ServicingPotentialNoteWriteoffDataContract> ServicingPotentialNoteWriteoffList = new List<ServicingPotentialNoteWriteoffDataContract>();
        private int createcsv = 0;
        Guid? noteidWithMaxBalance = new Guid();

        public PrincipalWriteoffDataContract StartCalculation(PrincipalWriteoffDataContract _principalwriteoff)
        {
            try
            {
                createcsv = 0;
                dataobj = _principalwriteoff;
                AutoDistributeWriteoffList = dataobj.AutoDistributeWriteoffList;
                ServicingPotentialDealWriteoffList = dataobj.ServicingPotentialDealWriteoffList;
                ServicingPotentialNoteWriteoffList = dataobj.ServicingPotentialNoteWriteoffList;

                ServicingPotentialDealWriteoffList = ServicingPotentialDealWriteoffList.OrderBy(x => x.Date).ToList();
                ServicingPotentialDealWriteoffList = ServicingPotentialDealWriteoffList.OrderBy(x => x.Date).OrderByDescending(x => x.Applied).ToList();

                DistributeWriteoffData();

                dataobj.ServicingPotentialDealWriteoffList = new List<ServicingPotentialDealWriteoffDataContract>();
                dataobj.ServicingPotentialDealWriteoffList = ServicingPotentialDealWriteoffList;

                dataobj.ServicingPotentialNoteWriteoffList = new List<ServicingPotentialNoteWriteoffDataContract>();
                dataobj.ServicingPotentialNoteWriteoffList = ServicingPotentialNoteWriteoffList;
                GenerateCsvFile("End");

            }
            catch (Exception ex)
            {
                dataobj.GenerationExceptionMessage = "Auto Distribution Principal Writeoff Failed - " + System.Environment.NewLine + "" + ex.Message;
                dataobj.GenerationStackTrace = "Auto Distribution Principal Writeoff Failed : " + ex.Message + ". Stack Trace:" + ex.StackTrace;
            }
            return dataobj;
        }

        public void DistributeWriteoffData()
        {
            DeleteWriteOffDataFromNoteBeforeAutoSpread();
            GenerateCsvFile("after_delete");
            AssignPriority();
            var maxPriority = (AutoDistributeWriteoffList.Max(x => x.PriorityUsedInCaculation)).GetValueOrDefault(0);
            var minPriority = (AutoDistributeWriteoffList.Min(x => x.PriorityUsedInCaculation)).GetValueOrDefault(0);
            if (minPriority == 0)
            {
                minPriority = 1;
            }
            bool movetonextdate = false;
            decimal? totaldealamount = 0, totaldealrowamount = 0;
            foreach (var dealinfo in ServicingPotentialDealWriteoffList)
            {
                movetonextdate = false;
                if (dealinfo.Applied == false)
                {
                    totaldealamount = dealinfo.Value;
                    totaldealrowamount = dealinfo.Value;
                    for (int i = maxPriority; i >= minPriority; i--)
                    {
                        totaldealamount = totaldealrowamount;
                        List<AutoDistributeWriteoffDataContract> filterlist = AutoDistributeWriteoffList.FindAll(x => x.PriorityUsedInCaculation == i);
                        if (filterlist != null && filterlist.Count > 0)
                        {
                            decimal cPrioritybaltotal = filterlist.Sum(x => x.EstBls).GetValueOrDefault(0);
                            if (cPrioritybaltotal != 0)
                            {
                                foreach (var calcratio in filterlist)
                                {
                                    if (calcratio.EstBls != null && calcratio.EstBls != 0)
                                    {
                                        calcratio.TotalAmountDistributed = GetNoteAmountDistributed(calcratio.NoteID.ToString());
                                        calcratio.Ratio = NumericExtension.SafeDivision(calcratio.EstBls.GetValueOrDefault(0), cPrioritybaltotal);
                                    }
                                    else
                                    {
                                        calcratio.Ratio = 0;
                                    }
                                }
                                // distribute amount
                                foreach (var noteinfo in filterlist)
                                {
                                    decimal? currentamount = 0;
                                    decimal? totaldistributed = GetNoteAmountDistributed(noteinfo.NoteID.ToString());
                                    decimal? maxamount = noteinfo.EstBls;
                                    //noteinfo.NoteID
                                    decimal? totalamountremaining = maxamount - totaldistributed;
                                    if (totalamountremaining > 0)
                                    {
                                        currentamount = totaldealamount * noteinfo.Ratio;
                                        if (currentamount > totalamountremaining)
                                        {
                                            currentamount = totalamountremaining;
                                        }
                                        AddValuesToNoteList(dealinfo, currentamount, noteinfo);
                                        totaldistributed = GetTotalDealRowAmountDistributed(dealinfo.Date, dealinfo.RowNo);
                                        if (totaldistributed >= dealinfo.Value)
                                        {
                                            movetonextdate = true;
                                            break;
                                        }
                                        else
                                        {
                                            //mov to next Priority if no notes 
                                            totaldealrowamount = dealinfo.Value - totaldistributed;
                                        }
                                    }
                                }
                                if (movetonextdate == true)
                                {

                                    break;
                                }
                                //check deal amount distribuated
                            }
                        }
                    }
                    //penny adjustment for row
                    var rowtoatal = GetTotalDealRowAmountDistributed(dealinfo.Date, dealinfo.RowNo);
                    decimal amttoadjut = dealinfo.Value.GetValueOrDefault(0) - rowtoatal.GetValueOrDefault(0);
                    if (amttoadjut != 0)
                    {
                        foreach (var note in ServicingPotentialNoteWriteoffList)
                        {
                            if (note.Date == dealinfo.Date && note.RowNo == dealinfo.RowNo)
                            {
                                if (noteidWithMaxBalance.ToString() == note.NoteID)
                                {
                                    note.Value = note.Value + amttoadjut;
                                }
                            }
                        }
                    }                    

                }

            }
            //delete zero values
            DeleteZeroValuesFromNoteWriteOffData();
        }

        public void DeleteWriteOffDataFromNoteBeforeAutoSpread()
        {
            foreach (var note in ServicingPotentialNoteWriteoffList)
            {
                if (note.Applied != true)
                {
                    note.IsDeleted = 1;
                }
            }
            ServicingPotentialNoteWriteoffList.RemoveAll(x => x.IsDeleted == 1);

            foreach (var dealinfo in ServicingPotentialDealWriteoffList)
            {
                if (dealinfo.Value == 0 && dealinfo.Applied != true)
                {
                    dealinfo.IsDeleted = 1;

                    foreach (var note in ServicingPotentialNoteWriteoffList)
                    {
                        if (note.Applied != true && note.RowNo == dealinfo.RowNo)
                        {
                            note.IsDeleted = 1;
                        }
                    }
                }

            }

            ServicingPotentialDealWriteoffList.RemoveAll(x => x.IsDeleted == 1);
            ServicingPotentialNoteWriteoffList.RemoveAll(x => x.IsDeleted == 1);
        }

        public void DeleteZeroValuesFromNoteWriteOffData()
        {
            foreach (var note in ServicingPotentialNoteWriteoffList)
            {
                if (note.Applied != true && note.Value == 0)
                {
                    if (note.Value == 0)
                    {
                        note.IsDeleted = 1;
                    }
                }
            }
            ServicingPotentialNoteWriteoffList.RemoveAll(x => x.IsDeleted == 1);
        }
        public decimal? GetTotalDealRowAmountDistributed(DateTime? currentdate, int rownumber)
        {
            decimal? totalDistributed = 0;
            foreach (var note in ServicingPotentialNoteWriteoffList)
            {
                if (note.Date == currentdate && note.RowNo == rownumber && note.Applied != true)
                {
                    totalDistributed = totalDistributed + note.Value.GetValueOrDefault(0);
                }
            }
            return totalDistributed;
        }
        public void AddValuesToNoteList(ServicingPotentialDealWriteoffDataContract dealinfo, decimal? currentamount, AutoDistributeWriteoffDataContract noteinfo)
        {
            ServicingPotentialNoteWriteoffDataContract note = new ServicingPotentialNoteWriteoffDataContract();
            note.WLDealPotentialImpairmentID = dealinfo.WLDealPotentialImpairmentID;
            note.DealID = dealinfo.DealID;
            note.Date = dealinfo.Date;
            note.Value = Math.Round(currentamount.GetValueOrDefault(0), 2);
            note.AdjustmentType = dealinfo.AdjustmentType;
            note.AdjustmentTypeText = dealinfo.AdjustmentTypeText;
            note.Comment = dealinfo.Comment;
            note.RowNo = dealinfo.RowNo;
            note.Applied = dealinfo.Applied;
            note.NoteID = noteinfo.NoteID.ToString();
            note.CRENoteID = noteinfo.CRENoteID;
            note.Notename = noteinfo.NoteName;
            note.UserID = dealinfo.UserID;
            note.IsDeleted = 0;

            ServicingPotentialNoteWriteoffList.Add(note);
        }
        public decimal? GetNoteAmountDistributed(string noteid)
        {
            decimal? totalDistributed = 0;
            foreach (var note in ServicingPotentialNoteWriteoffList)
            {
                if (note.NoteID == noteid )
                {
                    totalDistributed = totalDistributed + note.Value.GetValueOrDefault(0);
                }
            }
            return totalDistributed;
        }
        public void AssignPriority()
        {
            decimal? maxesitmatebal = 0;

            foreach (var item in AutoDistributeWriteoffList)
            {
                if (item.PriorityOverride != null)
                {
                    item.PriorityUsedInCaculation = item.PriorityOverride;
                }
                else if (item.PriorityOverride == 0) 
                {
                    item.PriorityUsedInCaculation = 0;
                }
                else if (item.Priority != null && item.Priority != 0)
                {
                    item.PriorityUsedInCaculation = item.Priority;
                }
                else
                {
                    item.PriorityUsedInCaculation = 1;
                }
                if (maxesitmatebal < item.EstBls)
                {
                    maxesitmatebal = item.EstBls;
                    noteidWithMaxBalance = item.NoteID;
                }
            }
        }
        public void GenerateCsvFile(string filename)
        {
            if (createcsv == 1)
            {
                ObjToCsv.CreateCSVFile(ObjToCsv.ToDataSet(AutoDistributeWriteoffList).Tables[0], "AutoDistribute_" + filename);
                ObjToCsv.CreateCSVFile(ObjToCsv.ToDataSet(ServicingPotentialDealWriteoffList).Tables[0], "Deal_Writeoff_" + filename);
                ObjToCsv.CreateCSVFile(ObjToCsv.ToDataSet(ServicingPotentialNoteWriteoffList).Tables[0], "Note_Writeoff_" + filename);
            }
        }
    }
}
