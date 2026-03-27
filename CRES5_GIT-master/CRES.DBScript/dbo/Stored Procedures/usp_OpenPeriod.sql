
CREATE procedure [dbo].[usp_OpenPeriod] 
@DealIDs nvarchar(max),
@OpenDate Date,
@UserID nvarchar(256),
@Comments nvarchar(max),
@Description nvarchar(max) = null
AS

BEGIN

	SET NOCOUNT ON;



IF OBJECT_ID('tempdb..#tblOpenPeriod') IS NOT NULL         
	DROP TABLE #tblOpenPeriod

CREATE TABLE #tblOpenPeriod(
	PeriodID UNIQUEIDENTIFIER,
	CloseDate Date,
	DealID UNIQUEIDENTIFIER
)
INSERT INTO #tblOpenPeriod(PeriodID,CloseDate,DealID)

Select p.PeriodID,p.CloseDate,p.DealID
from CORE.[Period] p 	
Inner Join cre.deal d on d.dealid =  p.dealid
where d.isdeleted <> 1 and p.isdeleted <> 1
and d.credealid in (Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|'))
and p.CloseDate > @OpenDate


IF NOT EXISTS(Select PeriodID from #tblOpenPeriod)
BEGIN
	return;
END

INSERT INTO [Core].[Period] (DealID,CloseDate,OpenDate,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AnalysisID,LastActivityType,Comments,[Description])
Select d.DealID,null,@OpenDate,@UserID,getdate(),@UserID,getdate() ,'C10F3372-0FC2-4861-A9F5-148F1F80804F','Open',@Comments,@Description
From cre.deal d 
where isdeleted <> 1
and d.dealid in (Select DealID from #tblOpenPeriod)



UPDATE [Core].[Period] set IsDeleted = 1, LastActivityType = 'Open',OpenDate = @OpenDate where PeriodID in (Select PeriodID from #tblOpenPeriod)  -----UpdatedBy =@UserID,UpdatedDate = getdate()
UPDATE core.[AccountingCloseTransationArchive] SET IsDeleted=1 WHERE PeriodID in (Select PeriodID from #tblOpenPeriod)
UPDATE core.AccountingClosePeriodicArchive SET IsDeleted=1 WHERE PeriodID in (Select PeriodID from #tblOpenPeriod)



--------auto close Feature-------
--Set @DealIDs = (select STUFF((SELECT '|' + (CAST(CREDealId as nvarchar(MAX))) 
--                From(
--                    Select CREDealId from cre.deal where isdeleted <> 1
--					and dealid in (Select DealID from #tblOpenPeriod)
--                 )a
--            FOR XML PATH(''), TYPE
--            ).value('.', 'NVARCHAR(MAX)') 
--        ,1,1,'')
--		)


--exec [dbo].[usp_ClosePeriodAuto]  @DealIDs,@UserID
------------------------------------------


--========Auto Close==============================

IF OBJECT_ID('tempdb..#tblDealData') IS NOT NULL         
	DROP TABLE #tblDealData

CREATE TABLE #tblDealData(	
	dealid	UNIQUEIDENTIFIER,
	credealid nvarchar(256),
	Last_CloseDate	Date,
	OpenDate	Date,
	New_CloseDate	Date,
	MAX_PeriodID	UNIQUEIDENTIFIER,
	Min_ClosingDate	Date,
	NewCloseDate_AlreadyExists int
)

INSERT INTO #tblDealData(dealid,credealid,Last_CloseDate,OpenDate,New_CloseDate,MAX_PeriodID,Min_ClosingDate,NewCloseDate_AlreadyExists)

Select dealid,credealid,Last_CloseDate,OpenDate,New_CloseDate,MAX_PeriodID,Min_ClosingDate,AlreadyExists
From(
	Select dealid,credealid,ISNULL(Last_CloseDate,DATEADD(day,-1,Actual_ClosingDate))  as Last_CloseDate,OpenDate,New_CloseDate,MAX_PeriodID,
	Min_ClosingDate,
	(CASE WHEN Last_CloseDate = New_CloseDate THEN 1 ELSE 0 END) as AlreadyExists
	From(
		
		Select d.dealid,d.credealid,MAX(p.CloseDate) as Last_CloseDate,tblLastOpenID.LastAccountingOpenDate as OpenDate, 
		(CASE 
			WHEN tblLastOpenID.LastAccountingOpenDate = EOMONTH(tblLastOpenID.LastAccountingOpenDate) THEN EOMONTH(tblLastOpenID.LastAccountingOpenDate)
			--WHEN EOMONTH(DateADD(month,-1,(tblLastOpenID.LastAccountingOpenDate))) < EOMONTH(tbldd.ClosingDate) THEN EOMONTH(tbldd.ClosingDate) 		
			ELSE EOMONTH(DateADD(month,-1,(tblLastOpenID.LastAccountingOpenDate))) END) as New_CloseDate,
		tblLastOpenID.MAX_PeriodID,
		EOMONTH(tbldd.ClosingDate) as Min_ClosingDate,
		tbldd.ClosingDate as Actual_ClosingDate
		from CORE.[Period] p 	
		Inner Join cre.deal d on d.dealid =  p.dealid
		LEFT JOIN(
			Select DealID,LastAccountingOpenDate,MAX_PeriodID
			From(
				Select 
				d.DealID,p.OpenDate as LastAccountingOpenDate,PeriodiD	MAX_PeriodID
				,ROW_NUMBER() OVER (Partition BY p.dealid order by p.dealid,p.updateddate desc) rno
				from cre.deal d
				Inner join CORE.[Period] p on d.dealid = p.dealid 
				where p.CloseDate is null
				and d.credealid in (Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|'))
			)y
			Where rno = 1
		)tblLastOpenID on tblLastOpenID.dealid = d.dealid
		Left Join(
			Select d.dealid,MAX(n.ClosingDate) as ClosingDate
			from cre.Deal d
			Inner Join cre.note n on n.dealid = d.dealid
			Inner Join core.account acc on acc.accountid = n.account_accountid
			Where acc.isdeleted <> 1 and d.isdeleted <> 1
			Group by d.dealid
		)tbldd on tbldd.dealid = d.dealid

		where d.isdeleted <> 1 and p.isdeleted <> 1
		and d.credealid in (Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|'))

		and EOMONTH(DateADD(month,-1,(tblLastOpenID.LastAccountingOpenDate))) > EOMONTH(tbldd.ClosingDate)

		group by d.dealid,d.credealid,tblLastOpenID.MAX_PeriodID,EOMONTH(tbldd.ClosingDate) ,tblLastOpenID.LastAccountingOpenDate,tbldd.ClosingDate
	
	
	)a
)z
--Where z.AlreadyExists = 0



Declare @AnalysisID UNIQUEIDENTIFIER
Select @AnalysisID = AnalysisID from core.Analysis where Name='Default'

Declare @dealid UNIQUEIDENTIFIER
Declare @credealid nvarchar(256)
Declare @Last_CloseDate date
Declare @L_OpenDate Date
Declare @New_CloseDate Date
Declare @MAX_PeriodID UNIQUEIDENTIFIER
Declare @Min_ClosingDate Date
Declare @NewCloseDate_AlreadyExists bit



IF CURSOR_STATUS('global','Cursor_Close')>=-1
BEGIN
	DEALLOCATE Cursor_Close
END

DECLARE Cursor_Close CURSOR 
for
(
	Select dealid,credealid,Last_CloseDate,OpenDate,New_CloseDate,MAX_PeriodID,Min_ClosingDate,NewCloseDate_AlreadyExists
	From #tblDealData

)
OPEN Cursor_Close 

FETCH NEXT FROM Cursor_Close
INTO @dealid,@credealid,@Last_CloseDate,@L_OpenDate,@New_CloseDate,@MAX_PeriodID,@Min_ClosingDate,@NewCloseDate_AlreadyExists

WHILE @@FETCH_STATUS = 0
BEGIN
	
	DECLARE @tperiod TABLE (tperiodId UNIQUEIDENTIFIER)
	Declare @PeriodID_New UNIQUEIDENTIFIER;
	

	IF(@NewCloseDate_AlreadyExists = 1)
	BEGIN
		
		print('already exists')
		Declare @L_PeriodID UNIQUEIDENTIFIER =  (Select PeriodID from core.[period] where dealid = @dealid and CloseDate = @New_CloseDate and isdeleted <> 1)
		

		UPDATE [Core].[Period] set IsDeleted = 1 --, LastActivityType = 'Open',OpenDate = @OpenDate 
		where PeriodID = @L_PeriodID
		
		---Created new close date
		Delete from @tperiod
		INSERT INTO [Core].[Period] (DealID,CloseDate,OpenDate,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AnalysisID,[IsDeleted],LastActivityType,[Description])
		OUTPUT inserted.PeriodID INTO @tperiod(tperiodId)
		Select @dealid,@New_CloseDate,NUll,@UserID,getdate(),@UserID,getdate() ,@AnalysisID,0,'Close', CONVERT(nvarchar(256),@New_CloseDate,101) +' auto close'

		SELECT @PeriodID_New = tperiodId FROM @tperiod;

		Update [Core].[AccountingClosePeriodicArchive] SET PeriodID = @PeriodID_New where PeriodID = @L_PeriodID
		Update [Core].[AccountingCloseTransationArchive] SET PeriodID = @PeriodID_New where PeriodID = @L_PeriodID


	END
	ELSE
	BEGIN		
		
		Delete from @tperiod
		INSERT INTO [Core].[Period] (DealID,CloseDate,OpenDate,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AnalysisID,[IsDeleted],LastActivityType,[Description])
		OUTPUT inserted.PeriodID INTO @tperiod(tperiodId)
		Select @dealid,@New_CloseDate,NUll,@UserID,getdate(),@UserID,getdate() ,@AnalysisID,0,'Close', CONVERT(nvarchar(256),@New_CloseDate,101) +' auto close'

		SELECT @PeriodID_New = tperiodId FROM @tperiod;

		----Set New PeriodID in deleted data
		Update [Core].[AccountingClosePeriodicArchive] SET PeriodID = @PeriodID_New,IsDeleted = 0
		Where AccountingClosePeriodicArchiveID in (

			Select nc.AccountingClosePeriodicArchiveID
			FROM [Core].[AccountingClosePeriodicArchive] nc
			inner join cre.Note n on n.NoteID = nc.NoteID
			Inner join core.account acc on acc.accountid =n.account_accountid	
			WHERE  acc.Isdeleted <> 1	
	
			and nc.IsDeleted=1 and PeriodID in (Select PeriodID from #tblOpenPeriod where DealID = @dealid)
	
			and (CAST(PeriodEndDate as date) > CAST(@Last_CloseDate as date) and CAST(PeriodEndDate as date) <= CAST(@New_CloseDate as date))	
		)

		Update [Core].[AccountingCloseTransationArchive] SET PeriodID = @PeriodID_New,IsDeleted = 0
		Where AccountingCloseTransationArchiveID in (

			Select tr.AccountingCloseTransationArchiveID
			FROM [Core].[AccountingCloseTransationArchive] tr	
			inner join cre.Note n on n.NoteID = tr.NoteID
			Inner join core.account acc on acc.accountid =n.account_accountid
			WHERE  acc.Isdeleted <> 1	

			and tr.IsDeleted=1 and PeriodID in (Select PeriodID from #tblOpenPeriod where DealID = @dealid)

			and ( CAST(tr.Date as date) > CAST(@Last_CloseDate as date) and CAST(tr.Date as date) <= CAST(@New_CloseDate as date))	
		)

	END


	
					 
FETCH NEXT FROM Cursor_Close
INTO @dealid,@credealid,@Last_CloseDate,@L_OpenDate,@New_CloseDate,@MAX_PeriodID,@Min_ClosingDate,@NewCloseDate_AlreadyExists
END
CLOSE Cursor_Close   
DEALLOCATE Cursor_Close






-----Queue deal in calculation
Declare  @tmpCalcNotes TABLE(Noteid uniqueidentifier )

INSERT INTO  @tmpCalcNotes(Noteid)
SELECT 
Distinct n.[NoteId]	
from  CRE.Note n
left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID='C10F3372-0FC2-4861-A9F5-148F1F80804F'
left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
inner join cre.Deal d on n.DealId = d.DealId	
left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
where  
n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
and ac.IsDeleted=0
and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='active')
and d.credealid in (Select [Value] from [dbo].[fn_Split_Str](@DealIDs,'|'))


Declare @L_PriorityText nvarchar(100);
SET @L_PriorityText = 'Real Time'

IF((Select count(noteid) from @tmpCalcNotes) > 10)
BEGIN
	SET @L_PriorityText = 'Batch'
END


declare @TableTypeCalculationRequests TableTypeCalculationRequests
insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
Select Noteid,'Processing',@UserID,@L_PriorityText, 'C10F3372-0FC2-4861-A9F5-148F1F80804F' ,775 as CalcType From @tmpCalcNotes
	
exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UserID,@UserID, NULL, NULL, 'OpenPeriod'
----==========================================




END





