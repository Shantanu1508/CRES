CREATE View DW.Deal_NoteBI_Entity
as

Select CreDealID, CRENoteID,DealName, Name NoteName,[Participation], [Entity] from [DW].[DealBI] D
inner join [DW].[NoteBI] N on D.DealID = N.DealID
Left Join ParticipationBI P on P.NoteiD = N.CreNoteID 
