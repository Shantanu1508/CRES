
CREATE PROCEDURE [dbo].[usp_SchedulerJobNightly] 
as 
BEGIN

	Exec [DW].[usp_UpdateNoteMatrixFields]
	Exec [DW].[usp_UpdateAMUserInDeal]
	
	--Wells Update
	Exec [DW].[usp_UpdateDealNotePropertyNewColumnForWells]

	--Delete, soft deleted tag's data
	Delete from cre.TransactionEntryClose where TagMasterID in (Select TagMasterID from cre.TagMaster where IsDeleted = 1)
	Delete from cre.TagMaster where IsDeleted = 1

END
