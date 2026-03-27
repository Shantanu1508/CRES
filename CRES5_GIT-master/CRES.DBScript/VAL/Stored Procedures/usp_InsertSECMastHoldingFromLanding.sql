CREATE PROCEDURE [VAL].[usp_InsertSECMastHoldingFromLanding]    
 @MarkedDate date,  
 @UserID nvarchar(256)  
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     
  
  
 Declare @MarkedDateMasterID int;  
 SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)  
  
  
 IF EXISTS(  
  Select Ticker from [IO].[L_SECMastHolding]   
  Where Ticker in (  
    Select Distinct d.credealid from val.deallist dl  
    Inner Join cre.deal d on d.dealid = dl.dealid  
    where dl.MarkedDateMasterID = @MarkedDateMasterID  
   )  
 )  
 BEGIN  
  Delete From [VAL].[SECMastHolding]  where MarkedDateMasterID = @MarkedDateMasterID  
  
  INSERT INTO [VAL].[SECMastHolding](  
  MarkedDateMasterID  
  ,Ticker  
  ,LoanID  
  ,Description  
  ,FinancingSource  
  ,NoteName  
  ,Priority  
  ,OriginationDate  
  ,FullyExtendedMaturityDate  
  ,PaymentDay  
  ,InterestRate  
  ,InitialFunding  
  ,OriginalAmountofLoan  
  ,AdjustedCommitment  
  ,AmountofLoanOutstanding  
  ,IndexFloor  
  ,CreatedBy  
  ,CreatedDate  
  ,UpdateBy  
  ,UpdatedDate)  
  
  SELECT   
 @MarkedDateMasterID  
  ,sec.Ticker  
  ,sec.LoanID as LoanID  
  ,sec.[Description]  
  ,sec.FinancingSource  
  ,sec.NoteName  
  ,sec.[Priority]  
  ,sec.OriginationDate  
  ,sec.FullyExtendedMaturityDate  
  ,sec.PaymentDay  
  ,sec.InterestRate 
  ,sec.InitialFunding 
  ,sec.OriginalAmountofLoan 
  ,sec.AdjustedCommitment 
  ,sec.AmountofLoanOutstanding 
  ,sec.IndexFloor 
  
  ,@UserID  
  ,getdate()  
  ,@UserID  
  ,getdate()  
  from [IO].[L_SECMastHolding] sec  
  Where sec.Ticker in (  
   Select Distinct d.credealid from val.deallist dl  
   Inner Join cre.deal d on d.dealid = dl.dealid  
   where dl.MarkedDateMasterID = @MarkedDateMasterID  
  )  
  
 END  
  
  
  
  
  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END    