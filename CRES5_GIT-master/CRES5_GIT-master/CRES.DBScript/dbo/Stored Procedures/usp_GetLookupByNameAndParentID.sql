
--[usp_GetLookupByNameAndParentID] null,71
CREATE Procedure [dbo].[usp_GetLookupByNameAndParentID]  --null,null  --  'b9b9c9b6-f5cc-4701-b646-00a9ea0f543b','c10f3372-0fc2-4861-a9f5-148f1f80804f','b0e6697b-3534-4c09-be0a-04473401ab93'
(  
 @Name nvarchar(256),  
 @ParentID int,
 @LookupID int = null
)  
as   
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   print @Name
   print @ParentID
 IF (@LookupID is not null)
 BEGIN
 SELECT [LookupID]
      ,[ParentID]
      ,[Name]
      ,[Value]
      ,[Value1]
      ,[SortOrder]
      ,[StatusID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [Core].[Lookup]
  WHERE LookupID = @LookupID and ISNULL(StatusID,1)=1
 END
 
 
 ELSE IF (@Name IS NOT NULL and (@ParentID IS NULL OR @ParentID=0))
 BEGIN
 SELECT [LookupID]
      ,[ParentID]
      ,[Name]
      ,[Value]
      ,[Value1]
      ,[SortOrder]
      ,[StatusID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [Core].[Lookup]
  WHERE Name = @Name and ISNULL(StatusID,1)=1
 END
  
  ELSE IF (@Name IS NULL and @ParentID IS NOT NULL)
  BEGIN
  SELECT [LookupID]
      ,[ParentID]
      ,[Name]
      ,[Value]
      ,[Value1]
      ,[SortOrder]
      ,[StatusID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [Core].[Lookup]
  WHERE ParentID = @ParentID and ISNULL(StatusID,1)=1
  END

  ELSE IF (@Name IS NULL and @ParentID IS NULL)
  BEGIN
  SELECT [LookupID]
      ,[ParentID]
      ,[Name]
      ,[Value]
      ,[Value1]
      ,[SortOrder]
      ,[StatusID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [Core].[Lookup] where  ISNULL(StatusID,1)=1
  END
  ELSE IF (@Name IS NOT NULL and @ParentID IS NOT NULL)
  BEGIN
  SELECT [LookupID]
      ,[ParentID]
      ,[Name]
      ,[Value]
      ,[Value1]
      ,[SortOrder]
      ,[StatusID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
  FROM [Core].[Lookup]
  WHERE Name = @Name AND ParentID = @ParentID  and ISNULL(StatusID,1)=1
  END
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END

