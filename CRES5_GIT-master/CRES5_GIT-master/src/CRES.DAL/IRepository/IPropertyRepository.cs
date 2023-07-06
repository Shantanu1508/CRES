using CRES.DataContract;
using System;
using System.Collections.Generic;


namespace CRES.DAL.IRepository
{
    interface IPropertyRepository
    {
        List<PropertyDataContract> GetAllProperty(String dealID, Guid? userID, int? pageIndex, int? pageSize, out int? TotalCount);

        bool UpdateProperty(Guid? userid, List<PropertyDataContract> propertyDataContract, string CreatedBy, string UpdatedBy);
    }
}
