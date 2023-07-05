CREATE PROCEDURE [dbo].[usp_GetAlltransactionTypes] --'b0e6697b-3534-4c09-be0a-04473401ab93'
  @UserID UNIQUEIDENTIFIER
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
	SELECT  tt.TransactionTypesID
		   ,tt.TransactionName  
		   ,tt.TransactionCategory 
		   ,tt.Calculated 
		   ,l.Name as CalculatedText
		   ,tt.IncludeCashflowDownload 
		   ,l1.Name as IncludeCashflowDownloadText
		   ,tt.IncludeServicingReconciliation
		   ,l2.Name as IncludeServicingReconciliationText
		   ,tt.IncludeGAAPCalculations
		   ,l3.Name as IncludeGAAPCalculationsText
		   ,tt.AllowCalculationOverride
		   ,l4.Name as AllowCalculationOverrideText
		   ,tt.CreatedBy      
		   ,tt.CreatedDate     
		   ,tt.UpdatedBy      
		   ,tt.UpdatedDate
		   ,tt.TransactionGroup
		   ,l5.LookupID as Cash_NonCashID
		   ,l5.Name as Cash_NonCashText
		   ,tt.AccountName
	FROM CRE.TransactionTypes tt
	left join core.lookup l on l.LookupID = tt.Calculated
	left join core.lookup l1 on l1.LookupID = tt.IncludeCashflowDownload 
	left join core.lookup l2 on l2.LookupID = tt.IncludeServicingReconciliation
	left join core.lookup l3 on l3.LookupID = tt.IncludeGAAPCalculations
	left join core.lookup l4 on l4.LookupID = tt.AllowCalculationOverride
	left join core.lookup l5 on l5.name = tt.Cash_NonCash and l5.ParentID = 121
	order by tt.TransactionName asc
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  
  
