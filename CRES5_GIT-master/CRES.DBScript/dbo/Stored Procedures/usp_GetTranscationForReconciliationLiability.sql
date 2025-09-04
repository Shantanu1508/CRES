
--[dbo].[usp_GetTranscationForReconciliationLiability] null, 1,50,0
--[dbo].[usp_GetTranscationForReconciliationLiability] 'b0e6697b-3534-4c09-be0a-04473401ab93', 1,50,0

Create PROCEDURE [dbo].[usp_GetTranscationForReconciliationLiability] 
(
	@UserID varchar(50),
	@PgeIndex INT,
    @PageSize INT,
	@totalCount INT OUTPUT 
)
AS
BEGIN
   SELECT @totalCount = COUNT(Transactionid) FROM cre.TransactionReconciliationLiability where PostedDate  is null and Deleted=0 and ((CreatedBy=@UserId and @UserId is not null) or @UserId is null)
	select Transactionid,
	SplitTransactionid,
	[DateDue],
	RemittanceDate,
	LiabilityName,
	CREDealID,
	DealID,
	DealName,
	CRENoteID,
	NoteID,
	NoteName,
	TransactionType,	
	ServicingAmount,
	CalculatedAmount,
	Delta,
	Adjustment,
	ActualDelta,
	M61Value,
	ServicerValue,
	Ignore,
	OverrideValue,
	Exception,
	comments,			
	isRecon,			
	TransactionDate,
	SourceType,
	OverrideReason,
	OverrideReasonText,
	LastAccountingCloseDate,
	DueDateAlreadyReconciled,
	UpdatedBy,
	UpdatedByName,
	WriteOffAmount,
	FinancingSource
			from
			(
		    select	distinct
			tr.Transactionid,
			tr.SplitTransactionid,
			tr.[DateDue],
			tr.RemittanceDate,
			acl.Name as LiabilityName,
			d.CREDealID,
			d.DealID,
			d.DealName,
			n.CRENoteID,
			n.NoteID,
			ac.Name as NoteName,
			tr.TransactionType,	
			--tr.ServicingAmount as ServicingAmount,
			--tr.CalculatedAmount as CalculatedAmount,
			Round(tr.ServicingAmount,2) as ServicingAmount,
			Round(tr.CalculatedAmount,2) as CalculatedAmount,
			--tr.Delta,
			Case
			--When ISNULL(tr.OverrideValue,0)=0  Then Round(tr.Delta,2)
			When ISNULL(tr.OverrideValue,0)=0  Then Round((ISNULL(tr.ServicingAmount,0)-ISNULL(tr.CalculatedAmount,0)),2)
			When ISNULL(tr.OverrideValue,0)<>0  Then Round(tr.OverrideValue-tr.CalculatedAmount,2)
			END as Delta,
			Round(ISNULL(tr.Adjustment,0),2) as Adjustment,
			Round(ISNULL(tr.ActualDelta,tr.Delta),2) as ActualDelta,
			
			
			ISNULL(tr.M61Value,0) as M61Value,
			ISNULL(tr.ServicerValue,0) as ServicerValue,
			ISNULL(tr.Ignore,0) as Ignore,
			tr.OverrideValue,
			tr.Exception,
			tr.comments,			
			case when tr.PostedDate is null then 1
			when tr.PostedDate is not null then 0
			END  as isRecon,			
			tr.TransactionDate,
			sm.ServicerName as 'SourceType',
			tr.OverrideReason,
			lk.name OverrideReasonText,
			
			z.LastAccountingCloseDate,
			case when tr.DueDateAlreadyReconciled=1 then 'Yes'
			when isnull(tr.DueDateAlreadyReconciled,0)=0 then 'No'
			End as 'DueDateAlreadyReconciled',
			tr.UpdatedBy,
			u.FirstName + ' ' + u.LastName as  UpdatedByName,
			tr.WriteOffAmount,
			fm.FinancingSourceName as  FinancingSource
			from cre.TransactionReconciliationLiability tr	
			left join cre.note n on n.Account_AccountID=tr.NoteAccountID
			INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			INNER JOIN core.Account acl ON acl.AccountID = tr.LiabilityAccountID
			left join cre.Deal d on d.AccountID=tr.DealAccountID	
			left join cre.FinancingSourceMaster fm on fm.FinancingSourceMasterID = n.financingsourceid      
			inner join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=tr.ServcerMasterID	
	 
			Left Join Core.Lookup lk on tr.OverrideReason=lk.LookupID
			Left join app.[user] u on  tr.UpdatedBy=u.UserID 
			Left Join (
					Select NoteAccountID,LastAccountingCloseDate from(
							Select 
							d.DealID,n.Account_AccountID as NoteAccountID,p.CloseDate as LastAccountingCloseDate	
							,ROW_NUMBER() OVER (Partition BY d.dealid,n.Account_AccountID order by d.dealid,n.Account_AccountID,p.updateddate desc) rno
							from cre.deal d
							Inner join cre.note n on n.dealid = d.dealid
							Left join (
								Select dealid,CloseDate,updateddate
								from CORE.[Period]
								where isdeleted <> 1 and CloseDate is not null
							)p on d.dealid = p.dealid 
							Where d.IsDeleted <> 1
							)a
							where a.rno = 1
					)z on tr.NoteAccountID = z.NoteAccountID
			where tr.PostedDate  is null and Deleted=0
			and ((tr.CreatedBy=@UserId and @UserId is not null) or @UserId is null)
			and tr.TransactionMode='Deal Level'
		union

		select	distinct
		tr.Transactionid,
		tr.SplitTransactionid,
		tr.[DateDue],
		tr.RemittanceDate,
		acl.Name as LiabilityName,
		null as CREDealID,
		null as DealID,
		null as DealName,
		null as CRENoteID,
		null as NoteID,
		null as NoteName,
		tr.TransactionType,	
		Round(tr.ServicingAmount,2) as ServicingAmount,
		Round(tr.CalculatedAmount,2) as CalculatedAmount,
		--tr.Delta,
		Case
		--When ISNULL(tr.OverrideValue,0)=0  Then Round(tr.Delta,2)
		When ISNULL(tr.OverrideValue,0)=0  Then Round((ISNULL(tr.ServicingAmount,0)-ISNULL(tr.CalculatedAmount,0)),2)
		When ISNULL(tr.OverrideValue,0)<>0  Then Round(tr.OverrideValue-tr.CalculatedAmount,2)
		END as Delta,
		Round(ISNULL(tr.Adjustment,0),2) as Adjustment,
		Round(ISNULL(tr.ActualDelta,tr.Delta),2) as ActualDelta,
			
			
		ISNULL(tr.M61Value,0) as M61Value,
		ISNULL(tr.ServicerValue,0) as ServicerValue,
		ISNULL(tr.Ignore,0) as Ignore,
		tr.OverrideValue,
		tr.Exception,
		tr.comments,			
		case when tr.PostedDate is null then 1
		when tr.PostedDate is not null then 0
		END  as isRecon,			
		tr.TransactionDate,
		sm.ServicerName as 'SourceType',
		tr.OverrideReason,
		lk.name OverrideReasonText,
			
		null as LastAccountingCloseDate,
		case when tr.DueDateAlreadyReconciled=1 then 'Yes'
		when isnull(tr.DueDateAlreadyReconciled,0)=0 then 'No'
		End as 'DueDateAlreadyReconciled',
		tr.UpdatedBy,
		u.FirstName + ' ' + u.LastName as  UpdatedByName,
		tr.WriteOffAmount,
		null as  FinancingSource
		from cre.TransactionReconciliationLiability tr	
		inner join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=tr.ServcerMasterID	
		INNER JOIN core.Account ac ON ac.AccountID = tr.LiabilityAccountID
		INNER JOIN core.Account acl ON acl.AccountID = tr.LiabilityAccountID
		Left Join Core.Lookup lk on tr.OverrideReason=lk.LookupID
		Left join app.[user] u on  tr.UpdatedBy=u.UserID 
		where tr.PostedDate  is null and Deleted=0
		and ((tr.CreatedBy=@UserId and @UserId is not null) or @UserId is null)
		and tr.TransactionMode='Portfolio'
	) tbl
	order by M61Value desc,
	ServicerValue desc,
	Ignore desc,
	isnull(OverrideValue,0) desc,CREDealID,CRENoteID,TransactionType,[DateDue]
	OFFSET (@PgeIndex -1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;

END




