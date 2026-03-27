
CREATE procedure [dbo].[usp_OpenClosePeriodForManualTransaction] 
	@BatchLogID int,
	@UserID nvarchar(256)
AS

BEGIN

	SET NOCOUNT ON;


IF EXISTS(
	Select top 1 l.noteID from [IO].[L_M61AddinLanding] l
	Inner join cre.note n on n.crenoteid = l.NOteid
	Inner join cre.deal d on d.dealid = n.dealid
	where TableName = 'M61.Tables.ManualCashflows'  
	and l.[Status] = 'Imported'
	and BatchLogGenericID = @BatchLogID
	and d.dealid  in (Select distinct dealid from core.[period])
)
BEGIN


	Declare @CreatedBy UNIQUEIDENTIFIER;
	SEt @CreatedBy = (Select top 1 UserID from App.[User] where [login] = @UserID)

	Declare @AnalysisID UNIQUEIDENTIFIER;
	Select @AnalysisID = AnalysisID from core.Analysis where Name='Default'


	Declare @CREDealID nvarchar(256)
	Declare @ClosingDate nvarchar(256)




	IF CURSOR_STATUS('global','CursorDeal_ManualTran')>=-1
	BEGIN
		DEALLOCATE CursorDeal_ManualTran
	END

	DECLARE CursorDeal_ManualTran CURSOR 
	for
	(
		Select distinct d.credealid,MAX(n.ClosingDate) MAX_ClosingDate
		from [IO].[L_M61AddinLanding] l
		Inner join cre.note n on n.crenoteid = l.NOteid
		Inner join cre.deal d on d.dealid = n.dealid
		where TableName = 'M61.Tables.ManualCashflows'  
		and l.[Status] = 'Imported'
		and BatchLogGenericID = @BatchLogID

		and d.dealid  in (Select distinct dealid from core.[period])
		Group by d.credealid
	)
	OPEN CursorDeal_ManualTran 

	FETCH NEXT FROM CursorDeal_ManualTran
	INTO @CREDealID,@ClosingDate

	WHILE @@FETCH_STATUS = 0
	BEGIN
		print(@CREDealID)

	
	EXEC [dbo].[usp_OpenPeriod] @CREDealID,@ClosingDate,@CreatedBy,null,'Auto Open after upload manual transaction from Addin'
	EXEC [dbo].[usp_ClosePeriod] @CREDealID,@ClosingDate,@AnalysisID,@CreatedBy,null,'Auto Close after upload manual transaction from Addin'

	
					 
	FETCH NEXT FROM CursorDeal_ManualTran
	INTO @CREDealID,@ClosingDate

	END
	CLOSE CursorDeal_ManualTran   
	DEALLOCATE CursorDeal_ManualTran

END


END