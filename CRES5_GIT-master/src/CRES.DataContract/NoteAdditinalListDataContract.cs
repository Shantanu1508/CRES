using System;
using System.Collections.Generic;

namespace CRES.DataContract
{
    public class NoteAdditinalListDataContract
    {
        public string NoteId { get; set; }
        public int? ModuleId { get; set; }
        public Guid? SourceAccountID { get; set; }
        public string SourceAccount { get; set; }
        public Guid? TargetAccountID { get; set; }
        public string TargetAccount { get; set; }

        public List<MaturityScenariosDataContract> MaturityScenariosList { get; set; }

        public List<MaturityScenariosDataContract> lstMaturity { get; set; }

        public NoteDataContract noteobj { get; set; }

        public List<RateSpreadSchedule> RateSpreadScheduleList { get; set; }
        public List<PrepayAndAdditionalFeeScheduleDataContract> NotePrepayAndAdditionalFeeScheduleList { get; set; }
        public List<FinancingFeeScheduleDataContract> lstFinancingFeeSchedule { get; set; }
        public List<StrippingScheduleDataContract> NoteStrippingList { get; set; }
        public List<FinancingScheduleDataContract> NoteFinancingScheduleList { get; set; }
        public List<DefaultScheduleDataContract> NoteDefaultScheduleList { get; set; }
        public List<NoteServicingFeeScheduleDataContract> NoteServicingFeeScheduleList { get; set; }
        public List<PIKSchedule> NotePIKScheduleList { get; set; }
        public List<FutureFundingScheduleTab> ListFutureFundingScheduleTab { get; set; }
        public List<FixedAmortScheduleTab> ListFixedAmortScheduleTab { get; set; }
        public List<LiborScheduleTab> ListLiborScheduleTab { get; set; }
        public List<PIKfromPIKSourceNoteTab> ListPIKfromPIKSourceNoteTab { get; set; }
        public List<FeeCouponStripReceivableTab> ListFeeCouponStripReceivable { get; set; }
        public List<NoteServicingLogDataContract> lstNoteServicingLog { get; set; }




        //public List<MaturityScenariosDataContract> lstMaturity { get; set; }

        //public NoteDataContract noteobj { get; set; }

        //public List<RateSpreadSchedule> lstRateSpreadSchedule { get; set; }
        //public List<PrepayAndAdditionalFeeScheduleDataContract> lstNotePrepayFeeSchedule { get; set; }
        //public List<FinancingFeeScheduleDataContract> lstFinancingFeeSchedule { get; set; }
        //public List<StrippingScheduleDataContract> lstStrippingSchedule { get; set; }
        //public List<FinancingScheduleDataContract> lstFinancingSchedule { get; set; }
        //public List<DefaultScheduleDataContract> lstDefaultSchedule { get; set; }
        //public List<NoteServicingFeeScheduleDataContract> lstServicingFeeSchedule { get; set; }
        //public List<PIKSchedule> lstPIKSchedule { get; set; }
        //public List<FutureFundingScheduleTab> lstFutureFundingScheduleTab { get; set; }
        //public List<FixedAmortScheduleTab> lstFixedAmortScheduleTab { get; set; }
        //public List<LiborScheduleTab> lstLaborScheduleTab { get; set; }
        //public List<PIKfromPIKSourceNoteTab> lstPIKDetailScheduleTab { get; set; }
        //public List<FeeCouponStripReceivableTab> lstFeeCouponStripReceivableTab { get; set; }

        //public List<NoteServicingLogDataContract> lstNoteServicingLog { get; set; }

        public List<HistoricalAccrualDataContract> lstHistAccrual { get; set; }

        public List<ServicerDropDateSetup> lstServicerDropDateSetup { get; set; }
        public string noteValue { get; set; }

        public string ParentNoteID { get; set; }

        public List<NoteMarketPriceDataContract> deleteMarketPriceList { get; set; }

    }
}
