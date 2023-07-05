  
    
     
CREATE PROCEDURE [dbo].[usp_InsertUpdateNotePeriodicCalcByNoteIDUpdateColumn]     
 @noteAdditinallist tempNotePeriodicCalc READONLY,    
 @CreatedBy nvarchar(256),    
 @ListName nvarchar(256)    
AS    
BEGIN    
SET NOCOUNT ON;    
    
Declare @noteid UNIQUEIDENTIFIER= (Select top 1 NoteID from @noteAdditinallist)    
    
    
    
IF(@ListName = 'gaap' )    
BEGIN    
 Update [CRE].[NotePeriodicCalc] set     
 [CRE].[NotePeriodicCalc].InvestmentBasis = tblInvestmentBasis.InvestmentBasis,    
 [CRE].[NotePeriodicCalc].EndingGAAPBookValue = tblInvestmentBasis.EndingGAAPBookValue    
 from    
 (    
  Select     
  [NoteID]    
  ,[PeriodEndDate]     
  ,InvestmentBasis    
  ,EndingGAAPBookValue     
  ,@CreatedBy as UpdatedBy    
  ,GETDATE()  as UpdatedDate    
  ,AnalysisID    
  From  @noteAdditinallist    
 )tblInvestmentBasis    
 where [CRE].[NotePeriodicCalc].NoteID = tblInvestmentBasis.NoteID and    
 [CRE].[NotePeriodicCalc].PeriodEndDate = tblInvestmentBasis.PeriodEndDate and    
 [CRE].[NotePeriodicCalc].AnalysisID = tblInvestmentBasis.AnalysisID     
    
    
    
 INSERT INTO [CRE].[NotePeriodicCalc]    
 (    
  [NoteID]    
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
 [NoteID]    
 ,[PeriodEndDate]    
 ,InvestmentBasis    
 ,EndingGAAPBookValue    
 ,@CreatedBy    
 ,GETDATE()    
 ,@CreatedBy    
 ,GETDATE()    
 ,AnalysisID    
 From  @noteAdditinallist where PeriodEndDate not in (Select PeriodEndDate from cre.NotePeriodicCalc where NoteID = @noteid)    
    
END    
    
    
IF(@ListName = 'libor' )    
BEGIN    
 Update [CRE].[NotePeriodicCalc] set [CRE].[NotePeriodicCalc].LIBORPercentage = tblInvestmentBasis.LIBORPercentage,    
 [CRE].[NotePeriodicCalc].SpreadPercentage = tblInvestmentBasis.SpreadPercentage    
 from    
 (    
  Select     
  [NoteID]    
  ,[PeriodEndDate]     
  ,LIBORPercentage    
  ,SpreadPercentage     
  ,@CreatedBy as UpdatedBy    
  ,GETDATE()  as UpdatedDate    
  ,AnalysisID    
  From  @noteAdditinallist    
 )tblInvestmentBasis    
 where [CRE].[NotePeriodicCalc].NoteID = tblInvestmentBasis.NoteID and    
 [CRE].[NotePeriodicCalc].PeriodEndDate = tblInvestmentBasis.PeriodEndDate and     
 [CRE].[NotePeriodicCalc].AnalysisID = tblInvestmentBasis.AnalysisID    
    
    
    
 INSERT INTO [CRE].[NotePeriodicCalc]    
 (    
  [NoteID]    
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
 [NoteID]    
 ,[PeriodEndDate]    
 ,LIBORPercentage    
 ,SpreadPercentage     
 ,@CreatedBy    
 ,GETDATE()    
 ,@CreatedBy    
 ,GETDATE()    
 ,AnalysisID    
 From  @noteAdditinallist where PeriodEndDate not in (Select PeriodEndDate from cre.NotePeriodicCalc where NoteID = @noteid)    
    
END    
    
    
END    
    