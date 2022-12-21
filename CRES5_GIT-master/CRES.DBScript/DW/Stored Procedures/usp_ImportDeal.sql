
CREATE PROCEDURE [DW].[usp_ImportDeal]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_DealBI',GETDATE())

	DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


IF EXISTS(Select DealID from [dw].[DealBI])
BEGIN

Truncate table [DW].[L_DealBI]

INSERT INTO [DW].[L_DealBI]
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
,AMTeamLeadUserID
,AMSecondUserID
,AMTeamLeadUserBI
,AMSecondUserBI
,AMUserID
,AMUserBI
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]

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
Select
d.[DealID],
d.[DealName],
d.[CREDealID],
d.[DealType],
d.[LoanProgram],
d.[LoanPurpose],
d.[Status],
d.[AppReceived],
d.[EstClosingDate],
d.[BorrowerRequest],
d.[RecommendedLoan],
d.[TotalFutureFunding],
d.[Source],
d.[BrokerageFirm],
d.[BrokerageContact],
d.[Sponsor],
d.[Principal],
d.[NetWorth],
d.[Liquidity],
d.[ClientDealID],
d.[GeneratedBy],
d.[TotalCommitment],
d.[AdjustedTotalCommitment],
d.[AggregatedTotal],
d.[AssetManagerComment],
d.[AssetManager],
d.[DealCity],
d.[DealState],
d.[DealPropertyType],
d.[FullyExtMaturityDate],
d.[UnderwritingStatus],
lDealType.Name as [DealTypeBI],
lLoanProgram.Name as [LoanProgramBI],
lLoanPurpose.Name as [LoanPurposeBI],
lStatus.Name as [DealStatusBI],
lSource.Name as [SourceBI],
lUnderwritingStatus.Name as  [UnderwritingStatusBI],
AMTeamLeadUserID,
AMSecondUserID,
LTRIM(RTRIM(uAmLead.lastname))+', '+LTRIM(RTRIM(uAmLead.Firstname)) as AMTeamLeadUserBI,
LTRIM(RTRIM(uAmSec.lastname))+', '+LTRIM(RTRIM(uAmSec.Firstname)) as AMSecondUserBI,		
AMUserID,
LTRIM(RTRIM(uAm.lastname))+', '+LTRIM(RTRIM(uAm.Firstname)) as AMUserBI,
(CASE When EXISTS (SELECT 1 WHERE d.[CreatedBy] LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
THEN (select  top 1 u.[Login]  from App.[User] u where u.UserID =  d.[CreatedBy]) 
ELSE d.[CreatedBy] END) as [CreatedBy],
d.[CreatedDate],
(CASE When EXISTS (SELECT 1 WHERE d.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
THEN (select  top 1 u.[Login]  from App.[User] u where u.UserID =  d.UpdatedBy) 
ELSE d.UpdatedBy END) as UpdatedBy,
d.[UpdatedDate],

d.DealTypeMasterID,
dtm.DealTypeName as DealTypeMasterBI,
d.InquiryDate	,
d.BalanceAware,
d.BS_CollateralStatusDesc	,
d.BS_CollateralStatusDesclatest,
d.PropertyTypeMajorID,
ptm.PropertyTypeMajorDesc as PropertyTypeMajorBI,
d.BSCity,
d.BSState,
d.MSA_NAME,
d.LoanStatusID,
ls.LoanStatusDesc as LoanStatusBI


FROM CRE.Deal d
LEFT Join Core.Lookup lDealType on d.DealType=lDealType.LookupID
LEFT Join Core.Lookup lLoanProgram on d.LoanProgram=lLoanProgram.LookupID
LEFT Join Core.Lookup lLoanPurpose on d.LoanPurpose=lLoanPurpose.LookupID
LEFT Join Core.Lookup lStatus on d.Status=lStatus.LookupID
LEFT Join Core.Lookup lSource on d.Source=lSource.LookupID
LEFT Join Core.Lookup lUnderwritingStatus on d.UnderwritingStatus=lUnderwritingStatus.LookupID
left join app.[User] uAmLead on uAmLead.UserID = d.AMTeamLeadUserID
left join app.[User] uAmSec on uAmSec.UserID = d.AMSecondUserID
left join app.[User] uAm on uAm.UserID = d.AMUserID

LEFT Join cre.DealTypeMaster dtm on d.DealTypeMasterID=dtm.DealTypeMasterID
LEFT Join cre.PropertyTypeMajor ptm on ptm.PropertyTypeMajorID = d.PropertyTypeMajorID
LEFT Join cre.LoanStatus ls on d.LoanStatusID=ls.LoanStatusID

WHERE d.isdeleted <> 1
and (d.CreatedDate > @LastBatchStart 
	and d.CreatedDate < @CurrentBatchStart) 
	OR 
	(d.UpdatedDate > @LastBatchStart 
	and d.UpdatedDate < @CurrentBatchStart)


SET @RowCount = @@ROWCOUNT
Print(char(9) +'usp_ImportDeal - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END
ELSE
BEGIN

Truncate table [DW].[L_DealBI]
INSERT INTO [DW].[L_DealBI]
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
,AMTeamLeadUserID
,AMSecondUserID
,AMTeamLeadUserBI
,AMSecondUserBI
,AMUserID
,AMUserBI
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]

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
Select
d.[DealID],
d.[DealName],
d.[CREDealID],
d.[DealType],
d.[LoanProgram],
d.[LoanPurpose],
d.[Status],
d.[AppReceived],
d.[EstClosingDate],
d.[BorrowerRequest],
d.[RecommendedLoan],
d.[TotalFutureFunding],
d.[Source],
d.[BrokerageFirm],
d.[BrokerageContact],
d.[Sponsor],
d.[Principal],
d.[NetWorth],
d.[Liquidity],
d.[ClientDealID],
d.[GeneratedBy],
d.[TotalCommitment],
d.[AdjustedTotalCommitment],
d.[AggregatedTotal],
d.[AssetManagerComment],
d.[AssetManager],
d.[DealCity],
d.[DealState],
d.[DealPropertyType],
d.[FullyExtMaturityDate],
d.[UnderwritingStatus],
lDealType.Name as [DealTypeBI],
lLoanProgram.Name as [LoanProgramBI],
lLoanPurpose.Name as [LoanPurposeBI],
lStatus.Name as [DealStatusBI],
lSource.Name as [SourceBI],
lUnderwritingStatus.Name as  [UnderwritingStatusBI],
AMTeamLeadUserID,
AMSecondUserID,
LTRIM(RTRIM(uAmLead.lastname))+', '+LTRIM(RTRIM(uAmLead.Firstname)) as AMTeamLeadUserBI,
LTRIM(RTRIM(uAmSec.lastname))+', '+LTRIM(RTRIM(uAmSec.Firstname)) as AMSecondUserBI,		
AMUserID,
LTRIM(RTRIM(uAm.lastname))+', '+LTRIM(RTRIM(uAm.Firstname)) as AMUserBI,
(CASE When EXISTS (SELECT 1 WHERE d.[CreatedBy] LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
THEN (select  top 1 u.[Login]  from App.[User] u where u.UserID =  d.[CreatedBy]) 
ELSE d.[CreatedBy] END) as [CreatedBy],
d.[CreatedDate],
(CASE When EXISTS (SELECT 1 WHERE d.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
THEN (select  top 1 u.[Login]  from App.[User] u where u.UserID =  d.UpdatedBy) 
ELSE d.UpdatedBy END) as UpdatedBy,
d.[UpdatedDate],

d.DealTypeMasterID,
dtm.DealTypeName as DealTypeMasterBI,
d.InquiryDate	,
d.BalanceAware,
d.BS_CollateralStatusDesc	,
d.BS_CollateralStatusDesclatest,
d.PropertyTypeMajorID,
ptm.PropertyTypeMajorDesc as PropertyTypeMajorBI,
d.BSCity,
d.BSState,
d.MSA_NAME,
d.LoanStatusID,
ls.LoanStatusDesc as LoanStatusBI


FROM CRE.Deal d
LEFT Join Core.Lookup lDealType on d.DealType=lDealType.LookupID
LEFT Join Core.Lookup lLoanProgram on d.LoanProgram=lLoanProgram.LookupID
LEFT Join Core.Lookup lLoanPurpose on d.LoanPurpose=lLoanPurpose.LookupID
LEFT Join Core.Lookup lStatus on d.Status=lStatus.LookupID
LEFT Join Core.Lookup lSource on d.Source=lSource.LookupID
LEFT Join Core.Lookup lUnderwritingStatus on d.UnderwritingStatus=lUnderwritingStatus.LookupID
left join app.[User] uAmLead on uAmLead.UserID = d.AMTeamLeadUserID
left join app.[User] uAmSec on uAmSec.UserID = d.AMSecondUserID
left join app.[User] uAm on uAm.UserID = d.AMUserID

LEFT Join cre.DealTypeMaster dtm on d.DealTypeMasterID=dtm.DealTypeMasterID
LEFT Join cre.PropertyTypeMajor ptm on ptm.PropertyTypeMajorID = d.PropertyTypeMajorID
LEFT Join cre.LoanStatus ls on d.LoanStatusID=ls.LoanStatusID
	WHERE d.isdeleted <> 1


SET @RowCount = @@ROWCOUNT
Print(char(9) +char(9)+'usp_ImportDeal - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END




UPDATE [DW].BatchDetail
SET
LandingEndTime = GETDATE(),
LandingRecordCount = @RowCount
WHERE BatchDetailId = @id





END


