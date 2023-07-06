

CREATE PROCEDURE [DW].[usp_MergeDeal]

@BatchLogId int

AS
BEGIN

SET NOCOUNT ON


UPDATE [DW].BatchDetail
SET
BITableName = 'DealBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DealBI'


MERGE [DW].DealBI DB
USING [DW].L_DealBI LDB
ON DB.DealID = LDB.DealID
WHEN MATCHED THEN
	UPDATE 
	SET 
	DB.[DealName] = LDB.[DealName],
	DB.[CREDealID] = LDB.[CREDealID],
	DB.[DealType] = LDB.[DealType],
	DB.[LoanProgram] = LDB.[LoanProgram],
	DB.[LoanPurpose] = LDB.[LoanPurpose],
	DB.[Status] = LDB.[Status],
	DB.[AppReceived] = LDB.[AppReceived],
	DB.[EstClosingDate] = LDB.[EstClosingDate],
	DB.[BorrowerRequest] = LDB.[BorrowerRequest],
	DB.[RecommendedLoan] = LDB.[RecommendedLoan],
	DB.[TotalFutureFunding] = LDB.[TotalFutureFunding],
	DB.[Source] = LDB.[Source],
	DB.[BrokerageFirm] = LDB.[BrokerageFirm],
	DB.[BrokerageContact] = LDB.[BrokerageContact],
	DB.[Sponsor] = LDB.[Sponsor],
	DB.[Principal] = LDB.[Principal],
	DB.[NetWorth] = LDB.[NetWorth],
	DB.[Liquidity] = LDB.[Liquidity],
	DB.[ClientDealID] = LDB.[ClientDealID],
	DB.[GeneratedBy] = LDB.[GeneratedBy],
	DB.[TotalCommitment] = LDB.[TotalCommitment],
	DB.[AdjustedTotalCommitment] = LDB.[AdjustedTotalCommitment],
	DB.[AggregatedTotal] = LDB.[AggregatedTotal],
	DB.[AssetManagerComment] = LDB.[AssetManagerComment],
	DB.[AssetManager] = LDB.[AssetManager],
	DB.[DealCity] = LDB.[DealCity],
	DB.[DealState] = LDB.[DealState],
	DB.[DealPropertyType] = LDB.[DealPropertyType],
	DB.[FullyExtMaturityDate] = LDB.[FullyExtMaturityDate],
	DB.[UnderwritingStatus]= LDB.[UnderwritingStatus],
	
	DB.[DealTypeBI] = LDB.[DealTypeBI],
	DB.[LoanProgramBI] = LDB.[LoanProgramBI],
	DB.[LoanPurposeBI] = LDB.[LoanPurposeBI],
	DB.[DealStatusBI] = LDB.[DealStatusBI],
	DB.[SourceBI] = LDB.[SourceBI],
	DB.[UnderwritingStatusBI]= LDB.[UnderwritingStatusBI],
	DB.[ImportBIDate] = GETDATE(),
	DB.[CreatedBy] = LDB.[CreatedBy],
	DB.[CreatedDate] = LDB.[CreatedDate],
	DB.[UpdatedBy] = LDB.[UpdatedBy],
	DB.[UpdatedDate] = LDB.[UpdatedDate],
	DB.AMTeamLeadUserID = LDB.AMTeamLeadUserID,
	DB.AMSecondUserID = LDB.AMSecondUserID,
	DB.AMTeamLeadUserBI = LDB.AMTeamLeadUserBI,
	DB.AMSecondUserBI = LDB.AMSecondUserBI,
	DB.AMUserID = LDB.AMUserID,
	DB.AMUserBI = LDB.AMUserBI,

	DB.DealTypeMasterID = LDB.DealTypeMasterID,
	DB.DealTypeMasterBI = LDB.DealTypeMasterBI,
	DB.InquiryDate = LDB.InquiryDate,
	DB.BalanceAware = LDB.BalanceAware,
	DB.BS_CollateralStatusDesc = LDB.BS_CollateralStatusDesc,
	DB.BS_CollateralStatusDesclatest = LDB.BS_CollateralStatusDesclatest,
	DB.PropertyTypeMajorID = LDB.PropertyTypeMajorID,
	DB.PropertyTypeMajorBI = LDB.PropertyTypeMajorBI,
	DB.BSCity = LDB.BSCity,
	DB.BSState = LDB.BSState,
	DB.MSA_NAME = LDB.MSA_NAME,
	DB.LoanStatusID = LDB.LoanStatusID,
	DB.LoanStatusBI = LDB.LoanStatusBI

WHEN NOT MATCHED THEN
	
	INSERT 
	([DealID]
	,[DealName]
	,[CREDealID]
	,[DealType]
	,[LoanProgram]
	,[LoanPurpose]
	,[Status]
	,[AppReceived]
	,[EstClosingDate]
	,[BorrowerRequest]
	,[RecommendedLoan]
	,[TotalFutureFunding]
	,[Source]
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
	,[AssetManager]
	,[DealCity]
	,[DealState]
	,[DealPropertyType]
	,[FullyExtMaturityDate]
	,[UnderwritingStatus]
	,[DealTypeBI]
	,[LoanProgramBI]
	,[LoanPurposeBI]
	,[DealStatusBI]
	,[SourceBI]
	,[UnderwritingStatusBI]
	,[ImportBIDate]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]
	,AMTeamLeadUserID
	,AMSecondUserID
	,AMTeamLeadUserBI
	,AMSecondUserBI
	,AMUserID
	,AMUserBI	
	,DealTypeMasterID
,DealTypeMasterBI
,InquiryDate	
,BalanceAware
,BS_CollateralStatusDesc	
,BS_CollateralStatusDesclatest
,PropertyTypeMajorID
,PropertyTypeMajorBI
,BSCity
,BSState
,MSA_NAME
,LoanStatusID
,LoanStatusBI)

VALUES (LDB.[DealID],
LDB.[DealName],
LDB.[CREDealID],
LDB.[DealType],
LDB.[LoanProgram],
LDB.[LoanPurpose],
LDB.[Status],
LDB.[AppReceived],
LDB.[EstClosingDate],
LDB.[BorrowerRequest],
LDB.[RecommendedLoan],
LDB.[TotalFutureFunding],
LDB.[Source],
LDB.[BrokerageFirm],
LDB.[BrokerageContact],
LDB.[Sponsor],
LDB.[Principal],
LDB.[NetWorth],
LDB.[Liquidity],
LDB.[ClientDealID],
LDB.[GeneratedBy],
LDB.[TotalCommitment],
LDB.[AdjustedTotalCommitment],
LDB.[AggregatedTotal],
LDB.[AssetManagerComment],
LDB.[AssetManager],
LDB.[DealCity],
LDB.[DealState],
LDB.[DealPropertyType],
LDB.[FullyExtMaturityDate],
LDB.[UnderwritingStatus],
LDB.[DealTypeBI],
LDB.[LoanProgramBI],
LDB.[LoanPurposeBI],
LDB.[DealStatusBI],
LDB.[SourceBI],
LDB.[UnderwritingStatusBI],
GETDATE(),
LDB.[CreatedBy],
LDB.[CreatedDate],
LDB.[UpdatedBy],
LDB.[UpdatedDate],	
LDB.AMTeamLeadUserID,
LDB.AMSecondUserID,
LDB.AMTeamLeadUserBI,
LDB.AMSecondUserBI,
LDB.AMUserID,
LDB.AMUserBI,
LDB.DealTypeMasterID,
LDB.DealTypeMasterBI,
LDB.InquiryDate,
LDB.BalanceAware,
LDB.BS_CollateralStatusDesc,
LDB.BS_CollateralStatusDesclatest,
LDB.PropertyTypeMajorID,
LDB.PropertyTypeMajorBI,
LDB.BSCity,
LDB.BSState,
LDB.MSA_NAME,
LDB.LoanStatusID,
LDB.LoanStatusBI
);

DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_DealBI'

Print(char(9) +'usp_MergeDeal - ROWCOUNT = '+cast(@RowCount  as varchar(100)));


END

