-- Procedure
CREATE PROCEDURE [dbo].[usp_Test_GetScheduledPrincipalAndBalloonByDealID]  --'15-0220P'  
@DealID nvarchar(256)
  
AS    
BEGIN    
    SET NOCOUNT ON;    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
 SELECT n.CRENoteID,SUM(Amount) as Amount  ,t.Type
 FROM cre.note n   
 inner join cre.deal d on d.dealid = n.DealID  
 left join cre.TransactionEntry t on t.AccountID = n.Account_AccountID  
 where IIF(@DealID LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'),CAST(d.DealID as nvarchar(256)),d.CREDealID) = @DealID  
 and AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'   
 and t.type in ('ScheduledPrincipalPaid'   ,'Balloon')
 and t.Date <= cast(getdate() as date)  
 group by n.CRENoteID  ,t.Type
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END