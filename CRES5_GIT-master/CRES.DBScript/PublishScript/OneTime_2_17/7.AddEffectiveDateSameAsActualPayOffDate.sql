GO

--Print('Add Effective date same as ActualPayOffDate')
Go

--DECLARE @tblMaturityDataForNote [TableTypeMaturityDataForNote]

--INSERT INTO @tblMaturityDataForNote(NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate)  	
--Select  n.NoteID,n.ActualPayoffDate as EffectiveStartDate,MaturityDate,MaturityType,Approved,IsDeleted,n.ActualPayoffDate,n.ExpectedMaturityDate,n.OpenPrepaymentDate
--from [CORE].Maturity mat  
--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--INNER JOIN   
--(          
--	Select   
--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--	where EventTypeID = 11  and eve.StatusID = 1
--	and acc.IsDeleted = 0  				
--	GROUP BY n.Account_AccountID,EventTypeID    
--) sEvent    
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
--where n.actualPayoffdate is not null and acc.isdeleted <> 1


--exec [dbo].[usp_InsertUpdateMaturitySchedule] @tblMaturityDataForNote,'B0E6697B-3534-4C09-BE0A-04473401AB93'


--go

go

---Update Extention to appruval
Declare @UserID UNIQUEIDENTIFIER;
SET @UserID = (Select UserID from app.[user] where [Login] = 'Sys_Scheduler')

Update [CORE].Maturity set Approved = 3,IsAutoApproved = 1,UpdatedBy = @UserID,UpdatedDate = getdate()
Where MaturityID in (
	Select mat.MaturityID  --n.noteid,mat.* 
	from [CORE].Maturity mat  
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	INNER JOIN   
	(         
		Select   
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		where EventTypeID = 11 and eve.StatusID = 1
		--and n.NoteID = @NoteID  
		and acc.IsDeleted = 0  
		GROUP BY n.Account_AccountID,EventTypeID    
	) sEvent    
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    

	where acc.isdeleted <> 1
	and n.ActualPayOffDate is null
	and mat.maturityType = 709  
	and ISNULL(Approved,4) <> 3
	and MaturityDate <= Cast(getdate() as Date)
	--and n.crenoteid = '2567'

)



----Update Next Extention (If current maturity passed)
Update [CORE].Maturity set Approved = 3,IsAutoApproved = 1,UpdatedBy = @UserID,UpdatedDate = getdate()
Where MaturityID in (

	Select z.MaturityID
	From(
		Select  n.noteid,mat.MaturityID,mat.MaturityDate,tblInitialMat.MaturityDate as InitialMatDate,
		ISNULL(mat.Approved,4) as Approved,ROW_NUMBER() OVER (Partition by n.noteid Order by n.noteid,mat.MaturityDate) as rno
		from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN   
		(         
			Select   
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 11 and eve.StatusID = 1
			--and n.NoteID = @NoteID  
			and acc.IsDeleted = 0  
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID    
		LEFT JOIN(
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
				GROUP BY n.Account_AccountID,EventTypeID    
			) sEvent    
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 		
			where mat.maturityType = 708 
			and	mat.Approved = 3			
		)tblInitialMat on tblInitialMat.noteid = n.noteid

		where acc.isdeleted <> 1
		and n.ActualPayOffDate is null
		and mat.maturityType = 709  	
		and mat.MaturityDate > Cast(getdate() as Date)
		---and n.crenoteid in ('10331')  ---( '10331','10801')
	)z
	where z.rno = 1 and z.Approved = 4 and InitialMatDate < Cast(getdate() as date)

)


go





----UpdateCurrentExtendedMaturityInNote
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
					--and n.dealid = @DealID
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				where mat.MaturityType = 709 
				and mat.Approved = 3
				--and mat.MaturityDate <= CAST(getdate() as date)
				--and n.dealid = @DealID

			)a where rno = 1
		)tblExt on tblExt.noteid = n.noteid
		where acc.isdeleted <> 1

	)z
	where z.noteid = cre.note.noteid

---and n.crenoteid = '2230' 