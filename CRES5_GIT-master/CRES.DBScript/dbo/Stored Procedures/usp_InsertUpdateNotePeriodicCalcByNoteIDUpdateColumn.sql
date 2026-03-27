---- Procedure
CREATE PROCEDURE [dbo].[usp_InsertUpdateNotePeriodicCalcByNoteIDUpdateColumn]     
 @noteAdditinallist tempNotePeriodicCalc READONLY,    
 @CreatedBy nvarchar(256),    
 @ListName nvarchar(256)    
AS    
BEGIN    
SET NOCOUNT ON;    
    
Declare @noteid UNIQUEIDENTIFIER= (Select top 1 NoteID from @noteAdditinallist)    
Declare @AccountId UNIQUEIDENTIFIER= (Select Account_Accountid from cre.note where noteid = @noteid)     
    
    
IF(@ListName = 'gaap' )    
BEGIN    
 Update [CRE].[NotePeriodicCalc] set     
 [CRE].[NotePeriodicCalc].InvestmentBasis = tblInvestmentBasis.InvestmentBasis,    
 [CRE].[NotePeriodicCalc].EndingGAAPBookValue = tblInvestmentBasis.EndingGAAPBookValue    
 from    
 (    
  Select     
  nt.[NoteID]    
  ,[PeriodEndDate]     
  ,InvestmentBasis    
  ,EndingGAAPBookValue     
  ,@CreatedBy as UpdatedBy    
  ,GETDATE()  as UpdatedDate    
  ,AnalysisID  
  ,n.Account_AccountID
  From  @noteAdditinallist  nt
  Inner Join cre.note n on n.NoteID = nt.NoteID
 )tblInvestmentBasis    
 where [CRE].[NotePeriodicCalc].AccountID = tblInvestmentBasis.Account_AccountID and    
 [CRE].[NotePeriodicCalc].PeriodEndDate = tblInvestmentBasis.PeriodEndDate and    
 [CRE].[NotePeriodicCalc].AnalysisID = tblInvestmentBasis.AnalysisID     
    
    
    
 INSERT INTO [CRE].[NotePeriodicCalc]    
 (    
  --[NoteID]    
  AccountID
  ,[PeriodEndDate]    
  ,InvestmentBasis    
  ,EndingGAAPBookValue    
  ,[CreatedBy]    
  ,[CreatedDate]    
  ,[UpdatedBy]    
  ,[UpdatedDate]    
  ,AnalysisID    
 )    
 Select     
 --[NoteID]    
 n.Account_AccountID
 ,[PeriodEndDate]    
 ,InvestmentBasis    
 ,EndingGAAPBookValue    
 ,@CreatedBy    
 ,GETDATE()    
 ,@CreatedBy    
 ,GETDATE()    
 ,AnalysisID    
 From  @noteAdditinallist nt
 Inner Join cre.note n on n.NoteID = nt.NoteID
 where PeriodEndDate not in (Select PeriodEndDate from cre.NotePeriodicCalc where AccountID = @AccountId)    
    
END    
    
    
IF(@ListName = 'libor' )    
BEGIN    
 Update [CRE].[NotePeriodicCalc] set [CRE].[NotePeriodicCalc].LIBORPercentage = tblInvestmentBasis.LIBORPercentage,    
 [CRE].[NotePeriodicCalc].SpreadPercentage = tblInvestmentBasis.SpreadPercentage    
 from    
 (    
  Select     
  nt.[NoteID]    
  ,[PeriodEndDate]     
  ,LIBORPercentage    
  ,SpreadPercentage     
  ,@CreatedBy as UpdatedBy    
  ,GETDATE()  as UpdatedDate    
  ,AnalysisID    
  ,n.Account_AccountID
  From  @noteAdditinallist    nt
  Inner Join cre.note n on n.NoteID = nt.NoteID
 )tblInvestmentBasis    
 where [CRE].[NotePeriodicCalc].AccountID = tblInvestmentBasis.Account_AccountID and    
 [CRE].[NotePeriodicCalc].PeriodEndDate = tblInvestmentBasis.PeriodEndDate and     
 [CRE].[NotePeriodicCalc].AnalysisID = tblInvestmentBasis.AnalysisID    
    
    
    
 INSERT INTO [CRE].[NotePeriodicCalc]    
 (    
  --[NoteID]    
  AccountID
  ,[PeriodEndDate]    
  ,LIBORPercentage    
  ,SpreadPercentage     
  ,[CreatedBy]    
  ,[CreatedDate]    
  ,[UpdatedBy]    
  ,[UpdatedDate]    
  ,AnalysisID    
 )    
 Select     
 --[NoteID]    
 n.Account_AccountID
 ,[PeriodEndDate]    
 ,LIBORPercentage    
 ,SpreadPercentage     
 ,@CreatedBy    
 ,GETDATE()    
 ,@CreatedBy    
 ,GETDATE()    
 ,AnalysisID    
 From  @noteAdditinallist nt
 Inner Join cre.note n on n.NoteID = nt.NoteID
 where PeriodEndDate not in (Select PeriodEndDate from cre.NotePeriodicCalc where AccountID = @AccountId)    
    
END    
    
    
END    
    