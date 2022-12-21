CREATE view [dbo].[WireconfirmMaster]
As
Select  DISTINCT ISNULL( WIRECONFIRM,0) WireConfirm from [dbo].[NoteFundingSchedule]



