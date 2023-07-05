

 
CREATE PROCEDURE [dbo].[usp_InsertUpdateNoteArchieveAdditinalList] 
@noteAdditinallist tempInsert READONLY,
@CreatedBy nvarchar(256),
@UpdatedBy nvarchar(256)
AS
BEGIN

--Variable's--------------------

DECLARE @accountID varchar(256)
Declare  @RateSpreadSchedule  int  =14;
Declare  @PrepayAndAdditionalFeeSchedule  int  =13;
Declare  @StrippingSchedule  int  =16;

---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)
SELECT @accountID = n.Account_AccountID FROM CRE.Note n inner join core.Account acc on n.Account_AccountID=acc.AccountID WHERE n.NoteID = (SELECT TOP 1 (NoteId) FROM Core.tempinsert) and acc.IsDeleted=0

---------------------------------
--Insert RateSpreadSchedule archieve data
INSERT INTO [CORE].[ScheduleArchieveTable]
(EventId, Date,ValueTypeID, Value,IntCalcMethodID, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,ArchieveBy,ArchieveDate,EventTypeID)
				SELECT 
				na.EventId, 
				na.Date, 
				na.ValueTypeID,
				na.Value, 
				na.IntCalcMethodID,
				na.CreatedBy, 
				na.CreatedDate, 
				na.UpdatedBy, 
				na.UpdatedDate,
				@CreatedBy,
				GETDATE(),
				@RateSpreadSchedule
				FROM @noteAdditinallist na inner join core.RateSpreadSchedule  rs on na.EventID=rs.EventId and na.ScheduleID=rs.RateSpreadScheduleID
				inner join core.Event e on rs.EventId=e.EventId AND e.EffectiveStartDate = CONVERT(date, na.EffectiveDate, 101)
				WHERE ModuleId = @RateSpreadSchedule and na.Date is not null and na.EventId is not null
				

--Delete this record from main table
Delete from core.RateSpreadSchedule where RateSpreadScheduleID in(select ScheduleID 
FROM @noteAdditinallist na inner join core.RateSpreadSchedule  rs on na.EventID=rs.EventId and na.ScheduleID=rs.RateSpreadScheduleID
inner join core.Event e on rs.EventId=e.EventId AND e.EffectiveStartDate = CONVERT(date, na.EffectiveDate, 101)
WHERE ModuleId = @RateSpreadSchedule and na.Date is not null and na.EventId is not null)

---Delete effective date from event table if detail doesn't exist
Delete from core.Event where (select count(*)  
FROM @noteAdditinallist na inner join core.RateSpreadSchedule  rs on na.EventID=rs.EventId --and na.ScheduleID=rs.RateSpreadScheduleID
inner join core.Event e on rs.EventId=e.EventId AND CONVERT(date, e.EffectiveStartDate, 101) = CONVERT(date, na.EffectiveDate, 101)
WHERE ModuleId = @RateSpreadSchedule and na.Date is not null and na.EventId is not null)=0 and EventID=(select distinct EventID FROM @noteAdditinallist WHERE ModuleId = @RateSpreadSchedule)
--------------------------

--Insert PrepayAndAdditionalFeeSchedule archieve data
INSERT INTO [CORE].[ScheduleArchieveTable]
(EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,ArchieveBy,ArchieveDate,EventTypeID)
SELECT na.EventId, 
				na.StartDate, 
				na.ValueTypeID,
				na.Value, 
				na.IncludedLevelYield,
				na.IncludedBasis,
				na.CreatedBy, 
				na.CreatedDate, 
				na.UpdatedBy, 
				na.UpdatedDate,
				@CreatedBy,
				GETDATE(),
				@PrepayAndAdditionalFeeSchedule		
				FROM @noteAdditinallist na inner join core.PrepayAndAdditionalFeeSchedule  ps on na.EventID=ps.EventId and ps.PrepayAndAdditionalFeeScheduleID=na.ScheduleID
				inner join core.Event e on ps.EventId=e.EventId AND e.EffectiveStartDate = CONVERT(date, na.EffectiveDate, 101)
				WHERE ModuleId = @PrepayAndAdditionalFeeSchedule and na.StartDate is not null and na.EventId is not null
		
--Delete this record from main table
Delete from core.PrepayAndAdditionalFeeSchedule where PrepayAndAdditionalFeeScheduleID in(select ScheduleID 
FROM @noteAdditinallist na inner join core.PrepayAndAdditionalFeeSchedule  ps on na.EventID=ps.EventId and ps.PrepayAndAdditionalFeeScheduleID=na.ScheduleID
inner join core.Event e on ps.EventId=e.EventId AND e.EffectiveStartDate = CONVERT(date, na.EffectiveDate, 101)
WHERE ModuleId = @PrepayAndAdditionalFeeSchedule and na.StartDate is not null and na.EventId is not null)
		
---Delete effective date from event table if detail doesn't exist
Delete from core.Event where (select count(*)  
FROM @noteAdditinallist na inner join core.PrepayAndAdditionalFeeSchedule  ps on na.EventID=ps.EventId --and ps.PrepayAndAdditionalFeeScheduleID=na.ScheduleID
inner join core.Event e on ps.EventId=e.EventId AND e.EffectiveStartDate = CONVERT(date, na.EffectiveDate, 101)
WHERE ModuleId = @PrepayAndAdditionalFeeSchedule and na.StartDate is not null and na.EventId is not null)=0 and EventID=(select distinct EventID FROM @noteAdditinallist WHERE ModuleId = @PrepayAndAdditionalFeeSchedule)
---------------------------------
INSERT INTO [CORE].[ScheduleArchieveTable]
(EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,ArchieveBy,ArchieveDate,EventTypeID)
   SELECT na.EventId, 
				na.StartDate, 
				na.ValueTypeID,
				na.Value, 
				na.IncludedLevelYield,
				na.IncludedBasis,
				na.CreatedBy, 
				na.CreatedDate, 
				na.UpdatedBy, 
				na.UpdatedDate,
				@CreatedBy,
				GETDATE(),
				@StrippingSchedule			
				FROM @noteAdditinallist na inner join core.StrippingSchedule  ss on na.EventID=ss.EventId and ss.StrippingScheduleID=na.ScheduleID
				inner join core.Event e on ss.EventId=e.EventId AND e.EffectiveStartDate = CONVERT(date, na.EffectiveDate, 101)
				WHERE ModuleId = @StrippingSchedule and na.StartDate is not null and na.EventId is not null
		
--Delete this record from main table
Delete from core.StrippingSchedule where StrippingScheduleID in(select ScheduleID 
FROM @noteAdditinallist na inner join core.StrippingSchedule  ss on na.EventID=ss.EventId and ss.StrippingScheduleID=na.ScheduleID
inner join core.Event e on ss.EventId=e.EventId AND e.EffectiveStartDate = CONVERT(date, na.EffectiveDate, 101)
WHERE ModuleId = @StrippingSchedule and na.StartDate is not null and na.EventId is not null)

	---Delete effective date from event table if detail doesn't exist
Delete from core.Event where (select count(*)  
FROM @noteAdditinallist na inner join core.StrippingSchedule  ss on na.EventID=ss.EventId --and ss.StrippingScheduleID=na.ScheduleID
inner join core.Event e on ss.EventId=e.EventId AND e.EffectiveStartDate = CONVERT(date, na.EffectiveDate, 101)
WHERE ModuleId = @StrippingSchedule and na.StartDate is not null and na.EventId is not null)=0 and EventID=(select distinct EventID FROM @noteAdditinallist WHERE ModuleId = @StrippingSchedule)	

END
