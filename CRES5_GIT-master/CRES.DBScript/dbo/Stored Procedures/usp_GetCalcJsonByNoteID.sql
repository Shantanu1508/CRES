-- Procedure
-- Procedure
-- Procedure
--[dbo].[usp_GetCalcJsonByNoteID] '','8901','c10f3372-0fc2-4861-a9f5-148f1f80804f',775  
--[dbo].[usp_GetCalcJsonByNoteID] '','4851','c10f3372-0fc2-4861-a9f5-148f1f80804f',775  
--[dbo].[usp_GetCalcJsonByNoteID] '','6155','c10f3372-0fc2-4861-a9f5-148f1f80804f',775  
--[dbo].[usp_GetCalcJsonByNoteID] '','2230','c10f3372-0fc2-4861-a9f5-148f1f80804f',775  
--[dbo].[usp_GetCalcJsonByNoteID] '','8149','c10f3372-0fc2-4861-a9f5-148f1f80804f',775  
--[dbo].[usp_GetCalcJsonByNoteID] '','22130','c10f3372-0fc2-4861-a9f5-148f1f80804f',775  
--[dbo].[usp_GetCalcJsonByNoteID] '','23054','c10f3372-0fc2-4861-a9f5-148f1f80804f',775  
--[dbo].[usp_GetCalcJsonByNoteID] '','20589c','d8f8af6d-b9c7-4015-a610-41d34941eeb5',775
--[dbo].[usp_GetCalcJsonByNoteID] '','23054','72114A53-495C-464B-A020-62884A0F1462',775  
CREATE PROCEDURE [dbo].[usp_GetCalcJsonByNoteID]   
(  
	@UserID NVARCHAR(256),  
	@NoteID_any NVARCHAR(256),  
	@Analysis_ID UNIQUEIDENTIFIER,  
	@CalcTypeID int    

)   
  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
  
 Declare @NoteID UNIQUEIDENTIFIER;  
 Declare @DealID UNIQUEIDENTIFIER;  
  
   
 IF((SELECT 1 WHERE @NoteID_any LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) = 1)  
 BEGIN  
  ---If @NoteID_any is guid  
  SET @NoteID = @NoteID_any  
 END  
 ELSE  
 BEGIN  
  SET @NoteID = (Select noteid from cre.note where crenoteid = @NoteID_any)  
 END  
  
  
 SET @DealID = (Select dealid from cre.note where noteid = @NoteID)  
  
 Declare @AccountID UNIQUEIDENTIFIER
 SET @AccountID = (Select Account_AccountID from cre.note where noteid = @NoteID)

 Declare @prepaydate date;  
 SET @prepaydate = (Select ISNULL(prepaydate,getdate()) from cre.deal where dealid = @DealID)  
  
  
 Declare @CalculationMode int;  
 SET @CalculationMode = (Select CalculationMode from core.analysisparameter where analysisid=@Analysis_ID)  
  
 Declare @calc_basis_freq nvarchar(50);  
 SET @calc_basis_freq = (Select l.name from core.analysisparameter am left join core.lookup l on l.lookupid = am.CalculationFrequency where analysisid=@Analysis_ID)  
  
  
 Declare @IncludeProjectedPrincipalWriteoff int;  
 SET @IncludeProjectedPrincipalWriteoff = (Select IncludeProjectedPrincipalWriteoff from core.analysisparameter where analysisid=@Analysis_ID) 
 


 Declare @L_FullyExtendedDate Date
 SET @L_FullyExtendedDate  = (Select FullyExtendedMaturityDate from cre.note where noteid = @NoteID)  


 ---For Maturity Adj month
Declare @MaturityAdjustmentMonths int = null;  

IF EXISTS (Select analysisid from core.analysisparameter where analysisid=@Analysis_ID and UseMaturityAdjustmentMonths = 3)    
BEGIN  
	SET @MaturityAdjustmentMonths = (Select ISNULL(MaturityAdjMonthsOverride,0) from cre.deal where DealID = @DealID)  
	
	if @MaturityAdjustmentMonths = 0
	BEGIN
		SET @MaturityAdjustmentMonths = (Select ISNULL(MaturityAdjustment,0) from core.analysisparameter where analysisid=@Analysis_ID);  
	END
END  


 ---===============A/c Close section==================  
 Declare @accountingclosedate date;  
 Declare @IsAccountingClose bit;   
 Declare @PeriodID UNIQUEIDENTIFIER;  
 Declare @accountingclosedate_EffDate date;  
    
   
 Declare @L_ClosingDate Date = (Select ClosingDate from cre.note where noteid = @NoteID)  
 Declare @LastPeriodCloseDate date;  
  
  
 select top 1 @LastPeriodCloseDate = p.CloseDate,@PeriodID = p.PeriodID  
 from [Core].[Period] p  
 Inner Join [Core].[AccountingClosePeriodicArchive] nc on p.[PeriodID] = nc.[PeriodID]  
 Where p.IsDeleted <> 1  
 and nc.NoteID = @NoteID  
 and p.CloseDate is not null  
 and p.analysisid = @Analysis_ID
 Order by p.CloseDate desc  
  
 IF (@LastPeriodCloseDate is not null)  
 BEGIN  
  --exists in period close  
  SET @IsAccountingClose = 1  
  SET @accountingclosedate = @LastPeriodCloseDate;  
  SET @accountingclosedate_EffDate = DATEADD(day,1,@accountingclosedate);  
 END  
 ELSE  
 BEGIN  
  SET @IsAccountingClose = 0  
  SET @accountingclosedate = @L_ClosingDate;  
  SET @accountingclosedate_EffDate = @L_ClosingDate;  
 END  
 ---===============A/c Close section==================  
  
  
 -----===============A/c Close section==================  
 --Declare @accountingclosedate date;  
 --Declare @IsAccountingClose bit;  
 --Declare @AccountingClose_value int;  
 --Declare @PeriodID UNIQUEIDENTIFIER;  
    
   
 --Declare @L_ClosingDate Date = (Select ClosingDate from cre.note where noteid = @NoteID)  
  
 --SET @AccountingClose_value = (Select ISNULL(AccountingClose,4) from core.analysisparameter where analysisid=@Analysis_ID)  
  
 --IF(@AccountingClose_value = 3) --'Y'  
 --BEGIN  
 -- --Note level flag check  
 -- SET @IsAccountingClose =  (Select (CASE WHEN AccountingClose = 3 THEN 1 ELSE 0 END) from cre.note where noteid = @NoteID)    
  
 -- Declare @LastPeriodCloseDate date;  
 -- select top 1 @LastPeriodCloseDate = p.CloseDate,@PeriodID = p.PeriodID  
 -- from [Core].[Period] p  
 -- Inner Join [Core].[AccountingClosePeriodicArchive] nc on p.[PeriodID] = nc.[PeriodID]  
 -- Where p.IsDeleted <> 1  
 -- and nc.NoteID = @NoteID  
 -- Order by p.CloseDate desc  
  
 -- IF (@LastPeriodCloseDate is not null)  
 -- BEGIN  
 --  --exists in period close  
 --  SET @IsAccountingClose = 1  
 --  SET @accountingclosedate = @LastPeriodCloseDate;  
 -- END   -- ELSE  

 -- BEGIN  
 --  SET @IsAccountingClose = 0  
 --  SET @accountingclosedate = @L_ClosingDate;  
 -- END  
 --END  
 --ELSE   
 --BEGIN  
 -- SET @IsAccountingClose = 0;  
 -- SET @accountingclosedate = @L_ClosingDate;  
 --END  
 -----===============A/c Close section==================  
  
  
---==========================================================================================  
  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

 Declare @AnalysisPrepay UNIQUEIDENTIFIER = (Select AnalysisID from core.Analysis where [Name] = 'Prepayment Default') 


 DECLARE @AnalysisID UNIQUEIDENTIFIER = @Analysis_ID --'c10f3372-0fc2-4861-a9f5-148f1f80804f'  
 DECLARE @CRENoteID NVARCHAR(256)  
 DECLARE @NoteName NVARCHAR(256)   
 DECLARE @AnalysisName NVARCHAR(256)  
  
 DECLARE @RateSpreadSchedule nvarchar(max)  
 declare @cnt int=1,@ValueTypeID nvarchar(50),@Name nvarchar(100),@totalCntRateSpread int,  
 @deal_min_effDate date,@TotalSequ1 as DECIMAL (28, 15)  
 declare @UseRuletoDetermineNoteFundingAsYES int=(Select LookupID from CORE.Lookup where Name = 'Y' and Parentid = 2)     
  
 SET @AnalysisName = (Select [name] from core.analysis where AnalysisID = @AnalysisID)  
   
  
 DECLARE @CalcStatus int  
 SET @CalcStatus = (Select top 1 statusid from core.CalculationRequests where AnalysisId = @AnalysisID and AccountId = @AccountID)  
  
 ---=============================  
 DECLARE @isCalcStarted bit  
 DECLARE @isCalcCancel bit  
   
 set @isCalcStarted = 0  
 IF EXISTS(Select requestid from core.CalculationRequests where AnalysisId = @AnalysisID and AccountId = @AccountID and Requestid is not null)  
 BEGIN  
  set @isCalcStarted = 1  
 END  
  
 set @isCalcCancel = 0  
 IF NOT EXISTS(Select CalculationRequestID from core.CalculationRequests where AnalysisId = @AnalysisID and AccountId = @AccountID)  
 BEGIN  
  set @isCalcCancel = 1  
 END  
  
 ---=============================  
  
 Declare @IndexName nvarchar(256) = null;  
 SET @IndexName = (  
  Select im.indexesname as IndexName  
  from core.analysisParameter ap  
  left join core.indexesmaster im on im.IndexesMasterID = ap.IndexScenarioOverride  
  where analysisid = @AnalysisID  
 )  
 if(@IndexName is null)  
 BEGIN  
  SET @IndexName = 'Default Index';  
 END  
  
 Print(@IndexName)  
 --=================================  
  
  
  
 Declare @ExcludedForcastedPrePaymentText nvarchar(10);  
 Declare @UseServicingActual nvarchar(10);  
 Declare @DisableBusinessDay nvarchar(10);  
 Declare @MaturityScenarioOverride nvarchar(100);  
  
 Select @ExcludedForcastedPrePaymentText = ISNULL(lExcludedForcastedPrePayment.name,''),  
 @UseServicingActual = ISNULL(lUseActuals.name,''),  
 @DisableBusinessDay = ISNULL(lUseBusinessDayAdjustment.name,'N') ,  
 @MaturityScenarioOverride = ISNULL(lMaturityScenarioOverrideID.name,'')  
 from core.analysis a  
 inner join core.analysisparameter am on am.analysisid = a.analysisid  
 left join core.lookup lExcludedForcastedPrePayment on lExcludedForcastedPrePayment.lookupid = am.ExcludedForcastedPrePayment  
 left join core.lookup lUseActuals on lUseActuals.lookupid = am.UseActuals  
 left join core.lookup lUseBusinessDayAdjustment on lUseBusinessDayAdjustment.lookupid = am.UseBusinessDayAdjustment  
 left join core.lookup lMaturityScenarioOverrideID on lMaturityScenarioOverrideID.lookupid = am.MaturityScenarioOverrideID  
 where a.analysisid=@AnalysisID  
  
  
 Declare @calc_priority int;  
  
 sET @calc_priority = (Select top 1 cr.[PriorityID] as calc_priority  
 from core.calculationrequests cr  
 inner join cre.note n on n.Account_AccountID = cr.AccountId  
 where analysisid=@AnalysisID  
 and n.noteid = @NoteID)  
  
  
  
 ---===Root table variables========  
 Declare @calc_basis bit  
 Declare @calc_deffee_basis bit  
 Declare @calc_disc_basis bit  
 Declare @calc_capcosts_basis bit  
 Declare @batch bit  
 --Declare @init_logging bit  
 Declare @engine nvarchar(50)  
 Declare @debug bit  
  
 Select @calc_basis = calc_basis,  
 @calc_deffee_basis = calc_deffee_basis,  
 @calc_disc_basis = calc_disc_basis,  
 @calc_capcosts_basis = calc_capcosts_basis,  
 @batch = batch,  
 --@init_logging = init_logging,  
 @engine = (CASE WHEN @CalcTypeID = 776 THEN 'script' else  engine end)   
 from [CRE].[RootV1Calc]  
  
 SET @debug = (Select top 1 [value] from app.AppConfig where [Key] = 'AllowDebugInCalc')  
 --=======================================  
  
 Declare @mat_Type nvarchar(256)  
  
 SET @mat_Type = (  
  Select MaturityType from(  
   Select a.AnalysisID,a.name,l.name as MaturityScenarioOverride,  
   (CASE WHEN l.name ='Initial or Actual Payoff Date' then 'Initial'  
   WHEN l.name ='Expected Maturity Date' then 'Expected Maturity Date'    
   WHEN l.name ='Extended Maturity Date' then 'Extension'  
   WHEN l.name ='Open Prepayment Date' then 'Fully extended'  --'OpenPrepaymentDate'  
   WHEN l.name ='Fully Extended Maturity Date' then 'Fully extended'  
   WHEN l.name ='Current Maturity Date' then 'Current Maturity Date'  
   WHEN l.name ='Prepay Date' then 'Prepay Date'
   end)  MaturityType  
   from core.Analysis a  
   inner join core.analysisparameter am on am.AnalysisID = a.AnalysisID  
   left join core.lookup l on l.lookupid = am.MaturityScenarioOverrideID  
   where a.AnalysisID = @AnalysisID  
  )a  
 )  
 --=======================================  
  
  
 
 

 --======================================================= 
Declare @LastPyDnDay int = 10;
Declare @LastPyDn_Date Date = null;
Declare @LastFUllPayOffDate Date = null;

Declare @tblnoteff_lastPydnDate as Table(
noteid UNIQUEIDENTIFIER,
Purposeid int,
lastDate date
)

INSERT INTO @tblnoteff_lastPydnDate(noteid,Purposeid,lastDate)
Select top 1 n.noteid,Purposeid,fs.Date as lastDate
from [CORE].FundingSchedule fs
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
INNER JOIN (						
	Select 
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
	from [CORE].[Event] eve
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
	and n.NoteID = @NoteId  
	and acc.IsDeleted = 0
	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
	GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
) sEvent
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
left JOIN [CORE].[Lookup] LAdjustmentType ON LAdjustmentType.LookupID = fs.AdjustmentType 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
and n.NoteID = @NoteId
Order by fs.Date  desc


IF EXISTS(Select lastDate from @tblnoteff_lastPydnDate where Purposeid = 631 and NoteID = @NoteId) ---paydown
BEGIN
	
	Select @LastPyDnDay = DAY(lastDate) ,@LastPyDn_Date = lastDate
	from @tblnoteff_lastPydnDate where Purposeid = 631 and NoteID = @NoteId
	
END

IF EXISTS(Select lastDate from @tblnoteff_lastPydnDate where Purposeid = 630 and NoteID = @NoteId) ---Full pay off
BEGIN
	SET @LastFUllPayOffDate = (Select lastDate from @tblnoteff_lastPydnDate where Purposeid = 630 and NoteID = @NoteId);
END


Declare @l_MaxEffDate_Maturity date;

Select  @l_MaxEffDate_Maturity = MAX(EffectiveStartDate) 
from [CORE].[Event] eve    
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
where EventTypeID = 11  and eve.StatusID = 1  
and acc.IsDeleted = 0    
and n.noteid = @NoteID  
GROUP BY n.Account_AccountID,EventTypeID 



Declare @l_MaturityDate_ScenarioBased date;


Select @l_MaturityDate_ScenarioBased =    Dateadd(month,ISNULL(@MaturityAdjustmentMonths,0),MaturityDate_ScenarioBased)
From(
	Select Distinct crenoteid,NoteID,[MaturityType],[MaturityDate] as MaturityDate_ScenarioBased
	From(  

	   Select n.crenoteid,n.NoteID,e.EffectiveStartDate  as [EffectiveDate],  
	   lMaturityType.name as [MaturityType],  
	   (CASE WHEN e.EffectiveStartDate = n.actualPayoffdate THEN n.actualPayoffdate ELSE mat.MaturityDate END)  as [MaturityDate],      
	   lApproved.name as Approved 
	   from [CORE].Maturity mat    
	   INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
	   Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
	   Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved  
	   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
	   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
	   where e.StatusID = 1  
	   and lMaturityType.name  = @mat_Type  
	   and lApproved.name = 'Y'      
	   and e.EffectiveStartDate = @l_MaxEffDate_Maturity
	   and n.noteid = @NoteID  
  
	   UNION ALL  
  
  
	   ----------Current maturity-----------------  
	   Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved
	   from (  
		Select n.crenoteid,n.noteid,e.effectivestartdate,'Current Maturity Date' as [MaturityType],  
		(CASE WHEN e.EffectiveStartDate = n.actualPayoffdate THEN n.actualPayoffdate ELSE mat.MaturityDate END) as [MaturityDate],  
		lApproved.name as Approved, 
		ROW_NUMBER() Over(Partition by noteid,effectivestartdate order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno  
		from [CORE].Maturity mat    
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId      
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
		Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
		Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved   
		where mat.MaturityDate > getdate()  
		and lApproved.name = 'Y'  
		and e.EffectiveStartDate = @l_MaxEffDate_Maturity
		and n.noteid = @NoteID   
		and e.StatusID = 1  
	   )a    
	   where a.rno = 1  
	   and MaturityType = @mat_Type  
  
	   UNION ALL  
  
	   ---If current maturity is not available on closing------------  
	   Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved  
	   from (  
		Select n.crenoteid,n.noteid,n.closingdate as effectivestartdate, 'Current Maturity Date' as MaturityType,iSNULL(n.ActualPayoffdate,n.FullyExtendedMaturityDate) as MaturityDate,'Y' as Approved  
		from cre.Note n   
		inner join core.Account acc on acc.AccountID = n.Account_AccountID  
		where acc.IsDeleted <> 1  
		and n.noteid = @NoteID   
	   )a  
	   where MaturityType = @mat_Type  
	   and NOT EXISTS(  
		Select n.noteid from [CORE].Maturity mat    
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId      
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID        
		where mat.Approved= 3  
		and n.ClosingDate = e.EffectiveStartDate  
		and mat.MaturityDate > getdate()  
		and n.noteid = @NoteID   
	   )  
  
	   ------------------------------------------  
	   UNION ALL  
  
	   ---Expected Maturity date  
		Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved  
		from (  
			Select n.crenoteid,n.noteid,n.closingdate as effectivestartdate, 'Expected Maturity Date' as MaturityType	
			,(CASE WHEN @LastFUllPayOffDate is not null THEN @LastFUllPayOffDate
			WHEN (YEAR(n.ExpectedMaturityDate) = YEAR(@LastPyDn_Date) and MONTH(n.ExpectedMaturityDate) = MONTH(@LastPyDn_Date)) THEN @LastPyDn_Date
			ELSE ISNULL(n.ExpectedMaturityDate,n.FullyExtendedMaturityDate) END) as MaturityDate
			,'Y' as Approved  
			from cre.Note n   
			inner join core.Account acc on acc.AccountID = n.Account_AccountID  
			where acc.IsDeleted <> 1  
			and n.noteid = @NoteID  
		)a  
		where MaturityType = @mat_Type  


		UNION ALL  
  
	   ---Prepay date  
		Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved  
		from (  
			Select n.crenoteid,n.noteid,n.closingdate as effectivestartdate, 'Prepay Date' as MaturityType	
			,d.PrepayDate as MaturityDate
			,'Y' as Approved  
			from cre.Note n   
			inner join core.Account acc on acc.AccountID = n.Account_AccountID  
			inner join cre.deal d on d.dealid = n.dealid
			where acc.IsDeleted <> 1  
			and n.noteid = @NoteID  
		)a  
		where MaturityType = @mat_Type  
  
	)a  
	group by crenoteid,NoteID,[MaturityDate],[MaturityType]

)z
---=============================================================

  
  
  
  
  
  
 --DECLARE @tNoteEffectiveDates as table  
 --(  
 --CRENoteID NVARCHAR(256),  
 --NoteID UNIQUEIDENTIFIER,  
 --EffectiveDate date  
 --)  
 create table  #tNoteEffectiveDates  
 (  
 CRENoteID NVARCHAR(256),  
 NoteID UNIQUEIDENTIFIER,  
 EffectiveDate date  
 )  
 DECLARE @tRateSpreadSchedule as table  
 (  
 ID int identity(1,1),  
 ValueTypeID int,  
 Name NVARCHAR(100)  
 )  
 DECLARE @tTableAlias as table  
 (  
 ID int identity(1,1),  
 [Name] NVARCHAR(100),  
 [GroupName] NVARCHAR(100)  
 )  
   
    
   
  
 --#table  
 insert into #tNoteEffectiveDates   
 Select Distinct CRENoteID,NoteID,effectivestartdate as effective_dates  
 From(  
  select n.CRENoteID,n.NoteID,n.ClosingDate as effectivestartdate,'ClosingDate' as [Type]  
  from cre.note n  
  inner join core.account acc on acc.accountid = n.account_accountid   
  inner join cre.Deal d on d.DealID = n.DealID  
  where acc.IsDeleted <> 1  and n.noteid=@NoteID  
    
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'DefaultSchedule' as [Type]  
  from [CORE].DefaultSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'FeeCouponSchedule' as [Type]  
  from [CORE].FeeCouponSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'FinancingFeeSchedule' as [Type]  
  from [CORE].FinancingFeeSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'FinancingSchedule' as [Type]  
  from [CORE].FinancingSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'FundingSchedule' as [Type]  
  from [CORE].FundingSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID   
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted = 0   
  --and ISNULL(LPurposeID.name,'a') <> 'Amortization'  
  and n.noteid = @NoteID  
  
  UNION  
  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'PIKSchedule' as [Type]  
  from [CORE].PIKSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where ISNULL(e.StatusID,1) = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'PrepayAndAdditionalFeeSchedule' as [Type]  
  from [CORE].PrepayAndAdditionalFeeSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'RateSpreadSchedule' as [Type]  
  from [CORE].RateSpreadSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate,'PIKScheduleDetail' as [Type]  
  from [CORE].PIKScheduleDetail fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where  ISNULL(e.StatusID,1) = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate ,'AmortSchedule' as [Type]  
  from [CORE].AmortSchedule fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  UNION  
  
  Select Distinct n.CRENoteID,n.NoteID,e.effectivestartdate ,'FeeCouponStripReceivable' as [Type]  
  from [CORE].FeeCouponStripReceivable fs  
  INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where ISNULL(e.StatusID,1) = 1 and acc.IsDeleted = 0   
  and n.noteid = @NoteID  
  
  --UNION  
  
  --Select Distinct n.CRENoteID,n.NoteID,e.effectivedate,'PrepayPremiumSchedule' as [Type]  
  --from [CORE].prepaySchedule ps  
  --INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID  
  --inner join cre.note n on n.dealid = e.dealid  
  --INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.account_accountid  
  --where e.StatusID = 1  and acc.IsDeleted <> 1  
  --and e.dealid = @DealID  
  --and n.noteid = @NoteID  
  
  UNION  
  
    
  Select Distinct crenoteid,noteid,[EffectiveDate] as effectivedate,'MaturitySchedule' as [Type]  
  From(  
   Select Distinct crenoteid,NoteID,[MaturityType],MIN([EffectiveDate]) as [EffectiveDate],[MaturityDate]  
   From(  
    Select n.crenoteid,n.NoteID,e.EffectiveStartDate  as [EffectiveDate],  
    lMaturityType.name as [MaturityType],  
    (CASE WHEN e.EffectiveStartDate = n.actualPayoffdate THEN n.actualPayoffdate ELSE mat.MaturityDate END)  as [MaturityDate],  
    ---ISNULL(n.ActualPayoffDate,mat.MaturityDate) as [MaturityDate],  
    lApproved.name as Approved  
    from [CORE].Maturity mat    
    INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
    Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
    Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved  
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
    where e.StatusID = 1  
    and lMaturityType.name  = @mat_Type  
    and lApproved.name = 'Y'       
    and n.noteid = @NoteID  
  
  
    UNION ALL  
  
    Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved  
    from (  
     Select n.crenoteid,n.noteid,e.effectivestartdate,'Current Maturity Date' as [MaturityType],  
     (CASE WHEN e.EffectiveStartDate = n.actualPayoffdate THEN n.actualPayoffdate ELSE mat.MaturityDate END) as [MaturityDate],  
     lApproved.name as Approved,  
     ROW_NUMBER() Over(Partition by noteid,effectivestartdate order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno  
     from [CORE].Maturity mat    
     INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId      
     INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
     Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
     Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved   
     where mat.MaturityDate > getdate()  
     and lApproved.name = 'Y'  
     and n.noteid = @NoteID   
     and e.StatusID = 1  
    )a    
    where a.rno = 1  
    and MaturityType = @mat_Type 
   )a  
   group by crenoteid,NoteID,[MaturityDate],[MaturityType]  
  )b  
  
  
  UNION  
  
  select Distinct n.crenoteid,n.noteid,n.ActualPayoffdate as effectivedate,'ActualPayoffdate' as [Type]  
  from cre.note n  
  inner join core.account acc on acc.accountid = n.account_accountid   
  where acc.isdeleted <> 1  
  and n.ActualPayoffdate is not null  
  and noteid=@NoteID  
  
  
  UNION  
  
  Select (Select Top 1 CRENoteID from cre.note where noteid = @NoteID) as CRENoteID,@NoteID as NoteID,@accountingclosedate_EffDate as effectivestartdate ,'AccountingCloseDate' as [Type]  
  
    UNION 

    select Distinct n.crenoteid,n.noteid, pm.date as effectivedate,'PrincipalWriteoffEffDate' as [Type]
    from [CRE].[WLDealPotentialImpairmentMaster] pm
    left Join [CRE].[WLDealPotentialImpairmentDetail] pd on pm.WLDealPotentialImpairmentMasterID = pd.WLDealPotentialImpairmentMasterID
    Inner JOin cre.note n on n.noteid = pd.noteid
    Inner JOin core.account acc on acc.accountid = n.Account_accountid
    Where acc.Isdeleted <> 1
    and ISNULL(pm.Applied,0) = 1
    and pd.NoteID= @NoteID

    UNION 

    select Distinct n.crenoteid,n.noteid, pm.date as effectivedate,'PrincipalWriteoffEffDate' as [Type]
    from [CRE].[WLDealPotentialImpairmentMaster] pm
    left Join [CRE].[WLDealPotentialImpairmentDetail] pd on pm.WLDealPotentialImpairmentMasterID = pd.WLDealPotentialImpairmentMasterID
    Inner JOin cre.note n on n.noteid = pd.noteid
    Inner JOin core.account acc on acc.accountid = n.Account_accountid
    Where acc.Isdeleted <> 1
    and ISNULL(pm.Applied,0) <> 1
    and pd.NoteID= @NoteID
    AND 1 = (CASE WHEN @IncludeProjectedPrincipalWriteoff = 3 THEN 1 ELSE 0 END)
    --AND 1 = (CASE WHEN @IncludeProjectedPrincipalWriteoff = 3 THEN 0 ELSE 1 END)

	UNION

	---For prepay date, it will apprear for prepay default scenario only
	Select Distinct n.crenoteid,n.noteid, d.prepaydate as effectivedate,'PrepayDate' as [Type]
	from cre.note n
	Inner join cre.deal d on d.dealid= n.dealid
	Inner join core.account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1
	and n.NoteID= @NoteID
	and 1 = (CASE WHEN @AnalysisID = @AnalysisPrepay THEN 1 WHEN @AnalysisID <> @AnalysisPrepay THEN 0 END)
	

 )a where effectivestartdate is not null  
and effectivestartdate <= @l_MaturityDate_ScenarioBased
  
   
  
 select @deal_min_effDate = min(distinct EffectiveDate) from #tNoteEffectiveDates  
  
 select @CRENoteID = CRENoteID,@NoteName=acc.name   
 from cre.note n  
 inner join core.account acc on acc.accountid = n.account_accountid   
 where noteid=@NoteID  
   
    
  
 Select  CONVERT(VARCHAR, EffectiveDate,101) as effective_dates  
 From(  
  Select Distinct EffectiveDate from #tNoteEffectiveDates   
 )a  
 order by a.EffectiveDate  
 insert into @tTableAlias([Name]) values('data.effective_dates')  
   
  

  Declare @mat_for_PeriodEndDate date;

  IF(@AnalysisName like  '%Expected%')
  BEGIN
		SET @mat_for_PeriodEndDate = (
			Select MAX(a.FullyExtended) as FullyExtended 
			From(
				Select n.noteid,MAX(mat.MaturityDate) as FullyExtended  
				from [CORE].Maturity mat    
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId     
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
				where mat.Approved = 3 
				and acc.IsDeleted <> 1
				and n.noteid = @NoteID
				group by n.noteid 

				UNION ALL

				Select  n.noteid,n.ExpectedMaturityDate as FullyExtended  
				from cre.note n
				Inner join core.account acc on acc.accountid = n.account_accountid
				Where acc.isdeleted <> 1
				and n.noteid = @NoteID
			)a group by noteid 
		)
  END
  ELSE
  BEGIN
		SET @mat_for_PeriodEndDate = (Select MAX(mat.MaturityDate) as FullyExtended  
		from [CORE].Maturity mat    
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
		where  n.noteid = @NoteID and mat.MaturityType = 710 and mat.Approved = 3  
		group by n.noteid  )
  END

  SET @mat_for_PeriodEndDate = DateADD(month,ISNULL(@MaturityAdjustmentMonths,0),@mat_for_PeriodEndDate)
  
 select CONVERT(VARCHAR, period_start_date ,101) AS period_start_date,  
  CONVERT(VARCHAR,period_end_date,101) AS period_end_date,  
  root_note_id,  
  
  (CASE WHEN @CalculationMode = 503 THEN 0 ELSE 1 END) AS calc_basis,  ---Cash Flow Only = 503  
  @calc_basis_freq as calc_basis_freq,  
  
  @calc_deffee_basis AS calc_deffee_basis,  
     @calc_disc_basis AS calc_disc_basis,  
     @calc_capcosts_basis AS calc_capcosts_basis ,  
  LOWER(@AnalysisName) + '_' + LOWER(@CRENoteID) AS client_reference_id,  
  @batch as [batch],  
 -- @init_logging AS init_logging,  
  @engine as engine,  
  @CalcStatus as CalcStatus,  
 @ExcludedForcastedPrePaymentText as ExcludedForcastedPrePaymentText,  
  @UseServicingActual as UseServicingActual,  
  @DisableBusinessDay as DisableBusinessDay,  
  @MaturityScenarioOverride as MaturityScenarioOverride,  
  @debug as debug,  
  ISNULL(@calc_priority,273) as calc_priority,  
  (CASE WHEN @calc_priority =  272 tHEN 0 ELSE 1 END) as batchType,  
  @isCalcStarted as isCalcStarted,  
  @isCalcCancel as isCalcCancel,  
  @IsAccountingClose as accountingclose  
  
  from  
 (  
 --root level info  
 select  
 --min of all notes closing date  
 (  
  select min(n.closingDate) as period_start_date  
  from [CRE].[Note] n   
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
  inner join cre.deal d on d.DealID=n.DealID  
  where  acc.IsDeleted <> 1  
  and n.noteid = @NoteID  
  
 ) as period_start_date,    
  
 (  
 -- --Logic  
 -- --loanterm = YearMonthDiff(InitialInterestAccrualEndDate,SelectedMaturityDateLatest)  
 -- --period_end_date = InitialInterestAccrualEndDate.AddMonth(loanterm + 1)  
  
	--Select DateAdd(month, DateDIff(month,n.InitialInterestAccrualEndDate,tblmatfull.FullyExtended) + (CASE WHEN DAY(tblmatfull.FullyExtended) <= DAY(n.InitialInterestAccrualEndDate) Then 0 ELSE ISNULL(n.AccrualFrequency,1) END),n.InitialInterestAccrualEndDate) period_end_date  
	--from cre.note n  
	--left join(  
	--	Select n.noteid,MAX(mat.MaturityDate) as FullyExtended  
	--	from [CORE].Maturity mat    
	--	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
	--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
	--	where  n.noteid = @NoteID and mat.MaturityType = 710 and mat.Approved = 3  
	--	group by n.noteid  
	--)tblmatfull on tblmatfull.noteid = n.noteid  
	--where n.noteid = @NoteID  

	Select DateAdd(month, DateDIff(month,n.InitialInterestAccrualEndDate,@mat_for_PeriodEndDate) + (CASE WHEN DAY(@mat_for_PeriodEndDate) <= DAY(n.InitialInterestAccrualEndDate) Then 0 ELSE ISNULL(n.AccrualFrequency,1) END),n.InitialInterestAccrualEndDate) period_end_date  
	from cre.note n	
	where n.noteid = @NoteID  
	

	
	--Select DateAdd(month, DateDIff(month,InitialInterestAccrualEndDate,maturity) + (CASE WHEN DAY(maturity) <= DAY(InitialInterestAccrualEndDate) Then 0 ELSE ISNULL(AccrualFrequency,1) END),InitialInterestAccrualEndDate) period_end_date  
	--From(	
	--	Select n1.noteid,n1.InitialInterestAccrualEndDate,n1.AccrualFrequency,
	--	ISNULL(
	--		(CASE WHEN Scenario.MaturityScenarioOverride ='Initial or Actual Payoff Date' then ISNULL(n1.ActualPayoffDate,tblInitialMaturity.InitialMaturityDate) 
	--		WHEN Scenario.MaturityScenarioOverride ='Expected Maturity Date' then n1.ExpectedMaturityDate   
	--		WHEN Scenario.MaturityScenarioOverride ='Extended Maturity Date' then tblExtendedMaturity.ExtendedMaturity
	--		WHEN Scenario.MaturityScenarioOverride ='Open Prepayment Date' then n1.OpenPrepaymentDate   
	--		WHEN Scenario.MaturityScenarioOverride ='Fully Extended Maturity Date' then tblFullyExtMaturity.FullyExtended 
	--		Else ISNULL(n1.ActualPayOffDate,ISNULL(currMat.CurrentMaturityDate,tblFullyExtMaturity.FullyExtended))  end) 
	--	,tblInitialMaturity.InitialMaturityDate)
	--	as maturity

	--	from cre.note n1
	--	Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
	--	Left Join(
	--		Select noteid,MAX(MaturityDate) as CurrentMaturityDate 
	--		from (
	--			Select n.crenoteid,n.noteid,e.EffectiveStartDate,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
	--			ROW_NUMBER() Over(Partition by noteid,e.EffectiveStartDate order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
	--			from [CORE].Maturity mat  
	--			INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	--			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	--			Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
	--			Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
	--			where ISNULL(e.StatusID,1) = 1 and acc.IsDeleted <> 1
	--			and mat.MaturityDate > getdate()
	--			and lApproved.name = 'Y'
	--			and n.noteid = @NoteId
	--		)a where a.rno = 1
	--		Group by noteid
	--	)currMat on currMat.noteid = n1.noteid
	--	Left JOin(
	--		Select n.noteid,MAX(mat.MaturityDate) as InitialMaturityDate  
	--		from [CORE].Maturity mat  
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId 	
	--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	--		where mat.MaturityType = 708 and mat.Approved = 3
	--		and ISNULL(e.StatusID,1) = 1 and acc.IsDeleted <> 1
	--		and n.noteid = @NoteId
	--		group by n.noteid 

	--	)tblInitialMaturity on tblInitialMaturity.noteid = n1.noteid
	--	Left JOin(
	--		Select n.noteid,MAX(mat.MaturityDate) as FullyExtended  
	--		from [CORE].Maturity mat  
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId 	
	--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	--		where mat.MaturityType = 710 and mat.Approved = 3
	--		and ISNULL(e.StatusID,1) = 1 and acc.IsDeleted <> 1
	--		and n.noteid = @NoteId
	--		group by n.noteid 
	--	)tblFullyExtMaturity on tblFullyExtMaturity.noteid = n1.noteid
	--	Left JOin(
	--		Select n.noteid,MAX(mat.MaturityDate) as ExtendedMaturity  
	--		from [CORE].Maturity mat  
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId 	
	--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	--		where mat.MaturityType = 709 and mat.Approved = 3
	--		and ISNULL(e.StatusID,1) = 1 and acc.IsDeleted <> 1
	--		and n.noteid = @NoteId
	--		group by n.noteid 
	--	)tblExtendedMaturity on tblExtendedMaturity.noteid = n1.noteid
	--	,
	--	(
	--		Select a.AnalysisID,a.name,l.name as MaturityScenarioOverride from core.Analysis a
	--		inner join core.analysisparameter am on am.AnalysisID = a.AnalysisID
	--		left join core.lookup l on l.lookupid = am.MaturityScenarioOverrideID
	--		where a.AnalysisID = @AnalysisID
	--	)Scenario
	--	where acc1.IsDeleted <> 1
	--	and n1.noteid = @NoteId
	
	-- )z

 ) as period_end_date  
  
  
  
 ,@CRENoteID as root_note_id  
 ) as [data.rootinfo]  
   
 insert into @tTableAlias([Name]) values('data.rootinfo')  
  
  
 ----IF(@isCalcStarted = 1 or @isCalcCancel = 1)   
 ----BEGIN  
 -- INSERT INTO dbo.tempRequest(noteid,AnalysisID,isCalcStarted,isCalcCancel,CreatedDate)  
 -- VALUES(@NoteID,@AnalysisID,@isCalcStarted,@isCalcCancel,getdate())  
 ----END  
  
  
--notes  
select Id,[name],[type],objectguid from  
(  
 --select @CRENoteID as Id,@NoteName as [name],'wholenote' as [type]  
 --union all  
 select CRENoteID as Id,ac.[Name] as [name],'legal' as [type] ,n.noteid as objectguid  
 from cre.note n join [CORE].[Account] ac   
 on n.Account_AccountID=ac.AccountID   
 where n.noteid = @NoteID  
) as [data.notes]  
insert into @tTableAlias([Name]) values('data.notes')  
  
--  
--data.notes.setup  
select CRENoteID,NoteID,CONVERT(VARCHAR, EffectiveDate,101) as effective_dates from #tNoteEffectiveDates  
as [data.notes.setup]  
order by CRENoteID,EffectiveDate  
  
insert into @tTableAlias([Name]) values('data.notes.setup')  
--  
  
--data.notes.setup.dictionary  
select CRENoteID,NoteID,  
CONVERT(VARCHAR, min_effective_dates,101) as min_effective_dates,  
CONVERT(VARCHAR, initaccenddt,101) as initaccenddt,  
CONVERT(VARCHAR, initmatdt,101) as initmatdt,  
CONVERT(VARCHAR, initpmtdt,101) as initpmtdt,  
ioterm,amterm,  
CONVERT(VARCHAR, clsdt,101) as clsdt  
,initbal  as InitFund
--,totalcmt   
,leaddays,  
CONVERT(VARCHAR, initresetdt,101) as initresetdt ,  
  
initindex,  
UPPER(roundmethod) as roundmethod,  
[precision],  
ISNULL(discount,0) as discount  
  
, stubintovrd  
, loanpurchase  
, purintovrd  
, insvrpayoverinlvly  
, intecalcrulepydn as intcalcrulepydn  
, capclscost  
, busidayrelapmtdt  
, dayofmnth  
, accfreq  
, determidtinterestaccper  
, determidayrefdayofmnth  
  
, rateindexresetfreq  
, accperpaydaywhennoteomnth  
, payfreq  
, paydatebusiessdaylag  
, stubpaidadv  
, CONVERT(VARCHAR, finalintaccenddtvrd,101) as finalintaccenddtvrd  
, stubonff  
, monamovrd  
, fixedamortsche  
, amortintcalcdaycnt  
, pikinteraddedtoblsbusiadvdate  
, piksepcomponding  
, intcalcruleforpydwnamort as intcalcruleforamort  
,CONVERT(VARCHAR, actualpayoffdate,101)  as actualpayoffdate  
,[priority]  
,lienpos  
  
,pikcalcrulepydn  
,pikcalcruleforamort  
,intcalcrulepikprinpmt  
,pikcalcrulepikprinpmt  
,CONVERT(VARCHAR, expectedmaturitydate,101)  as  expectedmaturitydate  
,CONVERT(VARCHAR, FstIndexDeterDtOverride,101) as FstIndexDeterDtOverride  
,accrualperiodtype  
,accrualperiodbusinessdayadj  
,detdt_hlday_ls  
--,CONVERT(VARCHAR, EOMONTH(DateADD(month,-1,getdate())),101)  as accountingclosedate  
,CONVERT(VARCHAR, @accountingclosedate,101)  as accountingclosedate  
,fulliotermflag 
,ISNULL(@MaturityAdjustmentMonths,0) as matadjmonth
,intonlynote
,const_pi_flag
,pmtdtaccper
,CONVERT(VARCHAR, prepaydate,101) as prepaydate

from  
(  
 select CRENoteID,NoteID,min_effective_dates,  
 initaccenddt,  
   
 --(Select  mat.maturityDate  
 -- from [CORE].Maturity mat    
 -- INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
 -- INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 -- INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID     
 -- where mat.maturityType = 708   
 -- and mat.Approved = 3  
 -- and e.statusid = 1  
 -- and n.noteid = tbldictionary.NoteID  
 -- and cast(e.effectivestartdate as date) = cast(min_effective_dates as date)  
 --) as initmatdt,  
   
 initmatdt,  
  
 initpmtdt,  
 ioterm,  
 amterm,  
 clsdt,  
 initbal,  
 totalcmt,  
 leaddays,  
 initresetdt ,  
 initindex,  
 roundmethod,  
 [precision],  
 discount  
  
 , stubintovrd  
 , loanpurchase  
 , purintovrd  
 , insvrpayoverinlvly  
 , intecalcrulepydn  
 , capclscost  
 , busidayrelapmtdt  
 , dayofmnth  
 , accfreq  
 , determidtinterestaccper  
 , determidayrefdayofmnth  
   
 , rateindexresetfreq  
 , accperpaydaywhennoteomnth  
 , payfreq  
 , paydatebusiessdaylag  
 , stubpaidadv  
 , finalintaccenddtvrd  
 , stubonff  
 , monamovrd  
 , fixedamortsche  
 , amortintcalcdaycnt  
 , pikinteraddedtoblsbusiadvdate  
 , piksepcomponding  
 , intcalcruleforpydwnamort  
 ,actualpayoffdate  
 ,[priority]  
 ,lienpos  
 ,lienposition  
 ,NoteName  
  
 ,pikcalcrulepydn  
 ,pikcalcruleforamort  
 ,intcalcrulepikprinpmt  
 ,pikcalcrulepikprinpmt  
 ,expectedmaturitydate  
 ,fstIndexDeterDtOverride  
 ,accrualperiodtype  
 ,accrualperiodbusinessdayadj  
 ,detdt_hlday_ls  
 ,fulliotermflag
 ,intonlynote
 ,const_pi_flag
 ,pmtdtaccper
 ,prepaydate
 from   
 (  
  select CRENoteID,nt.NoteID,  
  (Select   
   min(EffectiveStartDate) as effective_dates  
   from [CORE].[Event] eve  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
   inner join cre.deal d on d.DealID=n.DealID  
   where  acc.IsDeleted=0  
   and isnull(eve.StatusID,1) = 1  
   and n.NoteID=nt.NoteID  
   and n.noteid = @NoteID  
  ) min_effective_dates,  
  
  nt.InitialInterestAccrualEndDate as initaccenddt,  
  tblInitmat.InitialMat as initmatdt,  
  nt.FirstPaymentDate as initpmtdt,  
  isnull(nt.IOTerm,0) as ioterm,  
  isnull(nt.AmortTerm,0) as amterm,  
  nt.ClosingDate as clsdt,  
  isnull(nt.InitialFundingAmount,0) as initbal,  
  isnull(nt.TotalCommitment,0) as totalcmt,  
  
  ISNULL(nt.DeterminationDateLeadDays,0) as leaddays,  
  nt.FirstRateIndexResetDate as initresetdt,  
  isnull(nt.InitialIndexValueOverride,0) as initindex,  
  ISNULL(lRoundingMethod.name,'') as roundmethod,  
    
  --ISNULL((LEN(nt.IndexRoundingRule) - 1) + 2, 5)  as [precision],  
  ISNULL(nt.IndexRoundingRule, 1000)  as [precision],  
  
  ISNULL(nt.discount,0) as discount   
  
  ,ISNULL(nt.StubIntOverride,0) as stubintovrd  
  ,ISNULL(lLoanPurchase.name,'') as loanpurchase  
  ,ISNULL(nt.PurchasedInterestOverride,0) as purintovrd  
  ,ISNULL(lIncludeServicingPaymentOverrideinLevelYield.name,'') as insvrpayoverinlvly  
  ,ISNULL(lInterestCalculationRuleForPaydowns.name,'') as intecalcrulepydn  
  ,ISNULL(nt.CapitalizedClosingCosts,0) as capclscost  
  ,ISNULL(nt.BusinessdaylafrelativetoPMTDate,0) as busidayrelapmtdt  
  ,ISNULL(nt.DayoftheMonth,0) as dayofmnth  
  ,ISNULL(nt.AccrualFrequency,0) as accfreq  
  ,ISNULL(nt.DeterminationDateInterestAccrualPeriod,0) as determidtinterestaccper  
  ,ISNULL(nt.DeterminationDateReferenceDayoftheMonth,0) as determidayrefdayofmnth  
   
  ,ISNULL(nt.RateIndexResetFreq,0) as rateindexresetfreq  
  ,ISNULL(nt.AccrualPeriodPaymentDayWhenNotEOMonth,0) as accperpaydaywhennoteomnth  
  ,ISNULL(ac.PayFrequency,0) as payfreq  
  ,ISNULL(nt.PaymentDateBusinessDayLag,0) as paydatebusiessdaylag  
  ,ISNULL(lStubPaidinAdvanceYN.name,'') as stubpaidadv  
  ,nt.FinalInterestAccrualEndDateOverride as finalintaccenddtvrd  --dt  
  ,ISNULL(lStubInterestPaidonFutureAdvances.name,'') as stubonff  
  ,ISNULL(nt.MonthlyDSOverridewhenAmortizing,0) as monamovrd  
  ,ISNULL(lFixedAmortScheduleCheck.name,'') as fixedamortsche  
  ,ISNULL(nt.AmortIntCalcDayCount,0) as amortintcalcdaycnt  
  ,ISNULL(lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.name,'') as pikinteraddedtoblsbusiadvdate  
  ,ISNULL(lPIKSeparateCompounding.name,'') as piksepcomponding  
  ,ISNULL(lInterestCalculationRuleForPaydownsAmort.name,'') as intcalcruleforpydwnamort  
    
  ,nt.ActualPayOffDate as actualpayoffdate  
  ,ISNULL(nt.[priority],0) as [priority]  
  ,isnuLL(llienposition.name,'') as lienpos  
  
  ,nt.lienposition  
  ,ac.name as NoteName  
  
  ,ISNULL(lpikCalculationRuleForPaydowns.name,'') as pikcalcrulepydn  
  ,ISNULL(lpikCalculationRuleForPaydownsAmort.name,'') as pikcalcruleforamort  
    
  --,ISNULL(lInterestCalculationRuleForPaydowns.name,'') as intcalcrulepikprinpmt  
  ,ISNULL(lInterestCalculationRuleForPIKPaydowns.name,'') as intcalcrulepikprinpmt 

  ,ISNULL(lpikCalculationRuleForPaydowns.name,'') as pikcalcrulepikprinpmt  
  ,nt.expectedmaturitydate  
  ,nt.FirstIndexDeterminationDateOverride as fstIndexDeterDtOverride  
  ,ISNULL(lAccrualPeriodType.name,'') as accrualperiodtype  
  ,ISNULL(lAccrualPeriodBusinessDayAdj.name,'') as accrualperiodbusinessdayadj  
  ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'') = 'US & UK' Then 'US_and_UK' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'') END)  as detdt_hlday_ls 
  ,ISNULL(lFullIOTermFlag.name,'') as fulliotermflag
  ,ISNULL(lInterestOnlyNote.name,'') as intonlynote
  ,ISNULL(lConstantPaymentMethod.name,'') as const_pi_flag
  ,ISNULL(lPaymentDateAccrualPeriod.name,'') as pmtdtaccper
  ,d.prepaydate
  from cre.note nt   
  inner join [CORE].[Account] ac on nt.Account_AccountID=ac.AccountID   
  Inner join cre.deal d on d.dealid = nt.dealid
  left join core.lookup lRoundingMethod on lRoundingMethod.lookupid = nt.RoundingMethod  
  left JOin core.lookup lLoanPurchase on lLoanPurchase.lookupid = nt.LoanPurchase  
  left JOin core.lookup lIncludeServicingPaymentOverrideinLevelYield on lIncludeServicingPaymentOverrideinLevelYield.lookupid = nt.IncludeServicingPaymentOverrideinLevelYield  
  left JOin core.lookup lInterestCalculationRuleForPaydowns on lInterestCalculationRuleForPaydowns.lookupid = nt.InterestCalculationRuleForPaydowns  
  left JOin core.lookup lStubPaidinAdvanceYN on lStubPaidinAdvanceYN.lookupid = nt.StubPaidinAdvanceYN  
  left JOin core.lookup lStubInterestPaidonFutureAdvances on lStubInterestPaidonFutureAdvances.lookupid = nt.StubInterestPaidonFutureAdvances  
  left JOin core.lookup lFixedAmortScheduleCheck on lFixedAmortScheduleCheck.lookupid = nt.FixedAmortScheduleCheck  
  left JOin core.lookup lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate on lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.lookupid = ISNULL(nt.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate  ,4)
  left JOin core.lookup lPIKSeparateCompounding on lPIKSeparateCompounding.lookupid = nt.PIKSeparateCompounding  
  left JOin core.lookup lInterestCalculationRuleForPaydownsAmort on lInterestCalculationRuleForPaydownsAmort.lookupid = nt.InterestCalculationRuleForPaydownsAmort  
  left join Core.Lookup llienposition ON nt.lienposition=llienposition.LookupID   
  
  left JOin core.lookup lpikCalculationRuleForPaydowns on lpikCalculationRuleForPaydowns.lookupid = nt.pikCalculationRuleForPaydowns  
  left JOin core.lookup lpikCalculationRuleForPaydownsAmort on lpikCalculationRuleForPaydownsAmort.lookupid = nt.pikCalculationRuleForPaydownsAmort  
  left JOin core.lookup lInterestCalculationRuleForPIKPaydowns on lInterestCalculationRuleForPIKPaydowns.lookupid = nt.InterestCalculationRuleForPIKPaydowns  

  left JOin core.lookup lAccrualPeriodType on lAccrualPeriodType.lookupid = ISNULL(nt.AccrualPeriodType,811)  
  left JOin core.lookup lAccrualPeriodBusinessDayAdj on lAccrualPeriodBusinessDayAdj.lookupid = ISNULL(nt.AccrualPeriodBusinessDayAdj,813)  
  LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = nt.DeterminationDateHolidayList  
  Left JOin core.lookup lFullIOTermFlag on lFullIOTermFlag.lookupid = nt.FullIOTermFlag 
  Left JOin core.lookup lInterestOnlyNote on lInterestOnlyNote.lookupid = nt.InterestOnlyNote
  Left JOin core.lookup lConstantPaymentMethod on lConstantPaymentMethod.lookupid = nt.ConstantPaymentMethod
  Left JOin core.lookup lPaymentDateAccrualPeriod on lPaymentDateAccrualPeriod.lookupid = nt.PaymentDateAccrualPeriod
  Left Join(  
     
   Select n.noteid,ISNULL(n.actualpayoffdate,tblmatfull.FullyExtended) InitialMat  
   from cre.note n  
   left join(  
    Select n.noteid,mat.MaturityDate as FullyExtended  
    from [CORE].Maturity mat    
    INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
    INNER JOIN     
    (            
     Select     
     (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
     MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
     INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
     INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
     where EventTypeID = 11  and eve.StatusID = 1  
     and acc.IsDeleted = 0    
     and n.noteid = @NoteID  
     GROUP BY n.Account_AccountID,EventTypeID      
    ) sEvent      
    ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1  
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
    where mat.MaturityType = 710 and mat.Approved = 3  
   )tblmatfull on tblmatfull.noteid = n.noteid  
   where n.noteid = @NoteID  
  
  
   --Select n.noteid,mat.MaturityDate as InitialMat  
   --from [CORE].Maturity mat    
   --INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
   --INNER JOIN     
   --(            
   -- Select     
   -- (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
   -- MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
   -- INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
   -- INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
   -- where EventTypeID = 11  and eve.StatusID = 1  
   -- and acc.IsDeleted = 0    
   -- and n.NoteID = @NoteID  
   -- GROUP BY n.Account_AccountID,EventTypeID      
   --) sEvent      
   --ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1  
   --INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
   --INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
   --where mat.MaturityType = 708 and mat.Approved = 3  
   --and n.NoteID = @NoteID  
  
  )tblInitmat on tblInitmat.NoteID = nt.NoteID  
  where nt.noteid = @NoteID  
  
 ) tbldictionary  
) as [data.notes.setup.dictionary]  
order by ISNULL(lienposition,99999), [Priority],initbal desc, NoteName  
insert into @tTableAlias([Name]) values('data.notes.setup.dictionary')  
--  
  
  
---==================================================================  
--data.notes.setup.tables.funiding  
--Select CRENoteID, noteid,  
--CONVERT(VARCHAR, effectivedate,101) as effectivedate,  
--CONVERT(VARCHAR, dt,101) as dt,  
--fundpydn,  
--purpose,  
--purposeText  
--from(  
-- Select n.CRENoteID, n.noteid,e.effectivestartdate as effectivedate,fs.date as dt,Cast(ROUND(ISNULL(fs.value,0),2) as decimal(28,2)) as fundpydn,fs.PurposeID as purpose,LPurposeID.name as purposeText  
-- from [CORE].FundingSchedule fs  
-- INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
-- left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
-- left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID   
-- INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
-- INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
-- where e.StatusID = 1 and acc.IsDeleted = 0 --and LPurposeID.name <> 'Amortization'  
-- and n.noteid = @NoteID  
--) as [data.notes.setup.tables.funding]  
--order by noteid,CAST(effectivedate as date),CAST(dt as date)  
--insert into @tTableAlias([Name]) values('data.notes.setup.tables.funding')  
  
--data.notes.setup.tables.funiding  
IF OBJECT_ID('tempdb..#tblFF ') IS NOT NULL               
 DROP TABLE #tblFF  
  
CREATE TABLE #tblFF  
(  
 NoteID UNIQUEIDENTIFIER,  
 AccountID UNIQUEIDENTIFIER,  
 Date Date,  
 Value decimal(28,15) null,  
 EffectiveDate date,  
 EffectiveStartDate date,  
 EffectiveEndDate date,  
 EventTypeID int null,  
 EventTypeText nvarchar(256),  
 EventID UNIQUEIDENTIFIER null,  
 PurposeID int null,  
 PurposeText nvarchar(256),  
 Applied bit null,  
 CreatedBy nvarchar(256),  
 CreatedDate datetime,  
 UpdatedBy nvarchar(256),  
 UpdatedDate datetime,  
 NonCommitmentAdj bit  ,
 AdjustmentType nvarchar(256)

)  
  
INSERT INTO #tblFF(NoteID,AccountID,Date,Value,EffectiveDate,EffectiveStartDate,EffectiveEndDate,EventTypeID,EventTypeText,EventID,PurposeID,PurposeText,Applied,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AdjustmentType)  
exec [dbo].[usp_GetFutureFundingScheduleDataByDealId] @DealID  
  
---========================
Declare @tblPrincipalWriteoffEffDateActual as Table(
NoteID UNIQUEIDENTIFIER,
EffDate date
)

INSERT INTO @tblPrincipalWriteoffEffDateActual(NoteID,EffDate)

select Distinct n.noteid, pm.date as effectivedate
from [CRE].[WLDealPotentialImpairmentMaster] pm
left Join [CRE].[WLDealPotentialImpairmentDetail] pd on pm.WLDealPotentialImpairmentMasterID = pd.WLDealPotentialImpairmentMasterID
Inner JOin cre.note n on n.noteid = pd.noteid
Inner JOin core.account acc on acc.accountid = n.Account_accountid
Where acc.Isdeleted <> 1
and ISNULL(pm.Applied,0) = 1
and pd.NoteID= @NoteID
---========================



  
Select CRENoteID, noteid,  
--(CASE WHEN purposeText= 'Principal Writeoff' THEN  CONVERT(VARCHAR, dt,101) ELSE CONVERT(VARCHAR, effectivedate,101) END) as effectivedate,  
CONVERT(VARCHAR, effectivedate,101)  as effectivedate,
CONVERT(VARCHAR, dt,101) as dt,  
fundpydn,  
purpose,  
purposeText,  
noncommitmentadj,
adjustmenttype
from(  
	Select n.CRENoteID, n.noteid,fs.effectivestartdate as effectivedate,fs.date as dt,Cast(ROUND(ISNULL(fs.value,0),2) as decimal(28,2)) as fundpydn,ISNULL(fs.PurposeID,0) as purpose,ISNULL(fs.purposeText,'') as purposeText  
	,(CASE WHEN NonCommitmentAdj = 1 THEN 'Yes' ELSE 'No' END) as NonCommitmentAdj  
	,AdjustmentType
	from #tblFF fs  
	INNER JOIN [CRE].[Note] n ON n.noteid = fs.NoteID   
	where n.noteid = @NoteID   
	and ISNULL(fs.purposeText,'a') <> 'Amortization'  
	and fs.PurposeID <> 840   ---'Principal Writeoff' 

	UNION ALL
	-----Added data in Principal Writeoff effective date 
	Select CRENoteID,z.noteid,pwed.EffDate as effectivedate,dt,fundpydn,purpose,purposeText,NonCommitmentAdj,AdjustmentType
	From(
		Select n.CRENoteID, n.noteid,fs.effectivestartdate as effectivedate,fs.date as dt,Cast(ROUND(ISNULL(fs.value,0),2) as decimal(28,2)) as fundpydn,ISNULL(fs.PurposeID,0) as purpose,ISNULL(fs.purposeText,'') as purposeText  
		,(CASE WHEN NonCommitmentAdj = 1 THEN 'Yes' ELSE 'No' END) as NonCommitmentAdj  
		,AdjustmentType
		from #tblFF fs 
		INNER JOIN [CRE].[Note] n ON n.noteid = fs.NoteID   
		Inner Join(
			Select ff.noteid,MAX(ff.EffectiveDate) as EffectiveDate
			from #tblFF ff 
			where ff.noteid = @NoteID
			group by ff.noteid
		)a on a.NoteID = fs.NoteID and a.EffectiveDate = fs.EffectiveDate
		where n.noteid = @NoteID
		and ISNULL(fs.purposeText,'a') <> 'Amortization' 
	)z ,@tblPrincipalWriteoffEffDateActual pwed 
	where z.dt >= pwed.EffDate

) as [data.notes.setup.tables.funding]  
order by noteid,CAST(effectivedate as date),CAST(dt as date)  
insert into @tTableAlias([Name]) values('data.notes.setup.tables.funding')  





--Select CRENoteID,z.noteid,y.PrinWriteEffDate as effectivedate,dt,fundpydn,purpose,purposeText,NonCommitmentAdj,AdjustmentType
--From(
--	Select n.CRENoteID, n.noteid,fs.effectivestartdate as effectivedate,fs.date as dt,Cast(ROUND(ISNULL(fs.value,0),2) as decimal(28,2)) as fundpydn,ISNULL(fs.PurposeID,0) as purpose,ISNULL(fs.purposeText,'') as purposeText  
--	,(CASE WHEN NonCommitmentAdj = 1 THEN 'Yes' ELSE 'No' END) as NonCommitmentAdj  
--	,AdjustmentType
--	,a.EffDate
--	from #tblFF fs 
--	INNER JOIN [CRE].[Note] n ON n.noteid = fs.NoteID   
--	Inner Join(
--		Select ff.noteid,pp.EffDate,MAX(ff.EffectiveDate) as EffectiveDate
--		from #tblFF ff ,@tblPrincipalWriteoffEffDateActual pp
--		where ff.noteid = '494021e0-1a87-4b5b-b777-16f3048c6a6b'
--		and ff.EffectiveDate <= pp.EffDate
--		group by ff.noteid,pp.EffDate
--	)a on a.NoteID = fs.NoteID and a.EffectiveDate = fs.EffectiveDate
--	where n.noteid = '494021e0-1a87-4b5b-b777-16f3048c6a6b'   
--	and ISNULL(fs.purposeText,'a') <> 'Amortization' 
--)z 
--Left Join (
--	Select ff.noteid,pp.EffDate as PrinWriteEffDate,MAX(ff.EffectiveDate) as FF_EffectiveDate
--	from #tblFF ff ,@tblPrincipalWriteoffEffDateActual pp
--	where ff.noteid = '494021e0-1a87-4b5b-b777-16f3048c6a6b'
--	and ff.EffectiveDate <= pp.EffDate
--	group by ff.noteid,pp.EffDate
--)y on z.NoteID = y.NoteID and z.effectivedate = y.FF_EffectiveDate 
--where z.dt >= y.PrinWriteEffDate
---==================================================================  
  
  
  
Select CRENoteID, noteid,  
CONVERT(VARCHAR, effectivedate,101) as effectivedate,  
CONVERT(VARCHAR, dt,101) as dt,  
val  
from(  
 Select n.CRENoteID, n.noteid,e.effectivestartdate as effectivedate,fs.date as dt,Cast(ROUND(ISNULL(fs.value,0),2) as decimal(28,2)) as val  
 from [CORE].AmortSchedule fs  
 INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
 left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
 where e.StatusID = 1 and acc.IsDeleted = 0   
 and n.noteid = @NoteID  
) as [data.notes.setup.tables.amsch]  
order by noteid,CAST(effectivedate as date),CAST(dt as date)  
insert into @tTableAlias([Name]) values('data.notes.setup.tables.amsch')  
  
 
 

Declare @L_pik_MaxEffDate Date;

Select @L_pik_MaxEffDate = MAX(EffectiveStartDate) 
from [CORE].PikSchedule pik
Inner JOin [CORE].[Event] eve  on eve.EventID = pik.EventID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
where EventTypeID = 12 -- 'PikSchedule'
and n.NoteID = @NoteID  and acc.IsDeleted = 0  
 

  
Select   
crenoteid  
,noteid  
,CONVERT(VARCHAR, effectivedate,101) as effectivedate  
,CONVERT(VARCHAR, startdt,101) as startdt  
,CONVERT(VARCHAR, enddt,101) as enddt  
,ISNULL(rate,0) as rate  
,ISNULL(spread,0) as spread  
,ISNULL(index_floor,0) as index_floor  
,ISNULL(intcalcdays ,0) as intcalcdays  
,ISNULL(cap_bal,0) as cap_bal  
,ISNULL(acc_cap_bal,0) as acc_cap_bal  
,pik_sep_comp   
,ISNULL(pik_reason_code ,'') as pik_reason_code  
,ISNULL(pik_comments,'') as pik_comments  
,ISNULL(pur_balance,0) as pur_balance  
,ISNULL(periodic_rate_cap_amount,0) as periodic_rate_cap_amount  
,ISNULL(periodic_rate_cap_per,0) as periodic_rate_cap_per  
,ISNULL(piksetup,0) as piksetup
,ISNULL(pikpercentage,0) as pikpercentage
,ISNULL(comp_rate,0) as comp_rate
,ISNULL(comp_spread,0) as comp_spread
,ISNULL(currentpayrate,0) as currentpayrate
From(  
 Select   n.crenoteid,n.noteid,e.EffectiveStartDate as effectivedate    
 ,pik.[StartDate] as startdt  
 ---,pik.[EndDate] as enddt  
 ,(CASE WHEN e.EffectiveStartDate = @L_pik_MaxEffDate and pik.StartDate is not null and pik.EndDate is null THEN DATEADD(day,-1,@l_MaturityDate_ScenarioBased) ELSE pik.[EndDate] END) as enddt  ---DATEADD(day,-1,@L_FullyExtendedDate) 
 ,pik.[AdditionalIntRate]   as rate  
 ,pik.[AdditionalSpread]  as spread  
 ,pik.[IndexFloor] as index_floor  
 ,PIKIntCalcMethodID as intcalcdays  
 ,pik.[IntCapAmt]  as cap_bal  
 ,pik.[AccCapBal] as acc_cap_bal  
 ,CAST((CASE When lPIKSeparateCompounding.name = 'Y' THEN 1 else 0 end) as bit) as pik_sep_comp  
 ,LPIKReasonCode.name as pik_reason_code   
 ,pik.PIKComments   as pik_comments  
 ,pik.PurBal as pur_balance  
 ,pik.PeriodicRateCapAmount as periodic_rate_cap_amount  
 ,pik.PeriodicRateCapPercent as periodic_rate_cap_per  
 ,pik.PIKSetUp as piksetup
 ,pik.pikpercentage

 ,pik.IntCompoundingRate as comp_rate
 ,pik.IntCompoundingSpread as comp_spread
 ,pik.PIKCurrentPayRate as currentpayrate

 from [CORE].PikSchedule pik    
 left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID    
 left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID    
 INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId    
 LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID    
 LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID    
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
 left JOin core.lookup lPIKSeparateCompounding on lPIKSeparateCompounding.lookupid = pik.PIKSeparateCompounding  ---n.PIKSeparateCompounding
--left JOin core.lookup lPIKSetUp on lPIKSetUp.lookupid =pik.PIKSetUp  
--left JOin core.lookup lPIKAccruesatDifferentRate on lPIKAccruesatDifferentRate.lookupid =pik.PIKAccruesatDifferentRate   
 where ISNULL(e.StatusID,1) = 1 --and acc.IsDeleted = 0   
 and n.noteid = @NoteID  
  
)as [data.notes.setup.tables.pikrate]  
order by noteid,CAST(effectivedate as date),CAST(startdt as date)  
insert into @tTableAlias([Name]) values('data.notes.setup.tables.pikrate')  
  
  
  
  
Select CRENoteID, noteid,  
CONVERT(VARCHAR, effectivedate,101) as effectivedate,  
CONVERT(VARCHAR, dt,101) as dt,  
val  
from(  
 Select n.CRENoteID, n.noteid,e.effectivestartdate as effectivedate,fs.date as dt,Cast(ROUND(ISNULL(fs.value,0),2) as decimal(28,2)) as val  
 from [CORE].PIKScheduleDetail fs  
 INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
 left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
 where e.StatusID = 1 and acc.IsDeleted = 0   
 and n.noteid = @NoteID  
) as [data.notes.setup.tables.piksch]  
order by noteid,CAST(effectivedate as date),CAST(dt as date)  
insert into @tTableAlias([Name]) values('data.notes.setup.tables.piksch')  

  
  
--setup->tables->rate spread  
--select NoteID,EffectiveDate,startdt,valtype,val ,intcalcdays  
--from  
--(  
--Select tn.NoteID,tn.EffectiveDate,rs.Date as startdt,  
--replace(lower(tl.[Name]),' ','_') as valtype,rs.Value as val ,360 as intcalcdays  
--from core.RateSpreadSchedule rs    
--INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
--LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID  
--INNER JOIN @tNoteEffectiveDates tn on tn.NoteID=n.NoteID  
--and tn.EffectiveDate=e.effectivestartdate  
--) as [data.notes.setup.tables]  
-- order by NoteID,EffectiveDate  
  
 --  
 --setup->tables->all rate spread with one result set corresponding to each  
insert into @tRateSpreadSchedule  
Select distinct rs.ValuetypeID,replace(lower(tl.[Name]),' ','_')  
from core.RateSpreadSchedule rs    
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID  
INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate  
where e.statusid = 1  
  
  
select @totalCntRateSpread = count(1) from @tRateSpreadSchedule  
while (@cnt<=@totalCntRateSpread)  
BEGIN  
  select @ValueTypeID=ValueTypeID,@Name=Name from @tRateSpreadSchedule where ID=@cnt  
   
 if(@Name = 'rate')  
 BEGIN  
   set @RateSpreadSchedule='Select CRENoteID, NoteID,  
   CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
   CONVERT(VARCHAR, startdt,101) as startdt,  
   valtype,  
   val,  
   intcalcdays,  
   detdt_hlday_ls,  
   LOWER(indexnametext) as indexnametext  
   from  
   (  
    Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,  
    '''+@Name+''' as valtype,isnull(rs.Value,0) as val ,  
    ISNULL(IntCalcMethodID,0) as intcalcdays  
   ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls  
   ,ISNULL(lindex.name,'''') as indexnametext  
   from core.RateSpreadSchedule rs    
   INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
   LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID  
   LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList  
   LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID   
   INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate  
   where e.statusid = 1 and ValueTypeID='''+@ValueTypeID+'''  
  
   union all  
  
   Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,  
    '''+@Name+''' as valtype,0 as val ,  
    ISNULL(IntCalcMethodID,0) as intcalcdays  
    ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls  
    ,ISNULL(lindex.name,'''') as indexnametext  
   from core.RateSpreadSchedule rs    
   INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
   LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID  
   LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList  
   LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID   
   INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate  
   where e.statusid = 1 and ValueTypeID=151  
  ) as [data.notes.'''+@Name+''']'  
 END  
 ELSE if(@Name = 'spread')  
 BEGIN  
   set @RateSpreadSchedule='Select CRENoteID, NoteID,  
   CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
   CONVERT(VARCHAR, startdt,101) as startdt,  
   valtype,  
   val,  
   intcalcdays,  
   detdt_hlday_ls,  
   LOWER(indexnametext) as indexnametext  
   from  
   (  
    Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,  
    '''+@Name+''' as valtype,isnull(rs.Value,0) as val ,  
    ISNULL(IntCalcMethodID,0) as intcalcdays  
    ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls  
    ,ISNULL(lindex.name,'''') as indexnametext  
   from core.RateSpreadSchedule rs    
   INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
   LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID  
   LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList  
   LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID   
   INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate  
   where e.statusid = 1 and ValueTypeID='''+@ValueTypeID+'''  
  
   union all  
  
   Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,  
    '''+@Name+''' as valtype,0 as val ,  
    ISNULL(IntCalcMethodID,0) as intcalcdays  
    ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls  
    ,ISNULL(lindex.name,'''') as indexnametext  
   from core.RateSpreadSchedule rs    
   INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
   LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID  
   LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList  
   LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID   
   INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate  
   where e.statusid = 1 and ValueTypeID=150  
  ) as [data.notes.'''+@Name+''']'  
 END  
 ELSE  
 BEGIN  
  set @RateSpreadSchedule='Select CRENoteID, NoteID,  
  CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
  CONVERT(VARCHAR, startdt,101) as startdt,  
  valtype,  
  val,  
  intcalcdays,  
  detdt_hlday_ls,  
  LOWER(indexnametext) as indexnametext  
  from  
  (  
   Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,  
   '''+@Name+''' as valtype,isnull(rs.Value,0) as val ,  
   ISNULL(IntCalcMethodID,0) as intcalcdays  
   ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls  
   ,ISNULL(lindex.name,'''') as indexnametext  
  from core.RateSpreadSchedule rs    
  INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID  
  LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList  
  LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID   
  INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate  
  where e.statusid = 1 and ValueTypeID='''+@ValueTypeID+'''  
 ) as [data.notes.'''+@Name+''']'  
 END  
  
 insert into @tTableAlias ([Name],GroupName) values('data.notes.'+@Name,'rate')  
 EXEC (@RateSpreadSchedule)  
 set @cnt+=1  
END  
  
-- 


Declare @L_FeeSche_MaxEffDate Date;

Select @L_FeeSche_MaxEffDate = MAX(EffectiveStartDate) 
from [CORE].PrepayAndAdditionalFeeSchedule pik
Inner JOin [CORE].[Event] eve  on eve.EventID = pik.EventID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
where EventTypeID = 13 -- 'PrepayAndAdditionalFeeSchedule'
and eve.StatusID = 1
and n.NoteID = @NoteID  and acc.IsDeleted = 0  


   
 --data.notes.setup.tables.fees  
 select CRENoteID, NoteID,  
 CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
 feename,  
 CONVERT(VARCHAR, startdt,101) as startdt,  
 CONVERT(VARCHAR, enddt,101) as enddt,  
 valtype,[type],  
 val ,ovrfeeamt,ovrbaseamt,trueupflag, levyldincl,basisincl, stripval,  
 CONVERT(VARCHAR, actual_startdt,101) as actual_startdt  ,
 feescheduleid
 from  
 (  
  Select n.CRENoteID, tn.NoteID,tn.EffectiveDate,  
  ISNULL(rs.FeeName,'') as feename,  
  ---rs.StartDate as startdt,  
  --(CASE 
  --WHEN (fe.FeeTypeNameID = rs.ValueTypeID) and rs.StartDate < tn.EffectiveDate  THEN tn.EffectiveDate
  --WHEN rs.EndDate is not null and rs.StartDate < tn.EffectiveDate and rs.EndDate >= tn.EffectiveDate THEN tn.EffectiveDate 
  --ELSE rs.StartDate END
  --) as startdt,  
  
	(CASE 
	WHEN (fe.FeeTypeNameID = rs.ValueTypeID) and rs.StartDate < tn.EffectiveDate  THEN tn.EffectiveDate  
	ELSE rs.StartDate END
	) as startdt,  

  --rs.EndDate as enddt,  
  (CASE WHEN rs.EndDate is null  and (fe.FeeTypeNameID = rs.ValueTypeID) THEN @l_MaturityDate_ScenarioBased ELSE rs.EndDate END) as enddt,   ------and e.EffectiveStartDate = @L_FeeSche_MaxEffDate   ----- @L_FullyExtendedDate

  rs.ValueTypeID as valtype,  
  LValueTypeID.FeeTypeNameText as [type]  ,  
  ISNULL(rs.Value,0) as val ,  
  ISNULL(rs.FeeAmountOverride,0) as ovrfeeamt,  
  ISNULL(rs.BaseAmountOverride,0) as ovrbaseamt,  
  
  rs.ApplyTrueUpFeature as trueupflag,  
  --ISNULL(tApplyTrueUpFeature.name,'') as trueupflag,  
  
  ISNULL(rs.IncludedLevelYield,0) as levyldincl,  
  ISNULL(rs.IncludedBasis,0) as basisincl,  
  ISNULL(rs.FeetobeStripped,0) as stripval,  
  rs.StartDate as actual_startdt  ,
  PrepayAndAdditionalFeeScheduleID as feescheduleid
 from core.PrepayAndAdditionalFeeSchedule rs    
 INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
 LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = rs.ValueTypeID    
 LEFT JOIN core.Lookup tApplyTrueUpFeature ON tApplyTrueUpFeature.LookupID=rs.ApplyTrueUpFeature   
 INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate  
 LEFT JOIN(
	Select	FeeTypeNameID,
	FS.FeeTypeNameText as feename	
	from [CRE].[FeeSchedulesConfig] FS
	LEFT JOIN [CORE].[Lookup] LFeePaymentFrequencyID ON LFeePaymentFrequencyID.LookupID = FS.FeePaymentFrequencyID AND LFeePaymentFrequencyID.ParentID=89 
	LEFT JOIN [CORE].[Lookup] LFeeCoveragePeriodID ON LFeeCoveragePeriodID.LookupID = FS.FeeCoveragePeriodID AND LFeeCoveragePeriodID.ParentID=90	
	where ISNULL(IsActive,1)  = 1
	--and LFeePaymentFrequencyID.Name = 'Transaction Based'
	and LFeeCoveragePeriodID.Name = 'Open Period'
 )fe on fe.FeeTypeNameID =  rs.ValueTypeID    

 where e.statusid = 1  
) as [data.notes.setup.tables.fees]  
 order by NoteID,EffectiveDate  
  
 insert into @tTableAlias([Name]) values('data.notes.setup.tables.fees')  
  
  
  
 --data.notes.setup.tables.fee_stripping  
 select CRENoteID,NoteID,[to],pct,feetype,feename  ,feescheduleid
 from  
 (  
 select n.CRENoteID,n.NoteID,nTo.CRENoteID as [to],ISNULL(Value,0) as pct ,fsc.feetypenametext as feetype,feesch.feename  ,feesch.FeeScheduleID
 from cre.note n join [CORE].[Account] ac   
 on n.Account_AccountID=ac.AccountID   
 join cre.payrulesetup p on p.StripTransferFrom = n.NoteID  
 left join cre.note nTo on p.StripTransferTo = nTo.NoteID  
 left join cre.feeschedulesconfig fsc on fsc.FeeTypeNameID = p.RuleID  
 Left JOin(  
  Select n.noteid,pafs.ValueTypeID  ,LValueTypeID.FeeTypeNameText,pafs.FeeName  ,pafs.PrepayAndAdditionalFeeScheduleID as FeeScheduleID
  from [CORE].PrepayAndAdditionalFeeSchedule pafs    
  INNER JOIN [CORE].[Event] e on e.EventID = pafs.EventId   
  LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = pafs.ValueTypeID    
	  --INNER JOIN   (           
	  -- Select     
	  -- (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
	  -- MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
	  -- INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
	  -- INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
	  -- where EventTypeID = 13  
	  -- and eve.StatusID = 1   
	  -- and acc.IsDeleted = 0       
	  -- GROUP BY n.Account_AccountID,EventTypeID      
	  --) sEvent  ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID    
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
  where e.StatusID = 1  
 ---)feesch on feesch.noteid = nTo.noteid and feesch.ValueTypeID = p.RuleID  
 )feesch on feesch.noteid = n.noteid and feesch.ValueTypeID = p.RuleID
 where n.noteid = @NoteID and ac.IsDeleted=0  
) as [data.notes.setup.tables.fee_stripping]  
order by CRENoteID  
  
insert into @tTableAlias([Name]) values('data.notes.setup.tables.fee_stripping')  
--  
  
--data.deal.setup.min_effective_date  
select CONVERT(VARCHAR, @deal_min_effDate,101) as min_effective_dates,  
CONVERT(VARCHAR, clsdt,101) as clsdt,  
initbal,  
CONVERT(VARCHAR, initmatdt,101) as initmatdt  
from  
(  
 select  
 (select min(n.closingDate) as period_start_date  
  from [CORE].[Event] eve  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
  inner join cre.deal d on d.DealID=n.DealID  
  where  acc.IsDeleted=0  
  and isnull(eve.StatusID,1) = 1  
  and n.noteid = @NoteID  
 ) as clsdt,  
 (select sum(isnull(InitialFundingAmount,0)) from cre.note where noteid = @NoteID) as initbal,  
 (Select  MIN(mat.maturityDate)   
  from [CORE].Maturity mat    
  INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID     
  where e.statusid = 1 and   
  mat.maturityType = 708   
  and mat.Approved = 3  
  and n.noteid = @NoteID  
  and e.effectiveStartDate=@deal_min_effDate  
  group by n.dealid  
 ) as initmatdt  
  
) as [data.deal.setup.min_effective_date]  
  
insert into @tTableAlias([Name]) values('data.deal.setup.min_effective_date')  
--  
  
  
----data.deal.setup.tables --deal funding  
--select   
--CONVERT(VARCHAR, @deal_min_effDate,101) as min_effective_date,  
--CONVERT(VARCHAR, Date,101) as dt,  
--ISNULL(Amount,0) as fundpydn ,  
--PurposeID as purpose   
--from cre.dealfunding as [data.deal.setup.tables]  
--where dealid=@DealID order by [date]  
--insert into @tTableAlias([Name]) values('data.deal.setup.tables.funding')  
  
  
  
  
--data.structure  
select CREDealID as [from],CRENoteID as [to]  
from  
(  
 select distinct(n.CRENoteID) as CRENoteID,d.CREDealID as CREDealID  
 from [CORE].[Event] eve  
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
 inner join cre.deal d on d.DealID=n.DealID  
 where  acc.IsDeleted=0  
 and isnull(eve.StatusID,1) = 1  
 and n.noteid = @NoteID  
) as [data.structure]  
order by CRENoteID  
  
insert into @tTableAlias([Name]) values('data.structure')  
--  
  
--data.rulesets.pay  
Select @TotalSequ1 = sum(ISNULL(fs.Value,0))  
from [CRE].[FundingRepaymentSequence] fs  
INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID  
LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType  
where n.noteid = @NoteID  
and fs.SequenceNo=1 and fs.SequenceType=258  
  
select CRENoteID as note, CAST(ROUND(Value,2) as decimal(28,2))  as cumulative_threshold,[weight]  
from  
(  
 Select n.CRENoteID,isnull(fs.Value,0) as Value,  
 [weight]=case when isnull(fs.Value,0)=0 then 0 else isnull(fs.Value,0)/@TotalSequ1 end,  
 1 as sortorder  
 from [CRE].[FundingRepaymentSequence] fs  
 INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID  
 inner join Core.Account a on a.AccountID=n.Account_AccountID  
 LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType  
 where n.noteid = @NoteID  
 and fs.SequenceNo=1 and fs.SequenceType=258  
 and n.UseRuletoDetermineNoteFunding=@UseRuletoDetermineNoteFundingAsYES  
  
 union  
  
 select CRENoteID,Value, [weight],sortorder   
 from (  
  Select top 1 n.CRENoteID,0 as Value,0 as [weight], 2 as sortorder  
  from [CRE].[FundingRepaymentSequence] fs  
  INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID  
  inner join Core.Account a on a.AccountID=n.Account_AccountID  
  LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType  
  where n.noteid = @NoteID  
  and fs.SequenceNo=1 and fs.SequenceType=258  
  and n.UseRuletoDetermineNoteFunding=@UseRuletoDetermineNoteFundingAsYES  
  order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, a.Name  
 ) tb1  
) as [data.rulesets.pay]  
order by sortorder  
  
insert into @tTableAlias([Name]) values('data.rulesets.pay')  
--  
  
  
  
--data.index  
Declare @min_closingDate date;  
 SET @min_closingDate = (select min(n.closingDate) min_closingDate  
  from [CRE].[Note] n  
  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
  inner join cre.deal d on d.DealID=n.DealID  
  where  acc.IsDeleted=0   
  and n.noteid = @NoteID)  
  
  
----====================================  
--Declare @Min_IndexDate date;  
--Declare @Max_IndexDate date;  
  
--set @Min_IndexDate = DATEADD(day,-5,@min_closingDate)  
  
--SET @Max_IndexDate = (Select  max(i.[date]) as Max_IndexDate  
--from core.Indexes i  
--Inner Join core.indexesmaster im on im.IndexesMasterID = i.IndexesMasterID  
--left JOin core.lookup l on l.lookupid = i.IndexType  
--where im.IndexesName = @IndexName)  
  
  
--declare @tblindexName as table   
--(  
-- NoteID UNIQUEIDENTIFIER,  
-- StartDate date,  
-- Index_Name nvarchar(256),  
   
-- NewStartDate date,  
-- NewEndDate date,  
-- RowNo int  
--)   
  
--Delete from @tblindexName  
--INSERT INTO @tblindexName (NoteID,StartDate,Index_Name,NewStartDate,NewEndDate,RowNo)  
  
--Select NoteID,StartDate,IndexName,   
--StartDate as NewStartDate,  
--dateadd(DAY,-1,lead(StartDate,1) OVER(PARTITION BY noteid ORDER BY noteid,Startdate)) AS NewEndDate,  
--ROW_NUMBER() OVER(PARTITION BY noteid ORDER BY noteid,Startdate) AS RNO  
--from(  
-- Select n.noteid,n.crenoteid,rs.IndexNameID ,rs.date as StartDate,lindex.Name as IndexName ,ROW_NUMBER() Over(Partition by noteid order by noteid) rno   
-- from [CORE].RateSpreadSchedule rs    
-- INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
-- LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID   
-- LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID    
-- INNER JOIN     
-- (            
--  Select     
--  (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,    
--  MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve    
--  INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID    
--  INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID    
--  where EventTypeID = 14  
--  and eve.StatusID = 1  
--  and acc.IsDeleted = 0   
--  and n.noteid = @NoteID  
--  GROUP BY n.Account_AccountID,EventTypeID      
-- ) sEvent      
-- ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID   
-- INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
-- INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
-- LEFT JOIN [CORE].[Lookup] Lratetype ON Lratetype.LookupID = n.RateType   
-- where e.StatusID = 1 and acc.isdeleted <> 1  
-- and LValueTypeID.name = 'Index Name'    
-- and n.noteid = @NoteID  
--)a  
----where a.rno = 1  
  
  
  
--declare @min_rno int;  
--declare @max_rno int;   
  
--SET @min_rno = (select min(RowNo) from  @tblindexName)  
--SET @max_rno = (select max(RowNo) from  @tblindexName)  
  
--update @tblindexName set NewStartDate = @Min_IndexDate where RowNo = @min_rno  
--update @tblindexName set NewEndDate = @Max_IndexDate where RowNo = @max_rno  
  
  
  
--declare @tblindex as table   
--(   
-- [Date] date,  
-- [value] decimal(28,7)  
--)   
  
--Delete from @tblindex  
--INSERT INTO @tblindex ([Date],[value])  
  
--select --NoteID,StartDate,Index_Name,NewStartDate,NewEndDate  
--CONVERT(VARCHAR, x.[date],101) as date,  
--Cast(ISNULL(x.[value],0) as decimal(28,7)) as [value]  
--from  @tblindexName t  
--Outer Apply(  
-- Select   
-- CONVERT(VARCHAR, i.[date],101) as date,  
-- Cast(ISNULL(i.[value],0) as decimal(28,7)) as [value],  
-- l.name as IndexName  
-- from core.Indexes i  
-- Inner Join core.indexesmaster im on im.IndexesMasterID = i.IndexesMasterID  
-- left JOin core.lookup l on l.lookupid = i.IndexType  
-- where im.IndexesName = @IndexName  
-- and l.name = t.Index_Name and (i.[date] >= t.NewStartDate and i.[date] <= NewEndDate)  
--)x  
--where x.[date] is not null  
--order by cAST(x.[Date] as Date)  
  
  
  
--IF EXISTS(Select [date] from @tblindex)  
--BEGIN  
-- Select CONVERT(VARCHAR, [date],101) as date,  
-- Cast(ISNULL([value],0) as decimal(28,7)) as [value]  
-- from @tblindex  
-- order by cAST([Date] as Date)  
  
-- insert into @tTableAlias([Name]) values('data.index')  
--END  
--ELSE  
--BEGIN  
-- select   
-- CONVERT(VARCHAR, @min_closingDate,101) as date,  
-- Cast(ISNULL(x.[value],0) as decimal(28,7)) as [value]  
-- from  @tblindexName t  
-- Outer Apply(  
--  Select top 1   
--  CONVERT(VARCHAR, i.[date],101) as date,  
--  Cast(ISNULL(i.[value],0) as decimal(28,7)) as [value],  
--  l.name as IndexName  
--  from core.Indexes i  
--  Inner Join core.indexesmaster im on im.IndexesMasterID = i.IndexesMasterID  
--  left JOin core.lookup l on l.lookupid = i.IndexType  
--  where im.IndexesName = @IndexName  
--  and l.name = t.Index_Name   
--  order by i.[date] desc  
-- )x  
-- where x.[date] is not null  
-- order by cAST(x.[Date] as Date)  
  
-- insert into @tTableAlias([Name]) values('data.index')  
--END  
  
  
---=====New Index Logic============  
declare @tblNote_indexName as table   
(  
 NoteID UNIQUEIDENTIFIER,  
 IndexNameID Int,  
 IndexName nvarchar(100)  
)  
  
Delete from @tblNote_indexName  
INSERT INTO @tblNote_indexName (NoteID,IndexNameID,IndexName)  
  
Select Distinct n.noteid,rs.IndexNameID,lindex.Name as IndexName  
from [CORE].RateSpreadSchedule rs    
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId    
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID   
LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID    
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
LEFT JOIN [CORE].[Lookup] Lratetype ON Lratetype.LookupID = n.RateType   
where e.StatusID = 1 and acc.isdeleted <> 1  
and LValueTypeID.name = 'Index Name'    
and n.noteid = @NoteID  
  
  
declare @tblindex as table   
(   
 [Date] date,  
 [value] decimal(28,7),  
 IndexName nvarchar(100)  
)   
  
Delete from @tblindex  
INSERT INTO @tblindex ([Date],[value],IndexName)  
  
Select   
CONVERT(VARCHAR, i.[date],101) as date,  
Cast(ISNULL(i.[value],0) as decimal(28,7)) as [value],  
--(CASE WHEN l.name = '1M LIBOR' THEN 'Libor' WHEN l.name = '1M USD SOFR' THEN 'SOFR' ELSE l.name END) as IndexName  
ISNULL(l.name,'')  as IndexName  
from core.Indexes i  
Inner Join core.indexesmaster im on im.IndexesMasterID = i.IndexesMasterID  
left JOin core.lookup l on l.lookupid = i.IndexType  
where im.IndexesName = @IndexName  
and i.[date] is not null  
and l.name in (Select IndexName from @tblNote_indexName)  
and i.[date] >= DATEADD(day,-5,@min_closingDate)  
  
order by CAST(i.[Date] as Date)  
  
  
IF EXISTS(Select [date] from @tblindex)  
BEGIN  
 Select CONVERT(VARCHAR, [date],101) as date,  
 Cast(ISNULL([value],0) as decimal(28,7)) as [value],  
 --Replace(indexname,' ','') as indexname  
 indexname  
 from @tblindex  
 order by IndexName,cAST([Date] as Date)  
  
 insert into @tTableAlias([Name]) values('data.index')  
END  
ELSE  
BEGIN  
 select   
 CONVERT(VARCHAR, @min_closingDate,101) as date,  
 Cast(ISNULL(x.[value],0) as decimal(28,7)) as [value],  
 --Replace(t.indexname,' ','') as indexname   
 t.indexname  
 from  @tblNote_indexName t  
 Outer Apply(  
  Select top 1   
  CONVERT(VARCHAR, i.[date],101) as date,  
  Cast(ISNULL(i.[value],0) as decimal(28,7)) as [value],  
  l.name as IndexName  
  from core.Indexes i  
  Inner Join core.indexesmaster im on im.IndexesMasterID = i.IndexesMasterID  
  left JOin core.lookup l on l.lookupid = i.IndexType  
  where im.IndexesName = @IndexName  
  and l.name = t.IndexName   
  order by i.[date] desc  
 )x  
 where x.[date] is not null  
 order by IndexName,cAST(x.[Date] as Date)  
  
 insert into @tTableAlias([Name]) values('data.index')  
END  
---===============================  
  
  
  
  
select CalendarName as HolidayTypeText,CONVERT(VARCHAR, HoliDayDate,101) HoliDayDate   
from App.HoliDays hd   
left join app.HoliDaysMaster hdm on hdm.HolidayMasterID = hd.HoliDayTypeID
where isnull(hd.isSoftHoliday,0)<>3
Order by CalendarName,CAST(HoliDayDate as date)  
insert into @tTableAlias([Name]) values('data.calendars')  
  
  
  
  
---==========================================  
    Declare @ServicerMasterID int;  
 Declare @ServicerModifiedID int;  
 Declare @ServicerManual int;  
  
IF (@UseServicingActual = 'Y')  
BEGIN  
   
  
 SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')   
 SET @ServicerModifiedID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'Modified')   
 SET @ServicerManual = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'ManualTransaction')  
  
 select  note.CRENoteID as CRENoteID,  
 ty.accountname as account,  
 CONVERT(VARCHAR, ntd.RelatedtoModeledPMTDate ,101) dt,  
 note.crenoteid as note,    
  
-- (CASE WHEN (ty.Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) 
--<> 0 ) Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END)   
-- WHEN (ty.Calculated = 3 and AllowCalculationOverride = 3) THEN ntd.CalculatedAmount  
-- WHEN (ty.Calculated = 4 and ntd.ServicerMasterID <> @ServicerManual)   
--  THEN (CASE WHEN TransactionTypeText = 'PrepaymentFeeExcludedFromLevelYield_Temp' THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END) ELSE ntd.CalculatedAmount END)  
-- WHEN (ty.Calculated = 4 and ntd.ServicerMasterID = @ServicerManual) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 )
-- Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END)   
-- ELSE ntd.CalculatedAmount END) as [val],  

(CASE WHEN (ty.Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END)   
WHEN (ty.Calculated = 3 and AllowCalculationOverride = 3) THEN ntd.CalculatedAmount  
WHEN (ty.Calculated = 4 and ntd.ServicerMasterID = @ServicerMasterID) THEN ntd.CalculatedAmount ---M61 Addin
WHEN (ty.Calculated = 4 and ntd.ServicerMasterID <> @ServicerManual) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END)
WHEN (ty.Calculated = 4 and ntd.ServicerMasterID = @ServicerManual) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 )
Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END)   
ELSE ntd.CalculatedAmount END) as [val], 
  
 CAST((CASE WHEN Cash_NonCash = 'Cash' then 1 else 0 end) as bit) as cash,  
 CAST((CASE WHEN ty.Calculated = 3 THEN 1 ELSE 0 END) as bit) as calculated,  
  
 CONVERT(VARCHAR, ntd.TransactionDate ,101) as trans_dt,  
 CONVERT(VARCHAR, ntd.RemittanceDate ,101)  as remit_dt,  
  
 COnvert(VARCHAR,  
 Cast(   
 (Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime), (case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end)  ,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime)   
 WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),(case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end),'PMT Date') THEN RemittanceDate   
 ELSE RelatedtoModeledPMTDate END)    
 as datetime)    
 ,101) as transdtbyrule_dt  
  
 ,ntd.Adjustment as adjustment  
 ,ntd.ActualDelta as actualdelta  
 ,CONVERT(VARCHAR, DATEADD(day,1,note.InitialInterestAccrualEndDate),101) as initialinterestaccrualenddate  
 ,ISNULL(writeoffamount,0) as writeoffamount 
 ,LOWER(sm.servicername)  as sourcetype
  ,ntd.comments as comment
  ,ISNULL(ntd.AddlInterest  ,0) as capitalizedInt
  ,ISNULL(ntd.TotalInterest ,0) as cashInt

 from cre.NoteTransactionDetail ntd  
 inner join CRE.Note note on note.NoteID = ntd.NoteID   
 inner join Core.Account ac on note.Account_AccountID=ac.AccountID  
 left join Core.Lookup l1 on l1.LookupID =ntd.TransactionType   
 left join cre.TransactionTypes ty on ty.TransactionName = ntd.TransactionTypeText  
 left join [Cre].[ServicerMaster] sm on ntd.[ServicerMasterID]=sm.ServicerMasterId
 where note.NoteID  = @NoteID  
 and ac.IsDeleted=0  
  
 and ((Calculated = 3 and IncludeServicingReconciliation = 3)   
   or (Calculated = 3 and AllowCalculationOverride = 3 and ntd.ServicerMasterID = @ServicerModifiedID)   
   or (Calculated = 4))  
  
 order by ntd.RelatedtoModeledPMTDate asc,ntd.TransactionDate asc  
  
 Insert into @tTableAlias([Name]) values('data.notes.actuals')  
END  
ELSE -- --for fetch M61Addin only  
BEGIN  
 --Declare @ServicerMasterID int;  
 --Declare @ServicerModifiedID int;  
 --Declare @ServicerManual int;  
  
 SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')   
 SET @ServicerModifiedID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'Modified')   
 SET @ServicerManual = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'ManualTransaction')  
  
 select  note.CRENoteID as CRENoteID,  
 ty.accountname as account,  
 CONVERT(VARCHAR, ntd.RelatedtoModeledPMTDate ,101) dt,  
 note.crenoteid as note,  
   
 --(CASE WHEN (ty.Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END)   
 --WHEN (ty.Calculated = 3 and AllowCalculationOverride = 3) THEN ntd.CalculatedAmount  
 --WHEN (ty.Calculated = 4 and ServicerMasterID <> @ServicerManual)   
 -- THEN (CASE WHEN TransactionTypeText = 'PrepaymentFeeExcludedFromLevelYield' THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END) ELSE ntd.CalculatedAmount END)  
 --WHEN (ty.Calculated = 4 and ServicerMasterID = @ServicerManual) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END)   
 --ELSE ntd.CalculatedAmount END) as [val],  
  
 (CASE   
 ---WHEN (ty.Calculated = 4 and ntd.ServicerMasterID <> @ServicerManual) THEN ntd.CalculatedAmount   
 ---WHEN (ty.Calculated = 4 and ntd.ServicerMasterID = @ServicerManual) THEN (Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue ELSE ntd.CalculatedAmount END)   
 WHEN (ty.Calculated = 4) THEN ntd.CalculatedAmount  
 ELSE  
  (Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue  
  When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount  
  When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount  
  When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue  
  ELSE ntd.CalculatedAmount END)   
 END)  
 as [val],  
  
 CAST((CASE WHEN Cash_NonCash = 'Cash' then 1 else 0 end) as bit) as cash,  
 CAST((CASE WHEN ty.Calculated = 3 THEN 1 ELSE 0 END) as bit) as calculated,  
  
 CONVERT(VARCHAR, ntd.TransactionDate ,101) as trans_dt,  
 CONVERT(VARCHAR, ntd.RemittanceDate ,101)  as remit_dt,  
  
 COnvert(VARCHAR,  
 Cast(   
 (Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime), (case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end)  ,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime)   
 WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),(case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end),'PMT Date') THEN RemittanceDate   
 ELSE RelatedtoModeledPMTDate END)    
 as datetime)    
 ,101) as transdtbyrule_dt  
  
,ntd.Adjustment as adjustment  
,ntd.ActualDelta as actualdelta  
,CONVERT(VARCHAR, DATEADD(day,1,note.InitialInterestAccrualEndDate),101) as initialinterestaccrualenddate  
,ISNULL(writeoffamount,0) as writeoffamount 
 ,LOWER(sm.servicername)  as sourcetype
 ,ntd.comments as comment
 from cre.NoteTransactionDetail ntd  
 inner join CRE.Note note on note.NoteID = ntd.NoteID   
 inner join Core.Account ac on note.Account_AccountID=ac.AccountID  
 left join Core.Lookup l1 on l1.LookupID =ntd.TransactionType   
 left join cre.TransactionTypes ty on ty.TransactionName = ntd.TransactionTypeText  
 left join [Cre].[ServicerMaster] sm on ntd.[ServicerMasterID]=sm.ServicerMasterId
 where note.NoteID  = @NoteID   
 and ac.IsDeleted=0  
 and ((ty.Calculated = 3 and ty.AllowCalculationOverride = 3 and ntd.ServicerMasterID = @ServicerModifiedID ) or (ty.Calculated = 4))   
 order by ntd.RelatedtoModeledPMTDate asc,ntd.TransactionDate asc  
  
 Insert into @tTableAlias([Name]) values('data.notes.actuals')  
END  
  
--========================================  
  
  
   
Select   n.CRENoteID as CRENoteID  
,CONVERT(VARCHAR, ls.[Date],101) as dt  
,ls.StrippedAmount as val  
,LRuleTypeID.FeeTypeNameText+' '+ 'Strip' as [type]  
,ls.FeeName as feename  
from [CORE].FeeCouponStripReceivable ls  
INNER JOIN [CORE].[Event] e on e.EventID = ls.EventId  
INNER JOIN   
(        
 Select   
 (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
 MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
 INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
 where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FeeCouponStripReceivable')  
 and n.NoteID = @NoteID and acc.IsDeleted = 0  
 GROUP BY n.Account_AccountID,EventTypeID  
) sEvent  
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
left JOIN [CRE].[FeeSchedulesConfig] LRuleTypeID ON LRuleTypeID.FeeTypeNameID = ls.RuleTypeID  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
left JOIN [CRE].[Note] nSource ON nSource.noteid =ls.SourceNoteId  
Where   acc.IsDeleted = 0  
and ls.AnalysisID = @AnalysisID  
Order by n.CRENoteID,ls.[Date]  
  
 insert into @tTableAlias([Name]) values('data.notes.fee_strip_received')  
   
  
  
Update core.calculationrequests set jsonpicktime =getdate() where AccountId = @AccountID and AnalysisID = @AnalysisID  
  
  
   
Select n.crenoteid,e.DealID  
,CONVERT(VARCHAR, e.EffectiveDate,101)  as EffectiveDate_Prepay  
--,CONVERT(VARCHAR, ps.[PrepayDate],101)  as [PrepayDate]  
,CONVERT(VARCHAR, ps.CalcThru,101)  as  CalcThru  
  
,ISNULL(PrepaymentMethod,0) as [PrepaymentMethod]  
,ISNULL(BaseAmountType,0) as BaseAmountType  
,ISNULL(SpreadCalcMethod,0) as [SpreadCalcMethod]  
  
,ISNULL(ps.[GreaterOfSMOrBaseAmtTimeSpread],0) as GreaterOfSMOrBaseAmtTimeSpread  
,ISNULL(ps.HasNoteLevelSMSchedule,0) as HasNoteLevelSMSchedule  --,ISNULL(ps.[IncludeFee] ,0) as [IncludeFee]  

,(CASE when ps.IncludeFeesInCredits = 1 then 'true' else 'false' end) as IncludeFeesInCredits  
from [CORE].prepaySchedule ps  
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID  
inner join cre.note n on n.dealid = e.dealid  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.account_accountid  
where e.StatusID = 1    
and e.dealid = @DealID  
and n.noteid = @NoteID  
ORDER BY n.crenoteid,e.EffectiveDate  
  
insert into @tTableAlias([Name]) values('data.notes.PrepayScheduleDict')  
  
Select n.crenoteid,  
e.DealID  
,CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay  
,CONVERT(VARCHAR, sm.date,101) [Date]  
,sm.Spread as Spread  
,sm.CalcAfterPayoff  
from [CORE].SpreadMaintenanceSchedule sm  
inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID  
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID  
left Join cre.note n on n.noteid = sm.noteid  
inner join core.account acc on acc.accountid = n.account_accountid  
where acc.isdeleted <> 1   
and e.StatusID = 1    
and e.dealid = @DealID  
and n.noteid = @NoteID  
  
and sm.date is not null  
order by e.EffectiveDate,n.crenoteid,sm.date  
  
insert into @tTableAlias([Name]) values('data.notes.SpreadMaintenanceSchedule')  
  
  
  
Select n.crenoteid,  
e.DealID  
,CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay  
,CONVERT(VARCHAR, sm.date,101) [Date]  
,ISNULL(sm.PrepayAdjAmt,0) as PrepayAdjAmt   
,ISNULL(sm.Comment,'') Comment  
from [CORE].PrepayAdjustment sm  
inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID  
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID  
inner join cre.deal d on d.dealid =e.dealid  
left Join cre.note n on n.dealid = d.dealid  
inner join core.account acc on acc.accountid = n.account_accountid  
where acc.isdeleted <> 1   
and e.StatusID = 1    
and e.dealid = @DealID  
and n.noteid = @NoteID  
order by n.crenoteid,e.EffectiveDate,sm.date  
insert into @tTableAlias([Name]) values('data.notes.PrepayAdjustment')  
  
  
Select n.crenoteid,  
e.DealID  
,CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay  
,CONVERT(VARCHAR, sm.date,101) [Date]  
,ISNULL(sm.MinMultAmount,0) as MinMultAmount  
from [CORE].MinMultSchedule sm  
inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID  
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID  
inner join cre.deal d on d.dealid =e.dealid  
left Join cre.note n on n.dealid = d.dealid  
inner join core.account acc on acc.accountid = n.account_accountid  
where acc.isdeleted <> 1   
and e.StatusID = 1    
and sm.IsDeleted <> 1  
and e.dealid = @DealID  
and n.noteid = @NoteID  
order by n.crenoteid,e.EffectiveDate,sm.date  
insert into @tTableAlias([Name]) values('data.notes.MinMultSchedule')  
  
  
Select n.crenoteid,  
e.DealID  
,CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay  
,iSNULL(f.FeeTypeNameText,'') as FeeType  
,ISNULL(sm.FeeCreditOverride,0) as OverrideFeeAmount  
,iSNULL(UseActualFees,0) as UseActualFees  
from [CORE].FeeCredits sm  
inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID  
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID  
inner join cre.deal d on d.dealid =e.dealid  
left Join cre.note n on n.dealid = d.dealid  
inner join core.account acc on acc.accountid = n.account_accountid  
left join [CRE].[FeeSchedulesConfig] f on f.[FeeTypeNameID] = sm.FeeType  
where acc.isdeleted <> 1   
and e.StatusID = 1    
and sm.IsDeleted <> 1  
and iSNULL(UseActualFees,0) <> 1  
and e.dealid = @DealID  
and n.noteid = @NoteID  
order by n.crenoteid,e.EffectiveDate  
insert into @tTableAlias([Name]) values('data.notes.FeeCredits')  
  
  
  
select @DealID as DealID,eff.CRENoteID  
,eff.NoteID  
,CONVERT(VARCHAR,eff.EffectiveDate,101) EffectiveDate  
,CAST(ROUND(ISNULL(x.NoteAdjustedTotalCommitment,0),2) as decimal(28,2)) noteadjustedtotalcommitment  
,CAST(ROUND(ISNULL(x.NoteTotalCommitment,0),2) as decimal(28,2)) totalcmt  from #tNoteEffectiveDates eff  

Outer Apply (  
 Select top 1 dealid,credealid,CRENoteID,Date,NoteAdjustedTotalCommitment,NoteTotalCommitment  
 From(     
  SELECT d.dealid,d.CREDealID  
  ,n.CRENoteID  
  ,Date as Date  
  ,nd.Type as Type  
  ,NoteAdjustedTotalCommitment  
  ,NoteTotalCommitment  
  ,nd.NoteID  
  ,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,  
  nd.Rowno  
  from cre.NoteAdjustedCommitmentMaster nm  
  left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID  
  right join cre.deal d on d.DealID=nm.DealID  
  Right join cre.note n on n.NoteID = nd.NoteID  
  inner join core.account acc on acc.AccountID = n.Account_AccountID  
  where d.IsDeleted<>1 and acc.IsDeleted<>1  
  and n.noteid =@NoteID  
 )a  
 where a.date <= eff.EffectiveDate  
 order by rno  
)x  
order by eff.CRENoteID,eff.EffectiveDate   
insert into @tTableAlias([Name]) values('data.notes.NoteAdjustedCommitment')  
  
-------============================================================  
  
  
  
  
Declare @ScenarioId UNIQUEIDENTIFIER = @Analysis_ID  ---'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
  
  
IF OBJECT_ID('tempdb..#tblTr ') IS NOT NULL               
 DROP TABLE #tblTr  
  
CREATE TABLE #tblTr  
(  
crenoteid nvarchar(256),  
NoteID UNIQUEIDENTIFIER,  
[Date] Date,  
Amount decimal(28,15),  
[Type] nvarchar(256),  
LIBORPercentage decimal(28,15),  
PIKInterestPercentage decimal(28,15),  
SpreadPercentage decimal(28,15),  
FeeName nvarchar(256),  
TransactionDateByRule Date,  
DueDate  Date,  
RemitDate Date,  
TransactionCategory nvarchar(256),  
Comment nvarchar(256),  
FeeTypeName nvarchar(256)  
)  
  
Declare @tblTranType as Table(  
TransType nvarchar(256)  
)  
  
INSERT INTO @tblTranType(TransType)  
Select TransType from(  
 Select [Name] as TransType from core.Lookup where ParentID = 94  
 UNION ALL  
 Select 'InterestPaid' as TransType  
 UNION ALL  
 Select 'FloatInterest' as TransType  
 UNION ALL  
 Select 'PIKInterestPaid' as TransType  
)a  
  
  
INSERT INTO #tblTr(crenoteid,NoteID,Date,Amount,Type,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,FeeName,TransactionDateByRule,DueDate,RemitDate,TransactionCategory,Comment,FeeTypeName)  
  
Select crenoteid,NoteID,Date,Amount,Type,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,FeeName,TransactionDateByRule,DueDate,RemitDate,TransactionCategory,Comment ,FeeTypeName  
From  
(  
 Select n.crenoteid,  
 n.NoteID,   
 (CASE WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(tt.[Type],' ','')) = 1) > 0   
  THEN ISNULL(TransactionDateByRule,tt.[Date])  
  ELSE tt.[Date]  
 END) AS [Date],  
 tt.Amount,  
 tt.Type,   
 /*
 (case   
 when tt.[Type] = 'InterestPaid' then tblTr.LIBORPercentage   
 when tt.[Type] = 'StubInterest' then n.InitialIndexValueOverride --n.StubInterestRateOverride   
 when tt.[Type] in ('PIKInterest','PIKInterestPaid') then tblTr.PIKLiborPercentage    
 else null end) as LIBORPercentage,  
 (case when tt.[Type] = 'PIKInterest' then tblTr.PIKInterestPercentage else null end) as PIKInterestPercentage,  
 (case when tt.[Type] in ('InterestPaid','StubInterest') then tblTr.SpreadPercentage   
  when tt.[Type] in ('PIKInterest','PIKInterestPaid') then tblTr.PIKInterestPercentage   
  else null   
  end  
 ) as SpreadPercentage,  
 */
 tt.IndexValue  as LIBORPercentage, 
 NULL as PIKInterestPercentage,
 tt.SpreadValue as SpreadPercentage,
 FeeName,  
 tt.TransactionDateServicingLog as TransactionDateByRule,  
 tt.[Date] as DueDate,  
 tt.RemitDate as RemitDate,  
 tym.TransactionCategory,  
 tt.comment,  
 tt.FeeTypeName  
 from cre.transactionentry tt  
 Inner join core.account acc on acc.accountid = tt.AccountID     
 Inner join cre.note n on n.account_accountid = acc.accountid  
 /*
 LEFT JOIN  
 (  
  Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage  
  from(  
   select  n.Noteid,te.[Date] ,te.Amount,te.[Type] ValueType  
   from  CRE.TransactionEntry te  
   Inner join core.account acc on acc.accountid = te.AccountID     
	Inner join cre.note n on n.account_accountid = acc.accountid  
   where te.analysisID= @ScenarioId and n.NoteID=@NoteId  and acc.AccounttypeID =  1
   AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')  
  )a  
  PIVOT (  
  SUM(Amount)  
  FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage)  
  ) pvt  
 )tblTr on tblTr.noteid = n.noteid and tblTr.[Date] = tt.[Date]
 */
 --left join cre.note n on n.noteid = tt.noteid  
 left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(tt.[Type])  
 where tt.analysisID= @ScenarioId and n.NoteID=@NoteId  and acc.AccounttypeID =  1
 AND tt.type not in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')   
)a  
  
  
  
Select crenoteid,  
CONVERT(VARCHAR, Date,101) [Date],  
ISNULL(Amount,0) as Amount,  
Type,  
ISNULL(LIBORPercentage,0) as LIBORPercentage,  
ISNULL(LIBORPercentage,0) as PIKInterestPercentage,  
ISNULL(LIBORPercentage,0) as SpreadPercentage,  
ISNULL(FeeName,'') as FeeName,  
ISNULL(FeeTypeName,'') as FeeTypeName  
from #tblTr  
where [Type] not in ('EndingGAAPBookValue','EndingPVGAAPBookValue')  
insert into @tTableAlias([Name]) values('data.notes.cashflow')  
   
  
   
Select noteid  
,CRENoteID  
,CONVERT(VARCHAR, periodenddate,101) as [Date]  
,ISNULL(EndingBalance,0) as EndingBalance  
from(  
 select n.noteid,n.CRENoteID,np.periodenddate,EndingBalance ,ROW_NUMBER() OVER(Partition by n.noteid order by n.noteid,np.periodenddate desc) rno  
 from  cre.NotePeriodicCalc np
    Inner join core.account acc on acc.accountid = np.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid
   and acc.isdeleted <> 1  
   and np.analysisid = @ScenarioId 
 --inner join [CRE].[NotePeriodicCalc] np  
 --on n.noteid = np.noteid and np.analysisid = @ScenarioId  
 --inner join core.account acc on acc.AccountID = n.Account_AccountID  
 where acc.IsDeleted <> 1 and np.periodenddate <= @prepaydate  --cast(getdate() as date)  
 and np.analysisid = @ScenarioId  
 and n.noteid = @NoteId  
)a where rno = 1  
insert into @tTableAlias([Name]) values('data.notes.notebalance')  
  
  
  
Select CRENoteID,[Date],[type],Typetext,Amount,TotalCommitmentAdjustment,TotalCommitment  
From(  
 SELECT n.CRENoteID  
 ,CONVERT(VARCHAR, [Date],101) as [Date]  
 ,ISNULL(nm.Type,0) as [type]  
 ,ISNULL(l.name,'') as Typetext  
 ,ISNULL(nd.Value,0) as Amount  
 ,ISNULL(nd.NoteAdjustedTotalCommitment,0) as TotalCommitmentAdjustment  
 --,ISNULL(NoteAggregatedTotalCommitment,0) as NoteAggregatedTotalCommitment  
 ,ISNULL(NoteTotalCommitment,0) as TotalCommitment  
 ,ROW_NUMBER() Over(Partition by n.noteid,[date] order by n.noteid,[date],nd.Rowno desc) rno  
 from cre.NoteAdjustedCommitmentMaster nm  
 left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID  
 left join core.lookup l on l.LookupID=nm.Type  
 left join cre.note n on n.noteid = nd.noteid  
 WHERE nd.NoteID = @NoteId  
 --order by nd.Rowno  
)a where rno = 1  
insert into @tTableAlias([Name]) values('data.notes.notecommitment')  
  



Declare @tblmat_temp as table(
crenoteid nvarchar(256),
NoteID UNIQUEIDENTIFIER,
[MaturityType] nvarchar(256),
[EffectiveDate] Date,
initmatdt date,
contractmat date
)

INSERT INTO @tblmat_temp(crenoteid,NoteID,[MaturityType],[EffectiveDate],initmatdt,contractmat)

Select Distinct crenoteid,NoteID,[MaturityType],MIN([EffectiveDate]) as [EffectiveDate],[MaturityDate] as initmatdt ,contractmat 
From(  

   Select n.crenoteid,n.NoteID,e.EffectiveStartDate  as [EffectiveDate],  
   lMaturityType.name as [MaturityType],  
   (CASE WHEN e.EffectiveStartDate = n.actualPayoffdate THEN n.actualPayoffdate ELSE mat.MaturityDate END)  as [MaturityDate],      
   lApproved.name as Approved ,
   mat.MaturityDate as contractmat
   from [CORE].Maturity mat    
   INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId    
   Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
   Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved  
   INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
   INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
   where e.StatusID = 1  
   and lMaturityType.name  = @mat_Type  
   and lApproved.name = 'Y'       
   and n.noteid = @NoteID  
  
   UNION ALL  
  
  
   ----------Current maturity-----------------  
   Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved,contractmat  
   from (  
    Select n.crenoteid,n.noteid,e.effectivestartdate,'Current Maturity Date' as [MaturityType],  
    (CASE WHEN e.EffectiveStartDate = n.actualPayoffdate THEN n.actualPayoffdate ELSE mat.MaturityDate END) as [MaturityDate],  
    lApproved.name as Approved, 
	mat.MaturityDate as contractmat,
    ROW_NUMBER() Over(Partition by noteid,effectivestartdate order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno  
    from [CORE].Maturity mat    
    INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId      
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
    Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType  
    Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved   
    where mat.MaturityDate > getdate()  
    and lApproved.name = 'Y'  
    and n.noteid = @NoteID   
    and e.StatusID = 1  
   )a    
   where a.rno = 1  
   and MaturityType = @mat_Type  
  
   UNION ALL  
  
   ---If current maturity is not available on closing------------  
   Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved  ,contractmat
   from (  
    Select n.crenoteid,n.noteid,n.closingdate as effectivestartdate, 'Current Maturity Date' as MaturityType,iSNULL(n.ActualPayoffdate,n.FullyExtendedMaturityDate) as MaturityDate,'Y' as Approved  ,n.FullyExtendedMaturityDate as contractmat
    from cre.Note n   
    inner join core.Account acc on acc.AccountID = n.Account_AccountID  
    where acc.IsDeleted <> 1  
    and n.noteid = @NoteID   
   )a  
   where MaturityType = @mat_Type  
   and NOT EXISTS(  
    Select n.noteid from [CORE].Maturity mat    
    INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId      
    INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
    INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID        
    where mat.Approved= 3  
    and n.ClosingDate = e.EffectiveStartDate  
    and mat.MaturityDate > getdate()  
    and n.noteid = @NoteID   
   )  
  
   ------------------------------------------  
   UNION ALL  
  
   ---Expected Maturity date  
	Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved  ,MaturityDate as contractmat
	from (  
		Select n.crenoteid,n.noteid,n.closingdate as effectivestartdate, 'Expected Maturity Date' as MaturityType	
		,(CASE WHEN @LastFUllPayOffDate is not null THEN @LastFUllPayOffDate
		WHEN (YEAR(n.ExpectedMaturityDate) = YEAR(@LastPyDn_Date) and MONTH(n.ExpectedMaturityDate) = MONTH(@LastPyDn_Date)) THEN @LastPyDn_Date
		ELSE ISNULL(n.ExpectedMaturityDate,n.FullyExtendedMaturityDate) END) as MaturityDate
		,'Y' as Approved  
		from cre.Note n   
		inner join core.Account acc on acc.AccountID = n.Account_AccountID  
		where acc.IsDeleted <> 1  
		and n.noteid = @NoteID  
	)a  
	where MaturityType = @mat_Type  
  
)a  
group by crenoteid,NoteID,[MaturityDate],[MaturityType] ,contractmat


Declare @maxeffdate_l1 date = (Select  MAX([EffectiveDate]) from @tblmat_temp )
Declare @contractmat_l1 date = (Select contractmat from @tblmat_temp where [EffectiveDate] = @maxeffdate_l1)


Select crenoteid,NoteID,CONVERT(VARCHAR, [EffectiveDate],101) as [EffectiveDate],CONVERT(VARCHAR, initmatdt,101) as initmatdt  ,CONVERT(VARCHAR, contractmat,101) as contractmat
From(  
	Select Distinct crenoteid,NoteID,[EffectiveDate],Dateadd(month,ISNULL(@MaturityAdjustmentMonths,0),initmatdt)  as initmatdt ,Dateadd(month,ISNULL(@MaturityAdjustmentMonths,0),contractmat) contractmat
	From(  
		Select  crenoteid,NoteID,[MaturityType],[EffectiveDate],initmatdt,contractmat from @tblmat_temp 
  
		UNION     
  
		Select Distinct crenoteid,NoteID,'ActualPayoffdate' as [MaturityType],n.ActualPayoffdate as [EffectiveDate],n.ActualPayoffdate as initmatdt  ,@contractmat_l1 as contractmat
		from cre.note n  
		inner join core.account acc on acc.accountid = n.account_accountid   
		where acc.isdeleted <> 1  
		and n.ActualPayoffdate is not null  
		and noteid=@NoteID  
	)y
)z  
Order by z.crenoteid,z.[EffectiveDate]  
  
insert into @tTableAlias([Name]) values('data.notes.maturity')  
  
  


----------------------------------------  
--select @accountingclosedate as EffectiveDate  
--,n.noteid,n.CRENoteID  
--,CONVERT(VARCHAR, np.PeriodEndDate,101) as PeriodEndDate  
--,EndingGAAPBookValue as EndingGAAPBV  
--,SLAmortOfDiscountPremium as DiscountPremiumAmort  
--,TotalAmortAccrualForPeriod as AmortofDeferredFees  
--,AccumulatedAmort as AccumulatedAmortofDeferredFees  
--from  cre.note n   
--inner join [CRE].[NotePeriodicCalc] np  on n.noteid = np.noteid and np.analysisid = @ScenarioId  
--inner join core.account acc on acc.AccountID = n.Account_AccountID  
--where acc.IsDeleted <> 1   
--and np.periodenddate <= cast(EOMONTH(DateADD(month,-1,getdate())) as date)  
--and np.analysisid = @ScenarioId  
--and n.noteid = @NoteID  
--and np.[month] is not null  
  
--insert into @tTableAlias([Name]) values('data.notes.noteperiodiccalc')  
  
  
select top 1   
n.crenoteid  
,CONVERT(VARCHAR, @accountingclosedate_EffDate,101) as effectivedate  
,CONVERT(nvarchar(20),nc.[PeriodEndDate],101) as [date]  
,ISNULL(nc.levyld,0.0) as levyld  
,ISNULL(nc.DeferredFeeGAAPBasis,0.0) as gaapbasis  
,ISNULL(nc.DiscountPremiumAccumulatedAmort,0.0) as cum_am_disc  
---,ISNULL(null,0.0) as feeamort  
,ISNULL(AccumulatedAmort,0.0) as cum_am_fee  
,ISNULL(nc.cum_dailypikint,0.0) as cum_dailypikint  
,ISNULL(nc.cum_baladdon_am,0.0) as cum_baladdon_am  
,ISNULL(nc.cum_baladdon_nonam,0.0) as cum_baladdon_nonam  
,ISNULL(nc.cum_dailyint,0.0) as cum_dailyint  
,ISNULL(nc.cum_ddbaladdon,0.0) as cum_ddbaladdon  
,ISNULL(nc.cum_ddintdelta,0.0) as cum_ddintdelta  
,ISNULL(nc.CapitalizedCostAccumulatedAmort,0.0) as cum_am_capcosts  
,ISNULL(nc.EndingBalance,0.0) as endbal  
,ISNULL(nc.initbal,0.0) as initbal  
,ISNULL(nc.cum_fee_levyld,0.0) as cum_fee_levyld  
,ISNULL(nc.period_ddintdelta_shifted,0.0) as period_ddintdelta_shifted  
,ISNULL(nc.intdeltabal,0.0) as intdeltabal  
,ISNULL(nc.cum_exit_fee_excl_lv_yield,0.0) as cum_exit_fee_excl_lv_yield  
  
,CONVERT(nvarchar(20),nc.AccPeriodEnd,101) as periodend  
,CONVERT(nvarchar(20),nc.AccPeriodStart,101) as periodstart  
,CONVERT(nvarchar(20),nc.pmtdtnotadj,101) as pmtdtnotadj  
,CONVERT(nvarchar(20),nc.pmtdt,101) as pmtdt  
,ISNULL(nc.periodpikint,0.0) as periodpikint  
  
,ISNULL(nc.CapitalizedCostLevelYield,0.0) as yld_capcosts    
,ISNULL(nc.CapitalizedCostGAAPBasis,0.0) as bas_capcosts    
--,ISNULL(nc.CapitalizedCostAccrual,0.0) as am_capcosts    
,ISNULL(nc.DiscountPremiumLevelYield,0.0) as yld_disc    
,ISNULL(nc.DiscountPremiumGAAPBasis,0.0) as bas_disc      
--,ISNULL(nc.DiscountPremiumAccrual,0.0) as am_disc        

,ISNULL(CurrentPeriodInterestAccrual   ,0.0)  as curperintaccr
,ISNULL(CurrentPeriodPIKInterestAccrual,0.0)  as curperpikintaccr
,ISNULL(InterestSuspenseAccountBalance * -1 ,0.0)  as intsuspensebal

,ISNULL(CurrentPeriodInterestAccrualPeriodEnddate ,0.0)  as curperintaccrmon
,ISNULL(CurrentPeriodPIKInterestAccrualPeriodEnddate ,0.0)  as curperpikintaccrmon
,ISNULL(cum_unusedfee ,0.0)  as cum_unusedfee  
---,ISNULL(nc.InitialFunding ,0.0)  as initfunding 


--,ISNULL(netpikamountfortheperiod ,0.0)  as netpikamountfortheperiod
--,ISNULL(cashinterest ,0.0)  as cashinterest
--,ISNULL(capitalizedinterest ,0.0)  as capitalizedinterest  
--,ISNULL(PIKBalanceBalloonPayment ,0.0)  as pikballoonsepcomp
,ISNULL(EndingPIKBalanceNotInsideLoanBalance ,0.0)  as pikendbalsepcomp
,ISNULL(CumulativeDailyPIKFromInterest ,0.0)  as cum_daily_pik_from_interest
,ISNULL(CumulativeDailyPIKCompounding ,0.0)  as cum_dailypikcomp
,ISNULL(CumulativeDailyIntoPIK ,0.0)  as cum_dailyintonpik
,ISNULL(BeginningPIKBalanceNotInsideLoanBalance ,0.0)  as pikinitbalsepcomp

from [Core].[Period] p  
Inner Join [Core].[AccountingClosePeriodicArchive] nc on p.[PeriodID] = nc.[PeriodID]  
Inner Join cre.note n on n.noteid = nc.noteid  
Where p.IsDeleted <> 1  
and nc.NoteID = @NoteID  
and p.PeriodID = @PeriodID  
and nc.[month] is not null  
and p.CloseDate = @accountingclosedate  
Order by nc.periodEnddate desc  --p.EndDate desc  
  
insert into @tTableAlias([Name]) values('data.notes.noteperiodiccalc')  


IF(@IncludeProjectedPrincipalWriteoff  = 3)
BEGIN
	select CONVERT(VARCHAR,pm.date,101) EffectiveDate 
	,n.crenoteid
	,CONVERT(nvarchar(20),pm.date,101) as [date]
	,ISNULL(pd.value   ,0.0) as amount
	from [CRE].[WLDealPotentialImpairmentMaster] pm
	left Join [CRE].[WLDealPotentialImpairmentDetail] pd on pm.WLDealPotentialImpairmentMasterID = pd.WLDealPotentialImpairmentMasterID
	Inner JOin cre.note n on n.noteid = pd.noteid
	Inner JOin core.account acc on acc.accountid = n.Account_accountid
	Where acc.Isdeleted <> 1
	and ISNULL(pm.Applied,0) <> 1
	and pd.NoteID= @NoteID
	ORDER by n.CRENoteID,pm.RowNo
	insert into @tTableAlias([Name]) values('data.notes.svrwatchlist')
END 


Select
FF.FunctionNameID,
FF.FunctionGuID,
ISNULL(FF.FunctionNameText,'') as FunctionNameText,
ISNULL(LFunctionTypeID.Name,'') as FunctionTypeText,
ISNULL(LFunctionTypeID.LookupID,0) as FunctionTypeID,
ISNULL(LPaymentFrequencyID.Name,'') as PaymentFrequencyText,
ISNULL(LPaymentFrequencyID.LookupID,0) as PaymentFrequencyID,
ISNULL(LAccrualBasisID.Name,'') as AccrualBasisText, 
ISNULL(LAccrualBasisID.LookupID,0) as AccrualBasisID,
ISNULL(LAccrualStartDateID.Name,'') as AccrualStartDateText, 
ISNULL(LAccrualStartDateID.LookupID,0) as AccrualStartDateID,
ISNULL(LAccrualPeriodID.Name,'') as AccrualPeriodText,
ISNULL(LAccrualPeriodID.LookupID,0) as AccrualPeriodID,
ISNULL(FF.FunctionNameID,0) as LookupID,
ISNULL(FF.FunctionNameText,'') as [Name],
IsUsedInFeeSchedule = Case when exists(select 1 from [CRE].[FeeSchedulesConfig] where FeeFunctionID=FF.FunctionNameID) then 1 else 0 end	
from [CRE].[FeeFunctionsConfig] FF
LEFT JOIN [CORE].[Lookup] LFunctionTypeID ON LFunctionTypeID.LookupID = FF.FunctionTypeID AND LFunctionTypeID.ParentID=84 
LEFT JOIN [CORE].[Lookup] LPaymentFrequencyID ON LPaymentFrequencyID.LookupID = FF.PaymentFrequencyID AND LPaymentFrequencyID.ParentID=85
LEFT JOIN [CORE].[Lookup] LAccrualBasisID ON LAccrualBasisID.LookupID = FF.AccrualBasisID AND LAccrualBasisID.ParentID=86
LEFT JOIN [CORE].[Lookup] LAccrualStartDateID ON LAccrualStartDateID.LookupID = FF.AccrualStartDateID AND LAccrualStartDateID.ParentID=87
LEFT JOIN [CORE].[Lookup] LAccrualPeriodID ON LAccrualPeriodID.LookupID = FF.AccrualPeriodID AND LAccrualPeriodID.ParentID=88
insert into @tTableAlias([Name]) values('data.listfeefunctions')





Select feename,type,frequency,Coverage,Account,[Value],[function]
From(
	Select	
	FS.FeeTypeNameText as feename,
	LFeeNameTransID.Name as [type],
	LFeePaymentFrequencyID.Name as frequency,
	LFeeCoveragePeriodID.Name as Coverage,
	LTotalCommitmentID.Name as totalcmt,
	LUnscheduledPaydownsID.Name as paydown,
	LBalloonPaymentID.Name as balloon,
	LLoanFundingsID.Name as funding,
	LScheduledPrincipalAmortizationPaymentID.Name as schprinpaid,
	LCurrentLoanBalanceID.Name as endbal,
	LInterestPaymentID.Name as periodint,
	LInitialFundingID.name as initfunding,
	LM61AdjustedCommitmentID.name as noteadjustedtotalcommitment,
	LPIKFundingID.name as periodpikfunding,
	LPIKPrincipalPaymentID.name as act_pikprinpaid,
	LUnfundedCommitmentID.name as rem_unfunded_commitment,
	LCurtailmentID.name as curtailment,
	LUpsizeAmountID.name as upsizeamount,
	FF.FunctionNameText as [function]
	from [CRE].[FeeSchedulesConfig] FS
	LEFT JOIN [CORE].[Lookup] LFeePaymentFrequencyID ON LFeePaymentFrequencyID.LookupID = FS.FeePaymentFrequencyID AND LFeePaymentFrequencyID.ParentID=89 
	LEFT JOIN [CORE].[Lookup] LFeeCoveragePeriodID ON LFeeCoveragePeriodID.LookupID = FS.FeeCoveragePeriodID AND LFeeCoveragePeriodID.ParentID=90
	LEFT JOIN [CRE].[FeeFunctionsConfig] FF ON FF.FunctionNameID = FS.FeeFunctionID
	LEFT JOIN [CORE].[Lookup] LTotalCommitmentID ON LTotalCommitmentID.LookupID = FS.TotalCommitmentID AND LTotalCommitmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUnscheduledPaydownsID ON LUnscheduledPaydownsID.LookupID = FS.UnscheduledPaydownsID AND LUnscheduledPaydownsID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LBalloonPaymentID ON LBalloonPaymentID.LookupID = FS.BalloonPaymentID AND LBalloonPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LLoanFundingsID ON LLoanFundingsID.LookupID = FS.LoanFundingsID AND LLoanFundingsID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LScheduledPrincipalAmortizationPaymentID ON LScheduledPrincipalAmortizationPaymentID.LookupID = FS.ScheduledPrincipalAmortizationPaymentID AND LScheduledPrincipalAmortizationPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LCurrentLoanBalanceID ON LCurrentLoanBalanceID.LookupID = FS.CurrentLoanBalanceID AND LCurrentLoanBalanceID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LInterestPaymentID ON LInterestPaymentID.LookupID = FS.InterestPaymentID AND LInterestPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LFeeNameTransID ON LFeeNameTransID.LookupID = FS.FeeNameTransID AND LFeeNameTransID.ParentID=94
	LEFT JOIN [CORE].[Lookup] LInitialFundingID ON LInitialFundingID.LookupID = FS.InitialFundingID AND LInitialFundingID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LM61AdjustedCommitmentID ON LM61AdjustedCommitmentID.LookupID = FS.M61AdjustedCommitmentID AND LM61AdjustedCommitmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LPIKFundingID ON LPIKFundingID.LookupID = FS.PIKFundingID AND LPIKFundingID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LPIKPrincipalPaymentID ON LPIKPrincipalPaymentID.LookupID = FS.PIKPrincipalPaymentID AND LPIKPrincipalPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LCurtailmentID ON LCurtailmentID.LookupID = FS.CurtailmentID AND LCurtailmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUpsizeAmountID ON LUpsizeAmountID.LookupID = FS.UpsizeAmountID AND LUpsizeAmountID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUnfundedCommitmentID ON LUnfundedCommitmentID.LookupID = FS.UnfundedCommitmentID AND LUnfundedCommitmentID.ParentID=91
	
	where ISNULL(IsActive,1)  = 1
)as a
UNPIVOT 
(
	[Value] FOR Account IN (totalcmt,paydown,balloon,funding,schprinpaid,endbal,periodint,initfunding,noteadjustedtotalcommitment,periodpikfunding,act_pikprinpaid,rem_unfunded_commitment,curtailment,upsizeamount)
) as sq_up

where sq_up.[Value] = 'TRUE'
order by sq_up.feename

insert into @tTableAlias([Name]) values('data.config.fee.config')

--===================================================================================  
--JsonTemplate table  
--select [Id],[Key],[Value],[Type],[FileName]   
--from CRE.JsonTemplate jt  
--left join [Core].[AnalysisParameter] ap on ap.JsonTemplateMasterID = jt.JsonTemplateMasterID  
--WHERE [Type] != 'BalanceAware'  
--and ap.AnalysisID = @Analysis_ID  
--insert into @tTableAlias([Name]) values('JsonTemplate')  
  
Declare @BalanceAware bit = 0;  
Declare @CalcType int;  
  
SET @BalanceAware = (Select top 1 ISNULL(BalanceAware,0) BalanceAware from cre.deal d  
inner join cre.note n on n.dealid = d.dealid  
where n.noteid = @NoteID)  
  
  
SET @CalcType = @CalcTypeID;  ---(Select CalcType from Core.CalculationRequests where noteid = @NoteID and AnalysisID = @Analysis_ID )  
  
  
  
Declare @JsonTemplate as table (  
Id int,  
[Key] nvarchar(256),  
[Value] nvarchar(256),  
[Type] nvarchar(256),  
[FileName] nvarchar(256),  
DBFileName nvarchar(256)  
)  
  
  
  
Declare @AnalysisID_Default UNIQUEIDENTIFIER = (Select AnalysisID from [CORE].[Analysis] where [Name] = 'Default')
  
IF EXISTS(Select 1 from [CRE].[DealNoteRuleTypeSetup] where AnalysisID = @Analysis_ID and noteid = @NoteID)  
BEGIN  
 IF(@BalanceAware = 1)  
 BEGIN  
	INSERT INTO @JsonTemplate (Id,[Key],[Value],[Type],[FileName],DBFileName)  
	Select c.RuleTypeMasterID as [Id],LOWER(c.RuleTypeName) as [Key],b.Content as [Value],b.[Type] as [Type],b.FileName as [FileName] ,b.[DBFileName]  
	from [CRE].[AnalysisRuleTypeSetup] a    
	inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID    
	inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID    
	where c.GroupName = 'Asset Calculator'
	and a.AnalysisID in (CASE WHEN (Select COUNT(AnalysisID) from [CRE].[AnalysisRuleTypeSetup] where AnalysisID = @Analysis_ID)= 0 THEN @AnalysisID_Default ELSE @Analysis_ID END )  
 END  
 ELSE  
 BEGIN  
    
  INSERT INTO @JsonTemplate (Id,[Key],[Value],[Type],[FileName],DBFileName)  
  Select Id,[Key],[Value],[Type],[FileName],DBFileName   
  From(  
   Select c.RuleTypeMasterID as [Id],LOWER(c.RuleTypeName) as [Key],b.Content as [Value],b.[Type] as [Type],b.FileName as [FileName] ,b.[DBFileName]  
   from [CRE].[DealNoteRuleTypeSetup] a    
   inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID    
   inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID    
   where a.noteid = @NoteID
   and c.GroupName = 'Asset Calculator'
	and a.AnalysisID in (CASE WHEN (Select COUNT(AnalysisID) from [CRE].[AnalysisRuleTypeSetup] where AnalysisID = @Analysis_ID)= 0 THEN @AnalysisID_Default ELSE @Analysis_ID END )  
  
   UNION  
  
   Select c.RuleTypeMasterID as [Id],LOWER(c.RuleTypeName) as [Key],b.Content as [Value],b.[Type] as [Type],b.FileName as [FileName] ,b.[DBFileName]  
   from [CRE].[AnalysisRuleTypeSetup] a    
   inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID    
   inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID    
   where c.RuleTypeMasterID not in (Select RuleTypeMasterID from [CRE].[DealNoteRuleTypeSetup] where AnalysisID = @Analysis_ID and noteid = @NoteID and RuleTypeDetailID is not null)  
   and a.AnalysisID in (CASE WHEN (Select COUNT(AnalysisID) from [CRE].[AnalysisRuleTypeSetup] where AnalysisID = @Analysis_ID)= 0 THEN @AnalysisID_Default ELSE @Analysis_ID END ) 
   and c.GroupName = 'Asset Calculator'
  )a  
  
 END  
  
END  
ELSE  
BEGIN  
 INSERT INTO @JsonTemplate (Id,[Key],[Value],[Type],[FileName],DBFileName)  
 Select c.RuleTypeMasterID as [Id],LOWER(c.RuleTypeName) as [Key],b.Content as [Value],b.[Type] as [Type],b.FileName as [FileName] ,b.[DBFileName]  
 from [CRE].[AnalysisRuleTypeSetup] a    
 inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID    
 inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID    
 where c.GroupName = 'Asset Calculator'
 and a.AnalysisID in (CASE WHEN (Select COUNT(AnalysisID) from [CRE].[AnalysisRuleTypeSetup] where AnalysisID = @Analysis_ID)= 0 THEN @AnalysisID_Default ELSE @Analysis_ID END ) 
  
END  
  
  
  
Select Id,  
LOWER(   
 CASE WHEN @CalcType = 776 THEN (CASE WHEN [Key] = 'prepay' THEN 'Rules' ELSE [Key] END)  
 ELSE (CASE WHEN [Key] = 'CashFlow' THEN 'Rules' ELSE [Key] END)  
 END  
) [Key],  
[Value],[Type],[FileName],DBFileName   
from @JsonTemplate  
  
insert into @tTableAlias([Name]) values('JsonTemplate')  
  
  
  
  
Select [Type],[Key],Position,DataType,IsActive from [CRE].[JsonFormatCalcV1]  
insert into @tTableAlias([Name]) values('JsonFormat')  
  
--all table alias names  
select [Name] as table_name,GroupName from @tTableAlias order by ID  
  
drop table #tNoteEffectiveDates  
  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

