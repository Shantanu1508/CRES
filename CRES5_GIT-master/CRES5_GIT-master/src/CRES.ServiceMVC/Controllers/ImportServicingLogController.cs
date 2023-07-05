using CRES.DataContract;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace CRES.Services.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class ImportServicingLogController : ControllerBase
    {
        [HttpPost]
        [Services.Controllers.DeflateCompression]
        [Services.Controllers.IsAuthenticate]
        [Route("api/ImportServicing/importIntoServicing")]
        public IActionResult ImportIntoINServicingTransaction([FromBody] List<ServicingLogDataContract> lstServicingLog)
        {
            GenericResult _actionResult = null;
            var result = 0;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            var createdBy = string.Empty;
            var UpdatedBy = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }


            try
            {
                if (result != 0)
                {

                    _actionResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Data imported successfully.",
                    };
                }
                else
                {
                    _actionResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Updation failed",
                    };
                }
            }
            catch (Exception ex)
            {
                _actionResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            //var javaScriptSerializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            //string jsonString = javaScriptSerializer.Serialize(_actionResult);
            //var json = new JavaScriptSerializer().Serialize(_actionResult);
            //Request.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
            return Ok(_actionResult);
        }
    }
}