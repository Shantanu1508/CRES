CREATE PROCEDURE [dbo].[usp_InsertYieldCalcInput]
(
	@TableTypeYieldCalcInput [TableTypeYieldCalcInput] READONLY,
	@CreatedBy nvarchar(256)
)
AS
BEGIN
SET NOCOUNT ON;

	Declare @Crenoteid nvarchar(256),@AnalysisID uniqueidentifier;
	SELECT top 1 @Crenoteid = CRENoteID, @AnalysisID=AnalysisID FROM @TableTypeYieldCalcInput
	DELETE FROM [CRE].[YieldCalcInput] WHERE CRENoteID=@Crenoteid and AnalysisID=@AnalysisID;

	INSERT INTO [CRE].[YieldCalcInput]
	([CRENoteID],
	[NPVdate],
	[Value],
	[Effectivedate],
	AnalysisID,
	YieldType,
	[CreatedBy],
	[CreatedDate],
	[UpdatedBy],
	[UpdatedDate]
	)
	SELECT CRENoteID,NPVdate,[Value],Effectivedate,AnalysisID,YieldType,@CreatedBy,getdate(),@CreatedBy,getdate()
	FROM @TableTypeYieldCalcInput
END

