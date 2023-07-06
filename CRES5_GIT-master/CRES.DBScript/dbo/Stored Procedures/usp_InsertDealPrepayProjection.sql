-- Procedure 
--drop proc [usp_InsertDealPrepayProjection]
create PROCEDURE [dbo].[usp_InsertDealPrepayProjection]         
(      
@tblPrepayPremiumoutput tblPrepayPremiumoutput READONLY,      
@CreatedBy nvarchar(256)      
)       
AS            
BEGIN            
 -- SET NOCOUNT ON added to prevent extra result sets from            
 -- interfering with SELECT statements.            
 SET NOCOUNT ON;  
 
  Declare @DealID [uniqueidentifier];      
 
  Select @DealID = DealID      
  from cre.Deal       
  where CREDealID =  (select top 1 DealID from @tblPrepayPremiumoutput)
    
 Delete from [CRE].[DealPrepayProjection] where DealID=@DealID and PrepayDate in (Select top 1 prepaydate from @tblPrepayPremiumoutput)         
      
     Insert into [CRE].[DealPrepayProjection]      
    (                    
     DealID,      
     PrepayDate,	
	 PrepayPremium_RemainingSpread,
	 OpenPrepaymentDate,	
	 TotalPayoff,
     CreatedBy,       
     CreatedDate,      
     UpdatedBy,       
     UpdatedDate      
    )              
    select @DealID,pp.prepaydate,pp.prepaypremium,pp.openprepaydate,pp.bal,@CreatedBy,getdate(),@CreatedBy,getdate()  
    from @tblPrepayPremiumoutput pp    
  
           
        
      
          
              
END
GO

