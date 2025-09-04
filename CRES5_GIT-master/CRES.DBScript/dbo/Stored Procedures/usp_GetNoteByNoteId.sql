
--[dbo].[usp_GetNoteByNoteId]  '0A835CFB-EEBA-43D0-AA28-42FFFDB6A40B','C10F3372-0FC2-4861-A9F5-148F1F80804F','C10F3372-0FC2-4861-A9F5-148F1F80804F'  
 
CREATE PROCEDURE [dbo].[usp_GetNoteByNoteId]    
(  
	@NoteId Varchar(500),  
	@UserID UNIQUEIDENTIFIER,  
	@AnalysisID UNIQUEIDENTIFIER  
)  
   
AS  
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
 Declare @AcctgCloseDate date    
    
  
  
Select @AcctgCloseDate = ISNULL(LastAccountingCloseDate,closingdate)   
from(  
 Select   
 d.DealID,n.noteid,p.CloseDate as LastAccountingCloseDate,n.closingdate   
 ,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno  
 from cre.deal d  
 Inner join cre.note n on n.dealid = d.dealid  
 Left join (  
  Select dealid,CloseDate,updateddate  
  from CORE.[Period]  
  where isdeleted <> 1 and CloseDate is not null  
 )p on d.dealid = p.dealid   
 Where d.IsDeleted <> 1   
 and n.noteid = @NoteId  
)a  
where a.rno = 1  
  
 --IF EXISTS (Select PeriodID from core.Period where IsDeleted <> 1)    
 --BEGIN    
 -- SET @AcctgCloseDate = (Select MAX(CloseDate) from core.[Period] where isdeleted <> 1)    
 --END    
 --ELSE    
 --BEGIN    
 -- SET @AcctgCloseDate = (Select ClosingDate from cre.note where noteid = @NoteId)    
 --END    
     
     
 Declare @ScenarioID UNIQUEIDENTIFIER;    
 DECLARE @CalculationMode int;    
 DECLARE @CalculationModeText nvarchar(256);    
    
 DECLARE @isAllowDebugInCalc bit =(Select [Value] from [App].[AppConfig] where [Key]='AllowDebugInCalc')    
 DECLARE @isCollectCalculatorLogs bit = (SELECT [Value] from [App].[AppConfig] WHERE [key]='CollectCalculatorLogs')    
 DECLARE @isAllowYieldConfigData bit = (SELECT [Value] from [App].[AppConfig] WHERE [key]='AllowYieldConfigData');    
 DECLARE @isCalcByNewMaturitySetup bit = (SELECT [Value] from [App].[AppConfig] WHERE [key]='CalcByNewMaturitySetup');    
   
 SET @ScenarioID = @AnalysisID;    
    
 Select @CalculationMode = ap.CalculationMode,    
 @CalculationModeText = lCalculationMode.Name    
 from core.Analysis an    
 left join core.AnalysisParameter ap on ap.AnalysisID = an.AnalysisID    
 left join core.Lookup lCalculationMode on lCalculationMode.LookupID = ap.CalculationMode    
 where an.AnalysisID = @ScenarioID    
    
    
 Declare @IsPIKNote bit = 0  
  
 IF EXISTS(  
  Select Distinct n.noteid   
  from [CORE].PikSchedule pik    
  INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId    
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  Where acc.isdeleted <> 1  
  and n.noteid = @NoteId  
 )  
 BEGIN  
  SET @IsPIKNote = 1  
 END  
  
  
       
IF EXISTS( SELECT n.NoteID FROM CRE.note n inner join core.Account acc on acc.AccountID = n.Account_AccountID where CAST(n.NoteID AS VARCHAR(500)) = @NoteId and acc.IsDeleted=0 )    
BEGIN    
 print 'if'    
    
Declare @Max_UpdatedDateFF nvarchar(256);    
Declare @UpdatedByFF nvarchar(256);    
Declare @lastCalcDateTime datetime;    
Declare @CalcEngineTypeText nvarchar(256);  


  
 Select  @Max_UpdatedDateFF = Cast(format(dbo.[ufn_GetTimeByTimeZone](Max(fs.UpdatedDate),@UserID),'MM/dd/yyyy   hh:mm:ss tt') as nvarchar(256)),    
 @UpdatedByFF = (CASE When EXISTS (SELECT 1 WHERE fs.UpdatedBy  LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))    
 THEN (select  top 1 u.[FirstName] +' '+u.[LastName] from CRE.DealFunding  sdf left join App.[User]  u  on u.UserID =  fs.UpdatedBy )     
 ELSE fs.UpdatedBy  END)    
 from [CORE].FundingSchedule fs    
 INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId    
 INNER JOIN     
 (    
          
  Select     
  (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
  MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID    
  from [CORE].[Event] eve    
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
  where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')    
  and n.NoteID = @NoteId  and acc.IsDeleted = 0    
  and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)    
  GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID    
    
 ) sEvent    
    
 ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID    
    
 left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID    
 left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID     
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID    
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
 where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0    
 group by fs.UpdatedBy    
    
    
 --SET @lastCalcDateTime = (Select Max(Calc.UpdatedDate) from cre.NotePeriodicCalc Calc where Calc.NoteID = @NoteId and AnalysisID = @AnalysisID)       
   
 Select @lastCalcDateTime = Max(Calc.UpdatedDate),  
 @CalcEngineTypeText = MAX(l.name)   
 from cre.NotePeriodicCalc Calc   
 Inner join core.account acc on acc.accountid = Calc.AccountID  
    Inner join cre.note n on n.account_accountid = acc.accountid  
 left join core.lookup l on l.lookupid = calc.CalcEngineType  
 where n.NoteID = @NoteId and AnalysisID = @AnalysisID and acc.AccounttypeID = 1  
    
  
 SELECT n.NoteID    
 ,ac.Name    
 ,ac.StatusID     
 ,ac.BaseCurrencyID    
 ,ac.StartDate    
 ,ac.EndDate    
 ,ac.PayFrequency    
 ,n.Account_AccountID    
 ,n.DealID    
 ,n.CRENoteID    
 ,n.ClientNoteID    
 ,n.Comments    
 ,n.InitialInterestAccrualEndDate    
 ,n.AccrualFrequency    
 ,n.DeterminationDateLeadDays    
 ,lDeterminationDateLeadDays.CalendarName as DeterminationDateHolidayListText    
 ,n.DeterminationDateReferenceDayoftheMonth    
 ,n.DeterminationDateInterestAccrualPeriod    
 ,n.DeterminationDateHolidayList    
 ,n.FirstPaymentDate    
 ,n.InitialMonthEndPMTDateBiWeekly    
 ,n.PaymentDateBusinessDayLag    
 ,n.IOTerm    
 ,n.AmortTerm    
 --,n.PIKSeparateCompounding    
 ,n.MonthlyDSOverridewhenAmortizing    
 ,n.AccrualPeriodPaymentDayWhenNotEOMonth    
 ,n.FirstPeriodInterestPaymentOverride    
 ,n.FirstPeriodPrincipalPaymentOverride    
 ,n.FinalInterestAccrualEndDateOverride    
 ,n.AmortType    
 ,n.RateType    
 ,l.Name 'RateTypeText'     
 ,n.ReAmortizeMonthly    
 ,n.ReAmortizeatPMTReset    
 ,n.StubPaidInArrears    
 ,n.RelativePaymentMonth    
 ,n.SettleWithAccrualFlag    
 ,n.InterestDueAtMaturity    
 ,n.RateIndexResetFreq    
 ,n.FirstRateIndexResetDate    
 ,n.LoanPurchase    
 ,lLoanPurchase.Name as LoanPurchaseText    
 ,n.AmortIntCalcDayCount    
 ,n.StubPaidinAdvanceYN    
 ,n.FullPeriodInterestDueatMaturity    
 ,n.ProspectiveAccountingMode    
 ,n.IsCapitalized    
 ,n.SelectedMaturityDateScenario    
 ,n.SelectedMaturityDate    
 ,n.InitialMaturityDate    
 ,n.ExpectedMaturityDate    
 ,n.FullyExtendedMaturityDate    
 ,n.OpenPrepaymentDate    
 ,n.CashflowEngineID    
 ,n.LoanType    
 ,n.Classification    
 ,n.SubClassification    
 ,n.GAAPDesignation    
 ,n.PortfolioID    
 ,n.GeographicLocation    
 ,n.PropertyType    
 ,n.RatingAgency    
 ,n.RiskRating    
 ,n.PurchasePrice    
 ,n.FutureFeesUsedforLevelYeild    
 ,n.TotalToBeAmortized    
 ,n.StubPeriodInterest    
 ,n.WDPAssetMultiple    
 ,CAST(n.WDPEquityMultiple as decimal(28,5)) as WDPEquityMultiple    
 ,n.PurchaseBalance    
 ,n.DaysofAccrued    
 ,CAST(n.InterestRate as decimal(28,5)) as InterestRate    
 ,n.PurchasedInterestCalc    
 ,n.NoteType  
 ,n.ModelFinancingDrawsForFutureFundings    
 ,n.NumberOfBusinessDaysLagForFinancingDraw    
 ,n.FinancingFacilityID    
 ,n.FinancingInitialMaturityDate    
 ,n.FinancingExtendedMaturityDate    
 ,n.FinancingPayFrequency    
 ,n.FinancingInterestPaymentDay    
 ,n.ClosingDate    
 ,n.InitialFundingAmount    
 ,n.Discount    
 ,n.OriginationFee    
 ,n.CapitalizedClosingCosts    
 ,n.PurchaseDate    
 ,n.PurchaseAccruedFromDate    
 ,n.PurchasedInterestOverride    
 ,CAST(n.DiscountRate as decimal(28,5)) as DiscountRate    
 ,n.ValuationDate    
 ,n.FairValue    
 ,n.TaxAmortCheck    
 ,n.PIKWoCompCheck    
 ,CAST(n.DiscountRatePlus as decimal(28,5)) as DiscountRatePlus    
 ,n.FairValuePlus    
 ,CAST(n.DiscountRateMinus as decimal(28,5)) as DiscountRateMinus    
 ,n.FairValueMinus    
 ,n.InitialIndexValueOverride as InitialIndexValueOverride    
 ,n.IncludeServicingPaymentOverrideinLevelYield    
 ,CAST(n.OngoingAnnualizedServicingFee as decimal(28,5)) as OngoingAnnualizedServicingFee    
 ,n.IndexRoundingRule    
 ,n.RoundingMethod    
 ,n.StubInterestPaidonFutureAdvances    
 ,n.CreatedBy    
 ,n.CreatedDate    


 ,@UpdatedByFF as UpdatedBy 
 
 
 ,n.UpdatedDate          
 ,n.StubIntOverride     
 ,n.PurchasedIntOverride    
 ,n.ExitFeeFreePrepayAmt     
 ,n.ExitFeeBaseAmountOverride     
 ,n.ExitFeeAmortCheck          
 ,lBaseCurrency.Name AS LoanCurrency    
 ,lIncludeServicingPaymentOverrideinLevelYield.Name AS IncludeServicingPaymentOverrideinLevelYieldText    
 --,lPIKSeparateCompounding.Name AS PIKSeparateCompoundingText    
 ,lStubPaidinAdvanceYN.Name AS StubPaidinAdvanceYNText    
 ,lModelFinancingDrawsForFutureFundings.Name AS ModelFinancingDrawsForFutureFundingsText    
 ,lExitFeeAmortCheck.Name AS ExitFeeAmortCheckText     
 ,n.FixedAmortScheduleCheck AS FixedAmortSchedule    
 ,lFixedAmortScheduleCheck.Name AS FixedAmortScheduleText    
 ,d.DealName    
 ,d.CREDealID    
 ,n.NoofdaysrelPaymentDaterollnextpaymentcycle    
       
 --,lIndex.Name 'IndexNameText'       
 ,tblindex.IndexName as 'IndexNameText'   
       
 ,@lastCalcDateTime as lastCalcDateTime    
 ,n.[UseIndexOverrides]    
        
 --,n.IndexNameID    
 ,tblindex.IndexNameID  
       
 ,n.ServicerID    
 ,n.TotalCommitment    
 ,n.ClientName    
 ,n.Portfolio    
 ,n.Tag1    
 ,n.Tag2    
 ,n.Tag3    
 ,n.Tag4    
 --  ,n.ExtendedMaturityScenario1    
 -- ,n.ExtendedMaturityScenario2    
 -- ,n.ExtendedMaturityScenario3    
 ,n.ActualPayoffDate    
 ,n.UnusedFeeThresholdBalance     
 ,n.UnusedFeePaymentFrequency    
 ,lSelectedMaturityDateScenario.Name as SelectedMaturityDateScenarioText    
 ,200 AS StatusCode    
 ,n.TotalCommitmentExtensionFeeisBasedOn    
 , isnull(lRoundingMethod.Name,'') as RoundingMethodText    
 ,UseRuletoDetermineNoteFunding    
 ,lUseRuletoDetermineNoteFunding.Name as  UseRuletoDetermineNoteFundingText    
 ,n.Servicer    
 ,lServicer.Name as  ServicerText    
 ,lFullInterestAtPPayoff.Name as FullInterestAtPPayoffText     
 ,n.FullInterestAtPPayoff        
 ,n.FullIOTermFlag  
 ,lFullIOTermFlag.Name as FullIOTermFlagText     
 ,@Max_UpdatedDateFF as FFLastUpdatedDate_String    
 ,@UpdatedByFF as UpdatedByFF    
 ,n.NoteRule    
 ,n.ClientID    
 ,n.FundId    
 ,n.FinancingSourceID    
 ,n.DebtTypeID    
 ,n.BillingNotesID    
 ,n.CapStack    
 ,n.PoolID           
 ,(select l.name from Core.AnalysisParameter ap      
 left join Core.Lookup l ON ap.MaturityScenarioOverrideID=l.LookupID     
 where AnalysisID = @AnalysisID -- in (select AnalysisID from Core.Analysis where StatusID  in (select LookupID from Core.lookup where ParentID=2 and Name='Y'))    
 ) as MaturityScenarioOverrideText    
    
 ,@AcctgCloseDate as AcctgCloseDate    
    
 ,@ScenarioID as ScenarioID    
 ,@CalculationMode as CalculationMode    
 ,@CalculationModeText as CalculationModeText    
 ,n.StubInterestRateOverride    
 ,n.LiborDataAsofDate      
 ,ServicerNameID    
 ,lsvr.ServicerName as ServicerNameText    
 ,BusinessdaylafrelativetoPMTDate    
 ,DayoftheMonth    
 ,InterestCalculationRuleForPaydowns    
 ,lInterestCalculationRuleForPaydowns.name as InterestCalculationRuleForPaydownsText    
     
   ,InterestCalculationRuleForPIKPaydowns    
   ,UPBAtForeclosure  
 ,lInterestCalculationRuleForPIKPaydowns.name as InterestCalculationRuleForPIKPaydownsText    
 --,PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate as  PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate    
 --,lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.name as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText  
  
 ,(CASE WHEN @IsPIKNote = 1 THEN ISNULL(PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,4) Else PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate END) as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate    
 ,(CASE WHEN @IsPIKNote = 1 THEN ISNULL(lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.name,'N') Else lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.name END) as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText    
     
     
 ,@isAllowDebugInCalc as isAllowDebugInCalc    
 ,n.InterestCalculationRuleForPaydownsAmort    
 ,paydownamort.Name as InterestCalculationRuleForPaydownsAmortText      
 ,n.RoundingNote    
 ,lRoundingNote.name as RoundingNoteText    
 ,n.StraightLineAmortOverride    
 ,n.AdjustedTotalCommitment    
 ,n.AggregatedTotal    
 ,n.RepaymentDayoftheMonth    
 ,@isCollectCalculatorLogs as CollectCalculatorLogs    
 ,n.OriginalTotalCommitment    
 ,n.MKT_PRICE    
 ,n.StrategyCode    
 ,lStrategy.Name StrategyName    
 ,n.NoteTransferDate    
 ,n.EnableM61Calculations    
 ,n.InitialRequiredEquity    
 ,n.InitialAdditionalEquity    
 ,n.OriginationFeePercentageRP    
 ,@isAllowYieldConfigData as AllowYieldConfigData    
 ,lAllowGaapComponentInCashflowDownload.name as AllowGaapComponentInCashflowDownload  
 ,n.ExtendedMaturityCurrent    
 ,@isCalcByNewMaturitySetup as CalcByNewMaturitySetup    
 ,n.ImpactCommitmentCalc    
 ,d.BalanceAware  
 ,@CalcEngineTypeText as CalcEngineTypeText  
 ,n.FirstIndexDeterminationDateOverride  
  
 ,ISNULL(n.AccrualPeriodType,811) as AccrualPeriodType  
 ,ISNULL(n.AccrualPeriodBusinessDayAdj,813) as AccrualPeriodBusinessDayAdj  
 ,lAccrualPeriodType.name as AccrualPeriodTypetext  
 ,lAccrualPeriodBusinessDayAdj.name as AccrualPeriodBusinessDayAdjText  
  
 ,AccountingClose  
 ,lAccountingClose.name as AccountingClosetext  
 ,d.MaturityAdjMonthsOverride
 ,n.InterestOnlyNote
 ,n.ConstantPaymentMethod
 ,n.PaymentDateAccrualPeriod 
 ,lPaymentDateAccrualPeriod.Name as PaymentDateAccrualPeriodText
 ,d.PrepayDate

 FROM CRE.Note n    
 INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID    
 left join Core.Lookup l ON n.RateType=l.LookupID    
 --left join Core.Lookup lIndex ON n.IndexNameID=lIndex.LookupID   
 left join Core.Lookup lBaseCurrency ON ac.BaseCurrencyID=lBaseCurrency.LookupID    
 left join Core.Lookup lIncludeServicingPaymentOverrideinLevelYield ON n.IncludeServicingPaymentOverrideinLevelYield =lIncludeServicingPaymentOverrideinLevelYield.LookupID    
 --left join Core.Lookup lPIKSeparateCompounding ON n.PIKSeparateCompounding=lPIKSeparateCompounding.LookupID    
 left join Core.Lookup lStubPaidinAdvanceYN ON n.StubPaidinAdvanceYN=lStubPaidinAdvanceYN.LookupID      
 left join Core.Lookup lModelFinancingDrawsForFutureFundings ON n.ModelFinancingDrawsForFutureFundings=lModelFinancingDrawsForFutureFundings.LookupID    
 left join Core.Lookup lExitFeeAmortCheck ON n.ExitFeeAmortCheck=lExitFeeAmortCheck.LookupID    
 left join Core.Lookup lSelectedMaturityDateScenario on n.SelectedMaturityDateScenario =lSelectedMaturityDateScenario.LookupID      
 left join Core.Lookup lLoanPurchase ON n.LoanPurchase=lLoanPurchase.LookupID    
 --left join Core.Lookup lDeterminationDateLeadDays ON n.DeterminationDateHolidayList=lDeterminationDateLeadDays.LookupID      
 left join Core.Lookup lRoundingMethod ON n.RoundingMethod=lRoundingMethod.LookupID       
 left join Core.Lookup lServicer ON n.Servicer=lServicer.LookupID       
 left join Core.Lookup lFullInterestAtPPayoff  ON n.FullInterestAtPPayoff=lFullInterestAtPPayoff.LookupID    
 left join Core.Lookup lFullIOTermFlag  ON n.FullIOTermFlag=lFullIOTermFlag.LookupID    
  
 left join Core.Lookup lFixedAmortScheduleCheck ON n.FixedAmortScheduleCheck=lFixedAmortScheduleCheck.LookupID    
 left join CRE.Deal d on d.DealID = n.DealID    
 left join Core.Lookup lUseRuletoDetermineNoteFunding ON n.UseRuletoDetermineNoteFunding=lUseRuletoDetermineNoteFunding.LookupID    
 left join cre.Servicer lsvr ON n.ServicerNameID = lsvr.ServicerID    
 left join Core.Lookup lInterestCalculationRuleForPaydowns ON n.InterestCalculationRuleForPaydowns=lInterestCalculationRuleForPaydowns.LookupID    
 left join Core.Lookup lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate ON n.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate=lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.LookupID    
 left join Core.Lookup paydownamort  ON n.InterestCalculationRuleForPaydownsAmort=paydownamort.LookupID     
 left join Core.Lookup lRoundingNote  ON n.RoundingNote=lRoundingNote.LookupID     
 left join Core.Lookup lStrategy  ON n.StrategyCode=lStrategy.LookupID     
 left join [App].[HoliDaysMaster] lDeterminationDateLeadDays ON n.DeterminationDateHolidayList=lDeterminationDateLeadDays.HolidayMasterID    
  
 left JOin core.lookup lAccrualPeriodType on lAccrualPeriodType.lookupid = ISNULL(n.AccrualPeriodType,811)  
 left JOin core.lookup lAccrualPeriodBusinessDayAdj on lAccrualPeriodBusinessDayAdj.lookupid = ISNULL(n.AccrualPeriodBusinessDayAdj,813)  
  
 left JOin core.lookup lAccountingClose on lAccountingClose.lookupid = n.AccountingClose  
 left JOin core.lookup lAllowGaapComponentInCashflowDownload on lAllowGaapComponentInCashflowDownload.lookupid = ISNULL(d.AllowGaapComponentInCashflowDownload,4)  
 left join Core.Lookup lInterestCalculationRuleForPIKPaydowns ON n.InterestCalculationRuleForPIKPaydowns=lInterestCalculationRuleForPIKPaydowns.LookupID    
 left join Core.Lookup lPaymentDateAccrualPeriod ON n.PaymentDateAccrualPeriod=lPaymentDateAccrualPeriod.LookupID
 
  
 left join(  
  Select noteid,IndexNameID,IndexName  
  from(  
   Select n.noteid,n.crenoteid,rs.IndexNameID ,lindex.Name as IndexName ,ROW_NUMBER() Over(Partition by noteid order by noteid) rno   
   from [CORE].RateSpreadSchedule rs    
   INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
   LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID   
   LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID    
   INNER JOIN     
   (            
    Select     
    (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
    MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
    where EventTypeID = 14  
    and eve.StatusID = 1  
    and acc.IsDeleted = 0    
    GROUP BY n.Account_AccountID,EventTypeID      
   ) sEvent      
   ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID   
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
   LEFT JOIN [CORE].[Lookup] Lratetype ON Lratetype.LookupID = n.RateType   
   where e.StatusID = 1 and acc.isdeleted <> 1  
   and LValueTypeID.name = 'Index Name'    
  )a  
  where a.rno = 1  
 )tblindex on tblindex.noteid = n.noteid  
   
 WHERE CAST(n.NoteID AS VARCHAR(500)) = @NoteId and ac.IsDeleted = 0    
    
  
END  
ELse   
Begin    
    
   print 'else'    
     SELECT cast(cast(0 as binary) as uniqueidentifier) NoteID    
            ,'' Name    
      ,NULL StatusID     
      ,NULL BaseCurrencyID    
      ,NULL StartDate    
      ,NULL EndDate    
      ,NULL PayFrequency    
      , cast(cast(0 as binary) as uniqueidentifier) Account_AccountID    
      ,cast(cast(0 as binary) as uniqueidentifier) DealID    
      ,'' CRENoteID    
      ,'' ClientNoteID    
      ,'' Comments    
      ,null InitialInterestAccrualEndDate    
      ,null AccrualFrequency      
      ,null DeterminationDateLeadDays    
      ,''  DeterminationDateHolidayListText    
      ,null DeterminationDateReferenceDayoftheMonth    
      ,null  DeterminationDateInterestAccrualPeriod    
      ,NULL DeterminationDateHolidayList    
      ,NULL FirstPaymentDate    
      ,NULL InitialMonthEndPMTDateBiWeekly    
      ,NULL PaymentDateBusinessDayLag    
      ,NULL IOTerm    
      ,NULL AmortTerm    
      --,NULL PIKSeparateCompounding    
      ,NULL MonthlyDSOverridewhenAmortizing    
      ,NULL AccrualPeriodPaymentDayWhenNotEOMonth   
      ,NULL FirstPeriodInterestPaymentOverride    
      ,NULL FirstPeriodPrincipalPaymentOverride    
      ,NULL FinalInterestAccrualEndDateOverride    
      ,NULL AmortType    
      ,NULL RateType    
      ,'' 'RateTypeText'     
      ,NULL ReAmortizeMonthly    
      ,NULL ReAmortizeatPMTReset    
      ,NULL StubPaidInArrears    
      ,NULL RelativePaymentMonth    
      ,NULL SettleWithAccrualFlag    
      ,NULL InterestDueAtMaturity    
      ,NULL RateIndexResetFreq    
      ,NULL FirstRateIndexResetDate    
      ,NULL LoanPurchase    
      ,''  LoanPurchaseText    
      ,null AmortIntCalcDayCount    
      ,null StubPaidinAdvanceYN    
      ,null FullPeriodInterestDueatMaturity    
      ,null ProspectiveAccountingMode    
      ,null IsCapitalized    
      ,null SelectedMaturityDateScenario    
     ,null SelectedMaturityDate    
     ,null InitialMaturityDate    
      ,null ExpectedMaturityDate    
     ,null FullyExtendedMaturityDate    
      ,null OpenPrepaymentDate    
      ,null CashflowEngineID    
      ,null LoanType    
      ,null Classification    
      ,null  SubClassification    
      ,null  GAAPDesignation    
      ,null PortfolioID    
      ,null GeographicLocation    
      ,null PropertyType    
      ,null RatingAgency    
      ,null RiskRating    
      ,null PurchasePrice    
      ,null FutureFeesUsedforLevelYeild    
      ,null TotalToBeAmortized    
      ,null StubPeriodInterest    
      ,null WDPAssetMultiple    
      ,null  WDPEquityMultiple    
      ,null PurchaseBalance    
      ,null DaysofAccrued    
      ,null InterestRate    
      ,null PurchasedInterestCalc    
   ,null NoteType  
      ,null  ModelFinancingDrawsForFutureFundings    
      ,null NumberOfBusinessDaysLagForFinancingDraw    
      ,null FinancingFacilityID    
      ,null FinancingInitialMaturityDate    
      ,null FinancingExtendedMaturityDate    
      ,null FinancingPayFrequency    
      ,null FinancingInterestPaymentDay    
      ,null ClosingDate    
      ,null InitialFundingAmount    
      ,null Discount    
      ,null OriginationFee    
      ,null CapitalizedClosingCosts    
      ,null PurchaseDate    
      ,null  PurchaseAccruedFromDate    
      ,null  PurchasedInterestOverride    
      ,null  DiscountRate    
      ,null  ValuationDate    
      ,null  FairValue    
      ,'' TaxAmortCheck    
      ,'' PIKWoCompCheck    
      ,NULL DiscountRatePlus    
      ,NULL FairValuePlus    
      ,NULL DiscountRateMinus    
      ,NULL FairValueMinus    
      ,NULL InitialIndexValueOverride    
      ,NULL IncludeServicingPaymentOverrideinLevelYield    
      ,NULL  OngoingAnnualizedServicingFee    
      ,NULL IndexRoundingRule    
      ,NULL RoundingMethod    
      ,NULL StubInterestPaidonFutureAdvances    
      ,'' CreatedBy    
      ,NULL CreatedDate    
      ,'' UpdatedBy    
      ,NULL UpdatedDate          
      ,NULL StubIntOverride     
      ,NULL PurchasedIntOverride    
      ,NULL ExitFeeFreePrepayAmt     
      ,NULL ExitFeeBaseAmountOverride     
      ,NULL ExitFeeAmortCheck          
      ,'' LoanCurrency    
      ,'' IncludeServicingPaymentOverrideinLevelYieldText    
      --,'' PIKSeparateCompoundingText    
      ,'' StubPaidinAdvanceYNText    
      ,'' ModelFinancingDrawsForFutureFundingsText    
      ,'' ExitFeeAmortCheckText     
      ,NULL FixedAmortSchedule    
      ,'' FixedAmortScheduleText    
      ,'' DealName    
      ,'' CREDealID    
      ,NULL NoofdaysrelPaymentDaterollnextpaymentcycle    
      ,'' 'IndexNameText'    
      ,NULL  lastCalcDateTime    
      ,NULL UseIndexOverrides    
      ,NULL IndexNameID    
      ,'' ServicerID    
      ,NULL TotalCommitment    
      ,'' ClientName    
      ,'' Portfolio    
      ,'' Tag1    
      ,'' Tag2    
      ,'' Tag3    
      ,'' Tag4    
     --  ,NULL ExtendedMaturityScenario1    
    -- ,NULL ExtendedMaturityScenario2    
    -- ,NULL ExtendedMaturityScenario3    
     ,NULL ActualPayoffDate    
     ,NULL  UnusedFeeThresholdBalance     
     ,NULL UnusedFeePaymentFrequency    
     ,'' SelectedMaturityDateScenarioText    
     ,404 AS StatusCode    
         ,NULL TotalCommitmentExtensionFeeisBasedOn    
      , '' as RoundingMethodText    
      ,null as UseRuletoDetermineNoteFunding    
      ,'' as  UseRuletoDetermineNoteFundingText    
      ,null as Servicer    
      ,'' as  ServicerText    
      ,'' as FullInterestAtPPayoffText     
      ,null as FullInterestAtPPayoff     
   ,null as FullIOTermFlag  
      ,null as FFLastUpdatedDate_String    
    ,null as UpdatedByFF    
    ,null as NoteRule    
    ,NULL ClientID    
    ,NULL FundId    
    ,NULL FinancingSourceID    
    ,NULL DebtTypeID    
    ,NULL BillingNotesID    
    ,NULL CapStack    
    ,NULL PoolID    
    ,null MaturityScenarioOverrideText    
    
    ,@AcctgCloseDate as AcctgCloseDate    
    ,@ScenarioID as ScenarioID    
    ,@CalculationMode as CalculationMode    
    ,@CalculationModeText as CalculationModeText    
    ,NULL as StubInterestRateOverride    
    ,NULL as LiborDataAsofDate    
    ,NULL as ServicerNameID    
    ,NULL as BusinessdaylafrelativetoPMTDate    
    ,NULL as DayoftheMonth    
    ,NULL as InterestCalculationRuleForPaydowns    
    ,NULL as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate    
    ,@isAllowDebugInCalc as isAllowDebugInCalc    
    ,NULL as InterestCalculationRuleForPaydownsAmort    
    ,NULL as RoundingNote    
    ,NULL as RoundingNoteText    
    ,NULL as StraightLineAmortOverride        
    ,NULL as AdjustedTotalCommitment    
    ,NULL as AggregatedTotal    
    ,NULl as RepaymentDayoftheMonth    
    ,NULL as CollectCalculatorLogs    
    ,NULL as OriginalTotalCommitment    
    ,NULL as MKT_PRICE    
    ,NULL as STRATEGY    
    ,NULL as StrategyCode    
    ,NULL as StrategyName    
    ,null as NoteTransferDate    
    ,null as EnableM61Calculations    
    ,null as InitialRequiredEquity    
    ,null as InitialAdditionalEquity    
    ,null as OriginationFeePercentageRP    
    ,null  as AllowYieldConfigData    
    ,NULL as ExtendedMaturityCurrent    
    ,NULL as CalcByNewMaturitySetup    
    ,NULL as ImpactCommitmentCalc    
 ,null as BalanceAware  
 ,null as CalcEngineTypeText  
 ,null as FirstIndexDeterminationDateOverride  
 ,811 as AccrualPeriodType  
 ,813 as AccrualPeriodBusinessDayAdj  
 ,null as AccrualPeriodTypeText  
 ,null as AccrualPeriodBusinessDayAdjText 
 ,null as MaturityAdjMonthsOverride
 ,null as InterestOnlyNote
 ,null as ConstantPaymentMethod
 ,null as PaymentDateAccrualPeriod
 ,null as PaymentDateAccrualPeriodText
 ,null as PrepayDate
   --  WHERE CAST(n.NoteID AS VARCHAR(500)) = @NoteId;    
   END    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END  