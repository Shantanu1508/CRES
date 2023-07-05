
CREATE PROCEDURE [dbo].[usp_QueueNotesForCalculationByScheduler] 

as 

BEGIN

Declare  @AnalysisID uniqueidentifier,@NextexcuteTime datetime,@AutoCalculationFrequency int

Declare @arrAnalysis table (AnalysisID uniqueidentifier,AutoCalculationFrequency int,NextExecuteTime Datetime)
INSERT INTO  @arrAnalysis(AnalysisID,AutoCalculationFrequency, NextExecuteTime)
Select AnalysisID,AutoCalculationFrequency, NextExecuteTime from Core.AnalysisParameter 
		Group by  AnalysisID,AutoCalculationFrequency, NextExecuteTime 
		having max(NextExecuteTime) < GETDATE() 

DECLARE scheduler_cursor CURSOR FOR     
SELECT AnalysisID,AutoCalculationFrequency, NextExecuteTime  
	FROM @arrAnalysis  
		order by NextExecuteTime

OPEN scheduler_cursor  


FETCH NEXT FROM scheduler_cursor     
INTO @AnalysisID,@AutoCalculationFrequency,@NextexcuteTime

WHILE @@FETCH_STATUS = 0    
BEGIN    
print @AnalysisID
--print cast(@AutoCalculationFrequency as varchar(20))    +'           '+   cast(@NextexcuteTime as varchar(20))  
	
Declare  @tmpCalcNotes TABLE(Noteid uniqueidentifier )

Declare @UserName uniqueidentifier;

Select @UserName=UserID from [App].[User] where Login='Sys_Scheduler'

INSERT INTO  @tmpCalcNotes(Noteid)
SELECT 
			  Distinct n.[NoteId]	
			  from  CRE.Note n
			  left join Core.CalculationRequests cr on n.NoteId=cr.NoteId and cr.AnalysisID=@AnalysisID
			  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  inner join cre.Deal d on n.DealId = d.DealId			
			  left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
			  where  
			  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
			 and ac.IsDeleted=0
			 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')


			declare @TableTypeCalculationRequests TableTypeCalculationRequests
			insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
			Select NoteId,'Processing',@UserName,'Real Time', @AnalysisID,775 
			From @tmpCalcNotes
			exec  [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UserName,@UserName 




	if(@AutoCalculationFrequency=584)--Daily
	BEGIN
		Set @NextexcuteTime = convert(date,getdate()+1)
	 END
	 if(@AutoCalculationFrequency=585)--Weekly
	 BEGIN
		Set @NextexcuteTime = DATEADD(day, DATEDIFF(day, 6, getdate()-1) /7*7 + 7, 6)
	END
	if(@AutoCalculationFrequency=586)--Monthly
	 BEGIN
		Set @NextexcuteTime = DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, getdate()) + 1, 0))
	END
	if(@AutoCalculationFrequency=587)--Quarterly
	 BEGIN
		Set @NextexcuteTime = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) +1, 0))
	END


  update Core.AnalysisParameter    
		set  NextExecuteTime=@NextexcuteTime,
		UpdatedBy=@UserName,
		UpdatedDate=getdate()			    
		where AnalysisID=@AnalysisID 

			 FETCH NEXT FROM scheduler_cursor     
INTO @AnalysisID,@AutoCalculationFrequency,@NextexcuteTime
	
END  
CLOSE scheduler_cursor;    
DEALLOCATE scheduler_cursor;   

END
