using Amazon.SimpleSystemsManagement;
using CRES.BusinessLogic;
using CRES.BusinessLogic;
using CRES.DataContract;
using CRES.Utilities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using CRES.Services;

namespace CRES.ServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class ReconController : Controller
    {
        [HttpPost]
        [Route("api/recon/InsertUpdateRuleTypeData")]
        public IActionResult InsertUpdateRuleTypeData([FromBody] DataTable data)
        {
            GenericResult _authenticationResult = null;
            var headerUserID = string.Empty;
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
            }

            V1RulesLogic rl = new V1RulesLogic();
            
            rl.InsertUpdateRuleTypeData(data, headerUserID);

            try
            {
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "succeeded"
                };
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
