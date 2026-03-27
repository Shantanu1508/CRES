using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Azure.Storage.Queues;
using System.Text.Json;
using CRES.DataContract;
using Microsoft.Extensions.Configuration;

namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    public class AzureQueueStorageController : Controller
    {
        private readonly IConfiguration _configuration;
        public AzureQueueStorageController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [Route("api/queuestorage/PostQueue")]
        public async Task Post([FromBody] V1CalcQueueSaveOutput v1paramdata)
        {
            string AzureStorageAccConnString = _configuration["Application:AzureStorageAccConnString"];
            string AzureQueueName = _configuration["Application:AzureQueueName"];

            var options = new QueueClientOptions();
            options.MessageEncoding = QueueMessageEncoding.Base64;

            var queClient = new QueueClient(AzureStorageAccConnString, AzureQueueName, options);

            string jsonData = JsonSerializer.Serialize(v1paramdata);
            await queClient.SendMessageAsync(jsonData);

        }
    }
}
