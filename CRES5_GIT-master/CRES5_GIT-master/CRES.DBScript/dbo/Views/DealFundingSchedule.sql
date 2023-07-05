CREATE view [dbo].[DealFundingSchedule]
as 

SELECT [DealFundingID] as DealFundingKey
      ,D.[DealID] as DealKey
      ,[CREDealID]
	  , DealName
      ,[Date]
      ,[Amount]      
      ,[PurposeBI] as Purpose
      ,ISNULL([Applied],0) as WireConfirm
	  ,CASE WHEN  COmment IS NULL OR COmment = '' THEN 'None' ELSE Comment END as Comment
	  
      ,[DrawFundingId]	  
      ,D.[CreatedBy]
      ,D.[CreatedDate]
      ,D.[UpdatedBy]
      ,D.[UpdatedDate]
	  , ([PurposeBI]+Comment) MAsterPurposecomments
	  --, UpdatedByBI =  FirstName +' ' + LastName
      ,[Projected]
      ,GeneratedByBI as GeneratedBy
  FROM [DW].[DealFundingSchduleBI] D
  Inner join Deal D1 on D.DealID = D1.DealKey
  where DealName is not NULL