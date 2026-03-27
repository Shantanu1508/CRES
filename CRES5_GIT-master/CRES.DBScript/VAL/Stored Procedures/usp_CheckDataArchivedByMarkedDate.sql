CREATE PROCEDURE [VAL].[usp_CheckDataArchivedByMarkedDate]  --'8/31/2022'
 
  @MarkedDate nvarchar(256)
 
AS  
BEGIN  
  
	SET NOCOUNT ON;  
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 


	Select  am.CreatedBy, am.CreatedDate 
	from [val].Archivemaster am
	Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = am.MarkedDateMasterID
	where md.MarkedDate = @MarkedDate and am.isdeleted <> 1


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

