--[usp_GetAllReportFileLog] 'b0e6697b-3534-4c09-be0a-04473401ab93',null,643,'2020-4-15 11:13',1,'4/14/2020 6:30:00 PM','4/15/2020 6:30:00 PM',1,30,0
--[usp_GetAllReportFileLog] 'b0e6697b-3534-4c09-be0a-04473401ab93','96c3a0cd-1e96-48ee-bdb6-7d229bb2cd25',643,'2020-4-15 11:13',1,'4/14/2020 6:30:00 PM','4/15/2020 6:30:00 PM',1,30,0

CREATE PROCEDURE [dbo].[usp_GetAllReportFileLog]
 -- Add the parameters for the stored procedure here  
 @UserID nvarchar(256) ,
 @ObjectGUID nvarchar(256), 
 @ObjectTypeID nvarchar(max),
 @currentTime nvarchar(50),
 @Status int,
 @StartDate Date,
 @EndDate Date,
 @PgeIndex INT=1,
 @pageSize INT=40,
 @TotalCount INT OUTPUT 
AS  
BEGIN  
 declare @ObjectID int
 
 IF (@ObjectGUID IS NOT NULL)
 BEGIN
	SELECT @ObjectID = ObjectID FROM [App].[ReportFileLog] WHERE ObjectGUID=@ObjectGUID
 END
 SELECT @TotalCount = COUNT(total.ReportFileLogID) from (select ReportFileLogID FROM [App].[ReportFileLog] rl
   LEFT JOIN App.[User] us ON cast(us.UserID as nvarchar(256)) = rl.UpdatedBy 
   LEFT JOIN core.Lookup l on l.LookupID = ObjectTypeID
   LEFT JOIN App.[ReportFile] rf on rf.ReportFileID = rl.ObjectID
   JOIN Core.Lookup ls on rl.[Status] =ls.LookupID
   WHERE 
  ObjectTypeID = @ObjectTypeID AND rl.IsDeleted = 0 and rl.[Status] = @Status
   AND (
	   (@ObjectGUID Is NOT NULL and @ObjectGUID <>'00000000-0000-0000-0000-000000000000' and ObjectID = @ObjectID)   OR (@ObjectGUID Is NULL OR @ObjectGUID='00000000-0000-0000-0000-000000000000')
   )
   AND(
   (@StartDate IS NOT NULL AND cast(rl.CreatedDate as Date)>=cast(@StartDate as Date) AND cast(rl.CreatedDate as Date)<=cast(@EndDate as Date))
   OR @StartDate IS NULL 
   )
  ) as total

SELECT
rf.ReportFileName 
,rl.ReportFileLogID
,rl.UploadedDocumentLogID 
   , rl.[FileName]
   , rl.[OriginalFileName]
   , rl.[CreatedBy]
   , rl.[CreatedDate]
   , rl.updateddate
   , rl.Comment
   ,us.FirstName
   ,UserFullName=(case when us.FirstName is null then '' else (us.FirstName+' ' + us.LastName) end) 
   --, us.FirstName+' ' + us.LastName AS UserFullName 
   ,CASE 
	  when (cast(rl.[UpdatedDate] as date)< cast(GETDate() as date)) Then  Convert(nvarchar(10),[dbo].[ufn_GetTimeByTimeZone](rl.CreatedDate,@UserID),101)  --format(ud.UpdatedDate,'MMM dd') 
	  else
			stuff(right(Convert(nvarchar(256),[dbo].[ufn_GetTimeByTimeZone](rl.CreatedDate,@UserID),109),15),7,7,' ')---  format(un.UpdatedDate,'hh:mm tt') 
	  end 'UploadedTime'
	
	,'' as ObjectType
	,rl.ObjectID
	,rl.ObjectGUID
	,rl.ObjectTypeID
	,rl.DocumentStorageID
	,(Select Name from core.lookup WHERE LookupID = rl.[StorageTypeID] ) AS Storagetype
	,rl.StorageTypeID
	,rl.StorageLocation
	,rl.ReportFileAttributes
   FROM [App].[ReportFileLog] rl
   LEFT JOIN App.[User] us ON cast(us.UserID as nvarchar(256)) = rl.CreatedBy  
   LEFT JOIN core.Lookup l on l.LookupID = ObjectTypeID
   LEFT JOIN App.[ReportFile] rf on rf.ReportFileID = rl.ObjectID
   JOIN Core.Lookup ls on rl.[Status] =ls.LookupID
   WHERE 
    ObjectTypeID = @ObjectTypeID AND rl.IsDeleted = 0 and rl.[Status] = @Status
   AND (
	   (@ObjectGUID Is NOT NULL and @ObjectGUID <>'00000000-0000-0000-0000-000000000000' and ObjectID = @ObjectID)   OR (@ObjectGUID Is NULL OR @ObjectGUID='00000000-0000-0000-0000-000000000000')
   )
   AND(
   (@StartDate IS NOT NULL AND cast(rl.CreatedDate as Date)>=cast(@StartDate as Date) AND cast(rl.CreatedDate as Date)<=cast(@EndDate as Date))
   OR @StartDate IS NULL )

   ORDER by rl.CreatedDate desc
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY

END




