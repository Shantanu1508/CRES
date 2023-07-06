


CREATE PROCEDURE [dbo].[usp_GetUserDetailsForEmailForTaskComment]  --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
    @UserID UNIQUEIDENTIFIER,
    @TaskID UNIQUEIDENTIFIER
     
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
      select * 
	  from App.[User] 
	  where	 UserID in (select UserId from App.TaskSubscribedUser  ts where TaskID=@TaskID and ts.UserId  !=@UserID)
    	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END      



