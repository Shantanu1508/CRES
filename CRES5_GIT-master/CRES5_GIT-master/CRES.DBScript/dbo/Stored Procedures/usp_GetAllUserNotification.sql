

--exec [dbo].[usp_GetAllUserNotification] '76226BCD-6051-402E-A2C4-ED8E52180B86','2019-12-05 13:35',1,10,0
CREATE PROCEDURE [dbo].[usp_GetAllUserNotification]
 -- Add the parameters for the stored procedure here  
 @UserID nvarchar(256) ,
 @currentTime nvarchar(50),
 @PgeIndex INT=1,
 @pageSize INT=20,
 @TotalCount INT OUTPUT 
AS  
BEGIN  
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  


  select @TotalCount =count(un.UserNotificationID) FROM [App].[UserNotification] un left join App.NotificationSubscription  ns on un.NotificationSubscriptionID=ns.NotificationSubscriptionID
 where ns.UserID=@UserID and un.[CleanTime] is null
 --Declare @floor int,@remainder int, @calc_pageSize int;

 --Set @floor = @TotalCount / @pageSize;
 --Set @remainder = @TotalCount % @pageSize;

 --IF @floor <= @PgeIndex
 --BEGIN

	--IF @floor = @PgeIndex
	--BEGIN
	--	SET @calc_pageSize= @pageSize + @remainder;
	--END
	--ELSE
	--BEGIN
	--	SET @calc_pageSize = @pageSize;
	--END

	SELECT  un.[UserNotificationID]
      ,un.[NotificationSubscriptionID]
      ,un.[ViewedTime]
      ,un.[CleanTime]
      ,un.[ObjectId]
      ,un.[ObjectTypeId]
	  ,
	  
		CASE WHEN un.[ObjectTypeId] = 283 THEN (Select n.Msg1 +' <b><a  href=#/dealdetail/' +++ CAST(d.dealid  AS varchar(50)) +++'>'+dealname +'</a></b> '+ ' ' + (CASE when un.generatedby=256 then 'has been imported from Backshop by ' else  n.msg2  END)+'  '+ 
		(CASE When EXISTS (SELECT 1 WHERE d.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
		THEN (Select '<b>' + FirstNAme+' '+LastName + '</b>' from App.[User] where UserId = un.UpdatedBy) 
		ELSE un.UpdatedBy END
		) from CRE.Deal d where d.dealid = un.[ObjectId] and d.IsDeleted=0)
	 
	 WHEN un.[ObjectTypeId] = 182 THEN (Select n.Msg1 +' <b><a href=#/notedetail/' + CAST(nt.NoteID  AS varchar(50)) +'>'+acc.Name +'</a></b> '+ n.msg2 +'  '+ 
	 
	 (CASE When EXISTS (SELECT 1 WHERE nt.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
	 THEN (Select '<b>' + FirstNAme+' '+LastName + '</b>' from App.[User] where UserId =  un.UpdatedBy) 
	 ELSE nt.UpdatedBy END
	 ) 
	 
	 from CRE.Note nt inner join core.account acc on acc.AccountID = nt.Account_AccountID where nt.noteid = un.[ObjectId] and acc.IsDeleted=0)
	  WHEN un.[ObjectTypeId] = 388 THEN (Select n.Msg1 +' <b><a href=#/taskactivity/' + CAST(tk.taskid  AS varchar(50)) +'>'+tk.Summary +'</a></b>'+ n.msg2 +'  '+ 
	 
	 (CASE When EXISTS (SELECT 1 WHERE tk.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
	 THEN (Select '<b>' + FirstNAme+' '+LastName + '</b>' from App.[User] where UserId =  un.UpdatedBy) 
	 ELSE un.UpdatedBy END
	 ) 
	 from app.Task tk  where tk.TaskID = un.[ObjectId])
	  ELSE n.Msg1 +' '+ n.msg2 END as Msg
	  ,(Select FirstName+' ' +LastName from App.[User] where UserId = un.[UpdatedBy]) as Sender
	  ,(select LEFT([FirstName], 1) + LEFT(LastName, 1) from App.[User] where UserId = un.[UpdatedBy]) as SenderFirstLetter
	   ,CASE 
	  when (cast(un.[UpdatedDate] as date)< cast(GETDate() as date)) Then   format(un.UpdatedDate,'MMM dd') 
	  else
			--dbo.ufn_GetUserNotificationTime(@currentTime,un.CreatedDate)---  format(un.UpdatedDate,'hh:mm tt') 
				format(dbo.ufn_GetTimeByTimeZone(un.CreatedDate, @UserID),'MMM dd') 
	  end 'Modified'
      ,un.[CreatedBy]
      ,un.[CreatedDate]
      ,un.[UpdatedBy]
      ,un.[UpdatedDate] 
		,(select 'avatorcircle ' + Color from [APP].[UserEx]  where userid=un.[UpdatedBy] ) UColor
  FROM [App].[UserNotification] un
  left join App.NotificationSubscription ns ON ns.NotificationSubscriptionId = un.NotificationSubscriptionId
  left Join app.[Notification] n ON n.NotificationId = ns.NotificationId  	
	Where ns.userid = @UserID
	and un.[CleanTime] is null
--	and un.ViewedTime is null
	order by un.updateddate desc
	OFFSET (@PgeIndex - 1)*@PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
--ELSE
--BEGIN
--	SELECT  un.[UserNotificationID]
--      ,un.[NotificationSubscriptionID]
--      ,un.[ViewedTime]
--      ,un.[CleanTime]
--      ,un.[ObjectId]
--      ,un.[ObjectTypeId]
--	  ,
	  
--		CASE WHEN un.[ObjectTypeId] = 283 THEN (Select n.Msg1 +' <b><a  href=#/dealdetail/' +++ CAST(d.dealid  AS varchar(50)) +++'>'+dealname +'</a></b> '+ ' ' + (CASE when un.generatedby=256 then 'has been imported from Backshop by ' else  n.msg2  END)+'  '+ 
--		(CASE When EXISTS (SELECT 1 WHERE d.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
--		THEN (Select '<b>' + FirstNAme+' '+LastName + '</b>' from App.[User] where UserId = un.UpdatedBy) 
--		ELSE un.UpdatedBy END
--		) from CRE.Deal d where d.dealid = un.[ObjectId] and d.IsDeleted=0)
	 
--	 WHEN un.[ObjectTypeId] = 182 THEN (Select n.Msg1 +' <b><a href=#/notedetail/' + CAST(nt.NoteID  AS varchar(50)) +'>'+acc.Name +'</a></b> '+ n.msg2 +'  '+ 
	 
--	 (CASE When EXISTS (SELECT 1 WHERE nt.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
--	 THEN (Select '<b>' + FirstNAme+' '+LastName + '</b>' from App.[User] where UserId =  un.UpdatedBy) 
--	 ELSE nt.UpdatedBy END
--	 ) 
	 
--	 from CRE.Note nt inner join core.account acc on acc.AccountID = nt.Account_AccountID where nt.noteid = un.[ObjectId] and acc.IsDeleted=0)
--	  WHEN un.[ObjectTypeId] = 388 THEN (Select n.Msg1 +' <b><a href=#/taskactivity/' + CAST(tk.taskid  AS varchar(50)) +'>'+tk.Summary +'</a></b>'+ n.msg2 +'  '+ 
	 
--	 (CASE When EXISTS (SELECT 1 WHERE tk.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
--	 THEN (Select '<b>' + FirstNAme+' '+LastName + '</b>' from App.[User] where UserId =  un.UpdatedBy) 
--	 ELSE un.UpdatedBy END
--	 ) 
--	 from app.Task tk  where tk.TaskID = un.[ObjectId])
--	  ELSE n.Msg1 +' '+ n.msg2 END as Msg
--	  ,(Select FirstName+' ' +LastName from App.[User] where UserId = un.[UpdatedBy]) as Sender
--	  ,(select LEFT([FirstName], 1) + LEFT(LastName, 1) from App.[User] where UserId = un.[UpdatedBy]) as SenderFirstLetter
--	   ,CASE 
--	  when (cast(un.[UpdatedDate] as date)< cast(GETDate() as date)) Then   format(un.UpdatedDate,'MMM dd') 
--	  else
--			dbo.ufn_GetUserNotificationTime(@currentTime,un.CreatedDate)---  format(un.UpdatedDate,'hh:mm tt') 
--	  end 'Modified'
--      ,un.[CreatedBy]
--      ,un.[CreatedDate]
--      ,un.[UpdatedBy]
--      ,un.[UpdatedDate] 
--		,(select 'avatorcircle ' + Color from [APP].[UserEx]  where userid=un.[UpdatedBy] ) UColor
--  FROM [App].[UserNotificationArchive] un
--  left join App.NotificationSubscription ns ON ns.NotificationSubscriptionId = un.NotificationSubscriptionId
--  left Join app.[Notification] n ON n.NotificationId = ns.NotificationId  	
--	Where ns.userid = @UserID
--	and un.[CleanTime] is null
----	and un.ViewedTime is null
--	order by un.updateddate desc
--	OFFSET (@PgeIndex - 1)*@PageSize ROWS
--	FETCH NEXT @PageSize ROWS ONLY
--	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--END
--END
