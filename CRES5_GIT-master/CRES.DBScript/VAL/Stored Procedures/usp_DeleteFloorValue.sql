

CREATE PROCEDURE [VAL].[usp_DeleteFloorValue]
(
	@MarkedDate date
)
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	delete from [VAL].[FloorByTerm] where FloorValueID in (Select FloorValueID from [VAL].[FloorValue] where MarkedDateMasterID = @MarkedDateMasterID)
	delete from [VAL].[FloorValue] where MarkedDateMasterID = @MarkedDateMasterID
	


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
