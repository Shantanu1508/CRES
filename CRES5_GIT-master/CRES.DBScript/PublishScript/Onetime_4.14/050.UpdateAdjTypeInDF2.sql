IF OBJECT_ID('tempdb..#tblUpdatedAdjustmentType') IS NOT NULL         
	DROP TABLE #tblUpdatedAdjustmentType

CREATE TABLE #tblUpdatedAdjustmentType(              
  DealFundingID	UNIQUEIDENTIFIER,
  credealid	 nvarchar(256),
  dealid	UNIQUEIDENTIFIER,
  [date]	date,
  purposeID	int,
  UpdatedAdjustmentType int
 ) 


INSERT INTO #tblUpdatedAdjustmentType(DealFundingID,credealid,dealid,date,purposeID,UpdatedAdjustmentType)
Select df.DealFundingID,sheet.credealid, sheet.dealid,sheet.[date],sheet.purposeID,sheet.[UpdatedAdjustmentType]
From(
	Select d.credealid,d.dealid,ex.date,lpurpose.LookupID as purposeID,ladj.lookupid as [UpdatedAdjustmentType],ex.Comment,ex.[Sum of Amount]
	from [dbo].[UpdateAdjTypeInDF$] ex
	Inner join cre.deal d on d.credealid = ex.[Deal ID]
	Inner join core.lookup lpurpose on lpurpose.name = ex.[Purpose Type] and lpurpose.parentid =50
	Inner join core.lookup ladj on ladj.name = ex.[Updated Adjustment Type] and ladj.parentid =141
)sheet

Inner Join(
	Select df.DealFundingID,df.dealid,df.date,df.purposeid ,df.Comment,df.Amount
	from cre.DealFunding df
	Inner join cre.deal d on d.dealid = df.dealid
	where d.isdeleted<>1 and Applied = 1
)df on df.DealID = sheet.dealid and  df.date = sheet.date and  df.PurposeID = sheet.PurposeID and  df.Comment = sheet.Comment and  df.Amount = sheet.[Sum of Amount]
order by sheet.credealid
----=========================================================


Update cre.DealFunding SET cre.DealFunding.AdjustmentType = z.UpdatedAdjustmentType
From(
	Select DealFundingID,UpdatedAdjustmentType from #tblUpdatedAdjustmentType
)z
where z.DealFundingID = cre.DealFunding.DealFundingID




Update [CORE].FundingSchedule SET [CORE].FundingSchedule.AdjustmentType = y.UpdatedAdjustmentType
From(

	Select fs.FundingScheduleID, fs.DealFundingID ,uadj.UpdatedAdjustmentType
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN (					
		Select 
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
		--and n.NoteID = @NoteId  
		and acc.IsDeleted = 0
		and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
		GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	left JOIN [CORE].[Lookup] LAdjustmentType ON LAdjustmentType.LookupID = fs.AdjustmentType 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

	Inner join #tblUpdatedAdjustmentType uadj on uadj.DealFundingID = fs.DealFundingID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0


)y
where y.FundingScheduleID = [CORE].FundingSchedule.FundingScheduleID

