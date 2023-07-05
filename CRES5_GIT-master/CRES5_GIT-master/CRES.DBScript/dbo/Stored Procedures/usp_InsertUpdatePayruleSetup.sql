
CREATE PROCEDURE [dbo].[usp_InsertUpdatePayruleSetup]

 @PayruleSetup [TableTypePayruleSetup] READONLY,
 @UpdatedBy [nvarchar](256) ,
 @DealID  [nvarchar](256) 

AS
BEGIN
    SET NOCOUNT ON;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--INSERT INTO [dbo].[temp] ([DealID],[StripTransferFrom],[StripTransferTo],[Value],[RuleID])
--Select [DealID],[StripTransferFrom],[StripTransferTo],[Value],[RuleID] from @PayruleSetup


IF EXISTS(
	Select t.dealid from @PayruleSetup t
	full join 
	(
		Select [DealID],[StripTransferFrom],[StripTransferTo],[Value],[RuleID] ,payrulesetupID
		from cre.payrulesetup  where dealid = @DealID
	)ps on 	t.DealID = ps.DealID
	and t.StripTransferFrom = ps.StripTransferFrom
	and t.StripTransferTo = ps.StripTransferTo
	and t.Value = ps.Value
	and t.RuleID = ps.RuleID
	where (ps.DealID is null or t.dealid is null)
)
BEGIN
	--Print('Changed')


Declare @InActive as nvarchar(256);
Declare @Active as nvarchar(256);
Declare @FeeCouponStripReceivable  int  = 20;
set @InActive= 2;
set @Active= 1;


----======Insert Activity Log=============================================================
--Add Deleted activity
INSERT INTO [App].[ActivityLog]([ParentModuleID],[ParentModuleTypeID],[ModuleID],[ActivityType],[DisplayMessage],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
SELECT distinct @DealID,283,[StripTransferFrom],415,'Deleted',@UpdatedBy,GETDATE(),@UpdatedBy,GETDATE() 
From(
	Select DealID,StripTransferFrom from CRE.PayruleSetup where [DealID]= @DealID
	except
	Select DealID,StripTransferFrom from @PayruleSetup  where [DealID]= @DealID
)a

--Add Inserted activity
INSERT INTO [App].[ActivityLog]([ParentModuleID],[ParentModuleTypeID],[ModuleID],[ActivityType],[DisplayMessage],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
SELECT distinct @DealID,283,[StripTransferFrom],415,'Inserted',@UpdatedBy,GETDATE(),@UpdatedBy,GETDATE() 
From(
	Select DealID,StripTransferFrom from @PayruleSetup  where [DealID]= @DealID
	except
	Select DealID,StripTransferFrom from CRE.PayruleSetup where [DealID]= @DealID	
)a

--Add Updated activity
INSERT INTO [App].[ActivityLog]([ParentModuleID],[ParentModuleTypeID],[ModuleID],[ActivityType],[DisplayMessage],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
select  distinct @DealID,283,StripTransferFrom,415,'Updated',@UpdatedBy,GETDATE(),@UpdatedBy,GETDATE()
From(
	Select DealID,StripTransferFrom,StripTransferTo,Value,RuleID from @PayruleSetup  where [DealID]= @DealID
	except
	Select DealID,StripTransferFrom,StripTransferTo,Value,RuleID from CRE.PayruleSetup where [DealID]= @DealID
)a
----===================================================================

--delete from CRE.PayruleSetup where DealID=@DealID
--delete from CRE.PayruleDistributions where SourceNoteID in (select NoteID from cre.Note where DealID=@DealID ) or ReceiverNoteID in (select NoteID from cre.Note where DealID=@DealID )
--Delete from core.[FeeCouponStripReceivable] where eventid in (Select eventid from core.Event WHERE EventTypeID = @FeeCouponStripReceivable and AccountID in (Select Account_AccountID from CRE.NOte where DealID=@DealID))
--Delete from core.Event WHERE EventTypeID = @FeeCouponStripReceivable and AccountID in (Select Account_AccountID from CRE.NOte where DealID=@DealID)

IF OBJECT_ID('tempdb..[#tblnotelist]') IS NOT NULL                                         
	DROP TABLE [#tblnotelist]

CREATE TABLE [#tblnotelist](
	NoteID UNIQUEIDENTIFIER,
	Account_AccountID UNIQUEIDENTIFIER
)
INSERT INTO [#tblnotelist] (NoteID,Account_AccountID)
select NoteID,Account_AccountID from cre.Note where DealID=@DealID
------------------------------------------------------------------

IF OBJECT_ID('tempdb..[#tblFeeCoupon_EventAutoID]') IS NOT NULL                                         
	DROP TABLE [#tblFeeCoupon_EventAutoID]

CREATE TABLE [#tblFeeCoupon_EventAutoID](
	FeeCouponStripReceivableAutoID int,
	EventAutoID int
)
INSERT INTO [#tblFeeCoupon_EventAutoID](FeeCouponStripReceivableAutoID,EventAutoID)
Select fc.FeeCouponStripReceivableAutoID,e.EventAutoID from core.[FeeCouponStripReceivable] fc
inner join core.event e on e.eventid = fc.eventid and EventTypeID = 20
inner join core.account acc on acc.accountid = e.accountid
where e.accountid in (Select Account_AccountID from [#tblnotelist])
------------------------------------------------------------------

-----Delete existing payrules data
Delete from CRE.PayruleSetup where PayruleSetupAutoID in (Select PayruleSetupAutoID from CRE.PayruleSetup where  DealID=@DealID)
Delete from CRE.PayruleDistributions where PayruleDistributionsAutoID in (Select PayruleDistributionsAutoID from CRE.PayruleDistributions where SourceNoteID in (Select NoteID from [#tblnotelist]) or ReceiverNoteID in (Select NoteID from [#tblnotelist]) )

Delete from core.[FeeCouponStripReceivable] where FeeCouponStripReceivableAutoID in (Select FeeCouponStripReceivableAutoID from [#tblFeeCoupon_EventAutoID])
Delete from core.Event WHERE EventAutoID in (Select EventAutoID from [#tblFeeCoupon_EventAutoID])
------------------------------------------------------------------

INSERT INTO [CRE].[PayruleSetup]
(		   
 [DealID]
,[StripTransferFrom]
,[StripTransferTo]
,[Value]
,[RuleID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
)
	Select	
		ps.DealID,
		StripTransferFrom,
		StripTransferTo,
		Value,
		RuleID,
		@UpdatedBy,
		GETDATE(),
		@UpdatedBy,
		GETDATE()
	FROM @PayruleSetup ps 
	INNER JOIN [CRE].[Note] nFrom ON ps.StripTransferFrom=nFrom.NoteID
	inner join Core.Account aFrom on aFrom.AccountID=nFrom.Account_AccountID
	where isnull(aFrom.StatusID, @Active)!= @InActive and aFrom.IsDeleted=0

	----Call Calculator
	--declare @TableTypeCalculationRequests TableTypeCalculationRequests
	--insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText)
	--Select NoteId,'Processing',@UpdatedBy,'Real Time' From Cre.Note where dealid=@DealID
	--exec  [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UpdatedBy,@UpdatedBy 


END


SET TRANSACTION ISOLATION LEVEL READ COMMITTED

    
END
