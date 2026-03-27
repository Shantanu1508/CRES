using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class FeeConfigDataContract
    {

        public FeeConfigDataContract()
        {
            lstFeeFunctionsConfig = new List<FeeFunctionsConfigDataContract>();
            lstFeeSchedulesConfig = new List<FeeSchedulesConfigDataContract>();
        }

        public List<FeeFunctionsConfigDataContract> lstFeeFunctionsConfig { get; set; }
        public List<FeeSchedulesConfigDataContract> lstFeeSchedulesConfig { get; set; }
    }

}
