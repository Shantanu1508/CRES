--DROP VIEW IF EXISTS [dbo].[vUwNoteTrRecon] 
--GO
Create VIEW [dbo].[vUwNoteTrRecon]  
AS    
SELECT   
NoteID  
, ControlId_F  
, NoteName  
, OrigLoanAmount  
, StatedMaturityDate  
, FundingDate  
, FinancingSource  
, TotalCommitment  
, TotalCurrentAdjustedCommitment  
, PastFunding  
, FutureFunding  
FROM DW.UwNoteBI