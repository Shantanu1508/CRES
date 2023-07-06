
 --Select MAX(UpdatedDate) as UpdatedDate from cre.DealFunding where dealid ='1A10B185-2BB2-4965-B47E-1760D084910D' 
--'FC977090-A4D7-4360-BE52-FAEFAB844745'

CREATE PROCEDURE [dbo].[usp_CheckConcurrentUpdate] 	--'1A10B185-2BB2-4965-B47E-1760D084910D','Deal','2018-05-25 16:35:01.900'
	@ObjectID Uniqueidentifier,
	@ModuleName nvarchar(256),
	@UpdatedDate DateTime
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
IF(@ModuleName = 'Deal')
BEGIN
	IF (Select abs(DATEDIFF(DAY,MAX(UpdatedDate),@UpdatedDate)) from cre.DealFunding where DealId=@ObjectID) > 1
	BEGIN
		select (CASE When EXISTS (SELECT 1 WHERE df.UpdatedBy  LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
		THEN (select  top 1 u.[Login]  from CRE.DealFunding  sdf left join App.[User]  u  on u.UserID =  df.UpdatedBy ) 
		ELSE df.UpdatedBy  END) as UpdatedBy , MAX(df.UpdatedDate)  as UpdatedDate
		from cre.DealFunding df 
		where DealID=@ObjectID
		group by df.UpdatedBy
		
	END
	ELSE
	BEGIN
		IF (Select abs(DATEDIFF(MILLISECOND,MAX(UpdatedDate),@UpdatedDate)) from cre.DealFunding where DealId=@ObjectID) > 1000
		BEGIN
			select (CASE When EXISTS (SELECT 1 WHERE df.UpdatedBy  LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
			THEN (select  top 1 u.[Login]  from CRE.DealFunding  sdf left join App.[User]  u  on u.UserID =  df.UpdatedBy ) 
			ELSE df.UpdatedBy  END) as UpdatedBy , MAX(df.UpdatedDate)  as UpdatedDate
			from cre.DealFunding df 
			where DealID=@ObjectID
			group by df.UpdatedBy
		END
		ELSE
		BEGIN
			select null as UpdatedBy , null  as UpdatedDate
		END
	END
END

IF(@ModuleName = 'Note')
BEGIN

	Declare @Max_UpdatedDateFF Datetime;
	Declare @UpdatedByFF nvarchar(256);
	

	Select  @Max_UpdatedDateFF = MAX(fs.UpdatedDate),
	@UpdatedByFF = (CASE When EXISTS (SELECT 1 WHERE fs.UpdatedBy  LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
	THEN (select  top 1 u.[Login]  from CRE.DealFunding  sdf left join App.[User]  u  on u.UserID =  fs.UpdatedBy ) 
	ELSE fs.UpdatedBy  END)
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
					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
					and n.NoteID = @ObjectID  and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	group by fs.UpdatedBy



	IF ( Select abs(DATEDIFF(DAY,@Max_UpdatedDateFF,@UpdatedDate)) ) > 1
	BEGIN
		select @UpdatedByFF as UpdatedBy , @Max_UpdatedDateFF  as UpdatedDate		
	END
	ELSE
	BEGIN
	
		IF ( Select abs(DATEDIFF(MILLISECOND,@Max_UpdatedDateFF,@UpdatedDate)) ) > 1000
		BEGIN
			select @UpdatedByFF as UpdatedBy , @Max_UpdatedDateFF  as UpdatedDate
		END
		ELSE
		BEGIN
			select null as UpdatedBy , null  as UpdatedDate
		END
	END

END

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
