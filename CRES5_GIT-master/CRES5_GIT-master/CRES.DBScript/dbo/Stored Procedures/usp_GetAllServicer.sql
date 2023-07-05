
CREATE PROCEDURE [dbo].[usp_GetAllServicer]
@UserID UNIQUEIDENTIFIER
	
AS
BEGIN
	SET NOCOUNT ON;

   SELECT   ServicerID
		   ,ServicerName	
		   ,ServicerDropDate	
		   ,RepaymentDropDate
  FROM [CRE].[Servicer]
END


