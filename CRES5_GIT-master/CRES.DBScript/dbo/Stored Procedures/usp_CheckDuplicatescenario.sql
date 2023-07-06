

CREATE PROCEDURE [DBO].[usp_CheckDuplicatescenario]
(
	@ScenarioID uniqueidentifier,
	@ScenarioName nvarchar(256)
	 
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
Declare @IsExist bit = 0;

IF EXISTS(Select * from Core.Analysis  where Name = @ScenarioName and AnalysisID!=@ScenarioID)
BEGIN
	 SET @IsExist = 1;
END
 
select @IsExist
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


