-- Procedure
  ---[VAL].[usp_GetRateExtension]  '11/30/2023'
  
CREATE PROCEDURE [VAL].[usp_GetRateExtension] 
(
	@MarkedDate date
) 
AS    
BEGIN    
    
	SET NOCOUNT ON;    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

	SELECT [Value] FROM [VAL].[RateExtension] Where MarkedDateMasterID =	@MarkedDateMasterID
	
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  

END