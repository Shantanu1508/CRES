using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Reflection;

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
    }
}
