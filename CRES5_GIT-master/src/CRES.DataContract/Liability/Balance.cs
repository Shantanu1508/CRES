using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract.Liability
{
    public class Balance
    {
        public Balance() { }
        public Balance(string name, DateTime dt, Decimal amt) { Name = name; Date = dt; Amount = amt; }
        public DateTime? Date { get; set; }
        public Decimal? Amount { get; set; }
        public string Name { get; set; }
    }
}
