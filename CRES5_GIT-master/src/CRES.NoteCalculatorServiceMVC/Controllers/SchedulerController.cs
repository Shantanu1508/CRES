using CRES.BusinessLogic;
using CRES.DataContract;
using Microsoft.AspNetCore.Mvc;
using System;

namespace CRES.NoteCalculatorService.Controllers
{
    [Microsoft.AspNetCore.Cors.EnableCors("CRESPolicy")]
    public class SchedulerController : ControllerBase
    {
        private NoteLogic _noteLogic = new NoteLogic();

        private readonly IEmailNotification _iEmailNotification;
        public SchedulerController(IEmailNotification iemailNotification)
        {
            _iEmailNotification = iemailNotification;
        }

        [HttpGet]
        //[Services.Controllers.IsAuthenticate]
        [Route("api/Scheduler/getexecuteprocedureonesinaday")]
        public IActionResult GetExecuteProcedureOnesInADay()
        {
            GenericResult _authenticationResult = null;

            _noteLogic.ExecuteProcedureOnesInADay();
            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Execute Procedure Ones In A Day succeeded."
            };

            return Ok(_authenticationResult);
        }


        [Route("api/Scheduler/getimportsourcetodw")]
        public IActionResult Getimportsourcetodw()
        {
            GenericResult _authenticationResult = null;

            _noteLogic.importsourcetodw();
            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Import succeeded"
            };

            return Ok(_authenticationResult);
        }


        [Route("api/Scheduler/SendEmailNotification")]
        [HttpGet]
        public IActionResult SendEmailNotification()
        {

            GenericResult _authenticationResult = null;
            try
            {
                //   EmailNotification emailNotification = new EmailNotification();
                _iEmailNotification.SendCalculationFailureNotification();
                _authenticationResult = new GenericResult()
                {
                    Succeeded = true,
                    Message = "Email sent succeeded",
                    Token = ""
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
            return Ok(_authenticationResult); ;

        }



        [Route("api/Scheduler/getExecuteProcedureInADay")]
        public IActionResult getExecuteProcedureInADay()
        {
            GenericResult _authenticationResult = null;
            CalculationManagerLogic _calcLogic = new CalculationManagerLogic();
            _calcLogic.ExecuteProcedureInADay();
            _authenticationResult = new GenericResult()
            {
                Succeeded = true,
                Message = "Notes calc process is succeeded"
            };

            return Ok(_authenticationResult);
        }



    }
}