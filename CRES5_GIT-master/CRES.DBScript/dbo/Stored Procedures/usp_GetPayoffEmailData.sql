CREATE PROCEDURE [dbo].[usp_GetPayoffEmailData]
AS
BEGIN
    SET NOCOUNT ON;
    select CalculationRequestID
         , AnalysisID
         , d.DealID
		 ,d.DealName
         , d.PrepayDate
         , UserName
         , u.Email
		 ,u.FirstName
    from Core.CalculationRequests cr
        Inner Join cre.Deal d on cr.DealID = d.DealID
        Left Join App.[User] u  on cr.UserName = u.UserID
    where CalcType = 776 and cr.StatusID = 266 and IsEmailSent=4
END