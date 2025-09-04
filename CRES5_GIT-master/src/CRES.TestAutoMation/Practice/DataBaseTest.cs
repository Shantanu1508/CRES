using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace CRES.TestAutoMation.Practice
{
    internal class DataBaseTest
    {

        static SqlConnection con;
        static SqlDataReader dr;
        static SqlCommand cmd;
        static String connectionString;
            

        [Test]
        public void DBConnect()
        {
            //ConnectionStringSettings connection = ConfigurationManager.ConnectionStrings["CRES4_QA"];
            

            try
            {                

                // 1. Address of SQL server and database 
                connectionString = @"Data Source=tcp:b0xesubcki1.database.windows.net,1433;Persist Security Info=True;User ID=Cres4_qa;Password=K55/=y-}/?JheFf;Initial Catalog=CRES4_QA";

                // 2. Stablish connection 

                con = new SqlConnection(connectionString);

                con.Open();


                cmd = new SqlCommand("Select Distinct top 10 dealname,credealid \r\nfrom cre.deal d\r\ninner join cre.note n on n.dealid = d.dealid\r\ninner join core.account acc on acc.accountid = n.account_accountid\r\nWhere d.isdeleted <> 1 and acc.isdeleted <> 1\r\nand d.status = 323\r\nand EnableAutoSpreadRepayments = 1", con);

             // cmd = new SqlCommand("Select Distinct top 10 dealname,credealid \r\nfrom cre.deal d\r\ninner join cre.note n on n.dealid = d.dealid\r\ninner join core.account acc on acc.accountid = n.account_accountid\r\nWhere d.isdeleted <> 1 and acc.isdeleted <> 1\r\nand d.status = 323\r\nand EnableAutoSpreadRepayments = 1", con);                

                dr = cmd.ExecuteReader();

                
                while (dr.Read())
                {
                    string DealId = dr["credealid"].ToString();
                    
                    string DealName = dr["dealname"].ToString();

                    Console.WriteLine("Deal Id = " + DealId + "   ---   Deal Name = " + DealName);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Error" + e.Message);
            }
            finally
            {
                con.Close();
            }
        }
    }
}

