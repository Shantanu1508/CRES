CREATE VIEW [DBO].[vw_disc_GetDiscrepancyForBalanceM61VsBackshop]
AS
SELECT
[Deal Name]		
,[Deal ID]		
,[Note ID]		
,[Note Name]		
,[Financing Source]
,[M61_CurrentBls]
,[BS_CurrentBls]	
,[Delta]			
,[Payoff Date]	
,[LastUpdatedDate]
FROM [DW].[tbl_GetDiscrepancyForBalanceM61VsBackshop];
