CREATE Procedure [dbo].[usp_GetNoteOutputNPVdataByNoteId] --'629A3892-863B-4313-8CCC-70205B36B9F6'
(
 @NoteId uniqueidentifier
)
as 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT [OutputNPVdataID]
      ,outnpv.[NoteID]
      ,[NPVdate]
      ,[CashFlowUsedForLevelYieldPrecap]
	  ,[CashFlowUsedForLevelYieldAmort]
	  ,[CashFlowAdjustedForServicingInfo]
	  ,[TotalStrippedCashFlow]
      ,outnpv.[CreatedBy]
      ,outnpv.[CreatedDate]
      ,outnpv.[UpdatedBy]
      ,outnpv.[UpdatedDate]
  FROM [CRE].[OutputNPVdata] outnpv
  left join cre.note n on n.NoteID = outnpv.NoteID
  inner join core.Account acc on acc.AccountID = n.Account_AccountID
	where outnpv.NoteID = @NoteId and acc.IsDeleted = 0
	ORDER BY [NPVdate]
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
