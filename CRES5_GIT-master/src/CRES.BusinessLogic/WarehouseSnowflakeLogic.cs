using CRES.DAL.IRepository;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace CRES.BusinessLogic
{
    public class WarehouseSnowflakeLogic
    {
        private WarehouseSnowflakeIntegrationRepository _wsRepository = new WarehouseSnowflakeIntegrationRepository();

        public List<WarehouseSnowflakeDataContract> GetTableRowCountsforSourceDW(string SchemaNames, string TableNames)
        {
            List<WarehouseSnowflakeDataContract> list = new List<WarehouseSnowflakeDataContract>();

            list = _wsRepository.GetTableRowCountsforSourceDW(SchemaNames, TableNames);

            return list;
        }
        public List<WarehouseSnowflakeDataContract> GetTableRowCountsBackshopSourceDW(string SchemaNames, string TableNames)
        {
            List<WarehouseSnowflakeDataContract> backshoplist = new List<WarehouseSnowflakeDataContract>();

            backshoplist = _wsRepository.GetTableRowCountsBackshopSourceDW(SchemaNames, TableNames);

            return backshoplist;
        }
        public DataTable GetPrimaryColumnIDFromSource(string SourceName, string SchemaName, string TableName, string PrimaryColumn)
        {
            return _wsRepository.GetPrimaryColumnIDFromSource( SourceName,  SchemaName,  TableName,  PrimaryColumn);
        }

        public DataTable GetPrimaryColumnIDNamesFromSource(string SourceName, string TableName)
        {
            return _wsRepository.GetPrimaryColumnIDNamesFromSource(SourceName, TableName);
        }
    }
}
