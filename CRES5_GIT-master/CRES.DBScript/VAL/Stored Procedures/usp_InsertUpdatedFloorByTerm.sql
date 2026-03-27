
CREATE PROCEDURE [VAL].[usp_InsertUpdatedFloorByTerm]
(
	@tbltype_FloorByTerm [val].[tbltype_FloorByTerm] READONLY 
	--@IndexTypeName	nvarchar(256),
	--@Percentage	decimal(28,15),
	--@Month	int,
	--@Value	decimal(28,15),
	--@UserID	nvarchar(256)	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
		
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_FloorByTerm))


	INSERT INTO [VAL].[FloorByTerm](FloorValueID,[Percentage],[Month],[Value],[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	Select fv.FloorValueID,ft.[Percentage],ft.[Month],ft.[Value],ft.UserID,getdate(),ft.UserID,getdate()
	From @tbltype_FloorByTerm ft
	Left Join [VAL].[FloorValue] fv on fv.IndexTypeName = ft.IndexTypeName and fv.MarkedDateMasterID = @MarkedDateMasterID


	--Declare @FloorValueID int = (select FloorValueID from [VAL].[FloorValue] where IndexTypeName = @IndexTypeName);

	--INSERT INTO [VAL].[FloorByTerm](FloorValueID,[Percentage],[Month],[Value],[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	--VALUES(@FloorValueID,@Percentage,@Month,@Value,@UserID,getdate(),@UserID,getdate())


	 

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
