

CREATE PROCEDURE [dbo].[usp_GetPatternWiseCount]  --'324f479b-aaa5-461a-b8a4-54ef9d405a5f' 

AS
BEGIN
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
and CAST(cl.createddate as date) >= DATEADD(day,1,EOMONTH(DAteAdd(month,-1,getdate()))) and CAST(cl.createddate as date) <= EOMONTH(getdate())
order by CreatedDate desc

--Select Distinct ID,IntentName,ParentId,Question from [#tblRecord] order by ID

--===========================================

IF OBJECT_ID('tempdb..[#tblRecordFinal]') IS NOT NULL                                         
 DROP TABLE [#tblRecordFinal] 
Create table [#tblRecordFinal]
(  
	[Type] nvarchar(256) null ,  
	[count] int	                   
)

INSERT INTO [#tblRecordFinal]([Type],[count])
Select 'OpenDeal',COUNT(Distinct ParentId)  from [#tblRecord] where IntentName = 'OpenDeal'

INSERT INTO [#tblRecordFinal]([Type],[count])
Select 'OpenNote',COUNT(Distinct ParentId)  from [#tblRecord] where IntentName = 'OpenNote' 

INSERT INTO [#tblRecordFinal]([Type],[count])
Select Distinct z.[Type],SUM(z.[count]) [count]
From(
Select (CASE WHEN b.cnt = 2 THEN 'SingleQuestion' ELSE 'MultiLevel' END) as [Type],SUM(b.count)  [count]
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


Select * from [#tblRecordFinal]


END
