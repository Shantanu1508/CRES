
CREATE PROCEDURE [dbo].[usp_UpdateAutoSpreadColumnByDealID]        
(        
	@DealID varchar(256),   
	@EarliestPossibleRepaymentDate date,        
	@LatestPossibleRepaymentDate date,        
	@ExpectedFullRepaymentDate date,
	@AutoPrepayEffectiveDate date, 
	@Userid nvarchar(256) 
)        
AS        
BEGIN   


Update cre.deal SEt       
EarliestPossibleRepaymentDate = @EarliestPossibleRepaymentDate,         
LatestPossibleRepaymentDate = @LatestPossibleRepaymentDate ,   
ExpectedFullRepaymentDate = @ExpectedFullRepaymentDate ,  
AutoPrepayEffectiveDate = @AutoPrepayEffectiveDate,   
UpdatedBy=@Userid,        
UpdatedDate =GETDATE()
Where dealID = @DealID


END