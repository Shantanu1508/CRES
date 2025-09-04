  
CREATE PROCEDURE [dbo].[usp_InsertDailyInterestAccruals_V1]   
@TableTypeDailyInterest [TableTypeDailyInterestAccruals] READONLY,  
@NoteId UNIQUEIDENTIFIER,  
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;  


DECLARE @AnalysisID UNIQUEIDENTIFIER; 
SET @AnalysisID = (Select Top 1 AnalysisID from @TableTypeDailyInterest)


IF (@AnalysisID is not null)
BEGIN
	 
	DELETE FROM [CRE].[DailyInterestAccruals] WHERE [NoteID]=@NoteId  and AnalysisID = @AnalysisID  

	INSERT INTO [CRE].[DailyInterestAccruals]
	(
	[NoteID]
	,[Date]
	,DailyInterestAccrual
	,EndingBalance
	,[AnalysisID]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]) 

	Select @NoteId  
	,[Date]  
	,DailyInterestAccrual  	 
	,EndingBalance
	,AnalysisID 
	,@CreatedBy  
	,GETDATE()  
	,@CreatedBy  
	,GETDATE() 
	from(
	select AnalysisID,NoteID,Date,DailyInterestAccrual,EndingBalance,
	ISNULL(LEAD(DailyInterestAccrual) OVER (Partition by AnalysisID,NoteID order by AnalysisID,NoteID),0) AS Lead_DailyInterestAccrual,
	ISNULL(LAG(DailyInterestAccrual) OVER (Partition by AnalysisID,NoteID order by AnalysisID,NoteID) ,0) AS Lag_DailyInterestAccrual,
	ISNULL(LEAD(EndingBalance) OVER (Partition by AnalysisID,NoteID order by AnalysisID,NoteID),0) AS Lead_EndingBalance,
	ISNULL(LAG(EndingBalance) OVER (Partition by AnalysisID,NoteID order by AnalysisID,NoteID) ,0) AS Lag_EndingBalance

	from @TableTypeDailyInterest
	where analysisid = @AnalysisID and noteid = @NoteId
	)z
	where (Lead_DailyInterestAccrual <> Lag_DailyInterestAccrual OR Lead_EndingBalance <> Lag_EndingBalance)


	 --Select  
	 -- @NoteId  
	 --,[Date]  
	 --,DailyInterestAccrual  	 
	 --,EndingBalance
	 --,AnalysisID 
	 --,@CreatedBy  
	 --,GETDATE()  
	 --,@CreatedBy  
	 --,GETDATE() 	 
	 --FROM @TableTypeDailyInterest 


 
 END  
  
END  


