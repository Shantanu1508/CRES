--[dbo].[usp_GetWFNoteFunding]  'b0e6697b-3534-4c09-be0a-04473401ab93','380490a4-f3dc-458d-891a-85eb9f0ef204'

CREATE PROCEDURE [dbo].[usp_GetWFNoteFunding]  
(
    @UserID UNIQUEIDENTIFIER,
    @DealFundingID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Declare  @FundingSchedule  int  =10;
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
Declare @InActive as nvarchar(256)=(select LookupID from core.lookup where name ='InActive' and ParentID=1);
DECLARE @DealID UNIQUEIDENTIFIER = (select DealID from cre.DealFunding where DealFundingID = @DealFundingID);


Select NoteID,Name,Value,TaxVendorLoanNumber,IsExcludeThirdParty,TotalFundAmountWithExclude,FinancingSourceName,FinancingSourceID,CRENoteID
From(

	Select n.NoteID,ac.Name,ISNULL(value,0) Value,ISNULL(n.TaxVendorLoanNumber,'') TaxVendorLoanNumber 
	,ISNULL(IsExcludeThirdParty,0) as IsExcludeThirdParty,
	SUM (CASE WHEN ISNULL(IsExcludeThirdParty,0) = 0 THEN ISNULL(value,0) ELSE 0 END) OVER (ORDER BY ISNULL(IsExcludeThirdParty,0)) AS TotalFundAmountWithExclude,
	ISNULL((select ISNULL(FinancingSourceName,'') From cre.FinancingSourceMaster where FinancingSourceMasterID=n.FinancingSourceID),'') FinancingSourceName,
	n.FinancingSourceID
	,n.CRENoteID
	,n.InitialFundingAmount
	,n.CreatedDate
	,n.lienposition
	,n.Priority
	,ISNULL(  
		(  
		 Select ISNULL(SUM(ISNULL(FS.Value,0)),0)  
		 from [CORE].FundingSchedule fs  
		 INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId  
		 INNER JOIN  
		 (  
			Select  
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n1.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID  
			from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n1 ON n1.Account_AccountID = eve.AccountID and n1.noteid=n.noteid  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n1.Account_AccountID  
			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')  
			and acc.IsDeleted = 0  
			and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)  
			and n1.dealid = @DealID   
			GROUP BY n1.Account_AccountID,EventTypeID,eve.StatusID  
		   ) sEvent  
   
		 ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID  
   
		 left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID  
		 left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
		 INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID  
		 where sEvent.StatusID = e.StatusID and acc.IsDeleted = 0  
		 and fs.Date = Cast(getdate() AS DATE))    
		 +    
		 ISNULL((select SUM((ISNULL(EndingBalance,0)))  
		 from [CRE].[NotePeriodicCalc] np 
		 Inner join core.account acc on acc.accountid = np.AccountID
		Inner join cre.note n on n.account_accountid = acc.accountid

		 where PeriodEndDate = CAST(getdate() - 1 as Date)
		 and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
		 and n.noteid = n.noteid 
		 and acc.AccounttypeID = 1
		 ) ,0)     
	,0) EstBls
	
	from cre.deal d 
	join cre.Note n on d.DealID=n.DealID join core.Account ac on n.Account_AccountID=ac.AccountID
	left join 
	(
		Select n.noteid,df.DealID DealID
		,acc.Name Name
		,fs.[Date] Date
		,fs.PurposeID
		,fs.Value Value
		,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno
		,n.TaxVendorLoanNumber
		,ISNULL(tblThirdPartyNotes.IsExcludeThirdParty,0) as IsExcludeThirdParty
		,n.CRENoteID
		from 
		[CRE].[DealFunding] df
		left join cre.deal d on d.DealID = df.DealID and d.DEalID=@DealID
		left join [CORE].FundingSchedule fs on df.[Date]=fs.[Date]  and df.purposeid=fs.purposeid and ISNULL(df.DealFundingRowno,0)=ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0))
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN 
					(
						
						Select 
							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
							MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
							from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = @FundingSchedule
							and n.DealID = @DealID
							and eve.StatusID =@Active  
							and acc.IsDeleted = 0
							GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

					) sEvent

		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		left join(
			select n.noteid,1 as IsExcludeThirdParty
			from cre.Note n
			inner join core.Account acc on acc.accountid = n.account_accountid
			left join cre.FinancingSourceMaster l on l.FinancingSourceMasterID = n.FinancingSourceID
			--left join cre.Client c on c.ClientID = n.ClientID
			inner join cre.Deal d on d.dealid = n.DealID
			left join cre.DealFunding df on df.dealid = d.dealid
			where acc.isdeleted <> 1
			and l.IsThirdParty=1
			and df.dealfundingid = @DealFundingID
		)tblThirdPartyNotes on tblThirdPartyNotes.noteid = n.noteid

		where sEvent.StatusID = e.StatusID 
		and isnull(acc.StatusID, @Active)!= @InActive 
		and acc.IsDeleted = 0 and 
		df.DealID =@DealID and d.IsDeleted = 0
		and df.DealFundingID=@DealFundingID
	) fn
	on n.NoteID = fn.noteid
	where d.DealID =@DealID and ac.IsDeleted=0 and ac.StatusID=1
)x

order by ISNULL(x.lienposition,99999), x.Priority ,x.InitialFundingAmount desc,x.Name --, x.CreatedDate desc

	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END



