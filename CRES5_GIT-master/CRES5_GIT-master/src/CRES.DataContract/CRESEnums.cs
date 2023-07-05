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
            WFNotification
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
