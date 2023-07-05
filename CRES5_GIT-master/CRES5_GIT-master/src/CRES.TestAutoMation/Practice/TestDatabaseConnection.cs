using NUnit.Framework;
using System;
using System.Data.SqlClient;

namespace CRES.TestAutoMation.Practice
{

    class TestDatabaseConnection
    {
        [Test]
        public void dataBase()
        {
            string connetionString;
            SqlConnection cnn;
            connetionString = (@"Data Source=b0xesubcki1.database.windows.net;Initial Catalog=CRES4_QA;User ID=Cres4_qa;Password=K55/=y-}/?JheFf;");
            cnn = new SqlConnection(connetionString);
            cnn.Open();

            SqlCommand command;
            SqlDataReader dataReader;
            string sql, output = "";
            sql = "Select CreNoteID from cre.Note ";
            command = new SqlCommand(sql, cnn);
            dataReader = command.ExecuteReader();

            while (dataReader.Read())
            {
                output = output + dataReader.GetValue(0) + "\n";
            }
            Console.WriteLine(output);
        }
    }
}
