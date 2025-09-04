
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using CRES.DataContract;
using CRES.BusinessLogic;
using System.Threading.Tasks;
using System.Collections;
using CRES.Utilities;
using System.Net.Http.Headers;
using System.Web;
using System.Drawing;
using System.Configuration;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Auth;
using Microsoft.WindowsAzure.Storage.Blob;
using CRES.Services;
using System.IO;
using System.Data;
using CRES.NoteCalculatorServiceMVC.Infrastructure;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.StaticFiles;
using ExcelDataReader;
using Microsoft.AspNetCore.Http;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using Newtonsoft.Json;
using System.Threading;

namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class ExceluploadController : ControllerBase
    {
        public async Task<IActionResult> UploadXIRRFiles(ReportFileDataContract reportDC, DataTable dt)
        {
            //ReportFileDataContract reportDC = new ReportFileDataContract();
            //reportDC.ReportFileName = "XIRR_Output";
            //reportDC.ReportFileFormat = "xlsx";
            //reportDC.SourceStorageLocation = "ExcelTemplate";
            //reportDC.SourceStorageTypeID = 641;
            //reportDC.ReportFileTemplate = "XIRR_Output_Archive" + "." + reportDC.ReportFileFormat;

            AccountingReportLogic reportLogic = new AccountingReportLogic();
            GenericResult _actionResult = null;
            var headerUserID = string.Empty;
            string CurrentDate = System.DateTime.Now.ToString("yyyyMMdd");
            TagXIRRLogic xirrLogic = new TagXIRRLogic();
            try
            {
                //if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                //{
                //    headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
                //}

                if (reportDC.ReportFileFormat.ToLower() == "xlsx")
                {
                    //read template from source
                    using (var memStream = await AzureStorageReadFile.ReadAccountingReportStream(reportDC))
                    {

                        DataSet dsXIRRData = new DataSet();
                        //get the data from the database 
                        //DataTable dtXIRR = new DataTable();
                        //dtXIRR = xirrLogic.GetXIRROutputArchive(xirrConfig.XIRRConfigID, Convert.ToDateTime(xirrConfig.ArchiveDate), headerUserID);
                        dsXIRRData.Tables.Add(dt);
                        // write data to stream
                        using (var package = new OfficeOpenXml.ExcelPackage(memStream))
                        {

                            //Step 2 : Add a new worksheet to ExcelPackage object and give a suitable name

                            int iSheetsCount = 0;
                            try
                            {
                                package.Workbook.Worksheets[0].Name = reportDC.ReportFileName;
                                iSheetsCount = package.Workbook.Worksheets.Count;
                            }
                            catch (Exception)
                            {
                                iSheetsCount = package.Workbook.Worksheets.Count;
                            }
                            if (iSheetsCount > 0)
                            {

                                // Get the sheet by index
                                OfficeOpenXml.ExcelWorksheet worksheet;
                                try
                                {
                                    worksheet = package.Workbook.Worksheets[0];
                                }
                                catch (Exception)
                                {
                                    worksheet = package.Workbook.Worksheets[0];
                                }

                                worksheet.Cells[2, 1].LoadFromDataTable(dsXIRRData.Tables[0], false);
                                var stream = new MemoryStream(package.GetAsByteArray());

                                //upload file to destination
                                FileUploadParameterDataContract fileParam = new FileUploadParameterDataContract();
                                fileParam.StorageTypeID = reportDC.DestinationStorageTypeID;
                                fileParam.StorageLocation = reportDC.DestinationStorageLocation;
                                fileParam.FileName = reportDC.NewFileName;
                                await UploadFilesByStorageType(fileParam, stream);//
                                stream.Flush();
                            }
                        }
                    }

                    //
                }

            }

            catch (Exception ex)
            {
                string output = "";
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.XIRRDownload.ToString(), "Error occurred in downloading XIRRReturn ", "", "", ex.TargetSite.Name.ToString(), "", ex);
                return File(output, "application/octet-stream");

            }


            finally
            {

            }
            return Ok(_actionResult);
        }
        public async Task<IActionResult> UploadXIRRFiles(ReportFileDataContract reportDC, DataTable dt, bool IsPrintHeader)
        {
            //ReportFileDataContract reportDC = new ReportFileDataContract();
            //reportDC.ReportFileName = "XIRR_Output";
            //reportDC.ReportFileFormat = "xlsx";
            //reportDC.SourceStorageLocation = "ExcelTemplate";
            //reportDC.SourceStorageTypeID = 641;
            //reportDC.ReportFileTemplate = "XIRR_Output_Archive" + "." + reportDC.ReportFileFormat;

            AccountingReportLogic reportLogic = new AccountingReportLogic();
            GenericResult _actionResult = null;
            var headerUserID = string.Empty;
            string CurrentDate = System.DateTime.Now.ToString("yyyyMMdd");
            TagXIRRLogic xirrLogic = new TagXIRRLogic();
            try
            {
                //if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                //{
                //    headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
                //}

                if (reportDC.ReportFileFormat.ToLower() == "xlsx")
                {
                    //read template from source
                    using (var memStream = AzureStorageReadFile.ReadAccountingReportInStream(reportDC))
                    {

                        DataSet dsXIRRData = new DataSet();
                        //get the data from the database 
                        //DataTable dtXIRR = new DataTable();
                        //dtXIRR = xirrLogic.GetXIRROutputArchive(xirrConfig.XIRRConfigID, Convert.ToDateTime(xirrConfig.ArchiveDate), headerUserID);
                        dsXIRRData.Tables.Add(dt);
                        // write data to stream
                        using (var package = new OfficeOpenXml.ExcelPackage(memStream))
                        {

                            //Step 2 : Add a new worksheet to ExcelPackage object and give a suitable name

                            int iSheetsCount = 0;
                            try
                            {
                                //package.Workbook.Worksheets[0].Name = reportDC.ReportFileName;
                                iSheetsCount = package.Workbook.Worksheets.Count;
                            }
                            catch (Exception)
                            {
                                iSheetsCount = package.Workbook.Worksheets.Count;
                            }
                            if (iSheetsCount > 0)
                            {

                                // Get the sheet by index
                                OfficeOpenXml.ExcelWorksheet worksheet;
                                try
                                {
                                    worksheet = package.Workbook.Worksheets[0];
                                }
                                catch (Exception)
                                {
                                    worksheet = package.Workbook.Worksheets[0];
                                }

                                worksheet.Cells[2, 1].LoadFromDataTable(dsXIRRData.Tables[0], IsPrintHeader);
                                var stream = new MemoryStream(package.GetAsByteArray());

                                //upload file to destination
                                FileUploadParameterDataContract fileParam = new FileUploadParameterDataContract();
                                fileParam.StorageTypeID = reportDC.DestinationStorageTypeID;
                                fileParam.StorageLocation = reportDC.DestinationStorageLocation;
                                fileParam.FileName = reportDC.NewFileName;
                                await UploadFilesByStorageType(fileParam, stream);//
                                stream.Flush();
                            }
                        }
                    }

                    //
                }

            }

            catch (Exception ex)
            {
                string output = "";
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.XIRRDownload.ToString(), "Error occurred in downloading XIRRReturn ", "", "", ex.TargetSite.Name.ToString(), "", ex);
                return File(output, "application/octet-stream");

            }


            finally
            {

            }
            return Ok(_actionResult);
        }

        public async Task<IActionResult> UploadXIRRFiles(ReportFileDataContract reportDC, DataSet dsXIRRData, bool IsPrintHeader)
        {
            //ReportFileDataContract reportDC = new ReportFileDataContract();
            //reportDC.ReportFileName = "XIRR_Output";
            //reportDC.ReportFileFormat = "xlsx";
            //reportDC.SourceStorageLocation = "ExcelTemplate";
            //reportDC.SourceStorageTypeID = 641;
            //reportDC.ReportFileTemplate = "XIRR_Output_Archive" + "." + reportDC.ReportFileFormat;
            string DocumentStorageID = "";
            AccountingReportLogic reportLogic = new AccountingReportLogic();
            GenericResult _actionResult = null;
            var headerUserID = string.Empty;
            string CurrentDate = System.DateTime.Now.ToString("yyyyMMdd");
            TagXIRRLogic xirrLogic = new TagXIRRLogic();
            try
            {
                if (reportDC.ReportFileFormat.ToLower() == "xlsx")
                {
                    //read template from source
                    using (var memStream = AzureStorageReadFile.ReadAccountingReportInStream(reportDC))
                    {
                        DocumentStorageID = await WriteDataToStream(reportDC, dsXIRRData, memStream);
                    }
                }

            }

            catch (Exception ex)
            {
                string output = "";
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.XIRRDownload.ToString(), "Error occurred in downloading XIRRReturn ", "", "", ex.TargetSite.Name.ToString(), "", ex);
                return File(output, "application/octet-stream");

            }
            finally
            {

            }
            return Ok(_actionResult);
        }

        public async Task<string> UploadFilesByStorageType(FileUploadParameterDataContract fileParamter, Stream msfile)
        {
            string DocumentStorageID = fileParamter.FileName;
            //392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer
            GetConfigSetting();
            try
            {
                if (fileParamter.StorageTypeID == 392)
                {
                    var Container = Sectionroot.GetSection("storage:container:name").Value;
                    var accountName = Sectionroot.GetSection("storage:account:name").Value;
                    var accountKey = Sectionroot.GetSection("storage:account:key").Value;
                    var storageAccount = new CloudStorageAccount(new StorageCredentials(accountName, accountKey), true);
                    CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
                    CloudBlobContainer excelContainer = blobClient.GetContainerReference(Container);
                    CloudBlobDirectory dr = excelContainer.GetDirectoryReference(fileParamter.StorageLocation);
                    CloudBlockBlob cloudBlockBlob = dr.GetBlockBlobReference(fileParamter.FileName);
                    msfile.Seek(0, SeekOrigin.Begin);
                    await cloudBlockBlob.UploadFromStreamAsync(msfile);
                }
                else if (fileParamter.StorageTypeID == 459)
                {

                    ////create folder structure
                    //var folderid = await new BoxHelper().CheckAndCreateBoxFolder("", fileParamter.StorageLocation);
                    //DocumentDataContract _docDC = new DocumentDataContract();

                    //// Generate a new filename for every new blob
                    //_docDC.FileName = fileParamter.FileName;
                    //_docDC.Storagetype = "Box";
                    //DocumentStorageID = await new BoxHelper().UploadFileToFolder(folderid.ToString(), _docDC, msfile);

                }
                else if (fileParamter.StorageTypeID == 641)
                {
                    string filePath = Path.Combine(Directory.GetCurrentDirectory() + "/wwwroot", fileParamter.StorageLocation);

                    string fileName = filePath + "/" + fileParamter.FileName;
                    if (!Directory.Exists(filePath))
                    {
                        Directory.CreateDirectory(filePath);
                    }
                    msfile.Seek(0, SeekOrigin.Begin);
                    using (FileStream fs = new FileStream(fileName, FileMode.Create, FileAccess.ReadWrite))
                    {
                        msfile.CopyTo(fs);
                    }
                }
                else if (fileParamter.StorageTypeID == 642)
                {
                    //result = await UploadFileToFTPServer();
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.FileUpload.ToString(), "Error in UploadFilesByStorageType", "", "", ex.TargetSite.Name.ToString(), "", ex);

                throw ex;
            }
            finally
            {
                msfile.Flush();
            }
            return DocumentStorageID;


        }

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

        public async Task<string> WriteDataToStream(ReportFileDataContract ReportFileDC, DataSet dsReportData, Stream strm)
        {
            string DocumentStorageID = "";
            DataTable dt = new DataTable();
            Stream TemplateMemoryStream = new MemoryStream();
            List<string> lstTemplateLines = new List<string>();
            try
            {

                Logger.Write(ModuleName.AccountingReport.ToString(), "Writing data to file " + ReportFileDC.NewFileName, MessageLevel.Info, "", "");

                //392-AzureBlob, 459-Box, 641-LocalServer, 642-FTPServer

                if (ReportFileDC.ReportFileFormat.ToLower() == "xlsx")
                {
                    using (var package = new OfficeOpenXml.ExcelPackage(strm))
                    {

                        //Step 2 : Add a new worksheet to ExcelPackage object and give a suitable name

                        int iSheetsCount = 0;
                        try
                        {
                            iSheetsCount = package.Workbook.Worksheets.Count;
                        }
                        catch (Exception)
                        {
                            iSheetsCount = package.Workbook.Worksheets.Count;
                        }
                        if (iSheetsCount > 0)
                        {
                            for (int i = 0; i < iSheetsCount; i++)
                            {
                                // Get the sheet by index
                                OfficeOpenXml.ExcelWorksheet worksheet;
                                try
                                {
                                    worksheet = package.Workbook.Worksheets[i];
                                }
                                catch (Exception)
                                {
                                    worksheet = package.Workbook.Worksheets[i];
                                }
                                worksheet.Cells[2, 1].LoadFromDataTable(dsReportData.Tables[i], true);
                            }

                            Byte[] fileBytes = package.GetAsByteArray();
                            TemplateMemoryStream = new MemoryStream(fileBytes);
                        }
                        FileUploadParameterDataContract fileParam = new FileUploadParameterDataContract();
                        fileParam.StorageTypeID = ReportFileDC.DestinationStorageTypeID;
                        fileParam.StorageLocation = ReportFileDC.DestinationStorageLocation;
                        fileParam.FileName = ReportFileDC.NewFileName;
                        DocumentStorageID = await UploadFilesByStorageType(fileParam, TemplateMemoryStream);//
                        TemplateMemoryStream.Flush();
                    }
                }
                else if (ReportFileDC.ReportFileFormat.ToLower() == "csv")
                {
                    int LineCount = new StreamReader(strm).ReadToEnd().Split(new char[] { '\n' }).Length;

                    StreamWriter writer = new StreamWriter(strm);
                    IEnumerable<String> items = null;
                    int skeplineCount = 0;
                    //write template content
                    //foreach (DataRow row in dsTemplateData.Tables[0].Rows)
                    //{
                    //    items = row.ItemArray.Select(o => QuoteValue(o?.ToString() ?? String.Empty));
                    //    writer.WriteLine(String.Join(",", items));
                    //}

                    if (ReportFileDC.HeaderPosition > 0)
                    {
                        skeplineCount = ReportFileDC.HeaderPosition - LineCount;
                        for (int i = 0; i < skeplineCount; i++)
                        {
                            writer.Write("");
                        }

                    }

                    //write db content header
                    IEnumerable<String> headerValues = dsReportData.Tables[0].Columns.OfType<DataColumn>().Select(column => QuoteValue(column.ColumnName));
                    writer.WriteLine(String.Join(",", headerValues));
                    //write db content(actual data)
                    foreach (DataRow row in dsReportData.Tables[0].Rows)
                    {
                        items = row.ItemArray.Select(o => QuoteValue(o?.ToString() ?? String.Empty));
                        writer.WriteLine(String.Join(",", items));
                    }

                    writer.Flush();
                }


            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.AccountingReport.ToString(), "Error detail(method: ReadAndUploadTemplateFile) :  ", "", "", ex.TargetSite.Name.ToString(), "", ex);

                throw ex;
            }
            return DocumentStorageID;
        }
        private string QuoteValue(string value)
        {
            return String.Concat("\"",
            value.Replace("\"", "\"\""), "\"");
        }
    }

}