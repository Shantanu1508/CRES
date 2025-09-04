CREATE VIEW [DBO].[vw_disc_GetDiscrepancyForFFBetweenM61andBackshop]
AS
SELECT
[Deal Name]				
,[Deal ID]				
,[Note ID]				
,[M61 Funding Date]		
,[M61 Funding Amount]	
,[BS Funding Date]		
,[BS Funding Amount]		
,[Delta]					
,[LastUpdatedDate]
FROM [DW].[tbl_GetDiscrepancyForFFBetweenM61andBackshop];
