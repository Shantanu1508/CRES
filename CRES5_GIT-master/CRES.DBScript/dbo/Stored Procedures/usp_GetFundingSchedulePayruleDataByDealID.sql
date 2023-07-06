


--[dbo].[usp_GetFundingSchedulePayruleDataByDealID] '63e79959-c7d8-4d69-a68a-28c8b2f423bc'
Create PROCEDURE [dbo].[usp_GetFundingSchedulePayruleDataByDealID] 
(
    @DealID UNIQUEIDENTIFIER
	
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare  @FundingSchedule  int  =10;
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
Declare @InActive as nvarchar(256)=(select LookupID from core.lookup where name ='InActive' and ParentID=1);


CREATE TABLE #tmpFunding
(
  Noteid uniqueidentifier,
  Name VARCHAR(5000),
  [Date] date,
  Value [decimal](28, 15) NULL,
  PurposeID [int] NULL,
  PurposeText VARCHAR(5000),
  Applied [bit] NULL,
  Comments [nvarchar](max) NULL,
  Drawfundingid [nvarchar](256) NULL,
  EventID uniqueidentifier,
  DealFundingRowno INT,
  DealFundingID uniqueidentifier
)

INSERT INTO #tmpFunding(Noteid, Name, [Date],Value ,PurposeID ,PurposeText, Applied, Comments, Drawfundingid, EventID, DealFundingRowno, DealFundingID)
Select 
a.Noteid as Noteid,
a.notename as Name,
a.[date],
--ISNULL(b.value, 0) as Value,
b.value as Value,
a.orgPurposeID,
a.OrgPurposeText,
a.Applied,
a.Comment,
a.Drawfundingid,
ISNULL(b.EventID,'00000000-0000-0000-0000-000000000000') as EventID,
b.DealFundingRowno,
a.DealFundingID
 from(
	Select
	n.noteid
	,acc.name as notename
	,fs.DealFundingID DealFundingID 
	,fs.[DealID] DealID
	,fs.[Date] Date
	,fs.[Amount] Value
	,fs.[Comment] Comment
	,fs.[PurposeID] PurposeID
	,fs.UpdatedDate UpdatedDate
	,l1.name PurposeText
	,ISNULL(fs.Applied,0) Applied
	,DrawFundingId
	,fs.[Date] as orgDate
	,fs.[Amount] as orgValue
	,ISNULL(fs.Applied,0) as OrgApplied
	,fs.[PurposeID] as orgPurposeID
	,l1.name  as OrgPurposeText
	,fs.Issaved as Issaved
	,ISNULL(fs.DealFundingRowno,0) as DealFundingRowno
	

	from [CRE].[DealFunding] fs
	left join cre.deal d on d.DealID = fs.DealID
	inner join cre.note n on n.dealid = d.dealid
	inner join core.account acc on acc.accountid = n.account_accountid
	Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID
	where fs.DealID = @DealID and d.IsDeleted = 0
	and acc.IsDeleted = 0
	--order by fs.[Date]
) a
Left JOin(					
	Select  ROW_NUMBER() OVER (PARTITION BY  fs.[Date],fs.[PurposeID],df.DealFundingRowno,acc.Name  ORDER BY fs.[Date]) AS SNO
	,df.DealID DealID
	,n.NoteId
	,acc.Name Name
	,df.[Date] Date
	,fs.PurposeID
	,fs.Value Value
	,fs.Applied
	,fs.EventID
	,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno
	,df.PurposeID as b_PurposeID
	from 
	[CRE].[DealFunding] df
	left join cre.deal d on d.DealID = df.DealID and d.DEalID= @DealID
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
						where EventTypeID = '10' 
						and n.DealID = @DealID
						and eve.StatusID ='1'  
						and acc.IsDeleted = 0
						GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

				) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where sEvent.StatusID = e.StatusID --and n.UseRuletoDetermineNoteFunding=(Select LookupID from Core.Lookup where name = 'Y' and parentId=2)
	--and isnull(acc.StatusID, '1')!= '2' 
	and acc.IsDeleted = 0 and 
	df.DealID = @DealID and d.IsDeleted = 0
	

)b on a.noteid=b.noteid and a.DealID=b.DealID and a.Date=b.Date and a.PurposeID=b.b_PurposeID and a.DealFundingRowno=b.DealFundingRowno 
order by a.[Date], ISNULL(a.DealFundingRowno,0) --ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name ,fs.[Date]
   
  

SELECT Noteid, Name, [Date],Value ,PurposeID ,PurposeText, Applied, Comments, EventID, Drawfundingid, DealFundingRowno, DealFundingID FROm #tmpFunding
order by Noteid, [Date], ISNULL(DealFundingRowno,0); 

DROP TABLE #tmpFunding



SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END





