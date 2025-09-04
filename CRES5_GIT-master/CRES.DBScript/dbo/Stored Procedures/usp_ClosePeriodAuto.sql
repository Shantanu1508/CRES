-- Procedure

---[dbo].[usp_ClosePeriodAuto]  '15-1101','b0e6697b-3534-4c09-be0a-04473401ab93'
CREATE PROCEDURE [dbo].[usp_ClosePeriodAuto] 
@DealIDs nvarchar(max),
@UserID nvarchar(256)
AS

BEGIN

	SET NOCOUNT ON;

Declare @AnalysisID UNIQUEIDENTIFIER
Select @AnalysisID = AnalysisID from core.Analysis where Name='Default'

Declare @dealid UNIQUEIDENTIFIER
Declare @credealid nvarchar(256)
Declare @Last_CloseDate date
Declare @OpenDate Date
Declare @New_CloseDate Date
Declare @MAX_PeriodID UNIQUEIDENTIFIER
Declare @Min_ClosingDate Date


IF CURSOR_STATUS('global','Cursor_Close')>=-1
BEGIN
	DEALLOCATE Cursor_Close
END

DECLARE Cursor_Close CURSOR 
for
(
	Select dealid,credealid,Last_CloseDate,OpenDate,New_CloseDate,MAX_PeriodID,Min_ClosingDate
	From(
		Select dealid,credealid,Last_CloseDate,OpenDate,New_CloseDate,MAX_PeriodID,
		Min_ClosingDate,
		(CASE WHEN Last_CloseDate = New_CloseDate THEN 1 ELSE 0 END) as AlreadyExists
		From(
			Select d.dealid,d.credealid,MAX(p.CloseDate) as Last_CloseDate,tblLastOpenID.LastAccountingOpenDate as OpenDate, 
			(CASE WHEN EOMONTH(DateADD(month,-1,(tblLastOpenID.LastAccountingOpenDate))) < EOMONTH(tbldd.ClosingDate) THEN EOMONTH(tbldd.ClosingDate) ELSE EOMONTH(DateADD(month,-1,(tblLastOpenID.LastAccountingOpenDate))) END) as New_CloseDate,
			tblLastOpenID.MAX_PeriodID,
			EOMONTH(tbldd.ClosingDate) as Min_ClosingDate
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
			group by d.dealid,d.credealid,tblLastOpenID.MAX_PeriodID,EOMONTH(tbldd.ClosingDate) ,tblLastOpenID.LastAccountingOpenDate
		)a
	)z
	Where z.AlreadyExists = 0

)
OPEN Cursor_Close 

FETCH NEXT FROM Cursor_Close
INTO @dealid,@credealid,@Last_CloseDate,@OpenDate,@New_CloseDate,@MAX_PeriodID,@Min_ClosingDate

WHILE @@FETCH_STATUS = 0
BEGIN

	
	INSERT INTO [Core].[Period] (DealID,CloseDate,OpenDate,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,AnalysisID,[IsDeleted],LastActivityType,Comments)
	Select @dealid,@New_CloseDate,NUll,@UserID,getdate(),@UserID,getdate() ,@AnalysisID,0,'Close', CONVERT(nvarchar(256),@New_CloseDate,101) +' auto close'

	
	--UPDATE [Core].[Period] set Comments = CONVERT(nvarchar(256),@New_CloseDate,101) +' auto close' where dealid = @dealid and Closedate is null and opendate = @OpenDate and PeriodID = @MAX_PeriodID

	exec  [dbo].[usp_ImportIntoAccountingClosePeriodicArchive] @credealid,@New_CloseDate,@UserID
	exec  [dbo].[usp_ImportIntoAccountingCloseTransationArchive] @credealid,@New_CloseDate,@UserID


					 
FETCH NEXT FROM Cursor_Close
INTO @dealid,@credealid,@Last_CloseDate,@OpenDate,@New_CloseDate,@MAX_PeriodID,@Min_ClosingDate
END
CLOSE Cursor_Close   
DEALLOCATE Cursor_Close









END





