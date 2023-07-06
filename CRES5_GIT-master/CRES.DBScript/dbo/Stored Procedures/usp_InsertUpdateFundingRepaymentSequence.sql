

CREATE PROCEDURE [dbo].[usp_InsertUpdateFundingRepaymentSequence] 
	@noteFundingRepayment [TableTypeFundingRepaymentSequence] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN
DECLARE @SourceTable int, @DestinationTable int, @countAll int,@DealID varchar(50)
Select @SourceTable = count(NoteID) from [CRE].[FundingRepaymentSequence] where NoteID in (Select DISTINCT NoteID from @noteFundingRepayment)
Select @DestinationTable = COUNT(NoteID) from @noteFundingRepayment

--Comparing both tables
SELECT @countAll = COUNT(NoteID) from
(
select   [NoteID]
        ,[SequenceNo]
        ,[SequenceType]
        ,[Value]
		 from [CRE].[FundingRepaymentSequence] where NoteID in (Select DISTINCT NoteID from @noteFundingRepayment)
UNION
select   [NoteID]
        ,[SequenceNo]
        ,[SequenceType]
        ,[Value] from @noteFundingRepayment
)a
   
IF(@SourceTable <> @DestinationTable OR @SourceTable <> @countAll )
BEGIN
		
		select @DealID=dealID from Cre.Note where NoteID = (Select top 1 NoteID from @noteFundingRepayment) 
		
		DELETE FROM app.activitylog WHERE activitylogAutoID in (
			Select activitylogAutoID from app.activitylog where ParentModuleID = @DealID and ParentModuleTypeID=283 and ModuleID = @DealID  and ActivityType=416 and CreatedBy = @CreatedBy
			and Cast(CreatedDate as date) = Cast(getdate() as Date)
			and DATEDIFF(SECOND, CreatedDate,  getdate()) <10
		)

		exec dbo.usp_InsertActivityLog @DealID,283,@DealID,416,'Updated',@CreatedBy
END


--Delete from [CRE].[FundingRepaymentSequence] where NoteID in (Select DISTINCT NoteID from @noteFundingRepayment)
Delete from [CRE].[FundingRepaymentSequence] where FundingRepaymentSequenceAutoID in (Select FundingRepaymentSequenceAutoID from [CRE].[FundingRepaymentSequence] where NoteID in (Select DISTINCT NoteID from @noteFundingRepayment))


INSERT INTO [CRE].[FundingRepaymentSequence]
           ([NoteID]
           ,[SequenceNo]
           ,[SequenceType]
           ,[Value]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
Select
[NoteID]
,[SequenceNo]
,[SequenceType]
,[Value]
,@CreatedBy
,Getdate()
,@UpdatedBy
,Getdate()
From @noteFundingRepayment


------===============FundingRepaymentSequenceLog======================-----
DECLARE @DealIDLog nvarchar(256) =(SELECT dealID from Cre.Note where NoteID = (Select top 1 NoteID from @noteFundingRepayment) )
EXEC [dbo].[usp_InsertIntoLogTables] 'FundingRepaymentSequence', @DealIDLog 

-----==================================================================---------

END

