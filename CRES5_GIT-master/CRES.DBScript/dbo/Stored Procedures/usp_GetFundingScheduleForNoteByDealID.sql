

--[dbo].[usp_GetFundingScheduleForNoteByDealID]  'd42e4d50-cbc1-4548-8786-be0f2036f59d'
CREATE PROCEDURE [dbo].[usp_GetFundingScheduleForNoteByDealID] --'F4BFC283-BADF-4A60-9BA8-04CAB977E08B'
(
    @UserID UNIQUEIDENTIFIER,
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
  Comment [nvarchar](max) NULL,
  Drawfundingid [nvarchar](256) NULL,
  DealFundingRowno INT
)


   
  
DECLARE @NoteID uniqueidentifier     
DECLARE @Name VARCHAR(5000)   
  
  
PRINT '--------Note Details --------';    
  
DECLARE note_cursor CURSOR FOR     
 select Noteid , acc.Name from CRE.Note n
	INNER JOIN core.account acc on acc.AccountId = n.account_accountId  where DealId= @DealID 
    
  
OPEN note_cursor    
  
FETCH NEXT FROM note_cursor     
INTO @NoteID, @Name    
  
WHILE @@FETCH_STATUS = 0    
BEGIN    
    PRINT (@Name)  
	--===========================
	
INSERT INTO #tmpFunding(Noteid, Name, [Date],Value ,PurposeID ,PurposeText, Applied, Comment, Drawfundingid, DealFundingRowno)
Select 
@Noteid as Noteid,
@Name as Name,
a.date,
ISNULL(b.value, 0) as Value,
a.orgPurposeID,
a.OrgPurposeText,
a.Applied,
a.Comment,
a.Drawfundingid,
a.DealFundingRowno
 from(
	Select
	 fs.DealFundingID DealFundingID 
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
	Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID
	where fs.DealID = @DealID and d.IsDeleted = 0
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
	and isnull(acc.StatusID, '1')!= '2' 
	and acc.IsDeleted = 0 and 
	df.DealID = @DealID and d.IsDeleted = 0
	and n.NoteId = @NoteID

	--and acc.IsDeleted = 0
    

)b on a.DealID=b.DealID and a.Date=b.Date and a.PurposeID=b.b_PurposeID and a.DealFundingRowno=b.DealFundingRowno 
order by a.[Date], ISNULL(a.DealFundingRowno,0) --ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name ,fs.[Date]



	--===========================
    FETCH NEXT FROM note_cursor     
INTO @NoteID ,@Name  
   
END     
CLOSE note_cursor;    
DEALLOCATE note_cursor;  


SELECT Noteid, Name, [Date],Value ,PurposeID ,PurposeText, Applied, Comment, Drawfundingid FROm #tmpFunding
order by a.[Date], ISNULL(a.DealFundingRowno,0) 

DROP TABLE #tmpFunding







/*
Select * from(
	Select
	 fs.DealFundingID DealFundingID 
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
	Left Join Core.Lookup l1 on fs.PurposeID=l1.LookupID
	where fs.DealID = @DealID and d.IsDeleted = 0
	--order by fs.[Date]
) a
Left JOin(					
	Select  ROW_NUMBER() OVER (PARTITION BY  fs.[Date],fs.[PurposeID],df.DealFundingRowno,acc.Name  ORDER BY fs.[Date]) AS SNO
	,df.DealID DealID
	,acc.Name Name
	,df.[Date] Date
	,fs.PurposeID
	,fs.Value Value
	,ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0)) as DealFundingRowno
	,df.PurposeID as b_PurposeID
	from 
	[CRE].[DealFunding] df
	left join cre.deal d on d.DealID = df.DealID and d.DEalID=@DealID
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
	and isnull(acc.StatusID, '1')!= '2' 
	and acc.IsDeleted = 0 and 
	df.DealID = @DealID and d.IsDeleted = 0
	--and acc.name = 'A-1F Note'

)b on a.DealID=b.DealID and a.Date=b.Date and a.PurposeID=b.b_PurposeID and a.DealFundingRowno=b.DealFundingRowno 


----------------------------

Select  
n.NoteID
,acc.Name
,fs.[Date]
,fs.Value
,fs.PurposeID
,LPurposeID.Name PurposeText
,e.EventID
,fs.Applied
,fs.Comments
,fs.DrawFundingID
from [CORE].FundingSchedule fs
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
INNER JOIN 
			(
						
				Select 
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
					from [CORE].[Event] eve
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
					where EventTypeID = @FundingSchedule
					and n.DealID = @DealID
					and eve.StatusID = @Active
					and acc.IsDeleted = 0
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

left join [CRE].[DealFunding] df on df.[Date]=fs.[Date]  and df.purposeid=fs.purposeid and ISNULL(df.DealFundingRowno,0)=ISNULL(fs.DealFundingRowno,ISNULL(df.DealFundingRowno,0))

 
where sEvent.StatusID = e.StatusID and n.UseRuletoDetermineNoteFunding=(Select LookupID from Core.Lookup where name = 'Y' and parentId=2)
and isnull(acc.StatusID,@Active)!=@InActive
and acc.IsDeleted = 0
order by fs.[Date], ISNULL(fs.DealFundingRowno,0) --ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name ,fs.[Date]


*/

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

