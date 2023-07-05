Create procedure [dbo].[usp_GetPeriodicCloseByUserID]

@UserID NVarchar(255),
@AnalysisID uniqueidentifier 

AS

BEGIN

	SET NOCOUNT ON;


	Declare @MaxEndDate Date = (Select MAX(EndDate) from [Core].[Period] Where IsDeleted=0);
	
	Select p.PeriodID,p.PeriodAutoID,P.StartDate,P.EndDate,U.FirstName+ ' ' + U.LastName as UserName,U.Login,P.CreatedDate,@MaxEndDate as MaxEndDate,AnalysisID
	from [Core].[Period] P
	LEFT JOIN [App].[User] U on P.CreatedBy = U.UserID 
	Where IsDeleted=0
	order by p.EndDate desc

END
