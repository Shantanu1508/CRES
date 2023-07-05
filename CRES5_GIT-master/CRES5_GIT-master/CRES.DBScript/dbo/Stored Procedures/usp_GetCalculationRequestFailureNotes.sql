-- Procedure
--SET FMTONLY OFF
--GO

CREATE PROCEDURE [dbo].[usp_GetCalculationRequestFailureNotes]
@ModuleId INT
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	--get receiver email ids 
	DECLARE @EmailIds NVARCHAR(2000)
	SELECT @EmailIds = LEFT(email, LEN(email) - 1)
	FROM (
    SELECT EmailId + ','
    FROM App.EmailNotification WHERE ModuleId = @ModuleId
	AND [Status]=1
    FOR XML PATH ('')
  ) c (email)
	
	SELECT ac.Name,n.NoteID,n.CRENoteID,d.DealID,d.CREDealID,d.DealName,RTRIM(ISNULL(u.FirstName,'')+ ' '+ISNULL(u.LastName,'')) as UserName,cr.StartTime,cr.EndTime,
	cr.ErrorMessage,@EmailIds as EmailIds 
	FROM CRE.NOTE n 
	INNER JOIN CORE.Account ac ON ac.AccountID = n.Account_AccountID
	INNER JOIN Core.CalculationRequests cr ON cr.NoteId= n.NoteID
	INNER JOIN CRE.Deal d ON d.DealID = n.DealID
	LEFT JOIN App.[User] u ON u.UserID=cr.UserName
	WHERE cr.statusid = 265 AND CONVERT(DATE, cr.RequestTime) = CONVERT(DATE, GETDATE()) and ac.IsDeleted=0
	and cr.CalcType = 775
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


