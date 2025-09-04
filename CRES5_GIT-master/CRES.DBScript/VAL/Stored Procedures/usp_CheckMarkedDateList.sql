-- Procedure
CREATE PROCEDURE [VAL].[usp_CheckMarkedDateList]  
 @MarkedDate date
AS  
BEGIN  
 SET NOCOUNT ON;  
  
  
  IF EXISTS(Select MarkedDate from val.MarkedDateMaster where MarkedDate = @MarkedDate)
  BEGIN
	Select 1 as IsMarkedDateExist
  END
  ELSE
  BEGIN
	Select 0 as IsMarkedDateExist
  END

END

GO

