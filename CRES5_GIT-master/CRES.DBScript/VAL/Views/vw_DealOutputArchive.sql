-- View
-- View
CREATE View [Val].[vw_DealOutputArchive]
AS

SELECT [MarkedDate],[DealID],[DealName], [Type], [Value]  
FROM   
(
	select am.ArchivemasterID
	,md.MarkedDate
	,d.credealid as [DealID]
	,d.dealname
	,do.[DealMarkPriceClean]
	,do.[DealGAAPPriceClean]
	,do.[DealMarkClean]
	,do.[DealUPB]
	,do.[DealCommitment]
	,do.[DealGAAPBasisDirty]
	,do.[DealYieldatParClean]
	,do.[DealYieldatGAAPBasis]
	,do.[DealMarkYield]
	,do.[CalculatedDealAccruedRate]
	,do.[DealGAAPDM_GtrFLR_Index]
	,do.[DealMarkDM_GtrFLR_Index]
	,do.[DealDuration_OnCommitment]
	,do.[GrossFloorValuefromGrid]
	,do.[GrossValue_UsageScalar]
	,do.[DollarValueofFloorinMark]
	,do.[PointvalueofFloorinMark]
	,do.[Term]
	,do.[Strike]
	,do.[MktStrike]	 
	from [val].DealOutputArchive do
	Inner join [val].Archivemaster am on am.ArchivemasterID = do.ArchivemasterID and am.Isdeleted <> 1
	Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = am.MarkedDateMasterID

	left join cre.deal d on d.dealid = do.dealid
	left Join Core.lookup lPayoffExtended on lPayoffExtended.lookupid = do.PayoffExtended
	Where d.IsDeleted <> 1 and am.isdeleted <> 1
	
) p  
UNPIVOT  
(
	[Value] FOR [Type] IN  (
		[DealMarkPriceClean]
		,[DealGAAPPriceClean]
		,[DealMarkClean]
		,[DealUPB]
		,[DealCommitment]
		,[DealGAAPBasisDirty]
		,[DealYieldatParClean]
		,[DealYieldatGAAPBasis]
		,[DealMarkYield]
		,[CalculatedDealAccruedRate]
		,[DealGAAPDM_GtrFLR_Index]
		,[DealMarkDM_GtrFLR_Index]
		,[DealDuration_OnCommitment]
		,[GrossFloorValuefromGrid]
		,[GrossValue_UsageScalar]
		,[DollarValueofFloorinMark]
		,[PointvalueofFloorinMark]
		,[Term]
		,[Strike]
		,[MktStrike]
	)  
)AS unpvt

