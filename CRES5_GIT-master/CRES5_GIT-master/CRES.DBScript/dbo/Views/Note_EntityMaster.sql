
CREATE view [dbo].[Note_EntityMaster]

as
Select N.*, DealName,  DealgroupID, LoanStatus, Client, Fund, AssetManager, Banker,Credit, Pool
, FinancingSource 
, DebtType
,NM.Capstack as NoteMatrix_Capstack
,BillingNote
,Commitment
,Spread
,Floor
,Type

,[PaidOffSold]
,[FeesStart]
,[RSLIC]
,[SNCC]

,[PIIC]
,[TMR]
,[HCC]
,[USSIC]

,[TMNF]

,[HAIH]
,[Check]


,[PremDisc]

,[Other]
from Dw.NoteBI N 
Left JOin Dw.NoteMatrixBI NM
on N.crenoteid = NM.Noteid




