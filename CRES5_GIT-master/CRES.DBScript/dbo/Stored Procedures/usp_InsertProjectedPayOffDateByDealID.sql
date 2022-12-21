
CREATE PROCEDURE [dbo].[usp_InsertProjectedPayOffDateByDealID]
(
	@TableTypeProjectedPayOffDate [TableTypeProjectedPayOffDate] READONLY,    
	@CreatedBy uniqueidentifier
)

AS
BEGIN
	SET NOCOUNT ON;
	
	Declare @DealID UNIQUEIDENTIFIER;
	SET @DealID = (Select top 1 DealID from @TableTypeProjectedPayOffDate)


	IF OBJECT_ID('tempdb..[#tblProjectedPayOffDate]') IS NOT NULL                                         
	 DROP TABLE [#tblProjectedPayOffDate]  

	Create table [#tblProjectedPayOffDate]
	(     
		DealID uniqueidentifier,
		ProjectedPayoffAsofDate date,
		CumulativeProbability decimal(28,15) ,
		[Status] nvarchar(256) null                      
	)
	INSERT INTO #tblProjectedPayOffDate(DealID,ProjectedPayoffAsofDate,CumulativeProbability,[Status])
	Select DealID,ProjectedPayoffAsofDate,CumulativeProbability,'Insert' as [Status]
	From @TableTypeProjectedPayOffDate
	Where DealID = @DealID


	-----Update Status-----
	Update [#tblProjectedPayOffDate] SET [#tblProjectedPayOffDate].[Status] = 'Update' 
	From(
		Select I.DealID,I.ProjectedPayoffAsofDate,I.CumulativeProbability --,O.DealID,O.AsofDate,O.CumulativeProbability
		from [#tblProjectedPayOffDate] I
		Inner Join [CRE].[DealProjectedPayOffAccounting] O on I.dealid = O.dealid and I.ProjectedPayoffAsofDate = O.AsOfDate
		Where I.DealId = @DealID
	)a
	Where [#tblProjectedPayOffDate].DealID = a.Dealid and [#tblProjectedPayOffDate].ProjectedPayoffAsofDate = a.ProjectedPayoffAsofDate

	--Update data
	Update [CRE].[DealProjectedPayOffAccounting] set [CRE].[DealProjectedPayOffAccounting].AsOfDate	= a.ProjectedPayoffAsofDate
	,[CRE].[DealProjectedPayOffAccounting].CumulativeProbability = a.CumulativeProbability
	,[CRE].[DealProjectedPayOffAccounting].UpdatedBy = @CreatedBy
	,[CRE].[DealProjectedPayOffAccounting].UpdatedDate = getdate()
	From(
		SELECT DealID,ProjectedPayoffAsofDate,CumulativeProbability 
		FROM [#tblProjectedPayOffDate]  
		Where [Status] = 'Update'
	)a
	Where [CRE].[DealProjectedPayOffAccounting].DealID = a.Dealid and [CRE].[DealProjectedPayOffAccounting].AsofDate = a.ProjectedPayoffAsofDate

	--Delete data
	Delete from [CRE].[DealProjectedPayOffAccounting] where DealId = @DealID and AsOfDate not in (Select ProjectedPayoffAsofDate from [#tblProjectedPayOffDate])


	--Insert date
	INSERT INTO [CRE].[DealProjectedPayOffAccounting](DealID,AsOfDate,CumulativeProbability,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
	SELECT DealID,ProjectedPayoffAsofDate,CumulativeProbability,@CreatedBy,getdate(),@CreatedBy,getdate() 
	FROM [#tblProjectedPayOffDate]  
	Where [Status] = 'Insert'

	
	



END

