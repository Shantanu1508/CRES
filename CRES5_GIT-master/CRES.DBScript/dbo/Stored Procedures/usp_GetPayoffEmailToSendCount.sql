CREATE PROCEDURE [dbo].[usp_GetPayoffEmailToSendCount]
AS
BEGIN
    SET NOCOUNT ON;
    select count(*)
    from Core.CalculationRequests
    where CalcType = 776
          and IsEmailSent = 4
          and StatusID = 266
END