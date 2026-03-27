CREATE View [dbo].[NoteParticipation_Master]

As


Select T.*
, P.[DealID] CreDeal
, [Participation]
, [Entity] 
from dw.TransactionEntryBI T
left Join ParticipationBI P on P.Noteid = T.creNoteid
and T.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and T.AccountTypeID = 1

