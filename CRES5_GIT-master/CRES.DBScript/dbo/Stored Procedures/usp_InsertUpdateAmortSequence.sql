

CREATE PROCEDURE [dbo].[usp_InsertUpdateAmortSequence] 
	@AmortSequence [TableTypeAmortSequence] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN


DECLARE @SourceTable int, @DestinationTable int, @countAll int,@DealID varchar(50)
Select @SourceTable = count(NoteID) from CRE.DealAmortSequence where NoteID in (Select DISTINCT NoteID from @AmortSequence)
Select @DestinationTable = COUNT(NoteID) from @AmortSequence

--Comparing both tables
SELECT @countAll = COUNT(NoteID) from
(
select   [NoteID]
        ,[SequenceNo]
       ,[SequenceType]
        ,[Value]
		 from CRE.DealAmortSequence where NoteID in (Select DISTINCT NoteID from @AmortSequence)
UNION
select   [NoteID]
        ,[SequenceNo]
        ,[SequenceType]
        ,[Value] from @AmortSequence
)a
   
IF(@SourceTable <> @DestinationTable OR @SourceTable <> @countAll )
BEGIN
		
		select @DealID=dealID from Cre.Note where NoteID = (Select top 1 NoteID from @AmortSequence) 
		
		delete from app.activitylog where ParentModuleID = @DealID and ParentModuleTypeID=283 and ModuleID = @DealID  and ActivityType=416 and CreatedBy = @CreatedBy
		  and Cast(CreatedDate as date) = Cast(getdate() as Date)
		   and DATEDIFF(SECOND, CreatedDate,  getdate()) <10
		   
		exec dbo.usp_InsertActivityLog @DealID,283,@DealID,416,'Updated',@CreatedBy
END


Delete from CRE.DealAmortSequence where NoteID in (Select DISTINCT NoteID from @AmortSequence)

INSERT INTO CRE.DealAmortSequence
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
,'Sequence'
,[Value]
,@CreatedBy
,Getdate()
,@UpdatedBy
,Getdate()
From @AmortSequence


------===============FundingRepaymentSequenceLog======================-----
DECLARE @DealIDLog nvarchar(256) =(SELECT dealID from Cre.Note where NoteID = (Select top 1 NoteID from @AmortSequence) )
EXEC [dbo].[usp_InsertIntoLogTables] 'AmortSequence', @DealIDLog 

-----==================================================================---------

END

