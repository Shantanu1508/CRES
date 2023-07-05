using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using System;
using System.Data.SqlClient;

namespace CRES.TestAutoMation.TestCases
{
    internal class DataBaseConnection
    {
        [DataSource("System.Data.SqlClient", "Server=.\\SQLWriter; , Database=CRES4;User Id=Cres4_qa; Password=K55/=y-}/?JheFf", "NoteTable", DataAccessMethod.Sequential)]



        /*
        public DataTable GetQueryResult(String vConnectionString, String vQuery)
        {
            SqlConnection Connection;  // It is for SQL connection
            DataSet ds = new DataSet();  // it is for store query result

            try
            {
               Connection con =  DriverManager.getConnection(JDBCType:SQL://localhost3036/emp,"abc", "abcs123");

                Class.forName(com.oracle.jdbc.Driver);


                Connection = new SqlConnection(vConnectionString);  // Declare SQL connection with connection string 
                Connection.Open();  // Connect to Database
                Console.WriteLine("Connection with database is done.");


                vQuery = "select * from CRE.Deal";
                SqlDataAdapter adp = new SqlDataAdapter(vQuery, Connection);  // Execute query on database 
                Console.WriteLine(adp.Fill(ds));  // Store query result into DataSet object   
                Connection.Close();  // Close connection 
                Connection.Dispose();   // Dispose connection             
            }
            catch (Exception E)
            {
                Console.WriteLine("Error in getting result of query.");
                Console.WriteLine(E.Message);
                return new DataTable();
            }
            return ds.Tables[0];
        }
        */

        [TestMethod]
        public static int SSN_DB(IWebDriver session, string connString)
        {
            //creating a db connection connection
            var DBConnection = new SqlConnection(connString);
            DBConnection.Open();
            // Can execute a query or store procedure 
            var MemTable = new SqlCommand();
            MemTable.CommandText = "select * from CRE.Deal";
            MemTable.Connection = DBConnection;
            var dr = MemTable.ExecuteReader();
            var Memberid = 0;

            while (dr.Read())
            {
                Memberid = dr.GetInt32(0);
                Console.WriteLine(Memberid);
            }
            return Memberid;
        }

    }

}

