using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
    public class XIRRConfigDataContract
    {
        public int RowNumber { get; set; }
        public int XIRRConfigID { get; set; }
        public string XIRRConfigGUID { get; set; }
        public string ReturnName { get; set; }
        public string Type { get; set; }
        public string PortfolioID { get; set; }
        public string AnalysisID { get; set; }
        public string Name { get; set; }
        public DateTime? ArchiveDate { get; set; }
        public string ObjectType { get; set; }
        public string ObjectID { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public List<TagMasterXIRRDataContract> ListTagMasterXIRRData { get; set; }
        public List<TransactionTypesDataContract> ListTransactionTypesData { get; set; }

        public bool IsActive { get; set; }
        public string Status { get; set; }
        public string Comments { get; set; }
        public string ErrorDetails { get; set; }
        public int? Group1 { get; set; }
        public int? Group2 { get; set; }

        public int? ArchivalRequirement { get; set; }
        public int? UpdateXIRRLinkedDeal { get; set; }
        public int? ReferencingDealLevelReturn { get; set; }
        public string FileNameInput { get; set; }
        public string FileNameOutput { get; set; }

        public string Tags { get; set; }
        public string AnalysisName { get; set; }
        public string ArchivalRequirementText { get; set; }
        public string UpdateXIRRLinkedDealText { get; set; }

        public List<XIRRConfigFilterDataContract> ListXirrConfigFilter { get; set; }

        public List<XIRRConfigDataContract> ListXirrConfig { get; set; }
        public Boolean active { get; set; }
        public Boolean isSystemGenerated { get; set; }

        public int? CutoffRelativeDateID { get; set; }

        public DateTime? CutoffDateOverride { get; set; }
        public int? ShowReturnonDealScreen { get; set; }
        public Boolean? isAllowDelete { get; set; }
    }
    public class XIRRConfigFilterDataContract
    {
        public int? RowNumber { get; set; }
        public int? XIRRConfigID { get; set; }
        public int? XIRRFilterSetupID { get; set; }
        public string FilterName { get; set; }
        public string FilterDropDownValue { get; set; }
    }
    public class XIRRFiltersLookupDataContract
    {
        public string LookupID { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public Boolean active { get; set; }
    }
}
