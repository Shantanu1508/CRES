--   [dbo].[usp_GetAllExceptionsByObjectIDandObjectName] '00000000-0000-0000-0000-000000000000','Calc','7114,12132,2401,RXR_Mezz - Protect Adv', '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000'
--  [dbo].[usp_GetAllExceptionsByObjectIDandObjectName] '00000000-0000-0000-0000-000000000000','Note','','00000000-0000-0000-0000-000000000000','56EE82E7-4E29-477D-9367-37A440AAAC20'

CREATE PROCEDURE [dbo].[usp_GetAllExceptionsByObjectIDandObjectName] -- 'b59b1166-cf70-41f4-a53e-f9228db01f35','Deal',null,'00000000-0000-0000-0000-000000000000'
 @DealID uniqueidentifier = '00000000-0000-0000-0000-000000000000', 
 @Type nvarchar(256),
 @MultipleNoteids nvarchar(max) = null,
 @ScenarioId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
 @NoteID uniqueidentifier = '00000000-0000-0000-0000-000000000000'
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


IF(@Type = 'Deal')
BEGIN
	select 
	 n.CRENoteID
	,ac.Name
	--,exc.[ObjectID]
	--,exc.[ObjectTypeID]
	,exc.FieldName
	,exc.[Summary]
	,lActionLevel.Name as [Exception type]
	--,exc.[CreatedBy]
	,exc.[CreatedDate] as [Exception date]
	--,exc.[UpdatedBy]
	--,exc.[UpdatedDate]
	from core.Exceptions exc
	Inner join cre.Note n on n.noteID=exc.ObjectID and n.dealid = @DealID
	INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
	left join core.Lookup lActionLevel on lActionLevel.LookupID=exc.ActionLevelID 
	where n.dealid=@DealID
	and ac.isdeleted=0 
 END

ELSE IF(@Type = 'Calc')
BEGIN
	CREATE TABLE #tblListNotes(
	  CRENoteID VARCHAR(256)
	)

	INSERT INTO #tblListNotes(CRENoteID)
	select Value from fn_Split(@MultipleNoteids);

	select distinct 
			--exc.[ObjectID] as ObjectID
			n.CRENoteID as CRENoteID
			 ,ac.Name as Name
			 ,exc.FieldName
			 ,exc.[Summary] as Summary
			,lActionLevel.Name as [Exception type]
			,exc.[CreatedDate] as [Exception date]
			 --,(select max([UpdatedDate]) from core.Exceptions where ObjectID=exc.ObjectID) as UpdatedDate
			-- ,d.DealName
			-- ,d.DealID
			-- ,d.CREDealID
	from  core.Exceptions exc 
	Inner join cre.Note n on n.noteID=exc.ObjectID
	left join cre.Deal d on d.DealID = n.DealID
	inner join #tblListNotes tbl on tbl.CRENoteID = n.CRENoteID
	INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
	left join core.Lookup lActionLevel on lActionLevel.LookupID=exc.ActionLevelID
	where ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME='note' ) 
	and ac.IsDeleted=0 
	and (exc.ActionLevelID = 293 or exc.ActionLevelID=294)
	and ac.statusid <> 2

	ORDER BY [Exception type],[Exception date] DESC

	Drop Table #tblListNotes;
END
ELSE IF(@Type ='Scenario')
BEGIN
	select distinct 
			--exc.[ObjectID] as ObjectID
			n.CRENoteID as CRENoteID
			 ,ac.Name as Name
			 ,exc.FieldName
			 ,exc.[Summary] as Summary
			,lActionLevel.Name as [Exception type]
			,exc.[CreatedDate] as [Exception date]
			-- ,(select max([UpdatedDate]) from core.Exceptions where ObjectID=exc.ObjectID) as UpdatedDate
			-- ,d.DealName
			-- ,d.DealID
			-- ,d.CREDealID
	from  core.Exceptions exc 
	Inner join cre.Note n on n.noteID=exc.ObjectID
	left join cre.Deal d on d.DealID = n.DealID
	INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
	left join core.Lookup lActionLevel on lActionLevel.LookupID=exc.ActionLevelID
	where ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME='note' ) 
	and ac.IsDeleted=0 
	and (exc.ActionLevelID = 293 or exc.ActionLevelID=294)
	and ac.statusid <> 2

	ORDER BY [Exception type],[Exception date] DESC
END
ELSE IF (@Type= 'Note')
BEGIN
		select ac.Name
		,n.CRENoteID
		--,exc.[ObjectID]
		--,exc.[ObjectTypeID]
		,exc.FieldName
		,exc.[Summary]
		,lActionLevel.Name as [Exception type]
		--,exc.[CreatedBy]
		,exc.[CreatedDate] as [Exception date]
		--,exc.[UpdatedBy]
		--,exc.[UpdatedDate]
		from core.Exceptions exc
		Inner join cre.Note n on n.noteID=exc.ObjectID
		 INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
		left join core.Lookup lActionLevel on lActionLevel.LookupID=exc.ActionLevelID 
		 where ObjectID=@NoteID and ObjectTypeID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=27 AND NAME='note' ) and ac.isdeleted=0
END


SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END





