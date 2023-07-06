
CREATE PROCEDURE [dbo].[usp_GetAIUserData] --'22835d10-486d-40df-98af-87489ec7bc12'
	@UserID uniqueidentifier

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..[#tblUserRecord]') IS NOT NULL                                         
 DROP TABLE [#tblUserRecord] 
Create table [#tblUserRecord]
(     
	ID int IDENTITY(1,1),
	IntentName nvarchar(256) null ,  
	ParentId int,
	Question nvarchar(max) null,
	CreatedBy nvarchar(256) null       
)
	
INSERT INTO [#tblUserRecord] (IntentName,ParentId,Question,CreatedBy)

SELECT ISNULL(cl.IntentName,tblIntents.IntentName) as IntentName,ISNULL(cl.ParentId,Chatlogid) as ParentId,Question ,CreatedBy
--,[status],CreatedDate,
--CreatedBy,Chatlogid,SentBy 
FROM [Hbot].[ChatLog]  cl
left join(
	Select ISNULL(ParentId,ChatLogID) as  ParentId,IntentName
	from hbot.chatlog 
	where IntentName is not null
	and Question not like 'Session end%'
)tblIntents on tblIntents.ParentId = cl.ChatLogID
where Question <>'Session end.' and  CreatedBy =@UserID
 
order by CreatedDate desc 

--===========================================

IF OBJECT_ID('tempdb..[#tblUserRecordFinal]') IS NOT NULL                                         
 DROP TABLE [#tblUserRecordFinal] 
Create table [#tblUserRecordFinal]
(   [count] int,
	[Type] nvarchar(256) null ,
	[ischart] nvarchar(256) null ,
	ChartType nvarchar(256) null ,
	ChartName nvarchar(256) null
	            
)

INSERT INTO [#tblUserRecordFinal]([count],[Type],[ischart],ChartType,ChartName)
Select COUNT(Distinct ParentId) ,'Open Deal','Chart','Pie','Question Pattern' from [#tblUserRecord] where IntentName = 'OpenDeal'

INSERT INTO [#tblUserRecordFinal]([count],[Type],[ischart],ChartType,ChartName)
Select COUNT(Distinct ParentId),'Open Note' ,'Chart','Pie','Question Pattern' from [#tblUserRecord] where IntentName = 'OpenNote' 

INSERT INTO [#tblUserRecordFinal]([count],[Type],[ischart],ChartType,ChartName)
Select Distinct SUM(z.[count]) [count],z.[Type],'Chart','Pie','Question Pattern'
From(
Select (CASE WHEN b.cnt = 2 THEN 'Single Question' ELSE 'Multi Level' END) as [Type],SUM(b.count)  [count]
from(
	Select a.cnt,SUM(a.cnt) [count]
	from(
		Select ParentId,COUNT(*) cnt  from [#tblUserRecord]  where IntentName not in ('OpenNote' ,'OpenDeal')
		group by ParentId
	)a
	group by a.cnt
)b
group by b.cnt

)z
group by z.[Type]
 

 
 ----------------------------------------------------------------------------------------- 
SELECT Count (ais.statusname) AS [Count], 
       ais.description        AS [Text], 
       'Chart'                AS ischart, 
       'Bar'               AS ChartType,
	   'AI Response Analysis'  as ChartName
FROM   hbot.chatlog cl 
       LEFT JOIN hbot.[aistatusmapping] ais 
              ON cl.status = ais.statusid 
			   where  cl.CreatedBy = @UserID  and question != 'Session end.'
GROUP  BY cl.status, 
          ais.description 		 
 
      
 UNION ALL

	select count(IntentName) AS [Count], 
	  IntentName AS [Text],
	  'Chart'                AS ischart, 
       'Column'               AS ChartType,
	   'Most Used Intent'  as ChartName

	 from  hbot.chatlog	 cl
	   where  cl.CreatedBy = @UserID  and question != 'Session end.'
	group by  IntentName
		having count(IntentName)>=8 and IntentName !=''
 
  UNION ALL
 Select * from [#tblUserRecordFinal]


END


  
 