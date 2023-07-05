
CREATE PROCEDURE [dbo].[usp_DeleteNoteDataSizer] 
@crenoteid nvarchar(256)

AS
BEGIN

exec usp_DeleteRateSpreadScheduleSizer @crenoteid
exec usp_DeletePrepayScheduleSizer @crenoteid
exec usp_DeleteAmortScheduleSizer @crenoteid
exec usp_DeleteNoteFundingScheduleSizer @crenoteid
exec usp_DeleteFeeCouponSizer @crenoteid
exec  usp_DeletePIKScheduleDetailSizer @crenoteid
exec usp_DeletePIKScheduleSizer @crenoteid
--exec usp_DeleteStrippingScheduleSizer  @crenoteid
exec usp_DeleteSizerDocuments @crenoteid

END

