-- Procedure
-- Procedure

--drop PROCEDURE cre.GetTransactionAuditLog

CREATE PROCEDURE CRE.usp_GetTransactionAuditLog

AS
BEGIN

select distinct OrigFileName,
BlobFileName,
UploadedBY,
 Sum(nn.TotalNumberofRecords) as TotalNumberofRecords,
 Sum(nn.NumberofRecordsimported) as NumberofRecordsimported,
 Sum(nn.NumberofRecordsIgnored) as NumberofRecordsIgnored,
  Sum(nn.NumberofRecordsPaydownIgnored) as NumberofRecordsPaydownIgnored,
 nn.createdDate	as CreatedDate,
 BatchLogID 
from 
(
	Select 
	ta.BatchLogID as BatchLogID,
	fb.BlobFileName as BlobFileName,
	fb.OrigFileName as OrigFileName ,	
	us.FirstName + ' ' + us.LastName  as UploadedBY,
	Count(TransactionType) as TotalNumberofRecords,	
	0 as NumberofRecordsimported,
	0 as NumberofRecordsIgnored	,
	0 as NumberofRecordsPaydownIgnored	,
	fb.createdDate	
	from 
	cre.TransactionAuditLog ta
	inner join [IO].[FileBatchLog] fb on fb.BatchLogID=ta.BatchLogID
	inner join app.[user] us on fb.createdby=us.userID
	where isnull(ta.IsDeleted,0)<>1
	group by fb.OrigFileName,fb.createdDate,ta.BatchLogID,fb.BlobFileName,us.FirstName, us.LastName 
	--having Status not in ('Remit Amount is Zero.','Data already Reconcilled.')
	

	UNION 

	Select 
	ta.BatchLogID as BatchLogID,
	fb.BlobFileName as BlobFileName,
	fb.OrigFileName as OrigFileName,
	us.FirstName + ' ' + us.LastName  as UploadedBY,	
	0 as TotalNumberofRecords,	
	Count(TransactionType) as  NumberofRecordsimported,
	0 as NumberofRecordsIgnored	,
	0 as NumberofRecordsPaydownIgnored	,
	fb.createdDate	
	from 
	cre.TransactionAuditLog ta
	inner join [IO].[FileBatchLog] fb on fb.BatchLogID=ta.BatchLogID
	inner join app.[user] us on fb.createdby=us.userID
	where isnull(ta.IsDeleted,0)<>1
	and Status not in ('Note does not exist.','Remit Amount is Zero.','Data already Reconcilled.','Transaction type does not exists in fee transaction master.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Ignore Paydowns','Ignore Pik Principal Paid' )  ---,'Ignore Paydowns Plus Pik Principal Paid')
	group by fb.OrigFileName,fb.createdDate,ta.BatchLogID,fb.BlobFileName,us.FirstName, us.LastName
	--having 

	UNION 

	Select 
	ta.BatchLogID as BatchLogID,
	fb.BlobFileName as BlobFileName,
	fb.OrigFileName  as OrigFileName,
	us.FirstName + ' ' + us.LastName  as UploadedBY,	
	0 as TotalNumberofRecords,	
	0 as  NumberofRecordsimported,
	Count(TransactionType) as NumberofRecordsIgnored	,
	0 as NumberofRecordsPaydownIgnored	,
	fb.createdDate	
	from 
	cre.TransactionAuditLog ta
	inner join [IO].[FileBatchLog] fb on fb.BatchLogID=ta.BatchLogID
	inner join app.[user] us on fb.createdby=us.userID
	where isnull(ta.IsDeleted,0)<>1
	and Status  in ('Note does not exist.','Remit Amount is Zero.','Data already Reconcilled.','Transaction type does not exists in fee transaction master.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Ignore Pik Principal Paid')  ---,'Ignore Paydowns Plus Pik Principal Paid')
	group by fb.OrigFileName,fb.createdDate,ta.BatchLogID,fb.BlobFileName,us.FirstName , us.LastName 
	--having Status  in ('Note does not exist.','Remit Amount is Zero.','Data already Reconcilled.','Transaction type does not exists in fee transaction master.','Zero Interest','Note Enable M61 Calculations is N.','Duplicate Record','Transaction type does not configured in transaction master.','Ignore Paydowns')

	UNION 

	Select 
	ta.BatchLogID as BatchLogID,
	fb.BlobFileName as BlobFileName,
	fb.OrigFileName  as OrigFileName,
	us.FirstName + ' ' + us.LastName  as UploadedBY,	
	0 as TotalNumberofRecords,	
	0 as  NumberofRecordsimported,
	0 as NumberofRecordsIgnored	,
	Count(TransactionType) as NumberofRecordsPaydownIgnored	,
	fb.createdDate	
	from 
	cre.TransactionAuditLog ta
	inner join [IO].[FileBatchLog] fb on fb.BatchLogID=ta.BatchLogID
	inner join app.[user] us on fb.createdby=us.userID
	where isnull(ta.IsDeleted,0)<>1
	and Status  in ('Ignore Paydowns')  ---,'Ignore Paydowns Plus Pik Principal Paid')
	group by fb.OrigFileName,fb.createdDate,ta.BatchLogID,fb.BlobFileName,us.FirstName , us.LastName 
) nn
group by OrigFileName,createdDate,BlobFileName,UploadedBY,BatchLogID
order by BatchLogID desc
	END



	--select *  from cre.TransactionAuditLog




