  
  --[dbo].[usp_LCGetLIBORScheduleDetailByCRENoteID] '2307' ,'Default'  

CREATE PROCEDURE [dbo].[usp_LCGetLIBORScheduleDetailByCRENoteID]
(  
 @CRENoteID NVARCHAR(256),  
 @AnalysisName nvarchar(256)  
)  
   
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  

Declare @IndexScenarioOverride int = (Select IndexScenarioOverride from core.analysis an left join core.analysisparameter ap on an.analysisId = ap.analysisId where [Name] = @AnalysisName)


DECLARE @IndexNameID int = (select distinct IndexNameID from cre.Note  n inner join core.Account acc on n.Account_AccountID = acc.AccountID  where creNoteID=@CRENoteID and acc.IsDeleted = 0)  
  
IF @IndexNameID is NULL or @IndexNameID=0  
Begin  
	set @IndexNameID=(SELECT LookupID FROM CORE.LOOKUP WHERE Name='1M LIBOR')  
End  


Select     
CONVERT(NVARCHAR(256),[Date],101)   as [Date]  
,[Value] as [Value]      
from Core.[Indexes]  i
left join core.indexesmaster im on i.IndexesMasterID = im.IndexesMasterID     
where i.IndexesMasterID = @IndexScenarioOverride and IndexType =@IndexNameID   and [Date] <=getdate()  
order by CONVERT(NVARCHAR(256),[Date],126)  
   

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
