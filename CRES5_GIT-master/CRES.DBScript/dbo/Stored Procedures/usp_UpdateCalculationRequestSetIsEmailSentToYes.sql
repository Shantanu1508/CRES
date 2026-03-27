CREATE PROCEDURE [dbo].[usp_UpdateCalculationRequestSetIsEmailSentToYes] 
(
	@CalculationRequestID nvarchar(256)
)
AS
BEGIN
    SET NOCOUNT ON;
    update Core.CalculationRequests
    set IsEmailSent = 3
    where CalculationRequestID = @CalculationRequestID
END