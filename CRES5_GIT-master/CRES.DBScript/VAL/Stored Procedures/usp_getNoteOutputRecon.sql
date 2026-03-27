CREATE PROCEDURE [VAL].[usp_getNoteOutputRecon]  --'3/31/2023'
	@MarkedDate date
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	Select 
 
	 dout_ar.DealID 
	,dout.DealName

	,dout_ar.NoteID
	,dout_ar.NoteName

	,dout_ar.Type	
	,dout_ar.Value as Value_Archive
	,dout.Value as [Value]
	,(dout_ar.Value  - dout.Value ) as Delta

	from [Val].[vw_NoteOutputArchive] dout_ar
	Full Outer Join [Val].[vw_NoteOutput] dout on dout_ar.DealID = dout.DealID and dout_ar.NoteID = dout.NoteID and dout_ar.Type = dout.Type and dout_ar.MarkedDate = dout.MarkedDate
	
	
	where dout_ar.MarkedDate = @MarkedDate  ---'2022-08-31'



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  