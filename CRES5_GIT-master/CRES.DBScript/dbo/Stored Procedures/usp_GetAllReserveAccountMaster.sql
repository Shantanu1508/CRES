CREATE PROCEDURE [dbo].[usp_GetAllReserveAccountMaster]
	@UserID NVarchar(255) 
AS

BEGIN  
  
 SET NOCOUNT ON;  
 select ReserveAccountMasterID,ReserveAccountName from cre.ReserveAccountMaster order by ReserveAccountName
END
