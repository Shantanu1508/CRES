

CREATE VIEW [dbo].vTransactionAuditLog AS

select Distinct  
fl.OrigFileName as FileName
,ta.RemitDate as RemitDate
,ta.transactionType as TransactionType
,isNull(tblTotalrecord.TotalRecord,0) as TotalRecords
,isNull(tbltotalIgnored.TotalIgnored,0) as TotalIgnored
,isNull(tblTotalimported.Totalimported,0) as TotalImported
,isNull(tblManualIgnored.ManualIgnored,0) as Manual_Ignored

,isNull(tblsysIgnored.sysIgnored,0) as sys_Ignored
,isNull(tblReconci.TotalReconciledCnt,0) as TotalReconciled_Cnt

,isNull(tblignorePydn.ignorePydn,0) as PaydownIgnored
,isNull(tblignorepik.ignorepik,0) as PIKPrincipalPaidIgnored
,tblrec.TotalRemitAmount as TotalRemitAmount

,tblrec.ReconciledAmount as ReconciledAmount
,tblrec.Adjustment as AmountAdjustment

--,fl.createdby as Uploadedby
--,tblrec.Reconciledby as Reconciledby
,u_up.FirstName + ' '+ u_up.LastName as Uploadedby
,u_rec.FirstName + ' '+ u_rec.LastName as Reconciledby

,fl.createddate as UploadedDate 
,tblrec.ReconciledDate as ReconciledDate
,sm.ServicerName
,ta.BatchLogID
,ta.IsDeleted
from cre.transactionauditlog ta
inner join cre.servicermaster sm on sm.servicermasterid = ta.servicermasterid
inner join [IO].[FileBatchLog] fl on fl.BatchLogID = ta.BatchLogID
left Join (
	Select BatchLogID,TransactionType,RemitDate ,count(*) as TotalRecord
	from cre.transactionauditlog 
	--where BatchLogID = @BatchLogID
	group by BatchLogID,TransactionType,RemitDate
)tblTotalrecord on tblTotalrecord.BatchLogID = ta.BatchLogID and tblTotalrecord.TransactionType = ta.TransactionType and tblTotalrecord.RemitDate = ta.RemitDate
left Join (
	Select ta.BatchLogID,ta.TransactionType,ta.RemitDate,Count(ta.TransactionType) as TotalIgnored	
	from cre.TransactionAuditLog ta
	where [Status]  in ('Note does not exist.','Remit Amount is Zero.','Data already Reconcilled.','Transaction type does not exists in fee transaction master.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Ignore Paydowns','Ignore Pik Principal Paid')  ---,'Ignore Paydowns Plus Pik Principal Paid')
	--and  ta.BatchLogID = @BatchLogID
	group by BatchLogID,TransactionType,RemitDate
)tbltotalIgnored on tbltotalIgnored.BatchLogID = ta.BatchLogID and tbltotalIgnored.TransactionType = ta.TransactionType and tbltotalIgnored.RemitDate = ta.RemitDate

left Join (
	Select ta.BatchLogID,ta.TransactionType,ta.RemitDate,Count(ta.TransactionType) as Totalimported
	from cre.TransactionAuditLog ta
	where [Status] not in ('Note does not exist.','Remit Amount is Zero.','Data already Reconcilled.','Transaction type does not exists in fee transaction master.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Ignore Paydowns','Ignore Pik Principal Paid')  ---,'Ignore Paydowns Plus Pik Principal Paid')
	--and  ta.BatchLogID = @BatchLogID
	group by BatchLogID,TransactionType,RemitDate
)tblTotalimported on tblTotalimported.BatchLogID = ta.BatchLogID and tblTotalimported.TransactionType = ta.TransactionType and tblTotalimported.RemitDate = ta.RemitDate
left Join (
	Select ta.BatchLogID,ta.TransactionType,ta.RemitDate,Count(ta.TransactionType) as ignorePydn
	from cre.TransactionAuditLog ta
	where [Status] = 'Ignore Paydowns'
	--and  ta.BatchLogID = @BatchLogID
	group by BatchLogID,TransactionType,RemitDate

)tblignorePydn on tblignorePydn.BatchLogID = ta.BatchLogID and tblignorePydn.TransactionType = ta.TransactionType and tblignorePydn.RemitDate = ta.RemitDate

left Join (
	Select ta.BatchLogID,ta.TransactionType,ta.RemitDate,Count(ta.TransactionType) as ignorepik
	from cre.TransactionAuditLog ta
	where [Status] = 'Ignore Pik Principal Paid'
	--and  ta.BatchLogID = @BatchLogID
	group by BatchLogID,TransactionType,RemitDate

)tblignorepik on tblignorepik.BatchLogID = ta.BatchLogID and tblignorepik.TransactionType = ta.TransactionType and tblignorepik.RemitDate = ta.RemitDate

left Join (
	
	Select BatchLogID,TransactionType,RemittanceDate as RemitDate,SUM(TotalRemitAmount) as TotalRemitAmount
	,SUM(ReconciledAmount) as ReconciledAmount
	,SUM(Adjustment) as Adjustment
	,Reconciledby
	,ReconciledDate
	from(
		Select BatchLogID,TransactionType,RemittanceDate, ServicingAmount as TotalRemitAmount,
		(Case When tr.OverrideValue > 0 then tr.OverrideValue 
		When (isnull(tr.M61Value,0) = 0 and isnull(tr.ServicerValue,0) = 0 ) then tr.OverrideValue 
		When (isnull(tr.M61Value,0) <> 0 ) Then tr.CalculatedAmount	
		When (isnull(tr.ServicerValue,0) <>0 ) Then tr.ServicingAmount	
		When (isnull(tr.Ignore,0) <> 0 ) Then tr.OverrideValue	
		ELSE tr.CalculatedAmount END) as ReconciledAmount,
		Adjustment
		,tr.Createdby as Reconciledby
		,CAST(tr.CreatedDate as date) as ReconciledDate
		from cre.TranscationReconciliation tr
		where tr.posteddate is not null 
		--and batchlogid = @BatchLogID
		and tr.Transcationid not in (Select SplitTransactionid from cre.TranscationReconciliation where SplitTransactionid is not null)

	)a
	group by BatchLogID,TransactionType,RemittanceDate,Reconciledby,ReconciledDate	


)tblrec on tblrec.BatchLogID = ta.BatchLogID and tblrec.TransactionType = ta.TransactionType and tblrec.RemitDate = ta.RemitDate

left Join (	
	Select BatchLogID,RemittanceDate as RemitDate,TransactionType,Count(TransactionType) as ManualIgnored	
	from cre.TranscationReconciliation 
	where Ignore = 1
	group by BatchLogID,TransactionType,RemittanceDate
)tblManualIgnored on tblManualIgnored.BatchLogID = ta.BatchLogID and tblManualIgnored.TransactionType = ta.TransactionType and tblManualIgnored.RemitDate = ta.RemitDate

left Join (	
	Select BatchLogID,RemittanceDate as RemitDate,TransactionType,Count(TransactionType) as sysIgnored	
	from cre.TranscationReconciliation 
	where (ISNULL(M61Value,0) =0 and ISNULL(ServicerValue,0) = 0 and ISNULL(Ignore,0) = 0 and OverrideValue is null and Deleted = 1)
	and Transcationid not in (Select SplitTransactionid from cre.TranscationReconciliation where SplitTransactionid is not null)
	group by BatchLogID,TransactionType,RemittanceDate
)tblsysIgnored on tblsysIgnored.BatchLogID = ta.BatchLogID and tblsysIgnored.TransactionType = ta.TransactionType and tblsysIgnored.RemitDate = ta.RemitDate

Left JOin app.[user] u_up on u_up.userid = fl.createdby
Left JOin app.[user] u_rec on u_rec.userid = tblrec.Reconciledby

left Join (	
	Select BatchLogID,RemittanceDate as RemitDate,TransactionType,COUNT(BatchLogID) as TotalReconciledCnt
	from cre.TranscationReconciliation 
	where posteddate is not null and Ignore <> 1  
	group by BatchLogID,TransactionType,RemittanceDate
)tblReconci on tblReconci.BatchLogID = ta.BatchLogID and tblReconci.TransactionType = ta.TransactionType and tblReconci.RemitDate = ta.RemitDate
 

--left Join (	
--	Select BatchLogID,TransactionType,RemittanceDate as RemitDate, SUM(ServicingAmount) as TotalRemitAmount
--	from cre.TranscationReconciliation tr
----	where BatchLogID in (2153)
--	group by BatchLogID,TransactionType,RemittanceDate
--)tblTotRemit on tblTotRemit.BatchLogID = ta.BatchLogID and tblTotRemit.TransactionType = ta.TransactionType and tblTotRemit.RemitDate = ta.RemitDate
 


where ta.IsDeleted <> 1
---fl.BatchLogID = @BatchLogID

