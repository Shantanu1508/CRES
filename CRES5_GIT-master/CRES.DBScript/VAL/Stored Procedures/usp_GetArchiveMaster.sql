  
CREATE PROCEDURE [Val].[usp_GetArchiveMaster]  
  @FromDate date,
  @ToDate date   
AS        
BEGIN        
 SET NOCOUNT ON;        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        

	Select md.MarkedDate,am.UpdatedBy,am.UpdatedDate
	from [val].Archivemaster am
	Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = am.MarkedDateMasterID
	where am.isdeleted <> 1
	and (md.MarkedDate >= @FromDate and md.MarkedDate <= @ToDate)
    
	
	
	    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
END    
  