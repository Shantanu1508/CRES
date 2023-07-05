
CREATE PROCEDURE [dbo].[usp_GetAIDashBoardData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..[#tblRecord]') IS NOT NULL                                         
 DROP TABLE [#tblRecord] 
Create table [#tblRecord]
(     
	ID int IDENTITY(1,1),
	IntentName nvarchar(256) null ,  
	ParentId int,
	Question nvarchar(max) null	                   
)
	
INSERT INTO [#tblRecord] (IntentName,ParentId,Question)

SELECT ISNULL(cl.IntentName,tblIntents.IntentName) as IntentName,ISNULL(cl.ParentId,Chatlogid) as ParentId,Question
--,[status],CreatedDate,
--CreatedBy,Chatlogid,SentBy 
FROM [Hbot].[ChatLog]  cl
left join(
	Select ISNULL(ParentId,ChatLogID) as  ParentId,IntentName
	from hbot.chatlog 
	where IntentName is not null
	and Question not like 'Session end%'
)tblIntents on tblIntents.ParentId = cl.ChatLogID
where Question <>'Session end.'
--and CAST(cl.createddate as date) >= DATEADD(day,1,EOMONTH(DAteAdd(month,-1,getdate()))) and CAST(cl.createddate as date) <= EOMONTH(getdate())
order by CreatedDate desc

--Select Distinct ID,IntentName,ParentId,Question from [#tblRecord] order by ID

--===========================================

IF OBJECT_ID('tempdb..[#tblRecordFinal]') IS NOT NULL                                         
 DROP TABLE [#tblRecordFinal] 
Create table [#tblRecordFinal]
(   [count] int,
	[Type] nvarchar(256) null ,
	[ischart] nvarchar(256) null ,
	ChartType nvarchar(256) null ,
	ChartName nvarchar(256) null	                   
)

INSERT INTO [#tblRecordFinal]([count],[Type],[ischart],ChartType,ChartName)

Select COUNT(Distinct ParentId) ,'Open Deal','Chart','Pie','Question Pattern' from [#tblRecord] where IntentName = 'OpenDeal'

INSERT INTO [#tblRecordFinal]([count],[Type],[ischart],ChartType,ChartName)
Select COUNT(Distinct ParentId),'Open Note' ,'Chart','Pie','Question Pattern' from [#tblRecord] where IntentName = 'OpenNote' 

INSERT INTO [#tblRecordFinal]([count],[Type],[ischart],ChartType,ChartName)
Select Distinct SUM(z.[count]) [count],z.[Type],'Chart','Pie','Question Pattern'
From(
Select (CASE WHEN b.cnt = 2 THEN 'Single Question' ELSE 'Multi Level' END) as [Type],SUM(b.count)  [count]
from(
	Select a.cnt,SUM(a.cnt) [count]
	from(
		Select ParentId,COUNT(*) cnt  from [#tblRecord]  where IntentName not in ('OpenNote' ,'OpenDeal')
		group by ParentId
	)a
	group by a.cnt
)b
group by b.cnt

)z
group by z.[Type]

-------------------------------------------------------------------------------------

	SELECT Count(chatlogid) AS [Count], 
       'Today'          AS [Text], 
       'Box'            AS ischart, 
       ''               AS ChartType ,
	   ''               as ChartName
FROM   hbot.chatlog cl 
WHERE  cl.createddate > Cast(Dateadd(day, -1, Getdate()) AS DATE)
UNION ALL 
SELECT Count(chatlogid) AS [Count], 
       'Current Month'  AS [Text], 
       'Box'            AS ischart, 
       ''               AS ChartType ,
	   ''               as ChartName
FROM   hbot.chatlog cl 
WHERE  cl.createddate >=Cast(Dateadd(day, -30, Getdate()) AS DATE)
UNION ALL 
SELECT Count(chatlogid) AS [Count], 
       'Current Week'   AS [Text], 
       'Box'            AS ischart, 
       ''               AS ChartType ,
	   	''               as ChartName
FROM   hbot.chatlog cl 
WHERE  cl.createddate >= Dateadd(week, Datediff(week, 0, Getdate()), 0) 
       AND cl.createddate <= Dateadd(wk, 1, Dateadd(day, 1 - Datepart(weekday, 
                                                             Getdate()), 
                                            Datediff(dd, 0, Getdate() 
                                            ))) 
UNION ALL 
SELECT Count(ch.createdby) AS [Count], 
       l1.firstname        AS [Text], 
       'Chart'             AS ischart, 
       'Pie'               AS ChartType,
	   	'User Wise Interaction'  as ChartName
FROM   hbot.chatlog ch 
       INNER JOIN app.[user] l1 
               ON l1.userid = ch.createdby 
GROUP  BY ch.createdby, 
          l1.firstname 
UNION ALL 
SELECT Count (ais.statusname) AS [Count], 
       ais.description        AS [Text], 
       'Chart'                AS ischart, 
       'Bar'               AS ChartType,
	   'AI Response Analysis'  as ChartName
FROM   hbot.chatlog cl 

       LEFT JOIN hbot.[aistatusmapping] ais 
              ON cl.status = ais.statusid 

			where  question != 'Session end.'
GROUP  BY cl.status, 
          ais.description 
UNION ALL 
SELECT Count (sentby) AS [Count], 
       'Total Sent'   AS [Text], 
       'Box'          AS ischart, 
       ''             AS ChartType ,
	   ''             as ChartName
FROM   hbot.chatlog cl 
WHERE  sentby = 'user' 
       AND question != 'Session end.' 
UNION ALL 
SELECT Count (sentby) AS [Count], 
       'Total Received'   AS [Text], 
       'Box'          AS ischart, 
       ''             AS ChartType ,
	   ''             as ChartName
FROM   hbot.chatlog cl 
WHERE  sentby = 'bot' 
      
 UNION ALL

 Select AVG(a.cnt) as [Count] ,   'Avg Question'   AS [Text],  'Box'          AS ischart,    ''             AS ChartType ,   ''             as ChartName
from(
Select CAST(CreatedDate as Date) as CreatedDate,count(CAST(CreatedDate as Date)) cnt
from hbot.chatlog
where CreatedDate >=Cast(Dateadd(day, -30, Getdate()) AS DATE)
and SentBy ='user' and Question <> 'Session end.'
group by CAST(CreatedDate as Date)
)a

 UNION ALL
 Select * from [#tblRecordFinal]

 UNION ALL

	select count(IntentName) AS [Count], 
	  IntentName AS [Text],
	  'Chart'                AS ischart, 
       'Column'               AS ChartType,
	   'Most Used Intent'  as ChartName

	 from  hbot.chatlog	
	group by  IntentName
		having count(IntentName)>=8 and IntentName !=''


END


  
 