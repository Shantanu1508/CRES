
CREATE PROCEDURE [dbo].[usp_GetErrorLogs]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

       select	 
	ff.Module as Category,count(Module) as CategoryCount
	from app.logger ff
where ff.Severity ='Error'
	and ff.CreatedDate >= cast(dateadd(day, -1, getdate()) as date)
	
 GROUP BY ff.Module

 
END


  
 
