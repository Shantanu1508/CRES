
-- [dbo].[usp_GetWFApprover] 'B0E6697B-3534-4C09-BE0A-04473401AB93'
CREATE PROCEDURE [dbo].[usp_GetWFApprover] --'B0E6697B-3534-4C09-BE0A-04473401AB93'

@UserID nvarchar(256)


AS
BEGIN
	SET NOCOUNT ON;

SELECT e.EmailId, u.Login, e.EmailNotificationID,e.ModuleId,e.Status, u.FirstName , u.LastName,
CASE
	WHEN l.Name = '1st Approval' THEN 'First draw approver'
	WHEN l.Name = 'Tier 1 Approval' THEN 'Tier 1 approver'
	WHEN l.Name = 'Tier 2 Approval' THEN 'Tier 2 approver'
	ELSE l.Name
	END AS Name

 FROM [App].[EmailNotification] e
left join  [CORE].[Lookup] l ON l.LookupID = e.ModuleId
left join [App].[User] u ON  u.Email = e.EmailId
WHERE e.ModuleId in ('552','606','617','720')
ORDER BY Name, u.FirstName, u.LastName


END
