
CREATE View [dbo].[vw_NoteAdjustedCommitmentByperiodenddate] 
AS
select notekey,periodenddate ,adj.NoteAdjustedTotalCommitment,adj.NoteTotalCommitment
from noteperiodiccalc nc
Outer apply    
(  
	
	Select NoteID,NoteAdjustedTotalCommitment ,NoteTotalCommitment
	From(			
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
		,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno	
		From [DW].[TotalCommitmentDataBI] nd

		where noteid =  nc.notekey --'16361'
		and [Date] <= CAST(nc.periodenddate as Date)
	)a
	where rno =  1 

) adj  

go