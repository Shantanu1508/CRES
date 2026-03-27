  
CREATE VIEW [dbo].[vw_LiabilityNoteBI]    
AS    
SELECT [LiabilityNoteAutoID]    
,[LiabilityNoteGUID]    
,[AccountID]    
,[DealAccountID]    
,[DealID]    
,[LiabilityNoteID]    
,[LiabilityTypeID]    
,[TypeName]    
,[AssetAccountID]    
,[AssetID]    
,[PledgeDate]    
,[CurrentAdvanceRate]    
,[TargetAdvanceRate]    
,[CurrentBalance]    
,[UndrawnCapacity]    
,[CreatedBy]    
,[CreatedDate]    
,[UpdatedBy]    
,[UpdatedDate]    
,[TempBalanceAsofCalcDate]    
,[DebtEquityType]    
,LiabilitySourceText as LiabilitySource
,case when [LiabilityNoteID] like '%[_]ACPII[_]%' then 'ACP II'    
when [LiabilityNoteID] like '%[_]AOCII[_]%' then 'AOC II'    
when [LiabilityNoteID] like '%[_]AOCI[_]%' then 'AOC I'    
when [LiabilityNoteID] like '%[_]ACPI[_]%' then 'ACP I'  
else 'N/A'    
end as AbbreviationName   , 
[LatestMaturityDate],
[LatestEffectiveDate]
FROM [DW].[LiabilityNoteBI]    