CREATE view [dbo].[DealFundingSchdule]  
as   
  
SELECT [DealFundingID] as DealFundingKey  
,[DealID] as DealKey  
,[CREDealID]  
,[Date]  
,[Amount]        
,[PurposeBI] as Purpose  
,[Applied] as WireConfirm  
,[Comment]  
,[DrawFundingId]     
,[CreatedBy]  
,[CreatedDate]  
,[UpdatedBy]  
,[UpdatedDate]  
, ([PurposeBI]+Comment) MAsterPurposecomments  
,[Projected]  
,GeneratedByBI as GeneratedBy
FROM [DW].[DealFundingSchduleBI]  
  
  
  
  