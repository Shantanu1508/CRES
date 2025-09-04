
--ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN CapitalizedCostYield
--ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN CapitalizedCostBasis
--ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN cum_am_capcosts
--ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN YieldDiscount
--ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN BasisDiscount
--ALTER TABLE [CRE].[NotePeriodicCalc] DROP COLUMN cum_am_disc

--ALTER TABLE [CRE].[NotePeriodicCalc] ADD DeferredFeeGAAPBasis   decimal(28,15) null 
--ALTER TABLE [CRE].[NotePeriodicCalc] ADD CapitalizedCostLevelYield        decimal(28,15) null
--ALTER TABLE [CRE].[NotePeriodicCalc] ADD CapitalizedCostGAAPBasis		 decimal(28,15) null
--ALTER TABLE [CRE].[NotePeriodicCalc] ADD CapitalizedCostAccumulatedAmort	 decimal(28,15) null
--ALTER TABLE [CRE].[NotePeriodicCalc] ADD DiscountPremiumLevelYield		 decimal(28,15) null
--ALTER TABLE [CRE].[NotePeriodicCalc] ADD DiscountPremiumGAAPBasis		 decimal(28,15) null
--ALTER TABLE [CRE].[NotePeriodicCalc] ADD DiscountPremiumAccumulatedAmort	 decimal(28,15) null


--ALTER TABLE [Core].[AccountingClosePeriodicArchive] DROP COLUMN CapitalizedCostYield
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] DROP COLUMN CapitalizedCostBasis
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] DROP COLUMN cum_am_capcosts
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] DROP COLUMN YieldDiscount
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] DROP COLUMN BasisDiscount
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] DROP COLUMN cum_am_disc


--ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD DeferredFeeGAAPBasis   decimal(28,15) null 
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD CapitalizedCostLevelYield        decimal(28,15) null
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD CapitalizedCostGAAPBasis		 decimal(28,15) null
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD CapitalizedCostAccumulatedAmort	 decimal(28,15) null
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD DiscountPremiumLevelYield		 decimal(28,15) null
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD DiscountPremiumGAAPBasis		 decimal(28,15) null
--ALTER TABLE [Core].[AccountingClosePeriodicArchive] ADD DiscountPremiumAccumulatedAmort	 decimal(28,15) null


