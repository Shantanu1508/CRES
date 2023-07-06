CREATE View [dbo].[Balloon_Repayments]
as
Select
 T.NoteID as NoteKey,
T.CRENoteID as NoteID,
--Date,
Sum(Amount) as Balloon_Plus_RePayment
,Max(TotalCommitment) TotaLCommitment
--Type,
--T.CreatedBy,
--T.CreatedDate,
--T.UpdatedBy,
--T.UpdatedDate ,
--( T.crenoteid+'_'+ Type + '_' + CONVERT (VARCHAR(10),Date, 110)  ) Note_Type_Date,

--T.crenoteid+'_'+CONVERT (VARCHAR(10),Date, 110)  NoteID_Date,

--AnalysisID,
--AnalysisName as Scenario
--FeeName  
From [DW].[TransactionEntryBI] T
Inner Join Dw.NoteBi n on N.Crenoteid = T.Crenoteid
where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and (type = 'Balloon' or( Type = 'FundingOrRepayment' and Amount>0) Or Type = 'ScheduledPrincipalPaid')
--and T.Crenoteid = 'Ritz Phtm A'
group by T.Crenoteid,  T.NoteID
--Select * from Dw.NoteBi


