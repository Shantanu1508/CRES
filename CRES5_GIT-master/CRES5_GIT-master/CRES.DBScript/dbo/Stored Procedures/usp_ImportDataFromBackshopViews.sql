

CREATE PROCEDURE [dbo].[usp_ImportDataFromBackshopViews] --'2502','KrishnaBaderia'
As
BEGIN


TRUNCATE TABLE [IO].[IN_AcctDeal]
INSERT INTO [IO].[IN_AcctDeal] (ControlId,DealName,AssetManager,CommitmentAmount,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select ControlId,DealName,AssetManagerName,CommitmentAmount
from [acore].[vw_AcctDeal] vd'

-----------------------------------------------------

TRUNCATE TABLE [IO].[IN_AcctNote]
INSERT INTO [IO].[IN_AcctNote](ControlId,NoteId,NoteName,FundingDate,TotalCommitment,FirstPIPaymentDate,StatedMaturityDate,OrigLoanAmount,OriginationFee,LiborFloor,OriginationFeePct,InterestSpread,AmortIOPeriod,AmortizationTerm,PaymentFreqCd_F,PaymentFreqDesc,IntCalcMethodDesc,AccrualRate,DeterminationMethodDay,DeterminationDate,RoundingType,RoundingDenominator,lienposition ,[priority],ShardName)


EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select ControlId,NoteId,NoteName,FundingDate,TotalCommitment,FirstPIPaymentDate,StatedMaturityDate,OrigLoanAmount,OriginationFee,LiborFloor,OriginationFeePct,InterestSpread,AmortIOPeriod,AmortizationTerm,PaymentFreqCd_F,PaymentFreqDesc,IntCalcMethodDesc,AccrualRate,DeterminationMethodDay,DeterminationDate,RoundingType,RoundingDenominator,lienposition ,priority
FROM [acore].[vw_AcctNote] '

-----------------------------------------------------

TRUNCATE TABLE [IO].[IN_AcctNoteExt]
INSERT INTO [IO].[IN_AcctNoteExt] (ControlId,NoteId_F,NoteExtensionId,ExtStatedMaturityDate,ExecutedSw,ShardName)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select 
ControlId,NoteId_F,NoteExtensionId,ExtStatedMaturityDate,ExecutedSw
from [acore].[vw_AcctNoteExt]'

-----------------------------------------------------

TRUNCATE TABLE [IO].[IN_AcctProperty]

INSERT INTO [IO].[IN_AcctProperty] (ControlId,PropertyId,PropertyName,City,[state],PropertyTypeMajorCd_F,PropertyTypeMajorDesc,ShardName)
EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'Select 
ControlId,PropertyId,PropertyName,City,[state],PropertyTypeMajorCd_F,PropertyTypeMajorDesc
from [acore].[vw_AcctProperty]'

-----------------------------------------------------


END



