

CREATE PROCEDURE [DW].[usp_MergePrepayAndAdditionalFeeSchedule]
@BatchLogId int
AS
BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


UPDATE [DW].BatchDetail
SET
BITableName = 'PrepayAndAdditionalFeeScheduleBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_PrepayAndAdditionalFeeScheduleBI'


Truncate table [DW].[PrepayAndAdditionalFeeScheduleBI]
	
INSERT INTO [DW].[PrepayAndAdditionalFeeScheduleBI]
(
	PrepayAndAdditionalFeeScheduleID
	,DealID
	,NoteID
	,DealName
	,CREDealID
	,CRENoteID
	,NoteName
	,EffectiveDate
	,StartDate
	,EndDate
	,[Value]
	,IncludedLevelYield
	,ValueTypeID
	,ValueTypeText
	,FeeName
	,FeeAmountOverride
	,BaseAmountOverride
	,ApplyTrueUpFeature
	,ApplyTrueUpFeatureText
	,FeetobeStripped
	,FinancingSourceName
	,ScheduleText
	,[CreatedBy]  
	,[CreatedDate]
	,[UpdatedBy]  
	,[UpdatedDate]
)
Select PrepayAndAdditionalFeeScheduleID
,d.DealID
,n.NoteID
,d.DealName
,d.CREDealID
,n.CRENoteID
,acc.name as NoteName
,e.EffectiveStartDate as EffectiveDate  
,pafs.[StartDate]   
,pafs.EndDate   
,ISNULL(pafs.[Value],0) as [Value]  
,ISNULL(pafs.[IncludedLevelYield],0) as [IncludedLevelYield]
,pafs.[ValueTypeID] as [ValueTypeID]  
,LValueTypeID.FeeTypeNameText as [ValueTypeText]  
,pafs.FeeName  
,pafs.FeeAmountOverride  
,pafs.BaseAmountOverride  
,pafs.ApplyTrueUpFeature  
,LApplyTrueUpFeature.[Name] as ApplyTrueUpFeatureText  
,ISNULL(pafs.FeetobeStripped,0) as  FeetobeStripped 
,fn.FinancingSourceName
,(CASE WHEN e.EffectiveStartDate = tblLatest.EffectiveStartDate THEN 'Latest Schedule' ELSE 'History Schedule' END) as ScheduleText
,pafs.[CreatedBy]  
,pafs.[CreatedDate]
,pafs.[UpdatedBy]  
,pafs.[UpdatedDate]

from [CORE].PrepayAndAdditionalFeeSchedule pafs  
INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId  
LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID  
LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
Inner Join cre.deal d on d.dealid = n.dealid
Left join cre.FinancingSourcemaster fn on fn.FinancingSourcemasterID = n.FinancingSourceID	

Left Join(
	Select 
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')
	and eve.StatusID = 1
	and acc.IsDeleted = 0
	GROUP BY n.Account_AccountID,EventTypeID
)tblLatest on tblLatest.accountid = n.account_accountid

where e.StatusID = 1
and acc.IsDeleted <> 1



DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT



UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_PrepayAndAdditionalFeeScheduleBI'

Print(char(9) +'usp_MergePrepayAndAdditionalFeeSchedule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));



SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END

