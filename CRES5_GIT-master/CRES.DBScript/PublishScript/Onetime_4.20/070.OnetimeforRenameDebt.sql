
Update cre.debt set DebtNameClientSheet = debtname
From(
	Select dt.accountid,acc.name  as debtname
	from cre.debt dt
	inner join core.account acc on acc.accountid = dt.accountid
)a
where cre.debt.AccountID = a.AccountID

go

Update core.Account set [name] = 'bcIMC JV' where [name] = 'bcIMC'
Update core.Account set [name] = 'C3' where [name] = 'C3 Bank'
Update core.Account set [name] = 'Hamburg' where [name] = 'Bank of Hamburg'

go
--=====================================


Declare @tblRenameDebt as Table(
Accountid UNIQUEIDENTIFIER,
DebtName nvarchar(256),
FacilityName nvarchar(256),
FacilityShortName nvarchar(256),
LiabilityID nvarchar(256),
Eq_AbbName nvarchar(256),
Eq_AccountID UNIQUEIDENTIFIER,
DebtTypeName nvarchar(256),
debttype int,
rno int
)

INSERT INTO @tblRenameDebt(Accountid,DebtName,FacilityName,FacilityShortName,LiabilityID,Eq_AbbName,Eq_AccountID,DebtTypeName,debttype,rno)
Select --t.* ,dt.DebtName
dt.accountid,dt.DebtName,t.FacilityName,t.FacilityShortName,t.LiabilityID
,SUBSTRING(t.LiabilityID,1,CHARINDEX('-',t.LiabilityID)-1) Eq_AbbName
,eq.AccountID as Eq_AccountID
,REVERSE(SUBSTRING(REVERSE(t.LiabilityID),1,CHARINDEX('-',REVERSE(t.LiabilityID))-1)) DebtTypeName
,ac.AccountCategoryID as debttype
,ROW_NUMBER() OVER (Partition BY ISNULL(dt.DebtName,'new') Order by dt.DebtName ) as rno

from dbo.[FacilityNameUpdate$] t
Left Join(
	Select dt.accountid,acc.name as DebtName
	from cre.debt dt
	Inner join core.account acc on acc.accountid =dt.accountid
)dt on dt.DebtName = t.FacilityName
Left join cre.equity eq on Replace(eq.AbbreviationName,' ','')= SUBSTRING(t.LiabilityID,1,CHARINDEX('-',t.LiabilityID)-1)
Left join CORE.AccountCategory ac  on ac.name= REVERSE(SUBSTRING(REVERSE(t.LiabilityID),1,CHARINDEX('-',REVERSE(t.LiabilityID))-1))
order by dt.DebtName
---=====================


Update  cre.debt set  cre.debt.AbbreviationName = z.FacilityShortName,cre.debt.LinkedFundID = z.Eq_AccountID
From(
	Select Accountid,DebtName,FacilityName,FacilityShortName,LiabilityID,Eq_AbbName,Eq_AccountID,DebtTypeName,debttype,rno 
	from @tblRenameDebt
	where Accountid is not null 
	and rno = 1
)z
Where cre.debt.AccountID = z.AccountID



Update CORE.Account set  CORE.Account.Name = z.LiabilityID,AccountTypeID = debttype
From(
	Select Accountid,DebtName,FacilityName,FacilityShortName,LiabilityID,Eq_AbbName,Eq_AccountID,DebtTypeName,debttype,rno 
	from @tblRenameDebt
	where Accountid is not null
	and rno = 1
)z
Where CORE.Account.AccountID = z.AccountID


---===============================
Declare @L_DebtName nvarchar(256)
Declare @L_AbbreviationName nvarchar(256)
Declare @L_LinkedFundID nvarchar(256)
Declare @L_DebtType nvarchar(256)


IF CURSOR_STATUS('global','CursorInserDebt')>=-1
BEGIN
	DEALLOCATE CursorInserDebt
END

DECLARE CursorInserDebt CURSOR 
for
(
	Select LiabilityID,FacilityShortName,Eq_AccountID,debttype
	From(
		Select LiabilityID,FacilityShortName,Eq_AccountID,debttype
		--Accountid,DebtName,FacilityName,FacilityShortName,LiabilityID,Eq_AbbName,Eq_AccountID,DebtTypeName,debttype,rno 
		from @tblRenameDebt
		where Accountid is not null
		and rno = 2

		UNION

		Select LiabilityID,FacilityShortName,Eq_AccountID,debttype
		from @tblRenameDebt
		where Accountid is null
		and FacilityName = 'PNC 2025-01'
	)a
)
OPEN CursorInserDebt 

FETCH NEXT FROM CursorInserDebt
INTO @L_DebtName,@L_AbbreviationName,@L_LinkedFundID,@L_DebtType
WHILE @@FETCH_STATUS = 0
BEGIN
	
	Print(@L_DebtName)
	EXEC [dbo].[usp_InsertUpdateDebt] 
	@DebtID = 0
	,@AccountID = '00000000-0000-0000-0000-000000000000'
	,@DebtName = @L_DebtName
	,@DebtType  = @L_DebtType
	,@Status = 1
	,@Currency = null
	,@CurrentCommitment	= null
	,@MatchTerm	= null
	,@IsRevolving	= null
	,@FundingNoticeBD	= null
	,@EarliestFinancingArrival	= null
	,@OriginationDate	= null
	,@OriginationFees	= null
	,@RateType	= null
	,@DrawLag	= null
	,@PaydownDelay = null
	,@EffectiveDate = null
	,@Commitment   = null
	,@InitialMaturityDate	= null
	,@ExitFee= null
	,@ExtensionFees= null
	,@InitialFundingDelay = null
	,@MaxAdvanceRate    = null
	,@TargetAdvanceRate = null
	,@FundDelay = null
	,@FundingDay = null
	,@UserID = null
	,@DebtAccountID = null
	,@DebtGUID_Output = null
	,@CashAccountID = null
	,@LiabilityBankerID = null
	,@AbbreviationName = @L_AbbreviationName
	,@LinkedFundID = @L_LinkedFundID
					 
FETCH NEXT FROM CursorInserDebt
INTO @L_DebtName,@L_AbbreviationName,@L_LinkedFundID,@L_DebtType
END
CLOSE CursorInserDebt   
DEALLOCATE CursorInserDebt
---===============================





Declare @tbldebtnametemp as Table(
DebtNameClientSheet	nvarchar(256),
DebtName nvarchar(256)
)
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('3rd Party','AOCI-3rd Party-Sale')
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('Axos Bank','AOCI-Axos-NoN')
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('Bank OZK','AOCI-OZK-Sale')
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('Customers','AOCI-Customers-NoN')
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('GS Repo','AOCII-GS-Repo')
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('JP Morgan','AOCII-JPM-Sale')
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('TBD','AOCI-TBD-TBD')
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('TBK Bank','AOCI-TBK-Sale')
INSERT INTO @tbldebtnametemp(DebtNameClientSheet,DebtName)VALUES('PNC 2025-01','AOCII-PNC-Subline')

Update CRE.Debt set CRE.Debt.DebtNameClientSheet = z.DebtNameClientSheet +'_New'
From(
	Select dt.accountid,eq.AbbreviationName,acc.name as DebtName,t1.DebtNameClientSheet
	from cre.debt dt
	Inner join core.account acc on acc.accountid =dt.accountid
	Left join cre.equity eq on eq.AccountID = dt.LinkedFundID
	Inner join @tbldebtnametemp t1 on t1.DebtName = acc.Name
	where acc.IsDeleted <> 1
	and acc.name in (
	'AOCI-3rd Party-Sale',
	'AOCI-Axos-NoN',
	'AOCI-OZK-Sale',
	'AOCI-Customers-NoN',
	'AOCII-GS-Repo',
	'AOCII-JPM-Sale',
	'AOCI-TBD-TBD',
	'AOCI-TBK-Sale',
	'AOCII-PNC-Subline'
	)
	--order by eq.AbbreviationName

)z
where CRE.Debt.AccountID = z.AccountID



---=====================

----Update for cona-repo
Update  cre.debt set  cre.debt.AbbreviationName = z.FacilityShortName,cre.debt.LinkedFundID = z.Eq_AccountID
From(
	Select dt.accountid,'CONA' as FacilityShortName,(Select accountid from cre.equity where AbbreviationName = 'ACP II') Eq_AccountID,'ACP II-CONA-Repo' new_DebtName
	from cre.debt dt
	Inner join core.account acc on acc.accountid =dt.accountid
	where acc.IsDeleted <> 1
	and acc.name in ('CONA REPO')

)z
Where cre.debt.AccountID = z.AccountID


Update CORE.Account set  CORE.Account.Name = z.LiabilityID,AccountTypeID = debttype
From(
	Select dt.accountid,'CONA' as FacilityShortName,(Select accountid from cre.equity where AbbreviationName = 'ACP II') Eq_AccountID,'ACP II-CONA-Repo' LiabilityID,acc.AccountTypeID as debttype
	from cre.debt dt
	Inner join core.account acc on acc.accountid =dt.accountid
	where acc.IsDeleted <> 1
	and acc.name in ('CONA REPO')
)z
Where CORE.Account.AccountID = z.AccountID

