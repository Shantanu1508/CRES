CREATE PROCEDURE [dbo].[usp_ArchiveXIRROutput]
(
    @XIRRConfigIDs nvarchar(1000),
    @ArchiveDate Date=null,
    @UserID nvarchar(256)
)
AS
BEGIN
    declare @XIRRConfigID int,@cnt int=1,@TotalCnt int=0
    declare @tblXIRRConfigID as table (
       ID int identity(1,1),
       XIRRConfigID int
    )

	IF (@ArchiveDate IS NOT NULL and @XIRRConfigIDs<>'')
	BEGIN
    BEGIN TRY
      BEGIN TRANSACTION 
		
        insert into @tblXIRRConfigID select value from dbo.fn_Split(@XIRRConfigIDs)

        select @TotalCnt=count(1) from @tblXIRRConfigID
        
        While (@cnt<=@TotalCnt)
        BEGIN
           select @XIRRConfigID = XIRRConfigID from @tblXIRRConfigID where ID=@cnt

           --
			IF EXISTS(select 1 from CRE.XIRROutputDetailArchive where cast(ArchiveDate as Date)=@ArchiveDate and XIRRConfigID=@XIRRConfigID)
			BEGIN
				delete from  CRE.XIRROutputDetailArchive where cast(ArchiveDate as Date)=@ArchiveDate and XIRRConfigID=@XIRRConfigID
			END

			IF EXISTS(select 1 from CRE.XIRROutputArchive where cast(ArchiveDate as Date)=@ArchiveDate and XIRRConfigID=@XIRRConfigID)
			BEGIN
				delete from  CRE.XIRROutputArchive where cast(ArchiveDate as Date)=@ArchiveDate and XIRRConfigID=@XIRRConfigID
			END

		
			INSERT INTO [CRE].[XIRROutputArchive]
			([XIRRConfigID]
			,[ObjectType]
			,[ObjectID]
			,[ReturnName]
			,[XIRRValue]
			,[AnalysisID]
            ,[Tags]
			,[Comments]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate]
			,[ArchiveDate])
			select
			XIRRConfigID
			,ObjectType
			,ObjectID
			,ReturnName
			,XIRRValue
			,AnalysisID
            ,[Tags]
			,[Comments]
			,CreatedBy
			,CreatedDate
			,UpdatedBy
			,UpdatedDate
			,@ArchiveDate
			from [CRE].[XIRROutput]
			where XIRRConfigID=@XIRRConfigID


			INSERT INTO [CRE].[XIRROutputDetailArchive]
			([XIRRConfigID]
           ,[ArchiveDate]
           ,[AnalysisID]
           ,[AccountID]
           ,[ObjectType]
           ,[ObjectID]
           ,[TransactionType]
           ,[TransactionDate]
           ,[Amount]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
			select 
			[XIRRConfigID]
           ,@ArchiveDate
           ,[AnalysisID]
           ,[AccountID]
           ,[ObjectType]
           ,[ObjectID]
           ,[TransactionType]
           ,[TransactionDate]
           ,[Amount]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
			from [CRE].[XIRROutputDetail]
			where XIRRConfigID=@XIRRConfigID
           --

           SET @cnt+=1
        
        END
	COMMIT
    END TRY
    BEGIN CATCH
            ROLLBACK
    END CATCH
	END
END
