
CREATE PROCEDURE [dbo].[usp_GetGeneralSetupDetailsByAccountID] 
(
	@AccountID	nvarchar(256)
)
AS
BEGIN

	Declare  @EventID varchar(256);

	Set @EventID = (Select EventID from [Core].[Event] 
	Where AccountID=@AccountID AND EffectiveStartDate=(select Max(EffectiveStartDate) from [Core].[Event] Where AccountID=@AccountID))

	SELECT AttributeName,[Value] From GeneralSetupDetails Where EventID=@EventID

END