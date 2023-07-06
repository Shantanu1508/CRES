using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace CRES.ServiceMVC.Controllers
{
    //[Route("api/account")]
    [ApiController]
    public class TestController : ControllerBase
    {
        // GET: api/Test
        [HttpGet]
        [Route("api/account/getaccoutdetail")]
        public IEnumerable<string> Get123()
        {
            return new string[] { "value1", "value2" };
        }

        //// GET: api/Test/5
        //[HttpGet("{id}", Name = "Get")]
        //public string Get(int id)
        //{
        //    return "value";
        //}

        // POST: api/Test
        [HttpPost]
        [Route("api/account/post123")]
        public void Post([FromBody] string value)
        {
        }


    }
}
