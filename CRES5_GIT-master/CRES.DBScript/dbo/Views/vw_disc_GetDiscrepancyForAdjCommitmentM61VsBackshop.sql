CREATE VIEW [DBO].[vw_disc_GetDiscrepancyForAdjCommitmentM61VsBackshop]
AS
SELECT
[Deal Name]						
,[Deal ID]						
,[Note ID]						
,[Note Name]						
,[Financing Source]				
,[Enable M61 Calculation]		
,[M61_NoteAdjustedTotalCommitment]	
,[TotalCurrentAdjustedCommitment]
,[Delta]							
,[Deal Type]						
,[Payoff Date]					
,[LastUpdatedDate]
FROM [DW].[tbl_GetDiscrepancyForAdjCommitmentM61VsBackshop];
