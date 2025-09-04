using CRES.DataContract;
using CRES.Utilities;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Math;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CRES.BusinessLogic
{
    public static class ScenarioRules
    {

        public static NoteDataContract ApplyExcludedForcastedPrePaymentRule(NoteDataContract notedc)
        {
            List<FutureFundingScheduleTab> FundingSchedule = new List<FutureFundingScheduleTab>();
            if (notedc.DefaultScenarioParameters.ExcludedForcastedPrePaymentText != null)

            {
                var checkdate = DateTime.Now;
                var repayment = (from F in notedc.ListFutureFundingScheduleTab
                                 where F.Value < 0
                                 orderby F.EffectiveDate
                                 select F.Value).LastOrDefault();
                var duplicates = (from p in notedc.ListFutureFundingScheduleTab
                                  group p.EffectiveDate
                                  by p.EffectiveDate
                             ).Count();

                if (duplicates == 1)
                {
                    var repaylessthantoday = (from p in notedc.ListFutureFundingScheduleTab
                                              where p.Value < 0 && p.Date < checkdate
                                              select p.Value
                                               ).Count();
                    if (repaylessthantoday != 0)
                    { duplicates = 2; }
                }

                if (notedc.DefaultScenarioParameters.ExcludedForcastedPrePaymentText.ToLower() == "y" && repayment != null)
                    if (duplicates == 1)
                    {
                        foreach (FutureFundingScheduleTab ff in notedc.ListFutureFundingScheduleTab)
                        {
                            if (ff.Value < 0 && ff.Date > checkdate)
                            {
                                ff.Value = 0;

                            }
                        }
                    }

                if (notedc.DefaultScenarioParameters.ExcludedForcastedPrePaymentText.ToLower() == "y" && repayment != null && duplicates > 1)
                {
                    var sortFF = notedc.ListFutureFundingScheduleTab.OrderBy(f => f.EffectiveDate).ThenBy(f => f.Date).ToList();
                    var lastschedule = (from F in notedc.ListFutureFundingScheduleTab
                                        orderby F.EffectiveDate
                                        select F.EffectiveDate).LastOrDefault();
                    for (int F = 0; F < sortFF.Count(); F++)
                    {
                        if (sortFF[F].Value < 0 && sortFF[F].Date > checkdate && sortFF[F].EffectiveDate == lastschedule)
                        {
                            sortFF[F].Value = 0;
                        }
                    }
                    var removeRepay = sortFF.OrderBy(f => f.EffectiveDate).ThenBy(f => f.Date).ThenBy(f => f.Value).ToList();


                    List<FutureFundingScheduleTab> mostrecentminEffdate1 = null;

                    for (int i = 0; i < removeRepay.Count; i++)
                    {
                        var nexteffedate = (from F in removeRepay
                                            orderby F.EffectiveDate
                                            where F.EffectiveDate > removeRepay[i].EffectiveDate
                                            select F.EffectiveDate).FirstOrDefault();

                        //adding the "third schedule" for repayment 
                        //where the repayment date is greater than the effective date
                        if ((removeRepay[i].EffectiveDate == lastschedule &&
                                removeRepay[i].Date > removeRepay[i].EffectiveDate && removeRepay[i].Value < 0)
                            ||
                             (removeRepay[i].EffectiveDate < nexteffedate
                            && removeRepay[i].Date > removeRepay[i].EffectiveDate && removeRepay[i].Date != nexteffedate
                            && removeRepay[i].EffectiveDate != lastschedule && removeRepay[i].Date < nexteffedate
                            && lastschedule > removeRepay[i].Date && removeRepay[i].Value < 0
                            ))
                            if (removeRepay[i].EffectiveDate != nexteffedate)
                            {
                                {
                                    FundingSchedule.Add(new FutureFundingScheduleTab
                                    {
                                        EffectiveDate = removeRepay[i].Date,
                                        Value = removeRepay[i].Value,
                                        Date = removeRepay[i].Date,
                                        PurposeID = removeRepay[i].PurposeID,
                                        PurposeText = removeRepay[i].PurposeText,
                                        AdjustmentType = removeRepay[i].AdjustmentType,
                                        AdjustmentTypeText = removeRepay[i].AdjustmentTypeText,
                                    });



                                    if (mostrecentminEffdate1 != null)
                                    { mostrecentminEffdate1.Clear(); }

                                    //populating the collection mostrecentminEffdate1 with all the fundings repayments to be added to
                                    // the repayment schedule from previous effective date


                                    mostrecentminEffdate1 = removeRepay.FindAll(s => s.EffectiveDate == removeRepay[i].EffectiveDate);


                                    var FF_count = FundingSchedule.FindAll(x => x.EffectiveDate == removeRepay[i].Date).ToList().Count();


                                    for (int q = 0; q < mostrecentminEffdate1.Count(); q++)
                                    {
                                        if (mostrecentminEffdate1[q].Date != removeRepay[i].Date
                                            //|| removeRepay[i].Value>0
                                            )
                                            if (FF_count < 2)

                                                FundingSchedule.Add(new FutureFundingScheduleTab
                                                {
                                                    EffectiveDate = removeRepay[i].Date,
                                                    Value = mostrecentminEffdate1[q].Value,
                                                    Date = mostrecentminEffdate1[q].Date,
                                                    PurposeID = mostrecentminEffdate1[q].PurposeID,
                                                    PurposeText = mostrecentminEffdate1[q].PurposeText,
                                                    AdjustmentType = mostrecentminEffdate1[q].AdjustmentType,
                                                    AdjustmentTypeText = mostrecentminEffdate1[q].AdjustmentTypeText
                                                });
                                    }
                                }
                            }
                        var newEffDateequalCurrentEffdate = (from f in FundingSchedule
                                                             where f.EffectiveDate == removeRepay[i].Date
                                                             && f.Date > removeRepay[i].EffectiveDate
                                                             orderby f.EffectiveDate
                                                             select f.EffectiveDate

                                                           ).LastOrDefault();
                        //if (FundingSchedule.Count() > 0)

                        if (newEffDateequalCurrentEffdate == removeRepay[i].Date && removeRepay[i].Value > 0
                                && removeRepay[i].EffectiveDate < newEffDateequalCurrentEffdate)
                            FundingSchedule.Add(new FutureFundingScheduleTab
                            {
                                EffectiveDate = newEffDateequalCurrentEffdate,
                                Value = removeRepay[i].Value,
                                Date = removeRepay[i].Date,
                                PurposeID = removeRepay[i].PurposeID,
                                PurposeText = removeRepay[i].PurposeText,
                                AdjustmentType = removeRepay[i].AdjustmentType,
                                AdjustmentTypeText = removeRepay[i].AdjustmentTypeText
                            });

                        //make the values in the orignal list 0 which are greate than effective date.
                        if (removeRepay[i].Date > removeRepay[i].EffectiveDate && removeRepay[i].EffectiveDate != lastschedule
                            && removeRepay[i].Value < 0
                            )
                        {
                            removeRepay[i].Value = 0;
                            //removeRepay.RemoveAt(i);

                        }
                        for (int m = 0; m < FundingSchedule.Count(); m++)
                        {
                            if (FundingSchedule[m].Date > FundingSchedule[m].EffectiveDate && FundingSchedule[m].Value < 0)
                            {
                                FundingSchedule[m].Value = 0;
                            }
                        }
                    }
                    //for (int m = 0; m < removeRepay.Count(); m++)
                    //{
                    //    if (removeRepay[m].EffectiveDate == lastschedule && removeRepay[m].Date<checkdate && removeRepay[m].Value<0)
                    //    {
                    //        removeRepay[m].Value = 0;
                    //    }
                    //}

                    var newList = removeRepay.Concat(FundingSchedule);

                    notedc.ListFutureFundingScheduleTab.Clear();
                    notedc.ListFutureFundingScheduleTab = newList.OrderBy(f => f.EffectiveDate).ThenBy(f => f.Date).ToList();
                    //notedc.ListFutureFundingScheduleTab.Sort();

                    var Finalschedule = (from F in notedc.ListFutureFundingScheduleTab
                                         orderby F.EffectiveDate
                                         select F.EffectiveDate).LastOrDefault();
                    for (int m = 0; m < notedc.ListFutureFundingScheduleTab.Count(); m++)
                    {
                        if (Finalschedule == lastschedule && notedc.ListFutureFundingScheduleTab[m].Value < 0
                            && notedc.ListFutureFundingScheduleTab[m].Date > checkdate
                            )
                        {
                            notedc.ListFutureFundingScheduleTab[m].Value = 0;
                        }

                        if (notedc.ListFutureFundingScheduleTab[m].EffectiveDate == lastschedule
                            && notedc.ListFutureFundingScheduleTab[m].EffectiveDate < notedc.ListFutureFundingScheduleTab[m].Date
                            && notedc.ListFutureFundingScheduleTab[m].Value < 0 && Finalschedule > lastschedule

                           )

                        {
                            notedc.ListFutureFundingScheduleTab[m].Value = 0;
                        }

                        if (notedc.ListFutureFundingScheduleTab[m].Date > notedc.ListFutureFundingScheduleTab[m].EffectiveDate && notedc.ListFutureFundingScheduleTab[m].EffectiveDate != lastschedule
                       && notedc.ListFutureFundingScheduleTab[m].Value < 0
                       )
                        {
                            notedc.ListFutureFundingScheduleTab[m].Value = 0;
                        }
                    }
                }
            }

            return notedc;
        }

        public static NoteDataContract GetAccoutingCLoseDate(NoteDataContract notedc)
        {
            DateTime? maxdate = notedc.ListHistoricalAccrual.Max(x => x.PeriodDate);

            if (notedc.CalculationModeText == "CF + PV Basis (Inception)" || notedc.CalculationModeText == "Full Mode (Inception)" || notedc.CalculationModeText == "CF + GAAP Basis (Inception)")
            {
                notedc.AcctgCloseDate = DateTime.MinValue;
            }
            else
            {
                if (maxdate != null)
                {
                    if (maxdate < notedc.ClosingDate)
                    {
                        notedc.AcctgCloseDate = DateTime.MinValue;
                    }
                    else
                    {
                        notedc.AcctgCloseDate = maxdate;
                    }
                }
                else
                {
                    notedc.AcctgCloseDate = DateTime.MinValue;
                }
            }

            return notedc;
        }

        public static NoteDataContract UpdateRateSpreadSchedule(NoteDataContract notedc)
        {
            int add = 0;
            List<RateSpreadSchedule> ListSpread = new List<RateSpreadSchedule>();
            if (notedc.RateSpreadScheduleList != null)
            {
                var maxeffective = notedc.RateSpreadScheduleList.Max(x => x.EffectiveDate);
                foreach (RateSpreadSchedule rss in notedc.RateSpreadScheduleList)
                {
                    if (rss.ValueTypeText == "Spread")
                    {
                        foreach (RateSpreadSchedule inner in notedc.RateSpreadScheduleList)
                        {
                            if (rss.EffectiveDate == inner.EffectiveDate && rss.Date == inner.Date && inner.ValueTypeText == "Reference Rate")
                            {
                                if (inner.Value != null || inner.Value != 0)
                                {
                                    add = 1;
                                    RateSpreadSchedule rs1 = new RateSpreadSchedule();
                                    rs1.EffectiveDate = rss.EffectiveDate;
                                    rs1.Date = rss.Date;
                                    rs1.ValueTypeText = "Rate";
                                    rs1.IntCalcMethodText = rss.IntCalcMethodText;
                                    rs1.Value = rss.Value.GetValueOrDefault(0) + inner.Value.GetValueOrDefault(0);
                                    rss.isdeleted = true;
                                    inner.isdeleted = true;
                                    ListSpread.Add(rs1);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            if (add == 1)
            {
                notedc.RateSpreadScheduleList.RemoveAll(x => x.isdeleted == true);
                foreach (RateSpreadSchedule rp in ListSpread)
                {
                    notedc.RateSpreadScheduleList.Add(rp);
                }
            }
            return notedc;
        }
        public static NoteDataContract AssignValuesToSelectedMaturityUsingDealSetup(NoteDataContract notedc, string MaturityScenarioOverrideText)
        {
            string scenriotext = "";
            List<MaturityDateList> MaturityDateList = notedc.MaturityScenariosListFromDatabase[0].MaturityDateList;
            if (MaturityScenarioOverrideText != "")
            {
                scenriotext = MaturityScenarioOverrideText;
            }
            else
            {
                scenriotext = notedc.DefaultScenarioParameters.MaturityScenarioOverrideText;
            }
            


            DateTime todaydate = DateTime.Now.Date;
            DateTime? currentmatdate = DateTime.MinValue.Date;
            DateTime? Initialmatdate = DateTime.MinValue.Date;

            DateTime? actualpayoffdate = DateTime.MinValue;
            string MaturityType = "";
            string currentMaturityType = "";
            string DoesNotehasActualpayoff = "";
            DateTime? specialMaturity = DateTime.MinValue;
            List<DateTime?> MaturityDatesDistinct = new List<DateTime?>();

            List<MaturityScenariosDataContract> NoteMaturityDateList = new List<MaturityScenariosDataContract>();
            MaturityDateList = MaturityDateList.OrderBy(x => x.EffectiveDate).ToList();
            List<DateTime?> MaturityEffectiveDateList = MaturityDateList.Select(x => x.EffectiveDate).Distinct().ToList();


            if (notedc.MaturityScenariosListFromDatabase[0].ActualPayoffDate != null && notedc.MaturityScenariosListFromDatabase[0].ActualPayoffDate != DateTime.MinValue)
            {
                actualpayoffdate = notedc.MaturityScenariosListFromDatabase[0].ActualPayoffDate;
                DoesNotehasActualpayoff = "yes";
            }

            //Initial,Extension,Fully extended,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate,Current Maturity Date,Initial or Actual Payoff Date             
            switch (scenriotext)
            {
                case "Initial or Actual Payoff Date":
                    MaturityType = "Initial";
                    break;

                case "Expected Maturity Date":
                    MaturityType = "ExpectedMaturityDate";
                    break;

                case "Extended Maturity Date":
                    MaturityType = "Extension";
                    break;

                case "Open Prepayment Date":
                    MaturityType = "OpenPrepaymentDate";
                    break;
                case "Fully Extended Maturity Date":
                    MaturityType = "Fully extended";
                    break;
                case "Current Maturity Date":
                    MaturityType = "Current Maturity Date";
                    break;
                case "Prepay Date":
                    MaturityType = "Prepay Date";
                    break;
            }

            DateTime lastmaturitydate = DateTime.MinValue;
            foreach (var dictitem in MaturityEffectiveDateList)
            {
                foreach (var item in MaturityDateList)
                {
                    if (item.Type == MaturityType)
                    {
                        if (item.EffectiveDate == dictitem && lastmaturitydate != item.MaturityDate.Value.Date)
                        {
                            MaturityDatesDistinct.Add(item.EffectiveDate);
                            lastmaturitydate = item.MaturityDate.Value.Date;
                        }
                    }

                }

            }

            currentMaturityType = MaturityType;
            if (MaturityType == "ActualPayoffDate" || MaturityType == "ExpectedMaturityDate" || MaturityType == "OpenPrepaymentDate")
            {
                MaturityType = "Fully extended";
            }
            if (MaturityType == "Current Maturity Date")
            {
                if (DoesNotehasActualpayoff != "")
                {
                    MaturityScenariosDataContract md = new MaturityScenariosDataContract();
                    md.EffectiveDate = actualpayoffdate;
                    md.Type = "ActualPayoffDate";
                    md.SelectedMaturityDate = actualpayoffdate;
                    currentmatdate = actualpayoffdate;
                    NoteMaturityDateList.Add(md);
                }
                else
                {
                    foreach (var effectivedate in MaturityEffectiveDateList)
                    {
                        MaturityScenariosDataContract md = new MaturityScenariosDataContract();
                        md.EffectiveDate = effectivedate;

                        Initialmatdate = GetMaturityDateByEffectiveDate(MaturityDateList, "Initial", effectivedate);
                        if (Initialmatdate.Value.Date <= todaydate)
                        {
                            DateTime? extensiondate = GetMaturityDateByEffectiveDate(MaturityDateList, "Extension", effectivedate);
                            if (extensiondate < todaydate)
                            {
                                DateTime? FullyExtended = GetMaturityDateByEffectiveDate(MaturityDateList, "Fully extended", effectivedate);
                                md.Type = "Fully extended";
                                currentmatdate = FullyExtended;

                            }
                            else
                            {
                                md.Type = "Extension";
                                currentmatdate = extensiondate;
                            }
                        }
                        else
                        {
                            currentmatdate = Initialmatdate;
                            md.Type = "Initial";
                        }

                        md.SelectedMaturityDate = currentmatdate;
                        NoteMaturityDateList.Add(md);
                    }
                }
            }
            else if (MaturityType == "Prepay Date")
            {
                if (DoesNotehasActualpayoff != "")
                {
                    MaturityScenariosDataContract md = new MaturityScenariosDataContract();
                    md.EffectiveDate = actualpayoffdate;
                    md.Type = "ActualPayoffDate";
                    md.SelectedMaturityDate = actualpayoffdate;
                    currentmatdate = actualpayoffdate;
                    NoteMaturityDateList.Add(md);
                }
                else
                {
                    foreach (var effectivedate in MaturityEffectiveDateList)
                    {
                        MaturityScenariosDataContract md = new MaturityScenariosDataContract();
                        md.EffectiveDate = effectivedate;
                        md.Type = "Prepay Date";
                        md.SelectedMaturityDate = notedc.PrepayDate;
                        currentmatdate = notedc.PrepayDate;
                        NoteMaturityDateList.Add(md);
                    }
                }

            }
            else
            {
                foreach (var effectivedate in MaturityDatesDistinct)
                {
                    if (effectivedate <= actualpayoffdate || actualpayoffdate == DateTime.MinValue)
                    {
                        if (effectivedate != actualpayoffdate)
                        {
                            MaturityScenariosDataContract md = new MaturityScenariosDataContract();
                            md.EffectiveDate = effectivedate;

                            if (MaturityType == "Current Maturity Date")
                            {
                                if (notedc.SelectedMaturityDate <= todaydate)
                                {
                                    DateTime? extensiondate = GetMaturityDateByEffectiveDate(MaturityDateList, "Extension", effectivedate);

                                    if (extensiondate < todaydate)
                                    {
                                        DateTime? FullyExtended = GetMaturityDateByEffectiveDate(MaturityDateList, "Fully extended", effectivedate);
                                        if (FullyExtended < todaydate)
                                        {
                                            currentmatdate = todaydate;
                                        }
                                        else
                                        {
                                            currentmatdate = FullyExtended;
                                        }
                                    }
                                    else
                                    {
                                        currentmatdate = extensiondate;
                                    }
                                }
                                else
                                {
                                    currentmatdate = notedc.SelectedMaturityDate;
                                }
                            }
                            else
                            {
                                currentmatdate = GetMaturityDateByEffectiveDate(MaturityDateList, "Fully extended", effectivedate);
                            }

                            md.Type = MaturityType;
                            if (currentmatdate == DateTime.MinValue || currentmatdate == null)
                            {
                                currentmatdate = GetMaturityDateByEffectiveDate(MaturityDateList, "Initial", effectivedate);
                                md.Type = "Initial";
                            }

                            md.SelectedMaturityDate = currentmatdate;
                            NoteMaturityDateList.Add(md);
                        }
                    }

                }
                if (DoesNotehasActualpayoff != "")
                {
                    specialMaturity = actualpayoffdate;
                    currentMaturityType = "ActualPayoffDate";
                }
                else
                {
                    if (currentMaturityType == "ExpectedMaturityDate")
                    {
                        if (notedc.MaturityScenariosListFromDatabase[0].ExpectedMaturityDate != null || notedc.MaturityScenariosListFromDatabase[0].ExpectedMaturityDate != DateTime.MinValue)
                        {
                            specialMaturity = notedc.MaturityScenariosListFromDatabase[0].ExpectedMaturityDate;

                            DateTime last_Paydowndate = DateTime.MinValue;
                            DateTime last_fullpayoffdate = DateTime.MinValue;

                            if (notedc.ListFutureFundingScheduleTab != null)
                            {
                                var LatestSchedule = (from F in notedc.ListFutureFundingScheduleTab
                                                      orderby F.EffectiveDate
                                                      select F.EffectiveDate).LastOrDefault();

                                var LastPyDn = (from pd in notedc.ListFutureFundingScheduleTab
                                                where pd.EffectiveDate == LatestSchedule && pd.PurposeID == 631 && pd.Value != 0
                                                orderby pd.Date
                                                select pd.Date).LastOrDefault();

                                var LastFullPyOff = (from pd in notedc.ListFutureFundingScheduleTab
                                                     where pd.EffectiveDate == LatestSchedule && pd.PurposeID == 630 && pd.Value != 0
                                                     orderby pd.Date
                                                     select pd.Date).LastOrDefault();

                                if (LastPyDn != null)
                                {
                                    last_Paydowndate = Convert.ToDateTime(LastPyDn);
                                }
                                if (LastFullPyOff != null)
                                {
                                    last_fullpayoffdate = Convert.ToDateTime(LastFullPyOff);
                                }


                                if (last_Paydowndate != DateTime.MinValue)
                                {
                                    if (Convert.ToDateTime(specialMaturity).Year == Convert.ToDateTime(last_Paydowndate).Year && Convert.ToDateTime(specialMaturity).Month == Convert.ToDateTime(last_Paydowndate).Month)
                                    {
                                        specialMaturity = last_Paydowndate;
                                    }
                                }

                                if (last_fullpayoffdate != DateTime.MinValue)
                                {
                                    specialMaturity = last_fullpayoffdate;
                                }


                            }


                            #region VB - 01072025 --COmmented
                            /////VB - 01072025============
                            //if (specialMaturity == DateExtensions.LastDateOfMonth(Convert.ToDateTime(specialMaturity)))
                            //{
                            //    int day_LastPyDn = 10;
                            //    DateTime fullpayoffdate = DateTime.MinValue;

                            //    if (notedc.ListFutureFundingScheduleTab != null)
                            //    {
                            //        var LatestSchedule = (from F in notedc.ListFutureFundingScheduleTab
                            //                              orderby F.EffectiveDate
                            //                              select F.EffectiveDate).LastOrDefault();

                            //        var LastPaydownDate = (from pd in notedc.ListFutureFundingScheduleTab
                            //                               where pd.EffectiveDate == LatestSchedule && pd.PurposeID == 631 && pd.Value != 0
                            //                               orderby pd.Date
                            //                               select pd.Date).LastOrDefault();

                            //        if (LastPaydownDate != null)
                            //        {
                            //            day_LastPyDn = Convert.ToDateTime(LastPaydownDate).Day;
                            //        }

                            //    }

                            //    specialMaturity = DateExtensions.CreateNewDate(Convert.ToDateTime(specialMaturity).Year, Convert.ToDateTime(specialMaturity).Month, day_LastPyDn);
                            //    //specialMaturity = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(specialMaturity), Convert.ToInt16(-1), "US", notedc.ListHoliday).Date;
                            //}
                            //////For Full Pay Off Date set (Expected Maturity Date = Full Pay Off Date)                            
                            //if (notedc.ListFutureFundingScheduleTab != null)
                            //{
                            //    var LatestSchedule = (from F in notedc.ListFutureFundingScheduleTab
                            //                          orderby F.EffectiveDate
                            //                          select F.EffectiveDate).LastOrDefault();


                            //    var FullPyDate = (from pd in notedc.ListFutureFundingScheduleTab
                            //                      where pd.EffectiveDate == LatestSchedule && pd.PurposeID == 630 && pd.Value != 0
                            //                      orderby pd.Date
                            //                      select pd.Date).LastOrDefault();

                            //    if (FullPyDate != null)
                            //    {
                            //        specialMaturity = Convert.ToDateTime(FullPyDate);
                            //    }

                            //}
                            ////=========================
                            #endregion


                        }
                    }
                    if (currentMaturityType == "OpenPrepaymentDate")
                    {
                        if (notedc.MaturityScenariosListFromDatabase[0].OpenPrepaymentDate != null || notedc.MaturityScenariosListFromDatabase[0].OpenPrepaymentDate != DateTime.MinValue)
                        {
                            specialMaturity = notedc.MaturityScenariosListFromDatabase[0].OpenPrepaymentDate;
                        }
                    }
                }

                if (specialMaturity != DateTime.MinValue)
                {
                    MaturityScenariosDataContract md = new MaturityScenariosDataContract();
                    md.EffectiveDate = specialMaturity.Value.Date;
                    md.Type = currentMaturityType;
                    md.SelectedMaturityDate = specialMaturity.Value.Date; ;
                    NoteMaturityDateList.Add(md);
                }
            }


            //if (currentMaturityType == "ExpectedMaturityDate")
            //{
            //    if (currentmatdate == DateExtensions.LastDateOfMonth(Convert.ToDateTime(currentmatdate)))
            //    {
            //        currentmatdate = DateExtensions.CreateNewDate(Convert.ToDateTime(currentmatdate).Year, Convert.ToDateTime(currentmatdate).Month, 10);
            //        currentmatdate = DateExtensions.GetWorkingDayUsingOffset(Convert.ToDateTime(currentmatdate), Convert.ToInt16(-1), "US", notedc.ListHoliday).Date;
            //    }
            //}


            notedc.SelectedMaturityDate = currentmatdate;


            if (notedc.DefaultScenarioParameters != null)
            {
                if (notedc.DefaultScenarioParameters.UseMaturityAdjustmentMonthsText == "Y")
                {
                    int? MaturityAdjustment = 0;
                    if (notedc.MaturityAdjMonthsOverride == null || notedc.MaturityAdjMonthsOverride == 0)
                    {
                        //use from scenrio when deal level is not provided
                        MaturityAdjustment = notedc.DefaultScenarioParameters.MaturityAdjustment;
                    }
                    else
                    {
                        MaturityAdjustment = notedc.MaturityAdjMonthsOverride;
                    }

                    foreach (var items in NoteMaturityDateList)
                    {
                        DateTime tempdate = Convert.ToDateTime(items.SelectedMaturityDate);
                        currentmatdate = tempdate.AddMonths(Convert.ToInt16(MaturityAdjustment));
                        items.SelectedMaturityDate = currentmatdate;
                    }
                }
            }
            NoteMaturityDateList = NoteMaturityDateList.OrderBy(x => x.EffectiveDate).ToList();
            notedc.MaturityScenariosList = new List<MaturityScenariosDataContract>();
            notedc.MaturityScenariosList = NoteMaturityDateList;
            return notedc;
        }
        public static DateTime? GetMaturityDateByEffectiveDate(List<MaturityDateList> MaturityDateList, string type, DateTime? EffectiveDate)
        {
            DateTime? extensiondate = DateTime.MinValue;
            foreach (var item in MaturityDateList)
            {
                if (item.EffectiveDate == EffectiveDate)
                {
                    if (item.Type == type)
                    {
                        if (item.Type == "Extension" && item.Approved == "Y")
                        {
                            if (item.MaturityDate > extensiondate)
                            {
                                extensiondate = item.MaturityDate;
                            }
                        }
                        else if (item.Type != "Extension")
                        {
                            // if (item.Type == type)
                            {
                                extensiondate = item.MaturityDate;
                            }
                        }
                    }
                }
            }
            return extensiondate;
        }
        public static NoteDataContract AssignIndexRates(NoteDataContract notedc)
        {
            //notedc.ListLiborScheduleTab = notedc.ListLiborScheduleTabFromDB;
            List<LiborScheduleTab> IndexList = new List<LiborScheduleTab>();
            List<RateSpreadSchedule> listdate = new List<RateSpreadSchedule>();
            int listindex = 0;
            DateTime? maxDate = DateTime.MinValue;
            DateTime? SelectedMaturityDate = DateTime.MinValue;

            DateTime? libormindate = notedc.ListLiborScheduleTab.Min(x => x.Date);
            var latesteffectivedate = notedc.RateSpreadScheduleList.Max(x => x.EffectiveDate);

            List<MaturityDateList> MaturityDateList = notedc.MaturityScenariosListFromDatabase[0].MaturityDateList;
            foreach (var maturity in MaturityDateList)
            {
                if (maxDate == DateTime.MinValue)
                {
                    maxDate = maturity.EffectiveDate;
                }
                else if (maturity.EffectiveDate > maxDate)
                {
                    maxDate = maturity.EffectiveDate;
                }
            }
            foreach (var maturity in MaturityDateList)
            {
                if (maturity.Type == "Fully extended" && maxDate == maturity.EffectiveDate)
                {
                    SelectedMaturityDate = maturity.MaturityDate;
                }
            }
            foreach (RateSpreadSchedule rate in notedc.RateSpreadScheduleList)
            {
                if (rate.ValueTypeText == "Index Name" && rate.EffectiveDate.Value.Date == latesteffectivedate.Value.Date)
                {
                    RateSpreadSchedule rs = new RateSpreadSchedule();
                    if (listdate.Count > 0)
                    {
                        listdate[listindex - 1].EndDate = rate.Date.Value.AddDays(-1);
                    }
                    if (rate.Date.Value.Date == notedc.ClosingDate.Value.Date)
                    {
                        rs.StartDate = libormindate;
                    }
                    else
                    {
                        rs.StartDate = rate.Date;
                    }

                    rs.IndexNameText = rate.IndexNameText;
                    listdate.Add(rs);
                    listindex = listindex + 1;
                }
            }
            foreach (var item in listdate)
            {
                if (item.EndDate == null || item.EndDate == DateTime.MinValue)
                {
                    item.EndDate = SelectedMaturityDate;
                }
                foreach (var indexitems in notedc.ListLiborScheduleTab)
                {
                    if (indexitems.Date >= item.StartDate && indexitems.Date <= item.EndDate && indexitems.IndexType == item.IndexNameText)
                    {
                        IndexList.Add(indexitems);
                    }
                    else if (indexitems.Date > item.EndDate && indexitems.IndexType == item.IndexNameText)
                    {
                        break;
                    }
                }
            }

            notedc.ListLiborScheduleTab = null;
            notedc.ListLiborScheduleTab = IndexList;
            return notedc;
        }


        public static IndexDataContract CreateIndexDataContract(List<LiborScheduleTab> ListLiborScheduleTab)
        {
            List<IndexScheduleDataContract> ListLibor = new List<IndexScheduleDataContract>();
            List<IndexScheduleDataContract> ListSofr = new List<IndexScheduleDataContract>();
            IndexDataContract index = new IndexDataContract();

            foreach (var item in ListLiborScheduleTab)
            {
                if (item.IndexType.ToLower().Contains("sofr"))
                {
                    IndexScheduleDataContract sofr = new IndexScheduleDataContract();
                    sofr.EffectiveDate = item.EffectiveDate;
                    sofr.Date = item.Date;
                    sofr.Value = item.Value;
                    sofr.NoteID = item.NoteID;
                    sofr.IndexType = item.IndexType;
                    ListSofr.Add(sofr);


                }
                else
                {
                    IndexScheduleDataContract libor = new IndexScheduleDataContract();
                    libor.EffectiveDate = item.EffectiveDate;
                    libor.Date = item.Date;
                    libor.Value = item.Value;
                    libor.NoteID = item.NoteID;
                    libor.IndexType = item.IndexType;
                    ListLibor.Add(libor);
                }
            }

            index.Libor = ListLibor;
            index.SOFR = ListSofr;
            return index;

        }


        public static NoteDataContract AddEndDateToPikSchedule(NoteDataContract _noteCalculatorDC)
        {
            var currentmat = GetCurrentMaturityBasedOnStartDate(_noteCalculatorDC);
            foreach (var pik in _noteCalculatorDC.NotePIKScheduleList)
            {
                if (pik.EndDate == null || pik.EndDate == DateTime.MinValue)
                {
                    if (pik.StartDate != null)
                    {
                        pik.EndDate = currentmat.Value.AddDays(-1);
                    }
                }
            }

            return _noteCalculatorDC;
        }

        public static DateTime? GetCurrentMaturityBasedOnStartDate(NoteDataContract _noteCalculatorDC)
        {
            DateTime? currentmat = DateTime.MinValue;

            foreach (var MaturityDate in _noteCalculatorDC.MaturityScenariosList)
            {
                if (MaturityDate.Type == "Fully extended")
                {
                    if (currentmat.Value.Date == DateTime.MinValue)
                    {
                        currentmat = MaturityDate.SelectedMaturityDate;
                    }
                    else if (currentmat.Value.Date < MaturityDate.SelectedMaturityDate)
                    {
                        currentmat = MaturityDate.SelectedMaturityDate;
                    }
                }
            }

            return currentmat;
        }
    }
}