--Select * from cre.deal where dealid = '7dc585e3-fe90-4636-93ef-2efc3fd67faf'
--Select * from [Core].[PrepaySchedule]
--Select * from [Core].[PrepayAdjustment]
--Select * from [Core].[SpreadMaintenance]
--Select * from Core.MinSpreadInterest
--Select * from Core.MinFee



Print('ONe time PrepaySchedule data')
go
Declare @DealID uniqUeidentifier = '7dc585e3-fe90-4636-93ef-2efc3fd67faf';
Declare @EventDealID int;
Declare @PrepayScheduleID int;
Declare @SpreadCalcMethod int = (Select LookupID from core.lookup where name = 'Actual/360' and ParentID  = 25)
Declare @PrepaymentMethod  int = (Select LookupID from core.lookup where name = 'Spread Maintenance')
Declare @BaseAmount  int = (Select LookupID from core.lookup where name = 'Principal Balance' and ParentID = 124)

INSERT INTO core.EventDeal (DealID,EventTypeID,EffectiveDate,StatusID)VALUES(@DealID,737,'12/31/2020',1)

SET @EventDealID = @@Identity

INSERT INTO [Core].[PrepaySchedule]
           ([EventDealID]
           ,[PrepayDate]
           ,[CalcThro]
           ,[PrepaymentMethod]
           ,[BaseAmount]
           ,[SpreadCalcMethod]
           ,[GreaterOfSMOrBaseAmtTimeSpread]
           ,[ChkNoteLevel]
           ,[IncludeFee]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
VALUES(@EventDealID,'12/31/2020','12/31/2020',@PrepaymentMethod,@BaseAmount,@SpreadCalcMethod,0,1,0,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())

SET @PrepayScheduleID = @@Identity

INSERT INTO [Core].[PrepayAdjustment]
           ([PrepayScheduleID]
           ,[Date]
           ,[PrepayAdjAmt]
           ,[Comment]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
		   VALUES(@PrepayScheduleID,'12/01/2020',200,'Test','B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate())


INSERT INTO [Core].[SpreadMaintenance]
           ([PrepayScheduleID]
           ,NOteID
           ,[Date]
           ,[Percentage]
           ,[CalcAfterPayoff]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
select @PrepayScheduleID,n.noteid,'12/02/2020',0.02,0,'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate(),'B0E6697B-3534-4C09-BE0A-04473401AB93',getdate()
from cre.note n
inner join core.account acc on acc.accountid = n.account_accountid
Inner join cre.deal d on d.dealid = n.dealid
where acc.isdeleted <> 1 and d.dealid = @DealID



INSERT INTO Core.MinSpreadInterest([PrepayScheduleID],Date,amount)
		Select @PrepayScheduleID,'12/02/2021',1000
		
INSERT INTO Core.MinFee([PrepayScheduleID],FeeType,CheckFeeLevel,amount)VALUES( @PrepayScheduleID,1,1,1000)
INSERT INTO Core.MinFee([PrepayScheduleID],FeeType,CheckFeeLevel,amount)VALUES( @PrepayScheduleID,4,1,2000)

