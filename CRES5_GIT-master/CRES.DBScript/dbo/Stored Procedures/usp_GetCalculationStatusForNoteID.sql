 
CREATE PROCEDURE [dbo].[usp_GetCalculationStatusForNoteID]  
 -- Add the parameters for the stored procedure here  
 @CRENoteID nvarchar(256)  
 
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
    -- Insert statements for procedure here   


select  
l.Name as statusname 
from Core.CalculationRequests  cr 
Inner Join core.Account acc on acc.AccountID = cr.AccountId and acc.AccountTypeID = 1
inner join  Core.Lookup l on l.LookupID = cr.StatusID
where cr.AccountID in( select  Account_AccountID from CRE.Note where CRENoteID =@CRENoteID)
and cr.CalcType = 775
and acc.AccountTypeID = 1


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 
END
