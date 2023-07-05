using CRES.DataContract;
using CRES.NoteCalculator;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Xml.Linq;

namespace CRES.CashFlowEngineCheckCore
{
    internal class Program
    {
        public static List<RateSpreadSchedule> NoteRateSpreadScheduleList = new List<RateSpreadSchedule>();
        public static List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepayAndAdditionalFeeScheduleDataContractlist = new List<PrepayAndAdditionalFeeScheduleDataContract>();
        public static List<MaturityScenariosDataContract> MaturityScenariosDataContractList = new List<MaturityScenariosDataContract>();

        private static void Main(string[] args)
        {
            // ReadException();
            //getcommitmentdata();


            string noteid = args.Length > 0 ? args[0] : "8103";
            RunNoteCalculator(noteid);
            //GeneratePDFFile();
            // RunPayRule();
        }

        public static void TestCommitmentData(NoteDataContract notedc)
        {
            CommitmentEquityHelper ce = new CommitmentEquityHelper();
            // List<NoteCommitmentEquityDataContract> calcNoteCommitmentdata =  ce.calcNoteCommitment(notedc);


        }

        public static void RunPayRule()
        {
            PayruleNoteFutureFundingHelper pm = new PayruleNoteFutureFundingHelper();

            string json = File.ReadAllText(@"C:\temp\issuejson.json");

            DealDataContract deal = JsonConvert.DeserializeObject<DealDataContract>(json);

            deal = pm.StartCalculation(deal);

            // var json = new JavaScriptSerializer().Serialize(dc);
        }

        public static void getcommitmentdata()
        {
            CommitmentEquityHelper ce = new CommitmentEquityHelper();
            string json = File.ReadAllText(@"C:\temp\10471notedc.json");

            NoteDataContract note = JsonConvert.DeserializeObject<NoteDataContract>(json);
            //   ce.calcNoteCommitment(note);
        }

        public static void RunNoteCalculator(string noteid)
        {
            string Resultjson = "";
            CalculationMaster cm = new CalculationMaster();

            // NoteDataContract note= Setdata();

            string json = File.ReadAllText(@"C:\temp\Samplenote.json");

            NoteDataContract note = JsonConvert.DeserializeObject<NoteDataContract>(json);

            // note = ScenarioRules.AssignValuesToSelectedMaturityUsingDealSetup(note);
            NoteDataContract ndc = cm.StartCalculation(note);
            note.ListCashflowTransactionEntry = ndc.ListCashflowTransactionEntry;

            TestCommitmentData(note);

            Resultjson = JsonConvert.SerializeObject(note);
        }

        public void ReadExcelCellTest()
        {
            XDocument document = XDocument.Load(@"C:\BDATA\Cars.xml");
            XNamespace workbookNameSpace = @"urn:schemas-microsoft-com:office:spreadsheet";

            // Get worksheet
            var query = from w in document.Elements(workbookNameSpace + "Workbook").Elements(workbookNameSpace + "Worksheet")
                        where w.Attribute(workbookNameSpace + "Name").Value.Equals("Settings")
                        select w;

            List<XElement> foundWoksheets = query.ToList<XElement>();
            if (foundWoksheets.Count() <= 0) { throw new ApplicationException("Worksheet Settings could not be found"); }
            XElement worksheet = query.ToList<XElement>()[0];

            // Get the row for "Seat"
            query = from d in worksheet.Elements(workbookNameSpace + "Table").Elements(workbookNameSpace + "Row").Elements(workbookNameSpace + "Cell").Elements(workbookNameSpace + "Data")
                    where d.Value.Equals("Seat")
                    select d;
            List<XElement> foundData = query.ToList<XElement>();
            if (foundData.Count() <= 0) { throw new ApplicationException("Row 'Seat' could not be found"); }
            XElement row = query.ToList<XElement>()[0].Parent.Parent;

            // Get value cell of Etl_SPIImportLocation_ImportPath setting
            XElement cell = row.Elements().ToList<XElement>()[1];

            // Get the value "Leon"
            string cellValue = cell.Elements(workbookNameSpace + "Data").ToList<XElement>()[0].Value;

            Console.WriteLine(cellValue);
        }

        public static void CheckCalculationStatus()
        {

            string[] REQUESTID = { "f91cdfd96ef1413aa248fbb8fe315f6a", "de9a23352e7a47e6b8a6b203c891c4a9", "db2b5c5c96cf4197935fb9049e27d8df" };

            dynamic flexible = new ExpandoObject();

            flexible.property = "cancelled_flag";
            flexible.value = true;
            flexible.request_ids = REQUESTID;

#pragma warning disable CS0219 // The variable 'requestid' is assigned but its value is never used
            string requestid = "";
#pragma warning restore CS0219 // The variable 'requestid' is assigned but its value is never used
            string apiPath = "";
            string headerkey = "auth_key";
            string headerValue = "fc00b7e3880e4f04abffdf03b6fca55d";
            requestid = "144eff828a6c4fbda795d29b97b80c6f";

            string ApiConstantUrl = "https://m61engine.azurewebsites.net/";
            apiPath = ApiConstantUrl + "requests";


            var content = new StringContent(JsonConvert.SerializeObject(flexible), Encoding.UTF8, "application/json");
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
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
            }


        }

        //public static void GeneratePDFFile() 
        //{
        //    //Create document
        //    Document doc = new Document();
        //    //Create PDF Table
        //    PdfPTable tableLayout = new PdfPTable(4);
        //    // Directory.GetCurrentDirectory();

        //    //Create a PDF file in specific path
        //    PdfWriter writer = PdfWriter.GetInstance(doc, new FileStream(@"C:\temp\test.pdf", FileMode.Create));
        //    //Open the PDF document
        //    doc.Open();
        //    // step 4: we grab the ContentByte and do some stuff with it
        //    PdfContentByte cb = writer.DirectContent;

        //    BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
        //    cb.SetColorFill(BaseColor.BLACK);
        //    cb.SetFontAndSize(bf, 8);
        //    // we tell the ContentByte we're ready to draw text
        //    cb.BeginText();

        //    // we draw some text on a certain position
        //    cb.SetTextMatrix(200, 800);
        //    cb.ShowText("Text at position 100,400.");
        //    cb.EndText();

        //    cb.BeginText();
        //    string text = "Some random blablablabla...";
        //    // put the alignment and coordinates here
        //    cb.ShowTextAligned(1, text, 520, 640, 0);
        //    cb.EndText();
        //    cb.BeginText();
        //    text = "Other random blabla...";
        //    // put the alignment and coordinates here
        //    cb.ShowTextAligned(2, text, 100, 200, 0);
        //    cb.EndText();

        //    doc.Add(new Paragraph("manish"));           


        //    // Closing the document
        //    doc.Close();


        //}

        public static ExceptionDataContract ReadException()
        {
            string errormesg = "Error in calculating for request id:: e8386a49c34c437081b61f1520e90044 Traceback (most recent call last):   File  run.py , line 391, in <module>     engine_job.execute()   File  run.py , line 355, in execute     self.load_queue_data()   File  run.py , line 147, in load_queue_data     raise exceptions.MaxRetryError( Max retry attempts reached. Dequeue count: {} .format(self.queue_message.dequeue_count)) #Exception( Max retry attempts reached. Deleting the message from queue. ) exceptions.MaxRetryError: Max retry attempts reached. Dequeue count: 6 ";
            ExceptionDataContract edc = new ExceptionDataContract();
            string errtype = "";
            string innnerexeption = "";
            string[] errortype = { "AttributeError", "KeyError", "ImportError", "IndexError", "SyntaxError", "NameError", "TypeError", "ValueError", "ConnectionError", "InvalidOperation", "Exception:", "MaxRetryError:" };
            for (int i = 0; i < errortype.Length; i++)
            {
                var res = errormesg.Contains(errortype[i]);
                if (res == true)
                {
                    var errormessage = errormesg.Substring(errormesg.IndexOf(errortype[i]) + (errortype[i]).Length);
                    if (errormessage != "")
                    {
                        errtype = errortype[i];
                        if (errtype == "KeyError")
                        {
                            int id = errormessage.LastIndexOf(errtype);
                            int indexoferror = errormessage.LastIndexOf("During handling of the above exception, another exception occurred");
                            if (indexoferror > 0)
                            {
                                innnerexeption = errormessage.Substring(id, indexoferror - id);
                            }
                            else
                            {
                                innnerexeption = errormessage;
                            }
                        }
                        else
                        {
                            int indexoferror = errormessage.IndexOf("During handling of the above exception, another exception occurred");
                            if (indexoferror > 0)
                            {
                                innnerexeption = errormessage.Substring(0, indexoferror);
                            }
                            else
                            {
                                innnerexeption = errormessage;
                            }
                        }

                        break;
                    }
                }
            }

            edc.Summary = innnerexeption;
            edc.MethodName = errtype;
            edc.StackTrace = errormesg;
            return edc;


        }


    }
}