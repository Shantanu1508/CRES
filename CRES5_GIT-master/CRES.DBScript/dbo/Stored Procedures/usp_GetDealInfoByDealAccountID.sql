CREATE PROCEDURE [dbo].[usp_GetDealInfoByDealAccountID]
    @DealAccountID uniqueidentifier
AS
BEGIN
		select 
		DealID,	
		DealName,
		CREDealID 
		from CRE.Deal AS d
		where AccountID=@DealAccountID
		and IsDeleted <> 1
    
END;
