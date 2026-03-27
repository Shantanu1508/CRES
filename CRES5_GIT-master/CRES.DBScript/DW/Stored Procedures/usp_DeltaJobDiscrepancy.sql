CREATE PROCEDURE [DW].[usp_DeltaJobDiscrepancy]
AS
BEGIN

	SET NOCOUNT ON;

	EXEC [DW].[usp_ImportGetDiscrepancyForFFBetweenM61andBackshop];
	EXEC [DW].[usp_ImportGetDiscrepancyForExportPaydown];
	EXEC [DW].[usp_ImportGetDiscrepancyForDuplicatePIK_InBackshop];
	EXEC [DW].[usp_ImportGetDiscrepancyForBalanceM61VsBackshop];
	EXEC [DW].[usp_ImportGetDiscrepancyForAdjCommitmentM61VsBackshop];
END