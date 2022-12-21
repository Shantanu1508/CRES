
--usp_GetGetLiborScheduleForFast 

Create PROCEDURE [dbo].[usp_GetLiborScheduleForFast] 
as
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	select 
			[Date],			
			Value,
			0 as indexoverridevalue from Core.Indexes 
		where AnalysisID=(select top 1 AnalysisID from  Core.Analysis a where statusID=3 ) and indextype=245


		END



