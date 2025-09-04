
--[dbo].[usp_GetTranscationForReconciliationPaging] null, 1,50,0
--[dbo].[usp_GetTranscationForReconciliationPaging] 'b0e6697b-3534-4c09-be0a-04473401ab93', 1,50,0

Create PROCEDURE [dbo].[usp_GetTranscationForReconciliationPaging] 
(
	@UserID varchar(50),
	@PgeIndex INT,
    @PageSize INT,
	@totalCount INT OUTPUT 
)
AS
BEGIN
if (@UserId is null)
Begin
print 'ShowALL Transaction'
   SELECT @totalCount = COUNT(Transcationid) FROM cre.TranscationReconciliation where PostedDate  is null and Deleted=0 ;

	select	
		tr.Transcationid,
		tr.SplitTransactionid,
		tr.[DateDue],
		tr.RemittanceDate,
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
			Round(ISNULL(tr.AddlInterest,0),2) as AddlInterest,
			Round(ISNULL(tr.TotalInterest,0),2) as TotalInterest,
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
			tr.InterestAdj,
			z.LastAccountingCloseDate,
			case when tr.DueDateAlreadyReconciled=1 then 'Yes'
			when isnull(tr.DueDateAlreadyReconciled,0)=0 then 'No'
			End as 'DueDateAlreadyReconciled',
			tr.UpdatedBy,
			u.FirstName + ' ' + u.LastName as  UpdatedByName,
			tr.WriteOffAmount,
			fm.FinancingSourceName as  FinancingSource
	 from cre.TranscationReconciliation tr	
	left join cre.note n on n.NoteID=tr.NoteID
	left join cre.Deal d on d.DealID=n.DealID	
	 left join cre.FinancingSourceMaster fm on fm.FinancingSourceMasterID = n.financingsourceid      
	inner join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=tr.ServcerMasterID	
	 INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
	  Left Join Core.Lookup lk on tr.OverrideReason=lk.LookupID
	 Left join app.[user] u on  tr.UpdatedBy=u.UserID 
	  Left Join (
		Select noteid,LastAccountingCloseDate from(
			Select 
			d.DealID,n.noteid,p.CloseDate as LastAccountingCloseDate	
			,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
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
	)z on tr.noteid = z.NoteID
	where tr.PostedDate  is null and Deleted=0
	order by tr.M61Value desc,
			tr.ServicerValue desc,
			tr.Ignore desc,
			isnull(tr.OverrideValue,0) desc,d.CREDealID,n.CRENoteID,tr.TransactionType,tr.[DateDue]
			  OFFSET (@PgeIndex -1)*@PageSize ROWS
			  FETCH NEXT @PageSize ROWS ONLY;
END
ELSE
Begin

 SELECT @totalCount = COUNT(Transcationid) FROM cre.TranscationReconciliation where PostedDate  is null and Deleted=0 and CreatedBy=@UserId ;

	select	
		tr.Transcationid,
		tr.SplitTransactionid,
		tr.[DateDue],
		tr.RemittanceDate,
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
			Round(ISNULL(tr.AddlInterest,0),2) as AddlInterest,
			Round(ISNULL(tr.TotalInterest,0),2) as TotalInterest,
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
			tr.InterestAdj,
			z.LastAccountingCloseDate ,
			case when tr.DueDateAlreadyReconciled=1 then 'Yes'
			when isnull(tr.DueDateAlreadyReconciled,0)=0 then 'No'
			End as 'DueDateAlreadyReconciled',
			tr.CreatedBy,
			u.FirstName + ' ' + u.LastName as  UpdatedByName,
			tr.WriteOffAmount,
			fm.FinancingSourceName as  FinancingSource
	 from cre.TranscationReconciliation tr	
	left join cre.note n on n.NoteID=tr.NoteID
	left join cre.Deal d on d.DealID=n.DealID	
	left join cre.FinancingSourceMaster fm on fm.FinancingSourceMasterID = n.financingsourceid 
	inner join [CRE].[ServicerMaster] sm on sm.ServicerMasterID=tr.ServcerMasterID	
	 INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
	  Left Join Core.Lookup lk on tr.OverrideReason=lk.LookupID
	  Left join app.[user] u on  tr.UpdatedBy=u.UserID 
	  Left Join (
		Select noteid,LastAccountingCloseDate from(
			Select 
			d.DealID,n.noteid,p.CloseDate as LastAccountingCloseDate	
			,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
			from cre.deal d
			Inner join cre.note n on n.dealid = d.dealid
			Left join (
				Select dealid,CloseDate,updateddate
				from CORE.[Period]
				where CloseDate is not null
			)p on d.dealid = p.dealid 
			Where d.IsDeleted <> 1
		)a
		where a.rno = 1
	)z on tr.noteid = z.NoteID
	where tr.PostedDate  is null and Deleted=0
	and tr.UpdatedBy=@UserId
	order by tr.M61Value desc,
			tr.ServicerValue desc,
			tr.Ignore desc,
			isnull(tr.OverrideValue,0) desc,d.CREDealID,n.CRENoteID,tr.TransactionType,tr.[DateDue]
			  OFFSET (@PgeIndex -1)*@PageSize ROWS
			  FETCH NEXT @PageSize ROWS ONLY;
END

END


--select * from  cre.TranscationReconciliation where  Deleted=0

--select * from [CRE].[ServicerMaster]

--select * from IO.L_Remittance


