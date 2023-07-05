CREATE Procedure [dbo].[usp_InsertDelegateHistory]
@delegatedUserID UNIQUEIDENTIFIER,
@userID UNIQUEIDENTIFIER,
@entryType as  nvarchar(256),
@requestType nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;

if @RequestType='Start' 
BEGIN
			/* Ending previous session */
			UPDATE  [App].[DelegateHistory] 
				set SessionEnddate = GETDATE() ,
				EntryType = (select LookupID from Core.Lookup WHERE ParentID=97 and [Name]='System'),
				SessionStatus =2					                      
			WHERE SessionEndDate is null and DelegatedUserID = @delegatedUserID and SessionStatus=1

			/* Inserting log for new session */
				INSERT INTO  [App].[DelegateHistory]
				(
					[UserID] ,
					[DelegatedUserID], 
					SessionStartdate ,	
					EntryType ,
					SessionStatus,
					CreatedDate,
					CreatedBy ,
					UpdatedDate  ,
					UpdatedBy	
				)
				Values(
						@UserID ,
						@DelegatedUserID, 
						GETDATE(),
						(select LookupID from Core.Lookup where ParentID=97 and Name=@entryType),
						1,
						GETDATE(),
						@DelegatedUserID,
						GETDATE(),
						@DelegatedUserID
				) 
			END
END
if @RequestType='End' 
BEGIN
				/* Ending session */
				Update  [App].[DelegateHistory] 
							set SessionEnddate =GETDATE() ,
							 EntryType = (select LookupID from Core.Lookup where ParentID=97 and Name=@entryType),
							SessionStatus =2,
							UpdatedDate=  GETDATE(),
				            UpdatedBy=  @delegatedUserID                     
		                 where SessionEnddate is null and DelegatedUserID = @delegatedUserID and SessionStatus=1

END
