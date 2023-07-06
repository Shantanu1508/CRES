
CREATE PROCEDURE [DW].[usp_ImportInterestCalculator]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_InterestCalculatorBI',GETDATE())

		DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


	Truncate table [DW].[L_InterestCalculatorBI]

	INSERT INTO [DW].[L_InterestCalculatorBI]	
           ([InterestCalculatorID]
		   ,[InterestCalculatorAutoID]
           ,[NoteID]
           ,[CRENoteID]
           ,[AccrualStartDate]
           ,[AccrualEndDate]
           ,[PaymentDate]
           ,[BeginningBalance]
           ,[AnalysisID]
           ,[LIBOR]
           ,[Spread]
           ,[AllInOnecoupon]
           ,[EndingBalance]
           ,[Repayment]
           ,[Funding]
           ,[ScheduledPrincipal]
           ,[PikInterest]
           ,[InterestExcludePrepayDate]
           ,[InterestFullAccrual]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])	
SELECT 
[InterestCalculatorID]
,icalc.[InterestCalculatorAutoID]
,icalc.[NoteID]
,n.[CRENoteID]
,icalc.[AccrualStartDate]
,icalc.[AccrualEndDate]
,icalc.[PaymentDate]
,icalc.[BeginningBalance]
,icalc.[AnalysisID]
,null as [LIBOR]
,null as [Spread]
,null as [AllInOnecoupon]
,null as [EndingBalance]
,null as [Repayment]
,null as [Funding]
,null as [ScheduledPrincipal]
,null as [PikInterest]
,null as [InterestExcludePrepayDate]
,null as [InterestFullAccrual]
,icalc.[CreatedBy]
,icalc.[CreatedDate]
,icalc.[UpdatedBy]
,icalc.[UpdatedDate]
FROM [cre].[InterestCalculator] icalc
inner join cre.note n on n.NoteID = icalc.NoteID
Where icalc.InterestCalculatorAutoID > (Select ISNULL(MAX(InterestCalculatorAutoID),0) from [DW].[InterestCalculatorBI])



SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportInterestCalculator - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	UPDATE [DW].BatchDetail
	SET
	LandingEndTime = GETDATE(),
	LandingRecordCount = @RowCount
	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


