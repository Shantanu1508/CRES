CREATE View SumPrepayandBaloon  
as  
Select Crenoteid, SUM(Prepayment)Prepayment from  
(  
select CRENoteID, ISNULL(Prepayments,0) + ISNULL(FullPayoff,0) Prepayment  from [dbo].[CurtailmentsTilldate]  
  
  
Union  
  
Select NoteID, (Case when Amount= 0.01 then 0 else Amount end)*-1 Amount from TransactionEntry  
Where Scenario = 'Default' and Type = 'Balloon' and Date <= GETDATE()  
  
)X  
Group by Crenoteid