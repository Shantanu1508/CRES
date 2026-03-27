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
,(select [Value]+'#/dealdetail/'+[CREDealID] from app.appconfig where [key]='M61BaseUrl')  as DealUrl
FROM [DW].[DealFundingSchduleBI]  
  
  
  
  