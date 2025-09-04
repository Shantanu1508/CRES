-- Procedure
-- Procedure
--[dbo].[usp_FilterTransactionReconcil_CashFlow]  '12/1/2024' ,'12/31/2024','','''20-1044''',0,0,'''exitfee''' ,''       
--[dbo].[usp_FilterTransactionReconcil_CashFlow]  '' ,'','','',0,0,''          
        
CREATE PROCEDURE [dbo].[usp_FilterTransactionReconcil_CashFlow]         
@StartDate Date=null,        
@EndDate Date=null,        
@Delta nvarchar(500),        
@CREDealID nvarchar(500),        
@IsReconciled bit=false,        
@IsException bit=false,        
@TransactionType nvarchar(max) ,       
@FinancingSource nvarchar(max)       
AS        
BEGIN        
        
SET NOCOUNT ON;        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
Declare @sql varchar(max)=''        
        
        
set @sql=        
'
Select Transcationid,SplitTransactionid,DateDue,RemittanceDate,CREDealID,DealID,DealName,CRENoteID,NoteID,NoteName,TransactionType,ServicingAmount,CalculatedAmount,Delta,Adjustment,ActualDelta,AddlInterest,TotalInterest,M61Value,ServicerValue,Ignore,OverrideValue,Exception,comments,isRecon,TransactionDate,SourceType,OverrideReason,OverrideReasonText,InterestAdj,DueDateAlreadyReconciled,UpdatedBy,WriteOffAmount,FinancingSource
From(
	Select Transcationid,SplitTransactionid,DateDue,RemittanceDate,CREDealID,DealID,DealName,CRENoteID,NoteID,NoteName,TransactionType,ServicingAmount,SUM(CalculatedAmount) as CalculatedAmount,SUM(Delta) as Delta,Adjustment,ActualDelta,AddlInterest,TotalInterest,M61Value,ServicerValue,Ignore,OverrideValue,Exception,comments,isRecon,TransactionDate,SourceType,OverrideReason,OverrideReasonText,InterestAdj,DueDateAlreadyReconciled,UpdatedBy,WriteOffAmount,FinancingSource
	From(
		select         
		null as Transcationid,        
		null as SplitTransactionid,        
		tr.Date as [DateDue],        
		tr.Remitdate as RemittanceDate,          
		d.CREDealID,        
		d.DealID,        
		d.DealName,        
		n.CRENoteID,        
		n.NoteID,        
		acc.Name as NoteName,        
		REPLACE(REPLACE(REPLACE(tr.[type],''ExitFeeStripReceivable'',''ExitFee''),''ExitFeeExcludedFromLevelYield'',''ExitFee''),''ExitFeeStrippingExcldfromLevelYield'',''ExitFee'')  as TransactionType,         
		null as ServicingAmount,        
		Round(tr.Amount,2) as CalculatedAmount,        
		Round((ISNULL(null,0)-ISNULL(tr.Amount,0)),2) as Delta,        
		null as Adjustment,        
		null as ActualDelta,        
		null as AddlInterest,        
		null as TotalInterest,        
		CAST(0 as bit) as M61Value ,        
		CAST(0 as bit) as ServicerValue,        
		CAST(0 as bit) as Ignore,        
		null as OverrideValue,        
		null as Exception,        
		null as comments,        
		1 as isRecon,        
		tr.date as TransactionDate,        
		''ManualCashFlowRecon'' as SourceType,        
		null as OverrideReason,        
		null as OverrideReasonText,        
		null as InterestAdj,        
		''No'' as [DueDateAlreadyReconciled],        
		 null as  UpdatedBy,
		 null as WriteOffAmount,
		 fm.FinancingSourceName as  FinancingSource
		from cre.TransactionEntry tr        
		 Inner join core.account acc on acc.accountid = tr.AccountID
		 Inner join cre.note n on n.account_accountid = acc.accountid       
		 left join cre.Deal d on d.DealID=n.DealID       
		 left join cre.FinancingSourceMaster fm on fm.FinancingSourceMasterID = n.financingsourceid   
		 Left Join(
			Select  noteid,RelatedtoModeledPMTDate as DueDate,[TransactionTypetext] 
			from cre.notetransactiondetail where Servicermasterid = 8
		)nt on nt.noteid = n.noteid and nt.DueDate = tr.date and nt.[TransactionTypetext] = tr.[Type]
		Where acc.isdeleted <> 1         
		and tr.AnalysisID = ''c10f3372-0fc2-4861-a9f5-148f1f80804f''        
		and (tr.[type] in (''AdditionalFeesExcludedFromLevelYield'',''ExitFeeExcludedFromLevelYield'',''ExitFeeStripReceivable'',''ExitFeeStrippingExcldfromLevelYield'',''ExtensionFeeExcludedFromLevelYield'',''FloatInterest'',''InterestPaid'',''ManagementFee'',''OriginationFeeIncludedInLevelYield'',''OtherFeeExcludedFromLevelYield'',''PIKInterestPaid'',''PrepaymentFeeExcludedFromLevelYield'',''PurchasedInterest'',''StubInterest'',''UnusedFeeExcludedFromLevelYield'')  OR (tr.[type] =''FundingOrRepayment'' and tr.Amount>0))   
		and tr.Remitdate is null   
		--and n.actualpayoffdate is null
		and Round((tr.Amount),2)<>0
		and nt.noteid is null
'   
       
        
if(@CREDealID<>'')        
BEGIN        
 set @sql= @sql + ' and  d.CREDealID in (' + @CREDealID + ') '        
END        
     
        
if(@StartDate<>'' and @EndDate<>'')        
BEGIN        
 set @sql= @sql +' and isnull(tr.Date,''1900-01-02'') between ''' + CAST(@StartDate  AS VARCHAR(100))   + ''' and ''' + CAST(@EndDate AS   VARCHAR(100))  +''' '        
END      


if(@TransactionType<>'' )          
BEGIN     
	IF(@TransactionType = '''ExitFeeExcludedFromLevelYield''' OR @TransactionType = '''ExitFeeStrippingExcldfromLevelYield''' OR @TransactionType = '''ExitFee''')  
	BEGIN  
		set @sql= @sql + ' and  (tr.Type =''ExitFeeExcludedFromLevelYield'' OR tr.Type = ''ExitFeeStrippingExcldfromLevelYield'' OR tr.Type =''ExitFeeStripReceivable'' )'   
	END  	
	ELSE  
	BEGIN  
		set @sql= @sql + ' and tr.Type in (' + @TransactionType + ') '      
	END  
END  


if(@FinancingSource<>'' )        
BEGIN        
 set @sql= @sql + ' and  fm.FinancingSourceMasterID in (' + @FinancingSource + ')'        
END       

Declare @Orderby nvarchar(MAX) = N'
	)z
	Group By Transcationid,SplitTransactionid,DateDue,RemittanceDate,CREDealID,DealID,DealName,CRENoteID,NoteID,NoteName,TransactionType,ServicingAmount,Adjustment,ActualDelta,AddlInterest,TotalInterest,M61Value,ServicerValue,Ignore,OverrideValue,Exception,comments,isRecon,TransactionDate,SourceType,OverrideReason,OverrideReasonText,InterestAdj,DueDateAlreadyReconciled,UpdatedBy,WriteOffAmount,FinancingSource
)y
order by CREDealID,CRENoteID,TransactionType,DateDue'



Declare @FinalQuery nvarchar(max) ;
set @FinalQuery = @sql +   @Orderby      


print (@FinalQuery);        
EXEC (@FinalQuery);        



SET TRANSACTION ISOLATION LEVEL READ COMMITTED        
END 