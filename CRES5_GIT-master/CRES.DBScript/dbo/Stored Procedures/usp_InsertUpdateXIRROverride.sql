CREATE PROCEDURE [dbo].[usp_InsertUpdateXIRROverride] 
	@XIRROverride [TableTypeXIRROverride] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

	Update XIR Set XIR.XIRROverrideValue=TXIR.XIRR,
	XIR.IsOverride=TXIR.IsOverride,
	XIR.UpdatedBy=@UpdatedBy,
	XIR.UpdatedDate=GETDATE()
	FROM [CRE].[XIRROverride] XIR
	INNER JOIN @XIRROverride TXIR ON TXIR.DealAccountID=XIR.DealAccountID AND TXIR.XIRRConfigID=XIR.XIRRConfigID

	INSERT INTO [CRE].[XIRROverride]
		([XIRRConfigID]
		,[DealAccountID]
		,[XIRROverrideValue]
		,[IsOverride]
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate])
	Select
		[XIRRConfigID]
		,[DealAccountID]
		,[XIRROverrideValue]
		,[IsOverride]
		,@CreatedBy
		,Getdate()
		,@UpdatedBy
		,Getdate()
	From (
		Select
			TXIR.[XIRRConfigID]
			,TXIR.[DealAccountID]
			,TXIR.[XIRR] as XIRROverrideValue
			,TXIR.[IsOverride]
		FROM @XIRROverride TXIR 
		LEFT JOIN [CRE].[XIRROverride] XIR ON TXIR.DealAccountID=XIR.DealAccountID AND TXIR.XIRRConfigID=XIR.XIRRConfigID
		Where XIR.[XIRROverrideValue] IS NULL
	) Res

	DELETE FROM  [CRE].[XIRROverride] WHERE ISNULL([IsOverride], 0) = 0
END