-- [dbo].[usp_GetLinkedPhantomDealID]  '16-1024'

CREATE PROCEDURE [dbo].[usp_GetLinkedPhantomDealID]  --'15-0219'
(
	@CREDealID nvarchar(256)
)
  
AS
  BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
Declare @FullyExtendedMaturityDate date;
SET @FullyExtendedMaturityDate = (Select Distinct  MAX(FullyExtendedMaturityDate) as Date
from cre.deal d
inner join cre.note n on n.dealid = d.dealid
inner join core.account acc on acc.accountid = n.account_accountid
where d.isdeleted <> 1 and acc.isdeleted <> 1
and d.linkeddealid = @CREDealID)


	 
Select dealid,d.LinkedDealID,CREDealID,EnableAutoSpreadRepayments,ApplyNoteLevelPaydowns,RepaymentAutoSpreadMethodID,
l.Name as RepaymentAutoSpreadMethodIDText,PossibleRepaymentdayofthemonth,
Repaymentallocationfrequency,Blockoutperiod,EarliestPossibleRepaymentDate,ExpectedFullRepaymentDate,LatestPossibleRepaymentDate,
AutoPrepayEffectiveDate,(CASE WHEN tbl_Y_Deal.LinkedDealID is not null THEN 1 Else 0 end) EnableAutospreadUseRuleN ,@FullyExtendedMaturityDate as FullyExtendedMaturityDate

from cre.Deal d
left join core.lookup l on l.LookupID = RepaymentAutoSpreadMethodID
Left Join(
	Select Distinct LinkedDealID
	from cre.Note n
	inner join cre.Deal d on n.DealID = d.DealID
	where UseRuletoDetermineNoteFunding = 3
)tbl_Y_Deal on tbl_Y_Deal.LinkedDealID = @CREDealID
where d.LinkedDealID = @CREDealID and IsDeleted=0


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

 




