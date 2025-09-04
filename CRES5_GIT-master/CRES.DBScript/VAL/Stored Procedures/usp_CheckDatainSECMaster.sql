
 
CREATE PROCEDURE [VAL].[usp_CheckDatainSECMaster]     --'4/30/2023'
 @MarkedDate date  
AS    
BEGIN    
 SET NOCOUNT ON;    
    
    
    declare @seccount int ;
    set @seccount = (select COUNT(*) from val.SECMastHolding where MarkedDateMasterID in  (Select MarkedDateMasterID from val.MarkedDateMaster where MarkedDate = @MarkedDate))


    if(@seccount>0)
    BEGIN
        Select 1 as IsMarkedDateExist  
    END  
    ELSE  
    BEGIN
        Select 0 as IsMarkedDateExist      
    END

  
END  
  