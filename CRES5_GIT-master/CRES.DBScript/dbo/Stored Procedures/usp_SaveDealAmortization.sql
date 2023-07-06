

CREATE PROCEDURE [dbo].[usp_SaveDealAmortization]
(
	@XMLDealAmortization XML,
	@isDeleteOldAmortSchedule bit	
)
  
AS
BEGIN
  SET NOCOUNT ON;  

	declare @TempDealAmortization table
	(
	    ID int identity,
		DealAmortizationScheduleID  uniqueidentifier,
		DealAmortScheduleRowno int,
		DealID varchar(256),    
		[Date] datetime,
		Amount decimal(28, 15) ,		
		CreatedBy nvarchar(256)
	)

	INSERT INTO @TempDealAmortization
	select 
	ISNULL(nullif(Pers.value('(DealAmortizationScheduleID)[1]', 'varchar(256)'), ''),'00000000-0000-0000-0000-000000000000'),  
	Pers.value('(DealAmortScheduleRowno)[1]', 'int'),
	nullif(Pers.value('(DealID)[1]', 'varchar(256)'), ''),
	Pers.value('(Date)[1]', 'datetime'),
	Pers.value('(Amount)[1]', 'decimal(28, 15)'),	
	nullif(Pers.value('(CreatedBy)[1]', 'nvarchar(256)'), '')
	FROM @XMLDealAmortization.nodes('/ArrayOfDealAmortScheduleDataContract/DealAmortScheduleDataContract') as t(Pers)
	WHERE Pers.value('(Amount)[1]', 'varchar(256)') != ''

	DECLARE @DealID uniqueidentifier=(select top 1 DealID from  @TempDealAmortization)
	--DECLARE @DBAmortMethod int =(select AmortizationMethod from cre.deal where dealid = (select top 1 DealID from  @TempDealAmortization))
	Declare @UseRuletoDetermineAmortallN int=(select Count(UseRuletoDetermineAmortization) from cre.Note where  DealID=@DealID and UseRuletoDetermineAmortization=3)


	--if(@isDeleteOldAmortSchedule=1 or @UseRuletoDetermineAmortallN=0)
	--BEGIN
	
	Delete from [CRE].[DealAmortizationSchedule] where DealAmortizationScheduleAutoID in (
	select DealAmortizationScheduleAutoID from [CRE].[DealAmortizationSchedule] where DealID=@DealID)
	
		Delete from CORE.AmortSchedule where amortscheduleautoid in (
		select amortscheduleautoid from CORE.AmortSchedule where eventid in (
			Select Distinct e.eventid from cre.note n 
			inner join cre.deal d on n.dealid = d.dealid
			inner join core.event e on e.accountid = n.account_accountid and eventtypeid = 19
			where d.dealid = @DealID
		)
		)
		Delete from CORE.[Event] where eventtypeid = 19 and eventautoid in (
			Select Distinct e.eventautoid from cre.note n 
			inner join cre.deal d on n.dealid = d.dealid
			inner join core.event e on e.accountid = n.account_accountid and eventtypeid = 19
			where d.dealid = @DealID
		)
	--END

	--Delete from [CRE].[DealAmortizationSchedule] where DealAmortizationScheduleAutoID in (
	--select DealAmortizationScheduleAutoID from [CRE].[DealAmortizationSchedule] 
	--where DealID=@DealID and
	--DealAmortScheduleRowno not in (select DealAmortScheduleRowno from @TempDealAmortization)
	--)

	INSERT INTO [CRE].[DealAmortizationSchedule]
	([DealID]
	,DealAmortScheduleRowno
	,[Date]
	,[Amount]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])
	Select DealID,
	DealAmortScheduleRowno,
	[Date],
	Amount ,
	CreatedBy,
	getdate(),
	CreatedBy,
	getdate()
	from @TempDealAmortization --where DealAmortizationScheduleID = '00000000-0000-0000-0000-000000000000'
	

	Update [CRE].[DealAmortizationSchedule]
	SET [CRE].[DealAmortizationSchedule].[Date] = tmp.[Date],
	[CRE].[DealAmortizationSchedule].DealAmortScheduleRowno = tmp.DealAmortScheduleRowno,
	[CRE].[DealAmortizationSchedule].[Amount] = tmp.[Amount],
	[CRE].[DealAmortizationSchedule].[UpdatedBy] = tmp.CreatedBy,
	[CRE].[DealAmortizationSchedule].[UpdatedDate] = getdate()
	From(
		Select DealAmortizationScheduleID,
		DealAmortScheduleRowno,
		DealID,
		[Date],
		Amount ,
		CreatedBy		
		from @TempDealAmortization 
		where DealAmortizationScheduleID <> '00000000-0000-0000-0000-000000000000'
	)tmp
	where [CRE].[DealAmortizationSchedule].DealAmortizationScheduleID = tmp.DealAmortizationScheduleID


	--Delete Note Amort
	exec dbo.usp_DeleteNoteAmortDataForDealFundingID @DealID
END



