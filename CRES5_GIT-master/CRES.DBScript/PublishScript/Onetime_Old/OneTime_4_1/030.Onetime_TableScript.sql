--CurrentPeriodInterestAccrualPeriodEnddate
--CurrentPeriodPIKInterestAccrualPeriodEnddate

--InterestAccrualforthePeriod
--TotalGAAPIncomeforthePeriod

--PIKInterestAccrualforthePeriod

--CurrentPeriodInterestAccrual
--CurrentPeriodPIKInterestAccrual



--View:
--PIKLoanGaap
--[vw_Recon_GaapComponents]
--[dbo].[IntegrationGAAP]
--[dbo].[NotePeriodicCalc]     
--[dbo].[NotePeriodicCalc_AccountingRecon]
--[dbo].[NotePeriodicCalc_GAAPTEst]      
--[dbo].[NotePeriodicCalc_GAAPTEst] 
--[dbo].[NotePeriodicCalc_GAAPTEst_NegativeAddtionalfee] 
--[dbo].[NotePeriodicCalc_GAAPTEst_PostiveAddtionalFees]
--[dbo].[NotePeriodicCalc_PipeLineRecon] 
--[dbo].StagingnGAAP




--------------------------------------

ALTER TABLE [CRE].[NotePeriodicCalc] add CurrentPeriodPIKInterestAccrual  DECIMAL (28, 15) NULL


ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN CurrentPeriodInterestAccrualPeriodEnddate
ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN CurrentPeriodPIKInterestAccrualPeriodEnddate
ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN InterestAccrualforthePeriod
ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN TotalGAAPIncomeforthePeriod
ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN PIKInterestAccrualforthePeriod


---dw
ALTER TABLE [DW].[L_NotePeriodicCalcBI] add CurrentPeriodPIKInterestAccrual  DECIMAL (28, 15) NULL
ALTER TABLE [DW].[L_NotePeriodicCalcBI] DROP COLUMN CurrentPeriodInterestAccrualPeriodEnddate
ALTER TABLE [DW].[L_NotePeriodicCalcBI] DROP COLUMN CurrentPeriodPIKInterestAccrualPeriodEnddate
ALTER TABLE [DW].[L_NotePeriodicCalcBI] DROP COLUMN InterestAccrualforthePeriod
ALTER TABLE [DW].[L_NotePeriodicCalcBI] DROP COLUMN TotalGAAPIncomeforthePeriod
ALTER TABLE [DW].[L_NotePeriodicCalcBI] DROP COLUMN PIKInterestAccrualforthePeriod


DROP INDEX nci_wi_NotePeriodicCalcBI_AE45FF4DA3E894C277EAA0001C711966 on [DW].[NotePeriodicCalcBI]
DROP INDEX nci_wi_NotePeriodicCalcBI_8EDCA4CF62598A3E51CC19CC20B5CD62 on [DW].[NotePeriodicCalcBI]

ALTER TABLE [DW].[NotePeriodicCalcBI] add CurrentPeriodPIKInterestAccrual  DECIMAL (28, 15) NULL
ALTER TABLE [DW].[NotePeriodicCalcBI] DROP COLUMN CurrentPeriodInterestAccrualPeriodEnddate
ALTER TABLE [DW].[NotePeriodicCalcBI] DROP COLUMN CurrentPeriodPIKInterestAccrualPeriodEnddate
ALTER TABLE [DW].[NotePeriodicCalcBI] DROP COLUMN InterestAccrualforthePeriod
ALTER TABLE [DW].[NotePeriodicCalcBI] DROP COLUMN TotalGAAPIncomeforthePeriod
ALTER TABLE [DW].[NotePeriodicCalcBI] DROP COLUMN PIKInterestAccrualforthePeriod



-----DailyGAAPBasisComponents
ALTER TABLE [CRE].[DailyGAAPBasisComponents] DROP COLUMN CurrentPeriodInterestAccrualPeriodEnddate
ALTER TABLE [CRE].[DailyGAAPBasisComponents] DROP COLUMN CurrentPeriodPIKInterestAccrualPeriodEnddate


ALTER TABLE [CRE].[DailyGAAPBasisComponents] ADD CurrentPeriodInterestAccrual   DECIMAL (28, 15) NULL
ALTER TABLE [CRE].[DailyGAAPBasisComponents] ADD CurrentPeriodPIKInterestAccrual DECIMAL (28, 15) NULL





ALTER TABLE [CRE].[NotePeriodicCalc] ADD AccPeriodEnd		Date null
ALTER TABLE [CRE].[NotePeriodicCalc] ADD AccPeriodStart		Date null
ALTER TABLE [CRE].[NotePeriodicCalc] ADD pmtdtnotadj		Date null
ALTER TABLE [CRE].[NotePeriodicCalc] ADD pmtdt				Date null
ALTER TABLE [CRE].[NotePeriodicCalc] ADD periodpikint		Decimal(28,15) null		



ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD DropDateInterestDeltaBalance		Decimal(28,15) null	
ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD AccPeriodEnd		Date null
ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD AccPeriodStart		Date null
ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD pmtdtnotadj		Date null
ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD pmtdt				Date null
ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD periodpikint		Decimal(28,15) null	