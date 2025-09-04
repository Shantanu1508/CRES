--[usp_GetInvoiceSplit] 'DBB7AD37-EC3E-4C3D-AEB6-44EC2A333346',558,600,''
CREATE PROCEDURE [dbo].[usp_GetInvoiceSplit]
(
    @DealIDOrCREDealID Varchar(500),
	@InvoiceTypeID int,
	@FeeAmount decimal(28,15),
	@UserID Varchar(500)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	declare @sumAdjustedTotalCommitment decimal(28,15),
	@sumPercentage decimal(28,15),@penny decimal(28,15)=0
	if (len(@DealIDOrCREDealID)<>36)
	 BEGIN
	    Select @DealIDOrCREDealID=DealID from Cre.Deal where CREDealID=@DealIDOrCREDealID
	 END
	select @sumAdjustedTotalCommitment = sum(AdjustedTotalCommitment) from cre.note np  join  cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID=np.financingSourceID 
    join core.Account act on np.Account_AccountID=act.AccountID
	where dealid=@DealIDOrCREDealID --and fs.IsThirdParty=0
	and act.IsDeleted=0 and isnull(act.statusID,1)=1

	IF (@sumAdjustedTotalCommitment=0)
	BEGIN
	     select top 1 DealName,format(@FeeAmount,'#0.00') SplitAmount,QBAccountNo,QBItemName from 
			(
			select DealName,qb.QBAccountNo,qb.QBItemName
			 from
			(
			select d.credealid,d.dealname,f.financingSourcename,f.FinancingSourceMasterID,f.IsThirdParty

			from cre.deal d join cre.note n on d.dealid=n.dealid 
			join core.account ac on ac.AccountID=n.Account_AccountID
			left join cre.FinancingSourceMaster f on f.FinancingSourceMasterID=n.financingSourceID
			where isnull(d.isdeleted,0)=0 and isnull(ac.statusID,1)=1
			and ac.IsDeleted=0
			group by f.financingSourcename,FinancingSourceMasterID,d.dealid,d.credealid,d.dealname,n.dealid,f.IsThirdParty
			having d.DealID=@DealIDOrCREDealID
			--and f.IsThirdParty=0
			) tbl 

			join cre.QBAccountFinancingSourceMapping qb on qb.FinancingSourceID = tbl.FinancingSourceMasterID
			where IsThirdParty=0
			and qb.InvoiceTypeID=@InvoiceTypeID
			) tblmain group by QBAccountNo,QBItemName,DealName
			having QBAccountNo is not null
	END
	ELSE
	BEGIN

select @sumPercentage =sum((AdjustedTotalCommitment/@sumAdjustedTotalCommitment)*100)
 from
(
select d.credealid,d.dealname, sum(n.AdjustedTotalCommitment) AdjustedTotalCommitment,f.financingSourcename,f.IsThirdParty

from cre.deal d join cre.note n on d.dealid=n.dealid 
join core.account ac on ac.AccountID=n.Account_AccountID
left join cre.FinancingSourceMaster f on f.FinancingSourceMasterID=n.financingSourceID
where isnull(d.isdeleted,0)=0 and isnull(ac.statusID,1)=1
and ac.IsDeleted=0
group by f.financingSourcename,d.dealid,d.credealid,d.dealname,n.dealid,f.IsThirdParty
having d.DealID=@DealIDOrCREDealID
--and f.IsThirdParty=0
) tb  where IsThirdParty=0


declare @temp as Table
(
ID int identity(1,1) ,
DealName nvarchar(256),
SplitAmount decimal(28,15),
QBAccountNo nvarchar(256),
QBItemName nvarchar(256)
)

insert into @temp
select DealName,format(sum(FeeAmount),'#0.00') SplitAmount,QBAccountNo,QBItemName from 
(
select DealName,financingSourceName,FinancingSourceMasterID,format((AdjustedTotalCommitment/@sumAdjustedTotalCommitment)*100,'#0.00') as Percentage,
((AdjustedTotalCommitment/@sumAdjustedTotalCommitment)*100 * @FeeAmount)/@sumPercentage as FeeAmount
--format((format((AdjustedTotalCommitment/@sumAdjustedTotalCommitment)*100,'#0.00') * @FeeAmount)/@sumPercentage,'#0.00') as FeeAmount
,qb.QBAccountNo,qb.QBItemName

 from
(
select d.credealid,d.dealname, sum(n.AdjustedTotalCommitment) AdjustedTotalCommitment,f.financingSourcename,f.FinancingSourceMasterID,f.IsThirdParty

from cre.deal d join cre.note n on d.dealid=n.dealid 
join core.account ac on ac.AccountID=n.Account_AccountID
left join cre.FinancingSourceMaster f on f.FinancingSourceMasterID=n.financingSourceID
where isnull(d.isdeleted,0)=0 and isnull(ac.statusID,1)=1
and ac.IsDeleted=0
group by f.financingSourcename,FinancingSourceMasterID,d.dealid,d.credealid,d.dealname,n.dealid,f.IsThirdParty
having d.DealID=@DealIDOrCREDealID
--and f.IsThirdParty=0
) tbl 

join cre.QBAccountFinancingSourceMapping qb on qb.FinancingSourceID = tbl.FinancingSourceMasterID
where IsThirdParty=0
and qb.InvoiceTypeID=@InvoiceTypeID
) tblmain group by QBAccountNo,QBItemName,DealName
having QBAccountNo is not null and sum(FeeAmount)<>0

--adjust penny to the large value
select @penny= @FeeAmount-sum(SplitAmount) from @temp
update @temp set SplitAmount=SplitAmount+@penny where ID=
(
select top 1 ID from @temp order by SplitAmount desc
)

select DealName,
format(SplitAmount,'#0.00') as SplitAmount,
QBAccountNo,
QBItemName from @temp

----for debug purpose

--select @sumAdjustedTotalCommitment,DealName,financingSourceName,FinancingSourceMasterID,format((AdjustedTotalCommitment/@sumAdjustedTotalCommitment)*100,'#0.00') as Percentage,
--format((format((AdjustedTotalCommitment/@sumAdjustedTotalCommitment)*100,'#0.00') * @FeeAmount)/@sumPercentage,'#0.00') as FeeAmount
--,qb.QBAccountNo,qb.QBItemName

-- from
--(
--select d.credealid,d.dealname, sum(n.AdjustedTotalCommitment) AdjustedTotalCommitment,f.financingSourcename,f.FinancingSourceMasterID,f.IsThirdParty

--from cre.deal d join cre.note n on d.dealid=n.dealid 
--join core.account ac on ac.AccountID=n.Account_AccountID
--left join cre.FinancingSourceMaster f on f.FinancingSourceMasterID=n.financingSourceID
--where isnull(d.isdeleted,0)=0 and isnull(ac.statusID,1)=1
--group by f.financingSourcename,FinancingSourceMasterID,d.dealid,d.credealid,d.dealname,n.dealid,f.IsThirdParty
--having d.DealID=@DealIDOrCREDealID
----and f.IsThirdParty=0
--) tbl 

--join cre.QBAccountFinancingSourceMapping qb on qb.FinancingSourceID = tbl.FinancingSourceMasterID
--where IsThirdParty=0
--and qb.InvoiceTypeID=@InvoiceTypeID
----
END
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END  