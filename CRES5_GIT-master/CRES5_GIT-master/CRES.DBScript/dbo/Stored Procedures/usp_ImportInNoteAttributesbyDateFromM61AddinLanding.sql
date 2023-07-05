
CREATE PROCEDURE [dbo].[usp_ImportInNoteAttributesbyDateFromM61AddinLanding]
@BatchLogGenericID int,
@CreatedBy nvarchar(256)

AS
BEGIN



--Ignore records if flag set to EnableM61Calculations = N
Update [IO].[L_M61AddinLanding] set [Status] = 'Ignore' ,Comment = 'Enable M61 Calculations flag on accounting tab is not set to Y' 
where M61AddinLandingID in (	
	Select mch.M61AddinLandingID
	from [IO].[L_M61AddinLanding] mch
	inner join cre.note n on n.crenoteid = mch.Noteid
	where TableName = 'M61.Tables.MarketPrice' 
	and BatchLogGenericID = @BatchLogGenericID
	and [Status] = 'InProcess'
	and ISNULL(EnableM61Calculations,3) = 4
)



Declare @ServicerMasterID int;
SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')


	--transfer market price from landing table to actual table
	IF OBJECT_ID('tempdb..[#NoteAttributesbyDate]') IS NOT NULL                                         
	 DROP TABLE [#NoteAttributesbyDate]  
	create table [#NoteAttributesbyDate](
		[NoteID] [nvarchar](256) NULL,
		[Date] datetime null,
		[Value] decimal(28,15),
		[ValueTypeID] int null,
		[StatusType] [nvarchar](256) NULL,
		[CreatedBy] [nvarchar](256) NULL,
		[CreatedDate] [datetime] NULL Default getdate(),
		[UpdatedBy] [nvarchar](256) NULL,
		[UpdatedDate] [datetime] NULL Default getdate()
	)

	INSERT into [#NoteAttributesbyDate](NoteID,[Date],Value,ValueTypeID,[StatusType],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	Select n.crenoteid,mt.DueDate,mt.Value,mt.TransactionTypeID,'insert' as [StatusType],
	mt.[CreatedBy],mt.[CreatedDate],mt.[UpdatedBy],mt.[UpdatedDate]
	from [IO].[L_M61AddinLanding] mt
	inner join cre.note n on n.crenoteid =mt.noteid
	left join CRE.TransactionTypes ty on ty.TransactionTypesID = mt.TransactionTypeID
	Where [Status] = 'InProcess'
	and TableName = 'M61.Tables.MarketPrice' 
	and BatchLogGenericID = @BatchLogGenericID


	Update [#NoteAttributesbyDate] set [StatusType] = 'update'
	from(
		Select 
		a.noteid,
		a.ValueTypeID,
		a.[Date]
		from [#NoteAttributesbyDate] a
		inner join cre.NoteAttributesbyDate te on te.noteid = a.noteid 
		and a.[Date] = te.[Date] 
		and a.[ValueTypeID] = te.[ValueTypeID] 
	)b
	where 
	[#NoteAttributesbyDate].noteid = b.noteid
	and [#NoteAttributesbyDate].ValueTypeID = b.ValueTypeID
	and [#NoteAttributesbyDate].[Date] = b.[Date]


	insert into cre.NoteAttributesbyDate([NoteID],[Date],[Value],[ValueTypeID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	select [NoteID],[Date],[Value],[ValueTypeID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate]
	from [#NoteAttributesbyDate] where [StatusType] = 'insert'


	update [CRE].[NoteAttributesbyDate] set [Value] =  b.Value
	from(
		select [NoteID],[Date],[Value],[ValueTypeID]
		from [#NoteAttributesbyDate] a
		Where a.[StatusType] = 'update'	
	) b
	where 
	[CRE].[NoteAttributesbyDate].noteid = b.[NoteID]
	and [CRE].[NoteAttributesbyDate].[Date] = b.[Date]
	and [CRE].[NoteAttributesbyDate].ValueTypeID=b.ValueTypeID



	Update [IO].[L_M61AddinLanding] set [Status] = 'Imported' 
	where TableName = 'M61.Tables.MarketPrice' 
	and BatchLogGenericID = @BatchLogGenericID 
	and [Status] = 'InProcess' 
	and ServicerMasterID = @ServicerMasterID
  


End





