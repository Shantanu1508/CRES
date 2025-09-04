using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data;
using System;
using Snowflake.Data.Client;
using System.Text;
using CRES.BusinessLogic;
using CRES.DataContract;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Newtonsoft.Json;
using Microsoft.Extensions.Primitives;
using CRES.DAL.Helper;

namespace CRES.NoteCalculatorServiceMVC.Controllers
{
    public class WarehouseSnowflakeController : Controller
    {
        private readonly IConfiguration _configuration;
        private readonly IEmailNotification _iEmailNotification;
        private readonly IHostingEnvironment _hostingEnvironment;
        public WarehouseSnowflakeController(IConfiguration configuration, IEmailNotification iEmailNotification, IHostingEnvironment hostingEnvironment)
        {
            _configuration = configuration;
            _iEmailNotification = iEmailNotification;
            _hostingEnvironment = hostingEnvironment;
        }

        private string useridforSys_Scheduler = "3D6DB33D-2B3A-4415-991D-A3DA5CEB8B50";
        [HttpPost("api/snowflake/GetRowCounts")]
        public IActionResult GetRowCounts([FromBody] RequestJsonDataContract request)
        {
            GenericResult _authenticationResult = null;

            DataTable dataTable = new DataTable();
            dataTable.Columns.Add("SourceName", typeof(string));
            dataTable.Columns.Add("SchemaName", typeof(string));
            dataTable.Columns.Add("TableName", typeof(string));
            dataTable.Columns.Add("SourceCount", typeof(int));
            dataTable.Columns.Add("DestinationCount(Snowflake)", typeof(int));
            dataTable.Columns.Add("Delta", typeof(int));

            WarehouseSnowflakeLogic wslogic = new WarehouseSnowflakeLogic();

            string schemaNames = string.Join(",", request.M61SnowflakeJsonList.Select(x => x.schema_name));
            string tableNames = string.Join(",", request.M61SnowflakeJsonList.Select(x => x.table_name));

            string backshopschemaNames = string.Join(",", request.BackshopJsonList.Select(x => x.schema_name));
            string backshoptableNames = string.Join(",", request.BackshopJsonList.Select(x => x.table_name));

            List<WarehouseSnowflakeDataContract> list = wslogic.GetTableRowCountsforSourceDW(schemaNames, tableNames);
            List<WarehouseSnowflakeDataContract> backshoplist = wslogic.GetTableRowCountsBackshopSourceDW(backshopschemaNames, backshoptableNames);

            try
            {
                string account = _configuration["Snowflake:Account"];
                string user = _configuration["Snowflake:User"];
                string privateKeyPath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "SharedResources", "RSAKey.txt");
                string warehouse = _configuration["Snowflake:Warehouse"];
                string database = _configuration["Snowflake:Database"];
                string schema = _configuration["Snowflake:Schema"];


                string keyText = System.IO.File.ReadAllText(privateKeyPath);

                keyText = keyText.Replace("\n", "\n").Replace("=", "==");

                using (IDbConnection conn = new SnowflakeDbConnection())
                {
                    SnowflakeDbConnectionStringBuilder connStringBuilder = new SnowflakeDbConnectionStringBuilder()
                    {
                        ["ACCOUNT"] = account,
                        ["DB"] = database,
                        ["SCHEMA"] = schema,
                        ["USER"] = user,
                        ["ROLE"] = "ACCOUNTADMIN",
                        ["WAREHOUSE"] = warehouse,
                        ["PRIVATE_KEY"] = keyText,
                        ["AUTHENTICATOR"] = "SNOWFLAKE_JWT"
                    };

                    conn.ConnectionString = connStringBuilder.ConnectionString;
                    conn.Open();
                    Console.WriteLine("Connection successful!");

                    string constpref = "ACORE.M61.CRES4_ACORE_";
                    string backshopconst = "ACORE.BS.BACKSHOPPRODUCTION_";

                    var combinedNames = request.M61SnowflakeJsonList.Select(x => constpref + x.schema_name + "_" + x.table_name).Distinct().ToArray();
                    var backshopcombinedNames = request.BackshopJsonList.Select(x => backshopconst + x.schema_name + "_" + x.table_name).Distinct().ToArray();

                    string[] tables = combinedNames;
                    string[] backshoptables = backshopcombinedNames;

                    using (IDbCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = $"USE WAREHOUSE {warehouse}";
                        cmd.ExecuteNonQuery();

                        // Process (M61) tables
                        for (int i = 0; i < tables.Length; i++)
                        {
                            cmd.CommandText = $"SELECT COUNT(*) FROM {tables[i]}";
                            int rowCount = Convert.ToInt32(cmd.ExecuteScalar());

                            string schemaAndTable = tables[i].Replace(constpref, "");
                            string[] parts = schemaAndTable.Split('_');

                            string schemaName = parts.Length > 1 ? parts[0].ToUpper() : "UNKNOWN";
                            string tableName = parts.Length > 2 ? (parts[1] + "_" + parts[2]).ToUpper()
                                : (parts.Length > 1 ? parts[1].ToUpper() : schemaAndTable.ToUpper());

                            string fullTableName = $"{schemaName}.{tableName}";

                            var matchingM61Item = list.FirstOrDefault(item => item.TableName.Equals(fullTableName, StringComparison.OrdinalIgnoreCase));

                            if (matchingM61Item != null)
                            {
                                int? sourceRowCount = matchingM61Item.SourceRowCount ?? 0;
                                int? delta = sourceRowCount - rowCount;

                                if (delta != 0)
                                {
                                    DataRow row = dataTable.NewRow();
                                    row["SourceName"] = "M61";
                                    row["SchemaName"] = schemaName;
                                    row["TableName"] = tableName;
                                    row["SourceCount"] = sourceRowCount;
                                    row["DestinationCount(Snowflake)"] = rowCount;
                                    row["Delta"] = delta;

                                    dataTable.Rows.Add(row);
                                }
                            }
                        }

                        // Process Backshop (BS) tables
                        for (int i = 0; i < backshoptables.Length; i++)
                        {
                            cmd.CommandText = $"SELECT COUNT(*) FROM {backshoptables[i]}";
                            int backshoprowCount = Convert.ToInt32(cmd.ExecuteScalar());

                            string BSschemaAndTable = backshoptables[i].Replace(backshopconst, "");
                            string[] BSparts = BSschemaAndTable.Split('_');

                            string BSschemaName = BSparts.Length > 1 ? BSparts[0].ToUpper() : "UNKNOWN";
                            string BStableName = BSparts.Length > 2 ? (BSparts[1] + "_" + BSparts[2]).ToUpper()
                                : (BSparts.Length > 1 ? BSparts[1].ToUpper() : BSschemaAndTable.ToUpper());

                            string fullTableName = $"{BSschemaName}.{BStableName}";

                            var matchingBackshopItem = backshoplist.FirstOrDefault(item => item.TableName.Equals(fullTableName, StringComparison.OrdinalIgnoreCase));

                            if (matchingBackshopItem != null)
                            {
                                int? BSsourceRowCount = matchingBackshopItem.SourceRowCount ?? 0;
                                int? BSdelta = BSsourceRowCount - backshoprowCount;

                                if (BSdelta != 0)
                                {
                                    DataRow row = dataTable.NewRow();
                                    row["SourceName"] = "BS";
                                    row["SchemaName"] = BSschemaName;
                                    row["TableName"] = BStableName;
                                    row["SourceCount"] = BSsourceRowCount;
                                    row["DestinationCount(Snowflake)"] = backshoprowCount;
                                    row["Delta"] = BSdelta;

                                    dataTable.Rows.Add(row);
                                }
                            }

                        }

                        dataTable.DefaultView.Sort = "SourceName DESC, SchemaName ASC, TableName ASC";

                        dataTable = dataTable.DefaultView.ToTable();

                    }
                }

                //var csvData = ConvertDataTableToCsv(dataTable);

                //var fileName = "row_counts.csv";
                //var fileBytes = System.Text.Encoding.UTF8.GetBytes(csvData);

                //Response.Headers.Add("Content-Disposition", "attachment; filename=" + fileName);
                //return File(fileBytes, "text/csv");

                if (dataTable.Rows.Count > 0)
                {
                    _iEmailNotification.SendEmailforADFDiscrepancy(dataTable);
                }
                else
                {
                    _iEmailNotification.SendEmailforZeroADFDiscrepancy();
                }

                return Ok(_authenticationResult);
            }
            catch (Exception ex)
            {
                return Json(new { error = "Error fetching row counts", message = ex.Message });
            }
        }

        private string ConvertDataTableToCsv(DataTable dataTable)
        {
            var csvBuilder = new StringBuilder();

            foreach (DataColumn column in dataTable.Columns)
            {
                csvBuilder.Append(column.ColumnName + ",");
            }
            csvBuilder.AppendLine();

            foreach (DataRow row in dataTable.Rows)
            {
                foreach (var item in row.ItemArray)
                {
                    csvBuilder.Append(item.ToString().Replace(",", ";") + ",");
                }
                csvBuilder.AppendLine();
            }

            return csvBuilder.ToString();
        }

        [HttpPost]
        [Route("api/snowflake/Cleanup")]
        public IActionResult Cleanup([FromBody] RequestJsonDataContract request)
        {
            LoggerLogic Log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;

            WarehouseSnowflakeLogic wslogic = new WarehouseSnowflakeLogic();

            string schemaNames = string.Join(",", request.M61SnowflakeJsonList.Select(x => x.schema_name));
            string tableNames = string.Join(",", request.M61SnowflakeJsonList.Select(x => x.table_name));

            string backshopschemaNames = string.Join(",", request.BackshopJsonList.Select(x => x.schema_name));
            string backshoptableNames = string.Join(",", request.BackshopJsonList.Select(x => x.table_name));

            List<WarehouseSnowflakeDataContract> list = wslogic.GetTableRowCountsforSourceDW(schemaNames, tableNames);
            List<WarehouseSnowflakeDataContract> backshoplist = wslogic.GetTableRowCountsBackshopSourceDW(backshopschemaNames, backshoptableNames);

            try
            {
                string account = _configuration["Snowflake:Account"];
                string user = _configuration["Snowflake:User"];
                string privateKeyPath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "SharedResources", "RSAKey.txt");
                string warehouse = _configuration["Snowflake:Warehouse"];
                string database = _configuration["Snowflake:Database"];
                string schema = _configuration["Snowflake:Schema"];


                string keyText = System.IO.File.ReadAllText(privateKeyPath);

                keyText = keyText.Replace("\n", "\n").Replace("=", "==");

                using (IDbConnection conn = new SnowflakeDbConnection())
                {
                    SnowflakeDbConnectionStringBuilder connStringBuilder = new SnowflakeDbConnectionStringBuilder()
                    {
                        ["ACCOUNT"] = account,
                        ["DB"] = database,
                        ["SCHEMA"] = schema,
                        ["USER"] = user,
                        ["ROLE"] = "ACCOUNTADMIN",
                        ["WAREHOUSE"] = warehouse,
                        ["PRIVATE_KEY"] = keyText,
                        ["AUTHENTICATOR"] = "SNOWFLAKE_JWT"
                    };

                    conn.ConnectionString = connStringBuilder.ConnectionString;
                    conn.Open();
                    Console.WriteLine("Connection successful!");

                    string constpref = "ACORE.M61.CRES4_ACORE_";
                    string backshopconst = "ACORE.BS.BACKSHOPPRODUCTION_";

                    var combinedNames = request.M61SnowflakeJsonList.Select(x => constpref + x.schema_name + "_" + x.table_name).Distinct().ToArray();
                    var backshopcombinedNames = request.BackshopJsonList.Select(x => backshopconst + x.schema_name + "_" + x.table_name).Distinct().ToArray();

                    string[] tables = combinedNames;
                    string[] backshoptables = backshopcombinedNames;

                    using (IDbCommand cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = $"USE WAREHOUSE {warehouse}";
                        cmd.ExecuteNonQuery();

                        // Process (M61) tables
                        for (int i = 0; i < tables.Length; i++)
                        {
                            cmd.CommandText = $"SELECT COUNT(*) FROM {tables[i]}";
                            int rowCount = Convert.ToInt32(cmd.ExecuteScalar());

                            string schemaAndTable = tables[i].Replace(constpref, "");
                            string[] parts = schemaAndTable.Split('_');

                            string schemaName = parts.Length > 1 ? parts[0].ToUpper() : "UNKNOWN";
                            string tableName = parts.Length > 2 ? (parts[1] + "_" + parts[2]).ToUpper()
                                : (parts.Length > 1 ? parts[1].ToUpper() : schemaAndTable.ToUpper());

                            string fullTableName = $"{schemaName}.{tableName}";

                            var matchingM61Item = list.FirstOrDefault(item => item.TableName.Equals(fullTableName, StringComparison.OrdinalIgnoreCase));

                            if (matchingM61Item != null)
                            {
                                int? sourceRowCount = matchingM61Item.SourceRowCount ?? 0;
                                int? delta = sourceRowCount - rowCount;

                                if (delta != 0)
                                {
                                    Log.WriteLogInfo("WarehouseSnowflake", "Cleanup Called : " + schemaName + " " + tableName + " ", "", "");

                                    //doing cleanup when found discrepancy
                                    DataTable dtColumn = wslogic.GetPrimaryColumnIDNamesFromSource("M61", tableName);
                                    string primaryColumn = dtColumn.Rows[0].ItemArray[0].ToString();

                                    DataTable dt = wslogic.GetPrimaryColumnIDFromSource("M61", schemaName, tableName, primaryColumn);

                                    // Inserting ID's and tableName into PRIMARY_KEY_COLUMN_IDS table of ADF

                                    int cntRow = 0; //we will took max upto 50K for batch because of command time out and connection break;
                                    StringBuilder sb = new StringBuilder();
                                    string primary_key_value = "";

                                    cmd.CommandText = $"DELETE FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{tableName}')";
                                    rowCount = Convert.ToInt32(cmd.ExecuteNonQuery());

                                    foreach (DataRow row in dt.Rows)
                                    {
                                        sb.Append("('");
                                        sb.Append(string.Join("','", row.ItemArray));
                                        sb.Append("'),");
                                        cntRow++;
                                        if (cntRow == 50000)
                                        {
                                            primary_key_value = sb.ToString().Substring(0, sb.ToString().Length - 1);
                                            sb.Clear();
                                            cntRow = 0;

                                            cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1) VALUES" + primary_key_value;
                                            rowCount = Convert.ToInt32(cmd.ExecuteNonQuery());
                                        }
                                    }

                                    if (cntRow > 0)
                                    {
                                        primary_key_value = sb.ToString().Substring(0, sb.ToString().Length - 1);
                                        sb.Clear();
                                        cntRow = 0;

                                        cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1) VALUES" + primary_key_value;
                                        rowCount = Convert.ToInt32(cmd.ExecuteNonQuery());
                                    }

                                    // Cleanup Process

                                    cmd.CommandText = $"DELETE FROM {tables[i]} WHERE UPPER({primaryColumn}) NOT IN (SELECT UPPER(COLUMNID1) FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{tableName}'))";
                                    rowCount = Convert.ToInt32(cmd.ExecuteNonQuery());

                                    Log.WriteLogInfo("WarehouseSnowflake", "Deleted from : " + tables[i] + " ", "", "");

                                }
                            }
                        }

                        // Process Backshop (BS) tables
                        for (int i = 0; i < backshoptables.Length; i++)
                        {
                            cmd.CommandText = $"SELECT COUNT(*) FROM {backshoptables[i]}";
                            int backshoprowCount = Convert.ToInt32(cmd.ExecuteScalar());

                            string BSschemaAndTable = backshoptables[i].Replace(backshopconst, "");
                            string[] BSparts = BSschemaAndTable.Split('_');

                            string BSschemaName = BSparts.Length > 1 ? BSparts[0].ToUpper() : "UNKNOWN";
                            string BStableName = BSparts.Length > 2 ? (BSparts[1] + "_" + BSparts[2]).ToUpper()
                                : (BSparts.Length > 1 ? BSparts[1].ToUpper() : BSschemaAndTable.ToUpper());

                            string fullTableName = $"{BSschemaName}.{BStableName}";

                            var matchingBackshopItem = backshoplist.FirstOrDefault(item => item.TableName.Equals(fullTableName, StringComparison.OrdinalIgnoreCase));

                            if (matchingBackshopItem != null)
                            {
                                int? BSsourceRowCount = matchingBackshopItem.SourceRowCount ?? 0;
                                int? BSdelta = BSsourceRowCount - backshoprowCount;

                                if (BSdelta != 0)
                                {
                                    Log.WriteLogInfo("WarehouseSnowflake", "Cleanup Called : " + BSschemaName + " " + BStableName + " ", "", "");

                                    //doing cleanup when found discrepancy
                                    DataTable dtColumn = wslogic.GetPrimaryColumnIDNamesFromSource("BS", BStableName);
                                    dtColumn.Columns.Remove("$ShardName");
                                    string primaryColumn = dtColumn.Rows[0].ItemArray[0].ToString();

                                    //if (primaryColumn.Contains(',') == false)
                                    //{
                                    DataTable dt = wslogic.GetPrimaryColumnIDFromSource("BS", BSschemaName, BStableName, primaryColumn);
                                    dt.Columns.Remove("$ShardName");

                                    // Inserting ID's and tableName into PRIMARY_KEY_COLUMN_IDS table of ADF

                                    int cntRow = 0; //we will took max upto 50K for batch because of command time out and connection break;
                                    StringBuilder sb = new StringBuilder();
                                    string primary_key_value = "";

                                    cmd.CommandText = $"DELETE FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{BStableName}')";
                                    backshoprowCount = Convert.ToInt32(cmd.ExecuteNonQuery());

                                    foreach (DataRow row in dt.Rows)
                                    {
                                        sb.Append("('");
                                        sb.Append(string.Join("','", row.ItemArray));
                                        sb.Append("'),");
                                        cntRow++;
                                        if (cntRow == 50000)
                                        {
                                            primary_key_value = sb.ToString().Substring(0, sb.ToString().Length - 1);
                                            sb.Clear();
                                            cntRow = 0;

                                            if (dt.Columns.Count == 2)
                                                cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1) VALUES" + primary_key_value;
                                            if (dt.Columns.Count == 3)
                                                cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1,COLUMNID2) VALUES" + primary_key_value;
                                            if (dt.Columns.Count == 4)
                                                cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1,COLUMNID2,COLUMNID3) VALUES" + primary_key_value;
                                            if (dt.Columns.Count == 5)
                                                cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1,COLUMNID2,COLUMNID3,COLUMNID4) VALUES" + primary_key_value;
                                            if (dt.Columns.Count == 6)
                                                cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1,COLUMNID2,COLUMNID3,COLUMNID4,COLUMNID5) VALUES" + primary_key_value;

                                            backshoprowCount = Convert.ToInt32(cmd.ExecuteNonQuery());
                                        }
                                    }

                                    if (cntRow > 0)
                                    {
                                        primary_key_value = sb.ToString().Substring(0, sb.ToString().Length - 1);
                                        sb.Clear();
                                        cntRow = 0;

                                        if (dt.Columns.Count == 2)
                                            cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1) VALUES" + primary_key_value;
                                        if (dt.Columns.Count == 3)
                                            cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1,COLUMNID2) VALUES" + primary_key_value;
                                        if (dt.Columns.Count == 4)
                                            cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1,COLUMNID2,COLUMNID3) VALUES" + primary_key_value;
                                        if (dt.Columns.Count == 5)
                                            cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1,COLUMNID2,COLUMNID3,COLUMNID4) VALUES" + primary_key_value;
                                        if (dt.Columns.Count == 6)
                                            cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID1,COLUMNID2,COLUMNID3,COLUMNID4,COLUMNID5) VALUES" + primary_key_value;
                                        backshoprowCount = Convert.ToInt32(cmd.ExecuteNonQuery());
                                    }

                                    // Cleanup Process

                                    if (dt.Columns.Count == 2)
                                        cmd.CommandText = $"DELETE FROM {backshoptables[i]} WHERE UPPER({primaryColumn}) NOT IN (SELECT UPPER(COLUMNID1) FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{BStableName}'))";
                                    if (dt.Columns.Count == 3)
                                        cmd.CommandText = $"DELETE FROM {backshoptables[i]} WHERE ({primaryColumn}) NOT IN (SELECT UPPER(COLUMNID1),UPPER(COLUMNID2) FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{BStableName}'))";
                                    if (dt.Columns.Count == 4)
                                        cmd.CommandText = $"DELETE FROM {backshoptables[i]} WHERE ({primaryColumn}) NOT IN (SELECT UPPER(COLUMNID1),UPPER(COLUMNID2),UPPER(COLUMNID3) FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{BStableName}'))";
                                    if (dt.Columns.Count == 5)
                                        cmd.CommandText = $"DELETE FROM {backshoptables[i]} WHERE ({primaryColumn}) NOT IN (SELECT UPPER(COLUMNID1),UPPER(COLUMNID2),UPPER(COLUMNID3),UPPER(COLUMNID4) FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{BStableName}'))";
                                    if (dt.Columns.Count == 6)
                                        cmd.CommandText = $"DELETE FROM {backshoptables[i]} WHERE ({primaryColumn}) NOT IN (SELECT UPPER(COLUMNID1),UPPER(COLUMNID2),UPPER(COLUMNID3),UPPER(COLUMNID4),UPPER(COLUMNID5) FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{BStableName}'))";
                                    backshoprowCount = Convert.ToInt32(cmd.ExecuteNonQuery());
                                    Log.WriteLogInfo("WarehouseSnowflake", "Deleted from : " + backshoptables[i] + " ", "", "");

                                    //}
                                }
                            }

                        }
                    }
                }

                Log.WriteLogInfo("WarehouseSnowflake", "Cleanup Completed.", useridforSys_Scheduler, "");
                _authenticationResult = new v1GenericResult()
                {
                    Status = 1,
                    Succeeded = true,
                    Message = "Success",
                    ErrorDetails = ""
                };
            }
            catch (Exception ex)
            {
                var requestjson = JsonConvert.SerializeObject(request);
                Log.WriteLogExceptionMessage("WarehouseSnowflake", "Error during cleanup " + " for request id:: " + requestjson + " " + ex.StackTrace, "", useridforSys_Scheduler, "cleanup", "Error ");

                _authenticationResult = new v1GenericResult()
                {
                    Status = 2,
                    Succeeded = false,
                    Message = "Error",
                    ErrorDetails = "Error during cleanup :" + ex.Message
                };
            }

            return Ok(_authenticationResult);
        }
        /*
        [HttpPost]
        [Route("api/snowflake/Cleanup")]
        public IActionResult Cleanup([FromBody] SnowflakeCleanupListJsonDataContract requestList)
        {
            LoggerLogic Log = new LoggerLogic();
            v1GenericResult _authenticationResult = null;

            WarehouseSnowflakeLogic wslogic = new WarehouseSnowflakeLogic();
            SnowflakeCleanupJsonDataContract request = new SnowflakeCleanupJsonDataContract();

            for (int i = 0; i < requestList.SnowflakeCleanupJsonList.Count; i++)
            {
                request = requestList.SnowflakeCleanupJsonList[i];

                string sourceName = request.source;
                string tableName = request.table_name;
                string schemaName = request.schema_name;
                string primaryColumn = request.primary_column;

                if (!primaryColumn.Contains(","))
                {
                    Log.WriteLogInfo("WarehouseSnowflake", "Cleanup Called : " + schemaName + " " + tableName + " ", "", "");

                    DataTable dt = wslogic.GetPrimaryColumnIDFromSource(sourceName, schemaName, tableName, primaryColumn);

                    if (sourceName == "BS")
                        dt.Columns.Remove("$ShardName");

                    Log.WriteLogInfo("WarehouseSnowflake", "GetPrimaryColumnIDFromSource Called : " + schemaName + " " + tableName + " ", useridforSys_Scheduler, "");
                    try
                    {
                        string account = _configuration["Snowflake:Account"];
                        string user = _configuration["Snowflake:User"];
                        string privateKeyPath = Path.Combine(_hostingEnvironment.ContentRootPath, "wwwroot", "SharedResources", "RSAKey.txt");
                        string warehouse = _configuration["Snowflake:Warehouse"];
                        string database = _configuration["Snowflake:Database"];
                        string schema = _configuration["Snowflake:Schema"];
                        string keyText = System.IO.File.ReadAllText(privateKeyPath);
                        keyText = keyText.Replace("\n", "\n").Replace("=", "==");

                        using (IDbConnection conn = new SnowflakeDbConnection())
                        {
                            SnowflakeDbConnectionStringBuilder connStringBuilder = new SnowflakeDbConnectionStringBuilder()
                            {
                                ["ACCOUNT"] = account,
                                ["DB"] = database,
                                ["SCHEMA"] = schema,
                                ["USER"] = user,
                                ["ROLE"] = "ACCOUNTADMIN",
                                ["WAREHOUSE"] = warehouse,
                                ["PRIVATE_KEY"] = keyText,
                                ["AUTHENTICATOR"] = "SNOWFLAKE_JWT"
                            };

                            conn.ConnectionString = connStringBuilder.ConnectionString;
                            conn.Open();
                            Console.WriteLine("Connection successful!");

                            // Inserting ID's and tableName into PRIMARY_KEY_COLUMN_IDS table of ADF

                        int cntRow = 0; //we will took max upto 50K for batch because of command time out and connection break;
                        StringBuilder sb = new StringBuilder();
                        string primary_key_value = "";

                        using (IDbCommand cmd = conn.CreateCommand())
                        {
                            cmd.CommandText = $"USE WAREHOUSE {warehouse}";
                            cmd.CommandTimeout = 0;
                            cmd.ExecuteNonQuery();

                            cmd.CommandText = $"DELETE FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{tableName}')";
                            int rowCount = Convert.ToInt32(cmd.ExecuteNonQuery());

                            foreach (DataRow row in dt.Rows)
                            {
                                sb.Append("('");
                                sb.Append(string.Join("','", row.ItemArray));
                                sb.Append("'),");
                                cntRow++;
                                if (cntRow == 50000)
                                {
                                    primary_key_value = sb.ToString().Substring(0, sb.ToString().Length - 1);
                                    sb.Clear();
                                    cntRow = 0;

                                    cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID) VALUES" + primary_key_value;
                                    rowCount = Convert.ToInt32(cmd.ExecuteNonQuery());
                                }
                            }

                            if (cntRow > 0)
                            {
                                primary_key_value = sb.ToString().Substring(0, sb.ToString().Length - 1);
                                sb.Clear();
                                cntRow = 0;

                                cmd.CommandText = $"INSERT INTO ACORE.ADF.PRIMARY_KEY_COLUMN_IDS(TABLENAME,COLUMNID) VALUES" + primary_key_value;
                                rowCount = Convert.ToInt32(cmd.ExecuteNonQuery());
                            }


                            string constpref = "";
                            if (sourceName == "M61")
                                constpref = "ACORE.M61.CRES4_ACORE_";
                            else if (sourceName == "BS")
                                constpref = "ACORE.BS.BACKSHOPPRODUCTION_";

                            if (constpref != "")
                            {
                                var combinedNames = constpref + request.schema_name + "_" + request.table_name;

                                string table = combinedNames;

                                // Cleanup Process

                                cmd.CommandText = $"DELETE FROM {table} WHERE UPPER({primaryColumn}) NOT IN (SELECT UPPER(COLUMNID) FROM ACORE.ADF.PRIMARY_KEY_COLUMN_IDS WHERE UPPER(TABLENAME) = UPPER('{tableName}'))";
                                rowCount = Convert.ToInt32(cmd.ExecuteNonQuery());

                            }
                        }
                    }

                    Log.WriteLogInfo("WarehouseSnowflake", "Cleanup Completed : " + schemaName + " " + tableName + " ", useridforSys_Scheduler, "");
                    _authenticationResult = new v1GenericResult()
                    {
                        Status = 1,
                        Succeeded = true,
                        Message = "Success",
                        ErrorDetails = ""
                    };
                }
                catch (Exception ex)
                {

                    var requestjson = JsonConvert.SerializeObject(request);
                    Log.WriteLogExceptionMessage("WarehouseSnowflake", "Error during cleanup " + " for request id:: " + requestjson + " " + ex.StackTrace, "", useridforSys_Scheduler, "cleanup", "Error ");

                    _authenticationResult = new v1GenericResult()
                    {
                        Status = 2,
                        Succeeded = false,
                        Message = "Error",
                        ErrorDetails = "Error during cleanup :" + ex.Message
                    };
                }
            }
        }

        return Ok(_authenticationResult);
    }
    */

    }
}
