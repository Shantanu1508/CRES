

CREATE PROCEDURE [dbo].[usp_GetFutureFundingData_DE] --null,null
   @StartDate datetime,
   @EndDate datetime
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
             
      SELECT --n.NoteID
                     --,n.Account_AccountID
                     distinct n.CRENoteID NoteID
                     ,acc.name NoteName
                     ,fs.[Date]
                     ,fs.Value
                     ,case when fs.value>=0 then 'Funding' else 'Curtailment' end FundingType
from [CORE].[FundingSchedule] fs INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where eve.EffectiveStartDate=(select max(EffectiveStartDate) from [CORE].[Event] where AccountID = eve.AccountID 
and StatusID = (Select LookupID from Core.Lookup where name = 'Active' and Parentid = 1))
and isnull(fs.value,0)<>0 and acc.IsDeleted=0
and fs.[Date] between  (CASE WHEN @StartDate IS NULL or @StartDate=''THEN (select min([Date])FROM [CORE].[FundingSchedule]) ELSE @StartDate END )
and   (CASE WHEN @EndDate IS NULL or @EndDate='' THEN (select max([Date])FROM [CORE].[FundingSchedule]) ELSE @EndDate END )
union
select crenoteid,name,closingdate,initialfundingamount,'Intial Funding' from cre.note n
      INNER JOIN [CORE].[Account] a ON a.AccountID = n.Account_AccountID 
      where IsDeleted=0 and closingdate between  (CASE WHEN @StartDate IS NULL or @StartDate=''THEN (select min(closingdate) FROM cre.note) ELSE @StartDate END )
and   (CASE WHEN @EndDate IS NULL or @EndDate='' THEN (select max(closingdate)FROM cre.note) ELSE @EndDate END )

union
select crenoteid,name,periodenddate,-balloonpayment,'Balloon Payment' from cre.note n
      INNER JOIN [CORE].[Account] a ON a.AccountID = n.Account_AccountID 
      LEFT JOIN [CRE].[NotePeriodicCalc] pc on pc.AccountID= a.AccountID
	   

      where isnull(balloonpayment,0)<>0 and a.IsDeleted=0 and a.AccounttypeID = 1
      and pc.PeriodEndDate between (CASE WHEN @StartDate IS NULL or @StartDate=''THEN (select min(PeriodEndDate) FROM cre.noteperiodiccalc) ELSE @StartDate END )
and   (CASE WHEN @EndDate IS NULL or @EndDate='' THEN (select max(PeriodEndDate)FROM cre.noteperiodiccalc) ELSE @EndDate END )

order by acc.name ,fs.[Date]
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END      

