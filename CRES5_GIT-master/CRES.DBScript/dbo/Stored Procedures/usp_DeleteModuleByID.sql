-- Procedure
--[dbo].[usp_DeleteModuleByID] 'b0e6697b-3534-4c09-be0a-04473401ab93',"Deal",'f4c26166-9808-480c-ba65-a259331e796b',0
CREATE PROCEDURE [dbo].[usp_DeleteModuleByID] --'1479'
(
	@UserId Uniqueidentifier,
	@ModuleName nvarchar(256),
	@ModuleID Uniqueidentifier,
	@LookupID int
)
AS
BEGIN
    declare @AccountID uniqueidentifier,@DeleteCount int=0
	IF(@ModuleName = 'Note')
	BEGIN
		
		select @AccountID = AccountID from Core.Account c join CRE.Note n on c.AccountID=n.Account_AccountID WHERE n.NoteID = @ModuleID
		
		IF (@LookupID=null or @LookupID = 0) --delete whole note
		BEGIN
			--delete note (soft delete)
			UPDATE Core.Account set IsDeleted=1,UpdatedDate=getdate(),UpdatedBy=@UserId where AccountID = @AccountID
			
			update cre.note set CRENoteID = CRENoteID + '_deleted_'+replace(convert(varchar, getdate(),101),'/','') + replace(convert(varchar, getdate(),114),':','')
			,UpdatedDate=getdate(),UpdatedBy=@UserId 
			where  Account_AccountID = @AccountID

			--delete all SearchItem associated with this note (hard delete)
			DELETE FROM App.SearchItem WHERE Object_ObjectAutoID  in 
			(
				SELECT ObjectAutoID FROM App.Object WHERE objectID=@ModuleID
			)
			--delete object associated with this note (hard delete)
			DELETE FROM App.Object WHERE objectID=@ModuleID

			--delete note from DW schema tables associated with this note
			--DELETE FROM [DW].[L_DailyCalcBI] where AccountID = @AccountID
			--DELETE FROM [DW].[DailyCalcBI] where AccountID = @AccountID
			--DELETE FROM [DW].[L_NoteBI] where AccountID = @AccountID
			--DELETE FROM [DW].[NoteBI] where AccountID = @AccountID
			--DELETE FROM [DW].[L_NotePeriodicCalcBI] WHERE NoteID = @ModuleID
			--DELETE FROM [DW].[NotePeriodicCalcBI] WHERE NoteID = @ModuleID
			--DELETE FROM [DW].[L_TransactionBI] where AccountID = @AccountID
			--DELETE FROM [DW].[TransactionBI] where AccountID = @AccountID
			--DELETE FROM [DW].[L_TransactionEntryBI] WHERE NoteID = @ModuleID
			--DELETE FROM [DW].[TransactionEntryBI] WHERE NoteID = @ModuleID
			--DELETE FROM [DW].[L_ExceptionsBI] WHERE ObjectID = @ModuleID AND ObjectTypeID=182
			--DELETE FROM [DW].[ExceptionsBI] WHERE ObjectID = @ModuleID AND ObjectTypeID=182

			--delete note from PayruleDistributions,PayruleSetup
			DELETE FROM [CRE].[PayruleDistributions] WHERE [ReceiverNoteID]=@ModuleID or [SourceNoteID]=@ModuleID
			DELETE FROM [CRE].[PayruleSetup] WHERE [StripTransferFrom]=@ModuleID or [StripTransferTo]=@ModuleID

			--delete note from CRE schema tables associated with this note
			--DELETE FROM cre.TransactionEntry where NoteID=@ModuleID
			--DELETE FROM cre.NotePeriodicCalc where NoteID=@ModuleID
			--DELETE FROM core.CalculationRequests where NoteID=@ModuleID
			--DELETE FROM core.DailyCalc where AccountID = @AccountID

			--delete notification of the note
			--DELETE FROM [App].[UserNotification] WHERE ObjectID=@ModuleID and ObjectTypeID=182
		END
		ELSE   --delete specific section from the note
		BEGIN
		    
			IF (@LookupID = 399) --Delete Spread Schedules
			BEGIN
				delete from core.RateSpreadSchedule where eventId in (Select eventID from core.event where EventTypeID = 14   and accountid = @AccountID)
				delete from core.event where EventTypeID = 14 and accountid = @AccountID
				SET @DeleteCount = @@ROWCOUNT
			END
			ELSE IF (@LookupID = 400) --Delete Prepay Fee Schedules
			BEGIN
				delete from core.PrepayAndAdditionalFeeSchedule where eventId in (Select eventID from core.event where EventTypeID = 13   and accountid = @AccountID)
				delete from core.event where EventTypeID = 13 and accountid = @AccountID
				SET @DeleteCount = @@ROWCOUNT
			END
			ELSE IF (@LookupID = 401) --Delete Stripping Schedules
			BEGIN
				delete from core.StrippingSchedule where eventId in (Select eventID from core.event where EventTypeID = 16   and accountid = @AccountID)
				delete from core.event where EventTypeID = 16 and accountid = @AccountID
				SET @DeleteCount = @@ROWCOUNT
			END
			ELSE IF (@LookupID = 402) --Delete Funding Schedules
			BEGIN
				delete from core.FundingSchedule where eventId in (Select eventID from core.event where EventTypeID = 10   and accountid = @AccountID)
				delete from core.event where EventTypeID = 10 and accountid = @AccountID
				
				SET @DeleteCount = @@ROWCOUNT

				--Delete FF from Backshop
				Declare @L_CreNoteId nvarchar(256)
				Declare @L_NoteId UNIQUEIDENTIFIER

				Select @L_CreNoteId = n.crenoteid ,@L_NoteId = n.NoteId
				from cre.note n
				inner join core.account acc on acc.accountid = n.account_accountid
				where n.account_accountid = @AccountID

				IF ((SELECT ISNUMERIC(@L_CreNoteId)) = 1) --Because backshop's procedure take crenoteid as int
				BEGIN
					DECLARE @query nvarchar(256) = N'Select COUNT(noteid) from [acore].[vw_AcctNote] where Noteid = '''+@L_CreNoteId+''''
					DECLARE @NoteCount TABLE (Cnt int,ShardName nvarchar(max))
					INSERT INTO @NoteCount (Cnt,ShardName)
					EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceDataFF', @stmt = @query

					IF ((Select cnt from @NoteCount) > 0) --Check if note exists in backshop database
					BEGIN
						exec sp_NoteFundingsDeleteByNoteId @L_CreNoteId
						--exec sp_NoteFundingsDeleteByNoteIdPIK @L_CreNoteId
					END
				END

			 

			END
			ELSE IF (@LookupID = 403) --Delete Coupon Schedule
			BEGIN
				delete from core.FeeCouponStripReceivable where eventId in (Select eventID from core.event where EventTypeID = 20   and accountid = @AccountID)
				delete from core.event where EventTypeID = 20 and accountid = @AccountID
				SET @DeleteCount = @@ROWCOUNT
			END
			ELSE IF (@LookupID = 404) --Delete Amortization Schedule
			BEGIN
				delete from core.AmortSchedule where eventId in (Select eventID from core.event where EventTypeID = 19   and accountid = @AccountID)
				delete from core.event where EventTypeID = 19 and accountid = @AccountID
				SET @DeleteCount = @@ROWCOUNT
			END
			ELSE IF (@LookupID = 413) --Delete Maturity Schedule
			BEGIN
				delete from core.Maturity where eventId in (Select eventID from core.event where EventTypeID = 11   and accountid = @AccountID)
				delete from core.event where EventTypeID = 11 and accountid = @AccountID
				SET @DeleteCount = @@ROWCOUNT
			END
			ELSE IF (@LookupID = 495) --Delete PIK Schedule
			BEGIN
				delete from core.PIKSchedule where eventId in (Select eventID from core.event where EventTypeID = 12   and accountid = @AccountID)
				delete from core.event where EventTypeID = 12 and accountid = @AccountID
				SET @DeleteCount = @@ROWCOUNT

				Update cre.Note set PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = null where Account_AccountID = @AccountID
				---PIKSeparateCompounding = null,
			END
			ELSE IF (@LookupID = 685) --Delete Manual Cashflow
			BEGIN
				IF EXISTS(Select NoteID from cre.Note where EnableM61Calculations = 4 and noteid = @ModuleID)
				BEGIN
					Declare @l_Accountid uniqueidentifier = (Select Account_accountid from cre.note where noteid = @ModuleID)

					Delete From CRE.TransactionEntryManual where AccountID = @l_Accountid  --@ModuleID
					Delete from CRE.TransactionEntry where Accountid = @l_Accountid -- NoteID =@ModuleID
					SET @DeleteCount = @@ROWCOUNT
				END
			END
			ELSE IF (@LookupID = 780) --Delete Market Price
			BEGIN
				Delete from CRE.NoteAttributesbyDate where ValueTypeID = 53 and Noteid in (Select crenoteid from cre.note where noteid = @ModuleID)
				SET @DeleteCount = @@ROWCOUNT
			END


			--set updated by and date
			IF (@LookupID = 399 or @LookupID = 400 or @LookupID = 401 or @LookupID = 402 or @LookupID = 403 or @LookupID = 404 or @LookupID = 413 or @LookupID = 495) 
			BEGIN
				UPDATE Core.Account SET UpdatedDate=getdate(),UpdatedBy=@UserId where AccountID = @AccountID
			END

			--log activity
			IF (@DeleteCount>0)
				exec usp_InsertActivityLog @ModuleID,182,@ModuleID,@LookupID,'deleted',@UserId
		END
		
		--Call Calculator for note
		if not exists(select * from core.Exceptions where ActionLevelID=(select Lookupid from core.Lookup where name='Critical' and ParentID=46)
		and ObjectTypeID=182 and ObjectID= @ModuleID)
		begin
			declare @TableTypeCalculationRequests TableTypeCalculationRequests
			insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText)
			Select @ModuleID,'Processing',@UserId,'Real Time'
			exec  [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@UserId,@UserId, NULL, NULL, 'DeleteNote'
		end
		

	END

	IF(@ModuleName = 'Deal')
	BEGIN
		
		Create Table #Tempobject(objectAutoID uniqueidentifier,ObjectID uniqueidentifier )
		Create Table #TempNotes(AccountID uniqueidentifier,NoteID uniqueidentifier )
		--Create Table #Tempobject(objectAutoID uniqueidentifier,ObjectID uniqueidentifier )
		insert into #TempNotes SELECT Account_AccountID,NoteID FROM CRE.Note n JOIN cORE.ACCOUNT AC ON n.Account_AccountID = AC.AccountID WHERE n.DealID = @ModuleID
		insert into #Tempobject SELECT o.objectAutoID,o.objectID FROM CRE.Note n JOIN App.Object o ON n.NoteID = o.objectID WHERE n.DealID = @ModuleID
		
		IF (@LookupID=null or @LookupID = 0) --delete whole Deal
		BEGIN
			   --delete all notes associated with this deal (soft delete)
			UPDATE Core.Account set IsDeleted=1,UpdatedDate=getdate(),UpdatedBy=@UserId where AccountID in (Select AccountID from #TempNotes)
			
			update cre.note set CRENoteID = CRENoteID + '_deleted_'+replace(convert(varchar, getdate(),101),'/','') + replace(convert(varchar, getdate(),114),':','')
			,UpdatedDate=getdate(),UpdatedBy=@UserId 
			where  Account_AccountID in (Select AccountID from #TempNotes)
			
			--delete deal (soft delete)

			UPDATE Core.Account set IsDeleted=1,UpdatedDate=getdate(),UpdatedBy=@UserId where AccountID in (Select AccountID from cre.deal where DealID = @ModuleID )

			UPDATE CRE.Deal SET IsDeleted=1,UpdatedDate=getdate(),UpdatedBy=@UserId ,CREDealID = CREDealID + '_deleted_'+replace(convert(varchar, getdate(),101),'/','') + replace(convert(varchar, getdate(),114),':','')
			WHERE DealID = @ModuleID 


			--delete all notification associated with this deals note
			DELETE FROM [App].[UserNotification] WHERE  ObjectTypeID=182 AND ObjectID in (SELECT NoteID FROM #TempNotes)

			--delete all notification associated with this deals
			DELETE FROM [App].[UserNotification] WHERE  ObjectTypeID=283 AND ObjectID =@ModuleID
			
			--delete all SearchItem associated with this deal note(hard delete)
			DELETE FROM App.SearchItem WHERE Object_ObjectAutoID  in (select objectAutoID from #Tempobject)
		
			--delete all object associated with the deal note(hard delete)
			DELETE FROM App.Object WHERE ObjectID  in (select objectID from #Tempobject)

			--delete all SearchItem associated with this deal property(hard delete)
			DELETE FROM App.SearchItem WHERE Object_ObjectAutoID  in (SELECT o.objectAutoID FROM CRE.Property p JOIN App.Object o ON p.PropertyID = o.objectID WHERE p.Deal_DealID = @ModuleID)
		
			--delete all object associated with the deal property(hard delete)
			DELETE FROM App.Object WHERE ObjectID  in (SELECT o.objectID FROM CRE.Property p JOIN App.Object o ON p.PropertyID = o.objectID WHERE p.Deal_DealID = @ModuleID)
				
			--delete all SearchItem associated with this deal (hard delete)
			DELETE FROM App.SearchItem WHERE Object_ObjectAutoID  in (SELECT ObjectAutoID FROM App.Object WHERE objectID=@ModuleID)
			
			--delete object associated with this deal (hard delete)
			DELETE FROM App.Object WHERE objectID=@ModuleID

			
			--DELETE FROM [DW].[L_NoteBI] where AccountID in	(Select AccountID from #TempNotes)
			--DELETE FROM [DW].[NoteBI] where AccountID in(Select AccountID from #TempNotes)
			--DELETE FROM [DW].[L_NotePeriodicCalcBI] WHERE NoteID in (Select AccountID from #TempNotes)
			--DELETE FROM [DW].[NotePeriodicCalcBI] WHERE NoteID in(Select NoteID from #TempNotes)
			--DELETE FROM [DW].[L_TransactionBI] where AccountID in(Select AccountID from #TempNotes)
			--DELETE FROM [DW].[TransactionBI] where AccountID in (Select AccountID from #TempNotes)		
			--DELETE FROM [DW].[L_TransactionEntryBI] WHERE NoteID in (Select NoteID from #TempNotes)
			--DELETE FROM [DW].[TransactionEntryBI] WHERE NoteID in (Select NoteID from #TempNotes)
			--DELETE FROM [DW].[L_DealBI] WHERE DealID=@ModuleID
			--DELETE FROM [DW].[DealBI] WHERE DealID=@ModuleID
			--DELETE FROM [DW].[L_ExceptionsBI] WHERE ObjectID in (Select NoteID from #TempNotes) AND ObjectTypeID=182
			--DELETE FROM [DW].[ExceptionsBI] WHERE ObjectID in  (Select NoteID from #TempNotes) AND ObjectTypeID=182
			--DELETE FROM [DW].[L_ExceptionsBI] WHERE ObjectID = @ModuleID AND ObjectTypeID=283
			--DELETE FROM [DW].[ExceptionsBI] WHERE ObjectID = @ModuleID AND ObjectTypeID=283

		 --  --delete note from PayruleDistributions,PayruleSetup associated with this deal
			--DELETE FROM [CRE].[PayruleDistributions] WHERE [ReceiverNoteID] in (Select NoteID from #TempNotes) OR [SourceNoteID] in (Select NoteID from #TempNotes)
			--DELETE FROM [CRE].[PayruleSetup] WHERE [StripTransferFrom] in (Select NoteID from #TempNotes) OR [StripTransferTo] in (Select NoteID from #TempNotes)
			
			----delete note from calculation generated result
			--DELETE FROM cre.TransactionEntry where NoteID IN (Select NoteID from #TempNotes)
			--DELETE FROM cre.NotePeriodicCalc where NoteID IN (Select NoteID from #TempNotes)
			--DELETE FROM core.CalculationRequests where NoteID IN (Select NoteID from #TempNotes)
			--DELETE FROM core.DailyCalc where AccountID in (Select AccountID from #TempNotes)

		END
		ELSE
		BEGIN
		  IF (@LookupID = 396) --Delete Stripping Payrules
			BEGIN
				DELETE FROM [CRE].[PayruleDistributions] WHERE [ReceiverNoteID] in 
				(
				Select NoteID from #TempNotes
				--	SELECT NoteID from CRE.Note WHERE DealID = @ModuleID
				) OR 
		
				[SourceNoteID] in 
				(
				Select NoteID from #TempNotes
					--SELECT NoteID from CRE.Note WHERE DealID = @ModuleID
				)

				DELETE FROM [CRE].[PayruleSetup] WHERE DealID = @ModuleID
				SET @DeleteCount = @@ROWCOUNT
			END
			ELSE IF (@LookupID = 397) --Delete Funding Rules
			BEGIN
				delete from [CRE].[FundingRepaymentSequence] where [NoteID] in 
				(
				Select NoteID from #TempNotes
					--SELECT NoteID from CRE.Note WHERE DealID = @ModuleID
				)
				SET @DeleteCount = @@ROWCOUNT
			END
			ELSE IF (@LookupID = 398) --Delete Funding Schedules
			BEGIN
				Delete from [CRE].DealFunding WHERE DealID = @ModuleID
				---SET @DeleteCount = @@ROWCOUNT

				IF EXISTS(Select AccountID from #TempNotes)
				BEGIN
					delete from core.FundingSchedule where eventId in (Select eventID from core.event where EventTypeID = 10  and accountid in (Select AccountID from #TempNotes) )
					delete from core.event where EventTypeID = 10 and accountid in (Select AccountID from #TempNotes)
				END
				SET @DeleteCount = @@ROWCOUNT

			END
			IF (@LookupID = 396 or @LookupID = 397 or @LookupID = 398)
			BEGIN
				UPDATE CRE.Deal SET UpdatedDate=getdate(),UpdatedBy=@UserId WHERE DealID = @ModuleID
			END
			--log activity
			IF (@DeleteCount>0)
				exec usp_InsertActivityLog @ModuleID,283,@ModuleID,@LookupID,'deleted',@UserId
		END
		drop table #TempNotes
		drop Table #Tempobject

		--call calculator for deal
			declare @TableTypeCalculationRequestsfordeal TableTypeCalculationRequests
			insert into @TableTypeCalculationRequestsfordeal(NoteId,StatusText,UserName,PriorityText)
			--Select NoteId,'Processing',@UserId,'Real Time' From Cre.Note where dealid=@ModuleID
			--and NoteID Not IN(
			--	select n.NoteID from core.Exceptions ex join Cre.note n on ex.ObjectID = n.NoteId  where ActionLevelID=(select Lookupid from core.Lookup where name='Critical' and ParentID=46)
			--	and ObjectTypeID=182 and n.dealId =@ModuleID 
			--)
			select n.NoteID,'Processing',@UserId,'Real Time' from Cre.Note n left join core.Exceptions ex on ex.ObjectID = n.NoteId  
			and ActionLevelID=(select Lookupid from core.Lookup where name='Critical' and ParentID=46)
			and ObjectTypeID=182 where n.dealId = @ModuleID and ex.ObjectID is null
			
			exec  [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequestsfordeal,@UserId,@UserId, NULL, NULL, 'DeleteDeal'
	END

END







