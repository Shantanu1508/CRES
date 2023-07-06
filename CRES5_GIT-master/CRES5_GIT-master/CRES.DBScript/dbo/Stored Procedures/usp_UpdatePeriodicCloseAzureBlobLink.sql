

CREATE Procedure [dbo].[usp_UpdatePeriodicCloseAzureBlobLink]
@UserID uniqueidentifier,
@PeriodID uniqueidentifier,
@AzureBlobLink nvarchar(max)
AS

BEGIN

	SET NOCOUNT ON;
	UPDATE [Core].[Period] SET AzureBlobLink=@AzureBlobLink,UpdatedBy=@UserID,UpdatedDate=GETDATE() where PeriodID = @PeriodID
END
