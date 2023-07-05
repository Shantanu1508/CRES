CREATE PROCEDURE [dbo].[usp_GetAllStatesMaster]
	@UserID nvarchar(256)

AS

 BEGIN
 	SET NOCOUNT ON;

	SELECT StatesID,CountryName,StatesName from App.StatesMaster order by StatesName
END