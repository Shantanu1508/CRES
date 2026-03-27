CREATE view [dbo].[Balloon]
As
Select ISNULL(NoteID,'None')Noteid,SUM( Amount)*-1 as Balloon 
from Transactionentry
Where Type = 'Balloon' and Scenario = 'Default'
and date <=GETDATE()
and AccountTypeID = 1
Group by Noteid
Having ABS(SUM(Amount)) > 0.01


