
--[usp_GetSearchBykey] '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,'A Note',''

CREATE PROCEDURE [dbo].[usp_GetSearchBykey] 
    @UserID UNIQUEIDENTIFIER,
    @PageIndex INT,
    @PageSize INT,
	@SearchKey VARCHAR(500),
	@TotalCount INT OUTPUT 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @LID_Phantom int = (Select lookupid from core.lookup where ParentID = 51 and Name = 'Phantom')


	 
if CHARINDEX('\\',@SearchKey) > 0 
BEGIN
		set  @SearchKey= replace(@SearchKey,'\\','\')
END

if CHARINDEX('\-',@SearchKey)>0
BEGIN
		set  @SearchKey= replace(@SearchKey,'\','')
END
	
SELECT @TotalCount = 0; --COUNT(DealID) FROM CRE.Deal WHERE DealName LIKE @SearchKey + '%' ;
     



IF EXISTS(SELECT u.UserID FROM [App].[User] u Inner join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID] Inner join [App].[Role] r on r.[RoleID] = rm.[RoleID]	where u.UserID = @UserID and RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM('Asset Manager')) )
BEGIN
	PRINT('Y')
	SELECT 
	ValueID,
	Valuekey,
	ValueType FROM
	(
		Select 
		Distinct si.SearchText AS Valuekey,
		ObjectID AS ValueID,
		ObjectTypeID AS ValueType,
		si.[Rank]
		from App.SearchItem si
		Inner join App.Object obj on si.Object_ObjectAutoID = obj.ObjectAutoID 
		WHERE si.SearchText LIKE '%' + @SearchKey + '%'
		and ObjectTypeID in (182,283,842,843,844)
		and ObjectID not in 
			(
				Select DealID as Phtm_ObjectID from CRE.Deal where [Status] = @LID_Phantom
				UNION ALL
				Select n.NoteID as Phtm_ObjectID from cre.note n inner join cre.deal d on d.dealid = n.dealid where d.[Status] = @LID_Phantom
			)
	) Search
	ORDER BY Search.[Rank] DESC
END
ELSE
BEGIN
	PRINT('N')
	SELECT 
	ValueID,
	Valuekey,
	ValueType FROM
	(
		Select 
		Distinct si.SearchText AS Valuekey,
		ObjectID AS ValueID,
		ObjectTypeID AS ValueType,
		si.[Rank]
		from App.SearchItem si
		Inner join App.Object obj on si.Object_ObjectAutoID = obj.ObjectAutoID 
		WHERE si.SearchText LIKE '%' + @SearchKey + '%'
		and ObjectTypeID in (182,283,842,843,844)
	) Search
	ORDER BY Search.[Rank] DESC
END






------------------------------------------------------------------
 --   SELECT * FROM
	--  (
	-- SELECT TOP (@PageSize) DealID AS ValueID
 --     ,DealName AS Valuekey
	--  , 1 AS ValueType
	--   FROM CRE.Deal d   
	--   WHERE DealName LIKE '%' + @SearchKey + '%'
 --      ORDER BY d.UpdatedDate DESC
	----OFFSET @PgeIndex - 1 ROWS
	----FETCH NEXT @PageSize ROWS ONLY
	--  ) Search1

	 

 --   UNION ALL

	-- SELECT * FROM
	--  (
	--   SELECT TOP (@PageSize) NoteID AS ValueID
	--	 ,a.Name  AS Valuekey	
	--	  , 2 AS ValueType	 
	--	FROM CRE.Note n inner join Core.Account a on Account_AccountID=a.AccountID
	--	 WHERE a.Name LIKE '%' + @SearchKey + '%'
 --        ORDER BY n.UpdatedDate DESC
 --      ) Search2


	--    UNION ALL

	-- SELECT * FROM
	--  (
	--   SELECT TOP (@PageSize) NoteID AS ValueID
	--	 , n.CRENoteID AS Valuekey	
	--	  , 2 AS ValueType	 
	--	FROM CRE.Note n 
	--	 WHERE n.CRENoteID LIKE '%' + @SearchKey + '%'
 --        ORDER BY n.UpdatedDate DESC
 --      ) Search3



 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END      









