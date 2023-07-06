Create View DW.Deal_NoteBI
as

Select CreDealID, CRENoteID,DealName, Name NoteName from [DW].[DealBI] D
inner join [DW].[NoteBI] N on D.DealID = N.DealID
