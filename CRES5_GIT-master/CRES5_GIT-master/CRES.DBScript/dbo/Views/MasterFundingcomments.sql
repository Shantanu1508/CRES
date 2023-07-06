CREATE View [dbo].[MasterFundingcomments]
AS
Select * from
(

Select Distinct CASE WHEN  COmment IS NULL OR COmment = '' THEN 'None' Else COmment END as Comment  from [dbo].[DealFundingSchedule]


)x





