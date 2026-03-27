CREATE VIEW [DBO].[vw_disc_GetDiscrepancyForDuplicatePIK_InBackshop]
AS
SELECT
[Deal Name]		
,[Deal ID]		
,[Note ID]		
,[Funding Purpose]
,[Count]
,[LastUpdatedDate]
FROM [DW].[tbl_GetDiscrepancyForDuplicatePIK_InBackshop];
