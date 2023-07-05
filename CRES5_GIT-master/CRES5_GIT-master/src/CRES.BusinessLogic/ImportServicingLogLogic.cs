using CRES.DAL.Repository;
using System.Data;

namespace CRES.BusinessLogic
{
    public class ImportServicingLogLogic
    {
        ImportServicingLogRepository _importServicinglog = new ImportServicingLogRepository();

        public int ImportIntoINServicingTransaction(DataTable dt, string userId, string sourceBlobFileName, string fileDisplayName, string storagetype, string _startdate, string _enddate)
        {
            return _importServicinglog.ImportIntoINServicingTransaction(dt, userId, sourceBlobFileName, fileDisplayName, storagetype, _startdate, _enddate);
        }



        //protected void ImportCSV(object sender, EventArgs e)
        //{
        //    //Upload and save the file
        //    string csvPath = Server.MapPath("~/Files/") + Path.GetFileName(FileUpload1.PostedFile.FileName);
        //    FileUpload1.SaveAs(csvPath);

        //    //Create a DataTable.
        //    DataTable dt = new DataTable();
        //    dt.Columns.AddRange(new DataColumn[3] { new DataColumn("Id", typeof(int)),
        //new DataColumn("Name", typeof(string)),
        //new DataColumn("Country",typeof(string)) });

        //    //Read the contents of CSV file.
        //    string csvData = File.ReadAllText(csvPath);

        //    //Execute a loop over the rows.
        //    foreach (string row in csvData.Split('\n'))
        //    {
        //        if (!string.IsNullOrEmpty(row))
        //        {
        //            dt.Rows.Add();
        //            int i = 0;

        //            //Execute a loop over the columns.
        //            foreach (string cell in row.Split(','))
        //            {
        //                dt.Rows[dt.Rows.Count - 1][i] = cell;
        //                i++;
        //            }
        //        }
        //    }

        //    //Bind the DataTable.
        //    GridView1.DataSource = dt;
        //    GridView1.DataBind();
        //}


    }
}
