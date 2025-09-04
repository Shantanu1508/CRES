-- Procedure
CREATE PROCEDURE [DBO].[usp_SaveDealRelationship]
	@Tbl_DealRelationship [TableTypeDealRelationship] READONLY,
	@CreatedBy  nvarchar(256),
	@UpdatedBy  nvarchar(256)
AS          
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [CRE].[DealRelationship] WHERE DealID in (SELECT DealID From @Tbl_DealRelationship);

	INSERT INTO CRE.DealRelationship          
	(          
		DealID
		,RelationshipID
		,LinkedDealID
		,CreatedBy
		,CreatedDate
		,UpdatedBy
		,UpdatedDate
    )          
	Select 
	DR.DealID
	,DR.RelationshipID
	,D.DealID
	,@CreatedBy
	,GETDATE()
	,@UpdatedBy
	,GETDATE()          
    FROM @Tbl_DealRelationship DR
	INNER JOIN [CRE].[Deal] D ON D.CREDealID = DR.LinkedDealID;          

END
GO

