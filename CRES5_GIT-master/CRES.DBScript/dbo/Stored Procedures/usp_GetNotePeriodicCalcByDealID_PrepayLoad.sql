--[dbo].[usp_GetNotePeriodicCalcByDealID_PrepayLoad]    '1fd23dfd-9739-48e5-8c4d-20a6015a77ae','16-0155'


CREATE PROCEDURE [dbo].[usp_GetNotePeriodicCalcByDealID_PrepayLoad] 
(
    @DealID UNIQUEIDENTIFIER,
	@CREDEalID nvarchar(256)
)
	
AS
BEGIN

Select 
Row_number() over (Partition by nc.noteid order by nc.periodenddate) [Period],
n.CRENoteID,
nc.PeriodEndDate,
nc.Month,
ISNULL(nc.AllInCouponRate,0) AllInCouponRate,
ISNULL(nc.BeginningBalance,0) BeginningBalance,
ISNULL(nc.InterestReceivedinCurrentPeriod,0) InterestReceivedinCurrentPeriod,
ISNULL(nc.PrincipalPaid,0) PrincipalPaid,
ISNULL(nc.EndingBalance,0) EndingBalance,

n.TotalCommitment as TotalCommitment,
DateDiff(month,n.ClosingDate,ISNULL(n.ActualPayoffDate,n.FullyExtendedMaturityDate) ) as LoanDuration

from cre.NotePeriodicCalc nc
inner join cre.note n on n.noteid = nc.noteid
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.deal d on d.dealid = n.dealid
where nc.analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and nc.[Month] is not null
and d.dealid = @DealID



END
