-- Procedure

Create Procedure dbo.usp_InsertLiabilityFundingSchedule_FromFile
as 
BEGIN



------Equity LiabilityFundingSchedule
Truncate table CRE.LiabilityFundingSchedule

INSERT into CRE.LiabilityFundingSchedule (
LiabilityNoteAccountID
,TransactionDate
,TransactionAmount
,Applied
,Comments
,AssetAccountID
,RowNo
,CreatedBy
,CreatedDate
,UpdatedBy
,UpdatedDate
,[Description]
,TransactionTypes
,AccountID)

select
lmapp.LiabilityNoteAccountId as LiabilityNoteAccountID
,[Transaction Date]
,[Transaction Amount]
,1 as [Status]
,eq.Comments
,n.account_accountid as AssetAccountID
,1 as RowNo
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE() 
,[Description]
,ty.transactionname
,ln.LiabilityTypeID 

From [dbo].[EquityCapitalTransactions] eq
left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
left Join cre.transactiontypes ty on ty.transactionname= eq.Comments

where ln.LiabilityTypeID = (Select e.accountid from cre.equity e inner join core.account acc on acc.accountid = e.accountid where acc.name = 'ACORE Credit Partners II')


--375==============================


--WF REPO

INSERT into CRE.LiabilityFundingSchedule (
LiabilityNoteAccountID
,TransactionDate
,TransactionAmount
,Applied
,Comments
,AssetAccountID
,RowNo
,CreatedBy
,CreatedDate
,UpdatedBy
,UpdatedDate
,[Description]
,TransactionTypes
,AccountID)

select
lmapp.LiabilityNoteAccountId as LiabilityNoteAccountID
,[Transaction Date]
,[Transaction Amount]
,1 as [Status]
,eq.Comments
,n.account_accountid as AssetAccountID
,1 as RowNo
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE() 
,[Description]
,ty.transactionname
,ln.LiabilityTypeID 
From [dbo].[DebtDrawsPaydowns] eq
left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
left Join cre.transactiontypes ty on ty.transactionname= eq.Comments
where [Liability  Name] <> 'Cap One 2022-01'
and [Liability  Name] = 'WF Repo'
and ln.LiabilityTypeID = (Select e.accountid from cre.debt e inner join core.account acc on acc.accountid = e.accountid where acc.name = 'WF Repo')


--375


----MS Repo

--select * from CRE.LiabilityFundingSchedule

INSERT into CRE.LiabilityFundingSchedule (
LiabilityNoteAccountID
,TransactionDate
,TransactionAmount
,Applied
,Comments
,AssetAccountID
,RowNo
,CreatedBy
,CreatedDate
,UpdatedBy
,UpdatedDate
,[Description]
,TransactionTypes
,AccountID)

select
lmapp.LiabilityNoteAccountId as LiabilityNoteAccountID
,[Transaction Date]
,[Transaction Amount]
,1 as [Status]
,eq.Comments
,n.account_accountid as AssetAccountID
,1 as RowNo
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE() 
,[Description]
,ty.transactionname
,ln.LiabilityTypeID 
From [dbo].[DebtDrawsPaydowns] eq
left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
left Join cre.transactiontypes ty on ty.transactionname= eq.Comments
where [Liability  Name] <> 'Cap One 2022-01'
and [Liability  Name] = 'MS Repo'
and ln.LiabilityTypeID = (Select e.accountid from cre.debt e inner join core.account acc on acc.accountid = e.accountid where acc.name = 'MS Repo')


--375

----Subline


--select * from CRE.LiabilityFundingSchedule

INSERT into CRE.LiabilityFundingSchedule (
LiabilityNoteAccountID
,TransactionDate
,TransactionAmount
,Applied
,Comments
,AssetAccountID
,RowNo
,CreatedBy
,CreatedDate
,UpdatedBy
,UpdatedDate
,[Description]
,TransactionTypes
,AccountID)

select
lmapp.LiabilityNoteAccountId as LiabilityNoteAccountID
,[Transaction Date]
,[Transaction Amount]
,1 as [Status]
,eq.Comments
,n.account_accountid as AssetAccountID
,1 as RowNo
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE()
,'B0E6697B-3534-4C09-BE0A-04473401AB93'
,GETDATE() 
,[Description]
,ty.transactionname
,ln.LiabilityTypeID 
From [dbo].[DebtDrawsPaydowns] eq
left join cre.note n on n.crenoteid = CAST(eq.crenoteid as nvarchar(256))
left join [CRE].[LiabilityNoteAssetMapping]  lmapp on lmapp.AssetAccountId = n.account_accountid
left join cre.liabilityNote ln on ln.AccountID = lmapp.LiabilityNoteAccountId
left Join cre.transactiontypes ty on ty.transactionname= eq.Comments
where [Liability  Name] = 'Cap One 2022-01'
and ln.LiabilityTypeID = (Select e.accountid from cre.debt e inner join core.account acc on acc.accountid = e.accountid where acc.name = 'Cap One 2022-01')


--375


---================================================

Update CRE.LiabilityFundingSchedule set Applied = 1 where  TransactionDate <= '06/05/2024'
delete from CRE.LiabilityFundingSchedule where  TransactionDate > '06/05/2024'



update [CRE].[LiabilityFundingSchedule] set [CRE].[LiabilityFundingSchedule].Accountid = a.accountid
From(
select lfs.LiabilityFundingScheduleGUID,lfs.LiabilityNoteAccountID,ln.liabilitytypeid as accountid
from CRE.LiabilityFundingSchedule lfs
left join CRE.LiabilityNote ln on ln.accountid = lfs.LiabilityNoteAccountID
)a
where [CRE].[LiabilityFundingSchedule].LiabilityFundingScheduleGUID = a.LiabilityFundingScheduleGUID


---============LiabilityFundingScheduleAggregate====================================


truncate table CRE.LiabilityFundingScheduleAggregate

 declare @TableTypeLiabilityFundingScheduleAggregate [dbo].[TableTypeLiabilityFundingScheduleAggregate]  
 
 Insert into @TableTypeLiabilityFundingScheduleAggregate(LiabilityFundingScheduleAggregateID,[AccountID],TransactionDate,TransactionAmount,TransactionTypes,Applied,Comments,EndingBalance)  


 Select LiabilityFundingScheduleAggregateID
 ,[AccountID]
 ,TransactionDate
 ,TransactionAmount
 ,TransactionTypes
 ,Applied
 ,Comments
,ROUND(SUM(ISNULL(a.TransactionAmount,0)) OVER(PARTITION BY [AccountID] ORDER BY [AccountID],TransactionDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),0) AS AccumaltedEndingBalance

 from
 (
Select 0 as LiabilityFundingScheduleAggregateID
,ln.liabilitytypeid as [AccountID]
,TransactionDate
,sum(TransactionAmount) as TransactionAmount
,lfs.TransactionTypes as TransactionTypes
,lfs.Applied as Applied
,Comments
From CRE.LiabilityFundingSchedule lfs
Inner Join cre.liabilitynote ln on ln.accountid = lfs.LiabilityNoteAccountID
--left join cre.transactiontypes ty on ty.TransactionTypesID = lfs.TransactionTypesID
group by ln.liabilitytypeid,TransactionDate,lfs.TransactionTypes,lfs.Applied,Comments
)a


EXEC [dbo].[usp_InsertUpdateLiabilityFundingScheduleAggregate]  @TableTypeLiabilityFundingScheduleAggregate,'B0E6697B-3534-4C09-BE0A-04473401AB93'




Update [CRE].LiabilityFundingSchedule set [CRE].LiabilityFundingSchedule.EndingBalance = a.AccumaltedEndingBalance_new
From(
	Select LiabilityFundingScheduleID,
	--ROUND(SUM(ISNULL(TransactionAmount,0)) OVER(PARTITION BY [AccountID],LiabilityNoteAccountID,TransactionDate ORDER BY [AccountID],LiabilityNoteAccountID ),2) AS AccumaltedEndingBalance_new
	ROUND(SUM(ISNULL(TransactionAmount,0)) OVER(PARTITION BY AccountID ORDER BY AccountID,TransactionDate ),2) AS AccumaltedEndingBalance_new
	from  [CRE].LiabilityFundingSchedule --where accountid = '5A948E47-EB12-4DCC-B673-457FBA6FF7A4'
)a
where [CRE].LiabilityFundingSchedule.LiabilityFundingScheduleID = a.LiabilityFundingScheduleID


---================================================


END