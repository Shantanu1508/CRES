CREATE View [dbo].[TotalCommitmentData] AS

SELECT
NoteID as notekey
,CRENoteID as NoteID
,Date
,TypeBI as [type]
,value as [Value]
,NoteAdjustedTotalCommitment
,NoteTotalCommitment
,Rowno
,CREDealID as DealID
,dealid as DealKey
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
From [DW].[TotalCommitmentDataBI]


go
