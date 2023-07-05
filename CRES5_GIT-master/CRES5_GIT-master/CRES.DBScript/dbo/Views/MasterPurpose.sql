CREATE View [dbo].[MasterPurpose]
as Select * from 
(
Select Distinct Purpose from [dbo].[NoteFundingSchedule]
where Purpose is not nULL
Union
Select Distinct Purpose_calculated from 
[dbo].[Staging_NoteFunding]
where Purpose_calculated is not nULL
 )X

