




CREATE view [dbo].[BackshopNoteBI]
as 

Select 
LoanNumber,
DealName,
NoteID,
NoteName,
ServicerLoanNumber,
FundingDate,
PastFunding,
FutureFunding,
InitialLoanAmount,
TotalCommitmentAmount,
TotalCurrentAdjustedCommitment,
CurrentBalance,
FinancingSource,
RSLIC,
SNCC,
PIIC,
TMR,
HCC,
USSIC,
TMNF,
HAIH,
TotalParticipation,
'06/30/2018' AS ReportDate
From dw.BackshopNoteBI

