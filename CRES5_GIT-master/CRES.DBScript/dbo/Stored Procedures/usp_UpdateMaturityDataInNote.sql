CREATE PROCEDURE [dbo].[usp_UpdateMaturityDataInNote]  
@DealID UNIQUEIDENTIFIER,
@UserID UNIQUEIDENTIFIER
AS  
BEGIN  
    SET NOCOUNT ON;  




	--Update latest Initial Maturity in note
	Update cre.note set 
	cre.note.SelectedMaturityDate = z.maturityDate
	--cre.note.InitialMaturityDate = z.maturityDate
	From(

		Select  n.noteid,mat.maturityType,mat.maturityDate,mat.Approved
		from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN   
		(          
			Select   
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 11  and eve.StatusID = 1
			and acc.IsDeleted = 0  
			and n.dealid = @DealID
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	
		where mat.maturityType = 708 
		and	mat.Approved = 3
		and n.dealid = @DealID

	)z
	where z.noteid = cre.note.noteid



	--Update latest Fully Extended Maturity Date in note

	Update cre.note set cre.note.FullyExtendedMaturityDate = z.maturityDate
	From(

		Select  n.noteid,mat.maturityType,mat.maturityDate,mat.Approved
		from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN   
		(          
			Select   
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 11  and eve.StatusID = 1
			and acc.IsDeleted = 0  
			and n.dealid = @DealID
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	
		where mat.maturityType = 710
		and	mat.Approved = 3
		and n.dealid = @DealID

	)z
	where z.noteid = cre.note.noteid


	---Update Current Extended Maturity in ExtendedMaturityCurrent column
	Update cre.note set cre.note.ExtendedMaturityCurrent = z.ExtendedMaturityCurrent
	From(

		Select n.noteid,tblExt.ExtendedMaturityCurrent
		from cre.note n
		inner join core.account acc on acc.accountid = n.account_accountid
		Left Join(
			Select noteid,ExtendedMaturityCurrent
			From(
				Select n.noteid,mat.MaturityDate as ExtendedMaturityCurrent,
				ROW_NUMBER() Over(Partition by noteid order by noteid,mat.MaturityDate desc) rno
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11  
					and acc.IsDeleted = 0  
					and n.dealid = @DealID
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				where mat.MaturityType = 709 
				and mat.Approved = 3
				--and mat.MaturityDate <= CAST(getdate() as date)
				and n.dealid = @DealID

			)a where rno = 1
		)tblExt on tblExt.noteid = n.noteid
		where acc.isdeleted <> 1

	)z
	where z.noteid = cre.note.noteid





		--Update cre.note set 
	--cre.note.ActualPayoffDate = z.ActualPayoffDate,
	--cre.note.ExpectedMaturityDate = z.ExpectedMaturityDate,
	--cre.note.OpenPrepaymentDate = z.OpenPrepaymentDate
	--From(
	--	Select noteid,[ActualPayoffDate],[ExpectedMaturityDate],[OpenPrepaymentDate]
	--	From(
	--		Select  n.noteid,(CASE WHEN mat.MaturityType = 711 THEN 'ActualPayoffDate' WHEN mat.MaturityType = 712 THEN 'ExpectedMaturityDate' WHEN mat.MaturityType = 713 THEN 'OpenPrepaymentDate' END) as  MaturityType,mat.MaturityDate
	--		from [CORE].Maturity mat  
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	--		INNER JOIN   
	--		(          
	--			Select   
	--			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
	--			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
	--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
	--			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
	--			where EventTypeID = 11  and eve.StatusID = 1
	--			and acc.IsDeleted = 0  
	--			and n.dealid = @DealID
	--			GROUP BY n.Account_AccountID,EventTypeID    
	--		) sEvent    
	--		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
	--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	--		where mat.MaturityType in (711,712,713)
	--		and n.dealid = @DealID

	--	) AS SourceTable  
	--	PIVOT  
	--	(  
	--		MIN(MaturityDate)  
	--		FOR MaturityType IN ([ActualPayoffDate],[ExpectedMaturityDate],[OpenPrepaymentDate])  
	--	) AS PivotTable

	--)z
	--where z.noteid = cre.note.noteid
END