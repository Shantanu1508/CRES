Create View [dbo].[MasterPurposeComments]
as Select * from 
(
Select Distinct (Purpose + Comments) MAsterPurposecomments from [dbo].[NoteFundingSchedule]
where Purpose is not nULL
Union
Select Distinct (Purpose_calculated)MAsterPurposecomments from 
[dbo].[Staging_NoteFunding]
where Purpose_calculated is not nULL
 )X
