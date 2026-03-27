
--INSERT INTO Core.Event (EffectiveStartDate, AccountID, EventTypeID, StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate, AdditionalAccountID) 
--Select 
--	D.OriginationDate as EffectiveDate,
--	DebtAccountID,
--	914,
--	1,
--	'B0E6697B-3534-4C09-BE0A-04473401AB93',
--	getdate(),
--	'B0E6697B-3534-4C09-BE0A-04473401AB93',
--	getdate(), 
--	AdditionalAccountID 
--	from Cre.Debt D 
--	INNER JOIN cre.debtext DE 
--	ON DE.DebtAccountID = D.AccountID
--	WHERE D.OriginationDate IS NOT NULL;
	


--INSERT INTO [Core].[InterestExpenseSchedule] (EventId, InitialInterestAccrualEndDate,PaymentDayOfMonth,PaymentDateBusinessDayLag,DeterminationDateLeadDays,DeterminationDateReferenceDayOftheMonth,InitialIndexValueOverride,FirstRateIndexResetDate,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--SELECT E.EventID, DE.InitialInterestAccrualEndDate,De.PaymentDayOfMonth,DE.PaymentDateBusinessDayLag,DE.DeterminationDateLeadDays,DE.DeterminationDateReferenceDayOftheMonth,DE.InitialIndexValueOverride,DE.FirstRateIndexResetDate, 
--'B0E6697B-3534-4C09-BE0A-04473401AB93',
--	getdate(),
--	'B0E6697B-3534-4C09-BE0A-04473401AB93',
--	getdate()
--FROM Cre.Debt D 
--	INNER JOIN cre.debtext DE 
--	ON DE.DebtAccountID = D.AccountID
--	INNER JOIN CORE.Event E ON E.EventTypeID=914 AND E.StatusID=1 AND E.AccountID = DE.DebtAccountID 
--	AND E.AdditionalAccountID = DE.AdditionalAccountID AND E.EffectiveStartDate = D.OriginationDate
--	WHERE D.OriginationDate IS NOT NULL;
