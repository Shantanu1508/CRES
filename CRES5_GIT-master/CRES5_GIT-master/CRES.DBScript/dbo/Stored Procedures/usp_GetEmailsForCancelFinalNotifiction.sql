
--[usp_GetEmailsForCancelFinalNotifiction] '738F62DA-6FC0-46AF-8DCB-BF97812089FD',502,'C24C8297-3B99-4BF1-8CE0-85DA85A86223'
CREATE PROCEDURE [dbo].[usp_GetEmailsForCancelFinalNotifiction] 
(
    @ObjectID varchar(5000),
	@ObjectTypeId INT,	
	@UserID nvarchar(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;

		declare @AllowWFInternalNotification nvarchar(10)=(select [Value] from app.AppConfig WHERE [key]='AllowWFInternalNotification'),
		@TaskID varchar(256)
		DECLARE @EmailNotification Table(
		 UserID UNIQUEIDENTIFIER,
		 Email varchar(5000),
		 UserName varchar(256)
		 )

if (@AllowWFInternalNotification='1') 
BEGIN
 IF(@ObjectTypeId = 502) -- Deal Funding
	BEGIN
	   --Enable/Disbale wf notification based on app.AppConfig flage
	  
		   SET @TaskID = @ObjectID

		   INSERT INTO @EmailNotification
						SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName FROM [CRE].[DealFunding] df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealFundingID FROM [CRE].[Deal] d
						JOIN  CRE.DealFunding df ON df.DealID = d.DealID
						WHERE df.DealFundingID = @TaskID
						

						) tbluser on tbluser.DealFundingID =df.DealFundingID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealFundingID = @TaskID

						UNION
						
						SELECT @UserID UserID,Email, FirstName +'  '+ LastName as UserName from app.[User] where UserID=@UserID
						UNION
						SELECT '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName  from App.EmailNotification where ModuleId=686
    END
ELSE IF(@ObjectTypeId = 719) -- Reserve Account
BEGIN
	   --Enable/Disbale wf notification based on app.AppConfig flage
	  
		   SET @TaskID = @ObjectID

		   INSERT INTO @EmailNotification
						SELECT DISTINCT u.UserID, u.Email, u.FirstName +'  '+ u.LastName as UserName FROM CRE.DealReserveSchedule df
						JOIN  CRE.Deal d ON d.DealID = df.DealID
						join
						( 
						SELECT AMUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AMSecondUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT AMTeamLeadUserID UserID,df.DealReserveScheduleGUID FROM [CRE].[Deal] d
						JOIN  CRE.DealReserveSchedule df ON df.DealID = d.DealID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT @UserID UserID,newid() from app.[User] where UserID=@UserID
						) tbluser on tbluser.DealReserveScheduleGUID =df.DealReserveScheduleGUID
						join App.[User] u on u.UserID=tbluser.UserID
						WHERE df.DealReserveScheduleGUID = @TaskID
						UNION
						SELECT @UserID UserID,Email, FirstName +'  '+ LastName as UserName from app.[User] where UserID=@UserID
						UNION
						SELECT '00000000-0000-0000-0000-000000000000' as UserID ,EmailId,'' as UserName  from App.EmailNotification where ModuleId=686

END

END

 select STUFF((SELECT distinct ', ' + Email
			FROM @EmailNotification where UserID <>'00000000-0000-0000-0000-000000000000'
			FOR XML PATH('')), 1, 2, '') as EmailToIds,
			STUFF((SELECT distinct ', ' + Email
			FROM @EmailNotification where UserID='00000000-0000-0000-0000-000000000000'
			FOR XML PATH('')), 1, 2, '') as EmailCCIds

END

