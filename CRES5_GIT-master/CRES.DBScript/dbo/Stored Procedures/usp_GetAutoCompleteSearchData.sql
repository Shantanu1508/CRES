CREATE PROCEDURE [dbo].[usp_GetAutoCompleteSearchData] ---'Note A1'
    @SearchBy nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
          Declare @Query nvarchar(MAX) 

		

 
 ---178

set @Query='
		select
		AccountID,[Name],''CRE Loan (Note)'' as AccountType
		from [Core].[Account] acc where acc.IsDeleted = 0 and AccountTypeID= 1 and [Name] like ''%'+CONVERT(VARCHAR(256),@SearchBy)+'%''  
		
		union
		
		select
		DealID,DealName,''Deal'' as AccountType
		from [CRE].Deal d where d.IsDeleted = 0 and d.DealName like ''%'+CONVERT(VARCHAR(256),@SearchBy)+'%'''   	
		
		exec(@Query)
		print  (@Query)
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END      
