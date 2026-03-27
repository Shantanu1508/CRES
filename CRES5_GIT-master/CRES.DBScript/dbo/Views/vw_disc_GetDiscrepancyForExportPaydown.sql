CREATE VIEW [DBO].[vw_disc_GetDiscrepancyForExportPaydown]
AS
SELECT
[Deal Name]	
,[Deal ID]	
,[Note ID]	
,[Note Name]	
,[Date]		
,[M61 Amount]
,[BS Amount]	
,[Delta]		
,[LastUpdatedDate]
FROM [DW].[tbl_GetDiscrepancyForExportPaydown];
