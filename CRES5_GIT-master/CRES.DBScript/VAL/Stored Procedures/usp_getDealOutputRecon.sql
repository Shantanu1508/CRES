CREATE PROCEDURE [VAL].[usp_getDealOutputRecon]  -- '3/31/2023'
	@MarkedDate date
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	Select 
 
	 dout_ar.DealID	
	,dout_ar.DealName	as DealName_Archive
	--,dout.DealName
	,dout_ar.Type	
	,dout_ar.Value as Value_Archive
	,dout.Value as [Value]
	,(dout_ar.Value  - dout.Value ) as Delta

	from [Val].[vw_DealOutputArchive] dout_ar
	Full Outer Join [Val].[vw_DealOutput] dout on dout_ar.DealID = dout.DealID and dout_ar.Type = dout.Type and dout_ar.MarkedDate = dout.MarkedDate
	where dout_ar.MarkedDate = @MarkedDate  ---'2022-08-31'



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

