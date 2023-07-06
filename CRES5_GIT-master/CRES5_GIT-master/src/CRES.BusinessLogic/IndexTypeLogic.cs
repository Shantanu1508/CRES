using CRES.DAL.Helper;
using CRES.DAL.Repository;
using CRES.DataContract;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace CRES.BusinessLogic
{
    public class IndexTypeLogic
    {
        IndexTypeRepository indexTypeRepository = new IndexTypeRepository();

        public DataTable GetIndexTypeByDate(IndexTypeDataContract indextypeDc)
        {
            return indexTypeRepository.getIndextypeByDate(indextypeDc);
        }

        public int AddUpdateIndexes(DataTable indextypedt, string CreatedBy, string UpdatedBy)
        {
            List<IndexTypeDataContract> lstindexes = new List<IndexTypeDataContract>();
            DataTable dtindexes = new DataTable();

            Helper hp = new Helper();
            if (indextypedt != null)
            {
                foreach (DataRow dr in indextypedt.Rows)
                {
                    int colCount = 0;

                    int lastcol = indextypedt.Columns.Count - 1;
                    foreach (DataColumn dc in indextypedt.Columns)
                    {
                        if (colCount > 0 && colCount < lastcol)
                        {
                            if (!DBNull.Value.Equals(dr[colCount]))
                            {
                                IndexTypeDataContract index = new IndexTypeDataContract();
                                index.Date = Convert.ToDateTime(dr[0].ToString());
                                index.Name = (dc.ColumnName);
#pragma warning disable CS0252 // Possible unintended reference comparison; to get a value comparison, cast the left hand side to type 'string'
                                if (dr[colCount] == "" || dr[colCount] == null)
                                {
                                    dr[colCount] = 0;
                                }
#pragma warning restore CS0252 // Possible unintended reference comparison; to get a value comparison, cast the left hand side to type 'string'
                                index.Value = Convert.ToDecimal(dr[colCount]);
                                index.AnalysisID = dr[lastcol].ToString();

                                lstindexes.Add(index);
                            }
                        }
                        colCount++;
                    }
                }

                DataTable dt = hp.ToDataTable(lstindexes);

                dtindexes.Columns.Add("Date");
                dtindexes.Columns.Add("Name");
                dtindexes.Columns.Add("Value");
                dtindexes.Columns.Add("AnalysisID");


                foreach (DataRow dr in dt.Rows)
                {
                    dtindexes.ImportRow(dr);
                }

            }

            return indexTypeRepository.AddUpdateIndexes(dtindexes, CreatedBy, UpdatedBy);
        }

        //
        public int AddUpdateIndexList(DataTable indextypedt, string CreatedBy, string UpdatedBy)
        {
            List<IndexTypeDataContract> lstindexes = new List<IndexTypeDataContract>();
            DataTable dtindexes = new DataTable();

            Helper hp = new Helper();
            if (indextypedt != null)
            {
                foreach (DataRow dr in indextypedt.Rows)
                {
                    int colCount = 0;

                    int lastcol = indextypedt.Columns.Count - 1;
                    foreach (DataColumn dc in indextypedt.Columns)
                    {
                        if (colCount > 0 && colCount < lastcol)
                        {
                            // if (!DBNull.Value.Equals(dr[colCount]))
                            if (!String.IsNullOrWhiteSpace(dr[colCount].ToString()))
                            {
                                IndexTypeDataContract index = new IndexTypeDataContract();
                                index.Date = Convert.ToDateTime(dr[0].ToString());
                                index.Name = (dc.ColumnName);
#pragma warning disable CS0252 // Possible unintended reference comparison; to get a value comparison, cast the left hand side to type 'string'
                                if (dr[colCount] == "" || dr[colCount] == null)
                                {
                                    dr[colCount] = 0;
                                }
#pragma warning restore CS0252 // Possible unintended reference comparison; to get a value comparison, cast the left hand side to type 'string'
                                index.Value = Convert.ToDecimal(dr[colCount]);
                                index.IndexesMasterGuid = new Guid(dr[lastcol].ToString());

                                lstindexes.Add(index);
                            }
                        }
                        colCount++;
                    }
                }

                DataTable dt = hp.ToDataTable(lstindexes);

                dtindexes.Columns.Add("Date", typeof(System.DateTime));
                dtindexes.Columns.Add("Name");
                dtindexes.Columns.Add("Value");
                dtindexes.Columns.Add("IndexesMasterGuid");


                foreach (DataRow dr in dt.Rows)
                {
                    dtindexes.ImportRow(dr);
                }

            }

            return indexTypeRepository.AddUpdateIndexList(dtindexes, CreatedBy, UpdatedBy);
        }


        public IndexesMasterDataContract GetIndexesMasterDetailByIndexesMaster(Guid indexesMasterGuid, string userID)
        {
            return indexTypeRepository.GetIndexesMasterDetailByIndexesMaster(indexesMasterGuid, userID);
        }

        public string InsertUpdateIndexesMasterDetail(IndexesMasterDataContract _indexesMasterDC)
        {
            return indexTypeRepository.InsertUpdateIndexesMasterDetail(_indexesMasterDC);
        }



        public List<IndexesMasterDataContract> GetIndexesFromIndexesMaster()
        {
            List<IndexesMasterDataContract> lstIndexes = new List<IndexesMasterDataContract>();
            lstIndexes = indexTypeRepository.GetIndexesFromIndexesMaster();
            return lstIndexes;
        }

        public List<IndexesMasterDataContract> GetAllIndexesMaster(Guid? userId, int? pageSize, int? pageIndex, out int? TotalCount)
        {
            List<IndexesMasterDataContract> lstIndexesMaster = new List<IndexesMasterDataContract>();
            lstIndexesMaster = indexTypeRepository.GetAllIndexesMaster(userId, pageSize, pageIndex, out TotalCount).ToList();
            return lstIndexesMaster;
        }

        public bool CheckDuplicateIndexesName(string indexesMasterGuid, string indexesName)
        {
            return indexTypeRepository.CheckDuplicateIndexesName(indexesMasterGuid, indexesName);
        }

        public DataTable GetIndexesExportDataByIndexesMasterID(IndexesMasterSearchDataContract _indexesMasterDC, string headerUserID, out int? TotalCount)
        {
            return indexTypeRepository.GetIndexesExportDataByIndexesMasterID(_indexesMasterDC, headerUserID, out TotalCount);
        }

        public DataTable GetIndexListByIndexesMasterID(string headerUserID, string indexesMasterGuid, int? pageIndex, int? pageSize, out int? TotalCount)
        {
            return indexTypeRepository.GetIndexListByIndexesMasterID(headerUserID, indexesMasterGuid, pageIndex, pageSize, out TotalCount);
        }

        public DataTable GetIndexListByDates(IndexesMasterSearchDataContract _indexesMasterSearchDC, string headerUserID, out int? TotalCount)
        {
            return indexTypeRepository.GetIndexListByDates(_indexesMasterSearchDC, headerUserID, out TotalCount);
        }

        public void ImportIndexes(Guid? userId, IndexesMasterDataContract _indexesDC)
        {
            indexTypeRepository.ImportIndexes(userId, _indexesDC);
        }

        public int InsertIndexTypeOutputJsonInfo(string IndexName, DataTable dtjsonresult, Guid? UserID)
        {
            return indexTypeRepository.InsertIndexTypeOutputJsonInfo(IndexName, dtjsonresult, UserID);
        }
    }
}







