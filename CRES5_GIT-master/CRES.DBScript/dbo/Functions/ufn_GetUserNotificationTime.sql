-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetUserNotificationTime] 
(
	-- Add the parameters for the function here
	@UserSystemDate Datetime,
	@ActionTime DateTime
)
RETURNS  nvarchar(250)
AS
BEGIN

  DECLARE @DBTime DATETIME
  SET @DBTime = GETDATE();

  --RETURN  DATEDIFF(HH, @ActionTime, GETDATE())

   -- RETURN DATEADD(hh, DATEDIFF(HH, @ActionTime, GETDATE()), @ActionTime)
   RETURN stuff( right( convert( varchar(26), 
     DATEADD(hh, DATEDIFF(HH, GETDATE() , @ActionTime), @UserSystemDate)
   , 109 ), 15 ), 7, 7, ' ' )

	---- Declare the return variable here
	--DECLARE <@ResultVar, sysname, @Result> <Function_Data_Type, ,int>

	---- Add the T-SQL statements to compute the return value here
	--SELECT <@ResultVar, sysname, @Result> = <@Param1, sysname, @p1>

	---- Return the result of the function
	--RETURN <@ResultVar, sysname, @Result>

END
