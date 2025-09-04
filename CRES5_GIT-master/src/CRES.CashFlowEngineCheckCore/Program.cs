using CRES.DataContract;
using CRES.NoteCalculator;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Xml.Linq;
using System.Linq;
using System;
using CRES.BusinessLogic;
using System.Net.Http;
using System.Net;
using Newtonsoft.Json.Linq;
using System.Dynamic;
using System.Text;
using System.Collections.Specialized;
using static CRES.DataContract.V1CalcDataContract;
using CRES.Utilities;
using Microsoft.Extensions.FileSystemGlobbing.Internal.PathSegments;
using System.Data;
using Microsoft.Data.Analysis;
using System.Text.RegularExpressions;
using CRES.DataContract.Liability;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;
using System.Runtime.Intrinsics.X86;

namespace CRES.CashFlowEngineCheckCore
{
    internal class Program
    {
        public static List<RateSpreadSchedule> NoteRateSpreadScheduleList = new List<RateSpreadSchedule>();
        public static List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepayAndAdditionalFeeScheduleDataContractlist = new List<PrepayAndAdditionalFeeScheduleDataContract>();
        public static List<MaturityScenariosDataContract> MaturityScenariosDataContractList = new List<MaturityScenariosDataContract>();

        private static void Main(string[] args)
        {
            //string filename = "creslogfiles" + "/";
            //string ss = ":creslogfiles/FF_0001_QA_07_04_2022_08_27_08.json,creslogfiles/FF_0001_QA_07_04_2022_08_28_27.json,creslogfiles/FF_0001_QA_07_04_2022_09_53_59.json";
            //ss = ss.Replace(filename, "");
            //var date = DateTime.MinValue;
            // ReadException();
            //getcommitmentdata();
            //GetjsonObject();

            //Createjson();
            // CheckBackShopProcess();
            //ReadtextFile();
            //GetNextQuarterEndDate();
            string noteid = "";
            //string notes = args.Length > 0 ? args[0] : "4399";
            //foreach (string noteid in notes.Split(",")) ;
            //RunNoteCalculator(noteid);
            // PrincipalWriteoff();
            //GenerateLiabilityCashflow();
            //GeneratePDFFile();
            RunPayRule();
            //CheCkXirr();
            //CreateDataTable();
            //PocAutoDistributeWriteOff();
            // CaculateWightedAvg();

            Calcfees("Y", "N");
        }

        public static void TestCommitmentData(NoteDataContract notedc)
        {
            CommitmentEquityHelperLogic ce = new CommitmentEquityHelperLogic();
            // List<NoteCommitmentEquityDataContract> calcNoteCommitmentdata =  ce.calcNoteCommitment(notedc);


        }
        //
        public static void ReadtextFile()
        {
            PrincipalWriteoffHelper pw = new PrincipalWriteoffHelper();
            string datafromfile = File.ReadAllText(@"C:\temp\griddata.txt");
            string stringBeforeChar = "";
            List<string> HeadersList = new List<string>();
            List<string> bindingList = new List<string>();

            DataTable dt = new DataTable();
            dt.Columns.Add("header");
            dt.Columns.Add("binding");



            var headerlist = datafromfile.Split("[header]=\"'");
            foreach (var name in headerlist)
            {
                stringBeforeChar = "";
                if (name.IndexOf("'\" [binding]") != -1)
                {
                    stringBeforeChar = name.Substring(0, name.IndexOf("'\" [binding]"));
                    HeadersList.Add(stringBeforeChar);
                }
            }

            var bindinglist = datafromfile.Split(" [binding]=\"'");
            int index = 0;
            foreach (var name in bindinglist)
            {
                stringBeforeChar = "";
                if (index > 0)
                {
                    if (name.IndexOf("'\"") != -1)
                    {
                        stringBeforeChar = name.Substring(0, name.IndexOf("'\""));
                        bindingList.Add(stringBeforeChar);
                    }
                }
                index = index + 1;
            }
            index = 0;
            foreach (var item in HeadersList)
            {
                DataRow data = dt.NewRow();
                data["header"] = HeadersList[index];
                data["binding"] = bindingList[index];
                dt.Rows.Add(data);
                index = index + 1;
            }

            CreateCSVFile(dt, "headerlist");
        }
        public static void PrincipalWriteoff()
        {
            PrincipalWriteoffHelper pw = new PrincipalWriteoffHelper();

            string json = File.ReadAllText(@"C:\temp\writeoffdistribute.json");
            PrincipalWriteoffDataContract Writeoff = JsonConvert.DeserializeObject<PrincipalWriteoffDataContract>(json);
            Writeoff = pw.StartCalculation(Writeoff);


        }
        public static void RunPayRule()
        {
            PayruleNoteFutureFundingHelper pm = new PayruleNoteFutureFundingHelper();

            string json = File.ReadAllText(@"C:\temp\FF_22-3554_Acore_09_01_2025_05_53_53.json");

            DealDataContract deal = JsonConvert.DeserializeObject<DealDataContract>(json);

            deal = pm.StartCalculation(deal);

            // var json = new JavaScriptSerializer().Serialize(dc);
        }

        public static void getcommitmentdata()
        {
            CommitmentEquityHelperLogic ce = new CommitmentEquityHelperLogic();
            string json = File.ReadAllText(@"C:\temp\Note_10509_Calc.json");

            NoteDataContract note = JsonConvert.DeserializeObject<NoteDataContract>(json);
            //   ce.calcNoteCommitment(note);
        }

        public static void RunNoteCalculator(string noteid)
        {
            string Resultjson = "";
            CalculationMaster cm = new CalculationMaster();


            string json = File.ReadAllText(@"C:\Temp\Note_23058_Calc_Default.json");
            NoteDataContract note = JsonConvert.DeserializeObject<NoteDataContract>(json);


            //note.ListFutureFundingScheduleTab = note.ListFutureFundingScheduleTabFromDB;
            //ScenarioRules.ApplyExcludedForcastedPrePaymentRule(note);
            //note = ScenarioRules.AssignValuesToSelectedMaturityUsingDealSetup(note);
            //AddEndDateToPikSchedule(note);
            NoteDataContract ndc = cm.StartCalculation(note);
            //note.ListCashflowTransactionEntry = ndc.ListCashflowTransactionEntry;
            //CreateIndexjson(note);
            //TestCommitmentData(note);
            //checkholidaydate(note.ListHoliday);
            Resultjson = JsonConvert.SerializeObject(note);
            //_noteCalculatorDC.NotePIKScheduleList
            //MaturityScenariosListFromDatabase
        }

        public static void AddEndDateToPikSchedule(NoteDataContract _noteCalculatorDC)
        {
            var currentmat = GetCurrentMaturityBasedOnStartDate(_noteCalculatorDC);
            foreach (var pik in _noteCalculatorDC.NotePIKScheduleList)
            {
                if (pik.EndDate == null || pik.EndDate == DateTime.MinValue)
                {
                    //pik.EndDate = 
                    if (pik.StartDate != null)
                    {
                        pik.EndDate = currentmat.Value.AddDays(-1);
                    }
                }
            }
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
        public static void GenerateLiabilityCashflow()
        {
            string json = File.ReadAllText(@"C:\temp\AOC2.json");

            LiabilityCFInput lcfInput;
            try
            {
                lcfInput = JsonConvert.DeserializeObject<LiabilityCFInput>(json);
                LiabilityCashflowManager lcm = new LiabilityCashflowManager();
                LiabilityCFOutput cf = lcm.GenerateLiabilityCashflow(json);
                // Console.WriteLine(cf.LiabilityNoteTransactions.Count);
                //Console.WriteLine(cf.LiabilityLineTransactions.Count);
                CreateCSVFile(ToDataSet(cf.LiabilityNoteTransactions).Tables[0], "LiabilityNoteTransactions");
                CreateCSVFile(ToDataSet(cf.LiabilityLineTransactions).Tables[0], "LiabilityLineTransactions");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.Read();
            }
        }
        public static void GetjsonObject()
        {
            dynamic obj = new JObject();
            var records = new JArray();
            obj.GeneratedBy = "User Entered";
            obj.CommentsShort = "Lorem ispsum....";
            obj.FundingLBLock = false;
            obj.NoteFundingReasonCD_F = "CON";
            obj.ParentID = 1563;
            obj.Noteid_F = 1563;
            obj.Applied = true;
            obj.FundingDate = "2022-10-18T00:00:00";
            obj.FundingAmount = 10000.0;
            obj.FundingPurposeCD_F = "CAPEXPEN";
            obj.FundingExpense = 1111.0;
            obj.Comments = "Lorem ispsum....";
            obj.WireConfirm = false;
            obj.AuditUserName = "aaguilar";
            obj.Status = "Projected";

            records.Add(obj);

            obj = new JObject();
            obj.GeneratedBy = "User Entered";
            obj.CommentsShort = "Lorem ispsum....";
            obj.FundingLBLock = false;
            obj.NoteFundingReasonCD_F = "CON";
            obj.ParentID = 1563;
            obj.Noteid_F = 1563;
            obj.Applied = true;
            obj.FundingDate = "2022-11-18T00:00:00";
            obj.FundingAmount = 10000.0;
            obj.FundingPurposeCD_F = "CAPEXPEN";
            obj.FundingExpense = 1111.0;
            obj.Comments = "Lorem ispsum....";
            obj.WireConfirm = false;
            obj.AuditUserName = "aaguilar";
            obj.Status = "Projected";

            records.Add(obj);

            var objectd = new { NoteFundings = records };


            var jsonstring = JsonConvert.SerializeObject(objectd);
        }

        public static void Calcfees(string PortfolioLoan, string AssigningLoanToTakeoutLender)
        {
            //PortfolioLoan =al6
            ////AssigningLoanToTakeoutLender =al7
            decimal legalfee = 0;

            if (AssigningLoanToTakeoutLender == "N" && PortfolioLoan == "N")
            {
                legalfee = 3500m;
            }
            else if (AssigningLoanToTakeoutLender == "Y" && PortfolioLoan == "Y")
            {
                legalfee = 7500m;
            }
            else
            {
                legalfee = 5500m;
            }
        }
        public static void Createjson()
        {

            List<BackShopExportDataContract> abc = new List<BackShopExportDataContract>();

            BackShopExportDataContract bse = new BackShopExportDataContract();
            List<BackShopNoteFundingsDataContract> list = new List<BackShopNoteFundingsDataContract>();
            BackShopNoteFundingsDataContract bsn = new BackShopNoteFundingsDataContract();
            bsn.FundingId = null;
            bsn.Noteid_F = "4203";
            bsn.Applied = true;
            bsn.FundingDate = DateTime.Now;
            bsn.FundingAmount = 1111;
            bsn.FundingPurposeCD_F = "CAPEXPEN";
            bsn.FundingExpense = null;
            bsn.Comments = "Test123";
            bsn.NoteFundingReasonCD_F = "Test123";
            bsn.GeneratedBy = "Test123";
            bsn.Status = "Projected";
            bsn.AuditUserName = "rsahu";
            bsn.WireConfirm = true;
            list.Add(bsn);

            bsn.FundingId = null;
            bsn.Noteid_F = "4203";
            bsn.Applied = true;
            bsn.FundingDate = DateTime.Now;
            bsn.FundingAmount = 1111;
            bsn.FundingPurposeCD_F = "CAPEXPEN";
            bsn.FundingExpense = null;
            bsn.Comments = "Test123";
            bsn.NoteFundingReasonCD_F = "Test123";
            bsn.GeneratedBy = "Test123";
            bsn.Status = "Projected";
            bsn.AuditUserName = "rsahu";
            bsn.WireConfirm = true;
            list.Add(bsn);


            bse.NoteId = "4203";
            bse.NoteFundings = list;

            abc.Add(bse);
            abc.Add(bse);

            var objectd = new { Notes = abc };

            var aa = JsonConvert.SerializeObject(objectd);
        }

        //public static IndexDataContract CreateIndexjson(NoteDataContract dc)
        //{
        //    List<IndexScheduleDataContract> ListLibor = new List<IndexScheduleDataContract>();
        //    List<IndexScheduleDataContract> ListSofr = new List<IndexScheduleDataContract>();
        //    IndexDataContract index = new IndexDataContract();

        //    foreach (var item in dc.ListLiborScheduleTabFromDB)
        //    {
        //        if (item.IndexType.ToLower().Contains("sofr"))
        //        {
        //            IndexScheduleDataContract sofr = new IndexScheduleDataContract();
        //            sofr.EffectiveDate = item.EffectiveDate;
        //            sofr.Date = item.Date;
        //            sofr.Value = item.Value;
        //            sofr.NoteID = item.NoteID;
        //            sofr.IndexType = item.IndexType;
        //            ListSofr.Add(sofr);


        //        }
        //        else
        //        {
        //            IndexScheduleDataContract libor = new IndexScheduleDataContract();
        //            libor.EffectiveDate = item.EffectiveDate;
        //            libor.Date = item.Date;
        //            libor.Value = item.Value;
        //            libor.NoteID = item.NoteID;
        //            libor.IndexType = item.IndexType;
        //            ListLibor.Add(libor);
        //        }
        //    }

        //    index.Libor = ListLibor;
        //    index.SOFR = ListSofr;
        //    return index;

        //}

        public static void checkholidaydate(List<HolidayListDataContract> ListHoliday)
        {

            List<DatesDataContract> dateslist = new List<DatesDataContract>();
            DateTime calcDate = Convert.ToDateTime("06/09/2019");
            DateTime calcDate1 = Convert.ToDateTime("06/06/2019");
            //DateTime dt1 = Convert.ToDateTime("09/10/2021");
            //DateTime dt2 = Convert.ToDateTime("07/04/2022");

            var date1 = GetWorkingDayUsingOffset(calcDate, -1, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate1, -2, "US", ListHoliday);

            date1 = GetWorkingDayUsingOffset(calcDate, -3, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, -4, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, -5, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, -6, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, -7, "US", ListHoliday);

            date1 = GetWorkingDayUsingOffset(calcDate, 1, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, 2, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, 3, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, 4, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, 5, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, 6, "US", ListHoliday);
            date1 = GetWorkingDayUsingOffset(calcDate, 7, "US", ListHoliday);

            date1 = GetWorkingDayUsingOffset(calcDate, 0, "US", ListHoliday);
            //date1 = GetWorkingDayUsingOffset(dt2, -1, "US", ListHoliday, 0);
            //date1 = GetWorkingDayUsingOffset(end, -1, "US", ListHoliday,-2);
            //while (calcDate <= end)
            //{
            //    DatesDataContract ddc = new DatesDataContract();


            //    var oldcode = DateExtensions.GetnextWorkingDays(Convert.ToDateTime(calcDate.AddDays(1)), Convert.ToInt16(-1), "US", ListHoliday).Date;
            //    var newcode = GetnextWorkingDays(Convert.ToDateTime(calcDate), Convert.ToInt16(-1), "US", ListHoliday).Date;


            //    ddc.OriginalDate = calcDate;
            //    ddc.NewCodeDate = newcode;
            //    ddc.OldoCodeDate = oldcode;
            //    dateslist.Add(ddc);

            //    calcDate = calcDate.AddDays(1);

            //}
            CreateCSVFile(ToDataSet(dateslist).Tables[0], "HolidateDateList");

        }
        public static void CheCkXirr()
        {
            DataTable dt = CreateDataTable();
            List<decimal> values = new List<decimal>();
            List<DateTime> datelist = new List<DateTime>();
            foreach (DataRow dr in dt.Rows)
            {
                decimal val = new decimal();
                DateTime dte = new DateTime();

                dte = Convert.ToDateTime(dr["Date"]);
                val = Convert.ToDecimal(dr["Value"]);
                values.Add(val);
                datelist.Add(dte);
            }
            double xirr = Financial.cXIRR(values, datelist);




        }
        public static DataTable CreateDataTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ReturnName");
            dt.Columns.Add("XIRRConfigID");
            dt.Columns.Add("Vehicle");
            dt.Columns.Add("Y_Axis");
            dt.Columns.Add("CA");
            dt.Columns.Add("NY");

            DataRow rmport = dt.NewRow();
            rmport["ReturnName"] = "Do_Not_Change_Portfolio";
            rmport["XIRRConfigID"] = 9;
            rmport["Y_Axis"] = "Delphi I";
            rmport["Vehicle"] = "Realized";
            rmport["CA"] = 0.070631003;
            rmport["NY"] = 0.066184943073927;
            dt.Rows.Add(rmport);


            DataRow r1 = dt.NewRow();
            r1["ReturnName"] = "Do_Not_Change_Portfolio";
            r1["XIRRConfigID"] = 9;
            r1["Y_Axis"] = "Delphi I";
            r1["Vehicle"] = "Unrealized";
            r1["CA"] = 0.070631003;
            r1["NY"] = 0.066184943073927;
            dt.Rows.Add(r1);



            DataRow r2 = dt.NewRow();
            r2["ReturnName"] = "Do_Not_Change_Portfolio";
            r2["XIRRConfigID"] = 9;
            r2["Y_Axis"] = "Delphi II";
            r2["Vehicle"] = "Unrealized";
            r2["CA"] = 0.070631003;
            r2["NY"] = 0.066184943073927;
            dt.Rows.Add(r2);

            DataRow r3 = dt.NewRow();
            r3["ReturnName"] = "Do_Not_Change_Portfolio";
            r3["XIRRConfigID"] = 9;
            r3["Y_Axis"] = "Delphi II";
            r3["Vehicle"] = "Realized";
            r3["CA"] = 0.070631003;
            r3["NY"] = 0.066184943073927;
            dt.Rows.Add(r3);

            return dt;
        }

        public static DateTime GetWorkingDayUsingOffset(DateTime date, int offset, string HolidayCalendarType, List<HolidayListDataContract> ListHoliday = null)
        {
            int loopLimitVariable = 0;
            int adjustmentday = 0;
            DateTime nextWorkingDay = date;
            if (offset > 0)
            {
                loopLimitVariable = offset * -1;
                adjustmentday = 1;
            }
            else if (offset == 0)
            {
                adjustmentday = 0;
                loopLimitVariable = 0;
            }
            else
            {
                loopLimitVariable = offset;
                adjustmentday = -1;
            }

            nextWorkingDay = GetnextWorkingDays(date, adjustmentday, HolidayCalendarType, ListHoliday);
            if (nextWorkingDay.Date != date.Date)
            {
                for (int i = 0; i < (-loopLimitVariable - 1); i++)
                {
                    nextWorkingDay = nextWorkingDay.AddDays(adjustmentday);
                    nextWorkingDay = GetnextWorkingDays(nextWorkingDay, adjustmentday, HolidayCalendarType, ListHoliday);
                }
            }
            return nextWorkingDay;
        }

        public static DateTime GetnextWorkingDays(DateTime date, int days, string HolidayCalendarType = null, List<HolidayListDataContract> ListHoliday = null)
        {
            if (days == 0) return date;
            if (days > 0)
            {
                if (date.DayOfWeek == DayOfWeek.Saturday)
                    date = date.AddDays(2);
                if (date.DayOfWeek == DayOfWeek.Sunday)
                    date = date.AddDays(1);
                int i = 1;
                while (i <= days)
                {
                    if (date.DayOfWeek == DayOfWeek.Saturday)
                        date = date.AddDays(2);
                    if (date.DayOfWeek == DayOfWeek.Sunday)
                        date = date.AddDays(1);

                    if (HolidayCalendarType != null)
                    {
                        if (CheckForHoliday(date, HolidayCalendarType, ListHoliday))
                        {
                            date = date.AddDays(1);
                            i = i - 1;
                        }
                    }
                    i = i + 1;
                }

                return date;
            }
            else
            {
                if (date.DayOfWeek == DayOfWeek.Sunday)
                    date = date.AddDays(-2);
                if (date.DayOfWeek == DayOfWeek.Saturday)
                    date = date.AddDays(-1);
                int i = 1;
                while (i <= -days)
                {
                    if (date.DayOfWeek == DayOfWeek.Sunday)
                        date = date.AddDays(-2);
                    if (date.DayOfWeek == DayOfWeek.Saturday)
                        date = date.AddDays(-1);

                    if (HolidayCalendarType != null)
                    {
                        if (CheckForHoliday(date, HolidayCalendarType, ListHoliday))
                        {
                            date = date.AddDays(-1);
                            i = i - 1;
                        }
                    }

                    i = i + 1;
                }
                return date;
            }
        }

        public static bool CheckForHoliday(DateTime refDate, string DateType, List<HolidayListDataContract> ListHoliday = null)
        {
            bool holidayCheck = false;

            foreach (var holiday in ListHoliday)
            {
                if (holiday.HolidayType == DateType && holiday.HolidayDate == refDate)
                {
                    holidayCheck = true;
                    break;
                }
            }
            return holidayCheck;
        }

        public static void CreateCSVFile(System.Data.DataTable dt, string csvname)
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

        public static DataTable? ManuallyConvertJsonToDataTable(string sampleJson)
        {
            DataTable? dataTable = new DataTable();
            if (string.IsNullOrWhiteSpace(sampleJson))
            {
                return dataTable;
            }
            var cleanedJson = Regex.Replace(sampleJson, "\\\\| |\n|\r|\t|\\[|\\]|\"", "");
            var items = Regex.Split(cleanedJson, "},{").AsSpan();
            for (int i = 0; i < items.Length; i++)
            {
                items[i] = items[i].Replace("{", "").Replace("}", "");
            }
            var columns = Regex.Split(items[0], ",").AsSpan();
            foreach (string column in columns)
            {
                var parts = Regex.Split(column, ":").AsSpan();
                dataTable.Columns.Add(parts[0].Trim());
            }
            for (int i = 0; i < items.Length; i++)
            {
                var row = dataTable.NewRow();
                var values = Regex.Split(items[i], ",").AsSpan();
                for (int j = 0; j < values.Length; j++)
                {
                    var parts = Regex.Split(values[j], ":").AsSpan();
                    if (int.TryParse(parts[1].Trim(), out int temp))
                        row[j] = temp;
                    else
                        row[j] = parts[1].Trim();
                }
                dataTable.Rows.Add(row);
            }
            return dataTable;
        }
        //public static void PocAutoDistributeWriteOff()
        //{
        //    string json = File.ReadAllText(@"C:\Temp\sample.json");
        //    PrincipalWriteoffDataContract dc = JsonConvert.DeserializeObject<PrincipalWriteoffDataContract>(json);

        //    List<AutoDistributeWriteoffDataContract> dist = dc.AutoDistributeWriteoffList;
        //    List<ServicingPotentialDealWriteoffDataContract> deallist = dc.ServicingPotentialDealWriteoffList;

        //    Console.Write("Date\t\tAmount\t");
        //    foreach (var note in dist.OrderByDescending(n => n.Priority))
        //    {
        //        Console.Write($"\t{note.NoteName}\t");
        //    }
        //    Console.WriteLine();

        //    foreach (var deal in deallist)
        //    {
        //        decimal totalAmountToDistribute = deal.Value ?? 0;

        //        if (totalAmountToDistribute > 0)
        //        {
        //            decimal totalEstBls = dist.Sum(n => n.EstBls ?? 0);

        //            bool samePriority = dist.Select(n => n.Priority).Distinct().Count() == 1;

        //            if (samePriority)
        //            {
        //                foreach (var note in dist)
        //                {
        //                    if (note.EstBls.HasValue)
        //                    {
        //                        decimal ratio = note.EstBls.Value / totalEstBls;
        //                        note.TotalAmountDistributed = totalAmountToDistribute * ratio;
        //                    }
        //                    else
        //                    {
        //                        note.TotalAmountDistributed = 0;
        //                    }
        //                }
        //            }
        //            else
        //            {
        //                foreach (var note in dist.OrderByDescending(n => n.Priority))
        //                {
        //                    if (note.EstBls.HasValue)
        //                    {
        //                        decimal estBls = note.EstBls.Value;
        //                        if (totalAmountToDistribute > 0)
        //                        {
        //                            if (totalAmountToDistribute >= estBls)
        //                            {
        //                                note.TotalAmountDistributed = estBls;
        //                                totalAmountToDistribute -= estBls;
        //                                note.EstBls = 0;
        //                            }
        //                            else
        //                            {
        //                                note.TotalAmountDistributed = totalAmountToDistribute;
        //                                note.EstBls -= totalAmountToDistribute;
        //                                totalAmountToDistribute = 0;
        //                            }
        //                        }
        //                        else
        //                        {
        //                            note.TotalAmountDistributed = 0;
        //                        }
        //                    }
        //                    else
        //                    {
        //                        note.TotalAmountDistributed = 0;
        //                    }
        //                }
        //            }

        //            Console.Write($"{deal.Date:yyyy-MM-dd}\t{deal.Value:F2}\t");
        //            foreach (var note in dist.OrderByDescending(n => n.Priority))
        //            {
        //                Console.Write($"\t{note.TotalAmountDistributed:F2}\t");
        //            }
        //            Console.WriteLine();
        //        }
        //        else
        //        {
        //            Console.WriteLine($"{deal.Date:yyyy-MM-dd}\t{totalAmountToDistribute:F2}\tNo value to distribute");
        //        }
        //    }
        //}


        public static DataTable CaculateWightedAvg()
        {
            DataTable dtWeightedSpread = GetCaculateWightedAvgDataTable();
            Decimal? CalcTotalCommitment = 0;
            foreach (DataRow row in dtWeightedSpread.Rows)
            {
                if (row["TotalCommitment"] != null)
                {
                    CalcTotalCommitment = CalcTotalCommitment + CommonHelper.StringToDecimal(row["TotalCommitment"]);
                }
            }
            if (dtWeightedSpread != null)
            {
                foreach (DataRow row in dtWeightedSpread.Rows)
                {
                    decimal? noteCommitment = CommonHelper.StringToDecimal(row["TotalCommitment"]);
                    decimal? WeightedSpread = CommonHelper.StringToDecimal(row["WeightedSpread"]);
                    decimal? weight = (noteCommitment * 100 / CalcTotalCommitment) / 100;
                    decimal? NoteCalcWeightedAvg = weight * WeightedSpread;
                    row["CalcWeightedSpread"] = NoteCalcWeightedAvg;
                }
            }
            return dtWeightedSpread;
        }
        public static DataTable GetCaculateWightedAvgDataTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("NoteID");
            dt.Columns.Add("WeightedSpread");
            dt.Columns.Add("EffectiveRate");
            dt.Columns.Add("TotalCommitment");
            dt.Columns.Add("CalcWeightedSpread");
            dt.Columns.Add("CalcWeightedEffectiveRate");

            DataRow rmport = dt.NewRow();
            rmport["NoteID"] = "98AE5D02-3816-475E-9613-92CDFDC9B140";
            rmport["WeightedSpread"] = 0.0386448m;
            rmport["EffectiveRate"] = 0m;
            rmport["CalcWeightedSpread"] = null;
            rmport["CalcWeightedEffectiveRate"] = null;
            rmport["TotalCommitment"] = 52350000m;
            dt.Rows.Add(rmport);


            rmport = dt.NewRow();
            rmport["NoteID"] = "55793BB2-DCF3-4C4C-8010-09C7DE1D95EE";
            rmport["WeightedSpread"] = 0.0386448m;
            rmport["EffectiveRate"] = 0m;
            rmport["CalcWeightedSpread"] = null;
            rmport["CalcWeightedEffectiveRate"] = null;
            rmport["TotalCommitment"] = 12000000m;
            dt.Rows.Add(rmport);

            return dt;
        }

        public static void GetNextQuarterEndDate()
        {
            DateTime today = DateTime.Today;
            //DateTime today = new DateTime(2022,12,22);
            var dt = DateExtensions.GetNextQuarterEndDate(today);
        }
    }
    public class DatesDataContract
    {
        public DateTime OriginalDate { get; set; }
        public DateTime OldoCodeDate { get; set; }
        public DateTime NewCodeDate { get; set; }

    }
}