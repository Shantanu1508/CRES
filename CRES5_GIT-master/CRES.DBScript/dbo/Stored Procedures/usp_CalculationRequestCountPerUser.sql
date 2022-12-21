  --[dbo].[usp_CalculationRequestCountPerUser] 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  


CREATE PROCEDURE [dbo].[usp_CalculationRequestCountPerUser]   --'d0ead735-ba55-45c6-bc53-126cdce6664a'   
 @AnalysisID UNIQUEIDENTIFIER  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET FMTONLY OFF;    
   
  
 SELECT UserName, COUNT(UserName) as RequestCount ,--u.[Firstname]

 (CASE When EXISTS (SELECT 1 WHERE cr.UserName  LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
		THEN (select  top 1 u.[Firstname]  from App.[User]  u  where u.UserID =  cr.UserName ) 
		ELSE cr.UserName  END) as [Firstname]

 from Core.CalculationRequests cr  
 -- inner join app.[user] u on u.UserID = cr.UserName   
  where cr.AnalysisID=@AnalysisID  
   and cr.RequestTime>=cast(dateadd(day, -1, getdate()) as date)  
   and cr.CalcType = 775
GROUP BY UserName--,Firstname  
  
  
END  
  

  

--   SELECT UserName, COUNT(UserName) as RequestCount ,

-- (CASE When EXISTS (SELECT 1 WHERE cr.UserName  LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
--		THEN (select  top 1 u.[Firstname]  from App.[User]  u  where u.UserID =  cr.UserName ) 
--		ELSE cr.UserName  END) as [Firstname]

-- from Core.CalculationRequests cr  
 
--  where cr.AnalysisID= 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
--   and cr.RequestTime>=cast(dateadd(day, -1, getdate()) as date)  
--GROUP BY UserName 