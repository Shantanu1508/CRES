-- Procedure
CREATE PROCEDURE [dbo].[usp_CheckDuplicateXIRRConfig] 
(   
    @ReturnName nvarchar(256),
	@XIRRConfigID int
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @IsExist bit = 0;

		IF EXISTS(SELECT * FROM [CRE].XIRRConfig WHERE ReturnName = @ReturnName and XIRRConfigID <> @XIRRConfigID)
		BEGIN
			SET @IsExist = 1;
		END
	SELECT @IsExist;

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
