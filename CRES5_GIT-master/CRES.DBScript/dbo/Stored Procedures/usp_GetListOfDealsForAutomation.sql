CREATE PROCEDURE [dbo].[usp_GetListOfDealsForAutomation]    
       
AS          
BEGIN          
 SET NOCOUNT ON;          
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
          
  
 Declare @countMax int = 20   ;  
 Declare @Running int = (select COUNT(*) from Core.AutomationRequests where StatusID=267 and AutomationType <> 853);        
  
 Declare @count int = 0;  
 set @count = @countMax-@Running;  
  
 DECLARE @query  AS NVARCHAR(MAX);      
 SET @query = N'    
 select top '+CAST(@count as nvarchar(50))+' * from  Core.AutomationRequests where  StatusID =292 and AutomationType <> 853'  ;   ---batch type
          
          
 exec(@query)       
          
 --select top 1 * from  Core.AutomationRequests where 1=2  
          
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED          
END 