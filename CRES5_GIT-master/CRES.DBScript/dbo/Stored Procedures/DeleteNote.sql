-- Procedure

CREATE procedure [dbo].DeleteNote 
	@CreNoteID varchar(256)
as
Begin

declare @noteid uniqueidentifier, @accountid uniqueidentifier

select @accountid=account_accountid, @noteid=noteid from cre.note where crenoteid=@crenoteid

delete from [Core].[DailyCalc] where accountid=@accountid --noteid=@noteid
delete from [Core].[Exceptions] where objectid=@noteid
delete from [Core].[PIKScheduleDetail] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[FinancingFeeSchedule]  where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[FeeCouponStripReceivable] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[FeeCouponSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[LIBORSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[DefaultSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[AmortSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[BalanceTransactionSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[Maturity] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[PIKSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[FundingSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[PrepayAndAdditionalFeeSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[RateSpreadSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[ServicingFeeSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[StrippingSchedule] where eventid in (select eventid from core.event where accountid=@accountid)
delete from [Core].[Transaction] where RegisterID in (select registerID from Core.Register where Accountid=@Accountid)
delete from [Core].[Event] where accountid=@accountid --noteid=@noteid
delete from [Core].[Register] where accountid=@accountid --noteid=@noteid
delete from [CRE].[AMNoteEx] where [Note_NoteID]=@noteid
delete from [CRE].[FundingRepaymentSequence] where [NoteID]=@noteid
delete from [CRE].[NoteEx] where [Note_NoteID]=@noteid
delete from [CRE].[PayruleDistributions] where [ReceiverNoteID]=@noteid or [SourceNoteID]=@noteid
delete from [CRE].[OutputNPVdata] where noteid=@noteid
delete from [CRE].[NoteTransactionDetail] where noteid=@noteid
delete from [CRE].[NoteTransaction] where [Note_NoteID]=@noteid
delete from [CRE].[NotePeriodicCalc] where AccountID=@accountid
delete from [CRE].[NotePeriodic] where [Note_NoteID]=@noteid
delete from [CRE].[Note] where noteid=@noteid
delete from [Core].[Account] where accountid=@accountid --noteid=@noteid
delete from [App].[SearchItem] where [Object_ObjectAutoID]=@accountid --noteid=@noteid
delete from [App].[Object] where [Object_ObjectAutoID]=@accountid --noteid=@noteid
End
