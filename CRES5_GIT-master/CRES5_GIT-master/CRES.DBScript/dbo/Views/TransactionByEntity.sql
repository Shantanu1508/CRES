CREATE View [dbo].[TransactionByEntity]
as 
select 
TransactionByEntityBI_AutoID,
TransactionEntryAutoID,
NoteID as NoteKey,
CRENoteID as NoteID,
EntityName,
PctAllocation,
Date,
Amount,
Type,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate ,
( crenoteid+'_'+ Type + '_' + CONVERT (VARCHAR(10),Date, 110)  ) Note_Type_Date,
( crenoteid+'_'+ Type + '_' + CONVERT (VARCHAR(10),Date, 110) +'_'+EntityName ) Note_Type_Date_Entity,
FeeName ,
AnalysisName as Scenario


From [DW].[TransactionByEntityBI]
Where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'




