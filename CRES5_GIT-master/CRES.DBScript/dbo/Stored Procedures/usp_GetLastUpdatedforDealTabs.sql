-- Procedure
-- Procedure
CREATE PROCEDURE [dbo].[usp_GetLastUpdatedforDealTabs]
    @DealID uniqueidentifier,
	@UserID uniqueidentifier

AS
BEGIN
	SET NOCOUNT ON;
	
Declare @l_getdate datetime = [dbo].[ufn_GetTimeByTimeZone](GETDATE(), @UserID);

DECLARE @DealAccountId UNIQUEIDENTIFIER;

SELECT @DealAccountId = AccountID FROM cre.Deal WHERE DealID = @DealID;

SELECT 
z.HTMLTagID,
z.UpdatedDate,
IIF(z.[year] > 0,CAST(z.[year] as nvarchar(5))+'y ago',
  IIF(z.[month] > 0,CAST(z.[month] as nvarchar(5))+'mo ago',
	IIF(z.[week] > 0,CAST(z.[week] as nvarchar(5))+'w ago',
		IIF(z.[day] > 0,CAST(z.[day] as nvarchar(5))+'d ago',
			IIF(z.[hour] > 0,CAST(z.[hour] as nvarchar(5))+'h ago',
				IIF(z.[minute] > 0,CAST(z.[minute] as nvarchar(5))+'m ago',
				IIF(z.[minute] < 1,CAST(1 as nvarchar(5))+'m ago','-')
				)
			)
		)
	)
  )
)AS TimeAgo
From(
	Select a.HTMLTagID
	,a.UpdatedDate
	,datediff(minute,[dbo].[ufn_GetTimeByTimeZone](UpdatedDate, @UserID),@l_getdate) / (24*365*60) as [Year]
	,datediff(minute,[dbo].[ufn_GetTimeByTimeZone](UpdatedDate, @UserID),@l_getdate) / (24*30*60) as [Month]
	,datediff(minute,[dbo].[ufn_GetTimeByTimeZone](UpdatedDate, @UserID),@l_getdate) / (24*7*60) as [Week]
	,datediff(minute,[dbo].[ufn_GetTimeByTimeZone](UpdatedDate, @UserID),@l_getdate) / (24*60) as [Day]
	,datediff(minute,[dbo].[ufn_GetTimeByTimeZone](UpdatedDate, @UserID),@l_getdate) / 60 as [Hour]
	,datediff(minute,[dbo].[ufn_GetTimeByTimeZone](UpdatedDate, @UserID),@l_getdate) as [Minute]
	FROM ( 		 
	    SELECT 'aMain' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.Deal where dealid = @DealID
		UNION
		SELECT 'aFunding' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.DealFunding where dealid = @DealID
		UNION
		SELECT 'aLiability' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.LiabilityNote where DealAccountID = @DealAccountId
		UNION
		SELECT 'aAdjustedTotalCommitment' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.NoteAdjustedCommitmentDetail where dealid = @DealID
		UNION
		SELECT 'aReservetab' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.ReserveAccount where dealid = @DealID
		UNION
		SELECT 'aFeeInvoicetab' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.InvoiceDetail where dealid = @DealID
		UNION
		SELECT 'aNotepayrule' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.PayruleSetup where dealid = @DealID
		UNION
		SELECT 'aMaturitytab' AS HTMLTagID,MAX(m.UpdatedDate) UpdatedDate FROM core.Maturity m  
				Inner Join core.Event e on e.EventID = m.EventId
				Inner Join core.Account a on a.AccountID = e.AccountID
				Inner Join cre.Note n on n.Account_AccountID = a.AccountID
				where n.DealID = @DealID
		UNION
		SELECT 'aAccountingtab' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM core.Period where dealid = @DealID
		UNION
		SELECT 'aServicingWatchlisttab' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.WLDealAccounting where dealid = @DealID
		UNION
		SELECT 'aXIRRTab' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.XIRROutputDealLevel where DealAccountID = @DealAccountId
		UNION
		SELECT 'aRulestab' AS HTMLTagID,MAX(UpdatedDate) UpdatedDate FROM cre.RuleTypeDetail
		UNION
		SELECT 'aImport' AS HTMLTagID, @l_getdate
		UNION
		SELECT 'aActivitytab' AS HTMLTagID, @l_getdate
	)a	

)z


END
GO

