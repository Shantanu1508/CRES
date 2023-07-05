CREATE PROCEDURE [dbo].[usp_GetPrepayCalculationStatus] --'332A5E28-5CE1-4EB4-AE5C-77CCCEE140C9'    
(     
  @DealID nvarchar(256)     
)    
as    
BEGIN    
     SET NOCOUNT ON;    
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
    
select [lu].[Name] as CalcStatus,Cr.ErrorMessage    
from Core.CalculationRequests cr   
inner join CORE.Lookup lu on lu.LookupID=cr.StatusID  
where  dealid=@DealID and noteid='00000000-0000-0000-0000-000000000000' and calctype =776   
     
SET TRANSACTION ISOLATION LEVEL READ COMMITTED     
      
END
GO

