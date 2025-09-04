
CREATE PROCEDURE [DW].[usp_UpdateDealNotePropertyNewColumnForWells]
AS
BEGIN
	SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


--ImportDataFromBackshopViews to landing tables
EXEC [dbo].[usp_ImportDataFromBackshopViews]


--Import servicing data from Backshop
TRUNCATE TABLE [CRE].[ServicingFeeSchedule]
INSERT INTO [CRE].[ServicingFeeSchedule]([AcoreServicingFeeScheduleId],[InvestorId],[MinimumBalance],[MaximumBalance],[FeePct],CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
Select [AcoreServicingFeeScheduleId],[InvestorId],[MinimumBalance],[MaximumBalance],[FeePct], [AuditAddUserid] ,[AuditAddDate],[AuditUpdateUserid],[AuditUpdateDate] 
from tblzCdAcoreServicingFeeSchedule


EXEC [DW].[usp_UpdateDealNewColumnForWells]

EXEC [DW].[usp_UpdateNoteNewColumnForWells]

EXEC [DW].[usp_UpdatePropertyNewColumnForWells]


--Update speciaal character (which throw error export well file)
Update cre.deal set FederalID1 = null ,updatedBy = User_Name(),updatedDate = getdate() where FederalID1 not like '%[a-z]%'
Update cre.note set WF_FederalID1 = null ,updatedBy = User_Name(),updatedDate = getdate() where WF_FederalID1 not like '%[a-z]%'
Update cre.deal set FederalID1 = null ,updatedBy = User_Name(),updatedDate = getdate() where LEN(FederalID1) = 26 and FederalID1 is not null
Update cre.note set WF_FederalID1 = null ,updatedBy = User_Name(),updatedDate = getdate() where LEN(WF_FederalID1) = 26 and WF_FederalID1 is not null

update CRE.Note set TaxVendorLoanNumber = 'NA' Where TaxVendorLoanNumber is null


SET TRANSACTION ISOLATION LEVEL READ COMMITTED


END