-- [dbo].[usp_GetDealPrepayAllocationsByDealId]      
        
        
CREATE PROCEDURE [dbo].[usp_GetDealPrepayAllocationsByDealId]   --'90fa31ec-a1e5-4714-a157-b4f8def20b1f','B0E6697B-3534-4C09-BE0A-04473401AB93'        
        
            
AS        
        
BEGIN        
 SET NOCOUNT ON;        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
         
 Select a.DealPrepayAllocationsID,
 a.DealID	,
 a.NoteID,	
 a.PrepayDate,	
 a.MinmultDue,
 b.CRENoteID
 from [CRE].[DealPrepayAllocations] a  
inner join [CRE].[Note] b on a.NoteID=b.NoteID              
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
        
END
GO

