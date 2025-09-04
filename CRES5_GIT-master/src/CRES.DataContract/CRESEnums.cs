using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CRES.DataContract
{
   public class CRESEnums
    {
        public enum Severity
        {
            Info,
            Warning,
            Error,
            Critical,
            Debug,
            Calculator_Info,
            Calculator_Warning
        }

        public enum Module
        {
            Deal,
            Note,
            Calculator,
            WellsExtract,
            VSTO,
            AccountingReport,
            AccountingReportHistory,
            TransactionReconciliation,
            FileUpload,
            ServicerFileImport,
            CashFlowDownload,
            Account,
            CalculationManager,
            System,
            ExportFutureFunding,
            AI_Assistant,
            GenericScheduler,
            DrawFee,
            DealSave,
            WFNotification,
            Automation,
            GenerateAutomation,
            ValuationModule,
            DailyRatePull,            
            ServicingWatchlist,
            ValuationModuleAutoMation,
            ValuationServer,
            Equity,
            EquityCalculator,
            JournalEntry,
            LiabilityNote,
            Debt,
            XIRRDownload,
            XIRRCalculator,
            XIRR,
            DeleteBlobFile,
            V1Calculator,
            LiabiltyFeeInterestCalculator,
            PrepaymentCalculator,
            TransactionReconciliationLiability,
        }

        public enum Priority
        {
            High,
            Low,
            Medium,
            Fatal,
        }


    }
}
