-- View
CREATE VIEW [dbo].xCashflowM61_Backshop_new
AS  
SELECT   
DISTINCT  
N.NoteID  
 ,ControlId_F  
 ,NoteName  
 ,OrigLoanAmount  
 ,StatedMaturityDate  
 ,FundingDate  
 ,N.FinancingSource AS FinancingSource_BS  
 ,Note.FinancingSource AS FinancingSource_M61  
 ,N.TotalCommitment  
 ,TotalCurrentAdjustedCommitment  
 ,PastFunding  
 ,FutureFunding  
 ,ServicerName  
 ,NP.PeriodEndDate  
 ,CurrentBalance  
 ,EndingBalance  
 ,TotalCurrentAdjustedCommitment -CurrentBalance- FutureFunding AS CurCommit_CurrBal_RFFunding   
 ,CASE WHEN note.ActualPayoffDate IS NULL THEN 'Active' ELSE 'PaidOff' END AS [PaidOff Vs Active]  
FROM vUwNoteTrRecon N  
LEFT JOIN vCashflow c ON C.Noteid = N.Noteid  
LEFT JOIN cashflow NP ON NP.Noteid = Convert(VARCHAR(10), N.Noteid) and  C.Periodenddate = NP.Periodenddate  
LEFT JOIN Note Note ON Note.NoteID = Convert(VARCHAR(10), N.Noteid)
