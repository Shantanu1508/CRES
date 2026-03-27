-- [dbo].[usp_GetFCApprover] 'B0E6697B-3534-4C09-BE0A-04473401AB93'
CREATE PROCEDURE [dbo].[usp_GetFCApprover] --'B0E6697B-3534-4C09-BE0A-04473401AB93'

@UserID nvarchar(256)


AS
BEGIN
	SET NOCOUNT ON;

	declare @tFCApprover table
	(
	ID int identity(1,1),
	FirstName nvarchar(256),
	LastName nvarchar(256),
	UserID uniqueidentifier,
	RoleName nvarchar(50),
	SortOrder int
	)

	insert into @tFCApprover
    SELECT '-' ,'','00000000-0000-0000-0000-000000000000','None',0


	insert into @tFCApprover
    SELECT  FirstName ,LastName,u.UserID,RoleName,1 from 
	(
     SELECT  count(UserID) cnt ,u.UserID,'T1-T2' as RoleName
		FROM [App].[EmailNotification] e
		left join  [CORE].[Lookup] l ON l.LookupID = e.ModuleId
		left join [App].[User] u ON  u.Email = e.EmailId
		WHERE e.ModuleId in ('552','617')
		group by UserID having count(UserID)>1
	) a 
	join [App].[User] u ON  u.UserID = a.UserID

	insert into @tFCApprover
		SELECT   u.FirstName , u.LastName,u.UserID, RoleName =(case when l.LookupID=617 then 'T1' else 'T2' end),1
	 FROM [App].[EmailNotification] e
	left join  [CORE].[Lookup] l ON l.LookupID = e.ModuleId
	left join [App].[User] u ON  u.Email = e.EmailId
	WHERE e.ModuleId in ('552','617') 
	and u.UserID not in (select UserID from @tFCApprover)

	select FirstName,LastName,UserID,RoleName from @tFCApprover order by SortOrder,FirstName,LastName

END
GO

