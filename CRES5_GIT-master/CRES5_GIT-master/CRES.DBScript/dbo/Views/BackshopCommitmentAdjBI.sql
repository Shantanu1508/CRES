
CREATE view [dbo].[BackshopCommitmentAdjBI]
as 

Select 
[LoanNumber]
,[DealName]
,[NoteID] ,
[NoteName] ,
[AdjustmentDate],
[AdjustmentAmount]
From dw.BackshopCommitmentAdjBI

