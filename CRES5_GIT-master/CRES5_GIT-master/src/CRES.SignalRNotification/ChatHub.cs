using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;

namespace CRES.SignalRNotification
{
    public class ChatHub : Hub
    {
        public static int intUserCount = 0;

        public override Task OnConnected()
        {
            intUserCount += 1;
            this.ProcessEmbededRequest();
            return base.OnConnected();
        }


        public void Send(string name, string message)
        {
            // Call the broadcastMessage method to update clients.
            Clients.All.broadcastMessage(name, message);
        }

        public void SendToOtherUsers(string name, string message)
        {
            // Call the broadcastMessage method to update clients.           
            Clients.Others.addMessage(name, message);
        }

        public void UpdateCalcStatus(string message)
        {
            Clients.Others.updateClientCalcStatus(message);
        }

        public void SendTaskToOthers(string _taskid, string _message)
        {
            Clients.Others.SendTaskToOtherUsers(_taskid, _message);
        }

        public void ProcessEmbededRequest()
        {
            Clients.All.embededRequest(intUserCount);
        }

        public override Task OnDisconnected()
        {
            intUserCount -= 1;
            this.ProcessEmbededRequest();
            return base.OnDisconnected();
        }
    }
}