
CREATE PROCEDURE [dbo].[usp_ClearLog]  

AS
BEGIN
     SET NOCOUNT ON;
 
 	Delete from app.CategoryLog where LogID in (Select logid from  app.log where [timestamp] < Convert(Date,DATEADD(day, -7, GEtdate()),101))
	Delete from app.log where [timestamp] < Convert(Date,DATEADD(day, -7, GEtdate()),101)

END
