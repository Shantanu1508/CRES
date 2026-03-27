using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using System.Dynamic;
using System.Data;
using System.IO;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;

namespace CRES.Utilities
{
    public static class ObjToCsv
    {
        /// <summary>
        /// Using a bit of reflection to build up the strings.
        /// </summary>
        public static string ToCsvHeader(this object obj)
        {
            Type type = obj.GetType();
            var properties = type.GetProperties(BindingFlags.DeclaredOnly |
                                           BindingFlags.Public |
                                           BindingFlags.Instance);

            string result = string.Empty;
            Array.ForEach(properties, prop =>
            {
                result += prop.Name + ",";
            });

            return (!string.IsNullOrEmpty(result) ? result.Substring(0, result.Length - 1) : result);
        }

        public static string ToCsvRow(this object obj)
        {
            Type type = obj.GetType();
            var properties = type.GetProperties(BindingFlags.DeclaredOnly |
                                           BindingFlags.Public |
                                           BindingFlags.Instance);

            string result = string.Empty;
            Array.ForEach(properties, prop =>
            {
                var value = prop.GetValue(obj, null);
                var propertyType = prop.PropertyType.FullName;
                if (propertyType == "System.String")
                {
                    // wrap value incase of commas
                    value = "\"" + value + "\"";
                }

                result += value + ",";

            });

            return (!string.IsNullOrEmpty(result) ? result.Substring(0, result.Length - 1) : result);
        }

        public static string ToCsv<T>(this List<T> obj, string path = null)
        {
            try
            {
                string output;
                if (obj.Count == 0)
                {
                    output = "List is empty.";
                }
                else
                {
                    output = obj[0].ToCsvHeader();
                    output += Environment.NewLine;

                    obj.ForEach(x =>
                    {
                        output += x.ToCsvRow();
                        output += Environment.NewLine;
                    });
                }

                if (path != null && path != "")
                    System.IO.File.WriteAllText(path, output);

                return output;
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to serialize to Csv.", ex);
            }
        }

        public static dynamic DictionaryToObject(IDictionary<String, Object> dictionary)
        {
            var expandoObj = new ExpandoObject();
            var expandoObjCollection = (ICollection<KeyValuePair<String, Object>>)expandoObj;

            foreach (var keyValuePair in dictionary)
            {
                expandoObjCollection.Add(keyValuePair);
            }
            dynamic eoDynamic = expandoObj;
            return eoDynamic;
        }

        public static T DictionaryToObject<T>(IDictionary<String, Object> dictionary) where T : class
        {
            return DictionaryToObject(dictionary) as T;
        }

        public static void CreateCSVFile(System.Data.DataTable dt, string csvname, string path = "")
        {
            try
            {
                if (path == "")
                {
                    path = @"C:\temp";
                }
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                string strFilePath = "C:\\temp\\" + csvname + ".csv";

                StreamWriter sw = new StreamWriter(strFilePath, false);
                int columnCount = dt.Columns.Count;

                for (int i = 0; i < columnCount; i++)
                {
                    sw.Write(dt.Columns[i]);

                    if (i < columnCount - 1)
                    {
                        sw.Write(",");
                    }
                }

                sw.Write(sw.NewLine);

                foreach (DataRow dr in dt.Rows)
                {
                    for (int i = 0; i < columnCount; i++)
                    {
                        if (!Convert.IsDBNull(dr[i]))
                        {
                            sw.Write(dr[i].ToString());
                        }

                        if (i < columnCount - 1)
                        {
                            sw.Write(",");
                        }
                    }

                    sw.Write(sw.NewLine);
                }

                sw.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        
        public static DataSet ToDataSet<T>(IEnumerable<T> list)
        {
            Type elementType = typeof(T);
            DataSet ds = new DataSet();
            System.Data.DataTable t = new System.Data.DataTable();
            ds.Tables.Add(t);

            //add a column to table for each public property on T
            foreach (var propInfo in elementType.GetProperties())
            {
                t.Columns.Add(propInfo.Name);
            }

            //go through each property on T and add each value to the table
            foreach (T item in list)
            {
                DataRow row = t.NewRow();
                foreach (var propInfo in elementType.GetProperties())
                {
                    row[propInfo.Name] = propInfo.GetValue(item, null);
                }

                //This line was missing:
                t.Rows.Add(row);
            }

            return ds;
        }
    }
}
