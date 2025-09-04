
CREATE PROCEDURE [DW].[usp_ImportTransactionByEntity]
AS
BEGIN
	SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

--Declare @analysisID UNIQUEIDENTIFIER  = (Select analysisID from core.analysis where [Name] = 'Default')



Truncate table [DW].[TransactionByEntityBI] 


INSERT INTO [DW].[TransactionByEntityBI]
(TransactionEntryID,
TransactionEntryAutoID ,
NoteID,
CRENoteID,
EntityName,
PctAllocation,
Date ,
Amount, 
Type,
CreatedBy ,
CreatedDate, 
UpdatedBy ,
UpdatedDate ,
AnalysisID,
AnalysisName,
FeeName
)
Select 
tr.TransactionEntryID,
tr.TransactionEntryAutoID ,
na.NoteID,
n.CReNoteID,
EntityName,
na.PctAllocation,	
tr.Date,
(tr.Amount * PctAllocation)  as PerAmount,
tr.Type,
tr.CreatedBy ,
tr.CreatedDate, 
tr.UpdatedBy ,
tr.UpdatedDate ,
tr.AnalysisID,
ana.AnalysisName as AnalysisName,
tr.FeeName

from CRE.NoteEntityAllocation na
inner join cre.note n on n.noteid = na.noteid
inner join cre.TransactionEntry tr on tr.AccountID = n.Account_AccountID and tr.analysisID in (Select analysisID from core.analysis where [Name] in ('Default','Expected Maturity Date (with Prepay, Index Flat)') )
and tr.Date >= CAST(DateADD(year,-1,getdate())  as Date)    ----and tr.Date <= CAST(getdate() as Date))

inner join cre.Entity e on e.entityID= na.entityID and e.EntityName in ('RSLIC','SNCC' ,'PIIC' ,'TMR' ,'HCC' ,'USSIC' ,'TMNF' ,'HAIH')

Left Join
(
	Select analysisID,Name as AnalysisName 
	from core.analysis 
	where [Name] in ('Default','Expected Maturity Date (with Prepay, Index Flat)') 
)ana on ana.analysisID = tr.analysisID

Where tr.analysisID in (Select analysisID from core.analysis where [Name] in ('Default','Expected Maturity Date (with Prepay, Index Flat)') )
and tr.Date >= CAST(DateADD(year,-1,getdate())  as Date) 



----and tr.Date <= CAST(getdate() as Date))





--Delete ncBI from [DW].[TransactionByEntityBI] ncBI
--inner join 
--(
--	Select Distinct NoteID,AnalysisID from [DW].[L_TransactionEntryBI]

--)L on L.Noteid = ncBI.Noteid and ncBI.AnalysisID = L.AnalysisID


--INSERT INTO [DW].[TransactionByEntityBI]
--(TransactionEntryID,
--TransactionEntryAutoID ,
--NoteID,
--CRENoteID,
--EntityName,
--PctAllocation,
--Date ,
--Amount, 
--Type,
--CreatedBy ,
--CreatedDate, 
--UpdatedBy ,
--UpdatedDate ,

--AnalysisID,
--AnalysisName,
--FeeName
--)
--Select
--tr.TransactionEntryID,
--tr.TransactionEntryAutoID ,
--na.NoteID,
--n.CReNoteID,
--EntityName,
--na.PctAllocation,	
--tr.Date,
--(tr.Amount * PctAllocation)  as PerAmount,
--tr.Type,
--tr.CreatedBy ,
--tr.CreatedDate, 
--tr.UpdatedBy ,
--tr.UpdatedDate ,
--tr.AnalysisID,
--an.[Name] as AnalysisName,
--tr.FeeName
--from CRE.NoteEntityAllocation na
--inner join DW.TransactionEntryBI tr on tr.noteid = na.noteid
--inner join cre.note n on n.noteid = na.noteid
--inner join cre.Entity e on e.entityID= na.entityID
--left join core.Analysis an on an.AnalysisID = tr.AnalysisID	
--Inner join (
--	Select Distinct NoteID,AnalysisID from [DW].[L_TransactionEntryBI] 
--)Landing on Landing.NoteID = tr.Noteid and Landing.AnalysisID = tr.AnalysisID





SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


