CREATE PROCEDURE [VAL].[usp_GetMarkedDateList]
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
	Select CAST(MarkedDate	as Datetime) as MarkedDate
	--,CreatedBy	
	--,CreatedDate	
	,UpdateBy	
	,UpdatedDate 
	from val.MarkedDateMaster
	Order by UpdatedDate desc


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

