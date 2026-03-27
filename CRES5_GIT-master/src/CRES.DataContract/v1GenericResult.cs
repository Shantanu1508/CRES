using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class v1GenericResult
    {
        public bool Succeeded { get; set; }
        public string Message { get; set; }
        public int Status { get; set; }
        public string ErrorDetails { get; set; }
        public List<string> Validationarray { get; set; }
    }
}
