
--Drop PROCEDURE [dbo].[usp_SaveTranscations]
Create PROCEDURE [dbo].[usp_SaveTranscations]
@TmpTrans TableTypeTranscationRecon READONLY,
@CreatedBy nvarchar(256)

AS
BEGIN


	Update cre.TranscationReconciliation
    SET 
	
	M61Value=tr.M61Value,
	ServicerValue=tr.ServicerValue,
	comments=tr.comments,
	overridevalue=tr.overridevalue,
	Ignore=tr.Ignore,
	UpdatedBy=@CreatedBy,
	Adjustment=tr.Adjustment,
	ActualDelta=tr.ActualDelta,
	OverrideReason=tr.OverrideReason,
	WriteOffAmount = tr.WriteOffAmount,
	AddlInterest = tr.AddlInterest,
	TotalInterest = tr.TotalInterest
    from @TmpTrans tr
    Where cre.TranscationReconciliation.Transcationid = tr.Transcationid


	END
