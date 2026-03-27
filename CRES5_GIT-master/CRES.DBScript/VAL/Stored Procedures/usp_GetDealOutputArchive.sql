  
CREATE PROCEDURE [Val].[usp_GetDealOutputArchive]  
  @MarkedDate date
AS        
BEGIN        
 SET NOCOUNT ON;        
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
	select 
	do.CalculationStatus
	,[LastCalculatedon]	 
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
	from [VAL].[DealOutputArchive] do
	Inner join [val].Archivemaster am on am.ArchivemasterID = do.ArchivemasterID and am.Isdeleted <> 1
	left join cre.deal d on d.dealid = do.dealid
	left Join Core.lookup lPayoffExtended on lPayoffExtended.lookupid = do.PayoffExtended

	Inner Join [VAL].[MarkedDateMaster] md on md.MarkedDateMasterID = am.MarkedDateMasterID

	Where md.MarkedDate = @MarkedDate	

	
	    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
END    
  