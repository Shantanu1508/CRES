Declare @tblAccountIDs as Table(
	AccountID UNIQUEIDENTIFIER	
)

INSERT INTO @tblAccountIDs (AccountID)

Select Distinct AccountID From(
Select agg.LiabilityFundingScheduleAggregateID,agg.AccountID,agg.LibName,agg.TransactionDate,agg.TransactionTypes,det.TransactionTypes as TransactionTypes_New,detCnt.AccountIDCnt
From(
	Select Distinct acc.name as LibName,LiabilityFundingScheduleAggregateID,lfa.AccountID,lfa.TransactionDate,lfa.TransactionTypes
	from cre.LiabilityFundingScheduleAggregate lfa
	Inner join core.Account acc on acc.accountid = lfa.AccountID
	where Applied =1
	--and lfa.Accountid = '05A96B38-8B22-47B2-AA06-6C84F63C9C67'
)agg
Left JOin(
	Select Distinct acc.name as LibName,lf.AccountID,lf.TransactionDate,lf.TransactionTypes
	from cre.LiabilityFundingSchedule lf
	Inner join core.Account acc on acc.accountid = lf.AccountID
	where Applied =1
	--and lf.Accountid = '05A96B38-8B22-47B2-AA06-6C84F63C9C67'
)det on agg.AccountID = det.AccountID and agg.TransactionDate = det.TransactionDate

Left JOin(
	Select Distinct acc.name as LibName,lf.AccountID as AccountIDCnt,lf.TransactionDate,lf.TransactionTypes
	from cre.LiabilityFundingSchedule lf
	Inner join core.Account acc on acc.accountid = lf.AccountID
	where Applied =1
	--and lf.Accountid = '05A96B38-8B22-47B2-AA06-6C84F63C9C67'
	
)detCnt on agg.AccountID = detCnt.AccountIDCnt and agg.TransactionDate = detCnt.TransactionDate and agg.TransactionTypes = detCnt.TransactionTypes
where agg.TransactionTypes <> det.TransactionTypes
and agg.LibName not like '% cash%'
and detCnt.AccountIDCnt is not null
--and agg.TransactionDate = '6/17/2022'
--order by agg.LibName,agg.TransactionDate

)z


Declare @tblFinalTransactiontoUpdate as Table(
	AccountName nvarchar(256),
	LiabilityFundingScheduleID	 int,
	LibName	nvarchar(256),
	TransactionDate	date,
	TransactionTypes nvarchar(256),	
	TransactionAmount	decimal(28,15),
	TransactionTypes_NeedtoUpdate nvarchar(256),
	Agg_TransactionTypes nvarchar(256)
)

Delete from @tblFinalTransactiontoUpdate

---========Cursor Start========================
Declare @AccountID_Cur UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorAccount')>=-1
BEGIN
	DEALLOCATE CursorAccount
END

DECLARE CursorAccount CURSOR 
for
(
	--DB3AD1CE-466C-4BF7-8B24-854736BAD7A3
	Select AccountID from @tblAccountIDs where AccountID in (Select accountid from cre.Equity)  ---('DB3AD1CE-466C-4BF7-8B24-854736BAD7A3') --('7FBA8A24-F9C0-44F3-91B1-615DB18979AA') --
)
OPEN CursorAccount 
FETCH NEXT FROM CursorAccount
INTO @AccountID_Cur
WHILE @@FETCH_STATUS = 0
BEGIN

	Declare @AccountID UNIQUEIDENTIFIER = @AccountID_Cur
	Declare @CashAccountID UNIQUEIDENTIFIER;
	Declare @AccountName nvarchar(256);

	SET @AccountName = (Select [name] from core.account where accountid = @AccountID)

	IF EXISTS(Select PortfolioAccountID from cre.Equity where AccountID = @AccountID)
	BEGIN
		SET @CashAccountID = (Select PortfolioAccountID from cre.Equity where AccountID = @AccountID)
	END
	ELSE
	BEGIN
		SET @CashAccountID = (Select PortfolioAccountID from cre.Debt where AccountID = @AccountID)
	END

	Declare @tblAffectedDate as Table(
		AccountID UNIQUEIDENTIFIER,
		CashAccount UNIQUEIDENTIFIER,
		[Date] Date
	)

	Delete From @tblAffectedDate
	INSERT INTO @tblAffectedDate(AccountID,CashAccount,[Date])
	Select Distinct agg.AccountID,@CashAccountID,agg.TransactionDate
	--Distinct agg.LiabilityFundingScheduleAggregateID,agg.AccountID,agg.LibName,agg.TransactionDate,agg.TransactionTypes,det.TransactionTypes as TransactionTypes_New,detCnt.AccountIDCnt
	From(
		Select Distinct acc.name as LibName,LiabilityFundingScheduleAggregateID,lfa.AccountID,lfa.TransactionDate,lfa.TransactionTypes
		from cre.LiabilityFundingScheduleAggregate lfa
		Inner join core.Account acc on acc.accountid = lfa.AccountID
		where Applied =1
		and lfa.Accountid = @AccountID
	)agg
	Left JOin(
		Select Distinct lf.LiabilityFundingScheduleid, acc.name as LibName,lf.AccountID,lf.TransactionDate,lf.TransactionTypes,lf.TransactionAmount
		from cre.LiabilityFundingSchedule lf
		inner join cre.LiabilityNote ln on ln.AccountID = lf.LiabilityNoteAccountID
		Inner join core.Account acc on acc.accountid = lf.AccountID
		where Applied =1
		and lf.Accountid = @AccountID
	)det on agg.AccountID = det.AccountID and agg.TransactionDate = det.TransactionDate
	Left JOin(
		Select Distinct acc.name as LibName,lf.AccountID as AccountIDCnt,lf.TransactionDate,lf.TransactionTypes
		from cre.LiabilityFundingSchedule lf
		Inner join core.Account acc on acc.accountid = lf.AccountID
		where Applied =1
		and lf.Accountid = @AccountID
	
	)detCnt on agg.AccountID = detCnt.AccountIDCnt and agg.TransactionDate = detCnt.TransactionDate and agg.TransactionTypes = detCnt.TransactionTypes


	where agg.TransactionTypes <> det.TransactionTypes and
	 agg.LibName not like '% cash%'	
	and detCnt.AccountIDCnt is not null
	--and det.TransactionAmount < 0
	--and agg.TransactionDate = '2/11/2025'
	--order by agg.LibName,agg.TransactionDate

	---====================================
	
	INSERT INTO @tblFinalTransactiontoUpdate(AccountName,LiabilityFundingScheduleID,LibName,TransactionDate,TransactionTypes,TransactionAmount,TransactionTypes_NeedtoUpdate,Agg_TransactionTypes)

	Select @AccountName,y.* from(

	Select z.*,agg.TransactionTypes as Agg_TransactionTypes 
	from(
		Select LiabilityFundingScheduleID,acc.name as LibName,lf.TransactionDate,lf.TransactionTypes,lf.TransactionAmount,'EquityCapitalCall' as TransactionTypes_NeedtoUpdate
		from cre.LiabilityFundingSchedule lf
		Inner join core.Account acc on acc.accountid = lf.AccountID
		Inner join @tblAffectedDate afd on afd.AccountID = lf.AccountID and afd.Date = lf.TransactionDate
		where Applied =1
		and TransactionTypes = 'EquityCapitalDistribution'
		--and lf.TransactionDate = '8/11/2022'

		UNION ALL 

		Select LiabilityFundingScheduleID,acc.name as LibName,lf.TransactionDate,lf.TransactionTypes,lf.TransactionAmount ,'EquityCapitalDistribution' as TransactionTypes_NeedtoUpdate
		from cre.LiabilityFundingSchedule lf
		Inner join core.Account acc on acc.accountid = lf.AccountID
		Inner join @tblAffectedDate afd on afd.CashAccount = lf.AccountID and afd.Date = lf.TransactionDate
		where Applied =1
		and TransactionTypes = 'EquityCapitalCall'
		--and lf.TransactionDate = '8/11/2022'
	)z
	Inner join(
		Select Distinct acc.name as LibName,LiabilityFundingScheduleAggregateID,lfa.AccountID,lfa.TransactionDate,lfa.TransactionTypes
		from cre.LiabilityFundingScheduleAggregate lfa
		Inner join core.Account acc on acc.accountid = lfa.AccountID
		where Applied =1
		and lfa.Accountid = @AccountID
	)agg on agg.TransactionDate = z.TransactionDate

	where agg.TransactionTypes = 'EquityCapitalCall'

	UNION ALL

	Select z.*,agg.TransactionTypes as Agg_TransactionTypes 
	from(
		Select LiabilityFundingScheduleID,acc.name as LibName,lf.TransactionDate,lf.TransactionTypes,lf.TransactionAmount,'EquityCapitalDistribution' as TransactionTypes_NeedtoUpdate
		from cre.LiabilityFundingSchedule lf
		Inner join core.Account acc on acc.accountid = lf.AccountID
		Inner join @tblAffectedDate afd on afd.AccountID = lf.AccountID and afd.Date = lf.TransactionDate
		where Applied =1
		and TransactionTypes = 'EquityCapitalCall' 
		--and lf.TransactionDate = '8/11/2022'

		UNION ALL 

		Select LiabilityFundingScheduleID,acc.name as LibName,lf.TransactionDate,lf.TransactionTypes,lf.TransactionAmount,'EquityCapitalCall' as TransactionTypes_NeedtoUpdate
		from cre.LiabilityFundingSchedule lf
		Inner join core.Account acc on acc.accountid = lf.AccountID
		Inner join @tblAffectedDate afd on afd.CashAccount = lf.AccountID and afd.Date = lf.TransactionDate
		where Applied =1
		and TransactionTypes = 'EquityCapitalDistribution'
		--and lf.TransactionDate = '8/11/2022'
	)z
	Inner join(
		Select Distinct acc.name as LibName,LiabilityFundingScheduleAggregateID,lfa.AccountID,lfa.TransactionDate,lfa.TransactionTypes
		from cre.LiabilityFundingScheduleAggregate lfa
		Inner join core.Account acc on acc.accountid = lfa.AccountID
		where Applied =1
		and lfa.Accountid = @AccountID
	)agg on agg.TransactionDate = z.TransactionDate

	where agg.TransactionTypes = 'EquityCapitalDistribution'


	)y
	order by y.transactiondate
					
					
	FETCH NEXT FROM CursorAccount
	INTO @AccountID_Cur
END
CLOSE CursorAccount   
DEALLOCATE CursorAccount

---========Cursor END========================



Update cre.LiabilityFundingSchedule set cre.LiabilityFundingSchedule.TransactionTypes = a.TransactionTypes_NeedtoUpdate
From(
	Select * from @tblFinalTransactiontoUpdate
	--order by AccountName,TransactionDate
)a
where cre.LiabilityFundingSchedule.LiabilityFundingScheduleID = a.LiabilityFundingScheduleID