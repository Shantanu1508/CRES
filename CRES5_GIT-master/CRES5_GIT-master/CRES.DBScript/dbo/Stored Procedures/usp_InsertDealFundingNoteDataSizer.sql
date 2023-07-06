
Create PROCEDURE [dbo].[usp_InsertDealFundingNoteDataSizer] 
@creNoteID nvarchar(256), 
@UseRuletoDetermineNoteFundingID int,
@NoteFundingRuleID int,
@FundingPriority int,
@NoteBalanceCap decimal(28,15),
@RepaymentPriorityID int,
@UpdatedBy nvarchar(256)
AS
BEGIN


DECLARE @accountID varchar(256)

SELECT @accountID = n.Account_AccountID FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID
WHERE n.CRENoteID=@creNoteID

Update cre.note set
UseRuletoDetermineNoteFunding=@UseRuletoDetermineNoteFundingID 
,NoteFundingRule=@NoteFundingRuleID
,FundingPriority=@FundingPriority
,NoteBalanceCap=@NoteBalanceCap
,RepaymentPriority=@RepaymentPriorityID
,UpdatedBy=@UpdatedBy
,UpdatedDate=getdate()
where Account_AccountID=@accountID

END
