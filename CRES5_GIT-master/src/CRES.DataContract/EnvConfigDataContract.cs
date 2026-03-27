using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class EnvConfigDataContract
    {
        public string EnvName { get; set; }
        public string ServerName { get; set; }
        public string LoginName { get; set; }
        public string Password { get; set; }
        public string DBName { get; set; }
        public string DealID { get; set; }
        public string NoteID { get; set; }
    }
}
