-- Procedure
  ---[VAL].[usp_GetValueDeclineByPropertyType]  '11/30/2023'
  
CREATE PROCEDURE [VAL].[usp_GetValueDeclineByPropertyType] 
(
	@MarkedDate date
) 
AS    
BEGIN    
    
	SET NOCOUNT ON;    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

	SELECT PropertyType,ValueDecline FROM [VAL].[ValueDeclineByPropertyType] Where MarkedDateMasterID =	@MarkedDateMasterID
	
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  

END