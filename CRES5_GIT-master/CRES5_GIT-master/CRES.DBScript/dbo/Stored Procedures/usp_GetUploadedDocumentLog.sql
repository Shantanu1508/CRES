
--[usp_GetUploadedDocumentLog] '3bbeac70-f8a0-49ee-906d-1e4d40cd16e7','ca55e008-c06f-4ab4-907c-97eecfa4c731','283','2018-8-28 15:48',1,1,30,0
CREATE PROCEDURE [dbo].[usp_GetUploadedDocumentLog]
 -- Add the parameters for the stored procedure here  
 @UserID nvarchar(256) ,
 @ObjectID nvarchar(max), 
 @ObjectTypeID nvarchar(max),
 @currentTime nvarchar(50),
 @Status int,
 @PgeIndex INT=1,
 @pageSize INT=40,
 @TotalCount INT OUTPUT 
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  

 SELECT @TotalCount = COUNT(total.UploadedDocumentLogID) from (select UploadedDocumentLogID FROM [App].[UploadedDocumentLog] ud
   INNER JOIN App.[User] us ON us.UserID = ud.UpdatedBy 
   LEFT JOIN core.Lookup l on l.LookupID = ObjectTypeID
   LEFT JOIN cre.Note n on n.NoteID = ud.ObjectID
   LEFT JOIN core.Account ac on ac.AccountID = n.Account_AccountID
   LEFT JOIN cre.deal d on d.DealID=ud.ObjectID
   JOIN Core.Lookup ls on ud.[Status] =ls.LookupID
   WHERE ObjectID = @ObjectID AND ObjectTypeID = @ObjectTypeID AND ud.IsDeleted = 0 and ud.[Status] = @Status
  UNION
  select UploadedDocumentLogID FROM [App].[UploadedDocumentLog] ud
   INNER JOIN App.[User] us ON us.UserID = ud.UpdatedBy 
   LEFT JOIN core.Lookup l on l.LookupID = ObjectTypeID
   JOIN (select NoteID,Account_AccountID from cre.Note where DealID=@ObjectID and @ObjectTypeID =283) n on cast (n.NoteID as nvarchar(50)) = ud.ObjectID
   JOIN core.Account ac on ac.AccountID = n.Account_AccountID
   JOIN Core.Lookup ls on ud.[Status] =ls.LookupID
   WHERE ud.IsDeleted = 0 and @ObjectTypeID =283 and ud.[Status] = @Status
  
  ) as total


--get documents of specific deal or note
SELECT ud.UploadedDocumentLogID 
   , ud.[FileName]
   , ud.[OriginalFileName]
   , ud.[CreatedBy]
   , ud.[CreatedDate]
   , ud.updateddate
   , ud.[DocumentTypeID]
   , (Select Name from core.lookup WHERE LookupID = ud.[DocumentTypeID] ) AS DocumentType
   , ud.Comment
   , us.FirstName+' ' + us.LastName AS UserFullName 
   ,CASE 
	  when (cast(ud.[UpdatedDate] as date)< cast(GETDate() as date)) Then CONVERT(VARCHAR(10), ud.UpdatedDate, 101)  --format(ud.UpdatedDate,'MMM dd') 
	  else
			dbo.ufn_GetUserNotificationTime(@currentTime,ud.CreatedDate)---  format(un.UpdatedDate,'hh:mm tt') 
	  end 'UploadedTime'
	,(case when l.LookupID=182 then ac.Name when l.LookupID=283 then d.DealName else null end) Name
	,l.Name as ObjectType
	,ObjectID
	,ObjectTypeID
	,DocumentStorageID
	,(Select Name from core.lookup WHERE LookupID = ud.[StorageTypeID] ) AS Storagetype

   FROM [App].[UploadedDocumentLog] ud
   INNER JOIN App.[User] us ON us.UserID = ud.UpdatedBy 
   LEFT JOIN core.Lookup l on l.LookupID = ObjectTypeID
   LEFT JOIN cre.Note n on n.NoteID = ud.ObjectID
   LEFT JOIN core.Account ac on ac.AccountID = n.Account_AccountID
   LEFT JOIN cre.deal d on d.DealID=ud.ObjectID
   JOIN Core.Lookup ls on ud.[Status] =ls.LookupID
   WHERE ObjectID = @ObjectID AND ObjectTypeID = @ObjectTypeID AND ud.IsDeleted = 0 and ud.[Status] = @Status
   
   Union
   --get documents of all notes belongs to this deal
   SELECT ud.UploadedDocumentLogID 
   , ud.[FileName]
   , ud.[OriginalFileName]
   , ud.[CreatedBy]
   , ud.[CreatedDate]
   , ud.updateddate
   , ud.[DocumentTypeID]
   , (Select Name from core.lookup WHERE LookupID = ud.[DocumentTypeID] ) AS DocumentType
   , ud.Comment
   , us.FirstName+' ' + us.LastName AS UserFullName 
   ,CASE 
	  when (cast(ud.[UpdatedDate] as date)< cast(GETDate() as date)) Then CONVERT(VARCHAR(10), ud.UpdatedDate, 101)  --format(ud.UpdatedDate,'MMM dd') 
	  else
			dbo.ufn_GetUserNotificationTime(@currentTime,ud.CreatedDate)---  format(un.UpdatedDate,'hh:mm tt') 
	  end 'UploadedTime'
	,ac.Name
	,l.Name as ObjectType
	,ObjectID
	,ObjectTypeID
	,DocumentStorageID
	,(Select Name from core.lookup WHERE LookupID = ud.[StorageTypeID] ) AS Storagetype

   FROM [App].[UploadedDocumentLog] ud
   INNER JOIN App.[User] us ON us.UserID = ud.UpdatedBy 
   LEFT JOIN core.Lookup l on l.LookupID = ObjectTypeID
   JOIN (select NoteID,Account_AccountID from cre.Note where DealID=@ObjectID and @ObjectTypeID =283) n on cast (n.NoteID as nvarchar(50)) = ud.ObjectID
   JOIN core.Account ac on ac.AccountID = n.Account_AccountID
   JOIN Core.Lookup ls on ud.[Status] =ls.LookupID
   WHERE ud.IsDeleted = 0 and @ObjectTypeID =283 and ud.[Status] = @Status


   ORDER by ud.updateddate desc
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY

END


