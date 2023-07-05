-- Procedure  
--drop proc [usp_InsertDealPrepayAllocations] 
CREATE PROCEDURE [dbo].[usp_InsertDealPrepayAllocations]         
(      
@tblPrepayallocationsoutput tblPrepayallocationsoutput READONLY,      
@CreatedBy nvarchar(256)      
)       
AS            
BEGIN            
 -- SET NOCOUNT ON added to prevent extra result sets from            
 -- interfering with SELECT statements.            
 SET NOCOUNT ON;
 
 Declare @DealID [uniqueidentifier];      
 
  Select @DealID = DealID      
  from cre.Note       
  where CRENoteID =  (select top 1 noteid from @tblPrepayallocationsoutput)
    
 Delete from [CRE].[DealPrepayAllocations] where DealID=@DealID and PrepayDate in (Select top 1 prepaydt from @tblPrepayallocationsoutput)         
      
     Insert into [CRE].[DealPrepayAllocations]      
    (                    
     DealID,      
     NoteID,
	 PrepayDate,
	 MinmultDue,
     CreatedBy,       
     CreatedDate,      
     UpdatedBy,       
     UpdatedDate      
    )              
    select @DealID,(select NoteID from CRE.Note where CRENoteID= pp.noteid),pp.prepaydt,pp.minmultdue,@CreatedBy,getdate(),@CreatedBy,getdate()  
    from @tblPrepayallocationsoutput pp    
  
           
        
      
          
              
END
GO

