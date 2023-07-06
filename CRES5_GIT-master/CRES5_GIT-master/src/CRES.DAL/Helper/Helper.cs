using CRES.Utilities;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace CRES.DAL.Helper
{
    public class Helper
    {
        //   public int[] arrayOfTransientErrorNumbers =
        //            { 4060, 40197, 40501, 40613, 49918, 49919, 49920
        //	//,11001   // 11001 for testing, pretend network error is transient.
        //};
        //    public G.List<int> m_listTransientErrorNumbers = new G.List<int>(arrayOfTransientErrorNumbers);
        //m_listTransientErrorNumbers = new G.List<int>(arrayOfTransientErrorNumbers);

        //  private string connstring = ConfigurationManager.ConnectionStrings["LoggingInDB"].ToString();
        public string connstring = "";

        SqlConnection connection = new SqlConnection();
        public Helper()
        {

            IConfigurationBuilder builder = new ConfigurationBuilder();
            builder.AddJsonFile(Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json"));
            var root = builder.Build();
            connstring = root.GetSection("Application").GetSection("ConnectionStrings").Value;
            //connstring = "Data Source = 192.168.1.250; Initial Catalog = CRES4_QA; user id=admin;password=admin1*";
        }

        public int ExecNonquery(string cmdText, params SqlParameter[] cmdParams)
        {
            int result = 0;
            connection.ConnectionString = connstring;

            DataTable resultDT = new DataTable();
            SqlCommand dbCmd = new SqlCommand(cmdText, connection);
            dbCmd.CommandType = CommandType.StoredProcedure;
            dbCmd.CommandTimeout = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    if (cmdParams != null)
                    {
                        //asign dbnull to null parameter
                        cmdParams.ToList().ForEach(x => x.Value = x.Value.CheckDBNull());
                        dbCmd.Parameters.AddRange(cmdParams);
                    }

                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    //connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used

            }
            return result;
        }

        public DataTable ExecDataTable(string cmdText, params SqlParameter[] cmdParams)
        {
            connection.ConnectionString = connstring;

            DataTable resultDT = new DataTable();
            SqlCommand dbCmd = new SqlCommand(cmdText, connection);
            dbCmd.CommandTimeout = 0;
            dbCmd.CommandType = CommandType.StoredProcedure;
            int retryIntervalSeconds = 10;


            for (int tries = 1; tries <= 5; tries++)
            {

#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.Open();

                    if (cmdParams != null)
                    {
                        //asign dbnull to null parameter
                        cmdParams.ToList().ForEach(x => x.Value = x.Value.CheckDBNull());
                        dbCmd.Parameters.AddRange(cmdParams);
                    }
                    SqlDataAdapter dbDA = new SqlDataAdapter { SelectCommand = dbCmd };

                    dbDA.Fill(resultDT);

                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return resultDT;
        }




        public int ExecDataTablewithtable(string cmdText, DataTable dt, string CreatedBy = null, string UpdatedBy = null)
        {
            int result = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandTimeout = 0;
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue("noteAdditinallist", dt);
                    dbCmd.Parameters.AddWithValue("CreatedBy", CreatedBy);
                    dbCmd.Parameters.AddWithValue("UpdatedBy", UpdatedBy);
                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }


        public int ExecDataTablewithtable(string cmdText, string parameterName, string parameter, string dtParameterName, DataTable dt, string CreatedBy, string UpdatedBy, string RequestType = null, string AnalysisID = null)
        {
            int result = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);

                    dbCmd.CommandType = CommandType.StoredProcedure;

                    dbCmd.Parameters.AddWithValue(parameterName, parameter);
                    dbCmd.Parameters.AddWithValue("CreatedBy", CreatedBy);
                    dbCmd.Parameters.AddWithValue("UpdatedBy", UpdatedBy);
                    dbCmd.Parameters.AddWithValue("RequestType", RequestType);
                    dbCmd.Parameters.AddWithValue("AnalysisID", AnalysisID);
                    //dbCmd.Parameters.AddWithValue(dtParameterName, dt);

                    dbCmd.CommandTimeout = 0;

                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }



        public int ExecDataTablewithgaapandlibor(string cmdText, DataTable dt, string CreatedBy = null, string Listname = null)
        {
            int result = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandTimeout = 0;
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue("noteAdditinallist", dt);
                    dbCmd.Parameters.AddWithValue("CreatedBy", CreatedBy);
                    dbCmd.Parameters.AddWithValue("Listname", Listname);
                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }

        public int ExecDataTablewithtable(string cmdText, string parameterName, DataTable dt, string CreatedBy, string UpdatedBy)
        {
            int result = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandTimeout = 0;
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue(parameterName, dt);
                    dbCmd.Parameters.AddWithValue("CreatedBy", CreatedBy);
                    dbCmd.Parameters.AddWithValue("UpdatedBy", UpdatedBy);
                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }

        public int ExecDataTablewithtable(string cmdText, string parameterName, string parameter, string dtParameterName, DataTable dt, string CreatedBy, string UpdatedBy, string RequestType = null)
        {
            int result = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }
                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandType = CommandType.StoredProcedure;

                    dbCmd.Parameters.AddWithValue(parameterName, parameter);
                    dbCmd.Parameters.AddWithValue("CreatedBy", CreatedBy);
                    dbCmd.Parameters.AddWithValue("UpdatedBy", UpdatedBy);
                    dbCmd.Parameters.AddWithValue("RequestType", RequestType);
                    dbCmd.Parameters.AddWithValue(dtParameterName, dt);

                    dbCmd.CommandTimeout = 0;

                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }

        public int ExecDataTablewithparams(string cmdText, params SqlParameter[] cmdParams)// Guid AccountID, string RegisterName, string CreatedBy)
        {
            int result = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }
                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    //  dbCmd.Parameters.AddWithValue("TableTypeTransaction", dt);

                    if (cmdParams != null)
                    {
                        dbCmd.Parameters.AddRange(cmdParams);
                    }
                    dbCmd.CommandTimeout = 0;

                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();

                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }


        public int ExecNonquery(string cmdText, string str)
        {
            int retryIntervalSeconds = 10;
            int result = 0;
            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.CommandTimeout = 0;
                    dbCmd.Parameters.AddWithValue("Msg", str);
                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }

        public int ExecNonqueryForCalcLog(string cmdText, string Msg1, string Msg2, string Msg3, string Msg4, string Msg5, string Msg6, string Msg7, string Msg8, string Msg9, string Msg10)
        {
            int retryIntervalSeconds = 10;
            int result = 0;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandTimeout = 0;
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue("Msg1", Msg1);
                    dbCmd.Parameters.AddWithValue("Msg2", Msg2);
                    dbCmd.Parameters.AddWithValue("Msg3", Msg3);
                    dbCmd.Parameters.AddWithValue("Msg4", Msg4);
                    dbCmd.Parameters.AddWithValue("Msg5", Msg5);
                    dbCmd.Parameters.AddWithValue("Msg6", Msg6);
                    dbCmd.Parameters.AddWithValue("Msg7", Msg7);
                    dbCmd.Parameters.AddWithValue("Msg8", Msg8);
                    dbCmd.Parameters.AddWithValue("Msg9", Msg9);
                    dbCmd.Parameters.AddWithValue("Msg10", Msg10);


                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }

        public int BatchUpdateOrInsert(string cmdText, DataTable dt, string aduitfield, string listname)
        {
            int result = 0;
            int retryIntervalSeconds = 10;
            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandTimeout = 0;
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue(listname, dt);
                    dbCmd.Parameters.AddWithValue("CreatedBy", aduitfield);
                    dbCmd.Parameters.AddWithValue("UpdatedBy", aduitfield);
                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }


        public int BatchUpdateOrInsertException(string cmdText, DataTable dt, string username, string listname, string FieldName)
        {

            int result = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandTimeout = 0;
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue(listname, dt);
                    dbCmd.Parameters.AddWithValue("FieldName", FieldName);
                    dbCmd.Parameters.AddWithValue("UserName", username);
                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }

        public int BatchUpdateOrInsertDealFunding(string cmdText, DataTable dt, string aduitfield, string listname, bool SavingFromDeal)
        {
            int result = 0;
            int retryIntervalSeconds = 10;

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandTimeout = 0;
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue(listname, dt);
                    dbCmd.Parameters.AddWithValue("CreatedBy", aduitfield);
                    dbCmd.Parameters.AddWithValue("UpdatedBy", aduitfield);
                    dbCmd.Parameters.AddWithValue("SavingFromDeal", SavingFromDeal);
                    connection.Open();
                    result = dbCmd.ExecuteNonQuery();
                    connection.Close();
                    //return result;
                    break;
                }
                catch (Exception ex)
                {
                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }


        public string InsertFFBackshop(string cmdText, DataTable dt, string aduitfield, string listname, bool SavingFromDeal)
        {
            int retryIntervalSeconds = 10;
            string result = "success";

            for (int tries = 1; tries <= 5; tries++)
            {
#pragma warning disable CS0168 // The variable 'ex' is declared but never used
                try
                {
                    if (tries > 1)
                    {
                        System.Threading.Thread.Sleep(1000 * retryIntervalSeconds);
                        retryIntervalSeconds = Convert.ToInt32(retryIntervalSeconds * 1.5);
                    }

                    connection.ConnectionString = connstring;

                    DataTable resultDT = new DataTable();
                    SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                    dbCmd.CommandTimeout = 0;
                    dbCmd.CommandType = CommandType.StoredProcedure;
                    dbCmd.Parameters.AddWithValue(listname, dt);
                    dbCmd.Parameters.AddWithValue("CreatedBy", aduitfield);
                    dbCmd.Parameters.AddWithValue("UpdatedBy", aduitfield);
                    dbCmd.Parameters.AddWithValue("SavingFromDeal", SavingFromDeal);
                    connection.Open();

                    dbCmd.ExecuteNonQuery();
                    connection.Close();

                    break;
                }
                catch (Exception ex)
                {
                    //connection.Close();
                    //result = ex.StackTrace;
                    //throw ex;

                    //== TODO save ex.Number in file log
                    //if (this.m_listTransientErrorNumbers.Contains(ex.Number) == true)
                    //{ continue; }
                    //else
                    //{ throw ex; }

                    continue;
                }
                finally
                {
                    connection.Close();
                }
#pragma warning restore CS0168 // The variable 'ex' is declared but never used
            }
            return result;
        }


        public int QueueLoansHelper(string cmdText, DataTable dt, string username, string listname, string batchtype, string PortfolioMasterGuid)
        {
            int result = 0;
            connection.ConnectionString = connstring;

            DataTable resultDT = new DataTable();
            SqlCommand dbCmd = new SqlCommand(cmdText, connection);
            dbCmd.CommandTimeout = 0;
            dbCmd.CommandType = CommandType.StoredProcedure;
            dbCmd.Parameters.AddWithValue(listname, dt);
            dbCmd.Parameters.AddWithValue("CreatedBy", username);
            dbCmd.Parameters.AddWithValue("UpdatedBy", username);
            dbCmd.Parameters.AddWithValue("BatchType", batchtype);
            dbCmd.Parameters.AddWithValue("PortfolioMasterGuid", PortfolioMasterGuid);
            connection.Open();
            result = dbCmd.ExecuteNonQuery();
            connection.Close();
            return result;
        }

        public int InsertUpdatePayruleSetup(DataTable dt, string username, string dealid, string tabletypename)
        {
            int result = 0;
            connection.ConnectionString = connstring;

            DataTable resultDT = new DataTable();
            SqlCommand dbCmd = new SqlCommand("usp_InsertUpdatePayruleSetup", connection);
            dbCmd.CommandTimeout = 0;
            dbCmd.CommandType = CommandType.StoredProcedure;
            dbCmd.Parameters.AddWithValue(tabletypename, dt);
            dbCmd.Parameters.AddWithValue("UpdatedBy", username);
            dbCmd.Parameters.AddWithValue("DealID", dealid);
            connection.Open();
            result = dbCmd.ExecuteNonQuery();
            connection.Close();
            return result;
        }




        //PayruleSetup


        public int ExecuteDatatable(string cmdText, string tableparam, DataTable dt, string createdby = null, string updatedby = null)
        {
            int result = 0;
            connection.ConnectionString = connstring;

            DataTable resultDT = new DataTable();
            SqlCommand dbCmd = new SqlCommand(cmdText, connection);
            dbCmd.CommandTimeout = 0;
            dbCmd.CommandType = CommandType.StoredProcedure;
            dbCmd.Parameters.AddWithValue(tableparam, dt);
            dbCmd.Parameters.AddWithValue("CreatedBy", createdby);
            dbCmd.Parameters.AddWithValue("UpdatedBy", updatedby);
            connection.Open();
            result = dbCmd.ExecuteNonQuery();
            connection.Close();
            return result;
        }



        public DataTable GetDatatable(string cmdText, string tableparam, DataTable dt)
        {

            connection.ConnectionString = connstring;

            DataTable resultDT = new DataTable();
            SqlCommand dbCmd = new SqlCommand(cmdText, connection);
            dbCmd.CommandType = CommandType.StoredProcedure;
            dbCmd.CommandTimeout = 0;
            dbCmd.Parameters.AddWithValue(tableparam, dt);
            //    connection.Open();
            SqlDataAdapter da = new SqlDataAdapter(dbCmd);
            da.Fill(resultDT);
            //  connection.Close();
            return resultDT;
        }



        public int ExecuteScalar(string cmdText, params SqlParameter[] cmdParams)
        {
            int result;
            connection.ConnectionString = connstring;
            SqlCommand dbCmd = new SqlCommand(cmdText, connection);
            dbCmd.CommandTimeout = 0;
            dbCmd.CommandType = CommandType.StoredProcedure;

            if (cmdParams != null)
            {
                //asign dbnull to null parameter
                cmdParams.ToList().ForEach(x => x.Value = x.Value.CheckDBNull());
                dbCmd.Parameters.AddRange(cmdParams);
            }
            try
            {
                connection.Open();
                result = Convert.ToInt32(dbCmd.ExecuteScalar() == null ? 0 : dbCmd.ExecuteScalar());
                connection.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public object ExecuteScalarAll(string cmdText, params SqlParameter[] cmdParams)
        {
            object result;
            connection.ConnectionString = connstring;
            SqlCommand dbCmd = new SqlCommand(cmdText, connection);
            dbCmd.CommandTimeout = 0;
            dbCmd.CommandType = CommandType.StoredProcedure;

            if (cmdParams != null)
            {
                //asign dbnull to null parameter
                cmdParams.ToList().ForEach(x => x.Value = x.Value.CheckDBNull());
                dbCmd.Parameters.AddRange(cmdParams);
            }
            try
            {
                connection.Open();
                result = dbCmd.ExecuteScalar();
                connection.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public DataSet ExecDataSet(string cmdText, params SqlParameter[] cmdParams)
        {
            connection.ConnectionString = connstring;

            DataSet resultDS = new DataSet();
            SqlCommand dbCmd = new SqlCommand(cmdText, connection);
            dbCmd.CommandType = CommandType.StoredProcedure;
            dbCmd.CommandTimeout = 0;
            try
            {
                connection.Open();

                if (cmdParams != null)
                {
                    dbCmd.Parameters.AddRange(cmdParams);
                }
                SqlDataAdapter dbDA = new SqlDataAdapter { SelectCommand = dbCmd };
                dbDA.Fill(resultDS);

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                connection.Close();
            }

            return resultDS;
        }


        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name);
            }
            if (items != null)
            {
                foreach (T item in items)
                {
                    var values = new object[Props.Length];
                    for (int i = 0; i < Props.Length; i++)
                    {
                        //inserting property values to datatable rows
                        values[i] = Props[i].GetValue(item, null);
                    }
                    dataTable.Rows.Add(values);
                }
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }


        public void WriteToCsvFile(DataTable dataTable, string filePath)
        {
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }

            StringBuilder fileContent = new StringBuilder();

            foreach (var col in dataTable.Columns)
            {
                fileContent.Append(col.ToString() + ",");
            }

            fileContent.Replace(",", System.Environment.NewLine, fileContent.Length - 1, 1);



            foreach (DataRow dr in dataTable.Rows)
            {

                foreach (var column in dr.ItemArray)
                {
                    fileContent.Append("\"" + column.ToString() + "\",");
                }

                fileContent.Replace(",", System.Environment.NewLine, fileContent.Length - 1, 1);
            }

            System.IO.File.WriteAllText(filePath, fileContent.ToString());

        }


        public int ExecDataTableServingLog(string cmdText, DataTable dt, string userid, string sourceBlobFileName, string fileDisplayName, string storagetype, string _startdate, string _enddate)
        {
            try
            {
                int result = 0;
                connection.ConnectionString = connstring;

                DataTable resultDT = new DataTable();
                SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                dbCmd.CommandType = CommandType.StoredProcedure;
                dbCmd.Parameters.AddWithValue("tblServicingTransaction", dt);
                dbCmd.Parameters.AddWithValue("CreatedBy", userid);
                dbCmd.Parameters.AddWithValue("FileName", sourceBlobFileName);
                dbCmd.Parameters.AddWithValue("OriginalFileName", fileDisplayName);
                dbCmd.Parameters.AddWithValue("storagetype", storagetype);
                dbCmd.Parameters.AddWithValue("StartDate", _startdate);
                dbCmd.Parameters.AddWithValue("EndDate", _enddate);
                connection.Open();
                dbCmd.CommandTimeout = 0;
                result = dbCmd.ExecuteNonQuery();
                connection.Close();
                return result;
            }
            catch (Exception ex)
            {
                connection.Close();

                throw ex;
            }
        }



        public int ExecDataTableForHistAccrual(string cmdText, string tableTypeName, DataTable dt, string UserID = null)
        {
            try
            {
                int result = 0;
                connection.ConnectionString = connstring;

                DataTable resultDT = new DataTable();
                SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                dbCmd.CommandTimeout = 0;
                dbCmd.CommandType = CommandType.StoredProcedure;
                dbCmd.Parameters.AddWithValue(tableTypeName, dt);
                dbCmd.Parameters.AddWithValue("UserID", UserID.ToString());

                connection.Open();
                result = dbCmd.ExecuteNonQuery();
                connection.Close();
                return result;
            }
            catch (Exception ex)
            {
                connection.Close();

                throw ex;
            }
        }

        public int ExecDataTablewithtableforjson(string cmdText, string parameterName, DataTable dt, string IndexName, Guid? UserID)
        {
            try
            {
                int result = 0;
                connection.ConnectionString = connstring;

                DataTable resultDT = new DataTable();
                SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                dbCmd.CommandTimeout = 0;
                dbCmd.CommandType = CommandType.StoredProcedure;
                dbCmd.Parameters.AddWithValue(parameterName, dt);
                dbCmd.Parameters.AddWithValue("IndexName", IndexName);
                dbCmd.Parameters.AddWithValue("UserID", UserID);
                connection.Open();
                result = dbCmd.ExecuteNonQuery();
                connection.Close();
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                connection.Close();
            }
        }


        public int ExecDataTablewithtableVSTO(string cmdText, DataTable dt, string CreatedBy)
        {
            try
            {   //manish
                int result = 0;
                connection.ConnectionString = connstring;

                DataTable resultDT = new DataTable();
                SqlCommand dbCmd = new SqlCommand(cmdText, connection);
                dbCmd.CommandTimeout = 0;
                dbCmd.CommandType = CommandType.StoredProcedure;
                dbCmd.Parameters.AddWithValue("noteAdditinallist", dt);
                dbCmd.Parameters.AddWithValue("CreatedBy", CreatedBy);

                connection.Open();
                result = dbCmd.ExecuteNonQuery();
                connection.Close();
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                connection.Close();
            }
        }

    }
}


