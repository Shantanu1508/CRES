using CRES.BusinessLogic;
using CRES.DataContract;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;


namespace CRES.ServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class LoggingController : ControllerBase
    {

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/logging/writeLog")]
        public IActionResult WriteLog([FromBody] string logtext)
        {
            GenericResult _authenticationResult = null;
            List<DevDashBoardDataContract> lstCalculationStatus = new List<DevDashBoardDataContract>();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = string.Empty;
            LoggerLogic log = new LoggerLogic();

            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            String[] strlist = logtext.Split("||");
            if (strlist[1].ToLower() == "error")
            {
                log.WriteLogExceptionMessage(strlist[0], strlist[2], "", headerUserID, "UI Log", "");
            }
            else
            {
                log.WriteLogInfo(strlist[0], strlist[2], "", headerUserID);
            }

            try
            {
                if (lstCalculationStatus != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Succeeded"
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = false,
                        Message = "Failed"
                    };
                }
            }
            catch (Exception ex)
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }
    }
}
