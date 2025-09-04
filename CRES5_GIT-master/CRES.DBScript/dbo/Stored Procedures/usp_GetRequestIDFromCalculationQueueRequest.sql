--select  * from Core.CalculationQueueRequest where CalculationQueueRequestID =173187


CREATE PROCEDURE [dbo].[usp_GetRequestIDFromCalculationQueueRequest]    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    
	
	Update [Core].[CalculationQueueRequest] set TransactionOutput = 292 ,NotePeriodicOutput= 292 ,StrippingOutput= 292,DailyInterestAccOutput = 292,CreatedDate = getdate(),updateddate = getdate()
		Where CalculationQueueRequestID in (
		select CalculationQueueRequestID ----,DATEDIFF(MINUTE,CreatedDate,getdate())  
		from [Core].[CalculationQueueRequest] 
		where (TransactionOutput = 267 OR	NotePeriodicOutput= 267 OR	StrippingOutput= 267 OR Prepaypremium_Output = 292)
		and DATEDIFF(MINUTE,CreatedDate,getdate())   > 10
	)


	--Select top 50 cq.RequestID , cq.TransactionOutput, cq.NotePeriodicOutput,cq.StrippingOutput ,cq.Prepaypremium_Output,cq.Prepayallocations_Output     
	--from [Core].[CalculationQueueRequest] cq    
	--Inner join core.CalculationRequests cr on cq.RequestID = cr.RequestID   
	--Where ([TransactionOutput] = 292 OR [NotePeriodicOutput] = 292 OR [StrippingOutput] = 292)    
	--order by cr.[priorityID] asc  
 
 
	Declare @tblReqid as table(
		RequestID nvarchar(256),
		TransactionOutput int, 
		NotePeriodicOutput int,
		StrippingOutput int,
		Prepaypremium_Output int,
		Prepayallocations_Output int,
		AnalysisID UNIQUEIDENTIFIER,
		priorityID int,
		noteid UNIQUEIDENTIFIER,
		DailyInterestAccOutput int
	)

	INSERT INTO @tblReqid(RequestID, TransactionOutput, NotePeriodicOutput,StrippingOutput ,Prepaypremium_Output,Prepayallocations_Output ,AnalysisID,priorityID,noteid,DailyInterestAccOutput)   
	Select top 50 cq.RequestID , cq.TransactionOutput, cq.NotePeriodicOutput,cq.StrippingOutput ,cq.Prepaypremium_Output,cq.Prepayallocations_Output ,cr.AnalysisID,cr.priorityID,n.noteid,cq.DailyInterestAccOutput
	from [Core].[CalculationQueueRequest] cq    
	Inner join core.CalculationRequests cr on cq.RequestID = cr.RequestID  
	left Join cre.note n on n.Account_AccountID = cr.AccountId
	Where ([TransactionOutput] = 292 OR [NotePeriodicOutput] = 292 OR [StrippingOutput] = 292 OR Prepaypremium_Output = 292)    
	order by cr.[priorityID] asc    
    
	

	--CREATE TABLE dbo.Temp_CalcQueueReq
	--(NoteID UNIQUEIDENTIFIER,
	--AnalysisID UNIQUEIDENTIFIER,
	--RequestID nvarchar(256),
	--CreatedDate datetime
	--)

	INSERT INTO dbo.Temp_CalcQueueReq(NoteID,AnalysisID,RequestID)
	Select cq.noteid,cq.AnalysisID,cq.RequestID
	from @tblReqid cq  	
	order by cq.[priorityID] asc 


	Select cq.RequestID, cq.TransactionOutput, cq.NotePeriodicOutput,cq.StrippingOutput ,cq.Prepaypremium_Output,cq.Prepayallocations_Output,cq.DailyInterestAccOutput
	from @tblReqid cq  	
	order by cq.[priorityID] asc    
 
  
	Update Core.CalculationQueueRequest set [TransactionOutput] = 267,updateddate = getdate()
	Where [RequestID] in (Select RequestID from @tblReqid where [TransactionOutput] = 292) and [TransactionOutput] = 292
	
	Update Core.CalculationQueueRequest set NotePeriodicOutput = 267,updateddate = getdate()
	Where [RequestID] in (Select RequestID from @tblReqid where NotePeriodicOutput = 292) and NotePeriodicOutput = 292
    
	Update Core.CalculationQueueRequest set StrippingOutput = 267,updateddate = getdate()
	Where [RequestID] in (Select RequestID from @tblReqid where StrippingOutput = 292) and StrippingOutput = 292
    
    

	Update Core.CalculationQueueRequest set Prepaypremium_Output = 267,updateddate = getdate()
	Where [RequestID] in (Select RequestID from @tblReqid where Prepaypremium_Output = 292) and Prepaypremium_Output = 292
    
	Update Core.CalculationQueueRequest set Prepayallocations_Output = 267,updateddate = getdate()
	Where [RequestID] in (Select RequestID from @tblReqid where Prepayallocations_Output = 292) and Prepayallocations_Output = 292
    
    Update Core.CalculationQueueRequest set DailyInterestAccOutput = 267,updateddate = getdate()
	Where [RequestID] in (Select RequestID from @tblReqid where DailyInterestAccOutput = 292) and DailyInterestAccOutput = 292
	
END
GO

