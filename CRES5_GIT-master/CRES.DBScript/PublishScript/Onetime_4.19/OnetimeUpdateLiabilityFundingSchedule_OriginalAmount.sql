UPDATE [CRE].[LiabilityFundingSchedule] SET OriginalAmount = TransactionAmount;
UPDATE [CRE].[LiabilityFundingScheduleAggregate] SET OriginalAmount = TransactionAmount;
UPDATE [CRE].[LiabilityFundingScheduleDeal] SET OriginalAmount = TransactionAmount;