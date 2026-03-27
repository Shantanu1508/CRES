Create procedure [dbo].[usp_GetPeriodicCloseByUserID]

@UserID NVarchar(255),
@AnalysisID uniqueidentifier 

AS

BEGIN

	SET NOCOUNT ON;


	Declare @MaxEndDate Date = (Select MAX(CloseDate) from [Core].[Period] Where IsDeleted=0);
	
	Select p.PeriodID,p.PeriodAutoID,P.CloseDate,P.OpenDate,U.FirstName+ ' ' + U.LastName as UserName,U.Login,P.CreatedDate,@MaxEndDate as MaxEndDate,AnalysisID
	from [Core].[Period] P
	LEFT JOIN [App].[User] U on P.CreatedBy = U.UserID 
	Where IsDeleted=0
	order by p.CloseDate desc

END
