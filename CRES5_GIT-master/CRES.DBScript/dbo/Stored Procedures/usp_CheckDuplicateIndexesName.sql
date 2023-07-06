

CREATE PROCEDURE [dbo].[usp_CheckDuplicateIndexesName]
(
	@IndexesMasterGuid uniqueidentifier,
	@IndexesName nvarchar(256)
	 
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @IsExist bit = 0;

IF EXISTS(Select TOP 1 IndexesMasterID from core.IndexesMaster where IndexesName = @IndexesName and IndexesMasterGuid != @IndexesMasterGuid)
BEGIN
	 SET @IsExist = 1;
END
 
select @IsExist
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


