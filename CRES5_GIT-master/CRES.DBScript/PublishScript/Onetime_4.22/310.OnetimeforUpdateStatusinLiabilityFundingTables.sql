-- For updating status column in all liability funding tables

Update [CRE].[LiabilityFundingScheduleDeal] 
SET [Status] = 944
where Applied = 1
 
Update [CRE].[LiabilityFundingScheduleAggregate]
SET [Status] = 944
where Applied = 1
 
Update [CRE].[LiabilityFundingSchedule]
SET [Status] = 944
where Applied = 1