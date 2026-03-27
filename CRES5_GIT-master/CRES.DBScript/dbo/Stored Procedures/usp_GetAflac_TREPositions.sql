-- Procedure
-- Procedure  
 --   [dbo].[usp_GetAflac_TREPositions]  '{"Date":"09/8/2023"}' 
  
  
CREATE Procedure [dbo].[usp_GetAflac_TREPositions]  
(  
  @JsonReportParamters NVARCHAR(MAX)=null  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 /*--read paramter from the json  
 DECLARE @SheetName NVARCHAR(256),  
   @SheetJsonParamters NVARCHAR(MAX),  
   @SheetJsonParamtersRoot NVARCHAR(MAX),  
   @Client_ID NVARCHAR(10),@SOURCE NVARCHAR(10)  
   
 Select @SheetName=SheetName From App.ReportFileSheet where ReportFileSheetID=2  
   
 SELECT @SheetJsonParamters=[value]  
    FROM OPENJSON (@JsonReportParamters,'$.Root') where [key]=@SheetName  
 print @SheetJsonParamters  
 IF (@SheetJsonParamters IS NOT NULL)  
 BEGIN  
     select @Client_ID=value from OPENJSON(@SheetJsonParamters) where [key]='CLIENT_ID'  
     select @SOURCE=value from OPENJSON(@SheetJsonParamters) where [key]='SOURCE'  
 END  
 --  
 */  
 --US Eastern time zone  
-- declare @TimeZoneName nvarchar(256)='US Eastern Standard Time'  
--  declare @currentdatetime datetime = [dbo].[ufn_GetTimeByTimeZoneName](getdate(),@TimeZoneName)

-------------=====================================-------------------------
If(OBJECT_ID('tempdb..#tempReadJsonData') Is Not Null)
		Drop Table #tempReadJsonData
	
	CREATE TABLE #tempReadJsonData(Date date)
	INSERT INTO #tempReadJsonData (Date)
	SELECT * FROM OPENJSON(@JsonReportParamters)  WITH (Date Date '$.Date');

	declare @currentdatetime datetime	
	SET @currentdatetime = (Select date from #tempReadJsonData);
----------------===============================---------------------------------------

Declare @ServicerMasterID int;
Declare @ServicerModifiedID int;
Declare @ServicerManual int;

SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')	
SET @ServicerModifiedID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'Modified')	
SET @ServicerManual = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'ManualTransaction')

If(OBJECT_ID('tempdb..#tblNPC') Is Not Null)
	Drop Table #tblNPC
	

CREATE TABLE #tblNPC(
crenoteid	nvarchar(256),
noteid	UNIQUEIDENTIFIER,
PeriodEndDate	Date,
EndingBalance	decimal(28,15),
DueDate	Date,
RemitDate	Date,
Amount	decimal(28,15),
SP_DueDate	decimal(28,15),
SP_remitDate	decimal(28,15),
Reporting_EndingBalance	decimal(28,15)
)

INSERT into #tblNPC (crenoteid,noteid,PeriodEndDate,EndingBalance,DueDate,RemitDate,Amount,SP_DueDate,SP_remitDate,Reporting_EndingBalance)
Select a.crenoteid,a.noteid,a.PeriodEndDAte,a.EndingBalance ,a.DueDate,a.RemitDate,a.Amount,a.SP_DueDate,a.SP_remitDate,(a.EndingBalance + a.SP_remitDate) as Reporting_EndingBalance  ----(a.EndingBalance + a.SP_DueDate - a.SP_remitDate)
From(
	Select  n.crenoteid,n.noteid,PeriodEndDAte,EndingBalance ,tblntd.DueDate,tblntd.RemitDate,tblntd.Amount,ISNULL(tblntd.Amount,0) as SP_DueDate,
	(CASE WHEN PeriodEndDAte < tblntd.RemitDate THEN tblntd.Amount Else 0 end) SP_remitDate
	from cre.noteperiodiccalc nc
	inner join cre.note n on n.Account_accountid = nc.accountid
	Outer Apply(
		Select ntd.noteid,RelatedtoModeledPMTDate as DueDate,RemittanceDate as RemitDate,
		(CASE WHEN (ty.Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
		WHEN (ty.Calculated = 3 and AllowCalculationOverride = 3) THEN ntd.CalculatedAmount
		WHEN (ty.Calculated = 4 and ServicerMasterID <> @ServicerManual) THEN ntd.CalculatedAmount	
		WHEN (ty.Calculated = 4 and ServicerMasterID = @ServicerManual) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
		ELSE ntd.CalculatedAmount END) as Amount

		from cre.notetransactiondetail ntd
		inner join cre.note n on n.noteid = ntd.noteid
		left join cre.TransactionTypes ty on ty.TransactionName = ntd.TransactionTypeText
		where ntd.transactiontypetext = 'ScheduledPrincipalPaid'
		and RelatedtoModeledPMTDate <= nc.PeriodEndDate and RemittanceDate >= nc.PeriodEndDate
		and n.Account_accountid = nc.Accountid
	)tblntd

	where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
	and PeriodEndDAte <= CAST(@currentdatetime as date)  
	and EndingBalance is not null  
	and EndingBalance>=1  
	
	and nc.accountid in (
		Select n.Account_accountid 
		From cre.Note n
		inner join core.account acc on acc.accountid = n.account_accountid  
		left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID  
		where acc.IsDeleted <> 1  
		and ISNUMERIC(n.crenoteid) = 1   
		and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  
		and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
	)
	---and nc.noteid = 'F8209738-F2BF-49D0-B051-C79B92183C19'  --n.noteid  
	  
)a
order by a.crenoteid,a.PeriodEndDAte 





----------------===============================---------------------------------------

Select   
(CASE WHEN fs.FinancingSourceName = 'TRE ACR Portfolio' THEN 'JPDACRTRE' WHEN fs.FinancingSourceName = 'TRE ACR Series II Portfolio' THEN 'JPDACRTRE2' ELSE 'USDACRTRE' END) as [Portfolio Name],  ---PORTFOLIO, 
'ACR' + FORMAT(CAST(n.crenoteid as int),'D6') as [Client ID],  
 lcurrency.name as Currency, 
  CONVERT(varchar, @currentdatetime,110) as [Position Date],
(CASE WHEN n.InitialFundingAMount = 0.01 THEN FORMAT(ISNULL(nc.Reporting_EndingBalance,0) - ISNULL(n.InitialFundingAMount,0),'#,0.00') 
ELSE FORMAT(ISNULL(nc.Reporting_EndingBalance,0),'#,0.00') 
END
)as [Position Current Par], ---POS_CUR_PAR,   
FORMAT(adj.TotalCurrentAdjustedCommitment,'#,0.00') as [Position Face]


 --b.[Value] as MKT_PRICE,  
 --'ACR' as SOURCE,  
 --'LOAN' as CLIENT_SEC_TYPE,  
 --null as BOOK_TYPE,  
 --null as BOOK_PRICE,  
 --null as BOOK_FX_RATE,  
 --null as BOOK_VALUE,  
 --null as BOOK_DATE,  
 --null as BOOK_TYPE_2,  
 --null as BOOK_PRICE_2,  
 --null as BOOK_VALUE_2,  
 --null as BOOK_DATE_2,  
 --null as BOOK_TYPE_3,  
 --null as BOOK_PRICE_3,  
 --null as BOOK_VALUE_3,  
 --null as BOOK_DATE_3,  
 --null as BOOK_YIELD,  
 --null as BOOK_YIELD_2,  
 --null as BOOK_YIELD_3,  
 --NULLIF(lstrategy.Name,'None') as STRATEGY  

 From cre.Note n  
 inner join core.account acc on acc.accountid = n.account_accountid  
 left join core.lookup lcurrency on lcurrency.lookupid = ISNULL(acc.BaseCurrencyID,187) and ParentID = 29  
 left join core.lookup lstrategy on lstrategy.LookupID = n.StrategyCode  
 left join cre.FinancingSourcemaster fs on fs.FinancingSourcemasterID = n.FinancingSourceID  
 left join   
 (  
 --Select CAST(noteid as nvarchar(256)) NoteID,TotalCurrentAdjustedCommitment   
 --from dw.UwNoteBI   
 --where noteid in (Select crenoteid from cre.note where ISNUMERIC(crenoteid) = 1)  
	Select CRENoteID,NoteAdjustedTotalCommitment as TotalCurrentAdjustedCommitment,NoteTotalCommitment
	From(			
		SELECT d.CREDealID
		,n.CRENoteID
		,Date as Date
		,nd.Type as Type
		,NoteAdjustedTotalCommitment
		,NoteTotalCommitment
		,nd.NoteID
		,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,
		nd.Rowno,
		tblntd.RemitDate
		from cre.NoteAdjustedCommitmentMaster nm
		left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
		right join cre.deal d on d.DealID=nm.DealID
		Right join cre.note n on n.NoteID = nd.NoteID
		inner join core.account acc on acc.AccountID = n.Account_AccountID

		Outer Apply(
			Select ntd.noteid,RelatedtoModeledPMTDate as DueDate,RemittanceDate as RemitDate
			from cre.notetransactiondetail ntd
			inner join cre.note n on n.noteid = ntd.noteid
			where ntd.transactiontypetext = 'ScheduledPrincipalPaid'
			and n.noteid = nd.noteid
			and ntd.RelatedtoModeledPMTDate = nm.date
		)tblntd

		where d.IsDeleted<>1 and acc.IsDeleted<>1
		and ISNUMERIC(n.crenoteid) = 1
		and isnull(tblntd.RemitDate,nm.date) <= Cast(@currentdatetime as date)		
		
	)a
	where rno =  1

 ) adj  on adj.CRENoteID =  n.CRENoteID  
 Outer Apply(  
	  --Select top 1 noteid,PeriodEndDAte,EndingBalance from cre.noteperiodiccalc where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  
	  --and PeriodEndDAte <= CAST(@currentdatetime as date)  
	  --and EndingBalance is not null  
	  --and EndingBalance>=1  
	  --and noteid = n.noteid  
	  --order by PeriodEndDAte desc 
  
	  Select top 1 noteid,PeriodEndDate,EndingBalance ,Reporting_EndingBalance
	  from #tblNPC where PeriodEndDAte <= CAST(@currentdatetime as date)  
	  and EndingBalance is not null  
	  and EndingBalance>=1  
	  and noteid = n.noteid  
	  order by PeriodEndDAte desc 
 )nc   
 left join (  
 Select Noteid,Date,Value  
  From(  
   Select na.Noteid,na.Date,na.Value ,Row_number() over(Partition by na.Noteid order by na.date desc) as rno  
   from [CRE].[NoteAttributesbyDate] na  
   inner join cre.TransactionTypes ty on ty.TransactionTypesID = na.ValueTypeID  
   where ty.TransactionName = 'MarketPrice'  
   and cast(na.Date as date) <=cast(@currentdatetime as date)  
  )a where rno =  1) b  
    on b.Noteid=n.crenoteid  
 where acc.IsDeleted <> 1  
 and ISNUMERIC(n.crenoteid) = 1   
 and fs.FinancingSourceName in ('AFLAC US','TRE ACR Portfolio','TRE ACR Series II Portfolio')  
and (n.ActualPayOffDate is null OR n.ActualPayOffDate >= Cast(@currentdatetime as date))
 and nc.EndingBalance is not null  
 and nc.EndingBalance >= 1  
 --and (('ACR' + FORMAT(CAST(n.crenoteid as int),'D6')=@Client_ID and @Client_ID IS NOT NULL) OR @Client_ID IS NULL)  
 order by CAST(n.crenoteid as int)  
  
  
  
  
END  