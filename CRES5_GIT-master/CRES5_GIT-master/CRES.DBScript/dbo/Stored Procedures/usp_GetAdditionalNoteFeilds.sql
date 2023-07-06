--SET FMTONLY OFF
--GO


CREATE PROCEDURE [dbo].[usp_GetAdditionalNoteFeilds] --'1ebb0ed1-7ed4-4c55-a4f7-b9cd73ad88ea', ''
(
    @NoteId Varchar(500),
	@UserID Varchar(500)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


---FOR EDMX Schema

	 IF 1 = 2 BEGIN
    SELECT
       cast(null as uniqueidentifier ) as NoteId ,
		cast(null as Date ) as Maturity_EffectiveDate ,
		cast(null as Date ) as Maturity_MaturityDate ,
		cast(null as Date ) as RateSpreadSch_EffectiveDate ,
		cast(null as Date ) as RateSpreadSch_Date ,
		cast(null as int ) as RateSpreadSch_ValueTypeID ,
		cast(null as decimal(2812) ) as RateSpreadSch_Value ,
		cast(null as Int ) as RateSpreadSch_IntCalcMethodID ,
		cast(null as Date ) as PrepayAddFeeSch_EffectiveDate ,
		cast(null as Date ) as PrepayAddFeeSch_StartDate ,
		cast(null as Int ) as PrepayAddFeeSch_ValueTypeID ,
		cast(null as decimal(2812) ) as PrepayAddFeeSch_Value ,
		cast(null as decimal(2812) ) as PrepayAddFeeSch_IncludedLevelYield ,
		cast(null as decimal(2812) ) as PrepayAddFeeSch_IncludedBasis ,
		
		cast(null as Date ) as stripping_EffectiveDate ,
		cast(null as Date ) as stripping_StartDate ,
		cast(null as Int ) as stripping_ValueTypeID ,
		cast(null as decimal(2812) ) as stripping_Value ,
		cast(null as decimal(2812) ) as stripping_IncludedLevelYield ,
		cast(null as decimal(2812) ) as stripping_IncludedBasis ,
		cast(null as Date ) as FinancingFeeSch_EffectiveDate ,
		cast(null as Date ) as FinancingFeeSch_Date ,
		cast(null as int ) as FinancingFeeSch_ValueTypeID ,
		cast(null as decimal(2812) ) as FinancingFeeSch_Value ,
		cast(null as Date ) as FinancingSch_EffectiveDate ,
		cast(null as Date ) as FinancingSch_Date ,
		cast(null as int ) as FinancingSch_ValueTypeID ,
		cast(null as decimal(2812) ) as FinancingSch_Value ,
		cast(null as int ) as FinancingSch_IndexTypeID ,
		cast(null as int ) as FinancingSch_IntCalcMethodID ,
		cast(null as int ) as FinancingSch_CurrencyCode ,
		cast(null as Date ) as DefaultSch_EffectiveDate ,
		cast(null as Date ) as DefaultSch_StartDate ,
		cast(null as Date ) as DefaultSch_EndDate ,
		cast(null as int ) as DefaultSch_ValueTypeID ,
		cast(null as decimal(2812) ) as DefaultSch_Value ,
		cast(null as Date ) as ServicingFeeSch_EffectiveDate ,
		cast(null as Date ) as ServicingFeeSch_Date ,
		cast(null as decimal(2812) ) as ServicingFeeSch_Value ,
		cast(null as INT ) as ServicingFeeSch_IsCapitalized ,
		
		cast(null as Date ) as pik_EffectiveDate ,
		cast(null as varchar(256 )) as SourceAccountID ,
		cast(null as varchar(256 )) as TargetAccountID ,
		cast(null as decimal(28,15) ) as AdditionalIntRate ,
		cast(null as decimal(28,15) ) as AdditionalSpread ,
		cast(null as decimal(28,15) ) as IndexFloor ,
		cast(null as decimal(28,15) ) as IntCompoundingRate ,
		cast(null as decimal(28,15) ) as IntCompoundingSpread ,
		cast(null as date ) as StartDate ,
		cast(null as date ) as EndDate ,
		cast(null as money ) as IntCapAmt ,
		cast(null as money ) as PurBal ,
		cast(null as money ) as AccCapBal 

    WHERE
        1 = 2  
		
END
-----FOR EDMX Schema

	 Declare @accountID varchar(256)

	Declare @Maturity_EffectiveDate Date
	Declare @Maturity_MaturityDate Date
	Declare @RateSpreadSch_EffectiveDate Date
	Declare @RateSpreadSch_Date Date
	Declare @RateSpreadSch_ValueTypeID int
	Declare @RateSpreadSch_Value decimal(28,12)
	Declare @RateSpreadSch_IntCalcMethodID Int
	Declare @PrepayAddFeeSch_EffectiveDate Date
	Declare @PrepayAddFeeSch_StartDate Date
	Declare @PrepayAddFeeSch_ValueTypeID Int
	Declare @PrepayAddFeeSch_Value decimal(28,12)
	Declare @PrepayAddFeeSch_IncludedLevelYield decimal(28,12)
	Declare @PrepayAddFeeSch_IncludedBasis decimal(28,12)
	
	Declare @stripping_EffectiveDate Date
	Declare @stripping_StartDate Date
	Declare @stripping_ValueTypeID Int
	Declare @stripping_Value decimal(28,12)
	Declare @stripping_IncludedLevelYield decimal(28,12)
	Declare @stripping_IncludedBasis decimal(28,12)
	Declare @FinancingFeeSch_EffectiveDate Date
	Declare @FinancingFeeSch_Date Date
	Declare @FinancingFeeSch_ValueTypeID int
	Declare @FinancingFeeSch_Value decimal(28,12)
	Declare @FinancingSch_EffectiveDate Date
	Declare @FinancingSch_Date Date
	Declare @FinancingSch_ValueTypeID int
	Declare @FinancingSch_Value decimal(28,12)
	Declare @FinancingSch_IndexTypeID int
	Declare @FinancingSch_IntCalcMethodID int
	Declare @FinancingSch_CurrencyCode int
	Declare @DefaultSch_EffectiveDate Date
	Declare @DefaultSch_StartDate Date
	Declare @DefaultSch_EndDate Date
	Declare @DefaultSch_ValueTypeID int
	Declare @DefaultSch_Value decimal(28,12)
	Declare @ServicingFeeSch_EffectiveDate Date
	Declare @ServicingFeeSch_Date Date	
	Declare @ServicingFeeSch_Value decimal(28,12)
	Declare @ServicingFeeSch_IsCapitalized INT

	Declare @pik_EffectiveDate Date
	Declare @SourceAccountID varchar(256)
	Declare @TargetAccountID varchar(256)
	Declare @AdditionalIntRate decimal(28,15)
	Declare @AdditionalSpread decimal(28,15)
	Declare @IndexFloor decimal(28,15)
	Declare @IntCompoundingRate decimal(28,15)
	Declare @IntCompoundingSpread decimal(28,15)
	Declare @StartDate Date
	Declare @EndDate Date
	Declare @IntCapAmt money
	Declare @PurBal money
	Declare @AccCapBal money
	
	Declare @eventId_maturity varchar(256)
	 

Declare @tmpNoteAdditinal  table  
(
	--Create table #tmpNoteAdditinal(
	
					NoteId uniqueidentifier,
					Maturity_EffectiveDate Date,
					Maturity_MaturityDate Date,
					RateSpreadSch_EffectiveDate Date,
					RateSpreadSch_Date Date,
					RateSpreadSch_ValueTypeID int,
					RateSpreadSch_Value decimal(28,12),
					RateSpreadSch_IntCalcMethodID Int,
					PrepayAddFeeSch_EffectiveDate Date,
					PrepayAddFeeSch_StartDate Date,
					PrepayAddFeeSch_ValueTypeID Int,
					PrepayAddFeeSch_Value decimal(28,12),
					PrepayAddFeeSch_IncludedLevelYield decimal(28,12),
					PrepayAddFeeSch_IncludedBasis decimal(28,12),
					
					stripping_EffectiveDate Date,
					stripping_StartDate Date,
					stripping_ValueTypeID Int,
					stripping_Value decimal(28,12),
					stripping_IncludedLevelYield decimal(28,12),
					stripping_IncludedBasis decimal(28,12),
					FinancingFeeSch_EffectiveDate Date,
					FinancingFeeSch_Date Date,
					FinancingFeeSch_ValueTypeID int,
					FinancingFeeSch_Value decimal(28,12),
					FinancingSch_EffectiveDate Date,
					FinancingSch_Date Date,
					FinancingSch_ValueTypeID int,
					FinancingSch_Value decimal(28,12),
					FinancingSch_IndexTypeID int,
					FinancingSch_IntCalcMethodID int,
					FinancingSch_CurrencyCode int,
					DefaultSch_EffectiveDate Date,
					DefaultSch_StartDate Date,
					DefaultSch_EndDate Date,
					DefaultSch_ValueTypeID int,
					DefaultSch_Value decimal(28,12),
					ServicingFeeSch_EffectiveDate Date,
					ServicingFeeSch_Date Date,
					ServicingFeeSch_Value decimal(28,12),
					ServicingFeeSch_IsCapitalized INT,
					 pik_EffectiveDate Date,
					 SourceAccountID varchar(256),					
					TargetAccountID varchar(256),
					AdditionalIntRate decimal(28,15),
					 AdditionalSpread decimal(28,15),
					 IndexFloor decimal(28,15),
					 IntCompoundingRate decimal(28,15),
					 IntCompoundingSpread decimal(28,15),
					 StartDate Date,
					 EndDate Date,
					 IntCapAmt money,
					 PurBal money,
					 AccCapBal money
	)

	Create table #tmpEvent (evtTypeid int,effStartDate date,LookupName Varchar(100))
	DECLARE @tInserted TABLE (tinsertedVal UNIQUEIDENTIFIER)

	SELECT @accountID=Account_AccountID from CRE.Note n inner join core.Account acc on n.Account_AccountID = acc.AccountID where n.NoteID=@NoteId and acc.IsDeleted=0

	INSERT INTO #tmpEvent (evtTypeid, effStartDate,LookupName) 
	SELECT 	
	EventTypeID,
	max(EffectiveStartDate),
	lk.Name
	from Core.Event eve
	INNER JOIN [CORE].[Lookup] lk ON lk.LookupID = eve.EventTypeID
	where AccountID=@accountID 
	group by EventTypeID,lk.Name
	
	Declare @evtTypeid INT,@effStartDate DATE,@teventId varchar(100),@tempTableName varchar(200)

While (Select Count(*) From #tmpEvent) > 0
Begin

	Select Top 1 @evtTypeid=evtTypeid, @effStartDate=effStartDate From #tmpEvent
	--Maturity
	SELECT @teventId=EventID from Core.Event where AccountID=@accountID and EventTypeID=@evtTypeid and EffectiveStartDate=@effStartDate
	print @effStartDate;
	print @teventId;
	
	--Select @Maturity_MaturityDate=SelectedMaturityDate,@Maturity_EffectiveDate=(select EffectiveStartDate from Core.Event ev where ev.EventId=@teventId)
	--from core.Maturity where EventId=@teventId

	Select  @Maturity_MaturityDate = mat.maturityDate,@Maturity_EffectiveDate = e.EffectiveStartDate
	from [CORE].Maturity mat  
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	where mat.maturityType = 708 
	and	mat.Approved = 3
	and e.EventId=@teventId
	and e.StatusID = 1


	
	--RateSpreadSchedule
	Select @RateSpreadSch_EffectiveDate=(select EffectiveStartDate from Core.Event ev1 where ev1.EventId=@teventId),
	@RateSpreadSch_Date=Date,
	@RateSpreadSch_ValueTypeID=ValueTypeID ,
	@RateSpreadSch_Value=Value,
	@RateSpreadSch_IntCalcMethodID=IntCalcMethodID
	from core.RateSpreadSchedule where EventId=@teventId

	
	-- SELECT @RateSpreadSch_EffectiveDate=@effStartDate
	

	--PrepayAndAdditionalFeeSchedule
	select @PrepayAddFeeSch_EffectiveDate=(select EffectiveStartDate from Core.Event ev2 where ev2.EventId=@teventId),
	@PrepayAddFeeSch_StartDate=StartDate,
	@PrepayAddFeeSch_ValueTypeID=ValueTypeID,
	@PrepayAddFeeSch_Value=Value,
	@PrepayAddFeeSch_IncludedLevelYield=IncludedLevelYield,
	@PrepayAddFeeSch_IncludedBasis=IncludedBasis

	 from Core.PrepayAndAdditionalFeeSchedule where EventId=@teventId
	
	 --stripping

	 Select @stripping_EffectiveDate=(select EffectiveStartDate from Core.Event ev3 where ev3.EventId=@teventId),
	 @stripping_StartDate=StartDate,
	 @stripping_ValueTypeID=ValueTypeID,
	 @stripping_Value=Value,
	 @stripping_IncludedLevelYield=IncludedLevelYield,
	 @stripping_IncludedBasis=IncludedBasis
	  from Core.StrippingSchedule where EventId=@teventId
	 
	--Financing Fee Schedule
	select @FinancingFeeSch_EffectiveDate=(select EffectiveStartDate from Core.Event ev7 where ev7.EventId=@teventId),
	@FinancingFeeSch_Date=Date,
	 @FinancingFeeSch_ValueTypeID=ValueTypeID,
	 @FinancingFeeSch_Value=Value
	 from Core.FinancingFeeSchedule where EventId=@teventId
	
	
	 --Financing Schedule
	 select @FinancingSch_EffectiveDate=(select EffectiveStartDate from Core.Event ev4 where ev4.EventId=@teventId),
	 @FinancingSch_Date=Date,
	 @FinancingSch_ValueTypeID=ValueTypeID,
	 @FinancingSch_Value=Value,
	 @FinancingSch_IndexTypeID=IndexTypeID,
	 @FinancingSch_IntCalcMethodID=IntCalcMethodID,
	 @FinancingSch_CurrencyCode=CurrencyCode
	  from Core.FinancingSchedule where EventId=@teventId

	  --Default Schedule
	  select @DefaultSch_EffectiveDate=(select EffectiveStartDate from Core.Event ev5 where ev5.EventId=@teventId),
	  @DefaultSch_StartDate=StartDate,
	  @DefaultSch_EndDate=EndDate,
	  @DefaultSch_ValueTypeID=ValueTypeID,
	  @DefaultSch_Value=Value
	  from Core.DefaultSchedule where EventId=@teventId


	  --Servicing Fee Schedule
	  Select @ServicingFeeSch_EffectiveDate=(select EffectiveStartDate from Core.Event ev6 where ev6.EventId=@teventId),
	  @ServicingFeeSch_Date=Date,
	  @ServicingFeeSch_Value=Value,
	  @ServicingFeeSch_IsCapitalized=IsCapitalized
	  from Core.ServicingFeeSchedule where EventId=@teventId

	 ---PIK
	   Select @pik_EffectiveDate=(select EffectiveStartDate from Core.Event ev7 where ev7.EventId=@teventId),
	  @SourceAccountID=SourceAccountID,
	  @TargetAccountID=TargetAccountID,
	  @AdditionalIntRate=AdditionalIntRate,
	  @AdditionalSpread=[AdditionalSpread],
	 @IndexFloor=IndexFloor,
	 @AdditionalSpread=AdditionalSpread,
	 @IndexFloor=IndexFloor,
     @IntCompoundingRate=IntCompoundingRate,
	 @IntCompoundingSpread=IntCompoundingSpread,
	 @StartDate=StartDate,
	 @EndDate=EndDate,
	 @IntCapAmt=IntCapAmt,
	 @PurBal=PurBal,
	 @AccCapBal=AccCapBal
	  from Core.PIKSchedule where EventId=@teventId


	

    Delete #tmpEvent Where evtTypeid = @evtTypeid

End
drop table #tmpEvent
	--drop table #tmpNoteAdditinal

insert into @tmpNoteAdditinal 
 SElect
     @NoteId,
	 @Maturity_EffectiveDate  'Maturity_EffectiveDate',
	 @Maturity_MaturityDate 'Maturity_MaturityDate',
	 @RateSpreadSch_EffectiveDate 'RateSpreadSch_EffectiveDate',
	 @RateSpreadSch_Date 'RateSpreadSch_Date',
	 @RateSpreadSch_ValueTypeID 'RateSpreadSch_ValueTypeID',
	 @RateSpreadSch_Value 'RateSpreadSch_Value',
	 @RateSpreadSch_IntCalcMethodID 'RateSpreadSch_IntCalcMethodID',
	 @PrepayAddFeeSch_EffectiveDate 'PrepayAddFeeSch_EffectiveDate',
	 @PrepayAddFeeSch_StartDate 'PrepayAddFeeSch_StartDate', 
	 @PrepayAddFeeSch_ValueTypeID 'PrepayAddFeeSch_ValueTypeID',
	 @PrepayAddFeeSch_Value 'PrepayAddFeeSch_Value',
	 @PrepayAddFeeSch_IncludedLevelYield 'PrepayAddFeeSch_IncludedLevelYield',
	 @PrepayAddFeeSch_IncludedBasis 'PrepayAddFeeSch_IncludedBasis',
	
	 @stripping_EffectiveDate 'stripping_EffectiveDate',
	 @stripping_StartDate 'stripping_StartDate',
	 @stripping_ValueTypeID 'stripping_ValueTypeID',
	 @stripping_Value 'stripping_Value',
	 @stripping_IncludedLevelYield 'stripping_IncludedLevelYield',
	 @stripping_IncludedBasis 'stripping_IncludedBasis',
	 @FinancingFeeSch_EffectiveDate,
	 @FinancingFeeSch_Date	'FinancingFeeSch_Date'	,
	 @FinancingFeeSch_ValueTypeID 'FinancingFeeSch_ValueTypeID',
	 @FinancingFeeSch_Value 'FinancingFeeSch_Value',	
	@FinancingSch_EffectiveDate	'FinancingSch_EffectiveDate',
	@FinancingSch_Date 'FinancingSch_Date',	
	@FinancingSch_ValueTypeID 'FinancingSch_ValueTypeID',	
	@FinancingSch_Value	'FinancingSch_Value',	
	@FinancingSch_IndexTypeID 'FinancingSch_IndexTypeID',	
	@FinancingSch_IntCalcMethodID 'FinancingSch_IntCalcMethodID'	,
	@FinancingSch_CurrencyCode 'FinancingSch_CurrencyCode'	,
	@DefaultSch_EffectiveDate 'DefaultSch_EffectiveDate',	
	@DefaultSch_StartDate 'DefaultSch_StartDate'	,
	@DefaultSch_EndDate	'DefaultSch_EndDate',
	@DefaultSch_ValueTypeID	'DefaultSch_ValueTypeID',
	@DefaultSch_Value 'DefaultSch_Value',	
	@ServicingFeeSch_EffectiveDate	'ServicingFeeSch_EffectiveDate',	
	@ServicingFeeSch_Date 'ServicingFeeSch_Date',	
	@ServicingFeeSch_Value 'ServicingFeeSch_Value',	
	@ServicingFeeSch_IsCapitalized	'ServicingFeeSch_IsCapitalized'	,
	@pik_EffectiveDate 'pik_EffectiveDate',	
	@SourceAccountID 'SourceAccountID',
	@TargetAccountID  'TargetAccountID',
	@AdditionalIntRate 'AdditionalIntRate',
	@AdditionalSpread 'AdditionalSpread',
	@IndexFloor 'IndexFloor',
	@IntCompoundingRate 'IntCompoundingRate',
	@IntCompoundingSpread 'IntCompoundingSpread',
	@StartDate 'StartDate',
	@EndDate 'EndDate',
	@IntCapAmt 'IntCapAmt',
	@PurBal 'PurBal',
	@AccCapBal 'AccCapBal'

	select 
	NoteId	,
Maturity_EffectiveDate	,
Maturity_MaturityDate	,
RateSpreadSch_EffectiveDate	,
RateSpreadSch_Date	,
RateSpreadSch_ValueTypeID	,
RateSpreadSch_Value	,
RateSpreadSch_IntCalcMethodID	,
PrepayAddFeeSch_EffectiveDate	,
PrepayAddFeeSch_StartDate	,
PrepayAddFeeSch_ValueTypeID	,
PrepayAddFeeSch_Value	,
PrepayAddFeeSch_IncludedLevelYield	,
PrepayAddFeeSch_IncludedBasis	,

stripping_EffectiveDate	,
stripping_StartDate	,
stripping_ValueTypeID	,
stripping_Value	,
stripping_IncludedLevelYield	,
stripping_IncludedBasis	,
FinancingFeeSch_EffectiveDate	,
FinancingFeeSch_Date	,
FinancingFeeSch_ValueTypeID	,
FinancingFeeSch_Value	,
FinancingSch_EffectiveDate	,
FinancingSch_Date	,
FinancingSch_ValueTypeID	,
FinancingSch_Value	,
FinancingSch_IndexTypeID	,
FinancingSch_IntCalcMethodID	,
FinancingSch_CurrencyCode	,
DefaultSch_EffectiveDate	,
DefaultSch_StartDate	,
DefaultSch_EndDate	,
DefaultSch_ValueTypeID	,
DefaultSch_Value	,
ServicingFeeSch_EffectiveDate	,
ServicingFeeSch_Date	,
ServicingFeeSch_Value	,
ServicingFeeSch_IsCapitalized	,
pik_EffectiveDate,
 SourceAccountID,
   TargetAccountID,
      AdditionalIntRate,
      AdditionalSpread,
      IndexFloor,
      IntCompoundingRate,
      IntCompoundingSpread,
      StartDate,
      EndDate,
      IntCapAmt,
      PurBal,
      AccCapBal   

 from @tmpNoteAdditinal
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END



