using CRES.BusinessLogic;
using CRES.DataContract;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace CRES.Services.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class PortfolioController : ControllerBase
    {

        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Route("api/portfolio/addupdateportfolio")]
        public IActionResult AddUpdatePortfolio([FromBody] PortfolioDataContract _portfolioDataContract)
        {
            GenericResult _authenticationResult = null;

            PortfolioLogic portfoliologic = new PortfolioLogic();
            int status = 0;
            try
            {

                var headerUserID = string.Empty;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
                IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
                if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
                {
                    headerUserID = Convert.ToString(Request.Headers["TokenUId"]);
                }
                _portfolioDataContract.CreatedBy = headerUserID;
                status = portfoliologic.AddUpdateFortfolio(_portfolioDataContract);

                if (status == 0)
                {

                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Success",

                    };
                }
                else if (status == 1)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Duplicate",

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

            return Ok(_authenticationResult); ;
        }


        [HttpPost]
        [Services.Controllers.IsAuthenticate]
        [Route("api/portfolio/getportfoliodetailbyid")]
        public IActionResult GetPortfolioDetailByID([FromBody] PortfolioDataContract portfolioDC)
        {
            GenericResult _authenticationResult = null;
            PortfolioDataContract _portfolioDC = new PortfolioDataContract();
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used

            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            UserPermissionLogic upl = new UserPermissionLogic();
            PortfolioLogic portfoliologic = new PortfolioLogic();

            //to get user
            List<UserPermissionDataContract> permissionlist = upl.GetuserPermissionByUserIDAndPageName(headerUserID.ToString(), "Dynamic_Portfolio_List");
            if (permissionlist != null && permissionlist.Count > 0)
            {
                _portfolioDC = portfoliologic.GetPortfolioDetailByID(portfolioDC.PortfolioMasterGuid);
            }
            try
            {
                if (_portfolioDC != null)
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded",
                        portfolioDataContract = _portfolioDC,
                        UserPermissionList = permissionlist,
                        StatusCode = 200
                    };
                }
                else
                {
                    _authenticationResult = new GenericResult()
                    {
                        Succeeded = true,
                        Message = "Not Exists",
                        StatusCode = 404
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

        [HttpGet]
        [Services.Controllers.IsAuthenticate]
        [Services.Controllers.DeflateCompression]
        [Route("api/portfolio/getallportfolio")]
        public IActionResult GetAllPortfolio()
        {
            GenericResult _authenticationResult = null;
#pragma warning disable CS0168 // The variable 'headerValues' is declared but never used
            IEnumerable<string> headerValues;
#pragma warning restore CS0168 // The variable 'headerValues' is declared but never used
            var headerUserID = new Guid();
            if (!string.IsNullOrEmpty(Request.Headers["TokenUId"]))
            {
                headerUserID = new Guid(Request.Headers["TokenUId"]);
            }

            int pageSize = 20;
            int pageIndex = 1;

            List<PortfolioDataContract> listportfolio = new List<PortfolioDataContract>();
            UserPermissionLogic upl = new UserPermissionLogic();
            PortfolioLogic portfoliologic = new PortfolioLogic();

            int? totalCount;


            try
            {
                List<UserPermissionDataContract> permissionlist = upl.GetuserPermissionByUserIDAndPageName(headerUserID.ToString(), "Dynamic_Portfolio");
                if (permissionlist != null && permissionlist.Count > 0)
                {
                    listportfolio = portfoliologic.GetAllPortfolio(headerUserID.ToString(), pageIndex, pageSize, out totalCount);
                }
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Authentication succeeded",
                    lstportfolio = listportfolio,
                    UserPermissionList = permissionlist,
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
