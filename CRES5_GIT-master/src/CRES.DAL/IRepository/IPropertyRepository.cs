using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CRES.DataContract;


namespace CRES.DAL.IRepository
{
    interface IPropertyRepository 
    {
        List<PropertyDataContract> GetAllProperty(String dealID, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        bool UpdateProperty(Guid? userid, List<PropertyDataContract> propertyDataContract, string CreatedBy, string UpdatedBy);
    }
}
