using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;

namespace CRES.BusinessLogic
{
    public class PropertyLogic
    {
        PropertyRepository _propertyRepository = new PropertyRepository();
        public List<PropertyDataContract> getAllProperty(string DealId, Guid? userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            return _propertyRepository.GetAllProperty(DealId, userId, pageIndex, pageSize, out TotalCount);
        }


        public bool UpdateProperty(Guid? userid, List<PropertyDataContract> propertyDataContract, string CreatedBy, string UpdatedBy)
        {
            bool retValue = false;
            retValue = _propertyRepository.UpdateProperty(userid, propertyDataContract, CreatedBy, UpdatedBy);
            return retValue;
        }


        public PropertyDataContract GetPropertyById(string PropertyId)
        {
            return _propertyRepository.GetPropertyById(PropertyId);
        }
    }
}
