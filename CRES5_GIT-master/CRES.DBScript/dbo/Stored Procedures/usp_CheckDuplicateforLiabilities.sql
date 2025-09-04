CREATE PROCEDURE [dbo].[usp_CheckDuplicateforLiabilities] --- 'A6C9C2D0-1CFC-4805-8850-C30A69FA3A21','ACP II','Equity'
(
	@AccountID UNIQUEIDENTIFIER,
	@ID nvarchar(256),
	@Type nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @IsExist bit = 0;

	IF @Type = 'LiabilityNote'
	BEGIN
		IF EXISTS(SELECT * FROM [CRE].[LiabilityNote] WHERE LiabilityNoteID = @ID and AccountID <> @AccountID)
		BEGIN
			SET @IsExist = 1;
		END
	END

	ELSE IF @Type = 'Debt' 
	BEGIN
		IF EXISTS(Select * from [CRE].[Debt] d inner join CORE.Account ac on d.AccountID=ac.AccountID  where ac.Name = @ID and ac.IsDeleted <> 1 and d.AccountID <> @AccountID)
		BEGIN
			SET @IsExist = 1;
		END
	END

	ELSE IF @Type = 'Equity' 
	BEGIN
		IF EXISTS(Select * from [CRE].[Equity] e inner join CORE.Account ac on e.AccountID=ac.AccountID  where ac.Name = @ID and ac.IsDeleted <> 1 and e.AccountID <> @AccountID)
		BEGIN
			SET @IsExist = 1;
		END
	END
	
	SELECT @IsExist;

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
