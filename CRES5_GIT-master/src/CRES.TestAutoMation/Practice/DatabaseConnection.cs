using System;
using System.Data;
using System.Data.SqlClient;

namespace CRES.TestAutoMation.Practice
{
    internal static class DatabaseConnection
    {
        static SqlConnection sqlConnection1 = null;

        public static SqlConnection DBConnect(this SqlConnection sqlConnection, String ConnectionString)
        {
            try
            {
                sqlConnection = new SqlConnection(ConnectionString);
                sqlConnection.Open();
                return sqlConnection;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            return null;
        }


        //Closing the Dastabase Connection

        public static void DBClose(this SqlConnection sqlConnection)
        {
            try
            {
                sqlConnection.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("Closing Exception = " + e.Message);
            }
        }

        //Query Execution

        public static DataTable ExecuteQuery(this SqlConnection sqlConnection, String queryString)
        {
            DataSet dataSet;
            try
            {
                //Checking the state of connection
                if (sqlConnection == null || ((sqlConnection != null && (sqlConnection.State == ConnectionState.Closed || sqlConnection.State == ConnectionState.Broken))))
                    sqlConnection.Open();

                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                //dataAdapter.SelectCommand = new SqlConnection(queryString, sqlConnection);
                dataAdapter.SelectCommand.CommandType = CommandType.Text;

                dataSet = new DataSet();
                dataAdapter.Fill(dataSet, "table");
                sqlConnection.Close();
                return dataSet.Tables["table"];
            }
            catch (Exception e)
            {
                dataSet = null;
                sqlConnection.Close();
                Console.WriteLine("Query Excecution Exception = " + e.Message);
                return null;
            }
            finally
            {
                sqlConnection.Close();
                dataSet = null;
            }
        }
    }
}
