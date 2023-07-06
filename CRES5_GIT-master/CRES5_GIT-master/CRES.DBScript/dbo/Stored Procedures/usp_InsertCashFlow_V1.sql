  
CREATE PROCEDURE [dbo].[usp_InsertCashFlow_V1]  
  
@TableTypeCashFlow_v1 [tbltype_CashFlow_V1] READONLY,  
@AnalysisID uniqueidentifier,
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;



IF (@AnalysisID is not null)
BEGIN
  
	Delete from [CRE].[CashFlow_V1] where analysisid = @AnalysisID and note in (
		Select Distinct  n.crenoteid 
		from @TableTypeCashFlow_v1 tr
		inner join cre.note n on n.crenoteid = tr.note
	)
	

	INSERT INTO [CRE].[CashFlow_V1]  
	(  
		[Date]       
		,[Note]       
		,[Type]       
		,[Value]      
		,[FeeName]    
		,[Rate]       
		,[CreatedBy]  
		,[CreatedDate]
		,[UpdatedBy]  
		,[UpdatedDate]
		,[AnalysisID] 
	)  
	Select  
	tr.[Date]  
	,n.creNoteId  
	,tr.[Type] as TransactionType  
	,tr.value as Amount  
	,nullIF(FeeName,'')
	,Rate
	,@CreatedBy  
	,GETDATE()  
	,@CreatedBy  
	,GETDATE() 
	,@AnalysisID 	
	FROM @TableTypeCashFlow_v1  tr
	inner join cre.note n on n.crenoteid = tr.note
  
 


END
 
  

  
END  