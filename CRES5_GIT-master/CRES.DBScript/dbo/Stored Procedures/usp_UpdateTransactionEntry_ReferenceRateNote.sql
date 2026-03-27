 --[dbo].[usp_UpdateTransactionEntry_ReferenceRateNote]  '818A9ABC-0AFB-48BD-A2CF-0676E1C231AF','C10F3372-0FC2-4861-A9F5-148F1F80804F'


CREATE Procedure [dbo].[usp_UpdateTransactionEntry_ReferenceRateNote] 
 @NoteID uniqueidentifier,  
 @AnalysisID uniqueidentifier  
AS  
BEGIN  
 SET NOCOUNT ON;  
 
 
Declare @AccountID UNIQUEIDENTIFIER;
SET @AccountID = (Select Account_Accountid from cre.note where noteid = @NoteID )


IF OBJECT_ID('tempdb..[#tblSpreadRefRate]') IS NOT NULL                                         
 DROP TABLE [#tblSpreadRefRate]

CREATE TABLE [#tblSpreadRefRate](
	NoteID UNIQUEIDENTIFIER null,
	[date] Date null,
	ValueTypeID int null,
	Value decimal(28,15) null,
	TrType nvarchar(256) null,
	cnt int null
)
INSERT INTO [#tblSpreadRefRate](NoteID,[date],ValueTypeID,Value,TrType,cnt)
Select b.NoteID,b.date,b.ValueTypeID,b.Value,b.TrType,b.cnt 
from(
	Select n1.NoteID, rs.date,rs.ValueTypeID,rs.Value,
	(CASE when LValueTypeID.name ='Reference Rate' THen 'LIBORPercentage'
	when LValueTypeID.name ='Spread' THen 'SpreadPercentage' END)as TrType,
	count(rs.date) over (partition by n1.noteid,rs.date order by n1.noteid,rs.date) as cnt
	from [CORE].RateSpreadSchedule rs
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId
	LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
	INNER JOIN(					
					Select 
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
						and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
						and n.NoteID = @NoteID
						and acc.IsDeleted = 0
						GROUP BY n.Account_AccountID,EventTypeID
				) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	inner join core.Account ac on ac.AccountID =e.AccountID
	inner join cre.Note n1 on n1.Account_AccountID = ac.AccountID
	where e.StatusID = 1
	and n1.RateType = 139
	and rs.ValueTypeID in (151,596)		
)b
where b.cnt = 2
order by b.date


IF EXISTS(SELECT NoteID FROM [#tblSpreadRefRate])
BEGIN
	Declare @Liborpercentage decimal(28,15) = (select top 1 Value from [#tblSpreadRefRate] where TrType = 'LIBORPercentage'  order by date asc);
	Declare @Spreadpercentage decimal(28,15) = (select top 1 Value from [#tblSpreadRefRate]  where TrType = 'SpreadPercentage'  order by date asc);


	UPDATE CRe.TransactionEntry SET cre.TransactionEntry.IndexValue = z.IndexValue,cre.TransactionEntry.SpreadValue = z.SpreadValue
	FROM(
		select tr.TransactionEntryID,n.NoteID,tr.date,ISNULL(x.Value,@Liborpercentage) as IndexValue,ISNULL(y.Value,@Spreadpercentage) as SpreadValue	
		,tr.Type 
		from cre.TransactionEntry tr
		Inner Join cre.note n on n.account_accountid = tr.AccountID
		outer apply(
					select top 1 sp.Date,sp.Value from [#tblSpreadRefRate] sp 
					where sp.TrType='LIBORPercentage' and sp.NoteID = n.NoteID and sp.Date < tr.Date 
					order by date desc
				) as x
		outer apply(
					select top 1 sp.Date,sp.Value from [#tblSpreadRefRate] sp 
					where sp.TrType='SpreadPercentage' and sp.NoteID = n.NoteID and sp.Date < tr.Date 
					order by date desc
				) as y
		where 
		analysisid = @AnalysisID
		and tr.AccountID= @AccountID
		and tr.Type in ('InterestPaid','StubInterest')
	)z
	WHERE z.TransactionEntryID= CRe.TransactionEntry.TransactionEntryID


END


END