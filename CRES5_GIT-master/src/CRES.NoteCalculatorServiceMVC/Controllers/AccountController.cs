using System; 
using CRES.DataContract;
using CRES.BusinessLogic; 
using Microsoft.AspNetCore.Mvc; 
using CRES.Utilities;
using Newtonsoft.Json;

namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class AccountController : ControllerBase
    {
        [HttpPost]
        [Route("api/account/authenticateUser")]
        public IActionResult AuthenticateUser([FromBody] dynamic inputjson)
        {

            v1GenericResult _authenticationResult = null;
            UserDataContract _userDataContract = new UserDataContract();

            _userDataContract.Login = inputjson["Login"];
            _userDataContract.Password = inputjson["Password"];



            string EncruptPassword = Encryptor.MD5Hash(_userDataContract.Password);

            CRES.BusinessLogic.UserLogic userlogic = new CRES.BusinessLogic.UserLogic();
            _userDataContract = userlogic.ValidateUser(_userDataContract.Login, EncruptPassword);//_userDataContract.Password
            try
            {
                if (_userDataContract != null)
                {
                    _authenticationResult = new v1GenericResult()
                    {
                        Succeeded = true,
                        Message = "Authentication succeeded"
                    };
                }
                else
                {
                    _authenticationResult = new v1GenericResult()
                    {
                        Succeeded = false,                        
                        Message = "Username and password don't match to our records."
                    };
                }
            }
            catch (Exception ex)
            {
                LoggerLogic Log = new LoggerLogic();
                Log.WriteLogException(CRESEnums.Module.Account.ToString(), "Error occurred in Login", "", "", ex.TargetSite.Name.ToString(), "", ex);

                _authenticationResult = new v1GenericResult()
                {
                    Succeeded = false,
                    Message = ex.Message
                };
            }

            return Ok(_authenticationResult); ;

        }


        [HttpGet]
        [Route("api/account/Checklogin")]
        public IActionResult CheckApiHealth()
        {
            v1GenericResult _authenticationResult = null;
            try
            {
                UserDataContract _userDataContract = new UserDataContract();


                _userDataContract.Login = "msingh";
                _userDataContract.Password = "Zmxncb1*";

                var json = JsonConvert.SerializeObject(_userDataContract);

                //Login(_userDataContract);

                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
                LoggerLogic log = new LoggerLogic();
                log.WriteLogInfo(CRESEnums.Module.ValuationModule.ToString(), "Valuation api CheckApiHealth called ", "", "B0E6697B-3534-4C09-BE0A-04473401AB93");

            }
            catch (Exception ex)
            {

                _authenticationResult = new v1GenericResult()
                {
                    Status = 2,
                    Succeeded = false,
                    Message = "Error",
                    ErrorDetails = ex.Message
                };
            }
            return Ok(_authenticationResult);
        }

    }
}
