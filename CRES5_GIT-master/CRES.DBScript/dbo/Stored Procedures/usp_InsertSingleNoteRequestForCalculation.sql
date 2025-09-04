 
CREATE PROCEDURE [dbo].[usp_InsertSingleNoteRequestForCalculation]  
 -- Add the parameters for the stored procedure here  
 @CRENoteID nvarchar(256)  ,
 @UserName nvarchar(256)
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
    -- Insert statements for procedure here   


    declare @TableTypeCalculationRequests TableTypeCalculationRequests
	insert into @TableTypeCalculationRequests(
	NoteId,
	StatusText,
	UserName,
	PriorityText,
	AnalysisID,
	CalcType
	)
	select 
	(select NoteID from CRE.Note where CRENoteID=@CRENoteID) as noteid,'Processing',@username,'Real Time','C10F3372-0FC2-4861-A9F5-148F1F80804F',775
		
	exec  [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@username,@username, NULL, NULL, 'SingleNote'

END
