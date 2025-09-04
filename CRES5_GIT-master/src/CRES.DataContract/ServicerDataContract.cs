using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace CRES.DataContract
{
   public class ServicerDataContract
    {
        public int? ServicerMasterID { get; set; }
        public string SericerName { get; set; }
        public int? Status { get; set; }
        public string ServicerDisplayName { get; set; }
        public string ServicerNamecss { get; set; }
        public DateTime? CloseDate { get; set; }
        public string ServicerFile { get; set; }
        public string DownloadFileName { get; set; }
        public int? ServicerDropDate { get; set; }
        public int? RepaymentDropDate { get; set; }
    }



    public class JsonFileConfiguration
    {
        public string SheetName { get; set; }
        public string LandingTableName { get; set; }
        public string ImportProcedureName { get; set; }
        public int? HeaderPosition { get; set; }
        public bool? Check2BlankRow { get; set; }
        //  public string RemoveBlankRow { get; set; }
        public List<JsonColumnsConfiguration> MappingColumns { get; set; }
        public string ReconType { get; set; }
        
    }


    public class JsonColumnsConfiguration
    {
        public string SheetColumnName { get; set; }
        public string SheetColumnDataType { get; set; }
        public string LandingColumnName { get; set; }
        public string IsMandatoryColumn { get; set; }
        public string IsMandatoryValue { get; set; }      

    }
    public class JsonTemplate
    {
        public int? JsonTemplateID { get; set; }
        public string keyname { get; set; }
        public string Value { get; set; }
        public string Type { get; set; }
        public string JsonTemplateName { get; set; }
    }

    public class TemplateNameDc
    {
        public int? JsonTemplateMasterID { get; set; }
        public string TemplateName { get; set; }
        public string NewTemplateName { get; set; }
     
    }
}
