--[usp_RefreshCalculationRequestsTEST1] 'cab9ab7a-9794-4a8d-bc81-a2125e3db631'
CREATE FUNCTION [dbo].[fn_GetCalculationRequestsInActiveNotes] 
(
@PortfolioMasterGuid uniqueidentifier,
@AnalysisID uniqueidentifier
)
RETURNS

      @Result TABLE(CRENoteID varchar(50))
AS
BEGIN
	
  declare @cashflowEngineId int;

Select @cashflowEngineId=lookupid from core.Lookup where ParentID=47 and Name='Default'
declare @maturityDateID int
declare @currDate  datetime
declare @FilterDate datetime
declare @FilterStartDate date
declare @FilterEndDate date
declare @ObjectTypeCount int = 0
declare @ObjectTypeID int = 0
declare @ObjectID int = 0

set @currDate = getdate()

if (@PortfolioMasterGuid is null or @PortfolioMasterGuid='00000000-0000-0000-0000-000000000000')
  BEGIN
		insert into @Result
		
		SELECT 
			   distinct 
			  n.CRENoteID
			  from  CRE.Note n
			  left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountId and cr.AnalysisID=@AnalysisID
			  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  inner join cre.Deal d on n.DealId = d.DealId
			  left join Core.Lookup l ON cr.[StatusID]=l.LookupID
			  left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID
			  left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID
			  left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
			  where  
			  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
			 and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null)
			 and ac.IsDeleted=0
			 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='inactive')
			 and cr.CalcType  = 775
  END
  ELSE
  BEGIN
	--get notes based on filter criteria
	
	select @ObjectTypeCount = count(distinct ObjectTypeID) from core.PortfolioMaster pm join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID
	where pm.PortfolioMasterGuid=@PortfolioMasterGuid and ObjectID not in (6,458,527)
	if (@ObjectTypeCount=1 or @ObjectTypeCount=0)
	begin

	 select distinct @ObjectTypeID =  ObjectTypeID,@ObjectID=ObjectID from core.PortfolioMaster pm join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID
	 where pm.PortfolioMasterGuid=@PortfolioMasterGuid and ObjectID not in (6,458,527)
	 if (@ObjectTypeID =510)
	 begin
	    insert into @Result
		
		SELECT 
			   distinct n.CRENoteID
			  from  CRE.Note n
			  left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountID and cr.AnalysisID=@AnalysisID
			  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  inner join cre.Deal d on n.DealId = d.DealId
			  left join Core.Lookup l ON cr.[StatusID]=l.LookupID
			  left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID
			  left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID
			  left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
			  where  
			  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
			 and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null)
			 and ac.IsDeleted=0
			 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='inactive')
			 and 
			 n.NoteID in 
			 (
			 select n.NoteID from cre.note n where 
				ClientID in 
				(
				select  pd.ObjectID from core.PortfolioMaster pm join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID
				where pm.PortfolioMasterGuid=@PortfolioMasterGuid and ObjectTypeID =510
				)
			 )
			 and  cr.CalcType  = 775
	 
	 end
	 else if (@ObjectTypeID =511)
	 begin
	     insert into @Result
		
		SELECT 
			   distinct n.CRENoteID
			  from  CRE.Note n
			  left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountID and cr.AnalysisID=@AnalysisID
			  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  inner join cre.Deal d on n.DealId = d.DealId
			  left join Core.Lookup l ON cr.[StatusID]=l.LookupID
			  left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID
			  left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID
			  left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
			  where  
			  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
			 and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null)
			 and ac.IsDeleted=0
			 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='inactive')
			 and
			 n.NoteID in 
			 (
			 select n.NoteID from cre.note n where 
				PoolID in 
				(
				select  pd.ObjectID from core.PortfolioMaster pm join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID
				where pm.PortfolioMasterGuid=@PortfolioMasterGuid and ObjectTypeID =511
				)
			 )
			 and  cr.CalcType  = 775
	 end
	 else
	 begin
	 insert into @Result
		
		SELECT 
			   distinct n.CRENoteID
			  from  CRE.Note n
			  left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountID and cr.AnalysisID=@AnalysisID
			  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  inner join cre.Deal d on n.DealId = d.DealId
			  left join Core.Lookup l ON cr.[StatusID]=l.LookupID
			  left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID
			  left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID
			  left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
			  where  
			  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
			 and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null)
			 and ac.IsDeleted=0
			 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='inactive')
			 and  cr.CalcType  = 775
			 
	 end
	end
	else if (@ObjectTypeCount=2)
	begin
	   --client+pool
	   if (  (select count(ObjectTypeID) from
		(
         select distinct ObjectTypeID from core.PortfolioMaster pm join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID
	     where pm.PortfolioMasterGuid=@PortfolioMasterGuid and (ObjectTypeID =510 or ObjectTypeID =511 ) and ObjectID not in (6,458,527)

		 ) tbl)=2)
	  
		 begin
		 insert into @Result
		select CRENoteID from 
		(
			SELECT 
				   distinct n.[NoteId]			  
				  ,ac.[Name]
				  ,[RequestTime]
				  ,cr.[StatusID]
				  ,l.[Name] as StatusText
				  ,cr.[UserName]
				  ,cr.[ApplicationID]
				  ,lApplication.[Name] as ApplicationText
				  ,cr.[StartTime]
				  ,cr.[EndTime]
				  ,cr.[PriorityID]
				  ,lPriority.[Name] as PriorityText
				  ,cr.[ErrorMessage]
				  ,cr.[ErrorDetails]
				  ,n.DealId
				  ,d.DealName
				  ,n.CRENoteID
				  ,n.CashflowEngineID
				  from  CRE.Note n
				  left join Core.CalculationRequests cr on n.Account_AccountID=cr.AccountID and cr.AnalysisID=@AnalysisID
				  left JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
				  inner join cre.Deal d on n.DealId = d.DealId
				  left join Core.Lookup l ON cr.[StatusID]=l.LookupID
				  left join Core.Lookup lPriority ON cr.[PriorityID]=lPriority.LookupID
				  left join Core.Lookup lApplication ON cr.[ApplicationID]=lApplication.LookupID
				  left join Core.Lookup lstaus on lstaus.LookupID = ac.StatusID and ac.IsDeleted=0 
				  where  
				  n.noteID not in (select distinct ObjectID FROM CORE.Exceptions where ActionLevelID=(SELECT LookupID FROM Core.Lookup WHERE ParentId=46 AND NAME='Critical') )
				 and (n.CashflowEngineID=@cashflowEngineId or n.CashflowEngineID is null)
				 and ac.IsDeleted=0
				 and ISNULL(ac.StatusID,1) = (select LookupID from Core.Lookup where  ParentID=1 and Name='inactive')
				 and 
				 n.NoteID in 
				 (
				 select n.NoteID from cre.note n where 
					ClientID in 
					(
					select  pd.ObjectID from core.PortfolioMaster pm join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID
					where pm.PortfolioMasterGuid=@PortfolioMasterGuid and ObjectTypeID =510
					)
				 )
				 and  cr.CalcType  = 775

			 ) tblclient
			 where tblclient.NoteID in 
			 (
			 select n.NoteID from cre.note n where 
				PoolID in 
				(
				select  pd.ObjectID from core.PortfolioMaster pm join core.PortfolioDetail pd on pm.PortfolioMasterID = pd.PortfolioMasterID
				where pm.PortfolioMasterGuid=@PortfolioMasterGuid and ObjectTypeID =511
				)
			 )
			 
			
		 end
	end
	  END

     			
	RETURN
END



