using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class WarehouseSnowflakeDataContract
    {
        public string TableName { get; set; }
        public int? SourceRowCount { get; set; }
        public int? DestinationRowCount { get; set; }
    }
    public class M61SnowflakeBackshopJsonDataContract
    {
        public string schema_name { get; set; }
        public string table_name { get; set; }
        public string action { get; set; }
    }

    public class RequestJsonDataContract
    {
        public List<M61SnowflakeBackshopJsonDataContract> M61SnowflakeJsonList { get; set; }
        public List<M61SnowflakeBackshopJsonDataContract> BackshopJsonList { get; set; }
    }

    public class SnowflakeCleanupJsonDataContract
    {
        public string source { get; set; }
        public string schema_name { get; set; }
        public string table_name { get; set; }
        public string primary_column { get; set; }
    }

    public class SnowflakeCleanupListJsonDataContract
    {   
        public List<SnowflakeCleanupJsonDataContract> SnowflakeCleanupJsonList {  get; set; }
    }
}
