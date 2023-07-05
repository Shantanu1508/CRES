




CREATE VIEW [dbo].[Deal] AS
SELECT 
[DealName]
,[DealID] as DealKey
,[CREDealID] as [DealID]
--,[DealTypeBI] as [DealType]
--,[LoanProgramBI] as [LoanProgram]
--,[LoanPurposeBI] as [LoanPurpose]
,[DealStatusBI] as [Status]
--,[AppReceived]
--,[EstClosingDate]
,[BorrowerRequest]
,[RecommendedLoan]
,[TotalFutureFunding]
--,[SourceBI] as [Source]
,[BrokerageFirm]
,[BrokerageContact]
,[Sponsor]
,[Principal]
,[NetWorth]
,[Liquidity]
,[ClientDealID]
,[GeneratedBy]
,[TotalCommitment]
,[AdjustedTotalCommitment]
,[AggregatedTotal]
,[AssetManagerComment]

,AMUserBI as [AssetManager]
,AssetManagerBI = substring(AMUserBI, charindex(',', replace(AMUserBI, ' ', '')) + 1, len(AMUserBI)) 
  + ' ' 
  + left(AMUserBI, charindex(',', AMUserBI) -1)  

,[DealCity]
,[DealState]
,[DealPropertyType]
,[FullyExtMaturityDate]
,[ImportBIDate]

,AMTeamLeadUserBI as [LeadAssetManager]
, TeamLeadAMBI = substring(AMTeamLeadUserBI, charindex(',', replace(AMTeamLeadUserBI, ' ', '')) + 1, len(AMTeamLeadUserBI)) 
  + ' ' 
  + left(AMTeamLeadUserBI, charindex(',', AMTeamLeadUserBI) -1)  

,AMSecondUserBI as [SecondaryAssetManager]
, SecondaryAMBI= substring(AMSecondUserBI, charindex(',', replace(AMSecondUserBI, ' ', '')) + 1, len(AMSecondUserBI)) 
  + ' ' 
  + left(AMSecondUserBI, charindex(',', AMSecondUserBI) -1)  

,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,isUpsize_refi = Case When DealName Like '%Upsize%' Then 'Yes'
	  When DealName Like '%Refi' Then 'Yes'
	  Else 'No'
	  End
FROM [DW].[DealBI]






