-- Procedure
CREATE PROCEDURE [dbo].[usp_UpdateXIRRInputOutputArchiveFiles]
(
@XIRRConfigID int,
@FileNameInput nvarchar(256),
@FileNameOutput nvarchar(256),
@ArchiveDate datetime,
@Comments nvarchar(max),
@UserID nvarchar(256)
)
AS
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  


Declare @Tags_CommSep nvarchar(max);
Declare @Tran_CommSep nvarchar(max);

Declare @tblXIRRConfigDetail as Table(
	XIRRConfigID	int,
	ObjectType	nvarchar(256),
	ObjectText nvarchar(MAX)

	)

	INSERT INTO @tblXIRRConfigDetail(XIRRConfigID,ObjectType,ObjectText)
	Select XIRRConfigID,ObjectType,ObjectText from (

	Select Distinct xd.XIRRConfigID,xd.ObjectType,tx.Name as [ObjectText]
	from cre.XIRRConfigDetail xd 
	left join cre.TagMasterXIRR tx on tx.TagMasterXIRRID = xd.ObjectID
	where xd.ObjectType = 'Tag'
	and xd.XIRRConfigID = @XIRRConfigID

	UNION ALL

	Select Distinct xd.XIRRConfigID,xd.ObjectType,ty.TransactionName as [ObjectText]
	from cre.XIRRConfigDetail xd 
	left join cre.TransactionTypes ty on ty.TransactionTypesID = xd.ObjectID 
	where xd.ObjectType = 'Transaction'
	and xd.XIRRConfigID = @XIRRConfigID

	)a
	ORDER BY XIRRConfigID
	-------------------------------------------

	Declare @tblXIRRCD as Table(
	XIRRConfigID	int,
	[Tag]	nvarchar(256),
	[Transaction] nvarchar(MAX)

	)

	INSERT INTO @tblXIRRCD(XIRRConfigID,[Tag],[Transaction])
	Select XIRRConfigID,[Tag],[Transaction] From(
	Select  Distinct XIRRConfigID,ObjectType
	,STUFF((
		Select Distinct  ', '  + xd.ObjectText  
		from (
			Select c.ObjectText
			from @tblXIRRConfigDetail c
			Where c.XIRRConfigID = p.XIRRConfigID
			 and c.objectType = p.objectType
		)xd
		FOR XML PATH('') ), 1, 1, '')
		as ObjectText

	from @tblXIRRConfigDetail p
	)z
	PIVOT
	(
		MAX(ObjectText) FOR ObjectType IN([Tag],[Transaction])

	)AS pivot_table



	Select @Tags_CommSep = [Tag],
	@Tran_CommSep = [Transaction] from @tblXIRRCD



	Declare @ConfigSetup nvarchar(MAX) = null
	Declare @ReturnName nvarchar(256) 
	Declare @AnalysisID UNIQUEIDENTIFIER
	Declare @Type nvarchar(256)


	Select @ReturnName = ReturnName,@AnalysisID = AnalysisID,@Type= [Type] from cre.XIRRConfig where XIRRConfigID = @XIRRConfigID

	

IF (ISNULL(@FileNameInput,'')<>'')
 BEGIN
	IF EXISTS(select 1 from CRE.[XIRRConfigArchive] where XIRRConfigID=@XIRRConfigID and cast(ArchiveDate as date)=cast(@ArchiveDate as date))
	BEGIN
		UPDATE CRE.[XIRRConfigArchive] set FileName_Input=@FileNameInput,ArchiveDate=@ArchiveDate,UpdatedDate=GETDATE(),UpdatedBy=@UserID,Comments=@Comments ,
		ReturnName = @ReturnName,[Type] = @Type,AnalysisID = @AnalysisID,ConfigSetup = @ConfigSetup,
		Tags = @Tags_CommSep,[Transaction] = @Tran_CommSep
		WHERE XIRRConfigID=@XIRRConfigID and cast(ArchiveDate as date)=cast(@ArchiveDate as date)
	 END
	 ELSE
	 BEGIN
	    insert into CRE.[XIRRConfigArchive](XIRRConfigID,ArchiveDate,FileName_Input,CreatedDate,UpdatedDate,CreatedBy,UpdatedBy,Comments,ReturnName,[Type],AnalysisID,ConfigSetup,Tags,[Transaction]) 
		values(@XIRRConfigID,@ArchiveDate,@FileNameInput,GETDATE(),GETDATE(),@UserID,@UserID,@Comments,@ReturnName,@Type,@AnalysisID,@ConfigSetup,@Tags_CommSep,@Tran_CommSep)
	 END
 END

 IF (ISNULL(@FileNameOutput,'')<>'')
 BEGIN
	IF EXISTS(select 1 from CRE.[XIRRConfigArchive] where XIRRConfigID=@XIRRConfigID and cast(ArchiveDate as date)=cast(@ArchiveDate as date))
	BEGIN
		UPDATE CRE.[XIRRConfigArchive] set FileName_Output=@FileNameOutput,ArchiveDate=@ArchiveDate,UpdatedDate=GETDATE(),UpdatedBy=@UserID,Comments=@Comments ,
		ReturnName = @ReturnName,[Type] = @Type,AnalysisID = @AnalysisID,ConfigSetup = @ConfigSetup,
		Tags = @Tags_CommSep,[Transaction] = @Tran_CommSep
		WHERE XIRRConfigID=@XIRRConfigID and cast(ArchiveDate as date)=cast(@ArchiveDate as date)
	 END
	 ELSE
	 BEGIN
	    insert into CRE.[XIRRConfigArchive](XIRRConfigID,ArchiveDate,FileName_Output,CreatedDate,UpdatedDate,CreatedBy,UpdatedBy,Comments,ReturnName,[Type],AnalysisID,ConfigSetup,Tags,[Transaction]) 
		values(@XIRRConfigID,@ArchiveDate,@FileNameOutput,GETDATE(),GETDATE(),@UserID,@UserID,@Comments,@ReturnName,@Type,@AnalysisID,@ConfigSetup,@Tags_CommSep,@Tran_CommSep)
	 END
 END

END

