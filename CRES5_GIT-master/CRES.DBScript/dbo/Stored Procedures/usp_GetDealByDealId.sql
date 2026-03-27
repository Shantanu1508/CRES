-- Procedure
-- Procedure

-- [dbo].[usp_GetDealByDealId]'00000000-0000-0000-0000-000000000000','5848ca08-b9b0-4b93-9e0b-311c560f58f4'      
-- [dbo].[usp_GetDealByDealId] 'EB318B15-3EDD-4601-9C8D-2D5C4C3613BE','5848ca08-b9b0-4b93-9e0b-311c560f58f4'      
-- [dbo].[usp_GetDealByDealId] 'D73C24C9-797C-4165-8EF3-C1AE5839C513','B0E6697B-3534-4C09-BE0A-04473401AB93'      
-- [dbo].[usp_GetDealByDealId]'00000000-0000-0000-0000-000000000000','B0E6697B-3534-4C09-BE0A-04473401AB93'      
-- 11202C6C-D8A1-4C9E-9261-5F5EC311E5CA      
      
CREATE PROCEDURE [dbo].[usp_GetDealByDealId]   --'90fa31ec-a1e5-4714-a157-b4f8def20b1f','B0E6697B-3534-4C09-BE0A-04473401AB93'      
(      
 @Dealid varchar(50),      
 @UserID UNIQUEIDENTIFIER      
)      
AS      
      
BEGIN      
 SET NOCOUNT ON;      
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
      
 --if(CAST(@Dealid AS VARCHAR(500)) = '00000000-0000-0000-0000-000000000000')      
 -- BEGIN      
 --   SELECT @Dealid = d.DealID FROM CRE.Deal d WHERE CREDealID = @Dealid;      
 -- END      
      
      
      
IF EXISTS( SELECT DealID FROM CRE.Deal where CAST(DealID AS VARCHAR(500)) = @Dealid OR CREDealID = @Dealid and isdeleted=0)      
BEGIN      
      
    
    
    -- select @Dealid from CREDealID      
 SELECT @Dealid  = d.DealID FROM CRE.Deal d WHERE CAST(DealID AS VARCHAR(500)) = @Dealid OR CREDealID = @Dealid and isdeleted=0; 
 

          
 Declare @BaseCurrencyName nvarchar(max) = ISNULL((SELECT TOP 1  ISNULL(REPLACE(l.Name,'CAD','USD'),'USD') as Name      
           FROM cre.note n      
           left join  core.account acc on n.Account_AccountID = acc.AccountID      
           left join core.lookup l on l.lookupid = acc.BaseCurrencyID      
           left join cre.deal d on d.DealID = n.DealID      
           WHERE d.DealID = @Dealid      
           ORDER BY case when l.Name = 'USD' then 9999 else 1 end desc) ,'USD')      
       
 Declare @MinAccrualFrequency int = (SELECT min(AccrualFrequency) from CRE.Note where DealID = @Dealid);      
 Declare @AllowFundingFlag bit = (SELECT [Value] from [App].[AppConfig] where [key]='AllowFundingDevData');       
 Declare @AllowFFSaveJsonIntoBlob bit = (SELECT [Value] from [App].[AppConfig] where [key]='AllowFFSaveJsonIntoBlob');       
           
 Declare @max_ExtensionMat date = null;      
      
 Declare @last_wireconfirmdate_db date;      
 SET @last_wireconfirmdate_db = (Select MAX([date]) from cre.dealfunding where applied = 1 and dealid = @Dealid)  
 
  --shahid
        declare @XIRRConfigID int
        select @XIRRConfigID=XIRRConfigID from cre.XIRRConfig where ReturnName='Whole Loan Return (Excl. 3rd Party)'
 --
       
 Select @max_ExtensionMat = MAX(mat.MaturityDate)      
 from [CORE].Maturity mat            
 INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId      
 INNER JOIN           
 (             
  Select             
  (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,               
  MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve            
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID            
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID            
  where EventTypeID = 11   and eve.StatusID = 1         
  and acc.IsDeleted = 0        
  and n.dealid = @Dealid      
  GROUP BY n.Account_AccountID,EventTypeID           
 ) sEvent            
 ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = 1       
 INNER JOIN [CRE].[Note] nt   on nt.Account_AccountID = sEvent.AccountID       
 where mat.MaturityType = 709       
 and mat.Approved = 3      
       
      
 SELECT d.DealID      
 ,DealName      
 ,DealType      
 ,l1.name DealTypeText      
 ,LoanProgram           
 ,l2.name LoanProgramText      
 ,LoanPurpose      
 ,l3.name LoanPurposeText      
 ,Status      
 ,l4.name StatusText      
 ,AppReceived        
 ,EstClosingDate       
 , BorrowerRequest      
 ,l5.Name BorrowerRequestText      
 ,RecommendedLoan      
 ,TotalFutureFunding      
 ,Source      
 ,l6.Name SourceText      
 ,BrokerageFirm      
 ,BrokerageContact      
 ,Sponsor      
 ,Principal      
 ,NetWorth      
 ,Liquidity      
 ,ClientDealID      
 ,CREDealID      
 ,d.TotalCommitment      
 ,d.AdjustedTotalCommitment      
 ,d.AggregatedTotal      
 ,d.AssetManagerComment     ,d.CreatedBy      
 ,d.CreatedDate      
 ,d.UpdatedBy      
 ,d.LinkedDealID      
 ,d.UpdatedDate       
 ,d.DealComment      
 ,UnderwritingStatus      
 ,l7.name UnderwritingStatusText      
 ,(case when r.roleName is not null then (u.FirstName+' '+u.LastName) else null end) as AssetManager      
 ,(case when r.roleName is not null then AMUserID else null end) as AMUserID      
 ,(case when rTeam.roleName is not null then AMTeamLeadUserID else null end) as AMTeamLeadUserID      
 ,(case when rSec.roleName is not null then AMSecondUserID else null end) as AMSecondUserID      
 ,DealCity      
 ,DealState      
 ,DealPropertyType      
 ,FullyExtMaturityDate      
 ,d.AllowSizerUpload      
 ,l8.Name as AllowSizerUploadText      
 --DATENAME(weekday,(Select Max(df.UpdatedDate)  from [CRE].[DealFunding] df where df.DealID = d.DealID))+ ', ' + CONVERT(varchar,dbo.[ufn_GetTimeByTimeZone]((Select Max(df.UpdatedDate)
 --from [CRE].[DealFunding] df where df.DealID = d.DealID),@UserID),100) as lastUpdatedFF      
 ,dbo.[ufn_GetTimeByTimeZone]((Select Max(df.UpdatedDate)  from [CRE].[DealFunding] df where df.DealID = d.DealID),@UserID)as lastUpdatedFF      
 --,(Select Max(df.UpdatedDate) from [CRE].[DealFunding] df where df.DealID = d.DealID) as lastUpdatedFF      
 --,(select  top 1 FirstName +' '+ LastName from CRE.DealFunding  df left join App.[User]  u  on u.UserID =  df.UpdatedBy) as LastUpdatedByFF      
 ,
 (CASE When EXISTS (SELECT 1 WHERE d.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) THEN 
 (select  top 1 FirstName +' '+ LastName from CRE.DealFunding  df left join App.[User]  u  on u.UserID =  df.UpdatedBy where df.DealID=@Dealid) ELSE d.UpdatedBy END) as LastUpdatedByFF      
 ,200 AS StatusCode       
 ,(Select Cast(format(Max(df.UpdatedDate),'MM/dd/yyyy hh:mm:ss tt') as nvarchar(256))  from [CRE].[DealFunding] df where df.DealID = d.DealID) as LastUpdatedFF_String      
 ,d.DealRule      
 ,d.BoxDocumentLink       
 ,d.DealGroupID        
 ,d.EnableAutoSpread      
 ,ISNULL(a.DayoftheMonth,29) as ServicerDropDate      
 ,ISNULL(a.DayoftheMonth,29) as ServicereDayAjustement      
 ,d.AmortizationMethod       
 ,lAmortizationMethod.Name as AmortizationMethodText      
 ,d.ReduceAmortizationForCurtailments       
 ,lReduceAmortizationForCurtailments.Name as ReduceAmortizationForCurtailmentsText      
 ,d.BusinessDayAdjustmentForAmort       
 ,lBusinessDayAdjustmentForAmort.Name as BusinessDayAdjustmentForAmortText      
 ,d.NoteDistributionMethod       
 ,lNoteDistributionMethod.Name as NoteDistributionMethodText      
 ,d.PeriodicStraightLineAmortOverride      
 ,d.FixedPeriodicPayment      
 ,@BaseCurrencyName as BaseCurrencyName      
 ,a.FirstPaymentDate      
 ,d.EquityAmount      
 ,isnull(d.RemainingAmount,0) as RemainingAmount      
 ,d.EnableAutoSpreadRepayments      
 ,d.AutoUpdateFromUnderwriting      
 ,d.ExpectedFullRepaymentDate      
 ,d.RepaymentAutoSpreadMethodID      
 ,lRepaymentAutoSpreadMethod.Name as RepaymentAutoSpreadMethodText      
 ,d.RepaymentStartDate      
 ,d.EarliestPossibleRepaymentDate      
 ,d.Blockoutperiod      
 ,d.PossibleRepaymentdayofthemonth      
 ,d.Repaymentallocationfrequency      
 ,d.AutoPrepayEffectiveDate      
 ,d.LatestPossibleRepaymentDate      
 --,d.KnownFullPayoffDate      
 ,@MinAccrualFrequency as MinAccrualFrequency      
 ,@AllowFundingFlag as AllowFundingFlag      
 ,@AllowFFSaveJsonIntoBlob as AllowFFSaveJsonIntoBlob      
 ,d.DealLevelMaturity      
 ,d.ApplyNoteLevelPaydowns      
 ,d.IsREODeal      
 ,@max_ExtensionMat as max_ExtensionMat      
 ,d.BalanceAware      
 ,tlbprepay.EffectiveDate_Prepay           
 ,tlbprepay.CalcThru     
 ,tlbprepay.PrepaymentMethod      
 ,tlbprepay.PrepaymentMethodText      
 ,tlbprepay.BaseAmountType      
 ,tlbprepay.BaseAmountTypeText      
 ,tlbprepay.SpreadCalcMethod      
 ,tlbprepay.SpreadCalcMethodtext      
 ,tlbprepay.GreaterOfSMOrBaseAmtTimeSpread      
 ,tlbprepay.HasNoteLevelSMSchedule      
 ,tlbprepay.Includefeesincredits    
 ,tlbprepay.MinimumMultipleDue
 ,tlbprepay.OpenPaymentDate
 ,@last_wireconfirmdate_db as LastWireConfirmDate_db      
 ,d.PropertyTypeMajorID    
 ,d.LoanStatusID 
 ,d.PrepayDate
 ,d.ICMFullyFundedEquity
 ,d.EquityAtClosing 
 ,d.CalcEngineType
 ,lCalcEngineType.name as CalcEngineTypeText
,d.AllowGaapComponentInCashflowDownload
,lAllowGaapComponentInCashflowDownload.name as AllowGaapComponentInCashflowDownloadText
,WatchlistStatus as  WatchlistStatus
,d.AccountID as DealAccountID
 ,xd.XIRRValue
 ,d.EnableAutoDistributePrincipalWriteoff
 ,d.PrepaymentGroupSize
,d.PrepaymentAllocationMethod
,b.Bookmark
,d.MaturityAdjMonthsOverride
,d.ExcludeDealFromLiability
,LiabilitySource
,lLiabilitySource.name as LiabilitySourceText
,InternalRefi      
,l11.Name InternalRefiText
,PortfolioLoan      
,l12.Name PortfolioLoanText
,AssigningLoanToTakeoutLender      
,l14.Name AssigningLoanToTakeoutLenderText  
,NettingofReservesEscrows      
,l15.Name NettingofReservesEscrowsText  
,CASE WHEN ls.LoanStatusDesc IS NULL Then 'N' ELSE 'Y' END AS isPipeline

 FROM CRE.Deal d      
 Left Join Core.Lookup l1 on d.DealType=l1.LookupID      
 Left Join Core.Lookup l2 on d.LoanProgram=l2.LookupID      
 Left Join Core.Lookup l3 on d.LoanPurpose=l3.LookupID      
 Left Join Core.Lookup l4 on d.Status=l4.LookupID      
 Left Join Core.Lookup l5 on d.BorrowerRequest=l5.LookupID      
 Left Join Core.Lookup l6 on d.Source=l6.LookupID      
 Left Join Core.Lookup l7 on d.Source=l7.LookupID      
 Left Join Core.Lookup l8 on d.AllowSizerUpload=l8.LookupID      
 left join app.[User] u on d.AMUserID = u.UserID      
 left join app.[User] uTeam on d.AMTeamLeadUserID = uTeam.UserID      
 left join app.[User] uSec on d.AMSecondUserID = uSec.UserID      
 left join app.UserRoleMap ur on u.UserID=ur.UserID      
 left join app.UserRoleMap urTeam on uTeam.UserID=urTeam.UserID      
 left join app.UserRoleMap urSec on uSec.UserID=urSec.UserID      
 left join app.role r on ur.RoleID=r.RoleID  and r.roleName='Asset Manager'      
 left join app.role rTeam on urTeam.RoleID=rTeam.RoleID  and rTeam.roleName='Asset Manager'      
 left join app.role rSec on urSec.RoleID=rSec.RoleID  and rSec.roleName='Asset Manager'      
 Left Join Core.Lookup lAmortizationMethod on d.AmortizationMethod=lAmortizationMethod.LookupID      
 Left Join Core.Lookup lReduceAmortizationForCurtailments on d.ReduceAmortizationForCurtailments=lReduceAmortizationForCurtailments.LookupID      
 Left Join Core.Lookup lBusinessDayAdjustmentForAmort on d.BusinessDayAdjustmentForAmort=lBusinessDayAdjustmentForAmort.LookupID      
 Left Join Core.Lookup lNoteDistributionMethod on d.NoteDistributionMethod=lNoteDistributionMethod.LookupID   
 Left Join Core.Lookup lAllowGaapComponentInCashflowDownload on d.AllowGaapComponentInCashflowDownload=lAllowGaapComponentInCashflowDownload.LookupID 
 Left Join Core.Lookup lLiabilitySource on d.LiabilitySource=lLiabilitySource.LookupID 
  
 Left Join Core.Lookup l11 on d.InternalRefi=l11.LookupID    
 Left Join Core.Lookup l12 on d.PortfolioLoan=l12.LookupID      
 Left Join Core.Lookup l14 on d.AssigningLoanToTakeoutLender=l14.LookupID      
 Left Join Core.Lookup l15 on d.NettingofReservesEscrows=l15.LookupID      

 Left Join (      
  SELECT top 1  dd.DealID,n.DayoftheMonth,min(n.FirstPaymentDate) as FirstPaymentDate        
  FROM [CRE].[Deal] dd        
  left join [CRE].[Note] n on n.DealID=dd.dealid        
  WHERE n.FirstPaymentDate is not null        
  and dd.dealid = @Dealid        
  group by dd.DealID,n.DayoftheMonth        
 )a ON a.DealID = d.DealID      
 Left Join Core.Lookup lRepaymentAutoSpreadMethod on d.RepaymentAutoSpreadMethodID = lRepaymentAutoSpreadMethod.Lookupid      

Left Join(
	SELECT 
	dd.DealID,
	CASE
		WHEN b.AccountID IS NOT NULL THEN 'Pin' 
		ELSE 'Unpin'
	END AS Bookmark
	FROM [CRE].[BookMark] b        
		left join [CRE].[Deal] dd on dd.AccountID=b.AccountID        
		WHERE b.UserID = @UserID        
		and dd.dealid = @Dealid   
)b ON b.DealID = d.DealID 

 lEFT joIN(      
  Select e.DealID      
  ,e.EffectiveDate as EffectiveDate_Prepay           
  ,ps.[CalcThru]      
  ,ps.PrepaymentMethod as PrepaymentMethod      
  ,lPrepaymentMethod.name as PrepaymentMethodText      
  ,ps.BaseAmountType as BaseAmountType      
  ,lBaseAmount.name as BaseAmountTypeText      
  ,SpreadCalcMethod as SpreadCalcMethod      
  ,lSpreadCalcMethod.name as SpreadCalcMethodtext      
  ,ps.[GreaterOfSMOrBaseAmtTimeSpread]      
  ,ISNULL(ps.HasNoteLevelSMSchedule,0) as HasNoteLevelSMSchedule     
  ,ISNULL(ps.[Includefeesincredits],0) as Includefeesincredits  
  ,ps.MinimumMultipleDue
  ,ps.OpenPaymentDate
  from [CORE].prepaySchedule ps      
  INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID      
  INNER JOIN       
  (      
   Select d.dealid,ed.eventtypeid,ed.StatusID,MAX(EffectiveDate) as EffectiveDate from core.EventDeal ed      
   inner join cre.deal d on d.dealid = ed.dealid      
   where d.IsDeleted <> 1 and ed.StatusID = 1      
   and ed.eventtypeid = 737      
   and d.dealid = @Dealid      
   group by d.dealid,ed.StatusID,ed.eventtypeid      
  ) sEvent ON sEvent.Dealid = e.Dealid and e.EffectiveDate = sEvent.EffectiveDate  and e.EventTypeID = sEvent.EventTypeID and e.StatusID = sEvent.StatusID      
  left JOin core.Lookup lPrepaymentMethod on lPrepaymentMethod.lookupid = ps.PrepaymentMethod      
  left JOin core.Lookup lSpreadCalcMethod on lSpreadCalcMethod.lookupid = ps.SpreadCalcMethod      
  left JOin core.Lookup lBaseAmount on lBaseAmount.lookupid = ps.BaseAmountType      
  where e.StatusID = 1  and e.dealid = @Dealid      
 )tlbprepay on tlbprepay.Dealid = d.dealid      
 Left Join Core.Lookup lCalcEngineType on d.CalcEngineType=lCalcEngineType.LookupID   
 Left Join CRE.XIRROutputDealLevel xd on xd.DealAccountID=d.AccountID and xd.XIRRConfigID=@XIRRConfigID
 
 LEFT JOIN cre.loanstatus ls on d.LoanStatusID = ls.LoanStatusID
	and ls.LoanStatusDesc in (
	'Inquiry',
	'Dead',
	'Quote / Proposal',
	'Term Sheet Issued',
	'Term Sheet Signed',
	'Credit Committee Approved',
	'Committed')
 
 where d.DealID = @Dealid and d.IsDeleted = 0      
      
END      
ELSE      
BEGIN      
 SELECT       
 cast(cast(0 as binary) as uniqueidentifier) AS DealID      
 ,'' DealName      
 ,NULL DealType      
 ,'' DealTypeText      
 ,NULL LoanProgram           
 ,'' LoanProgramText      
 ,NULL LoanPurpose      
 ,'' LoanPurposeText      
 ,NULL Status      
 ,'' StatusText      
 ,NULL AppReceived        
 ,NULL EstClosingDate       
 ,'' BorrowerRequest      
 ,'' BorrowerRequestText      
 ,NULL RecommendedLoan      
 ,NULL TotalFutureFunding      
 ,NULL Source      
 ,'' SourceText      
 ,'' BrokerageFirm      
 ,'' BrokerageContact      
 ,'' Sponsor      
 ,'' Principal      
 ,NULL NetWorth      
 ,NULL Liquidity      
 ,'' ClientDealID      
 ,'' CREDealID      
 ,NULL TotalCommitment      
 ,NULL AdjustedTotalCommitment      
 ,NULL AggregatedTotal      
 ,'' AssetManagerComment      
 ,'' CreatedBy      
 ,NULL CreatedDate      
 ,'' UpdatedBy      
 ,'' LinkedDealID      
 ,NULL UpdatedDate       
 ,'' DealComment      
 ,NULL UnderwritingStatus      
 ,'' UnderwritingStatusText      
 ,'' AssetManager      
 ,NULL AMUserID      
 ,NULL AMTeamLeadUserID      
 ,NULL AMSecondUserID      
 ,'' DealCity      
 ,'' DealState      
 ,'' DealPropertyType      
 ,NULL FullyExtMaturityDate      
 ,NULL as lastUpdatedFF      
 , NULL LastUpdatedByFF         
 ,NULL as AllowSizerUpload      
 ,NULL as AllowSizerUploadText      
 ,404 AS StatusCode      
 ,'' as LastUpdatedFF_String      
 ,'' as DealRule      
 ,NULL as BoxDocumentLink      
 ,NULL as DealGroupID      
 ,Null as EnableAutoSpread      
 ,Null as ServicerDropDate      
 ,29 as ServicereDayAjustement      
 ,NULL as AmortizationMethod       
 ,NULL as AmortizationMethodText      
 ,NULL as ReduceAmortizationForCurtailments       
 ,NULL as ReduceAmortizationForCurtailmentsText      
 ,NULL as BusinessDayAdjustmentForAmort       
 ,NULL as BusinessDayAdjustmentForAmortText      
 ,NULL as NoteDistributionMethod       
 ,NULL as NoteDistributionMethodText      
 ,NULL as PeriodicStraightLineAmortOverride      
 ,NULL as FixedPeriodicPayment      
 ,'USD' as BaseCurrencyName       
 ,NULL as FirstPaymentDate      
 ,Null as EquityAmount      
 ,Null as RemainingAmount      
 ,Null as EnableAutoSpreadRepayments      
 ,Null as EnableAutoSpreadRepayments      
 ,Null as AutoUpdateFromUnderwriting      
 ,Null as ExpectedFullRepaymentDate      
 ,Null as RepaymentAutoSpreadMethodID      
 ,Null as RepaymentAutoSpreadMethodText      
 ,Null as RepaymentStartDate      
 ,Null as EarliestPossibleRepaymentDate      
 ,Null as Blockoutperiod      
 ,Null as PossibleRepaymentdayofthemonth      
 ,Null as Repaymentallocationfrequency      
 ,NULL as AutoPrepayEffectiveDate      
 ,NULL as LatestPossibleRepaymentDate      
 --,NULL as KnownFullPayoffDate      
 ,Null as MinAccrualFrequency      
 ,Null as AllowFundingFlag      
 ,NULL as ApplyNoteLevelPaydowns      
 ,NULL as IsREODeal      
 ,null as max_ExtensionMat      
 ,null as BalanceAware      
 ,null as EffectiveDate_Prepay  
 ,null as CalcThru      
 ,null as PrepaymentMethod      
 ,'' as PrepaymentMethodText      
 ,null as BaseAmountType      
 ,'' as BaseAmountTypeText      
 ,null as SpreadCalcMethod      
 ,'' as SpreadCalcMethodtext      
 ,null as GreaterOfSMOrBaseAmtTimeSpread      
 ,null as HasNoteLevelSMSchedule      
 ,null as Includefeesincredits      
 ,null as LastWireConfirmDate_db      
 ,null as PropertyTypeMajorID    
 ,null as LoanStatusID    
 ,null as PrepayDate     
 ,null as ICMFullyFundedEquity
 ,null as EquityAtClosing  
 ,null as CalcEngineType
 ,null as AllowGaapComponentInCashflowDownload
 ,''WatchlistStatus
 ,cast(cast(0 as binary) as uniqueidentifier) as DealAccountID
 ,null as XIRRValue
 ,null as EnableAutoDistributePrincipalWriteoff
 ,null as Bookmark
 ,null as MaturityAdjMonthsOverride
 ,null as ExcludeDealFromLiability
 ,'N' as isPipeline
END          
      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
      
END 