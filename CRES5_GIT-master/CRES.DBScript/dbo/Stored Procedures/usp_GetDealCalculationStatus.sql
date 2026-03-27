CREATE PROCEDURE [dbo].[usp_GetDealCalculationStatus] --'A48F6318-37EF-41CA-8143-1B84484974C0'
( 
  @DealID nvarchar(256) 
)
as
BEGIN
     SET NOCOUNT ON;
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 	 select * from Core.CalculationRequests  cr
	inner join  Core.Lookup l on l.LookupID = cr.StatusID
	where 
	 AccountId in (select Account_AccountID from cre.note where dealid =@DealID) 
	and  AnalysisID ='C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and   cr.StatusID NOT IN (266,265,736)
	and cr.CalcType = 775
 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
		
END


