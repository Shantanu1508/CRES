CREATE Procedure [dbo].[usp_DeleteLiabilityNote_Temp] 
(
	 @EquityAccountID uniqueidentifier,
	 @DebtAccountID uniqueidentIfier
)
as 
BEGIN
	SET NOCOUNT ON;
---Delete liability noteid

--declare @EquityAccountID uniqueidentIfier ='A6C9C2D0-1CFC-4805-8850-C30A69FA3A21'  ---ACP II
--declare @DebtAccountID uniqueidentIfier   ='18F6EEEC-3822-4667-BA66-8481C915F78B'  ---MS Repo 1

---======================================
declare @tbLiabilityNote as table(
	liabilityNoteGUID uniqueidentIfier
)

INSERT INTO @tbLiabilityNote(liabilityNoteGUID)
SELECT Distinct ln.LiabilityNoteGUID
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
    SELECT am.AssetAccountId AS assetnotesid
    FROM cre.liabilitynote l
    INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
    WHERE l.LiabilityTypeID = @EquityAccountID
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID
where a.IsDeleted <> 1
and ln.LiabilityTypeID = @DebtAccountID


delete from [Core].[GeneralSetupDetailsLiabilityNote] where eventid in (
	select eventid from core.Event where eventtypeid = 841 and accountid in (Select accountid from cre.liabilitynote where liabilityNoteGUID in (Select liabilityNoteGUID from @tbLiabilityNote))
)

delete from [Core].RateSpreadScheduleLiability where eventid in (
	select eventid from core.Event where eventtypeid = 909 and accountid in (Select accountid from cre.liabilitynote where liabilityNoteGUID in (Select liabilityNoteGUID from @tbLiabilityNote))
)

delete from [Core].PrepayAndAdditionalFeeScheduleLiability where eventid in (
	select eventid from core.Event where eventtypeid = 908 and accountid in (Select accountid from cre.liabilitynote where liabilityNoteGUID in (Select liabilityNoteGUID from @tbLiabilityNote))
)

delete from [Core].[InterestExpenseSchedule] where eventid in (
	select eventid from core.Event where eventtypeid = 914 and accountid in (Select accountid from cre.liabilitynote where liabilityNoteGUID in (Select liabilityNoteGUID from @tbLiabilityNote))
)


delete from core.Event where eventtypeid in (841,909,908,914) and accountid in (Select accountid from cre.liabilitynote where liabilityNoteGUID in (Select liabilityNoteGUID from @tbLiabilityNote))

delete from cre.LiabilityNoteAssetMapping where LiabilityNoteAccountId in (select AccountID from cre.liabilitynote where liabilityNoteGUID in (Select liabilityNoteGUID from @tbLiabilityNote))

delete from cre.liabilitynote where liabilityNoteGUID in (Select liabilityNoteGUID from @tbLiabilityNote)


END
GO

