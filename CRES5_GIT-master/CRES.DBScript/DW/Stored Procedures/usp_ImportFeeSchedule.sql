
CREATE PROCEDURE [DW].[usp_ImportFeeSchedule]
	
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int


	Truncate table [DW].[FeeScheduleBI]

	INSERT INTO [DW].[FeeScheduleBI]
           ([dealid]
           ,[NoteID]
           ,[CREDealID]
           ,[crenoteid]
           ,[EffectiveDate]
           ,[FeeName]
           ,[StartDate]
           ,[EndDate]
           ,[FeeType]
           ,[Value]
           ,[FeeAmountOverride]
           ,[BaseAmountOverride]
           ,[ApplyTrueUpFeature]
           ,[IncludedLevelYield]
           ,[FeetobeStripped])


	Select 
	d.dealid
	,nn.NoteID
	,d.CREDealID
	,nn.crenoteid
	,e.EffectiveStartDate as EffectiveDate
	,pafs.FeeName
	,pafs.[StartDate] as [StartDate]
	,pafs.EndDate as [EndDate]
	,LValueTypeID.FeeTypeNameText as FeeType
	,pafs.[Value] as [Value]
	,pafs.FeeAmountOverride
	,pafs.BaseAmountOverride
	,LApplyTrueUpFeature.[Name] as ApplyTrueUpFeature
	,pafs.[IncludedLevelYield]
	,pafs.FeetobeStripped
	from [CORE].PrepayAndAdditionalFeeSchedule pafs
	INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId
	LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID
	LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = pafs.ApplyTrueUpFeature
	INNER JOIN 
				(
						
					Select 
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PrepayAndAdditionalFeeSchedule')
						and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
						and acc.IsDeleted = 0
						GROUP BY n.Account_AccountID,EventTypeID

				) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	left join cre.note nn on nn.account_accountid = e.accountid 
	left join cre.Deal d on d.dealid = nn.DealID

	where e.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)








	SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportFeeSchedule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


