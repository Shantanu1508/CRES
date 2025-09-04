--[dbo].[usp_GetServicingLogByNoteID] '1e5f84e6-3ee8-4907-b9d6-7fbd0f81a7ab'  ,'C10F3372-0FC2-4861-A9F5-148F1F80804F'


CREATE PROCEDURE [dbo].[usp_GetServicingLogByNoteID] --'69f7abd1-c9c4-414d-8846-bc7247c9522b'
	@NoteID nvarchar(256),
	@Analysisid UNIQUEIDENTIFIER

AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @UseActuals int;
Declare @ServicerMasterID int;
Declare @ServicerModifiedID int;
Declare @ServicerManual int;

SET @UseActuals =  (Select UseActuals from core.analysis a inner join core.analysisparameter am on am.analysisid = a.analysisid where a.Analysisid = @Analysisid)
SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')	
SET @ServicerModifiedID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'Modified')	
SET @ServicerManual = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'ManualTransaction')
	--====================================


IF(@UseActuals = 3)
BEGIN

	select
	Cast(ntd.RelatedtoModeledPMTDate as datetime) TransactionDate,
	--l1.Name,
	TransactionTypeText as [Name], 
	--(Case 
	--	When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue
	--	When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount
	--	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount
	--	When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue
	--	ELSE ntd.CalculatedAmount
	--END) as Amount,

	--(CASE WHEN (ty.Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	--WHEN (ty.Calculated = 3 and AllowCalculationOverride = 3) THEN ntd.CalculatedAmount
	--WHEN (ty.Calculated = 4 and ServicerMasterID <> @ServicerManual) THEN ntd.CalculatedAmount	
	--WHEN (ty.Calculated = 4 and ServicerMasterID = @ServicerManual) THEN (Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	--ELSE ntd.CalculatedAmount END) as Amount,

	(CASE WHEN (ty.Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	WHEN (ty.Calculated = 3 and AllowCalculationOverride = 3) THEN ntd.CalculatedAmount
	WHEN (ty.Calculated = 4 and ServicerMasterID <> @ServicerManual) THEN ntd.CalculatedAmount	
	WHEN (ty.Calculated = 4 and ServicerMasterID = @ServicerManual) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	ELSE ntd.CalculatedAmount END) as Amount,

	

	Cast(ntd.RelatedtoModeledPMTDate as datetime) RelatedtoModeledPMTDate,
	ntd.Adjustment,
	ntd.ActualDelta,
	(Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) as UsedInFeeRecon,

	(Cast((Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime)
	WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN RemittanceDate
	ELSE RelatedtoModeledPMTDate END) as datetime) ) as TransactionDateByRule,

	ntd.TransactionDate as TransactionDateServicingLog,
	ntd.RemittanceDate,
	DATEADD(day,1,note.InitialInterestAccrualEndDate) as InitialInterestAccrualEndDate,
	ntd.WriteOffAmount,
	ntd.TotalInterest as CashInterest,
	ntd.AddlInterest as CapitalizedInterest

	from cre.NoteTransactionDetail ntd
	inner join CRE.Note note on note.NoteID = ntd.NoteID 
	inner join Core.Account ac on note.Account_AccountID=ac.AccountID
	left join Core.Lookup l1 on l1.LookupID =ntd.TransactionType 
	left join cre.TransactionTypes ty on ty.TransactionName = ntd.TransactionTypeText
	where note.NoteID  = @NoteID
	and ac.IsDeleted=0

	and ((Calculated = 3 and IncludeServicingReconciliation = 3) 
			or (Calculated = 3 and AllowCalculationOverride = 3 and ntd.ServicerMasterID = @ServicerModifiedID) 
			or (Calculated = 4))


	order by ntd.RelatedtoModeledPMTDate asc,ntd.TransactionDate asc

END

IF(@UseActuals = 4)
BEGIN
	

	select
	Cast(ntd.RelatedtoModeledPMTDate as datetime) TransactionDate,
	--l1.Name,
	TransactionTypeText as [Name], 
	(CASE 
	----WHEN (ty.Calculated = 4 and ntd.ServicerMasterID <> @ServicerManual) THEN ntd.CalculatedAmount	
	----WHEN (ty.Calculated = 4 and ntd.ServicerMasterID = @ServicerManual) THEN ntd.CalculatedAmount --(Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	WHEN (ty.Calculated = 4) THEN ntd.CalculatedAmount	
	ELSE
		(Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue
		When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount
		When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount
		When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue
		ELSE ntd.CalculatedAmount END) 
	END)
	as Amount,
	Cast(ntd.RelatedtoModeledPMTDate as datetime) RelatedtoModeledPMTDate,
	ntd.Adjustment,
	ntd.ActualDelta ,
	(Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) as UsedInFeeRecon,

	(Cast((Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime)
	WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN RemittanceDate
	ELSE RelatedtoModeledPMTDate END) as datetime) ) as TransactionDateByRule,

	ntd.TransactionDate as TransactionDateServicingLog,
	ntd.RemittanceDate,
	DATEADD(day,1,note.InitialInterestAccrualEndDate) as InitialInterestAccrualEndDate,
	ntd.WriteOffAmount,
	ntd.TotalInterest as CashInterest,
	ntd.AddlInterest as CapitalizedInterest

	from cre.NoteTransactionDetail ntd
	inner join CRE.Note note on note.NoteID = ntd.NoteID 
	inner join Core.Account ac on note.Account_AccountID=ac.AccountID
	left join Core.Lookup l1 on l1.LookupID =ntd.TransactionType 
	left join cre.TransactionTypes ty on ty.TransactionName = ntd.TransactionTypeText
	
	where note.NoteID = @NoteID
	and ac.IsDeleted=0
	and ((ty.Calculated = 3 and ty.AllowCalculationOverride = 3 and ntd.ServicerMasterID = @ServicerModifiedID ) or (ty.Calculated = 4))	
	order by ntd.RelatedtoModeledPMTDate asc,ntd.TransactionDate asc

END




	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

